#Include "Protheus.ch"

#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//Static lPmsInt:=(IsIntegTop(,.T.))
Static lMTA650AC  := ExistBlock('MTA650AC')
Static lIntSFC	:= ExisteSFC("SC2") .And. !IsInCallStack("AUTO650")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A250TudoOk³ Autor ³ Marcos Bregantim      ³ Data ³ 05/10/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa que faz consistencias apos a digitacao da tela    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA250                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o   ³ MontEstru³ Autor ³ Eveli Morasco         ³ Data ³ 09/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o³ Monta array com estrutura do produto                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontEstru(ExpC1,ExpN1,ExpD1,ExpC2,ExpN2,ExpC3,ExpL1,ExpC4, ³±±
±±³          ³           ExpL2,ExpC5,ExpC6,ExpC7)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade a ser explodida                         ³±±
±±³          ³ ExpD1 = Data Prevista de Entrega                           ³±±
±±³          ³ ExpC2 = Campo da Projecao de Estoques                      ³±±
±±³          ³ ExpN2 = Sequencia da OP                                    ³±±
±±³          ³ ExpC3 = Prioridade da OP                                   ³±±
±±³          ³ ExpL1 = Considera saldo em estoque (.T. Sim .F. Nao)       ³±±
±±³          ³ ExpC4 = String com opcionais selecionados                  ³±±
±±³          ³ ExpL2 = Indicador se gera uma unica OP por produto qdo     ³±±
±±³          ³         utiliza projecao de estoques                       ³±±
±±³          ³ ExpC5 = Tipo da Ordem de Producao                          ³±±
±±³          ³ ExpC6 = Revisao do Produto                                 ³±±
±±³          ³ ExpC7 = String com toda arvore para controle de opcionais  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function MGMontEstru(cProduto,nQuantPai,dEntrega,cCpoProj,cSeqPai,cPrior,lConsEst,cOpcionais,lOne,cTpOp,cRevisao,cStrOpc,aOPInt,cProOpc)
Static l650LocEmp

Local nR		:= 0
Local nRegSC2	:= 0
Local nQuantItem:= 0
Local nQtyStok	:= 0
Local nQtdBack	:= 0
Local nAchoOpc	:= 0
Local nNecessid := 0
//Local nToler	:= 0
//Local nQtdeTot	:= 0
Local nSG1		:= 0
//Local nRecSD4	:= 0
//Local nRecOpc	:= 0
Local nRecSB1	:= 0
Local nAchoSeq	:= 0
Local nBaixa    := 0
Local nEstSeg   := 0
Local i         := 0
Local nPeriodo  := 0
Local nSaldoSB2 := 0
Local nQtdSC    := 0
//Local nCount    := 0
Local nQtdPrj   := 0
Local nOpca		:= 3

Local aAlter    := {}
Local aObjects  := {}
Local aPosObj   := {}
Local aScAglu   := {}
Local aQtdes    := {}
Local aSalvRot	:= {}
Local aSalvCols	:= {}
Local aSeq		:= {}
Local aOps		:= {}
//Local aTravas	:= {}
Local aButtons  := {}
Local aRetPE	:= {}

Local cLocalSC1	 := ""
Local cPeriodoOpc:= ""
Local cOldTipo   := ""
Local cLocAnt    := ""
Local cRevAtu    := ""
Local cSeqC2Aux	 := ""

//Local lLocaliza	:= .F.
Local lPrevista := .F.
Local lRastroLoc:= .T.
Local lRetBlock	:= .T.
Local lOkPeri   := .T.

Local cDesc		 := SB1->B1_DESC
Local nSalB1     := SB1->(Recno())
Local lAltEmp    := (SubStr( cAcesso,37,1 ) == "S")
Local lExistBlkT := ExistTemplate("A650SALDO")
Local lA650CCF   := ExistBlock("A650CCF")
Local lExistBlock:= ExistBlock("A650SALDO")
Local lBlockOPI  := ExistBlock("A650OPI")
Local lMA650SAL  := ExistBlock("MA650SAL")
Local lA650REVEM := ExistBlock("A650REVEM")
Local lMA650SEQ  := ExistBlock("MA650SEQ")
Local lEMP650    := ExistBlock( "EMP650" )
Local lM650BUT   := ExistBlock( "M650BUT" )
Local lMA650EMP  := ExistBlock( "MA650EMP" )
Local lMA650Dlg	 := ExistBlock("MA650DLG")
Local lA650ALTD4 := ExistBlock("A650ALTD4")
//Local lEstNeg    := IF(GETMV("MV_ESTNEG")=="S",.T.,.F.)
Local cLocProc   := SuperGetMV("MV_LOCPROC",.F.,"99")
Local lEmpPrj    := SuperGetMV("MV_EMPPRJ",.F.,.T.)
Local lEmpBN 	 := SuperGetMV("MV_EMPBN",.F.,.F.)
Local lEstMax    := lProj711 .And. aPergs711[19] == 2 .And. aPergs711[1] == 1
Local aSize      := MsAdvSize()
Local aInfo      := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local lEvento001 := MExistMail("001")
Local laSAv651   := TYPE("aSAv651") == 'A'
Local aNegEst	 := {}
Local cFormMRP   := ""
Local lRetPe 	 := .T.
Local aOpcCam    := {}

Local nX,cOp,cTipo,lProjIni,nY
Local aComplCols
Local lGeraSc,lGeraOPI
Local oGet,oDlg2
Local cTitulo
Local lProj
Local cD4_OPORIG  := ''
Local aAreaSH5 := If (lProj711 .And. !lMata712 .And. !lPCPA107, SH5->(GetArea()),nil)
Local aAreaCZI := If (lMata712, CZI->(GetArea()),nil)
Local aAreaSOQ := If (lPCPA107, SOQ->(GetArea()),Nil)
Local lExistComp
Local nInd       := 0

Local cEventID   := 0    // Variavel usada para armazenar o ID do EventViewer
Local cMensagem  := " " // Variavel para armazenar a mensagem utilizada no eventviewer

Local aErros     := {}

Default aOPInt    := {}
Default cProOpc   := cProduto 

Private cLocCQ    := GetMV('MV_CQ')
Private aCols     := {}
Private aColsDele := {}

Private lConsNPT  := .F.
Private lConsTerc := .F.
PRIVATE aAltSaldo := {}
Private aLotesUsado := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na geracao de SCS aglutinadas por data  ³
//³ de necessidade.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aDataOPC1:={},aDataOPC7:={},aOPC1:={},aOPC7:={}

If Select('SH5') > 0
	aAreaSH5 := SH5->(GetArea())
EndIf

lAltEmp 	:= If( (ValType( lAltEmp ) # "L"),.F.,lAltEmp )
l650LocEmp 	:= If(ValType(l650LocEmp)#"L",ExistBlock("A650LEMP"),l650LocEmp)

If TYPE("aRotina") == "A"
	aSalvRot := aClone(aRotina)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento da variavel "aSav650", que armazena as perguntas MTA650  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(Type('aSav650')=='A') .Or. !Empty(AsCan(aSav650,{|x|x == NIL}))
	aSav650 := Array(20)
	MTA650PERG(.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a rotina esta sendo chamada da Proj.Estoques NOVA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lProj711:=If(Type("lProj711") == "L",lProj711,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se a chamada da funcao vier da projecao, verifica se    ³
//³ e' Projecao pelo inicio :                               ³
//³ Se Sim nao gera op dos filhos e solicitacao de compra.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lProj	 := If(  cCpoProj == NIL ,.F.,.T.)
lProjIni := If( (cCpoProj == NIL),.F.,If(cCpoProj == "INICIO",.T.,.F.) )
lConsEst := If( (lConsEst == NIL),(GetMV("MV_CONSEST") == "S"),lConsEst )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se a chamada da funcao vier da projecao, verifica se    ³
//³ e' Projecao, quanto a geracao da sc (nPar02 - PRIVATE)  ³
//³ 1 - Gera Sc no Mata650   2 - Gera SC no MATA710         ³
//³ quanto a geracao da OP PI (nPar03 - PRIVATE)            ³
//³ 1 - Gera OP de PI (Mata650)  2 - Gera OP de PI (MATA710)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCpoProj != NIL
	If nPar02 == 2
		lGeraSc := .F.
	Else
		lGeraSC := .T.
	Endif
	If nPar03 == 2
		lGeraOPI:= .F.
	Else
		lGeraOPI:= .T.
	Endif
ElseIf lProj711
	cFormMRP := Posicione("SB5",1,xFilial("SB5")+cProduto,"B5_FORMMRP")
	If cFormMRP $ ' 1'
		lGeraSC  := aPergs711[2] == 1
		lGeraOPI := aPergs711[3] == 1
	Else
		lGeraSC  := cFormMRP == '2'
		lGeraOPI := cFormMRP == '2'
	EndIf
Else
	lGeraSc := GETMV("MV_GERASC")
	lGeraOPI:= GETMV("MV_GERAOPI")

	//-- Verifica se ha flag no array da execauto para nao gerar SCs
	If l650Auto .And. (i := aScan(aRotProd,{|x| AllTrim(x[1]) == "GERASC"})) > 0 .And. ValType(aRotProd[i,2]) == "C"
		lGeraSc := aRotProd[i,2] == "S"
	EndIf

	//-- Verifica se ha flag no array da execauto para nao gerar OPIs
	If l650Auto .And. (i := aScan(aRotProd,{|x| AllTrim(x[1]) == "GERAOPI"})) > 0 .And. ValType(aRotProd[i,2]) == "C"
		lGeraOPI := aRotProd[i,2] == "S"
	EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava nas Ops filhas o numero da sequencia da Op Pai    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSeqPai := IIf(cSeqPai != NIL,cSeqPai,"000")
cPrior  := IIf(cPrior != NIL,cPrior,"500")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega o numero da OP que serao gerados os empenhos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOp := cC2_NUM+cC2_ITEM+cC2_SEQUEN+cC2_ITEMGRD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza OP Prevista                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lPrevista := cC2_TPOP == 'P'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o array aCols verificando se existem produtos     ³
//³ fantasma na estrutura.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRotina   := { { "" , "        ", 0 , 3}}

// Verifica se tem que zerar o aHeader
if !IsInCallStack('MATA760')
	If lZrHeader
		lZrHeader := .F.
		aHeader := {}
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do AHeader.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('aHeader')<>'A' .Or. (Type('aHeader')=='A' .And. Len(aHeader)==0) .Or. lMTA650AC
	PRIVATE aHeader := {}
	aTam:=TamSX3("G1_COMP")	//1
	Aadd(aHeader,{"Componente","G1_COMP" ,PesqPict("SG1","G1_COMP" ,atam[1]),aTam[1],aTam[2],"NaoVazio() .And. ExistCpo('SB1') .And. M->G1_COMP != '"+cProduto+"' .And. A650IniPrd()",USADO, "C" ,"SG1"," " })
	aTam:=TamSX3("D4_QUANT")//2
	Aadd(aHeader,{"Quantidade Empenho","D4_QUANT",PesqPict("SD4","D4_QUANT",atam[1]),aTam[1],aTam[2],"A650ConvUM(2) .And. M->D4_QUANT # 0 .And. A650VlQtNg() .And. A380TipDec(aCols[n,1],aCols[n,2],aCols[n,2],2)",USADO, "N" ,"SD4"," " })
	aTam:=TamSX3("D4_LOCAL")//3
	Aadd(aHeader,{"Local","D4_LOCAL",PesqPict("SD4","D4_LOCAL",atam[1]),aTam[1],aTam[2],"NaoVazio() .And. existcpo('SB2',aCols[n,1]+M->D4_LOCAL) .And. M->D4_LOCAL <> cLocCQ .And. ValLocProc(aCols[n,1])",USADO, "C" ,"SD4"," " })
	aTam:=TamSX3("G1_TRT")	//4
	Aadd(aHeader,{"Sequencia","G1_TRT"  ,PesqPict("SG1","G1_TRT"  ,atam[1]),aTam[1],aTam[2],"A650Seq()",USADO, "C" ,"SG1"," " })
	aTam:=TamSX3("D4_NUMLOTE")//5
	Aadd(aHeader,{"Sub-Lote","D4_NUMLOTE",PesqPict("SD4","D4_NUMLOTE",atam[1]),aTam[1],aTam[2],"A650LotCTL()",USADO, "C" ,"SD4"," " })
	aTam:=TamSX3("D4_LOTECTL")//6
	Aadd(aHeader,{"Lote","D4_LOTECTL",PesqPict("SD4","D4_LOTECTL",atam[1]),aTam[1],aTam[2],"A650LotCTL()",USADO, "C" ,"SD4"," " })
	aTam:=TamSX3("D4_DTVALID")//7
	Aadd(aHeader,{"Data de Validade","D4_DTVALID",PesqPict("SD4","D4_DTVALID",atam[1]),aTam[1],aTam[2]," ",USADO, "D" ,"SD4"," " })
	aTam:=TamSX3("D4_POTENCI")//8
	Aadd(aHeader,{"Potencia","D4_POTENCI",PesqPict("SD4","D4_POTENCI",atam[1]),aTam[1],aTam[2]," ",USADO, "N" ,"SD4"," " })
	aTam:=TamSX3("DC_LOCALIZ")//9
	Aadd(aHeader,{"Localizacao","DC_LOCALIZ",PesqPict("SDC","DC_LOCALIZ" ,atam[1]),aTam[1],aTam[2],"Vazio() .Or. (ExistCpo('SBE',aCols[n,3]+M->DC_LOCALIZ) .And. A650VldLoclz(." + If(lConsEst, "T", "F") + ".))",USADO, "C" ,"SBE"," " })
	aTam:=TamSX3("DC_NUMSERI")//10
	Aadd(aHeader,{"Num de Serie","DC_NUMSERI",PesqPict("SDC","DC_NUMSERI" ,atam[1]),aTam[1],aTam[2],"",USADO, "C" ,""," " })
	aTam:=TamSX3("B1_UM")//11
	Aadd(aHeader,{"1a. UM","B1_UM",PesqPict("SB1","B1_UM",atam[1]),aTam[1],aTam[2],,USADO, "C" ,"SB1","V" })
	aTam:=TamSX3("D4_QTSEGUM")//12
	Aadd(aHeader,{"Quantidade Empenho 2a. UM","D4_QTSEGUM",PesqPict("SD4","D4_QTSEGUM",atam[1]),aTam[1],aTam[2],"A650ConvUM(1)",USADO, "N" ,"SD4"," " })
	aTam:=TamSX3("B1_SEGUM")//13
	Aadd(aHeader,{"2a. UM","B1_SEGUM",PesqPict("SB1","B1_SEGUM",atam[1]),aTam[1],aTam[2],,USADO, "N" ,"SB1"," " })
	aTam:=TamSX3("B1_DESC")	//14
	Aadd(aHeader,{"Descrição","B1_DESC" ,PesqPict("SB1","B1_DESC" ,atam[1]),aTam[1],aTam[2],,USADO, "C" ,"SB1"," " })
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Execblock Para Inserir Campo em aCols - MTA650AC        ³
//³ 1 - Complemento do aHeader                              ³
//³ 2 - Conteudo do aCols                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMTA650AC
	aComplCols := ExecBlock('MTA650AC',.F.,.F.)
Else
	aComplCols := {{},}
EndIf

If Len(aComplCols[1]) != 0
	Aadd(aHeader,aComplCols[1])
EndIf

nPosCod    :=aScan(aHeader,{|x| AllTrim(x[2])=="G1_COMP"})
nPosQuant  :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_QUANT"})
nPosLocal  :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOCAL"})
nPosTrt    :=aScan(aHeader,{|x| AllTrim(x[2])=="G1_TRT"})
nPosLote   :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_NUMLOTE"})
nPosLotCTL :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_LOTECTL"})
nPosDValid :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_DTVALID"})
nPosPotenc :=aScan(aHeader,{|x| AllTrim(x[2])=="D4_POTENCI"})
nPosLocLz  :=aScan(aHeader,{|x| AllTrim(x[2])=="DC_LOCALIZ"})
nPosnSerie :=aScan(aHeader,{|x| AllTrim(x[2])=="DC_NUMSERI"})
nPosUM     :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_UM"})
nPosQtSegum:=aScan(aHeader,{|x| AllTrim(x[2])=="D4_QTSEGUM"})
nPos2UM    :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_SEGUM"})
nPosDescr  :=aScan(aHeader,{|x| AllTrim(x[2])=="B1_DESC"})

A650ACols(cProduto,nQuantPai,cOpcionais,lConsEst,cRevisao,aComplCols[2],aHeader,cLocProc,cProOpc,@aOpcCam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pontos de Entrada   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistTemplate( "EMP650" ) )
	ExecTemplate("EMP650",.F.,.F.,{cStrOpc})
EndIf

If lEMP650
	ExecBlock("EMP650",.F.,.F.,{cStrOpc})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre o array aCols verificando se existem produtos     ³
//³ com o mesmo nivel e sequencia na estrutura. Caso isso   ³
//³ ocorra, soma o nivel do segundo para n„o gerar divergen ³
//³ cias na hora da producao.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i:=1 To Len(aCols)
	If !aCols[i,Len(aCols[i])]
		nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosnSerie])
		IF nAchoSeq > 0
			aCols[i,nPosTrt]:=Soma1(aCols[i,nPosTrt])
			nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosnSerie])
			While nAchoSeq > 0
				aCols[i,nPosTrt]:=Soma1(aCols[i,nPosTrt])
				nAchoSeq:=ASCAN(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosNserie])
			EndDo
			AADD(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosnSerie])
		Else
			AADD(aSeq,aCols[i,nPosCod]+aCols[i,nPosTrt]+aCols[i,nPosLote]+aCols[i,nPosLotCtl]+aCols[i,nPosLocLz]+aCols[i,nPosnSerie])
		Endif
	EndIf
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva em aSalvCols o array aCols para copia de seguranca.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSalvCols := AClone(aCols)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PE para alterar a qtde. de empenho antes da tela             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType(lA650ALTD4)=='L' .And. lA650ALTD4
	ExecBlock("A650ALTD4",.F.,.F.,{cStrOpc})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso usuario deseje alterar empenho, monta GetDados.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAltEmp .And. Len(aCols) > 0 .And. aSav650[13] == 1 .And. (!Type('l650Auto')=='L' .Or. !l650Auto)
	Private aTELA[0,0],aGETS[0]
	Private nUsado := 5
	nPosAtu:=0
	nPosAnt:=9999
	nColAnt:=9999
	n      := 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ativa tecla F4 para comunicacao com Saldos dos Lotes         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Set Key VK_F4 TO ShowF4()
	If lMTA650AC
		cTitulo:=OemToAnsi("Alteração de Empenho - "+Trim(cProduto)+ " - "+Trim(cDesc)+" / "+cOp)
	Else
		cTitulo:=OemToAnsi("Alteração de Empenho - "+AllTrim(cProduto)+" / "+cOp)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa ponto de entrada para montar array com botoes a      ³
	//³ serem apresentados na tela de alteracao de empenho           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lM650BUT
		aButtons:=ExecBlock("M650BUT",.F.,.F.)
		If ValType(aButtons) # "A"
			aButtons:={}
		EndIf
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Botao para exportar dados para EXCEL                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If RemoteType() == 1
		aAdd(aButtons   , {PmsBExcel()[1],{|| DlgToExcel({ {"GETDADOS",cTitulo,aHeader,aCols}})},PmsBExcel()[2],PmsBExcel()[3]})
	EndIf
	If ( Type("l650Auto") # "L" .or. !l650Auto ) .And. !IsInCallStack("U_MA650TOK")
		For i := 1 to Len(aHeader)
			If ! aHeader[i,2] $ "B1_UM, B1_SEGUM"
				Aadd(aAlter, aHeader[i,2])
			Endif
		Next
		nOpca := 0
		AADD(aObjects,{100,100,.T.,.T.,.F.})
		aPosObj:=MsObjSize(aInfo,aObjects)
		If lMA650Dlg
			lRetPe := ExecBlock("MA650DLG",.F.,.F.)
			If ValType (lRetPe) != "L"
				lRetPe := .T.
			EndIf
		EndIf
		If lRetPe
			DEFINE MSDIALOG oDlg2 TITLE ctitulo OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
		Else
			DEFINE MSDIALOG oDlg2 TITLE ctitulo OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5] STYLE DS_MODALFRAME
		EndIf
		oGet := MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],1,"A650LinOk","A650AETdOk","",.T.,,,,1024) // Aumentado numero maximo de linhas na GetDados
		oGet:oBrowse:aAlter := aAlter
		If lRetPe
			ACTIVATE MSDIALOG oDlg2 ON INIT (EnchoiceBar(oDlg2,{||If(A650AETdOk(),(nopca:=1,oDlg2:End()),.F.)},{||oDlg2:End()},,aButtons),A650DelCols(oGet:oBrowse))
		Else
			ACTIVATE MSDIALOG oDlg2 ON INIT (EnchoiceBar(oDlg2,{||If(A650AETdOk(),(nopca:=1,oDlg2:End()),.F.)},{||.T.},,aButtons),A650DelCols(oGet:oBrowse))
		EndIf
	Else
		nopca:=1
	EndIF
	If nOpca == 0
		aCols := AClone(aSalvCols)
	Else
		aSalvCols:=AClone(aCols)
	EndIf
	Set Key VK_F4 TO
EndIf

lMV_GERAPI  := SuperGetMv("MV_GERAPI")
lMV_GRVLOCP := SuperGetMV("MV_GRVLOCP",.F.,.T.)

For nSG1 := 1 to Len(aSalvCols)
	If aSalvCols[nSG1,Len(aSalvCols[nSG1])] .Or. Empty(aSalvCols[nSG1,1])
		Loop
	Endif
	aQtdes     := {}
	nQuantItem := aSalvCols[nSG1,nPosQuant]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona SB1                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+aSalvCols[nSG1,nPosCod])
	cRoteiro:= SB1->B1_OPERPAD

	If QtdComp(nQuantItem,.T.) == QtdComp(0)
		Loop
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida Armazem de CQ                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aSalvCols[nSG1,nPosLocal] == cLocCQ
		aSalvCols[nSG1,nPosLocal] := RetFldProd(SB1->B1_COD,"B1_LOCPAD")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona SB2                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB2")
	dbSetOrder(1)
	MsSeek(xFilial("SB2")+aSalvCols[nSG1,nPosCod]+If (SB1->B1_APROPRI == 'I', SB1->B1_LOCPAD, aSalvCols[nSG1,nPosLocal]))
	If Eof()
		CriaSB2(aSalvCols[nSG1,nPosCod],aSalvCols[nSG1,nPosLocal])
		MsUnlock()
	EndIf
	If mv_par02 = 1 .And. cCpoProj == NIL .And. !lProj711
		If lConsEst
			If !lEmpPrj
				nQtdPrj := SB2->B2_QEMPPRJ
			EndIf
			nQtyStok := SaldoSB2(.T., , ,lConsTerc,lConsNPT,,,nQtdPrj)+SB2->B2_SALPEDI-SB2->B2_QEMPN+AvalQtdPre("SB2",2)
			If lPrevista .And. ( nQtyStok > SB2->B2_QEMPPRE )
				nQtyStok -= SB2->B2_QEMPPRE
			Endif
			nQtyStok += A650Prev(SB2->B2_COD)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa P.E. para tratar saldo disponivel.                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lExistBlkT
				nQtdBack:=nQtyStok
				nQtyStok:=ExecTemplate("A650SALDO",.F.,.F.,nQtyStok)
				If ValType(nQtyStok) != "N"
					nQtyStok:=nQtdBack
				EndIf
			EndIf
			If lExistBlock
				nQtdBack:=nQtyStok
				nQtyStok:=ExecBlock("A650SALDO",.F.,.F.,nQtyStok)
				If ValType(nQtyStok) != "N"
					nQtyStok:=nQtdBack
				EndIf
			EndIf
		Else
			nQtyStok := 0
		Endif
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona SB2                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nQtyStok := 0
		If cCpoProj <> NIL
			nQtyStok:=A650SldMRP(.F.,.T.,aSalvCols[nSG1,nPosCod],dEntrega,cOpcionais)
		ElseIf lProj711 .And. nQuantItem > 0
			nQtyStok:=Max(A650SldMRP(.T.,.F.,aSalvCols[nSG1,nPosCod],dEntrega,cOpcionais)+nQuantItem,0)
		ElseIf lConsEst
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial("SB2")+aSalvCols[nSG1,nPosCod]+mv_par03,.T.)
			While !Eof() .And. SB2->B2_FILIAL+SB2->B2_COD+SB2->B2_LOCAL <= xFilial("SB2")+aSalvCols[nSG1,nPosCod]+mv_par04
				If !lEmpPrj
					nQtdPrj := SB2->B2_QEMPPRJ
				EndIf
				nQtyStok += SaldoSB2(.T., , ,lConsTerc,lConsNPT,,,nQtdPrj)+SB2->B2_SALPEDI-SB2->B2_QEMPN+AvalQtdPre("SB2",2)
				nQtyStok += A650Prev(SB2->B2_COD)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa P.E. para tratar saldo disponivel.                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lExistBlkT
					nQtdBack:=nQtyStok
					nQtyStok:=ExecTemplate("A650SALDO",.F.,.F.,nQtyStok)
					If ValType(nQtyStok) != "N"
						nQtyStok:=nQtdBack
					EndIf
				EndIf

				If lExistBlock
					nQtdBack:=nQtyStok
					nQtyStok:=ExecBlock("A650SALDO",.F.,.F.,nQtyStok)
					If ValType(nQtyStok) != "N"
						nQtyStok:=nQtdBack
					EndIf
				EndIf
				dbSkip()
			End
			dbSelectArea("SB2")
			dbSetOrder(1)
			MsSeek(xFilial("SB2")+aSalvCols[nSG1,nPosCod]+aSalvCols[nSG1,nPosLocal])
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula necessidade para o produto     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lProj711
		If laSAv651
			If aSav651[26] == 1
				// --- Verifica Estoque de Seguranca (B1_ESTSEG)
				nEstSeg := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
				nQtyStok -= nEstSeg
			EndIf
		Else
			// --- Verifica Estoque de Seguranca (B1_ESTSEG)
			nEstSeg := CalcEstSeg( RetFldProd(SB1->B1_COD,"B1_ESTFOR") )
			nQtyStok -= nEstSeg
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para considerar somente uma vez o Estoque de Seguranca ³
		//³quando parametrizado para Aglut. SCs "Por OP" ou "Por Data Nece"  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If QtdComp(nEstSeg) > QtdComp(0) .And. aSav650[06] <> 1
			If aSav650[06] == 2
				aScAglu := aClone(aOpc1)
			ElseIf aSav650[06] == 3
				aScAglu := aClone(aDataOpC1)
			EndIf
			nQtdSC := 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³A verificacao de saldo de SCs anteriores		  			|
			//³foi retirada, pois isso ja eh feito na funcao A650Prev   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		EndIf
	EndIf

	If nQuantItem < 0
		nNecessid := nQuantItem
	Else
		nNecessid := IIF(nQtyStok >= nQuantItem,0,nQuantItem - nQtyStok)
	EndIf
	
	If nQtyStok < nQuantItem
		lBloqueia := .T.
		
		// Posiciona no Cadastro do Grupo
		SBM->(dbSetOrder(1))
		If !Empty(SB1->B1_XGRUPO) .And. SBM->(FieldPos("BM_XVSDOP")) > 0 .And. SBM->(dbSeek(XFILIAL("SBM")+SB1->B1_XGRUPO))
			lBloqueia := (SBM->BM_XVSDOP == "S")   // Define se valida o saldo de OP para o produto
		Endif
		
		If lBloqueia
			AADD(aErros,{SB1->B1_COD,SB2->B2_LOCAL,cValToChar(nQuantItem),cValToChar(nQtyStok),"Saldo insuficiente no estoque", Nil, Nil})
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se envia e-mail ref. PONTO DE PEDIDO - 001³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEvento001 .And. nQuantItem > 0 .And. !(SB2->B2_LOCAL == cLocCQ) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_EMIN"))
		nSaldoSB2 := SALDOSB2(.T.,.T.,dDataBase)+SB2->B2_SALPEDI+SB2->B2_QACLASS
		nSaldoSB2 += A650Prev(SB2->B2_COD)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para validar saldo em TODOS os armazens³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMA650SAL
			nSaldoSB2 := ExecBlock('MA650SAL',.F.,.F.)
			nSaldoSB2 := IIf(Valtype(nSaldoSB2) <> "N", 0, nSaldoSB2)
		EndIf
		If (nSaldoSB2 - nQuantItem) <= RetFldProd(SB1->B1_COD,"B1_EMIN")
			dbSelectarea("SXI")
			dbsetorder(2)
			cEventID  := "001" //Ponto de pedido
			If msSeek('002' + '001' + cEventID)
				cMensagem:="O produto "+SB1->B1_COD+" - "+SB1->B1_DESC+" atingiu a quantidade de "
				cMensagem+= Str(nSALDOSB2 + (nSaldoSB2 - nQuantItem))+" (armazém "+SB2->B2_LOCAL+"), abaixo do Ponto de Pedido de "+ Str(RetFldProd(SB1->B1_COD,"B1_EMIN"))
				EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,""/*cCargo*/,"STR0179",cMensagem,.T./*lPublic*/)
			Else
				MEnviaMail("001",{SB1->B1_COD,SB1->B1_DESC,SB2->B2_LOCAL,(nSaldoSB2 - nQuantItem),RetFldProd(SB1->B1_COD,"B1_EMIN")})
			EndIf
		EndIf
	EndIf

	dbSelectArea("SG1")
	If MsSeek(xFilial("SG1")+aSalvCols[nSG1,nPosCod])
		lExistComp := .F.
		While !Eof() .And. G1_FILIAL == xFilial("SG1") .And. aSalvCols[nSG1,nPosCod] == SG1->G1_COD
			If aSalvCols[nSG1,nPosCod] == SG1->G1_COD .And. dEntrega <= SG1->G1_FIM .And. dEntrega >=SG1->G1_INI
				lExistComp := .T.
				Exit
			EndIf
			dbskip()
		End

		If lExistComp
			cTipo := "F"
		Else
	  		cTipo := "C"
		EndIf
	ElseIf !lProj711 .And. IsNegEstr(aSalvCols[nSG1,nPosCod],,,cProduto)[1] //Sub-produto
		cTipo := "S"
	Else
		cTipo := "C"
	Endif
	If cTipo $ "FS" .And. !lMV_GERAPI .And. RetFldProd(SB1->B1_COD,"B1_MRP") == "N" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
		cTipo := "I"
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa execblock para verificar se     ³
	//³ produto sera fabricado ou comprado      ³
	//³ "COMPONENTE FABRICADO OU COMPRADO"      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lA650CCF
		cOldTipo:=cTipo
		cTipo:=ExecBlock("A650CCF",.F.,.F.,{aSalvCols[nSG1,nPosCod],cTipo,dC2_DATPRI,nSG1})
		If !(ValType(cTipo) == "C") .Or. !(cTipo $ "FCI")
			cTipo:=cOldtipo
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto eh intermediario  ³
	//³ e se deve ou nao considerar o armazem de³
	//³ processo na geracao de SCs              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SB1->B1_APROPRI == "I"
		If lMV_GRVLOCP
			cLocalSC1:= cLocProc
		Else
			cLocalSC1:= RetFldProd(SB1->B1_COD,"B1_LOCPAD")
		EndIf
	Else
		cLocalSC1:= aSalvCols[nSG1,nPosLocal]
	EndIf

	nRecSB1:=SB1->(Recno())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Permite alterar o local atraves de P.E. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l650LocEmp
		cLocAnt:=ExecBlock("A650LEMP",.F.,.F.,aSalvCols[nSG1])
		If ValType(cLocAnt) == "C" .And. Len(cLocAnt) == Len(aSalvCols[nSG1,nPosLocal])
			aSalvCols[nSG1,nPosLocal]:=cLocAnt
			If SB1->B1_APROPRI == "I"
				If lMV_GRVLOCP
					cLocalSC1:= cLocProc
				Else
					cLocalSC1:= RetFldProd(SB1->B1_COD,"B1_LOCPAD")
				EndIf
			Else
				cLocalSC1:= aSalvCols[nSG1,nPosLocal]
			EndIf
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se Lote do Empenho ja foi preenchido ou   ³
	//³ se a Localizacao do Empenho ja foi preenchida      ³
	//³ Caso ja tenha sido, o estoque ja foi verificado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRastroLoc:=.T.
	If Rastro(aCols[nSG1,nPosCod],"S")
		lRastroLoc:=Empty(aCols[nSG1,nPosLote]).And.Empty(aCols[nSG1,nPosLotCtl])
	ElseIf Rastro(aCols[nSG1,nPosCod],"L")
		lRastroLoc:=Empty(aCols[nSG1,nPosLotCtl])
	EndIf
	If lRastroLoc .And. Localiza(aCols[nSG1,nPosCod])
		lRastroLoc:=Empty(aCols[nSG1,nPosLocLz]).And.Empty(aCols[nSG1,nPosNSerie])
	EndIf

	If lProj711
		nPeriodo := Val(A650DtoPer(dEntrega))
		If cTipo == "C" .And. lGeraSC
			lOkPeri := Substr(cSelPerSC,nPeriodo,1) == "û"
		Endif
		If cTipo == "F" .And. lGeraOPI
			lOkPeri :=  Substr(cSelPer,nPeriodo,1)   == "û"
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera Solicitacoes de Compras ou OPs intermediarias ³
	//³ caso haja necessidade.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nNecessid > 0 .And. lRastroLoc .And. lOkPeri
		If cTipo == "F"
			nAchoOpc:=ASCAN(aRetorOpc,{|x| x[1] == cStrOpc+aCols[nSG1,nPosCod]+aCols[nSG1,nPosTRT] })
			If nAchoOpc > 0
				cOpcionais:=aRetorOpc[nAchoOpc,2]
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica ponto de entrada para gerar ou nao OPs    ³
			//³ intermediarias                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lBlockOPI
				lRetBlock:=ExecBlock("A650OPI",.F.,.F.,nSG1)
				If ValType(lRetBlock) # "L"
					lRetBlock:=.T.
				EndIf
			EndIf
			If lGeraOPI .And. lRetBlock .And. RetFldProd(SB1->B1_COD,"B1_FANTASM") != "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
				aOps:={}
				aQtdes := CalcLote(aSalvCols[nSG1,nPosCod],nNecessid,"F")
				If lEstMax
					aQtdes := A711LotMax(aSalvCols[nSG1,nPosCod], nNecessid, aQtdes)
				Endif
				If laSAv651
			    	If Asav651[19] == 2
					   aQtdes := {nNecessid}
					EndIF
				EndIf
				nRegSC2 := SC2->(RecNo())
				SB1->(MsGoto(nRecSB1))
				For nX := 1 To Len(aQtdes)
					If !((RetFldProd(SB1->B1_COD,"B1_FANTASM") == "S") .Or. (cTipo == "F" .And. !lMV_GERAPI))  // Projeto Implementeacao de campos MRP e FANTASM no SBZ
						IF (cCpoProj != NIL .and. RetFldProd(SB1->B1_COD,"B1_MRP") $ " S") .or. cCpoProj = NIL // Projeto Implementeacao de campos MRP e FANTASM no SBZ
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Caso gere Ordem de Producao pela projecao³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lProj .And. nPar10 == 2
								cPeriodoOpc:=A650DtoPer(dEntrega)
								dbSelectArea("OPC")
								dbSetOrder(2)
								If dbSeek(cPeriodoOpc+cProduto+aSalvCols[nSG1,nPosCod]+cOpcionais)
									RecLock("OPC",.F.)
									Replace QUANTIDADE With QUANTIDADE - aQtdes[nx]
									MsUnlock()
								EndIf
							EndIf
							cSeqC2:=Soma1(cSeqC2,Len(cC2_SEQUEN))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Ponto de entrada para Alterar a sequencia ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						 	If lMA650SEQ
						  		cSeqC2Aux := ExecBlock("MA650SEQ",.F.,.F.)
								If Valtype(cSeqC2Aux) == "C"
							  		cSeqC2 := cSeqC2Aux
								EndIf
							EndIf
							cItemGrd := cC2_ITEMGRD
							cGrade := cC2_GRADE
							If !lOne
								cRevAtu := SB1->B1_REVATU
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Ponto de Entrada para alterar a Revisao da estrutura  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If lA650REVEM
									aRetPE := ExecBlock("A650REVEM",.F.,.F.,{cRevAtu})
									If ValType(aRetPE) == "A" .And. !Empty(aRetPE[1])
										cRevAtu := aRetPE[1]
									EndIf
								EndIf
								AADD(aOps,cC2_NUM+cC2_ITEM+cC2_SEQUEN+cC2_ITEMGRD)
								AADD(aOPInt, {cC2_PRODUTO, cC2_NUM+cC2_ITEM+cC2_SEQUEN+cC2_ITEMGRD, (nC2_QUANT - nQuantItem) } )
								dbSelectArea("SG1")
								nR := RecNo()
								MontEstru(aSalvCols[nSG1,nPosCod],aQtdes[nX],dC2_DATPRI,cCpoProj,cSeqC2,cC2_PRIOR,lConsEst,cOpcionais,lOne,cTpOp,cRevAtu,cStrOpc+aCols[nSG1,nPosCod]+aCols[nSG1,nPosTRT],@aOPInt,If(Len(aOpcCam)<=nSG1,aSalvCols[nSG1,nPosCod],aOpcCam[nSG1]))
							EndIf
						EndIf
					EndIf
				Next nX
				SC2->(dbGoTo(nRegSC2))
			EndIf
		ElseIf cTipo == "C" .And. (SB1->B1_TIPO # "BN" .Or. MatBuyBN())
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se deve quebrar pelo Lote Economico ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If lEstMax
				nNecessid := Min(nNecessid, A711Lote(nQuantItem,aSalvCols[nSG1,nPosCod]) + IIF(lMata712,A712RetVld(aSalvCols[nSG1,nPosCod], dEntrega, "1"),AReadSha(aSalvCols[nSG1,nPosCod],dEntrega,"1")) - nQuantItem)
			Endif

			// Aglutina SC por OP
			If aSav650[06] == 2
				aQtdes := { nNecessid }
			Else
				aQtdes := CalcLote(aSalvCols[nSG1,nPosCod],nNecessid,"C")
			EndIf

			If laSAv651
				If aSav651[19] == 2
					aQtdes := { nNecessid }
				EndIf
			EndIf

			If lEstMax
				aQtdes := A711LotMax(aSalvCols[nSG1,nPosCod], nNecessid, aQtdes)
			Endif
			If !IsProdMod(aSalvCols[nSG1,nPosCod])
				If lGeraSc
					IF (cCpoProj != NIL .and. RetFldProd(SB1->B1_COD,"B1_MRP") $" S") .Or. cCpoProj = NIL // Projeto Implementeacao de campos MRP e FANTASM no SBZ
						For nX := 1 To Len(aQtdes)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Baixa quantidade do arquivo de opcionais       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lProj .And. nPar10 == 2
								dbSelectArea("OPC")
								dbSetOrder(2)
								If dbSeek(A650DtoPer(dEntrega)+cProduto+aSalvCols[nSG1,nPosCod]+cOpcionais)
									RecLock("OPC",.F.)
									Replace QUANTIDADE With QUANTIDADE - aQtdes[nx]
									MsUnlock()
								EndIf
							EndIf
							//A650GeraC1(aSalvCols[nSG1,nPosCod],aQtdes[nX],cOp,dEntrega,cCpoProj,nx,nNecessid,cLocalSC1,cTpOp)
						Next nX
					Endif
				Endif
			EndIf
			dbSelectArea("SG1")
		ElseIf cTipo == "S"
			aNegEst := IsNegEstr(aSalvCols[nSG1,nPosCod],dC2_DATPRI,nNecessid,cProduto)
			SB1->(MsSeek(xFilial("SB1")+aNegEst[2]))
			For nX := 1 To aNegEst[5]
				aQtdes := CalcLote(aNegEst[2],aNegEst[4],"F")
				If lEstMax
					aQtdes := A711LotMax(aNegEst[2],nNecessid,aQtdes)
				Endif
				cRevAtu := SB1->B1_REVATU
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada para alterar a Revisao da estrutura  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lA650REVEM
					aRetPE := ExecBlock("A650REVEM",.F.,.F.,{cRevAtu})
					If ValType(aRetPE) == "A" .And. !Empty(aRetPE[1])
						cRevAtu := aRetPE[1]
					EndIf
				EndIf
				For nY := 1 To Len(aQtdes)
					cSeqC2:=Soma1(cSeqC2,Len(cC2_SEQUEN))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para Alterar a sequencia ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				  	If lMA650SEQ
						cSeqC2Aux := ExecBlock("MA650SEQ",.F.,.F.,{cSeqC2})
					 	If Valtype(cSeqC2Aux) == "C"
					  		cSeqC2 := cSeqC2Aux
						EndIf
					EndIf
					AADD(aOPInt, {cC2_PRODUTO, cC2_NUM+cC2_ITEM+cC2_SEQUEN+cC2_ITEMGRD, (nC2_QUANT - nQuantItem) } )
					dbSelectArea("SG1")
					nR := RecNo()
			        MontEstru(aNegEst[2],aQtdes[nY],dC2_DATPRI,cCpoProj,cSeqC2,cC2_PRIOR,lConsEst,RetFldProd(SB1->B1_COD,"B1_OPC"),lOne,cTpOp,cRevAtu,cStrOpc,@aOPInt,aNegEst[2])
					SG1->(dbGoTo(nR))
				Next nY
			Next nX
		Endif
	EndIf
	If nQuantItem > 0 .Or. nQuantItem < 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Amarra empenhos com OPs geradas            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nQuantItem > 0 .And. cTipo # "C" .And. nNecessid > 0 .And. lGeraOPI .And. RetFldProd(SB1->B1_COD,"B1_FANTASM") != "S" .And. (SB1->B1_TIPO != "BN" .Or. lEmpBN) // Projeto Implementeacao de campos MRP e FANTASM no SBZ
			For nx:=1 To Len(aQtdes)
				nBaixa:=Min(nQuantItem,aQtdes[nx])

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza arquivo de empenhos               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				/*GravaEmp(	aSalvCols[nSG1,nPosCod],;
							aSalvCols[nSG1,nPosLocal],;
							nBaixa,;
							aSalvCols[nSG1,nPosQtSegum],;
							aSalvCols[nSG1,nPosLotCtl],;
							aSalvCols[nSG1,nPosLote],;
							aSalvCols[nSG1,nPosLocLz],;
							aSalvCols[nSG1,nPosnSerie],;
							cOp,;
							aSalvCols[nSG1,nPosTrt],;
							NIL,;
							NIL,;
							"SC2",;
							If(Len(aOps)>0,aOps[nx],NIL),;
							dEntrega,;
							@aTravas,;
							.F.,;
							lProj,;
							.T.,;
							.T.,;
							NIL,;
							NIL,;
							!lRastroLoc,;
							,;
							,;
							aClone(aSalvCols),;
							nSG1,;
							,;
							cTpOp,;
							NIL)*/
				
				//Michele   				
				If !lProj711 .And. !lMata712			
 					For nInd := 1 to len(aAltSaldo)
						If aAltSaldo[nInd,1] == aSalvCols[nSG1,nPosCod]
							aAltSaldo[nInd,2] -= nBaixa  							
 							Exit			
						EndIf		
					Next nInd
				EndIf
				
				nIndice := ASCAN(aLotesUsado,{|x| x[1] == aSalvCols[nSG1,nPosCod] .And. x[2] == aSalvCols[nSG1,nPosLotCtl] .And. x[3] == aSalvCols[nSG1,nPosLocLz]}) 
	    		
	    		If nIndice > 0
	    			aLotesUsado[nIndice,4] -= nBaixa
	    		EndIf 

				nQuantItem-=Min(nQuantItem, nBaixa)

			Next nx
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera Empenho de qtd que ja existente ou    ³
		//³ quantidade que nao precisa ser produzida.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nQuantItem # 0 .And. (SB1->B1_TIPO != "BN" .Or. lEmpBN)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Somente se B1_LM estiver configurado:          ³
			//³ Localiza no vetor aOPInt a OP gerada para o PI ³
			//³ e tenta utiliza-la no empenho (D4_OPORIG).     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cD4_OPORIG := ''
			If !Empty(SB1->B1_LM)
				nX := aScan(aOPInt,{|x| x[1] == aSalvCols[nSG1,nPosCod] .And. QtdComp(x[3]) > QtdComp(0) }) // Posiciona no primeiro elemento do vetor igual ao produto com qtd > 0
				If nX > 0
					cD4_OPORIG   := aOPInt[nX,2] // obtem a OP intermediaria
					aOPInt[nX,3] -= nQuantItem 	 // subtrai a quantidade empenhada do produto
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza arquivo de empenhos               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/*GravaEmp(	aSalvCols[nSG1,nPosCod],;
						aSalvCols[nSG1,nPosLocal],;
						nQuantItem,;
						aSalvCols[nSG1,nPosQtSegum],;
						aSalvCols[nSG1,nPosLotCtl],;
						aSalvCols[nSG1,nPosLote],;
						aSalvCols[nSG1,nPosLocLz],;
						aSalvCols[nSG1,nPosnSerie],;
						cOp,;
						aSalvCols[nSG1,nPosTrt],;
						NIL,;
						NIL,;
						"SC2",;
						IIF(!Empty(cD4_OPORIG), cD4_OPORIG, NIL),;
						dEntrega,;
						@aTravas,;
						.F.,;
						lProj,;
						.T.,;
						.T.,;
						NIL,;
						NIL,;
						!lRastroLoc,;
						,;
						,;
						aClone(aSalvCols),;
						nSG1,;
						,;
						cTpOp,;
						NIL)*/
			
			//Michele    
			If !lProj711 .And. !lMata712			
				For nInd := 1 to len(aAltSaldo)
					If aAltSaldo[nInd,1] == aSalvCols[nSG1,nPosCod]
						aAltSaldo[nInd,2] -= nQuantItem  												
 						Exit			
					EndIf		
				Next nInd
			EndIf
			
			nIndice := ASCAN(aLotesUsado,{|x| x[1] == aSalvCols[nSG1,nPosCod] .And. x[2] == aSalvCols[nSG1,nPosLotCtl] .And. x[3] == aSalvCols[nSG1,nPosLocLz]}) 
	    		
	    	If nIndice > 0
	    		aLotesUsado[nIndice,4] -= nQuantItem
	    	EndIf			
		EndIf
	EndIf
Next
//If lIntSFC
//	A650IntSFC(4,3) //Evento 3 - Geracao dos Empenhos
//EndIf
SB1->(dbGoTo(nSalB1))
If aSalvRot != NIL
	aRotina:=aClone(aSalvRot)
EndIf
//Integração com o PCFactory. Manda a OP novamente após a geração dos empenhos.
//If FindFunction('PCPIntgPPI') .And. PCPIntgPPI()
//   mata650PPI(,,.T.,.T.,.F.)
//EndIf
If lMA650EMP
	ExecBlock('MA650EMP',.F.,.F.)
EndIf
If lProj711 .And. !lMata712 .And. !lPCPA107
	RestArea(aAreaSH5)
ElseIf lMata712
	RestArea(aAreaCZI)
ElseIf lPCPA107
	RestArea(aAreaSOQ)
EndIf

If !Empty(aErros)
	MTA250TELA(aErros)
Endif

Return Empty(aErros)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A650ACols ³ Autor ³ Rodrigo de A. Sartorio ³ Data ³ 16/06/97³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fun‡„o recursiva que monta o array aCols usado para gerar  ³±±
±±³          ³ empenhos e SC's, verifica se existem produtos fantasma na  ³±±
±±³          ³ estrutura e substitue os mesmos pelos produtos incluidos   ³±±
±±³          ³ nos n¡veis abaixo.                                         ³±±
±±³          ³ Caso o usuario tenha preenchido a pergunte MV_PAR08        ³±±
±±³          ³ ("Sugerir lotes a empenhar") como SIM, quebra o empenho das³±±
±±³          ³ MPS de acordo com os lotes dispon¡veis.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA650                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A650ACols(cProduto,nQuantPai,cOpcionais,lConsEst,cRevisao,uConteudo,aHeader,cLocProc,cProOpc,aOpcCam)
Local nRecno     := 0
Local cGravaOpc  := ""
Local cAlias     := Alias()
Local zi         := 0
Local aRetorno   := {}
Local nSC2Recno  := SC2->(Recno())
//Local lSwap
Local nQtd2UM    := 0
Local nDecSD4    := TamSX3('D4_QUANT')[2]
Local cDescB1    := ""
Local nProcura   := 0
Local aLotesTot  := {}
Local lPotencia  :=.F.,nQuantPot:=0,nQuantPot2:=0
Local lExistePE  := ExistBlock("A650ADCOL")
//Local nIniOpc    := 0
Local nRegSB2    := 0
Local nQtyStok   := 0
Local nCntFor    := 0
Local lEmpPrj    := SuperGetMV("MV_EMPPRJ",.F.,.T.)
Local nQtdPrj    := 0
Local nSldDisp   := 0
Local nQtdBack   := 0
Local nQtdDif    := 0
//Local nCAT       := 0
Local lEmpBN     := SuperGetMV("MV_EMPBN",.F.,.F.)
Local lGrvAllOpc := .T. //GetNewpar("MV_GALLOPC",.F.)	//Grava todos os opcionais no campo C2_OPC
Local nSldSBF    := 0
Local aTravSB2	 :=  (Iif (GetNewpar("MV_EMPEXCL",.F.),{},NIL))
Local cProOpcT   := ""
Local aLoteTeste := {}
Local nCont      := 0
Local nIndice    := 0
Local lEmpAlt
Local lNewOpc   := SuperGetMV("MV_REPGOPC",.F.,"N")=="S"

Local nInd       := 0
Local lExistEmSa := .F.
//Local nSalDisAlt := 0

PRIVATE uTrans:=uConteudo

STATIC lA650GRVOPC :=  ExistBlock("A650GRVOPC")

lConsEst := If( (lConsEst == NIL),(GetMV("MV_CONSEST") == "S"),lConsEst )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica informacoes de rastreabilidade                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par08 == 1 .And. lConsEst
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial("SG1")+cProduto)
	Do While !Eof() .And. G1_FILIAL+G1_COD == xFilial("SG1")+cProduto
		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial("SB1")+SG1->G1_COMP)
		dbSelectArea("SG1")
		
		If SB1->B1_TIPO $ "MO"    // Ignora esses tipos
			dbSkip()
			Loop
		Endif
		
		cProOpcT   := (cProOpc + SG1->G1_COMP + SG1->G1_TRT ) 
		nQuantItem :=Round(ExplEstr(nQuantPai,dC2_DATPRI,cOpcionais,cRevisao, /*05*/, /*06*/, /*07*/, /*08*/, /*09*/, /*10*/,cProOpcT),nDecSD4)
				
		nQtd2UM:=ConvUM(SG1->G1_COMP,nQuantItem,0,2)
		cDescB1:=SB1->B1_DESC
		If RetFldProd(SB1->B1_COD,"B1_FANTASM") != "S" .And. QtdComp(nQuantItem,.T.) # QtdComp(0) // Projeto Implementeacao de campos MRP e FANTASM no SBZ
			If lEmpBN .Or. SB1->B1_TIPO <> "BN"
				nProcura := ASCAN(aLotesTot,{|x| x[1]== SG1->G1_COMP .And. x[6]== SG1->G1_POTENCI})
				If nProcura == 0
					AADD(aLotesTot,{SG1->G1_COMP,nQuantItem,nQtd2UM,If(SB1->B1_APROPRI=="I",cLocProc,If(MV_PAR02=1,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),MV_PAR03)),NIL,SG1->G1_POTENCI})
				Else
					aLotesTot[nProcura,2]+=nQuantItem
					aLotesTot[nProcura,3]+=nQtd2Um
				EndIf
			Endif
		EndIf
		dbSelectArea("SG1")
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui informacoes referente aos lotes que serao utilizados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMV_QTDPREV := SuperGetMV("MV_QTDPREV",.F.,"N")
nRegSB2 := SB2->(RecNo())
For zi:=1 to Len(aLotesTot)
	aRetorno := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o Saldo Disponivel no SB2 antes de verificar o Saldo dos Lotes³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nQtyStok := 0
	SB1->(MsSeek(xFilial("SB1")+aLotesTot[zi,1]))
	SB2->(MsSeek(xFilial("SB2")+aLotesTot[zi,1]+If(mv_par02==1,RetFldProd(aLotesTot[zi,1],"B1_LOCPAD"),mv_par03),.T.))
	While SB2->(!Eof() .And. B2_FILIAL+B2_COD==xFilial("SB2")+aLotesTot[zi,1] .And. ;
		B2_LOCAL <= If(mv_par02==1,RetFldProd(aLotesTot[zi,1],"B1_LOCPAD"),mv_par04))
		If !lEmpPrj
			nQtdPrj := SB2->B2_QEMPPRJ
		EndIf
		nQtyStok += SaldoSB2(.T., , ,lConsTerc,lConsNPT,,,nQtdPrj)+SB2->B2_SALPEDI-SB2->B2_QEMPN+AvalQtdPre("SB2",2)
		nQtyStok += A650Prev(SB2->B2_COD)
		SB2->(DbSkip())
	EndDo
    If QtdComp(nQtyStok) > QtdComp(0)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica informacoes de maneira diferenciada quando produto  ³
		//³ utiliza controle de potencia identificada na estrutura.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aLoteTeste := {}
		
		For nCont := 1 TO LEN(aLotesUsado)
			If aLotesUsado[nCont,1] == aLotesTot[zi,1]
				AADD(aLoteTeste,{aLotesUsado[nCont,2],'',aLotesUsado[nCont,3],'',aLotesUsado[nCont,4],0})
			EndIf
		Next nCont
		
		If Empty(aLotesTot[zi,6]) .Or. !PotencLote(aLotesTot[zi,1])
			aRetorno:=SldPorLote(aLotesTot[zi,1],aLotesTot[zi,4],aLotesTot[zi,2],aLotesTot[zi,3],NIL,NIL,NIL,NIL,aTravSB2,.T.,;
										If(mv_par02==1 .Or. aLotesTot[zi,4] == cLocProc,NIL,mv_par04),nil,aLoteTeste,;
										If(cC2_TPOP == "F",cMV_QTDPREV=="S" .And. !PotencLote(aLotesTot[zi,1]),.T.),;
										dDataBase)
		Else
			aRetorno:=SldPorLote(aLotesTot[zi,1],aLotesTot[zi,4],99999999999999999999,99999999999999999999,NIL,NIL,NIL,NIL,NIL,.T.,;
										If(mv_par02==1 .Or. aLotesTot[zi,4] == cLocProc,NIL,mv_par04),nil,aLoteTeste,;
										If(cC2_TPOP == "F",cMV_QTDPREV=="S" .And. !PotencLote(aLotesTot[zi,1]),.T.),;
										dDataBase)
		EndIf
		For nCntFor := 1 To Len(aRetorno)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o endereco possui quantidade suficiente para atender o empenho. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nSldSBF := SaldoSBF(aLotesTot[zi,4], aRetorno[nCntFor,3], aLotesTot[zi,1])
	    	aRetorno[nCntFor,5] := Min(aRetorno[nCntFor,5],If(QtdComp(nQtyStok)<QtdComp(0),0,IIf(nSldSBF < nQtyStok, nQtyStok, nSldSBF)))
	    	aRetorno[nCntFor,6] := ConvUM(aLotesTot[zi,1],aRetorno[nCntFor,5],0,2)
	    	nQtyStok -= aRetorno[nCntFor,5]
	    	
	    	nIndice := ASCAN(aLotesUsado,{|x| x[1] == aLotesTot[zi,1] .And. x[2] == aRetorno[nCntFor,1] .And. x[3] == aRetorno[nCntFor,3]}) 
	    	If nIndice == 0
	    		AADD(aLotesUsado,{aLotesTot[zi,1],aRetorno[nCntFor,1],aRetorno[nCntFor,3],aRetorno[nCntFor,5]})
	    	Else
	    		aLotesUsado[nIndice,4] += aRetorno[nCntFor,5]
	    	EndIf
		Next nCntFor
	EndIf
	aLotesTot[zi,5] := ACLONE(aRetorno)
Next zi
SB2->(DbGoto(nRegSB2))

lA650CALT  := ExistBlock("A650CALT")
lA650SALDO := ExistBlock("A650SALDO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa aCols                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1")+cProduto)
Do While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto
	
	nQuantItem := Round(If(Empty(nQuantPai),0,ExplEstr(nQuantPai,dC2_DATPRI,cOpcionais,cRevisao, /*05*/, /*06*/, /*07*/, /*08*/, /*09*/, /*10*/, IIf(!IsInCallStack("A650Acols"),(cProOpc + SG1->G1_COMP + SG1->G1_TRT ),Nil))),nDecSD4)
 	nQtd2UM	   := ConvUM(SG1->G1_COMP,nQuantItem,0,2)
	nSldDisp   := 0
	nQtdDif	   := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica informacoes de maneira diferenciada quando produto  ³
	//³ utiliza controle de potencia identificada na estrutura.      ³
	//³ Converte a quantidade necessaria sempre baseado na POTENCIA  ³
	//³ MAXIMA (100%)                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SG1->G1_POTENCI) .And. PotencLote(SG1->G1_COMP) .And. QtdComp(nQuantItem,.T.) > QtdComp(0)
		lPotencia  :=.T.
		nQuantItem := Round(nQuantItem*(SG1->G1_POTENCI/100),nDecSD4)
		nQtd2UM    := ConvUM(SG1->G1_COMP,nQuantItem,0,2)
	Else
		lPotencia:=.F.
	EndIf
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+SG1->G1_COMP)
	dbSelectArea("SG1")
	
	If SB1->B1_TIPO $ "MO"    // Ignora esses tipos
		dbSkip()
		Loop
	Endif
	
	cDescB1:=SB1->B1_DESC
	If lProj711 .And. !RetFldProd(SG1->G1_COMP,"B1_MRP") $ " S"
		 SG1->(DbSkip())
		 Loop
	EndIf
	
	If RetFldProd(SB1->B1_COD,"B1_FANTASM") != "S" // Projeto Implementeacao de campos MRP e FANTASM no SBZ
		If lEmpBN .Or. SB1->B1_TIPO <> "BN"
			If QtdComp(nQuantItem,.T.) <= QtdComp(0)
				AADD(aCols,ARRAY(Len(aHeader)+1))
				aCols[Len(aCols),nPosCod  ] := SG1->G1_COMP
				aCols[Len(aCols),nPosQuant] := nQuantItem
				aCols[Len(aCols),nPosLocal] := If(SB1->B1_APROPRI=="I",cLocProc,RetFldProd(SB1->B1_COD,"B1_LOCPAD"))
				aCols[Len(aCols),nPosTRT  ] := SG1->G1_TRT
				aCols[Len(aCols),nPosLote  ]:= CriaVar("D4_NUMLOTE")
				aCols[Len(aCols),nPosLotCtl]:= CriaVar("D4_LOTECTL")
				aCols[Len(aCols),nPosdValid]:= CriaVar("D4_DTVALID")
				aCols[Len(aCols),nPosPotenc]:= CriaVar("D4_POTENCI")
				aCols[Len(aCols),nPosLocLz ]:= CriaVar("DC_LOCALIZ")
				aCols[Len(aCols),nPosnSerie]:= CriaVar("DC_NUMSERI")
				aCols[Len(aCols),nPosUM     ] := SB1->B1_UM
				aCols[Len(aCols),nPosQtSegum] :=nQtd2UM
				aCols[Len(aCols),nPos2UM    ] :=SB1->B1_SEGUM
				aCols[Len(aCols),nPosDescr  ] :=cDescB1
				If ValType(uConteudo) != "U"
					aCols[Len(aCols), Len(aHeader)] := &(uTrans)
				EndIf
				aCols[Len(aCols),Len(aHeader)+1]:= .F.
				If (QtdComp(nQuantItem) == QtdComp(0))
					AADD(aColsDele,Len(aCols))
				EndIf
				If lExistePE
					ExecBlock("A650ADCOL",.F.,.F.,{cProduto,nQuantPai,cOpcionais,cRevisao,dC2_DATPRI})
				EndIf
				If !lGrvAllOpc	//Grava todos os opcionais no campo C2_OPC
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Incrementa variavel dos opcionais                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(cOpcionais) .And. !Empty(SG1->G1_GROPC) .And. ;
							!Empty(SG1->G1_OPC) .And. (SG1->G1_GROPC+SG1->G1_OPC $ cOpcionais) .And. ;
							!(SG1->G1_GROPC+SG1->G1_OPC $ cGravaOpc)
						cGravaOpc+=SG1->G1_GROPC+SG1->G1_OPC+"/"
					EndIf
				Endif
				
				AADD(aOpcCam,cProOpc + SG1->G1_COMP + SG1->G1_TRT)  
			Else
				If !lGrvAllOpc	//Grava todos os opcionais no campo C2_OPC
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Incrementa variavel dos opcionais                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(cOpcionais) .And. !Empty(SG1->G1_GROPC) .And. ;
							!Empty(SG1->G1_OPC) .And. (SG1->G1_GROPC+SG1->G1_OPC $ cOpcionais) .And. ;
							!(SG1->G1_GROPC+SG1->G1_OPC $ cGravaOpc)
						cGravaOpc+=SG1->G1_GROPC+SG1->G1_OPC+"/"
					EndIf
				Endif
				// Verifica se usa Rastro ou Localizacao Fisica
				// e se deve sugerir os lotes e localizacoes do empenho
				If mv_par08 == 1 .And. (Rastro(SG1->G1_COMP) .Or. Localiza(SG1->G1_COMP));
						.And. lConsEst .And. QtdComp(SG1->G1_QUANT) > QtdComp(0)
					nProcura := ASCAN(aLotesTot,{|x| x[1]== SG1->G1_COMP})
					If nProcura > 0
						aRetorno:=ACLONE(aLotesTot[nProcura,5])
						For zi:=1 to Len(aRetorno)
							If QtdComp(aRetorno[zi,5]) > QtdComp(0) .And. If(lPotencia,aRetorno[zi,12] > 0,.T.)
								AADD(aCols,ARRAY(Len(aHeader)+1))
								aCols[Len(aCols),nPosCod]   := SG1->G1_COMP
								If lPotencia
									// PRIMEIRA UNIDADE DE MEDIDA
									nQuantPot:=aRetorno[zi,5]*(aRetorno[zi,12]/100)
									aCols[Len(aCols),nPosQuant] := Min(nQuantPot,nQuantItem)
									nQuantPot:=aCols[Len(aCols),nPosQuant]
									aCols[Len(aCols),nPosQuant] := aCols[Len(aCols),nPosQuant]/(aRetorno[zi,12]/100)
									// SEGUNDA UNIDADE DE MEDIDA
									nQuantPot2:=aRetorno[zi,6]*(aRetorno[zi,12]/100)
									aCols[Len(aCols),nPosQtSegum] := Min(nQuantPot2,nQtd2UM)
									nQuantPot2:=aCols[Len(aCols),nPosQtSegum]
									aCols[Len(aCols),nPosQtSegum] := aCols[Len(aCols),nPosQtSegum]/(aRetorno[zi,12]/100)
								Else
									aCols[Len(aCols),nPosQuant] := Min(aRetorno[zi,5],nQuantItem)
									aCols[Len(aCols),nPosQtSegum]:=Min(aRetorno[zi,6],nQtd2UM)
								EndIf
								aCols[Len(aCols),nPosLocal] := aRetorno[zi,11]
								aCols[Len(aCols),nPosTRT]   := SG1->G1_TRT
								aCols[Len(aCols),nPosLote]  := aRetorno[zi,2]
								aCols[Len(aCols),nPosLotCtl]:= aRetorno[zi,1]
								aCols[Len(aCols),nPosdValid]:= aRetorno[zi,7]
								aCols[Len(aCols),nPosPotenc]:= aRetorno[zi,12]
								aCols[Len(aCols),nPosLocLz] := aRetorno[zi,3]
								aCols[Len(aCols),nPosnSerie]:= aRetorno[zi,4]
								aCols[Len(aCols),nPosUM]    := SB1->B1_UM
								aCols[Len(aCols),nPos2UM]   := SB1->B1_SEGUM
								aCols[Len(aCols),nPosDescr] := cDescB1
								If ValType(uConteudo) != "U"
									aCols[Len(aCols), Len(aHeader)] := &(uTrans)
								EndIf
								aCols[Len(aCols),Len(aHeader)+1]:= .F.
								If lExistePE
									ExecBlock("A650ADCOL",.F.,.F.,{cProduto,nQuantPai,cOpcionais,cRevisao,dC2_DATPRI})
								EndIf
								If lPotencia
									nQuantItem -= nQuantPot
									nQtd2UM    -= nQuantPot2
								Else
									nQuantItem -= aCols[Len(aCols),nPosQuant]
									nQtd2UM    -= aCols[Len(aCols),nPosQtSegum]
								EndIf
								aRetorno[zi,5] -= aCols[Len(aCols),nPosQuant]
								aRetorno[zi,6] -= aCols[Len(aCols),nPosQtSegum]
								aLotesTot[nProcura,5] := ACLONE(aRetorno)
								
								AADD(aOpcCam,cProOpc + SG1->G1_COMP + SG1->G1_TRT)
							EndIf
							If QtdComp(nQuantItem,.t.) <= QtdComp(0,.t.)
								Exit
							EndIf
						Next zi
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Utiliza produtos alternativos (SGI)	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lA650CALT
						lEmpAlt := .T.
						lEmpAlt :=!ExecBlock('A650CALT',.F.,.F.,{SG1->G1_COMP, nQtdDif, cProduto, nQuantPai, cLocProc,dC2_DATPRI })

						If lEmpAlt
							A650EmpAlt(SG1->G1_COMP,nQtdDif,uConteudo,cLocProc,{cProduto,nQuantPai,cOpcionais,cRevisao,dC2_DATPRI},dC2_DATPRI,cOpcionais,cProOpc,@aOpcCam)												
						EndIf
					Else
						If QtdComp(nQuantItem,.T.) > QtdComp(0)
							A650EmpAlt(SG1->G1_COMP,nQuantItem,uConteudo,cLocProc,{cProduto,nQuantPai,cOpcionais,cRevisao,dC2_DATPRI},dC2_DATPRI,cOpcionais,cProOpc,@aOpcCam)
						EndIf
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calcula saldo disponivel para, se for o caso, utilizar alternativos (SGI) ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lConsEst .And. SGI->(MsSeek(xFilial("SGI")+SG1->G1_COMP))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona SB2                          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lProj711
							dbSelectArea("SB2")
							dbSetOrder(1)
							dbSeek(xFilial("SB2")+SG1->G1_COMP+If(SB1->B1_APROPRI=="I",cLocProc,RetFldProd(SB1->B1_COD,"B1_LOCPAD")))
							If EOF()
								CriaSB2(SG1->G1_COMP,If(SB1->B1_APROPRI=="I",cLocProc,RetFldProd(SB1->B1_COD,"B1_LOCPAD")))
								MsUnlock()
							EndIf
							nQtdPrj := SB2->B2_QEMPPRJ
							nSldDisp := SaldoSB2(.T., , ,lConsTerc,lConsNPT,,,nQtdPrj)+SB2->B2_SALPEDI-SB2->B2_QEMPN+AvalQtdPre("SB2",2)
							nSldDisp += A650Prev(SB2->B2_COD)
						ElseIf lProj711 .And. !lMata712 .And. !lPCPA107
							nSldDisp := A650UsoSH5(SG1->G1_COD,SG1->G1_COMP,Space(Len(SG1->G1_COMP)),cOpcionais,A650DtoPer(dC2_DATPRI),nQuantItem)
						ElseIf lMata712
							nSldDisp := A650UsoCZI(SG1->G1_COD,SG1->G1_COMP,Space(Len(SG1->G1_COMP)),cOpcionais,A650DtoPer(dC2_DATPRI),nQuantItem)
						ElseIf lPCPA107
							nSldDisp := A650UsoSOQ(SG1->G1_COD,SG1->G1_COMP,Space(Len(SG1->G1_COMP)),cOpcionais,A650DtoPer(dC2_DATPRI),nQuantItem) 
						EndIf
						
						//Michele
						//Verifica array de saldo do alternativo para descontar o que ja foi empenhado no nivel anterior
						If !lProj711 .And. !lMata712
							lExistEmSa := .F.
			
							For nInd := 1 to len(aAltSaldo)
			   					If aAltSaldo[nInd,1] == SG1->G1_COMP
				  					nSldDisp -= aAltSaldo[nInd,2]
			    
			    					If nSldDisp <= 0
					 					nSldDisp := 0
				  					/*Else
										nSalDisAlt :=aAltSaldo[nInd,2]
										aAltSaldo[nInd,2] := nSalDisAlt + nSldDisp*/
								    EndIf
					
									lExistEmSa := .T. 			   				
				   					Exit			
								EndIf		
							Next nInd
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Executa P.E. para tratar saldo disponivel.                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ExistTemplate("A650SALDO")
							nQtdBack := nSldDisp
							nSldDisp := ExecTemplate("A650SALDO",.F.,.F.,nSldDisp)
							If ValType(nQtyStok) != "N"
								nSldDisp := nQtdBack
							EndIf
						EndIf
						If lA650SALDO
							nQtdBack := nSldDisp
							nSldDisp := ExecBlock("A650SALDO",.F.,.F.,nSldDisp)
							If ValType(nSldDisp) != "N"
								nSldDisp:=nQtdBack
							EndIf
						EndIf
					EndIf
					If nSldDisp > 0
						nQtdDif := Max(nQuantItem-nSldDisp,0)
					Else
						nQtdDif := Max(nQuantItem,0)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//| Empenha o saldo que esta disponivel	|
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nQtdDif < nQuantItem
						AADD(aCols,ARRAY(Len(aHeader)+1))
						aCols[Len(aCols),nPosCod    ] := SG1->G1_COMP
						aCols[Len(aCols),nPosQuant  ] := If(Empty(nQtdDif),nQuantItem,nSldDisp)
						aCols[Len(aCols),nPosLocal  ] := If(SB1->B1_APROPRI=="I",cLocProc,RetFldProd(SB1->B1_COD,"B1_LOCPAD"))
						aCols[Len(aCols),nPosTRT    ] := SG1->G1_TRT
						aCols[Len(aCols),nPosLote   ] := CriaVar("D4_NUMLOTE")
						aCols[Len(aCols),nPosLotCtl ] := CriaVar("D4_LOTECTL")
						aCols[Len(aCols),nPosdValid ] := CriaVar("D4_DTVALID")
						aCols[Len(aCols),nPosPotenc ] := CriaVar("D4_POTENCI")
						aCols[Len(aCols),nPosLocLz  ] := CriaVar("DC_LOCALIZ")
						aCols[Len(aCols),nPosnSerie ] := CriaVar("DC_NUMSERI")
						aCols[Len(aCols),nPosUM     ] := SB1->B1_UM
						aCols[Len(aCols),nPosQtSegum] := nQtd2UM
						aCols[Len(aCols),nPos2UM    ] := SB1->B1_SEGUM
						aCols[Len(aCols),nPosDescr  ] := cDescB1
						If ValType(uConteudo) != "U"
							aCols[Len(aCols), Len(aHeader)] := &(uTrans)
						EndIf
						aCols[Len(aCols),Len(aHeader)+1]:= .F.
						If lExistePE
							ExecBlock("A650ADCOL",.F.,.F.,{cProduto,nQuantPai,cOpcionais,cRevisao,dC2_DATPRI})
						EndIf
						
						AADD(aOpcCam,cProOpc + SG1->G1_COMP + SG1->G1_TRT)
						
						//Michele
						//Inclui alternativo e o saldo no array 
						If !lProj711 .And. !lMata712 .And. !lExistEmSa .And. !lPCPA107
 							aadd(aAltSaldo,{SG1->G1_COMP,If(Empty(nQtdDif),nQuantItem,nSldDisp)})
			 			EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Utiliza produtos alternativos (SGI)	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lA650CALT
						lEmpAlt := .T.
						lEmpAlt :=!ExecBlock('A650CALT',.F.,.F.,{SG1->G1_COMP, nQtdDif, cProduto, nQuantPai, cLocProc,dC2_DATPRI })

						If lEmpAlt
							A650EmpAlt(SG1->G1_COMP,nQtdDif,uConteudo,cLocProc,{cProduto,nQuantPai,cOpcionais,cRevisao,dC2_DATPRI},dC2_DATPRI,cOpcionais,cProOpc,@aOpcCam)												
						EndIf
					Else
						If nQtdDif > 0
							A650EmpAlt(SG1->G1_COMP,nQtdDif,uConteudo,cLocProc,{cProduto,nQuantPai,cOpcionais,cRevisao,dC2_DATPRI},dC2_DATPRI,cOpcionais,cProOpc,@aOpcCam)
						EndIf
					EndIf
				EndIf
			EndIf
		Endif
	Else
		If !lGrvAllOpc	//Grava todos os opcionais no campo C2_OPC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Incrementa variavel dos opcionais dos componentes fantasmas  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cOpcionais) .And. !Empty(SG1->G1_GROPC) .And. ;
					!Empty(SG1->G1_OPC) .And. (SG1->G1_GROPC+SG1->G1_OPC $ cOpcionais) .And. ;
					!(SG1->G1_GROPC+SG1->G1_OPC $ cGravaOpc)
				cGravaOpc+=SG1->G1_GROPC+SG1->G1_OPC+"/"
			EndIf
		Endif
		nRecno:=SG1->(Recno())
		cProOpcT := (cProOpc + SG1->G1_COMP + SG1->G1_TRT )
        A650ACols(SG1->G1_COMP,nQuantItem,cOpcionais,lConsEst,,uConteudo,aHeader,cLocProc,cProOpcT,@aOpcCam)      		
		SG1->(dbGoto(nRecno))
		SC2->(dbGoto(nSC2Recno))
	EndIf
	dbSelectArea("SG1")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava opcionais corretos na Ordem de Producao                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SC2->(dbGoto(nSC2Recno))
If !lGrvAllOpc
	Reclock("SC2",.F.)
	If !Empty( cOpcionais )
		If aScan(aOPOpc,SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN)) == 0
			If lNewOPC .And. IsInCallStack("A650Acols")			
				Replace	SC2->C2_MOPC	With cGravaOpc
			Else
				Replace	SC2->C2_OPC	With cGravaOpc
			EndIf
			AADD(aOPOpc,SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN))
		Else
			If !Empty(cGravaOpc) .And. cGravaOpc <> cOpcionais
				If !( cGravaOpc $ SC2->C2_OPC )
					If lNewOPC .And. IsInCallStack("A650Acols")
						SC2->C2_MOPC  := Alltrim(SC2->C2_MOPC)+cGravaOpc
					Else	
						SC2->C2_OPC	:= Alltrim(SC2->C2_OPC)+cGravaOpc
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		If lNewOPC .And. IsInCallStack("A650Acols")
			SC2->C2_MOPC	:= cGravaOpc
		Else
			SC2->C2_OPC	:= cGravaOpc
		EndIf
	EndIf
	MsUnlock()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PE apos a gravacao dos opcionais da Ordem de Producao        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lA650GRVOPC
	ExecBlock("A650GRVOPC",.F.,.F.,cOpcionais)
Endif

dbSelectArea(cAlias)
RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTA650PERG³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 28/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada da funcao PERGUNTE                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA650                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA650PERG(lMostra)
Local ni:=0
Pergunte("MTA650", lMostra)
//Salvar variaveis existentes
For ni := 1 to 20
	aSav650[ni] := &("mv_par"+StrZero(ni,2))
Next ni
lConsNPT  := (aSav650[14] == 1)
lConsTerc := !(aSav650[15] == 1)
RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |A650EmpAltºAutor  ³Andre Anjos         º Data ³  24/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina que coloca produtos alternativos no aCols de        º±±
±±º          | empenhos.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cProdOri: produto origem da relacao com o alternativo      º±±
±±º          ³ nQtdOri: quantidade origem                                 º±±
±±º          ³ uConteudo: ponto de entrada A650ADCOL                      º±±
±±º          ³ cLocProc: armazem de processo                              º±±
±±º          ³ aParamPE: array contendo {cProduto,nQuantPai,cOpcionais,   º±±
±±º          ³           cRevisao} para uso do ponto de entrada A650ADCOL º±±
±±º          ³ dEntrega: data da necessidade                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA650                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A650EmpAlt(cProdOri,nQtdOri,uConteudo,cLocProc,aParamPE,dEntrega,cOpcionais,cProOpc,aOpcCam)
Local aArea      := GetArea()
Local aRetorno   := {}
Local cLocAn     := ""
Local nQtdPrj    := 0
Local nX         := 0
Local nQuantItem := 0
Local nQtd2UM    := 0
Local nQuantPot  := 0
Local nQuantPot2 := 0
Local nSldDisp   := 0
Local nRetPE	 := 0
Local lEmpPrj    := SuperGetMV("MV_EMPPRJ",.F.,.T.)
Local lRetPe	 := .T.
Local nRecSG1	 := SG1->(RECNO())
Local nInd       := 0
Local lExistEmSa := .F.
//Local nSalDisAlt := 0
Local cMV_QTDPREV := SuperGetMV("MV_QTDPREV",.F.,"N")

Default cLocProc := SuperGetMV("MV_LOCPROC",.F.,"99")
Default aParamPE := Array(4)
Default dEntrega := dC2_DATPRI

Static lA650VLALT:= ExistBlock("A650VLALT")
Static lA650ADCOL:= ExistBlock("A650ADCOL")
Static lA650SALDO:= ExistBlock("A650SALDO")
Static lA650ASCOL:= ExistBlock("A650ASCOL")

                              // somente atribuir valor depois de declarada a static pois pode dar problema no menudef

dbSelectArea("SGI")
dbSetOrder(1)
dbSeek(xFilial("SGI")+cProdOri)
While nQtdOri > 0 .And. !EOF() .And. SGI->(GI_FILIAL+GI_PRODORI) == xFilial("SGI")+cProdOri
	//reposiciona SG1 que se perde no loop
	SG1->(dbGoto(nRecSG1))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Posiciona SB1 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SB1->(MsSeek(xFilial("SB1")+SGI->GI_PRODALT))

	If SB1->B1_TIPO $ "MO"    // Ignora esses tipos
		SGI->(dbSkip())
		Loop
	Endif
	
	If lA650VLALT
		lRetPe := ExecBlock("A650VLALT",.F.,.F.)
		If ValType(lRetPe) == "L"
			If !lRetPE
				SGI->(dbSkip())
				Loop
			EndIf
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Converte a quantidade conforme fator |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SGI->GI_TIPOCON == "M"
		nQuantItem := nQtdOri * SGI->GI_FATOR
	Else
		nQuantItem := nQtdOri / SGI->GI_FATOR
	EndIf
	nQtd2UM	:= ConvUM(SGI->GI_PRODALT,nQuantItem,0,2)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Analisa saldo disponivel do alternativo |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lProj711 .And. !lMata712 .And. !lPCPA107
		nSldDisp := A650UsoSH5(SG1->G1_COD,SGI->GI_PRODALT,cProdOri,cOpcionais,A650DtoPer(dEntrega),nQuantItem)
	ElseIf lMata712 .And. !lPCPA107
		nSldDisp := A650UsoCZI(SG1->G1_COD,SGI->GI_PRODALT,cProdOri,cOpcionais,A650DtoPer(dEntrega),nQuantItem)
	ElseIf lPCPA107
		nSldDisp := A650UsoSOQ(SG1->G1_COD,SGI->GI_PRODALT,cProdOri,cOpcionais,A650DtoPer(dEntrega),nQuantItem)
	Else
		If( mv_par02 = 1 )
		   SB2->(dbSeek(xFilial("SB2")+SGI->GI_PRODALT+RetFldProd(SGI->GI_PRODALT,"B1_LOCPAD")))
		Else
		   SB2->(dbSeek(xFilial("SB2")+SGI->GI_PRODALT+If(SB1->B1_APROPRI=="I",cLocProc,RetFldProd(SGI->GI_PRODALT,"B1_LOCPAD"))))
		Endif   
		
		If EOF()
			CriaSB2(SGI->GI_PRODALT,If(SB1->B1_APROPRI=="I",cLocProc,RetFldProd(SGI->GI_PRODALT,"B1_LOCPAD")))
			MsUnlock()
		EndIf
		If !lEmpPrj
			nQtdPrj := SB2->B2_QEMPPRJ
		EndIf
		nSldDisp := SaldoSB2(.T., , ,lConsTerc,lConsNPT,,,nQtdPrj)+SB2->B2_SALPEDI-SB2->B2_QEMPN+AvalQtdPre("SB2",2)
		nSldDisp += A650Prev(SB2->B2_COD)
	EndIf
	
	//Michele
	//Verifica array de saldo do alternativo para descontar o que ja foi empenhado no nivel anterior
	If !lProj711 .And. !lMata712
		lExistEmSa := .F.
						
		For nInd := 1 to len(aAltSaldo)
			If aAltSaldo[nInd,1] == SGI->GI_PRODALT  
				
				nSldDisp -= aAltSaldo[nInd,2]
		    
		    	If nSldDisp <= 0
					nSldDisp := 0
				/*Else
					nSalDisAlt :=aAltSaldo[nInd,2]
					aAltSaldo[nInd,2] := nSalDisAlt + nSldDisp*/
			    EndIf
				lExistEmSa := .T. 
				Exit			
			EndIf		
		Next nInd
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa P.E. para tratar saldo disponivel.                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistTemplate("A650SALDO")
		nQtdBack := nSldDisp
		nSldDisp := ExecTemplate("A650SALDO",.F.,.F.,nSldDisp)
		If ValType(nQtyStok) != "N"
			nSldDisp := nQtdBack
		EndIf
	EndIf
	If lA650SALDO
		nQtdBack := nSldDisp
		nSldDisp := ExecBlock("A650SALDO",.F.,.F.,nSldDisp)
		If ValType(nSldDisp) != "N"
			nSldDisp:=nQtdBack
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Prepara nQtdOri para loop	|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SGI")
	Do Case
		Case nSldDisp <= 0 //desconsidera alternativo
			nQuantItem := 0
		Case nSldDisp < nQuantItem //volta diferenca para pegar outro alternativo
			If SGI->GI_TIPOCON == "M"
				nQtdOri -= (nSldDisp / SGI->GI_FATOR)
			Else
				nQtdOri -= (nSldDisp * SGI->GI_FATOR)
			EndIf
			nQuantItem := nSldDisp
			nQtd2UM := ConvUM(SGI->GI_PRODALT,nQuantItem,0,2)
		Otherwise //finaliza busca pois empenha somente este alternativo
			nQtdOri := 0
	EndCase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Busca lotes/enderecos a sugerir		    |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nSldDisp > 0 .And. mv_par08 == 1 .And. (Rastro(SGI->GI_PRODALT) .Or. Localiza(SGI->GI_PRODALT))
		cLocAn := If(SB1->B1_APROPRI=="I",cLocProc,If(MV_PAR02=1,RetFldProd(SB1->B1_COD,"B1_LOCPAD"),MV_PAR03))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica informacoes de maneira diferenciada quando produto  ³
		//³ utiliza controle de potencia identificada na estrutura.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !PotencLote(SGI->GI_PRODALT)
			aRetorno:=SldPorLote(SGI->GI_PRODALT,cLocAn,nQuantItem,nQtd2UM,NIL,NIL,NIL,NIL,NIL,.T.,;
										If(mv_par02==1 .Or. cLocAn == cLocProc,NIL,mv_par04),nil,nil,;
										If(cC2_TPOP == "F",cMV_QTDPREV=="S" .And. !PotencLote(SGI->GI_PRODALT),.T.),;
										dDataBase)
		Else
			aRetorno:=SldPorLote(SGI->GI_PRODALT,cLocAn,99999999999999999999,99999999999999999999,NIL,NIL,NIL,NIL,NIL,.T.,;
										If(mv_par02==1 .Or. cLocAn == cLocProc,NIL,mv_par04),nil,nil,;
										If(cC2_TPOP == "F",cMV_QTDPREV=="S" .And. !PotencLote(SGI->GI_PRODALT),.T.),;
										dDataBase)
		EndIf
		For nX := 1 To Len(aRetorno)
	    	aRetorno[nX,5] := Min(aRetorno[nX,5],If(QtdComp(nSldDisp)<QtdComp(0),0,nSldDisp))
	    	aRetorno[nX,6] := Min(aRetorno[nX,6],ConvUM(SGI->GI_PRODALT,If(QtdComp(nSldDisp)<QtdComp(0),0,nSldDisp),0,2))
		Next nX
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Gera empenho para o alternativo |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aRetorno)
		If QtdComp(aRetorno[nX,5]) > QtdComp(0) .And. If(PotencLote(SGI->GI_PRODALT),aRetorno[nX,12] > 0,.T.)
			AADD(aCols,ARRAY(Len(aHeader)+1))
			aCols[Len(aCols),nPosCod] := SGI->GI_PRODALT
			If PotencLote(SGI->GI_PRODALT)
				// PRIMEIRA UNIDADE DE MEDIDA
				nQuantPot:=aRetorno[nX,5]*(aRetorno[nX,12]/100)
				aCols[Len(aCols),nPosQuant] := Min(nQuantPot,nQuantItem)
				nQuantPot:=aCols[Len(aCols),nPosQuant]
				aCols[Len(aCols),nPosQuant] := aCols[Len(aCols),nPosQuant]/(aRetorno[nX,12]/100)
				// SEGUNDA UNIDADE DE MEDIDA
				nQuantPot2:=aRetorno[nX,6]*(aRetorno[nX,12]/100)
				aCols[Len(aCols),nPosQtSegum] := Min(nQuantPot2,nQtd2UM)
				nQuantPot2:=aCols[Len(aCols),nPosQtSegum]
				aCols[Len(aCols),nPosQtSegum] := aCols[Len(aCols),nPosQtSegum]/(aRetorno[nX,12]/100)
			Else
				aCols[Len(aCols),nPosQuant] := Min(aRetorno[nX,5],nQuantItem)
				aCols[Len(aCols),nPosQtSegum]:=Min(aRetorno[nX,6],nQtd2UM)
			EndIf
			aCols[Len(aCols),nPosLocal] := aRetorno[nX,11]
			aCols[Len(aCols),nPosTRT]   := CriaVar("G1_TRT")
			aCols[Len(aCols),nPosLote]  := aRetorno[nX,2]
			aCols[Len(aCols),nPosLotCtl]:= aRetorno[nX,1]
			aCols[Len(aCols),nPosdValid]:= aRetorno[nX,7]
			aCols[Len(aCols),nPosPotenc]:= aRetorno[nX,12]
			aCols[Len(aCols),nPosLocLz] := aRetorno[nX,3]
			aCols[Len(aCols),nPosnSerie]:= aRetorno[nX,4]
			aCols[Len(aCols),nPosUM]    := SB1->B1_UM
			aCols[Len(aCols),nPos2UM]   := SB1->B1_SEGUM
			aCols[Len(aCols),nPosDescr] := SB1->B1_DESC
			If ValType(uConteudo) != "U"
				aCols[Len(aCols), Len(aHeader)] := &(uTrans)
			EndIf
			aCols[Len(aCols),Len(aHeader)+1]:= .F.
			If lA650ADCOL
				ExecBlock("A650ADCOL",.F.,.F.,aParamPE)
			EndIf
			If PotencLote(SGI->GI_PRODALT)
				nQuantItem -= nQuantPot
				nQtd2UM    -= nQuantPot2
			Else
				nQuantItem -= aCols[Len(aCols),nPosQuant]
				nQtd2UM    -= aCols[Len(aCols),nPosQtSegum]
			EndIf
			aRetorno[nX,5] -= aCols[Len(aCols),nPosQuant]
			aRetorno[nX,6] -= aCols[Len(aCols),nPosQtSegum]
			
			AADD(aOpcCam,cProOpc + cProdOri + SG1->G1_TRT)
		EndIf
		If QtdComp(nQuantItem,.t.) <= QtdComp(0,.t.)
			Exit
		EndIf
	Next nX

	If nQuantItem > 0
		AADD(aCols,ARRAY(Len(aHeader)+1))
		aCols[Len(aCols),nPosCod    ] := SGI->GI_PRODALT
		aCols[Len(aCols),nPosQuant  ] := nQuantItem
		aCols[Len(aCols),nPosLocal  ] := If(SB1->B1_APROPRI=="I",cLocProc,RetFldProd(SGI->GI_PRODALT,"B1_LOCPAD"))
		aCols[Len(aCols),nPosTRT    ] := CriaVar("G1_TRT")
		aCols[Len(aCols),nPosLote   ] := CriaVar("D4_NUMLOTE")
		aCols[Len(aCols),nPosLotCtl ] := CriaVar("D4_LOTECTL")
		aCols[Len(aCols),nPosdValid ] := CriaVar("D4_DTVALID")
		aCols[Len(aCols),nPosPotenc ] := CriaVar("D4_POTENCI")
		aCols[Len(aCols),nPosLocLz  ] := CriaVar("DC_LOCALIZ")
		aCols[Len(aCols),nPosnSerie ] := CriaVar("DC_NUMSERI")
		aCols[Len(aCols),nPosUM     ] := SB1->B1_UM
		aCols[Len(aCols),nPosQtSegum] := nQtd2UM
		aCols[Len(aCols),nPos2UM    ] := SB1->B1_SEGUM
		aCols[Len(aCols),nPosDescr  ] := SB1->B1_DESC
		If ValType(uConteudo) != "U"
			aCols[Len(aCols), Len(aHeader)] := &(uTrans)
		EndIf
		aCols[Len(aCols),Len(aHeader)+1]:= .F.
		If lA650ADCOL
			ExecBlock("A650ADCOL",.F.,.F.,aParamPE)
		EndIf
		
		//Michele
		//Inclui alternativo e o saldo no array 
		If !lProj711 .And. !lMata712 .And. !lExistEmSa .And. !lPCPA107
 			aadd(aAltSaldo,{SGI->GI_PRODALT,nQuantItem})
 		EndIf
 		
 		AADD(aOpcCam,cProOpc)
 	    AADD(aOpcCam,cProOpc + cProdOri + SG1->G1_TRT)
	EndIf

	SGI->(dbSkip())
End

//reposiciona SG1 que se perde no loop
SG1->(dbGoto(nRecSG1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Se houver sobra, volta a empenhar produto origem |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nQtdOri > 0
	//Acumula saldo de empenho quando ja ha registro
	nProcura := aScan(aCols,{|x| x[nPosCod] == SG1->G1_COMP .And. x[nPosTRT] == SG1->G1_TRT .And.;
								  x[nPosLotCtl] == CriaVar("D4_LOTECTL") .And. x[nPosLote] == CriaVar("D4_NUMLOTE") .And.;
								  If(nPosLocLz>0,(x[nPosLocLz] == CriaVar("DC_LOCALIZ") .And. x[nPosnSerie] == CriaVar("DC_NUMSERI")),.T.) })
  If lA650ASCOL
    nRetPE := ExecBlock("A650ASCOL",.F.,.F.,{aParamPE,nProcura})
    if valtype(nRetPE) = 'N'
      nProcura := nRetPE
    EndIf
  EndIf

  	If nProcura > 0
		aCols[nProcura,nPosQuant] += nQtdOri
		aCols[nProcura,nPosQtSegum] += ConvUM(SG1->G1_COMP,nQtdOri,0,2)
		If (nProcura := aScan(aColsDele,{|x| x == nProcura})) > 0
			aDel(aColsDele,nProcura)
			aSize(aColsDele,Len(aColsDele)-1)
		EndIf
	Else
		SB1->(MsSeek(xFilial("SB1")+SG1->G1_COMP))
		AADD(aCols,Array(Len(aHeader)+1))
		aCols[Len(aCols),nPosCod    ] := SG1->G1_COMP
		aCols[Len(aCols),nPosQuant  ] := nQtdOri
		aCols[Len(aCols),nPosLocal  ] := If(SB1->B1_APROPRI=="I",cLocProc,RetFldProd(SB1->B1_COD,"B1_LOCPAD"))
		aCols[Len(aCols),nPosTRT    ] := SG1->G1_TRT
		aCols[Len(aCols),nPosLote   ] := CriaVar("D4_NUMLOTE")
		aCols[Len(aCols),nPosLotCtl ] := CriaVar("D4_LOTECTL")
		aCols[Len(aCols),nPosdValid ] := CriaVar("D4_DTVALID")
		aCols[Len(aCols),nPosPotenc ] := CriaVar("D4_POTENCI")
		aCols[Len(aCols),nPosLocLz  ] := CriaVar("DC_LOCALIZ")
		aCols[Len(aCols),nPosnSerie ] := CriaVar("DC_NUMSERI")
		aCols[Len(aCols),nPosUM     ] := SB1->B1_UM
		aCols[Len(aCols),nPosQtSegum] := ConvUM(SG1->G1_COMP,nQtdOri,0,2)
		aCols[Len(aCols),nPos2UM    ] := SB1->B1_SEGUM
		aCols[Len(aCols),nPosDescr  ] := SB1->B1_DESC
		If ValType(uConteudo) != "U"
			aCols[Len(aCols), Len(aHeader)] := &(uTrans)
		EndIf
		aCols[Len(aCols),Len(aHeader)+1]:= .F.
		If lA650ADCOL
			ExecBlock("A650ADCOL",.F.,.F.,aParamPE)
		EndIf
		
		AADD(aOpcCam,cProOpc + cProdOri + SG1->G1_TRT)		
	EndIf
EndIf

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A650Prev  ³ Autor ³Rodrigo de A Sartorio  ³ Data ³09/01/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Checa saldo previsto pendente para gravacao                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A650Prev(ExpC1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Cadastro de produtos                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Mata650                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A650Prev(cProduto)
Local nAchou:= 1
Local nRet  :=0
Local lQtdPrev := SuperGetMV("MV_QTDPREV",.F.,"N")=="S"

While nAchou > 0
	nAchou:=ASCAN(aOpC1,{|x| x[1] == cProduto .And. If(!lQtdPrev,x[11] # "P",.T.)},nAchou)
	If nAchou > 0
		nRet+=aOpc1[nAchou,2]
		nAchou++
	EndIf
EndDo
nAchou:=ASCAN(aOpC7,{|x| x[1] == cProduto .And. If(!lQtdPrev,x[6] # "P",.T.)})
If nAchou > 0
	nRet+=aOpc7[nAchou,2]
EndIf
nAchou:=ASCAN(aDataOpC1,{|x| x[1] == cProduto .And. If(!lQtdPrev,x[11] # "P",.T.)})
If nAchou > 0
	nRet+=aDataOpc1[nAchou,2]
EndIf
nAchou:=ASCAN(aDataOpC7,{|x| x[1] == cProduto .And. If(!lQtdPrev,x[6] # "P",.T.)})
If nAchou > 0
	nRet+=aDataOpc7[nAchou,2]
EndIf
RETURN nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTA250TELA³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 06/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada da listbox para caso de Erro.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros| aErros[nX,1] - Produto                                     ³±±
±±³          | aErros[nX,2] - Local                                       ³±±
±±³          | aErros[nX,3] - Saldo                                       ³±±
±±³          | aErros[nX,4] - Ocorrencia                                  ³±±
±±³          | aErros[nX,5] - Lote                                        ³±±
±±³          | aErros[nX,6] - SubLote                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA250                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA250TELA(aErros)
	Local oDlg, oQual
	Local cCadastro := OemToAnsi("Itens Sem Sld / Bloqs. / Empenhos Pendentes")
	//Local lM250Erro := ExistBlock("M250ERRO")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ M250TELA - Ponto de entrada utilizado para customizacao da   ³
	//|            janela de Itens sem Saldo / bloqueados.           |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("M250TELA")
		ExecBlock("M250TELA",.F.,.F.,{aErros})
	Else
		DEFINE MSDIALOG oDlg TITLE cCadastro From 09,0 To 30.5,123 OF oMainWnd
		@ 0.5,0.5 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Produto"),OemToAnsi("Descrição"),OemToAnsi("Local"),OemToAnsi("Necessidade"),OemToAnsi("Saldo"),OemToAnsi("Ocorrência") SIZE 437.5,150
		oQual:SetArray(aErros)
		oQual:bLine := {|| {aErros[oQual:nAT][1],Posicione("SB1",1,XFILIAL("SB1")+aErros[oQual:nAT][1],"B1_DESC"),aErros[oQual:nAT][2],aErros[oQual:nAT][3],aErros[oQual:nAT][4],aErros[oQual:nAT][5]}}
		oQual:lHScroll := .F.
		DEFINE SBUTTON FROM 50,450  TYPE 1 ACTION (oDlg:End()) ENABLE OF oDlg
		//DEFINE SBUTTON FROM 65 ,260  TYPE 6 ACTION (If(lM250Erro,ExecBlock("M250ERRO",.F.,.F.,{aErros}),A250ERRO(aErros)) ) ENABLE OF oDlg
		If aErros[1][6] # Nil
			DEFINE SBUTTON FROM 80 ,260  TYPE 15 ACTION (A250BLQLOT(aErros[oQual:nAT][2],aErros[oQual:nAT][1],aErros[oQual:nAT][6],aErros[oQual:nAT][7])) ENABLE OF oDlg
		EndIf
		ACTIVATE MSDIALOG oDlg
	EndIf
Return NIL
