
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR015  ³ Autor ³ Alexandre Inacio Lemes³ Data ³22/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o entre NFs Originais X NFs Frete/Importa‡„o.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR015(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function CMPROR01()

	Local oReport
	Local aArea    := FWGetArea()
	Private cPerg :='CMPROR01'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// CriaSx1()
	IF Pergunte(cPerg,.T.)
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
	FWRestArea(aArea)
Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ReportDef ³Autor  ³Alexandre Inacio Lemes ³Data  ³22/05/2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Rela‡„o entre NFs Originais X NFs Frete/Importa‡„o.        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
	Local oReport
	Local oSection1
	Local cAlias := GetNextAlias()
	Local aArea    := FWGetArea()
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oReport := TReport():New(cPerg,"Ordens de Produção",cPerg, {|oReport| ReportPrint(oReport,cAlias)},"Este relatorio ira imprimir a relação de ordens de produção ano a ano.")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetTotalInLine(.F.)
	oReport:oPage:SetPaperSize(9)
	oReport:SetLandscape()
	oReport:SetLineHeight(50)
	oReport:nFontBody := 12

	oSection1 := TRSection():New(oReport,'Ordens de Produção',cAlias,,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
	TRCell():New(oSection1, "D3_FILIAL",   	"QRY_REP", "Filial",     /*cPicture*/, 20, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "B1_CLCFAM",   		"QRY_REP","Familia",     /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "B1_CLDFAM",  	"QRY_REP", "Desc. familia",  /*cPicture*/, 100, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "JANEIRO",     	"QRY_REP", "Janeiro",       /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "FEVEREIRO",   	"QRY_REP", "Fevereiro",       /*cPicture*/, 45, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "MARCO",  		"QRY_REP", "Marco", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "ABRIL",    		"QRY_REP", "Abril", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "MAIO",   		"QRY_REP", "Maio", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "JUNHO",   		"QRY_REP", "Junho", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "JULHO",   		"QRY_REP", "Julho", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "AGOSTO",    	"QRY_REP", "Agosto", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "SETEMBRO",  	"QRY_REP", "Setembro", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "OUTUBRO",  		"QRY_REP", "Outubro", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NOVEMBRO",  	"QRY_REP", "Novembro", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "DEZEMBRO",  	"QRY_REP", "Dezembro", /*cPicture*/, 40, /*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)

	oSection1:SetHeaderPage()

	FWRestArea(aArea)
Return(oReport)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ReportPrin³Autor  ³Alexandre Inacio Lemes ³Data  ³19/05/2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Imprime o Relatorio definido pela funcao ReportDef MATR190. ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAlias)

	Local oSection1 := oReport:Section(1)
	Local cQryReport := ''
	Local nTotal := 0
	Local nAtual := 0
	Local aArea    := FWGetArea()

	oSection1:Init()
	oSection1:SetHeaderSection(.T.)

	cQryReport += "  SELECT D3_FILIAL,B1_CLCFAM,B1_CLDFAM,   "
	cQryReport += "  ISNULL(["+MV_PAR03+"01],0) JANEIRO, 	ISNULL(["+MV_PAR03+"02],0) FEVEREIRO,  "
	cQryReport += "  ISNULL(["+MV_PAR03+"03],0) MARCO, 		ISNULL(["+MV_PAR03+"04],0) ABRIL,  "
	cQryReport += "  ISNULL(["+MV_PAR03+"05],0) MAIO, 		ISNULL(["+MV_PAR03+"06],0) JUNHO,  "
	cQryReport += "  ISNULL(["+MV_PAR03+"07],0) JULHO, 		ISNULL(["+MV_PAR03+"08],0) AGOSTO,  "
	cQryReport += "  ISNULL(["+MV_PAR03+"09],0) SETEMBRO, 	ISNULL(["+MV_PAR03+"10],0) OUTUBRO,  "
	cQryReport += "  ISNULL(["+MV_PAR03+"11],0) NOVEMBRO, 	ISNULL(["+MV_PAR03+"12],0) DEZEMBRO  "
	cQryReport += "  FROM (  "
	cQryReport += "  SELECT D3_FILIAL, B1_CLCFAM,B1_CLDFAM, SUM (D3_QUANT) D3_QUANT, LEFT(D3_EMISSAO,6) D3_MESANO 
	cQryReport += "  FROM "+ RetSQLName('SD3') +" SD3 (NOLOCK) "
	cQryReport += "  INNER JOIN "+ RetSQLName('SB1') +" SB1 (NOLOCK) ON SB1.D_E_L_E_T_ = '' AND D3_COD =B1_COD"
	cQryReport += "  WHERE D3_EMISSAO BETWEEN '"+MV_PAR03+"0101' AND '"+MV_PAR03+"1231' "
	cQryReport += "  AND D3_ESTORNO = '' "
	cQryReport += "  AND D3_CF = 'PR0' "
	cQryReport += "  AND D3_FILIAL BETWEEN '"+ MV_PAR01 +"' AND '"+MV_PAR02 +"' "
	cQryReport += "  AND SD3.D_E_L_E_T_ = '' AND B1_CLCFAM BETWEEN '"+ MV_PAR04 +"' AND '"+MV_PAR05 +"' "
	cQryReport += "  GROUP BY D3_FILIAL, B1_CLCFAM, LEFT(D3_EMISSAO,6),B1_CLCFAM,B1_CLDFAM "
	cQryReport += "  ) DADOS "
	cQryReport += "  PIVOT ( "
	cQryReport += "  SUM(D3_QUANT) FOR D3_MESANO IN (["+MV_PAR03+"01],["+MV_PAR03+"02],["+MV_PAR03+"03],["+MV_PAR03+"04],["+MV_PAR03+"05],["+MV_PAR03+"06],["+MV_PAR03+"07],["+MV_PAR03+"08],["+MV_PAR03+"09],["+MV_PAR03+"10],["+MV_PAR03+"11],["+MV_PAR03+"12]) "
	cQryReport += "  ) PVT "
	
	//Executando consulta e setando o total da regua
	PlsQuery(cQryReport, cAlias)
	DbSelectArea(cAlias)

	Count to nTotal
	oReport:SetMeter(nTotal)
	(cAlias)->(DbGoTop())

	//Enquanto houver dados
	oSection1:Init()
	(cAlias)->(DbGoTop())
	While ! (cAlias)->(Eof())
		//Incrementando a regua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
		oReport:IncMeter()
		oSection1:Cell("D3_FILIAL"):SetValue((cAlias)->D3_FILIAL)
		oSection1:Cell("B1_CLCFAM"):SetValue((cAlias)->B1_CLCFAM)
		oSection1:Cell("B1_CLDFAM"):SetValue((cAlias)->B1_CLDFAM)
		oSection1:Cell("JANEIRO"):SetValue((cAlias)->JANEIRO)
		oSection1:Cell("FEVEREIRO"):SetValue((cAlias)->FEVEREIRO)
		oSection1:Cell("MARCO"):SetValue((cAlias)->MARCO)
		oSection1:Cell("ABRIL"):SetValue((cAlias)->ABRIL)
		oSection1:Cell("MAIO"):SetValue((cAlias)->MAIO)
		oSection1:Cell("JUNHO"):SetValue((cAlias)->JUNHO)
		oSection1:Cell("JULHO"):SetValue((cAlias)->JULHO)
		oSection1:Cell("AGOSTO"):SetValue((cAlias)->AGOSTO)
		oSection1:Cell("SETEMBRO"):SetValue((cAlias)->SETEMBRO)
		oSection1:Cell("OUTUBRO"):SetValue((cAlias)->OUTUBRO)
		oSection1:Cell("NOVEMBRO"):SetValue((cAlias)->NOVEMBRO)
		oSection1:Cell("DEZEMBRO"):SetValue((cAlias)->DEZEMBRO)

		//Imprimindo a linha atual
		oSection1:PrintLine()
		(cAlias)->(DbSkip())
	EndDo

	FWRestArea(aArea)

Return
