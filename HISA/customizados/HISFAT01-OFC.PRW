#INCLUDE "RMATR780.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR780  ³ Autor ³ Marco Bianchi         ³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Vendas por Cliente, quantidade de cada Produto, ³±±
±±³          ³ Release 4.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function HISFAT01()

Local oReport

Private oTmpTab_1 	:= Nil
Private oTmpTab_2 	:= Nil

	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local cAliasSD2 := GetNextAlias()
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
// Local lValadi	:= cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico
// Private cAliasSD2

oReport := TReport():New("MATR780",STR0018,"MR780A", {|oReport| ReportPrint(oReport,cAliasSD2)},STR0019 + " " + STR0020)	// "Estatisticas de Vendas (Cliente x Produto)"###"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"###"totalizando por produto e escolhendo a moeda forte para os Valores."
oReport:SetPortrait() 
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)

oProduto := TRSection():New(oReport,STR0028,{},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Estatisticas de Vendas (Cliente x Produto)"
oProduto:SetTotalInLine(.F.)

TRCell():New(oProduto,"CCLIEANT"	,'SD2TMP',RetTitle("D2_CLIENTE"		)	,PesqPict("SD2","D2_CLIENTE"	),08							,/*lPixel*/,)
TRCell():New(oProduto,"CLOJA"		,'SD2TMP',RetTitle("D2_LOJA"		)	,PesqPict("SD2","D2_LOJA"		),TamSx3("D2_LOJA"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"A1_NOME"		,'SD2TMP',RetTitle("A1_NOME"		)	,PesqPict("SA1","A1_NOME"		),TamSx3("A1_NOME"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"A1_OBSERV"	,'SD2TMP',RetTitle("A1_OBSERV"		)	,PesqPict("SA1","A1_OBSERV"		),TamSx3("A1_OBSERV"	)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"CCODPROD"	,'SD2TMP',RetTitle("D2_COD"			)	,PesqPict("SD2","D2_COD"		),TamSx3("D2_COD"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"CDESCPROD"	,'SD2TMP',RetTitle("B1_DESC"		)	,PesqPict("SB1","B1_DESC"		),TamSx3("B1_DESC"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"CDOC"		,'SD2TMP',RetTitle("D2_DOC"			)	,PesqPict("SD2","D2_DOC"		),TamSx3("D2_DOC"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"CPEDIDO"	    ,'SD2TMP',RetTitle("C5_PEDCLI"		)	,PesqPict("SC5","C5_PEDCLI"		),TamSx3("C5_PEDCLI"	)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"CSERIE" 		,'SD2TMP',SerieNfId("SD2",7,"D2_SERIE") ,PesqPict("SD2","D2_SERIE"		),SerieNfId("SD2",6,"D2_SERIE")	,/*lPixel*/,)
TRCell():New(oProduto,"DEMISSAO"	,'SD2TMP',RetTitle("D2_EMISSAO"		)	,PesqPict("SD2","D2_EMISSAO"	),nTamData						,/*lPixel*/,)
TRCell():New(oProduto,"CUM"			,'SD2TMP',RetTitle("B1_UM"			)	,PesqPict("SB1","B1_UM"			),TamSx3("B1_UM"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NTOTQUANT"	,'SD2TMP',RetTitle("D2_QUANT"		)	,PesqPict("SD2","D2_QUANT"		),TamSx3("D2_QUANT"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NVLRUNIT"	,'SD2TMP',RetTitle("D2_PRCVEN"		)	,PesqPict("SD2","D2_PRCVEN"		),TamSx3("D2_PRCVEN"	)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NBASECOF"	,'SD2TMP','Base COF'					,PesqPict("CD2","CD2_BC"		),TamSx3("CD2_BC"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NALIQCOF"	,'SD2TMP','Aliq. COF'					,PesqPict("CD2","CD2_ALIQ"		),TamSx3("CD2_ALIQ"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NVALCOF"		,'SD2TMP','Vlr. COF'					,PesqPict("CD2","CD2_VLTRIB"	),TamSx3("CD2_VLTRIB"	)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NBASEPIS"	,'SD2TMP','Base PIS'					,PesqPict("CD2","CD2_BC"		),TamSx3("CD2_BC"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NALIQPIS"	,'SD2TMP','Aliq. PIS'					,PesqPict("CD2","CD2_ALIQ"		),TamSx3("CD2_ALIQ"		)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NVALPIS"		,'SD2TMP','Vlr. PIS'					,PesqPict("CD2","CD2_VLTRIB"	),TamSx3("CD2_VLTRIB"	)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NVALICMS"	,'SD2TMP',RetTitle("D2_VALICM"	)		,PesqPict("SD2","D2_VALICM"		),TamSx3("D2_VALICM"	)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NICMSST"		,'SD2TMP',RetTitle("D2_ICMSRET"	)		,PesqPict("SD2","D2_ICMSRET"	),TamSx3("D2_ICMSRET"	)[1]	,/*lPixel*/,)
TRCell():New(oProduto,"NVLRTOT"		,'SD2TMP',RetTitle("D2_TOTAL"	)		,PesqPict("SD2","D2_TOTAL"		),TamSx3("D2_TOTAL"		)[1]	,/*lPixel*/,)
// // TRCell():New(oProduto,"CVENDS"		,'',STR0024					 ,PesqPict("SF2","F2_VEND1"					),TamSx3("F2_VEND1"		)[1],/*lPixel*/,"

// Alinhamento a direita das colunas de valor
oProduto:Cell("NTOTQUANT"):SetHeaderAlign("RIGHT") 
oProduto:Cell("NVLRUNIT"):SetHeaderAlign("RIGHT")
oProduto:Cell("NBASECOF"):SetHeaderAlign("RIGHT")
oProduto:Cell("NALIQCOF"):SetHeaderAlign("RIGHT")
oProduto:Cell("NVALCOF"):SetHeaderAlign("RIGHT")
oProduto:Cell("NBASEPIS"):SetHeaderAlign("RIGHT")
oProduto:Cell("NALIQPIS"):SetHeaderAlign("RIGHT")
oProduto:Cell("NVALPIS"):SetHeaderAlign("RIGHT")
oProduto:Cell("NVALICMS"):SetHeaderAlign("RIGHT")
oProduto:Cell("NICMSST"):SetHeaderAlign("RIGHT")
oProduto:Cell("NVLRTOT"):SetHeaderAlign("RIGHT") 

oProduto:SetEditCell(.F.)
oProduto:SetHeaderPage()

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Marco Bianchi         ³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAliasSD2)

// Local  nV := 0
// Local cProdAnt	  := "", cLojaAnt := ""
Local lNewProd	  := .T.
// Local nTamRef	  := Val(Substr(GetMv("MV_MASCGRD"),1,2))
// Local cProdRef	  := ""
Local cUM		  := ""
Local nTotQuant	  := 0
Local nReg		  := 0
Local cFiltro	  := ""
// Local cEstoq	  := If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ))
// Local cDupli	  := If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ))
// Local cVends	  := ""
// Local nVend		  := FA440CntVend()
// Local nDevQtd	  := 0
// Local nDevVal	  := 0
// Local aDev		  := {}
// Local aStru
// Local lNfD2Ori	  := .F. 
// Local cVendedores := ""
// Local lNewCli     := .T.
// Local lValadi		:= cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico
Local cWhere:= ""	
Local oProduto := Section(1)

Private nIndD1  :=0
Private nDecs	:=msdecimais(mv_par09)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona ordem dos arquivos consultados no processamento    		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF2->(dbsetorder(1))
SB1->(dbSetOrder(1))
SA7->(dbSetOrder(2))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com parametros                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title() + " " + STR0021 +GetMV("MV_SIMB"+Str(mv_par09,1)))		// "Estatisticas de Vendas (Cliente x Produto)"###"Valores em "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)
    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta filtro para processar as vendas por cliente            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SD2")
cFiltro := SD2->(dbFilter())
If Empty(cFiltro)
	bFiltro := { || .T. }
Else
	cFiltro := "{ || " + cFiltro + " }"
	bFiltro := &(cFiltro)
Endif

DbSelectArea("SD2")
            
    cAliasSD2   := "SD2TMP"
    cWhere := "%NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ")%"

    oProduto:BeginQuery()
    BeginSql Alias cAliasSD2
		SELECT D2_FILIAL,D2_CLIENTE,D2_LOJA,A1_NOME,D2_COD,D2_ITEM,A1_OBSERV,B1_COD,B1_DESC,D2_DOC,D2_SERIE,D2_PEDIDO,D2_EMISSAO,D2_UM,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_VALICM,D2_ICMSRET,D2_TIPO,D2_GRADE
		FROM %Table:SD2% SD2
		INNER JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = %xFilial:SA1% AND SA1.A1_COD=SD2.D2_CLIENTE AND
		SA1.A1_COD >= %Exp:MV_PAR01% AND
		SA1.A1_COD <= %Exp:MV_PAR02% AND
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
    oProduto:EndQuery()

oProduto:Init()
While !(cAliasSD2)->(Eof())
	oReport:IncMeter()
	cPedido  := POSICIONE("SC5",1,(cAliasSD2)->D2_FILIAL+(cAliasSD2)->D2_PEDIDO,"C5_PEDCLI")
						
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se mesmo produto inibe impressao do codigo e descricao   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lNewProd
		lNewProd := .F.
		oProduto:Cell("CCODPROD"	):Show()
		oProduto:Cell("CDESCPROD"	):Show()
		//Se for tipo planilha e estilo relatório em formato de tabela.
	ElseIf	oReport:nDevice == 4 .AND. oReport:nXlsStyle == 1
		oProduto:Cell("CCODPROD"	):Show()
		oProduto:Cell("CDESCPROD"	):Show()
	Else
		oProduto:Cell("CCODPROD"	):Hide()
		oProduto:Cell("CDESCPROD"	):Hide()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se processou algum registro        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nReg > 0
		dbGoto(nReg)
		nReg:=0
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os dados da NF                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz Verificacao da Moeda Escolhida e Imprime os Valores  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	// cCodProd 	:= Eval(bGrade)
	
	oProduto:PrintLine()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao dos Vendedores                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProduto:Cell("CCODPROD"	):Hide()
	oProduto:Cell("CDESCPROD"	):Hide()
	oProduto:Cell("CDOC"		):Hide()
	oProduto:Cell("CSERIE"		):Hide()
	oProduto:Cell("DEMISSAO"	):Hide()
	oProduto:Cell("CUM"		):Hide()
	oProduto:Cell("NTOTQUANT"	):Hide()
	oProduto:Cell("NVLRUNIT"	):Hide()
	oProduto:Cell("NBASECOF"	):Hide()
	oProduto:Cell("NALIQCOF"	):Hide()
	oProduto:Cell("NVALCOF"	):Hide()
	oProduto:Cell("NBASEPIS"	):Hide()
	oProduto:Cell("NALIQPIS"	):Hide()
	oProduto:Cell("NVALPIS"	):Hide()
	oProduto:Cell("NVALICMS"	):Hide()
	oProduto:Cell("NICMSST"	):Hide()
	oProduto:Cell("NVLRTOT"	):Hide()


	nTotQuant := 0
	(cAliasSD2)->(dbSkip())

EndDo


If( valtype(oTmpTab_1) == "O")
	oTmpTab_1:Delete()
	freeObj(oTmpTab_1)
	oTmpTab_1 := nil
EndIf

If( valtype(oTmpTab_2) == "O")
	oTmpTab_2:Delete()
	freeObj(oTmpTab_2)
	oTmpTab_2 := nil
EndIf

Return
