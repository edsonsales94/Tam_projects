#INCLUDE "MATR300.CH"
#INCLUDE "PROTHEUS.CH"


/*______________________________________________________________________________
¦ Programa  ¦ PLESTR04   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 14/02/2008 ¦
+-----------+------------+-------+--------------------------+------+------------+
¦ Descriçäo ¦ Relação de movimentações internas									¦
+-------------------------------------------------------------------------------+
¦ Utilizada a rotina MATR300 para efetuar as alterações necessárias				¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/				
User Function PLESTR04()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis tipo Local padrao de todos os relatorios           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL Tamanho  := "G"
	LOCAL titulo   := "Relacao das Movimentacoes Internas"
	LOCAL cDesc1   := "Lista  as  movimentacoes  internas  da empresa  ,ou seja ,Requisicoes ,"
	LOCAL cDesc2   := "Devolucoes ,Producoes e Estornos de Producao."
	LOCAL cDesc3   := ""
	LOCAL cString  := "SD3"
	LOCAL nTipo    := 0
	LOCAL aOrd     := {OemToAnsi(" Codigo Produto "),OemToAnsi(" Ordem Producao "),OemToAnsi(" Classificacao  "),OemToAnsi(" Tipo Produto   "),OemToAnsi(" Grupo Produto  "),OemToAnsi(" Centro Custo   "),OemToAnsi(" Conta Contabil "),OemToAnsi(" Nr. Documento  ")}
	LOCAL wnrel := "PLESTR04"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis privadas ,padrao de todos os relatorios            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
	PRIVATE nLastKey := 0 ,cPerg := padr("MTR300",Len(SX1->X1_GRUPO))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSX1()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01     // Produto inicial                              ³
	//³ mv_par02     // Produto final                                ³
	//³ mv_par03     // Ordem de producao inicial                    ³
	//³ mv_par04     // Ordem de producao final                      ³
	//³ mv_par05     // classificacao do movimento inicial           ³
	//³ mv_par06     // classificacao do movimento final             ³
	//³ mv_par07     // tipo do produto inicial                      ³
	//³ mv_par08     // tipo do produto final                        ³
	//³ mv_par09     // grupo do produto inicial                     ³
	//³ mv_par10     // grupo do produto final                       ³
	//³ mv_par11     // centro de custo do produto inicial           ³
	//³ mv_par12     // centro de custo do produto final             ³
	//³ mv_par13     // conta contabil do produto inicial            ³
	//³ mv_par14     // conta contabil do produto final              ³
	//³ mv_par15     // moeda selecionada ( 1 a 5 )                  ³
	//³ mv_par16     // Data inicial                                 ³
	//³ mv_par17     // Data final                                   ³
	//³ mv_par18     // 1 - Analitico , 2 - Sintetico                ³
	//³ mv_par19     // De  Local                                    ³
	//³ mv_par20     // Ate Local                                    ³
	//³ mv_par21     // De  Documento                                ³
	//³ mv_par22     // Ate Documento                                ³
	//³ mv_par23     // De  Lote                                     ³
	//³ mv_par24     // Ate Lote                                     ³
	//³ mv_par25     // De  SubLote                                  ³
	//³ mv_par26     // Ate SubLote                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)

	If nLastKey = 27
		dbClearFilter()
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		dbClearFilter()
		Return
	Endif

	RptStatus({|lEnd| C300Imp(aOrd,@lEnd,wnRel,cString,tamanho,titulo)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C300IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 12.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR300                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C300Imp(aOrd,lEnd,WnRel,cString,tamanho,titulo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis locais especificas deste relatorio                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL cRodaTxt 	:= STR0014		//"MOVIMENTO(S)"
	LOCAL nCntImpr 	:= 0
	LOCAL nProdEnt,nProdSai,nProdVal,nQuebraEnt,nQuebraSai,nQuebraVal,nGeralEnt,nGeralSai,nGeralVal,nQSegEnt,nQSegSai,nGSegEnt,nGSegSai
	LOCAL cCampoCus  ,lPassou1  ,nCntProd   ,cCompCampo ,lImprime  ,cCodAnt
	LOCAL nCusto ,nCM, cDet := ''
	LOCAL nIndex ,cSeek  
	Local aEntCt    := { "CT1", "CTT" }
	Local cEntCpo 	:= If(aReturn[8]==6,"CTT->CTT_CUSTO + '-' + CTT->CTT_DESC" + StrZero(mv_par15, 2),"CT1->CT1_DESC" + StrZero(mv_par15, 2))
	Local lDescArm := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis privadas especificas deste relatorio               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE cCondicao ,cCondSec ,cNomArq ,lContinua

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contadores de linha e pagina                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE li := 80 ,m_pag := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve comprimir ou nao                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTipo  := IIF(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona a ordem escolhida ao titulo do relatorio          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Type("NewHead")#"U"
		NewHead += STR0040+AllTrim(aOrd[aReturn[8]])+STR0041+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par15))))+")" //" (Por "###" ,em "
	Else
		Titulo  += STR0040+AllTrim(aOrd[aReturn[8]])+STR0041+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par15))))+")" //" (Por "###" ,em "
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o cabecalho do relatorio                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//"ALMOXARIFADO                    QUANTIDADE                            CUSTO                 CUSTO    TIPO DE     TIPO    ORDEM DE IT SEQ    CENTRO              CONTA           DOCUMENTO       EMISSAO      NOME DO"
	//"                      ENTRADA                   SAIDA              UNITARIO                 TOTAL    MOVIMENTO   RE/DE   PRODUCAO           CUSTO              CONTABIL                                      USUARIO"
	// XX            99,999,999,999.99       99,999,999,999.99         99,999,999,999.99     99,999,999,999.99       123        123     123456   12 123    123456789    123456789012345   123456        12/12/12    XXXXXXXXXXXXXXX
	// 0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Cabec1 := STR0015+If(mv_par18==1, STR0038, "")
	Cabec2 := STR0016+If(mv_par18==1, STR0039, "")

	dbSelectArea("SD3")

	cFiltro := "D3_FILIAL=='"+xFilial()+"'.And."
	cFiltro += "D3_COD>='"+mv_par01+"'.And.D3_COD<='"+mv_par02+"'.And."
	cFiltro += "D3_LOCAL>='"+mv_par19+"'.And.D3_LOCAL<='"+mv_par20+"'.And."
	cFiltro += "D3_OP>='"+mv_par03+"'.And.D3_OP<='"+mv_par04+"'.And."
	cFiltro += "D3_CF>='"+ mv_par05+"'.And.D3_CF<='"+mv_par06+"'.And."
	cFiltro += "D3_TIPO>='"+mv_par07+"'.And. D3_TIPO<='"+mv_par08+"'.And."
	cFiltro += "D3_LOTECTL>='"+mv_par23+"'.And. D3_LOTECTL<='"+mv_par24+"'.And."
	cFiltro += "D3_NUMLOTE>='"+mv_par25+"'.And. D3_NUMLOTE<='"+mv_par26+"'"

	#IFDEF TOP
	cFiltro += ".And.D3_GRUPO>='"+mv_par09+"'.And.D3_GRUPO<='"+mv_par10+"'.And."
	cFiltro += "D3_CC>='"+mv_par11+"'.And.D3_CC<='"+mv_par12+"'.And."
	cFiltro += "D3_CONTA>='"+mv_par13+"'.And.D3_CONTA<='"+mv_par14+"'.And."
	cFiltro += "DTOS(D3_EMISSAO)>='"+DTOS(mv_par16)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(mv_par17)+"'"
	#ENDIF	

	Do Case
		Case aReturn[8] == 1
		cNomArq := CriaTrab("",.F.)
		Set Order To 3
		IndRegua("SD3",cNomArq,IndexKey(),,cFiltro,STR0019) 		//"Selecionando Registros..."
		cSeek :=cFilial+mv_par01
		cCondicao  := "lContinua .And. !EOF() .And. D3_COD <= mv_par02"
		cCondSec   := "D3_COD == cVar"
		cCompCampo := "D3_COD"
		cMens      := STR0017 //"......... Total do Produto "
		Case aReturn[8] == 2
		cNomArq := CriaTrab("",.F.)
		Set Order To 1
		IndRegua("SD3",cNomArq,IndexKey(),,cFiltro,STR0019) 		//"Selecionando Registros..."
		cSeek :=cFilial+mv_par03
		cCondicao  := "lContinua .And. !EOF() .And. D3_OP <= mv_par04"
		cCondSec   := "D3_OP == cVar"
		cCompCampo := "D3_OP"
		cMens      := STR0018 //"......... Total da Ordem de Producao "
		Case aReturn[8] == 3
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CF+D3_COD+D3_LOCAL",,cFiltro,STR0019)			//"Selecionando Registros..."
		cSeek :=cFilial+mv_par05
		cCondicao  := "lContinua .And. !EOF() .And. D3_CF <= mv_par06"
		cCondSec   := "D3_CF == cVar"
		cCompCampo := "D3_CF"
		cMens      := STR0020 //"......... Total da Classificacao "
		Case aReturn[8] == 4
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_TIPO+D3_COD+D3_LOCAL",,cFiltro,STR0019)		//"Selecionando Registros..."
		cSeek := cFilial+mv_par07
		cCondicao  := "lContinua .And. !EOF() .And. D3_TIPO <= mv_par08"
		cCondSec   := "D3_TIPO == cVar"
		cCompCampo := "D3_TIPO"
		cMens      := STR0021 //"......... Total do Tipo "
		Case aReturn[8] == 5
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_GRUPO+D3_COD+D3_LOCAL",,cFiltro,STR0019)		//"Selecionando Registros..."
		cSeek := cFilial+mv_par09
		cCondicao  := "lContinua .And. !EOF() .And. D3_GRUPO <= mv_par10"
		cCondSec   := "D3_GRUPO == cVar"
		cCompCampo := "D3_GRUPO"
		cMens      := STR0022 //"......... Total do Grupo "
		Case aReturn[8] == 6
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CC+D3_COD+D3_LOCAL",,cFiltro,STR0019)			//"Selecionando Registros..."
		cSeek :=cFilial+mv_par11
		cCondicao  := "lContinua .And. !EOF() .And. D3_CC <= mv_par12"
		cCondSec   := "D3_CC == cVar"
		cCompCampo := "D3_CC"
		cMens      := STR0023 //"......... Total do Centro de Custo"
		Case aReturn[8] == 7
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,"D3_FILIAL+D3_CONTA+D3_COD+D3_LOCAL",,cFiltro,STR0019)		//"Selecionando Registros..."
		cSeek :=cFilial+mv_par13
		cCondicao  := "lContinua .And. !EOF() .And. D3_CONTA <= mv_par14"
		cCondSec   := "D3_CONTA == cVar"
		cCompCampo := "D3_CONTA"
		cMens      := STR0024 //"......... Total da Conta"
		Case aReturn[8] == 8
		Set Order To 2
		cNomArq := CriaTrab("",.F.)
		IndRegua("SD3",cNomArq,IndexKey(),,cFiltro,STR0019)		//"Selecionando Registros..."
		cSeek :=cFilial
		cCondicao  := "lContinua .And. !EOF() "
		cCondSec   := "D3_DOC == cVar"
		cCompCampo := "D3_DOC"
		cMens      := STR0025 //"......... Total do Documento "
	EndCase

	nIndex := RetIndex("SD3")
	#IFNDEF TOP
	dbSetIndex(cNomArq+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	SetRegua(RecCount())		// Total de Elementos da regua

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o campo a ser impresso no valor de acordo com a moeda selecionada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCampoCus := "SD3->D3_CUSTO"+Str(mv_par15,1)

	Store 0 To nGeralEnt,nGeralSai,nGeralVal,nGSegEnt,nGSegSai
	lContinua := .T.
	dbSeek(cSeek,.T.)
	While &(cCondicao) .and. cFilial == D3_FILIAL

		cVar := &(cCompCampo)

		Store 0 To nQuebraEnt,nQuebraSai,nQuebraVal,nQSegEnt,nQSegSai
		lPassou1 := .F.

		If UPPER(D3_DOC) < UPPER(mv_par21) .Or. UPPER(D3_DOC) > UPPER(mv_par22)
			dbSkip()
			Loop
		EndIf

		While &cCondicao .And. &cCondSec .and. cFilial == D3_FILIAL

			cCodAnt := D3_COD
			Store 0 To nProdEnt,nProdSai,nProdVal,nProdSegEnt,nProdSegSai
			nCntProd := 0
			lImprime := .T.
			While &(cCondicao) .And. &(cCondSec) .And. D3_COD == cCodAnt .and. cFilial == D3_FILIAL

				If lEnd
					@ PROW()+1,001 PSay STR0026		//"CANCELADO PELO OPERADOR"
					lContinua := .F.
					Exit
				EndIf

				IncRegua()

				#IFNDEF TOP
				If D3_GRUPO < mv_par09 .Or. D3_GRUPO > mv_par10
					dbSkip()
					Loop
				EndIf

				If D3_CC < mv_par11 .Or. D3_CC > mv_par12
					dbSkip()
					Loop
				EndIf

				If D3_CONTA < mv_par13 .Or. D3_CONTA > mv_par14
					dbSkip()
					Loop
				EndIF

				If D3_EMISSAO < mv_par16 .Or. D3_EMISSAO > mv_par17
					dbSkip()
					Loop
				EndIf
				#ENDIF	

				If !D3Valido()
					dbSkip()
					Loop
				EndIf

				If !Empty(aReturn[7]) .And. ! &(aReturn[7])
					dbSkip()
					Loop
				Endif

				If li > 58
					Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
					lImprime := .T.
				EndIf

				If lImprime
					dbSelectArea("SB1")
					dbSeek(cFilial+SD3->D3_COD)
					If mv_par27 == 1
						lDescArm := SB2->(MsSeek(xFilial("SB2")+SD3->D3_COD+SD3->D3_LOCAL)) .And. !Empty(SB2->B2_LOCALIZ)
					Endif
					@ li,000 PSay STR0027+B1_COD+STR0028+SubStr(B1_DESC,1,30)+"   Cor : "+B1_COR+STR0029+B1_TIPO+STR0030+SD3->D3_GRUPO+STR0031+B1_UM+IIF(lDescArm,STR0042+SD3->D3_LOCAL+" - "+SB2->B2_LOCALIZ,"")	//"Codigo : "###"   Descricao : "###"   Tipo : "###"   Grupo : "###"   UM : "##"   Armazem : "###############"
					IF mv_par18 == 1
						li += 2
					Endif
					dbSelectArea("SD3")
					lImprime := .F.
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adiciona 1 ao contador de registros impressos         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nCntImpr++
				nCusto := &(cCampoCus)
				nCM    := nCusto / Iif(D3_QUANT == 0,1,D3_QUANT)
				IF mv_par18 == 1
					@ Li,000 PSay D3_LOCAL
					If D3_TM <= "500"
						@ Li,013 PSay D3_QUANT Picture PesqPictQt("D3_QUANT",17)
					Else
						@ Li,037 PSay D3_QUANT Picture PesqPictQt("D3_QUANT",17)
					EndIf
					@ Li,053 PSay nCm			Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
					@ Li,075 PSay nCusto		Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
					@ Li,099 PSay D3_TM
					@ Li,109 PSay D3_CF
					@ Li,116 PSay SubStr(D3_OP,1,6)  Picture "@!"
					@ Li,125 PSay SubStr(D3_OP,7,2)  Picture "@!"
					@ Li,128 PSay SubStr(D3_OP,9,3)  Picture "@!"
					@ Li,135 PSay D3_NUMSEQ
					@ Li,142 PSay D3_CC
					@ Li,163 PSay D3_CONTA
					@ Li,185 PSay D3_DOC
					@ Li,196 PSay D3_EMISSAO
					@ Li,210 PSay D3_USUARIO
					Li++
				Endif
				lPassou1 := .T.

				If D3_TM <= "500"
					nProdEnt  += D3_QUANT
					nProdVal  += nCusto
				Else
					nProdSai  += D3_QUANT
					nProdVal  -= nCusto
				EndIf
				nCntProd++
				dbSkip()
			EndDo

			If aReturn[8] != 1
				IF nCntProd > 1 .or. (mv_par18 == 2 .and. nCntProd > 0)
					Li++
					If mv_par18 == 1
						@ Li,000 PSay STR0032 	//"TOT"
					Endif
					@ Li,013 PSay nProdEnt Picture PesqPictQt("D3_QUANT",17)
					@ Li,037 PSay nProdSai Picture PesqPictQt("D3_QUANT",17)
					@ Li,075 PSay nProdVal Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
					@ Li,099 PSay STR0033+SB1->B1_SEGUM+STR0034		//"Quantidade na Seg. UM ("###"): Entrada -> "
					nProdSegEnt :=ConvUm(SB1->B1_COD,nProdEnt,0,2)
					@ Li,138 PSay nProdSegEnt Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
					@ Li,159 PSay STR0035	//"Saida -> "
					nProdSegSai :=ConvUm(SB1->B1_COD,nProdSai,0,2)
					@ Li,168 PSay nProdSegSai Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
					Li++
					IF mv_par18 == 1
						@ Li,000 PSay __PrtThinLine()
						Li++
					Endif
				Endif
			ElseIf nCntProd == 1 .And. aReturn[8] != 1 .and. mv_par18 == 1
				@ Li,000 PSay __PrtThinLine()
				Li++
			EndIf

			nQuebraEnt += nProdEnt
			nQuebraSai += nProdSai
			nQuebraVal += nProdVal
			nQSegEnt   += nProdSegEnt
			nQSegSai   += nProdSegSai

		EndDo

		If lPassou1
			If aReturn[8] == 1
				Li++
				@ Li,000 PSay  STR0032		//"TOT"
				@ Li,013 PSay nQuebraEnt Picture PesqPictQt("D3_QUANT",17)
				@ Li,037 PSay nQuebraSai Picture PesqPictQt("D3_QUANT",17)
				@ Li,075 PSay nQuebraVal Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
				@ Li,099 PSay STR0033+SB1->B1_SEGUM+STR0034		//"Quantidade na Seg. UM ("###"): Entrada -> "
				nQSegEnt := ConvUm(SB1->B1_COD,nQuebraEnt,0,2)
				@ Li,138 PSay nQSegEnt	Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
				@ Li,159 PSay STR0035	//"Saida -> "
				nQSegSai := ConvUm(SB1->B1_COD,nQuebraSai,0,2)
				@ Li,168 PSay nQSegSai	Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
				Li++
				@ Li,000 PSay __PrtThinLine()
				Li++
			Else
				@ Li,013 PSay nQuebraEnt Picture PesqPictQt("D3_QUANT",17)
				@ Li,037 PSay nQuebraSai Picture PesqPictQt("D3_QUANT",17)
				@ Li,075 PSay nQuebraVal Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)

				cDet := ''
				If aReturn[8] == 6 .Or. aReturn[8] == 7
					If aReturn[8]==6 .And. (aEntCt[2])->(dbSeek(xFilial(aEntCt[2])+cVar,.F.)) .Or. ;
					aReturn[8]==7 .And. (aEntCt[1])->(dbSeek(xFilial(aEntCt[1])+cVar,.F.))
						cDet := &(cEntCpo)
					ElseIf !Empty(cVar)
						cDet := STR0037 // ' ** CC nao cadastrado ** '
					EndIf
				EndIf

				@ Li,099 PSay cMens + cDet
				Li++

				@ Li,000 PSay __PrtThinLine()
				Li += 2

				dbSelectArea("SD3")
			EndIf
		EndIf

		nGeralEnt += nQuebraEnt
		nGeralSai += nQuebraSai
		nGeralVal += nQuebraVal
		nGSegEnt  += nQSegEnt
		nGSegSai  += nQSegSai

	EndDo

	If nCntImpr > 0
		If li > 58
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		@ Li,013 PSay nGeralEnt Picture PesqPictQt("D3_QUANT",17)
		@ Li,037 PSay nGeralSai Picture PesqPictQt("D3_QUANT",17)
		@ Li,075 PSay nGeralVal Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
		@ Li,099 PSay STR0036		//"......... TOTAL GERAL"
		@ Li,138 PSay nGSegEnt Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)
		@ Li,168 PSay nGSegSai Picture PesqPict("SD3", "D3_CUSTO"+Str(mv_par15,1),17)	
		Roda(nCntImpr,cRodaTxt,Tamanho)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve as ordens originais do arquivo                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex("SD3")
	dbClearFilter()
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga indice de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Ferase(cNomArq+OrdBagExt())

	If aReturn[5] = 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Marcos V. Ferreira    ³ Data ³30.03.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
	Local aArea := GetArea()
	Local aHelpPor :={} 
	Local aHelpEng :={} 
	Local aHelpSpa :={} 

	//Correcao de Ortografia do MV_PAR18
	If SX1->(DbSeek ("MTR30018"))
		RecLock("SX1",.F.)
		Replace SX1->X1_DEF01   With "Analitico"
		Replace SX1->X1_DEFSPA2 With "Analitico"
		Replace SX1->X1_DEF02   With "Sintetico"
		Replace SX1->X1_DEFSPA2 With "Sintetico"
		MsUnLock()
	EndIf

	u_InPutSx1('MTR300','23','De Lote                      ?','¿De Lote                     ?','From Lot                     ?', ;  
	'mv_chn','C',10,0,0,'G','','','','','mv_par23','','','','','','','','','','','','','','','','', ;                                     
	{'Lote Inicial a ser considerado na filtr ','agem da impressao do relatorio.         '}, ;                        
	{'                                        ','                                        '}, ;                        
	{'                                        ','                                        '},'')                                            //-- 36 - X1_HELP

	u_InPutSx1('MTR300','24','Ate Lote                     ?','¿A Lote                      ?','To Lot                       ?', ;  
	'mv_cho','C',10,0,0,'G','','','','','mv_par24','','','','ZZZZZZZZZZ','','','','','','','','','','','','', ;                                     
	{'Lote Final a ser considerado na filtrage','m da impressao do relatorio.            '}, ;                        
	{'                                        ','                                        '}, ;                        
	{'                                        ','                                        '},'')                                            //-- 36 - X1_HELP

	u_InPutSx1('MTR300','25','De Sub-Lote                  ?','¿De Sub-Lote                 ?','From Sub-Lot                 ?', ;  
	'mv_chp','C',6,0,0,'G','','','','','mv_par25','','','','','','','','','','','','','','','','', ;                                     
	{'Sub-Lote Inicial a ser considerado na fi','ltragem da impressao do relatorio.      '}, ;                        
	{'                                        ','                                        '}, ;                        
	{'                                        ','                                        '},'')                                            //-- 36 - X1_HELP

	u_InPutSx1('MTR300','26','Ate Sub-Lote                 ?','¿A Sub-Lote                  ?','To Sub-Lot                   ?', ;  
	'mv_chq','C',6,0,0,'G','','','','','mv_par26','','','','ZZZZZZ','','','','','','','','','','','','', ;                                     
	{'Sub-Lote Final a ser considerado na filt','ragem da impressao do relatorio.        '}, ;                        
	{'                                        ','                                        '}, ;                        
	{'                                        ','                                        '},'')                                            //-- 36 - X1_HELP

	/*-----------------------MV_PAR27--------------------------*/
	Aadd( aHelpPor, "Imprime descricao do Armazem. Sim ou Nao" )

	Aadd( aHelpEng, "Print warehouse description. Yes or No  " )

	Aadd( aHelpSpa, "Imprime descripcion del almacen. Si o No" ) 

	u_InPutSx1( "MTR300","27","Imprime descricao do Armazem ?","Imprime descripc. del almacen?","Print warehouse description ?","mv_chr",;
	"N",1,0,2,"C","","","","","mv_par27","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",;
	aHelpPor,aHelpEng,aHelpSpa)

	RestArea(aArea)
Return
