#INCLUDE "CTBR010.CH"
//#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ctbr010  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 10/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Impressao do Plano de Contas              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr010()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctbr010a(wnRel,dDataRef,cMoeda)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cString	:="CT1"
LOCAL aOrd	 	:= {OemToAnsi(STR0004),OemToAnsi(STR0005)}  //"Conta"###"Descri‡„o"
LOCAL cDesc1 	:= OemToAnsi(STR0001)  //"Este programa ir  imprimir o Plano de Contas."
LOCAL cDesc2 	:= OemToAnsi(STR0002)  //"Ser  impresso de acordo com os parƒmetros solicitados pelo"
LOCAL cDesc3 	:= OemToAnsi(STR0003)  //"usu rio."
Local lExterno 	:= wnRel <> Nil

lOCAL dDataRef:= dDataBase
//DEFAULT dDataRef:= dDataBase
PRIVATE Tamanho	:="M"
PRIVATE aReturn := { OemToAnsi(STR0006), 1,OemToAnsi(STR0007), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="CTBR010"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="CTR010"

li       := 80

pergunte("CTR010",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01		// da conta                             	³
//³ mv_par02      	// ate a conta                          	³
//³ mv_par03      	// imprime centro de custo               	³ 
//³ mv_par04      	// folha inicial		         			³
//³ mv_par05		// Analitica - Sintetica - Todas        	³ 
//³ mv_par06		// Desc na Moeda						   	³ 
//³ mv_par07		// Imprime Bloqueadas?         	       		³ 
//³ mv_par08		// Mascara                    	       		³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE titulo := OemToAnsi(STR0008)  //"Listagem do Plano de Contas"
PRIVATE cabec1 := OemToAnsi(STR0009)  //"CONTA                          DC COD.RES.   D E N O M I N A C A O                    CLASSE COND NORMAL CTA SUPERIOR         BLOQ"
PRIVATE cabec2 := " "
PRIVATE cCancel:= OemToAnsi(STR0010)  //"***** CANCELADO PELO OPERADOR *****"

If ! lExterno
	wnrel:="CTBR010"            //Nome Default do relatorio em Disco
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
Else
	mv_par01 := Repl(" ", Len(mv_par01))
	mv_par02 := Repl("Z", Len(mv_par02))
	mv_par06 := cMoeda
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif

If ! lExterno
	SetDefault(aReturn,cString)
Endif

If Empty(mv_par06)
	Set Filter To
	Help(" ",1,"NOMOEDA")
	Return
EndIf

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTr010Imp(@lEnd,wnRel,cString,lExterno)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Ctr010Imp³ Autor ³ Pilar S Albaladejo    ³ Data ³ 10/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Impressao do Plano de Contas              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr010(lEnd,wnRel,cString)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBR010                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctr010Imp(lEnd,WnRel,cString,lExterno)

LOCAL limite := 80//132
LOCAL cClasse
Local cMascara
Local cSeparador 	:= ""

If Empty(mv_par08)
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara := RetMasCtb(mv_par08,@cSeparador)
EndIf

// Verifica ordem a ser impressa                                
nOrdem := aReturn[8]

dbSelectArea("CT1")
IF nOrdem == 2
	cChave 	:= "CT1_FILIAL+CT1_DESC"+mv_par06
	cIndex	:= CriaTrab(nil,.f.)
	IndRegua("CT1",cIndex,cChave,, "CT1_CONTA >= '" + mv_par01 + "' .And. " +;
									"CT1_CONTA <= '" + mv_par02 + "'",OemToAnsi(STR0011)) //"Selecionando Registros..."
	nIndex	:= RetIndex("CT1")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbSeek(xFilial("CT1"))
Else
	dbSetOrder( 1 )
	dbSeek( xFilial("CT1")+mv_par01,.T. )
End

SetRegua(RecCount())   						// Total de elementos da regua

If nOrdem == 1
	dbSelectArea("CT1")
	dbSetOrder(1)
	cCondicao:=	"CT1->CT1_FILIAL == xFilial('CT1') .And. CT1->CT1_CONTA <= mv_par02 .And. !Eof()"
Else
	dbSelectarea("CT1")
	dbSetOrder(nIndex+1)
	cCondicao := "CT1->CT1_FILIAL == xFilial('CT1') .And. !Eof()"
EndIF

If ! lExterno
	m_pag:=mv_par04
Endif

While &cCondicao

	If lEnd 	
		@Prow()+1,001 PSAY cCancel
		Exit
	EndIF
     
	IncRegua()
	
	IF mv_par03 == 2
		IF CT1->CT1_NCUSTO > 0
			dbSkip()
			Loop
		EndIF
	EndIF

	If mv_par07 == 2
		If CT1->CT1_BLOQ == "1"				// Conta Bloqueada
			dbSkip()
			Loop
		EndIf
	EndIf

	If mv_par05 == 1							// Imprime Analiticas
		If CT1->CT1_CLASSE == "1"
			dbSkip()
			Loop
		EndIf
	ElseIF mv_par05 ==2						// Imprime Sinteticas
		IF CT1->CT1_CLASSE = "2"
			dbSkip()
			Loop
		EndIf
	EndIf
		
	IF li > 55
		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
		li--
	EndIF

	cCodigo	:=	Alltrim(CT1_CONTA)
	cDesc := &('CT1->CT1_DESC'+mv_par06)

	li++

	EntidadeCTB(CT1->CT1_CONTA,li,000,015,.F.,cMascara,cSeparador)
	@li, 016 PSAY CT1->CT1_DC        
	@li, 019 PSAY CT1->CT1_RES
	@li, 030 PSAY cDesc              
	
	If CT1->CT1_CLASSE == '1'
		@li, 071 PSAY OemToAnsi(STR0014)
	ElseIf CT1->CT1_CLASSE == '2'
		@li, 071 PSAY OemToAnsi(STR0015)
	EndIf
	
	If CT1->CT1_NORMAL == '1'
		@li, 078 PSAY OemToAnsi(STR0016)
	ElseIf CT1->CT1_NORMAL =='2'
		@li, 078 PSAY OemToAnsi(STR0017)
	EndIf
	
	//@li, 106 PSAY CT1->CT1_CTASUP
	//If CT1->CT1_BLOQ == "1"	
	//	@li, 126 PSAY OemToAnsi(STR0012)	//Sim
	//ElseIf CTT->CTT_BLOQ == "2"	
	//	@li, 126 PSAY OemToAnsi(STR0013)	// Nao
	//EndIf					
	dbSkip( )

EndDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se emissao foi alfabetica, deleta arquivo de trabalho        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 2
	dbSelectArea("CT1")
	dbClearFil(NIL)
	RetIndex( "CT1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
EndIf

dbSelectarea( "CT1" )
dbSetOrder( 1 )
IF ! lExterno .And. li != 80
	roda(0,"","M")
EndIF

Set Filter To
If aReturn[5] = 1 .And. ! lExterno
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

If ! lExterno
	MS_FLUSH()
Endif

Return