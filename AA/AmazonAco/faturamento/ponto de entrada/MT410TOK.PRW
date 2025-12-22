#Include "rwmake.ch"
#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"

User Function MT410TOK()

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada executado na finalização do Orçamento ou Venda, para verificar a Senha do Vendedor.
OBJETIVO 1: Chamada de Senha para Liberação do Orçamento com a senha do Vendedor ou do SUPERIOR;
OBJETIVO 2: Analisar as Formas de Pagamentos x Condição de Pagamentos e cria os bloqueios necessários na finalização do Orçamentos;
OBJETIVO 3: Verificar se a impressão de Cupom Fiscal será com Boleto ou Cheque-Pré, caso afirmativo, bloqueia a finalização da venda;
OBJETIVO 4: Analisar se o cliente pode comprar em BOLETO na condição 2 sem autorização do SUPERIOR;
OBJETIVO 5: Bloquear a finalização, caso haja diferença entre o valor do orçamento e as parcelas;
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/
Local   cNome    	:= GETMV("MV_USRSUP")   // Usuários Superiores
Local   cFormLib    := GETMV("MV_FORLIB")   // Formas de Pagamentos liberadas para descontos
Local   ndTotVal    := 0
Local   ndTotDes    := 0
Local   _adArea   := getArea()

Private   nProduto    := Ascan(aHeader		,{|x|Alltrim(x[2]) == "C6_PRODUTO"})
Private   nPosTot     := Ascan(aHeader		,{|x|Alltrim(x[2]) == "C6_VALOR"  })
Private   nPosDes     := Ascan(aHeader		,{|x|Alltrim(x[2]) == "C6_VALDESC"})
Private   nPosEnt     := Ascan(aHeader		,{|x|Alltrim(x[2]) == "C6_ENTBRAS"})
Private   nPosAut     := Ascan(aHeader		,{|x|Alltrim(x[2]) == "C6_AUTDESC"})
Private   nQuant      := Ascan(aHeader		,{|x|Alltrim(x[2]) == "C6_QUANT"  })
Private   _nPDesc     := Ascan(aHeader    ,{|x|Alltrim(x[2]) == "C6_DESCONT"})
Private   nTES        := Ascan(aHeader    ,{|x|Alltrim(x[2]) == "C6_TES"    })

Private nDescPer    := 0
Private cPassWord   := Space(06)
Private lRet 		:= .T.
Private vFormas     := {}
Private lDesc       := .T.
Private nLastKe1    := 0
Private lRetSup     := .F.
Private lFPgtoProib := .F.
Private nTotPrc		:= 0
Public nRecSA3 		:= SA3->(RecNo())
Public nLastKe2    	:= 0
conout('topassando aki ')
conout(FunName())

If (ParamIXB[1] == 4 .And. Len(ALltrim(M->C5_ORCRES)) != 0 )
   If !__cUserID $ SuperGetmv("MV_XUSRPVA",.F.," ")
      Aviso('Atenção','Usuario sem Acesso a Alteração de Pedido de Reserva',{'OK'} )
      Return .F.
   EndIf
EndIf

If FunName() $ "MATA310/LOJA701/AAFKE01"
	// Define se libera a atualização do campo C6_QTDLIB para o LOJA
	If !(FunName() $ "LOJA701/AAFKE01") .Or. GetMV("MV_XLIBRES",.F.,.F.)
		nPos1 := aScan(aHeader,{|x| Alltrim(x[02]) == "C6_QTDLIB" } )
		nPos2 := aScan(aHeader,{|x| Alltrim(x[02]) == "C6_QTDVEN" } )
	
		For nI :=1 to Len(aCols)
			aCols[nI][nPos1] := aCols[nI][nPos2]
		Next
	Endif
	
	Return .T.
EndIf


//VFilEnt()  // Verifica se há Filial de Entrega divergentes entre os itens do Orçamento

if lRet .And. SC5->(FieldPos("C5_XNUMOS")) > 0
	SL1->(dbSetORder(1))
	cdNumOs := iIf(SL1->(dbseek(SC5->(C5_FILIAL + C5_ORCRES )  ) ), SL1->L1_XNUMOS ,u_AAVALPRD(M->C5_XNUMOS) )
	If !Empty(cdNumOs)
		M->C5_XNUMOS := cdNumOs
	EndIf
EndIf



If ParamIXB[1] == 3 .Or.  ParamIXB[1] == 4 //Finalizacao da Manutencao do Pedido
	
	aEval(aCols,{|x| ndTotVal += x[nPosTot] })
	aEval(aCols,{|x| ndTotDes += x[nPosDes] })
	
	ndPerDes := ndTotDes * 100 / ndTotVal
	nDescPer := ndPerDes
	/*
	If Round(aTotais[2][2],2) > M->C6_DESCONT
	//Verifica se o % de desconto liberado está igual ao desconto do rodapé do orçamento, devido a Tela de Desconto na exclusão do item, modificava o % correto
	MsgAlert("Favor corrija o percentual de desconto !!!","ATENÇÃO")
	lRet := .F.
	EndIf
	*/
	
	_lDescItem := .F. //  '-----------------'
	
	For i:=1 To Len(aCols)
		//If aCols[i, _nPDesc] > _nPercMax
		aResult := u_VLDESCPRD(aCols[i,nProduto] , aCols[i, _nPDesc],M->C5_VEND1)
		If aResult[01] .And. FunName() == "MATA410"//.Or. u_VLDESCPRD(aCols[i,nProduto] , _nPercLQ) //Adicionado Por Diego
			_lDescItem := .T.
			Exit
		EndIf
		//EndIf
	Next
	If !_lDescItem .and. FunName() == "MATA410"
		nSoma  := 0
		nTotal := 0
		aEval(aCols,{|x| nSoma += Round(x[nPosTot] * u_VLDESCPRD(x[nProduto],,M->C5_VEND1)[02] / 100,2) })
		
		aEval(aCols,{|x| nTotal += Round(x[nPosTot],2) } )
		
		If(Max( M->C5_DESCONT, M->C5_PDESCAB * nTotal / 100  ) > nSoma)
			_lDescItem := .T.
		Endif
	EndIf
	
	
	If lRet
		
		Entrega()  // Regrava a situação de Entrega
		
		
		Private aPgtos := {}
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI))
		lRetLC := !u_LJ7014()
		If lRetLC .And. Empty(M->C5_ORCRES)
			
			If M->C5_CLIENTE == GETMV("MV_CLIPAD")
				MSGALERT("Venda em CHEQUE-PRÉ ou BOLETO não pode ser finalizada com CLIENTE PADRÃO !!!", "ATENÇÃO")
				lRet := .F.
			EndIf
			
		EndIf
		
		If lRet
			nPosUM := ASCAN(aHeader,{|x|Alltrim(x[2]) == "C6_UM"})
			For I:=1 to Len(Acols)
				If Alltrim(Acols[I][nPosUM]) == "SV"
					lFPgtoProib := .T.
				Else
					lRet := .T.
				EndIf
			Next
		EndIf
		
		If lFPgtoProib
			MSGALERT("Serviço somente com Comprovante de Venda e Nota Fiscal de Serviço !!!", "ATENÇÃO")
			lRet := .F.
		EndIf
		
		If lRet
			nPDel := Len(aCols[1])
			For I:=1 To Len(Acols)
				If ! Acols[I][nPDel]
					If Acols[I][nTes] == GETMV("MV_LJOUTLJ")
						If SB2->(DbSeek(Acols[I][nPosEnt]+Acols[I][nProduto]+Acols[I][nPosEnt]))
							If SB2->B2_QATU-(SB2->B2_QEMP+SB2->B2_RESERVA) < Acols[I][nQuant]
								lRet := .F.
								Alert("Produto "+SB2->B2_COD+" na Filial "+Acols[I][nPosEnt]+" não possui estoque SUFICIENTE!!!","ATENÇÃO")
							Endif
						EndIf
					Endif
				Endif
			Next
			
		EndIf
		
		If lRet																	// Liberado as vendas em Cheque Pré e Boleto
			
			VParcelas() 														// Calcula o total das parcelas
			
			If ndTotDes > 0  											 	// Verifica se há desconto - Vetor Padrão do Sistema
				lFPgtoProib := .F.
				For J:=1 to Len(vFormas) 										// Verifica se a venda está parcelada em CC e CH
					
					If AllTrim(vFormas[J][1]) $ cFormLib 						// Verifica se não há formas de pagamentos liberadas para desconto
						lDesc := .T.
					Else
						lFPgtoProib := .T.
					EndIf
					
				Next
				lFPgtoProib := .F.//COLOCADO POR DIEGO
				If lFPgtoProib    												// Verifica se as formas de pagamentos permitem descontos
					
					If MsgNoYes("Venda com Forma de Pagamento que não permite Desconto !!!, Deseja senha superior? ")
						
						Do While nLastKe2 == 0
							lRetSup := u_SenhaSup("LJ7001",u_VSuperior())  					// Verifica Senha do Superior para liberação da Venda - LJ7018.PRW
						EndDo
						
						If ! lRetSup
							lDesc := .F.
						EndIf
						
					Else
						lDesc := .F.
					EndIf
					
				EndIf
				
			EndIf
			
			If lDesc  																	// Somente se o Desconto for permitido analisa a Venda na Tabela 2
				Do While nLastKe1 == 0 .And. lDesc
					
					// Senha do Vendedor ou do SUPERIOR
					If ParamIxb[1] == 3 .Or. ParamIxb[1] == 4  // Se é Inclusao ou Alteração
						
						If Alltrim(cUserName) $ cNome   				// Verifica se o usuário que está acessando é um SUPERIOR para finalizar o orçamento
							
							If ! lRetSup								// Já passou por uma senha de um SUPERIOR anteriormente
								
								nLastKe2 := 0
								
								Do While nLastKe2 == 0
									lRet 	:= u_SenhaSup("LJ700A1",u_VSuperior()) 	// Verifica Senha do Superior para liberação da Venda - LJ7018.PRW - O "A" significa que somente deverá verifica a senha do superior e não o desconto
									nLastKe1:= 1
								EndDo
							Else
								lRet     := lRetSup  				 	// Já passou por uma senha de um SUPERIOR
								nLastKe1 := 1
							EndIf
						Else
							nLastke1 := 1
							lRet := .T.
						EndIf
						
					EndIf
					
				EndDo
				
				If ! lDesc   											// Desconto não autorizado
					lRet := lDesc
				Endif
				
			Else
				lRet := lDesc
			EndIf
			
			If lRet 					 // Tudo liberado
				If M->C5_CLIENTE == GETMV("MV_CLIPAD")
					MSGALERT("Venda para CLIENTE PADRÃO será possível emitir CUPOM FISCAL", "ATENÇÃO")
				EndIf
			EndIf
			
		EndIf
		
	EndIf
	
	If lRet
		if !EMPTY(M->C5_XBLQORC)
			aBloqueio := {}
			aAdd(aBloqueio,{"Z3_FILIAL",M->C5_FILIAL})
			aAdd(aBloqueio,{"Z3_VENDA",M->C5_NUM})
			aAdd(aBloqueio,{"Z3_TIPO","2"})
			aAdd(aBloqueio,{"Z3_CLIENTE",M->C5_CLIENTE})
			aAdd(aBloqueio,{"Z3_LOJA",M->C5_LOJACLI })
			aAdd(aBloqueio,{"Z3_TIPOCLI",M->C5_TIPOCLI})
			aAdd(aBloqueio,{"Z3_VEND",M->C5_VEND1})
			aAdd(aBloqueio,{"Z3_EMISSAO",M->C5_EMISSAO})
			aAdd(aBloqueio,{"Z3_ENDENT",M->C5_ENDENT})
			aAdd(aBloqueio,{"Z3_BAIRROE",M->C5_BAIRROE})
			aAdd(aBloqueio,{"Z3_MUNE",M->C5_MUNE})
			aAdd(aBloqueio,{"Z3_ESTE",M->C5_ESTE})
			aAdd(aBloqueio,{"Z3_DESCONT",M->C5_DESCONT})
			aAdd(aBloqueio,{"Z3_PESOL",M->C5_PESOL})
			aAdd(aBloqueio,{"Z3_PESOB",M->C5_PBRUTO})
			aAdd(aBloqueio,{"Z3_FONEENT",M->C5_FONEENT})
			aAdd(aBloqueio,{"Z3_OBS1",M->C5_OBSENT1})
			aAdd(aBloqueio,{"Z3_OBS2",M->C5_OBSENT2})
			aAdd(aBloqueio,{"Z3_BLOQUEI",M->C5_XBLQORC})
			aAdd(aBloqueio,{"Z3_NOMCLI",Posicione('SA1',1,xFilial("SA1") +SC5->(C5_CLIENTE  + C5_LOJACLI),"A1_NOME") })
			
			If ExistBlock("AALJ05GRV")
				u_AALJ05GRV(aBloqueio)
			EndIf
			
		EndIf
	EndIf
	
	
	
	//Dia 27/07/11
	If lRet
		
		_ndOpc := PARAMIXB[01]
	  //	alert(_ndOpc)
		aDados := {}
		_cMensagem := ""
		_ndStatus  := ""
		If _ndOpc == 5
			_cMensagem := "EXCLUSAO DE PEDIDO"
			_ndStatus := " "
		elseif _ndOpc == 4
			_cMensagem := "ALTERACAO DE PEDIDO"
			_ndStatus := "1"
		elseif _ndOpc == 3
			_cMensagem := "INCLUSAO DE PEDIDO"
			_ndStatus := "1"
		EndIf
		
		/*
		if !Empty(_cMensagem) .And. Alltrim(Str(_ndOpc)) $ "3/2"
			SC6->(dbSetOrder(1))
			SC6->(dbSeek(SC5->(C5_FILIAL + C5_NUM)))
			While SC6->(C6_FILIAL + C6_NUM)  ==  SC5->(C5_FILIAL + C5_NUM)
				
				aAdd(aDados,{'Z5_PEDIDO',SC5->C5_NUM})
				aAdd(aDados,{'Z5_PRODUTO', SC6->C6_PRODUTO })
				aAdd(aDados,{'Z5_DATA',dDataBase})
				aAdd(aDados,{'Z5_HORA',SubStr(Time(),1,5)})
				aAdd(aDados,{'Z5_USER',cUserName})
				aAdd(aDados,{'Z5_OP',''})
				aAdd(aDados,{'Z5_OBS',_cMensagem})
				aAdd(aDados,{'Z5_STATUS', _ndStatus})
				aAdd(aDados,{'Z5_ENTREGA',STOD('  /  /  ')})
				
				SC6->(dbSkip())
			EndDo
			
		elseif !Empty(_cMensagem) .And. Alltrim(Str(_ndOpc)) $ "1"
			_ndPos := aScan(aHeader,{|x| Alltrim(x[02]) == "C6_PRODUTO" })
			
			For _ndK := 1 To Len(aCols)
				aAdd(aDados,{'Z5_PEDIDO',M->C5_NUM})
				aAdd(aDados,{'Z5_PRODUTO', aCols[_ndK][_ndPos] })
				aAdd(aDados,{'Z5_DATA',dDataBase})
				aAdd(aDados,{'Z5_USER',cUserName})
				aAdd(aDados,{'Z5_OP',''})
				aAdd(aDados,{'Z5_OBS',_cMensagem})
				aAdd(aDados,{'Z5_STATUS', '1'})
				aAdd(aDados,{'Z5_ENTREGA',STOD('  /  /  ')})
			Next
			
		EndIf
		*/
		
		_ndPos := aScan(aHeader,{|x| Alltrim(x[02]) == "C6_PRODUTO" })
			
			For _ndK := 1 To Len(aCols)
			    If aCols[_ndk][Len(aHeader) + 1]
			       _cMens := 'EXCLUSAO PRODUTO DO PEDIDO'
			    else
			       _cMens := _cMensagem
			    EndIf
			    
				aAdd(aDados,{'Z5_PEDIDO' ,M->C5_NUM})
				aAdd(aDados,{'Z5_PRODUTO', aCols[_ndK][_ndPos] })
				aAdd(aDados,{'Z5_DATA'   ,dDataBase})
				aAdd(aDados,{'Z5_HORA'   ,Time()})
				aAdd(aDados,{'Z5_USER'   ,cUserName})
				aAdd(aDados,{'Z5_OP'     ,''})
				aAdd(aDados,{'Z5_OBS'    ,_cMens})
				aAdd(aDados,{'Z5_STATUS' , _ndStatus})
				aAdd(aDados,{'Z5_ENTREGA',STOD('  /  /  ')})
				If ExistBlock("AALOGE02")
			       u_AALOGE02(aDados)
		        EndIf
			Next				
		
	EndIf
EndIF

//*********************************************************************
//*******************VALIDACAO LIMITE DE CREDITO***********************
//*********************************************************************
/* comentado por Chico Butico 16-11-13
If lRet .And. AllTrim ( FunName() ) == "MATA410" .And. ( PARAMIXB[01] == 3 .Or. PARAMIXB[01] == 4)
                    
	ndTotVal := 0
	ndTotDes := 0
	
	aEval(aCols,{|x| ndTotVal += x[nPosTot] })
	aEval(aCols,{|x| ndTotDes += x[nPosDes] })

        
	_cQry := " SELECT A1_XLIBCRE, A1_COD, A1_LC, SUM(SALDO_FIN) AS SALDO_FIN, SUM(ATRASO) AS ATRASO, 
	_cQry +=        " ( SELECT SUM ( (SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRCVEN ) 
	_cQry +=            " FROM " + RetSQLName("SC6") + " SC6 (NOLOCK)
	_cQry +=           " WHERE SC6.D_E_L_E_T_ = ''
	_cQry +=             " AND SC6.C6_BLQ <> 'R'            
	_cQry +=             " AND SC6.C6_QTDVEN > SC6.C6_QTDENT            
	_cQry +=             " AND SC6.C6_CLI     = '" + M->C5_CLIENTE + "' "
	_cQry +=             " AND SC6.C6_LOJA    = '" + M->C5_LOJACLI + "' "	  
	_cQry +=             " AND SC6.C6_NUM    <> '" + M->C5_NUM     + "' "	  	 
	_cQry +=        " ) AS SALDO_FAT 
	_cQry +=   " FROM ( SELECT A1_XLIBCRE, A1_COD, A1_LC, ISNULL(E1_SALDO,0) AS SALDO_FIN, 
	_cQry +=                "  CASE WHEN E1_VENCREA < '20130625' THEN ISNULL(E1_SALDO, 0) ELSE 0 END AS  ATRASO
	_cQry +=            " FROM " + RetSQLName("SA1") + " SA1 (NOLOCK)  
	_cQry +=            " LEFT JOIN " + RetSQLName("SE1") + " AS SE1 
	_cQry +=              " ON SE1.D_E_L_E_T_ = '' AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA
	_cQry +=             " AND E1_SALDO > 0 AND E1_TIPO NOT IN ('RA', 'NCC')   
	_cQry +=           " WHERE SA1.D_E_L_E_T_ = ''
	_cQry +=             " AND SA1.A1_COD     = '" + M->C5_CLIENTE + "' "
	_cQry +=             " AND SA1.A1_LOJA    = '" + M->C5_LOJACLI + "' "	   
	_cQry +=   "      ) AS AUX 
	_cQry +=  " GROUP BY A1_XLIBCRE, A1_COD, A1_LC
 		
	dbUseArea(.T., "TOPCONN", tcGenQry(,,_cQry), "TMP01", .T., .T.) 
	
	If TMP01->A1_XLIBCRE	== "2" .And. ( TMP01->ATRASO > 0 ) .And. M->C5_TIPO == "N" 
		Aviso("Financeiro","Este Cliente possui pendenencias financeiras! Favor contactar o setor Financeiro!",{"OK"},3)			
		lRet := .F. 
	EndIf                                                                                       
		
	If lRet .And. TMP01->A1_XLIBCRE	== "2" .And. (  ( TMP01->SALDO_FIN + TMP01->SALDO_FAT + ndTotVal - ndTotDes ) > TMP01->A1_LC )  .And. M->C5_TIPO == "N" 
		Aviso("Financeiro","Limite de credito excedido! Favor contactar o setor Financeiro!",{"OK"},3)			
		lRet := .F. 
	EndIf
	
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek( xFilial("SA1") + TMP01->A1_COD )) 
	
		SA1->(Reclock("SA1", .F.))
			SA1->A1_XLIBCRE := "2"		
		SA1->(MsUnlock()) 
	
	EndIf 
	
	TMP01->(dbCloseArea())           	

EndIf 
*/	  

//*********************************************************************
//********************FIM VALIDACAO LIMITE DE CREDITO******************
//*********************************************************************



RestArea(_adArea)

Return(lRet)

/*------------------------------------------------------------------------------------------*/
Static Function VParcelas()
/*------------------------------------------------------------------------------------------*/
// Calcula a soma das Parcelas
Local nPosTipo := aScan(aHeadFor,{|x|Alltrim(x[2]) == "CV_FORMAPG"})
Local nPosVal  := aScan(aHeadFor,{|x|Alltrim(x[2]) == "CV_VALOR"})

For I:=1 to Len(aColsFor) 											// Adiciona todas as Formas de Pagamentos e número de parcelas
	If !aColsFor[I][Len(aColsFor[I])]
		nPos := ASCAN(vFormas,{|x|x[1]==aColsFor[I][nPosTipo]})
		If nPos == 0
			AADD(vFormas,{aColsFor[I][nPosTipo],1,aColsFor[I][nPosVal]})                 // Forma de Pagamento, Parcelas da Forma de Pgto e Vencimento
		Else
			vFormas[nPos][nPosVal] += 1
		EndIf
		nTotPrc+= aColsFor[I][nPosVal]											// Soma das Parcelas
	EndIf
Next

Return

/*------------------------------------------------------------------------------------------*/
Static Function Senha()
/*------------------------------------------------------------------------------------------*/

// Função de Senhas do SUPERIOR

Define Font oFnt3 Name "Ms Sans Serif" Bold

Define Msdialog oSenhas Title "SENHA DO VENDEDOR" From 190,110 to 300,370 Pixel

@ 015,004 Say "Senha   :" Size 220,10 Of oSenhas Pixel Font oFnt3
@ 015,050 Get cPassWord   Picture "@!"  Valid .T.  PASSWORD  Object oSenha

@ 035,042 BmpButton Type 1 Action ValidaSenha()

Activate Dialog oSenhas Centered

Return

/*------------------------------------------------------------------------------------------*/
Static Function ValidaSenha()
/*------------------------------------------------------------------------------------------*/
// Valida SENHA informada na Tela de Senha

DbSelectArea("SA3")
DbSetOrder(1)

Close(oSenhas)
If cPassWord == SA3->A3_SENHA           // Verifica se a senha é Valida
	lRet := .T.
Else
	MsgAlert("Senha do Vendedor Incorreta !!!","ATENÇÃO")
	lRet := .F.
EndIf

nLastke1 := 1

Return


Return()

/*------------------------------------------------------------------------------------------*/
Static Function Entrega()
/*------------------------------------------------------------------------------------------*/
// Regrava a situacção de Entrega
If ! Empty(M->C5_RECENT)
	M->C5_ENTREGA := "S"
EndIf
return()

/*------------------------------------------------------------------------------------------*/
Static Function VFilEnt()
/*------------------------------------------------------------------------------------------*/
// Verifica se há Filiais de Entrega divergentes entre os itens do Orçamento

M->C5_ENTBRAS   := Acols[1][nPosEnt]              								// Filial em que a mercadoria irá sair fisicamente, através do PV

For I:=1 to Len(Acols)
	
	If M->C5_ENTBRAS <> Acols[I][nPosEnt]
		lRet := .F.
	EndIf
	
Next

If ! lRet
	Aviso("ATENÇÃO","Há Lojas de Entrega diferentes, favor revisar os itens !!! ",{"OK"},2)
EndIf

Return
