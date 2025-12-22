//Bibliotecas
#Include "TOTVS.ch"

/*/AAFATR22
Classes para montagem de um relatório com listagem de informações
@author Edson Sales
/*/

User Function AAFATR22()
	Local aArea := FWGetArea()
	Local oReport
	Local aPergs   := {}
	Local cFilialDe  := Space(TamSX3('L1_FILIAL')[1])
	Local cFilialAte := StrTran(cFilialDe, ' ', 'Z')
	Local dDataDe  := FirstDate(Date())
	Local dDataAte := LastDate(Date())

	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Filial De",  cFilialDe,  "", ".T.", "SL1", ".T.", 80,  .F.}) // MV_PAR01
	aAdd(aPergs, {1, "Filial Até", cFilialAte, "", ".T.", "SL1", ".T.", 80,  .T.}) // MV_PAR02
	aAdd(aPergs, {1, "Data De",    dDataDe,  "", ".T." , "SL1", ".T.", 40,  .F.}) // MV_PAR03
	aAdd(aPergs, {1, "Data Até",   dDataAte, "", ".T." , "SL1", ".T.", 40,  .T.}) // MV_PAR04

	//Se a pergunta for confirma, cria as definicoes do relatorio
	If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)
		oReport := fReportDef()
		oReport:PrintDialog()
	EndIf

	FWRestArea(aArea)
Return

Static Function fReportDef()
	Local oReport
	Local oSection := Nil

	//Criacao do componente de impressao
	oReport := TReport():New( "AAFATR22",;
		"Relatorio de vendas, CD Entrega / Cliente Retira / Canais de Vendas",;
		,;
		{|oReport| fRepPrint(oReport),};
		)
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9)
	//Orientacao do Relatorio
	oReport:SetLandscape()
    oReport:SetBorder( "ALL",  , , .T. )

	//Definicoes da fonte utilizada
	oReport:SetLineHeight(50)
	oReport:nFontBody := 12

	//Criando a secao de dados
	oSection := TRSection():New( oReport,"Relatorio de vendas, CD Entrega / Cliente Retira / Canais de Vendas",	{"QRY_REP"})
    oSection:SetBorder(5,3,,.T.)
	oSection:SetTotalInLine(.F.)

	//Colunas do relatorio
	TRCell():New(oSection, "GRUPO",          "QRY_REP", "Empresa",     /*cPicture*/, 60, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection, "FILIAL",         "QRY_REP", "Filial",  /*cPicture*/, 70, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "VALOR_TOTAL",    "QRY_REP", "Valor Total",       /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "CD_ENTREGA",     "QRY_REP", "Cd Entrega", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "CLIENTE_RETIRA", "QRY_REP", "Cliente Retira", /*cPicture*/, 50, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "PRESENCIAL",     "QRY_REP", "Presencial", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "WHATSAPP",       "QRY_REP", "WhatsApp", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "EMAIL",          "QRY_REP", "EMail", /*cPicture*/, 30, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "REDE_SOCIAL",    "QRY_REP", "Rede Social", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection, "GOOGLE",         "QRY_REP", "Google", /*cPicture*/, 35, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)

	//Quebras do relatorio
	// oBreak := TRBreak():New(oSection, oSection:Cell("B1_TIPO"), {||"Total da Quebra"}, .F.)

	//Totalizadores
	// TRFunction():New(oSection:Cell("B1_COD"), , "COUNT", , , "@E 999,999,999", , .F.)

Return oReport

Static Function fRepPrint(oReport)
	Local aArea    := FWGetArea()
	Local cQryReport  := ""
	Local oSection := oReport:Section(1)
	Local nAtual   := 0
	Local nTotal   := 0

	oSection:Init()
	oSection:SetHeaderSection(.T.)
	//Pegando as secoes do relatorio
	// oSectDad := oReport:Section(1)

    cQryReport +=" SELECT GRUPO,     "
    cQryReport +="        FILIAL,   "
    cQryReport +="        SUM(ISNULL([VALOR TOTAL],0)) [VALOR_TOTAL],   "
    cQryReport +="        ROUND(SUM(ISNULL([CD ENTREGA],0    ))*100/(SUM([VALOR TOTAL])),2) [CD_ENTREGA],   "
    cQryReport +="        ROUND(SUM(ISNULL([CLIENTE RETIRA],0))*100/(SUM([VALOR TOTAL])),2) [CLIENTE_RETIRA],   "
    cQryReport +="        ROUND(SUM(ISNULL(P,0))*100/(SUM([VALOR TOTAL])),2) PRESENCIAL,    "
    cQryReport +="        ROUND(SUM(ISNULL(W,0))*100/(SUM([VALOR TOTAL])),2) WHATSAPP,  "
    cQryReport +="        ROUND(SUM(ISNULL(E,0))*100/(SUM([VALOR TOTAL])),2) EMAIL,     "
    cQryReport +="        ROUND(SUM(ISNULL(T,0))*100/(SUM([VALOR TOTAL])),2) TELEFONE,  "
    cQryReport +="        ROUND(SUM(ISNULL(R,0))*100/(SUM([VALOR TOTAL])),2) [REDE_SOCIAL],     "
    cQryReport +="        ROUND(SUM(ISNULL(G,0))*100/(SUM([VALOR TOTAL])),2) GOOGLE     "
    cQryReport +="        FROM (    "
    cQryReport +="        select '01 - INDUSTRIA' GRUPO,    "
    cQryReport +="               CASE  "
    cQryReport +="                   when L1_FILIAL = '02' THEN '02 - REDIRECIONADO'   "
    cQryReport +="                   when L1_FILIAL = '03' THEN '03 - INDUSTRIA SILVES'    "
    cQryReport +="                   when L1_FILIAL = '04' THEN '04 - INDUSTRIA ALVORADA'  "
    cQryReport +="                   when L1_FILIAL = '10' THEN '10 - INDUSTRIA TIMBIRA'   "
    cQryReport +="               END FILIAL,   "
    cQryReport +="               IIF(L1_XENTDEP='S','CD ENTREGA','CLIENTE RETIRA') L1_XENTDEP,     "
    cQryReport +="               SUM(L1_VLRTOT) [VALOR TOTAL],     "
    cQryReport +="               SUM(L1_VLRTOT) [TOTAL],   "
    cQryReport +="               SUM(L1_VLRTOT) VALOR,     "
    cQryReport +="               IIF( L1_XATENDE=''  ,'P', L1_XATENDE) CANAL   "
    cQryReport +="         from SL1010   "
    cQryReport +="         where D_E_L_E_T_='' AND L1_FILIAL BETWEEN '" + MV_PAR01 + "'  AND '" + MV_PAR02 + "' " 
    cQryReport +="               AND L1_EMISSAO BETWEEN '" +DtoS(MV_PAR03) + "'  AND '" +DtoS(MV_PAR04) + "' " 
    cQryReport +="               AND L1_OPERADO!=''  AND L1_FILIAL != '01'  "
    cQryReport +="               GROUP BY L1_FILIAL,L1_XENTDEP,L1_XATENDE  "
    cQryReport +="    UNION ALL     "
    cQryReport +="        select '06 - COMERCIO' GRUPO,     "
    cQryReport +="                CASE  "
    cQryReport +="                    when L1_FILIAL = '01' THEN '01 - COMERCIO ALVORADA'   "
    cQryReport +="                    when L1_FILIAL = '03' THEN '03 - COMERCIO CD ENTREGA'     "
    cQryReport +="                    when L1_FILIAL = '04' THEN '04 - COMERCIO SILVES'     "
    cQryReport +="                    when L1_FILIAL = '05' THEN '05 - COMERCIO TIMBIRAS'   "
    cQryReport +="                END,  "
    cQryReport +="                IIF(L1_XENTDEP='S','CD ENTREGA','CLIENTE RETIRA') L1_XENTDEP,     "
    cQryReport +="                SUM(L1_VLRTOT) [VALOR TOTAL],     "
    cQryReport +="                SUM(L1_VLRTOT) [TOTAL],   "
    cQryReport +="                SUM(L1_VLRTOT) VALOR,     "
    cQryReport +="                IIF( L1_XATENDE=''  ,'P', L1_XATENDE) CANAL   "
    cQryReport +="         from SL1060   "
    cQryReport +="         where D_E_L_E_T_='' AND L1_FILIAL BETWEEN '" + MV_PAR01 + "'  AND '" + MV_PAR02 +  "'" 
    cQryReport +="               AND L1_EMISSAO BETWEEN '" +DtoS(MV_PAR03) + "'  AND '" +DtoS(MV_PAR04) + "' "
    cQryReport +="               AND L1_OPERADO!=''     "
    cQryReport +="       GROUP BY L1_FILIAL,L1_XENTDEP,L1_XATENDE  "
    cQryReport +="    ) AS T    "
    cQryReport +="    PIVOT (   "
    cQryReport +="      SUM(T.VALOR) FOR T.CANAL in (P,W,E,T,R,G)     "
    cQryReport +="    ) AS PVT1     "
    cQryReport +="    PIVOT (   "
    cQryReport +="      SUM([TOTAL]) FOR L1_XENTDEP in ([CD ENTREGA],[CLIENTE RETIRA])    "
    cQryReport +="    ) AS PVT2     "
    cQryReport +="    GROUP BY GRUPO,   "
    cQryReport +="    FILIAL    "
    cQryReport +="    HAVING FILIAL <>''    "
    cQryReport +="    ORDER BY GRUPO,FILIAL     "

//Executando consulta e setando o total da regua
PlsQuery(cQryReport, "QRY_REP")
DbSelectArea("QRY_REP")
Count to nTotal
oReport:SetMeter(nTotal)

//Enquanto houver dados
// oSectDad:Init()
QRY_REP->(DbGoTop())
While ! QRY_REP->(Eof())

	//Incrementando a regua
	nAtual++
	oReport:SetMsgPrint("Imprimindo registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
	oReport:IncMeter()

	// //Imprimindo a linha atual
	// oSectDad:PrintLine()
    
    oSection:Cell("GRUPO"):SetBlock(	        {|| QRY_REP->GRUPO                            }):SetBorder(5,3,,.T.)
    oSection:Cell("FILIAL"):SetBlock(	        {|| QRY_REP->FILIAL                           }):SetBorder(5,3,,.T.)
    oSection:Cell("VALOR_TOTAL"):SetBlock(	    {|| "R$  " + cValtoChar(QRY_REP->VALOR_TOTAL) }):SetBorder(5,3,,.T.)
    oSection:Cell("CD_ENTREGA"):SetBlock(	    {|| cValtoChar(QRY_REP->CD_ENTREGA)     +" %" }):SetBorder(5,3,,.T.)
    oSection:Cell("CLIENTE_RETIRA"):SetBlock(	{|| cValtoChar(QRY_REP->CLIENTE_RETIRA) +" %" }):SetBorder(5,3,,.T.)
    oSection:Cell("PRESENCIAL"):SetBlock(	    {|| cValtoChar(QRY_REP->PRESENCIAL)     +" %" }):SetBorder(5,3,,.T.)
    oSection:Cell("WHATSAPP"):SetBlock(	        {|| cValtoChar(QRY_REP->WHATSAPP)       +" %" }):SetBorder(5,3,,.T.)
    oSection:Cell("EMAIL"):SetBlock(	        {|| cValtoChar(QRY_REP->EMAIL)          +" %" }):SetBorder(5,3,,.T.)
    oSection:Cell("REDE_SOCIAL"):SetBlock(	    {|| cValtoChar(QRY_REP->REDE_SOCIAL)    +" %" }):SetBorder(5,3,,.T.)
    oSection:Cell("GOOGLE"):SetBlock(	        {|| cValtoChar(QRY_REP->GOOGLE)         +" %" }):SetBorder(5,3,,.T.)
    oSection:PrintLine()
	QRY_REP->(DbSkip())
EndDo
oSection:Finish()
QRY_REP->(DbCloseArea())

FWRestArea(aArea)
Return
