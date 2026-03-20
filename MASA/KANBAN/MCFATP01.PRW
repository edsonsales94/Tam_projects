#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"                  
#Include 'Protheus.ch'                                       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCFATP01  º Autor ³ ENER FREDES        º Data ³  19/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importação da Carteira de Pedido em TXT.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MC PLASTICOS                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MCFATP01(lGravaPedido)
	Local cPerg := PADR("MCFATP01",Len(SX1->X1_GRUPO))
	
	Private lKanBan  := If( lGravaPedido == Nil .Or. lGravaPedido , .F., .T.)   // Define se grava o kanban ou pedido de venda direto
	Private aCabArq  := {}
	Private aItemArq := {}
	
	ValidPerg(cPerg)
	If Pergunte(cPerg,.T.)
		Processa({|| fLerArq() },"Importando TXT...")
	EndIf
	
Return Nil

Static Function fLerArq()
	Local nTotReg, cLinha, cCliente, cTipo, cPedido, cItem, dDtPlan, cHrPlan, cSetor, nQuant, cInform, cAstec, cInfXped, cInfLnPed, nL, cQtdTemp, cDtTemp
	Local cDataPrd, cHoraPrd, cModelo, cPesoBru, cEmbalage, cPostos, cClassi, cTipEnt, cLocEnt, cEmpDes, cTipPed, cItePSV, cHrHonda, nPos
	Local cPastaArq := Alltrim(GetMV("MV_XPCART"))
	Local cSetAstec := GetMV("MV_XSETAST",.F.,"DIV.PC.EMB")
	Local cPositivo := GetMV("MV_XCLIPOS",.F.,"L4527E,L4527F,L45281")    // Cliente POSITIVO
	local aArquivos := {}
	Local lCab      := .T.
	Local cParCli   := AllTrim(Mv_Par01)
	//Local cParLoja  := AllTrim(Mv_Par02)
	Local cA1KANBAN := If( lKanban , "1", " 2")
	Local aHoras    := {}
	Local lOk       := .F.
	
	Private nHandle, aItens, cHashMD5
	
	aArquivos := Directory(cPastaArq+"\*.TXT", "D")
	
	SA1->(dbSetOrder(1))
	
	For nL := 1 to Len(aArquivos)
		
		cHashMD5 := MD5FILE(cPastaArq+"\"+aArquivos[nL,1] , 2, 0 )   // Calcula o identificador do arquivo
		
		If Empty(cHashMD5)
			FWAlertError("Ocorreu um erro na leitura do arquivo "+cPastaArq+"\"+aArquivos[nL,1]+" informado !")
			Loop
		Else
			SZ1->(dbSetOrder(2))
			If SZ1->(dbSeek(XFILIAL("SZ1")+cHashMD5))
				MostraLog("O arquivo "+cPastaArq+"\"+aArquivos[nL,1]+" já foi importado ! Hash: "+cHashMD5)
				Loop
			Endif
		Endif
		
		nHandle := FT_FUse(cPastaArq+"\"+aArquivos[nL,1])
		
		If FError() != 0
			FWAlertError("Erro ao abrir arquivo","ERRO")
			Return .f.
		EndIf
		
		FT_FGoTop()
		nTotReg := FT_FLastRec()
		ProcRegua(nTotReg)
		aCabArq     := {}
		aItemArq    := {}
		lMostraTela := .T.
		While !FT_FEOF()
			
			IncProc()
			
			cLinha    := FT_FReadLn()
			
			cCliente  := ExtraiCampo(@cLinha)            // 1
			cTipo     := ExtraiCampo(@cLinha)            // 2
			cPedido   := ExtraiCampo(@cLinha)            // 3
			cItem     := ExtraiCampo(@cLinha)            // 4
			cDtTemp   := ExtraiCampo(@cLinha)            // 5
			cHrPlan   := ExtraiCampo(@cLinha)            // 6
			cSetor    := ExtraiCampo(@cLinha)            // 7
			cQtdTemp  := ExtraiCampo(@cLinha)            // 8
			cInform   := ExtraiCampo(@cLinha)            // 9
			cAstec    := ExtraiCampo(@cLinha)            // 10
			cInfXped  := ExtraiCampo(@cLinha)            // 11
			cInfLnPed := ExtraiCampo(@cLinha)            // 12
			
			If Trim(cSetor) $ cSetAstec   // Se for de um setor específico a loja será sempre 02
				cAstec := "02"
			Endif
			
			If Empty(cInform) .And. Trim(cHrPlan) == "00:00:00"   // Caso não tenha conteúdo válido para a hora
				nPos := AScan( aHoras , {|x| x[1] == cItem+cDtTemp } )
				If nPos == 0
					AAdd( aHoras , { cItem+cDtTemp, 0})
					nPos := Len(aHoras)
				Endif
				aHoras[nPos,2]++
				
				If Right(StrZero(aHoras[nPos,2],6),2) >= "60"
					aHoras[nPos,2] += 40
				Endif
				
				cHrPlan := Transform(StrZero(aHoras[nPos,2],6),"@R 99:99:99")
			Endif
			
			If mv_par01 $ cPositivo    // Caso seja o cliente POSITIVO
				If !Empty(cPedido) .And. Empty(cInfLnPed)   // Caso não venha linha do pedido
					// Caso seja um pedido válido e haja uma barra no número do pedido
					If cTipo == "1" .And. (nPos := At("/",cPedido)) > 0
						// Separa a linha do número do pedido
						cInfLnPed := SubStr(cPedido,nPos+1,Len(cPedido))
						//cPedido   := PADR(cPedido,nPos-1)
					Endif
				Endif
				
				If Empty(cInform)      // Atribui o pedido do cliente ao Kanban
					cInform := AllTrim(cPedido) + If( Empty(cInfLnPed) , "", "/" + AllTrim(cInfLnPed))
				Endif
			Endif
			
			If !Empty(cPedido) .And. Empty(cInfLnPed)   // Caso não venha linha do pedido
				cInfLnPed := "01"
			Endif
			
			// Pesquisa os novos conteúdos da Honda
			SZ5->(dbSetOrder(3))
			If SZ5->(dbSeek(XFILIAL("SZ5")+cCliente+PADR(cItem,Len(SZ5->Z5_PRODUTO))+PADR(cInform,Len(SZ5->Z5_KANBAN))+StrTran(cDtTemp,"-","")))
				cLinha   := Trim(SZ5->Z5_HONDA)
				cHrHonda := SubStr(SZ5->Z5_FENIX,30,5)
			Else
				cHr := cHrPlan
			Endif
			
			cDataPrd  := ExtraiCampo(@cLinha)            // 13
			cHoraPrd  := ExtraiCampo(@cLinha)            // 14
			cModelo   := ExtraiCampo(@cLinha)            // 15
			cPesoBru  := ExtraiCampo(@cLinha)            // 16
			cEmbalage := ExtraiCampo(@cLinha)            // 17
			cPostos   := ExtraiCampo(@cLinha)            // 18
			cClassi   := ExtraiCampo(@cLinha)            // 19
			cTipEnt   := ExtraiCampo(@cLinha)            // 20
			cLocEnt   := ExtraiCampo(@cLinha)            // 21
			cEmpDes   := ExtraiCampo(@cLinha)            // 22
			cTipPed   := ExtraiCampo(@cLinha)            // 23
			cItePSV   := ExtraiCampo(@cLinha)            // 24
			
			nQuant    := Val(cQtdTemp)
			dDtPlan   := StoD(StrTran(cDtTemp,"-",""))
			if left(cDataPrd,2) = '  '
			   xl:= 1
			Endif   
			If !Empty(cParCli) .And. cParCli <> cCliente
				FT_FUSE()
				lMostraTela := .F.
				Exit
			EndIf
			
			// Somente importa datas de entrega igual ou superior a data atual
			If dDtPlan >= dDataBase
				// Posiciona no cliente e identifica se o controle de kanban permite a importação da carteira
				If SA1->(dbSeek(XFILIAL("SA1")+cCliente)) .And. SA1->A1_XUSAKAN $ cA1KANBAN
					
					If lCab
						AAdd(aCabArq, {cCliente, cAstec})
						lCab := .F.
					EndIf
					
					//                 1        2      3        4        5       6       7        8       9         10         11     12        13        14       15        16         17       18       19       20       21       22       23       24
					AAdd( aItemArq , { cPedido, cItem, dDtPlan, cHrPlan, cSetor, nQuant, cInform, cAstec, cInfXped, cInfLnPed, cTipo, cDataPrd, cHoraPrd, cModelo, cPesoBru, cEmbalage, cPostos, cClassi, cTipEnt, cLocEnt, cEmpDes, cTipPed, cItePSV, cHrHonda})
				Endif
			Endif
			
			FT_FSKIP()
		Enddo
		lCab := .T.
		FT_FUSE()
		
		If lMostraTela
			If !Empty(aCabArq)   // Se encontrou registros válidos
				Processa({|| lOk := fTelaImp() },"Processando os Dados...")
			Endif
			
			If lOk
				// Apaga arquivo no destino antes de movê-lo
				FErase(cPastaArq+"\lidos\"+aArquivos[nL,1])
				
				// Move o arquivo processado para a pasta LIDOS
				If FRename(cPastaArq+"\"+aArquivos[nL,1],cPastaArq+"\lidos\"+aArquivos[nL,1]) < 0
					FWAlertError("Ocorreu um erro ao mover o arquivo " + Str(FError(),4) )
				Endif
			Endif
		EndIf
	Next
	
Return

Static Function ExtraiCampo(cLinha)
	Local nPos    := At("|",cLinha)
	Local cTrecho := Upper(AllTrim(If(nPos>0,Substr(cLinha,1,nPos-1),cLinha)))
	cLinha := If(nPos>0,Substr(cLinha,nPos+1),"")
Return cTrecho

Static Function fTelaImp()
	Local oDlg, nX, cCliente, cProduto, cDescri, cUM, nTitens, nY, aSize, aPosObj
	Local lRet      := .F.
	Local oFonte_16 := TFont():New("Calibri",,-16,.T.,.T.)
	Local oFonte_14 := TFont():New("Calibri",,-14,.T.,.T.)
	
	Private aCampos  := {}
	
	AAdd( aCampos , { "C6_XTIPPED", {|| aItemArq[nX,11]                           }} )   //  1 - Tipo do Pedido
	AAdd( aCampos , { "C6_XCODITE", {|| SA7->A7_CODCLI                            }} )   //  2 - Produto Cliente
	AAdd( aCampos , { "A7_PRODUTO", {|| cProduto                                  }} )   //  3 - Produto MC
	AAdd( aCampos , { "A7_DESCCLI", {|| cDescri                                   }} )   //  4 - Descrição Produto
	AAdd( aCampos , { "C6_UM"     , {|| cUM                                       }} )   //  5 - Unidade Produto
	AAdd( aCampos , { "C6_QTDVEN" , {|| aItemArq[nX,6]                            }} )   //  6 - Quantidade
	AAdd( aCampos , { "C6_ENTREG" , {|| aItemArq[nX,3]                            }} )   //  7 - Data de Entrega
	AAdd( aCampos , { "C6_PEDCLI" , {|| aItemArq[nX,1]                            }} )   //  8 - Pedido Cliente
	AAdd( aCampos , { "C6_XSETENT", {|| PADR(aItemArq[nX,5],Len(SZ1->Z1_SETENT))  }} )   //  9 - Setor
	AAdd( aCampos , { "C6_XHORENT", {|| FormataHora(aItemArq[nX,4])               }} )   // 10 - Hora
	AAdd( aCampos , { "Z1_HRHONDA", {|| aItemArq[nX,24]                           }} )   // 11 - Hora Honda
	AAdd( aCampos , { "C6_XPED"   , {|| aItemArq[nX,9]                            }} )   // 12 - Linha
	AAdd( aCampos , { "C6_XLINPED", {|| aItemArq[nX,10]                           }} )   // 13 - xPed
	AAdd( aCampos , { "C6_XKANBAN", {|| PADR(aItemArq[nX,7],Len(SZ1->Z1_KANBAN))  }} )   // 14 - Kanban
	AAdd( aCampos , { "C6_LOJA"   , {|| PADR(aItemArq[nX,8],Len(SZ1->Z1_LOJA  ))  }} )   // 15 - Astec
	AAdd( aCampos , { "C6_XDATPRD" ,{|| StoD(StrTran(aItemArq[nX,12],"-",""))     }} )   // 16 - Data Produção
	AAdd( aCampos , { "C6_XHORPRD" ,{|| StrTran(aItemArq[nX,13],":","")           }} )   // 17 - Hora Produção
	AAdd( aCampos , { "C6_XMODELO" ,{|| aItemArq[nX,14]                           }} )   // 18 - Modelo
	AAdd( aCampos , { "C6_XPESOBR" ,{|| Val(aItemArq[nX,15])                      }} )   // 19 - Peso Bruto
	AAdd( aCampos , { "C6_XEMBALA" ,{|| aItemArq[nX,16]                           }} )   // 20 - Embalagem
	AAdd( aCampos , { "C6_XPOSTOS" ,{|| aItemArq[nX,17]                           }} )   // 21 - Postos
	AAdd( aCampos , { "C6_XCLASSI" ,{|| aItemArq[nX,18]                           }} )   // 22 - Classificação
	AAdd( aCampos , { "C6_XTIPENT" ,{|| aItemArq[nX,19]                           }} )   // 23 - Tipo Entrega
	AAdd( aCampos , { "C6_XLOCENT" ,{|| aItemArq[nX,20]                           }} )   // 24 - Local de Entrega
	AAdd( aCampos , { "C6_XEMPDES" ,{|| aItemArq[nX,21]                           }} )   // 25 - Empresa Destino
	AAdd( aCampos , { "C6_OK"     , {|| aItemArq[nX,22]                           }} )   // 26 - Tp Pedido Honda
	AAdd( aCampos , { "C6_XPSV"   , {|| aItemArq[nX,23]                           }} )   // 27 - Item PSV
	
	Private aHeader := {}
	Private aCols   := {}
	
	SX3->(dbSetOrder(2))
	
	For nX:=1 To Len(aCampos)
		AAdd( aHeader , aCampos[nX,1] )
		
		SX3->(dbSeek(aHeader[nX]))   // Posiciona no campo
		
		aHeader[nX] := {	Trim(X3Titulo()), ;
								SX3->X3_CAMPO, ;
								SX3->X3_PICTURE , ;
								SX3->X3_TAMANHO , ;
								SX3->X3_DECIMAL , ;
								"", ;
								SX3->X3_USADO   , ;
								SX3->X3_TIPO    , ;
								SX3->X3_F3      , ;
								SX3->X3_CONTEXT , ;
								SX3->X3_CBOX    , ;
								SX3->X3_RELACAO }
	Next
	
	cCliente := aCabArq[1,1]+aCabArq[1,2]
	
	SA1->(DbSetorder(1))
	If SA1->(DbSeek(xFilial("SA1")+cCliente))
		cCliente := SA1->A1_COD + "-"+SA1->A1_LOJA+" "+SA1->A1_NOME
	EndIf
	
	ProcRegua(Len(aItemArq))
	
	nTitens := 0
	For nX:=1 To Len(aItemArq)
		
		IncProc()
		
		cProduto := ""
		cDescri  := ""
		cUM      := ""
		
		DbselectArea("SB1")
		DbSetorder(1)
		If DbSeek(xFilial("SB1")+aItemArq[nX,2]) 
			cProduto := SB1->B1_COD
			cDescri  := SB1->B1_DESC
			cUM      := SB1->B1_UM
		EndIf
		
		SA7->(dbSetOrder(1))
		SA7->(dbSeek(XFILIAL("SA7")+SA1->A1_COD+SA1->A1_LOJA+SB1->B1_COD))
		
		AddLinhaaCols(@aCols,aHeader)
		
		For nY:=1 To Len(aCampos)
			aCols[nX,nY] := Eval(aCampos[nY,2])
		Next
		
		nTitens++
	Next
	
	PosObjetos(@aSize,@aPosObj)
	//DEFINE MSDIALOG oDlg TITLE OemToAnsi("Importação do Arquivo do Kanban") FROM 09,00 TO 46,160
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Importação do Arquivo do Kanban") From aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ aPosObj[1,1]+00,005 SAY "Validação do Arquivo" SIZE 100,15 OF oDlg PIXEL FONT oFonte_16 COLOR CLR_BLUE
	@ aPosObj[1,1]+00,aPosObj[1,4]-100 BUTTON OemToAnsi("Cancelar") SIZE 40,11 FONT oDlg:oFont ACTION oDlg:End() PIXEL OF oDlg
	@ aPosObj[1,1]+00,aPosObj[1,4]-050 BUTTON OemToAnsi("Importar") SIZE 40,11 FONT oDlg:oFont ACTION If(lRet:=fValidArq(),(aItens:=oGet:aCols,oDlg:End()),) PIXEL OF oDlg
	
	@ aPosObj[1,1]+13,002 TO aPosObj[1,1]+14,aPosObj[1,4] PIXEL OF oDlg
	
	@ aPosObj[1,1]+25,005 SAY "Cliente:" SIZE 100,10 PIXEL OF oDlg 
	@ aPosObj[1,1]+25,045 SAY cCliente SIZE 200,10 OF oDlg PIXEL FONT oFonte_14
	
	@ aPosObj[1,1]+40,005 SAY "Total Pedido:" SIZE 70,10 PIXEL OF oDlg 
	@ aPosObj[1,1]+40,035 SAY PadR(Transform(nTitens,"@E 999,999,999"),15) SIZE 140,10  OF oDlg PIXEL FONT oFonte_14
	
	@ aPosObj[1,1]+50,002 TO aPosObj[1,1]+51,aPosObj[1,4] PIXEL OF oDlg
	
	oGet := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],;
								GD_UPDATE + GD_INSERT + GD_DELETE,;
								"LinOk",;
								"TudoOk",;
								NIL,;
								NIL,;
								NIL,;
								Len(aCols),;
								NIL,;
								NIL,;
								"AllWaysFalse",; 							//Validacao p/ delecao
								oDlg,;
								@aHeader,;
								@aCols)
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If lRet .And. lKanBan
	Processa({|| lRet := ExcluiCarteira(SA1->A1_COD,SA1->A1_LOJA) },"Excluindo kanban...")
	Endif
	
	If lRet
		Processa({|| lRet := fGeraPV(aItens) },"Gravando "+If( lKanBan , "kanban", "pedidos")+"...")
	Endif
	
Return lRet

Static Function fValidArq()
	Local nPKan   := AScan( aHeader , {|x| Trim(x[2]) == "C6_XKANBAN" })
	Local nPDat   := AScan( aHeader , {|x| Trim(x[2]) == "C6_XDATPRD" })
	Local nPTip   := AScan( aHeader , {|x| Trim(x[2]) == "C6_XTIPPED" })
	Local nPLoj   := AScan( aHeader , {|x| Trim(x[2]) == "C6_LOJA"    })
	Local nPSet   := AScan( aHeader , {|x| Trim(x[2]) == "C6_XSETENT" })
  	Local cCliHon := GetMV("MV_XCLIHON",.F.,"L0052701,L0054201")   // Clientes Honda que precisam de validação dos dados adicionais
	Local cLocExc := GetMV("MV_XSETEXC",.F.,"NOV. MODELOS")        // Setor exceção para não validar os dados adicionais
	Local nLin    := 0
	Local lReturn := .F.
	
	SA1->(dbSetOrder(1))
	SE4->(dbSetOrder(1))
	
	If SA1->(dbSeek(XFILIAL("SA1")+aCabArq[1,1]+aCabArq[1,2])) .And. ( !Empty(SA1->A1_COND) .And. SE4->(dbSeek(XFILIAL("SE4")+SA1->A1_COND)) )
		If SA1->A1_COD+SA1->A1_LOJA $ cCliHon  // Clientes Honda LUCCA
			If (nLin:=AScan( aCols , {|x| Trim(x[nPTip]) == "1" .And. x[nPLoj] == "01" .And. !(Trim(x[nPSet]) $ cLocExc) .And. (Empty(x[nPDat]) .Or. Empty(x[nPKan])) })) > 0
				FWAlertError("Existem itens sem os dados necessários para impressão do QrCode Honda ! <br /><br />"+;
							"Linha: " + LTrim(Str(nLin,10)),"Erro - Sem Dados Adicionais !")
			Else
				lReturn := .T.
			Endif
		Else
			lReturn := .T.
		Endif
	Else   
		FWAlertError("A Codição de Pagamento não foi localizada no Cadastro do Cliente "+aCabArq[1,1]+"/"+aCabArq[1,2]+" - "+Alltrim(SA1->A1_NOME)+".","Erro - Condição de Pagamento Inválida!")
	EndIf

Return lReturn

Static Function AddLinhaaCols(aCols,aHeader)
	Local nX
	Local nTam := Len(aCols)+1
	
	AAdd( aCols , Array(Len(aHeader)+1) )
	For nX:=1 To Len(aHeader)
		aCols[nTam,nX] := CriaVar(aHeader[nX,2])
	Next
	aCols[nTam,Len(aHeader)+1] := .F.
	
Return

Static Function ExcluiCarteira(cCodigo,cLoja)
	Local cQry
	
	// Iguala as quantidades dos itens faturados parcialmente
	cQry := "UPDATE " + RetSQLName("SZ1")
	cQry += " SET Z1_QUANT = Z1_QTDENT"
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND Z1_CLIENTE = '"+cCodigo+"'"
	
	If cCodigo $ GETMV("MV_XESP002")
		cQry += " AND Z1_LOJA = '"+cLoja+"'"
	EndIf
	
	//cQry += " AND Z1_DATENT >= '"+DtoS(dDataBase)+"'"
	cQry += " AND Z1_QTDENT > 0"
	cQry += " AND Z1_QTDENT < Z1_QUANT"
	
	If TCSQLExec(cQry) < 0
		FWAlertError("TCSQLError() " + TCSQLError())
		Return .F.
	Endif
	
	// Exclui os itens ainda não faturados
	cQry := "UPDATE " + RetSQLName("SZ1")
	cQry += " SET D_E_L_E_T_ = '*'" //, R_E_C_D_E_L = R_E_C_N_O_"
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND Z1_CLIENTE = '"+cCodigo+"'"
	If cCodigo $ GETMV("MV_XESP002")
		cQry += " AND Z1_LOJA = '"+cLoja+"'"
	EndIf
	//cQry += " AND Z1_DATENT >= '"+DtoS(dDataBase)+"'"
	cQry += " AND Z1_QTDENT = 0"
	
	If TCSQLExec(cQry) < 0
		FWAlertError("TCSQLError() " + TCSQLError())
		Return .F.
	Endif
	
Return .T.

Static Function fGeraPV(aItens)
	Local x, y, nValor, nSaveSX8, nPos, aItem
	Local nX       := 1
	Local lRetorno := .F.
	Local nPreco   := 0      
  	Local cLocExp  := Alltrim(GetMV("MV_XLOCEXP"))
	Local aArrSC5  := {}
	Local aArrSC6  := {}
	Local cItem    := StrZero(0,Len(SC6->C6_ITEM))
  	Local nPPrd    := PosCampo("A7_PRODUTO")
  	Local nPTip    := PosCampo("C6_XTIPPED")
  	Local nPEnt    := PosCampo("C6_ENTREG" )
  	Local nPHor    := PosCampo("C6_XHORENT")
  	Local nPHHd    := PosCampo("Z1_HRHONDA")
  	Local nPSet    := PosCampo("C6_XSETENT")
  	Local nPKan    := PosCampo("C6_XKANBAN")
  	Local nPQtd    := PosCampo("C6_QTDVEN" )
  	Local nPCIt    := PosCampo("C6_XCODITE")
  	Local nPPCl    := PosCampo("C6_PEDCLI" )
  	Local nPxPd    := PosCampo("C6_XPED"   )
  	Local nPLin    := PosCampo("C6_XLINPED")
  	Local nPLoj    := PosCampo("C6_LOJA"   )
	Local nPDtP    := PosCampo("C6_XDATPRD")
	Local nPHrP    := PosCampo("C6_XHORPRD")
	Local nPMod    := PosCampo("C6_XMODELO")
	Local nPPes    := PosCampo("C6_XPESOBR")
	Local nPEmb    := PosCampo("C6_XEMBALA")
	Local nPPos    := PosCampo("C6_XPOSTOS")
	Local nPCls    := PosCampo("C6_XCLASSI")
	Local nPTPE    := PosCampo("C6_XTIPENT")
  	Local nPLoc    := PosCampo("C6_XLOCENT")
  	Local nPEmp    := PosCampo("C6_XEMPDES")
	Local nPPOk    := PosCampo("C6_OK"     )
  	Local nPPSV    := PosCampo("C6_XPSV"   )
  	Local aPrev    := {}
	Local NPEYNT
  	
	lMsErroAuto := .F.
	
	ASort( aItens ,,, {|x,y| DtoS(x[nPEnt])+x[nPHor]+x[nPSet]+x[nPKan] < DtoS(y[nPEnt])+y[nPHor]+y[nPSet]+y[nPKan] } )
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(XFILIAL("SA1")+aCabArq[1,1]))
	
	ProcRegua(Len(aItens))
	
	BeginTran()
	
	While nX <= Len(aItens)
		
		IncProc()
		
		If aItens[nX,nPTip] == "1"
			// Posiciona no Cadastro de Produtos
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+aItens[nX,nPPrd]))
			
			SB2->(dbSetOrder(1))
			If !SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+cLocExp))
				CriaSB2(SB1->B1_COD,cLocExp)
			EndIf
			 
			If lKanban
				// Verifica se o kanban já existe, caso exista atualiza os campos de informação e quantidade
				SZ1->(dbSetOrder(1))  // Z1_FILIAL+Z1_CLIENTE+Z1_LOJA+Z1_PRODUTO+DTOS(Z1_DATENT)+Z1_HORENT+Z1_SETENT+Z1_KANBAN
				If SZ1->(dbSeek(XFILIAL("SZ1")+SA1->A1_COD+aItens[nX,nPLoj]+SB1->B1_COD+DtoS(aItens[nX,nPEnt])+aItens[nX,nPHor]+aItens[nX,nPSet]+aItens[nX,nPKan]))
			      //Z1_CLIENTE+Z1_LOJA+Z1_PRODUTO+DTOS(Z1_DATENT)+Z1_HORENT+Z1_SETENT+Z1_KANBAN
				    // de lucca 30/01/2023 - item a item Samsung
					IF SA1->A1_COD = "L00634"
					   QtdDif := 0 
					   Chave := SA1->A1_COD+aItens[nX,nPLoj]+SB1->B1_COD+DtoS(aItens[nX,nPEnt])+aItens[nX,nPHor]+aItens[nX,nPSet]+aItens[nX,nPKan]
					   While Chave == SZ1->(Z1_CLIENTE+Z1_LOJA+Z1_PRODUTO+DTOS(Z1_DATENT)+Z1_HORENT+Z1_SETENT+Z1_KANBAN)
					         IF aItens[nX,nPQtd]  == SZ1->Z1_QUANT
							    nQtdDif := 1
							 /*else
							    nQtdDif := 0*/
							 ElseIf aItens[nX,nPQtd] > SZ1->Z1_QUANT
							 	nQtdDif := 2
								RecLock("SZ1",.F.)
									SZ1->Z1_QUANT   := aItens[nX,nPQtd]
								MsUnLock()
							 Else 
							 	nQtdDif := 0
							 ENDIF		
							 SZ1->(DBSKIP())
						END
						IF nQtdDif = 0	 
					            RecLock("SZ1",.T.)
					            SZ1->Z1_FILIAL  := XFILIAL("SZ1")
					            SZ1->Z1_CLIENTE := SA1->A1_COD
					            SZ1->Z1_LOJA    := aItens[nX,nPLoj]
					            SZ1->Z1_PRODUTO := SB1->B1_COD
					            SZ1->Z1_DATENT  := aItens[nX,nPEnt]
					            SZ1->Z1_HORENT  := SZ1->(RIGHT( SZ1->Z1_KANBAN, 3 ))
								//SZ1->Z1_HORENT  := aItens[nX,nPHor]
					            SZ1->Z1_SETENT  := aItens[nX,nPSet]
					            SZ1->Z1_KANBAN  := aItens[nX,nPKan]
					            SZ1->Z1_HRHONDA := aItens[nX,nPHHd]
				                SZ1->Z1_QUANT	:= Max(aItens[nX,nPQtd],SZ1->Z1_QTDENT)  // Anizio Cunha 02/01/2025
				                SZ1->Z1_TIPPED  := aItens[nX,nPPOk]
				                SZ1->Z1_PEDCLI  := aItens[nX,nPPCl]
				                SZ1->Z1_XPED    := aItens[nX,nPxPd]
				                SZ1->Z1_LINPED  := aItens[nX,nPLin]
				                SZ1->Z1_ITEMPSV := aItens[nX,nPPSV]
				                SZ1->Z1_HASHMD5 := cHashMD5
				                SZ1->Z1_DATPRD  := aItens[nX,nPDtP]
				                SZ1->Z1_HORPRD  := aItens[nX,nPHrP]
				                SZ1->Z1_MODELO  := aItens[nX,nPMod]
				                SZ1->Z1_PESOBR  := aItens[nX,nPPes]
				                SZ1->Z1_EMBALA  := aItens[nX,nPEmb]
				                SZ1->Z1_POSTOS  := aItens[nX,nPPos]
				                SZ1->Z1_CLASSI  := aItens[nX,nPCls]
				                SZ1->Z1_TIPENT  := aItens[nX,nPTPE]
				                SZ1->Z1_LOCENT  := aItens[nX,nPLoc]
				                SZ1->Z1_EMPDES  := aItens[nX,nPEmp]
				                MsUnLock()
						else
							RecLock("SZ1",.F.)
                        ENDIF
					ELSE
					  RecLock("SZ1",.F.) // Anizio Cunha 02/01/2025
					ENDIF  
				Else
					RecLock("SZ1",.T.)
					SZ1->Z1_FILIAL  := XFILIAL("SZ1")
					SZ1->Z1_CLIENTE := SA1->A1_COD
					SZ1->Z1_LOJA    := aItens[nX,nPLoj]
					SZ1->Z1_PRODUTO := SB1->B1_COD
					SZ1->Z1_DATENT  := aItens[nX,nPEnt]
					SZ1->Z1_HORENT  := aItens[nX,nPHor]
					SZ1->Z1_SETENT  := aItens[nX,nPSet]
					SZ1->Z1_KANBAN  := aItens[nX,nPKan]
					SZ1->Z1_HRHONDA := aItens[nX,nPHHd]
				Endif // Anizio Cunha 02/01/2025
				SZ1->Z1_QUANT   := Max(aItens[nX,nPQtd],SZ1->Z1_QTDENT) // Anizio Cunha 02/01/2025
				SZ1->Z1_TIPPED  := aItens[nX,nPPOk]
				SZ1->Z1_PEDCLI  := aItens[nX,nPPCl]
				SZ1->Z1_XPED    := aItens[nX,nPxPd]
				SZ1->Z1_LINPED  := aItens[nX,nPLin]
				SZ1->Z1_ITEMPSV := aItens[nX,nPPSV]
				SZ1->Z1_HASHMD5 := cHashMD5
				
				SZ1->Z1_DATPRD  := aItens[nX,nPDtP]
				SZ1->Z1_HORPRD  := aItens[nX,nPHrP]
				SZ1->Z1_MODELO  := aItens[nX,nPMod]
				SZ1->Z1_PESOBR  := aItens[nX,nPPes]
				SZ1->Z1_EMBALA  := aItens[nX,nPEmb]
				SZ1->Z1_POSTOS  := aItens[nX,nPPos]
				SZ1->Z1_CLASSI  := aItens[nX,nPCls]
				SZ1->Z1_TIPENT  := aItens[nX,nPTPE]
				SZ1->Z1_LOCENT  := aItens[nX,nPLoc]
				SZ1->Z1_EMPDES  := aItens[nX,nPEmp]
				MsUnLock()
				//EndIf 
			Else
				nPreco := u_fPrecoTab(SB1->B1_COD,SA1->A1_COD+aItens[nX,nPLoj])
				cItem  := Soma1(cItem)
				nValor := a410Arred( aItens[nX,6] * nPreco , "C6_VALOR" , NIL )
				
				aItem  := {}
				AAdd( aItem, { "C6_FILIAL"  , xFilial("SC6")  , Nil} )
				AAdd( aItem, { "C6_ITEM"    , cItem           , Nil} )
				AAdd( aItem, { "C6_PRODUTO" , SB1->B1_COD     , Nil} )
				AAdd( aItem, { "C6_DESCRI"  , SB1->B1_DESC    , Nil} )
				AAdd( aItem, { "C6_QTDVEN"  , aItens[nX,nPQtd], Nil} )
				AAdd( aItem, { "C6_ENTREG"  , aItens[nX,nPEnt], Nil} )
				AAdd( aItem, { "C6_UM"      , SB1->B1_UM      , Nil} )
				AAdd( aItem, { "C6_OPER"    , "01"            , Nil} )
				AAdd( aItem, { "C6_QTDLIB"  , 0               , Nil} )
				AAdd( aItem, { "C6_LOCAL"   , cLocExp         , Nil} )
				AAdd( aItem, { "C6_CLI"     , SA1->A1_COD     , Nil} )
				AAdd( aItem, { "C6_LOJA"    , SA1->A1_LOJA    , Nil} )
				AAdd( aItem, { "C6_PRCVEN"  , nPreco          , Nil} )
				AAdd( aItem, { "C6_VALOR"   , nValor          , Nil} )
				AAdd( aItem, { "C6_PRUNIT"  , nPreco          , Nil} )
				AAdd( aItem, { "C6_XTIPPED" , aItens[nX,nPPOk], Nil} )
				AAdd( aItem, { "C6_XCODITE" , aItens[nX,nPCIt], Nil} )
				AAdd( aItem, { "C6_PEDCLI"  , aItens[nX,nPPCl], Nil} )
				AAdd( aItem, { "C6_XSETENT" , aItens[nX,nPSet], Nil} )
				AAdd( aItem, { "C6_XHORENT" , aItens[nX,nPHor], Nil} )
				AAdd( aItem, { "C6_XPED"    , aItens[nX,nPxPd], Nil} )
				AAdd( aItem, { "C6_XLINPED" , aItens[nX,nPLin], Nil} )
				AAdd( aItem, { "C6_XKANBAN" , aItens[nX,nPKan], Nil} )
				AAdd( aItem, { "C6_XPSV"    , aItens[nX,nPPSV], Nil} )
				
				// Dados Adicionais do Kanban Honda
				AAdd( aItem , { "C6_XDATPRD" , DtoS(Itens[nX,nPDtP]), Nil} )
				AAdd( aItem , { "C6_XHORPRD" , aItens[nX,nPHrP], Nil} )
				AAdd( aItem , { "C6_XMODELO" , aItens[nX,nPMod], Nil} )
				AAdd( aItem , { "C6_XPESOBR" , aItens[nX,nPPes], Nil} )
				AAdd( aItem , { "C6_XEMBALA" , aItens[nX,nPEmb], Nil} )
				AAdd( aItem , { "C6_XPOSTOS" , aItens[nX,nPPos], Nil} )
				AAdd( aItem , { "C6_XCLASSI" , aItens[nX,nPCls], Nil} )
				AAdd( aItem , { "C6_XTIPENT" , aItens[nX,nPTPE], Nil} )
				AAdd( aItem , { "C6_XLOCENT" , aItens[nX,nPLoc], Nil} )
				AAdd( aItem , { "C6_XEMPDES" , aItens[nX,nPEmp], Nil} )
				
				aAdd(aArrSC6,aClone(aItem))
			Endif
		EndIf
		
		// Acumula os dados da previsão
		nPos := AScan( aPrev , {|x| x[1] == aItens[nX,nPPrd] .And. x[2] == aItens[nX,nPEnt] } )
		If nPos == 0
			AAdd( aPrev , { aItens[nX,nPPrd], aItens[nX,nPEnt], 0, aItens[nX,nPPCl]} )
			nPos := Len(aPrev)
		Endif
		aPrev[nPos,3] += aItens[nX,nPQtd]
		
		nX++
	Enddo	
	
	If lKanban .And. (!Empty(aArrSC6) .Or. !Empty(aPrev))
		lRetorno := .T.
	Endif
	
	If !lKanban .And. !Empty(aArrSC6)
		cNumPed := GetSXENum("SC5","C5_NUM")   // Pega o próximo pedido de venda
		RollBAckSx8()
		
		// Variavel que controla numeracao
		nSaveSX8 := GetSx8Len()
		
		aArrSC5 := {{ "C5_FILIAL"  , xFilial("SC5")  , Nil}, ;
					{ "C5_NUM"     , cNumPed         , Nil}, ;
					{ "C5_TIPO"    , "N"             , Nil}, ;
					{ "C5_CLIENTE" , SA1->A1_COD     , Nil}, ;
					{ "C5_LOJACLI" , SA1->A1_LOJA    , Nil}, ;
					{ "C5_CLIENT"  , SA1->A1_COD     , Nil}, ;
					{ "C5_LOJAENT" , SA1->A1_LOJA    , Nil}, ;
					{ "C5_EMISSAO" , dDataBase       , Nil}, ;
					{ "C5_CONDPAG" , SA1->A1_COND    , Nil}, ;
					{ "C5_TABELA"  , ""              , Nil}, ;
					{ "C5_MOEDA"   , 1               , Nil}, ;
					{ "C5_TIPOCLI" , SA1->A1_TIPO    , Nil} }
		
		MSExecAuto({|x,y,Z| Mata410(x,y,Z)}, aArrSC5, aArrSC6, 3)

		If lRetorno := !lMsErroAuto
			If (__lSX8)
				// Confirma SX8
				While ( GetSx8Len() > nSaveSX8 )
					ConfirmSX8()
				Enddo
			EndIf
		Else
			MostraErro()
			
			If (__lSX8)
				While ( GetSx8Len() > nSaveSX8 )
					RollBackSx8()
				Enddo
			EndIf
			
			DisarmTransaction()
		EndIf
	Endif

	If lRetorno
		Processa({|| GravaPrevisao(aPrev) },"Gravando da previsão de venda. Aguarde...")
		
		EndTran()
		
		If lKanban
			FWAlertSuccess("Kanban foi importado com sucesso !","Importação Kanban")
		Else
			If MV_PAR02 = 1
				FWAlertSuccess("PEDIDO - "+cNumPed,"Pedido "+cNumPed+" gerado com sucesso !")
			Else
				FWAlertSuccess("PEDIDO - "+cNumPed,"Pedido - "+cNumPed+" alterado com Sucesso!!")
			EndIf
		Endif
	Endif
	
Return lRetorno

Static Function PosCampo(cCampo)
Return AScan( aCampos , {|x| x[1] == cCampo } )

User Function fPrecoTab(cProduto,cCliente)
	Local nPreco := 0
	Local aArea  := GetArea()
	Local cQuery
	
	Default cCliente := "XyZxYzZz"
	
	SA1->(dbSetOrder(1))
	DA0->(dbSetOrder(1))
	DA1->(dbSetOrder(1))
	
	// Posiciona no Cliente e na tabela de preço definida para o mesmo
	If SA1->(dbSeek(XFILIAL("SA1")+cCliente)) .And. !Empty(SA1->A1_TABELA) .And. DA0->(dbSeek(XFILIAL("DA0")+SA1->A1_TABELA))
		// Caso a tabela esteja ativa
		If DA0->DA0_ATIVO == "1" .And. dDataBase >= DA0->DA0_DATDE .And. dDataBase <= If( Empty(DA0->DA0_DATATE) , dDataBase, DA0->DA0_DATATE)
			// Pesquisa os preços definidos para o produto + tabela cliente
			DA1->(dbSeek(XFILIAL("DA1")+SA1->A1_TABELA+cProduto,.T.))
			While !DA1->(Eof()) .And. XFILIAL("DA1")+SA1->A1_TABELA+cProduto == DA1->DA1_FILIAL+DA1->DA1_CODTAB+DA1->DA1_CODPRO
				// Caso a tabela definida para o produto esteja ativa
				If DA1->DA1_ATIVO == "1" .And. dDataBase >= If( Empty(DA1->DA1_DATVIG) , dDataBase, DA1->DA1_DATVIG)
					nPreco := DA1->DA1_PRCVEN    // Retorna o preço do produto + cliente e sai da pesquisa
					Exit
				Endif
				DA1->(dbSkip())
			Enddo
		Endif
	Endif
	
	// Caso não tenha encontrado um preço válido, processa o método antigo
	If nPreco == 0
		cQuery := " SELECT DA1_CODTAB,DA1_CODPRO,DA1_PRCVEN,DA1_ATIVO,DA1_DATVIG FROM "+RetSqlName("DA1")+" DA1"
		cQuery += " WHERE DA1_CODPRO = '"+cProduto+"' AND DA1_ATIVO = '1' AND DA1.D_E_L_E_T_ = ''"
		
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TBTEMP", .T., .T.)
		While !TBTEMP->(Eof())
			nPreco := TBTEMP->DA1_PRCVEN
			TBTEMP->(DbSkip())
		Enddo
		DbCloseArea()
	Endif
	RestArea(aArea)
	
Return nPreco

Static Function GravaPrevisao(aPrev)
	Local x, d, cProduto
	
	SC4->(dbSetOrder(1))
	
	ASort( aPrev ,,, {|x,y| x[1]+DtoS(x[2]) < y[1]+DtoS(y[2]) } )   // Ordena por PRODUTO + DATA ENTREGA
	
	ProcRegua(Len(aPrev))
	x := 1
	While x <= Len(aPrev)
		cProduto := aPrev[x,1]
		While x <= Len(aPrev) .And. cProduto == aPrev[x,1]
			
			IncProc()
			
			If SC4->(dbSeek(XFILIAL("SC4")+cProduto+DtoS(aPrev[x,2])))
				RecLock("SC4",.F.)
				SC4->C4_QUANT := aPrev[x,3]
				SC4->C4_VALOR := a410Arred( SC4->C4_QUANT * u_fPrecoTab(cProduto) , "C6_VALOR" , NIL )
				MsUnLock()
			Else
				RecLock("SC4",.T.)
				SC4->C4_FILIAL  := xFilial("SC4")
				SC4->C4_PRODUTO := cProduto
				SC4->C4_LOCAL   := Posicione("SB1",1,XFILIAL("SB1")+cProduto,"B1_LOCPAD")
				SC4->C4_DOC     := SA1->A1_COD + SA1->A1_LOJA
				SC4->C4_QUANT   := aPrev[x,3]
				SC4->C4_VALOR   := a410Arred( SC4->C4_QUANT * u_fPrecoTab(cProduto) , "C6_VALOR" , NIL )
				SC4->C4_DATA    := aPrev[x,2]
				SC4->C4_OBS     := aPrev[x,4]
				MsUnLock()
			Endif

			x++
			
			// Apaga as datas não atualizadas
			If x <= Len(aPrev) .And. cProduto == aPrev[x,1]
				For d:=(aPrev[x-1,2]+1) To (aPrev[x,2]-1)
					If SC4->(dbSeek(XFILIAL("SC4")+cProduto+DtoS(d)))
						RecLock("SC4",.F.)
						dbDelete()
						MsUnLock()
					Endif
				Next
			Endif
		Enddo
		
	Enddo
	
Return

Static Function FormataHora(cHora)
	Local cRet := PADR(AllTrim(cHora),Len(SZ1->Z1_HORENT))
	
	// Caso o conteúdo da hora não seja válida, grava com espaço em branco
	If Val(StrTran(cRet,":","")) == 0
		cRet := CriaVar("Z1_HORENT",.F.)
	Endif

Return cRet

Static Function MostraLog(cMsg)
	Local oFntTxt := TFont():New("Lucida Console",,-015,,.F.,,,,,.F.,.F.)

	//Criando a janela centralizada com os botões
    DEFINE MSDIALOG oDlgMens TITLE "ATENÇÃO" FROM 000, 000  TO 300, 400 COLORS 0, 16777215 PIXEL
        //Get com o Log
        @ 002, 004 GET oMsg VAR cMsg OF oDlgMens MULTILINE SIZE 191, 121 FONT oFntTxt COLORS 0, 16777215 HSCROLL PIXEL
        oMsg:lReadOnly := .T.
         
        @ 127, 144 BUTTON oBtnOk  PROMPT "OK"   SIZE 051, 019 ACTION (oDlgMens:End()) OF oDlgMens PIXEL
         
    ACTIVATE MSDIALOG oDlgMens CENTERED
Return

Static Function PosObjetos(aSize,aPosObj)
	Local aInfo1
	Local aObjects := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize(.F.)
	
	// Divide a tela para os objetos ENCHOICE e FOLDER
	AAdd( aObjects, { 100, 060, .t., .f. } )    // ENCHOICE
	AAdd( aObjects, { 100, 100, .t., .t. } )    // FOLDER
	
	// Calcula as coordenadas no MSDIALOG para os objetos (ENCHOICE e FOLDER)
	aInfo1  := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo1, aObjects )
	
Return

/*_______________________________________________________________________________
¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ulysses Ribeiro          ¦ Data ¦ 05/12/2005 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Criação das perguntas da rotina.                                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)

	FPPutSx1(cPerg,"01","Cliente"                      ,"Cliente"                      ,"Cliente"                      ,"mv_ch4","C",06,0,0,"G","","SA1","","","Mv_Par04")
	FPPutSx1(cPerg,"02","Loja"                         ,"Loja"                         ,"Loja"                         ,"mv_ch5","C",02,0,0,"G","","","","","Mv_Par05")

Return Nil        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PutSx1    ³ Autor ³Wagner                 ³ Data ³ 14/02/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria uma pergunta usando rotina padrao                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FPPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	Local aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa  := .f.
	Local lIngl := .f. 
	
	If .T. //GetVersao(.F.) < "12"
	
		cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."
		
		cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
		cF3      := Iif( cF3 		== NIl, " ", cF3		)
		cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
		cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
		cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)
		
		dbSelectArea( "SX1" )
		dbSetOrder( 1 )
		
		// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
		// RFC - 15/03/2007
		cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )
		
		If !( DbSeek( cGrupo + cOrdem ))
		
		    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
			cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
			cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
		
			Reclock( "SX1" , .T. )
		
			Replace X1_GRUPO   With cGrupo
			Replace X1_ORDEM   With cOrdem
			Replace X1_PERGUNT With cPergunt
			Replace X1_PERSPA  With cPerSpa
			Replace X1_PERENG  With cPerEng
			Replace X1_VARIAVL With cVar
			Replace X1_TIPO    With cTipo
			Replace X1_TAMANHO With nTamanho
			Replace X1_DECIMAL With nDecimal
			Replace X1_PRESEL  With nPresel
			Replace X1_GSC     With cGSC
			Replace X1_VALID   With cValid
		
			Replace X1_VAR01   With cVar01
		
			Replace X1_F3      With cF3
			Replace X1_GRPSXG  With cGrpSxg
		
			If Fieldpos("X1_PYME") > 0
				If cPyme != Nil
					Replace X1_PYME With cPyme
				Endif
			Endif
		
			Replace X1_CNT01   With cCnt01
			If cGSC == "C" .or. cGSC == "F" 		// Mult Escolha
				Replace X1_DEF01   With cDef01
				Replace X1_DEFSPA1 With cDefSpa1
				Replace X1_DEFENG1 With cDefEng1
		
				Replace X1_DEF02   With cDef02
				Replace X1_DEFSPA2 With cDefSpa2
				Replace X1_DEFENG2 With cDefEng2
		
				Replace X1_DEF03   With cDef03
				Replace X1_DEFSPA3 With cDefSpa3
				Replace X1_DEFENG3 With cDefEng3
		
				Replace X1_DEF04   With cDef04
				Replace X1_DEFSPA4 With cDefSpa4
				Replace X1_DEFENG4 With cDefEng4
		
				Replace X1_DEF05   With cDef05
				Replace X1_DEFSPA5 With cDefSpa5
				Replace X1_DEFENG5 With cDefEng5
			Endif
		
			Replace X1_HELP  With cHelp
		
			PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
		
			MsUnlock()
		Else
		
		   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		   lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
		   lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)
		
		   If lPort .Or. lSpa .Or. lIngl
				RecLock("SX1",.F.)
				If lPort 
		         SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
				EndIf
				If lSpa 
					SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
				EndIf
				If lIngl
					SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
				EndIf
				SX1->(MsUnLock())
			EndIf
		Endif
		
		RestArea( aArea )
	Endif	
Return
