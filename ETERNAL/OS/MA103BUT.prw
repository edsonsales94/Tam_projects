#Include "TOTVS.ch"
#INCLUDE 'ParmType.ch'
#INCLUDE 'FWBrowse.ch
#Include 'FWMVCDef.ch'
#INCLUDE "RWMAKE.CH"

/*
Importar Pedidos de Compras OLUC.
Filtar pela placa do veiculo da coleta.
*/

User Function MA103BUT()
	Local aButtons := {}
	Local dEmisDe   := FirstDate(Date())
	Local dEmisAte  := LastDate(Date())
	Local nFinanc   := 2 // 1=Sim / 2=Não
	Local cPlaca    := Space(10)
	Local cCCODe    := Space(TamSX3("C7_XDOCCO")[1])
	Local cCCOAte   := Space(TamSX3("C7_XDOCCO")[1])

	aadd(aButtons, {'Pedidos de Compras – OLUC', {||  fnParams(@dEmisDe,@dEmisAte,@nFinanc,@cPlaca,@cCCODe,@cCCOAte)}, 'Pedidos de Compras – OLUC'})

Return (aButtons)

Static Function fnParams(dEmisDe, dEmisAte, nFinanc, cPlaca, cCCODe, cCCOAte)

	Local aPergs    	:= {}
	Local aGets    		:= {}
	Local lTxNeg        := .F.
	Local nTaxaMoeda	:= 0
	Local lConsMedic    := .F.
	Local lUsaFiscal	:= .T.
	Local lNfMedic		:= .T.
	Local aHeadSDE 		:= {}
	Local aColsSDE 		:= {}
	Local aHeadSEV 		:= {}
	Local aColsSEV 		:= {}
	Local aRetPed  		:= NIL
	Local OlistBox
	PRIVATE aF4For     := {}
	PRIVATE aRecSC7    := {}
	PRIVATE oOk        := LoadBitMap(GetResources(), "LBOK")
	PRIVATE oNo        := LoadBitMap(GetResources(), "LBNO")

	aAdd(aPergs,{1,"Data Emissão De",  dEmisDe ,"",".T.","",".T.",80,.F.})
	aAdd(aPergs,{1,"Data Emissão Até", dEmisAte,"",".T.","",".T.",80,.T.})
	aAdd(aPergs,{2,"Financeiro (Adiantamento)",nFinanc,{"1=Sim","2=Não"},90,".T.",.F.})
	aAdd(aPergs,{1,"Placa do Veículo",cPlaca,"",".T.","",".T.",80,.F.})
	aAdd(aPergs,{1,"CCO De",cCCODe,"",".T.","",".T.",30,.F.})
	aAdd(aPergs,{1,"CCO Até",cCCOAte,"",".T.","",".T.",30,.T.})


	If CFORMUL == 'N' // PRECISA SER FORMULÁRIO PRÓPRIO
		FwAlertWarning("Essa operação exige que seja informado * Form. próprio = SIM *.",'Warning!!!')
		Return
	EndIf

	If Empty(CA100FOR)
		FwAlertWarning("Fornecedor não informado, Informe o fornecedor para prosseguir.",'Warning!!!')
		Return
	EndIf

	// Verificar se o fornecedor permite formulario proprio.
	if Posicione('SA2',1,xFilial("SA2")+CA100FOR+cLoja,"A2_XFPROP") != 'S'
		FwAlertWarning("Fornecedor não permite formulário próprio, verifique o cadastro do fornecedor informado - (A2_XFPROP).",'Warning!!!')
		Return
	EndIf

	//---------------------------------------------------------
	If ParamBox(aPergs,"Informe os parâmetros")

		dEmisDe  := MV_PAR01
		dEmisAte := MV_PAR02
		nFinanc  := Val(cValToChar(MV_PAR03))
		cPlaca   := AllTrim(MV_PAR04)
		cCCODe   := AllTrim(MV_PAR05)
		cCCOAte  := AllTrim(MV_PAR06)
		// chamar a função que marca os pedidos de compras.
		fnMarkPed(lUsaFiscal,aGets,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV, lTxNeg, nTaxaMoeda, @aRetPed, oListBox, @aRecSC7)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103ForF4 ³ Autor ³ Edson Maricate        ³ Data ³27.01.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de importacao de Pedidos de Compra.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103Pedido()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fnMarkPed(lUsaFiscal,aGets,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV, lTxNeg, nTaxaMoeda, aRetPed, oListBox, aRecSC7)

	Local nSldPed    := 0
	Local nOpc       := 0
	Local cAliasSC7  := "SC7"
	Local cQueryQPC  := ""
	Local lQuery     := .F.
	// Local bSavSetKey := SetKey(VK_F4,Nil)
	Local bSavKeyF1  := SetKey(VK_F1,Nil)
	// Local bSavKeyF6  := SetKey(VK_F6,Nil)
	// Local bSavKeyF7  := SetKey(VK_F7,Nil)
	// Local bSavKeyF8  := SetKey(VK_F8,Nil)
	// Local bSavKeyF9  := SetKey(VK_F9,Nil)
	// Local bSavKeyF10 := SetKey(VK_F10,Nil)
	// Local bSavKeyF11 := SetKey(VK_F11,Nil)
	Local cCbmFor    := ""
	Local cCbmLoj    := ""
	Local aArea      := GetArea()
	Local aAreaSA2   := SA2->(GetArea())
	Local aAreaSC7   := SC7->(GetArea())
	Local aAreaColab := {}
	Local nF4For     := 0
	Local aButtons   := { {'PESQUISA',{|| IIf(Len(aRecSC7) > 0, A103VisuJC(aRecSC7[oListBox:nAt]) ,)},OemToAnsi('Visualiza Pedido'),OemToAnsi('Pedido')} } //"Visualiza Pedido"
	Local oDlg
	Local cNomeFor   := ''
	Local aTitCampos := {}
	Local aConteudos := {}
	Local aUsCont    := {}
	Local aUsTitu    := {}
	Local bLine      := { || .T. }
	Local cLine      := ""
	Local cComboFor  := ""
	Local cCodLoj    := ""
	Local lMa103F4I  := ExistBlock( "MA103F4I" )
	Local nLoop      := 0
	Local lMt103Vpc  := ExistBlock("MT103VPC")
	Local lRet103Vpc := .T.
	Local lContinua  := .T.
	Local lMT103APC  := ExistBlock("MT103APC")
	Local lRetAPC    := .F.
	Local lForpcnf   := .T.//SuperGetMV("MV_FORPCNF",.F.,.F.)
	Local lXmlxped	 := SuperGetMV("MV_XMLXPED",.F.,.F.)
	Local lRetPed    := (aRetPed == Nil)
	Local oSize
	Local nNumCampos := 0
	// Local cRestNFe	:= SuperGetMV("MV_RESTNFE")
	Local lMA103F4L	:= ExistBlock("MA103F4L")
	Local lMA103F4H	:= ExistBlock( "MA103F4H" )
	// Local oNomeFor	:= NIL
	Local lIntPMS := SuperGetMv("MV_INTPMS",.F.,"N") == "S"

	DEFAULT lUsaFiscal := .T.
	DEFAULT aGets      := {}
	DEFAULT lNfMedic   := .F.
	DEFAULT lConsMedic := .F.
	DEFAULT aHeadSDE   := {}
	DEFAULT aColsSDE   := {}

	nTamX3A2CD := 0
	nTamX3A2LJ := 0
	nTamX3A2CD	:= Iif(nTamX3A2CD==0,TamSX3("A2_COD")[1],nTamX3A2CD)
	nTamX3A2LJ	:= Iif(nTamX3A2LJ==0,TamSX3("A2_LOJA")[1],nTamX3A2LJ)

	If VALType("cQueryC7") <> "C"
		PRIVATE cQueryC7   := ""
	EndIf

	//Impede de executar a rotina quando a tecla F3 estiver ativa
	If Type("InConPad") == "L"
		lContinua := !InConPad
	EndIf

	//Impede de executar a rotina quando algum campo estiver em edicao
	If lContinua .And. IsInCallStack("EDITCELL")
		lContinua:=.F.
	EndIf

	//Informa que houve importação de pedido no documento
	If lContinua .And. Type("lImpPedido")<>"U"
		lImpPedido := .T.
	Endif

	//Verifica se a nota foi importada via TOTVS Colaboracao
	If lContinua .And. lXmlxped .And. Type("l103Class") == "L" .And. l103Class
		aAreaColab := GetArea()
		DbSelectArea("SDS")
		SDS->(DbSetOrder(1))
		If SDS->(DbSeek(xFilial("SDS")+cNFiscal+cSerie+cA100For+cLoja))
			Aviso('Aviso','Nota Importada via TOTVS Colaboração',{'OK'})
			lContinua := .F.
		EndIf
		RestArea(aAreaColab)
	EndIf

	//Ponto de entrada para validacoes da importacao do Pedido de Compras
	If lContinua .And. lMT103APC
		lRetAPC := ExecBlock("MT103APC",.F.,.F.)
		If ValType(lRetAPC)=="L"
			lContinua:= lRetAPC
		EndIf
	EndIf

	If lContinua

		If !MaFisFound("NF")
			MaFisIni(CA100For,cLOJA,"F",cTIPO,,,Nil,,,,,,,,Nil)
		endIf

		If MaFisFound("NF") .Or. !lUsaFiscal
			//Verifica se o aCols esta vazio, se o Tipo da Nota é
			//normal e se a rotina foi disparada pelo campo correto
			If cTipo == "N"
				DbSelectArea("SA2")
				SA2->(DbSetOrder(1))
				SA2->(DbSeek(xFilial("SA2")+cA100For+cLoja))
				cNomeFor	:= SA2->A2_NOME

				DbSelectArea("SC7")
				SC7->(DbSetOrder(9))
				lQuery    := .T.
				cAliasSC7 := "QRYSC7"

				/*/------------------------------------------------------------
				MV_PAR01 -> Data Emissão De
				MV_PAR02 -> Data Emissão Até
				MV_PAR03 -> Financeiro
				1 = Sim
				2 = Não
				MV_PAR04 -> Placa
				MV_PAR05 -> CCO De
				MV_PAR06 -> CCO Até
				--------------------------------------------------------------*/

				cQueryC7 := "       SELECT "
				cQueryC7 += "       SC7.R_E_C_N_O_ RECSC7, "
				cQueryC7 += "       SC7.C7_FILIAL, "
				cQueryC7 += "       SC7.C7_NUM, "
				cQueryC7 += "       SC7.C7_ITEM, "
				cQueryC7 += "       SC7.C7_PRODUTO, "
				cQueryC7 += "       SC7.C7_DESCRI, "
				cQueryC7 += "       SC7.C7_UM, "
				cQueryC7 += "       C7_QUANT-C7_QUJE-C7_QTDACLA C7_QUANT, "
				cQueryC7 += "       SC7.C7_QUJE, "
				cQueryC7 += "       SC7.C7_PRECO, "
				cQueryC7 += "       SC7.C7_TOTAL, "
				cQueryC7 += "       SC7.C7_EMISSAO, "
				cQueryC7 += "       SC7.C7_DATPRF, "
				cQueryC7 += "       SC7.C7_FORNECE, "
				cQueryC7 += "       SC7.C7_LOJA, "
				cQueryC7 += "       SC7.C7_CC, "
				cQueryC7 += "       SC7.C7_BASEICM, "
				cQueryC7 += "       SC7.C7_VALICM, "
				cQueryC7 += "       SC7.C7_PICM, "
				cQueryC7 += "       SC7.C7_BASEIPI, "
				cQueryC7 += "       SC7.C7_VALIPI, "
				cQueryC7 += "       SC7.C7_IPI, "
				cQueryC7 += "       SC7.C7_VALIMP5, "
				cQueryC7 += "       SC7.C7_VALIMP6, "
				cQueryC7 += "       SC7.C7_ICMSRET, "
				cQueryC7 += "       SC7.C7_COND, "
				cQueryC7 += "       SC7.C7_TES, "
				cQueryC7 += "       SC7.C7_LOCAL, "
				cQueryC7 += "       SC7.C7_XDOCCO, "
				cQueryC7 += "       SC7.C7_XPLACA, "
				cQueryC7 += "       SC7.C7_XTPDOC, "
				cQueryC7 += "       SC7.C7_RESIDUO, "
				cQueryC7 += "       SE4.E4_DESCRI, "
				cQueryC7 += "       SE4.E4_CTRADT "

				cQueryC7 += " FROM " + RetSqlName("SC7") + " SC7 "

				cQueryC7 += " INNER JOIN " + RetSqlName("SE4") + " SE4 "
				cQueryC7 += "        ON "
				// cQueryC7 += " SE4.E4_FILIAL  = SC7.C7_FILIAL "
				cQueryC7 += "       SC7.C7_COND = SE4.E4_CODIGO "
				cQueryC7 += "       AND SE4.D_E_L_E_T_ = ' ' "
				//====================================================
				// Financeiro (Adiantamento)
				// SE4.E4_CTRADT
				//====================================================

				if Val(cValToChar(MV_PAR03)) == 1      // Sim
					cQueryC7 += " AND SE4.E4_CTRADT = '1' "
				else
					cQueryC7 += " AND (SE4.E4_CTRADT = '2' OR SE4.E4_CTRADT='') "
				endIf

				cQueryC7 += " WHERE SC7.D_E_L_E_T_ = ' ' "
				cQueryC7 += "   AND SC7.C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' "
				cQueryC7 += "   AND SC7.C7_XTPDOC  = 'O' "
				// cQueryC7 += "   AND SC7.C7_QUJE < SC7.C7_QUANT "
				cQueryC7 += "   AND SC7.C7_RESIDUO = ' ' "
				cQueryC7 += "   AND (C7_QUANT-C7_QUJE-C7_QTDACLA)>0  "
				cQueryC7 += "   AND C7_RESIDUO=' '  "
				cQueryC7 += "   AND C7_TPOP<>'P'  "
				cQueryC7 += "   AND C7_TIPO = 1  "
				cQueryC7 += "AND C7_CONAPRO <> 'B' AND C7_CONAPRO <> 'R' "

				//====================================================
				// Data de emissão
				//====================================================
				cQueryC7 += " AND SC7.C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' "
				cQueryC7 += "                         AND '" + DTOS(MV_PAR02) + "' "

				//====================================================
				// CCO
				//====================================================
				cQueryC7 += " AND SC7.C7_XDOCCO BETWEEN '" + ;
					AllTrim(MV_PAR05) + "' AND '" + ;
					AllTrim(MV_PAR06) + "' "

				//====================================================
				// Placa
				//====================================================
				cQueryC7 += " AND SC7.C7_XPLACA = '" + AllTrim(MV_PAR04) + "' "

				cQueryC7 += " ORDER BY "
				cQueryC7 += " SC7.C7_EMISSAO, "
				cQueryC7 += " SC7.C7_NUM, "
				cQueryC7 += " SC7.C7_ITEM "


				If ExistBlock("MT103QPC")
					cQueryQPC := ExecBlock("MT103QPC",.F.,.F.,{cQueryC7,1})
					If (ValType(cQueryQPC) == 'C' )
						cQueryC7 := cQueryQPC
					EndIf
				EndIf

				cQueryC7 := ChangeQuery(cQueryC7)

				If !lRetPed .And. Select(cAliasSC7) > 0
					(cAliasSC7)->(dbCloseArea())
				EndIf

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryC7),cAliasSC7,.T.,.T.)

				Do While (cAliasSC7)->(!Eof())
					SC7->(MsGoto((cAliasSC7)->RECSC7))

					If lMt103Vpc
						lRet103Vpc := .T.
						lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
					Endif

					If lRet103Vpc
						If lConsMedic .And. lNfMedic
							nF4For := aScan(aF4For,{|x|x[5]== SC7->C7_LOJA .And. x[6]== SC7->C7_NUM})
						Else
							nF4For := aScan(aF4For,{|x|x[2]== SC7->C7_LOJA .And. x[3]== SC7->C7_NUM})
						EndIf

						If ( nF4For == 0 )
							If lConsMedic .And. lNfMedic
								aConteudos := {.T.,SC7->C7_MEDICAO,SC7->C7_CONTRA,SC7->C7_PLANILH,SC7->C7_LOJA,SC7->C7_NUM,DTOC(SC7->C7_EMISSAO),If(SC7->C7_TIPO==2,'AE','PC') }
							Else
								cNomeFor := posicione('SA2',1,XFILIAL('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA,'A2_NOME')
								nSldPc := SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA
								aConteudos := {.T.,SC7->C7_FORNECE,cNomeFor,SC7->C7_LOJA,SC7->C7_NUM,DTOC(SC7->C7_EMISSAO),SC7->C7_ITEM,SC7->C7_PRODUTO,nSldPc,SC7->C7_PRECO,SC7->C7_TOTAL,SC7->C7_VLDESC,SC7->C7_COND,SC7->C7_TES,If(SC7->C7_TIPO==2,'AE', 'PC'),SC7->C7_XPLACA,SC7->C7_XDOCCO,iif((cAliasSC7)->E4_CTRADT=='1','Sim','Nao')}
							EndIf

							//Agroindustria
							If FindFunction("OGXUtlOrig") .And. OGXUtlOrig() //Encontra a função
								If FindFunction("OGX200") //Encontra a função
									If ValType( aUsCont := OGX200() ) == "A"
										AEval( aUsCont, { |x| AAdd( aConteudos, x ) } )
									EndIf
								EndIf
							EndIf

							If lMa103F4I
								If ValType( aUsCont := ExecBlock( "MA103F4I", .F., .F. ) ) == "A"
									AEval( aUsCont, { |x| AAdd( aConteudos, x ) } )
								EndIf
							EndIf

							aAdd(aF4For , aConteudos )
							aAdd(aRecSC7, SC7->(Recno()))
						EndIf
					Endif
					(cAliasSC7)->(dbSkip())
				EndDo

				If lMA103F4L
					ExecBlock("MA103F4L", .F., .F., { aF4For, aRecSC7 } )
				EndIf

				//Exibe os dados na Tela
				If (!Empty(aF4For) ) .or. lForPCNF

					aTitCampos := {" ",OemToAnsi('Fornecedor'),OemToAnsi('Nome'),OemToAnsi('Loja'),OemToAnsi('Pedido'),OemToAnsi('Emissao'),OemToAnsi('Item'),OemToAnsi('Produto'),OemToAnsi('Quant'),OemToAnsi('Vlr. Unit'),OemToAnsi('Total'),OemToAnsi('Desconto'),OemToAnsi('Cond. Pgto'),OemToAnsi('TES'),OemToAnsi('Origem'),OemToAnsi('Placa'),OemToAnsi('CCO'),OemToAnsi('Adiantamento')} //"Loja"###"Pedido"###"Emissao"###"Origem"
					If !Empty(aF4For)
						cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8],aF4For[oListBox:nAT][9],aF4For[oListBox:nAT][10],aF4For[oListBox:nAT][11],aF4For[oListBox:nAT][12],aF4For[oListBox:nAT][13],aF4For[oListBox:nAT][14],aF4For[oListBox:nAT][15],aF4For[oListBox:nAT][16],aF4For[oListBox:nAT][17],aF4For[oListBox:nAT][18]"
					Else
						cLine := "{If(Empty(aF4For),oNO,oOK)," +Replicate("'',",17) +""
					EndIf

					//Agroindustria
					If FindFunction("OGXUtlOrig") .And. OGXUtlOrig() //Encontra a função
						If FindFunction("OGX195") //Encontra a função
							If ValType( aUsTitu := OGX195() ) == "A"
								nNumCampos := Len(aTitCampos)
								For nLoop := 1 To Len( aUsTitu )
									AAdd( aTitCampos, aUsTitu[ nLoop ] )
									cLine += ",aF4For[oListBox:nAT][" + AllTrim( Str( nLoop + nNumCampos ) ) + "]"
								Next nLoop
							EndIf
						EndIf
					EndIf

					If lMA103F4H .And. !Empty(aF4For)
						If ValType( aUsTitu := ExecBlock( "MA103F4H", .F., .F. ) ) == "A"
							nNumCampos := Len(aTitCampos)
							For nLoop := 1 To Len( aUsTitu )
								AAdd( aTitCampos, aUsTitu[ nLoop ] )
								cLine += ",aF4For[oListBox:nAT][" + AllTrim( Str( nLoop + nNumCampos ) ) + "]"
							Next nLoop
						EndIf
					EndIf

					cLine += " } "

					//Monta dinamicamente o bline do CodeBlock
					bLine := &( "{ || " + cLine + " }" )

					aSize := MsAdvSize(.F.)

					nLarg := aSize[5]//Int(aSize[5] * 0.80)
					nAltu := aSize[6]//Int(aSize[6] * 0.90)

					If lRetPed
						DEFINE MSDIALOG oDlg FROM 50,40  TO nAltu,nLarg TITLE OemToAnsi("Selecionar Pedido de Compra"+" - <F5> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra"

						//Calcula dimensões
						oSize := FwDefSize():New(.T.,,,oDlg)
						// oSize:AddObject( "CAB"		,  100, 20, .T., .T. ) // Totalmente dimensionavel
						// oSize:AddObject( "LISTBOX" 	,  100, 80, .T., .T. ) // Totalmente dimensionavel

						oSize:AddObject("CAB"     , 100, 12, .T., .F.)
						oSize:AddObject("LISTBOX" , 100, 88, .T., .T.)

						oSize:lProp 	:= .T. // Proporcional
						oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3

						oSize:Process() 	   // Dispara os calculos

						// @ oSize:GetDimension("CAB","LININI")+2  ,oSize:GetDimension("CAB","COLINI")   SAY OemToAnsi('Fornecedor') Of oDlg PIXEL SIZE 47 ,9 //"Fornecedor"

						// @ oSize:GetDimension("CAB","LININI")+18, oSize:GetDimension("CAB","COLINI")+32 BUTTON "Marcar/Desmarcar Todos" ACTION TrocaMarcacao(oListBox) SIZE 90,12 PIXEL OF oDlg
						@ oSize:GetDimension("CAB","LININI"), ;
							oSize:GetDimension("CAB","COLINI") ;
							BUTTON "Marcar/Desmarcar Todos" ;
							ACTION TrocaMarcacao(oListBox) ;
							SIZE 90,12 ;
							PIXEL ;
							OF oDlg

						If lForPCNF
							// @ oSize:GetDimension("CAB","LININI") ,oSize:GetDimension("CAB","COLINI")+32  MSGET oNomeFor VAR cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oDlg PIXEL SIZE 120,9
							// If(lLGPD,OfuscaLGPD(oNomeFor,"A2_NOME"),.F.)
							// Else
							// 	@ oSize:GetDimension("CAB","LININI") ,oSize:GetDimension("CAB","COLINI")+32  MSCOMBOBOX oComboBox VAR cComboFor ITEMS MTGetForRl(cA100For,cLoja) SIZE 215,9 OF oDlg PIXEL ON CHANGE A103LoadPd(lUsaFiscal,aGets,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV, lTxNeg, nTaxaMoeda, @oListBox, cComboFor, @aF4For, bLine, @aRecSC7)
							// EndIf

							oListBox := TWBrowse():New( oSize:GetDimension("LISTBOX","LININI"),oSize:GetDimension("LISTBOX","COLINI"),;
								oSize:GetDimension("LISTBOX","XSIZE")-22,oSize:GetDimension("LISTBOX","YSIZE")+1.4,;
								,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
							// oListBox:aColumns[2]:nWidth := 80   // Fornecedor
							// oListBox:aColumns[3]:nWidth := 40   // Loja
							// oListBox:aColumns[4]:nWidth := 80   // Pedido
							// oListBox:aColumns[5]:nWidth := 80   // Emissao
							// oListBox:aColumns[6]:nWidth := 40   // Origem
							// oListBox:aColumns[7]:nWidth := 80   // Placa
							// oListBox:aColumns[8]:nWidth := 80   // CCO
							// oListBox:aColumns[9]:nWidth := 40   // Adiantamento
							oListBox:SetArray(aF4For)
							If (!Empty(aF4For))
								oListBox:bLDblClick := { || A103SELPC(aTitCampos,aF4For,oListBox:nAt,lIntPms)}
							EndIf
							oListBox:bLine := bLine

							ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| (nOpc := 1,nF4For := oListBox:nAt,oDlg:End()) },{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)

							If nOpc == 1
								If (!Empty(aF4For)) .And. lForPCNF
									cCodLoj := SubStr(cComboFor, At(' | ',cComboFor)+3, Len(cComboFor))
									cCodLoj := SubStr(cCodLoj,1, At(' - ',cCodLoj)-1)
									cCbmFor := SubStr(cCodLoj, 1, At('/',cCodLoj)-1)
									cCbmLoj := SubStr(cCodLoj, At('/',cCodLoj)+1, Len(cCodLoj))
									cCbmFor := Padr(cCbmFor,nTamX3A2CD)
									cCbmLoj := Padr(cCbmLoj,nTamX3A2LJ)
									Processa({|| a103JgLimp(aF4For,nOpc,cCbmFor,cCbmLoj,@lRet103Vpc,@lMt103Vpc,@nSldPed,lUsaFiscal,aGets,( lConsMedic .And. lNfMedic ),aHeadSDE,@aColsSDE,aHeadSEV, aColsSEV, @lTxNeg, @nTaxaMoeda)})
								ElseIf (!Empty(aF4For))
									Processa({|| a103JgLimp(aF4For,nOpc,cA100For,cLoja,@lRet103Vpc,@lMt103Vpc,@nSldPed,lUsaFiscal,aGets,( lConsMedic .And. lNfMedic ),aHeadSDE,@aColsSDE,aHeadSEV, aColsSEV, @lTxNeg, @nTaxaMoeda)})
								Else
									Help(" ",1,"A103F4")
								EndIf
							EndIf
						EndIf
					Else
						Help(" ",1,"A103F4")
					EndIf
				Else
					FwalertWarning('Não existem pedidos aptos para importa...','Warning!!!')
				EndIf
			Else
				Help('   ',1,'A103CAB')
			EndIf
		Endif
	Endif


	//Restaura a Integrida dos dados de Entrada
	If lRetPed
		If Select(cAliasSC7) > 0
			(cAliasSC7)->(dbCloseArea())
		Endif

		DbSelectArea("SC7")

		// SetKey(VK_F4,bSavSetKey)
		SetKey(VK_F1,bSavKeyF1)
		// SetKey(VK_F6,bSavKeyF6)
		// SetKey(VK_F7,bSavKeyF7)
		// SetKey(VK_F8,bSavKeyF8)
		// SetKey(VK_F9,bSavKeyF9)
		// SetKey(VK_F10,bSavKeyF10)
		// SetKey(VK_F11,bSavKeyF11)
		RestArea(aAreaSA2)
		RestArea(aAreaSC7)
		RestArea(aArea)
	Else
		aRetPed := aClone(aF4For)
		oListBox:bLine := bLine
	EndIf
	If lDKD .And. lTabAuxD1 .And. FindFunction("gatilhadkd")
		gatilhadkd()
	Endif

Return(.T.)

Static Function TrocaMarcacao(oListBox)

	Local n
	Local lMarca := .F.

	// Se existir algum desmarcado, marca todos
	For n := 1 To Len(aF4For)
		If !aF4For[n][1]
			lMarca := .T.
			Exit
		EndIf
	Next

	For n := 1 To Len(aF4For)
		aF4For[n][1] := lMarca
	Next

	oListBox:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103JgLimp| Autor ³ Alex Lemes            ³ Data ³09/06/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa o carregamento do pedido de compras para a NFE    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os itens do pedido de compras            ³±±
±±³          ³ ExpN1 = Opcao valida                                       ³±±
±±³          ³ ExpC1 = Fornecedor                                         ³±±
±±³          ³ ExpC2 = loja fornecedor                                    ³±±
±±³          ³ ExpL1 = retorno do ponto de entrada                        ³±±
±±³          ³ ExpL2 = Uso do ponto de entrada                            ³±±
±±³          ³ ExpN2 = Saldo do pedido                                    ³±±
±±³          ³ ExpL3 = Usa funcao fiscal                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a103JgLimp(aF4For,nOpc,cA100For,cLoja,lRet103Vpc,lMt103Vpc,nSldPed,lUsaFiscal,aGets,lNfMedic,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV, lTxNeg, nTaxaMoeda)

	Local nx         := 0
	Local cItem		 := StrZero(1,Len(SD1->D1_ITEM))
	Local lZeraCols  := .T.
	Local aRateio    := {0,0,0}
	Local aMT103NPC  := {}
	Local aColsBkp   := Aclone(Acols)
	Local cPrdNCad   := ""
	Local nSavNF  	 := MaFisSave()
	Local n103TXPC	 := 0
	Local cSeekTXPC	 := ""
	Local nPosPc	 := GetPosSD1("D1_PEDIDO")
	Local nPosVlr	 := GetPosSD1("D1_VUNIT")
	Local aMT103FRE  := {}
	Local aCombo		:= {}
	Local nPsTpFrt		:= 0
	Local lvldFret 		:= SuperGetMV("MV_VALFRET",.F.,.F.)
	Local cFilSC7		:= xFilEnt(xFilial("SC7"),"SC7")
	Local lMT103NPC		:= ExistBlock("MT103NPC")
	Local lMT103TXPC	:= ExistBlock("MT103TXPC")
	Local lMT103FRE		:= ExistBlock("MT103FRE")
	Local cFilSB1		:= xFilial("SB1")
	Local cPCNum		:= ""
	Local aEstruSC7		:= SC7->( dbStruct() )
	Local nPosC7Qtd		:= aScan(aEstruSC7, {|x| AllTrim(x[1]) == "C7_QUANT"})
	Local lPeVldPc		:= .T.
	Local lPergBloq 	:= .F.
	Local aBkpImport 	:= {}
	Local aBkpDKDImport := {}
	Local lMT103PBLQ := .F.

	DEFAULT lUsaFiscal := .T.
	DEFAULT aGets      := {}
	DEFAULT lNfMedic   := .F.
	DEFAULT aHeadSDE   := {}
	DEFAULT aColsSDE   := {}

	If VALType("cQueryC7") <> "C"
		PRIVATE cQueryC7   := ""
	EndIf

	If ( nOpc == 1 )

		// PE para validação de carregamento do pedido de compras.
		If ExistBlock("M120vlpc")
			lPeVldPc := ExecBlock("M120vlpc",.F.,.F.,{@aF4For,lNfMedic,lUsaFiscal})
		EndIf
		If lPeVldPc

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))

			DbSelectArea("SC7")
			SC7->(DbSetOrder(14))

			For nx	:= 1 to Len(aF4For)
				If aF4For[nx][1]
					lPergBloq := .T.
					aBkpImport := aClone(aCols)
					aBkpDKDImport := aClone(aColsDKD)

					If lNfMedic
						cPCNum := aF4For[nx,7]
					Else
						cPCNum := aF4For[nx,5]
					Endif

					If Select("ITPC") > 0
						ITPC->(DbCloseArea())
					Endif

					cQry := StrTran(cQueryC7,"R_E_C_N_O_ RECSC7",	"R_E_C_N_O_ as RECNO, "+;
						"C7_NUM, "+;
						"C7_ITEM, "+;
						"C7_LOTPLS, "+;
						"C7_CODRDA, "+;
						"C7_PLOPELT, "+;
						"C7_PRODUTO, "+;
						"C7_TPFRETE, "+;
						"C7_MOEDA, "+;
						"C7_XTPDOC, "+;
						"C7_XDOCCO, "+;
						"C7_XPLACA, "+;
						"C7_QUANT - C7_QUJE - C7_QTDACLA AS SLDPC ")

					cQry := StrTran(cQry,"WHERE ",	"WHERE C7_NUM = '" + cPCNum + "' AND "+;
						"C7_FORNECE = '" + aF4For[nx,2] + "' AND "+;
						"C7_LOJA = '" + aF4For[nx,4] + "' AND "+;
						"C7_ITEM = '" + aF4For[nx,7] + "' AND "+;
						"C7_PRODUTO = '" + aF4For[nx,8] + "' AND ")

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"ITPC",.T.,.T.)

					If Len(aEstruSC7) > 0 .And. nPosC7Qtd > 0
						TcSetField( "ITPC", "SLDPC", aEstruSC7[nPosC7Qtd,2], aEstruSC7[nPosC7Qtd,3], aEstruSC7[nPosC7Qtd,4] )
					EndIf

					DbSelectArea("ITPC")

					While ITPC->(!EOF())
						SC7->(DbGoTo(ITPC->RECNO))
						If lZeraCols
							aCols		:= {}
							aBkpImport  := {}
							aColsDKD	:= {}
							aBkpDKDImport := {}
							lZeraCols	:= .F.
							MaFisClear()

							If lVldFret .And. !Empty(ITPC->C7_TPFRETE) .And. MaFisFound("NF") .AND. Type("aNFEDanfe") == "A" .AND. Empty(aNfeDanfe[14])
								aCombo			:= CarregaTipoFrete()
								aNfeDanfe[14] := ITPC->C7_TPFRETE
								nPsTpFrt 		:= ascan(aCombo ,{|x| Substr(x,1,1) == Substr(aNFEDanfe[14],1,1)})
								If nPsTpFrt > 0
									oTpFrete:NAT := nPsTpFrt
									oTpFrete:refresh()
								EndIf
							ElseIf lVldFret .And. !Empty(ITPC->C7_TPFRETE) .And. !MaFisFound("NF")
								cTpFrete := ITPC->C7_TPFRETE
							EndIf
						EndIf

						If SB1->(DbSeek(cFilSB1 + ITPC->C7_PRODUTO))
							If RegistroOk("SB1",.F.)
								If lMt103Vpc
									lRet103Vpc := .T.
									lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
								EndIf

								if fJaExiste(ITPC->C7_NUM,ITPC->C7_ITEM,ITPC->C7_PRODUTO)
									FwAlertWarning("O item do pedido de compras já foi importado para a NFE", "Atenção")
								Else
									If lRet103Vpc
										JGPC2Acol(ITPC->RECNO,,ITPC->SLDPC,cItem,,@aRateio,aHeadSDE,@aColsSDE)

										fSetCampo(aCols[val(cItem)],"D1_XDOCCO" ,ITPC->C7_XDOCCO)
										fSetCampo(aCols[val(cItem)],"D1_XPLACA" ,ITPC->C7_XPLACA)
										fSetCampo(aCols[val(cItem)],"D1_XTPDOC" ,ITPC->C7_XTPDOC)
										cItem := SomaIt(cItem)
									EndIf
								EndIf
							ElseIf ExistBlock("MT103PBLQ")
								lMT103PBLQ := ExecBlock("MT103PBLQ",.F.,.F.,{ITPC->C7_PRODUTO})
								If lMT103PBLQ
									JGPC2Acol( ITPC->RECNO, , ITPC->SLDPC, cItem, , @aRateio, aHeadSDE, @aColsSDE )
									cItem := SomaIt( cItem )
								Endif
							ElseIf lPergBloq .And. !MsgYesNo('O pedido de compra' + AllTrim(ITPC->C7_NUM) + 'tem produtos bloqueados', 'Deseja importar apenas os produtos não bloqueados desse pedido?') //O pedido de compra XXXX tem produtos bloqueados. Deseja importar apenas os produtos não bloqueados desse pedido?
								If Len(aBkpImport) > 0 .And. Empty(aBkpImport[1][2]) //Verifica se a primeira posição do aCols está vazia para não gravar linha em branco
									aCols := {}
								Else
									aCols := aBkpImport //Restaura aCols
									aColsDKD := aBkpDKDImport
								EndIf
								Exit
							Else
								lPergBloq := .F. //Pergunta apenas uma vez por pedido
							EndIf
						Else
							cPrdNCad += 'Pedido'+": "+ITPC->C7_NUM+"  "+Produto+": "+ITPC->C7_PRODUTO+CHR(10)
						EndIf

						If ITPC->C7_MOEDA != 1
							cSeekTXPC := cFilSC7+cPCNum
						EndIf

						ITPC->(dbSkip())
					EndDo

					If Select("ITPC") > 0
						ITPC->(DbCloseArea())
					Endif
				EndIf
			Next nX

			//Exibe Lista dos Produtos não Cadastrados na Filial de Entrega
			If Len(cPrdNCad)>0 .And. !l103Auto
				Aviso("A103JgLimp",'Produtos não cadastrado	s'+CHR(10)+'na filial de entrega'+CHR(10)+cPrdNCad,{"Ok"})
			EndIf

			//Restaura o Acols caso o mesmo estiver vazio
			If Len(Acols) == 0
				aCols:= aColsBKP
				MaFisRestore(nSavNF)
			Else
				//Ponto de entrada para manipular o array de multiplas naturezas por titulo no Pedido de Compras
				If lMT103NPC
					aMT103NPC := ExecBlock("MT103NPC",.F.,.F.,{aHeadSEV,aColsSEV})
					If (ValType(aMT103NPC) == "A")
						aColsSEV := aClone(aMT103NPC)
					EndIf
				EndIf

				//Ponto de entrada para alterar a moeda, taxa, e check box de taxa negociada de acordo com o Pedido de Compras
				If lMT103TXPC .And. !Empty(cSeekTXPC)
					If SC7->(DbSeek(cSeekTXPC))
						nPosItPc := aScan(aCols,{|x| AllTrim(x[nPosPc])==AllTrim(SC7->C7_NUM)})
						n103TXPC := ExecBlock("MT103TXPC",.F.,.F.)
						If ValType(n103TXPC) == "N"
							If n103TXPC > 0
								nTaxaMoeda := n103TXPC
							ElseIf nPosItPc > 0
								nTaxaMoeda := NoRound((aCols[nPosItPc][nPosVlr] / SC7->C7_PRECO),TamSx3("F1_TXMOEDA")[2])
							EndIf
							lTxNeg := .T.
							nMoedaCor := SC7->C7_MOEDA
						EndIf
					Endif
				EndIf

				//Impede que o item do PC seja deletado pela getdados da NFE na movimentacao das setas.
				If Type( "oGetDados" ) == "O"
					oGetDados:lNewLine:=.F.
					oGetDados:oBrowse:Refresh()
				EndIf

				//Ponto de entrada para manipular o array de Frete/Seguro/Despesa do Pedido de Compras
				If lMT103FRE
					aMT103FRE := ExecBlock("MT103FRE",.F.,.F.,aRateio)
					If (ValType(aMT103FRE) == "A")
						aRateio := aClone(aMT103FRE)
					EndIf
				EndIf

				//Rateio do valores de Frete/Seguro/Despesa do PC
				If lUsaFiscal
					Eval(bRefresh)
					lAtuDupPC := .T.
					Eval(bRefresh,6)
				Else
					aGets[SEGURO] := aRateio[1]
					aGets[VALDESP]:= aRateio[2]
					aGets[FRETE]  := aRateio[3]
				EndIf
			Endif
		Endif
	Endif

Return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³A103VisuJC³ Autor ³ Edson Maricate       ³ Data ³16.02.2000³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Chama a rotina de visualizacao dos Pedidos de Compras      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Dicionario de Dados - Campo:D1_TOTAL                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A103VisuJC(nRecSC7)

	Local aArea			:= GetArea()
	Local aAreaSC7		:= SC7->(GetArea())
	Local nSavNF		:= MaFisSave()
	Local cSavCadastro	:= cCadastro
	Local cFilBak		:= cFilAnt
	Local nBack       	:= n

	PRIVATE nTipoPed	:= 1
	PRIVATE cCadastro	:= OemToAnsi('Consulta ao Pedido de Compra') //"Consulta ao Pedido de Compra"
	PRIVATE l120Auto	:= .F.
	PRIVATE l123Auto	:= .F.
	PRIVATE aBackSC7	:= {}  //Sera utilizada na visualizacao do pedido - MATA120

	MaFisEnd()

	DbSelectArea("SC7")
	MsGoto(nRecSC7)

	nTipoPed  := SC7->C7_TIPO
	cCadastro := iif(nTipoPed==1 ,OemToAnsi('Consulta ao Pedido de Compra'),OemToAnsi('Consulta ao Pedido de Compra')) //"Consulta ao Pedido de Compra"
	cFilAnt   := IIf(!Empty(SC7->C7_FILIAL),SC7->C7_FILIAL,cFilAnt)

	If SC7->C7_TIPO <> 3
		A120Pedido(Alias(),RecNo(),2)
	Else
		nTipoPed := 3
		A123Pedido(Alias(),RecNo(),2)
	EndIf

	cFilant := cFilBak

	n := nBack
	cCadastro	:= cSavCadastro
	MaFisRestore(nSavNF)
	RestArea(aAreaSC7)
	RestArea(aArea)

Return .T.

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun??o    ³JGPC2Acol³ Autor ³ Edson Maricate        ³ Data ³27.01.2000 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Esta rotina atualiza o acols com base no item do pedido de   ³±±
	±±³          ³compra                                                       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpN1 : Numero do registro do SC7                            ³±±
	±±³          ³ExpN2 : Item da NF                                           ³±±
	±±³          ³ExpN3 : Saldo do Pedido                                      ³±±
	±±³          ³ExpC1 : Item a ser carregado no aCols ( D1_ITEM )            ³±±
	±±³          ³ExpL1 : Indica se os dados da Pre-Nota devem ser preservados ³±±
	±±³          ³ExpA1 : Valores das despesas acessorias do pedido de compras ³±±
	±±³          ³ExpA2 : Cabecalho do rateio                                  ³±±
	±±³          ³ExpA3 : Itens do rateio                                      ³±±
	±±³          ³ExpN4 : Preco unitário na Pré-Nota						   ³±±
	±±³          ³ExpL2 : Indica se nota foi importada pelo TOTVS Colaboracao  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpL1: Sempre .T.                                            ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri??o ³Esta rotina tem como objetivo atualizar a funcao fiscal com  ³±±
	±±³          ³base no item do pedido de compra.                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function JGPC2Acol(nRecSC7,nItem,nSalPed,cItem,lPreNota,aRateio,aHeadSDE,aColsSDE,nPrUPreNf,lTColab)

	Local aArea		   := GetArea()
	Local aAreaSC7	   := SC7->(GetArea())
	Local aAreaSF4	   := SF4->(GetArea())
	Local aAreaSB1	   := SB1->(GetArea())
	Local aAreaSC1     := SC1->(GetArea())
	Local aAreaSTJ
	Local aRefSC7      := MaFisSXRef("SC7")

	Local cNGMNTNO	   := SuperGetMV("MV_NGMNTNO",.F.,"2")
	Local cNGMNTES	   := SuperGetMV('MV_NGMNTES', .F., 'N' )
	Local cMVARRPEDC   := SuperGetMV("MV_ARRPEDC", .F., "")
	Local lMNTD1OP	   := FindFunction( 'MNTD1OP' )
	Local lMNTD1ORDEM  := FindFunction( 'MNTD1ORDEM' )

	Local lRateioPC    := SuperGetMv("MV_NFEDAPC")
	Local lAllPC       := .T.
	Local lAltImpPreNf := .F.
	Local lMaFisFound  := MaFisFound()
	Local lMT103IPC	   := ExistBlock( "MT103IPC",,.T. )
	Local lMT103RCC	   := ExistBlock( "MT103RCC",,.T. )
	Local lMT103IP2	   := ExistBlock( "MT103IP2",,.T. )
	Local lRateioDE	   := .F.
	Local lTOPDRFRM    := FindFunction("A120RDFRM") .And. A120RDFRM("A103")

	Local nQuantPed    := 0
	Local nX           := 0
	Local nCntFor      := 0
	Local nValUnit     := 0
	Local nValFre      := 0
	Local nValDesc     := 0
	Local nValDesp     := 0
	Local nValSeg      := 0
	Local nValTot      := 0
	Local nPosQtd      := GetPosSD1("D1_QUANT")
	Local nPosQtd2     := GetPosSD1("D1_QTSEGUM")
	Local nPosTes      := GetPosSD1("D1_TES")
	Local nPosVunit    := GetPosSD1("D1_VUNIT")
	Local nPValFret	   := GetPosSD1("D1_VALFRE")
	Local nPValDesc	   := GetPosSD1("D1_VALDESC")
	Local nPValDesp	   := GetPosSD1("D1_DESPESA")
	Local nPValSeg	   := GetPosSD1("D1_SEGURO")
	Local nPVOrdem 	   := GetPosSD1("D1_ORDEM")
	Local nPMSIPC	   := GetNewPar("MV_PMSIPC",2)
	Local aVencReal    := {}
	Local dVencReal    := Ctod("")
	Local lXmlxped	   := .F.
	Local lPropFret    := SuperGetMV("MV_FRT103E",.F.,.T.)//Proporcionalização de frete.
	Local nBkp		   := 0
	Local lM103lRat    := SuperGetMv("MV_M103LRA",.F.,.F.)

	Local lDKD		   := ChkFile("DKD") .and. !Empty(aHeadDKD) //Tabela Complementar SD1
	local lExistC7CF   := SC7->(FieldPos("C7_CF")) > 0
	Local lTrbGen      := IIf(FindFunction("ChkTrbGen"),ChkTrbGen("SD1", "D1_IDTRIB"),.F.) // Verificacao tributos genericos

	DEFAULT aHeadSDE   := {}
	DEFAULT aColsSDE   := {}

	DEFAULT lPreNota := .F.
	DEFAULT lTColab  := .F.
	DEFAULT aRateio  := {0,0,0}

	If lTColab
		lXmlxped := SuperGetMV("MV_XMLXPED",.F.,.F.) //.T. = Mantém dados provenientes da NF, .F. = Assume dados provenientes do pedido de compra
	Endif

//-- Verifica a existencia do item do acols
	If nItem == Nil .Or. nItem > Len(aCols)
		aadd(aCols,Array(Len(aHeader)+1))
		For nX := 1 to Len(aHeader)
			If IsHeadRec(aHeader[nX][2])
				aCols[Len(aCols)][nX] := 0
			ElseIf IsHeadAlias(aHeader[nX][2])
				aCols[Len(aCols)][nX] := "SD1"
			ElseIf Trim(aHeader[nX][2]) == "D1_ITEM"
				aCols[Len(aCols)][nX] 	:= IIF(cItem<>Nil,cItem,StrZero(1,Len(SD1->D1_ITEM)))
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2], (aHeader[nX][10] <> "V") )
			EndIf
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
		Next nX
		nItem := Len(aCols)
	EndIf

//Posiciona registros
	dbSelectArea("SC7")
	SC7->(MsGoto(nRecSC7))

	lAllPC := SC7->C7_QUANT == nSalPed .And. Empty(SC7->C7_REAJUST)

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))

	If !lXmlxped
		nQuantPed:= SC7->C7_QUANT
		nValFre  := SC7->C7_VALFRE
		nValDesc := SC7->C7_VLDESC
		nValDesp := SC7->C7_DESPESA
		nValSeg  := SC7->C7_SEGURO
		If !Empty(cMVARRPEDC) .AND. AllTrim(Upper(cMVARRPEDC)) == "NOROUND"
			nValUnit := NoRound(NfePcReaj(SC7->C7_REAJUST,lReajuste),TamSX3('D1_VUNIT')[2])
			nValTot := NoRound(nSalPed*nValUnit,TamSX3('D1_TOTAL')[2])
		Else
			nValUnit := Round(NfePcReaj(SC7->C7_REAJUST,lReajuste),TamSX3('D1_VUNIT')[2])
			nValTot := Round(nSalPed*nValUnit,TamSX3('D1_TOTAL')[2])
		EndIf
	Else
		nValUnit := aCols[nItem][nPosVunit]
		nSalPed  := aCols[nItem][nPosQtd]
		nValFre	 := aCols[nItem][nPValFret]
		nValDesc := aCols[nItem][nPValDesc]
		nValDesp := IIF((nPValDesp > 0),aCols[nItem][nPValDesp],0)
		nValSeg  := IIF((nPValSeg > 0),aCols[nItem][nPValSeg],0)
		If !Empty(cMVARRPEDC)
			If AllTrim(Upper(cMVARRPEDC)) == "ROUND"
				nValTot := Round(nSalPed*nValUnit, TamSX3('D1_TOTAL')[2])
			ElseIf AllTrim(Upper(cMVARRPEDC)) == "NOROUND"
				nValTot := NoRound(nSalPed*nValUnit,TamSX3('D1_TOTAL')[2])
			EndIf
		Else
			nValTot := Round(nSalPed*nValUnit,TamSX3('D1_TOTAL')[2])
		EndIf
	EndIf

//Carrega os impostos do pedido de compra para o Doc.Entrada
	If lMaFisFound
		//Obtem a condicao de pagamento do pedido de compra
		If (l103Class .and. Empty(cCondicao)) .Or. !l103Class
			cCondicao := Iif(l103Auto .And. !Empty(cCondicao), cCondicao, SC7->C7_COND)
			aVencReal := Condicao(1,cCondicao,,M->dDEmissao) // O valor (parametro 1) não interessa neste momento, mas a funcão Condição() não retorna nada se o primeiro paramentro for 0 (zero), por esse motivo tive que chumbar um valor (1).
			If Len(aVencReal) > 0
				dVencReal := aVencReal[1][1]
			Else
				dVencReal := dDataBase
			EndIf
		EndIf

		MaFisIniLoad(nItem)
		For nX := 1 To Len(aRefSc7)
			Do Case
			Case aRefSC7[nX][2] == "IT_QUANT"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nSalPed,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_PRCUNI"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nValUnit,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_VALMERC"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nValTot,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_DESCONTO"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],xMoeda(((nValDesc/nQuantPed)* nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_VALEMB"
				MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_VALEMB,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
			Case aRefSc7[nX][2] == "IT_SEGURO"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(((nValSeg/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[1] += xMoeda(((nValSeg/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_DESPESA"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(((nValDesp/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[2] += xMoeda(((nValDesp/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_FRETE"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(((nValFre/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[3] += xMoeda(((nValFre/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_TES"
				If !Empty(SC7->C7_TES)
					dbSelectArea("SF4")
					SF4->(dbSetOrder(1))
					SF4->(DbSeek(xFilial("SF4")+SC7->C7_TES))
					MaFisLoad("IT_CF",MaFisCFO(nItem,SF4->F4_CF),nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_BASEICM"
				nD1BaseIcm := SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_BASEICM) .Or. SD1->D1_BASEICM == nD1BaseIcm
					If nD1BaseIcm <> 0
						MaFisLoad(aRefSc7[nX][2],nD1BaseIcm,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_ALIQICM"
				nD1Picm := SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_PICM) .Or. SD1->D1_PICM == nD1Picm
					If nD1Picm <> 0
						MaFisLoad(aRefSc7[nX][2],nD1Picm,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_VALICM"
				nD1ValIcm	:= SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_VALICM) .Or. SD1->D1_VALICM == nD1ValIcm
					If nD1ValIcm <> 0
						MaFisLoad(aRefSc7[nX][2],nD1ValIcm,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_BASEIPI"
				nD1BaseIpi	:= SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_BASEIPI) .Or. SD1->D1_BASEIPI == nD1BaseIpi
					If nD1BaseIpi <> 0
						MaFisLoad(aRefSc7[nX][2],nD1BaseIpi,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_ALIQIPI"
				nD1AliqIpi := SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_IPI) .Or. SD1->D1_IPI == nD1AliqIpi
					If nD1AliqIpi <> 0
						MaFisLoad(aRefSc7[nX][2],nD1AliqIpi,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_VALIPI"
				nD1ValIpi	:= SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_VALIPI) .Or. SD1->D1_VALIPI == nD1ValIpi
					If nD1ValIpi <> 0
						MaFisLoad(aRefSc7[nX][2],nD1ValIpi,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			OtherWise
				MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
			EndCase
		Next nX
		MaFisEndLoad(nItem)
	Else
		//Obtem a condicao de pagamento do pedido de compra
		cCondicao := SC7->C7_COND
	EndIf

//Atualiza o acols com base no pedido de compras
	If !lPreNota
		if FwIsInCallStack("MATA103") .and. FwAliasInDic("DHR") .and. FindFunction("A103NatRen") .and. type("aHeadDHR") == "A" .and. type("aColsDHR") == "A"
			nBkp := n
		endif
		For nCntFor := 1 To Len(aHeader)
			Do Case
			Case Trim(aHeader[nCntFor,2]) == "D1_COD"
				aCols[nItem,nCntFor] := SC7->C7_PRODUTO
				//Atualiza a natureza de rendimento do item correspondente.
				if FwIsInCallStack("MATA103") .and. FwAliasInDic("DHR") .and. FindFunction("A103NatRen") .and. type("aHeadDHR") == "A" .and. type("aColsDHR") == "A"
					n := nItem
					A103NatRen(aHeadDHR,aColsDHR,.T.,.F.,,SC7->C7_PRODUTO)
				endif

				//Função responsável por retornar ncm definido na amarração prod x fornecedor
				Mt060CodFis(aCols[nItem,nCntFor],cA100For,cLoja)

			Case Trim(aHeader[nCntFor,2]) == "D1_REVISAO"
				aCols[nItem,nCntFor] := SC7->C7_REVISAO
			Case Trim(aHeader[nCntFor,2]) == "D1_TOTAL"
				aCols[nItem,nCntFor] := Round(nSalPed*Round(nValUnit,TamSX3('D1_VUNIT')[2]), TamSX3('D1_TOTAL')[2])
			Case Trim(aHeader[nCntFor,2]) == "D1_TES" .And. !Empty(SC7->C7_TES)
				aCols[nItem,nCntFor] := SC7->C7_TES
			Case Trim(aHeader[nCntFor,2]) == "D1_PEDIDO"
				aCols[nItem,nCntFor] := SC7->C7_NUM
			Case Trim(aHeader[nCntFor,2]) == "D1_QUANT" .Or. Trim(aHeader[nCntFor,2]) == "D1_SLDEXP"
				aCols[nItem,nCntFor] := nSalPed
			Case Trim(aHeader[nCntFor,2]) == "D1_VUNIT"
				aCols[nItem,nCntFor] := Round(nValUnit,TamSX3('D1_VUNIT')[2])
			Case Trim(aHeader[nCntFor,2]) == "D1_ITEMPC"
				aCols[nItem,nCntFor] := SC7->C7_ITEM
			Case Trim(aHeader[nCntFor,2]) == "D1_LOCAL"
				aCols[nItem,nCntFor] := SC7->C7_LOCAL
			Case Trim(aHeader[nCntFor,2]) == "D1_CC"
				aCols[nItem,nCntFor] := SC7->C7_CC
				If SC7->C7_RATEIO == "1" .And. lM103lRat
					aCols[nItem,nCntFor] := Space(Len(SC7->C7_CC)) // Limpa o conteúdo do campo devido a ativação do parametro MV_M103LRA.
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_OP"
				dbSelectArea("SC1")
				SC1->(dbSetOrder(1))
				SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
				If AllTrim(SC1->C1_ORIGEM) <> "MATA106" .And. (IIf(nPVOrdem > 0 ,Empty(aCols[nItem,nPVOrdem]) , .T.))
					aCols[nItem,nCntFor] := SC7->C7_OP
				EndIf

				// Integração com Sigamnt - carrega o campo OP
				If cNGMNTES == 'S' .And. Empty( aCols[nItem,nCntFor] ) .And. lMNTD1OP
					MNTD1OP( aHeader, aCols, nItem )
				EndIf

			Case Trim(aHeader[nCntFor,2]) == "D1_ITEMCTA"			// Item Contabil
				aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_ITEMCTA) .AND. SC7->C7_RATEIO !="1", SB1->B1_ITEMCC, SC7->C7_ITEMCTA )
				If SC7->C7_RATEIO == "1" .And. lM103lRat
					aCols[nItem,nCntFor] := Space(Len(SC7->C7_ITEMCTA)) // Limpa o conteúdo do campo devido a ativação do parametro MV_M103LRA.
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_CONTA"				// Conta Contabil
				aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_CONTA) .AND. SC7->C7_RATEIO !="1", SB1->B1_CONTA, SC7->C7_CONTA )
				If SC7->C7_RATEIO == "1" .And. lM103lRat
					aCols[nItem,nCntFor] := Space(Len(SC7->C7_CONTA)) // Limpa o conteúdo do campo devido a ativação do parametro MV_M103LRA.
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_CLVL"				// Classe de Valor
				aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_CLVL) .AND. SC7->C7_RATEIO !="1", SB1->B1_CLVL, SC7->C7_CLVL )
				If SC7->C7_RATEIO == "1" .And. lM103lRat
					aCols[nItem,nCntFor] := Space(Len(SC7->C7_CLVL)) // Limpa o conteúdo do campo devido a ativação do parametro MV_M103LRA.
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_UM"
				aCols[nItem,nCntFor] := SC7->C7_UM
			Case Trim(aHeader[nCntFor,2]) == "D1_SEGUM"
				aCols[nItem,nCntFor] := SC7->C7_SEGUM
			Case Trim(aHeader[nCntFor,2]) == "D1_QTSEGUM"
				aCols[nItem,nCntFor] := IIF(SB1->B1_CONV <> 0 .And. aCols[nItem][nPosQtd] <> 0, ConvUm(SB1->B1_COD,aCols[nItem][nPosQtd],aCols[nItem][nPosQtd2],2),SC7->C7_QTSEGUM)
			Case Trim(aHeader[nCntFor,2]) == "D1_DESC"
				aCols[nItem,nCntFor] := SC7->C7_DESC
			Case Trim(aHeader[nCntFor,2]) == "D1_VALDESC"
				aCols[nItem,nCntFor] := xMoeda(((SC7->C7_VLDESC/SC7->C7_QUANT)* nSalPed) , SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			Case Trim(aHeader[nCntFor,2]) == "D1_RATEIO"
				aCols[nItem,nCntFor] := SC7->C7_RATEIO
				If SC7->C7_RATEIO == "1"
					lRateioDE	:= .T.
				Endif
			Case Trim(aHeader[nCntFor,2]) == "D1_VALFRE"
				If nPValFret > 0
					aCols[nItem,nCntFor] := if(lPropFret,xMoeda(((SC7->C7_VALFRE/SC7->C7_QUANT)* nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA),xMoeda(SC7->C7_VALFRE,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA))
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_DESPESA"
				If nPValDesp > 0
					aCols[nItem,nCntFor] := xMoeda(((SC7->C7_DESPESA/SC7->C7_QUANT)* nSalPed) , SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				Endif
			Case Trim(aHeader[nCntFor,2]) == "D1_SEGURO"
				If nPValSeg > 0
					aCols[nItem,nCntFor] := xMoeda(((SC7->C7_SEGURO/SC7->C7_QUANT)* nSalPed) , SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				Endif
			Case Trim(aHeader[nCntFor,2]) == "D1_CODGRP"
				aCols[nItem,nCntFor] := SB1->B1_GRUPO
			Case Trim(aHeader[nCntFor,2]) == "D1_CODITE"
				aCols[nItem,nCntFor] := SB1->B1_CODITE
			Case Trim(aHeader[nCntFor,2]) == "D1_CLASFIS"
				dbSelectArea("SF4")
				SF4->(dbSetOrder(1))
				SF4->(DbSeek(xFilial("SF4")+SC7->C7_TES))
				aCols[nItem,nCntFor] := SubStr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
			Case Trim(aHeader[nCntFor,2]) == "D1_IPI"
				If !Empty(SC7->C7_IPI)
					aCols[nItem,nCntFor] := SC7->C7_IPI
				Else
					aCols[nItem,nCntFor] := SB1->B1_IPI
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_PICM"
				If !Empty(SC7->C7_PICM)
					aCols[nItem,nCntFor] := SC7->C7_PICM
				Else
					aCols[nItem,nCntFor] := SB1->B1_PICM
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_ITEMMED"
				aCols[nItem,nCntFor] := If( !Empty( SC7->C7_CONTRA ) .And. !Empty( SC7->C7_MEDICAO ), "1", "2" )
				//Nota de empenho
			Case Trim(aHeader[nCntFor,2]) == "D1_CODNE"
				aCols[nItem,nCntFor] := SC7->C7_CODNE
			Case Trim(aHeader[nCntFor,2]) == "D1_ITEMNE"
				aCols[nItem,nCntFor] := SC7->C7_ITEMNE
			Case Trim(aHeader[nCntFor,2]) == "D1_DTVALID"
				If Rastro(SC7->C7_PRODUTO)
					If !lTColab
						aCols[nItem,nCntFor] := dDatabase + SB1->B1_PRVALID
					EndIf
				Else
					aCols[nItem,nCntFor] := Ctod( '' )
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_ORDEM"

				// Integração com Sigamnt - Carrega campo D1_ORDEM
				If lMNTD1ORDEM
					MNTD1ORDEM( aHeader, aCols, nItem )
				Else
					aAreaSC1 := SC1->(GetArea())

					dbSelectArea("SC1")
					SC1->(dbSetOrder(1))
					SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
					If AllTrim(SC1->C1_ORIGEM) <> "MATA106"
						If cNGMNTNO == "1"
							aAreaSC1 := SC1->(GetArea())
							aAreaSTJ := STJ->(GetArea())

							If !Empty(SC7->C7_OP)
								dbSelectArea("STJ")
								STJ->(dbSetOrder(1))

								cOPStj := SubStr(SC7->C7_OP,1,At("OS",SC7->C7_OP)-1)

								If !Empty(cOPStj) .And. STJ->(dbSeek(xFilial("STJ")+ cOPStj))
									aCols[nItem,nCntFor] := cOPStj
								EndIf
							Else
								dbSelectArea("SC1")
								SC1->(dbSetOrder(1))
								If SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
									dbSelectArea("STJ")
									STJ->(dbSetOrder(1))

									cOPStj := if(!empty(SC1->C1_OS),SC1->C1_OS,SubStr(SC1->C1_OP,1,At("OS",SC1->C1_OP)-1))

									If !Empty(cOPStj) .And. STJ->(dbSeek(xFilial("STJ")+ cOPStj))
										aCols[nItem,nCntFor] := cOPStj
										NGSDCHKORDEM(cOPStj,nItem)
									Endif
								Endif
							EndIf

							RestArea(aAreaSTJ)
							RestArea(aAreaSC1)
						EndIf
					Endif
					RestArea(aAreaSC1)
				Endif
				//Integração RM TOP x Protheus (Retenção/Dedução/Faturamento Direto)
			Case Type("lTOPDRFRM") <> "U" .And. lTOPDRFRM .And. Trim(aHeader[nCntFor,2]) == "D1_RETENCA"
				aCols[nItem,nCntFor] := SC7->C7_RETENCA-SC7->C7_QUJERET

			Case Type("lTOPDRFRM") <> "U" .And. lTOPDRFRM .And. Trim(aHeader[nCntFor,2]) == "D1_DEDUCAO"
				aCols[nItem,nCntFor] := SC7->C7_DEDUCAO-SC7->C7_QUJEDED

			Case Type("lTOPDRFRM") <> "U" .And. lTOPDRFRM .And. Trim(aHeader[nCntFor,2]) == "D1_FATDIRE"
				aCols[nItem,nCntFor] := SC7->C7_FATDIRE-SC7->C7_QUJEFAT
			EndCase
		Next nCntFor
		if FwIsInCallStack("MATA103") .and. FwAliasInDic("DHR") .and. FindFunction("A103NatRen") .and. type("aHeadDHR") == "A" .and. type("aColsDHR") == "A"
			n := nBkp
		endif
		FillCTBEnt("SC7",nItem)

		//Atualização de campos referente o modulo de Armazenagem - SIGAWMS
		If IntWMS(SC7->C7_PRODUTO)
			WmsAvalSD1("8","SD1",aCols,nItem,aHeader)
		EndIf

		If !lMaFisFound
			aRateio[1] += xMoeda(SC7->C7_SEGURO ,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			aRateio[2] += xMoeda(SC7->C7_DESPESA,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			aRateio[3] += xMoeda(SC7->C7_VALFRE ,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
		EndIf

		//Complementa o rateio da nota fiscal de saida com o rateio do pedido de compras
		If lRateioDE
			If Empty(aHeadSDE)
				dbSelectArea("SX3")
				SX3->(dbSetOrder(1))
				SX3->(DbSeek("SDE"))
				While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "SDE"
					IF X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"DE_CUSTO" $ SX3->X3_CAMPO
						AADD(aHeadSDE,{TRIM(x3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
					EndIf
					SX3->(dbSkip())
				EndDo
				//Adiciona os campos de Alias e Recno ao aHeader para WalkThru
				ADHeadRec("SDE",aHeadSDE)
			Endif

			cItemRat := IIF(cItem<>Nil,cItem,StrZero(nItem,Len(SD1->D1_ITEM)))
			RatPed2NF(aHeadSDE,@aColsSDE,cItemRat,nRecSC7)
		Endif
		If lDKD
			//Atualiza aColsDKD
			A103DKDATU(0,.T.)
		Endif
		// 1 - utilização a associação automática com o PMS
		// 2 - não utiliza a associação automática com o PMS
		// default: não utilizar a associação automática
		If IntePMS() .And. nPMSIPC == 1
			PMS103IPC(nItem)
		EndIf

		//Efetua a chamada dos pontos de entrada
		If ExistTemplate( "MT103IPC",,.T. ) .AND. HasTemplate("MT103IPC")
			ExecTemplate( "MT103IPC", .F., .F.,{nItem})
		EndIf

		//Agroindustria
		If FindFunction("OGXUtlOrig") .And. OGXUtlOrig()  //Encontra a função
			If FindFunction("OGX205") //Encontra a função
				OGX205() // Executa a função
			EndIf
		EndIf

		If lMT103IPC
			ExecBlock( "MT103IPC", .F., .F.,{nItem})
		EndIf

		If lMT103RCC
			aColsSDE := ExecBlock( "MT103RCC", .F., .F.,{aHeadSDE,aColsSDE})
		EndIf

		If lDKD
			//Atualiza aColsDKD
			A103DKDATU(0,.T.)
		Endif
	EndIf

//Quando ha TES no pedido de compra, deve-se recalcular os
//impostos carregados para verificar se nao ha novos impostos
//que devem ser calculados!
	If lMaFisFound
		Do Case
		Case cA100For+cLoja <> SC7->C7_FORNECE+SC7->C7_LOJA
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_ALIQICM",0,nItem)
			MaFisAlt("IT_ALIQIPI",0,nItem)
			If Empty(SC7->C7_TES)
				MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),nItem)
			Else
				MaFisAlt("IT_TES",SC7->C7_TES,nItem)
			EndIf
		Case Empty(SC7->C7_TES) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_TE"))
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),nItem)
		Case Empty(SC7->C7_TES) .And. Empty(RetFldProd(SB1->B1_COD,"B1_TE")) .And. nPosTes > 0
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",IF( aCols[nItem,nPosTes] == Nil,CriaVar("D1_TES"),aCols[nItem,nPosTes] ),nItem,,,,,,dVencReal)
		Case !Empty(SC7->C7_TES)
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",SC7->C7_TES,nItem,,,,,,dVencReal)
			If lAllPC .And. !lAltImpPreNf
				// Quando for Relacionar o Pedido a Nf ou preço unitário da Pré-Nf for igual ao Pedido, entra na Rotina
				// Caso Preço Unitário da Pré-Nf for divergente do pedido, prevalece o preço da Pré-Nf mesmo que a quantidade do pedido seja igual.

				If nPrUPreNf == Nil .Or. (nPrUPreNf-SC7->C7_PRECO) == 0
					For nX := 1 To Len(aRefSc7)
						Do Case
						Case !("IT_BAS"$aRefSc7[nX][2] .Or. "IT_VAL"$aRefSc7[nX][2] .Or. "IT_ALIQ"$aRefSc7[nX][2])
							//Não fazer nada
						case !Empty(SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))))
							iF !(SUBSTR(aRefSc7[NX][2],4,3) $ 'BAS|VAL')
								MaFisAlt(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
							ELSE
								MaFisAlt(aRefSc7[nX][2],xMoeda(SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
							ENDif
						EndCase
					Next nX
				EndIf
			EndIf

			If lTColab
				ATriGenCol(nItem)
			EndIf
		EndCase

		//Tratamento do configurador de tributos a partir do CFOP
		if lExistC7CF .And. !Empty(SC7->C7_CF) .And. lTrbGen
			MaFisLoad("IT_CF","",nItem)
			MaFisAlt("IT_CF",SC7->C7_CF,nItem,,,,,,dVencReal)

			If lTColab
				ATriGenCol(nItem)
			EndIf
		endif

		//Ponto de entrada para tratamentos diversos após o recalculo de
		//impostos carregados a partir da TES correspondente
		If lMT103IP2
			ExecBlock( "MT103IP2", .F., .F.,{nItem})
		EndIf

		MaFisToCols(aHeader,aCols,Len(aCols),"MT100")
		aColsD1 := acols //Atualização necessária para que, o Array do Lançamento da Apuração de ICMS tenha o mesmos itens do acols da Nota Fiscal de Entrada.
	EndIf

	If cPaisLoc == "BRA" .And. Type("lIntermed") == "L" .And. lIntermed
		Eval(bRefresh,10)
	Endif

	If Type("bRefresh")=="B"
		Eval(bRefresh,6)
	EndIf

	RestArea(aAreaSB1)
	RestArea(aAreaSF4)
	RestArea(aAreaSC7)
	RestArea(aArea)
Return .T.


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun??o    ³NfePcReaj ³ Autor ³ Edson Maricate        ³ Data ³28.01.2000 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Esta rotina atualiza o valor unitario do pedido de compra com³±±
	±±³          ³base na cotacao da moeda                                     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpC1 : Formula de reajuste                                  ³±±
	±±³          ³ExpL2 : Indica se a formula de reajuste de ser aplicada      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpN1: valor unitario reajustado                             ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri??o ³Esta rotina tem como objetivo atualizar o valor unitario do  ³±±
	±±³          ³pedido de compra com base na taxa da moeda do dia            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Materiais                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function NfePcReaj(cReajuste,lReajuste)

	Local nPreco := 0
	Local dBase  := dDataBase

	dDataBase := dDEmissao
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o pedido de compra com base na cotacao da moeda     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPreco := xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,M->dDEmissao,9,SC7->C7_TXMOEDA)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aplica a formula de reajuste do pedido de compra             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SC7->C7_REAJUST)
		If !Empty(cReajuste) .And. lReajuste
			nPreco := Formula(cReajuste)
		EndIf
	EndIf
	dDataBase := dBase
Return( nPreco )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FillCTBEntºAutor  ³ Andre Anjos		 º Data ³ 02/08/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inicaliza campos das entidades contabeis de acordo com a   º±±
±±º          ³ origem.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA103                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FillCTBEnt(cOrigem,nItem)
	Local aCTBEnt := CTBEntArr()
	Local nX	  := 0

	For nX := 1 To Len(aCTBEnt)
		If GetPosSD1("D1_EC"+aCTBEnt[nX]+"CR") > 0 .And. (cOrigem)->(FieldPos(Substr(cOrigem,2)+"_EC"+aCTBEnt[nX]+"CR")) > 0
			aCols[nItem,GetPosSD1("D1_EC"+aCTBEnt[nX]+"CR")] := (cOrigem)->&(Substr(cOrigem,2)+"_EC"+aCTBEnt[nX]+"CR")
		EndIf
		If GetPosSD1("D1_EC"+aCTBEnt[nX]+"DB") > 0 .And. (cOrigem)->(FieldPos(Substr(cOrigem,2)+"_EC"+aCTBEnt[nX]+"DB")) > 0
			aCols[nItem,GetPosSD1("D1_EC"+aCTBEnt[nX]+"DB")] := (cOrigem)->&(Substr(cOrigem,2)+"_EC"+aCTBEnt[nX]+"DB")
		EndIf
	Next nX

Return

Static Function fSetCampo(aLinha,cCampo,xValor)

	Local nPos := fPosCampo(cCampo)

	If nPos > 0
		aLinha[nPos] := xValor
	EndIf

Return

Static Function fGetCampo(aLinha,cCampo)

	Local nPos := fPosCampo(cCampo)

	If nPos > 0
		Return aLinha[nPos]
	EndIf

Return Nil

Static Function fPosCampo(cCampo)

Return AScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(cCampo)})

Return


Static Function fJaExiste(cPedido,cItem,cProduto)

	cItem := StrZero(Val(cItem),4)


	if AScan(aCols, {|aLinha| AllTrim(aLinha[22]) == AllTrim(cPedido) .AND.AllTrim(aLinha[23]) == AllTrim(cItem) .And. AllTrim(aLinha[2]) == AllTrim(cProduto) }) > 0
		Return .T.
	EndIf


Return .F.
