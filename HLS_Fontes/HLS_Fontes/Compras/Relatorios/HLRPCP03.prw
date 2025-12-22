#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} RELFOREC

Relatório Forecast

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		27/05/2019
@version 	Protheus 12 - PCP

/*/

User Function HLRPCP03(cId, dDtBase)

	Local cPerg 	:= "RELFOREC"
	Local oReport	:= Nil
	
	Default cId 	:= ""
	Default dDtBase	:= CToD("//")
	
	Pergunte(cPerg, .F.)
	
	MV_PAR01 := cId
	MV_PAR02 := dDtBase
	
	oReport := ReportDef(cPerg)
	
	oReport:PrintDialog()
	
Return Nil

Static Function ReportDef(cPerg)

	Local cTitulo 	:= "Forecast"
	Local cHelp		:= "Relatório Forecast"
	Local oReport	:= Nil
	Local oProduct	:= Nil
		
	oReport := TReport():New("HPRPCP03", cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cHelp)
	
	oReport:SetLandscape(.T.) 		
	oReport:HideFooter(.T.) 		
	oReport:HideParamPage(.T.) 			
	
	oReport:oPage:SetPaperSize(9) 	//Define o tamanho do papel - 9 (A4)

	oProduct := TRSection():New(oReport, "Produtos", "", {"Produto"})  
		
	TRCell():New(oProduct, "PART_NUMBER", 		/*cAlias*/, "Part Number", 	 	PesqPict("SA5", "A5_CODPRF"),  	TamSX3("A5_CODPRF")[1])
	TRCell():New(oProduct, "PRODUTO", 			/*cAlias*/, "Produto", 	 		PesqPict("SB1", "B1_COD"),  	TamSX3("B1_COD")[1])
	TRCell():New(oProduct, "DESCRICAO", 		/*cAlias*/, "Descrição", 		PesqPict("SB1", "B1_DESC"), 	TamSX3("B1_DESC")[1])
	TRCell():New(oProduct, "MAKER_LOT", 		/*cAlias*/, "Lote Economico", 	PesqPict("SB1", "B1_LE"), 		TamSX3("B1_LE")[1], 	/*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
	TRCell():New(oProduct, "TOTAL_PC", 			/*cAlias*/, "Total PC", 		PesqPict("SC7", "C7_QUANT"), 	TamSX3("C7_QUANT")[1], 	/*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
	TRCell():New(oProduct, "TOTAL_M1", 			/*cAlias*/, "Total M1", 		PesqPict("SC7", "C7_QUANT"), 	TamSX3("C7_QUANT")[1], 	/*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
	TRCell():New(oProduct, "TOTAL_M2", 			/*cAlias*/, "Total M2", 		PesqPict("SC7", "C7_QUANT"), 	TamSX3("C7_QUANT")[1], 	/*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
			
Return oReport

Static Function ReportPrint(oReport)

	Local oProduct	:= oReport:Section(1)
	Local cAliasQry := ReportQuery()
	Local nQtdReg	:= 0 
	Local nPedido	:= 0
	Local nMrpM1	:= 0
	Local nMrpM2	:= 0
	
	Count To nQtdReg
	
	oReport:SetMeter(nQtdReg)
	
	oReport:SetTitle(oReport:Title() +" ("+ AllTrim(MV_PAR01) +")")
	
	(cAliasQry)->(DbGoTop())
	
	If !(cAliasQry)->(Eof())
		
		oProduct:Init()
		
		While !(cAliasQry)->(Eof())
			
			If oReport:Cancel()
				Exit
			EndIf
		
			oReport:IncMeter()
			
			nPedido := Pedido((cAliasQry)->A2_COD, (cAliasQry)->A2_LOJA, (cAliasQry)->B1_COD, MV_PAR02) 
			nMrpM1	:= Mrp((cAliasQry)->A2_COD, (cAliasQry)->A2_LOJA, (cAliasQry)->B1_COD, Left(DToS(MonthSum(MV_PAR02, 1)), 6))
			nMrpM2	:= Mrp((cAliasQry)->A2_COD, (cAliasQry)->A2_LOJA, (cAliasQry)->B1_COD, Left(DToS(MonthSum(MV_PAR02, 2)), 6))
			
			oProduct:Cell("TOTAL_PC"):SetTitle(MesExtenso(MV_PAR02))
			oProduct:Cell("TOTAL_M1"):SetTitle(MesExtenso(MonthSum(MV_PAR02, 1)))
			oProduct:Cell("TOTAL_M2"):SetTitle(MesExtenso(MonthSum(MV_PAR02, 2)))					
			oProduct:Cell("PRODUTO"):SetValue(AllTrim((cAliasQry)->B1_COD))
			oProduct:Cell("PART_NUMBER"):SetValue(AllTrim((cAliasQry)->A5_CODPRF))
			oProduct:Cell("DESCRICAO"):SetValue(AllTrim((cAliasQry)->B1_DESC))
			oProduct:Cell("MAKER_LOT"):SetValue((cAliasQry)->B1_LE)
			oProduct:Cell("TOTAL_PC"):SetValue(nPedido)
			oProduct:Cell("TOTAL_M1"):SetValue(nMrpM1)
			oProduct:Cell("TOTAL_M2"):SetValue(nMrpM2)
									
			oProduct:PrintLine()
			
			(cAliasQry)->(DbSkip())
			
		EndDo
		
		oProduct:Finish()
				
	EndIf
	
	(cAliasQry)->(DbCloseArea()) 
	
Return Nil

Static Function ReportQuery()
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()

	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2B.Z2B_FILIAL, Z2B.Z2B_CODIGO, "+ CRLF
	cQuery += "		SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NREDUZ, "+ CRLF
	cQuery += "		SB1.B1_COD, SB1.B1_DESC, SB1.B1_LE, "+ CRLF
	cQuery += "		ISNULL(SA5.A5_CODPRF, '') AS A5_CODPRF "+ CRLF
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
	cQuery += "		LEFT JOIN "+ RetSqlTab("SA5") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SA5") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SA5") +" "+ CRLF
	cQuery += "				AND SA5.A5_FORNECE = Z2B.Z2B_FORNEC "+ CRLF
	cQuery += "				AND SA5.A5_LOJA = Z2B.Z2B_LOJA "+ CRLF
	cQuery += "				AND SA5.A5_PRODUTO = Z2B.Z2B_PRODUT "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2B") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2B") +" "+ CRLF
	cQuery += "		AND Z2B.Z2B_CODIGO = '"+ MV_PAR01 +"' "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		Z2B.Z2B_FILIAL, Z2B.Z2B_CODIGO, "+ CRLF
	cQuery += "		SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NREDUZ, "+ CRLF
	cQuery += "		SB1.B1_COD, SB1.B1_DESC, SB1.B1_LE, "+ CRLF
	cQuery += "		ISNULL(SA5.A5_CODPRF, '') "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		SB1.B1_COD "
	cQuery := ChangeQuery(cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
Return cAliasQry

Static Function Pedido(cFornec, cLoja, cProd, dDtBase)
		
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nPedido 	:= 0
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SUM(C7_QUANT) AS QUANT "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SC7") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SC7") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SC7") +" "+ CRLF
	cQuery += "		AND SC7.C7_FORNECE = '"+ cFornec +"' "+ CRLF
	cQuery += "		AND SC7.C7_LOJA = '"+ cLoja +"' "+ CRLF
	cQuery += "		AND SC7.C7_PRODUTO = '"+ cProd +"' "+ CRLF
	cQuery += "		AND SC7.C7_ZZDTENT = '"+ Left(DToS(dDtBase), 6) +"01' "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\HRPCP03_2.SQL", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		nPedido := (cAliasQry)->QUANT
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return nPedido

Static Function Mrp(cFornec, cLoja, cProd, cDtBase)
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nMRP 		:= 0
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2B.Z2B_NECESS AS QUANT "+ CRLF
	cQuery += "FROM "+ RetSqlTab("Z2B") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("Z2B") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("Z2B") +" "+ CRLF
	cQuery += "		AND Z2B.Z2B_FORNEC = '"+ cFornec +"' "+ CRLF
	cQuery += "		AND Z2B.Z2B_LOJA = '"+ cLoja +"' "+ CRLF
	cQuery += "		AND Z2B.Z2B_PRODUT = '"+ cProd +"' "+ CRLF
	cQuery += "		AND Z2B.Z2B_PERIOD = '"+ cDtBase +"'"+ CRLF
	cQuery += "		AND Z2B.Z2B_STATUS = 'A' "
	cQuery := ChangeQuery(cQuery)
	
	MemoWrite("\SQL\HRPCP03_3.SQL", cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		nMRP := (cAliasQry)->QUANT
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return nMRP
