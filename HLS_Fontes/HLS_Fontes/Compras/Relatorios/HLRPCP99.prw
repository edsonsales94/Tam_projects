#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} HLRPCP05

Relatório Comparação Plano de Produção

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		15/04/2019
@version 	Protheus 12 - PCP

/*/

User Function HLRPCP99()

	Local cPerg 	:= "HLRPCP05"
	Local oReport	:= Nil

	Pergunte(cPerg, .F.)

	oReport:= ReportDef(cPerg)

	oReport:PrintDialog()

Return Nil

Static Function ReportDef(cPerg)

	Local cTitulo 	:= "Comparação Plano de Produção"
	Local cHelp		:= "Relatório Comparação Plano de Produção"
	Local oReport	:= Nil
	Local oProduct	:= Nil

	oReport := TReport():New("HLRPCP05", cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cHelp)

	oReport:SetLandscape(.T.)
	oReport:HideFooter(.T.)
	oReport:HideParamPage(.T.)

	oReport:oPage:SetPaperSize(9) 	//Define o tamanho do papel - 9 (A4)

	oProduct := TRSection():New(oReport, "Produto", "",  {"ID"})

	TRCell():New(oProduct, "PRODUTO", 	/*cAlias*/, "Produto", 	 	"@!", TamSX3("B1_COD")[1])
	TRCell():New(oProduct, "DESCRICAO", /*cAlias*/, "Descrição", 	"@!", TamSX3("B1_DESC")[1])
	TRCell():New(oProduct, "PLANO", 	/*cAlias*/, "Plano Prod.", 	"@!", TamSX3("HC_DOC")[1])

Return oReport

Static Function ReportPrint(oReport)

	Local aPeriodos	:= {}
	Local aProducao	:= {}
	Local cPlano01	:= AllTrim(MV_PAR01)
	Local cPlano02	:= AllTrim(MV_PAR02)
	Local nPeriodo	:= 0
	Local nItem		:= 0
	Local nClrFore	:= 0
	Local oProduct	:= oReport:Section(1)

	Processa({|| aPeriodos := Periodos(cPlano01, cPlano02)}, "Aguarde", "Carregando períodos", .T.)
	Processa({|| aProducao := PlanoProd(cPlano01, cPlano02, aPeriodos)}, "Aguarde", "Carregando produção", .T.)

	//Cria colunas no relatório
	For nPeriodo := 1 To Len(aPeriodos)
		TRCell():New(oProduct, 	"PERIODO"+ aPeriodos[nPeriodo], /*cAlias*/, SubStr(aPeriodos[nPeriodo], 5, 2) +"/"+ Left(aPeriodos[nPeriodo], 4), PesqPict("SHC", "HC_QUANT"), TamSX3("HC_QUANT")[1], /*Pixel*/, /*Block*/, /*Align*/, /*LineBreak*/, "RIGHT")
	Next nPeriodo

	oReport:SetMeter(Len(aProducao))

	If !Empty(aProducao)

		oProduct:Init()

		For nItem := 1 To Len(aProducao)

			If oReport:Cancel()
				Exit
			EndIf

			oReport:IncMeter()

			oProduct:Cell("PRODUTO"):SetValue(aProducao[nItem][1])
			oProduct:Cell("DESCRICAO"):SetValue(aProducao[nItem][2])
			oProduct:Cell("PLANO"):SetValue(aProducao[nItem][3])

			For nPeriodo := 1 To Len(aPeriodos)

				oProduct:Cell("PERIODO"+ aPeriodos[nPeriodo]):SetValue(aProducao[nItem][nPeriodo + 3])

				If aProducao[nItem][nPeriodo + 3] < 0
					nClrFore := 16711680
				Else
					nClrFore := 0
				EndIf

				oProduct:Cell("PERIODO"+ aPeriodos[nPeriodo]):SetClrFore(nClrFore)

			Next nPeriodo

			oProduct:PrintLine()

		Next nItem

		oProduct:Finish()

	EndIf

Return Nil

Static Function Periodos(cPlano01, cPlano02)

	Local aPeriodos	:= {}
	Local cQuery	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nQtdReg	:= 0

	cQuery := "SELECT "+ CRLF
	cQuery += "		SHC.HC_DATA "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SHC") +"  "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SHC") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SHC") +" "+ CRLF
	cQuery += "		AND SHC.HC_DOC IN ('"+ cPlano01 +"', '"+ cPlano02 +"') "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		SHC.HC_DATA "
	cQuery := ChangeQuery(cQuery)

	MemoWrite("\SQL\Periodos.sql", cQuery)

	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

	Count To nQtdReg

	ProcRegua(nQtdReg)

	(cAliasQry)->(DbGoTop())

	While !(cAliasQry)->(Eof())

		IncProc()

		aAdd(aPeriodos, (cAliasQry)->HC_DATA)

		(cAliasQry)->(DbSkip())

	EndDo

	(cAliasQry)->(DbCloseArea())

Return aPeriodos

Static Function PlanoProd(cPlano01, cPlano02, aPeriodos)

	Local aProducao	:= {}
	Local aProduto	:= {}
	Local cQuery 	:= ""
	Local cProduto	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nPeriodo	:= 0
	Local nQtdReg	:= 0
	Local nDif		:= 0
	Local nTotDif	:= 0

	cQuery := "SELECT "+ CRLF
	cQuery += "		SHC.HC_PRODUTO, SHC.HC_DOC, "+ CRLF
	cQuery += "		SB1.B1_DESC "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SHC") +" "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SB1") +" "+ CRLF
	cQuery += "			ON	"+ RetSqlDel("SB1") +" "+ CRLF
	cQuery += "				AND "+ RetSqlFil("SB1") +" "+ CRLF
	cQuery += "				AND SB1.B1_COD = SHC.HC_PRODUTO "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SHC") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SHC") +" "+ CRLF
	cQuery += "		AND SHC.HC_DOC IN ('"+ cPlano01 +"', '"+ cPlano02 +"') "+ CRLF
	cQuery += "GROUP BY "+ CRLF
	cQuery += "		SHC.HC_PRODUTO, SHC.HC_DOC, SB1.B1_DESC "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		SHC.HC_PRODUTO, SHC.HC_DOC "
	cQuery := ChangeQuery(cQuery)

	MemoWrite("\SQL\PlanoProd.sql", cQuery)

	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

	Count To nQtdReg

	ProcRegua(nQtdReg)

	(cAliasQry)->(DbGoTop())

	While !(cAliasQry)->(Eof())

		IncProc("Produto "+ AllTrim((cAliasQry)->HC_PRODUTO))

		aProduto := {}
		cProduto := AllTrim((cAliasQry)->HC_PRODUTO)

		aAdd(aProduto, AllTrim((cAliasQry)->HC_PRODUTO))
		aAdd(aProduto, AllTrim((cAliasQry)->B1_DESC))
		aAdd(aProduto, AllTrim((cAliasQry)->HC_DOC))

		For nPeriodo := 1 To Len(aPeriodos)
			aAdd(aProduto, Producao((cAliasQry)->HC_PRODUTO, (cAliasQry)->HC_DOC, aPeriodos[nPeriodo]))
		Next nPeriodo

		aAdd(aProducao, aProduto)

		(cAliasQry)->(DbSkip())

		//Diferença / Total
		If cProduto != AllTrim((cAliasQry)->HC_PRODUTO)

			//Diferença
			aProduto := {}
			nDif	 := 0
			nTotDif	 := 0

			aAdd(aProduto, "DIFERENÇA")
			aAdd(aProduto, Replicate("-", TamSX3("B1_DESC")[1]))
			aAdd(aProduto, Replicate("-", TamSX3("HC_DOC")[1]))

			For nPeriodo := 1 To Len(aPeriodos)

				nDif := aProducao[Len(aProducao) - 1][nPeriodo + 3] - aProducao[Len(aProducao)][nPeriodo + 3]

				aAdd(aProduto, nDif)

				If nPeriodo <= 6
					nTotDif += nDif
				EndIf

			Next nPeriodo

			aAdd(aProducao, aProduto)

			//Total da diferença
			aProduto := {}

			aAdd(aProduto, "TOTAL")
			aAdd(aProduto, Replicate("-", TamSX3("B1_DESC")[1]))
			aAdd(aProduto, Replicate("-", TamSX3("HC_DOC")[1]))

			For nPeriodo := 1 To Len(aPeriodos)
				aAdd(aProduto, nTotDif)
			Next nPeriodo

			aAdd(aProducao, aProduto)

		EndIf

	EndDo

	(cAliasQry)->(DbCloseArea())

Return aProducao

Static Function Producao(cProduto, cPlano, cPeriodo)

	Local cAliasQry	:= GetNextAlias()
	Local cQuery 	:= ""
	Local nProducao := 0

	cQuery := "SELECT "+ CRLF
	cQuery += "		SUM(SHC.HC_QUANT) AS QUANT "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SHC") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SHC") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SHC") +" "+ CRLF
	cQuery += "		AND SHC.HC_DATA = '"+ cPeriodo +"' "
	cQuery += "		AND SHC.HC_PRODUTO = '"+ cProduto +"' "
	cQuery += "		AND SHC.HC_DOC = '"+ cPlano +"' "
	cQuery := ChangeQuery(cQuery)

	MemoWrite("\SQL\Producao.sql", cQuery)

	MPSysOpenQuery( cQuery, cAliasQry ) // DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

	If !(cAliasQry)->(Eof())
		nProducao := (cAliasQry)->QUANT
	EndIf

	(cAliasQry)->(DbCloseArea())

Return nProducao
/*
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

	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)

	While !(cAliasQry)->(Eof())

		aAdd(aCalc, {(cAliasQry)->PERIODO, (cAliasQry)->VALOR})

		(cAliasQry)->(DbSkip())

	EndDo

	(cAliasQry)->(DbCloseArea())

Return aCalc
*/
