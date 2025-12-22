#Include "ctbr280.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Ctbr280A  ³ Autor ³ Rogerio Batista       ³ Data ³ 07.03.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rela‡ao de Movimentos Acumulados p/ CC Extra               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr280()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Montado para trazer os valores de movimentos mes a mes     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtbR280A()
Local Wnrel
LOCAL cString:="CT1"
LOCAL cDesc1:= OemToAnsi(STR0001)                                              //"Este programa ir  imprimir a rela‡„o de Movimentos "
LOCAL cDesc2:= OemToAnsi(STR0002)+RetTitle("CT3_CUSTO",15)+OemToAnsi(STR0010)  //"Acumulados por "###" Extra Cont bil das con-"
LOCAL cDesc3:= OemToAnsi(STR0003)                                              //"tas determinadas pelo usu rio."
LOCAL tamanho:="G"
Local titulo :=OemToAnsi(STR0006)                                              //"Relacao de Movimentos Acumulados para CC Extra - Exercicio "
Local aSetOfBook

PRIVATE aReturn := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 2, 2, 1, "",1 } //"Zebrado"###"Administracao"
PRIVATE nomeprog:="CTBR280"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="CTR280"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("CTR280",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                       ³
//³ mv_par01            // Data inicial                        ³
//³ mv_par02            // Data Final                          ³
//³ mv_par03            // do Centro do Custo                  ³
//³ mv_par04            // at‚ o Centro de Custo               ³
//³ mv_par05            // da Conta                            ³
//³ mv_par06            // at‚ a Conta                         ³
//³ mv_par07            // moeda                               ³
//³ mv_par08            // Pagina inicial                      ³
//³ mv_par09   			// Saldos? Reais / Orcados/Gerenciais  ³
//³ mv_par10            // Set of books                        ³
//³ mv_par11			// Saldos Zerados?			     	   ³
//³ mv_par12			// Filtra Segmento?					   ³
//³ mv_par13			// Conteudo Inicial Segmento?		   ³
//³ mv_par14			// Conteudo Final Segmento?		       ³
//³ mv_par15 			// Codigo da Conta (Reduzido/Normal)   ³
//³ mv_par16			// Codigo do CC (Reduzido/Normal)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="CTBR280"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par10)
	Set Filter To
	Return
EndIf
aSetOfBook := CTBSetOf(mv_par10)

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| Ct280Imp(@lEnd,wnRel,cString,Tamanho,Titulo,aSetOfBook)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡ao    ³ Ct280Imp ³ Autor ³ Claudio Donizete      ³ Data ³ 20/12/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao Relacao Movimento Mensal                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ Ct280Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd    - Acao do Codeblock                                ³±±
±±³           ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³           ³ cString - Mensagem                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ct280Imp(lEnd,WnRel,cString,Tamanho,Titulo, aSetOfBook)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt
LOCAL Cbcont
LOCAL limite := 220
Local lImpCC := .T., lImpConta := .T.
Local nDecimais := 2
Local cabec1 := OemToAnsi(STR0014)
Local cabec2 := OemToAnsi(STR0015)
Local cCtt_Custo
Local aCtbMoeda := {}
Local aPeriodos
Local aSaldos
Local cMascConta
Local cMascCus
Local cSepConta := ""
Local cSepCus   := ""
Local cPicture
Local nX
Local aTotalCC
Local nCol
Local nTotais
Local cCodRes
Local cCodResCC
Local cChave
Local nRecCC := 0
Local cAliasAnt := ""
Local lFirst	:= .T.

nDecimais 	:= DecimalCTB(aSetOfBook,mv_par07)

If Empty(aSetOfBook[2])
	cMascConta := GetMv("MV_MASCARA")
	cMascCus	  := GetMv("MV_MASCCUS")
Else
	cMascConta := RetMasCtb(aSetOfBook[2],@cSepConta)
	cMascCus   := RetMasCtb(aSetofBook[6],@cSepCus)
EndIf
cPicture 	:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := MV_PAR08

//	Se nenhuma moeda foi escolhida, sai do programa
aCtbMoeda  	:= CtbMoeda(mv_par07)
If Empty(aCtbMoeda[1])
	Help(" ",1,"NOMOEDA")
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza centro de custo inicial                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CTT")
dbSetOrder(1)
dbSeek( xFilial("CTT")+mv_par03,.T. )
SetRegua(Reccount())

// Localiza o periodo contabil para os calendarios da moeda
aPeriodos := ctbPeriodos(mv_par07, mv_par01, mv_par02, .T., .F.)
aTotalCC  := Array(Len(aPeriodos))
Titulo += aPeriodos[1][3] // Adiciona o exercicio ao titulo

For nX := 1 To Len(aPeriodos)

		Cabec1 += Padl("" + Dtoc(aPeriodos[nX][2]),11) + "   "
Next

// Processa o arquivo de centro de custos, dentro dos parametros do usuario
dbSelectArea("CTT")
dbSetOrder(1)
While !Eof() .And. CTT->CTT_FILIAL==xFilial("CTT") .And. CTT->CTT_CUSTO <= mv_par04
	IncRegua()
	// Guarda o centro de custo para ser utilizado na quebra
	cCtt_Custo 	:= CTT->CTT_CUSTO
	cCodResCC	:= CTT->CTT_RES
	lImpCC     	:= .T.
	aFill(aTotalCC,0) 			// Zera o totalizador por periodo
	
	// Localiza os saldos do centro de custo
	dbSelectArea("CT1")
	dbSetOrder(1)			 	// Filial+Custo+Conta+Moeda
	dbSeek(xFilial("CT1")+mv_par05, .T.)
		
	// Obtem os saldos do centro de custo
	While !Eof() .And. CT1->CT1_FILIAL == xFilial("CT1") .And. CT1->CT1_CONTA <= mv_par06
		
		If CT1->CT1_CLASSE = "1"		// Sintetica
			DbSkip()
			Loop
		Endif
		
		lImpConta 	:= .T.
		cCt3_Conta  := CT3->CT3_CONTA
		nCol 	  	:= 1
		aSaldos 	:= {}
			        	
		For nX := 1 To Len(aPeriodos)
			//	Obtem o saldo acumulado ate o ultimo dia do periodo
			// da moeda escolhida.
			Aadd(	aSaldos,SaldoCt3(CT1->CT1_CONTA,cCtt_Custo,aPeriodos[nX][2],;
			mv_par07,MV_PAR09))
			
			nTotais   := aSaldos[nX][1] 
																									
		Next
		
		// Se imprime saldos zerados ou se nao imprime saldos zerados e
		// o somatorio dos saldos nao for zero, imprime os saldos
		If mv_par11 == 1 .OR. (mv_par11 == 2 .AND. nTotais != 0)
			For nX := 1 To Len(aSaldos)
				IF lEnd
					@Prow()+1,0 PSAY OemToAnsi(STR0009)  //"***** CANCELADO PELO OPERADOR *****"
					Exit
				EndIf
				// quebra de linha a cada 8 periodos
				
				// Inicio da impressao
				If li+If(lImpcc .and. lImpConta,3,If(lImpCC,2,If(lImpConta,1,0))) > 57
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					li--
					If lImpcc
						Li--
					Endif
					lFirst	:= .F.
				EndIf
				
				// Imprime o Centro de Custo
				If lImpCC
					li += 2
					If mv_par18 ==1 //Imprime Cod. CC Normal
						EntidadeCtb(cCtt_Custo,li,00,15,.f.,cMascCus,cSepCus)
					Else
						// Imprime codigo reduzido
						EntidadeCtb(cCodResCC,li,00,15,.f.,cMascCus,cSepCus)
					Endif
					@ li, PCOL() + 1 PSAY CtbDescMoeda("CTT->CTT_DESC"+MV_PAR07)
					lImpCC := .F.
					li++
				Endif
				// Imprime a Conta
				If lImpConta
					cCodRes := CT1->CT1_RES
					If mv_par17 ==1 //Imprime Cod. Conta Normal
						EntidadeCTB(CT1->&("CT1_CONTA"),++li,00,10,.F.,cMascConta,cSepConta)
					Else
						EntidadeCTB(cCodRes,++li,00,20,.F.,cMascConta,cSepConta)
					Endif
					@ li, PCOL() + 1 PSAY CtbDescMoeda("CT1->CT1_DESC" + MV_PAR07)
					lImpConta := .F.
				EndIf
				// Imprime o valor

//				ValorCTB(aSaldos[nX][1],li,40+(nCol++*14),12,nDecimais,.T.,cPicture) 
										
				aTotalCC[nX] += aSaldos[nX][1]                  
				
			Next       
				@ li, PCOL() + 1 PSAY aSaldos[01][1]*-1                  picture "@E 99,999,999.99"
				@ li, PCOL() + 1 PSAY (aSaldos[02][1]-aSaldos[01][1])*-1 picture "@E 99,999,999.99"       
				@ li, PCOL() + 1 PSAY (aSaldos[03][1]-aSaldos[02][1])*-1 picture "@E 99,999,999.99"
				@ li, PCOL() + 1 PSAY (aSaldos[04][1]-aSaldos[03][1])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aSaldos[05][1]-aSaldos[04][1])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aSaldos[06][1]-aSaldos[05][1])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aSaldos[07][1]-aSaldos[06][1])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aSaldos[08][1]-aSaldos[07][1])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aSaldos[09][1]-aSaldos[08][1])*-1 picture "@E 99,999,999.99"	
 				@ li, PCOL() + 1 PSAY (aSaldos[10][1]-aSaldos[09][1])*-1 picture "@E 99,999,999.99"	
 				@ li, PCOL() + 1 PSAY (aSaldos[11][1]-aSaldos[10][1])*-1 picture "@E 99,999,999.99"	
 				@ li, PCOL() + 1 PSAY (aSaldos[12][1]-aSaldos[11][1])*-1 picture "@E 99,999,999.99"	
		Endif
		
		// Vai para a proxima conta
		dbSelectArea("CT1")
		DbSkip()
		
	EndDo
	
	If !lFirst
		// Quebrou o Centro de Custo
		If !lImpCC
			li+=2
			@ li,000 PSay OemToAnsi(STR0012)+RetTitle("CTT_CUSTO",7)+": "
			If mv_par18 == 1 //Imprime Cod. CC Normal
				EntidadeCtb(cCtt_Custo,li,PCOL(),34,.F.,cMascCus,cSepCus)
			Else
				EntidadeCtb(cCodResCC,li,PCOL(),34,.F.,cMascCus,cSepCus)
			Endif
			
			// Imprime o totalizador por periodo
			nCol := 1
//			Aeval( aTotalCC, { |e,nX| If(nX%13==0,(nCol := 1, Li++),NIL),;
//			ValorCTB(e,li,40+(nCol++*14),12,nDecimais,.T.,cPicture) } )
			
				@ li, PCOL() + 1 PSAY  aTotalCC[01]*-1               picture "@E 99,999,999.99"
				@ li, PCOL() + 1 PSAY (aTotalCC[02]-aTotalCC[01])*-1 picture "@E 99,999,999.99"       
				@ li, PCOL() + 1 PSAY (aTotalCC[03]-aTotalCC[02])*-1 picture "@E 99,999,999.99"
				@ li, PCOL() + 1 PSAY (aTotalCC[04]-aTotalCC[03])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aTotalCC[05]-aTotalCC[04])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aTotalCC[06]-aTotalCC[05])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aTotalCC[07]-aTotalCC[06])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aTotalCC[08]-aTotalCC[07])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aTotalCC[09]-aTotalCC[08])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aTotalCC[10]-aTotalCC[09])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aTotalCC[11]-aTotalCC[10])*-1 picture "@E 99,999,999.99"	
				@ li, PCOL() + 1 PSAY (aTotalCC[12]-aTotalCC[11])*-1 picture "@E 99,999,999.99"	

		EndIf
	EndIf
	dbSelectArea("CTT")
	dbSetOrder(1)
	dbSkip()
Enddo

dbsetOrder(1)
Set Filter To
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()


