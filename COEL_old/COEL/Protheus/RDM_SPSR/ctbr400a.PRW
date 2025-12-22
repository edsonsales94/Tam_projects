#Include "CTBR400a.Ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR400a  ³ Autor ³ Rogerio Batista       ³ Data ³ 12.09.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao do Razao por centro de custos Específico           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR400a()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR400a(	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
					cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
					lClVl, cClvlIni, cClvlFim,lSaltLin)

Local aCtbMoeda	:= {}           
Local cDesc1		:= STR0001	//"Este programa ir  imprimir o Raz„o Contabil,"
Local cDesc2		:= STR0002	// "de acordo com os parametros solicitados pelo"
Local cDesc3		:= STR0003	// "usuario."
Local cString		:= "CT2"
Local titulo		:= STR0006 	//"Emissao do Razao Contabil"
Local lAnalitico 	:= .T.
Local lRet			:= .T.
Local lExterno		:= cContaIni <> Nil
Local nTamLinha  	:= 132
Local nTamConta		:= Len(CriaVar ("CT1_CONTA"))
Local cSepara1		:= ""

Local WnRel			:= "CTBR400A"
lCusto		:= .F.
lItem		:= .F.
lCLVL		:= .F.
lSaltLin	:= .T.
cSayCC := Upper(AllTrim(CtbSayApro("CTT"))) + " "  + STR0026
cSayIT := Upper(AllTrim(CtbSayApro("CTD"))) + " "  + STR0026
cSayCL := Upper(AllTrim(CtbSayApro("CTH"))) + " "  + STR0026
lUsaTRB		  := .T.
Private aReturn	:= { STR0004, 1,STR0005, 2, 2, 1, "", 1 }  //"Zebrado"###"Administracao"
Private aLinha		:= {}

Private cPerg		:= "CTR400"

Private nomeprog	:= "CTBR400A"
Private nLastKey	:= 0

Private Tamanho 	:= "M"
Private lSalLin		:= .T.

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

//AjusteSX1()
Pergunte("CTR400", .F.)
lCodImp := AjCodImpX1("CTR400","11",3)			// AJUSTA O SX1 PARA USAR O CODIGO DE IMPRESSAO DO PLANO DE CONTAS
AjCTR400MV9()									// AJUSTA O SX1 (PERGUNTA 09) PARA IMPRIMIR S/ MOVIMENTO COM SALDO ANTERIOR.
If ! lExterno
	If ! Pergunte("CTR400", .T.)
		Return
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // da conta                              ³
//³ mv_par02            // ate a conta                           ³
//³ mv_par03            // da data                               ³
//³ mv_par04            // Ate a data                            ³
//³ mv_par05            // Moeda			                          ³   
//³ mv_par06            // Saldos		                          ³   
//³ mv_par07            // Set Of Books                          ³
//³ mv_par08            // Analitico ou Resumido dia (resumo)    ³
//³ mv_par09            // Imprime conta sem movimento?          ³
//³ mv_par10            // Junta Contas com mesmo C.Custo?       ³
//³ mv_par11            // Impr Cod (Normal/Reduzida/Cod.Impress)³ /// VER CT1_CODIMP
//³ mv_par12            // Imprime C.Custo?                      ³
//³ mv_par13            // Do Centro de Custo                    ³
//³ mv_par14            // At‚ o Centro de Custo                 ³
//³ mv_par15            // Imprime Item?	                       ³	
//³ mv_par16            // Do Item                               ³
//³ mv_par17            // Ate Item                              ³
//³ mv_par18            // Imprime Classe de Valor?              ³	
//³ mv_par19            // Da Classe de Valor                    ³
//³ mv_par20            // Ate a Classe de Valor                 ³
//³ mv_par21            // Salto de pagina                       ³
//³ mv_par22            // Pagina Inicial                        ³
//³ mv_par23            // Pagina Final                          ³
//³ mv_par24            // Numero da Pag p/ Reiniciar            ³	   
//³ mv_par25            // Imprime Cod C.Custo(Normal / Reduzido)³
//³ mv_par26            // Imprime Cod Item (Normal / Reduzido)  ³
//³ mv_par27            // Imprime Cod Cl.Valor(Normal /Reduzida)³
//³ mv_par28            // Imprime Total Geral (Sim/Nao)         ³
//³ mv_par29            // So Livro/Livro e Termos/So Termos     ³
//³ mv_par30		  		//"Salta linha entre contas?"
//³ mv_par31            // Num.linhas p/ o Razao?				 ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAnalitico	:= Iif(mv_par08 == 1,.T.,.F.)
If !lExterno
	lCusto 			:= Iif(mv_par12 == 1,.T.,.T.)
	lItem			:= Iif(mv_par15 == 1,.F.,.F.)
	lCLVL			:= Iif(mv_par18 == 1,.F.,.F.)  
EndIf

nTamLinha	:= Iif(lAnalitico, 132, 132)
aSetOfBook	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books -> Conf. da Mascara / Valores   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Ct040Valid(mv_par07)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par07)
EndIf

If !lRet
	Set Filter To
	Return
EndIf

// Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1	:= RetMasCtb(aSetOfBook[2],@cSepara1)
	//A mascara sera considerada no tamanho da conta somente com a mascara da configuracao de livros. 
	//Quando nao tiver configuracao de livros, o relatorio podera ser impresso em formato retrato e, caso 
	//nao haja espaco para a impressao do codigo da conta (contra-partida), esse codigo sera truncado.
	nTamConta		:= nTamConta+Len(ALLTRIM(cMascara1))	
EndIf               

If (lAnalitico .And. (!lCusto .And. !lItem .And. !lCLVL) .And. nTamConta <= 22) .Or. ! lAnalitico 
	Tamanho := "M"
	nTamLinha := 132
EndIf	

wnrel := SetPrint(cString,wnrel,If(! lExterno, cPerg,),@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
//Verifica se o relatorio foi chamado a partir de outro programa. Ex. CTBC400
If ! lExterno
	lCusto 	        := Iif(mv_par12 == 1,.T.,.T.)
	lItem			:= Iif(mv_par15 == 1,.F.,.F.)
	lCLVL			:= Iif(mv_par18 == 1,.F.,.F.)
Else  //Caso seja externo, atualiza os parametros do relatorio com os dados passados como parametros.	
	mv_par01 := cContaIni
	mv_par02 := cContaFim
	mv_par03 := dDataIni
	mv_par04 := dDataFim
	mv_par05 := cMoeda
	mv_par06 := cSaldos
	mv_par07 := cBook
	mv_par12 := If(lCusto =.T.,1,2)
	mv_par13 := cCustoIni
	mv_par14 := cCustoFim
	mv_par15 := If(lItem =.T.,1,2)
	mv_par16 := cItemIni
	mv_par17 := cItemFim
	mv_par18 := If(lClVl =.T.,1,2)
	mv_par19 := cClVlIni
	mv_par20 := cClVlFim
	mv_par30 := If(lSaltLin==.T.,1,2)
Endif
lAnalitico	:= Iif(mv_par08 == 1,.T.,.F.)

nTamLinha	:= If( lAnalitico, 132, 132)


If (lAnalitico .And. (!lCusto .And. !lItem .And. !lCLVL).And. nTamConta<= 22) .Or. ! lAnalitico
	Tamanho := "M"
	nTamLinha := 132
EndIf	

If nLastKey = 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books -> Conf. da Mascara / Valores   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Ct040Valid(mv_par07)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par07)
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par05)
   If Empty(aCtbMoeda[1])
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If !lRet	
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR400Imp(@lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,;
	   	lAnalitico,Titulo,nTamlinha,aCtbMoeda, nTamConta)})

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTR400Imp ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Razao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³Ctr400Imp(lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,;      ³±±
±±³           ³          lCLVL,Titulo,nTamLinha,aCtbMoeda)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd       - A‡ao do Codeblock                             ³±±
±±³           ³ wnRel      - Nome do Relatorio                             ³±±
±±³           ³ cString    - Mensagem                                      ³±±
±±³           ³ aSetOfBook - Array de configuracao set of book             ³±±
±±³           ³ lCusto     - Imprime Centro de Custo?                      ³±±
±±³           ³ lItem      - Imprime Item Contabil?                        ³±±
±±³           ³ lCLVL      - Imprime Classe de Valor?                      ³±± 
±±³           ³ Titulo     - Titulo do Relatorio                           ³±±
±±³           ³ nTamLinha  - Tamanho da linha a ser impressa               ³±± 
±±³           ³ aCtbMoeda  - Moeda                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR400Imp(lEnd,WnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,lAnalitico,Titulo,nTamlinha,;
						aCtbMoeda,nTamConta)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSaldoAnt		:= {}
Local CbTxt
Local cbcont
Local Cabec1		:= ""
Local Cabec2		:= ""

Local cDescMoeda
Local cMascara1
Local cMascara2
Local cMascara3
Local cMascara4
Local cPicture
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local cSaldo		:= mv_par06
Local cContaIni		:= mv_par01
Local cContaFIm		:= mv_par02
Local cCustoIni		:= mv_par13
Local cCustoFim		:= mv_par14
Local cItemIni		:= mv_par16
Local cItemFim		:= mv_par17
Local cCLVLIni		:= mv_par19
Local cCLVLFim		:= mv_par20
Local cContaAnt		:= ""
Local dDataAnt		:= CTOD("  /  /  ")
Local cDescConta	:= ""
Local cCodRes		:= ""
Local cResCC		:= ""
Local cResItem		:= ""
Local cResCLVL		:= ""
Local cDescSint		:= ""
Local cMoeda		:= mv_par05
Local cContaSint	:= ""
Local cArqTmp
Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVl		:= CtbSayApro("CTH")
Local cNormal := ""
Local dDataIni		:= mv_par03
Local dDataFim		:= mv_par04
Local lNoMov		:= Iif(mv_par09==1,.T.,.F.)
Local lSldAnt		:= Iif(mv_par09==3,.T.,.F.)
Local lJunta		:= Iif(mv_par10==1,.T.,.F.)
Local lSalto		:= Iif(mv_par21==1,.T.,.F.)
Local lFirst		:= .T.
Local lImpLivro		:=.t.
Local lImpTermos	:=.f.
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nPagIni		:= mv_par22
Local nReinicia 	:= mv_par24
Local nPagFim		:= mv_par23
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0, aColunas 
Local l1StQb 		:= .T.
Local lQbPg			:= .F.
Local lEmissUnica	:= If(GetNewPar("MV_CTBQBPG","M") == "M",.F.,.F.)			/// U=Quebra única (.F.) ; M=Multiplas quebras (.T.)
Local lNewPAGFIM	:= If(nReinicia > nPagFim,.T.,.F.)
Local LIMITE		:= If(TAMANHO=="M",132,If(TAMANHO=="M",132,80))
Local nMaxLin   	:= MV_PAR32

Local cFilCT1		:= ""
Local cFilCTT		:= ""
Local cFilCTD		:= ""
Local cFilCTH		:= ""
Local cFilCT2	 	:= ""

Local lSemMov		:= .F.
Local cUFilter		:= ".T."

Local nBloco		:= 0
Local nBlCount		:= 0
lSalLin		:= If(mv_par30 ==1 ,.T.,.F.)
m_pag    := 1
If lEmissUnica
	CtbQbPg(.T.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
Endif

dbSelectArea("CT1")
cFilCT1	:= xFilial("CT1")
dbSelectArea("CTT")
cFilCTT	:= xFilial("CTT")
dbSelectArea("CTD")
cFilCTD	:= xFilial("CTD")
dbSelectArea("CTH")
cFilCTH	:= xFilial("CTH")
dbSelectArea("CT2")
cFilCT2	:= xFilial("CT2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par29==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par29==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par29==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80


cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)

// Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := ""//GetMv("MV_MASCARA")
Else
	cMascara1	:= ""//RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf               

If lCusto .Or. lItem .Or. lCLVL
	// Mascara do Centro de Custo
	If Empty(aSetOfBook[6])
		cMascara2 := ""//GetMv("MV_MASCCUS")
	Else
		cMascara2	:=""// RetMasCtb(aSetOfBook[6],@cSepara2)
	EndIf                                                
	// Mascara do Item Contabil
	If Empty(aSetOfBook[7])
		dbSelectArea("CTD")
		cMascara3 := ALLTRIM(STR(Len(CTD->CTD_ITEM)))
	Else
		cMascara3 := RetMasCtb(aSetOfBook[7],@cSepara3)
	EndIf
	// Mascara da Classe de Valor
	If Empty(aSetOfBook[8])
		dbSelectArea("CTH")
		cMascara4 := ALLTRIM(STR(Len(CTH->CTH_CLVL)))
	Else
		cMascara4 := RetMasCtb(aSetOfBook[8],@cSepara4)
	EndIf
EndIf	

cPicture 	:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")== "U"
	IF lAnalitico
		Titulo	:=	STR0007	//"RAZAO ANALITICO EM "
	Else
		Titulo	:=	STR0008	//"RAZAO SINTETICO EM "
	EndIf
	Titulo += 	cDescMoeda + STR0009 + DTOC(dDataIni) +;	// "DE"
				STR0010 + DTOC(dDataFim) + CtbTitSaldo(mv_par06)	// "ATE"
Else
	Titulo := NewHead
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Resumido                                  						         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// DATA                         					                                DEBITO               CREDITO            SALDO ATUAL
// XX/XX/XXXX 			                                 		     99,999,999,999,999.99 99,999,999,999,999.99 99,999,999,999,999.99D
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16         17        18        19        20       21        22
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabe‡alho Conta                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// DATA
// LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA                      DEBITO          CREDITO       SALDO ATUAL"
// XX/XX/XXXX         
// XXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 9999999999999.99 9999999999999.99 9999999999999.99D
// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabe‡alho Conta + CCusto + Item + Classe de Valor								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// DATA
// LOTE/SUB/DOC/LINHA  H I S T O R I C O                        C/PARTIDA                      CENTRO CUSTO         ITEM                 CLASSE DE VALOR                     DEBITO               CREDITO           SALDO ATUAL"
// XX/XX/XXXX 
// XXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 99,999,999,999,999.99 99,999,999,999,999.99 99,999,999,999,999.99D
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16         17        18        19        20       21        22
/*
#DEFINE 	COL_NUMERO 			1
#DEFINE 	COL_HISTORICO		2
#DEFINE 	COL_CONTRA_PARTIDA	3
#DEFINE 	COL_CENTRO_CUSTO 	4
#DEFINE 	COL_ITEM_CONTABIL 	5
#DEFINE 	COL_CLASSE_VALOR  	6 
#DEFINE 	COL_VLR_DEBITO		7
#DEFINE 	COL_VLR_CREDITO		8
#DEFINE 	COL_VLR_SALDO  		9
#DEFINE 	TAMANHO_TM       	10
#DEFINE 	COL_VLR_TRANSPORTE  11
*/ 
#DEFINE 	COL_DATA 			1
#DEFINE 	COL_NUMERO 			2
#DEFINE 	COL_HISTORICO		3
#DEFINE 	COL_CONTRA_PARTIDA	4
#DEFINE 	COL_CENTRO_CUSTO 	5
#DEFINE 	COL_VLR_DEBITO		6
#DEFINE 	COL_VLR_CREDITO		7
#DEFINE 	COL_VLR_SALDO  		8
#DEFINE 	TAMANHO_TM       	9
#DEFINE 	COL_VLR_TRANSPORTE  10

If mv_par11 == 3 						//// SE O PARAMETRO DO CODIGO ESTIVER PARA IMPRESSAO
	nTamConta := Len(CT1->CT1_CODIMP)	//// USA O TAMANHO DO CAMPO CODIGO DE IMPRESSAO
Endif
If lAnalitico .And. (lCusto .Or. lItem .Or. lCLVL) 
	nTamConta := 30						// Tamanho disponivel no relatorio para imprimir
EndIf		

If ! lAnalitico
	aColunas := { 000, 019,    ,    ,    ,    , 068, 090, 111, 19, 091 }
Else
	If cPaisLoc == "CHI"
		If ((!lCusto .And. !lItem .And. !lCLVL) .And. nTamConta<= 22)
  			aColunas := { 000, 030, 060,    ,    ,    , 84, 100, 115, 15, 097}
		Else
			aColunas := { 000, 030, 060, 092, 113, 134, 156, 178, 198, 20 ,178 }
		Endif
	Else
	   If ((!lCusto .And. !lItem .And. !lCLVL) .And. nTamConta<=22)
	  		//aColunas := { 000, 019, 060,    ,    ,    , 84, 100, 115, 15, 097}
	  		aColunas := { 000, 019, 060,    ,    ,    , 84, 100, 115, 15, 097}
	   Else
	   	aColunas := { 000, 010, 028, 069, 080, 086, 101, 116, 14 ,116 }
		 //	aColunas := { 000, 019, 060, 092, 113, 134, 156, 178, 198, 20 ,178 }
	   Endif
	EndIf
Endif

If lAnalitico							   	// Relatorio Analitico
	Cabec1 := STR0019					   	// "DATA"
	
	If (!lCusto .And. !lItem .And. !lCLVL)
		If nTamConta <= 22
			If cPaisLoc == "CHI"
				Cabec2:= STR0041
			ElseIf cPaisLoc == "MEX"
				Cabec2:= STR0037
			Else
				Cabec2:= STR0031
			EndIf
		Else 
			If cPaisLoc == "CHI"
				Cabec2:= STR0042
			ElseIf cPaisLoc == "MEX"
				Cabec2:= STR0038
			Else
				Cabec2:= STR0032
			EndIf
	    EndIf
	Else
		If cPaisLoc == "CHI"
			Cabec2:= STR0040
		ElseIf cPaisLoc == "MEX"
			Cabec2:= STR0039
		Else
			Cabec2:= STR0013
		EndIf
		Cabec2 += "C.CUSTO  "//Upper(cSayCusto) //+Space(11)+Upper(cSayItem)+Space(11)+Upper(cSayClVl)+Space(26)
		Cabec2 += Iif (cPaisLoc<>"MEX" ,STR0029,STR0036)
   EndIf
Else                
	lCusto := .F.
	lItem  := .F.
	lCLVL  := .F.
	Cabec1 := Iif (cPaisLoc<>"MEX" ,STR0024,STR0035)						// "DATA					                              					              	 DEBITO               CREDITO          	SALDO ATUAL"
EndIf	

m_pag := mv_par22
                 
If lImpLivro
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,,,aReturn[7],lSldAnt)},;
				STR0018,;		// "Criando Arquivo Tempor rio..."
				STR0006)		// "Emissao do Razao"
    
	dbSelectArea("CT2") 
	If !Empty(dbFilter())
		dbClearFilter()
	Endif
          

	If !lUsaTRB
		dbSelectArea("CT1")
		SetRegua(RecCount()*2)		
	EndIf

	dbSelectArea("cArqTmp")

	If lUsaTRB
		SetRegua(RecCount())                                      
	EndIf

	dbGoTop()
Endif

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If lImpLivro
	If cArqTmp->(RecCount()) == 0 .And. !Empty(aSetOfBook[5])                                       
		dbCloseArea("cArqTmp")
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())	
		Return
	Endif
EndIf

If !lUsaTRB
	cUFilter := ALLTRIM(aReturn[7])
EndIf

While lImpLivro .And. !cArqTmp->(Eof())

	IF lEnd
		@Prow()+1,0 PSAY STR0015  //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua(cArqTMP->CONTA)
	
	If !lUsaTRB .and. !Empty(cUFilter)
		If !&(cUFilter)
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop		
		EndIf	
	EndIf

	aSaldoAnt	:= SaldoCT7(cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,"CTBR400")
	
	If !lNoMov			//Se conta sem movimento não deve ser impressa.
		If aSaldoAnt[6] <> 0 .AND. cArqTmp->LANCDEB == 0 .And. cArqTmp->LANCCRD == 0 
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop		
		Endif	
	Endif             
     
	If li > nMaxLin .Or. lSalto              
		If lEmissUnica
			CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
		Else
			If m_pag > nPagFim
				If lNewPAGFIM
					nPagFim := m_pag+nPagFim		
					If l1StQb							//// SE FOR A 1ª QUEBRA
						m_pag := nReinicia
						l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
					Endif
				Else
					m_pag := nReinicia
				Endif
			EndIf	
		Endif
		CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
		If !lFirst
			lQbPg	:= .T.
		Else
			lFirst := .F.
		Endif
	EndIf

	nSaldoAtu:= 0
	nTotDeb	:= 0
	nTotCrd	:= 0
                              
	// IMPRIME A CONTA
	
	// Conta Sintetica	
	cContaSint := Ctr400Sint(cArqTmp->CONTA,@cDescSint,cMoeda,@cDescConta,@cCodRes)
	cNormal := CT1->CT1_NORMAL
	// Conta Analitica

	@li,001 PSAY STR0016 	//"CONTA - "	

	If mv_par11 == 1							// Imprime Cod Normal
		EntidadeCTB(cArqTmp->CONTA,li,9,nTamConta,.F.,cMascara1,cSepara1)
	Else
		dbSelectArea("CT1")
		dbSetOrder(1)
		MsSeek(cFilCT1+cArqTMP->CONTA,.F.)
		If mv_par11 == 3						// Imprime Codigo de Impressao
			EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
		Else										// Caso contrário usa codigo reduzido
			EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
		EndIf
		cDescConta := &("CT1->CT1_DESC"+cMoeda)
	Endif
	If !lAnalitico		// Se for resumido
		@ li, 9+nTamConta PSAY "- " + Left(cDescConta,30)	
	Else
		@ li, 9+nTamConta PSAY "- " + Left(cDescConta,38)
	EndIf
	
	@li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0033) - 1;
		 PSAY STR0033	//"SALDO ANTERIOR: "	
	
	// Impressao do Saldo Anterior do Centro de Custo
	ValorCTB(aSaldoAnt[6],li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,;
							         .T.,cPicture)
		
	nSaldoAtu := aSaldoAnt[6]                                           
	If lSalLin
		li+=2
	Else
		li += 1         
	EndIf
	dbSelectArea("cArqTmp")
	cContaAnt:= cArqTmp->CONTA
	dDataAnt	:= CTOD("  /  /  ")
	lSemMov		:= .F.
	
	While cArqTmp->(!Eof()) .And. cArqTmp->CONTA == cContaAnt

		If !lUsaTRB .and. !Empty(cUFilter)
			If !&(cUFilter)
				dbSelectArea("cArqTmp")
				dbSkip()
				Loop		
			EndIf	
		EndIf
	
		If li > nMaxLin
			If lSalLin
				li++
			EndIf
			
			@li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0022) - 1;
						 PSAY STR0022	//"A TRANSPORTAR : "
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],;
					   aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal)
			   
			If lEmissUnica
				CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
			Else
				If m_pag > nPagFim
					If lNewPAGFIM
						nPagFim := m_pag+nPagFim
						If l1StQb							//// SE FOR A 1ª QUEBRA
							m_pag := nReinicia
							l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
						Endif
					Else
						m_pag := nReinicia
					Endif
				EndIf	
			Endif
			
			CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
			lQbPg := .T.
			        
			@li,001 PSAY STR0016 	//"CONTA - "	
	
			If mv_par11 == 1							// Imprime Cod Normal
				EntidadeCTB(cArqTmp->CONTA,li,9,nTamConta,.F.,cMascara1,cSepara1)
			Else
				dbSelectArea("CT1")
				dbSetOrder(1)
				MsSeek(cFilCT1+cArqTMP->CONTA,.F.)
				If mv_par11 == 3						// Imprime Codigo de Impressao
					EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
				Else										// Caso contrário usa codigo reduzido
					EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
				EndIf
				cDescConta := &("CT1->CT1_DESC"+cMoeda)
			Endif
			@ li, 9+nTamConta PSAY "- " + Left(cDescConta,38)			
			
			@li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0023) - 1 PSAY STR0023	//"DE TRANSPORTE : "
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal)
			li+= 2
		EndIf
	
		// Imprime os lancamentos para a conta                          
/*		
		If dDataAnt != cArqTmp->DATAL 
			If (cArqTmp->LANCDEB <> 0 .Or. cArqTmp->LANCCRD <> 0) .and. !Empty(cArqTMP->DATAL)
				If lAnalitico
					@li,000 PSAY cArqTmp->DATAL
					li++                       
				Else
					@li,000 PSAY cArqTmp->DATAL
				Endif		
			Endif	
			dDataAnt := cArqTmp->DATAL
			lQbPg := .F.			
		ElseIf lQbPg
			If !Empty(dDataAnt)
				@li,000 PSAY dDataAnt
				li++                       		
			EndIf
			lQbPg := .F.
		EndIf	
*/		
		If lAnalitico		//Se for relatorio analitico
			nSaldoAtu 	:= nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD
			nTotDeb		+= cArqTmp->LANCDEB
			nTotCrd		+= cArqTmp->LANCCRD
			nTotGerDeb	+= cArqTmp->LANCDEB
			nTotGerCrd	+= cArqTmp->LANCCRD			
            
           @li,aColunas[COL_DATA] PSAY cArqTmp->DATAL
		   	dDataAnt := cArqTmp->DATAL
		   
			If !lUsaTRB .and. cArqTmp->LANCDEB == 0 .And. cArqTmp->LANCCRD == 0 
				If lSldAnt .and. aSaldoAnt[6] <> 0 // Se contas com saldo anterior (mesmo sem movimento) devem ser impressas
					If !lSemMov					// Pode não ter movimento à débito mas ter movimento à credito
						lSemMov := .T.			// lSemMov indica que não teve mov. na 1ª parte (reiniciada por conta)
						dbSelectArea("cArqTmp")
						dbSkip()	
						Loop		
					Else            			// Imprimir "sem movimento" apenas se não tiver movimento nas 2 cond.
						@li,aColunas[COL_HISTORICO] PSAY Subs(STR0021,1,40)						
					EndIf
				ElseIf !lNoMov //Se conta sem movimento não deve ser impressa.
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop		
				Else
					If !lSemMov					// Pode não ter movimento à débito mas ter movimento à credito
						lSemMov := .T.			// lSemMov indica que não teve mov. na 1ª parte (reiniciada por conta)
						dbSelectArea("cArqTmp")
						dbSkip()	
						Loop		
					Else            			// Imprimir "sem movimento" apenas se não tiver movimento nas 2 cond.
						@li,aColunas[COL_HISTORICO] PSAY Subs(STR0021,1,40)						
					EndIf
				Endif	
			Else	/// SE A CONTA/LANCAMENTO TEM VALOR	
				If cPaisLoc == "CHI"				
					@li,aColunas[COL_NUMERO] PSAY cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->LINHA+" "+cArqTmp->SEGOFI 
					@li,aColunas[COL_HISTORICO] PSAY Subs(cArqTmp->HISTORICO,1,30)
				Else
					@li,aColunas[COL_NUMERO] PSAY cArqTmp->LOTE+"/"+cArqTmp->DOC+"-"+cArqTmp->LINHA
					@li,aColunas[COL_HISTORICO] PSAY Subs(cArqTmp->HISTORICO,1,40)
				EndIf									   
				
				If !Empty(cArqTmp->XPARTIDA)
					dbSelectArea("CT1")
					dbSetOrder(1)
					MsSeek(cFilCT1+cArqTmp->XPARTIDA)
					cCodRes := CT1->CT1_RES
					dbSelectArea("cArqTmp")
		
					If mv_par11 == 1
						EntidadeCTB(cArqTmp->XPARTIDA,li,aColunas[COL_CONTRA_PARTIDA], 10 ,.F.,cMascara1 ,cSepara1)
					ElseIf mv_par11 == 3
						EntidadeCTB(CT1->CT1_CODIMP,li,aColunas[COL_CONTRA_PARTIDA],10,.F., cMascara1 ,cSepara1)				
					Else
						EntidadeCTB(CT1->CT1_RES,li,aColunas[COL_CONTRA_PARTIDA],10,.F., cMascara1 ,cSepara1)				
					Endif                              
				EndIf
	
				If lCusto .and. !Empty(cArqTmp->CCUSTO)
					If mv_par25 == 1 //Imprime Cod. Centro de Custo Normal 
						EntidadeCTB(cArqTmp->CCUSTO,li,aColunas[COL_CENTRO_CUSTO],5,.F.,cMascara2,cSepara2)
					Else 
						dbSelectArea("CTT")
						dbSetOrder(1)
						MsSeek(cFilCTT+cArqTmp->CCUSTO)				
						cResCC := CTT->CTT_RES
						EntidadeCTB(cResCC,li,aColunas[COL_CENTRO_CUSTO],5,.F.,cMascara2,cSepara2)
						dbSelectArea("cArqTmp")
					Endif                                                       
				Endif
	
				If lItem .and. !Empty(cArqTmp->ITEM) 						//Se imprime item 
					If mv_par26 == 1 //Imprime Codigo Normal Item Contabl
						EntidadeCTB(cArqTmp->ITEM,li,aColunas[COL_ITEM_CONTABIL],17,.F.,cMascara3,cSepara3)
					Else
						dbSelectArea("CTD")
						dbSetOrder(1)
						MsSeek(cFilCTD+cArqTmp->ITEM)				
						cResItem := CTD->CTD_RES
						EntidadeCTB(cResItem,li,aColunas[COL_ITEM_CONTABIL],17,.F.,cMascara3,cSepara3)						
						dbSelectArea("cArqTmp")					
					Endif
				Endif
					
				If lCLVL .and. !Empty(cArqTmp->CLVL)				//Se imprime classe de valor
					If mv_par27 == 1 //Imprime Cod. Normal Classe de Valor
						EntidadeCTB(cArqTmp->CLVL,li,aColunas[COL_CLASSE_VALOR],17,.F.,cMascara4,cSepara4)
					Else
						dbSelectArea("CTH")
						dbSetOrder(1)
						MsSeek(cFilCTH+cArqTmp->CLVL)				
						cResClVl := CTH->CTH_RES						
						EntidadeCTB(cResClVl,li,aColunas[COL_CLASSE_VALOR],17,.F.,cMascara4,cSepara4)
						dbSelectArea("cArqTmp")					
					Endif			
				Endif
				
				ValorCTB(cArqTmp->LANCDEB,li,aColunas[COL_VLR_DEBITO],;                       
															  aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,,,,,,,.F.)
//											  aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1")
				ValorCTB(cArqTmp->LANCCRD,li,aColunas[COL_VLR_CREDITO],;
											  aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,,,,,,,.F.)
//											  aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2")											  
				ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],;
									   aColunas[TAMANHO_TM],nDecimais,.T.,cPicture,cNormal)
			
				// Procura pelo complemento de historico
				dbSelectArea("CT2")
				dbSetOrder(10)                                                                   
				If dbSeek(cFilCT2+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)
					dbSkip()                 
					If CT2->CT2_DC == "4"			//// TRATAMENTO PARA IMPRESSAO DAS CONTINUACOES DE HISTORICO
						While !CT2->(Eof()) .And. CT2->CT2_FILIAL == cFilCT2 	.And.;
									   		DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL) .And.;                       
											CT2->CT2_LOTE 		== cArqTMP->LOTE 		.And.;
											CT2->CT2_SBLOTE 	== cArqTMP->SUBLOTE 	.And.;
											CT2->CT2_DOC 		== cArqTmp->DOC 		.And.;
											CT2->CT2_SEQLAN 	== cArqTmp->SEQLAN 		.And.;
											CT2->CT2_EMPORI 	== cArqTmp->EMPORI 		.And.;
											CT2->CT2_FILORI 	== cArqTmp->FILORI 		.And.;
											CT2->CT2_DC == "4"
							If !lUsaTRB .and. !Empty(cUFilter)
								If !&(cUFilter)
									dbSelectArea("cArqTmp")
									dbSkip()
									Loop		
								EndIf	
							EndIf											
											
							li++
							If li > nMaxLin
								//// VALOR A TRANSPORTAR NA QUEBRA DE PAGINA    
								If lSalLin
									li++
								EndIf
								@li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0022) - 1 PSAY STR0022	//"A TRANSPORTAR : "
								ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal)
							    //// FIM DO TRATAMENTO PARA QUEBRA DO VALORA A TRANSPORTAR
							                                 
								If lEmissUnica
									CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
								Else
									If m_pag > nPagFim
										If lNewPAGFIM
											nPagFim := m_pag+nPagFim
											If l1StQb							//// SE FOR A 1ª QUEBRA
												m_pag := nReinicia
												l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
											Endif
										Else
											m_pag := nReinicia
										Endif
									EndIf	
								Endif
								
								CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
	
								//// VALOR DE TRANSPORTE NA QUEBRA DE PÁGINA
								@li,001 PSAY STR0016 	//"CONTA - "	
		
								If mv_par11 == 1							// Imprime Cod Normal
									EntidadeCTB(cArqTmp->CONTA,li,9,nTamConta,.F.,cMascara1,cSepara1)
								Else
									dbSelectArea("CT1")
									dbSetOrder(1)
									MsSeek(cFilCT1+cArqTMP->CONTA,.F.)											
									If mv_par11 == 3						// Imprime Codigo de Impressao
										EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
									Else										// Caso contrário usa codigo reduzido
										EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
									Endif
									cDescConta := &("CT1->CT1_DESC"+cMoeda)
									dbSelectArea("CT2")
								EndIf
								@ li, 9+nTamConta PSAY "- " + Left(cDescConta,38)			
				
								@li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0023) - 1 PSAY STR0023	//"DE TRANSPORTE : "
								ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal)
								li+= 2
								//// FINAL DO TRATAMENTO PARA O VALOR DE TRANSPORTE NA QUEBRA DE PAGINA
								
								If !lFirst
									If !Empty(dDataAnt)
										@li,000 PSAY dDataAnt
										li++
									EndIf
								Else
									lFirst := .F.
								Endif
							
							EndIf
							@li,aColunas[COL_NUMERO] 	PSAY Space(15)+CT2->CT2_LINHA
							@li,aColunas[COL_HISTORICO] PSAY Subs(CT2->CT2_HIST,1,40)
							CT2->(dbSkip())
						EndDo	
					EndIf	
				EndIf	
			EndIf
			cCtAnt := cArqTMP->CONTA
			dbSelectArea("cArqTmp")
			dbSkip()			
		Else		// Se for resumido.                               			
			dbSelectArea("cArqTmp")
			While dDataAnt == cArqTmp->DATAL .And. cContaAnt == cArqTmp->CONTA

				If !lUsaTRB .and. !Empty(cUFilter)
					If !&(cUFilter)
						dbSelectArea("cArqTmp")
						dbSkip()
						Loop		
					EndIf	
				EndIf

				nVlrDeb	+= cArqTmp->LANCDEB		                                         
				nVlrCrd	+= cArqTmp->LANCCRD		                                         
				nTotGerDeb	+= cArqTmp->LANCDEB
				nTotGerCrd	+= cArqTmp->LANCCRD			
				dbSkip()                                                                    				
			End			                                                                    
			nSaldoAtu	:= nSaldoAtu - nVlrDeb + nVlrCrd
			ValorCTB(nVlrDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],;
					 nDecimais,.F.,cPicture,"1")
			ValorCTB(nVlrCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],;
					 nDecimais,.F.,cPicture,"2")
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],;
					 nDecimais,.T.,cPicture,cNormal)
			nTotDeb		+= nVlrDeb
			nTotCrd		+= nVlrCrd         
			nVlrDeb	:= 0
			nVlrCrd	:= 0
		Endif
		dbSelectArea("cArqTmp")
		//dbSkip()  
		li++
	EndDo
     
  	If lSalLin
		li+=2
	EndIf
	If li > nMaxLin
		If lSalLin
			li++
		EndIf
		@li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0022) - 1;
					 PSAY STR0022	//"A TRANSPORTAR : "
		ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],;
							   aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal)

		If lEmissUnica
			CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
		Else
			If m_pag > nPagFim
				If lNewPAGFIM
					nPagFim := m_pag+nPagFim
					If l1StQb							//// SE FOR A 1ª QUEBRA
						m_pag := nReinicia
						l1StQb := .F.					//// INDICA Q NÃO É MAIS A 1ª QUEBRA
					Endif
				Else
					m_pag := nReinicia
				Endif
			EndIf	
		Endif
		
		CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
		If !lFirst
			lQbPg := .T.
		Else
			lFirst := .F.                                
		Endif
		
		@li,001 PSAY STR0016 	//"CONTA - "	
	
		If Empty(cContaAnt) .or. cArqTMP->CONTA == cContaAnt			//// SE O REG NO COMECO DA PAGINA FOR DA MESMA CONTA DA PG ANTERIOR
			If mv_par11 == 1							// Imprime Cod Normal
				EntidadeCTB(cArqTmp->CONTA,li,9,nTamConta,.F.,cMascara1,cSepara1)
			Else
				dbSelectArea("CT1")
				dbSetOrder(1)
				MsSeek(cFilCT1+cArqTMP->CONTA,.F.)			
				If mv_par11 == 3						// Imprime Codigo de Impressao
					EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
				Else										// Caso contrário usa codigo reduzido
					EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
				EndIf
			Endif
		Else									//// SE NAO FOR DA MESMA CONTA
			dbSelectArea("CT1")
			dbSetOrder(1)
			If MsSeek(cFilCT1+cContaAnt,.F.)		/// IMPRIME OS DADOS DA CONTA ANTERIOR
				If mv_par11 == 1							// Imprime Cod Normal
					EntidadeCTB(cContaAnt,li,9,nTamConta,.F.,cMascara1,cSepara1)
				ElseIf mv_par11 == 3						// Imprime Codigo de Impressao
					EntidadeCTB(CT1->CT1_CODIMP,li,9,nTamConta,.F.,cMascara1,cSepara1)
				Else										// Caso contrário usa codigo reduzido
					EntidadeCTB(CT1->CT1_RES,li,9,nTamConta,.F.,cMascara1,cSepara1)
				EndIf
			Endif
		Endif
		cDescConta := &("CT1->CT1_DESC"+cMoeda)
		@ li, 9+nTamConta PSAY "- " + Left(cDescConta,38)				
		
		@li,aColunas[COL_VLR_TRANSPORTE] - Len(STR0023) - 1 PSAY STR0023	//"DE TRANSPORTE "
		ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais, .T.,cPicture,cNormal)
		If lSalLin
			li+=2
		Else
			li+= 1
		EndIf
		
		If lQbPg 
			If !Empty(dDataAnt)
				If cArqtmp->(!Eof()) .And. cArqTmp->CONTA == cContaAnt		
					@li,000 PSAY dDataAnt
				EndIf
			EndIf
			li++
			lQbPg := .F.
		Endif
    EndIf
    
	@li,aColunas[If(lAnalitico,COL_HISTORICO,COL_NUMERO)] PSAY STR0020  //"T o t a i s  d a  C o n t a  ==> " 	    

	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],nDecimais,;
			 .F.,cPicture,"1")
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],nDecimais,;
			 .F.,cPicture,"2")
	ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO],aColunas[TAMANHO_TM],nDecimais,;
			 .T.,cPicture,cNormal)
    
	li++
	@li, 00 PSAY Replicate("-",nTamLinha)
	li++
	dbSelectArea("cArqTMP")
EndDo	 
          
If li != 80 .And. lImpLivro .And. mv_par28 == 1	//Imprime total Geral
    @li, 30 PSAY STR0025  //"T O T A L  G E R A L  ==> " 	        
	If lAnalitico .And. (lCusto .Or. lItem .Or. lClVl)
		ValorCTB(nTotGerDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1")
		ValorCTB(nTotGerCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2")
		li++
		@li, 00 PSAY Replicate("-",nTamLinha)
	Else
		ValorCTB(nTotGerDeb,li,aColunas[COL_VLR_DEBITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1")
		ValorCTB(nTotGerCrd,li,aColunas[COL_VLR_CREDITO],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2")
		li++
		@li, 00 PSAY Replicate("-",nTamLinha)
	Endif
Endif

nLinAst := GetNewPar("MV_INUTLIN",0)
If li < nMaxLin .and. nLinAst <> 0 .and. !lEnd
	For _n := 1 to nLinAst
		li++
		@li,00 PSAY REPLICATE("*",LIMITE)	
		If li == nMaxLin
			Exit
		EndIf
	Next
EndIf

If li <= nMaxLin .and. !lEnd .and. !lImpTermos
	Roda(cbCont,cbTxt,Tamanho)
EndIf

If lImpTermos 							// Impressao dos Termos

	cArqAbert:=GetNewPar("MV_LRAZABE","")
	cArqEncer:=GetNewPar("MV_LRAZENC","")
	
    If Empty(cArqAbert)
		ApMsgAlert(	STR0027 +; //"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. "
						STR0028) //"Utilize como base o parametro MV_LDIARAB."
	Endif
Endif

If lImpTermos .And. ! Empty(cArqAbert)	// Impressao dos Termos
	li+=2
	dbSelectArea("SM0")
	aVariaveis:={}

	For i:=1 to FCount()	
		If FieldName(i)=="M0_CGC"
			AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
		Else
            If FieldName(i)=="M0_NOME"
                Loop
            EndIf
			AADD(aVariaveis,{FieldName(i),FieldGet(i)})
		Endif
	Next

	dbSelectArea("SX1")
	dbSeek("CTR400"+"01")

	While SX1->X1_GRUPO=="CTR400"
		AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
		dbSkip()
	End

	If !File(cArqAbert)
		aSavSet:=__SetSets()
		cArqAbert:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If !File(cArqEncer)
		aSavSet:=__SetSets()
		cArqEncer:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqAbert#NIL
		ImpTerm(cArqAbert,aVariaveis,AvalImp(132))
	Endif

	If cArqEncer#NIL
		ImpTerm(cArqEncer,aVariaveis,AvalImp(132))
	Endif	 
Endif

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
End

If lImpLivro
	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIf	
Endif

dbselectArea("CT2")

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGerRaz ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Cria Arquivo Temporario para imprimir o Razao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim³±±
±±³			  ³cCustoIni,cCustoFim,cItemIni,cItemFim,cCLVLIni,cCLVLFim,    ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo,lAnalit)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nome do arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ ExpL4 = Indica se imprime analitico ou sintetico           ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
						cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
						aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,lAnalit,c2Moeda,;
						nTipo,cUFilter,lSldAnt)

Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO")
Local aCtbMoeda	:= {}
Local aSaveArea := GetArea()                       
Local aCampos

Local cChave
Local nTamDesc	:= Len(CriaVar("CT1_DESC"+cMoeda))
Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM"))
Local nTamCLVL	:= Len(CriaVar("CTH_CLVL"))
Local nDecimais	:= 0    
Local cMensagem	:= STR0030// O plano gerencial nao esta disponivel nesse relatorio. 
Local lCTR400QRY:= GetNewPar("MV_CTR400Q",.T.)

c2Moeda := ""
nTipo	:= 1
cUFilter:= ""
lSldAnt		:= .F.

cUFilter	:= ".T."			    	

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]

If !Empty(aSetOfBook[5])
	MsgAlert(cMensagem)	
	Return
EndIf
    
	aCampos :={	{ "CONTA"		, "C", aTamConta[1], 0 },;  		// Codigo da Conta
				{ "XPARTIDA"   	, "C", aTamConta[1] , 0 },;		// Contra Partida
				{ "TIPO"       	, "C", 01			, 0 },;			// Tipo do Registro (Debito/Credito/Continuacao)
				{ "LANCDEB"		, "N", 17			, nDecimais },; // Debito
				{ "LANCCRD"		, "N", 17			, nDecimais },; // Credito
				{ "SALDOSCR"	, "N", 17, nDecimais },; 			// Saldo
				{ "TPSLDANT"	, "C", 01, 0 },; 					// Sinal do Saldo Anterior => Consulta Razao
				{ "TPSLDATU"	, "C", 01, 0 },; 					// Sinal do Saldo Atual => Consulta Razao
				{ "HISTORICO"	, "C", nTamHist   	, 0 },;			// Historico
				{ "CCUSTO"		, "C", aTamCusto[1], 0 },;			// Centro de Custo
				{ "ITEM"		, "C", nTamItem		, 0 },;			// Item Contabil
				{ "CLVL"		, "C", nTamCLVL		, 0 },;			// Classe de Valor
				{ "DATAL"		, "D", 10			, 0 },;			// Data do Lancamento
				{ "LOTE" 		, "C", 06			, 0 },;			// Lote
				{ "SUBLOTE" 	, "C", 03			, 0 },;			// Sub-Lote
				{ "DOC" 		, "C", 06			, 0 },;			// Documento
				{ "LINHA"		, "C", 03			, 0 },;			// Linha
				{ "SEQLAN"		, "C", 03			, 0 },;			// Sequencia do Lancamento
				{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico
				{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original
				{ "FILORI"		, "C", 02			, 0 },;			// Filial Original
				{ "NOMOV"		, "L", 01			, 0 }}			// Conta Sem Movimento
	
	If cPaisLoc = "CHI"
		Aadd(aCampos,{"SEGOFI","C",TamSx3("CT2_SEGOFI")[1],0})
	EndIf
	If ! Empty(c2Moeda)
		Aadd(aCampos, { "LANCDEB_1"	, "N", 17, nDecimais }) // Debito
		Aadd(aCampos, { "LANCCRD_1"	, "N", 17, nDecimais }) // Credito
		Aadd(aCampos, { "TXDEBITO"	, "N", 17, 6 }) // Taxa Debito
		Aadd(aCampos, { "TXCREDITO"	, "N",  17, 6 }) // Taxa Credito
	Endif
																	
	cArqTmp := CriaTrab(aCampos, .T.)
	If ( Select ( "cArqTmp" ) <> 0 )
		dbSelectArea ( "cArqTmp" )
		dbCloseArea ()
	Endif
	
	
	dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipo == "1"			// Razao por Conta
	    If FunName() <> "CTBC400"
			cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
		EndIf
	ElseIf cTipo == "2"		// Razao por Centro de Custo                   
		If lAnalit 				// Se o relatorio for analitico
			If FunName() <> "CTBC440"
				cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
			Else
				cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
			EndIf
		Else                                                                  
			cChave 	:= "CCUSTO+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Endif
	ElseIf cTipo == "3" 		//Razao por Item Contabil      
		If lAnalit 				// Se o relatorio for analitico               
			If FunName() <> "CTBC480"
				cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
			Else
				cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
			Endif
		Else                                                                  
			cChave 	:= "ITEM+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Endif
	ElseIf cTipo == "4"		//Razao por Classe de Valor	
		If lAnalit 				// Se o relatorio for analitico               
			If FunName() <> "CTBC490"	
				cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
			Else
				cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
			EndIf
		Else                                                                  
			cChave 	:= "CLVL+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Endif	
	EndIf
	
	IndRegua("cArqTmp",cArqTmp,cChave,,,STR0017)  //"Selecionando Registros..."
	dbSelectArea("cArqTmp")
	dbSetIndex(cArqTmp+OrdBagExt())
	dbSetOrder(1)

	// Monta Arquivo para gerar o Razao
	CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
			cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
			aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt)

RestArea(aSaveArea)

Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbRazao  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,		   ³±±
±±³			  ³cCustoIni,cCustoFim, cItemIni,cItemFim,cCLVLIni,cCLVLFim,   ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo)                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
					  	cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
					  	aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt)

Local aSaveArea 	:= GetArea()
Local lNoMovDeb, lNoMovCrd
Local cChave, cCpoChave, cTmpChave
Local cContaI	:= ""
Local cContaF	:= ""
Local cCustoI	:= ""
Local cCustoF	:= ""
Local cItemI	:= ""
Local cItemF	:= ""
Local cClVlI	:= ""
Local cClVlF	:= ""
Local cVldEnt	:= ""
Local cAlias	:= ""
Local lUFilter	:= !Empty(cUFilter)			//// SE O FILTRO DE USUÁRIO NÃO ESTIVER VAZIO - TEM FILTRO DE USUÁRIO
Local cFilMoeda	:= "" 							
Local cAliasCT2	:= "CT2"	
Local bCond		:= {||.T.}


cUFilter := ".T."
lSldAnt	 := .F.

cCustoI	:= CCUSTOINI
cCustoF := CCUSTOFIM
cContaI	:= CCONTAINI
cContaF := CCONTAFIM
cItemI	:= CITEMINI      
cItemF 	:= CITEMFIM
cClvlI	:= CCLVLINI
cClVlF 	:= CCLVLFIM

	If !Empty(c2Moeda) 			
		cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' .Or. "		
		cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') " 			
	Else
		cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "				
	EndIf

oMeter:nTotal := CT1->(RecCount())

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os d‚bitos ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cTipo <> "1"
	If cTipo = "2" .And. Empty(cCustoIni)
		CTT->(DbSeek(xFilial("CTT")))
		cCustoIni := CTT->CTT_CUSTO
	Endif
	If cTipo = "3" .And. Empty(cItemIni)
		CTD->(DbSeek(xFilial("CTD")))
		cItemIni := CTD->CTD_ITEM
	Endif
	If cTipo = "4" .And. Empty(cClVlIni)
		CTH->(DbSeek(xFilial("CTH")))
		cClVlIni := CTH->CTH_CLVL
	Endif
Endif

	If cTipo == "1"
		dbSelectArea("CT2")                              
		dbSetOrder(2)
		cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' .And. " +;
					"CT2_DEBITO<='" + cContaFim + "'"
		cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' .And. " +;
					"CT2_CCD<='" + cCustoFim + "' .And. " +;
					"CT2_ITEMD>='" + cItemIni + "' .And. " +;
					"CT2_ITEMD<='" + cItemFim + "' .And. " +;
					"CT2_CLVLDB>='" + cClVlIni + "' .And. " +;
					"CT2_CLVLDB<='" + cClVlFim + "'"
		bCond 	:= { ||CT2->CT2_DEBITO >= cContaIni .And. CT2->CT2_DEBITO <= cContaFim}
	ElseIf cTipo == "2"
		dbSelectArea("CT2")
		dbSetOrder(4)
		cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'"
		cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'  .And.  " +;
					"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
	ElseIf cTipo == "3"
		dbSelectArea("CT2")
		dbSetOrder(6)
		cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'"
		cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
					"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
	ElseIf cTipo == "4"
		dbSelectArea("CT2")
		dbSetOrder(8)
		cValid 	:= 	"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
		cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
					"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'"
	EndIf
		
	If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
		If !Empty(cVldEnt)
			cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."		
		EndIf
	Endif
	
	cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
		
	If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO

		dbSelectArea("CT2")
		dbSetOrder(2)
		
		dbSelectArea("CT1")
		dbSetOrder(3)
		cFilCT1 := xFilial("CT1")
		cFilCT2	:= xFilial("CT2")
		cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica
		
		While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
			dbSelectArea("CT2")
			MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
			While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DEBITO == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim
		
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo
			CT1->(dbSkip())
		EndDo
	Else
		dbSelectArea("CT2")

		cTabCad := "CTT"
		cEntIni	:= cCustoIni
		bCond 	:= { || CT2->CT2_CCD == CTT->CTT_CUSTO}
		bCondCad:= { || .T.}
		dbSetOrder(4)

		If cTipo == "3"
			cTabCad := "CTD"
			cEntIni := cItemIni
			bCond 	:= { || CT2->CT2_ITEMD == CTD->CTD_ITEM}			
			dbSetOrder(6)
		ElseIf cTipo == "4"
			cTabCad := "CTH"
			cEntIni := cCLVLIni
			bCond 	:= { || CT2->CT2_CLVLDB == CTH->CTH_CLVL}					
			dbSetOrder(8)
		EndIf
		
		dbSelectArea(cTabCad)
		dbSetOrder(2)
		cFilEnt := xFilial(cTabCad)
		cFilCT2	:= xFilial("CT2")
		cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica
		
		If cTipo == "2"
			bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
		ElseIf cTipo == "3"
   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
  		ElseIf cTipo == "4"
			bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CTH->CTH_CLVL <= cCLVLFim }  		
  		EndIf
		
		While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
	
			dbSelectArea("CT2")    			
			If cTipo == "2"
				MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
			ElseIf cTipo == "3"
				MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)			
			Else
				MsSeek(cFilCT2+CTH->CTH_CLVL+DTOS(dDataIni),.T.)						
			EndIf

			dbSelectArea("CT2")									/// WHILE CT2 - DEBITOS
			While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim
		
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo	
			(cTabCad)->(dbSkip())
		EndDo
	Endif
		
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os creditos³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"
	dbSelectArea("CT2")
	dbSetOrder(3)
ElseIf cTipo == "2"
	dbSelectArea("CT2")
	dbSetOrder(5)
ElseIf cTipo == "3"
	dbSelectArea("CT2")
	dbSetOrder(7)
ElseIf cTipo == "4"		
	dbSelectArea("CT2")
	dbSetOrder(9)
EndIf

	bCond	:= {||.T.}

	If cTipo == "1"
		cValid	:= 	"CT2_CREDIT>='" + cContaIni + "'.And." +;
					"CT2_CREDIT<='" + cContaFim + "'"
		cVldEnt :=	"CT2_CCC>='" + cCustoIni + "'.And." +;
					"CT2_CCC<='" + cCustoFim + "'.And." +;
					"CT2_ITEMC>='" + cItemIni + "'.And." +;
					"CT2_ITEMC<='" + cItemFim + "'.And." +;
					"CT2_CLVLCR>='" + cClVlIni + "'.And." +;
					"CT2_CLVLCR<='" + cClVlFim + "'"
		bCond 	:= { ||CT2->CT2_CREDIT >= cContaIni .And. CT2->CT2_CREDIT <= cContaFim}
	ElseIf cTipo == "2"
		cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "'"
		cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "' .And. " +;
					"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
	ElseIf cTipo == "3"
		cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "'"
		cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "' .And. " +;
					"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
	ElseIf cTipo == "4"		
		cValid 	:= 	"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
		cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "' .And. " +;
					"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "'"
	EndIf	
	
	If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
		If !Empty(cVldEnt)
			cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."		
		EndIf
	Endif
	
	cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
	
	If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO
		dbSelectArea("CT2")
		dbSetOrder(3)
		
		dbSelectArea("CT1")
		dbSetOrder(3)
		cFilCT1 := xFilial("CT1")
		cFilCT2	:= xFilial("CT2")
		cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica
		
		While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
			dbSelectArea("CT2")
			MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
			While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_CREDIT == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim
	
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
				If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					If Empty(c2Moeda)			
						If CT2->CT2_MOEDLC <> cMoeda
							dbSkip()
							Loop
						EndIF
					Else
						If !(&(cFilMoeda))
							dbSkip()
							Loop
						EndIf			
					EndIf			
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo			
			CT1->(dbSkip())
		EndDo
	Else
		dbSelectArea("CT2")

		cTabCad := "CTT"
		cEntIni	:= cCustoIni
		bCond 	:= { || CT2->CT2_CCC == CTT->CTT_CUSTO}
		bCondCad:= { || .T.}
		dbSetOrder(5)

		If cTipo == "3"
			cTabCad := "CTD"
			cEntIni := cItemIni
			bCond 	:= { || CT2->CT2_ITEMC == CTD->CTD_ITEM}			
			dbSetOrder(7)
		ElseIf cTipo == "4"
			cTabCad := "CTH"
			cEntIni := cCLVLIni
			bCond 	:= { || CT2->CT2_CLVLCR == CTH->CTH_CLVL}					
			dbSetOrder(9)
		EndIf
		
		dbSelectArea(cTabCad)
		dbSetOrder(2)
		cFilEnt := xFilial(cTabCad)
		cFilCT2	:= xFilial("CT2")
		cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica
		
		If cTipo == "2"
			bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
		ElseIf cTipo == "3"
   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
  		ElseIf cTipo == "4"
			bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CTH->CTH_CLVL <= cCLVLFim }  		
  		EndIf
		
		While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
	
			dbSelectArea("CT2")    	
			If cTipo == "2"
				MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
			ElseIf cTipo == "3"
				MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)			
			Else
				MsSeek(cFilCT2+CTH->CTH_CLVL+DTOS(dDataIni),.T.)						
			EndIf

			dbSelectArea("CT2")									/// WHILE CT2 - CREDITO
			While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim
		
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo	
			(cTabCad)->(dbSkip())
		EndDo
	EndIf


If lNoMov .or. lSldAnt
	If cTipo == "1"
		dbSelectArea("CT1")
		dbSetOrder(3)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CT1_FILIAL == '" + xFilial("CT1") + "' .And. CT1_CONTA >= '"+cContaI+ "' .And. CT1_CONTA <= '" +;
						cContaF + "' .And. CT1_CLASSE = '2'",STR0017)
		cCpoChave := "CT1_CONTA"
		cTmpChave := "CONTA"
	ElseIf cTipo == "2"
		dbSelectArea("CTT")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTT_FILIAL == '" + xFilial("CTT") + "' .And. CTT_CUSTO >= '"+cCustoI+"' .And. CTT_CUSTO <= '" +;
						cCUSTOF + "' .And. CTT_CLASSE == '2'",STR0017)
		cCpoChave := "CTT_CUSTO"
		cTmpChave := "CCUSTO"
	ElseIf ctipo == "3"
		dbSelectArea("CTD")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTD_FILIAL == '" + xFilial("CTD") + "' .And. CTD_ITEM >= '"+cItemI+"' .And. CTD_ITEM <= '" +;
						cITEMF + "' .And. CTD_CLASSE == '2'",STR0017)
		cCpoChave := "CTD_ITEM"
		cTmpChave := "ITEM"
	ElseIf ctipo == "4"
		dbSelectArea("CTH")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTH_FILIAL == '" + xFilial("CTH") + "' .And. CTH_CLVL >= '"+cClVlI+"' .And. CTH_CLVL <= '" +;
						cCLVLF + "' .And. CTH_CLASSE == '2'",STR0017)
		cCpoChave := "CTH_CLVL"
		cTmpChave := "CLVL"
	EndIf

	cAlias := Alias()

	While ! Eof()
		dbSelectArea("cArqTmp")
		cKey2Seek	:= &(cAlias + "->" + cCpoChave)
		If !MsSeek(cKey2Seek)
			If lNoMov		
				CtbGrvNoMov(cKey2Seek,dDataIni,cTmpChave)
			ElseIf cTipo == "1"		/// SOMENTE PARA O RAZAO POR CONTA
				/// TRATA OS DADOS PARA A PERGUNTA "IMPRIME CONTA SEM MOVIMENTO" = "NAO C/ SLD.ANT."
				If SaldoCT7(cKey2Seek,dDataIni,cMoeda,cSaldo,'CTBR400')[6] <> 0 .and. cArqTMP->CONTA <> cKey2Seek
					/// SE TIVER SALDO ANTERIOR E NÃO TIVER MOVIMENTO GRAVADO
					CtbGrvNoMov(cKey2Seek,dDataIni,cTmpChave)
				Endif
			EndIf
		Endif
		DbSelectArea(cAlias)
		DbSkip()
	EndDo

	DbSelectArea(cAlias)
	DbClearFil()
	RetIndex(cAlias)
EndIf	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvRaz ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario - Razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvRaz(lJunta,cMoeda,cSaldo,cTipo)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1 = Se Junta CC ou nao                                 ³±±
±±³           ³ ExpC1 = Moeda                                              ³±±
±±³           ³ ExpC2 = Tipo de saldo                                      ³±±
±±            ³ ExpC3 = Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cAliasQry = Alias com o conteudo selecionado do CT2        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGrvRAZ(lJunta,cMoeda,cSaldo,cTipo,c2Moeda,cAliasCT2,nTipo)

Local cSeqLan
Local cConta
Local cContra
Local cCusto
Local cItem
Local cCLVL
Local cChave	:= ""
Local nReg, cMoedLan := ""
Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.)   // Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
                                                                                  // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.
cAliasCT2	:= "CT2"

If !Empty(c2Moeda)
	If cTipo == "1"
		cChave	:=	(cAliasCT2)->(CT2_DEBITO+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
	Else
    	cChave	:=	(cAliasCT2)->(CT2_CREDIT+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
 	EndIf
EndIf


If cTipo == "1"
	cConta 	:= (cAliasCT2)->CT2_DEBITO
	cContra	:= (cAliasCT2)->CT2_CREDIT
	cCusto	:= (cAliasCT2)->CT2_CCD
	cItem	:= (cAliasCT2)->CT2_ITEMD
	cCLVL	:= (cAliasCT2)->CT2_CLVLDB
EndIf	
If cTipo == "2"
	cConta 	:= (cAliasCT2)->CT2_CREDIT
	cContra := (cAliasCT2)->CT2_DEBITO
	cCusto	:= (cAliasCT2)->CT2_CCC
	cItem	:= (cAliasCT2)->CT2_ITEMC
	cCLVL	:= (cAliasCT2)->CT2_CLVLCR
EndIf		           

dbSelectArea("cArqTmp")
dbSetOrder(1)	
If !Empty(c2Moeda) 
	If MsSeek(cChave,.F.)
		Reclock("cArqTmp",.F.)
	Else
		RecLock("cArqTmp",.T.)		
	EndIf
Else
	RecLock("cArqTmp",.T.)
EndIf

Replace DATAL		With (cAliasCT2)->CT2_DATA
Replace TIPO		With cTipo
Replace LOTE		With (cAliasCT2)->CT2_LOTE
Replace SUBLOTE		With (cAliasCT2)->CT2_SBLOTE
Replace DOC			With (cAliasCT2)->CT2_DOC
Replace LINHA		With (cAliasCT2)->CT2_LINHA
Replace CONTA		With cConta
If lImpCPartida
	Replace XPARTIDA	With cContra
EndIf
Replace CCUSTO		With cCusto
Replace ITEM		With cItem
Replace CLVL		With cCLVL
Replace HISTORICO	With (cAliasCT2)->CT2_HIST
Replace EMPORI		With (cAliasCT2)->CT2_EMPORI
Replace FILORI		With (cAliasCT2)->CT2_FILORI
Replace SEQHIST		With (cAliasCT2)->CT2_SEQHIST
Replace SEQLAN		With (cAliasCT2)->CT2_SEQLAN
Replace NOMOV		With .F.							// Conta com movimento

If cPaisLoc == "CHI"
	Replace SEGOFI With (cAliasCT2)->CT2_SEGOFI// Correlativo para Chile
EndIf

If Empty(c2Moeda)	//Se nao for Razao em 2 Moedas
	If cTipo == "1"
		Replace LANCDEB	With LANCDEB + (cAliasCT2)->CT2_VALOR
	EndIf	
	If cTipo == "2"
		Replace LANCCRD	With LANCCRD + (cAliasCT2)->CT2_VALOR
	EndIf	    
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf		
Else	//Se for Razao em 2 Moedas
	If (nTipo = 1 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = cMoeda //Se Imprime Valor na Moeda ou ambos
		If cTipo == "1"
			Replace LANCDEB With (cAliasCT2)->CT2_VALOR	
		Else			
			Replace LANCCRD With (cAliasCT2)->CT2_VALOR	
		EndIf
	EndIf
    If (nTipo = 2 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = c2Moeda	//Se Imprime Moeda Corrente ou Ambas
		If cTipo == "1"
			Replace LANCDEB_1	With (cAliasCT2)->CT2_VALOR
		Else
			Replace LANCCRD_1	With (cAliasCT2)->CT2_VALOR
		Endif
	EndIf
	If LANCDEB_1 <> 0 .And. LANCDEB <> 0 
		Replace TXDEBITO  	With LANCDEB_1 / LANCDEB		
	Endif                                               
	If LANCCRD_1 <> 0 .And. LANCCRD <> 0
		Replace TXCREDITO 	With LANCCRD_1 / LANCCRD
	EndIf	
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf			
EndIf

If nTipo = 1 .And. (LANCDEB + LANCCRD) = 0
	DbDelete()
ElseIf nTipo = 2 .And. (LANCDEB_1 + LANCCRD_1) = 0
	DbDelete()
Endif
If ! Empty(c2Moeda) .And. LANCDEB + LANCDEB_1 + LANCCRD + LANCCRD_1 = 0
	DbDelete()
Endif

MsUnlock()

 Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvNoMov ³ Autor ³ Pilar S. Albaladejo ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario sem movimento.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvNoMov(cConta)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ cConteudo = Conteudo a ser gravado no campo chave de acordo³±±
±±³           ³             com o razao impresso                           ³±±
±±³           ³ dDataL = Data para verificacao do movimento da conta       ³±±
±±³           ³ cCpoChave = Nome do campo para gravacao no temporario      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGrvNoMov(cConteudo,dDataL,cCpoTmp)

dbSelectArea("cArqTmp")
dbSetOrder(1)	

RecLock("cArqTmp",.T.)
Replace &(cCpoTmp)	With cConteudo
If cCpoTmp = "CONTA"
	Replace HISTORICO		With STR0021		//"CONTA SEM MOVIMENTO NO PERIODO"
ElseIf cCpoTmp = "CCUSTO"
	Replace HISTORICO		With cSayCC 	//"SEM MOVIMENTO NO PERIODO"
ElseIf cCpoTmp = "ITEM"
	Replace HISTORICO		With cSayIT 	//"SEM MOVIMENTO NO PERIODO"
ElseIf cCpoTmp = "CLVL"
	Replace HISTORICO		With cSayCL	//"SEM MOVIMENTO NO PERIODO"
Endif
Replace DATAL 			WITH dDataL 
MsUnlock()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³Ctr400Sint³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Imprime conta sintetica da conta do razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³Ctr400Sint(cConta,cDescSint,cMoeda,cDescConta,cCodRes)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Conta Sintetic		                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpC1 = Conta                                              ³±±
±±³           ³ ExpC2 = Descricao da Conta Sintetica                       ³±±
±±³           ³ ExpC3 = Moeda                                              ³±±
±±³           ³ ExpC4 = Descricao da Conta                                 ³±±
±±³           ³ ExpC5 = Codigo reduzido                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctr400Sint(cConta,cDescSint,cMoeda,cDescConta,cCodRes)

Local aSaveArea := GetArea()

Local lSint    	:= .T.
Local nPosCT1					//Guarda a posicao no CT1
Local cContaPai	:= ""
Local cContaSint	:= ""

dbSelectArea("CT1")
dbSetOrder(1)
If dbSeek(xFilial("CT1")+cConta)
	nPosCT1 	:= Recno()
	cDescConta  := &("CT1->CT1_DESC"+cMoeda)
	If Empty(cDescConta)
		cDescConta  := CT1->CT1_DESC01
	Endif
	cCodRes		:= CT1->CT1_RES
	cContaPai	:= CT1->CT1_CTASUP
	If dbSeek(xFilial("CT1")+cContaPai)
		cContaSint 	:= CT1->CT1_CONTA
		cDescSint	:= &("CT1->CT1_DESC"+cMoeda)
		If Empty(cDescSint)
			cDescSint := CT1->CT1_DESC01
		Endif
	EndIf	
	dbGoto(nPosCT1)
EndIf	

RestArea(aSaveArea)

Return cContaSint
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjX1CodImpºAutor  ³Marcos S. Lobo      º Data ³  09/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua o ajuste no grupo de perguntas SX1 caso o campo      º±±
±±º          ³CT1_CODIMP esteja criado e em uso.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 - Relatórios SIGACTB                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ cPerg= Codigo do Grupo de Perguntas no SX1                 º±±          
±±º          ³ cSeq = Codigo da Sequencia da Pergunta Imprime?(Normal/Red)º±±
±±º          ³ nX1Def=Numero da Seqüencia de DEFINE no ComboBox do SX1    º±±
±±º          ³ cMvPar=Codigo do mv_parXX que será utilizado.			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjCodImpX1(cPerg,cSeq,nX1Def,cMvPar)
Local lUsaCodImp	:= .F.
Local aArea			:= GetArea()
Local cCHAR2CH		:= "123456789abcdefghijklmnopqrstuv"
Local cMVCH			:= cMvPar

If Empty(cPerg) .or. Empty(cSeq)
	Return(lUsaCodImp)
Endif
  
dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek("CT1_CODIMP")	.and. X3Uso(SX3->X3_USADO)				//// SE ENCONTRAR O CODIGO DE IMPRESSAO NO SX3 E ESTIVER EM USO
	lUsaCodImp := .T.											//// USO DO CODIGO DE IMPRESSA ESTARÁ HABILITADO
Else
	lUsaCodImp := .F.											//// USO DO CODIGO DE IMPRESSAO ESTARA DESABILITADO
Endif

If nX1Def > 0										/// SE FOR SOMENTE MANUTENÇÃO DE COMBOBOX
	dbSelectArea("SX1")
	dbSetOrder(1)
	If MsSeek(cPerg+cSeq)
		If lUsaCodImp .and. Empty(&("SX1->X1_DEF"+STRZERO(nX1Def,2)))		/// SE USA E ESTA EM BRANCO
			RecLock("SX1",.F.)
			&("Field->X1_DEF"+STRZERO(nX1Def,2))  		:= SX3->X3_TITULO	/// PREENCHE PARA LIBERAR O USO
			&("Field->X1_DEFSPA"+ALLTRIM(STR(nX1Def)))	:= SX3->X3_TITSPA
			&("Field->X1_DEFENG"+ALLTRIM(STR(nX1Def)))	:= SX3->X3_TITENG
			SX1->(MsUnlock())
		ElseIf !lUsaCodImp .and. !Empty(&("SX1->X1_DEF"+STRZERO(nX1Def,2))) /// SE Ñ USA E NAO ESTÁ VAZIO
			RecLock("SX1",.F.)
			&("Field->X1_DEF"+STRZERO(nX1Def,2))  		:= " "			/// APAGA PARA NAO LIBERAR O USO DO COD.IMPRESSAO
			&("Field->X1_DEFSPA"+ALLTRIM(STR(nX1Def)))	:= " "
			&("Field->X1_DEFENG"+ALLTRIM(STR(nX1Def)))	:= " "
			Field->X1_PRESEL	:= 0
			SX1->(MsUnlock())
		Endif
	Endif
Else                    		/// SE FOR NOVA PERGUNTA NO SX1
	If Empty(cMvPar)
		RestArea(aArea)
		Return(.F.)
	Endif
	dbSelectArea("SX1")
	dbSetOrder(1)
	If !MsSeek(cPerg+cSeq)							/// SE A PERGUNTA NAO EXISTIR
		cMVCH := "mv_ch"+SubStr(cCHAR2CH,val(SubStr(cMvPar,7,Len(cMvPar)-6)),1)		/// DEFINE A SEQUENCIA DO X1_VARIAVL (MV_CHx) UTILIZADO
		RecLock("SX1",.T.)
		Field->X1_GRUPO		:= cPerg
		Field->X1_ORDEM		:= cSeq
		Field->X1_PERGUNT	:= "Impr Cod. Conta    ?"
		Field->X1_PERSPA	:= "¿Impr Cod Cuenta   ?"
		Field->X1_PERENG	:= "Print Account Code ?"
		Field->X1_VARIAVL	:= cMVCH
		Field->X1_TIPO		:= "N"
		Field->X1_TAMANHO	:= 1
		Field->X1_DECIMAL	:= 0
		Field->X1_PRESEL	:= 0
		Field->X1_GSC		:= "C"
		Field->X1_VAR01		:= cMvPar
		Field->X1_DEF01 	:= "Normal"
		Field->X1_DEFSPA1	:= "Normal"
		Field->X1_DEFENG1	:= "Normal"
		Field->X1_DEF02 	:= "Reduzido"
		Field->X1_DEFSPA2	:= "Reducido"
		Field->X1_DEFENG2	:= "Reduced"
		If lUsaCodImp												/// SE CODIGO DE IMPRESSAO ESTIVER EM USO
			Field->X1_DEF03 	:= SX3->X3_TITULO
			Field->X1_DEFSPA3	:= SX3->X3_TITSPA
			Field->X1_DEFENG3	:= SX3->X3_TITENG
		Endif
		SX1->(MsUnlock())
	Else
		If !lUsaCodImp .and. !Empty(SX1->X1_DEF03)	/// SE NÃO USAR O CODIGO DE IMPRESSAO E O MESMO NAO ESTIVER VAZIO
			RecLock("SX1",.F.)
			Field->X1_DEF03 	:= ""				/// LIMPA O DEFINE DO COD.IMPRESSAO PARA NAO UTILIZAR
			Field->X1_DEFSPA3	:= ""
			Field->X1_DEFENG3	:= ""
			Field->X1_PRESEL	:= 0
			SX1->(MsUnlock())
		ElseIf Empty(SX1->X1_DEF03)					/// SE USAR E O CODIGO DE IMPRESSAO ESTIVER VAZIO
			RecLock("SX1",.F.)
			Field->X1_DEF03 	:= SX3->X3_TITULO	/// ADICIONA O DEFINE DO COD. IMPRESSAO PARA UTILIZAR
			Field->X1_DEFSPA3	:= SX3->X3_TITSPA
			Field->X1_DEFENG3	:= SX3->X3_TITENG
			SX1->(MsUnlock())
		Endif
	Endif
Endif

RestArea(aArea)
Return(lUsaCodImp)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbQryRaz ³ Autor ³ Simone Mie Sato       ³ Data ³ 22/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,	   ³±±
±±³			  ³	cCustoIni,cCustoFim, cItemIni,cItemFim,cCLVLIni,cCLVLFim,  ³±±
±±³			  ³	cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,  ³±±
±±³			  ³	cTipo)                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				  cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				  aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt)

Local aSaveArea := GetArea()
Local nMeter	:= 0
Local cQuery	:= ""
Local aTamVlr	:= TAMSX3("CT2_VALOR")     
Local lNoMovim	:= .F.
Local cContaAnt	:= ""
Local cCampUSU	:= ""
local aStrSTRU	:= {}
Local nStr		:= 0
Local lUFilter	:= .T.
Local lChi		:= cPaisLoc == "CHI"
Local cGetDB	:= ALLTRIM(TcGetDB())

Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.) // Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
                                                  // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.
lSldAnt := .F.

oMeter:SetTotal(CT2->(RecCount()))
oMeter:Set(0)

cQuery	:= " SELECT CT1_CONTA CONTA, CT2_DATA DATAL, CT2_LOTE LOTE, CT2_SBLOTE SUBLOTE, CT2_DOC DOC, CT2_LINHA LINHA, CT2_EMPORI EMPORI, CT2_FILORI FILORI,"
cQuery  += " CT2_CREDIT  XPARTIDA, CT2_CCD CCUSTO, CT2_ITEMD ITEM, CT2_CLVLDB CLVL, CT2_TPSALD TPSALD, "
cQuery	+= " CT2_DC TIPO, CT2_HIST  HISTORICO, CT2_SEQHIS SEQHIST, CT2_SEQLAN SEQLAN, '1' TIPOLAN, "
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
cQuery  += "  CT2_VALOR LANCDEB, 0 LANCCRD"       
If cPaisLoc == "CHI"
	cQuery	+= ",  CT2_SEGOFI  SEGOFI"
EndIf
If cGetDb  $ "DB2/INFORMIX/MYSQL/POSTGRES"
	cQuery	+= " FROM "+ RetSqlName("CT1") + " CT1 LEFT OUTER JOIN " + RetSqlName("CT2") + " CT2 "
	cQuery  += " ON CT1.CT1_CONTA = CT2.CT2_DEBITO "
Else
	cQuery	+= " FROM "+ RetSqlName("CT1") + " CT1, " + RetSqlName("CT2") + " CT2 "
EndIf
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = '' "

cQuery	+= " AND "

If cGetDb  $ "DB2/INFORMIX/MYSQL/POSTGRES"
	cQuery += " ( CT2.CT2_FILIAL IS NULL OR ( "
EndIf

cQuery	+= " CT2.CT2_FILIAL"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery += "= '"+xFilial("CT2")+"' "

cQuery  += " AND CT2.CT2_DATA"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += " >= '"+DTOS(dDataIni)+ "' "

cQuery  += " AND CT2.CT2_DATA"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <= '"+DTOS(dDataFim)+"'"

cQuery  += " AND CT2.CT2_DC" 
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <> '2' "

cQuery  += " AND CT2.CT2_DC" 
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <> '4' "

cQuery  += " AND CT2.CT2_CLVLDB"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  >= '" + cClvlIni + "' "

cQuery  += " AND CT2.CT2_CLVLDB"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <= '" + cClVlFim +"'"

cQuery  += " AND CT2.CT2_ITEMD"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  >= '" + cItemIni + "' "

cQuery  += " AND CT2.CT2_ITEMD"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <= '"+ cItemFim +"'"

cQuery	+= " AND CT2.CT2_CCD"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  >= '" + cCustoIni + "'"

cQuery  += " AND CT2.CT2_CCD"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += " <= '" + cCustoFim +"'"

If !cGetDb $ "DB2/INFORMIX/MYSQL/POSTGRES"
	If cGetDb <> "ORACLE"
		cQuery	+= " AND CT1.CT1_CONTA *= CT2.CT2_DEBITO "
	Else
		cQuery	+= " AND CT1.CT1_CONTA = CT2.CT2_DEBITO(+) "
	EndIf
EndIf

cQuery  += " AND CT2.CT2_TPSALD"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += " = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  = '" + cMoeda +"'"
cQuery  += " AND CT2.CT2_VALOR <> 0 "
cQuery	+= " AND CT2.D_E_L_E_T_"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += " = ' ' "	
If cGetDb  $ "DB2/INFORMIX/MYSQL/POSTGRES"
	cQuery += " ) ) "
EndIf

cQuery	+= " UNION "

cQuery	+= " SELECT CT1_CONTA CONTA, CT2_DATA DATAL, CT2_LOTE LOTE, CT2_SBLOTE SUBLOTE, CT2_DOC DOC, CT2_LINHA LINHA, CT2_EMPORI EMPORI, CT2_FILORI FILORI,"
cQuery 	+= " CT2_DEBITO  XPARTIDA, CT2_CCC CCUSTO, CT2_ITEMC ITEM, CT2_CLVLCR CLVL, CT2_TPSALD TPSALD, "	
cQuery	+= "  CT2_DC TIPO, CT2_HIST HISTORICO, CT2_SEQHIS SEQHIST, CT2_SEQLAN SEQLAN, '2' TIPOLAN, "	
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

cQuery  += "  0 LANCDEB, CT2_VALOR LANCCRD "              
If cPaisLoc == "CHI"
	cQuery	+= ",  CT2_SEGOFI  SEGOFI"
EndIf

If cGetDb $ "DB2/INFORMIX/MYSQL/POSTGRES"
	cQuery	+= " FROM "+ RetSqlName("CT1") + " CT1 LEFT OUTER JOIN " + RetSqlName("CT2") + " CT2 "
	cQuery  += " ON CT1.CT1_CONTA = CT2.CT2_CREDIT "
Else
	cQuery	+= " FROM "+RetSqlName("CT1")+ ' CT1, '+ RetSqlName("CT2") + ' CT2 '
EndIf

cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = ''"	            

cQuery	+= " AND "

If cGetDb  $ "DB2/INFORMIX/MYSQL/POSTGRES"
	cQuery += " ( CT2.CT2_FILIAL IS NULL OR ( "
EndIf

cQuery	+= " CT2.CT2_FILIAL"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  = '"+xFilial("CT2")+"' "

cQuery  += " AND CT2.CT2_DATA"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  >= '"+DTOS(dDataIni)+ "' "

cQuery  += " AND CT2.CT2_DATA"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <= '"+DTOS(dDataFim)+"'"

cQuery  += " AND CT2.CT2_DC" 
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <> '1' "

cQuery  += " AND CT2.CT2_DC" 
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <> '4' "

cQuery  += " AND CT2.CT2_CLVLCR"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  >= '" + cClvlIni + "' "

cQuery  += " AND CT2.CT2_CLVLCR"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <= '" + cClVlFim +"'"

cQuery  += " AND CT2.CT2_ITEMC"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  >= '" + cItemIni + "'"

cQuery  += "  AND CT2.CT2_ITEMC"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <= '"+ cItemFim +"'"

cQuery	+= " AND CT2.CT2_CCC"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  >= '" + cCustoIni + "' "

cQuery  += " AND CT2.CT2_CCC"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  <= '" + cCustoFim +"'"

If !cGetDb $ "DB2/INFORMIX/MYSQL/POSTGRES"
	If cGetDb <> "ORACLE"
		cQuery	+= " AND CT1.CT1_CONTA *= CT2.CT2_CREDIT "
	Else
		cQuery	+= " AND CT1.CT1_CONTA = CT2.CT2_CREDIT(+) "
	EndIf
EndIf

cQuery  += " AND CT2.CT2_TPSALD"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  = '"+ cSaldo + "'"

cQuery	+= " AND CT2.CT2_MOEDLC"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += "  = '" + cMoeda +"'"
cQuery  += " AND CT2.CT2_VALOR <> 0 "
cQuery	+= " AND CT2.D_E_L_E_T_"
If cGetDb == "ORACLE"
	cQuery += "(+)"
EndIf
cQuery  += " = ' ' "	
If cGetDb $ "DB2/INFORMIX/MYSQL/POSTGRES"
	cQuery += " ) ) "
EndIf
                                 
If cGetDB == "INFORMIX"                        
	cQuery += " ORDER BY 1,2,3,4,5,6,7,8"
Else
	cQuery += " ORDER BY CONTA,DATAL,LOTE,SUBLOTE,DOC,LINHA,EMPORI,FILORI"
EndIf

//cQuery := MsParse(cQuery,ALLTRIM(TcGetDb()),.T.)

cQuery := ChangeQuery(cQuery)		   

If Select("cArqTMP") > 0
	dbSelectArea("cArqTMP")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqTMP",.T.,.F.)
TcSetField("cArqTMP","LANCDEB","N",aTamVlr[1],aTamVlr[2])
TcSetField("cArqTMP","LANCCRD","N",aTamVlr[1],aTamVlr[2])
TcSetField("cArqTMP","DATAL","D",8,0)

If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		If aStrSTRU[nStr][2] <> "C" .and. cArqTMP->(FieldPos(aStrSTRU[nStr][1])) > 0
			TcSetField("cArqTMP",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
		EndIf
	Next
Endif
 			
dbSelectarea("cArqTMP")

/*dbSelectarea("cArqCT2")
If Empty(cUFilter) .or. ALLTRIM(cUFilter) == ".T."
	lUFilter := .F.
	cUFilter := ".T."
Endif						

While !Eof()                                              
	If Empty(cArqCT2->DDATA) //Se nao existe movimento 
		cContaAnt	:= cArqCT2->CONTA	
		dbSkip()
		If Empty(cArqCT2->DDATA) .And. cContaAnt == cArqCT2->CONTA
			lNoMovim	:= .T.
		EndIf
	Endif        
	
	If lUFilter .and. !&("cArqCT2->("+cUFilter+")")						
		dbSkip()
		Loop
	EndIf
	
	If lNoMovim		
		If lNoMov  
			CtbGrvNoMov(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo 				
		ElseIf lSldAnt 
			If SaldoCT7(cArqCT2->CONTA,dDataIni,cMoeda,cSaldo,'CTBR400')[6] <> 0 .and. cArqTMP->CONTA <> cArqCT2->CONTA																							
				CtbGrvNoMov(cArqCT2->CONTA,dDataIni,"CONTA")	
			Endif			
		EndIf
	Else
		RecLock("cArqTmp",.T.)		    	
	    Replace DATAL		With cArqCT2->DDATA		// 12
		Replace TIPO		With cArqCT2->DC   		// 12
		Replace LOTE		With cArqCT2->LOTE		// 12
		Replace SUBLOTE		With cArqCT2->SUBLOTE	// 12
		Replace DOC			With cArqCT2->DOC		// 12
		Replace LINHA		With cArqCT2->LINHA		// 12
		Replace CONTA		With cArqCT2->CONTA		// 12
		Replace CCUSTO		With cArqCT2->CUSTO		// 12
		Replace ITEM		With cArqCT2->ITEM		// 12
		Replace CLVL		With cArqCT2->CLVL		// 12
		//If cArqCT2->DC == "3"
		If lImpCPartida
			Replace XPARTIDA	With cArqCT2->XPARTIDA// 12
		EndIf		
		Replace HISTORICO	With cArqCT2->HIST		// 12
		Replace EMPORI		With cArqCT2->EMPORI	// 12
		Replace FILORI		With cArqCT2->FILORI	// 12
		Replace SEQHIST		With cArqCT2->SEQHIS	// 12
		Replace SEQLAN		With cArqCT2->SEQLAN	// 12

		If lChi
			Replace SEGOFI With cArqCT2->SEGOFI 	// 12
		EndIf

		If cArqCT2->TIPOLAN = '1'
			Replace LANCDEB	With LANCDEB + cArqCT2->VALOR //12
		EndIf
		If cArqCT2->TIPOLAN = '2'
			Replace LANCCRD	With LANCCRD + cArqCT2->VALOR //12
		EndIf	
		MsUnlock()
	Endif         
	lNoMovim	:= .F.	
	dbSelectArea("cArqCT2")	
	dbSkip()
	nMeter++
	oMeter:Set(nMeter)		
Enddo	
*/
//RestArea(aSaveArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbQbPg   ºAutor  ³Marcos S. Lobo      º Data ³  12/02/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Controla a quebra de pagina dos relatorios SIGACTB          º±±
±±º          ³quando possuem os parametros de PAG.INICAL-FINAL-REINICIAR  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro1³ lNewVars  = (.T.=Inicializa variaveis/.F.=Trata Quebra)    º±±
±±º         2³ nPagIni 	 = Pagina Inicial do relatorio.               	  º±±
±±º         3³ nPagFim 	 = Pagina Final do relatorio               	 	  º±±
±±º         4³ nReinicia = Pagina ao Reiniciar do relatorio               º±±
±±º         5³ m_pag 	 = Numero da pagina usada na Cabec()              º±±
±±º         6³ nBloco    = Bloco de paginas (intervalo de quebra)		  º±±
±±º         7³ nBlCount  = Contador de páginas (zerado na qebra de bloco) º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbQbPg(lNewVars,nPagIni,nPagFim,nReinicia,m_pag,nBloco,nBlCount)

lNewVars := .F.

If lNewVars					/// INICIALIZA AS VARIAVEIS
	nBloco		:= (nPagFim+1) - nPagIni				/// (PAG. FIM + 1) - PAG. INICIAL - BLOCO DE PAG. PARA IMPRESSAO
	nBlCount	:= 0
	m_pag		:= nPagIni
Else						/// NAO INICIALIZA - TRATA A QUEBRA DE PAGINA
	nBlCount++
	If nBlCount > nBloco 							/// SE A QUANTIDADE DE PAGINAS IMPRESSAO FOR IGUAL AO BLOCO DEFINIDO
		If nReinicia > nPagFim						/// SE A PAG. DE REINICIO FOR MAIOR QUE A PAGINA FINAL (ATUAL)
			nUltPg	  := m_pag						/// GUARDA A ULTIMA PAG. IMPRESSA
			m_pag 	  := nReinicia					/// REINICIA A NUMERACAO DE PAG. (m_pag atual ainda não foi)
			nPagFim   := nReinicia+nBloco 			/// DEFINE O NOVO NUMERO DA PAGINA FIM
			nReinicia := nPagFim+(nReinicia-nUltPg)	/// DEFINE A PROX. PAG. AO REINICIAR PELA DIFERENCA COM  FINAL
		Else										/// SE A PAG. DE REINICIO FOR MENOR OU IGUAL A PAGINA FINAL                                                                
			m_pag := nReinicia						/// SO REINICIA A NUMERACAO DE PAG.
		Endif
		nBlCount := 1
	EndIf	
Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjCTR400MVºAutor  ³Marcos S. Lobo      º Data ³  08/30/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona opcao de Imprissao da Conta Sem Movimento com Saldoº±±
±±º          ³Adiciona opcao na pergunta 09 do grupo CTR400               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - RAZAO CONTABIL                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjCTR400MV9()
    
dbSelectArea("SX1")
dbSetOrder(1)
If !MsSeek("CTR40009",.F.)							/// SE A PERGUNTA NAO EXISTIR
	Return
EndIf

If Empty(SX1->X1_DEF03)
	RecLock("SX1",.F.)
	Field->X1_DEF03 	:= "Nao c/ Sld.Ant."
	Field->X1_DEFSPA3	:= "No c/ Sld.Ant."
	Field->X1_DEFENG3	:= "No wh Prev.Bal."
	SX1->(MsUnlock())
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³AjusteSX1 ³ Autor ³ Paulo Augusto         ³ Data ³ 23/06/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Cria pergunta para imprimir linha em branco entre lanctos  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjusteSX1()

Local aSaveArea 	:= GetArea()
Local aPergs		:= {}
Local aHelpPor		:= {}
Local aHelpEng		:= {}
Local aHelpSpa		:= {}


// Parâmetro 30 - Salta linha entre contas?

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe se imprime linhas entre")			
Aadd(aHelpPor,"as contas.")


Aadd(aHelpEng,"Enter whether to print blank ")
Aadd(aHelpEng,"lines between accounts.")

Aadd(aHelpSpa,"Informe si imprime lineas en")
Aadd(aHelpSpa,"blanco entre las cuentas.")

Aadd(aPergs,{"Salta linha entre contas?","¨Salta linea entre cuentas?","Skip line between accounts?","mv_chv","N",1,0,1,"C",,"mv_par30","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})


// Parâmetro 31 - Num.linhas p/ o Razao?

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe a quantidade de linhas ")			
Aadd(aHelpPor,"que serao impressas em cada pag.")
Aadd(aHelpPor,"do Razao.")

Aadd(aHelpEng,"Enter the number of rows to ")
Aadd(aHelpEng,"be printed in each Ledger ")
Aadd(aHelpEng,"page.")

Aadd(aHelpSpa,"Indique la cantidad de lineas ")
Aadd(aHelpSpa,"que imprimiran en cada pag. ")
Aadd(aHelpspa,"del Mayor.")                             

Aadd(aPergs,{"Num.linhas p/ o Razao?","¨Num.lineas p/ Mayor?","No.of rows for the Ledger?","mv_chw","N",2,0,0,"G",,"mv_par31","56","","","56","","","","","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})


AjustaSx1("CTR400",aPergs)   

RestArea(aSaveArea)

Return
