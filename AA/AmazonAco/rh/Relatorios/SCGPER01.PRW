#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ GPER030  ≥ Autor ≥ Edmilson Dias Santos  ≥ Data ≥ 14.03.95 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Emissao de Recibos de Pagamento                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ GPER030(void)                                              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Generico                                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥         ATUALIZACOES SOFRIDAS DESDE A CONSTRUÄAO INICIAL.             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ ** Alterado por: ClÌstenis Batista Amorim (clistenis@gmail.com)       ≥±±
±±≥ ** Em: 30/11/2017                                                     ≥±±
±±≥ ** Motivo:                                                            ≥±±
±±≥ ** AdaptaÁ„o do fonte para o protheus 12 (em partes)                  ≥±±
±±≥ ** Local: An·polis - Goi·s - www.cltecnologia.com.br (62) 99119-2727  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function SCGPER01()
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define Variaveis Locais (Basicas)                            ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local cString:="SRA"        // alias do arquivo principal (Base)
Local aOrd   := {"Matricula","C.Custo","Nome","C.Custo + Nome"}
Local cDesc1 := "Emissao de Recibos de Pagamento."
Local cDesc2 := "Ser·†impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "usuario."

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define Variaveis Locais (Programa)                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local nExtra,cIndCond,cIndRc
Local Baseaux := "S", cDemit := "N"
Local aRegs   := {}
Local aPergs  := {}
Local cDpto	  := 60
Private dDataRef := StoD("")
Private aSM0 	:= AdmAbreSM0()

Public _oPrint

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define o numero da linha de impress„o como 0                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//SetPrc(0,0)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define Variaveis Private(Basicas)                            ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Private aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }	//"Zebrado"###"AdministraáÑo"
Private nomeprog :="GPER030"
Private aLinha   := { },nLastKey := 0
Private cPerg    :="RGPE01"//+space(4) Clistenis
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
Private cCompac , cNormal
Private aDriver

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define Variaveis Private(Programa)                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Private aFunc  := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := _PROW()
Private Titulo := "EMISSAO DE RECIBOS DE PAGAMENTOS"
Private nTamanho	:= "M"
Private limite		:= 132

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Envia controle para a funcao SETPRINT                        ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
wnrel:="RELLAS" //Nome Default do relatorio em Disco
Pergunte(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho )

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define a Ordem do Relatorio                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
nOrdem :=  aReturn[8]

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Carregando variaveis mv_par?? para Variaveis do Sistema.     ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
dDataRef   := mv_par01
nTipRel    := 1
Esc        := mv_par02
cFilDe     := mv_par03			//Filial De
cFilAte    := mv_par04			//Filial Ate
cCcDe      := mv_par05			//Centro de Custo De
cCcAte     := mv_par06			//Centro de Custo Ate
cMatDe     := mv_par07			//Matricula Des
cMatAte    := mv_par08			//Matricula Ate
cNomDe     := mv_par09		      	//Nome De
cNomAte    := mv_par10		       	//Nome Ate
Mensag11   := substr(mv_par11,1,1) 	//Mensagem 1
Mensag12   := substr(mv_par11,2,1) 	//Mensagem 1
Mensag21   := substr(mv_par12,1,1)	//Mensagem 2
Mensag22   := substr(mv_par12,2,1)	//Mensagem 1
Mensag31   := substr(mv_par13,1,1)	//Mensagem 3
Mensag32   := substr(mv_par13,2,1)	//Mensagem 1
Mensag4    := mv_par14				//Mensagem 3
Mensag5    := mv_par15				//Mensagem 3
cTit	   := mv_par19
cSituacao  := mv_par16	//Situacoes a Imprimir
cCategoria := mv_par17	//Categorias a Imprimir
cBaseAux   := If(mv_par18 == 1,"S","N")	//Imprimir Bases

If aReturn[5] == 1 .and. nTipRel == 1
	li	:=  0
	// Return
EndIf

//cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
cAnoMesRef := StrZero(Year(dDataRef),4) + StrZero(Month(dDataRef),2)
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Inicializa Impressao                                         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !fInicia(cString,nTipRel)
	Return
Endif


//MsgRun("Gerando relatÛrio, aguarde...", "", {|| CursorWait(), R030IMPL(@lEnd,wnRel,cString,cAnoMesRef), CursorArrow()})

RptStatus({|lEnd| R030ImpL(@lEnd,wnRel,cString,cAnoMesRef)},Titulo)  // Chamada do Relatorio

Return(  NIL )

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ R030IMP  ≥ Autor ≥ R.H. - Ze Maria       ≥ Data ≥ 14.03.95 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Processamento Para emissao do Recibo                       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ R030Imp(lEnd,WnRel,cString,cAnoMesRef,lTerminal)			  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Generico                                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function R030ImpL(lEnd,WnRel,cString,cAnoMesRef)
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Define Variaveis Locais (Basicas)                            ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
Local lIgual                 //Vari†vel de retorno na comparaáao do SRC
Local cArqNew                //Vari†vel de retorno caso SRC # SX3
Local aOrdBag     := {}
//Local cMesArqRef  := If(Esc == 4,"13"+Right(cAnoMesRef,4),cAnoMesRef)
Local cMesArqRef  := If(Esc == 4,"13"+Left(cAnoMesRef,4),cAnoMesRef)
Local cArqMov     := ""
//Local aCodBenef   := {}
Local cNroHoras   := ""
Local nHoras      := 0
Local nMes, nAno
Local nAux			:= 0

Public cDescDpto  := ""		//-- DescriÁ„o do Departamento

Public cCodFunc	  := ""		//-- codigo da Funcao do funcionario
Public cDescFunc  := ""		//-- Descricao da Funcao do Funcionario
Public _n         := 1

Private cAliasMov := ""
private aCodBenef  := {}
Private cDtPago
Private cPict1	:=	"@E 999,999,999.99"
Private cPict2 	:= 	"@E 99,999,999.99"
Private cPict3 	:=	"@E 999,999.99"
If MsDecimais(1) == 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

If Esc == 4
	//cMesArqRef := "13" + Right(cMesAnoRef,4)
	cMesArqRef := "13" + Left(cAnoMesRef,4)
Else
	cMesArqRef := cAnoMesRef
Endif

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//| Verifica se existe o arquivo de fechamento do mes informado  |
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL  )
//	Return(  NIL  )
//Endif

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Selecionando a Ordem de impressao escolhida no parametro.    ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
dbSelectArea( "SRA")

If nOrdem == 1
	dbSetOrder(1)
ElseIf nOrdem == 2
	dbSetOrder(2)
ElseIf nOrdem == 3
	dbSetOrder(3)
ElseIf nOrdem == 4
	dbSetOrder(8)
Endif

dbGoTop()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Selecionando o Primeiro Registro e montando Filtro.          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If nOrdem == 1
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	dbSeek(cFilDe + cMatDe,.T.)
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif

dbSelectArea("SRA")
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Carrega Regua Processamento                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
SetRegua(RecCount())	// Total de elementos da regua

aFunc  :={}         // Zera Lancamentos
aProve :={}         // Zera Lancamentos
aDesco :={}         // Zera Lancamentos
aBases :={}         // Zera Lancamentos
aImpos :={}         // Zera Lancamentos
DESC_MSG:={}
FLAG:= CHAVE := 0

Desc_Fil   := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1  := DESC_MSG2:= DESC_MSG3:= Space(01)
DESC_MSG4  := DESC_MSG5:= Space(62)
cFilialAnt := "  "
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Movimenta Regua Processamento                                ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	
	IncRegua()  // Anda a regua
	
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Consiste Parametrizacao do Intervalo de Impressao            ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If  (SRA->RA_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) .Or. ;
		(SRA->RA_MAT  < cMatDe) .Or. (SRA->RA_MAT  > cMatAte) .Or. ;
		(SRA->RA_CC   < cCcDe ) .Or. (SRA->RA_CC   > cCcAte )
		SRA->(dbSkip(1))
		Loop
	EndIf
	
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Verifica Data Demissao         ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	cSitFunc := SRA->RA_SITFOLH
	//dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4))
	dDtPesqAf:= CTOD("01/" + Right(cAnoMesRef,2) + "/" + Left(cAnoMesRef,4))
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Consiste situacao e categoria dos funcionarios			     |
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
		//nAux := 0 // sampaio 27/11/2017
		SRA->(dbSkip())
		Loop
	Endif
	If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) >= Mesano(dDataRef)
		//nAux := 0 // sampaio 27/11/2017
		SRA->(dbSkip())
		Loop
	Endif
	
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//| Verifica se existe movimento no periodo do mes informado  |
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If nAux == 0
		
		DbSelectArea("SRC")
		SRC->(DbSetOrder(4)) //RC_FILIAL+RC_MAT+RC_PERIODO+RC_ROTEIR+RC_SEMANA+RC_PD
		If SRC->(DbSeek(xFilial("SRC")+SRA->RA_MAT+cAnoMesRef))
			cAliasMov	:= "SRC"
			cNroHoras	:= &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")
		Else
			cAliasMov	:= "SRD"
			cNroHoras	:= &("{ || If(SRD->RD_QTDSEM > 0, SRD->RD_QTDSEM, SRD->RD_HORAS) }")
		Endif
		
		nAux++
	Endif
	
	dbSelectArea("CTT")
	dbSetOrder(1)
	dbSeek(xFilial("CTT")+SRA->RA_CC,.F.)
	fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
	
	aAdd(aFunc,{SRA->RA_MAT,;
	Left(SRA->RA_NOME,28),;
	fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef),;
	SRA->RA_CC,;
	CTT->CTT_DESC01,;
	SRA->RA_Filial ,;
	TRANSFORM(strzero(ORDEM_REL,3),"9999"),;
	cCodFunc,;
	cDescFunc,;
	SRA->RA_SALARIO,;
	MONTH(SRA->RA_NASC),;
	Substr(Sra->Ra_BcDepSal,1,3),;
	SRA->RA_BCDEPSAL,;
	SRA->RA_CTDEPSAL,;
	SRA->RA_CATFUNC,;
	SRA->RA_ADMISSA})
	//SRA->RA_DPTO})//por Lucival R. Lima em 26/03/08, impress„o do departamento.
	
ï	If SRA->RA_Filial # cFilialAnt
		If !Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		DESC_MSG4:=DESC_MSG5:=Space(62)
		
		// MENSAGENS
		If MENSAG11 # SPACE(1) .or. MENSAG12 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG11)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG12)
					DESC_MSG1 := DESC_MSG1 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG12)
					DESC_MSG1 := DESC_MSG1 + Left(SRX->RX_TXT,30)
				Endif
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG11)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG12)
					DESC_MSG1 := DESC_MSG1 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG12)
					DESC_MSG1 := DESC_MSG1 + Left(SRX->RX_TXT,30)
				Endif
			Endif
		Endif
		If MENSAG21 # SPACE(1) .or. MENSAG22 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG21)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG22)
					DESC_MSG2 := DESC_MSG2 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG22)
					DESC_MSG2 := DESC_MSG2 + Left(SRX->RX_TXT,30)
				Endif
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG21)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG22)
					DESC_MSG2 := DESC_MSG2 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG22)
					DESC_MSG2 := DESC_MSG2 + Left(SRX->RX_TXT,30)
				Endif
			Endif
		Endif
		
		If MENSAG31 # SPACE(1) .or. MENSAG32 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG31)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG32)
					DESC_MSG3 := DESC_MSG3 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG32)
					DESC_MSG3 := DESC_MSG3 + Left(SRX->RX_TXT,30)
				Endif
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG31)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
				If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG32)
					DESC_MSG3 := DESC_MSG3 + Left(SRX->RX_TXT,30)
				ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG32)
					DESC_MSG3 := DESC_MSG3 + Left(SRX->RX_TXT,30)
				Endif
			Endif
		Endif
		DESC_MSG4 := Mensag4
		DESC_MSG5 := Mensag5
		
		dbSelectArea("SRA")
		cFilialAnt 	:= SRA->RA_FILIAL
		
	Endif
	aAdd(DESC_MSG,{DESC_MSG1,DESC_MSG2,DESC_MSG3,DESC_MSG4,DESC_MSG5})
	
	dbSelectArea("SRA")
	
	SRA->( dbSkip() )
	_TOTDESC := 0
	_TOTVENC := 0
	_n++
EndDo

fImpressaoL(cAnoMesRef)   // Impressao do Recibo de Pagamento

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Termino do relatorio                                         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
dbSelectArea("SRC")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
SET FILTER TO
RetIndex("SRA")

If !(Type("cArqNtx") == "U")
	fErase(cArqNtx + OrdBagExt())
Endif

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                         M
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥fImpressao≥ Autor ≥ R.H. - Ze Maria       ≥ Data ≥ 14.03.95 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ IMRESSAO DO RECIBO FORMULARIO CONTINUO                     ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ fImpressao()                                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Generico                                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function fImpressaoL(cAnoMesRef)

Local nConta  	 := nContr := nContrT:=0
Local aDriver 	 := LEDriver()
Local _i        := 0
Local _aPos1    := {2000, 1900, 2100, 2300}
Local _aPos2    := {2270, 1900, 2340, 2300}
Local _aBmp 	  := {}
Local _aEmp	  := {}
Local _oFont8   := Nil
Local _oFont8n  := Nil
Local _oFont10  := Nil
Local _oFont12  := Nil
Local _oFont16  := Nil
Local _oFont16n := Nil
Local _oFont24  := Nil
Local _oBrush   := Nil
Local cString   := ""
Local nCol	      := 0
Local _lmesmo	  := .F.
Local _cont	  := 0
Local _pag		  := 0
Local nRegSM0   := SM0->(Recno())
Local cFilBkp   := cFilant
Local _cEmpAnt	:= cEmpAnt
Private TOTVENC := {}
Private TOTDESC := {}
Private aLanca  := {}
Private aImpos  := {}
Private nLinhas :=19              // Numero de Linhas do Miolo do Recibo
Private cCompac := aDriver[1]
Private cNormal := aDriver[2]
Private cFileLogo	:= GetSrvProfString('Startpath','') +'lgrl'+ cEmpant + '.bmp'
Private cFileSeta	:= GetSrvProfString('Startpath','') + 'Seta'   		+ '.bmp'

Ordem_Rel := 1

_oPrint := TMSPrinter():New( "Recibo Laser" )
_oPrint:SetPaperSize(9)	// 1 - Carta / 9 - A4
_oPrint:StartPage()
_oPrint:SetPortrait() // ou SetLandscape()

//Par‚metros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

_oFont8   := TFont():New("Arial", 09, 08,   ,.F.,  ,   ,  ,    , .F.)
_oFont8n  := TFont():New("Arial", 09, 08,.T.,.T., 5,.T., 5, .T., .F.)  //-- 30/11/17 - Clistenis
_oFont10  := TFont():New("Arial", 09, 10,.T.,.F., 5,.T., 5, .T., .F.)
_oFont10n := TFont():New("Arial", 09, 10,.T.,.T., 5,.T., 5, .T., .F.)
_oFont12  := TFont():New("Arial", 09, 12,.T.,.F., 5,.T., 5, .T., .F.)
_oFont16  := TFont():New("Arial", 09, 16,.T.,.F., 5,.T., 5, .T., .F.)
_oFont16n := TFont():New("Arial", 09, 16,.T.,.T., 5,.T., 5, .T., .F.)
_oFont24  := TFont():New("Arial", 09, 24,.T.,.T., 5,.T., 5, .T., .F.)

_oBrush := TBrush():New("",4)

For _I := 1 TO Len(aFunc)
	IF _i <> 3
		_cFilant := aFunc[_I][6]
		_nPSm0 	:= aScan(aSM0, {|x| Upper(AllTrim(X[2])) == _cFilant .and. Upper(AllTrim(X[1]))  == _cEmpAnt  })
		If _nPSm0 <> 0
			
			aLanca   := {}         // Zera Lancamentos
			TOTVENC  := {}
			TOTDESC  := {}
			aImpos   := {}
			cEmp     := _cEmpant
			
			llanca(aFunc[_I][6],aFunc[_I][1],aFunc[_I][4],cAnoMesRef)
			
			_cont:= 0
			_pag := IIf(Abs(Len(aLanca)/19)<=1,1,2)
			z    := 0
			_nctaz := 1
			
			For y:=1 to _pag
				
				_oPrint:StartPage()  //Inicia uma nova p·gina
				
				For z:= 1 to 1
					
					/*⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
					≥ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ≥
					¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ*/
					//viu?
					fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc)
					
					_oPrint:Say(_cont+010, 0850, aSM0[_nPSm0,3], _oFont10) //Empresa - Eduardo
					_oPrint:Say(_cont+045, 0850, aSM0[_nPSm0,4], _oFont10) //EndereÁo - Eduardo
					_oPrint:Say(_cont+080, 0850, aSM0[_nPSm0,5], _oFont10) //CEP - Eduardo
					_oPrint:Say(_cont+115, 0850, aSM0[_nPSm0,7], _oFont10) //CNPJ - Eduardo
					//_oPrint:Say(_cont+115, 0550, aSM0[_nPSm0,8], _oFont10) //InscriÁ„o Estadual - Eduardo
					
					_oPrint:SayBitmap(_cont+020, 100, cFileLogo, 450, 130)
					
					_oPrint:Box(_cont+0180, 0100, _cont+0280, 2300)
					
					_reltipo := "Recibo de Pagamento de Sal·rio"
					
					_oPrint:Say(_cont+0200, 0550,_reltipo, _oFont16)
					_oPrint:Say(_cont+0200, 1790,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4), _oFont16)
					//_oPrint:Say(_cont+0200, 1790,UPPER(MesExtenso(MONTH(dDataRef)))+"/"+STR(YEAR(dDataRef),4), _oFont16)
					_oPrint:Box(_cont+0280, 0100, _cont+0410, 2300) //Box em volta do cabeÁalho
					
					_oPrint:Say(_cont+0280, 0115, "MatrÌcula"				,_oFont8n)
					_oPrint:Say(_cont+0280, 0300, "Nome do Funcion·rio"		,_oFont8n)
					_oPrint:Say(_cont+0280, 0950, "CBO" 					,_oFont8n)
					_oPrint:Say(_cont+0280, 1100, "Centro de Custo" 	 	,_oFont8n)
					_oPrint:Say(_cont+0280, 1400, "Desc. do Cto. Custo"     ,_oFont8n)
					_oPrint:Say(_cont+0280, 1965, "Empresa"					,_oFont8n)
					_oPrint:Say(_cont+0280, 2240, "Fl." 					,_oFont8n)
					
					_oPrint:Say(_cont+0310, 0115, aFunc[_I][1], _oFont8) //codigo
					_oPrint:Say(_cont+0310, 0300, aFunc[_I][2], _oFont8)//nome do funcionario
					_oPrint:Say(_cont+0310, 0950, aFunc[_I][3], _oFont8) //cbo
					_oPrint:Say(_cont+0310, 1100, aFunc[_I][4], _oFont8) //centro de custo 
					_oPrint:Say(_cont+0310, 1400, aFunc[_I][5], _oFont8) //descricao do cto custo
					_oPrint:Say(_cont+0310, 1975, aFunc[_I][6], _oFont8) //empresa
					_oPrint:Say(_cont+0310, 2240, strzero(y,2), _oFont8) //folha
					
					_oPrint:Say(_cont+0340, 0115, "FunÁ„o", _oFont8n)
					//_oPrint:Say(_cont+0340, 0235, aFunc[_I][8], _oFont8)
					_oPrint:Say(_cont+0340, 0300, "DescriÁ„o da funÁ„o", _oFont8n)
					//_oPrint:Say(_cont+0340, 0735, aFunc[_I][9], _oFont8)
					_oPrint:Say(_cont+0340, 0950, "Dt. Admiss„o", _oFont8n)
					//_oPrint:Say(_cont+0340, 1650, dtoc(aFunc[_I][16]), _oFont8)
					_cont += 30
					_oPrint:Say(_cont+0340, 0115, aFunc[_I][8], _oFont8) //funcao
					_oPrint:Say(_cont+0340, 0300, aFunc[_I][9], _oFont8) //descricao do cargo
					_oPrint:Say(_cont+0340, 0950, dtoc(aFunc[_I][16]), _oFont8) //data de admissao
					
					_oPrint:Box(_cont+0390, 0100, _cont+1380, 2300)
					_oPrint:Line(_cont+0450, 0100, _cont+0450, 2300)
					_oPrint:Say(_cont+0400, 0115, "CÛdigo"            , _oFont8n)
					_oPrint:Line(_cont+0390, 0250, _cont+1080, 0250)
					_oPrint:Say(_cont+0400, 0655, "DescriÁ„o"    , _oFont8n)
					_oPrint:Line(_cont+0390, 1150, _cont+1080, 1150)
					_oPrint:Say(_cont+0400, 1152, "ReferÍncia"    , _oFont8n)
					_oPrint:Line(_cont+0390, 1300, _cont+1380, 1300)
					_oPrint:Say(_cont+0400, 1450, "Vencimentos", _oFont8n)
					_oPrint:Line(_cont+0390, 1800, _cont+1380, 1800)
					_oPrint:Say(_cont+0400, 1950, "Descontos"   , _oFont8n)
					
					_w := 0
					nv := 0
					For nConta := _nctaz To Len(aLanca)
						If nConta <= iif(y >= 2,(nlinhas+_nctaz),nlinhas)
							
							_w := _w + 30
							cString := Transform(aLanca[nConta,5],cPict2)
							//nCol    := If(aLanca[nConta,1]="P",1630,If(aLanca[nConta,1]="D",2130,0255))
							nCol    := If(aLanca[nConta,1]="P",1590,If(aLanca[nConta,1]="D",2090,0255))
							_oPrint:Say(_cont+0440+_w, 0155, aLanca[nConta,2] , _oFont8)
							_oPrint:Say(_cont+0440+_w, 0255, aLanca[nConta,3] , _oFont8)
							
							If aLanca[nConta,1] # "B"    // So Imprime se nao for base - Referencias
								If aLanca[nConta,4] <= 9.99
									_oPrint:Say(_cont+0440+_w, 1185, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
								Endif
								If aLanca[nConta,4] <= 99.99 .and. aLanca[nConta,4] > 9.99
									_oPrint:Say(_cont+0440+_w, 1175, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
								Endif
								If aLanca[nConta,4] <= 999.99 .and. aLanca[nConta,4] > 99.99
									_oPrint:Say(_cont+0440+_w, 1165, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
								Endif
							Endif
							If aLanca[nConta,5] <= 9.99  //VALORES
								_oPrint:Say(_cont+0440+_w, nCol+50, cString , _oFont8)
							Endif
							If aLanca[nConta,5] <= 99.99 .and. aLanca[nConta,5] > 9.99
								_oPrint:Say(_cont+0440+_w, nCol+40, cString , _oFont8)
							Endif
							If aLanca[nConta,5] <= 999.99 .and. aLanca[nConta,5] > 99.99
								_oPrint:Say(_cont+0440+_w, nCol+30, cString            , _oFont8)
							Endif
							If aLanca[nConta,5] <= 9999.99 .and. aLanca[nConta,5] > 999.99
								_oPrint:Say(_cont+0440+_w, nCol+20, cString         , _oFont8)
							Endif
							If aLanca[nConta,5] <= 99999.99 .and. aLanca[nConta,5] > 9999.99
								_oPrint:Say(_cont+0440+_w, nCol+10, cString         , _oFont8)
							Endif
							If aLanca[nConta,5] <= 999999.99 .and. aLanca[nConta,5] > 99999.99
								_oPrint:Say(_cont+0440+_w, nCol, cString, _oFont10)
							Endif
							nContr ++
							nContrT ++
							
							//If nContr = nLinhas //.And. nContrT < Len(aLanca)
							If nContr > nLinhas   //.And. nContrT < Len(aLanca)
								nContr:=0
								Ordem_Rel ++
								_w := _w + 30
								_oPrint:Say(_cont+1205, nCol-20, "CONTINUA !!!" , _oFont8)
								
								//Mensagens
								_oPrint:Line(_cont+1080,0100, _cont+1080, 2300)
								
								_oPrint:Say(_cont+1090, 1450, "Total de Vencimentos", _oFont8n)
								_oPrint:Say(_cont+1090, 1950, "Total de Descontos"  , _oFont8n)
								_oPrint:Line(_cont+1180,1300, _cont+1180, 2300)
								_oPrint:Say(_cont+1210, 1315, "Valor Liquido     ====>"   	, _oFont10)
								
								//por Lucival R. Lima, em 27/03/08. Insere a imagem de uma seta
								_oPrint:SayBitmap(_cont+1200, 1700, cFileSeta, 100, 70)
								
								_oPrint:Box(_cont+1280, 0100, _cont+1380, 2300)
								_oPrint:Say(_cont+1295, 0150, "Sal·rio Base"   		, _oFont8n)
								_oPrint:Say(_cont+1295, 0500, "Sal. Contr. INSS"   	, _oFont8n)
								_oPrint:Say(_cont+1295, 1000, "Base C·lc. FGTS"   	, _oFont8n)
								_oPrint:Say(_cont+1295, 1300, "  F.G.T.S. do MÍs"   , _oFont8n)
								_oPrint:Say(_cont+1295, 1558, "Base C·lc. IRRF"		, _oFont8n)
								_oPrint:Say(_cont+1295, 2000, "Faixa IRRF"   		, _oFont8n)
								
								_oPrint:Box(_cont+1390, 0100, _cont+1500, 2300)
								//IF z == 2
									_oPrint:Say(_cont+1395, 0150, "DECLARO TER RECEBIDO A IMPORT¬NCIA LIQUIDA DISCRIMINADA NESTE RECIBO."   , _oFont8)
									_oPrint:Say(_cont+1460, 0150, " ________/________/________  ", _oFont8)
									_oPrint:Say(_cont+1460, 0950, " ____________________________________________________________"   , _oFont8)
									_oPrint:Say(_cont+1500, 0150, "                  DATA                     "  , _oFont8)
									_oPrint:Say(_cont+1500, 1100, " ASSINATURA DO FUNCION¡RIO                              "   , _oFont8)
								//ENDIF
								_oPrint:Say(_cont+1460, 2000,IIF(nConta==1,"    Via-Empregado","          Via-Empresa"), _oFont8)
								_lmesmo := .T.
							Endif
						Endif
					Next nConta
					
					If !_lmesmo .or. (y >= 2 .and. _lmesmo)
						//Mensagens
						
						//_oPrint:Say(_cont+1080, 0115, "ìPara maior participaÁ„o dos funcion·rios nas aÁıes preventivas e", _oFont10)
						//_oPrint:Say(_cont+1110, 0115, "objetivos da companhia, a empresa disponibilizou a Ouvidoria, linha", _oFont10)
						//_oPrint:Say(_cont+1140, 0115, "para reclamaÁıes, oportunidades de melhorias e den˙ncias.î", _oFont10)
						IF MONTH(dDataRef) = aFunc[_I][11]
							//_oPrint:Say(_cont+1170, 0115, "(62) xxxx-xxxx.", _oFont10)
							_oPrint:Say(_cont+1200, 0115, "F E L I Z   A N I V E R S A R I O  ! !", _oFont8n)
							
						ELSE
							_oPrint:Say(_cont+1170, 0115, DESC_MSG[_I][4], _oFont10)
							_oPrint:Say(_cont+1200, 0115, DESC_MSG[_I][5], _oFont10)
						ENDIF
						
						//Mensagens da conta corrente
						IF SRA->RA_BCDEPSAL # SPACE(8)
							If aFunc[_I][12] = "237"
								Desc_Bco := "Banco Bradesco "
							ElseIF aFunc[_I][12] = "001"
								Desc_Bco := "Banco do Brasil "
							ElseIf aFunc[_I][12] = "341"
								Desc_Bco := "Banco Ita˙ "
							ElseIf aFunc[_I][12] = "033"
								Desc_Bco := "Banco Santander "
							Endif
							_oPrint:Say(_cont+1230, 0115, "CRED: "+aFunc[_I][13]+" - "+DESC_BCO+"CONTA:" + aFunc[_I][14], _oFont8)
						//ELSE
						//	Desc_Bco := "  "
						ENDIF
						//_oPrint:Say(_cont+1230, 0115, "BANCO/AGENCIA: "+ SUBSTR(aFunc[_I][13],1,3)+"/"+ SUBSTR(aFunc[_I][13],4,8)+" - "+ DESC_BCO +"   CONTA:" + aFunc[_I][14], _oFont8)
												
						_oPrint:Line(_cont+1080, 0100, _cont+1080, 2300)
						
						_oPrint:Say(_cont+1090, 1450, "Total de Vencimentos", _oFont8n)
						_oPrint:Say(_cont+1090, 1950, "Total de Descontos"  , _oFont8n)
						
						_oPrint:Line(_cont+1180, 1300, _cont+1180, 2300)
						
						_oPrint:Say(_cont+1210, 1315, "Valor Liquido     ====>"   	, _oFont10)
						
						//por Lucival R. Lima, em 27/03/08. Insere a imagem de uma seta
						_oPrint:SayBitmap(_cont+1200, 1700, cFileSeta, 100, 70)
						
						If TOTVENC[1][2] <= 9.99
							//_oPrint:Say(_cont+1130, 1660,TRANSFORM(TOTVENC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 16230,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
						Endif
						If TOTVENC[1][2] <= 99.99 .and. TOTVENC[1][2] > 9.99
							//_oPrint:Say(_cont+1130, 1650,TRANSFORM(TOTVENC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 1620,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
						Endif
						If TOTVENC[1][2] <= 999.99 .and. TOTVENC[1][2] > 99.99
							//_oPrint:Say(_cont+1130, 1640,TRANSFORM(TOTVENC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 1590,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
						Endif
						If TOTVENC[1][2] <= 9999.99 .and. TOTVENC[1][2] > 999.99
							//_oPrint:Say(_cont+1130, 1630,TRANSFORM(TOTVENC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 1600,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
						Endif
						If TOTVENC[1][2] <= 99999.99 .and. TOTVENC[1][2] > 9999.99
							//_oPrint:Say(_cont+1130, 1620,TRANSFORM(TOTVENC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 1590,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
						Endif
						If TOTVENC[1][2] <= 999999.99 .and. TOTVENC[1][2] > 99999.99
							//_oPrint:Say(_cont+1130, 1610,TRANSFORM(TOTVENC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 1550,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
						Endif
						
						If TOTDESC[1][2] <= 9.99
							//_oPrint:Say(_cont+1130, 2160,TRANSFORM(TOTDESC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 2130,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
						Endif
						If TOTDESC[1][2] <= 99.99 .and. TOTDESC[1][2] > 9.99
							//_oPrint:Say(_cont+1130, 2150,TRANSFORM(TOTDESC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 2120,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
						Endif
						If TOTDESC[1][2] <= 999.99 .and. TOTDESC[1][2] > 99.99
							//_oPrint:Say(_cont+1130, 2140,TRANSFORM(TOTDESC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 2110,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
						Endif
						If TOTDESC[1][2] <= 9999.99 .and. TOTDESC[1][2] > 999.99
							//_oPrint:Say(_cont+1130, 2130,TRANSFORM(TOTDESC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 2100,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
						Endif
						If TOTDESC[1][2] <= 99999.99 .and. TOTDESC[1][2] > 9999.99
							//_oPrint:Say(_cont+1130, 2120,TRANSFORM(TOTDESC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 2090,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
						Endif
						If TOTDESC[1][2] <= 999999.99 .and. TOTDESC[1][2] > 99999.99
							//_oPrint:Say(_cont+1130, 2110,TRANSFORM(TOTDESC[1][2],cPict1), _oFont10n)
							_oPrint:Say(_cont+1130, 2080,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
						Endif
						
						If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9.99
							//_oPrint:Say(_cont+1205, 2160,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont10n)
							_oPrint:Say(_cont+1205, 2140,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
						Endif
						If (TOTVENC[1][2]-TOTDESC[1][2]) <= 99.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9.99
							//_oPrint:Say(_cont+1205, 2150,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont10n)
							_oPrint:Say(_cont+1205, 2130,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
						Endif
						If (TOTVENC[1][2]-TOTDESC[1][2]) <= 999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99.99
							//_oPrint:Say(_cont+1205, 2140,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont10n)
							_oPrint:Say(_cont+1205, 2120,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
						Endif
						If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 999.99
							//_oPrint:Say(_cont+1205, 2130,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont10n)
							_oPrint:Say(_cont+1205, 2110,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
						Endif
						If (TOTVENC[1][2]-TOTDESC[1][2]) <= 99999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9999.99
							//_oPrint:Say(_cont+1205, 2120,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont10n)
							_oPrint:Say(_cont+1205, 2100,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
						Endif
						If (TOTVENC[1][2]-TOTDESC[1][2]) <= 999999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99999.99
							//_oPrint:Say(_cont+1205, 2110,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont10n)
							_oPrint:Say(_cont+1205, 2090,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
						Endif
						
						_oPrint:Box(_cont+1280, 0100, _cont+1380, 2300)
						_oPrint:Say(_cont+1295, 0150, "Sal·rio Base"   		, _oFont8n)
						_oPrint:Say(_cont+1295, 0500, "Sal. Contr. INSS"   	, _oFont8n)
						_oPrint:Say(_cont+1295, 0800, "Base C·lc. FGTS"   	, _oFont8n)
						_oPrint:Say(_cont+1295, 1300, "  F.G.T.S. do MÍs"   , _oFont8n)
						_oPrint:Say(_cont+1295, 1558, "Base C·lc. IRRF"		, _oFont8n)
						_oPrint:Say(_cont+1295, 2000, "Faixa IRRF"   		, _oFont8n)
						
						If !Empty( cAliasMov )
							nValSal := 0
							//nValSal := fBuscaSal(dDataRef)
							If nValSal ==0
								nValSal := aFunc[_I][10]
							EndIf
						Else
							nValSal := aFunc[_I][10]
						EndIf
						_oPrint:Say(_cont+1325, 0150, Transform(nValSal,cPict2) , _oFont8)
						
						If Esc = 1  // Bases de Adiantamento
							If cBaseAux = "S" .And. aImpos[1][1] # 0
								_oPrint:Say(_cont+1325, 1600, TRANSFORM(aImpos[1][1],cPict1), _oFont8)
							Endif
						ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
							If cBaseAux = "S"
								_oPrint:Say(_cont+1325, 0500,Transform(aImpos[1][2],cPict1), _oFont8)
								If aImpos[1][3] # 0
									_oPrint:Say(_cont+1325, 0800, TRANSFORM(aImpos[1][3],cPict1), _oFont8)
								Endif
								If aImpos[1][4] # 0
									_oPrint:Say(_cont+1325, 1300,TRANSFORM(aImpos[1][4],cPict2), _oFont8)
								Endif
								If aImpos[1][1] # 0
									_oPrint:Say(_cont+1325, 1600,TRANSFORM(aImpos[1][1],cPict1), _oFont8)
								Endif
								_oPrint:Say(_cont+1325, 2000, Transform(aImpos[1][5],cPict1), _oFont8)
							Endif
						ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1¶ Parcela
							If cBaseAux = "S"
								If aImpos[1][3] # 0
									_oPrint:Say(_cont+1325, 0800,TRANSFORM(aImpos[1][3],cPict1), _oFont8)
								Endif
								If aImpos[1][4] # 0
									_oPrint:Say(_cont+1325, 1300, TRANSFORM(aImpos[1][4],cPict2), _oFont8)
								Endif
							Endif
						ElseIf Esc = 5 //Base IR PLR
							If cBaseAux = "S" .And. aImpos[1][1] # 0
								_oPrint:Say(_cont+1325, 1600, TRANSFORM(aImpos[1][1],cPict1), _oFont8)
							Endif
						Endif
						
						//_oPrint:Box(_cont+1390, 0100, _cont+1500, 2300)
						_oPrint:Box(_cont+1390, 0100, _cont+1550, 2300)
						//If z== 2
							_oPrint:Say(_cont+1395, 0150, "DECLARO TER RECEBIDO A IMPORT¬NCIA LIQUIDA DISCRIMINADA NESTE RECIBO."   , _oFont8)
							_oPrint:Say(_cont+1460, 0150, " ________/________/________  ", _oFont8)
							_oPrint:Say(_cont+1460, 0950, " ____________________________________________________________"   , _oFont8)
							_oPrint:Say(_cont+1500, 0150, "                  DATA                     "  , _oFont8)
							_oPrint:Say(_cont+1500, 1100, " ASSINATURA DO FUNCION¡RIO                              "   , _oFont8)
							//_oPrint:Say(_cont+1490, 1900, "Via-Empresa" , _oFont10n)
						//Endif
						_oPrint:Say(_cont+1490, 2000, IIF(Z==1,"    Via-Empregado","          Via-Empresa" ), _oFont8)
						
					Endif
					_lmesmo	:= .F.
					
					If z==1
						For i := 100 to 2300 step 50
							//_oPrint:Line(1540, i, 1540, i + 30)
							_oPrint:Line(1590, i, 1590, i + 30)
						Next i
						//_cont  := 1590
						_cont  := 1630
					Endif
					nContr := 0
					
				Next
				
				//			SM0->(DbCloseArea())
				//			RestArea(_aSM0)
				_aEmp  := {}
				_cont  := 0
				
				_oPrint:EndPage()     // Finaliza a p·gina
				_nctaz := 20
				
			Next
		Else
			MsgAlert(cValtoChar(_I))
		EndIF
	EndIF
Next

_oPrint:Preview()   // Visualiza antes de imprimir
cFilAnt := cFilBkp

Return Nil

//======================================================
Static Function llanca(_codFil,_codMat,_codCC,_cAnoMes)
//======================================================

local aArea := getArea()
local aAreaSRA	:= SRA->( getArea() )
local aAreaSRC	:= SRC->( getArea() )
local aAreaSRD	:= SRD->( getArea() )

Local cNroHoras := IIF(cAliasMov == "SRC",&("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }"),&("{ || If(SRD->RD_QTDSEM > 0, SRD->RD_QTDSEM, SRD->RD_HORAS) }"))
Local cPrefCpo	:= IF(cAliasMov == "SRC","RC","RD")

Local cSeek		:= ""
Local cCond		:= ""

Local cSeekCC	:= ""
Local cCondCC	:= ""

nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
_TOTVENC := 0
_TOTDESC := 0
Esc      := mv_par02

If Esc == 4 //2 parcela
	_cAnoMes := Soma1(_cAnoMes)
Endif

dbSelectArea("SRA")
dbgotop()
dbsetorder(1)
dbSeek(_codFil+_codmat)

cSeek	:= IIF(cAliasMov == "SRC",_codFil+_codmat,_codFil+_codmat+_cAnoMes)
cCond	:= IIF(cAliasMov == "SRC","SRC->(RC_FILIAL+RC_MAT) == SRA->RA_FILIAL+SRA->RA_MAT",;
"SRD->(RD_FILIAL+RD_MAT+RD_DATARQ) == SRA->RA_FILIAL+SRA->RA_MAT+_cAnoMes")

cSeekCC	:= IIF(cAliasMov == "SRC",_codFil+_codcc+_codmat,_codFil+_codcc+_codmat+_cAnoMes)
cCondCC	:= IIF(cAliasMov == "SRC","SRC->(RC_FILIAL+RC_CC+RC_MAT) == SRA->RA_FILIAL+SRA->RA_CC+SRA->RA_MAT",;
"SRD->(RD_FILIAL+RD_CC+RD_MAT+RD_DATARQ) == SRA->RA_FILIAL+SRA->RA_CC+SRA->RA_MAT+_cAnoMes")

If Esc == 1 .OR. Esc == 2  // adto ou folha
	dbSelectArea(cAliasMov)
	dbSetOrder(1)
	If dbSeek(cSeek,.T.)
		While !Eof() .And. &cCond
			If (Esc == 1) .And. (&(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[7,1]) .and. ( &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )    // Desconto de Adto
				fSomaPd("P",aCodFol[6,1],Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				//alert (&(cAliasMov+ "->" + cPrefCpo + "_VALOR"))
				_TOTVENC += &(cAliasMov+ "->" + cPrefCpo + "_VALOR")// .and. &(cAliasMov + "->" + cPrefCpo + "_ROTEIR") == "FOL"
				//_TOTVENC += &(cAliasMov+ "->" + cPrefCpo + "_VALOR") .and. &(cAliasMov + "->" + cPrefCpo + "_ROTEIR") == "FOL"
			Elseif (Esc == 1) .And. (&(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[12,1])
				fSomaPd("D",aCodFol[9,1],Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				_TOTDESC += &(cAliasMov+ "->" + cPrefCpo + "_VALOR") //.and. &(cAliasMov + "->" + cPrefCpo + "_ROTEIR") == "FOL"
				//_TOTDESC += &(cAliasMov+ "->" + cPrefCpo + "_VALOR") .and. &(cAliasMov + "->" + cPrefCpo + "_ROTEIR") == "FOL"
			Elseif (Esc == 1) .And. (&(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[8,1])
				fSomaPd("P",aCodFol[8,1],Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				_TOTVENC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Else
				If PosSrv( &(cAliasMov+"->"+cPrefCpo+"_PD") , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1" .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI")
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
							LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
						Else
							nHoras := Eval(cNroHoras)
						Endif
						If Esc == 1 .And. SRV->RV_ADIANTA == "S"
							fSomaPd("P",&(cAliasMov+"->"+cPrefCpo+"_PD"),nHoras,&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
							_TOTVENC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")
						ElseIf Esc == 2 .And. SRV->RV_ADIANTA != "S" 
							fSomaPd("P",&(cAliasMov+"->"+cPrefCpo+"_PD"),nHoras,&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
							_TOTVENC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")
						EndIf
					Endif
				Elseif SRV->RV_TIPOCOD == "2" .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						fSomaPd("D",&(cAliasMov+"->"+cPrefCpo+"_PD"),Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
						_TOTDESC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")
					Endif
				Elseif SRV->RV_TIPOCOD == "3" .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						fSomaPd("B",&(cAliasMov+"->"+cPrefCpo+"_PD"),Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
					Endif
				Endif
			Endif
			If ESC = 1
				If &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[10,1] .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )
					nBaseIr := &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Endif
			ElseIf &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[13,1] .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )
				nAteLim += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") $ aCodFol[108,1]+'*'+aCodFol[17,1] .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )
				nBaseFgts += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") $ aCodFol[109,1]+'*'+aCodFol[18,1] .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )
				nFgts += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[15,1] .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )
				nBaseIr += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[16,1] .and. (&(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "FOL" .Or. &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "ADI" )
				nBaseIrFe += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Endif
			dbSelectArea(cAliasMov)
			dbSkip()
		Enddo
	Endif
Elseif Esc == 3 //1 parcela
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Busca os codigos de pensao definidos no cadastro beneficiario≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	//fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
	dbSelectArea(cAliasMov)
	dbSetOrder(1)
	If dbSeek(cSeek,.T.)
		While !Eof()  .And. &cCond
						//ALERT (aCodFol[22,1])
			If &(cAliasMov+"->"+cPrefCpo+"_PD")== aCodFol[22,1]// 290 - 13∫ 1™ Parcela
				fSomaPd("P",&(cAliasMov+"->"+cPrefCpo+"_PD"),Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				_TOTVENC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD")== '294' //ATS 13 Salario
				fSomaPd("P",&(cAliasMov+"->"+cPrefCpo+"_PD"),Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				_TOTVENC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD")== '306' //Media 13∫ Horas
				fSomaPd("P",&(cAliasMov+"->"+cPrefCpo+"_PD"),Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				_TOTVENC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD")== '307' //Media 13∫ Valor
				fSomaPd("P",&(cAliasMov+"->"+cPrefCpo+"_PD"),Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				_TOTVENC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")				
			Elseif Ascan(aCodBenef, { |x| x[1] == &(cAliasMov+"->"+cPrefCpo+"_PD") }) > 0
				fSomaPd("D",&(cAliasMov+"->"+cPrefCpo+"_PD"),Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				_TOTDESC+=&(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[108,1] .Or. &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[109,1] .Or. &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[173,1]
				fSomaPd("B",&(cAliasMov+"->"+cPrefCpo+"_PD"),Eval(cNroHoras),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
			Endif
			
			If &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[108,1]
				nBaseFgts := &(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[109,1]
				nFgts     := &(cAliasMov+"->"+cPrefCpo+"_VALOR")
			Endif
			dbSelectArea(cAliasMov)
			dbSkip()
		Enddo
	Endif
Elseif Esc == 4 //2 parcela
	dbSelectArea(cAliasMov)
	dbSetOrder(2)
	If dbSeek(cSeekCC)
		While !Eof() .And. &cCondCC
			If &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "132"
				If PosSrv( &(cAliasMov+"->"+cPrefCpo+"_PD") , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",&(cAliasMov+"->"+cPrefCpo+"_PD"),&(cAliasMov+"->"+cPrefCpo+"_HORAS"),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
					_TOTVENC = _TOTVENC + &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",&(cAliasMov+"->"+cPrefCpo+"_PD"),&(cAliasMov+"->"+cPrefCpo+"_HORAS"),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
					_TOTDESC = _TOTDESC + &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",&(cAliasMov+"->"+cPrefCpo+"_PD"),&(cAliasMov+"->"+cPrefCpo+"_HORAS"),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				Endif
				
				If &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[19,1]
					nAteLim += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") $ aCodFol[108,1]
					nBaseFgts += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") $ aCodFol[109,1]
					nFgts += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Elseif &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[27,1]
					nBaseIr += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Endif
			Endif
			
			dbSkip()
		Enddo
	Endif
	
Elseif Esc == 5 //PLR/PPR
	dbSelectArea(cAliasMov)
	dbSetOrder(1)
	If dbSeek(cSeek)
		While !Eof() .And. &cCond
			If &(cAliasMov+"->"+cPrefCpo+"_ROTEIR") == "PLR"
				If PosSrv( &(cAliasMov+"->"+cPrefCpo+"_PD") , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPd("P",&(cAliasMov+"->"+cPrefCpo+"_PD"),&(cAliasMov+"->"+cPrefCpo+"_HORAS"),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
					_TOTVENC = _TOTVENC + &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPd("D",&(cAliasMov+"->"+cPrefCpo+"_PD"),&(cAliasMov+"->"+cPrefCpo+"_HORAS"),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
					_TOTDESC = _TOTDESC + &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPd("B",&(cAliasMov+"->"+cPrefCpo+"_PD"),&(cAliasMov+"->"+cPrefCpo+"_HORAS"),&(cAliasMov+"->"+cPrefCpo+"_VALOR"),&(cAliasMov+"->"+cPrefCpo+"_MAT"))
				Endif
				
				if &(cAliasMov+"->"+cPrefCpo+"_PD") == aCodFol[835,1]
					nBaseIr += &(cAliasMov+"->"+cPrefCpo+"_VALOR")
				endif
			Endif
			dbskip()
		Enddo
	Endif
Endif

dbSelectArea("SRA")

aAdd(TOTVENC,{_n, _TOTVENC})
aAdd(TOTDESC,{_n, _TOTDESC})

aAdd(aImpos,{nBaseIr,;
nAteLim,;
nBaseFgts,;
nFgts,;
nBaseIrFe})

restArea( aArea )
restArea( aAreaSRA )
restArea( aAreaSRC )
restArea( aAreaSRD )

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥fSomaPd   ≥ Autor ≥ R.H. - Mauro          ≥ Data ≥ 24.09.95 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Somar as Verbas no Array                                   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥ fSomaPd(Tipo,Verba,Horas,Valor)                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function fSomaPd(cTipo,cPd,nHoras,nValor,cMat)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor,cMat,_n})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

/*//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
	Aadd(&cArray,_n,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[_n,nPos,2] += nHoras
	&cArray[_n,nPos,3] += nValor
Endif
*/
Return

*-------------------------------------------------------
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA
*-------------------------------------------------------
Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥fInicia   ∫Autor  ≥Natie               ∫ Data ≥  04/12/01   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Inicializa parametros para impressao                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP5                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function  fInicia(cString,nTipoRel)

aDriver := LEDriver()

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F.
Endif

SetDefault(aReturn,cString)

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T.

Static Function CriaPerg(cPerg)
//mv_par01 	C3Da Matricula
//mv_par02   C3  Ate a Matricula

U_xPutSx1(cPerg, "01", "Data de Referencia      ?", "", "",;
"mv_ch1", "D", 8, 0, 0, "G", "naovazio", "", "", "",;
"mv_par01", "","", "", "",;
"" ,"", "","",;
"","", "", "",;
"","", "", "",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "02", "Imprimir Recibos         ?", "", "",;
"mv_ch2", "N", 1, 0, 0, "C", "", "", "", "",;
"mv_par02", "Adto."     ,"", "", "",;
"Folha"     ,"", "", "",;
"1¶Parc."   ,"", "", "",;
"2¶Parc."   ,"", "", "",;
"PLR/PPR","", "", "",;
"","")
U_xPutSx1(cPerg, "03", "De Filial      ?", "", "",;
"mv_ch3", "C", 2, 0, 0, "G", "naovazio", "", "", "",;
"mv_par03", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "XM0", "",;
"","")
U_xPutSx1(cPerg, "04", "Ate Filial     ?", "", "",;
"mv_ch4", "C", 2, 0, 0, "G", "naovazio", "", "", "",;
"mv_par04", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "XM0", "",;
"","")
U_xPutSx1(cPerg, "05", "De Centro de Custo     ?", "", "",;
"mv_ch5", "C", 9, 0, 0, "G", "naovazio", "", "", "",;
"mv_par05", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "CTT", "",;
"","")
U_xPutSx1(cPerg, "06", "Ate Centro de Custo      ?", "", "",;
"mv_ch6", "C", 9, 0, 0, "G", "naovazio", "", "", "",;
"mv_par06", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "CTT", "",;
"","")
U_xPutSx1(cPerg, "07", "De Matricula      ?", "", "",;
"mv_ch7", "C", 6, 0, 0, "G", "naovazio", "", "", "",;
"mv_par07", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "SRA", "",;
"","")
U_xPutSx1(cPerg, "08", "Ate Matricula     ?", "", "",;
"mv_ch8", "C", 6, 0, 0, "G", "naovazio", "", "", "",;
"mv_par08", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "SRA", "",;
"","")
U_xPutSx1(cPerg, "09", "De Nome      ?", "", "",;
"mv_ch9", "C", 30, 0, 0, "G", "naovazio", "", "", "",;
"mv_par09", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "10", "Ate Nome      ?", "", "",;
"mv_chA", "C", 30, 0, 0, "G", "naovazio", "", "", "",;
"mv_par10", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "11", "Mensagem 1      ?", "", "",;
"mv_chB", "C", 2, 0, 0, "G", "", "", "", "",;
"mv_par11", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "12", "Mensagem 2      ?", "", "",;
"mv_chC", "C", 2, 0, 0, "G", "", "", "", "",;
"mv_par12", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "13", "Mensagem 3     ?", "", "",;
"mv_chD", "C", 2, 0, 0, "G", "", "", "", "",;
"mv_par13", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "14", "Mensagem 4      ?", "", "",;
"mv_chE", "C", 62, 0, 0, "G", "", "", "", "",;
"mv_par14", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "15", "Mensagem 5      ?", "", "",;
"mv_chF", "C", 62, 0, 0, "G", "", "", "", "",;
"mv_par15", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "16", "Situacoes a Imp.      ?", "", "",;
"mv_chG", "C", 5, 0, 0, "G", "fSituacao", "", "", "",;
"mv_par16", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "17", "Categorias a Imp.  ?", "", "",;
"mv_chH", "C", 15, 0, 0, "G", "fCategoria", "", "", "",;
"mv_par17", "","", "","",;
"","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")
U_xPutSx1(cPerg, "18", "imprime Bases ?", "", "",;
"mv_chI", "C", 1, 0, 0, "C", "", "", "", "",;
"mv_par18", "Sim","", "","",;
"Nao","", "","",;
"","", "","",;
"","", "","",;
"","", "", "",;
"","")

AjustaSx1("RECPAG",aPergs)

Return


Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ		:= 0

aCposSX1:={	"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		//U_xPutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

Return()

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Fun??o    ≥AdmAbreSM0≥ Autor ≥ Orizio                ≥ Data ≥ 22/01/10 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descri??o ≥Retorna um array com as informacoes das filias das empresas ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Generico                                                   ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function AdmAbreSM0()
Local aArea			:= SM0->( GetArea() )
Local aAux			:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

//If lFWLoadSM0
//	aRetSM0	:= FWLoadSM0()
//Else
DbSelectArea( "SM0" )
SM0->( DbGoTop() )
While SM0->( !Eof() )
	aAux := { 	SM0->M0_CODIGO,;
	SM0->M0_CODFIL ,;
	SM0->M0_NOMECOM,;
	SUBSTR(AllTrim(SM0->M0_ENDCOB),1,30)+ "," +SUBSTR(AllTrim(SM0->M0_BAIRCOB),1,20),;
	AllTrim(SM0->M0_CIDCOB) + ", " + SM0->M0_ESTCOB+ " , "+"CEP: " + Transform(SM0->M0_CEPCOB, "@R 99999-999"),;
	"PABX/FAX: 55 " + SUBSTR(SM0->M0_TEL,3,2)+" "+SUBSTR(SM0->M0_TEL,5,4)+" "+SUBSTR(SM0->M0_TEL,9,4)+" / 55 "+ SUBSTR(SM0->M0_FAX,3,2)+" "+SUBSTR(SM0->M0_FAX,5,4)+" "+SUBSTR(SM0->M0_FAX,9,4),;
	"CNPJ : " 		+ Transform(SM0->M0_CGC, "@R 99.999.999/9999-99"),;
	"I.E.: " 		+ Transform(SM0->M0_INSC, "@R 999.999.999.999"),;
	SM0->M0_FILIAL }
	
	aAdd( aRetSM0, aClone( aAux ) )
	SM0->( DbSkip() )
End
//EndIf
RestArea( aArea )

Return aRetSM0
