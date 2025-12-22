#include "INFINR05.CH"
#Include "PROTHEUS.CH"

#DEFINE TOTSALDO	1
#DEFINE TOTJUROS	2
#DEFINE TOTIOF		3
#DEFINE TOTIR		4
#DEFINE TOTAPL		5

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ INFINR05	³ Autor ³ Ener Fredes           ³ Data ³ 20/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao relatorio de Aplicacoes Financeiras INDT   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Finr820()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR820													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INFINR05
Local oReport
If FindFunction("TRepInUse") .And. TRepInUse()
	oReport:=ReportDef()
	oReport:PrintDialog()
Else
   Return FinR820R3() // Executa versão anterior do relatorio
Endif

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Claudio D. de Souza    ³ Data ³24/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport,oSection1
Local cReport := "FINR820"
Local cAlias1 := "SEH"
Local cTitulo := STR0003 // "Demonstrativo de Aplicacoes"
Local cDescri := STR0001 + " " + " " + STR0003 // "Este programa tem como objetivo imprimir o valor atualizado das aplicacoes financeiras, conforme os parametros solicitados. "
Local bReport := { |oReport|	ReportPrint( oReport ) }

Pergunte("FIR820",.F.)
oReport  := TReport():New( cReport, cTitulo, "FIR820" , bReport, cDescri )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio Valores nas Moedas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New( oReport,STR0025, {cAlias1} )

TRCell():New( oSection1, "EH_NUMERO"	, cAlias1,/*X3Titulo*/     ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "EH_REVISAO"	, cAlias1,/*X3Titulo*/     ,/*Picture*/,Len(SEH->EH_REVISAO)/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
TRCell():New( oSection1, "EH_NBANCO"	, cAlias1,/*X3Titulo*/     ,/*Picture*/,20/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
TRCell():New( oSection1, "EH_TIPO"		, cAlias1,/*X3Titulo*/     ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
TRCell():New( oSection1, "EH_DATA"		, cAlias1,/*X3Titulo*/     ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
TRCell():New( oSection1, "EH_DATARES"	, cAlias1,/*X3Titulo*/     ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)	
TRCell():New( oSection1, "EH_SALDO"		, cAlias1,/*X3Titulo*/     ,/*Picture*/,/*Tamanho*/,/*lPixel*/, {|| xMoeda(SEH->EH_SALDO,1,MV_PAR05) } )
TRCell():New( oSection1, "EH_VLRCOTA"	, cAlias1,STR0018 /*X3Titulo*/,"@Z"+TM(SEH->EH_VLRCOTA,14,6)/*Picture*/,14/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ ) // "Cota Util. Apl"
TRCell():New( oSection1, "COTA ATUAL"	, "",STR0019 /*X3Titulo*/     ,"@Z"+TM(SEH->EH_VLRCOTA,14,6)/*Picture*/,14/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ ) // "Cota atual"
TRCell():New( oSection1, "RENDIMENTO BRUTO", "",STR0020 /*X3Titulo*/,TM(SEH->EH_VALCRED,14,2)/*Picture*/,/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ ) // "Rendimento Bruto"
TRCell():New( oSection1, "PERC REND BRUTO", "",STR0021 /*X3Titulo*/ ,"@E 999.999999%"/*Picture*/,12/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ ) // "Perc."
TRCell():New( oSection1, "EH_TAXAIOF"	, cAlias1,STR0022 /*X3Titulo*/,"@E 99.99%"/*Picture*/,/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ ) // "Taxa de IOF"
TRCell():New( oSection1, "VALOR IOF"	, cAlias1,STR0023 /*X3Titulo*/,"@E@Z 999,999,999.99"/*Picture*/,/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ ) // "Valor do IOF"
TRCell():New( oSection1, "EH_TAXAIRF"	, cAlias1,/*X3Titulo*/     ,/*Picture*/,/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection1, "EH_VALIRF"	, cAlias1,/*X3Titulo*/     ,/*Picture*/,/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ )
TRCell():New( oSection1, "EH_VALCRED"	, cAlias1,STR0024/*X3Titulo*/     ,/*Picture*/,/*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/ ) // "Resgate liquido"

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³Claudio D. de Souza º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query de impressao do relatorio                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )
Local oSection1 := oReport:Section(1)
Local cQuery		:= "SEH"
Local cWhere		:= ""
Local cAplCotas   := GetMv("MV_APLCAL4")
Local nAscan
Local nDias
Local aAplic := {}
Local cTabIrf		:= "AR"
Local aTabIrf		:= {	{ 180, 22.5 },;
								{ 360, 20.0 },;
								{ 720, 17.5 },;
								{ 1000000, 15.0 } }
Local bOnPrintLine

#IFDEF TOP

	cQuery 		:= GetNextAlias()
	
	If MV_PAR06==2
		cWhere := "EH_MOEDA = " + Alltrim(Str(mv_par05)) + " AND "
	Endif
	cWhere := "%" + cWhere + "%"
	
	oSection1:BeginQuery()
	
	BeginSql Alias cQuery
		SELECT
			SEH.R_E_C_N_O_ SEHRECNO
		FROM %table:SEH% SEH
		WHERE
			SEH.EH_FILIAL = %xfilial:SEH% AND
			SEH.EH_BANCO >= %Exp:mv_par03% AND 
			SEH.EH_BANCO <= %Exp:mv_par04% AND 
			SEH.EH_APLEMP = 'APL' AND 
			%Exp:cWhere%
			SEH.%notDel%
	EndSql

	oSection1:EndQuery()
	bOnPrintLine := { ||	SEH->(MsGoto((cQuery)->SEHRECNO)),;
								nDias := dDataBase - SEH->EH_DATA,;
								nTaxaIrf	:= If(Empty(SEH->EH_TAXAIRF), If(SX5->(MsSeek(xFilial("SX5")+"AR")),;
								Val(TabelaIrf(cTabIrf,nDias)),aTabIrf[Ascan( aTabIrf, { |e| e[1] >= nDias } )][2]),SEH->EH_TAXAIRF),;
								aCalculo := Fr820Calc(cAplCotas,@aAplic), .T. }
	
#ELSE

	cFiltro := 'EH_FILIAL == "'+xFilial("SEH")+'" .And. '
	cFiltro += 'EH_BANCO >= "'+mv_par03+'" .And. '
	cFiltro += 'EH_BANCO <= "'+mv_par04+'" .And. '
	cFiltro += StrTran(cWhere, "AND", ".And." )
	cFiltro += 'EH_APLEMP == "APL"'
	oSection1:SetFilter(cFiltro, SEH->(IndexKey(1)))
	bOnPrintLine := { ||	nDias := dDataBase - SEH->EH_DATA,;
								nTaxaIrf	:= If(Empty(SEH->EH_TAXAIRF), If(SX5->(MsSeek(xFilial("SX5")+"AR")),;
								Val(TabelaIrf(cTabIrf,nDias)),aTabIrf[Ascan( aTabIrf, { |e| e[1] >= nDias } )][2]),SEH->EH_TAXAIRF),;
								aCalculo := Fr820Calc(cAplCotas,@aAplic), .T. }

#ENDIF
oSection1:OnPrintLine( bOnPrintLine )
oSection1:Cell("EH_VLRCOTA"):SetBlock({||	 If( SEH->EH_TIPO $ cAplCotas, SEH->EH_VLRCOTA, 0 ) } )
oSection1:Cell("COTA ATUAL"):SetBlock({||	 If( SEH->EH_TIPO $ cAplCotas, Fr820Cota(aAplic), 0) } )
oSection1:Cell("EH_TAXAIOF"):SetBlock({|| If(Empty(SEH->EH_TAXAIOF) .And. nDias > 0 .And. nDias < 30,VAL(TABELA("A0", STRZERO(nDias,2))),SEH->EH_TAXAIOF) } )
oSection1:Cell("VALOR IOF"):SetBlock({|| xMoeda(aCalculo[3],1,MV_PAR05) } )
oSection1:Cell("EH_TAXAIRF"):SetBlock({|| nTaxaIrf } )
oSection1:Cell("EH_VALIRF"):SetBlock({|| xMoeda(aCalculo[2],1,MV_PAR05) } )
oSection1:Cell("VALOR IOF"):SetBlock({|| xMoeda(aCalculo[3],1,MV_PAR05) } )
oSection1:Cell("RENDIMENTO BRUTO"):SetBlock({|| xMoeda(aCalculo[5],1,MV_PAR05)} )
oSection1:Cell("PERC REND BRUTO"):SetBlock({|| (xMoeda(aCalculo[5],1,MV_PAR05) / aCalculo[1]) * 100 } )
oSection1:Cell("EH_VALCRED"):SetBlock({||  xMoeda(aCalculo[1],1,MV_PAR05) - (xMoeda(aCalculo[2]+aCalculo[3]+aCalculo[4],1,mv_par05))} )

TRFunction():New(oSection1:Cell("EH_SALDO"),,"SUM",,,,, .F. , .T. )
TRFunction():New(oSection1:Cell("RENDIMENTO BRUTO"),,"SUM",,,,, .F. , .T. )
TRFunction():New(oSection1:Cell("VALOR IOF"),,"SUM",,,,, .F. , .T. )
TRFunction():New(oSection1:Cell("EH_VALIRF"),,"SUM",,,,, .F. , .T. )
TRFunction():New(oSection1:Cell("EH_VALCRED"),,"SUM",,,,, .F. , .T. )

oSection1:SetLineBreak(.T.)

oSection1:Print()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fr820Calc  ºAutor  ³Claudio D. de Souza º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo dos valores a serem impressos                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR820                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fr820Calc(cAplCotas,aAplic,cAliasSeh)
Local aRet := {0,0,0,0,0,0}
Local nAscan
If ! SEH->EH_TIPO $ cAplCotas
	aRet	:= Fa171Calc(MV_PAR01,SEH->EH_SALDO,MV_PAR02==1)
Else
	aRet := {0,0,0,0,0,0}
	SE9->(DbSetOrder(1))	
	SE9->(MsSeek(xFilial()+SEH->EH_CONTRAT+SEH->EH_BCOCONT+SEH->EH_AGECONT))
	SE0->(MsSeek(xFilial("SE0")+SE9->(E9_BANCO+E9_AGENCIA+E9_CONTA+E9_NUMERO)))
	Aadd(aAplic,{	SEH->EH_CONTRAT,SEH->EH_BCOCONT,SEH->EH_AGECONT, SE0->E0_VALOR})
	nAscan := Ascan(aAplic, {|e|	e[1] == SEH->EH_CONTRAT .And.;
										   e[2] == SEH->EH_BCOCONT .And.;
										   e[3] == SEH->EH_AGECONT})
	If nAscan > 0
		aRet	:=	Fa171Calc(MV_PAR01,SEH->EH_SLDCOTA,,,,SEH->EH_VLRCOTA,aAplic[nAscan][4],(SEH->EH_SLDCOTA * aAplic[nAscan][4]))
	Endif	
EndIf		

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fr820Cota  ºAutor  ³Claudio D. de Souza º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo dos valor da cota a ser impressa                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR820                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fr820Cota(aAplic)
Local nAscan
Local nRet
nAscan := Ascan(aAplic, {|e|	e[1] == SEH->EH_CONTRAT .And.;
										e[2] == SEH->EH_BCOCONT .And.;
									   e[3] == SEH->EH_AGECONT})

nRet := If( nAscan > 0, aAplic[nAscan][4], 0)

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Finr820R3³ Autor ³ Eduardo Riera         ³ Data ³ 03/04/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao relatorio de Aplicacoes Financeiras    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Finr820()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR820																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinR820R3
LOCAL lEnd     	:= .T.
LOCAL wnrel    	:= "FINR820"
LOCAL cString		:="SEH"
LOCAL cDesc1		:= OemToAnsi(STR0001)  //"Este programa tem como objetivo imprimir o valor atualizado das "
LOCAL cDesc2		:= OemToAnsi(STR0002)  //"aplicacoes financeiras, conforme os parametros solicitados. "
LOCAL cDesc3		:= ""
LOCAL aOrdem   	:= {}
Local aAplic 		:= {}

PRIVATE cPerg		:= "FIR820"
PRIVATE NomeProg	:= "FINR820"
PRIVATE Titulo 	:= OemToAnsi(STR0003)  //"Demonstrativo de Aplicacoes"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE Tamanho	:= "G"
PRIVATE Limite 	:= 220
PRIVATE m_pag 		:= 1
PRIVATE nLastKey	:= 0
PRIVATE aReturn	:= { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ mv_par01				// Data de Referencia ?                  ³
//³ mv_par02				// Considera Resgate  ?  Sim Nao         ³
//³ mv_par03            // Banco de           ?                  ³
//³ mv_par04            // Banco Ate          ?                  ³
//³ mv_par05            // Moeda              ? Moeda1/2/3/4/5   ³
//³ mv_par06            // Otras Monedas      ? Converter / No Imrpimir ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,,Tamanho)
If ( nLastKey == 27 )
	 Return( .F. )
End
SetDefault(aReturn,cString)
If ( nLastKey == 27 )
	Return( .F. )
Endif
RptStatus({|lEnd| Fa820Imp(@lEnd,wnRel,cString,NomeProg,aAplic)},Titulo)
Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fa820Imp ³ Autor ³ Eduardo Riera         ³ Data ³ 03/04/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao relatorio                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA820Imp(lEnd,wnRel,cString)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Parametro 1 - lEnd	 - A‡Æo do CodeBlock 					  ³±±
±±³			 ³ Parametro 2 - wnRel	 - T¡tulo do relat¢rio					  ³±±
±±³			 ³ Parametro 3 - cString - Mensagem 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR820																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION FA820Imp(lEnd,wnRel,cString,NomeProg,aAplic)

LOCAL cbtxt 	:= Space(10)
LOCAL cbcont	:= 0
LOCAL Li       := 99
LOCAL aCalculo := {}
LOCAL nVlrApl  := 0
LOCAL nVlrImp  := 0
LOCAL nVlrJur  := 0
LOCAL aTotal   := { 0,0,0,0,0 }
LOCAL lResgate := If ( MV_PAR02==1 , .T. , .F. )
Local cAplCotas   := GetMv("MV_APLCAL4")
Local nAscan
Local nDias
Local nTaxaIrf	
Local cTabIrf		:= "AR"
Local aTabIrf		:= {	{ 180, 22.5 },;
								{ 360, 20.0 },;
								{ 720, 17.5 },;
								{ 1000000, 15.0 } }

Cabec1  := "                                                Dados da Aplicacao                                                                             Valores"
Cabec2  := "Numero    Instituicao          Mod Dt.Aplic   Dt.Resg.         Principal Cota Util. Apl     Cota Atual    Rend. Bruto       Perc. Taxa IOF    Valor IOF   Taxa IR        Valor IR       Resgate Total Nro. Aplic Venc Apl"
cbtxt 	:= Space(10)
cbcont	:= 0

dbSelectArea("SEH")
SetRegua(LastRec())
dbSetOrder(1)
dbSeek(xFilial("SEH"))

While ( !Eof() .And. SEH->EH_FILIAL == xFilial("SEH") )
	
	If ( lEnd )
		@PROW()+1,001 PSAY OemToAnsi(STR0007)  //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	If ( Li > 56 )
		Li := cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
		Li++
	EndIf
	IF MV_PAR06==2 .AND. MV_PAR05<>SEH->EH_MOEDA
		dbSelectArea("SEH")
		IncRegua()
		DBSKIP()
		LOOP
	Endif	
	
	DbSelectArea("SE9")
	DbSetOrder(1)
	dbSeek(xFilial()+SEH->EH_CONTRAT+SEH->EH_BCOCONT+SEH->EH_AGECONT)
	
	DbSelectArea("SEH")
	
	If ( SEH->EH_BANCO >= MV_PAR03 .And. SEH->EH_BANCO <= MV_PAR04 ) .And. SEH->EH_APLEMP == "APL"
		If !SEH->EH_TIPO $ cAplCotas
			aCalculo	:= Fa171Calc(MV_PAR01,SEH->EH_SALDO,lResgate)
		Else
			aCalculo := {0,0,0,0,0,0}
			DbSelectArea("SE0")
			MsSeek(xFilial("SE0")+SE9->(E9_BANCO+E9_AGENCIA+E9_CONTA+E9_NUMERO))
			Aadd(aAplic,{	SEH->EH_CONTRAT,SEH->EH_BCOCONT,SEH->EH_AGECONT,;
								Transform(SEH->EH_SALDO,"@E 999,999,999.99"),;
								Transform(SE9->E9_VLRCOTA,PesqPict("SE9","E9_VLRCOTA",18)),;
								SE0->E0_VALOR})
			DbSelectArea("SEH")
			nAscan := Ascan(aAplic, {|e|	e[1] == SEH->EH_CONTRAT .And.;
												   e[2] == SEH->EH_BCOCONT .And.;
												   e[3] == SEH->EH_AGECONT})
			If nAscan > 0
				aCalculo	:=	Fa171Calc(MV_PAR01,SEH->EH_SLDCOTA,,,,SEH->EH_VLRCOTA,aAplic[nAscan][6],(SEH->EH_SLDCOTA * aAplic[nAscan][6]))
			Endif	
		EndIf		
		
		nVlrApl		:= xMoeda(aCalculo[1],1,MV_PAR05)
		nVlrIr		:= xMoeda(aCalculo[2],1,MV_PAR05)
		nVlrIof		:= xMoeda(aCalculo[3],1,MV_PAR05)
		nVlrOutros	:= xMoeda(aCalculo[4],1,MV_PAR05)
		
		nVlrImp		:= aCalculo[2]+aCalculo[3]+aCalculo[4]
		nVlrImp		:= xMoeda(nVlrImp,1,MV_PAR05)
		nVlrApl		-= nVlrImp
		nVlrJur		:= xMoeda(aCalculo[5],1,MV_PAR05)
		
		@ Li,000 PSAY SEH->EH_NUMERO+"/"+SEH->EH_REVISAO
		@ Li,010 PSAY SubStr(SEH->EH_NBANCO,1,20)
		@ Li,031 PSAY SEH->EH_TIPO
		@ Li,035 PSAY SEH->EH_DATA
		@ Li,046 PSAY SEH->EH_DATARES
		@ Li,057 PSAY xMoeda(SEH->EH_SALDO,1,MV_PAR05) PICTURE TM(xMoeda(SEH->EH_VALOR,1,MV_PAR05),15,2)

		If SEH->EH_TIPO $ cAplCotas
			@ Li,073 PSAY SEH->EH_VLRCOTA PICTURE TM(SEH->EH_VLRCOTA,14,6)
			If nAscan > 0
				@ Li,088 PSAY aAplic[nAscan][6] PICTURE TM(aAplic[nAscan][6],14,6)
			Endif	
		EndIf
		
		@ Li,103 PSAY nVlrJur         		PICTURE TM(nVlrJur,14,2)
		@ Li,118 PSAY (nVlrJur/aCalculo[1])*100	PICTURE "@E 999.999999%"
		nDias := dDataBase - SEH->EH_DATA
		nAscan	:= Ascan( aTabIrf, { |e| e[1] >= nDias } ) // Pesquisa a aliquota conforme o tempo da aplicacao
		nTaxaIrf	:= If(Empty(SEH->EH_TAXAIRF), If(SX5->(MsSeek(xFilial("SX5")+"AR")),;
							Val(TabelaIrf(cTabIrf,nDias)),aTabIrf[nAscan][2]),SEH->EH_TAXAIRF)
		If Empty(SEH->EH_TAXAIOF) .And. nDias > 0 .And. nDias < 30
			@ Li,132 PSAY VAL(TABELA("A0", STRZERO(nDias,2))) PICTURE "@E 99.99%"
		Else
			@ Li,132 PSAY SEH->EH_TAXAIOF	PICTURE "@E 99.99%"
		Endif	
		@ Li,139 PSAY nVlrIof         	PICTURE TM(nVlrJur,12,2)
		@ Li,156 PSAY SEH->EH_TAXAIRF		PICTURE "@E 99.99%"
		@ Li,165 PSAY nVlrIr	         	PICTURE TM(nVlrJur,12,2)
		@ Li,181 PSAY nVlrApl+nVlrIr   		PICTURE TM(nVlrApl,16,2)
		@ Li,198 PSAY SEH->EH_NUMAPL
		@ Li,209 PSAY SEH->EH_DTVENC
		
		Li++
		
		aTotal[TOTSALDO]	+= xMoeda(SEH->EH_SALDO,1,MV_PAR05)
		aTotal[TOTJUROS]	+= nVlrJur
		aTotal[TOTIOF]		+= nVlrIof
		aTotal[TOTIR]  	+= nVlrIr
		aTotal[TOTAPL]		+= nVlrApl+nVlrIr
		
	EndIf
	dbSelectArea("SEH")
	dbSkip()
	IncRegua()
EndDo
		
If ( 	aTotal[TOTSALDO]+	aTotal[TOTJUROS]+	aTotal[TOTIOF]+aTotal[TOTIR]+aTotal[TOTAPL] > 0 )
	Li++
	@ Li,000 PSAY STR0010 //"Total Geral" 
	@ Li,056 PSAY aTotal[TOTSALDO]	PICTURE TM(aTotal[TOTSALDO],16,2)
	@ Li,101 PSAY aTotal[TOTJUROS]	PICTURE TM(aTotal[TOTJUROS],16,2)
	@ Li,139 PSAY aTotal[TOTIOF]		PICTURE TM(aTotal[TOTIOF],12,2)
	@ Li,164 PSAY aTotal[TOTIR]		PICTURE TM(aTotal[TOTIR],13,2)
	@ Li,179 PSAY aTotal[TOTAPL]		PICTURE TM(aTotal[TOTAPL],18,2)
	Roda(cbcont,cbtxt,Tamanho)
EndIf

dbSelectArea("SEH")
dbSetOrder(1)
dbClearFilter()
Set Device To Screen
Set Printer To
 dbCommitAll()
If ( aReturn[5] == 1 )
	 OurSpool(wnrel)
Endif
MS_FLUSH()
Return( .T. )