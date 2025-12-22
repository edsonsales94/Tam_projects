#Include "Ctbr100.Ch"
#Include "PROTHEUS.Ch"

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA  			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT     	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO    	8
#DEFINE 	COL_SEPARA5			9 
#DEFINE 	COL_VLR_CREDITO   	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13                                                                                       
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr100	³ Autor ³ Simone Mie Sato   	³ Data ³ 09.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Item /Conta                   			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr100()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ SIGACTB      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INCtbr10()

Local aSetOfBook
Local aCtbMoeda		:= {}
Local cSayItem		:= CtbSayApro("CTD")
LOCAL cDesc1 		:= OemToAnsi(STR0001)+ Upper(cSayItem)	+ " / "+Upper(OemtoAnsi(STR0021))//"Este programa ira imprimir o Balancete de Conta / "
LOCAL cDesc2 		:= OemToansi(STR0002)  //"de acordo com os parametros solicitados pelo Usuario"
LOCAL wnrel
LOCAL cString		:= "CT1"
Local titulo 		:= OemToAnsi(STR0003)+ Upper(cSayItem) + " / "+Upper(OemToAnsi(STR0021)) 	//"Balancete de Verificacao Conta / "
Local lRet			:= .T.
Local nDivide		:= 1

PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("CTR100",Len(SX1->X1_GRUPO))
PRIVATE aReturn 	:= { OemToAnsi(STR0015), 1,OemToAnsi(STR0016), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
//PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "CTBR100"
PRIVATE Tamanho		:="M"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li 		:= 80
m_pag	:= 1

CTR100SX1()
Pergunte("CTR100",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  	   	³
//³ mv_par01				// Data Inicial              	       	³
//³ mv_par02				// Data Final                          	³
//³ mv_par03				// Conta Inicial                       	³
//³ mv_par04				// Conta Final  					   	³
//³ mv_par05				// Item Inicial                        	³
//³ mv_par06				// Item Final   					   	³
//³ mv_par07				// Imprime Contas: Sintet/Analit/Ambas	³
//³ mv_par08				// Set Of Books				    	   	³
//³ mv_par09				// Saldos Zerados?			     	   	³
//³ mv_par10				// Moeda?          			     	   	³
//³ mv_par11				// Pagina Inicial  		     		   	³
//³ mv_par12				// Saldos? Reais / Orcados	/Gerenciais	³
//³ mv_par13				// Quebra por Grupo Contabil?		   	³
//³ mv_par14				// Imprimir ate o Segmento?			  	³
//³ mv_par15				// Filtra Segmento?					   	³
//³ mv_par16				// Conteudo Inicial Segmento?		   	³
//³ mv_par17				// Conteudo Final Segmento?		       	³
//³ mv_par18				// Conteudo Contido em?				   	³
//³ mv_par19				// Imprime Movimento do Mes            	³
//³ mv_par20				// Imprime Totalizacao de Itens Sintet.	³
//³ mv_par21				// Pula Pagina                         	³

//³ mv_par22				// Salta linha sintetica ?			    ³
//³ mv_par23				// Imprime valor 0.00    ?			    ³
//³ mv_par24				// Imprimir Codigo? Normal / Reduzido  	³
//³ mv_par25				// Divide por ?                   		³
                                                                     
//³ mv_par26				// Imprime Cod. Conta ? Normal/Reduzido ³
//³ mv_par27				// Posicao Ant. L/P? Sim / Nao         	³
//³ mv_par28 				// Data Lucros/Perdas?                	³
//³ mv_par29				// Item ate o Segmento?			   		³
//³ mv_par30				// Filtra Segmento?					   	³
//³ mv_par31				// Conteudo Inicial Segmento?		   	³
//³ mv_par32				// Conteudo Final Segmento?		       	³
//³ mv_par33				// Conteudo Contido em?				   	³
//³ mv_par34				// Imprime I.Cont.: Sintet/Analit/Ambas	³
//³ mv_par35				// Rec./Desp. Anterior Zeradas?			³		
//³ mv_par36				// Grupo Receitas/Despesas?      		³		
//³ mv_par37				// Data de Zeramento Receita/Despesas?	³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel	:= "CTBR100"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par08)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par08)
Endif

If mv_par25 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par25 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par25 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par10)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If lRet
	If (mv_par35 == 1) .and. ( Empty(mv_par36) .or. Empty(mv_par37) )
		cMensagem	:= STR0023	// "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
		cMensagem	+= STR0024	// "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")	
		lRet    	:= .F.	
    EndIf
EndIf

If !lRet
	Set Filter To
	Return
EndIf

If mv_par19 == 1			// Se imprime coluna movimento -> relatorio 220 colunas
	tamanho := "G"
EndIf

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR100Imp(@lEnd,wnrel,cString,aSetOfBook,aCtbMoeda,cSayItem,nDivide)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR100IMP ³ Autor ³ Simone Mie Sato       ³ Data ³ 09.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Balancete Conta/Item.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr100Imp(lEnd,Wnrel,cString,aSetOfBook,aCtbMoeda,cSayItem) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Sigactb                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd       - A‡ao do Codeblock                             ³±±
±±³          ³ wnRel      - Nome do Relatorio                             ³±±
±±³          ³ cString    - Mensagem                                      ³±±
±±³          ³ aSetOfBook - Array de configuracao set of book             ³±±
±±³          ³ aCtbMoeda  - Moeda                                         ³±±
±±³          ³ cSayItem   - Descricao do item utilizada pelo usuario.     ³±±
±±³          ³ nDivide    - Fator de divisao de valores                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR100Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayItem,nDivide)

LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL tamanho		:= "M"
LOCAL limite		:= 132
Local cabec1  		:= ""
Local cabec2		:= ""

Local aColunas

Local cSepara1		:= ""
Local cSepara2		:= ""
Local cPicture
Local cDescMoeda
Local cMascara1
Local cMascara2
Local cGrupo		:= ""
Local cItemAnt 		:= ""
Local cSegAte   	:= mv_par14
Local cArqTmp		:= ""

Local dDataLP		:= mv_par28
Local dDataFim		:= mv_par02

Local lFirstPage	:= .T.
Local lPula			:= Iif(mv_par22==1,.T.,.F.)
Local lJaPulou		:= .F.
Local l132			:= .T.
Local lImpAntLP		:= Iif(mv_par27==1,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local lPrintZero	:= Iif(mv_par23==1,.T.,.F.)
Local lItemNormal	:= Iif(mv_par24==1,.T.,.F.)
Local lContaNormal	:= Iif(mv_par26==1,.T.,.F.)
Local lSaltaPag		:= Iif(mv_par21==1,.T.,.F.)
Local lImpTotIt		:= .T.								/// INDICA SE DEVE IMPRIMIR O TOTAL POR ITEM

Local nNroHoras     := GetMv("MV_NROHOR")    // Número de horas por mês
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nTamItem		:= Len(CriaVar("CTD_ITEM"))
Local nTotItDeb		:= 0
Local nTotItCrd		:= 0
Local nDigitAte		:= 0
Local nDigGrAte		:= 0
Local n
Local lRecDesp0		:= Iif(mv_par35==1,.T.,.F.)
Local cRecDesp		:= mv_par36
Local dDtZeraRD		:= mv_par37

Local aDbfItem      := {}
Local cArqItem      := ""
Local cIndItem      := ""
Local _cHeader      := "CTD"
Local _lImp3Ent     := Nil

Private nTotPer     := 0   // Total do Periodo

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)

//Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1 	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf             

// Mascara do Item Contabil
If Empty(aSetOfBook[7])
	cMascara2 := ""
Else
	cMascara2 := RetMasCtb(aSetOfBook[7],@cSepara2)
EndIf

cPicture 		:= aSetOfBook[4]

If mv_par19 == 1 // Se imprime saldo movimento do periodo
	cabec1 := OemToAnsi(STR0004)  //"|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |    DEBITO     |    CREDITO   | MOVIMENTO DO PERIODO |   SALDO ATUAL    |"
	tamanho := "G"
	limite	:= 220        
	l132	:= .F.
Else	
	cabec1 := OemToAnsi(STR0005)  //"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
Endif
SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == 1
	Titulo:=	OemToAnsi(STR0006) + Upper(cSayItem)+ " / " + Upper(OemToAnsi(STR0021))	//"BALANCETE ANALITICO DE  / CONTA"
ElseIf mv_par07 == 2
	Titulo:=	OemToAnsi(STR0007) + Upper(cSayItem)+ " / "+ Upper(OemToAnsi(STR0021))	//"BALANCETE SINTETICO DE  / CONTA"
ElseIf mv_par07 == 3
	Titulo:=	OemToAnsi(STR0008) + Upper(cSayItem)+ " / "+ Upper(OemToAnsi(STR0021))	//"BALANCETE DE  / CONTA"
EndIf

Titulo += 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) + Dtoc(mv_par02) + ;
				OemToAnsi(STR0011) + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
EndIf

If nDivide > 1			
	Titulo += " (" + OemToAnsi(STR0022) + Alltrim(Str(nDivide)) + ")"
EndIf	

If l132
	aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
Else
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

// Limpa o conteudo dos parametros de contas, do aSetOfBook e salva o Cod. Config. Livros
mv_par03   := Replicate(" ",Len(mv_par03))
mv_par04   := Replicate("Z",Len(mv_par04))
cCustoIni  := Replicate(" ",Len(CTT->CTT_CUSTO))
cCustoFim  := Replicate("Z",Len(CTT->CTT_CUSTO))
cAuxPar08  := mv_par08
mv_par08   := Replicate(" ",Len(mv_par08))
aSetOfBook := {"","",0,"",""}

If !Empty(cAuxPar08)  // Configura processamento da 3a entidade contábil
   _cHeader   := "CTT"
   _lImp3Ent  := .T.
   Titulo     := StrTran(Titulo,Upper(cSayItem)+ " / " + Upper(OemToAnsi(STR0021)),"AREAS")
Endif

m_pag := mv_par11
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT4","",mv_par03,mv_par04,cCustoIni,cCustoFim,mv_par05,mv_par06,,,mv_par10,;
				mv_par12,aSetOfBook,mv_par15,mv_par16,mv_par17,mv_par18, l132,.T.,,_cHeader,;
				lImpAntLP,dDataLP,nDivide,lVlrZerado,,,mv_par30,mv_par31,mv_par32,mv_par33,,,,,,,,,aReturn[7],lRecDesp0,;
				cRecDesp,dDtZeraRD,_lImp3Ent)},;
				OemToAnsi(OemToAnsi(STR0014)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0003)+cSayItem+" / "+OemToAnsi(STR0021))     //"Balancete Verificacao Conta /"

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	For n := 1 to Val(cSegAte)
		nDigitAte += Val(Subs(cMascara1,n,1))	
	Next
EndIf		

// Verifica Se existe filtragem Ate o Segmento
If !Empty(mv_par29)
	For n := 1 to Val(mv_par29)
		nDigGrAte += Val(Subs(cMascara2,n,1))	
	Next
EndIf		

// Monta arquivo para calcular o valor homem / hora
AAdd( aDbfItem , { "ITEM"  , "C", Len(cArqTmp->ITEM), 0})
AAdd( aDbfItem , { "NORMAL", "C",                  1, 0})
AAdd( aDbfItem , { "TOTAL" , "N",                 14, 2})

cArqItem := CriaTrab(aDbfItem,.T.)
Use &(cArqItem) Alias ITE1 New Exclusive
cIndItem := CriaTrab( Nil,.F.)
IndRegua("ITE1",cIndItem,"ITEM",,,OemToAnsi("Selecionando Registros..."))

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	Return
Endif

If !Empty(cAuxPar08)
   MontaNovoArq(cAuxPar08,@cArqTmp)
Endif

SetRegua(RecCount())

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0017)   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If mv_par34 == 1					// So imprime Sinteticas
		If TIPOITEM == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par34 == 2				// So imprime Analiticas
		If TIPOITEM == "1"
			dbSkip()
			Loop
		EndIf
	EndIf

	If mv_par07 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par07 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf

	//Filtragem ate o Segmento da Conta( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf

	//Filtragem ate o Segmento do Item ( antigo nivel do SIGACON)		
	If !Empty(mv_par29)
		If Len(Alltrim(ITEM)) > nDigGrAte
			dbSkip()
			Loop
		Endif
	EndIf

	************************* ROTINA DE IMPRESSAO *************************
		
	If mv_par13 == 1				// Grupo Diferente
		If cGrupo != GRUPO
			lSaltaPag 	:= .T.
			li			:= 60
			cGrupo		:= GRUPO
		EndIf		
		lImpTotIt := .T.
	EndIf
		
	cItemAnt 	:= cArqTmp->ITEM
	cItemAntRes := cArqTmp->ITEMRES

	If li > 58 .Or. lFirstPage .Or. lSaltaPag
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	EndIf	
	
    // Imprime a descrição da Configuração do Livro utilizado no Plano Gerencial
    If !Empty(cAuxPar08)
       CTN->(dbSetOrder(1))
       CTN->(dbSeek(XFILIAL()+cAuxPar08))
 
       @ li,000 PSAY CTN->CTN_CODIGO+" - "+CTN->CTN_DESC
       li++
    Endif
	@ li,000 PSAY REPLICATE("-",limite)
	li++
	@ li,000 PSAY "|"                                
	@ li,001 PSAY Upper(cSayItem) + " : "
	If lItemNormal .or. TIPOITEM == "1"
		EntidadeCTB(ITEM,li,17,nTamItem+Len(cSepara2),.F.,cMascara2,cSepara2)					
	Else
		EntidadeCTB(ITEMRES,li,17,nTamItem+Len(cSepara2),.F.,cMascara2,cSepara2)		
	Endif			
	@ li,aColunas[COL_CONTA]+ Len(CriaVar("CTD_DESC01")) PSAY " - " +cArqTMP->DESCITEM
	@ li,131 PSAY "|"		                                        
	li++
	@ li,000 PSAY REPLICATE("-",limite)		
	li+=1		                                                    			
   
	While !Eof() .And. cItemAnt == cArqTmp->ITEM

		If mv_par07 == 1					// So imprime Sinteticas
			If TIPOCONTA == "2"
				dbSkip()
				Loop
			EndIf
		ElseIf mv_par07 == 2				// So imprime Analiticas
			If TIPOCONTA == "1"
				dbSkip()
				Loop
			EndIf
		EndIf

		//Filtragem ate o Segmento da Conta( antigo nivel do SIGACON)		
		If !Empty(cSegAte)
			If Len(Alltrim(CONTA)) > nDigitAte
				dbSkip()
				Loop
			Endif
		EndIf	

		If mv_par13 == 1				// Salta página por Grupo
			If cGrupo != GRUPO
				lImpTotIt 	:= .F.
				Exit
			EndIf		
		EndIf
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		If lContaNormal .or. TIPOCONTA == "1"
			EntidadeCTB(CONTA,li,aColunas[COL_CONTA],20,.F.,cMascara1,cSepara1)
		Else	
			EntidadeCTB(CTARES,li,aColunas[COL_CONTA],20,.F.,cMascara1,cSepara1)
		EndIf	
		
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCCTA,1,31)
		@ li,aColunas[COL_SEPARA3] PSAY "|"
		ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132
			ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA7] PSAY "|"	
		Endif
		ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		
		lJaPulou := .F.
		If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
			li++
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"	
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132  
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			EndIf	
			li++
			lJaPulou := .T.
		Else
			li++
		EndIf			

		// Soma dos totalizadores
		If mv_par07 != 1					// Imprime Analiticas ou Ambas
			If TIPOCONTA == "2"
				If (mv_par34 != 1 .And. TIPOITEM == "2")
					nTotDeb 		+= SALDODEB 
					nTotCrd    		+= SALDOCRD
				ElseIf (mv_par34 == 1 .And. TIPOITEM != "2"	)
					nTotDeb 		+= SALDODEB 
					nTotCrd    		+= SALDOCRD			
				EndIf	
				nTotItDeb 		+= SALDODEB
				nTotItCrd 		+= SALDOCRD				
			Endif
		Else
			If (TIPOCONTA == "1" .And. Empty(SUPERIOR))
				If (mv_par34 != 1 .And. TIPOITEM == "2")
					nTotDeb 		+= SALDODEB 
					nTotCrd    		+= SALDOCRD
				ElseIf (mv_par34 == 1 .And. TIPOITEM != "2"	)
					nTotDeb 		+= SALDODEB 
					nTotCrd    		+= SALDOCRD	
				EndIf	
				nTotItDeb 		+= SALDODEB
				nTotItCrd 		+= SALDOCRD							
			EndIf		
		Endif
	
		dbSkip()  
		
		If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
			If !lJaPulou
				@ li,aColunas[COL_SEPARA1] PSAY "|"
				@ li,aColunas[COL_SEPARA2] PSAY "|"
				@ li,aColunas[COL_SEPARA3] PSAY "|"	
				@ li,aColunas[COL_SEPARA4] PSAY "|"
				@ li,aColunas[COL_SEPARA5] PSAY "|"
				@ li,aColunas[COL_SEPARA6] PSAY "|"
				If !l132  
					@ li,aColunas[COL_SEPARA7] PSAY "|"
					@ li,aColunas[COL_SEPARA8] PSAY "|"
				Else
					@ li,aColunas[COL_SEPARA8] PSAY "|"
				EndIf	
				li++
			EndIf	
		EndIf
		
		If li > 58 
			If !lFirstPage
				@Prow()+1,00 PSAY	Replicate("-",limite)
			EndIf		
			CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
			lFirstPage := .F.
		EndIf	
		
    EndDo
    
	If lImpTotIt
		// Impressao do Totalizador do Item
		@li,00 PSAY	Replicate("-",limite)
		li++
		@li,0 PSAY "|"          			
		@li,01 PSAY OemToAnsi(STR0020)+ Upper(cSayItem)+" : "  		//"T O T A I S  D O  "
		If lItemNormal .or. TIPOITEM == "1"	  // Codigo Normal do Item ou tipo = 1 (sintetico)
			EntidadeCTB(cItemAnt,li,40,nTamItem+Len(cSepara2),.F.,cMascara2,cSepara2)		
		Else
			EntidadeCTB(cItemAntRes,li,40,nTamItem+Len(cSepara2),.F.,cMascara2,cSepara2)
		EndIf
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		ValorCTB(nTotItDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		ValorCTB(nTotItCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)			
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132
			nTotMov := (nTotItCrd - nTotItDeb)
			If Round(NoRound(nTotMov,3),2) < 0
				ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
			ElseIf Round(NoRound(nTotMov,3),2) > 0
				ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
		    EndIf
			@ li,aColunas[COL_SEPARA7] PSAY "|"	
		Endif
		@ li,aColunas[COL_SEPARA8] PSAY "|"
		nTotItDeb := 0
		nTotItCrd := 0                     
		li++

        ITE1->(dbSeek(cItemAnt))  // Posiciona no Item Contábil (Colaborador)

		@li,0 PSAY "|"          			
		@li,01 PSAY OemToAnsi(STR0025)+" ("+LTrim(Str(nNroHoras,5))+")"		//"H O M E M   /   H O R A : "
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132
			ValorCTB(ITE1->TOTAL/nNroHoras,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA7] PSAY "|"	
		Endif
		@ li,aColunas[COL_SEPARA8] PSAY "|"

		If li > 58  	
			If !lFirstPage
				@Prow()+1,00 PSAY	Replicate("-",limite)
			EndIf
			CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
			lFirstPage := .F.
		EndIf	
	EndIf
	
EndDO

IF li != 80 .And. !lEnd
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY "|"
	@li, 10 PSAY OemToAnsi(STR0018)  		//"T O T A I S  D O  P E R I O D O : "
	@ li,aColunas[COL_SEPARA4] PSAY "|"	
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] PSAY "|"
	If !l132
		@ li,aColunas[COL_SEPARA7] PSAY "|"	
	Endif
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	li++

	@li,0 PSAY "|"
	@li, 10 PSAY OemToAnsi(STR0025)+" ("+LTrim(Str(nNroHoras,5))+")"		//"H O M E M   /   H O R A : "
	@ li,aColunas[COL_SEPARA4] PSAY "|"	
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	@ li,aColunas[COL_SEPARA6] PSAY "|"
	If !l132
		nTotMov := (nTotCrd - nTotDeb)
		ValorCTB(nTotPer/nNroHoras,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"	
	Endif
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	If !lExterno
		roda(cbcont,cbtxt,"M")
		Set Filter To
	EndIf
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	Ferase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
EndIf
dbSelectArea("ITE1")
dbCloseArea()
Ferase(cArqItem+GetDBExtension())
FErase(cIndItem+OrdBagExt())
dbselectArea("CT2")

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTR100SX1    ³Autor ³  Simone Mie Sato     ³Data³ 16/05/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria as perguntas do relatório                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTR100SX1()

Local aArea 	:= GetArea()


aPergs 		:= {}    

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe se deseja ignorar o saldo ")			
Aadd(aHelpPor,"anterior das contas de receitas/despesas ")
Aadd(aHelpPor,"de acordo com o grupo e a data escolhida nas ")
Aadd(aHelpPor,"duas perguntas abaixo.")

Aadd(aHelpEng,"Enter if you want to ignore the prior ")
Aadd(aHelpEng,"balance of  revenue/expense accounts ")
Aadd(aHelpEng,"according to the group and chosen date ")
Aadd(aHelpEng,"in teh two queries below.")

Aadd(aHelpSpa,"Informe si desea ignorar el saldo ")
Aadd(aHelpSpa,"anterior de las cuentas de ingresos/ ")
Aadd(aHelpSpa,"gastos  de acuerdo con el grupo y la ")                             
Aadd(aHelpSpa,"fecha elegida en las dos preguntas ")
Aadd(aHelpSpa,"siguientes.")

Aadd(aPergs,{"Ignora Sl Ant.Rec/Des?","¨Ignora Sl Ant.Ing/Gas?","Ignore Rev/Exp.Pr.Blc?","mv_chz","N",1,0,0,"C","","mv_par35","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe quais os grupos de receitas/despesas")			
Aadd(aHelpPor,"que deverao ter seus saldos anteriores ignorados.")
Aadd(aHelpPor,"Essa pergunta sera considerada somente se a pergunta ")
Aadd(aHelpPor,"'Ignora Sl Ant.Rec/Des' estiver preenchida com 'Sim'.")                       

Aadd(aHelpEng,"Inform which revenue/expense groups must ")
Aadd(aHelpEng,"hold their prior balances ignored. ")
Aadd(aHelpEng,"This query will only be considered if the one ")
Aadd(aHelpEng,"'Ignore Rev/Exp.Pr.Blc' is filled out with 'Yes'")

Aadd(aHelpSpa,"Informe los grupos de ingresos/gastos que ")
Aadd(aHelpSpa,"deben tener sus saldos anteriores ignorados.")
Aadd(aHelpspa,"Esta pregunta solo se hara en el caso que ")                             
Aadd(aHelpspa,"'¨Ignora Sl Ant.Ing/Gas?' haya sido llenada ")
Aadd(aHelpspa," con 'Si'.")


Aadd(aPergs,{"Grupo Receitas/Desp. ?","¨Grupo Ingres./Gastos?","Revenue/Exp.Group?","mr_chz","C",5,0,0,"G","","mv_par36","","","","","","","","","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor	:= {} 
aHelpEng	:= {}	
aHelpSpa	:= {}

Aadd(aHelpPor,"Informe qual a data que as contas de receitas/despesas")			
Aadd(aHelpPor,"terao seus saldos anteriores ignorados.")
Aadd(aHelpPor,"Essa pergunta sera considerada somente se a pergunta ")
Aadd(aHelpPor,"'Ignora Sl Ant.Rec/Des' estiver preenchida com 'Sim'.")

Aadd(aHelpEng,"Inform which date the revenue/expense accounts will ")
Aadd(aHelpEng," hold their prior balances ignored.This query will ")
Aadd(aHelpEng," only be considered if the one 'Ignore Rev/Exp.Pr.Blc'")
Aadd(aHelpEng," is filled out with 'Yes'.")                          

Aadd(aHelpSpa,"Informe la fecha en que las cuentas de ingresos/gastos ")
Aadd(aHelpSpa,"tendran sus saldos anteriores ignorados. ")
Aadd(aHelpspa,"Esta pregunta solo se hara en el caso que ")                             
Aadd(aHelpSpa,"'¨Ignora Sl Ant.Ing/Gas?' haya sido llenada con 'Si'.")

Aadd(aPergs,{"Data Sld Ant.Rec/Desp?"      ,"¨Fecha Sld Ant.Ing/Gas?","Rev/Exp.Prior Blc.Date?","mv_chz","D",8,0,0,"G","","mv_par37","","","","","","","","","","","","","","","","","","","","","","","","","","","S","",aHelpPor,aHelpEng,aHelpSpa})

AjustaSx1("CTR100",aPergs)   

RestArea(aArea)

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦MontaNovoArq¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 09/02/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Baseado no arquivo temporario criado pela rotina CTGERPLAN,   ¦¦¦
¦¦¦           ¦ monta novo arquivo agrupando os dados conforme Plano Gerencial¦¦¦
¦¦¦           ¦ escolhido no parametro.                                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaNovoArq(cConfig,cArqTmp)
   Local aDbf, cKey, cFil, cArq, cInd, x, nRegCTS, cQry
   Local cFilSRA := SRA->(XFILIAL())
   Local cFilCT2 := CT2->(XFILIAL())
   Local cFilCTS := CTS->(XFILIAL())
   Local cTabCT2 := RetSQLName("CT2")

   // Salva as configuracoes do arquivo temporario criado pelo sistema
   dbSelectArea("cArqTmp")
   aDbf := dbStruct()
   cKey := IndexKey()
   cFil := ""   //SetFilter()

   // Apaga o filtro e indice do arquivo temporario e cria uma ordem por conta contabil
   If Trim(cKey) <> "CONTA+ITEM"
      dbClearFilter()
      dbClearIndex()
      IndRegua("cArqTmp","cArqInd","CONTA+ITEM",,cFil,OemToAnsi("Selecionando Registros..."))
   Endif

   // Cria o novo arquivo temporario que conterá os dados conforme a Visão Gerencial
   cArq := CriaTrab(aDbf,.T.)
   Use &(cArq) Alias TMP1 New Exclusive
   cInd := CriaTrab( Nil,.F.)
   IndRegua("TMP1",cInd,"ITEM+CONTA",,cFil,OemToAnsi("Selecionando Registros..."))

   dbSelectArea("CTS")
   dbSetOrder(1)
   dbSeek(cFilCTS+cConfig,.T.)
   While !Eof() .And. cFilCTS+cConfig == CTS->CTS_FILIAL+CTS->CTS_CODPLA

      If CTS_CLASSE == "1"   // Nao processa as contas sinteticas
         dbSkip()
         Loop
      Endif

      dbSelectArea("cArqTmp")
      dbSeek(CTS->CTS_CT1INI,.T.)
      While !Eof() .And. cArqTmp->CONTA <= CTS->CTS_CT1FIM

         SRA->(dbSetOrder(1))
         If SRA->(dbSeek(cFilSRA+PADR(cArqTmp->ITEM,6)))
            If SRA->RA_CATFUNC <> "M"   // Se nao for Mensalista
               dbSkip()
               Loop
            Endif
         Else
            dbSkip()
            Loop
         Endif

         // Processa os filtros do parametro
         If CONTA < mv_par03 .Or. CONTA > mv_par04 .Or.;
            ITEM  < mv_par05 .Or. ITEM  > mv_par06
            dbSkip()
            Loop
         Endif

         // Processa o filtro do Item Contábil caso tenha sido incluído Itens na Visão Gerencial
         If !Empty(CTS->CTS_CTDINI) .Or. !Empty(CTS->CTS_CTDFIM)
            If ITEM < CTS->CTS_CTDINI .Or. ITEM > CTS->CTS_CTDFIM
               dbSkip()
               Loop
            Endif
         Endif

         // Processa o filtro da Classe de Valor caso tenha sido incluído Classes na Visão Gerencial
         If !Empty(CTS->CTS_CTHINI) .Or. !Empty(CTS->CTS_CTHFIM)
            If CLVL < CTS->CTS_CTHINI .Or. CLVL > CTS->CTS_CTHFIM
               dbSkip()
               Loop
            Endif
         Endif

         // Processa o filtro do Centro de Custo caso tenha sido incluído C.C.'s na Visão Gerencial
         If !Empty(CTS->CTS_CTTINI) .Or. !Empty(CTS->CTS_CTTFIM)
            If CUSTO < CTS->CTS_CTTINI .Or. CUSTO > CTS->CTS_CTTFIM
               dbSkip()
               Loop
            Endif
         Endif

         nRegCTS := CTS->(Recno())
         While !Empty(CTS->CTS_CONTAG)
            dbSelectArea("TMP1")
            If !dbSeek(cArqTmp->ITEM+CTS->CTS_CONTAG)
               RecLock("TMP1",.T.)
               For x:=1 To FCount()
                  FieldPut( x , cArqTmp->(FieldGet(x)) )
               Next
               TMP1->CONTA     := CTS->CTS_CONTAG
               TMP1->SUPERIOR  := CTS->CTS_CTASUP
               TMP1->DESCCTA   := CTS->CTS_DESCCG
               TMP1->NORMAL    := CTS->CTS_NORMAL
               TMP1->COLUNA    := CTS->CTS_COLUNA
               TMP1->ORDEM     := CTS->CTS_ORDEM
               TMP1->TIPOCONTA := CTS->CTS_CLASSE
            Else
               RecLock("TMP1",.F.)
               TMP1->SALDOANT   += cArqTmp->SALDOANT
               TMP1->SALDOANTDB += cArqTmp->SALDOANTDB
               TMP1->SALDOANTCR += cArqTmp->SALDOANTCR
               TMP1->SALDODEB   += cArqTmp->SALDODEB
               TMP1->SALDOCRD   += cArqTmp->SALDOCRD
               TMP1->SALDOATU   += cArqTmp->SALDOATU
               TMP1->SALDOATUDB += cArqTmp->SALDOATUDB
               TMP1->SALDOATUCR += cArqTmp->SALDOATUCR
               TMP1->MOVIMENTO  += cArqTmp->MOVIMENTO
            Endif
            MsUnLock()

            // Atualiza valores no Item Contábil
            dbSelectArea("ITE1")
            If !dbSeek(cArqTmp->ITEM)
               RecLock("ITE1",.T.)
               ITE1->ITEM   := cArqTmp->ITEM
               ITE1->NORMAL := TMP1->NORMAL
               MsUnLock()
            Endif

            // Busca a conta superior da conta atual
            CTS->(dbSetOrder(2))
            If !CTS->(dbSeek(cFilCTS+cConfig+CTS->CTS_CTASUP))
               Exit
            Endif

         Enddo
         CTS->(dbSetOrder(1))
         CTS->(dbGoTo(nRegCTS))
         dbSelectArea("cArqTmp")

         dbSkip()
      Enddo

      dbSelectArea("CTS")
      dbSkip()
   Enddo

   // Fecha o temporario criado pelo sistema para que o novo seja criado no seu lugar
   dbSelectArea("cArqTmp")
   dbCloseArea()
   If Select("cArqTmp") == 0
      Ferase(cArqTmp+GetDBExtension())
      FErase("cArqInd"+OrdBagExt())
   EndIf

   // Fecha o novo temporario criado
   dbSelectArea("TMP1")
   dbCloseArea()
   If Select("TMP1") == 0
      FErase(cInd+OrdBagExt())
   EndIf

   // Acumula valores para o ITEM em outros Streams
   dbSelectArea("ITE1")
   dbGoTop()
   While !Eof()

      // Monta query para somar os valores lançados para o item contábil
      cQry := "SELECT CT2_ITEMD, SUM(CT2_VALOR)CT2_VALOR, COUNT(*)CT2_COUNT FROM "+cTabCT2+" WHERE "
      cQry += "D_E_L_E_T_ = ' ' AND CT2_FILIAL = '"+cFilCT2+"' AND CT2_MOEDLC = '"+mv_par10+"' AND "
      cQry += "CT2_TPSALD = '"+mv_par12+"' AND CT2_ITEMD = '"+ITE1->ITEM+"' AND "
      cQry += "CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"' AND "
      cQry += "EXISTS(SELECT * FROM "+RetSQLName("CTS")+" WHERE D_E_L_E_T_=' ' AND "
      cQry += "CTS_TPSALD = '"+mv_par12+"' AND "
      cQry += "CT2_DEBITO >= CTS_CT1INI AND CT2_DEBITO <= CTS_CT1FIM AND "
      cQry += "CT2_CCD >= CTS_CTTINI AND CT2_CCD <= CTS_CTTFIM AND "
      cQry += "CTS_CODPLA NOT IN ('001','002','003')) "
      cQry += "GROUP BY CT2_ITEMD"

      For x:=1 To 2

         If x == 2  // Na segunda vez, altera para pegar os valores do Credito
            cQry := StrTran(cQry,"CT2_ITEMD","CT2_ITEMC")
            cQry := StrTran(cQry,"CT2_DEBITO","CT2_CREDIT")
            cQry := StrTran(cQry,"CT2_CCD","CT2_CCC")
         Endif

         dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQry)), "QRY", .F., .T.)
         If If( x==1 , QRY->CT2_ITEMD, QRY->CT2_ITEMC) == ITE1->ITEM .And. QRY->CT2_VALOR > 0
            dbSelectArea("ITE1")
            RecLock("ITE1",.F.)
            ITE1->TOTAL += (QRY->CT2_VALOR * If( x==1 , 1, -1))
            MsUnLock()
            dbSelectArea("QRY")
         Endif
         dbCloseArea()
      Next
      RecLock("ITE1",.F.)
      If ITE1->NORMAL == "1"  // Se for Debito
         ITE1->TOTAL := (ITE1->TOTAL * If( ITE1->TOTAL > 0 , -1, 1))
      Else
         ITE1->TOTAL := (ITE1->TOTAL * If( ITE1->TOTAL > 0 , 1, -1))
      Endif
      MsUnLock()
      dbSelectArea("ITE1")

      nTotPer += ITE1->TOTAL

      dbSkip()
   Enddo

   // Abre o novo temporario criado com o mesmo nome e indice criado pelo sistema
   cArqTmp := cArq
   Use &(cArqTmp) Alias cArqTmp New Exclusive
   IndRegua("cArqTmp","cArqInd","ITEM+ORDEM",,cFil,OemToAnsi("Selecionando Registros..."))

   dbSetOrder(1)
   dbGoTop()
Return