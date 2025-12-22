//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RMATR780.CH"
/*/

Funo     MATR015   Autor  Alexandre Inacio Lemes Data 22/05/200
Descrio  Relao entre NFs Originais X NFs Frete/Importao.
Sintaxe    MATR015(void)
Uso       Generico


/*/
USER Function HISFAT01()

	Local oReport
	Local aArea    := FWGetArea()
	Private cPerg :=''

	oReport := ReportDef()
	oReport:PrintDialog()

	FWRestArea(aArea)
Return

/*/
	Programa  ReportDef Autor  Alexandre Inacio Lemes Data  22/05/2006
	Descrio  Relao entre NFs Originais X NFs Frete/Importao.
	Retorno   ExpO1: Objeto do relatrio
	ParametrosNenhum
/*/
Static Function ReportDef()
	Local oReport
	Local oSection1
	Local cAliasSD2 := GetNextAlias()
	Local aArea    := FWGetArea()
	Local oReport
	Local cCodProd	:= ""
	Local cDescProd	:= ""
	Local cDoc		:= ""
	Local cSerie	:= ""
	Local dEmissao	:= CTOD("  /  /  ")
	Local cUM		:= ""
	Local nTotQuant	:= 0
	Local nVlrUnit	:= 0
	Local nValadi	:= 0
	Local nVlrTot	:= 0
	Local NBASECOF	:= 0
	Local NALIQCOF	:= 0
	Local NVALCOF	:= 0
	Local NBASEPIS	:= 0
	Local NALIQPIS	:= 0
	Local NVALPIS	:= 0
	Local NVALICMS	:= 0
	Local NICMSST	:= 0
// Local cVends	:= ""
	Local cClieAnt	:= ""
	Local cLojaAnt	:= ""
	Local nTamData  := Len(DTOC(MsDate()))

	oReport := TReport():New("MATR780",STR0018,"MR780A", {|oReport| ReportPrint(oReport,cAliasSD2)},STR0019 + " " + STR0020)	// "Estatisticas de Vendas (Cliente x Produto)"###"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"###"totalizando por produto e escolhendo a moeda forte para os Valores."
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	Pergunte(oReport:uParam,.F.)

	oReport:oPage:SetPaperSize(8)
	oReport:SetLandscape(.T.)
	oReport:SetLineHeight(50)
	oReport:nFontBody := 12

	oSection1 := TRSection():New(oReport,STR0028,{},/*{Array com as ordens do relatСrio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
	oSection1:SetTotalInLine(.F.)

	TRCell():New(oSection1, "CCLIEANT"	,'SD2TMP',RetTitle("D2_CLIENTE"		)	,PesqPict("SD2","D2_CLIENTE"	),08							,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "CLOJA"		,'SD2TMP',RetTitle("D2_LOJA"		)	,PesqPict("SD2","D2_LOJA"		),TamSx3("D2_LOJA"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .T.)
	TRCell():New(oSection1, "A1_NOME"		,'SD2TMP',RetTitle("A1_NOME"		)	,PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "A1_OBSERV"	,'SD2TMP',RetTitle("A1_OBSERV"		)	,PesqPict("SA1","A1_OBSERV"		),TamSx3("A1_OBSERV"	)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "CCODPROD"	,'SD2TMP',RetTitle("D2_COD"			)	,PesqPict("SD2","D2_COD"		),TamSx3("D2_COD"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "CDESCPROD"	,'SD2TMP',RetTitle("B1_DESC"		)	,PesqPict("SB1","B1_DESC"		),TamSx3("B1_DESC"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "CDOC"		,'SD2TMP',RetTitle("D2_DOC"			)	,PesqPict("SD2","D2_DOC"		),TamSx3("D2_DOC"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "CPEDIDO"	    ,'SD2TMP',RetTitle("C5_PEDCLI"		)	,PesqPict("SC5","C5_PEDCLI"		),TamSx3("C5_PEDCLI"	)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "CSERIE" 		,'SD2TMP',SerieNfId("SD2",7,"D2_SERIE") ,PesqPict("SD2","D2_SERIE"		),SerieNfId("SD2",6,"D2_SERIE")	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "DEMISSAO"	,'SD2TMP',RetTitle("D2_EMISSAO"		)	,PesqPict("SD2","D2_EMISSAO"	),nTamData						,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "CUM"			,'SD2TMP',RetTitle("B1_UM"			)	,PesqPict("SB1","B1_UM"			),TamSx3("B1_UM"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NTOTQUANT"	,'SD2TMP',RetTitle("D2_QUANT"		)	,PesqPict("SD2","D2_QUANT"		),TamSx3("D2_QUANT"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NVLRUNIT"	,'SD2TMP',RetTitle("D2_PRCVEN"		)	,PesqPict("SD2","D2_PRCVEN"		),TamSx3("D2_PRCVEN"	)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NBASECOF"	,'SD2TMP','Base COF'					,PesqPict("CD2","CD2_BC"		),TamSx3("CD2_BC"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NALIQCOF"	,'SD2TMP','Aliq. COF'					,PesqPict("CD2","CD2_ALIQ"		),TamSx3("CD2_ALIQ"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NVALCOF"		,'SD2TMP','Vlr. COF'					,PesqPict("CD2","CD2_VLTRIB"	),TamSx3("CD2_VLTRIB"	)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NBASEPIS"	,'SD2TMP','Base PIS'					,PesqPict("CD2","CD2_BC"		),TamSx3("CD2_BC"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NALIQPIS"	,'SD2TMP','Aliq. PIS'					,PesqPict("CD2","CD2_ALIQ"		),TamSx3("CD2_ALIQ"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NVALPIS"		,'SD2TMP','Vlr. PIS'					,PesqPict("CD2","CD2_VLTRIB"	),TamSx3("CD2_VLTRIB"	)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NVALICMS"	,'SD2TMP',RetTitle("D2_VALICM"	)		,PesqPict("SD2","D2_VALICM"		),TamSx3("D2_VALICM"	)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NICMSST"		,'SD2TMP',RetTitle("D2_ICMSRET"	)		,PesqPict("SD2","D2_ICMSRET"	),TamSx3("D2_ICMSRET"	)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)
	TRCell():New(oSection1, "NVLRTOT"		,'SD2TMP',RetTitle("D2_TOTAL"	)		,PesqPict("SD2","D2_TOTAL"		),TamSx3("D2_TOTAL"		)[1]	,/*lPixel*/, /*{|| code-block de impressao }*/, "LEFT", /*lLineBreak*/, "LEFT", /*lCellBreak*/, /*nColSpace*/, /*lAutoSize*/, /*nClrBack*/, /*nClrFore*/, .F.)

	oSection1:SetHeaderPage()

	FWRestArea(aArea)
Return(oReport)


Static Function ReportPrint(oReport,cAliasSD2)

	Local cProdAnt	  := "", cLojaAnt := ""
	Local lNewProd	  := .T.
	Local aArea    := FWGetArea()
	Local cUM		  := ""
	Local nTotQuant	  := 0
	Local nReg		  := 0
	Local cFiltro	  := ""

	Local cWhere:= ""
	Local nAtual := 0
	Local oSection1 := oReport:Section(1)

	Private nIndD1  :=0
	Private nDecs	:=msdecimais(mv_par09)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Seleciona ordem dos arquivos consultados no processamento    		   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	SF2->(dbsetorder(1))
	SB1->(dbSetOrder(1))
	SA7->(dbSetOrder(2))

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta o Cabecalho de acordo com parametros                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oReport:SetTitle(oReport:Title() + " " + STR0021 +GetMV("MV_SIMB"+Str(mv_par09,1)))		// "Estatisticas de Vendas (Cliente x Produto)"###"Valores em "

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁTransforma parametros Range em expressao SQL                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	MakeSqlExpr(oReport:uParam)
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)

	DbSelectArea("SD2")

	cAliasSD2   := "SD2TMP"
	cWhere := "%NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ")%"

	oSection1:BeginQuery()
	BeginSql Alias cAliasSD2
		SELECT D2_FILIAL,D2_CLIENTE,D2_LOJA,A1_NOME,D2_COD,D2_ITEM,A1_OBSERV,B1_COD,B1_DESC,D2_DOC,D2_SERIE,D2_PEDIDO,D2_EMISSAO,D2_UM,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_VALICM,D2_ICMSRET,D2_TIPO,D2_GRADE
		FROM %Table:SD2% SD2
		INNER JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL=%xFilial:SA1% AND SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND
		SA1.%NotDel%
		INNER JOIN %Table:SB1% SB1 ON SB1.B1_COD=SD2.D2_COD
		WHERE SD2.D2_FILIAL = %xFilial:SD2% AND
			SD2.D2_CLIENTE BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
			SD2.D2_EMISSAO BETWEEN %Exp:DTOS(mv_par03)% AND %Exp:DTOS(mv_par04)% AND
			SD2.D2_COD     BETWEEN %Exp:mv_par05% AND %Exp:mv_par06% AND
			SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND
			%Exp:cWhere% AND
			SD2.%NotDel%
		ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_COD,SD2.D2_ITEM
	EndSql

	oSection1:EndQuery()

	Count to nTotal
	oReport:SetMeter(nTotal)
	//Enquanto houver dados
	oSection1:Init()

	DbSelectArea(cAliasSD2)
	(cAliasSD2)->(DbGoTop())
	While ! (cAliasSD2)->(Eof())

		oReport:IncMeter()
		cPedido  := POSICIONE("SC5",1,(cAliasSD2)->D2_FILIAL+(cAliasSD2)->D2_PEDIDO,"C5_PEDCLI")

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Se mesmo produto inibe impressao do codigo e descricao   Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		// If lNewProd
		// 	lNewProd := .F.
		// 	oSection1:Cell("CCODPROD"	):SetValue((cAliasSD2)->D2_COD)
		// 	oSection1:Cell("CDESCPROD"	):SetValue((cAliasSD2)->B1_DESC)
		// 	//Se for tipo planilha e estilo relatСrio em formato de tabela.
		// ElseIf	oReport:nDevice == 4 .AND. oReport:nXlsStyle == 1
		// 	oSection1:Cell("CCODPROD"	):SetValue((cAliasSD2)->D2_COD)
		// 	oSection1:Cell("CDESCPROD"	):SetValue((cAliasSD2)->B1_DESC)
		// EndIf

		//зддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verifica se processou algum registro        Ё
		//юддддддддддддддддддддддддддддддддддддддддддддды
		If nReg > 0
			dbGoto(nReg)
			nReg:=0
		EndIf

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Imprime os dados da NF                                   Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		SB1->(dbSeek(xFilial("SB1")+(cAliasSD2)->D2_COD))
		If mv_par16 = 1
			cDescProd := SB1->B1_DESC
		Else
			If SA7->(dbSeek(xFilial("SA7")+(cAliasSD2)->(D2_COD+D2_CLIENTE+D2_LOJA)))
				cDescProd := SA7->A7_DESCCLI
			Else
				cDescProd := SB1->B1_DESC
			Endif
		EndIf

		SF2->(dbSeek((cAliasSD2)->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))//SF2->(dbSeek(xFilial("SF2")+(cAliasSD2)->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
		cUM      := (cAliasSD2)->D2_UM
		cDoc     := (cAliasSD2)->D2_DOC
		cSerie   := (cAliasSD2)->&(SerieNfId("SD2",3,"D2_SERIE"))
		dEmissao := (cAliasSD2)->D2_EMISSAO

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Faz Verificacao da Moeda Escolhida e Imprime os Valores  Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		nVlrUnit := xMoeda((cAliasSD2)->D2_PRCVEN,SF2->F2_MOEDA,MV_PAR09,(cAliasSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
		// If lValadi
		// 	nValadi := xMoeda((cAliasSD2)->D2_VALADI,SF2->F2_MOEDA,MV_PAR09,(cAliasSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
		// EndIf
		If (cAliasSD2)->D2_TIPO $ "CIP"
			If cPaisLoc == "BRA"
				nVlrTot:= nVlrUnit
			ElseIf (cAliasSD2)->D2_TIPO $ "C"
				nVlrTot:= nTotQuant * nVlrUnit
			EndIf
		Else
			If (cAliasSD2)->D2_GRADE == "S" .And. MV_PAR12 == 1 // Aglutina Grade
				nVlrTot:= nVlrUnit * nTotQuant
			Else
				nVlrTot:=xmoeda((cAliasSD2)->D2_TOTAL,SF2->F2_MOEDA,mv_par09,(cAliasSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
			EndIf
		EndIf

		// BASE ALIQUOTA E VALOR DE PIS/COFINS
		DbSelectArea('CD2')
		dbSetOrder(1)
		MSSEEK((cAliasSD2)->D2_FILIAL+'S'+(cAliasSD2)->(D2_SERIE+D2_DOC+D2_CLIENTE+D2_LOJA+D2_ITEM))

		while !CD2->(EOF()) .AND. AllTrim((cAliasSD2)->D2_FILIAL+'S'+(cAliasSD2)->(D2_SERIE+D2_DOC+D2_CLIENTE+D2_LOJA+D2_ITEM));
				==AllTrim(CD2->CD2_FILIAL+'S'+CD2->(CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM))
			if ALLTRIM(CD2->CD2_IMP)=='CF2'
				NBASECOF :=	CD2->CD2_BC
				NALIQCOF := CD2->CD2_ALIQ
				NVALCOF  := CD2->CD2_VLTRIB
			ElseIf ALLTRIM(CD2->CD2_IMP)=='PS2'
				NBASEPIS := CD2->CD2_BC
				NALIQPIS := CD2->CD2_ALIQ
				NVALPIS  := CD2->CD2_VLTRIB
			endif
			CD2->(DbSkip())
		EndDo

		CD2->(dbCloseArea())
		NBASECOF := 0
		NALIQCOF := 0
		NVALCOF  := 0
		NBASEPIS := 0
		NALIQPIS := 0
		NVALPIS  := 0

		NVALICMS :=( cAliasSD2)->D2_VALICM
		NICMSST  :=( cAliasSD2)->D2_ICMSRET
		//Incrementando a regua
		nAtual++
		// cMotivo := POSICIONE("RCM",1,XFILIAL("RCM")+(cAliasSD2)->ZZ2_CODAUS,"RCM_DESCRI")
		oReport:SetMsgPrint("Imprimindo registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
		oReport:IncMeter()
		oSection1:Cell("CCLIEANT"	):SetValue((cAliasSD2)->D2_CLIENTE)
		oSection1:Cell("CLOJA"		):SetValue((cAliasSD2)->D2_LOJA)
		oSection1:Cell("A1_NOME"	):SetValue((cAliasSD2)->A1_NOME)
		oSection1:Cell("A1_OBSERV"	):SetValue((cAliasSD2)->A1_OBSERV)
		oSection1:Cell("CCODPROD"	):SetValue((cAliasSD2)->D2_COD)
		oSection1:Cell("CDESCPROD"	):SetValue((cAliasSD2)->B1_DESC)
		oSection1:Cell("CDOC"		):SetValue((cAliasSD2)->D2_DOC)
		oSection1:Cell("CPEDIDO"	):SetValue((cAliasSD2)->D2_PEDIDO)
		oSection1:Cell("CSERIE"		):SetValue((cAliasSD2)->D2_SERIE)
		oSection1:Cell("DEMISSAO"	):SetValue((cAliasSD2)->(D2_EMISSAO))
		oSection1:Cell("CUM"		):SetValue((cAliasSD2)->D2_UM)
		oSection1:Cell("NTOTQUANT"	):SetValue((cAliasSD2)->(D2_QUANT))
		oSection1:Cell("NVLRUNIT"	):SetValue((cAliasSD2)->D2_PRCVEN)
		oSection1:Cell("NBASECOF"	):SetValue(NBASECOF)
		oSection1:Cell("NALIQCOF"	):SetValue(NALIQCOF)
		oSection1:Cell("NVALCOF"	):SetValue(NVALCOF)
		oSection1:Cell("NBASEPIS"	):SetValue(NBASEPIS)
		oSection1:Cell("NALIQPIS"	):SetValue(NALIQPIS)
		oSection1:Cell("NVALPIS"	):SetValue(NVALPIS)
		oSection1:Cell("NVALICMS"	):SetValue((cAliasSD2)->D2_VALICM)
		oSection1:Cell("NICMSST"	):SetValue((cAliasSD2)->D2_ICMSRET)
		oSection1:Cell("NVLRTOT"	):SetValue(nVlrTot)

		//Imprimindo a linha atual
		oSection1:PrintLine()
		(cAliasSD2)->(DbSkip())
	EndDo

	(cAliasSD2)->(DbGoTop())
	FWRestArea(aArea)
Return

