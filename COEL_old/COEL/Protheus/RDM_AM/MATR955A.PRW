#INCLUDE "Matr955.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUN‡…O    ³ MATR955  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 23/06/95   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRI‡…O ³Emiss„o da Lista de Codigo de Emitentes Modelo P10            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SINTAXE   ³ MATR955(void)                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Marcos Simidu³05/01/98³13678A³Impressao loja Cli/Fornec.                ³±±
±±³ Edson   M.   ³09/03/98³XXXXXX³Acerto da comprssao.                      ³±±
±±³ Marcos Simidu³18/01/98³XXXXXX³Ordem Alfa.-Lista fornecedores de mesmo   ³±±
±±³              ³        ³XXXXXX³de mesmo nome mas de CGC diferentes.      ³±±
±±³ Marcos Simidu³18/01/98³XXXXXX³Ordem Cod.-Lista fornec.varias vezes.     ³±±
±±³ Andreia      ³05/11/99³24340a³Troca de CGC por CNPJ.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Matr955A()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL 	wnrel,lEnd:=.F.

PRIVATE tamanho:="M",;
	limite :=132,;
	titulo:=STR0001,; //"Lista de C¢digos de Emitentes"
	cDesc1:=STR0002,; //"Este relat¢rio imprimir  a Lista de C¢digos de Emitentes"
	cDesc2:=STR0003,; //"Modelo P10 ,conforme os parƒmetros informados."
	cDesc3:="",;
	aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",1 },; //"Zebrado"###"Administra‡„o"
	nomeprog:="MATR955",nLastKey:= 0,;
	cPerg   :="MTR955",;
	cString  := "SF3"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="MATR955"
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho)
If nLastKey==27
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| R955Imp(@lEnd,wnRel,cString,Tamanho)},titulo)

Set Filter to

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R955Imp  ³ Autor ³ Juan Jose Pereira     ³ Data ³ 18.12.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Relatorio                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION R955Imp(lEnd,wnRel,cString,Tamanho)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL	aCampos 	:=	{}
LOCAL aTam		:=	{}
LOCAL	cChave	
LOCAL	cAlias	:=	Alias()
PRIVATE lFirstPage:=.t.
PRIVATE li	:=	80
PRIVATE nPg	:=1
PRIVATE CbTxt
PRIVATE CbCont
PRIVATE cabec1
PRIVATE cabec2
PRIVATE cabec3
PRIVATE cNomArq
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega parametros                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTR955",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Data                              ³
//³ mv_par02             // Ate a Data                           ³
//³ mv_par03             // Livro Selecionado                    ³
//³ mv_par04             // Pagina Inicial                       ³
//³ mv_par05             // Ordem ? Alfabetica/Codigo            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDtIni	:=	mv_par01
dDtFim	:=	mv_par02
cNrLivro	:=	mv_par03
nPg		:=	IIf(Empty(mv_par04),1,mv_par04)
nOrdem	:=	mv_par05
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam	:=	TamSX3("A2_COD")
AADD(aCampos,{ "CODIGO","C",08, 0 } )   // 12345601
AADD(aCampos,{ "NOME"  ,"C",30, 0 } )
aTam	:=	TamSX3("A2_EST")
AADD(aCampos,{ "UF"    ,"C",atam[1],aTam[2] } )
aTam	:=	TamSX3("A2_CGC")
AADD(aCampos,{ "CGC"	  ,"C",atam[1],aTam[2] } )
aTam	:=	TamSX3("A2_INSCR")
AADD(aCampos,{ "INSCRI","C",atam[1],aTam[2] } )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq 	:=	CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq,"TRB", if(.T. .OR. .F., !.F., NIL), .F. )
cChave	:=	If(nOrdem==1,"NOME+CGC","CODIGO+CGC")
IndRegua("TRB",cNomArq,cChave,,,STR0006) //"Selecionando Registros..."
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona arquivos SA1/SA2.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)

dbSelectArea("SA2")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre SF3 para montar o arquivo de trabalho.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
dbSetOrder(4)
dbSeek(xFilial(),.F.)
SetRegua(LastRec())

Do While !EOF() .And. (SF3->F3_FILIAL == xFilial())
	IncRegua()
	If Interrupcao(@lEnd)
		Exit
	Endif
   
	If !empty( F3_DTLANC)
		dbskip()
		loop
	EndIf
		
	lLoop:=IIf(cNrLivro=="*",.f.,IIf(cNrLivro<>F3_NRLIVRO,.t.,.f.))

	If Substr(F3_CFO,1,1) >= "5" .or. lLoop.or.F3_ENTRADA < dDtIni .Or. F3_ENTRADA > dDtFim
		dbSkip()
		Loop
	EndIf

	If F3_TIPO $ "DB"
		dbSelectArea("SA1")
		dbSeek(F3Filial("SA1")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
		dbSelectArea("TRB")
		If nOrdem==1
			dbSeek(Substr(SA1->A1_NOME,1,30)+SA1->A1_CGC)
		Else
			dbSeek(SA1->A1_COD+SA1->A1_LOJA+SA1->A1_CGC)
		Endif
		If !Found()
			RecLock("TRB",.T.)
			TRB->CODIGO	:= SA1->A1_COD+SA1->A1_LOJA
			TRB->NOME	:= Substr(SA1->A1_NOME,1,30)
			TRB->UF		:= SA1->A1_EST
			TRB->CGC		:= SA1->A1_CGC
			TRB->INSCRI	:= SA1->A1_INSCR
		EndIf
	Else
		dbSelectArea("SA2")
		dbSeek(F3Filial("SA2")+SF3->F3_CLIEFOR+SF3->F3_LOJA)
		dbSelectArea("TRB")
		If nOrdem==1
			dbSeek(Substr(SA2->A2_NOME,1,30)+SA2->A2_CGC)
		Else
			dbSeek(SA2->A2_COD+SA2->A2_LOJA+SA2->A2_CGC)
		Endif
		If !Found()
			RecLock("TRB",.T.)
			TRB->CODIGO	:= SA2->A2_COD+SA2->A2_LOJA
			TRB->NOME	:= Substr(SA2->A2_NOME ,1,30)
			TRB->UF		:= SA2->A2_EST
			TRB->CGC	:= SA2->A2_CGC
			TRB->INSCRI	:= SA2->A2_INSCR
		Endif
	EndIf
	dbSelectArea("SF3")
	dbSKip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na segunda regua de processamento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGotop()
SetRegua(LastRec())
Do While !Eof().and.!lEnd
	IncRegua()
	If Interrupcao(@lEnd)
		Exit
	EndIf

	If li > 55
		Cabecalho()
	EndIf

	@ Li,000 PSAY "|"
	@ Li,005 PSAY Padr(CODIGO,6)+" / "+Subs(CODIGO,7)
	@ Li,020 PSAY "|"
	@ Li,024 PSAY NOME
	@ Li,059 PSAY "|"
	@ Li,067 PSAY UF
	@ Li,077 PSAY "|"
	@ Li,083 PSAY CGC		PICTURE If(Len(Alltrim(CGC))==14,"@R 99.999.999/9999-99","@R 999.999.999-99")
	@ Li,104 PSAY "|"
	@ Li,109 PSAY INSCRI	PICTURE PesqPict("SA2","A2_INSCR")
	@ Li,131 PSAY "|"
	Li++
	dbSkip()
EndDo

If !li==80.and.!lEnd
	@ li,00 PSAY __PrtThinLine()
EndIf

dbSelectArea("TRB")
dbCloseArea()
FErase(cNomarq+GetDBExtension())
FErase(cNomarq+OrdBagExt())

dbSelectArea(cAlias)
dbSetOrder(1)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CABECALHO ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 23/06/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emiss„o do Cabecalho p/ Lista de Codigo de Emitentes        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cabecalho()  	                                       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cabecalho()
If !lFirstPage
	@ li,00 PSAY __PrtThinLine()
Else
	lFirstPage:=.f.
EndIf
Li:=0
@ Li++,00 PSAY AvalImp(132)
@ li,00 PSAY __PrtThinLine()
Li++
@ LI,00 PSAY STR0007 //"|                                                   LISTA DE CODIGOS DE EMITENTES"
@ LI,131 PSAY "|"
Li++
@ Li,00 PSAY STR0008+SM0->M0_NOMECOM //"| FIRMA : "
@ Li,131 PSAY "|"
Li++
@ Li,00 PSAY STR0009+"06.300.298-1"
@ Li,40 PSAY STR0010+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") //"C.N.P.J. : "
@ Li,131 PSAY "|"
Li++
@ Li,00 PSAY STR0011+TRANSFORM(nPg,"@E 9,999") //"| FOLHA: "
@ Li,40 PSAY STR0012+ DTOC(dDtIni)+STR0013+DTOC(dDtFim) //"PERIODO : "###" ATE "
@ Li,131 PSAY "|"
Li++
@ Li,00 PSAY __PrtThinLine()
Li++
@ Li,00 PSAY STR0014 //"|     CODIGO DO     |     EMITENTE DO DOCUMENTO FISCAL     |     UNIDADE     |   INSCRICAO NO C.N.P.J.  |         INSCRICAO        |"
Li++
@ Li,00 PSAY STR0015 //"|     EMITENTE      |                                      |       DA        |                          |          ESTADUAL        |"
Li++
@ Li,00 PSAY STR0016 //"|                   |                                      |    FEDERACAO    |                          |                          |"
Li++
@ Li,00 PSAY "--------------------+--------------------------------------+-----------------+--------------------------+---------------------------"
Li++
//		        0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19       200       210       220
//     		  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
nPg++

Return
