#include "rwmake.ch" 

#define ESC     27

User Function Cpcp02r()


SetPrvt("TITULO,CSTRING,WNREL,CDESC,AORD,TAMANHO")
SetPrvt("ARETURN,CPERG,NLASTKEY,CBCONT,NQUANTITEM,CABEC1")
SetPrvt("COP,CDESCRI,CABEC2,LIMITE,NQUANT,NOMEPROG")
SetPrvt("NTIPO,CPRODUTO,CQTD,CINDSC2,NINDSC2,AARRAY")
SetPrvt("LI,CBTXT,M_PAG,LEND,OPR,I")
SetPrvt("NBEGIN,CCABEC1,CCABEC2,CCABEC3,LSH8,NLARGURA")
SetPrvt("J,L,K,NCARAC,CTEXTO,CESC")
SetPrvt("CCODE,NLIMITE,NIMP,NBORDA,NLIN,AV0")
SetPrvt("AV1,AIMP,CNUMOP,AARRAYPRO,LIMPITEM,NCNTARRAY")
SetPrvt("A01,A02,NX,NI,NL,NY")
SetPrvt("CNUM,CITEM,LIMPCAB,CDESCRI1,CDESCRI2,CCNT")
SetPrvt("AREGS,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR820  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07.07.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao Das Ordens de Producao                             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR820(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBS       ³ Programa transf. em RDMAKE por Fabricio Carlos David (CTC) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

titulo := ""
cString:= "SC2"
wnrel:="MATR820"
cDesc := "Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o"
aOrd := {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
tamanho:= "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
cPerg    :="CPCP02"
nLastKey := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Da OP                                 ³
//³ mv_par02            // Ate a OP                              ³
//³ mv_par03            // Da data                               ³
//³ mv_par04            // Ate a data                            ³
//³ mv_par05            // Imprime roteiro de operacoes          ³
//³ mv_par06            // Imprime codigo de barras              ³
//³ mv_par07            // Imprime Nome Cientifico               ³
//³ mv_par08            // Imprime Op Encerrada                  ³
//³ mv_par09            // Impr. por Ordem de                    ³
//³ mv_par10            // Impr. OP's Firmes, Previstas ou Ambas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !ChkFile("SH8",.F.)
	Help(" ",1,"SH8EmUso")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd)

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
Endif

RptStatus({||R820Imp()})
Return(NIL)

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R820Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function R820Imp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbCont:=""
nQuantItem:=0
cabec1:=""
cOp:="" 
cDescri:=""
cabec2:=""
limite := 132
nQuant := 1
nomeprog   := "CPCP02R"
nTipo      := 18
cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
cQtd       :=""
cIndSC2 := CriaTrab(NIL,.F.)
nIndSC2 :=0
aArray   :={}
li := 80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := ""
cabec2 := ""

dbSelectArea("SC2")
If aReturn[8] == 4
	  IndRegua("SC2",cIndSC2,"C2_FILIAL+C2_DATPRF",,,"Selecionando Registros...")
	dbGoTop()
Else
	dbSetOrder(aReturn[8])
EndIf

dbSeek(xFilial())

SetRegua(LastRec())

While !Eof()
	
	IF LastKEy()==27
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIF
	
	IncRegua()
		
	If  C2_DATPRF < mv_par03 .Or. C2_DATPRF > mv_par04
		dbSkip()
		Loop
	Endif
	
	If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN < xFilial()+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN > xFilial()+mv_par02
		dbSkip()
		Loop
	EndIf

	
	If !(Empty(C2_DATRF)) .And. mv_par08 == 2
		dbSkip()
		Loop
	Endif

	//-- Valida se a OP deve ser Impressa ou n„o
	If !MtrAValOP(mv_par10, 'SC2')
		dbSkip()
		Loop
	EndIf

	cProduto  := SC2->C2_PRODUTO
	nQuant    := SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA

    _aAlias := GetArea()
	dbSelectArea("SB1")                                                        
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AddAr820(nQuant)

	cOp:=SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"   "
	
	MontStruc() 
	
	If mv_par09 == 1
		aSort( aArray,2,, { |x, y| (x[1]+x[7]) < (y[1]+y[7]) } )
	Else
		aSort( aArray,2,, { |x, y| (x[7]+x[1]) < (y[7]+y[1]) } )
	EndIf
	
	IF (mv_par06 == 1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o codigo de barras do Cod.Produto + Numero da OP³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oPr := ReturnPrtObj()

 //       MSBAR("CODE3_9",1,2,Trim(cProduto)+cOP,oPr,.F.,,.T.,0.017,1,NIL,NIL,"B")
       MSBAR("CODE3_9",1,2,cOP,oPr,.F.,,.T.,0.017,1,NIL,NIL,"B")
	  
		/*
	       ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	       ±±±±±±±±±±±±±±Parametros da Funcao MSBAR()±±±±±±±±±±±±±±±±±±±
	       ±±±ImpressÆo de etiquetas c¢digo de Barras para HP e Laser±±±
	       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±
	       01 cTypeBar    String com o tipo do codigo de barras       ³± 
                          "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"  ³±
                          "INT25","MAT25,"IND25","CODABAR","CODE3_9"  ³±
	       02 nRow        Numero da Linha em centimentros             ³±
	       03 nCol        Numero da coluna em centimentros            ³±
	       04 cCode       String com o conteudo do codigo             ³±
	       05 oPr         Objecto Printer                             ³±
	       06 lcheck      Se calcula o digito de controle             ³±
	       07 Cor         Numero  da Cor, utilize a "common.ch"       ³±
	       08 lHort       Se imprime na Horizontal                    ³±
	       09 nWidth      Numero do Tamanho da barra em centimetros   ³±
	       10 nHeigth     Numero da Altura da barra em milimetros     ³±
	       11 lBanner     Se imprime o linha em baixo do codigo       ³±
	       12 cFont       String com o tipo de fonte                  ³±
	       13 cMode      String com o modo do codigo de barras CODE128³±
		*/

		//Exemplos:
		*MSBAR("EAN13"  , 12  ,  1 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
        *MSBAR("CODE128",  5  ,  1 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,"B")
        *MSBAR("EAN8"   , 5   , 10 ,"1234567"     ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
        *MSBAR("CODE3_9",  7.5,  1 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
        *MSBAR("CODABAR",  8  ,  7 ,"A12-34T"     ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
        *MSBAR("SUP5"   , 12  ,  1 ,"100441"      ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
        *MSBAR("UPCA"   , 15  ,  1 ,"07000002198" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
		*MSBAR("INT25"  , 21  ,  3 ,"123456789012",oPr,,,.t.)
		*MSBAR("MAT25"  , 23  ,  3 ,"123456789012",oPr,,,.t.)
		*MSBAR("IND25"  , 23  , 15 ,"123456789012",oPr,,,.t.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reestabelece a posicao da impressora p/ imprimir relatorio³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetPrc(10,0)

    Li := 10  // linha inicial do cabecalho

	ELSE
		Li := 0                                 // linha inicial do relatorio
	ENDIF
	        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime cabecalho                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cabecOp()

	For I := 2 TO Len(aArray)
        @Li ,   0 PSAY aArray[I][1]                                        // CODIGO PRODUTO
		For nBegin := 1 To Len(AllTrim(aArray[I][2])) Step 31
			@li,016 PSAY Substr(AllTrim(aArray[I][2]),nBegin,31)
		Next nBegin
		cQtd:= Alltrim(Transform(aArray[I][5],PesqPictQt("D4_QUANT",11)))
		@Li , (46+11-Len(cQtd)) PSAY cQtd                // QUANTIDADE
		@Li ,  57 PSAY "|"+Alltrim(aArray[I][4])+"|"             // UNIDADE DE MEDIDA
		@li ,  61 PSAY Alltrim(aArray[I][6])                     // OBSERVACAO
//		@li ,  76 PSAY "|"+AllTrim(aArray[I][7])                 // SEQUENCIA
		Li:=Li+1                                 
		@Li ,   0 PSAY REPLICATE("-",132)
		Li:=Li+1
		skip
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao couber, salta para proxima folha                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF li > 70
			Li := 10
			cabecOp()               // imprime cabecalho da OP
		EndIF
		
	Next 
	If mv_par05 == 1
		RotOper()       // IMPRIME ROTEIRO DAS OPERACOES
	Endif
    RestArea(_aAlias)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir Relacao de medidas para Cliente == HUNTER DOUGLAS.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SMX")
	If Found() .And. SC2->C2_DESTINA == "P"
		R820Medidas()
	EndIf
	
	m_pag:=m_pag+1
	Li := 0                                 // linha inicial - ejeta automatico
	aArray:={}
	
	dbSelectArea("SC2")
	dbSkip()
	EJECT
	
EndDO


dbSelectArea("SH8")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ClosFile("SH8")

dbSelectArea("SC2")
If aReturn[8] == 4
	RetIndex("SC2")
	Ferase(cIndSC2+OrdBagExt())
EndIf
Set Filter To
dbSetOrder(1)

Set device to Screen
RETURN

If aReturn[5] == 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return(NIL)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ AddAr820 ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Adiciona um elemento ao Array                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AddAr820(ExpN1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade da estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Static Function AddAr820()

cDesc := SB1->B1_DESC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se imprime nome cientifico do produto. Se Sim    ³
//³ verifica se existe registro no SB5 e se nao esta vazio    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 == 1
	dbSelectArea("SB5")
	dbSeek(xFilial()+SB1->B1_COD)
	If Found() .and. !Empty(B5_CEME)
		cDesc := B5_CEME
	EndIf
ElseIf mv_par07 == 2
	cDesc := SB1->B1_DESC
Else
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Verifica se imprime descricao digitada ped.venda, se sim  ³
      //³ verifica se existe registro no SC6 e se nao esta vazio    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SC2->C2_DESTINA == "P"
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM)
		If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
			cDesc := C6_DESCRI
		ElseIf C6_PRODUTO #SB1->B1_COD
			dbSelectArea("SB5")
			dbSeek(xFilial()+SB1->B1_COD)
			If Found() .and. !Empty(B5_CEME)
				cDesc := B5_CEME
		       EndIf
		EndIf
	EndIf
EndIf                   

dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial()+cProduto+SB1->B1_COD)

dbSelectArea("SB2")
dbSeek(xFilial()+SB1->B1_COD)
dbSelectArea("SD4")
AADD(aArray,{SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuant,SUBS(SG1->G1_OBSERV,1,70),D4_TRT } ) //nQuant
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStruc(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Return(nil)

Static Function MontStruc()

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSeek(xFilial()+SD4->D4_COD)
	If SD4->D4_QUANT > 0
		nQuant:=SD4->D4_QUANT
		AddAr820()
	EndIf
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ CabecOp  ³ Autor ³ Paulo Boschetti       ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta o cabecalho da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CabecOp()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> Function CabecOp
Static Function CabecOp()

cCabec1 := SM0->M0_NOME+"      O R D E M   D E   P R O D U C A O      Nr. :"
cCabec2 := "  C O M P O N E N T E S                                  |  |                   "
cCabec3 := "CODIGO          DESCRICAO                      QUANTIDADE|UM|OBSERVACAO         "
//                012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                          1         2         3         4         5         6         7         8
nBegin:=0

//If li #10
//	li := 0
//Endif

@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1
@Li  ,  0  PSAY cCabec1
@Li  , 90  PSAY SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1
@ Li  ,  0 PSAY "Produto: "+aArray[1][1]
@ Li  , 20 PSAY Posicione( "SB1", 1, xFilial("SB1")+SC2->C2_PRODUTO, "B1_DESC" )
ImpDescr(aArray[1][2])
Li:=Li+1
@Li  ,  0 PSAY "Emissao:"+DTOC(dDatabase)
@Li  , 73 PSAY "Fol:"+TRANSFORM(m_pag,'999')
Li:=Li+1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime nome do cliente quando OP for gerada            ³
//³ por pedidos de venda                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC2->C2_DESTINA == "P"
   dbSelectArea("SC5")
   dbSetOrder(1)
   dbSeek(xFilial()+SC2->C2_NUM)
   If Found()
      dbSelectArea("SA1")
      dbSetOrder(1)
      // Modificado cfe. requisicao do sr. Andre
      //dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
      dbSeek(xFilial()+SC5->C5_CLCLISP+SC5->C5_CLLOJSP)
      @Li  ,  0 PSAY "Cliente :"
      @Li  , 10 PSAY SC5->C5_CLCLISP+SC5->C5_CLLOJSP
      @Li  , 20 PSAY A1_NOME
      dbSelectArea("SG1")
      Li:=Li+1 
      @Li  , 0 PSAY "Observacao: " + SC5->C5_CLMSPED              
      Li:=Li+1 
   EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime a quantidade original quando a quantidade da    ³
//³ Op for diferente da quantidade ja entregue              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC2->C2_QUJE + SC2->C2_PERDA > 0
	@Li  ,  0 PSAY "Qtde Prod.:"
	@Li  , 11 PSAY SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA   PICTURE PesqPictQt("C2_QUANT",12)
	@Li  , 24 PSAY "Qtde Orig.:"
	@Li  , 35 PSAY SC2->C2_QUANT                  PICTURE PesqPictQt("C2_QUANT",12)
Else
	@Li  ,  0 PSAY "Quantidade :"
	@Li  , 15 PSAY SC2->C2_QUANT - SC2->C2_QUJE   PICTURE PesqPictQt("C2_QUANT",12)
Endif

@Li  , 48 PSAY "I N I C I O         F I M"
Li:=Li+1
_cSem:= Strzero(CalcSem(SC2->C2_EMISSAO),2)
@Li  ,  0 PSAY "Unid. Medida : "+aArray[1][4]
@Li  , 20 PSAY "Semana: " + _cSem
@Li  , 46 PSAY "Prev. : "+DTOC(SC2->C2_DATPRI)
@Li  , 64 PSAY "Prev. : "+DTOC(SC2->C2_DATPRF)
Li:=Li+1
@Li  ,  0 PSAY "C.Custo: "+SC2->C2_CC
@Li  , 46 PSAY "Ajuste: "+DTOC(SC2->C2_DATAJI)+"  Ajuste: "+DTOC(SC2->C2_DATAJF)
Li:=Li+1
If SC2->C2_STATUS == "S"
	@Li  ,  0 PSAY "Status: OP Sacram."
ElseIf SC2->C2_STATUS == "U"
	@Li  ,  0 PSAY "Status: OP Suspen."
ElseIf Empty(SC2->C2_STATUS)
	@Li  ,  0 PSAY "Status: OP Normal"
EndIf
@Li  , 20 PSAY "Rev: "+SB1->B1_REVATU
@Li  , 46 PSAY "Real  :   /  /    Real  :   /  / "
Li:=Li+1

If !(Empty(SC2->C2_OBS))
	@Li  ,  0 PSAY "Observacao: "
	
	For nBegin := 1 To Len(Alltrim(SC2->C2_OBS)) Step 65
		@li,012 PSAY Substr(SC2->C2_OBS,nBegin,65)
		li:=li+1
	Next nBegin
	
EndIf

@Li  ,  0 PSAY REPLICATE("*",132)
Li:=li+1
@Li  ,  0 PSAY cCabec2
Li:=li+1
@Li  ,  0 PSAY cCabec3
Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> Function RotOper
Static Function RotOper()

cCabec1 := SM0->M0_NOME+"              ROTEIRO DE OPERACOES              NRO :"
cCabec2 := "RECURSO                       FERRAMENTA               OPERACAO"
nBegin  :=0
lSH8    :=""

dbSelectArea("SG2")
dbSeek(xFilial()+aArray[1][1])

IF FOUND()
	
	cRotOper()
	
	While !Eof() .And. G2_FILIAL+G2_PRODUTO == xFilial()+aArray[1][1]
		
		dbSelectArea("SH4")
		dbSeek(xFilial()+SG2->G2_FERRAM)
		
		dbSelectArea("SH8")
		dbSetOrder(1)
		dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SG2->G2_OPERAC)
		lSH8 := IIf(Found(),.T.,.F.)
		
		If lSH8
			While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == cFilial+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SG2->G2_OPERAC
				ImpRot(lSH8)
				dbSelectArea("SH8")
				dbSkip()
			End
		Else
			ImpRot(lSH8)
		Endif
		
		dbSelectArea("SG2")
		dbSkip()
		
	EndDo
	
Endif

Return Li


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ ImpRot   ³ Autor ³ Marcos Bregantim      ³ Data ³ 10/07/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ ImpRot()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> Function ImpRot
Static Function ImpRot()
nBegin:=0

dbSelectArea("SH1")
dbSeek(xFilial()+IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))

Verilim()

@Li ,   0 PSAY IIF(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)+" "+SUBS(SH1->H1_DESCRI,1,25)
@Li ,  33 PSAY SG2->G2_FERRAM+" "+SUBS(SH4->H4_DESCRI,1,20)
@Li ,  61 PSAY SG2->G2_OPERAC

For nBegin := 1 To Len(Alltrim(SG2->G2_DESCRI)) Step 16
	@li,064 PSAY Substr(SG2->G2_DESCRI,nBegin,16)
	li:=li+1
Next nBegin

Li:=Li+1
@Li ,   0 PSAY "INICIO  ALOC.: "+IIF(lSH8,DTOC(SH8->H8_DTINI),Space(8))+" "+IIF(lSH8,SH8->H8_HRINI,Space(5))+" "+" INICIO  REAL : ____/ ____/____ ___:___"
Li:=Li+1
@Li ,   0 PSAY "TERMINO ALOC.: "+IIF(lSH8,DTOC(SH8->H8_DTFIM),Space(8))+" "+IIF(lSH8,SH8->H8_HRFIM,Space(5))+" "+" TERMINO REAL : ____/ ____/____ ___:___"
Li:=Li+1
@Li ,   0 PSAY "Quantidade :"
@Li  , 13 PSAY IIF(lSH8,SH8->H8_QUANT,SC2->C2_QUANT-SC2->C2_QUJE-SC2->C2_PERDA) PICTURE PesqPictQt("H8_QUANT",12)
@Li ,  26 PSAY "Quantidade Produzida :               Perdas :"
Li:=Li+1
@Li ,   0 PSAY REPLICATE("-",132)
Li:=Li+1

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ RotOper  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Imprime Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ RotOper()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> Function cRotOper
Static Function cRotOper()

cCabec1 := SM0->M0_NOME+"              ROTEIRO DE OPERACOES             NRO :"
cCabec2 := "RECURSO                       FERRAMENTA               OPERACAO"

Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1
@Li  ,  0 PSAY cCabec1
@Li  , 69 PSAY SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1
@Li  ,  0 PSAY "Produto: "+aArray[1][1]
ImpDescr(aArray[1][2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime a quantidade original quando a quantidade da    ³
//³ Op for diferente da quantidade ja entregue              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SC2->C2_QUJE + SC2->C2_PERDA > 0
	@Li  ,  0 PSAY "Qtde Prod.:"
	@Li  , 11 PSAY SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA   PICTURE PesqPictQt("C2_QUANT",12)
	@Li  , 24 PSAY "Qtde Orig.:"
	@Li  , 35 PSAY SC2->C2_QUANT                  PICTURE PesqPictQt("C2_QUANT",12)
Else
	@Li  ,  0 PSAY "Quantidade :"
	@Li  , 15 PSAY SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA   PICTURE PesqPictQt("C2_QUANT",12)
Endif

Li:=Li+1
@Li  ,  0 PSAY "C.Custo: "+SC2->C2_CC
Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1
@Li  ,  0 PSAY cCabec2
Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1

Return Li

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ Verilim  ³ Autor ³ Paulo Boschetti       ³ Data ³ 18/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ Verilim()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

Static Function Verilim()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a possibilidade de impressao da proxima operacao alocada na ³
//³ mesma folha.                                                         ³
//³ 7 linhas por operacao => (total da folha) 66 - 7 = 59                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Li > 59                                              // Li > 55
	Li := 0
	cRotOper(0)                                     // Imprime cabecalho roteiro de operacoes
Endif

Return Li

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BARCODE  ³ Autor ³ Ricardo Dutra          ³ Data ³ 16/08/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para imprimir codigo de barras                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CodBar(ExpC1)                                                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 16/09/02 ==> #define ESC     27

// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> Function BarCode   //(cCodigo) static
Static Function BarCode   //(cCodigo) static()

nLargura := 40    // largura de impressao do codigo
i        :=""
j        :=""
l        :=""
k        :=""
nCarac   :=0
cTexto   :=""
cEsc     :=""
cCode    :=""
nLimite  :=0
nImp     :=0
nBorda   :=0
nLin     :=0
aV0      := { Replicate(Chr(0),7), Chr(0) + Chr(0) + Chr(0) }
aV1      := { Replicate(Chr(127),6), Chr(127) + Chr(127) }
aImp [50]:=""
nLin     := 0                                                       // imprime codigo comeco formulario
cEsc     := Chr(ESC)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     Reseta a impressora na posicao atual - comeco formulario           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSAY cEsc + "@"                           // reseta a impressora nesta posicao

cTexto := cCodigo
cTexto := "*" + cTexto + "*"            // caracteres de inicio e fim

nImp := 1
aImp [nImp] := ""
nLimite := Len(cTexto)

FOR i := 1 TO nLimite
	nCarac := Asc (Substr (cTexto, i, 1))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atribui um codigo a cada caracter                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IF nCarac == 42                                 // *
		cCode := "2122121222"
	ELSEIF nCarac == 32                             // branco
		cCode := "2112221222"
	ELSEIF nCarac == 48                             // 0
		cCode := "2221121222"
	ELSEIF nCarac == 49                             // 1
		cCode := "1221222212"
	ELSEIF nCarac == 50                             // 2
		cCode := "2211222212"
	ELSEIF nCarac == 51                             // 3
		cCode := "1211222222"
	ELSEIF nCarac == 52                             // 4
		cCode := "2221122212"
	ELSEIF nCarac == 53                             // 5
		cCode := "1221122222"
	ELSEIF nCarac == 54                             // 6
		cCode := "2211122222"
	ELSEIF nCarac == 55                             // 7
		cCode := "2221221212"
	ELSEIF nCarac == 56                             // 8
		cCode := "1221221222"
	ELSEIF nCarac == 57                             // 9
		cCode := "2211221222"
	ELSEIF nCarac == 65                             // A
		cCode := "1222212212"
	ELSEIF nCarac == 66                             // B
		cCode := "2212212212"
	ELSEIF nCarac == 67                             // C
		cCode := "1212212222"
	ELSEIF nCarac == 68                             // D
		cCode := "2222112212"
	ELSEIF nCarac == 69                             // E
		cCode := "1222112222"
	ELSEIF nCarac == 70                             // F
		cCode := "2212112222"
	ELSEIF nCarac == 71                             // G
		cCode := "2222211212"
	ELSEIF nCarac == 72                             // H
		cCode := "1222211222"
	ELSEIF nCarac == 73                             // I
		cCode := "2212211222"
	ELSEIF nCarac == 74                             // J
		cCode := "2222111222"
	ELSEIF nCarac == 75                             // K
		cCode := "1222222112"
	ELSEIF nCarac == 76                             // L
		cCode := "2212222112"
	ELSEIF nCarac == 77                             // M
		cCode := "1212222122"
	ELSEIF nCarac == 78                             // N
		cCode := "2222122112"
	ELSEIF nCarac == 79                             // O
		cCode := "1222122122"
	ELSEIF nCarac == 80                             // P
		cCode := "2212122122"
	ELSEIF nCarac == 81                             // Q
		cCode := "2222221112"
	ELSEIF nCarac == 82                             // R
		cCode := "1222221122"
	ELSEIF nCarac == 83                             // S
		cCode := "2212221122"
	ELSEIF nCarac == 84                             // T
		cCode := "2222121122"
	ELSEIF nCarac == 85                             // U
		cCode := "1122222212"
	ELSEIF nCarac == 86                             // V
		cCode := "2112222212"
	ELSEIF nCarac == 87                             // W
		cCode := "1112222222"
	ELSEIF nCarac == 88                             // X
		cCode := "2122122212"
	ELSEIF nCarac == 89                             // Y
		cCode := "1122122222"
	ELSEIF nCarac == 90                             // Z
		cCode := "2112122222"
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona barras ou espacos ao array de impressao, sendo :     
	//³ - barra grossa  = 6 * Chr(127)                                
	//³ - barra fina    = 2 * Chr(127)                                
	//³ - espaco grosso = 7 * Chr(0)                                  
	//³ - espaco fino   = 3 * Chr(0)                                  
	//³                                                                                                                               ³
	//³ As barras e espacos sao alocados de acordo com os caracteres  
	//³ de cCode, tomados 2 a 2, sendo que o primeiro designa as bar- 
	//³ ras e o segundo, os espacos.                                  
	//³ Se o caracter for 1 => barra/espaco grosso                    
	//³ Se o caracter for 2 => barra/espaco fino                                     
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FOR j := 1 to 9 STEP 2
		aImp[nImp] := aImp[nImp] + aV1 [val(substr(cCode,j,1))] + ;
			      aV0 [val(substr(cCode,j + 1,1))]
	NEXT
	
	l := len(aImp[nImp])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se tamanho do string atual de impressao for maior que 120,           
	//³ copia o que ultrapassou para o proximo string                        
	//³Limita o string atual para 120 + caracteres de controle de imp grafica
	//³Incrementa contador de strings                                                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF l > 120
		aImp[nImp+1] := Right(aImp[nImp],l -120)
		aImp[nImp] := cEsc + "L" + Chr(120) + Chr(0) + Left(aImp[nImp],120)
		nImp:=nImp+1
	ENDIF
NEXT

j := Len(aImp[nImp])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Borda esquerda da etiqueta para centrar o codigo   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nBorda := (nLargura - (j + (nImp - 1) * 120 ) / Len(cTexto)) / 2

IF nBorda < 0
	return -2               // Codigo muito grande p/largura especificada
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acrescenta caracteres de controle grafico ao ultimo string   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aImp[nImp] := cEsc + "L" + Chr(j)+Chr(0) + aImp[nImp] + cEsc + "3" + Chr(1)

FOR l := 1 to 4                                 // imprime quatro linhas
	FOR k := 1 to 3                         // imprime tres vezes
		FOR i := 1 to nImp              // contador de strings
			@ nLin,nBorda+(i-1)*10 PSAY aImp[i]
		NEXT
		nLin:=nLin+1
	NEXT
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³     Seta tamanho de linha para posicionar para a proxima         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ nLin,1 PSAY cEsc + "3" + Chr(18)
	nLin:=nLin+1
NEXT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     Seta tamanho de linha p/ posicionar cursor proxima coluna de texto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ nLin,1 PSAY  cEsc + "3" + Chr(24)
nLin:=nLin+1

@ nLin,1 PSAY cEsc + "2"                        // cancela espacamentos de linha progrados

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³     Imprime o numero da OP expandido e centralizado, embaixo do codigo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumOp := Replicate(" ",3) + cTexto             // para centralizar
@ nLin,nBorda PSAY Chr(14) + cNumOp         // imprime expandido
nLin:=nLin+1
@ nLin,0 PSAY Chr(20)                                   // volta ao normal

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpDescr ³ Autor ³ Marcos Bregantim      ³ Data ³ 31.08.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir descricao do Produto.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpDescr//(cDescri) static()

For nBegin := 1 To Len(Alltrim(cDescri)) Step 50
	@li,025 PSAY Substr(cDescri,nBegin,50)
	li:=li+1
Next nBegin

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R820Medidas³ Autor ³ Jose Lucas           ³ Data ³ 25.01.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o registros referentes as medidas do Pedido Filho. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R820Medidas(Void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> Function R820Medidas
Static Function R820Medidas()
aArrayPro   := {}
lImpItem    := .T.
nCntArray   := 0
a01         := ""
a02         := ""
nX          :=0
nI          :=0
nL          :=0
nY          :=0
cNum        :=""
cItem       :=""
lImpCab     := .T.
nBegin      :=0
cProduto    :=""
cDesc       :=""
cDescri     :=""
cDescri1    :=""
cDescri2    :=""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Relacao de Medidas do cliente quando OP for gerada ³
//³ por pedidos de vendas.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial()+SC2->C2_NUM)
If Found()
	cNum := SC2->C2_NUM
	cItem := SC2->C2_ITEM
	cProduto := SC2->C2_PRODUTO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir somente se houver Observacoes.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !Empty(SC5->C5_OBSERVA)
		IF li > 53
			@ 03,001 PSAY "HUNTER DOUGLAS DO BRASIL LTDA"
			@ 05,008 PSAY "CONFIRMACAO DE PEDIDOS  -  "+IIF( SC5->C5_VENDA=="01","ASSESSORIA","DISTRIBUICAO")
			@ 05,055 PSAY "No. RMP    : "+SC5->C5_NUM+"-"+SC5->C5_VENDA
			@ 06,055 PSAY "DATA IMPRES: "+DTOC(dDataBase)
			li := 07
		EndIF
		li:=li+1
		@ li,001 PSAY "--------------------------------------------------------------------------------"
		li:=li+1
		cDescri := SC5->C5_OBSERVA
		@ li,001 PSAY " OBSERVACAO: "
		@ li,018 PSAY SubStr(cDescri,1,60)
		For nBegin := 61 To Len(Trim(cDescri)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		li:=li+1
		cDescri1 := SC5->C5_OBSERV1
		@ li,018 PSAY SubStr(cDescri1,1,60)
		For nBegin := 61 To Len(Trim(cDescri1)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri1,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		Li:=Li+1
		cDescri2 := SC5->C5_OBSERV2
		@ li,018 PSAY SubStr(cDescri2,1,60)
		For nBegin := 61 To Len(Trim(cDescri2)) Step 60
			li:=li+1
			cDesc:=Substr(cDescri2,nBegin,60)
			@ li,018 PSAY cDesc
		Next nBegin
		li:=li+1
		@ li,001 PSAY "--------------------------------------------------------------------------------"
		li:=li+1
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carregar as medidas em array para impressao.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SMX")
	dbSetOrder(2)
	dbSeek(xFilial()+cNum+cProduto)
	While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
		IF M6_ITEM == cItem
			AADD(aArrayPro,M6_ITEM+" - "+M6_PRODUTO)
			nCntArray:=nCntArray+1
			cCnt := StrZero(nCntArray,2)
			aArray&cCnt := {}
			While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+cProduto
				If M6_ITEM == cItem
					AADD(aArray&cCnt,{ Str(M6_QUANT,9,2)," PECAS COM ",M6_COMPTO})
				EndIf
				dbSkip()
			End
		Else
			dbSkip()
		EndIF
	End
	cCnt := StrZero(nCntArray+1,2)
	aArray&cCnt := {}
	
	For nX := 1 TO Len(aArrayPro)
		If li > 58
			R820CabMed()
		EndIF
		@ li,009 PSAY aArrayPro[nx]
		Li:=Li+1
		Li:=Li+1
		dbSelectArea("SMX")
		dbSetOrder(2)
		dbSeek( xFilial()+cNum+Subs(aArrayPro[nX],06,15) )
		While !Eof() .And. M6_FILIAL+M6_NRREL+M6_PRODUTO == xFilial()+cNum+Subs(aArrayPro[nX],06,15)
			If li > 58
				R820CabMed()
			EndIF
			IF M6_ITEM == Subs(aArrayPro[nX],1,2)
				@ li,002 PSAY M6_QUANT
				@ li,013 PSAY "PECAS COM"
				@ li,023 PSAY M6_COMPTO
				@ li,035 PSAY M6_OBS
				li:=li+1
			EndIF
			dbSkip()
		End
		li:=li+1
	Next nX
	@ li,001 PSAY "--------------------------------------------------------------------------------"
EndIf
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> __Return( Nil)
Return( Nil)        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R820CabMed ³ Autor ³ Jose Lucas           ³ Data ³ 25.01.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho referentes as medidas do Pedido Filho. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R820CabMed(Void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> Function R820CabMed
Static Function R820CabMed()

cCabec1 := SM0->M0_NOME+"               RELACAO DE MEDIDAS             NRO :"
cCabec2 := "MAQUINA                       FERRAMENTA               OPERACAO"

Li := 0

Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1
@Li  ,  0 PSAY cCabec1
@Li  , 69 PSAY SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Li:=Li+1
@Li  ,  0 PSAY REPLICATE("*",132)
Li:=Li+1
Li:=Li+1
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> __Return(Nil)
Return(Nil)        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

*---------------------------------------------------------------------------*
// Substituido pelo assistente de conversao do AP6 IDE em 16/09/02 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
    aRegs := {}
    aadd(aRegs,{cPerg,'01','Da OP                ? ','','','mv_ch1','C',11, 0, 0,'G', '', 'mv_par01','            ','','','','','               ','','','','','               ','','','','','','','','','','','','','','SC2'})
    aadd(aRegs,{cPerg,'02','Ate a OP             ? ','','','mv_ch2','C',11, 0, 0,'G', '', 'mv_par02','            ','','','','','               ','','','','','               ','','','','','','','','','','','','','','SC2'})
    aadd(aRegs,{cPerg,'03','Da Data              ? ','','','mv_ch3','D',08, 0, 0,'G', '', 'mv_par03','            ','','','','','               ','','','','','               ','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate a Data           ? ','','','mv_ch4','D',08, 0, 0,'G', '', 'mv_par04','            ','','','','','               ','','','','','               ','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Roteiro de Operacoes ? ','','','mv_ch5','N',01, 0, 2,'C', '', 'mv_par05','Sim         ','','','','','Nao            ','','','','','               ','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Imprime Cod.Barras   ? ','','','mv_ch6','N',01, 0, 1,'C', '', 'mv_par06','Sim         ','','','','','Nao            ','','','','','               ','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Descricao Produto    ? ','','','mv_ch7','N',01, 0, 2,'C', '', 'mv_par07','Descr.Cient.','','','','','Descr.Generica ','','','','','Pedido de Venda','','','','','','','',''})
    aadd(aRegs,{cPerg,'08','Imprime OP Encerrada ? ','','','mv_ch8','N',01, 0, 1,'C', '', 'mv_par08','Sim         ','','','','','Nao            ','','','','','               ','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Impr. por Ordem de   ? ','','','mv_ch9','N',01, 0, 2,'C', '', 'mv_par09','Codigo      ','','','','','Sequencia      ','','','','','               ','','','','','','','',''})
    aadd(aRegs,{cPerg,'10','Considera OPs        ? ','','','mv_chA','N',01, 0, 1,'C', '', 'mv_par10','Firmes      ','','','','','Previstas      ','','','','','Ambas          ','','','','','','','',''})

    For i:=1 to len(aRegs)
        Dbseek(cPerg+strzero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
	    For j:=1 to len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 16/09/02

Static Function CalcSem(_data)	      // incluido pelo assistente de conversao do AP6 IDE em 03/09/02

cRefer := "01/01/" + AllTrim( Str( Year( _data ), 4 ) )
dRefer := CToD( cRefer )
nAcres := Dow( dRefer ) - 1
nSem   := ( _data - dRefer ) + nAcres
nSem   := nSem / 7
nSem   := if( Subst( Str( nSem, 12, 2 ), 11, 2 )=="00", Int(nSem), Int(nSem)+1 )

Return( nSem )
