#Include "Protheus.ch"
#Include "ParmType.ch"

#Define ID_CALC					1
#Define FORNECEDOR				2
#Define LOJA					3
#Define NOME					4
#Define PRODUTO					5
#Define DESCRICAO				6
#Define LOTE_ECONOMICO			7
#Define ESTOQUE					8
#Define ENTRADA					9
#Define CONSUMO					10
#Define SALDO					11
#Define NECESSIDADE				12
#Define DIAS_ESTOQUE			13

#Define PERIODO_IND				1
#Define PERIODO_ATU				2
#Define PERIODO_FORM			3
#Define PERIODO_PROX			4

#Define TAM_COL_ID_CALC			20
#Define TAM_COL_FORNECEDOR		35
#Define TAM_COL_LOJA			15
#Define TAM_COL_NOME			100
#Define TAM_COL_PRODUTO			50
#Define TAM_COL_DESCRICAO		100
#Define TAM_COL_LOTE_ECONOMICO	30
#Define TAM_COL_ESTOQUE			30
#Define TAM_COL_ENTRADA			30
#Define TAM_COL_CONSUMO			35
#Define TAM_COL_SALDO			30
#Define TAM_COL_NECESSIDADE		30
#Define TAM_COL_DIAS_ESTOQUE	40
#Define TAM_COL_PC				100

#Define TIT_COL_ID_CALC			"ID"
#Define TIT_COL_FORNECEDOR		"Fornecedor"
#Define TIT_COL_LOJA			"Loja"
#Define TIT_COL_NOME			"Nome"
#Define TIT_COL_PRODUTO			"Produto"
#Define TIT_COL_DESCRICAO		"Descrição"
#Define TIT_COL_LOTE_ECONOMICO	"Lote Ec."
#Define TIT_COL_ESTOQUE			"Est. "
#Define TIT_COL_ENTRADA			"Ent. "
#Define TIT_COL_CONSUMO			"Cons. "
#Define TIT_COL_SALDO			"Sld. "
#Define TIT_COL_NECESSIDADE		"Nec. "
#Define TIT_COL_DIAS_ESTOQUE	"Dias Est. "
#Define TIT_COL_PC				"Num. PC"
	
#Define QTDCOL					6

#Define PEDIDO_NACIONAL			"Nacional"
#Define PEDIDO_INTERNACIONAL	"Internacional"
	
/*/{Protheus.doc} HLAPCP01

Rotina responsável pela análise da necessidade de compras [MRP Honda Lock]

@type 		function
@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		01/03/2019
@version 	Protheus 12 - PCP

/*/

User Function HLAPCP01()
	
	Local lContinue	:= .F.
	Local aSays 	:= {}
	Local aButtons	:= {}
	Local cPerg 	:= "HLAPCP01"
	
	Private aProdPA		:= {}	
	Private aCalcNec	:= {} 
	Private aPeriodos	:= {}
	Private aHeadCol	:= {}
	Private aColSize	:= {}
	Private aColBMP		:= {}
	Private cLine		:= ""
	Private cDoc		:= ""
	Private cFornec		:= "" 
	Private cLoja		:= ""
	Private cLocal		:= ""
	Private dDtBase		:= CToD("")
	Private nPeriodos	:= 0
	Private oBrowse		:= Nil
	Private lCalc 		:= .F.

	Pergunte(cPerg, .F.)
	
	Aadd(aSays, "Rotina responsável pela análise da necessidade de compras (MRP)")
	
	Aadd(aButtons, {5, 	.T., {|| Pergunte(cPerg, .T.)}})
	Aadd(aButtons, {1, 	.T., {|o| lContinue := .T., FechaBatch()}})
	Aadd(aButtons, {2, 	.T., {|o| lContinue := .F., FechaBatch()}})
	
	FormBatch("Análise de Necessidade - MRP", aSays, aButtons)
	
	If lContinue
		
		cDoc 		:= MV_PAR01
		cFornec 	:= MV_PAR02 
		cLoja		:= MV_PAR03
		cLocal 		:= MV_PAR04 
		dDtBase		:= MV_PAR05
		nPeriodos	:= MV_PAR06
		
		CalcPeriod()
		
		Processa({|| CarregaDados()}, "Aguarde", "Carregando necessidade", .T.)
		
		Necessidade()
		
	Endif
	
Return Nil

Static Function CarregaDados()
	
	Local lCabec	:= .T.
	Local aItem		:= {}
	Local aPedCom	:= {}
	Local cQuery 	:= ""
	Local cFilCalc	:= ""
	Local cProduto	:= ""
	Local cNumPC	:= ""
	Local cPeriodo	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nQtdReg	:= 0
	Local nPeriodo	:= 0
	Local nPerCalc	:= 0
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2B.Z2B_FILIAL, Z2B.Z2B_CODIGO, Z2B.Z2B_ESTOQU, Z2B.Z2B_ENTRAD, Z2B.Z2B_CONSUM, "+ CRLF
	cQuery += "		Z2B.Z2B_SALDO, Z2B.Z2B_NECESS, Z2B.Z2B_DIASES, Z2B.Z2B_NUMPC, Z2B.Z2B_PERIOD, "+ CRLF
	cQuery += "		SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NREDUZ, "+ CRLF
	cQuery += "		SB1.B1_COD, SB1.B1_DESC, SB1.B1_LE, "+ CRLF
	cQuery += "		( "+ CRLF
	cQuery += "			SELECT TOP 1 "+ CRLF
	cQuery += "				COUNT(*) "+ CRLF
	cQuery += "			FROM "+ RetSqlTab("Z2B") +" "+ CRLF
	cQuery += "			WHERE "+ CRLF
	cQuery += "				"+ RetSqlDel("Z2B") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("Z2B") +" "+ CRLF
	cQuery += "				AND Z2B.Z2B_STATUS = 'A' "+ CRLF
	cQuery += "			GROUP BY "+ CRLF
	cQuery += "				Z2B.Z2B_FILIAL, Z2B.Z2B_CODIGO, Z2B.Z2B_FORNEC, Z2B.Z2B_LOJA, Z2B.Z2B_PRODUT "+ CRLF
	cQuery += "		) AS PERIODO "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2B") +" "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SA2") +" "+ CRLF
	cQuery += "			ON 	"+ RetSqlDel("SA2") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SA2") +" "+ CRLF
	cQuery += "				AND SA2.A2_COD = Z2B.Z2B_FORNEC "+ CRLF
	cQuery += "				AND SA2.A2_LOJA = Z2B.Z2B_LOJA "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SB1") +" "+ CRLF
	cQuery += "			ON 	"+ RetSqlDel("SB1") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB1") +" "+ CRLF
	cQuery += "				AND SB1.B1_COD = Z2B.Z2B_PRODUT "+ CRLF  
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2B") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2B") +" "+ CRLF
	cQuery += "		AND Z2B.Z2B_STATUS = 'A' "+ CRLF
	cQuery += "		AND Z2B.Z2B_FORNEC = '"+ cFornec +"' "+ CRLF
	cQuery += "		AND Z2B.Z2B_LOJA = '"+ cLoja +"' "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		Z2B.Z2B_PRODUT, Z2B.Z2B_PERIOD "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\CarregaDados.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	Count To nQtdReg
	
	ProcRegua(nQtdReg)
	
	(cAliasQry)->(DbGoTop())

	//Colunas browser
	AdicCol("", 0, "", .F.)
	AdicCol(TIT_COL_ID_CALC, 		TAM_COL_ID_CALC, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(ID_CALC) +"]", 		.F.)
	AdicCol(TIT_COL_FORNECEDOR, 	TAM_COL_FORNECEDOR, 	"aCalcNec[oBrowse:nAt, "+ cValToChar(FORNECEDOR) +"]", 		.F.)
	AdicCol(TIT_COL_LOJA, 			TAM_COL_LOJA, 			"aCalcNec[oBrowse:nAt, "+ cValToChar(LOJA) +"]", 			.F.)
	AdicCol(TIT_COL_NOME, 			TAM_COL_NOME, 			"aCalcNec[oBrowse:nAt, "+ cValToChar(NOME) +"]", 			.F.)
	AdicCol(TIT_COL_PRODUTO, 		TAM_COL_PRODUTO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(PRODUTO) +"]", 		.F.)
	AdicCol(TIT_COL_DESCRICAO, 		TAM_COL_DESCRICAO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(DESCRICAO) +"]", 		.F.)
	AdicCol(TIT_COL_LOTE_ECONOMICO, TAM_COL_LOTE_ECONOMICO, "aCalcNec[oBrowse:nAt, "+ cValToChar(LOTE_ECONOMICO) +"]",	.F.)
				
	If !(cAliasQry)->(Eof())
		
		While !(cAliasQry)->(Eof())
			
			IncProc()
					
			aItem 	 := {}
			aPedCom	 := {}
			cNumPC	 := ""
			cFilCalc := (cAliasQry)->Z2B_FILIAL
			cProduto := (cAliasQry)->B1_COD
			
			aAdd(aItem, (cAliasQry)->Z2B_CODIGO)
			aAdd(aItem, (cAliasQry)->A2_COD)
			aAdd(aItem, (cAliasQry)->A2_LOJA)
			aAdd(aItem, AllTrim((cAliasQry)->A2_NREDUZ))
			aAdd(aItem, AllTrim((cAliasQry)->B1_COD))
			aAdd(aItem, AllTrim((cAliasQry)->B1_DESC))
			aAdd(aItem, (cAliasQry)->B1_LE)
			
			While !(cAliasQry)->(Eof()) .And. (cAliasQry)->Z2B_FILIAL == cFilCalc .And. (cAliasQry)->B1_COD == cProduto
				
				If lCabec
				
					cPeriodo := Right((cAliasQry)->Z2B_PERIOD, 2) +"/"+ SubStr((cAliasQry)->Z2B_PERIOD, 3, 2)
					nPerCalc := nPeriodo * QTDCOL
				
					AdicCol(TIT_COL_ESTOQUE + cPeriodo, 	 TAM_COL_ESTOQUE, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(ESTOQUE + nPerCalc) +"]",		.F.)
					AdicCol(TIT_COL_ENTRADA + cPeriodo, 	 TAM_COL_ENTRADA, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(ENTRADA + nPerCalc) +"]",		.F.)
					AdicCol(TIT_COL_CONSUMO + cPeriodo, 	 TAM_COL_CONSUMO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(CONSUMO + nPerCalc) +"]",		.F.)
					AdicCol(TIT_COL_SALDO + cPeriodo, 		 TAM_COL_SALDO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(SALDO + nPerCalc) +"]",		.F.)
					AdicCol(TIT_COL_NECESSIDADE + cPeriodo,  TAM_COL_NECESSIDADE, 	"aCalcNec[oBrowse:nAt, "+ cValToChar(NECESSIDADE + nPerCalc) +"]",	.F.)
					AdicCol(TIT_COL_DIAS_ESTOQUE + cPeriodo, TAM_COL_DIAS_ESTOQUE, 	"aCalcNec[oBrowse:nAt, "+ cValToChar(DIAS_ESTOQUE + nPerCalc) +"]",	.F.)
					
					nPeriodo++
					
				EndIf
								
				aAdd(aItem, (cAliasQry)->Z2B_ESTOQU)
				aAdd(aItem, (cAliasQry)->Z2B_ENTRAD)
				aAdd(aItem, (cAliasQry)->Z2B_CONSUM)
				aAdd(aItem, (cAliasQry)->Z2B_SALDO)
				aAdd(aItem, (cAliasQry)->Z2B_NECESS)
				aAdd(aItem, (cAliasQry)->Z2B_DIASES)
				
				If aScan(aPedCom, {|x| AllTrim(x) == AllTrim((cAliasQry)->Z2B_NUMPC)}) == 0
					aAdd(aPedCom, AllTrim((cAliasQry)->Z2B_NUMPC))
				EndIf
				
				(cAliasQry)->(DbSkip())
				
			EndDo

			For nPeriodo := 1 To Len(aPedCom)				
				
				If !Empty(cNumPC)
					cNumPC += ","
				EndIf 
				
				cNumPC += aPedCom[nPeriodo]
				
			Next nPeriodo
			
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, cNumPC)
		
			aAdd(aCalcNec, aItem)
			
			lCabec := .F.
			
		EndDo
	
	Else
		
		aAdd(aItem, "")
		aAdd(aItem, "")
		aAdd(aItem, "")
		aAdd(aItem, "")
		aAdd(aItem, "")
		aAdd(aItem, "")
		aAdd(aItem, "")
		
		For nPeriodo := 1 To Len(aPeriodos) - 1
		
			cPeriodo := aPeriodos[nPeriodo][PERIODO_FORM]
			nPerCalc := aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL
			
			AdicCol(TIT_COL_ESTOQUE + cPeriodo, 	 TAM_COL_ESTOQUE, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(ESTOQUE + nPerCalc) +"]",		.F.)
			AdicCol(TIT_COL_ENTRADA + cPeriodo, 	 TAM_COL_ENTRADA, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(ENTRADA + nPerCalc) +"]",		.F.)
			AdicCol(TIT_COL_CONSUMO + cPeriodo, 	 TAM_COL_CONSUMO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(CONSUMO + nPerCalc) +"]",		.F.)
			AdicCol(TIT_COL_SALDO + cPeriodo, 		 TAM_COL_SALDO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(SALDO + nPerCalc) +"]",		.F.)
			AdicCol(TIT_COL_NECESSIDADE + cPeriodo,  TAM_COL_NECESSIDADE, 	"aCalcNec[oBrowse:nAt, "+ cValToChar(NECESSIDADE + nPerCalc) +"]",	.F.)
			AdicCol(TIT_COL_DIAS_ESTOQUE + cPeriodo, TAM_COL_DIAS_ESTOQUE, 	"aCalcNec[oBrowse:nAt, "+ cValToChar(DIAS_ESTOQUE + nPerCalc) +"]",	.F.)
			
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			aAdd(aItem, 0)
			
		Next nPeriodo
		
		aAdd(aItem, "")
				
		aAdd(aCalcNec, aItem)
		
	EndIf
	
	AdicCol(TIT_COL_PC, TAM_COL_PC, "aCalcNec[oBrowse:nAt, "+ cValToChar(Len(aCalcNec[1])) +"]", .T.)
	
	(cAliasQry)->(DbCloseArea())
		
Return Nil

Static Function Necessidade()
	
	Local bCalc		:= {|| Processa({|| CalcNec()}, "Aguarde", "Calculando necessidade", .T.)}
	Local bFechar	:= {|| oDlg:End()}
	Local bSalvar	:= {|| Processa({|| SalvarCalc()}, "Aguarde", "Salvando calculo", .T.)}
	Local bReport	:= {|| Report()}
	Local bForecast	:= {|| Forecast()}
	Local bGerarPC	:= {|| Processa({|| GeneratePO()}, "Aguarde", "Gerando pedido de compras", .T.), oBrowse:Refresh()}
	Local bDblClick	:= {|| EditCell(oBrowse)}
	Local bZerarNec	:= {|| ZerarNec(oBrowse)}
	Local bConsumo	:= {|| Processa({|| ConsCon(oBrowse)}, "Aguarde", "Consultando consumo", .T.)}
	Local nWndTop	:= 0
	Local nWndLeft	:= 0
	Local nAdjust	:= 0
	Local oDlg 		:= Nil
	Local oPanel	:= Nil
	
	SetKey(VK_F10, bZerarNec)
	SetKey(VK_F11, bConsumo)
					
	oMainWnd:ReadClientCoors()
	
	nWndTop 	:= 0
	nWndLeft	:= 0
	nAdjust 	:= 30
	
	DEFINE MSDIALOG oDlg TITLE "Necessidade de Compras" FROM nWndTop, nWndLeft TO oMainWnd:nBottom-nAdjust, oMainWnd:nRight-10 OF oMainWnd PIXEL
		
		oDlg:lMaximized := .T.
		
		oPanel := TPanel():New(00, 00, "", oDlg,,,,,, 05, 05)
		oPanel:Align := CONTROL_ALIGN_TOP
		
		oPanel:= TPanel():New(00, 00, "", oDlg,,,,,, 05, 05)
		
		oPanel:Align := CONTROL_ALIGN_LEFT
		
		oBrowse := TCBrowse():New(05, 05, 200, 300,, aHeadCol, {20, 50, 50, 50}, oDlg,,,,,{|| },,,,,,,.F.,,.T.,,.F.,,,,,,,,,,, 1)
		
		oBrowse:SetArray(aCalcNec)
		
		oBrowse:Align 		:= CONTROL_ALIGN_ALLCLIENT
		oBrowse:aColSizes 	:= aColSize
		oBrowse:bLine 		:= &cLine
		oBrowse:bLDblClick 	:= bDblClick
		
		oPanel := TPanel():New(00, 00, "", oDlg,,,,,, 40, 40)
		
		oPanel:Align := CONTROL_ALIGN_RIGHT

		TButton():New(000, 005, "Calcular", 	oPanel, bCalc,		30, 12,,, .F., .T., .F.,, .F.,,, .F.)
		TButton():New(015, 005, "Zerar", 		oPanel, bZerarNec,	30, 12,,, .F., .T., .F.,, .F.,,, .F.)
		TButton():New(030, 005, "Consumo", 		oPanel, bConsumo,	30, 12,,, .F., .T., .F.,, .F.,,, .F.)
		TButton():New(045, 005, "Gerar PC",		oPanel, bGerarPC, 	30, 12,,, .F., .T., .F.,, .F.,,, .F.) 
		TButton():New(060, 005, "Salvar",		oPanel, bSalvar, 	30, 12,,, .F., .T., .F.,, .F.,,, .F.)
		TButton():New(075, 005, "Relatório", 	oPanel, bReport, 	30, 12,,, .F., .T., .F.,, .F.,,, .F.) 
		TButton():New(090, 005, "Forecast",		oPanel, bForecast, 	30, 12,,, .F., .T., .F.,, .F.,,, .F.) 
		TButton():New(105, 005, "Fechar", 		oPanel, bFechar, 	30, 12,,, .F., .T., .F.,, .F.,,, .F.) 
		
	ACTIVATE DIALOG oDlg ON INIT (oBrowse:Refresh())
	
	SetKey(VK_F10, {||})
	SetKey(VK_F11, {||})
	
Return Nil

Static Function Report()
	
	If Len(aCalcNec) > 0 .And. ExistBlock("HLRPCP02")
		U_HLRPCP02(aCalcNec[1][ID_CALC])
	Else
		MsgAlert("Relatório não disponível", "Atenção")
	EndIf
	
Return Nil 

Static Function GeneratePO()
	
	Local aCabec	 	:= {}
	Local aLinha	 	:= {}
	Local aItens	 	:= {}
	Local aPerBase	 	:= {}
	Local aDtEnt	 	:= {}
	Local aTotPed		:= {}
	Local lOK		 	:= .T.
	Local cCondPagto	:= CondPagto()
	Local nPeriodo 	 	:= 0
	Local nPerBase	 	:= 0
	Local nItem		 	:= 0
	Local nProd		 	:= 0
	Local nPosNec	 	:= 0
	Local nOpc		 	:= 3
	Local nQuebra	 	:= 0
	Local nQtdPed	 	:= 0
	Local nFator	 	:= 0
	Local nMoeda		:= 1

	Private lMsErroAuto := .F.
	
	ProcRegua(0)
	
	If !Empty(cCondPagto)
	
		Begin Transaction 
			
			If ParamGerPed(@aPerBase, @nQuebra, @nMoeda)
			
				For nPerBase = 1 To Len(aPerBase)
	
					For nPeriodo := 1 To Len(aPeriodos) - 1
						
						If aPerBase[nPerBase] == aPeriodos[nPeriodo][PERIODO_ATU]
							
							If DtEnt(aPeriodos[nPeriodo][PERIODO_ATU], nQuebra, @aDtEnt)
							
								aTotPed := Array(Len(aCalcNec))
								
								For nQtdPed := 1 To nQuebra
								
									aCabec 	:= {}
									aItens 	:= {}
		
									nFator  := (100 / nQuebra) / 100			
									nPosNec	:= (aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL) + NECESSIDADE
									dDtEnt	:= If(Len(aDtEnt) == nQuebra, aDtEnt[nQtdPed], StoD(aPeriodos[nPeriodo][PERIODO_ATU] + "01"))
									
									For nItem := 1 To Len(aCalcNec)
										
										If nQtdPed == nQuebra
											
											nQuant := aCalcNec[nItem][nPosNec] //- aTotPed[nItem]
											
											If nQuebra != 1
												nQuant -= aTotPed[nItem]
											EndIf
											
										Else
											nQuant := CalcQtd(aCalcNec[nItem][nPosNec] * nFator, aCalcNec[nItem][LOTE_ECONOMICO]) //Ceiling(aCalcNec[nItem][nPosNec] * nFator)
										EndIf
										
										If nQtdPed == 1
											aTotPed[nItem] := nQuant
										Else
											aTotPed[nItem] += nQuant
										EndIf
										
										If nQuant > 0
											
											aLinha := {}
											nPreco := PrcProd(aCalcNec[nItem][PRODUTO]) 	
											
											aAdd(aLinha, {"C7_PRODUTO",	aCalcNec[nItem][PRODUTO],						Nil})
											aAdd(aLinha, {"C7_QUANT",	nQuant,											Nil})
											aAdd(aLinha, {"C7_PRECO",	nPreco,											Nil})
											aAdd(aLinha, {"C7_TOTAL",	nQuant * nPreco,								Nil})
											aAdd(aLinha, {"C7_DATPRF",	dDtEnt,											Nil})
											aAdd(aLinha, {"C7_ZZDTENT",	StoD(aPeriodos[nPeriodo][PERIODO_ATU] + "01"),	Nil})
											aAdd(aLinha, {"C7_ZZIDCAL",	aCalcNec[nItem][ID_CALC],						Nil})
											aAdd(aLinha, {"C7_XRECEBI",	"S",											Nil})
											aAdd(aLinha, {"C7_FABRICA",	cFornec,										Nil})
											aAdd(aLinha, {"C7_LOJFABR",	cLoja,											Nil})
											
											aAdd(aItens, aLinha)
											
										EndIf
										
									Next nItem
							
									If Len(aItens) > 0
											
										aAdd(aCabec, {"C7_EMISSAO", dDataBase})
										aAdd(aCabec, {"C7_FORNECE", cFornec})
										aAdd(aCabec, {"C7_LOJA",	cLoja})
										aAdd(aCabec, {"C7_COND",	cCondPagto})
										aAdd(aCabec, {"C7_FILENT",	cFilAnt})
										aAdd(aCabec, {"C7_MOEDA",	nMoeda})

										MsExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, FWVetByDic(aCabec, "SC7"), FWVetByDic(aItens, "SC7", .T.), nOpc)
									
										If lMsErroAuto
											
											lOK := .F.
											
											MostraErro()
												
											DisarmTransaction()
												
											Break
										
										Else
												
											//Atualiza Z2B com PC e quantidade
											For nItem := 1 To Len(aItens)
												
												cQuery := "UPDATE "+ RetSqlName("Z2B") +" "+ CRLF
												cQuery += "SET "+ CRLF
												cQuery += "		Z2B_NUMPC = '"+ SC7->C7_NUM +"', "+ CRLF
												cQuery += "		Z2B_QTDPC = "+ cValToChar(aItens[nItem][2][2]) +" "+ CRLF
												cQuery += "WHERE "+ CRLF
												cQuery += "		D_E_L_E_T_ = ' ' "+ CRLF
												cQuery += "		AND Z2B_FILIAL = '"+ FWxFilial("Z2B") +"' "+ CRLF
												cQuery += "		AND Z2B_CODIGO = '"+ aCalcNec[1][ID_CALC] +"' "+ CRLF
												cQuery += "		AND Z2B_PRODUT = '"+ aItens[nItem][1][2] +"' "+ CRLF
												cQuery += "		AND Z2B_PERIOD = '"+ aPeriodos[nPeriodo][PERIODO_ATU] +"' "
												
												MemoWrite("\SQL\UPDATE_PC.sql", cQuery)
												
												If TcSqlExec(cQuery) != 0
													UserException(TCSQLError())
												Else
													
													For nProd := 1 To Len(aCalcNec)
														
														If AllTrim(aItens[nItem][1][2]) == AllTrim(aCalcNec[nProd][PRODUTO])
															
															If !Empty(aCalcNec[nProd][Len(aCalcNec[nProd])])
																aCalcNec[nProd][Len(aCalcNec[nProd])] += ", "	
															EndIf
															
															aCalcNec[nProd][Len(aCalcNec[nProd])] += SC7->C7_NUM
															
														EndIf
														
													Next nProd
													
												Endif
							
											Next Item
												
										EndIf
											
									EndIf
								
								Next nQtdPed
							
							EndIf
							
						EndIf
						
					Next nPeriodo
					
				Next nPeriodo
			
			EndIf
								
		End Transaction
	
	Else
	
		lOK := .F.
		
		MsgAlert("Fornecedor sem condição de pagamento", "Atenção")
		
	EndIf 
	
	If !lOK
		
		//Limpa informações do grid
		For nItem := 1 To Len(aCalcNec)
			aCalcNec[nProd][Len(aCalcNec[nProd])] := ""
		Next nItem
			
		//Limpa informações da tabela
		cQuery := "UPDATE "+ RetSqlName("Z2B") +" "+ CRLF
		cQuery += "SET "+ CRLF
		cQuery += "		Z2B_NUMPC = '', "+ CRLF
		cQuery += "		Z2B_QTDPC = 0 "+ CRLF
		cQuery += "WHERE "+ CRLF
		cQuery += "		D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += "		AND Z2B_FILIAL = '"+ FWxFilial("Z2B") +"' "+ CRLF
		cQuery += "		AND Z2B_CODIGO = '"+ aCalcNec[1][ID_CALC] +"' "+ CRLF
		
		MemoWrite("\SQL\UPDATE_PC_ZERA.sql", cQuery)
		
		If TcSqlExec(cQuery) != 0
			UserException(TCSQLError())
		EndIf
				
	EndIf
	
Return Nil

Static Function CalcNec()
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local cId		:= ""
	Local nPeriodo	:= 0
	
	aProdPA	 := {}
	aCalcNec := {}
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SHC.HC_FILIAL, SHC.HC_PRODUTO "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SHC") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SHC") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SHC") +" "+ CRLF
	cQuery += "		AND SHC.HC_DOC = '"+ cDoc +"' "+ CRLF
	cQuery += "		AND SUBSTRING(SHC.HC_DATA, 1, 6) BETWEEN '"+ aPeriodos[1][PERIODO_ATU] +"' AND '"+ aPeriodos[Len(aPeriodos)][PERIODO_ATU] +"' "+ CRLF
	//cQuery += "		AND HC_PRODUTO IN ('T00DMATL-B607M', 'T00DMATR-B607M', 'T14DMLWR-B607M') "
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		SHC.HC_FILIAL, SHC.HC_PRODUTO "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\CalcNec.sql", cQuery)
		
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
		
	Count To nQtdReg
	
	If !IsBlind()
	
		ProcRegua(nQtdReg + 3)
	 
		IncProc("Excluindo Calculo")
	
	EndIf 

	ExcCalcNec()
	
	(cAliasQry)->(DbGoTop())
	
	If !(cAliasQry)->(Eof())
		
		cId := GetSXENum("Z2B", "Z2B_CODIGO")
		
		ConfirmSx8()
		
		While !(cAliasQry)->(Eof())
			
			If !IsBlind()
				IncProc("Calculando produto "+ AllTrim((cAliasQry)->HC_PRODUTO))
			EndIf 

			ProdMP(cId, (cAliasQry)->HC_PRODUTO)
			
			(cAliasQry)->(DbSkip())
			
		EndDo
	
	Else

		If !IsBlind()
			Aviso("Atenção", "Não existe produção para os parÃ¢metros informados", {"Ok"})
		EndIf

	EndIf
		
	(cAliasQry)->(DbCloseArea())
	
	If !IsBlind()
		IncProc("Atualizando saldos")
	EndIf 

	AtuCalcNec()
	
	If !IsBlind()
		IncProc("Gravando calculo")
	EndIf

	GrvCalcNec()
	
	If !IsBlind()
	
		//Colunas browser
		AdicCol("", 0, "", .F.)
		AdicCol(TIT_COL_ID_CALC, 		TAM_COL_ID_CALC, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(ID_CALC) +"]", 		.F.)
		AdicCol(TIT_COL_FORNECEDOR, 	TAM_COL_FORNECEDOR, 	"aCalcNec[oBrowse:nAt, "+ cValToChar(FORNECEDOR) +"]", 		.F.)
		AdicCol(TIT_COL_LOJA, 			TAM_COL_LOJA, 			"aCalcNec[oBrowse:nAt, "+ cValToChar(LOJA) +"]", 			.F.)
		AdicCol(TIT_COL_NOME, 			TAM_COL_NOME, 			"aCalcNec[oBrowse:nAt, "+ cValToChar(NOME) +"]", 			.F.)
		AdicCol(TIT_COL_PRODUTO, 		TAM_COL_PRODUTO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(PRODUTO) +"]", 		.F.)
		AdicCol(TIT_COL_DESCRICAO, 		TAM_COL_DESCRICAO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(DESCRICAO) +"]", 		.F.)
		AdicCol(TIT_COL_LOTE_ECONOMICO, TAM_COL_LOTE_ECONOMICO, "aCalcNec[oBrowse:nAt, "+ cValToChar(LOTE_ECONOMICO) +"]",	.F.)
			
		For nPeriodo := 1 To Len(aPeriodos) - 1
			
			cPeriodo := aPeriodos[nPeriodo][PERIODO_FORM]
			nPerCalc := aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL
				
			AdicCol(TIT_COL_ESTOQUE + cPeriodo, 	 TAM_COL_ESTOQUE, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(ESTOQUE + nPerCalc) +"]",		.F.)
			AdicCol(TIT_COL_ENTRADA + cPeriodo, 	 TAM_COL_ENTRADA, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(ENTRADA + nPerCalc) +"]",		.F.)
			AdicCol(TIT_COL_CONSUMO + cPeriodo, 	 TAM_COL_CONSUMO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(CONSUMO + nPerCalc) +"]",		.F.)
			AdicCol(TIT_COL_SALDO + cPeriodo, 		 TAM_COL_SALDO, 		"aCalcNec[oBrowse:nAt, "+ cValToChar(SALDO + nPerCalc) +"]",		.F.)
			AdicCol(TIT_COL_NECESSIDADE + cPeriodo,  TAM_COL_NECESSIDADE, 	"aCalcNec[oBrowse:nAt, "+ cValToChar(NECESSIDADE + nPerCalc) +"]",	.F.)
			AdicCol(TIT_COL_DIAS_ESTOQUE + cPeriodo, TAM_COL_DIAS_ESTOQUE, 	"aCalcNec[oBrowse:nAt, "+ cValToChar(DIAS_ESTOQUE + nPerCalc) +"]",	.F.)
				
		Next nPeriodo
		
		AdicCol(TIT_COL_PC, TAM_COL_PC, "aCalcNec[oBrowse:nAt, "+ cValToChar((nPeriodo * 6) + 8) +"]", .T.)
		
		//Atualiza tela
		oBrowse:SetArray(aCalcNec)
		
		oBrowse:aHeaders  	:= aHeadCol
		oBrowse:aColSizes 	:= aColSize
		oBrowse:aColBmps  	:= aColBMP
		oBrowse:bLine 		:= &cLine
		
		oBrowse:RepaintHeader()
		oBrowse:Refresh()
	
	EndIf 

Return Nil

Static Function ProdMP(cID, cProduto)
	
	Local aProdMP		:= {}
	Local cAliasQry		:= GetNextAlias()
	Local cQuery 		:= ""
	Local cTpProd		:= AllTrim(SuperGetMV("ZZ_TPPRD", .F., "'MP', 'EM', 'OI'")) 	//ADD LUCIANO LAMBERTI - TIPO OI - 21-11-2022
	Local cPeriodo		:= ""
	Local nPeriodo		:= 0
	Local nEstoque		:= 0
	Local nEntrada		:= 0
	Local nConsumo		:= 0
	Local nPos			:= 0
	  
	cQuery := "WITH ESTRUTURA AS "+ CRLF
	cQuery += "( "+ CRLF
	cQuery += "		SELECT "+ CRLF 
	cQuery += "			SG1.G1_COD AS CODIGO, SG1.G1_COMP AS COMPONENTE, SG1.G1_QUANT AS QUANTIDADE,  "+ CRLF
	cQuery += "			SG1.G1_PERDA AS PERDA, SG1.G1_INI AS INICIO, SG1.G1_FIM AS FIM "+ CRLF
	cQuery += "		FROM "+ RetSqlTab("SG1") +" "+ CRLF
	cQuery += "		WHERE "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF  
	cQuery += "			AND "+ RetSqlFil("SG1") +" "+ CRLF 
	cQuery += "			AND SG1.G1_COD = '"+ cProduto +"' "+ CRLF  
	cQuery += "			AND CONVERT(CHAR(10), GETDATE(), 112) BETWEEN SG1.G1_INI AND SG1.G1_FIM "+ CRLF
	cQuery += "			AND SG1.G1_MSBLQL <> '1' "
	cQuery += " "+ CRLF
	cQuery += "		UNION ALL "+ CRLF
	cQuery += " "+ CRLF 
	cQuery += "		SELECT "+ CRLF
	cQuery += "			SG1.G1_COD AS CODIGO, SG1.G1_COMP AS COMPONENTE, SG1P.QUANTIDADE * SG1.G1_QUANT AS QUANTIDADE, "+ CRLF
	cQuery += "			SG1.G1_PERDA AS PERDA, SG1.G1_INI AS INICIO, SG1.G1_FIM AS FIM "+ CRLF
	cQuery += "		FROM "+ RetSqlTab("SG1") +", ESTRUTURA SG1P "+ CRLF
	cQuery += "		WHERE "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
	cQuery += "			AND "+ RetSqlFil("SG1") +" "+ CRLF
	cQuery += "			AND SG1P.COMPONENTE = SG1.G1_COD "+ CRLF
	cQuery += "			AND CONVERT(CHAR(10), GETDATE(), 112) BETWEEN SG1.G1_INI AND SG1.G1_FIM "+ CRLF
	cQuery += "			AND SG1.G1_MSBLQL <> '1' "
	cQuery += " "+ CRLF
	//Adicionado tratativa para troca de produto na estrutura (Recaten)
	cQuery += "		UNION ALL "+ CRLF
	cQuery += " "+ CRLF 
	cQuery += "		SELECT "+ CRLF
	cQuery += "			SG1.G1_COD AS CODIGO, SG1.G1_COMP AS COMPONENTE, SG1P.QUANTIDADE * SG1.G1_QUANT AS QUANTIDADE,  "+ CRLF
	cQuery += "			SG1.G1_PERDA AS PERDA, SG1.G1_INI AS INICIO, SG1.G1_FIM AS FIM  "+ CRLF
	cQuery += "		FROM "+ RetSqlTab("SG1") +", ESTRUTURA SG1P "+ CRLF
	cQuery += "		WHERE  "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
	cQuery += "			AND "+ RetSqlFil("SG1") +" "+ CRLF
	cQuery += "			AND SG1P.COMPONENTE = SG1.G1_COD  "+ CRLF
	cQuery += "			AND SG1.G1_INI > CONVERT(CHAR(10), GETDATE(), 112) "+ CRLF
	cQuery += "			AND SG1.G1_FIM > CONVERT(CHAR(10), GETDATE(), 112) "+ CRLF
	cQuery += "			AND SG1.G1_MSBLQL <> '1' "
	cQuery += ") "+ CRLF
	cQuery += "SELECT "+ CRLF
	cQuery += "		ESTRUTURA.CODIGO, ESTRUTURA.QUANTIDADE, ESTRUTURA.PERDA, ESTRUTURA.INICIO, ESTRUTURA.FIM, "+ CRLF
	cQuery += "		SB1.B1_COD, SB1.B1_DESC, SB1.B1_QE, SB1.B1_LE, "+ CRLF
	cQuery += "		SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NREDUZ, "+ CRLF
	cQuery += "		( "+ CRLF
	cQuery += "			SELECT "+ CRLF
	cQuery += "				SUM(SB2.B2_QATU) AS B2_QATU "+ CRLF
	cQuery += "			FROM "+ RetSqlTab("SB2") +" "+ CRLF
	cQuery += "			WHERE "+ CRLF
	cQuery += "				"+ RetSqlDel("SB2") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB2") +" "+ CRLF
	cQuery += "				AND SB2.B2_COD = SB1.B1_COD "+ CRLF
	cQuery += "				AND SB2.B2_LOCAL IN ("+ AllTrim(cLocal) +") "+ CRLF
	cQuery += "			GROUP BY "+ CRLF
	cQuery += "				SB2.B2_COD "+ CRLF
	cQuery += "		) AS B2_QATU "+ CRLF
	//Adicionado em 18/08/2020 para considerar o saldo em poder de terceiro - Ectore Cecato
	cQuery += "		,ISNULL(( "+ CRLF
	cQuery += "			SELECT "+ CRLF
	cQuery += "				SUM(SB6.B6_SALDO) AS B6_SALDO "+ CRLF
	cQuery += "			FROM "+ RetSqlTab("SB6") +" "+ CRLF
	cQuery += "			WHERE "+ CRLF
	cQuery += "				"+ RetSqlDel("SB6") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB6") +" "+ CRLF
	cQuery += "				AND SB6.B6_PRODUTO = SB1.B1_COD "+ CRLF
	cQuery += "				AND SB6.B6_LOCAL IN ("+ AllTrim(cLocal) +") "+ CRLF
	cQuery += "				AND SB6.B6_PODER3 = 'R' "+ CRLF
	cQuery += "				AND SB6.B6_SALDO > 0 "+ CRLF
	cQuery += "				AND SB6.B6_EMISSAO >= '20200401' "+ CRLF
	cQuery += "			GROUP BY "+ CRLF
	cQuery += "				SB6.B6_PRODUTO "+ CRLF
	cQuery += "		), 0) AS B6_SALDO "+ CRLF
	cQuery += "FROM ESTRUTURA "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SB1") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SB1") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB1") +" "+ CRLF
	cQuery += "				AND SB1.B1_COD = COMPONENTE "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SB5") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SB5") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB5") +" "+ CRLF
	cQuery += "				AND SB5.B5_COD = COMPONENTE "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SA2") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SA2") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SA2") +" "+ CRLF
	cQuery += "				AND SA2.A2_COD = SB1.B1_PROC "+ CRLF
	cQuery += "				AND SA2.A2_LOJA = SB1.B1_LOJPROC "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		SB1.B1_PROC = '"+ cFornec +"' "+ CRLF
	cQuery += "		AND SB1.B1_LOJPROC = '"+ cLoja +"' "+ CRLF
	cQuery += "		AND (SB1.B1_TIPO IN ("+ cTpProd +") OR SB5.B5_ZZREV = 'T') "+ CRLF
	//cQuery += "		AND SB1.B1_COD IN ('T2A-2B102-S00') "
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		SB1.B1_COD "
	
	MemoWrite("\SQL\ProdMP.sql", cQuery)
		
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	While !(cAliasQry)->(Eof())
		
		aProdMP := {}
		
		aAdd(aProdMP, cID)
		aAdd(aProdMP, (cAliasQry)->A2_COD)
		aAdd(aProdMP, (cAliasQry)->A2_LOJA)
		aAdd(aProdMP, AllTrim((cAliasQry)->A2_NREDUZ))
		aAdd(aProdMP, AllTrim((cAliasQry)->B1_COD))
		aAdd(aProdMP, AllTrim((cAliasQry)->B1_DESC))
		aAdd(aProdMP, (cAliasQry)->B1_LE)
			
		For nPeriodo := 1 To Len(aPeriodos)
			
			cPeriodo  := aPeriodos[nPeriodo][PERIODO_ATU] 
			nEstoque  := (cAliasQry)->B2_QATU + (cAliasQry)->B6_SALDO
			nEntrada  := Entrada((cAliasQry)->B1_COD, cPeriodo)
			nPerda	  := If((cAliasQry)->PERDA > 0, (cAliasQry)->PERDA, PerdaResina((cAliasQry)->CODIGO, (cAliasQry)->B1_COD))

			//Só considero produto que esteja com a vigência dentro do período avaliado
			If aPeriodos[nPeriodo][PERIODO_ATU] >= Left((cAliasQry)->INICIO, 6) .And. aPeriodos[nPeriodo][PERIODO_ATU] <= Left((cAliasQry)->FIM, 6)
				nConsumo := Consumo(cProduto, cPeriodo) * (cAliasQry)->QUANTIDADE
			Else 
				nConsumo := 0
			EndIf 

			//Aplico % da perda
			If nPerda > 0 
				nConsumo := Round((nConsumo / (100 - nPerda)) * 100, 2)
			EndIf
			
			aAdd(aProdMP, nEstoque)
			aAdd(aProdMP, nEntrada)
			aAdd(aProdMP, nConsumo)
			aAdd(aProdMP, 0)
			aAdd(aProdMP, 0)
			aAdd(aProdMP, 0)
				
		Next nPeriodo
			
		aAdd(aProdMP, "")
		
		nPos := aScan(aCalcNec, {|x| AllTrim(x[PRODUTO]) == AllTrim((cAliasQry)->B1_COD)}) 
		
		If nPos == 0 
			
			aAdd(aCalcNec, aProdMP)
			aAdd(aProdPA, AllTrim((cAliasQry)->CODIGO))
			
		Else
			
			For nPeriodo := 1 To Len(aPeriodos) 
				
				nCol := aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL
				
				aCalcNec[nPos][CONSUMO + nCol] += aProdMP[CONSUMO + nCol]
				
			Next nPeriodo
			
		EndIf
		
		(cAliasQry)->(DbSkip())
		
	EndDo
	
	(cAliasQry)->(DbCloseArea())
		
Return Nil

Static Function Entrada(cProduto, cPeriodo)
	
	Local cAliasQry	:= GetNextAlias()
	Local cQuery 	:= ""
	Local nQtd 		:= 0
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SC7.C7_PRODUTO, SUM(SC7.C7_QUANT - SC7.C7_QUJE) AS QUANTIDADE "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SC7") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SC7") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SC7") +" "+ CRLF
	cQuery += "		AND SC7.C7_PRODUTO = '"+ cProduto +"' "+ CRLF
	cQuery += "		AND SC7.C7_FORNECE = '"+ cFornec +"' "+ CRLF
	cQuery += "		AND SC7.C7_LOJA = '"+ cLoja +"' "+ CRLF
	cQuery += "		AND SC7.C7_RESIDUO = '' "+ CRLF
	cQuery += "		AND SUBSTRING(SC7.C7_ZZDTENT, 1, 6) = '"+ cPeriodo +"' "+ CRLF
	cQuery += "		AND SC7.C7_CONAPRO = 'L' "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		SC7.C7_PRODUTO "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\Entrada.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		nQtd := (cAliasQry)->QUANTIDADE
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return nQtd

Static Function Consumo(cProduto, cPeriodo)
	
	Local cAliasQry	:= GetNextAlias()
	Local cQuery 	:= ""
	Local nQtd 		:= 0
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SUM(SHC.HC_QUANT) AS QUANTIDADE "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SHC") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SHC") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SHC") +" "+ CRLF
	cQuery += "		AND SUBSTRING(SHC.HC_DATA, 1, 6) = '"+ cPeriodo +"' "+ CRLF
	cQuery += "		AND SHC.HC_PRODUTO = '"+ cProduto +"' "+ CRLF
	cQuery += "		AND SHC.HC_DOC = '"+ cDoc +"' "+ CRLF
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\Consumo.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		nQtd := (cAliasQry)->QUANTIDADE
	EndIf
	
	(cAliasQry)->(DbCloseArea()) 
	
Return nQtd

Static Function QtdNec(nQtdNec, cProduto)
	
	Local cAliasQry	:= GetNextAlias()
	Local nQtd 		:= 0
	Local nMult		:= 1
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SB1.B1_LE "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SB1") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SB1") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SB1") +" "+ CRLF
	cQuery += "		AND SB1.B1_COD = '"+ cProduto +"' "+ CRLF
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\QtdNec.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof()) .And. (cAliasQry)->B1_LE > 0
				
		While nQtd < nQtdNec 
		
			nQtd := (cAliasQry)->B1_LE * nMult
		
			nMult++
		
		EndDo
	
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return nQtd

Static Function ExcCalcNec()
	
	Local cQuery := ""
	
	cQuery := "UPDATE "+ RetSqlName("Z2B") +" "+ CRLF
	cQuery += "SET "+ CRLF
	cQuery += "		Z2B_STATUS = 'B' "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "		AND Z2B_FILIAL = '"+ FWxFilial("Z2B") +"' "
	cQuery += "		AND Z2B_STATUS <> 'B' "
	cQuery += "		AND Z2B_FORNEC = '"+ cFornec +"' "
	cQuery += "		AND Z2B_LOJA = '"+ cLoja +"' "
	
	MemoWrite("\SQL\ExcCalcNec.sql", cQuery)
	
	If TcSqlExec(cQuery) != 0
		UserException(TCSQLError())
	Endif		
	
Return Nil

Static Function GrvCalcNec()
	
	Local nProd	  	:= 0
	Local nPeriodo	:= 0
	Local nCol		:= 0
	
	For nProd := 1 To Len(aCalcNec)
		
		For nPeriodo := 1 To Len(aPeriodos) - 1
			
			nCol := aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL
			
			RecLock("Z2B", .T.)
				Z2B->Z2B_FILIAL	:= FWxFilial("Z2B")
				Z2B->Z2B_CODIGO	:= aCalcNec[nProd][ID_CALC]
				Z2B->Z2B_FORNEC	:= aCalcNec[nProd][FORNECEDOR]
				Z2B->Z2B_LOJA	:= aCalcNec[nProd][LOJA]
				Z2B->Z2B_PRODUT	:= aCalcNec[nProd][PRODUTO]
				Z2B->Z2B_PERIOD	:= aPeriodos[nPeriodo][PERIODO_ATU]
				Z2B->Z2B_ESTOQU	:= aCalcNec[nProd][ESTOQUE + nCol]
				Z2B->Z2B_ENTRAD	:= aCalcNec[nProd][ENTRADA + nCol]
				Z2B->Z2B_CONSUM	:= aCalcNec[nProd][CONSUMO + nCol]
				Z2B->Z2B_SALDO	:= aCalcNec[nProd][SALDO + nCol]
				Z2B->Z2B_NECESS	:= aCalcNec[nProd][NECESSIDADE + nCol]
				Z2B->Z2B_DIASES := aCalcNec[nProd][DIAS_ESTOQUE + nCol]
				Z2B->Z2B_PERCAL	:= Left(DtoS(dDataBase), 6)
				Z2B->Z2B_STATUS	:= "A"
			Z2B->(MsUnlock())
			
		Next nPeriodo
		
	Next nProd
	
Return Nil

Static Function DiasUteis(cPeriodo)
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nDias 	:= 0
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2A.Z2A_DIAS "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2A") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2A") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2A") +" "+ CRLF
	cQuery += "		AND Z2A.Z2A_ANO+Z2A.Z2A_MES = '"+ cPeriodo +"' "+ CRLF
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\DiasUteis.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		nDias := (cAliasQry)->Z2A_DIAS
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return nDias

Static Function CalcPeriod()
	
	Local nPeriodo 	:= 0
	Local cPeriodo1	:= ""
	Local cPeriodo2	:= ""
	Local cPeriodo3	:= ""
	
	aPeriodos := {}
	
	For nPeriodo := 0 To nPeriodos
		
		cPeriodo1 := Left(DtoS(MonthSum(dDtBase, nPeriodo)), 6) 
		cPeriodo2 := SubStr(DtoC(MonthSum(dDtBase, nPeriodo)), 4, 3) + Right(DtoC(MonthSum(dDtBase, nPeriodo)), 2)
		cPeriodo3 := Left(DtoS(MonthSum(dDtBase, (nPeriodo + 1))), 6)
						
		aAdd(aPeriodos, {nPeriodo, cPeriodo1, cPeriodo2, cPeriodo3})
	
	Next
				
Return Nil

Static Function AtuCalcNec()
	
	Local cPeriodo		:= ""
	Local nItem 		:= 0
	Local nPeriodo		:= 0
	Local nMes			:= 0
	Local nMesProx		:= 0 
	Local nSaldo		:= 0
	Local nNecessidade	:= 0
	Local nDiasEst		:= 0
	Local nDiasUteis	:= 0
		
	For nItem := 1 To Len(aCalcNec)

		For nPeriodo := 1 To Len(aPeriodos)

			cPeriodo		:= aPeriodos[nPeriodo][PERIODO_PROX]
			nDiasUteis		:= DiasUteis(cPeriodo)
			nMes 	 		:= aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL
			nMesProx 		:= If(nPeriodo < Len(aPeriodos), aPeriodos[nPeriodo + 1][PERIODO_IND] * QTDCOL, 0)
			nEstoque		:= aCalcNec[nItem][ESTOQUE + nMes]
			nEntrada		:= aCalcNec[nItem][ENTRADA + nMes]

			If Resina(aCalcNec[nItem][PRODUTO])
			
				nConsumo	:= CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_ATU]) //aCalcNec[nItem][CONSUMO + nMes]
				nConsumo2	:= If(nMesProx > 0, CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_PROX]), 0)
			
			Else
				
				nConsumo	:= aCalcNec[nItem][CONSUMO + nMes]
				nConsumo2	:= If(nMesProx > 0, aCalcNec[nItem][CONSUMO + nMesProx], 0)

			EndIf

			nSaldo	 	 	:= nEstoque + nEntrada - nConsumo
			nNecessidade	:= nSaldo - nConsumo2 
			nDiasEst 		:= Round(nSaldo / (nConsumo2 / nDiasUteis), 2)
			nEstMax			:= EstMax(aCalcNec[nItem][PRODUTO])

			If (nDiasEst < nDiasUteis .And. nSaldo < nConsumo2) .Or. (nEstMax > 0 .And. nDiasEst < nEstMax)
				
				If nEstMax > 0

					//If Resina(aCalcNec[nItem][PRODUTO])
					//	nNecessidade := CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_ATU])
					//Else	
						nNecessidade := (nEstMax - nDiasEst) * (nConsumo2 / nDiasUteis) 
					//EndIf 

				EndIf
				
				nNecessidade := QtdNec(Abs(nNecessidade), aCalcNec[nItem][PRODUTO])
			
			Else
				nNecessidade := 0
			EndIf
						
			//CalcResina(@nNecessidade, aProdPA[nItem], aCalcNec[nItem][PRODUTO], nConsumo)
			
			aCalcNec[nItem][ESTOQUE + nMes] 	 := Round(nEstoque, 2)
			aCalcNec[nItem][CONSUMO + nMes] 	 := Round(nConsumo, 2)
			aCalcNec[nItem][SALDO + nMes] 		 := Round(nSaldo, 2)  
			aCalcNec[nItem][NECESSIDADE + nMes]  := nNecessidade 
			aCalcNec[nItem][DIAS_ESTOQUE + nMes] := Round((nSaldo + nNecessidade) / (nConsumo2 / nDiasUteis), 2)
			
			//Atualiza estoque do próximo mês
			If nMesProx > 0
				aCalcNec[nItem][ESTOQUE + nMesProx] := nSaldo + nNecessidade
			EndIf
	
		Next nPeriodo

	Next nItem
	
	aCalcNec := aSort(aCalcNec,,,{|x, y| x[PRODUTO] < y[PRODUTO]})
	
Return Nil

Static Function EditCell(oBrowse)
	
	Local lAtuCalc	:= .F.
	Local nPos 		:= 0 
	Local nPeriodo	:= 0
	Local nPer		:= 0
	Local nItem		:= 0
	
	For nPeriodo := 1 To Len(aPeriodos) - 1
		
		nPos := (aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL) + NECESSIDADE
		
		If nPos == oBrowse:ColPos
			
			lEditCell(aCalcNec, oBrowse, "@E 999,999,999", oBrowse:ColPos)
			
			lAtuCalc := .T.
			nPer	 := nPeriodo
			
			Exit
			
		EndIf
		
	Next nPeriodo

	If lAtuCalc
	
		nItem := oBrowse:nAT
		
		ConOut("CALC INI => "+ Time())
		
		For nPeriodo := nPer To Len(aPeriodos)
			
			ConOut("NECESIDADE INI => "+ Time())
			
			cPeriodo		:= aPeriodos[nPeriodo][PERIODO_PROX]
			nDiasUteis		:= DiasUteis(cPeriodo)
			nMes 	 		:= aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL
			nMesProx 		:= If(nPeriodo < Len(aPeriodos), aPeriodos[nPeriodo + 1][PERIODO_IND] * QTDCOL, 0)
			nEstoque		:= aCalcNec[nItem][ESTOQUE + nMes]
			nEntrada		:= aCalcNec[nItem][ENTRADA + nMes]
			
			If Resina(aCalcNec[nItem][PRODUTO])
				nConsumo  := CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_ATU])
				nConsumo2 := If(nMesProx > 0 .And. (CONSUMO + nMesProx) <= Len(aCalcNec[nItem]), CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_PROX]), 0)
			Else
				nConsumo		:= aCalcNec[nItem][CONSUMO + nMes]
				nConsumo2		:= If(nMesProx > 0 .And. (CONSUMO + nMesProx) <= Len(aCalcNec[nItem]), aCalcNec[nItem][CONSUMO + nMesProx], 0)
			EndIf

			nSaldo	 	 	:= nEstoque + nEntrada - nConsumo
			nNecessidade	:= nSaldo - nConsumo2 
			nDiasEst 		:= Round(nSaldo / (nConsumo2 / nDiasUteis), 2)
			nEstMax			:= EstMax(aCalcNec[nItem][PRODUTO])
					
			If nPos == (NECESSIDADE + nMes)
				nNecessidade := aCalcNec[nItem][nPos]
			Else
			
				If (nDiasEst < nDiasUteis .And. nSaldo < nConsumo2) .Or. (nEstMax > 0 .And. nDiasEst < nEstMax)
					
					If nEstMax > 0
					
						//If Resina(aCalcNec[nItem][PRODUTO])
						//	nNecessidade := CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_ATU])
						//else
							nNecessidade := (nEstMax - nDiasEst) * (nConsumo2 / nDiasUteis) 
						//EndIf
						
					EndIf
					
					nNecessidade := QtdNec(Abs(nNecessidade), aCalcNec[nItem][PRODUTO])

				Else
					nNecessidade := 0
				EndIf			

				//CalcResina(@nNecessidade, aProdPA[nItem], aCalcNec[nItem][PRODUTO], nConsumo)

			EndIf
			
			aCalcNec[nItem][ESTOQUE + nMes] 		:= Round(nEstoque, 2)
			aCalcNec[nItem][CONSUMO + nMes] 		:= Round(nConsumo, 2)
			aCalcNec[nItem][SALDO + nMes] 			:= Round(nSaldo, 2)
			aCalcNec[nItem][NECESSIDADE + nMes]		:= nNecessidade 
			aCalcNec[nItem][DIAS_ESTOQUE + nMes]	:= Round((nSaldo + nNecessidade) / (nConsumo2 / nDiasUteis), 2)
			
			//Atualiza estoque do próximo mês
			If nMesProx > 0
				aCalcNec[nItem][ESTOQUE + nMesProx] := nSaldo + nNecessidade
			EndIf

		Next nPeriodo	
		
		ConOut("CALC FIM => "+ Time())
		
		oBrowse:RepaintHeader()
		oBrowse:Refresh()
		
	EndIf
	
Return Nil

Static Function CondPagto()
	
	Local cAliasQry	:= GetNextAlias()
	Local cQuery	:= ""
	Local cCondPgto := ""
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SA2.A2_COND, "+ CRLF
	cQuery += "		ISNULL(AIA.AIA_CONDPG, '') AS AIA_CONDPG "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SA2") +" "+ CRLF
	cQuery += "		LEFT JOIN "+ RetSqlTab("AIA") +" "+ CRLF
	cquery += "			ON	"+ RetSqlDel("AIA") +" "+ CRLF
	cQuery += "				AND "+ RetSqlDel("AIA") +" "+ CRLF
	cQuery += "				AND AIA.AIA_CODFOR = SA2.A2_COD "+ CRLF
	cQuery += "				AND AIA.AIA_LOJFOR = SA2.A2_LOJA "+ CRLF
	cQuery += "				AND "+ CRLF
	cQuery += "				( "+ CRLF
	cQuery += "					CONVERT(CHAR(10), GETDATE(), 112) BETWEEN AIA_DATDE AND AIA_DATATE "+ CRLF
	cQuery += "					OR "+ CRLF
	cQuery += "					CONVERT(CHAR(10), GETDATE(), 112) >= AIA_DATDE AND AIA_DATATE = '' "+ CRLF
	cQuery += "				)"+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SA2") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SA2") +" "+ CRLF
	cQuery += "		AND SA2.A2_COD = '"+ cFornec +"' "+ CRLF
	cQuery += "		AND SA2.A2_LOJA = '"+ cLoja +"' "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\CondPagto.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		cCondPgto := If(!Empty((cAliasQry)->AIA_CONDPG), (cAliasQry)->AIA_CONDPG, (cAliasQry)->A2_COND) 
	EndIf
	
	(cAliasQry)->(DbCloseArea())	
	
Return cCondPgto

Static Function PrcProd(cProduto)
	
	Local cAliasQry	:= GetNextAlias()
	Local cQuery	:= ""
	Local nPreco 	:= 0
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		AIB.AIB_PRCCOM "+ CRLF
	cQuery += "FROM "+ RetSqlTab("AIA") +" "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("AIB") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("AIB") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("AIB") +" "+ CRLF
	cQuery += "				AND AIB.AIB_CODFOR = AIA.AIA_CODFOR "+ CRLF
	cQuery += "				AND AIB.AIB_LOJFOR = AIA.AIA_LOJFOR "+ CRLF
	cQuery += "				AND AIB.AIB_CODTAB = AIA.AIA_CODTAB "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("AIA") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("AIA") +" "+ CRLF
	cQuery += "		AND AIA.AIA_CODFOR = '"+ cFornec +"' "+ CRLF
	cQuery += "		AND AIA.AIA_LOJFOR = '"+ cLoja +"' "+ CRLF
	cQuery += "		AND AIB.AIB_CODPRO = '"+ cProduto +"' "
	cQuery += "ORDER BY "
	cQuery += "		AIB.R_E_C_N_O_ DESC "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\PrcProd.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		nPreco := (cAliasQry)->AIB_PRCCOM 
	EndIf
	
	(cAliasQry)->(DbCloseArea())	
	
Return nPreco

Static Function Forecast()
	
	Local aRet 		:= {}
	Local aPergs	:= {}
		
	If Len(aCalcNec) > 0 .And. ExistBlock("HLRPCP03")
		
		aAdd(aPergs, {1, "Data base", dDataBase, "", "", "", "", 60, .F.})   

		If ParamBox(aPergs, "Forecast", @aRet,,,,,,, "Relatório Forecast", .T., .T.)
			U_HLRPCP03(aCalcNec[1][ID_CALC], MV_PAR01)
		EndIf
			
	Else
		MsgAlert("Relatório não disponível", "Atenção")
	EndIf
	
Return Nil

Static Function SalvarCalc()
	
	Local cId 	:= GetSXENum("Z2B", "Z2B_CODIGO")
	Local nItem	:= 0
		
	ConfirmSx8()
	
	ProcRegua(0)
	
	For nItem := 1 To Len(aCalcNec)
		aCalcNec[nItem][ID_CALC] := cId
	Next nItem
	
	ExcCalcNec()
	
	GrvCalcNec()
	
	Aviso("Atenção", "Calculo salvo com sucesso", {"Ok"})
		
Return Nil

Static Function EstMax(cProduto)
	
	Local cQuery	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nEstMax 	:= 0
		
	cQuery := "SELECT "+ CRLF
	cQuery += "		SB5.B5_ZZESTMX "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SB5") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SB5") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SB5") +" "+ CRLF
	cQuery += "		AND SB5.B5_COD = '"+ cProduto +"' "+ CRLF
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\EstMax.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		nEstMax := (cAliasQry)->B5_ZZESTMX 
	EndIf
	
	(cAliasQry)->(DbCloseArea())	
	
Return nEstMax

Static Function AdicCol(cTitulo, nTamanho, cLinha, lUltima)
	
	If Empty(cTitulo) .And. nTamanho == 0 .And. Empty(cLinha)
		
		aHeadCol := {}
		aColSize := {}
		aColBMP	 := {}
		cLine	 := ""
		
	Else
		
		aAdd(aHeadCol, cTitulo)
		aAdd(aColSize, nTamanho)
		aAdd(aColBMP,  .F.)
		
		cLine += cLinha
		
		If lUltima
			cLine := "{|| {"+ cLine +"}}"
		Else
			cLine += ","
		EndIf
		
	EndIf
	
Return Nil

Static Function ParamGerPed(aPerPed, nQuebra, nMoeda)

	Local aRet 		:= {}
	Local aPergs	:= {}
	//Local nItem		:= 0
	Local lContinua	:= .F.
		
	aAdd(aPergs, {1, "Periodo base", dDataBase, "", "", "", "", 60, .T.})   
	aAdd(aPergs ,{2, "Tipo Pedido", 1, {"", PEDIDO_NACIONAL, PEDIDO_INTERNACIONAL}, 50,".T.", .T.})
	aAdd(aPergs, {1, "Qtd. Pedido", 1, "", "", "", "", 60, .T.})
	aAdd(aPergs, {1, "Moeda", 1, "", "", "SM2", "", 60, .T.})

	If ParamBox(aPergs, "Pedido de Compras", @aRet,,,,,,, "Pedido de Compras", .T., .T.)
		
		lContinua 	:= .T.
		nQuebra 	:= MV_PAR03
		nMoeda		:= MV_PAR04

		aAdd(aPerPed, Left(DToS(MV_PAR01), 6))
		
		If MV_PAR02 == PEDIDO_INTERNACIONAL
			
			aAdd(aPerPed, Left(DToS(MonthSum(MV_PAR01, 1)), 6))
			
			//nQuebra := 2
			
			MsgAlert("Para pedidos de compras internacional, será gerado 2 pedidos (1 fixo e 1 previsto)", "Atenção")
			
		Endif
				
	EndIf
	
Return lContinua 

Static Function DtEnt(cPeriodo, nQuebra, aDtEnt)

	Local aRet 		:= {}
	Local aPergs	:= {}
	Local nItem		:= 0
	Local lContinue	:= .F.
	
	For nItem := 1 To nQuebra
		aAdd(aPergs, {1, "Dt Ent. "+ AllTrim(cValToChar(nItem)) +" "+ Right(cPeriodo, 2) +"/"+ Left(cPeriodo, 4), StoD(cPeriodo + "01"), "", "", "", "", 60, .T.})
	Next nItem	
	
	If ParamBox(aPergs, "Pedido de Compras", @aRet,,,,,,, "Pedido de Compras", .T., .T.)
		
		lContinue := .T.
		
		For nItem := 1 To nQuebra
			aAdd(aDtEnt, aRet[nItem])
		Next nItem
		
	EndIf
	
Return lContinue

Static Function ZerarNec(oBrowse)

	Local lAtuCalc	:= .F.
	Local nPos 		:= 0 
	Local nPeriodo	:= 0
	Local nItem		:= 0
	Local nPer		:= 0
	
	For nPeriodo := 1 To Len(aPeriodos) - 1
		
		nPos := (aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL) + NECESSIDADE
		
		If nPos == oBrowse:ColPos
			
			lAtuCalc := .T.
			nPer 	 := nPeriodo
			
			Exit
			
		EndIf
		
	Next nPeriodo

	If lAtuCalc
		
		For nItem := 1 To Len(aCalcNec)
		
			For nPeriodo := nPer To Len(aPeriodos)
	
				cPeriodo		:= aPeriodos[nPeriodo][PERIODO_PROX]
				nDiasUteis		:= DiasUteis(cPeriodo)
				nMes 	 		:= aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL
				nMesProx 		:= If(nPeriodo < Len(aPeriodos), aPeriodos[nPeriodo + 1][PERIODO_IND] * QTDCOL, 0)
				nEstoque		:= aCalcNec[nItem][ESTOQUE + nMes]
				nEntrada		:= aCalcNec[nItem][ENTRADA + nMes]

				If Resina(aCalcNec[nItem][PRODUTO])
					nConsumo		:= CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_ATU])
					nConsumo2		:= If(nMesProx > 0, CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_PROX]), 0)
				Else
					nConsumo		:= aCalcNec[nItem][CONSUMO + nMes]
					nConsumo2		:= If(nMesProx > 0, aCalcNec[nItem][CONSUMO + nMesProx], 0)
				EndIf

				nSaldo	 	 	:= nEstoque + nEntrada - nConsumo
				nNecessidade	:= nSaldo - nConsumo2 
				nDiasEst 		:= Round(nSaldo / (nConsumo2 / nDiasUteis), 2)
				nEstMax			:= EstMax(aCalcNec[nItem][PRODUTO])
							
				If nPos == (NECESSIDADE + nMes)
					nNecessidade := 0
				Else
				
					If (nDiasEst < nDiasUteis .And. nSaldo < nConsumo2) .Or. (nEstMax > 0 .And. nDiasEst < nEstMax)
						
						If nEstMax > 0

						//If Resina(aCalcNec[nItem][PRODUTO])
						//	nNecessidade := CalcResina(aCalcNec[nItem][PRODUTO], aPeriodos[nPeriodo][PERIODO_ATU])
						//Else
							nNecessidade := (nEstMax - nDiasEst) * (nConsumo2 / nDiasUteis) 
						EndIf
						
						nNecessidade := QtdNec(Abs(nNecessidade), aCalcNec[nItem][PRODUTO])

					Else
						nNecessidade := 0
					EndIf			
	
				EndIf

				aCalcNec[nItem][ESTOQUE + nMes] 	 := Round(nEstoque, 2)			
				aCalcNec[nItem][CONSUMO + nMes] 	 := Round(nConsumo, 2)
				aCalcNec[nItem][SALDO + nMes] 		 := Round(nSaldo, 2)
				aCalcNec[nItem][NECESSIDADE + nMes]	 := nNecessidade 
				aCalcNec[nItem][DIAS_ESTOQUE + nMes] := Round((nSaldo + nNecessidade) / (nConsumo2 / nDiasUteis), 2)
				
				//Atualiza estoque do próximo mês
				If nMesProx > 0
					aCalcNec[nItem][ESTOQUE + nMesProx] := nSaldo + nNecessidade
				EndIf
	
					
			Next nPeriodo
		
		Next nItem
		
		oBrowse:RepaintHeader()
		oBrowse:Refresh()
		
	EndIf
		
Return Nil

Static Function ConsCon(oBrowse)
	
	Local aConsumo	:= {}
	Local aLinha	:= {}
	Local cQuery	:= ""
	Local cAliasQry	:= ""
	Local nPos 		:= 0 
	Local nPeriodo	:= 0
	//Local nItem		:= 0
	Local nTotal	:= 0
	Local lContinua	:= .F.
	Local oDlg		:= Nil
	Local oBrwCon	:= Nil
	
	ProcRegua(0)
	
	For nPeriodo := 1 To Len(aPeriodos) - 1
		
		nPos := (aPeriodos[nPeriodo][PERIODO_IND] * QTDCOL) + CONSUMO
		
		If nPos == oBrowse:ColPos

			lContinua := .T.
			
			Exit
			
		EndIf
		
	Next nPeriodo
	
	If lContinua
	
		cAliasQry := GetNextAlias()
		
		cQuery := "WITH ESTRUT(CODIGO, COD_PAI, COD_COMP) AS "+ CRLF
		cQuery += "( "+ CRLF
		cQuery += "		SELECT "+ CRLF
		cQuery += "			SG1.G1_COD AS PAI, SG1.G1_COD, SG1.G1_COMP "+ CRLF
		cQuery += "     FROM "+ RetSqlTab("SG1") +" "+ CRLF
		cQuery += "     WHERE "+ CRLF
		cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
		cQuery += "       	AND "+ RetSqlFil("SG1") +" "+ CRLF
		cQuery += "	   		AND CONVERT(CHAR(10), GETDATE(), 112) BETWEEN SG1.G1_INI AND SG1.G1_FIM "+ CRLF
		cQuery += "			AND SG1.G1_MSBLQL <> '1' "
 		cQuery += "		"+ CRLF
		cQuery += "     UNION ALL "+ CRLF
		cQuery += "		"+ CRLF
		cQuery += "     SELECT "
		cQuery += "			CODIGO, SG1.G1_COD, SG1.G1_COMP "+ CRLF
		cQuery += "     FROM "+ RetSqlTab("SG1") +" "+ CRLF
		cQuery += "     	INNER JOIN ESTRUT EST "+ CRLF
		cQuery += "        		ON 	G1_COD = COD_COMP "+ CRLF
		cQuery += "     WHERE "+ CRLF
		cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
		cQuery += "       	AND "+ RetSqlFil("SG1") +" "+ CRLF
		cQuery += "	   		AND CONVERT(CHAR(10), GETDATE(), 112) BETWEEN SG1.G1_INI AND SG1.G1_FIM "+ CRLF
		cQuery += "			AND SG1.G1_MSBLQL <> '1' "
		cQuery += " "+ CRLF
		//Adicionado tratativa para troca de produto na estrutura (Recaten)
		cQuery += "		UNION ALL "+ CRLF
		cQuery += " "+ CRLF 
		cQuery += "     SELECT "
		cQuery += "			CODIGO, SG1.G1_COD, SG1.G1_COMP "+ CRLF
		cQuery += "     FROM "+ RetSqlTab("SG1") +" "+ CRLF
		cQuery += "     	INNER JOIN ESTRUT EST "+ CRLF
		cQuery += "        		ON 	G1_COD = COD_COMP "+ CRLF
		cQuery += "     WHERE "+ CRLF
		cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
		cQuery += "       	AND "+ RetSqlFil("SG1") +" "+ CRLF
		cQuery += "			AND SG1.G1_INI > CONVERT(CHAR(10), GETDATE(), 112) "+ CRLF
		cQuery += "			AND SG1.G1_FIM > CONVERT(CHAR(10), GETDATE(), 112) "+ CRLF
		cQuery += "			AND SG1.G1_MSBLQL <> '1' "
		cQuery += ""+ CRLF
		cQuery += ") "+ CRLF
		cQuery += "SELECT "
		cQuery += "		SB1.B1_COD, SB1.B1_DESC, SHC.HC_DATA, SHC.HC_QUANT "+ CRLF
		cQuery += "FROM ESTRUT "+ CRLF
		cQuery += "		INNER JOIN "+ RetSqlTab("SB1")+" "+ CRLF
		cQuery += "			ON 	"+ RetSqlDel("SB1") +" "
		cQuery += "				AND "+ RetSqlFil("SB1") +" "
		cQuery += "				AND SB1.B1_COD = CODIGO "
		cQuery += "		INNER JOIN "+ RetSqlTab("SHC") +" "
		cQuery += "			ON 	"+ RetSqlDel("SHC") +" "
		cQuery += "				AND "+ RetSqlFil("SHC") +" "
		cQuery += "				AND SHC.HC_PRODUTO = CODIGO "+ CRLF
		cQuery += "				AND SHC.HC_DOC = '"+ cDoc +"' "+ CRLF
		cQuery += "WHERE "
		cQuery += "		COD_COMP = '"+ aCalcNec[oBrowse:nAT][PRODUTO] +"' "
		cQuery += "		AND SUBSTRING(SHC.HC_DATA, 1, 6) BETWEEN '"+ aPeriodos[nPeriodo][PERIODO_ATU] +"' AND '"+ aPeriodos[nPeriodo][PERIODO_ATU] +"' "+ CRLF
		cQuery += "ORDER BY "
		cQuery += "		SB1.B1_COD "		
		
		MemoWrite("\SQL\ConsCon.sql", cQuery)
		
		MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
		
		TcSetField(cAliasQry, "HC_DATA", "D", 08, 00)
		
		While !(cAliasQry)->(Eof())
			
			aLinha := {}
			
			aAdd(aLinha, (cAliasQry)->B1_COD)
			aAdd(aLinha, (cAliasQry)->B1_DESC)
			aAdd(aLinha, (cAliasQry)->HC_QUANT)
			aAdd(aLinha, DToC((cAliasQry)->HC_DATA))
			
			aAdd(aConsumo, aLinha)
			
			nTotal += (cAliasQry)->HC_QUANT
			
			(cAliasQry)->(DbSkip())
			
		EndDo
		
		(cAliasQry)->(DbCloseArea())
		
		If !Empty(aConsumo)
			aAdd(aConsumo, {"TOTAL", "", nTotal, ""})
		EndIf 

	EndIf
	
	If !Empty(aConsumo)
		
		DEFINE MSDIALOG oDlg TITLE "Consumo" FROM 000, 000 TO 27, 77
		
			oBrwCon := TCBrowse():New(05, 05, 300, 200,,,, oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,,,,,,,,, 1)
			
			oBrwCon:SetArray(aConsumo)
			
			oBrwCon:AddColumn(TCColumn():New("Produto",		{|| aConsumo[oBrwCon:nAt, 01]},,,, "LEFT", 070, .F., .F.,,,, .F.,))
			oBrwCon:AddColumn(TCColumn():New("Descrição",	{|| aConsumo[oBrwCon:nAt, 02]},,,, "LEFT", 130, .F., .F.,,,, .F.,))
			oBrwCon:AddColumn(TCColumn():New("Quantidade",	{|| aConsumo[oBrwCon:nAt, 03]},,,, "LEFT", 050, .F., .F.,,,, .F.,))
			oBrwCon:AddColumn(TCColumn():New("Data",		{|| aConsumo[oBrwCon:nAt, 04]},,,, "LEFT", 020, .F., .F.,,,, .F.,))
			
		ACTIVATE DIALOG oDlg ON INIT (oBrwCon:Refresh())
		
	Else
		MsgAlert("Consumo não localizado", "Atenção")
	EndIf
	
Return Nil

Static Function CalcQtd(nQuant, nLote)
	
	nQuant := Ceiling(nQuant / nLote)
	nQuant := nQuant * nLote
	
Return nQuant

Static Function CalcResina(cResina, cPeriodo)
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nConsumo	:= 0
	
	cQuery := "WITH ESTRUT(CODIGO, COD_PAI, COD_COMP) AS "+ CRLF
	cQuery += "( "+ CRLF
	cQuery += "		SELECT "+ CRLF
	cQuery += "			SG1.G1_COD AS PAI, SG1.G1_COD, SG1.G1_COMP "+ CRLF
	cQuery += "     FROM "+ RetSqlTab("SG1") +" "+ CRLF
	cQuery += "     WHERE "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
	cQuery += "       	AND "+ RetSqlFil("SG1") +" "+ CRLF
	cQuery += "	   		AND CONVERT(CHAR(10), GETDATE(), 112) BETWEEN SG1.G1_INI AND SG1.G1_FIM "+ CRLF
 	cQuery += "		"+ CRLF
	cQuery += "     UNION ALL "+ CRLF
	cQuery += "		"+ CRLF
	cQuery += "     SELECT "
	cQuery += "			CODIGO, SG1.G1_COD, SG1.G1_COMP "+ CRLF
	cQuery += "     FROM "+ RetSqlTab("SG1") +" "+ CRLF
	cQuery += "     	INNER JOIN ESTRUT EST "+ CRLF
	cQuery += "        		ON 	G1_COD = COD_COMP "+ CRLF
	cQuery += "     WHERE "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
	cQuery += "       	AND "+ RetSqlFil("SG1") +" "+ CRLF
	cQuery += "	   		AND CONVERT(CHAR(10), GETDATE(), 112) BETWEEN SG1.G1_INI AND SG1.G1_FIM "+ CRLF
	cQuery += ""+ CRLF
	cQuery += ") "+ CRLF
	cQuery += "SELECT "
	cQuery += "		SB1.B1_COD, SB1.B1_DESC, "
	cQuery += "		SHC.HC_PRODUTO, SHC.HC_DATA, SHC.HC_QUANT "+ CRLF
	cQuery += "FROM ESTRUT ""
	cQuery += "		INNER JOIN "+ RetSqlTab("SB1")+" "+ CRLF
	cQuery += "			ON 	"+ RetSqlDel("SB1") +" "
	cQuery += "				AND "+ RetSqlFil("SB1") +" "
	cQuery += "				AND SB1.B1_COD = COD_PAI "
	cQuery += "		INNER JOIN "+ RetSqlTab("SHC") +" "
	cQuery += "			ON 	"+ RetSqlDel("SHC") +" "
	cQuery += "				AND "+ RetSqlFil("SHC") +" "
	cQuery += "				AND SHC.HC_PRODUTO = CODIGO "+ CRLF
	cQuery += "				AND SHC.HC_DOC = '"+ cDoc +"' "+ CRLF
	cQuery += "WHERE "
	cQuery += "		COD_COMP = '"+ cResina +"' "
	cQuery += "		AND SUBSTRING(SHC.HC_DATA, 1, 6) BETWEEN '"+ cPeriodo +"' AND '"+ cPeriodo +"' "+ CRLF
	cQuery += "		AND SHC.HC_QUANT > 0 "
	cQuery += "ORDER BY "
	cQuery += "		SB1.B1_COD "		
		
	MemoWrite("\SQL\CalcResina.sql", cQuery)
		
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
		
	TcSetField(cAliasQry, "HC_DATA", "D", 08, 00)
		
	While !(cAliasQry)->(Eof())
		
		nConsumo += ((cAliasQry)->HC_QUANT * QtdEstrut((cAliasQry)->HC_PRODUTO, (cAliasQry)->B1_COD) * QuantResina((cAliasQry)->B1_COD, cResina))
		
		(cAliasQry)->(DbSkip())
		
	EndDo
	
	//nNecessidade := QtdNec(Abs(nConsumo), cResina)
	
Return nConsumo

Static Function QuantResina(cProduto, cResina)
	
	Local nQuant 	:= 0
	Local cQuery	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2J.Z2J_QUANT "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2J") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2J") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2J") +" "+ CRLF
	cQuery += "		AND Z2J.Z2J_PROD = '"+ cProduto +"' "+ CRLF
	cQuery += "		AND Z2J.Z2J_RESINA = '"+ cResina +"' "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\QuantResina.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof()) .And. (cAliasQry)->Z2J_QUANT > 0
		nQuant := (cAliasQry)->Z2J_QUANT
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return nQuant

Static Function PerdaResina(cProduto, cResina)
	
	Local nQuant 	:= 0
	Local cQuery	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2J.Z2J_PERDA "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2J") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2J") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2J") +" "+ CRLF
	cQuery += "		AND Z2J.Z2J_PROD = '"+ cProduto +"' "+ CRLF
	cQuery += "		AND Z2J.Z2J_RESINA = '"+ cResina +"' "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\PerdaResina.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof()) //.And. !Empty((cAliasQry)->Z2J_PERDA)
		nQuant := (cAliasQry)->Z2J_PERDA
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return nQuant

Static Function Resina(cResina)
	
	Local lResina 	:= .F.
	Local cQuery	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2J.Z2J_QUANT "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2J") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2J") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2J") +" "+ CRLF
	cQuery += "		AND Z2J.Z2J_RESINA = '"+ cResina +"' "
	cQuery += "		AND Z2J.Z2J_MSBLQL <> '1' "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\Resina.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof()) 
		lResina := .T.
	EndIf
	
	(cAliasQry)->(DbCloseArea())	
	
Return lResina

Static Function QtdEstrut(cCodPA, cCodPI)

	Local nQuant 	:= 1
	Local cQuery	:= ""
	Local cAliasQry	:= GetNextAlias()

	cQuery := "WITH ESTRUT(CODIGO, COD_PAI, COD_COMP, QUANTIDADE) AS "+ CRLF
	cQuery += "( "+ CRLF
	cQuery += "		SELECT "+ CRLF
	cQuery += "			SG1.G1_COD AS PAI, SG1.G1_COD, SG1.G1_COMP, G1_QUANT AS QUANTIDADE "+ CRLF
    cQuery += "		FROM "+ RetSqlTab("SG1") +" "+ CRLF
    cQuery += "		WHERE "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
    cQuery += "   		AND "+ RetSqlFil("SG1") +" "+ CRLF
	cQuery += "   		AND CONVERT(CHAR(10), GETDATE(), 112) BETWEEN SG1.G1_INI AND SG1.G1_FIM "+ CRLF
 	cQuery += "			AND SG1.G1_COD = '"+ cCodPA +"' "+ CRLF
    cQuery += "	"
	cQuery += " 	UNION ALL "+ CRLF
	cQuery += "	"+ CRLF
    cQuery += " 	SELECT "+ CRLF
	cQuery += "			CODIGO, SG1.G1_COD, SG1.G1_COMP, G1_QUANT * ESTRUT.QUANTIDADE "+ CRLF
    cQuery += " 	FROM "+ RetSqlTab("SG1") +" "+ CRLF
	cQuery += "			INNER JOIN ESTRUT "+ CRLF
    cQuery += "    			ON 	G1_COD = COD_COMP "+ CRLF
    cQuery += " 	WHERE "+ CRLF
	cQuery += "			"+ RetSqlDel("SG1") +" "+ CRLF
    cQuery += "   		AND "+ RetSqlFil("SG1") +" "+ CRLF
	cQuery += "  		AND CONVERT(CHAR(10), GETDATE(), 112) BETWEEN SG1.G1_INI AND SG1.G1_FIM "+ CRLF
	cQuery += ") "+ CRLF
	cQuery += "SELECT "+ CRLF
	cQuery += "		* "+ CRLF
	cQuery += "FROM "+ CRLF
	cQuery += "		ESTRUT "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		COD_COMP = '"+ cCodPI +"' "

	MemoWrite("\SQL\QtdEstrut.sql", cQuery)					//add Luciano Lamberti - 22-11-2022
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof()) 
		nQuant := (cAliasQry)->QUANTIDADE
	EndIf
	
	(cAliasQry)->(DbCloseArea())

Return nQuant
