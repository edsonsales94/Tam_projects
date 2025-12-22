#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} RELMRP2

Relatório Demanda de Compras

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		15/04/2019
@version 	Protheus 12 - PCP

/*/

User Function RELMRP2(cId)
	
	Local cPerg 	:= "RELMRP2"
	Local oReport	:= Nil
	
	Default cId := ""
	 
	Pergunte(cPerg, .F.)
	
	If !Empty(cId)
		MV_PAR01 := cId
	EndIf
	
	oReport:= ReportDef(cPerg)
	
	oReport:PrintDialog()

Return Nil

Static Function ReportDef(cPerg)

	Local cTitulo 	:= "Relatório Demanda Compras"
	Local cHelp		:= "Relatório Demanda Compras"
	Local oReport	:= Nil
	Local oCabec	:= Nil
	Local oProduct	:= Nil
		
	oReport := TReport():New("RELMRP2", cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cHelp)
	
	oReport:SetLandscape(.T.) 		
	oReport:HideFooter(.T.) 		
	oReport:HideParamPage(.T.) 			
	
	oReport:oPage:SetPaperSize(9) 	//Define o tamanho do papel - 9 (A4)

	oCabec := TRSection():New(oReport, "Fornecedor", "", {"Produto"})  
	
	oCabec:SetLineStyle()

	TRCell():New(oCabec, "FORNECEDOR", 	/*cAlias*/, "Fornecedor", 	PesqPict("SA2", "A2_COD"), 	  100)
				
	oProduct := TRSection():New(oReport, "Produto")
	
	TRCell():New(oProduct, "PRODUTO", 			/*cAlias*/, "Produto", 	 		PesqPict("SB1", "B1_COD"),  TamSX3("B1_COD")[1])
	TRCell():New(oProduct, "DESCRICAO", 		/*cAlias*/, "Descrição", 		PesqPict("SB1", "B1_DESC"), TamSX3("B1_DESC")[1])
	TRCell():New(oProduct, "LOTE_ECONOMICO", 	/*cAlias*/, "Lote Economico", 	PesqPict("SB1", "B1_LE"), 	TamSX3("B1_LE")[1])
			
Return oReport

Static Function ReportPrint(oReport)

	Local oCabec	:= oReport:Section(1)
	Local oProduct	:= oReport:Section(2)
	Local cAliasQry := ReportQuery()
	Local cNumPC	:= ""
	Local cPeriodo	:= ""
	Local nQtdReg	:= 0 
	Local nPeriodo	:= 0
	
	Count To nQtdReg
	
	oReport:SetMeter(nQtdReg)
	
	(cAliasQry)->(DbGoTop())
	
	If !(cAliasQry)->(Eof())
		
		//Adiciona coluna dos tipos de saldo selecionados
		For nPeriodo := 1 To (cAliasQry)->PERIODO

			TRCell():New(oProduct, "ESTOQUE"+ cValToChar(nPeriodo), /*cAlias*/, "", ;
				PesqPict("Z2B", "Z2B_ESTOQU"), TamSX3("Z2B_ESTOQU")[1] + 5, /*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
			
			TRCell():New(oProduct, "ENTRADA"+ cValToChar(nPeriodo), /*cAlias*/, "", ;
				PesqPict("Z2B", "Z2B_ENTRAD"), TamSX3("Z2B_ENTRAD")[1] + 5, /*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
			
			TRCell():New(oProduct, "CONSUMO"+ cValToChar(nPeriodo), /*cAlias*/, "", ;
				PesqPict("Z2B", "Z2B_CONSUM"), TamSX3("Z2B_CONSUM")[1] + 5, /*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
			
			TRCell():New(oProduct, "SALDO"+ cValToChar(nPeriodo), /*cAlias*/, "", ;
				PesqPict("Z2B", "Z2B_SALDO"), TamSX3("Z2B_SALDO")[1] + 5, /*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
			
			TRCell():New(oProduct, "NECESSIDADE"+ cValToChar(nPeriodo), /*cAlias*/, "", ;
				PesqPict("Z2B", "Z2B_NECESS"), TamSX3("Z2B_NECESS")[1]+ 5, /*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
			
			TRCell():New(oProduct, "DIAS_ESTOQUE"+ cValToChar(nPeriodo), /*cAlias*/, "", ;
				PesqPict("Z2B", "Z2B_DIASES"), TamSX3("Z2B_DIASES")[1] + 15, /*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
			
		Next nI
		
		TRCell():New(oProduct, "NUMPC", /*cAlias*/, "PC", PesqPict("Z2B", "Z2B_NUMPC"), 50)
				
		oCabec:Init()
		
		oCabec:Cell("FORNECEDOR"):SetValue((cAliasQry)->A2_COD +"/"+ (cAliasQry)->A2_LOJA +" - "+ AllTrim((cAliasQry)->A2_NREDUZ))
		
		oCabec:PrintLine()
		
		oProduct:Init()
		
		While !(cAliasQry)->(Eof())
			
			If oReport:Cancel()
				Exit
			EndIf
		
			oReport:IncMeter()
			
			cProduto := (cAliasQry)->B1_COD
			cNumPC	 := ""
			nPeriodo := 1
						
			oProduct:Cell("PRODUTO"):SetValue(AllTrim((cAliasQry)->B1_COD))
			oProduct:Cell("DESCRICAO"):SetValue(AllTrim((cAliasQry)->B1_DESC))
			oProduct:Cell("LOTE_ECONOMICO"):SetValue((cAliasQry)->B1_LE)
						
			While !(cAliasQry)->(Eof()) .And. cProduto == (cAliasQry)->B1_COD
				
				cPeriodo := Right((cAliasQry)->Z2B_PERIOD, 2) +"/"+ SubStr((cAliasQry)->Z2B_PERIOD, 3, 2)
				
				oProduct:Cell("ESTOQUE"+ cValToChar(nPeriodo)):SetTitle("Est. "+ cPeriodo)
				oProduct:Cell("ENTRADA"+ cValToChar(nPeriodo)):SetTitle("Ent. "+ cPeriodo)
				oProduct:Cell("CONSUMO"+ cValToChar(nPeriodo)):SetTitle("Cons. "+ cPeriodo)
				oProduct:Cell("SALDO"+ cValToChar(nPeriodo)):SetTitle("Sld. "+ cPeriodo)
				oProduct:Cell("NECESSIDADE"+ cValToChar(nPeriodo)):SetTitle("Nec. "+ cPeriodo)
				oProduct:Cell("DIAS_ESTOQUE"+ cValToChar(nPeriodo)):SetTitle("Dias Est. "+ cPeriodo)
								
				oProduct:Cell("ESTOQUE"+ cValToChar(nPeriodo)):SetValue((cAliasQry)->Z2B_ESTOQU)
				oProduct:Cell("ENTRADA"+ cValToChar(nPeriodo)):SetValue((cAliasQry)->Z2B_ENTRAD)
				oProduct:Cell("CONSUMO"+ cValToChar(nPeriodo)):SetValue((cAliasQry)->Z2B_CONSUM)
				oProduct:Cell("SALDO"+ cValToChar(nPeriodo)):SetValue((cAliasQry)->Z2B_SALDO)
				oProduct:Cell("NECESSIDADE"+ cValToChar(nPeriodo)):SetValue((cAliasQry)->Z2B_NECESS)
				oProduct:Cell("DIAS_ESTOQUE"+ cValToChar(nPeriodo)):SetValue((cAliasQry)->Z2B_DIASES)
				
				If !Empty((cAliasQry)->Z2B_NUMPC)
					cNumPC += AllTrim((cAliasQry)->Z2B_NUMPC) +", "
				EndIf
				
				nPeriodo++
				
				(cAliasQry)->(DbSkip())
				
			EndDo
			
			oProduct:Cell("NUMPC"):SetValue(cNumPC)
			
			oProduct:PrintLine()
			
		EndDo
		
		oProduct:Finish()
	
		oCabec:Finish()
				
	EndIf
	
	(cAliasQry)->(DbCloseArea()) 
	
Return Nil

Static Function ReportQuery()
	
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()

	cQuery := "SELECT "+ CRLF
	cQuery += "		Z2B.Z2B_FILIAL, Z2B.Z2B_CODIGO, Z2B.Z2B_PERIOD, Z2B.Z2B_NUMPC, Z2B.Z2B_ESTOQU, "+ CRLF
	cQuery += "		Z2B.Z2B_ENTRAD, Z2B.Z2B_CONSUM, Z2B.Z2B_SALDO, Z2B.Z2B_NECESS, Z2B.Z2B_DIASES, "+ CRLF
	cQuery += "		SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NREDUZ, "
	cQuery += "		SB1.B1_COD, SB1.B1_DESC, SB1.B1_LE, "+ CRLF
	cQuery += "		( "+ CRLF
	cQuery += "			SELECT TOP 1 "+ CRLF
	cQuery += "				COUNT(*) "+ CRLF
	cQuery += "			FROM "+ RetSqlTab("Z2B") +" "+ CRLF
	cQuery += "			WHERE "+ CRLF
	cQuery += "				"+ RetSqlDel("Z2B") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("Z2B") +" "+ CRLF
	cQuery += "				AND Z2B.Z2B_CODIGO = '"+ MV_PAR01 +"' "+ CRLF
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
	cQuery += "		AND Z2B.Z2B_CODIGO = '"+ MV_PAR01 +"' "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		Z2B.Z2B_PRODUT, Z2B.Z2B_PERIOD "
	cQuery := ChangeQuery(cQuery)
	
	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
Return cAliasQry
