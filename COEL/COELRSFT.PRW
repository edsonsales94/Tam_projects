#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function COELRSFT()
	Local oReport
	Local aArea    := FWGetArea()
	Local aPergs   := {}
	Local _cFilDe  := ''
	Local _cFilAte := ''
	Local cDocDe   := Space(TamSX3("F2_DOC")[01])
	Local cDocAte  := Space(TamSX3("F2_DOC")[01])
	Local cSerDe   := Space(TamSX3("F2_SERIE")[01])
	Local cSerAte  := Space(TamSX3("F2_SERIE")[01])
	Local dDataDe  := FirstDate(Date())
	Local dDataAt  := LastDate(Date())
	// Local nOrden   := 1
	_cFilDe := '01'
	_cFilAte :='01'
	cDocAte := 'ZZZZZZZZZ'
	cSerAte := 'ZZZ'

	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Filial De",  _cFilDe,   "", ".T.", "SFT", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Filial Até", _cFilAte,  "", ".T.", "SFT", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Data De",    dDataDe,   "", ".T.", "", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Data Até",   dDataAt,   "", ".T.", "", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Nota De",    cDocDe,    "", ".T.", "SFT", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Nota Até",   cDocAte,   "", ".T.", "SFT", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Serie De",   cSerDe,    "", ".T.", "SFT", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Serie Até",  cSerAte,   "", ".T.", "SFT", ".T.", 80,  .T.})
	//Se a pergunta for confirma, cria as definicoes do relatorio
	If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
		// MV_PAR05 := Val(cValToChar(MV_PAR05))
		oReport := fReportDef()
		oReport:PrintDialog()
	EndIf

	FWRestArea(aArea)
Return

Static Function fReportDef()
	Local oReport
	Local oSection := Nil

	//Criacao do componente de impressao
	oReport := TReport():New( "zRel02",;
		"Relatório de Produto",;
		,;
		{|oReport| fRepPrint(oReport),};
		)
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9)

	//Orientacao do Relatorio
	// oReport:SetPortrait()
	oReport:SetLandscape()

	//Definicoes da fonte utilizada
	oReport:SetLineHeight(50)
	oReport:nFontBody := 12

	//Criando a secao de dados
	oSection := TRSection():New( oReport,;
		"Dados",;
		{"QRY_REP"})
	oSection:SetTotalInLine(.F.)
	//  SELECT FT_FILIAL, FT_ENTRADA, FT_CFOP, FT_PRCUNIT, FT_TOTAL, FT_VALIPI, FT_VALICM,
	//  FT_FRETE, FT_BASEPIS, FT_BASECOF, FT_ALIQPIS, FT_ALIQCOF, FT_VALPIS, FT_VALCOF "
	// 	Colunas do relatorio
	TRCell():New(oSection, "FT_FILIAL",   "QRY_REP", "Filial",     /*cPicture*/, 20, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection, "FT_NFISCAL",   "QRY_REP","Nota Fiscal",     /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection, "FT_ENTRADA",  "QRY_REP", "Dt. Emissao",  /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_CFOP",     "QRY_REP", "CFOP",       /*cPicture*/, 20, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_CSTPIS",   "QRY_REP", "CST",       /*cPicture*/, 20, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_PRCUNIT",  "QRY_REP", "Prc. Unit", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_TOTAL",    "QRY_REP", "Total", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_VALIPI",   "QRY_REP", "Vlr IPI", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_VALICM",   "QRY_REP", "Vlr ICMS", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_ICMSRET",   "QRY_REP", "ICMS/ST", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_FRETE",    "QRY_REP", "Frete", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_BASEPIS",  "QRY_REP", "Base PIS", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_BASECOF",  "QRY_REP", "Base COFINS", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_ALIQPIS",  "QRY_REP", "Aliq. PIS", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_ALIQCOF",  "QRY_REP", "Aliq. COFINS", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_VALPIS",   "QRY_REP", "Vlr. PIS", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "FT_VALCOF",   "QRY_REP", "Vlr. COFINS", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)

	//Quebras do relatorio
	// oBreak := TRBreak():New(oSection, oSection:Cell("B1_TIPO"), {||"Total da Quebra"}, .F.)

	//Totalizadores
	// TRFunction():New(oSection:Cell("B1_COD"), , "COUNT", , , "@E 999,999,999", , .F.)

Return oReport

Static Function fRepPrint(oReport)
	Local aArea    := FWGetArea()
	Local cQryReport  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0

	//Pegando as secoes do relatorio
	oSectDad := oReport:Section(1)

	//Montando consulta de dados

	cQryReport += " SELECT FT_FILIAL,FT_NFISCAL, FT_ENTRADA, FT_CFOP,FT_CSTPIS,FT_PRCUNIT, FT_TOTAL, FT_VALIPI, FT_VALICM,FT_ICMSRET "        + CRLF
	cQryReport += " FT_FRETE, FT_BASEPIS, FT_BASECOF, FT_ALIQPIS, FT_ALIQCOF, FT_VALPIS, FT_VALCOF "        + CRLF
	cQryReport += " FROM "        + CRLF
	cQryReport += "    " + RetSQLName("SFT") + " SFT (NOLOCK)"        + CRLF
	cQryReport += " WHERE SFT.D_E_L_E_T_ = ''  AND FT_FILIAL BETWEEN '"+MV_PAR01 +"' AND '" +MV_PAR02 +"'"+ CRLF
	cQryReport += " AND FT_ENTRADA BETWEEN '" + DTOS(MV_PAR03)+ "' AND '" + DTOS(MV_PAR04) + "'" + CRLF
	cQryReport += " AND FT_NFISCAL BETWEEN '"+MV_PAR05 +"' AND '" +MV_PAR06 +"'"+ CRLF
	cQryReport += " AND FT_SERIE BETWEEN '"+MV_PAR07 +"' AND '" +MV_PAR08 +"'"+ CRLF
	cQryReport += " AND FT_BASECOF > 0 AND FT_DTCANC ='' " + CRLF
	cQryReport += " ORDER BY FT_FILIAL,FT_CFOP, FT_ENTRADA " + CRLF

	//Executando consulta e setando o total da regua
	PlsQuery(cQryReport, "QRY_REP")
	DbSelectArea("QRY_REP")

	Count to nTotal
	oReport:SetMeter(nTotal)

	//Enquanto houver dados
	oSectDad:Init()
	QRY_REP->(DbGoTop())
	While ! QRY_REP->(Eof())

		//Incrementando a regua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
		oReport:IncMeter()

		//Imprimindo a linha atual
		oSectDad:PrintLine()

		QRY_REP->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_REP->(DbCloseArea())

	FWRestArea(aArea)
Return
