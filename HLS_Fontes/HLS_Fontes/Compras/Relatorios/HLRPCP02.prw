#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} HLRPCP02

Relatório Demanda de Compras

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		15/04/2019
@version 	Protheus 12 - PCP

/*/

User Function HLRPCP02(cId)
	
	Local cPerg 	:= "HLRPCP02"
	Local oReport	:= Nil
	
	Default cId := ""
	Default cId2 := ""
	 
	Pergunte(cPerg, .F.)
	
	If !Empty(cId)
		MV_PAR01 := cId
	EndIf

		If !Empty(cId2)
		MV_PAR02 := cId2
	EndIf
	
	oReport:= ReportDef(cPerg)
	
	oReport:PrintDialog()

Return Nil

Static Function ReportDef(cPerg)

	Local cTitulo 	:= "Demanda Compras"
	Local cHelp		:= "Relatório Demanda Compras"
	Local oReport	:= Nil
	Local oID		:= Nil
	Local oPO		:= Nil
	Local oProduct	:= Nil
	
	oReport := TReport():New("HLRPCP02", cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cHelp)
	
	oReport:SetLandscape(.T.) 		
	oReport:HideFooter(.T.) 		
	oReport:HideParamPage(.T.) 			
	
	oReport:oPage:SetPaperSize(9) 	//Define o tamanho do papel - 9 (A4)
	
	oID := TRSection():New(oReport, "Demanda", "",  {"ID"})  
	
	TRCell():New(oID, "ID_CALC", /*cAlias*/, "ID Calculo", "@!",  30)
	
	oPO := TRSection():New(oReport, "Pedido", "", {"PC"})  
	
	TRCell():New(oPO, "STATUS", /*cAlias*/, "", "@!",  30)
	
	oProduct := TRSection():New(oReport, "Produto", "", {"Produto"})  
	
	TRCell():New(oProduct, "PRODUTO", 		 	/*cAlias*/, "Produto", 	 		PesqPict("SB1", "B1_COD"),  TamSX3("B1_COD")[1])
	TRCell():New(oProduct, "DESCRICAO", 	 	/*cAlias*/, "Descrição", 		PesqPict("SB1", "B1_DESC"), TamSX3("B1_DESC")[1])
	TRCell():New(oProduct, "FORNECEDOR", 		/*cAlias*/, "Fornecedor", 		"@!", 						100)
	TRCell():New(oProduct, "LOTE_ECONOMICO", 	/*cAlias*/, "Lote Economico", 	PesqPict("SB1", "B1_LE"), 	TamSX3("B1_LE")[1])
	TRCell():New(oProduct, "STATUS", 			/*cAlias*/, "Status", 			"@!", 						30)
			
Return oReport

Static Function ReportPrint(oReport)
	
	Local aPeriodos	:= Periodos()
	Local aPedidos	:= Pedidos(aPeriodos[1], aPeriodos[Len(aPeriodos)])
	Local cAliasPrd := QueryPrd()
	Local cId		:= ""
	Local cProd 	:= ""
	Local cDesc 	:= ""
	Local cForn 	:= ""
	Local nPeriodo	:= 0
	Local nLotEco	:= 0
	Local oID		:= oReport:Section(1)
	Local oPO		:= oReport:Section(2)
	Local oProduct	:= oReport:Section(3)
		
	oReport:SetMeter(0)
	
	oReport:SetTitle(oReport:Title() +" ("+ AllTrim(MV_PAR01) +")")
	
	//ID Demanda Compras
	oID:Init()
	
	oID:Cell("ID_CALC"):SetValue(AllTrim(MV_PAR01))
	
	oID:PrintLine()
	
	oID:Finish()
		
	//Pedido de Compras
	If !Empty(aPedidos)
		
		//Cria colunas
		For nPeriodo := 1 To Len(aPedidos)
			TRCell():New(oPO, "PERIODO"+ cValToChar(nPeriodo), /*cAlias*/, Right(aPedidos[nPeriodo][8], 2) +"/"+ Left(aPedidos[nPeriodo][8], 4), "@!", 30)
		Next nPeriodo
		
		oPO:Init()
		
		PrintLinePO(oPO, aPedidos, 1, "Nº Pedido")	
		//PrintLinePO(oPO, aPedidos, 1, "Nº Pedido")
		PrintLinePO(oPO, aPedidos, 2, "Data Pedido")
		PrintLinePO(oPO, aPedidos, 3, "Nº Invoice")
		PrintLinePO(oPO, aPedidos, 4, "Nº Embarques")
		PrintLinePO(oPO, aPedidos, 5, "Data Embarque")
		PrintLinePO(oPO, aPedidos, 6, "Data Chegada (STS)")
		PrintLinePO(oPO, aPedidos, 7, "Data Chegada (HLS)")
		
		oPO:Finish()
		
	EndIf
	
	//MRP
	If !(cAliasPrd)->(Eof())
		
		//Cria colunas no relatório
		For nPeriodo := 1 To Len(aPeriodos)
	
			TRCell():New(oProduct, 	"PERIODO"+ aPeriodos[nPeriodo], /*cAlias*/, Right(aPeriodos[nPeriodo], 2) +"/"+ Left(aPeriodos[nPeriodo], 4), PesqPict("Z2B", "Z2B_ESTOQU"), TamSX3("Z2B_ESTOQU")[1] + 5, /*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
				
		Next nPeriodo
		
		oProduct:Init()

		While !(cAliasPrd)->(Eof())
			
			If oReport:Cancel()
				Exit
			EndIf
			
			cId		:= (cAliasPrd)->Z2B_CODIGO
			cProd 	:= AllTrim((cAliasPrd)->B1_COD)
			cDesc 	:= AllTrim((cAliasPrd)->B1_DESC)
			cForn 	:= (cAliasPrd)->A2_COD +"/"+ (cAliasPrd)->A2_LOJA +" - "+ AllTrim((cAliasPrd)->A2_NREDUZ)
			nLotEco	:= (cAliasPrd)->B1_LE
			
			PrintLineMRP(oProduct, cProd, 	cDesc, 	cForn, 	nLotEco, 	"Estoque", 		CalcNec(cId, cProd, "Z2B_ESTOQU"))
			PrintLineMRP(oProduct, "", 		"", 	"", 	0, 	 		"Entrada", 		CalcNec(cId, cProd, "Z2B_ENTRAD"))
			PrintLineMRP(oProduct, "", 		"", 	"", 	0, 	 		"Consumo", 		CalcNec(cId, cProd, "Z2B_CONSUM"))
			PrintLineMRP(oProduct, "", 		"", 	"", 	0, 	 		"Saldo", 		CalcNec(cId, cProd, "Z2B_SALDO"))
			PrintLineMRP(oProduct, "", 		"", 	"", 	0, 	 		"Necessidade",	CalcNec(cId, cProd, "Z2B_NECESS"))
			PrintLineMRP(oProduct, "", 		"", 	"", 	0, 	 		"Dias Est.", 	CalcNec(cId, cProd, "Z2B_DIASES"))

			(cAliasPrd)->(DbSkip())
					
		EndDo
		
		oProduct:Finish()
				
	EndIf
	
	(cAliasPrd)->(DbCloseArea()) 
	
Return Nil

Static Function QueryPrd()
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()

	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2B.Z2B_CODIGO, "+ CRLF
	cQuery += "		SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NREDUZ, "+ CRLF
	cQuery += "		SB1.B1_COD, SB1.B1_DESC, SB1.B1_LE "+ CRLF
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
//	cQuery += "		AND Z2B.Z2B_CODIGO = '"+ MV_PAR01 +"' "+ CRLF
	cQuery += "		AND Z2B.Z2B_CODIGO BETWEEN '"+ MV_PAR01 +"' AND  '"+ MV_PAR02 +"' "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		Z2B.Z2B_CODIGO, "+ CRLF
	cQuery += "		SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NREDUZ, "+ CRLF
	cQuery += "		SB1.B1_COD, SB1.B1_DESC, SB1.B1_LE "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		SB1.B1_COD "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\HLRPCP02_1.sql", cQuery)
	
    MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
Return cAliasQry

Static Function Pedidos(cPerIni, cPerFim)
	
	Local aPedido	:= {}
	Local aPedidos	:= {}
	Local cFornec	:= ""
	Local cLoja		:= ""
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2B.Z2B_FORNEC, Z2B.Z2B_LOJA "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2B") +" "+ CRLF  
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2B") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2B") +" "+ CRLF
	cQuery += "		AND Z2B.Z2B_CODIGO = '"+ MV_PAR01 +"' "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		Z2B.Z2B_FORNEC, Z2B.Z2B_LOJA "+ CRLF
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\HLRPCP02_5.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		
		cFornec := (cAliasQry)->Z2B_FORNEC
		cLoja	:= (cAliasQry)->Z2B_LOJA
		
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
	cAliasQry := GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SC7.C7_NUM, SC7.C7_EMISSAO, SUBSTRING(C7_ZZDTENT, 1, 6) AS PERIODO, "+ CRLF
	cQuery += "		ISNULL(Z0H.Z0H_REFPRO, '') AS Z0H_REFPRO, ISNULL(Z0H.Z0H_ETD, '') AS Z0H_ETD, "+ CRLF
	cQuery += "		ISNULL(Z0H.Z0H_ETA, '') AS Z0H_ETA "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SC7") +" "+ CRLF 
	cQuery += "		LEFT JOIN "+ RetSqlTab("Z0H") +" "+ CRLF
	cQuery += " 		ON	"+ RetSqlDel("Z0H") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("Z0H") +" "+ CRLF
	cQuery += "				AND Z0H.Z0H_PDBASE = SC7.C7_NUM "	
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SC7") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SC7") +" "+ CRLF
	cQuery += "		AND SC7.C7_FORNECE = '"+ cFornec +"' "+ CRLF
	cQuery += "		AND SC7.C7_LOJA = '"+ cLoja +"' "+ CRLF
	cQuery += "		AND SC7.C7_RESIDUO = '' "+ CRLF
	cQuery += "		AND SC7.C7_CONAPRO = 'L' "+ CRLF
	cQuery += "		AND SC7.C7_QUJE < SC7.C7_QUANT "+ CRLF
	cQuery += "		AND SUBSTRING(C7_ZZDTENT, 1, 6) BETWEEN '"+ cPerIni +"' AND '"+ cPerFim +"' "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		SC7.C7_NUM, SC7.C7_EMISSAO, SUBSTRING(C7_ZZDTENT, 1, 6), "+ CRLF
	cQuery += "		ISNULL(Z0H.Z0H_REFPRO, ''), ISNULL(Z0H.Z0H_ETD, ''), ISNULL(Z0H.Z0H_ETA, '') "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		SUBSTRING(C7_ZZDTENT, 1, 6) "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\HLRPCP02_4.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	TcSetField(cAliasQry, "C7_EMISSAO", "D", 08, 00)
	TcSetField(cAliasQry, "Z0H_ETD",    "D", 08, 00)
	TcSetField(cAliasQry, "Z0H_ETA",    "D", 08, 00)
	
	While !(cAliasQry)->(Eof())
		
		aPedido := {}
		
		aAdd(aPedido, (cAliasQry)->C7_NUM)
		aAdd(aPedido, DToC((cAliasQry)->C7_EMISSAO))
		aAdd(aPedido, AllTrim((cAliasQry)->Z0H_REFPRO))
		aAdd(aPedido, "1")
		aAdd(aPedido, If(!Empty((cAliasQry)->Z0H_ETD), DToC((cAliasQry)->Z0H_ETD), ""))
		aAdd(aPedido, If(!Empty((cAliasQry)->Z0H_ETA), DToC((cAliasQry)->Z0H_ETA), ""))
		aAdd(aPedido, If(!Empty((cAliasQry)->Z0H_ETA), DToC((cAliasQry)->Z0H_ETA + 15), ""))
		aAdd(aPedido, (cAliasQry)->PERIODO)
		
		aAdd(aPedidos, aPedido)
		
		(cAliasQry)->(DbSkip())
		
	EndDo
	
	(cAliasQry)->(DbCloseArea())
	
Return aPedidos

Static Function Periodos()
	
	Local aPeriodo 	:= {}
	Local cQuery	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2B.Z2B_PERIOD "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2B") +"  "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2B") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2B") +" "+ CRLF
	cQuery += "		AND Z2B.Z2B_CODIGO = '"+ MV_PAR01 +"' "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		Z2B.Z2B_PERIOD "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\HLRPCP02_2.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	While !(cAliasQry)->(Eof())
		
		aAdd(aPeriodo, (cAliasQry)->Z2B_PERIOD)
		
		(cAliasQry)->(DbSkip())
		
	EndDo
	
	(cAliasQry)->(DbCloseArea())
	
Return aPeriodo

Static Function PrintLinePO(oPO, aPedidos, nColuna, cStatus)
	
	Local nPeriodo := 0
	
	oPO:Cell("STATUS"):SetValue(cStatus)
		
	For nPeriodo := 1 To Len(aPedidos)
		oPO:Cell("PERIODO"+ cValToChar(nPeriodo)):SetValue(aPedidos[nPeriodo][nColuna])
	Next nPeriodo
				
	oPO:PrintLine()
	
Return Nil

Static Function PrintLineMRP(oProduct, cProd, cDesc, cForn, nLotEco, cStatus, aPeriodo)
	
	Local nPeriodo := 0
	
	oProduct:Cell("PRODUTO"):SetValue(cProd)
	oProduct:Cell("DESCRICAO"):SetValue(cDesc)
	oProduct:Cell("FORNECEDOR"):SetValue(cForn)
	oProduct:Cell("STATUS"):SetValue(cStatus)
	
	If nLotEco > 0
		oProduct:Cell("LOTE_ECONOMICO"):SetValue(nLotEco)
	//Else
	//	oProduct:Cell("LOTE_ECONOMICO"):Hide()
	EndIf
	
	For nPeriodo := 1 To Len(aPeriodo)
		oProduct:Cell("PERIODO"+ aPeriodo[nPeriodo][1]):SetValue(aPeriodo[nPeriodo][2])
	Next nPeriodo
				
	oProduct:PrintLine()
	
Return Nil

Static Function CalcNec(cId, cProd, cCampo)
	
	Local aCalc 	:= {}
	Local cQuery	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2B.Z2B_PERIOD AS PERIODO, Z2B."+ cCampo +" AS VALOR "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2B") +"  "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2B") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2B") +" "+ CRLF
	cQuery += "		AND Z2B.Z2B_CODIGO = '"+ cId +"' "+ CRLF
	cQuery += "		AND Z2B.Z2B_PRODUT = '"+ cProd +"' "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += " 	Z2B.Z2B_PERIOD "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\HLRPCP02_3.sql", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	While !(cAliasQry)->(Eof())

		aAdd(aCalc, {(cAliasQry)->PERIODO, (cAliasQry)->VALOR})
		
		(cAliasQry)->(DbSkip())
		
	EndDo
	
	(cAliasQry)->(DbCloseArea())	
	
Return aCalc
