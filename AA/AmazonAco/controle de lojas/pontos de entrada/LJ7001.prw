#Include "rwmake.ch"
#include "Protheus.CH"
#include "font.CH"
#include "Topconn.ch"
/*/
---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada executado na finalização do Orçamento ou Venda, para verificar a Senha do Vendedor.
OBJETIVO 1: Chamada de Senha para Liberação do Orçamento com a senha do Vendedor ou do SUPERIOR;
OBJETIVO 2: Analisar as Formas de Pagamentos x Condição de Pagamentos e cria os bloqueios necessários na finalização do Orçamentos;
OBJETIVO 3: Verificar se a impressão de Cupom Fiscal será com Boleto ou Cheque-Pré, caso afirmativo, bloqueia a finalização da venda;
OBJETIVO 4: Analisar se o cliente pode comprar em BOLETO na condição 2 sem autorização do SUPERIOR;
OBJETIVO 5: Bloquear a finalização, caso haja diferença entre o valor do orçamento e as parcelas;
-----------------------------------------------------------------------------------------------------------------------------------------------------
/*/
User Function LJ7001

Local cNome    	:= GETMV("MV_USRSUP")   // Usuários Superiores
Local cFormLib  := GETMV("MV_FORLIB")   // Formas de Pagamentos liberadas para descontos
Local _ndVlr    := 0
Local lExecPer  := .T. //GetMV("MV_XEXECPER",.F.,.F.)

Private nProduto := aScan(aHeader, {|x|Alltrim(x[2]) == "LR_PRODUTO"})
Private nPosEnt  := aScan(aHeader, {|x|Alltrim(x[2]) == "LR_ENTBRAS"})
Private nPosAut  := aScan(aHeader, {|x|Alltrim(x[2]) == "LR_AUTDESC"})
Private nQuant   := aScan(aHeader, {|x|Alltrim(x[2]) == "LR_QUANT"  })
Private _nPDesc  := aScan(aHeader, {|x|Alltrim(x[2]) == "LR_DESC"   })
Private nTES     := aScan(aHeader, {|x|Alltrim(x[2]) == "LR_TES"    })
Private nPosTot  := aScan(aHeader, {|x|Alltrim(x[2]) == "LR_VLRITEM"})

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

_nPercMax   := Posicione("SA3", 1, xFilial("SA3") + M->LQ_VEND, "A3_PERDESC")
_nPercLQ    := aTotais[2][2]
_nValDescLQ := aTotais[3][2]
//conout('vendoFuncao : ' + FunName() )
//VFilEnt()  // Verifica se há Filial de Entrega divergentes entre os itens do Orçamento
M->LQ_NOMCLI := Posicione("SA1",1,xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA,"A1_NOME" )

_lFilWrong := .T.

aEval(aCols,{|x| _lFilWrong := _lFilWrong .And. x[nPosEnt] != cFilAnt })

If !_lFilWrong
	Aviso('ERRO!', 'Existem itens com Filial de Destino igual a Origem , no campo "Filial Entrega"',{'ok'},2)
	// Return .F.
EndIf

if lRet .And. SLQ->(FieldPos("LQ_XNUMOS")) > 0
	cNumOs := u_AAVALPRD(M->LQ_XNUMOS)
	If !Empty(cNumOs)
		M->LQ_XNUMOS := cNumOs
	EndIf
EndIf

If Posicione("SA1",1,xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA,"A1_GRPTRIB" ) == "005" .And. aTotais[2][2] > 0
	Aviso("Atencao"," Nao Pode Efetuar Desconto no Total em Venda para Distribuidor",{"Ok"})
	lRet := .F.
EndIf            

//
// Orçamento
//
//For 
_cFormDel := SuperGetMv("MV_XFORMLJ",.F.,"BO")
lDeleta := .F.
_cdForma := aPgtos[01][03]


//13/11/2019
//Diego Inicio - Incremento de 3% quando CC for maior que 3 parcelas
//Alert("Verifica se tem mais de uma parcela")

If lExecPer .And. M->LQ_JUROS = 0 
	lAJuste := .F.
	_cIdCartao := ""
	_ndParcs := 0
	_xdI := 01
	vParcelas()


	If (ParamIXB[1] == 1 .Or. ParamIXB[1] == 3) 
		nOldVlr := nTotPrc
		nAuxVlr := round(nTotPrc * 1.03, 2)
		_ndVlr := 0
		//Alert("Entrou!")
		While _xdI <= Len(aPgtos)	
			
			xKey := aPgtos[_xdI][03]+aPgtos[_xdI][08]		
			If Alltrim(aPgtos[_xdI][03])=="CC"
				nParc := 0
				While _xdI <= Len(aPgtos) .And. xKey == aPgtos[_xdI][03]+aPgtos[_xdI][08]
					nParc++
					_xdI++
				EndDo
				If nParc >= 4
					While nParc > 0
						lAjuste := .T.
						//alert(str(nAuxVlr))
						//alert(str((aPgtos[_xdI-nParc][02] + (aPgtos[_xdI-nParc][02] * 3/100))))
						//alert(str(nParc))
					

						If nAuxVlr < (aPgtos[_xdI-nParc][02] + round(aPgtos[_xdI-nParc][02] * 3/100, 2))
								_ndVlr                 += nAuxVlr - aPgtos[_xdI-nParc][02] 
								aPgtos[_xdI-nParc][02] := nAuxVlr
								nAuxVlr                := 0
								nParc--
							Else 
								nAuxVlr                := nAuxVlr - (aPgtos[_xdI-nParc][02] + round(aPgtos[_xdI-nParc][02] * 3/100, 2))
								_ndVlr                 += round(aPgtos[_xdI-nParc][02] * 3/100, 2)
								aPgtos[_xdI-nParc][02] += round(aPgtos[_xdI-nParc][02] * 3/100, 2)
								nParc--
						End

						//ALERT(STR(_ndVlr))
					EndDo		  
				EndIf
			Else
				_xdI++
			EndIf
			
		EndDo	
		//Alert(lAJuste)
		If lAjuste
			//Alert("Vai ajustar!")
			vParcelas()
			M->LQ_JUROS   := 3 // (_ndVlr / nOldVlr) * 100		
			M->LQ_VLRJUR  := _ndVlr
			M->LQ_TIPOJUR := 1 
			M->LQ_VLRLIQ  := nOldVlr + _ndVlr
			M->LQ_VALBRUT := nOldVlr +_ndVlr
            M->LQ_XJUROS  := _ndVlr
			QOUT(M->LQ_VALBRUT)
			
		//	aAcrescimo[1] := _ndVlr
		//	aAcrescimo[2] := M->LQ_JUROS		
			
			//aDadosJur[1] := _ndVlr
			//aDadosJur[7] := M->LQ_JUROS
			
			Lj7T_Total( 2, nTotPrc)
			LJ7AjustaTroco()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ajusta os valores de PIS/COFINS caso Haja                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Lj7PisCof()
			
			// Incluido por wermeson gadelha em 02/12/2019
			// conforme solicitacao do Sr. Anderson Canto e Francisco Torres 
			// para acrescentar uma tela com os pagamentos apos ajuste dos valores 
			// de acordo com as parcelas do cartao de credito		
			fw_Comp(aPgtos, _ndVlr , nOldVlr)
			
			//M->LQ_JUROS   := (_ndVlr / nOldVlr) * 100
			//M->LQ_VLRJUR  := _ndVlr
			//M->LQ_TIPOJUR := 1
					
		EndIf

	EndIf
EndIf
//13/11/2019
//Diego Final - Incremento de 3% quando CC for maior que 3 parcelas

If _cdForma $ _cFormDel .And. M->LQ_ENTREGA = 'S'
	aEval(aPgtos,{|x| lDeleta := iIF( (Alltrim(x[03]) $ _cFormDel) ,.T.,lDeleta) } ,2 )
	If lDeleta
		Aviso('Atencao',' Formas de Pagamentos Divergentes na Venda',{'OK'},1)
		lRet := .F.
	EndIf
EndIf

If lRet .And. M->LQ_ENTREGA = 'S'
	aEval(aPgtos,{|x| lDeleta := iIF(  !(Alltrim(x[03]) $ _cFormDel) ,.T.,lDeleta) }  )
	If lDeleta
		lDeleta := .F.                                                                             
		
		For _nK := 1 To Len(aPgtos)
		   if Alltrim(aPgtos[_nK][03]) $ Alltrim(_cFormDel)
		      lDeleta := .T.
		   EndIf
		Next
		
		//aEval(aPgtos,{|x| lDeleta := iIF( (Alltrim(x[03]) $ Alltrim(_cFormDel) ) ,.T.,lDeleta) })
		If lDeleta
			Aviso('Atencao',' Formas de Pagamentos Divergentes na Venda',{'OK'},1)
			lRet := .F.
		EndIf
	EndIf
EndIf


iF M->LQ_ENTREGA = 'S' .And. (M->LQ_CONDPG = 'CN' .Or. Len(Alltrim(M->LQ_CONDPG)) = 0) .And. lRet
	lDeleta := .F.
	aEval(aPgtos,{|x| lDeleta := iIF( (Alltrim(x[03]) $ _cFormDel) ,.T.,lDeleta) } )
	If lDeleta
		Aviso('Atencao',' Para Esta Forma Tem-se a Necessidade de Escolha de Condicao de pagamento',{'OK'},1)
		lRet := .F.
	EndIf
EndIf


If ParamIXB[1] == 1
	M->LQ_NOMCLI := Posicione("SA1",1,xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA,"A1_NOME" )
	_lDescItem := .F.
	For i:=1 To Len(aCols)
		aResult := u_VlDescPrd(aCols[i,nProduto] , aCols[i, _nPDesc],M->LQ_VEND)
		If aResult[01]
			_lDescItem := .T.
			Exit
		EndIf
	Next
	
	If !_lDescItem
		nSoma := 0
		aEval(aCols,{|x| nSoma += Round(x[nPosTot] * u_VLDESCPRD(x[nProduto],x[_nPDesc],M->LQ_VEND)[02] / 100,2) })
		If(_nValDescLQ > nSoma)
			_lDescItem := .T.
		Endif
	EndIf
	
	
	If _lDescItem
		If Aviso("Atencao","Este Orcamento será Bloqueado por Desconto, Continuar?",{"Sim","Nao"}) = 1
			lRet := .T.
			M->LQ_XBLQORC := Left(M->LQ_XBLQORC,1)+'D'
		else
			lRet := .F.
		EndIf
	else
		M->LQ_XBLQORC := Left(M->LQ_XBLQORC,1)+' '
	EndIf
	
	If lRet
		
		Entrega()  // Regrava a situação de Entrega
		
		lRetLC := !u_LJ7014()  // Se o retorno da analise de crédito for verdadeira deve retorna como falsa para este PE.
		
		If lRetLC
			If M->LQ_CLIENTE == GETMV("MV_CLIPAD")
				MSGALERT("Venda em CHEQUE-PRÉ ou BOLETO não pode ser finalizada com CLIENTE PADRÃO !!!", "ATENÇÃO")
				lRet := .F.
			Else
				//MsgAlert("Consultar Setor Financeiro !","ATENÇÃO")
				if Aviso("Atencao","Este Orcamento Será Bloqueado por Credito, Continuar?",{"Sim","Nao"}) = 1
					M->LQ_XBLQORC := 'C'+Right(M->LQ_XBLQORC,1)
				Else
					lRet := .F.
				EndIf
			EndIf
		else
			M->LQ_XBLQORC := ' '+Right(M->LQ_XBLQORC,1)
		EndIf
		
	EndIf
	
	If lRet																	// Liberado as vendas em Cheque Pré e Boleto
		
		VParcelas() 														// Calcula o total das parcelas
		
		If aTotais[2][2] > 0  											 	// Verifica se há desconto - Vetor Padrão do Sistema
			
			For J:=1 to Len(vFormas) 										// Verifica se a venda está parcelada em CC e CH
				
				If AllTrim(vFormas[J][1]) $ cFormLib 						// Verifica se não há formas de pagamentos liberadas para desconto
					lDesc := .T.
				Else
					lFPgtoProib := .T.
				EndIf
				
			Next
			
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
			
			If M->LQ_PRCTAB == "2" 													// Tabela de Preço 2
				
				lRetSup  		:= .F.
				nLastKe2 		:=	0
				lFPgtoProib   	:= .F.
				
				For J:=1 to Len(vFormas)
					
					If 	(AllTrim(vFormas[J][1]) $ cFormLib+"#CC" .And. vFormas[J][2] == 1) .Or. ; 	  // Formas de Pagamentos liberadas para vender na tabela 2
						(AllTrim(vFormas[J][1]) $ "CH" .And. vFormas[J][2] == 1 .And. vFormas[J][3] == dDataBase) 	 // Cheque 1x somente a Vista
						lDesc 			:= .T.
					Else
						If AllTrim(vFormas[J][1]) $ "BC" .And. SA1->A1_BCCOND2 = "S"   // Venda na Tabela 2 em BOLETO permitido para o cliente
							lDesc 		:= .T.
						Else
							lFPgtoProib := .T.
						EndIf
					EndIf
					
				Next
				
				If lFPgtoProib
					
					If MsgNoYes("Venda parcelada ou Forma de Pgto não autorizada na Condição 2 !!!, Deseja senha superior? ")
						
						
						Do While nLastKe2 == 0
							lRetSup := u_SenhaSup("LJ7001",u_VSuperior())  					// Verifica Senha do Superior para liberação da Venda - LJ7018.PRW
						EndDo
						
						If ! lRetSup
							lDesc := .F.
						EndIf
						
					Else
						lDesc := .F.
					EndIf
					
				Endif
				
			EndIf
			
			Do While nLastKe1 == 0 .And. lDesc
				//
				// Senha do Vendedor ou do SUPERIOR
				//
				If ParamIxb[1] == 1  // Orçamento
					M->LQ_NOMCLI := Posicione("SA1",1,xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA,"A1_NOME" )
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
		
			//If nTotPrc <> (aTotais[1][2]-aTotais[3][2]) Alteração para considerar o Total da Venda	
		If nTotPrc <> aTotais[4][2]	// Compara a soma das parcelas aPgtos com aTotais(Total Impostos-Desconto) para não permitir diferença no orçamento
			Aviso("Parâmetro", "Verifique a soma das parcelas, pois estão diferente do valor total do orçamento!!!", {"Ok"}, 2)
			lRet := .F.
		Endif
		
		If lRet 					 // Tudo liberado
			If M->LQ_CLIENTE == GETMV("MV_CLIPAD")
				MSGALERT("Venda para CLIENTE PADRÃO, somente será possível emitir CUPOM FISCAL", "ATENÇÃO")
			EndIf
			
		EndIf
		
	EndIf
	
Else  									// Cupom Fiscal ou Nota Fiscal
	
	if SA1->A1_EST !='AM' .and. FunName()=='LOJA701' .and. (SL1->L1_ENTREGA != 'S') .And. ParamIxb[3] = 1
		Aviso('Atencao',' Vendas em cupom fiscal somente para o Estado AM, Corrigir o estado do cliente', {'OK'} )
		lRet := .F.
	EndIf	
	If lRet
		lFPgtoProib   := .F.				// Variavel que retorna a permissão ou não para alterar a forma de pagamentos
		
		VParcelas()                         // Calcula a soma das Parcelas
		
		If Left(SL1->L1_XBLQORC,1) = "C"
			MsgInfo("Este Orcamento foi Bloqueado por Credito, Consulte Setor Financeiro.")
			lRet := .F.
		elseif Right(SL1->L1_XBLQORC,1) = "D"
			MsgInfo("Este Orcamento foi Bloqueado por Desconto, Aguarde Liberação.")
			lRet := .F.
		EndIf
		
		Do Case
			
			Case ParamIxb[3] = 1 			// 1 = Emissão de Cupom Fiscal; 2 = Emissão de Nota Fiscal série ÚNICA
				M->LQ_NOMCLI := Posicione("SA1",1,xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA,"A1_NOME" )
				For I:=1 to Len(aPgtos) 	// Vetor PADRÃO com as formas de pagamentos
					
					If (Alltrim(aPgtos[I][3]) = "CH" .And. aPgtos[I][1] <> dDataBase) .Or. Alltrim(aPgtos[I][3]) $ "BC"
						// Caso seja Cheque PRÉ ou Boleto, deverá ser CADASTRADO um cliente para emissão de Nota Fiscal
						lFPgtoProib := .T.
					Else
						lRet := .T. .And. lRet
					EndIf
					
				Next
				
				If lFPgtoProib
					
					If M->LQ_CLIENTE == GetMV("MV_CLIPAD")
						MSGALERT("Venda em CHEQUE PRE ou BOLETO somente com CLIENTE CADASTRADO !!!", "ATENÇÃO")
						lRet := .F.
					Else
						lRet := .T. .And. lRet
					EndIf
					
				EndIf
				
			Case ParamIxb[3] = 2 // Nota Fiscal de Saída
				M->LQ_NOMCLI := Posicione("SA1",1,xFilial('SA1') + M->LQ_CLIENTE + M->LQ_LOJA,"A1_NOME" )
				nPosUM := aScan(aHeader, {|x|Alltrim(x[2]) == "LR_UM"})
				For I:=1 to Len(aCols)
					
					If Alltrim(aCols[I][nPosUM]) == "SV"
						lFPgtoProib := .T.
					Else
						lRet := .T.  .And. lRet
					EndIf
					
				Next
				
				If lFPgtoProib
					
					MsgAlert("Serviço somente com Comprovante de Venda e Nota Fiscal de Serviço !!!", "ATENÇÃO")
					lRet := .F.
					
				EndIf
				
		EndCase
		
		//nVlrFin := ( aTotais[1][2]-aTotais[3][2] )      // Valor Total - Desconto no Rodape da Venda Assistida
	    nVlrFin :=  aTotais[4][2]                        // Valor Total - Desconto no Rodape da Venda Assistida
		If nTotPrc <> nVlrFin .and. nNCCUsada = 0 .and. aTotais[6][2] = 0		// Compara a soma das parcelas aPgtos com aTotais(Total Impostos-Desconto) para não permitir diferença no orçamento
			//                                                                  // e verifica se há CRÉDITO para este cliente
			nVlrFinal := Iif(nVlrFin - nTotPrc > 0, nVlrFin - nTotPrc,(nVlrFin - nTotPrc)*-1)
			
			If 	nVlrFinal > 0.05										// Verifica se a diferença é superior a 5 centavos
				Aviso("Parâmetro", "Verifique a soma das parcelas, pois estão diferente do valor total do orçamento!!!", {"Ok"}, 2)
				lRet := .F.
			EndIf
			
		Endif
	EndIF
EndIf

Return(lRet)
//
// Calcula a soma das Parcelas
//
Static Function VParcelas()
nTotPrc := 0
For I:=1 to Len(aPgtos)                               // Adiciona todas as Formas de Pagamentos e número de parcelas
	nPos := aScan(vFormas,{|x|x[1]==aPgtos[I][3]})
	If nPos == 0
		aAdd(vFormas,{aPgtos[I][3],1,aPgtos[I][1]})   // Forma de Pagamento, Parcelas da Forma de Pgto e Vencimento
	Else
		vFormas[nPos][2]+=1
	EndIf
	nTotPrc+= aPgtos[I][2]                            // Soma das Parcelas
Next

Return
//
// Regrava a situacção de Entrega
//
Static Function Entrega()

If !Empty(M->LQ_RECENT)
	M->LQ_ENTREGA := "S"
EndIf
return()
//
// Verifica se há Filiais de Entrega divergentes entre os itens do Orçamento
//
Static Function VFilEnt()

M->LQ_ENTBRAS   := aCols[1][nPosEnt] // Filial em que a mercadoria irá sair fisicamente, através do PV

For I:=1 to Len(Acols)
	
	If M->LQ_ENTBRAS <> aCols[I][nPosEnt]
		lRet := .F.
	EndIf
	
Next

If ! lRet
	Aviso("ATENÇÃO","Há Lojas de Entrega diferentes, favor revisar os itens !!! ",{"OK"},2)
EndIf

Return


//****************************************************************************************************************************************

Static Function fw_Comp(aVetor, _nWdVlr , nWOldVlr)                     
// variaveis Locais 
 Local cVar     := Nil
 Local oDlg     := Nil
 Local oGet     := Nil
 Local oLbx     := Nil
 Local ny       := 1
 Local oMainWd       

	// criacao de uma tela 
	DEFINE MSDIALOG oDlg TITLE "Novos Valores da Venda" From 8,0 To 40,100 OF oMainWd
	
		@ 35,010 SAY "VALOR ANTERIOR: "  + Transform(nWOldVlr,"@E 999,999,999.99")  OF oDlg PIXEL
		@ 35,120 SAY "VALOR ACRESCIMO: " + Transform(_nWdVlr, "@E 999,999,999.99")  OF oDlg PIXEL
		@ 35,210 SAY "VALOR CORRIGIDO: " + Transform(nWOldVlr + _nWdVlr, "@E 999,999,999.99")  OF oDlg PIXEL
		
		// montagem de um list Box com os problemas encontrados
		@ 055,005 LISTBOX oLbx VAR cVar FIELDS HEADER;
		                                       "Data",;
		                                       "Valor",;
		                                       "Forma",;		                                           
			SIZE 390,127 OF oDlg PIXEL
			
			oLbx:SetArray( aVetor )
			oLbx:bLine := {|| { aVetor[oLbx:nAt,1],;
			aVetor[oLbx:nAt,2],;
			aVetor[oLbx:nAt,3]}}
			
	// ativação da tela	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() },{||oDlg:End()}) CENTERED
		
Return Nil

/*
				
				aAdd( aPgtos, {	aPrcAuto[nX][aScan(aParcAux,{|x|  Alltrim(x[1]) == "L4_DATA" })][2],;		//01 Data do orcamento
								aPrcAuto[nX][aScan(aParcAux,{|x|  Alltrim(x[1]) == "L4_VALOR"})][2],;		//02 Valor
								aPrcAuto[nX][aScan(aParcAux,{|x|  Alltrim(x[1]) == "L4_FORMA"})][2],;		//03 Forma de pagamento
				  				{ 	"",;
				  					"",;
				  					"",;
				  					aPrcAuto[nX][aScan(aParcAux,{|x|  Alltrim(x[1]) == "L4_ADMINIS"})][2],;	//Administradora
				  					.T.,;
				  				},;																			//04 Array de parcelas
								dDataBase,;				   													//05 Data base
								1,;																			//06 Moeda 
				               	aPrcAuto[nX][aScan(aParcAux,{|x|  Alltrim(x[1]) == "L4_DATA"})][2],;		//07 Data 
				               	aPrcAuto[nX][aScan(aParcAux,{|x|  Alltrim(x[1]) == "L4_FORMAID"})][2]})	//08 FormID 
*/
