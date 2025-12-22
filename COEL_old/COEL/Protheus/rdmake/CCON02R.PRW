#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Ccon02r()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,TITULO")
SetPrvt("TAMANHO,ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG")
SetPrvt("CDISCO,CBTXT,CBCONT,LIMITE,NQUEBRA,ACAMPOS")
SetPrvt("NTOTDEB,NTOTCRD,CCONTANT,NSALDOATU,AINICIOMES,LIMPRANT")
SetPrvt("DDATAINICIAL,DDATAFINAL,DDATAANT,LCENTRODECUSTO,LIMPCC,LSALTO")
SetPrvt("NSALTO,LIMPITEM,NTAMLINHA,CINICIO,CPER17,CPER17ANT")
SetPrvt("LRESUMIDO,NDEBITODIA,NCREDITDIA,NSALDOSDIA,NPAGINICIAL,DDATALANC")
SetPrvt("BSINAL,LNAODEB,LNAOCRED,LIMP,LESTRANG,LCUSTO")
SetPrvt("LCOMPLHIST,NCODNOR,CITEMINICIAL,CITEMFINAL,CDIGVER,NREINICIA")
SetPrvt("CDESCRICAO,CTITULOR,CCABECR,CTITULOA,CABEC1,CABEC2")
SetPrvt("CCABECA1,CCABECA2,LFIRSTPAGE,CMES17INI,CMES17FIM,CPERIODOINICIAL")
SetPrvt("CPERIODOATUAL,CSINTANT,CCONTASINT,CDESC,LI,M_PAG")
SetPrvt("CCONTAINICIAL,CCONTAFINAL,CCUSTOINICIAL,CCUSTOFINAL,M_PAGINICIAL,M_PAGFIM")
SetPrvt("CCABECA,CNOMEARQ,LEND,CFLAG,CCONTA,CCPAR")
SetPrvt("CCONTAREPL,CCUSTOREPL,CITEMREPL,NVALOR,CDC,LRETORNO")
SetPrvt("NREGISTRO,CAREA,NSAL,CALIAS,NREG,COLDAREA")
SetPrvt("NOLDORD,LSINT,NTAMCONTA,NPOSSI1,APERG,")


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Progr. ³ 						ALTERACAO 					      ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³03.03.98³      ³Pilar  ³compatibilizadas perguntas do relatorio/consulta³±±
±±³08.04.98³xxxxxx³Pilar  ³A funcao TM() deve levar em consideracao a      ³±±
±±³        ³      ³       ³lingua na qual esta sendo impresso o relatorio  ³±±
±±³23.04.98³xxxxxx³Pilar  ³Incluido parametro MV_DIGVER p/ imprimir o digi ³±±
±±³        ³      ³       ³to de controle ou nao junto … conta contabil    ³±±
±±³05.05.98³      ³Pilar  ³Alterado tamanho do campo I2_NUM (7->10)        ³±±
±±³27.07.98³      ³Pilar  ³Chamada direta pela consulta em tela            ³±±
±±³26.09.98³      ³Andreia³Alteracao do Lay-out para ativar set century    ³±±
±±³02.10.98³      ³Andreia³Alteracao do cabecalho quando imprimir C.Custo  ³±±
±±³16.12.98³18926A³Pilar  ³Ao pesquisar por descricao, trava a consulta    ³±±
±±³05.01.99³18064A³Pilar  ³Opcao p/ imprimir Do Item - Ate Item            ³±±
±±³17.03.99³xxxxxx³Pilar  ³Acertar incrementacao da pagina					   ³±±
±±³30.03.99³META  ³Julio  ³Verifica‡„o de Parƒmetros de Controle do Rel.   ³±±
±±³23.06.99³xxxxxx³Pilar  ³Criar pergunta: Reinicia numeracao de pagina	   ³±±
±±³16.07.99³xxxxxx³Julio  ³Correcao na AjustaSx1							      ³±±
±±³30.07.99³23090A³Julio  ³Correcao no tamanho do Relatorio				      ³±±
±±³05.08.99³      ³Pilar  ³Controle da 1a. pagina a ser impressa			   ³±±
±±³28.09.99³24109A³Pilar  ³Aumentar picture do campo saldo atual -> form G ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 02/09/02 ==> 	#DEFINE PSAY SAY
#ENDIF

// #IFDEF WINDOWS
//     #Include "FIVEWIN.Ch"
// #ENDIF
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
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Function RAZAO( cContaInicial, cContaFinal, cDisco )

WnRel := ""
cDesc1 := "Este programa ir  imprimir o Razao Contabil, de  acordo  com"
cDesc2  := "os parametros solicitados pelo usuario. Caso seja  escolhida"
cDesc3  := "a impressao do Centro de Custo, o relatorio ser  comprimido."
cString :="SI2"
titulo  :="Emissao do Razao em " + GetMV("MV_MOEDA1")
Tamanho :="M"
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "", 1 }
nomeprog := ""
aLinha   := {}
nLastKey := 0
cPerg    := ""
cDisco := NIL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os par„metros do relat¢rio                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

If ( cDisco == NIL )
	Pergunte ( "COR060", .F. )
	nomeprog := "RAZAO"
	cPerg    := "COR060"
	wnRel    := "RAZAO"
Else
	Pergunte ( "COC010", .F. )
	nomeprog := "CONC010"
	cPerg    := "COC010"
	wnRel    := "CONC010"
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cDisco != Nil                // Para consulta nao pode alterar perguntas
	wnrel := SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Else
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
EndIf

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

#IFDEF WINDOWS
        RptStatus({|| Cr060Imp()})// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==>         RptStatus({|| Execute(Cr060Imp)})
      //  RptStatus({|lEnd| Cr060Imp(@lEnd,wnRel,cString,cContaInicial, cContaFinal, cDisco)})  // Chamada do Relatorio

#ELSE
	Cr060Imp(.f.,wnRel,cString,cContaInicial,cContaFinal,cDisco)  // Chamada do Relatorio
#ENDIF
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ Cr060Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Razao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ Cr060Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACON                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³           ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³           ³ cString - Mensagem                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Cr060Imp
Static Function Cr060Imp()
//() //(lEnd,WnRel,cString,cContaInicial, cContaFinal, cDisco)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt :=""
cbcont :=""
tamanho:="M"
limite := 132
nQuebra:=0
aCampos:=""
nTotDeb:=0
nTotCrd:=0
cContAnt:=0
nSaldoAtu:=0
aInicioMes:=0
lImprAnt:=.F.
dDataInicial   := CtoD ( Space ( 08 ) )
dDataFinal     := CtoD ( Space ( 08 ) )
dDataAnt       := CtoD ( Space ( 08 ) )
lCentroDeCusto := .T.
lImpCC         :=.F.
lSalto:=.F.
nSalto:=""
lImpItem        := .F.
nTamLinha := 132
cInicio := ""
cPer17  := ""
cPer17Ant := ""
lResumido   := .F.     // relatorio resumido (s¢ totais) ou completo
nDebitoDia  := 0       // total de debitos do dia
nCreditDia  := 0       // total de creditos do dia
nSaldosDia  := 0       // saldo final do dia
nPagInicial := 1       // numero da pagina inicial
dDataLanc  := CtoD ( Space ( 08 ) )            // data de lancamento
bSinal     := { | nSaldo | Iif( nSaldo < 0 , "D", Iif( nSaldo > 0 , "C"," " ) ) }
lNaoDeb := lNaoCred := .F.
lImp := .F.
lEstrang := .T.
lCusto := .F.
lComplHist := .T.
nCodNor	:= 1
cItemInicial :=""
cItemFinal   :=""
cDigVer	:= GetMv("MV_DIGVER")
nReinicia := 0
cDescricao := "" // descricao da conta
cTituloR:= "RAZAO  ANALITICO  (TOTAIS)  DE "
cCabecR := "  DATA                                                                              D E B I T O    C R E D I T O        SALDO ATUAL "
cTituloA:= "RAZAO  ANALITICO  DE "
Cabec1 := ""
cabec2  := ""
cCabeca1:="DATA       NUMERO         H I S T O R I C O                        C/PARTIDA            "
cCabeca2:="  DEBITO      CREDITO   SALDO ATUAL"
lFirstPage:=.T.

cMes17Ini := ""
cMes17Fim := ""
cPeriodoInicial := ""
cPeriodoAtual := ""
cSintAnt   := ""     //Vari vel auxiliar
cContaSint := ""     //1a Conta sint‚tica Anterior
cDesc      := ""     //Nome da 1a Conta Sint‚tica Anterior

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

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
	//³ mv_par15            // Imprime Cod (Normal / Reduzida)       ³
	//³ mv_par16            // Imprime Item?	                       ³
	//³ mv_par17            // Do Item                               ³
	//³ mv_par18            // Ate Item                              ³
	//³ mv_par19            // Numero da Pag p/ Reiniciar            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cContaInicial  := Mv_Par01
	cContaFinal    := Mv_Par02
	cCustoInicial := mv_par13
	cCustoFinal	  := mv_par14
	dDataInicial   := Mv_Par03
	dDataFinal     := Mv_Par04
	lCentroDeCusto := ( Mv_Par05 == 1 )
	Tamanho	  	  := "M"
	lImpCC            := (Mv_Par06==1 .And. mv_par10==1)
	lImpItem          := (Mv_Par16==1 .And. mv_par10==1)
	nTamLinha         := If((lImpItem .Or. lImpCC .And. mv_par10==1),220,nTamLinha)
	nSalto	  	  := mv_par07
	m_pag	  	  := mv_par08
	m_paginicial  := mv_par08
	m_pagfim  	  := mv_par09
	lResumido 	  := If(mv_par10==2,.T.,.F.)
	lImp		  := If(mv_par11==1,.t.,.f.)
	nCodNor		  := mv_par15
	cItemInicial  := mv_par17
	cItemFinal    := mv_par18
	nReinicia	  := mv_par19
	
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
	dbSelectArea("SI1")
	dbSetOrder(1)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros ( COC010 )              ³
	//³ mv_par01            // do dia                                ³
	//³ mv_par02            // Ate o dia                             ³
	//³ mv_par03            // Considera os Centro de Custo          ³
	//³ mv_par04            // Pagina Inicial			    				  ³
	//³ mv_par05            // Pagina Final		            		  ³
	//³ mv_par06            // Descricao Nacional ou Estrangeira	  ³
	//³ mv_par07            // Considera os Items               	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dDataInicial  	:= Mv_Par01
	dDataFinal    	:= Mv_Par02
	cCustoInicial 	:= Space(9)
	cCustoFinal		:= Replicate("Z",9)
	lImpCC			:= ( Mv_Par03 == 1 )
	lImpItem			:= ( mv_par07 == 1 )
	Tamanho			:= "M"
	m_pag  		  	:= mv_par04
	m_paginicial   := mv_par04
	m_pagfim		  	:= mv_par05
	nSalto		  	:= 2   	// Nao Salta Pagina
	lImp			  	:= .t.
	nCodNor		  	:= 1
	cItemInicial	:= Space(09)
	cItemFinal		:= Replicate("Z",9)
	nReinicia	   := mv_par04

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
	dbSelectArea("SI1")
	dbSetOrder(1)
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

cCabeca2 := Iif(lImpItem .Or. lImpCC,"       DEBITO               CREDITO                    SALDO ATUAL",cCabeca2)

dataMoeda(1, @cPeriodoInicial, aInicioMes[2])
cCabecA := 	cCabeca1 + ;
Iif(lImpCC,Upper(RetTitle("I3_CUSTO",09)),Space(9)) +;
Iif(lImpItem .Or. lImpCC ,Space(1)+;
Iif(lImpItem,Upper(RetTitle("I4_ITEM",09)),Space(9)),"") +;
cCabeca2
If lResumido
	titulo:=cTituloR
	cabec1:=cCabecR
Else
	titulo:=cTituloA
	cabec1:=cCabecA
Endif
titulo:= titulo + Dtoc(dDataInicial) + " A " + Dtoc(dDataFinal)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos:={ {"CONTA  ","C",20,0},;
{"CPAR   ","C",20,0},;
{"DC     ","C", 1,0},;
{"VALOR"  ,"N",16,2},;
{"DATALAN","D",08,0},;
{"NUMERO" ,"C",10,0},;
{"LINHA"  ,"C",02,0},;
{"PERIODO","C",04,0},;
{"CCUSTO" ,"C",09,0},;
{"ITEM"  ,"C",09,0},;
{"HISTOR" ,"C",40,0},;
{"FILORIG","C",02,0},;
{"EMPORIG","C",02,0} }
If ( Select ( "cNomeArq" ) <> 0 )
	dbSelectArea ( "cNomeArq" )
	dbCloseArea ()
End
cNomeArq:=CriaTrab(aCampos)
dbUseArea( .T.,, cNomeArq, "cNomeArq", NIL, .F. )
IndRegua("cNomeArq",cNomeArq,"CONTA+DTOS(DATALAN)+NUMERO+LINHA+CCUSTO+EMPORIG+FILORIG",,,"Selecionando Registros...")  //
dbSelectArea("SI1")
dbSetOrder(1)
dbSeek ( xFilial() + Alltrim ( cContaInicial ), .T. )
SetRegua(Reccount())

While !Eof() .and. xFilial() == I1_FILIAL .and. I1_CODIGO <= cContaFinal
	
	IncRegua()
	
	IF I1_CLASSE == "S"
		dbSkip()
		Loop
	EndIF
	
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Obt‚m os d‚bitos ³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea ( "SI2" )
	dbSetOrder ( 4 )
	lNaoDeb := .T.
	SI2->(dbSeek ( xFilial() + SI1 -> I1_CODIGO + DTOS(aInicioMes[1]),.t.))
	While !Eof() .and. xFilial() == I2_FILIAL;
		.and. I2_DEBITO == SI1->I1_CODIGO .And. I2_DATA <= dDataFinal
		
		IF Substr(I2_MOEDAS,1,1) != "S" .or. I2_VALOR==0
			dbSkip()
			Loop
		EndIF
		
		IF I2_DC $ "C-"
			dbSkip()
			Loop
		EndIF
		
		If I2_CCD < cCustoInicial .Or. I2_CCD > cCustoFinal
			dbSkip()
			Loop
		EndIf
		
		If I2_ITEMD < cItemInicial .Or. I2_ITEMD > cItemFinal
			dbSkip()
			Loop
		Endif
		
		cr060Temp("D",lCentroDeCusto,SI2->I2_VALOR)
		lNaoDeb := .F.
		dbSelectArea("SI2")
		dbSetOrder(4)
		dbSkip()
	Enddo
	
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// ³ Obt‚m os Cr‚ditos³
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea ( "SI2" )
	dbSetOrder ( 5 )
	lNaoCred := .T.
	SI2 -> ( dbSeek ( xFilial() + SI1 -> I1_CODIGO + DTOS(aInicioMes[1]),.t.) )
	While !Eof() .and. xFilial() == I2_FILIAL ;
		.and. I2_CREDITO == SI1->I1_CODIGO .And. I2_DATA <= dDataFinal
		
		IF Substr(I2_MOEDAS,1,1) != "S" .or. I2_VALOR==0
			dbSkip()
			Loop
		EndIF
		
		IF I2_DC $ "D-"
			dbSkip()
			Loop
		EndIF
		
		If I2_CCC < cCustoInicial .Or. I2_CCC > cCustoFinal
			dbSkip()
			Loop
		EndIf
		
		If I2_ITEMC < cItemInicial .Or. I2_ITEMC > cItemFinal
			dbSkip()
			Loop
		EndIf
		
		cr060Temp("C",lCentrodeCusto,SI2->I2_VALOR)
		
		lNaoCred := .F.
		dbSelectArea("SI2")
		dbSetOrder(5)
		dbSkip()
	Enddo
	
	If lNaoDeb .And. lNaoCred .And. !lResumido
		cr060NoMov(1,lImp)
	EndIf
	
	dbSelectArea("SI1")
	dbSetOrder(1)
	dbSkip()
	
EndDo

dbSelectArea("cNomeArq")
dbGoTop()

SetRegua(Reccount())

dDataLanc := cNomeArq->DATALAN
While ( cNomeArq -> ( ! Eof () ) )
	
	#IFNDEF WINDOWS
		Inkey()
		If Lastkey() == K_ALT_A
			lEnd := .T.
		EndIf
	#ENDIF
	
	IF lEnd
		@Prow()+1,0 PSAY "***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF
	
	IncRegua()
	
	IF (CONTA < cContaInicial .or. CONTA > cContaFinal)
		dDataLanc := cNomeArq->DATALAN
		dbSkip()
		Loop
	EndIF
	
	Cr060Cabec(Titulo, Tamanho, Cabec1, Cabec2, nQuebra, @lSalto, nPagInicial,;
	lImpItem, lImpCC, cContAnt, nSaldoAtu, lEstrang, bSinal,;
	nReinicia, dDataFinal, @lFirstPage, cDigVer, nCodNor, @nSaldosDia)
	
	IF nQuebra == 0
		dbSelectArea("cNomeArq")
		nQuebra:=1
		lImprAnt:=.F.
		cContAnt:=CONTA
		dbSelectArea("SI1")
		dbSetOrder(1)
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
				li:=li+1
				@ li,000 PSAY dDataLanc
				If !lImpItem .And. !lImpCC
					@ li, 93 PSAY nDebitoDia  Picture tm(nDebitoDia,12,,lEstrang)
					@ li,106 PSAY nCreditDia  Picture tm(nCreditDia,12,,lEstrang)
					@ li,119 PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),12,,lEstrang)
					@ li,131 PSAY Eval ( bSinal , nSaldosDia )
				Else
					ValorContab(nDebitoDia,li,109,17,,.F.,lEstrang)
					ValorContab(nCreditDia,li,131,17,,.F.,lEstrang)
					ValorContab(nSaldosDia,li,154,17,,.T.,lEstrang)
				EndIf
				nDebitoDia := nCreditDia := 0
				dDataLanc := cNomeArq->DATALAN
			EndIf
			
			li:=li+2
			@li, 30 PSAY "T o t a i s  d a  C o n t a  ==> "
			If !lImpItem .And. !lImpCC
				@li, 93 PSAY nTotDeb     Picture tm(nTotDeb,12,,lEstrang)
				@li,106 PSAY nTotCrd     Picture tm(nTotCrd,12,,lEstrang)
				@li,119 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),12,,lEstrang)
				@li,131 PSAY Eval ( bSinal , nSaldoAtu )
			Else
				ValorContab(nTotDeb,li,109,17,,.F.,lEstrang)
				ValorContab(nTotCrd,li,131,17,,.F.,lEstrang)
				ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
			EndIf
			li:= li+1
			@li,00 PSAY Replicate("-",nTamLinha)
			li:= li+1
		EndIf
		If nSalto == 1
			lSalto := .T.
		Endif
		Loop
	EndIf
	dbSelectArea("cNomeArq")
	IF (DATALAN >= dDataInicial .and. DATALAN <= dDataFinal) .Or. Empty(DATALAN)
		IF !lImprAnt
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime a 1a Conta Sint‚tica Anterior quando for anal¡tica   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cContaSint := Cr060Sint(lEstrang)   //Retorna a 1a Conta Sint‚tica Anterior
			If cContaSint != cSintAnt .and. !lResumido
                                li:=li+1
                                @li, 001 PSAY mascara(cContaSint) +"-"+ cDesc
				li:=li+1
				cSintAnt := cContaSint
			Endif
			cDescricao := if(lEstrang,Substr(SI1->I1_DESCEST,1,60),Substr(SI1->I1_DESC,1,60))
			If cDigVer == "S"
				@li,011 PSAY "CONTA - " +;
				Iif(nCodNor==1.Or.Empty(SI1->I1_RES),;
				mascara(Alltrim(SI1->I1_CODIGO)+SI1->I1_DC),SI1->I1_RES)+"-"+;
				cDescricao
			Else
				@li,011 PSAY "CONTA - " +;
				Iif(nCodNor==1.Or.Empty(SI1->I1_RES),mascara(SI1->I1_CODIGO),SI1->I1_RES)+"-"+;
				cDescricao
			EndIf
			If !lImpItem .And. !lImpcc
				@li,102 PSAY "SALDO ANTERIOR : "
			Else
				@li,109 PSAY "SALDO ANTERIOR : "
			EndIf
			If !lImpItem .And. !lImpCC
				@li,119 PSAY Abs(nSaldoAtu)   Picture tm(Abs(nSaldoAtu),12,,lEstrang)
				@li,131 PSAY Eval ( bSinal , nSaldoAtu )
			Else
				ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
			EndIf
			li:=li+1
			lImprAnt:=.T.
			nSaldosDia := nSaldoAtu
		EndIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime totais do dia, para opcao de s¢ totais.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lResumido
			If dDataLanc != cNomeArq->DATALAN .And. cNomeArq->CONTA == cContAnt
				li:=li+1
				@ li,000 PSAY dDataLanc
				If !lImpItem .And. !lImpCC
					@ li, 93 PSAY nDebitoDia  Picture tm(nDebitoDia,12,,lEstrang)
					@ li,106 PSAY nCreditDia  Picture tm(nCreditDia,12,,lEstrang)
					@ li,119 PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),12,,lEstrang)
					@ li,131 PSAY Eval ( bSinal , nSaldosDia )
				Else
					ValorContab(nDebitoDia,li,109,17,,.F.,lEstrang)
					ValorContab(nCreditDia,li,131,17,,.F.,lEstrang)
					ValorContab(nSaldosDia,li,154,17,,.T.,lEstrang)
				EndIf
				nDebitoDia := nCreditDia := 0
			EndIf
			IF DC == "D"
				nSaldosDia := nSaldosDia - cNomeArq->VALOR
				nDebitoDia := nDebitoDia +cNomeArq->VALOR
				nSaldoAtu  :=nSaldoAtu-VALOR
				nTotDeb    :=nTotDeb  +VALOR
			Else
				nSaldosDia := nSaldosDia +cNomeArq->VALOR
				nCreditDia := nCreditDia +cNomeArq->VALOR
				nSaldoAtu  :=nSaldoAtu+VALOR
				nTotCrd    :=nTotCrd+VALOR
			EndIF
			
		Else    //IMPRIME TUDO
			li:=li+1
			If !Empty(DATALAN)
				@li,000 PSAY DATALAN
				@li,011 PSAY SUBSTR(NUMERO,1,4)+"/"+Substr(NUMERO,5,6)+"-"+LINHA
			EndIf
			@li,026 PSAY HISTOR
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tratamento para historico complementar                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SI2")
			dbSetOrder(3)
			IF ( dbSeek(xFilial()+Dtos(cNomeArq->DATALAN)+cNomeArq->NUMERO+cNomeArq->LINHA+cNomeArq->EMPORIG+cNomeArq->FILORIG,.T.) )
				dbSkip()
				lComplHist := .T.
				While ( !Eof() .And. ;
					SI2->I2_DATA == cNomeArq->DATALAN    .And.;
					SI2->I2_NUM  == cNomeArq->NUMERO     .And.;
					lComplHist )
					If ( I2_EMPORIG  == cNomeArq -> EMPORIG .And.;
						I2_FILORIG  == cNomeArq -> FILORIG )
						If ( SI2->I2_DC == "-" )
							li:=li+1
							dbSelectArea("cNomeArq")
							Cr060Cabec(Titulo, Tamanho, Cabec1, Cabec2, nQuebra, @lSalto,;
							nPagInicial, lImpItem, lImpCC, cContAnt,;
							nSaldoAtu, lEstrang, bSinal, nReinicia,;
							dDataFinal, @lFirstPage, cDigVer, nCodNor,;
							@nSaldosDia)
							dbSelectArea("SI2")
							@li,011 PSAY Substr(I2_NUM,1,4)+"/"+Substr(I2_NUM,5,6)+"-"+I2_LINHA
							@li,026 PSAY I2_HIST
						Else
							lComplHist := .F.
						EndIf
					EndIf
					dbSelectArea("SI2")
					dbSkip()
				Enddo
			EndIF
			dbSelectArea("cNomeArq")
			IF !Empty(CPAR)
				@li,67 PSAY TRIM(CPAR)
			EndIF
			
			IF lImpCC
				@li,088 PSAY CCUSTO
			Endif
			
			If lImpItem
                                @li,098 PSAY ITEM
			EndIf
			
			IF DC == "D"
				If !lImpItem .And. !lImpCC
					@li,093 PSAY VALOR    Picture  tm(VALOR,12,,lEstrang)
				Else
					ValorContab(VALOR,li,109,17,,.F.,lEstrang)
				EndIf
				nSaldoAtu:=nSaldoAtu-VALOR
				nTotDeb  :=nTotDeb +VALOR
			Else
				If !lImpItem .And. !lImpCC
					@li,106 PSAY VALOR    Picture tm(VALOR,12,,lEstrang)
				Else
					ValorContab(VALOR,li,131,17,,.F.,lEstrang)
				EndIf
				nSaldoAtu:=nSaldoAtu+VALOR
				nTotCrd  :=nTotCrd  +VALOR
			EndIF
			If !lImpItem .And. !lImpCC
				@li,119 PSAY Abs(nSaldoAtu)  Picture tm(Abs(nSaldoAtu),12,,lEstrang)
				@li,131 PSAY Eval ( bSinal , nSaldoAtu )
			Else
				ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
			EndIf
		EndIf
	Else
		IF DC == "D"
			nSaldoAtu:=nSaldoAtu-IIF(DATALAN>dDataFinal,0,VALOR)
		Else
			nSaldoAtu:=nSaldoAtu+IIF(DATALAN>dDataFinal,0,VALOR)
		EndIF
	EndIf
	dDataLanc := cNomeArq->DATALAN
	dbSkip( )
	
Enddo

IF lImp .Or. ;
	(li != 80 .and. ( nTotDeb != 0 .or. nTotCrd != 0 ) .And. !lEnd)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime totais do dia, para opcao de s¢ totais.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lResumido
		li:=li+1
		@ li,000 PSAY dDataLanc
		If !lImpItem .And. !lImpCC
			@ li,093 PSAY nDebitoDia      Picture tm(nDebitoDia,12,,lEstrang)
			@ li,106 PSAY nCreditDia      Picture tm(nCreditDia,12,,lEstrang)
			@ li,119 PSAY Abs(nSaldosDia) Picture tm(Abs(nSaldosDia),12,,lEstrang)
			@ li,131 PSAY Eval ( bSinal , nSaldosDia )
		Else
			ValorContab(nDebitoDia,li,109,17,,.F.,lEstrang)
			ValorContab(nCreditDia,li,131,17,,.F.,lEstrang)
			ValorContab(nSaldosDia,li,154,17,,.T.,lEstrang)
		EndIf
	EndIf
	
	li:=li+2
	@li, 30 PSAY "T o t a i s  d a  C o n t a  ==> "
	If !lImpItem .And. !lImpCC
		@li,093 PSAY nTotDeb        Picture tm(nTotDeb,12,,lEstrang)
		@li,106 PSAY nTotCrd        Picture tm(nTotCrd,12,,lEstrang)
		@li,119 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),12,,lEstrang)
		@li,131 PSAY Eval ( bSinal , nSaldoAtu )
	Else
		ValorContab(nTotDeb,li,109,17,,.F.,lEstrang)
		ValorContab(nTotCrd,li,131,17,,.F.,lEstrang)
		ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
	EndIf
	li:=li+1
	@li,00 PSAY Repl("-",nTamLinha)
	Li:=li+1
	Roda(cbcont,cbtxt,Iif(lImpItem .Or. lImpCC,"G",tamanho))
EndIF

If Li != 80 .Or. Select ( "cNomeArq" ) <> 0
	dbSelectArea("cNomeArq")
	Use
	Ferase(cNomeArq+".DBF")    	// Elimina arquivos de Trabalho
	Ferase(cNomeArq+OrdBagExt())	// Elimina arquivos de Trabalho
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
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function cr060Temp //( cDC, lCentroDeCusto , nValor)
Static Function cr060Temp //( cDC, lCentroDeCusto , nValor)()

cFlag :=""
cConta :=""
cCpar := ""
cContaRepl :=""
cCustoRepl :=""
cItemRepl  :=""

nValor:=Iif(nValor==NIL,SI2->I2_VALOR,nValor)
dbSelectArea ( "cNomeArq" )
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Caso o lan‡amento seja "X", define se ‚ cr‚dito ou d‚bito ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cDc := iIf ( SI2 -> I2_CREDITO == SI1 -> I1_CODIGO, "C", "D" )
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
IF lCentroDeCusto .And. cr060Join ( &cConta )
	cContaRepl := 	LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO) + ;
	Space(20-Len(LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO)))
Else
	cContaRepl := &cConta
EndIF
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Verifico o I1_NCUSTO se for cCentro de Custo Contabil     ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SI1->I1_NCUSTO != 0
	cCustoRepl := Subs(&cConta,Len(Trim(&cConta))+1-SI1->I1_NCUSTO,SI1->I1_NCUSTO)
Else
	cCustoRepl := Iif(cDC=="D",SI2->I2_CCD,SI2->I2_CCC)
Endif

cItemRepl	:= Iif(cDC=="D",SI2->I2_ITEMD,SI2->I2_ITEMC)

// Deve permitir imprimir registros repetidos, pois no caso de consolidacoes
// poderao existir lancamentos iguais!

Reclock("cNomeArq",.T.)
Replace DC     With cFlag
Replace HISTOR WITH SI2->I2_HIST
Replace NUMERO With SI2->I2_NUM
IF lCentroDeCusto .And. cr060Join ( &cConta )
	Replace CONTA WITH LEFT(&cConta,LEN(TRIM(&cConta))-SI1->I1_NCUSTO)
Else
	Replace CONTA With &cConta
EndIF
Replace CPAR    With &cCpar
Replace LINHA   With SI2->I2_LINHA
Replace VALOR   With nValor
Replace DATALAN With SI2->I2_DATA
Replace PERIODO With SI2->I2_PERIODO
Replace CCUSTO  With cCustoRepl
Replace ITEM	 With cItemRepl
Replace FILORIG With SI2->I2_FILORIG
Replace EMPORIG With SI2->I2_EMPORIG

MsUnlock()
Return ( "" )

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
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function cr060join //(cCodigo)
Static Function cr060join //(cCodigo)()

lRetorno  := .T.
nRegistro := 0
cArea     := ALias ()

dbSelectArea ( "SI1" )
nRegistro := SI1 -> ( Recno () )
SI1 -> ( dbSeek ( xFilial() + cCodigo ) )
lRetorno := ( SI1 -> I1_NCUSTO != 0 )
SI1 -> ( dbGoto ( nRegistro ) )

dbSelectArea ( cArea )

Return ( lRetorno )

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
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function cr060NoMov //(nMoeda,lImp)
Static Function cr060NoMov(nMoeda,lImp)

cConta := ""
nSal :=""
cAlias := Alias()
nReg := ""

If nMoeda == 1
   dbSelectArea("SI1")
Else
   dbSelectArea("SI7")
EndIf
nSal := CalcSaldo(Val(cMes17Ini)-1,nMoeda)
If lImp     // Imprime Contas Sem Movimento NO PERIODO (mv_par11 == 1)
	If (nSal) != 0      // .And. Int(nSal) == nSal)
		dbSelectArea ( "cNomeArq" )
		Reclock("cNomeArq",.t.)
		Replace HISTOR WITH "CONTA SEM MOVIMENTO NO PERIODO"
		Replace CONTA With SI1->I1_CODIGO
		MsUnlock()
	EndIf
EndIf
dbSelectArea(cAlias)

Return ( "" )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Cr060Sint ³ Autor ³ Alice Y. Yamamoto     ³ Data ³ 18.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a Conta sint‚tica Anterior                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cr060Sint()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONR060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Cr060Sint //(lEstrang)
Static Function Cr060Sint //(lEstrang)()
cOldArea := Alias()
nOldOrd	:= IndexOrd()
lSint    := .T.
nTamConta := 0  //Tamanho da Conta
nPosSI1  := 0  //Guarda a posicao no SI1

nPosSI1 := SI1->(Recno())
cContaSint   := cNomeArq->CONTA
cContaSint:=Alltrim(cContaSint)
nTamConta :=Len(cContaSint)
cContaSint:=Substr(cContaSint,1,nTamConta - 1 )
dbSelectArea("SI1")
dbSetOrder(1)

While lSint
	If	dbSeek(xFilial("SI1")+cContaSint)
		If SI1->I1_CLASSE =="S"
			If !lEstrang
				cDesc := SI1->I1_DESC
			Else
				cDesc := SI1->I1_DESCEST
			EndIf
			lSint := .F.
		Else
			nTamConta := nTamConta-1
			cContaSint:=Substr(cContaSint,1,nTamConta)
		Endif
	Endif
Enddo
dbGoTo(nPosSI1)
dbSelectArea(cOldArea)
dbSetOrder(nOldOrd)
Return(cContaSint)


// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> FUNCTION AjustaSx1
Static FUNCTION AjustaSx1()

cAlias:=Alias()
aPerg := {}
cPerg := "COR060"
Aadd(aPerg,{"No. Pag Reiniciar ? ","N",4})
dbSelectArea("SX1")
If !dbSeek(cPerg+"19")
	RecLock("SX1",.T.)
	Replace X1_GRUPO     with cPerg
	Replace X1_ORDEM     with "19"
	Replace X1_PERGUNT   with aPerg[1][1]
	Replace X1_VARIAVL   with "mv_chg"
	Replace X1_TIPO      with aPerg[1][2]
	Replace X1_TAMANHO   with aPerg[1][3]
	Replace X1_GSC       with "G"
	Replace X1_VAR01     with "mv_par19"
	Replace X1_CNT01     With "2"
EndIf

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Cr060Cabec³ Autor ³ Wagner Mobile Costa   ³ Data ³ 21.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o cabecalho do RAZAO                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Cr060Cabec()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CONR060                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function Cr060Cabec
Static Function Cr060Cabec()

/*
(Titulo, Tamanho, Cabec1, Cabec2, nQuebra, lSalto,;
                    nPagInicial, lImpItem, lImpCC, cContAnt, nSaldoAtu,;
                    lEstrang, bSinal, nReinicia, dDataFinal, lFirstPage,;
                    cDigVer, nCodNor, nSaldosDia)
*/

IF li>56 .or. lSalto
	lSalto:=.F.
	IF m_pag > nPagInicial .and. cContAnt==CONTA
		li:=li+1
		@li,102 PSAY "A TRANSPORTAR : "
		If !lImpItem .And. !lImpCC
			@li,119 PSAY Abs(nSaldoAtu) Picture  tm(Abs(nSaldoAtu),12,,lEstrang)
			@li,131 PSAY Eval ( bSinal , nSaldoAtu )
		Else
			ValorContab(nSaldoAtu,li,134,17,,.T.,lEstrang)
		EndIf
	EndIF
	If m_pag > m_pagfim
		m_pag := nReinicia
	EndIf
	CabecCont(Titulo,Cabec1,Cabec2,nomeprog,;
	Iif(lImpItem .Or. lImpCC,"G",Tamanho),;
	Iif(lImpItem .Or. lImpCC .or. aReturn[4]==1,GetMv("MV_COMP"),;
	GetMv("MV_NORM")),dDataFinal,lFirstPage)
	li:=9
	lFirstPage := .F.
	IF nQuebra == 1
		dbSelectArea("cNomeArq")
		cDescricao := if(lEstrang,Substr(SI1->I1_DESCEST,1,60),Substr(SI1->I1_DESC,1,60))
		IF cContAnt == CONTA
			If cDigVer == "S"
				@li,011 PSAY "CONTA - " + ;
				Iif(nCodNor==1.Or.Empty(SI1->I1_RES),;
				mascara(Alltrim(SI1->I1_CODIGO)+SI1->I1_DC),SI1->I1_RES)+"-"+;
				cDescricao
			Else
				@li,011 PSAY "CONTA - " + ;
				Iif(nCodNor==1.Or.Empty(SI1->I1_RES),;
				mascara(SI1->I1_CODIGO),SI1->I1_RES)+"-"+cDescricao
			EndIf
			@li,102 PSAY "DE TRANSPORTE : "
			If !lImpItem .And. !lImpCC
				@li,119 PSAY Abs(nSaldoAtu) Picture tm(Abs(nSaldoAtu),12,,lEstrang)
				@li,131 PSAY Eval ( bSinal , nSaldoAtu )
			Else
				ValorContab(nSaldoAtu,li,154,17,,.T.,lEstrang)
			EndIf
			nSaldosDia := nSaldoAtu
			li:=li+1
		EndIF
	EndIF
EndIF

Return
