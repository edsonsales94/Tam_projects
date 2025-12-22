#include "rwmake.ch"        
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function matrciap()       


SetPrvt("TAMANHO,TITULO,CDESC1,CDESC2,CDESC3,ARETURN")
SetPrvt("LIMITE,NOMEPROG,NLASTKEY,CPERG,ADRIVER,ALAY")
SetPrvt("NLIN,NRESUMO,CCODIGO,ARESUMO,NCNTFOR,NFOLHA")
SetPrvt("NTIPO,M_PAG,AREGISTROS,DLEI102,CSTRING,CABEC1")
SetPrvt("CABEC2,NPAGINA,LEND,I,J,WNREL")
SetPrvt("DDATA,")

#IFNDEF WINDOWS                              
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 03/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATRCIAP  ³ Autor ³ Andreia dos Santos    ³ Data ³ 14.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emiss„o de Demonstrativo de bens do Ativo Permanente -Estado³±±
±±³          ³de Minas Gerais                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MATRCIAP(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
tamanho	:=	""
titulo	:=	"Demonstrativo de bem do Ativo "
cDesc1	:=	"Demonstrativo de bem do Ativo entrado no estabelecimento"
cDesc2	:=	"a partir de 1 de agosto de 2000"
cDesc3	:=	""
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 } //
Limite 	:= 	132
nomeprog:=	"MATRCIAP"
nLastKey:=	0
cPerg   :=	"MTRCIA"
aDriver :=	ReadDriver()
aLay	:= array(29)
nLin	:= 80
nResumo	:= 0
cCodigo	:= ""
aResumo	:= array(12,4)
nCntFor	:= 0
nFolha	:= 0
nTipo	:=	18
m_pag:=1
aRegistros:= {}
dLei102 := GetNewPar("MV_DATCIAP",ctod("01/01/2001"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString  :="SF9"
cabec1   := ""
cabec2   := ""      
nPagina:=1          
lEND	:= .F.
aeval( aResumo,{|x|afill(x,0)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria as perguntas se nao existirem                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF9")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Codigo De   ?                        ³
//³ mv_par02             // Codigo Ate  ?                        ³
//³ mv_par03             // Data Fiscal de ?                     ³
//³ mv_par04             // Data Fiscal Ate?                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:="MATRCIAP"   // nome default do relatorio em disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")


If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFNDEF WINDOWS
	RDEMOCIAP(.F.,wnRel,cString,Tamanho)
#ELSE
	RptStatus({|| RDEMOCIAP()})// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> 	RptStatus({|| Execute(RDEMOCIAP)})
#ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF9")
dbSetOrder(1)
#IFNDEF WINDOWS
	Set Device To Screen
#ENDIF
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CabLivro() ³ Autor ³ Juan Jose Pereira     ³ Data ³01/06/95³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Cabecalho do Livro                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATRISS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function CabLivro
Static Function CabLivro()

aLay[01] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[02] :="|                                            DEMONSTRATIVO DE CREDITO DE ICMS DO ATIVO PERMANENTE - CIAP                                        |"
aLay[03] :="|                                                                                                                                               |"
aLay[04] :="| ANO: ####                                                                                                                         No. ######  |"
aLay[05] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[06] :="| 1 - IDENTIFICACAO DO CONTRIBUINTE                                                                                                             |"
aLay[07] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[08] :="|Nome: ######################################## C.N.P.J. No: ##################    Inscricao Estadual No: ##################################### |"
aLay[09] :="|Endereco: ####################################   Bairro: #####################    Municipio: ################################################# |"
aLay[10] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[11] :=""
aLay[12] :="+-----------------------------------------------------------------------------------------------------------------------------------------------+"
aLay[13] :="| 2 - IDENTIFICACAO DO BEM                                                                                                                      |"
aLay[14] :="+---------------+----------+----------------+----------------------------------------------------+---------------------------------+------------+"
aLay[15] :="|               |          |                |                                                    |         VALOR DO ICMS           |            |"
aLay[16] :="| No ou Codigo  |   Data   |   Nota Fiscal  | Descricao Resumida                                 |        DESTACADO NA NF          |   CFOP     |"
aLay[17] :="+---------------+----------+----------------+----------------------------------------------------+---------------------------------+------------+"
aLay[18] :="|    ######     | ######## |      #######   | ##########################################         |     ######################      |   ######   |"
aLay[19] :="+---------------+----------+----------------+----------------------------------------------------+---------------------------------+------------+"
aLay[20] :="+---------------------------------------------------------------------------------------+"
aLay[21] :="| 3 - DEMONSTRATIVO DE CREDITO                                                          |"
aLay[22] :="+----------+----------------------------------------------------------------------------+"
aLay[23] :="|          |    OPERACOES E PRESTACOES   |              |        |                      |"
aLay[24] :="|          +--------------+--------------+ COEFICIENTE  | FRACAO | CREDITO POR SAIDAS   |"
aLay[25] :="|    MES   |              |  TOTAL DAS   |  DE CREDITO  | MENSAL |      TRIBUTADAS      |"
aLay[26] :="|          | TRIBUTADA (1)|  SAIDAS (2)  | (3 = 1 / 2)  | ( 4 )  |          (5)         |"
aLay[27] :="+----------+--------------+--------------+--------------+--------+----------------------+"
aLay[28] :="| ######## |##############|##############|##############|  ####  |######################|"
aLay[29] :="+----------+--------------+--------------+--------------+--------+----------------------+"

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RDEMOCIAP ³ Autor ³ Andreia dos Santos    ³ Data ³14/09/00  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Demonstrativo p/ Credito de Ativo             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATRCIAP                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 03/09/02 ==> Function RDEMOCIAP
Static Function RDEMOCIAP()
CabLivro()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculando as movimentacoes do SF3                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF3")
dbSetOrder(1)
dbSeek(xFilial("SF3")+Dtos(MV_PAR03),.T.)
SetRegua(LastRec())
While ( !Eof() .And. xFilial("SF3") == F3_FILIAL .And.;
							MV_PAR03	<= F3_ENTRADA.And.;
							MV_PAR04	>= F3_ENTRADA )
	nResumo := Month(F3_ENTRADA)       
	IF Substr(F3_CFO,1,1) >= '5'	
		aResumo[nResumo][1] := aResumo[nResumo][1]+SF3->F3_BASEICM
		aResumo[nResumo][2] := aResumo[nResumo][2]+SF3->F3_BASEICM+SF3->F3_ISENICM+SF3->F3_OUTRICM
		aResumo[nResumo][3] := NoRound(aResumo[nResumo][1]/aResumo[nResumo][2],4)
	EndIf
	dbSelectArea("SF3")
	dbSkip()
	IncRegua()
EndDo


dbSelectArea("SF9")
dbSetOrder(1)
dbSeek(xFilial("SF9")+MV_PAR01,.T.)

SetRegua(LastRec())

While ( !Eof() .And. xFilial("SF9")==F9_FILIAL .And.;
			F9_CODIGO <= MV_PAR02 )

	IF SF9->F9_DTENTNE < dLei102
		SF9->(dbSkip())
		loop
	EndIf               
	
	nLin := 0
  	cCodigo	:= F9_CODIGO
	aeval( aResumo,{|x|afill(x,0,4)})

   	If Interrupcao(@lEnd)
		Exit
	EndIf

	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)			
	nLin	:=	PROW()+1
	nFolha 	:= nFolha+1
	FmtLin(,aLay[01],,,@nLin)
	FmtLin(,aLay[02],,,@nLin)
	FmtLin(,aLay[03],,,@nLin)
	FmtLin({StrZero(Year(MV_PAR03),4),StrZero(nFolha,4)},aLay[04],,,@nLin)
	FmtLin(,aLay[05],,,@nLin)
	FmtLin(,aLay[06],,,@nLin)
	FmtLin(,aLay[07],,,@nLin)
	FmtLin({SM0->M0_NOMECOM,Transf(SM0->M0_CGC,"@R 99.999.999/9999-99"),SM0->M0_INSC},aLay[08],,,@nLin)
	FmtLin({SM0->M0_ENDCOB,"",SM0->M0_CIDCOB},aLay[09],,,@nLin)
	FmtLin(,aLay[10],,,@nLin)
	FmtLin(,aLay[11],,,@nLin)
	FmtLin(,aLay[12],,,@nLin)
	FmtLin(,aLay[13],,,@nLin)
	FmtLin(,aLay[14],,,@nLin)
	FmtLin(,aLay[15],,,@nLin)
	FmtLin(,aLay[16],,,@nLin)
	FmtLin(,aLay[17],,,@nLin)
	dData := F9_DTENTNE

	dbSelectArea("SFA")
	dbSetOrder(1)
	dbSeek(xFilial("SFA")+cCODIGO)
	While ( !Eof() .And. xFilial("SFA") == FA_FILIAL .And.;
								cCODIGO == FA_CODIGO )
		
		if FA_CREDIT <> "1"
		   dbSkip()
		   loop
		EndIf   
		If ( Year(MV_PAR03) == Year(FA_DATA) )
			nResumo := Month(FA_DATA)
			If ( FA_TIPO == "1" ) //Credito Mensal
				aResumo[nResumo][4] := aResumo[nResumo][4] +FA_VALOR
			endIf	
		EndIf
		dbSelectArea("SFA")
		dbSkip()
	EndDo                    
	dbSelectArea("SF9")
	
	FmtLin({ F9_CODIGO,;
				dData,;
				If(Empty(F9_DOCNFS),F9_DOCNFE,F9_DOCNFS),;
				F9_DESCRI,;
				F9_VALICMS,;
				F9_CFOENT},aLay[18],,,@nLin)
	nResumo := Month(dData)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao do Demonstrativo de Credito                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FmtLin(,aLay[17],,,@nLin)
	FmtLin(,aLay[20],,,@nLin)
	FmtLin(,aLay[21],,,@nLin)
	FmtLin(,aLay[22],,,@nLin)
	FmtLin(,aLay[23],,,@nLin)
	FmtLin(,aLay[24],,,@nLin)
	FmtLin(,aLay[25],,,@nLin)
	FmtLin(,aLay[26],,,@nLin)
	FmtLin(,aLay[27],,,@nLin)
	
	For nCntFor := 1 To 12
		FmtLin({ MesExtenso(nCntFor),; 	//Mes
					 aResumo[nCntFor,1],;	//.Tributadas
					 aResumo[nCntFor,2],;	//Total das Saidas
					 TransForm(aResumo[nCntFor,3],Tm(aResumo[nCntFor,3],8,4)),;	//Coeficiente de Credito
					 "1/48",;
					 aResumo[nCntFor,4],;	// Valor do imposto efetivamente creditado
					 },aLay[28],,,@nLin)
	Next nCntFor
	FmtLin(,aLay[29],,,@nLin)
	dbSkip()
	IncRegua()
EndDo

Return


