#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"

user function relFluxo()
	Local oReport 	:= Nil
	Private cPerg 	:= "ZZRELFLUXO"
	Private aDatas	:= {}

	Pergunte(cPerg,.F.)
	oReport := RepDef()
	oReport:PrintDialog()
return

Static Function RepDef()

	Local oReport	:= Nil
	Local oPed		:= Nil
	Local oPick		:= Nil
	Local cTitulo	:= "Fluxo de Caixa"

	oReport := TReport():New("relFluxo",cTitulo,cPerg,{|oReport| RepPrint( oReport )},cTitulo)
    oReport:lParamPage  		:= .F.
    oReport:SetLandscape()

	oBancos := TRSection():New(oReport, "BANCO", {"TMP1"}, /*[Ordem]*/)
	oBancos:SetReadOnly()
	oBancos:AutoSize()
	TRCell():New(oBancos, "A6_NOME",		"TMP1", "BANCO", 			PesqPict("SA6", "A6_NOME"), 		TamSX3("A6_NOME")[1])

	oEntradas := TRSection():New(oBancos, "ENTRADAS", {"TMP1"}, /*[Ordem]*/)
	oEntradas:SetReadOnly()
	oEntradas:AutoSize()
	TRCell():New(oEntradas, "A6_NOME",		"TMP1", "ENTRADAS", 			PesqPict("SA6", "A6_NOME"), 		TamSX3("A6_NOME")[1])

	oSaidas := TRSection():New(oEntradas, "SAIDAS", {"TMP1"}, /*[Ordem]*/)
	oSaidas:SetReadOnly()
	oSaidas:AutoSize()
	TRCell():New(oSaidas, "A6_NOME",		"TMP1", "SAIDAS", 			PesqPict("SA6", "A6_NOME"), 		TamSX3("A6_NOME")[1])

	oTotais := TRSection():New(oSaidas, "TOTAL", {"TMP1"}, /*[Ordem]*/)
	oTotais:SetReadOnly()
	oTotais:AutoSize()
	TRCell():New(oTotais, "A6_NOME",		"TMP1", "TOTAL", 			PesqPict("SA6", "A6_NOME"), 		TamSX3("A6_NOME")[1])

Return oReport


Static Function RepPrint(oReport)
	Local nTotReg 		:= 0
	Local oBancos  		:= oReport:Section(1)
	Local oEntradas  	:= oReport:Section(1):Section(1)
	Local oSaidas	  	:= oReport:Section(1):Section(1):Section(1)
	Local oTotais	  	:= oReport:Section(1):Section(1):Section(1):Section(1)
	Local nSldAux		:= 0

	MsAguarde({ || nTotReg := ReportQry()}, "Aguarde", "Selecionado bancos")
	MsAguarde({ || retDatas()}, "Aguarde", "Selecionando periodos")

    oReport:SetMeter(nTotReg)
    For nH := 1 to len(aDatas)
    	TRCell():New(oBancos,dtoc(aDatas[nH][01]),,dtoc(aDatas[nH][01]), "@E 9,999,999.99", 12)
    Next

	TMP1->(dbGotop())
	oBancos:init()
	While TMP1->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
		For nH := 1 to len(aDatas)
			nSldAux := retSldBanco(dtos(aDatas[nH][01]-1),TMP1->A6_COD,TMP1->A6_NUMCON)
			aDatas[nH][02] += nSldAux
	    	oBancos:Cell(dtoc(aDatas[nH][01])):SetValue(nSldAux)
	    Next
		oBancos:PrintLine()
		TMP1->(dbSkip())
	EndDo
	oBancos:Cell("A6_NOME"):SetValue("Total Anterior")
	For nH := 1 to len(aDatas)
    	oBancos:Cell(dtoc(aDatas[nH][01])):SetValue(aDatas[nH][02])
    Next
    oBancos:PrintLine()
	oBancos:Finish()

	For nH := 1 to len(aDatas)
    	TRCell():New(oEntradas,dtoc(aDatas[nH][01]),,dtoc(aDatas[nH][01]), "@E 9,999,999.99", 12)
    Next

	TMP1->(dbGotop())
	oEntradas:init()
	While TMP1->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
		For nH := 1 to len(aDatas)
			nSldAux := retEntrada(dtos(aDatas[nH][01]),TMP1->A6_COD,TMP1->A6_NUMCON)
			aDatas[nH][03] += nSldAux
	    	oEntradas:Cell(dtoc(aDatas[nH][01])):SetValue(nSldAux)
	    Next
	    oEntradas:Cell("A6_NOME"):SetValue(TMP1->A6_NOME)
		oEntradas:PrintLine()
		TMP1->(dbSkip())
	EndDo
	oEntradas:Cell("A6_NOME"):SetValue("Total Entradas")
	For nH := 1 to len(aDatas)
    	oEntradas:Cell(dtoc(aDatas[nH][01])):SetValue(aDatas[nH][03])
    Next
    oEntradas:PrintLine()
	oEntradas:Finish()

	For nH := 1 to len(aDatas)
    	TRCell():New(oSaidas,dtoc(aDatas[nH][01]),,dtoc(aDatas[nH][01]), "@E 9,999,999.99", 12)
    Next

	TMP1->(dbGotop())
	oSaidas:init()
	While TMP1->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
		For nH := 1 to len(aDatas)
			nSldAux := retSaida(dtos(aDatas[nH][01]),TMP1->A6_COD,TMP1->A6_NUMCON)
			aDatas[nH][04] += nSldAux
	    	oSaidas:Cell(dtoc(aDatas[nH][01])):SetValue(nSldAux)
	    Next
	    oSaidas:Cell("A6_NOME"):SetValue(TMP1->A6_NOME)
		oSaidas:PrintLine()
		TMP1->(dbSkip())
	EndDo
	oSaidas:Cell("A6_NOME"):SetValue("Total Saidas")
	For nH := 1 to len(aDatas)
    	oSaidas:Cell(dtoc(aDatas[nH][01])):SetValue(aDatas[nH][04])
    Next
    oSaidas:PrintLine()
    oSaidas:Finish()

	For nH := 1 to len(aDatas)
    	TRCell():New(oTotais,dtoc(aDatas[nH][01]),,dtoc(aDatas[nH][01]), "@E 9,999,999.99", 12)
    Next

	TMP1->(dbGotop())
	oTotais:init()
	While TMP1->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
		For nH := 1 to len(aDatas)
			nSldAux := retSldBanco(dtos(aDatas[nH][01]-1),TMP1->A6_COD,TMP1->A6_NUMCON)
			nSldAux += retEntrada(dtos(aDatas[nH][01]),TMP1->A6_COD,TMP1->A6_NUMCON)
			nSldAux -= retSaida(dtos(aDatas[nH][01]),TMP1->A6_COD,TMP1->A6_NUMCON)
			aDatas[nH][05] += nSldAux
	    	oTotais:Cell(dtoc(aDatas[nH][01])):SetValue(nSldAux)
	    Next
	    oTotais:Cell("A6_NOME"):SetValue(TMP1->A6_NOME)
		oTotais:PrintLine()
		TMP1->(dbSkip())
	EndDo
	oTotais:Cell("A6_NOME"):SetValue("Total Final")
	For nH := 1 to len(aDatas)
    	oTotais:Cell(dtoc(aDatas[nH][01])):SetValue(aDatas[nH][05])
    Next
    oTotais:PrintLine()
	oTotais:Finish()

	TMP1->(dbCloseArea())
Return

Static Function ReportQry()
	Local cQuery	:= ""

	cQuery += " SELECT A6_NOME, A6_COD, A6_NUMCON   " + CRLF
	cQuery += " FROM "+RetSqlTab("SA6")+" WITH (NOLOCK)" + CRLF
	cQuery += " WHERE 1 = 1" + CRLF
	cQuery += " AND "+RetSqlDel("SA6")+"" + CRLF
	cQuery += " AND "+RetSqlFil("SA6")+"" + CRLF
	cQuery += " AND A6_FLUXCAI = 'S' " + CRLF
	cQuery += " ORDER BY A6_NOME " + CRLF

	MemoWrite("\SQL\relFluxo.SQL",cQuery)

	TcQuery cQuery NEW Alias "TMP1"
	Count to nTotReg

Return nTotReg

Static Function retDatas()
	Local nDias		:= DateDiffDay(MV_PAR01,MV_PAR02)
	Local dDtAtual	:= MV_PAR01
	aDatas := {}

	For nG := 1 to nDias
		aAdd(aDatas,{dDtAtual,0,0,0,0,0})
		dDtAtual := DaySum(dDtAtual,1)
	Next

Return

Static Function retSldBanco(cData,cBanco,cConta)
	Local nRet		:= 0
	Local cQuery	:= ""
	Local cQryAux	:= GetNextAlias()

	cQuery += " SELECT TOP 1 E8_SALATUA " + CRLF
	cQuery += " FROM "+RetSqlTab("SE8")+" " + CRLF
	cQuery += " WHERE 1 = 1 " + CRLF
	cQuery += " 	AND "+RetSqlDel("SE8")+" " + CRLF
	cQuery += " 	AND "+RetSqlFil("SE8")+" " + CRLF
	cQuery += " 	AND E8_BANCO = '"+cBanco+"' " + CRLF
	cQuery += " 	AND E8_CONTA = '"+cConta+"' " + CRLF
	cQuery += " 	AND E8_DTSALAT <= '"+cData+"' " + CRLF
	cQuery += " ORDER BY E8_DTSALAT DESC " + CRLF

	TcQuery cQuery NEW Alias &cQryAux

	(cQryAux)->(dbGotop())

	If (cQryAux)->(!Eof())
		nRet := (cQryAux)->E8_SALATUA
	EndIf
	(cQryAux)->(DbCloseArea())
Return nRet

Static Function retEntrada(cData,cBanco,cConta)
	Local nRet		:= 0
	Local cQuery	:= ""
	Local cQryAux	:= GetNextAlias()

	If stod(cData) < dDataBase
		cQuery += " SELECT SUM(E5_VALOR) AS VALOR " + CRLF
		cQuery += " FROM "+RetSqlTab("SE5")+" " + CRLF
		cQuery += " WHERE 1 = 1 " + CRLF
		cQuery += " 	AND "+RetSqlDel("SE5")+" " + CRLF
		cQuery += " 	AND "+RetSqlFil("SE5")+" " + CRLF
		cQuery += " 	AND E5_DTDISPO = '"+cData+"' " + CRLF
		cQuery += " 	AND E5_BANCO = '"+cBanco+"' " + CRLF
		cQuery += " 	AND E5_CONTA = '"+cConta+"' " + CRLF
		cQuery += " 	AND E5_TIPODOC NOT IN ('CM','MT','DC') " + CRLF
		cQuery += " 	AND E5_RECPAG = 'R' " + CRLF
	Else
		cQuery += " SELECT SUM(E1_SALDO - E1_COFINS - E1_PIS) AS VALOR " + CRLF
		cQuery += " FROM "+RetSqlTab("SE1")+" " + CRLF
		cQuery += " INNER JOIN "+RetSqlTab("SA1")+" ON 1 = 1 " + CRLF
		cQuery += " 	AND "+RetSqlDel("SA1")+" " + CRLF
		cQuery += " 	AND "+RetSqlFil("SA1")+" " + CRLF
		cQuery += " 	AND A1_COD = E1_CLIENTE " + CRLF
		cQuery += " 	AND A1_LOJA = E1_LOJA " + CRLF
		cQuery += " 	AND A1_BCO1 = '"+cBanco+"' " + CRLF
		cQuery += " WHERE 1 = 1 " + CRLF
		cQuery += " 	AND "+RetSqlDel("SE1")+" " + CRLF
		cQuery += " 	AND "+RetSqlFil("SE1")+" " + CRLF
		cQuery += " 	AND E1_VENCREA = '"+cData+"' " + CRLF
		cQuery += " 	AND E1_TIPO = 'NF' " + CRLF
	EndIf

	TcQuery cQuery NEW Alias &cQryAux

	(cQryAux)->(dbGotop())

	If (cQryAux)->(!Eof())
		nRet := (cQryAux)->VALOR
	EndIf
	(cQryAux)->(DbCloseArea())
Return nRet


Static Function retSaida(cData,cBanco,cConta)
	Local nRet		:= 0
	Local cQuery	:= ""
	Local cQryAux	:= GetNextAlias()

	If stod(cData) < dDataBase
		cQuery += " SELECT SUM(E5_VALOR) AS VALOR " + CRLF
		cQuery += " FROM "+RetSqlTab("SE5")+" " + CRLF
		cQuery += " WHERE 1 = 1 " + CRLF
		cQuery += " 	AND "+RetSqlDel("SE5")+" " + CRLF
		cQuery += " 	AND "+RetSqlFil("SE5")+" " + CRLF
		cQuery += " 	AND E5_DTDISPO = '"+cData+"' " + CRLF
		cQuery += " 	AND E5_BANCO = '"+cBanco+"' " + CRLF
		cQuery += " 	AND E5_CONTA = '"+cConta+"' " + CRLF
		cQuery += " 	AND E5_TIPODOC NOT IN ('CM','MT','DC') " + CRLF
		cQuery += " 	AND E5_RECPAG = 'P' " + CRLF
	Else
		cQuery += " SELECT SUM(E2_SALDO - E2_COFINS - E2_PIS) AS VALOR " + CRLF
		cQuery += " FROM "+RetSqlTab("SE2")+" " + CRLF
		cQuery += " INNER JOIN "+RetSqlTab("SA2")+" ON 1 = 1 " + CRLF
		cQuery += " 	AND "+RetSqlDel("SA2")+" " + CRLF
		cQuery += " 	AND "+RetSqlFil("SA2")+" " + CRLF
		cQuery += " 	AND A2_COD = E2_FORNECE " + CRLF
		cQuery += " 	AND A2_LOJA = E2_LOJA " + CRLF
		cQuery += " 	AND A2_BCO1 = '"+cBanco+"' " + CRLF
		cQuery += " WHERE 1 = 1 " + CRLF
		cQuery += " 	AND "+RetSqlDel("SE2")+" " + CRLF
		cQuery += " 	AND "+RetSqlFil("SE2")+" " + CRLF
		cQuery += " 	AND E2_VENCREA = '"+cData+"' " + CRLF
		cQuery += " 	AND E2_TIPO = 'NF' " + CRLF
	EndIf

	TcQuery cQuery NEW Alias &cQryAux

	(cQryAux)->(dbGotop())

	If (cQryAux)->(!Eof())
		nRet := (cQryAux)->VALOR
	EndIf
	(cQryAux)->(DbCloseArea())
Return nRet

/*
Static Function retAplica(cData,cBanco,cConta)
	Local nRet		:= 0
	Local cQuery	:= ""
	Local cQryAux	:= GetNextAlias()

Return nRet
*/