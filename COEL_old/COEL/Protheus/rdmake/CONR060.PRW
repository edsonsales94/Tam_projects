#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function conr060()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,CDISCO,CABEC1")
SetPrvt("CABEC2,TITULO,CCANCEL,CTITULOR,CCABECR,CTITULOA")
SetPrvt("CCABECA1,CCABECA2,CCENTRO,CDE,CA,CTRANSP")
SetPrvt("CCONT,CTRANS,CSALDANT,CTOTCONT,CD,CC")
SetPrvt("CRELPAR,CFOLHA,CREF,CHORA,CDATA,CSIGA")
SetPrvt("CTIMEFIM,CBTXT,CBCONT,TAMANHO,LIMITE,NQUEBRA")
SetPrvt("ACAMPOS,NTOTDEB,NTOTCRD,CCONTANT,NSALDOATU,AINICIOMES")
SetPrvt("LIMPRANT,DDATAINICIAL,DDATAFINAL,LCENTRODECUSTO,NCOLCC,LIMPCC")
SetPrvt("LSALTO,NSALTO,NTAMLINHA,CINICIO,CPER17,CPER17ANT")
SetPrvt("LRESUMIDO,NDEBITODIA,NCREDITDIA,NSALDOSDIA,NPAGINICIAL,DDATALANC")
SetPrvt("BSINAL,LNAODEB,LNAOCRED,LIMP,LESTRANG,LCUSTO")
SetPrvt("CCUSTOINICIAL,CCUSTOFINAL,CMES17INI,CMES17FIM,CPERIODOINICIAL,CPERIODOATUAL")
SetPrvt("LI,M_PAG,CCONTAINICIAL,CCONTAFINAL,M_PAGFIM,CCABECA")
SetPrvt("CNOMEARQ,CDC,NVALOR,LEND,NTAMANHO,NCHAR")
SetPrvt("WCBCONT,WCBTXT,RODA_TAM,CFLAG,CCONTA,CCPAR")
SetPrvt("CCONTAREPL,CCUSTOREPL,CCODIGO,LRETORNO,NREGISTRO,CAREA")
SetPrvt("CALIAS,ADRIVER,NLIN,NLARGURA,CCTL,LARGURA")
SetPrvt("NSAL,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 02/09/02 ==>     #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Conr060  ³ Autor ³ Wagner Xavier         ³ Data ³ 26.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o do Raz„o zebrado                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Conr060(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ Rogerio Batista 11/07/02 - Impressao com centro de custo   ³±±
±±³          ³ em 80 colunas                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Rdmake   ³ Autor  ³  Luiz Carlos Vieira       ³ Data  ³ Mon  02/03/98 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

WnRel    := ""
cDesc1   := "Este programa ir  imprimir o Raz„o Contabil, de  acordo  com"
cDesc2   := "os parƒmetros solicitados pelo usu rio. Caso seja  escolhida"
cDesc3   := "a impress„o do Centro de Custo, o relat¢rio ser  comprimido."
cString  := "SI1"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "", 1 }
nomeprog := ""
aLinha   := {}
nLastKey := 0
cPerg    := ""
cDisco   := NIL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os par„metros do relat¢rio                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( cDisco == NIL )
   Pergunte ( "COR060", .F. )
   nomeprog := "CONR060"
   cPerg    := "COR060"
   wnRel    := "CONR060"
Else
   Pergunte ( "COC010", .F. )
   nomeprog := "CONC010"
   cPerg    := "COC010"
   wnRel    := "CONC010"
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas no arquivo SIGACONR.INI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1   := ""
cabec2   := ""
titulo   := "Emissao do Razao em " + GetMV("MV_MOEDA1")
cCancel  := "***** CANCELADO PELO OPERADOR *****"
cTituloR := "RAZAO  ANALITICO  (TOTAIS)  DE "
cCabecR  := "  DATA                                                                              D E B I T O    C R E D I T O        SALDO ATUAL "
cTituloA := "RAZAO  ANALITICO  DE "
cCabeca1 := "  DATA    NUMERO     H I S T O R I C O                        C/PARTIDA     "
cCabeca2 := "      D E B I T O    C R E D I T O        SALDO ATUAL "
cCentro  := "C.CUSTO"
cDe      := " de "
cA       := " A "
cTransp  := "A TRANSPORTAR : "
cCont    := "CONTA - "
cTrans   := "DE TRANSPORTE : "
cSaldant := "SALDO ANTERIOR : "
cTotCont := "T o t a i s  d a  C o n t a  ==> "
cD       := "D"
cC       := "C"
cRelPar  := "Relacao dos Parametros do Relatorio"
cFolha   := "Folha:    "
cRef     := "Emissao:"
cHora    := "*Hora...: "
cData    := "DT.Ref.:"
cSiga    := "*Microsiga - Ass. Software e Com. de Computadores Ltda "
cTimeFim := "Hora Termino: "

CbTxt          := ""
cbcont         := 0
tamanho        := " "
limite         := 132
nQuebra        := 0
aCampos        := {}
nTotDeb        := 0
nTotCrd        := 0
cContAnt       := ""
nSaldoAtu      := 0
aInicioMes     := {}
lImprAnt       := .F.
dDataInicial   := CtoD ( Space ( 08 ) )
dDataFinal     := CtoD ( Space ( 08 ) )
lCentroDeCusto := .T.
nColCC         := 0
lImpCC         :=.F.
lSalto         :=.F.
nSalto         := 0
nTamLinha      := 132
cInicio        := ""
cPer17         := ""
cPer17Ant      := ""
lResumido      := .F.
nDebitoDia     := 0
nCreditDia     := 0
nSaldosDia     := 0
nPagInicial    := 1
dDataLanc      := CTOD("")
bSinal         := { | nSaldo | Iif( nSaldo < 0 , cD, Iif( nSaldo > 0 , cC," " ) ) }
lNaoDeb        := .F.
lNaoCred       := .F.
lImp           := .F.
lEstrang       := .F.
lCusto         := .F.
cCustoInicial  := ""
cCustoFinal    := ""
cMes17Ini      := ""
cMes17Fim      := ""
cPeriodoInicial:= ""
cPeriodoAtual  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cDisco != Nil		// Para consulta nao pode alterar perguntas
	wnrel := SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,"")
Else
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"")
EndIf	

If nLastKey == 27
	Set Filter To
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao REPORTINI substituir as variaveis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Reportini("CONR060")

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
   Return
Endif

#IFDEF WINDOWS
    RptStatus({|| Cr060Imp() },titulo)  // Chamada do Relatorio// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==>     RptStatus({|| Execute(Cr060Imp) },titulo)  // Chamada do Relatorio
    Return
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==>     Function Cr060Imp
Static Function Cr060Imp()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( cDisco == NIL )
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Variaveis utilizadas para parametros ( COR060 )              ³
   //³ mv_par01            // da conta                              ³
   //³ mv_par02            // ate a conta                           ³
   //³ mv_par03            // da data                               ³
   //³ mv_par04            // Ate a data                            ³
   //³ mv_par05            // junta as contas c/mesmo centro custo  ³
   //³ mv_par06            // verifica se imprime o Centro de Custo ³
   //³ mv_par07            // Salto de pagina                       ³
   //³ mv_par08            // Pagina Inicial                        ³
   //³ mv_par09            // Pagina Final                          ³
   //³ mv_par10            // Analitico ou Resumido dia (resumo)    ³
   //³ mv_par11            // Imprime conta sem movimento?          ³
   //³ mv_par12            // Descricao Nacional ou Estrangeira?    ³
   //³ mv_par13            // Do Centro de Custo                    ³
   //³ mv_par14            // At‚ o Centro de Custo                 ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cContaInicial   := Mv_Par01
    cContaFinal     := Mv_Par02
	cCustoInicial	:= mv_par13
	cCustoFinal		:= mv_par14
    dDataInicial    := Mv_Par03
    dDataFinal      := Mv_Par04
    lCentroDeCusto  := ( Mv_Par05 == 1 )
	Tamanho	  		:= If((Mv_par06==1 .And. mv_par10=1),"G"," ")
	lImpCC	  		:= (Mv_Par06==1 .And. mv_par10=1)
	nTamLinha 		:= If((Mv_Par06==1 .And. mv_par10=1),142,nTamLinha)
	nSalto	  		:= mv_par07
    m_pag           := mv_par08
	m_pagfim  		:= mv_par09	
	lResumido 		:= If(mv_par10==2,.T.,.F.)
    lImp            := If(mv_par11==1,.t.,.f.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se descricao em outra lingua      	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lEstrang := .F.
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("I1_DESCEST")
	If X3USO(X3_USADO)
		If mv_par12 == 2
			lEstrang := .T.
		EndIf
	EndIf		
	lCusto := .F.
	dbSeek("I2_CCD")
	If X3USO(X3_USADO)
		dbSeek("I2_CCC")
		If X3USO(X3_USADO)
			lCusto := .T.
		EndIf
	EndIf		
	dbSetOrder(1)
	dbSelectArea("SI1")
Else
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Variaveis utilizadas para parametros ( COC010 )              ³
   //³ mv_par01            // do dia                                ³
   //³ mv_par02            // Ate o dia                             ³
   //³ mv_par03            // junta as contas c/mesmo centro custo  ³
   //³ mv_par04            // Pagina Inicial                        ³ 
   //³ mv_par05            // Pagina Final                          ³
   //³ mv_par06           // Descricao Nacional ou Estrangeira      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   dDataInicial   := Mv_Par01
   dDataFinal     := Mv_Par02
   lCentroDeCusto := ( Mv_Par03 == 1 )
   m_pag  		  := mv_par04
   m_pagfim		  := mv_par05
   nSalto		  := 2   	// Nao Salta Pagina	
   lImp           := .t.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se descricao em outra lingua      	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lEstrang := .F.
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("I1_DESCEST")
	If X3USO(X3_USADO)
		If mv_par06 == 2
			lEstrang := .T.
		EndIf
	EndIf		
	dbSetOrder(1)
	dbSelectArea("SI1")
End
nPagInicial       := m_pag

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se datas informadas estao corretas	                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! DataMoeda(1, @cMes17Ini, dDataInicial)
	#IFNDEF WINDOWS
		Set Device To Screen
	#ENDIF	
	Help(" ",1,"MESINVALID")
	Return
End
If ! DataMoeda(1, @cMes17Fim, dDataFinal)
	#IFNDEF WINDOWS
		Set Device To Screen
	#ENDIF	
	Help(" ",1,"MESINVALID")
	Return
End		

aInicioMes := CalcData(dDataInicial,1)
If aInicioMes[2] >= dDataInicial	
	aInicioMes[2] := dDataInicial
End

dataMoeda(1, @cPeriodoInicial, aInicioMes[2])
cCabecA  := cCabeca1 + iF(LiMPcc,cCentro,"") + cCabeca2
If lResumido
	titulo:=cTituloR
	cabec1:=cCabecR
Else
	titulo:=cTituloA
	cabec1:=cCabecA
Endif
titulo := titulo +  Dtoc(dDataInicial) + cA + Dtoc(dDataFinal)

If ( cDisco == NIL )
   aCampos:={ {"CONTA  ","C",15,0},;
              {"CPAR   ","C",15,0},;
              {"DC     ","C", 1,0},;
              {"VALOR"  ,"N",16,2},;
	      {"DATALAN","D",08,0},;
              {"NUMERO" ,"C",10,0},;
              {"LINHA"  ,"C",02,0},;
              {"PERIODO","C",04,0},;
              {"CCUSTO" ,"C",09,0},;
              {"HISTOR" ,"C",40,0} }

	If ( Select ( "cNomeArq" ) <> 0 )
		dbSelectArea ( "cNomeArq" )
		dbCloseArea ()
	End
   cNomeArq:=CriaTrab(aCampos)
   dbUseArea( .T.,, cNomeArq, "cNomeArq", NIL, .F. )
   IndRegua("cNomeArq",cNomeArq,"CONTA+DTOS(DATALAN)+NUMERO+LINHA+CCUSTO",,,"Selecionando Registros...")
   dbSelectArea("SI1")
   dbSetOrder(1)
   dbSeek ( xFilial() + Alltrim ( cContaInicial ), .T. )
   SetRegua(Reccount())
End

While !Eof() .and. xFilial() == I1_FILIAL .and. I1_CODIGO >= cContaInicial .and. I1_CODIGO <= cContaFinal .and. cDisco == NIL

   IncRegua()

   IF I1_CLASSE == "S"
      dbSkip()
      Loop
   EndIF

   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³ Obt‚m os d‚bitos ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea ( "SI2" )
   SI2 -> ( dbSetOrder ( 4 ) )
	lNaoDeb := .T.
   If SI2 -> ( dbSeek ( xFilial() + SI1 -> I1_CODIGO ) )
        While !Eof() .and. xFilial() == I2_FILIAL .and. I2_DEBITO == SI1->I1_CODIGO
						
			IF Substr(I2_MOEDAS,1,1) != "S" .or. I2_VALOR==0
				dbSkip()
				Loop
			EndIF

			IF I2_DC $ "C-"
				dbSkip()
				Loop
			EndIF
			
			dataMoeda(1, @cPeriodoAtual, I2_DATA)
			If (I2_DATA < aInicioMes[2] .and. cPeriodoAtual != cPeriodoInicial);
				.or. I2_DATA > dDataFinal
				dbSkip()
				Loop
			End

			If I2_CCD < cCustoInicial .Or. I2_CCD > cCustoFinal
				dbSkip()
				Loop
			EndIf	
			
            cDC    := "D"
            nValor := SI2->I2_VALOR
            cr060Temp()

			lNaoDeb := .F.
			dbSelectArea("SI2")
			dbSkip()
		Enddo
	EndIf	

   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³ Obt‚m os Cr‚ditos³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea ( "SI2" )
   SI2 -> ( dbSetOrder ( 5 ) )
	lNaoCred := .T.	
    If SI2 -> ( dbSeek ( xFilial() + SI1 -> I1_CODIGO ) )
        While !Eof() .and. xFilial() == I2_FILIAL .and. I2_CREDITO == SI1->I1_CODIGO
			IF Substr(I2_MOEDAS,1,1) != "S" .or. I2_VALOR==0
				dbSkip()
				Loop
			EndIF
	
			IF I2_DC $ "D-"
				dbSkip()
				Loop
			EndIF

			dataMoeda(1, @cPeriodoAtual, I2_DATA)
			If (I2_DATA < aInicioMes[2] .and. cPeriodoAtual != cPeriodoInicial);
				.or. I2_DATA > dDataFinal
				dbSkip()
				Loop
			End

			If I2_CCC < cCustoInicial .Or. I2_CCC > cCustoFinal
				dbSkip()
				Loop
			EndIf	
			
            cDC    := "C"
            nValor := SI2->I2_VALOR
            cr060Temp()
			
			lNaoCred := .F.
			dbSelectArea("SI2")
			dbSkip()
		Enddo
	EndIf		

	If lImp .And. lNaoDeb .And. lNaoCred .And. !lResumido
        cr060NoMov()
	EndIf	

   dbSelectArea("SI1")
   dbSkip()

EndDo

dbSelectArea("cNomeArq")
dbGoTop()

SetRegua(Reccount())
nColCC:=If(lImpCC,3,0)

dDataLanc := cNomeArq->DATALAN
While ( cNomeArq -> ( ! Eof () ) )

	#IFNDEF WINDOWS
		Inkey()
        If Lastkey() == 286
			lEnd := .T.
		EndIf	
	#ENDIF

	IF lEnd
        @Prow()+1,0 PSAY cCancel
		Exit
	EndIF

	IncRegua()
/*
	IF (CONTA < cContaInicial .or. CONTA > cContaFinal)
		dDataLanc := cNomeArq->DATALAN
		dbSkip()
		Loop
	EndIF
*/
	IF li>56 .or. lSalto
		lSalto:=.F.
		IF m_pag > nPagInicial .and. cContAnt==CONTA
            li := li + 1
            @li,096+nColCC PSAY cTransp
            @li,114+nColCC PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),16)
            @li,131+nColCC PSAY Eval ( bSinal , nSaldoAtu )
		EndIF
		If m_pag == m_pagfim
			m_pag := 1
        EndIf

        nTamanho := tamanho
        nChar    := IIF(lImpCC .or. aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))
        cr060cabec()

		li:=9
		IF nQuebra == 1
			dbSelectArea("cNomeArq")
			IF cContAnt == CONTA
                @li,009 PSAY cCont+ mascara(SI1->I1_CODIGO)
				If lEstrang
                    @li,Pcol()+2 PSAY Substr(SI1->I1_DESCEST,1,60)
				Else
                    @li,Pcol()+2 PSAY Substr(SI1->I1_DESC,1,60)
				EndIf	
                @li,096+nColCC PSAY cTrans
                @li,114+nColCC PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),16)
                @li,131+nColCC PSAY Eval ( bSinal , nSaldoAtu )
				nSaldosDia := nSaldoAtu
                li := li + 1
			EndIF
		EndIF
	EndIF

	IF nQuebra == 0
		dbSelectArea("cNomeArq")
		nQuebra:=1
		lImprAnt:=.F.
		cContAnt:=CONTA
		dbSelectArea("SI1")
        dbSeek(xFilial()+cContAnt)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula o Saldo anterior ao periodo impresso                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nSaldoAtu := CalcSaldo(Val(cMes17Ini)-1,1)
		nTotDeb:=0
		nTotCrd:=0
		dbSelectArea("cNomeArq")
	EndIF
     
	IF CONTA != cContAnt
		nQuebra 	:= 0
		IF lImprAnt
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime totais do dia, para opcao de s¢ totais.              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lResumido
                li := li + 1
                @li,001 PSAY dDataLanc
                @ li, 80+nColCC PSAY nDebitoDia  Picture tm(nDebitoDia,16)
                @ li, 97+nColCC PSAY nCreditDia  Picture tm(nCreditDia,16)
                @ li,114+nColCC PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),16)
                @li,131+nColCC PSAY Eval ( bSinal , nSaldosDia )
				nDebitoDia := nCreditDia := 0
				dDataLanc := cNomeArq->DATALAN
			EndIf

            li := li + 2
            @li, 30 PSAY cTotCont
            @li, 80+nColCC PSAY nTotDeb     Picture tm(nTotDeb,16)
            @li, 97+nColCC PSAY nTotCrd     Picture tm(nTotCrd,16)
            @li,114+nColCC PSAY Abs(nSaldoAtu)    Picture tm(Abs(nSaldoAtu),16)
            @li,131+nColCC PSAY Eval ( bSinal , nSaldoAtu )
            li := li + 1
            @li,00 PSAY Repl("-",nTamLinha)
            li := li + 1
		EndIf
		If nSalto == 1
			lSalto := .T.
		Endif
		Loop
	EndIf
	dbSelectArea("cNomeArq")
	IF (DATALAN >= dDataInicial .and. DATALAN <= dDataFinal) .Or. Empty(DATALAN)
		IF !lImprAnt
            @li,009 PSAY cCont+ mascara(SI1->I1_CODIGO)
			If lEstrang
                @li,PCOL()+2 PSAY Substr(SI1->I1_DESCEST,1,60)
			Else
                @li,PCOL()+2 PSAY Substr(SI1->I1_DESC,1,60)
			EndIf	
            @li,096+nColCC PSAY cSaldAnt
            @li,114+nColCC PSAY Abs(nSaldoAtu)   Picture tm(Abs(nSaldoAtu),16)
            @li,131+nColCC PSAY Eval ( bSinal , nSaldoAtu )
            li := li + 1
			lImprAnt:=.T.
			nSaldosDia := nSaldoAtu
		EndIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime totais do dia, para opcao de s¢ totais.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lResumido
			If dDataLanc != cNomeArq->DATALAN .And. cNomeArq->CONTA == cContAnt
                li := li + 1
                @li,001 PSAY dDataLanc
                @ li, 80+nColCC PSAY nDebitoDia  Picture tm(nDebitoDia,16)
                @ li, 97+nColCC PSAY nCreditDia  Picture tm(nCreditDia,16)
                @ li,114+nColCC PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),16)
                @li,131+nColCC PSAY Eval ( bSinal , nSaldosDia )

				nDebitoDia := nCreditDia := 0
			EndIf
			IF DC == "D"
                nSaldosDia := nSaldosDia - cNomeArq -> VALOR
                nDebitoDia := nDebitoDia + cNomeArq -> VALOR
                nSaldoAtu  := nSaldoAtu  - VALOR
                nTotDeb    := nTotDeb    + VALOR
			Else
                nSaldosDia := nSaldosDia + cNomeArq -> VALOR
                nCreditDia := nCreditDia + cNomeArq -> VALOR
                nSaldoAtu  := nSaldoAtu  + VALOR
                nTotCrd    := nTotCrd    + VALOR
			EndIF
			
		Else
            li := li + 1
			If !Empty(DATALAN)
		@li,001 PSAY DATALAN
                @li,010 PSAY SUBSTR(NUMERO,1,4)+"/"+Substr(NUMERO,8,10)+"-"+LINHA
			EndIf	
            @li,022 PSAY HISTOR
			dbSelectArea("SI2")
			dbSetOrder(3)
	    IF ( dbSeek ( xFilial() + Dtos(cNomeArq -> DATALAN ) + cNomeArq -> NUMERO + cNomeArq-> LINHA ) )
				dbSkip()
		While !Eof() .and. I2_DC == "-" .and. I2_DATA == cNomeArq -> DATALAN
                    li := li + 1
                    @li,010 PSAY Substr(I2_NUM,1,4)+"/"+Substr(I2_NUM,8,10)+"-"+I2_LINHA
                    @li,022 PSAY I2_HIST
					dbSkip( )
				EndDO
			EndIF

			dbSelectArea("cNomeArq")

			IF !Empty(CPAR)
                @li,64 PSAY CPAR
			EndIF

			IF lImpCC
                @li,080 PSAY SUBS(CCUSTO,1,3)
			Endif

			IF DC == "D"
                @li,080+nColCC PSAY VALOR       Picture tm(VALOR,16)
                nSaldoAtu := nSaldoAtu  - VALOR
                nTotDeb   := nTotDeb    + VALOR
			Else
                @li,97+nColCC PSAY VALOR    Picture tm(VALOR,16)
                nSaldoAtu := nSaldoAtu + VALOR
                nTotCrd   := nTotCrd   + VALOR
			EndIF
            @li,114+nColCC PSAY Abs(nSaldoAtu)    Picture tm(Abs(nSaldoAtu),16)
            @li,131+nColCC PSAY Eval ( bSinal , nSaldoAtu )
		EndIf
	Else
		IF DC == "D"
	    nSaldoAtu := nSaldoAtu - IIF(DATALAN>dDataFinal,0,VALOR)
		Else
	    nSaldoAtu := nSaldoAtu + IIF(DATALAN>dDataFinal,0,VALOR)
		EndIF
	EndIf	
	dDataLanc := cNomeArq->DATALAN
	dbSkip( )
End

IF lImp .Or. ;
	(li != 80 .and. ( nTotDeb != 0 .or. nTotCrd != 0 ) .And. !lEnd)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime totais do dia, para opcao de s¢ totais.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lResumido
        li := li + 1
        @ li,001 PSAY dDataLanc
        @ li, 80+nColCC PSAY nDebitoDia  Picture tm(nDebitoDia,16)
        @ li, 97+nColCC PSAY nCreditDia  Picture tm(nCreditDia,16)
        @ li,114+nColCC PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),16)
        @ li,131+nColCC PSAY Eval ( bSinal , nSaldosDia )
	EndIf

    li := li + 2
    @li, 30 PSAY cTotCont
    @li, 80+nColCC PSAY nTotDeb        Picture tm(nTotDeb,16)
    @li, 97+nColCC PSAY nTotCrd        Picture tm(nTotCrd,16)
    @li,114+nColCC PSAY Abs(nSaldoAtu)    Picture tm(Abs(nSaldoAtu),16)
    @li,131+nColCC PSAY Eval ( bSinal , nSaldoAtu )
    li := li + 1
    @li,00 PSAY Repl("-",nTamLinha)
    Li := li + 1
    wcbcont  := cbCont
    wcbtxt   := cbTxt
    roda_tam := tamanho
    cr060Roda()
EndIF

If ( Li != 80 .and. cDisco == NIL ) .Or. Select ( "cNomeArq" ) <> 0
	dbSelectArea("cNomeArq")
    dbCloseArea()
	Ferase(cNomeArq+".DBF")    	// Elimina arquivos de Trabalho
	Ferase(cNomeArq+OrdBagExt())    // Elimina arquivos de Trabalho
End

dbSelectarea("SI1")
dbSetOrder(1)
Set Filter To
dbSelectarea("SI2")
dbSetOrder(1)
#IFNDEF WINDOWS
	Set Device To Screen
#ENDIF	

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Cr060Temp³ Autor ³ Wagner Xavier         ³ Data ³ 26.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria registro para arquivo tempor rio para emiss„o do      ³±±
±±³          ³ Raz„o                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cr060Temp ( cDC, lCentroDeCusto )                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cDC ú Tipo de lan‡amento ( D‚bito, Cr‚dito ou X )          ³±±
±±³          ³ lCentroDeCusto ú Inclui centros de custo ( .T. ou .F. )    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONR060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function cr060Temp
Static Function cr060Temp()

cFlag      := ""
cConta     := ""
cCpar      := ""
cContaRepl := ""
cCustoRepl := ""

nValor     := Iif(nValor==NIL,SI2->I2_VALOR,nValor)
dbSelectArea ( "cNomeArq" )

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Caso o lan‡amento seja "X", define se ‚ cr‚dito ou d‚bito ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
   Case ( cDc == "C" )
        cFlag := "C"
		cConta:= "SI2 -> I2_CREDITO"
		cCpar := "SI2 -> I2_DEBITO"
   Case ( cDc == "D" )
        cFlag := "D"
		cConta:= "SI2 -> I2_DEBITO"
		cCpar := "SI2 -> I2_CREDITO"
EndCase

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Verifica se ha registro repetido no arquivo temporario    ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCodigo := &cConta
cr060Join()
IF lCentroDeCusto .And. lRetorno
   cContaRepl :=    LEFT(cCodigo,LEN(TRIM(cCodigo))-SI1->I1_NCUSTO) + ;
                        Space(15-Len(LEFT(cCodigo,LEN(TRIM(cCodigo))-SI1->I1_NCUSTO)))
Else
    cContaRepl := cCodigo
EndIF
cCustoRepl := Iif(cDC=="D",SI2->I2_CCD,SI2->I2_CCC)

// Deve permitir imprimir registros repetidos, pois no caso de consolidacoes
// poderao existir lancamentos iguais!

Reclock("cNomeArq",.T.)
cNomeArq->DC     := cFlag
cNomeArq->HISTOR := SI2->I2_HIST
cNomeArq->NUMERO := SI2->I2_NUM
cCodigo := &cConta
cr060Join()
IF lCentroDeCusto .And. lRetorno
   cNomeArq->CONTA := LEFT(cCodigo,LEN(TRIM(cCodigo))-SI1->I1_NCUSTO)
Else
   cNomeArq->CONTA := cCodigo
EndIF
cNomeArq->CPAR    := &cCpar
cNomeArq->LINHA   := SI2->I2_LINHA
cNomeArq->VALOR   := nValor
cNomeArq->DATALAN := SI2->I2_DATA
cNomeArq->PERIODO := SI2->I2_PERIODO
cNomeArq->CCUSTO  := cCustoRepl
MsUnlock()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Cr060Join³ Autor ³ Wagner Xavier         ³ Data ³ 26.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se a conta sera agrupada por centro de custo      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cr060Join(ExpC1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ tipo do lancamento                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONR060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function cr060join
Static Function cr060join()

lRetorno  := .T.
nRegistro := 0
cArea     := ALias ()

dbSelectArea ( "SI1" )
nRegistro := Recno()
dbSeek ( xFilial() + cCodigo )
lRetorno := ( SI1 -> I1_NCUSTO != 0 )
dbGoto ( nRegistro )

dbSelectArea ( cArea )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³cr060Cabec³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de impressao do cabecalho dos relatorios            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ cr060cabec(nTamanho,char)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function cr060cabec
Static Function cr060cabec()

cAlias  := Alias()
aDriver := ReadDriver( )
nLin    := 0

Do Case
    Case nTamanho=='P'   // pequeno
        nLargura:=80
    Case nTamanho=='G'   // grande
        nLargura:=142
	Otherwise
        nLargura:=132
EndCase

if nChar == NIL
    cCtl := if(nTamanho=="P",aDriver[1],if(nTamanho=="G",aDriver[5],aDriver[3]))
    cCtl := &cCtl
else
    if nChar == 15
        cCtl := if(nTamanho=="P",aDriver[1],if(nTamanho=="G",aDriver[5],aDriver[3]))
        cCtl := &cCtl
    else
        cCtl := if(nTamanho=="P",aDriver[2],if(nTamanho=="G",aDriver[6],aDriver[4]))
        cCtl := &cCtl
    endif
endif

@ 0,0 PSAY cCtl

dbSelectArea( "SM0" )
@ nLin, 00 PSAY Replicate("*",nlargura)
nLin := nLin + 1
@ nLin, 00 PSAY "*"
@ nLin, 01 PSAY "SIGA/" + nomeprog + "/v."// + cVer
@ nLin, Int((nlargura - (Len(Trim(SM0->M0_NOMECOM))))/2) PSAY SM0->M0_NOMECOM
@ nLin, nlargura-18 PSAY cFolha + Transform(m_pag,'9999')+"   *"

nLin := nLin + 1
@ nLin, 00 PSAY "*"
@ nLin, Int((nlargura - 18)/2) PSAY Transform(Alltrim(SM0->M0_CGC),"@R 99.999.999/9999-99")
@ nLin, nlargura-18 PSAY cData + DtoC(dDataBase)
@ nLin, nLargura-1 PSAY "*"

nLin := nLin + 1

@ nLin, 00 PSAY cHora + Time()
@ nLin, Int((nlargura - (Len(Trim( titulo ))))/2) PSAY titulo
@ nLin, nLargura - 18  PSAY cRef + DtoC(date())
@ nLin, nLargura - 1 PSAY "*"

nLin := nLin + 1
@ nLin, 00 PSAY Replicate("*",nlargura)

nLin := nLin + 1
@ nLin, 00 PSAY cabec1
nLin := nLin + 1
@ nLin, 00 PSAY cabec2
nLin := nLin + 1
@ nLin, 00 PSAY Replicate("*",nlargura)

m_pag := m_pag + 1
dbSelectArea( cAlias )
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³cr060Roda ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 22.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de impressao do rodape dos relatorios               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ cr060roda()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function cr060Roda
Static Function cr060Roda()

Largura := 132

Do Case
    Case roda_tam == 'P'   // pequeno
		largura := 80
    Case roda_tam == 'G'   // grande
		largura := 142
EndCase
@ 59, 00        PSAY Replicate("*",largura)
If Empty(GetMv("MV_RODAPE"))
    @ 60, 00        PSAY cSiga + Iif(wcbcont==0," ",Str(wcbcont,4)+" "+wcbtxt)
Else
    @ 60, 00        PSAY "* " + Alltrim(GetMv("MV_RODAPE")) + " - Software by SIGA" + Iif(wcbcont==0," ",Str(wcbcont,4)+" "+wcbtxt)
EndIf	
@ 60, largura-25    PSAY cTimeFim + Time()
@ 60, largura-1     PSAY "*"
@ 61, 00        PSAY Replicate("*",largura)
@ 62, 00        PSAY "       "

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Cr060NoMov³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 18.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria registro para arquivo tempor rio para emiss„o do      ³±±
±±³          ³ Raz„o com contas sem movimento                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cr060NoMov()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONR060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function cr060NoMov
Static Function cr060NoMov()

cConta := ""
nSal   := 0

dbSelectArea("SI1")
nSal := CalcSaldo(Val(cMes17Ini),1)

If (Int(nSal*100)/100) != 0
	cConta := SI1->I1_CODIGO
	dbSelectArea ( "cNomeArq" )
	Reclock("cNomeArq",.t.)
    cNomeArq->HISTOR := "CONTA SEM MOVIMENTO NO PERIODO"
    cNomeArq->CONTA  := cConta
	MsUnlock()
EndIf	
Return
