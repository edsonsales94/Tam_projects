#INCLUDE "Protheus.ch"
#INCLUDE "Font.ch"
#INCLUDE "Colors.ch"
#INCLUDE "RWMAKE.CH"


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COnfig ³ Autor ³ Rogerio B.Oliveira   ³ Data ³ 01.03.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de Configurador Estrutura	                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function config()

Local _aCores := {{'!Empty(B1_X_POS01)' , 'ENABLE' },;
{'Empty(B1_X_POS01)' , 'DISABLE'}}
SetPrvt("_ARETORNO")

_aRetorno		:= {}

cCadastro := OEMTOANSI("COEL  - Configurador de Produtos")

aRotina := {{"Pesquisar","AxPesqui",0,1},;
{"Criar","U_PFTELA('A')",0,2},;
{"Legenda", "U_PFLEG()",0,2}}



dbSelectArea("SB1")
dbSetOrder(1)
//dbGotop()

SET FILTER TO B1_TIPO $ "PA/PI" //.AND. !EMPTY(B1_X_POS01)

mBrowse(06,01,22,75,"SB1",,,,,,_aCores)

SET FILTER TO
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PFLEG     ³ Autor ³ Wilson A. da Cruz    ³ Data ³ 19.09.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela contendo a legenda da mBrowse              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PFLEG()
Local aLegenda := {{"ENABLE"	, "Produto base" },;
{"DISABLE"	, "Outros produtos" }}

cCadastro := OEMTOANSI("Configurador de Produtos")

BrwLegenda(cCadastro,"Legenda",aLegenda)

Return .T.
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PFTELA    ³ Autor ³ Wilson A. da Cruz    ³ Data ³ 19.09.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Apresenta dados do canhoto para atualizacao e visualizacao ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Perflex                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PFTELA(_cTipo)
// Variaveis Locais da Funcao
Private cCod		:= SB1->B1_COD
Private cdesc		:= SB1->B1_DESCOMP
Private ctipo		:= SB1->B1_TIPO
Private cUm     	:= SB1->B1_UM
Private cLocPad     := SB1->B1_LOCPAD
Private cGrupo      := SB1->B1_GRUPO
Private cUm         := SB1->B1_UM
Private cPIcm       := SB1->B1_PICM
Private cIPI        := SB1->B1_IPI
Private cPosIpi     := SB1->B1_POSIPI
Private cOrigem     := SB1->B1_ORIGEM
Private cClStatu    := SB1->B1_CLSTATU
Private cDescomp    := SB1->B1_DESCOMP
Private cDescomp1   := ""  // Descricao Producao  
Private cDescomp2   := ""  // Descricao Comercial
Private cDescomp3   := ""  // Descricao Nota Fiscal
Private cConta      := SB1->B1_CONTA
Private cDescDCR    := ""
Private cDescCDCR   := ""
Private cNarra      := SB1->B1_NARRA
Private cClespec    := SB1->B1_CLESPEC
Private cClgOp      := SB1->B1_CLGOP
Private cClSite     := SB1->B1_CLSITE
Private cFabri      := SB1->B1_X_FABRI
Private cDCR        := SB1->B1_X_DCR        
Private cFamilia    := SB1->B1_CLCFAM
Private cGrpCtb     := SB1->B1_CLCGRP
Private _Xpos01     := IIF(!EMPTY(SB1->B1_X_POS01),ALLTRIM(SB1->B1_X_POS01),"**")
Private _Xpos02     := IIF(!EMPTY(SB1->B1_X_POS02),ALLTRIM(SB1->B1_X_POS02),"**")
Private _Xpos03     := IIF(!EMPTY(SB1->B1_X_POS03),ALLTRIM(SB1->B1_X_POS03),"**")
Private _Xpos04     := IIF(!EMPTY(SB1->B1_X_POS04),ALLTRIM(SB1->B1_X_POS04),"**")
Private _Xpos05     := IIF(!EMPTY(SB1->B1_X_POS05),ALLTRIM(SB1->B1_X_POS05),"**")
Private _Xpos06     := IIF(!EMPTY(SB1->B1_X_POS06),ALLTRIM(SB1->B1_X_POS06),"**")
Private _Xpos07     := IIF(!EMPTY(SB1->B1_X_POS07),ALLTRIM(SB1->B1_X_POS07),"**")
Private _Xpos08     := IIF(!EMPTY(SB1->B1_X_POS08),ALLTRIM(SB1->B1_X_POS08),"**")
Private _Xpos09     := IIF(!EMPTY(SB1->B1_X_POS09),ALLTRIM(SB1->B1_X_POS09),"**")
Private _Xpos10     := IIF(!EMPTY(SB1->B1_X_POS10),ALLTRIM(SB1->B1_X_POS10),"**")
Private _Xpos11     := IIF(!EMPTY(SB1->B1_X_POS11),ALLTRIM(SB1->B1_X_POS11),"**")
Private _Xpos12     := IIF(!EMPTY(SB1->B1_X_POS12),ALLTRIM(SB1->B1_X_POS12),"**")   
Private _Xpos13     := IIF(!EMPTY(SB1->B1_X_POS13),ALLTRIM(SB1->B1_X_POS13),"**")
Private _Xpos14     := IIF(!EMPTY(SB1->B1_X_POS14),ALLTRIM(SB1->B1_X_POS14),"**")
Private _Xpos15     := IIF(!EMPTY(SB1->B1_X_POS15),ALLTRIM(SB1->B1_X_POS15),"**")
Private _Xpos16     := IIF(!EMPTY(SB1->B1_X_POS16),ALLTRIM(SB1->B1_X_POS16),"**")
Private _Xpos17     := IIF(!EMPTY(SB1->B1_X_POS17),ALLTRIM(SB1->B1_X_POS17),"**")
Private _Xpos18     := IIF(!EMPTY(SB1->B1_X_POS18),ALLTRIM(SB1->B1_X_POS18),"**")
Private _Xpos19     := IIF(!EMPTY(SB1->B1_X_POS19),ALLTRIM(SB1->B1_X_POS19),"**")
Private _Xpos20     := IIF(!EMPTY(SB1->B1_X_POS20),ALLTRIM(SB1->B1_X_POS20),"**")

Private _cProjeto   := SB1->B1_X_PROJ


Private cAnuente    := "2"
Private cMidia      := "2"
Private lContinua   := .t.


Private cPos01      := "  "
Private cPos02      := "  "
Private cPos03      := "  "
Private cPos04      := "  "
Private cPos05      := "  "
Private cPos06      := "  "
Private cPos07      := "  "
Private cPos08      := "  "
Private cPos09      := "  "
Private cPos10      := "  "
Private cPos11      := "  "
Private cPos12      := "  "
Private cPos13      := "  "
Private cPos14      := "  "
Private cPos15      := "  "
Private cPos16      := "  "
Private cPos17      := "  "
Private cPos18      := "  "
Private cPos19      := "  "
Private cPos20      := "  "

/*
	dbSelectArea("SZ0")
	dbSetOrder(2)
	dbSeek(xFilial("SZ0")+cCod)
	While !Eof() .and. cCod == SZ0->Z0_CODIGO
		If !Empty(SZ0->Z0_POSICAO)
			dbSkip()
			Loop
		EndIf
	EndDo    ///carlos - 14/07/12
	
*/
// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

DEFINE FONT oFont  	NAME "Arial" Size 08,15 BOLD
DEFINE FONT oFont1	NAME "Arial" Size 08,15

DEFINE MSDIALOG _oDlg TITLE ":::... COEL - Configurador de Produtos ...:::" FROM C(178),C(181) TO C(598),C(967) PIXEL

// Cria as Groups do Sistema
@ C(002),C(004) TO C(049),C(390) LABEL "Dados do produto" PIXEL OF _oDlg
@ C(053),C(003) TO C(106),C(391) LABEL "Informações Complementares" PIXEL OF _oDlg
@ C(110),C(004) TO C(189),C(391) LABEL "Cenário" PIXEL OF _oDlg

// Cria Componentes Padroes do Sistema
@ C(021),C(013) Say "Codigo" Size C(040),C(010)  COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(019),C(040) MsGet oCod Var cCod Size C(060),C(015) When .F. COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(021),C(120) Say "Descricao" Size C(040),C(015) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(019),C(170) MsGet oDesc Var cDesc Size C(200),C(015) When .F. COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(074),C(015) Say "Tipo" Size C(032),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(073),C(035) MsGet oTipo Var cTipo Size C(010),C(009) When .F. COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(074),C(110) Say "UM" Size C(032),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(073),C(140) MsGet oUm Var cUm Size C(010),C(009) When .F. COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont

@ C(132),C(015) Say _XPos01 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(131),C(040) MsGet oPos01 Var cPos01 When IIF(_xPos01=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos01))  F3 "SZ001"  PIXEL OF _oDlg FONT oFont
@ C(142),C(015) Say _XPos02 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(141),C(040) MsGet oPos02 Var cPos02 When IIF(_xPos02=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos02))  F3 "SZ002"  PIXEL OF _oDlg FONT oFont
@ C(152),C(015) Say _XPos03 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(151),C(040) MsGet oPos03 Var cPos03 When IIF(_xPos03=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos03)) F3 "SZ003"  PIXEL OF _oDlg FONT oFont
@ C(162),C(015) Say _XPos04 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(161),C(040) MsGet oPos04 Var cPos04 When IIF(_xPos04=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos04)) F3 "SZ004"  PIXEL OF _oDlg FONT oFont

@ C(132),C(070) Say _XPos05 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(131),C(095) MsGet oPos05 Var cPos05 When IIF(_xPos05=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos05)) F3 "SZ005"  PIXEL OF _oDlg FONT oFont
@ C(142),C(070) Say _XPos06 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(141),C(095) MsGet oPos06 Var cPos06 When IIF(_xPos06=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos06)) F3 "SZ006"  PIXEL OF _oDlg FONT oFont
@ C(152),C(070) Say _XPos07 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(151),C(095) MsGet oPos07 Var cPos07 When IIF(_xPos07=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos07)) F3 "SZ007"  PIXEL OF _oDlg FONT oFont
@ C(162),C(070) Say _XPos08 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(161),C(095) MsGet oPos08 Var cPos08 When IIF(_xPos08=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos08)) F3 "SZ008"  PIXEL OF _oDlg FONT oFont

@ C(132),C(135) Say _XPos09 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(131),C(160) MsGet oPos09 Var cPos09 When IIF(_xPos09=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos09)) F3 "SZ009"  PIXEL OF _oDlg FONT oFont
@ C(142),C(135) Say _XPos10 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(141),C(160) MsGet oPos10 Var cPos10 When IIF(_xPos10=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos10)) F3 "SZ010"  PIXEL OF _oDlg FONT oFont
@ C(152),C(135) Say _XPos11 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(151),C(160) MsGet oPos11 Var cPos11 When IIF(_xPos11=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos11)) F3 "SZ011"  PIXEL OF _oDlg FONT oFont
@ C(162),C(135) Say _XPos12 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(161),C(160) MsGet oPos12 Var cPos12 When IIF(_xPos12=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos12)) F3 "SZ012"  PIXEL OF _oDlg FONT oFont

@ C(132),C(200) Say _XPos13 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(131),C(225) MsGet oPos13 Var cPos13 When IIF(_xPos13=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos13)) F3 "SZ013"  PIXEL OF _oDlg FONT oFont
@ C(142),C(200) Say _XPos14 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(141),C(225) MsGet oPos14 Var cPos14 When IIF(_xPos14=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos14)) F3 "SZ014"  PIXEL OF _oDlg FONT oFont
@ C(152),C(200) Say _XPos15 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(151),C(225) MsGet oPos15 Var cPos15 When IIF(_xPos15=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos15)) F3 "SZ015"  PIXEL OF _oDlg FONT oFont
@ C(162),C(200) Say _XPos16 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(161),C(225) MsGet oPos16 Var cPos16 When IIF(_xPos16=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos16)) F3 "SZ016"  PIXEL OF _oDlg FONT oFont

@ C(132),C(265) Say _XPos17 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(131),C(290) MsGet oPos17 Var cPos17 When IIF(_xPos17=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos17)) F3 "SZ017"  PIXEL OF _oDlg FONT oFont
@ C(142),C(265) Say _XPos18 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(141),C(290) MsGet oPos18 Var cPos18 When IIF(_xPos18=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos18)) F3 "SZ018"  PIXEL OF _oDlg FONT oFont
@ C(152),C(265) Say _XPos19 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(151),C(290) MsGet oPos19 Var cPos19 When IIF(_xPos19=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos19)) F3 "SZ019"  PIXEL OF _oDlg FONT oFont
@ C(162),C(265) Say _XPos20 Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
@ C(161),C(290) MsGet oPos20 Var cPos20 When IIF(_xPos20=="**",.F.,.T.) Size C(020),C(009) COLOR CLR_BLACK valid (!empty(cPos20)) F3 "SZ020"  PIXEL OF _oDlg FONT oFont

//@ C(169),C(015) Say "Recebimento" Size C(050),C(008) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
//@ C(169),C(075) MsGet oDtReceb Var dDtReceb When IIF(@_cTipo=="V",.F.,.T.) Size C(040),C(009) COLOR CLR_BLACK PIXEL OF _oDlg FONT oFont
//@ C(195),C(300) Button "Visualiza" Size C(037),C(012) ACTION(PFVisuNF(cDoc,cSerie)) PIXEL OF _oDlg
@ C(195),C(300) Button "Grava" Size C(037),C(012) ACTION(CriaProd()) PIXEL OF _oDlg
@ C(195),C(350) Button "Sair" Size C(037),C(012) ACTION(Sair()) PIXEL OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED

Return(.T.)

Static Function Sair()
Close(_oDlg)
Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PFTELA    ³ Autor ³ Wilson A. da Cruz    ³ Data ³ 19.09.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Apresenta dados do canhoto para atualizacao e visualizacao ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Perflex                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CriaProd()

Local aCab  :={}
Local aItem := {}
Local lOK	:= .T.
Local cString
Local cCond02:= ""
Local _cPos01c:=_cPos02c:=_cPos03c:=_cPos04c:=_cPos05c:=_cPos06c:=_cPos07c:=_cPos08c:=_cPos09c:=_cPos10c:=_cPos11c:=_cPos12c:=_cPos13c:=_cPos14c:=_cPos15c:=_cPos16c:=_cPos17c:=_cPos17c:=_cPos19c:=_cPos20c:=""
Local _cObrig01:=_cObrig02:=_cObrig03:=_cObrig04:=_cObrig05:=_cObrig06:=_cObrig07:=_cObrig08:=_cObrig09:=_cObrig10:=_cObrig11:=_cObrig12:=_cObrig13:=_cObrig14:=_cObrig15:=_cObrig16:=_cObrig17:=_cObrig18:=_cObrig19:=_cObrig20:=""
Local _cCodCal01:=_cCodCal02:=_cCodCal03:=_cCodCal04:=_cCodCal05:=_cCodCal06:=_cCodCal07:=_cCodCal08:=_cCodCal09:=_cCodCal10:=_cCodCal11:=_cCodCal12:=_cCodCal13:=_cCodCal14:=_cCodCal15:=_cCodCal16:=_cCodCal17:=_cCodCal18:=_cCodCal19:=_cCodCal20:="S"
Private _cDesc01:=_cDesc02:=_cDesc03:=_cDesc04:=_cDesc05:=_cDesc06:=_cDesc07:=_cDesc08:=_cDesc09:=_cDesc10:=_cDesc11:=_cDesc12:=_cDesc13:=_cDesc14:=_cDesc15:=_cDesc16:=_cDesc17:=_cDesc18:=_cDesc19:=_cDesc20:=""
Private _cDesc01c:=_cDesc02c:=_cDesc03c:=_cDesc04c:=_cDesc05c:=_cDesc06c:=_cDesc07c:=_cDesc08c:=_cDesc09c:=_cDesc10c:=_cDesc11c:=_cDesc12c:=_cDesc13c:=_cDesc14c:=_cDesc15c:=_cDesc16c:=_cDesc17c:=_cDesc18c:=_cDesc19c:=_cDesc20c:="" // Descricao comercial
Private _cDesc01d:=_cDesc02d:=_cDesc03d:=_cDesc04d:=_cDesc05d:=_cDesc06d:=_cDesc07d:=_cDesc08d:=_cDesc09d:=_cDesc10d:=_cDesc11d:=_cDesc12d:=_cDesc13d:=_cDesc14d:=_cDesc15d:=_cDesc16d:=_cDesc17d:=_cDesc18d:=_cDesc19d:=_cDesc20d:=""
Private _cDDcr01:=_cDDcr02:=_cDDcr03:=_cDDcr04:=_cDDcr05:=_cDDcr06:=_cDDcr07:=_cDDcr08:=_cDDcr09:=_cDDcr10:=_cDDcr11:=_cDDcr12:=_cDDcr13:=_cDDcr14:=_cDDcr15:=_cDDcr16:=_cDDcr17:=_cDDcr18:=_cDDcr19:=_cDDcr20:=""
Private _cDCDcr01:=_cDCDcr02:=_cDCDcr03:=_cDCDcr04:=_cDCDcr05:=_cDCDcr06:=_cDCDcr07:=_cDCDcr08:=_cDCDcr09:=_cDCDcr10:=_cDCDcr11:=_cDCDcr12:=_cDCDcr13:=_cDCDcr14:=_cDCDcr15:=_cDCDcr16:=_cDCDcr17:=_cDCDcr18:=_cDCDcr19:=_cDCDcr20:=""

Private lEspec1:= .f.
Private lMsErroAuto := .F.
Private	lcCond01:=lcCond02:=lcCond03:=lcCond04:=lcCond05:=lcCond06:=lcCond07:=lcCond08:=lcCond09:=lcCond10:=lcCond11:=lcCond12:=lcCond13:=lcCond14:=lcCond15:=lcCond16:=lcCond17:=lcCond18:=lcCond19:=lcCond20:= .t.    

_xcPos01:= alltrim(cPos01)
_xcPos02:= alltrim(cPos02)
_xcPos03:= alltrim(cPos03)
_xcPos04:= alltrim(cPos04)
_xcPos05:= alltrim(cPos05)
_xcPos06:= alltrim(cPos06)
_xcPos07:= alltrim(cPos07)
_xcPos08:= alltrim(cPos08)
_xcPos09:= alltrim(cPos09)
_xcPos10:= alltrim(cPos10)
_xcPos11:= alltrim(cPos11)
_xcPos12:= alltrim(cPos12)                          
_xcPos13:= alltrim(cPos13)                                                     
_xcPos14:= alltrim(cPos14)
_xcPos15:= alltrim(cPos15)
_xcPos16:= alltrim(cPos16)
_xcPos17:= alltrim(cPos17)
_xcPos18:= alltrim(cPos18)
_xcPos19:= alltrim(cPos19)
_xcPos20:= alltrim(cPos20)

If cPos01 == "-" .or. cPos01 = "--"
	cCond01 := cPos01
Else
	dbSelectArea("SZ0")
	dbSetOrder(3)
	If dbSeek(xFilial("SZ0")+cPos01+cCod+"01")          //LETRA+PRODUTO BASE+SEQUENCIA
		_cPos01c  := SZ0->Z0_POSICAO                    //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc01  := alltrim(SZ0->Z0_DESCOP)            // Descricao para a OP
		_cDesc01c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig01 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal01:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc01d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
			If !Empty(SZ0->Z0_CONDICA)
			_cCond01:= ALLTRIM(SZ0->Z0_CONDICA) 

            _cCond01a:= STRTRAN(_cCond01,_xPos01,"_xcPos01")
            _cCond01b:= STRTRAN(_cCond01a,_xPos02,"_xcPos02")
            _cCond01c:= STRTRAN(_cCond01b,_xPos03,"_xcPos03")
            _cCond01d:= STRTRAN(_cCond01c,_xPos04,"_xcPos04")
            _cCond01e:= STRTRAN(_cCond01d,_xPos05,"_xcPos05")
            _cCond01f:= STRTRAN(_cCond01e,_xPos06,"_xcPos06")
            _cCond01g:= STRTRAN(_cCond01f,_xPos07,"_xcPos07")
            _cCond01h:= STRTRAN(_cCond01g,_xPos08,"_xcPos08")
            _cCond01i:= STRTRAN(_cCond01h,_xPos09,"_xcPos09")
            _cCond01j:= STRTRAN(_cCond01i,_xPos10,"_xcPos10")
            _cCond01k:= STRTRAN(_cCond01j,_xPos11,"_xcPos11")
            _cCond01l:= STRTRAN(_cCond01k,_xPos12,"_xcPos12")
            _cCond01m:= STRTRAN(_cCond01l,_xPos13,"_xcPos13")
            _cCond01n:= STRTRAN(_cCond01m,_xPos14,"_xcPos14")
            _cCond01o:= STRTRAN(_cCond01n,_xPos15,"_xcPos15")
            _cCond01p:= STRTRAN(_cCond01o,_xPos16,"_xcPos16")
            _cCond01q:= STRTRAN(_cCond01p,_xPos17,"_xcPos17")
            _cCond01r:= STRTRAN(_cCond01q,_xPos18,"_xcPos18")
            _cCond01s:= STRTRAN(_cCond01r,_xPos19,"_xcPos19")
            _cCond01t:= STRTRAN(_cCond01s,_xPos20,"_xcPos20")

			
			lcCond01:= &_cCond01t
			If lcCond01
				cCond01:= cPos01
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 01: "+cPos01)
				cCond01:= "-"
			EndIf
		Else
			cCond01:= cPos01
		EndIf
		
	Else
		If !Empty(cPos01)
			alert("Atencao, acessorio nao disponível na posicao 01: "+cPos01)
			cCond01:= "-"
		Else
			cCond01:= ""
		EndIf
		
	EndIf    
		_cDDcr01  := iif(SZ0->Z0_DCR=="S",cCond01,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr01 := iif(SZ0->Z0_DCR=="N",cCond01,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 

EndIf


If cPos02 == "-" .or. cPos02 = "--"
	cCond02 := cPos02
Else
	If dbSeek(xFilial("SZ0")+cPos02+cCod+"02")
		_cPos02c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc02  := alltrim(SZ0->Z0_DESCOP)
		_cDesc02c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig02 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal02:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc02d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond02:= SZ0->Z0_CONDICA

            _cCond02a:= STRTRAN(_cCond02,_xPos01,"_xcPos01")
            _cCond02b:= STRTRAN(_cCond02a,_xPos02,"_xcPos02")
            _cCond02c:= STRTRAN(_cCond02b,_xPos03,"_xcPos03")
            _cCond02d:= STRTRAN(_cCond02c,_xPos04,"_xcPos04")
            _cCond02e:= STRTRAN(_cCond02d,_xPos05,"_xcPos05")
            _cCond02f:= STRTRAN(_cCond02e,_xPos06,"_xcPos06")
            _cCond02g:= STRTRAN(_cCond02f,_xPos07,"_xcPos07")
            _cCond02h:= STRTRAN(_cCond02g,_xPos08,"_xcPos08")
            _cCond02i:= STRTRAN(_cCond02h,_xPos09,"_xcPos09")
            _cCond02j:= STRTRAN(_cCond02i,_xPos10,"_xcPos10")
            _cCond02k:= STRTRAN(_cCond02j,_xPos11,"_xcPos11")
            _cCond02l:= STRTRAN(_cCond02k,_xPos12,"_xcPos12")
            _cCond02m:= STRTRAN(_cCond02l,_xPos13,"_xcPos13")
            _cCond02n:= STRTRAN(_cCond02m,_xPos14,"_xcPos14")
            _cCond02o:= STRTRAN(_cCond02n,_xPos15,"_xcPos15")
            _cCond02p:= STRTRAN(_cCond02o,_xPos16,"_xcPos16")
            _cCond02q:= STRTRAN(_cCond02p,_xPos17,"_xcPos17")
            _cCond02r:= STRTRAN(_cCond02q,_xPos18,"_xcPos18")
            _cCond02s:= STRTRAN(_cCond02r,_xPos19,"_xcPos19")
            _cCond02t:= STRTRAN(_cCond02s,_xPos20,"_xcPos20")
            
            
			lcCond02:= &_cCond02t
			If lcCond02
				cCond02:= cPos02
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 02: "+cPos02)
				cCond02:= "-"
			EndIf
			
		Else
			cCond02:= cPos02
		EndIf
	Else
		If !Empty(cPos02)
			alert("Atencao, acessorio nao disponível na posicao 02: "+cPos02)
			cCond02:= "-"
		Else
			cCond02:= ""
		EndIf
	EndIf 
		_cDDcr02  := iif(SZ0->Z0_DCR=="S",cCond02,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr02 := iif(SZ0->Z0_DCR=="N",cCond02,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos03 == "-" .or. cPos03 = "--"
	cCond03 := cPos03
Else
	If dbSeek(xFilial("SZ0")+cPos03+cCod+"03")
		_cPos03c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc03  := alltrim(SZ0->Z0_DESCOP)
		_cDesc03c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig03 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal03:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc03d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond03:= SZ0->Z0_CONDICA

            _cCond03a:= STRTRAN(_cCond03,_xPos01,"_xcPos01")
            _cCond03b:= STRTRAN(_cCond03a,_xPos02,"_xcPos02")
            _cCond03c:= STRTRAN(_cCond03b,_xPos03,"_xcPos03")
            _cCond03d:= STRTRAN(_cCond03c,_xPos04,"_xcPos04")
            _cCond03e:= STRTRAN(_cCond03d,_xPos05,"_xcPos05")
            _cCond03f:= STRTRAN(_cCond03e,_xPos06,"_xcPos06")
            _cCond03g:= STRTRAN(_cCond03f,_xPos07,"_xcPos07")
            _cCond03h:= STRTRAN(_cCond03g,_xPos08,"_xcPos08")
            _cCond03i:= STRTRAN(_cCond03h,_xPos09,"_xcPos09")
            _cCond03j:= STRTRAN(_cCond03i,_xPos10,"_xcPos10")
            _cCond03k:= STRTRAN(_cCond03j,_xPos11,"_xcPos11")
            _cCond03l:= STRTRAN(_cCond03k,_xPos12,"_xcPos12")
            _cCond03m:= STRTRAN(_cCond03l,_xPos13,"_xcPos13")
            _cCond03n:= STRTRAN(_cCond03m,_xPos14,"_xcPos14")
            _cCond03o:= STRTRAN(_cCond03n,_xPos15,"_xcPos15")
            _cCond03p:= STRTRAN(_cCond03o,_xPos16,"_xcPos16")
            _cCond03q:= STRTRAN(_cCond03p,_xPos17,"_xcPos17")
            _cCond03r:= STRTRAN(_cCond03q,_xPos18,"_xcPos18")
            _cCond03s:= STRTRAN(_cCond03r,_xPos19,"_xcPos19")
            _cCond03t:= STRTRAN(_cCond03s,_xPos20,"_xcPos20")
            
			lcCond03:= &_cCond03t
			If lcCond03
				cCond03:= cPos03
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 03: "+cPos03)
				cCond03:= "-"
			EndIf
			
		Else
			cCond03:= cPos03
		EndIf
	Else
		If !Empty(cPos03)
			alert("Atencao, acessorio nao disponível na posicao 03: "+cPos03)
			cCond03:= "-"
		Else
			cCond03:= ""
		EndIf
	EndIf    
		_cDDcr03  := iif(SZ0->Z0_DCR=="S",cCond03,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr03 := iif(SZ0->Z0_DCR=="N",cCond03,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos04 == "-" .or. cPos04 = "--"
	cCond04 := cPos04
Else
	If dbSeek(xFilial("SZ0")+cPos04+cCod+"04")
		_cPos04c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc04  := alltrim(SZ0->Z0_DESCOP)
		_cDesc04c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig04 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal04:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc04d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond04:= SZ0->Z0_CONDICA

            _cCond04a:= STRTRAN(_cCond04,_xPos01,"_xcPos01")
            _cCond04b:= STRTRAN(_cCond04a,_xPos02,"_xcPos02")
            _cCond04c:= STRTRAN(_cCond04b,_xPos03,"_xcPos03")
            _cCond04d:= STRTRAN(_cCond04c,_xPos04,"_xcPos04")
            _cCond04e:= STRTRAN(_cCond04d,_xPos05,"_xcPos05")
            _cCond04f:= STRTRAN(_cCond04e,_xPos06,"_xcPos06")
            _cCond04g:= STRTRAN(_cCond04f,_xPos07,"_xcPos07")
            _cCond04h:= STRTRAN(_cCond04g,_xPos08,"_xcPos08")
            _cCond04i:= STRTRAN(_cCond04h,_xPos09,"_xcPos09")
            _cCond04j:= STRTRAN(_cCond04i,_xPos10,"_xcPos10")
            _cCond04k:= STRTRAN(_cCond04j,_xPos11,"_xcPos11")
            _cCond04l:= STRTRAN(_cCond04k,_xPos12,"_xcPos12")
            _cCond04m:= STRTRAN(_cCond04l,_xPos13,"_xcPos13")
            _cCond04n:= STRTRAN(_cCond04m,_xPos14,"_xcPos14")
            _cCond04o:= STRTRAN(_cCond04n,_xPos15,"_xcPos15")
            _cCond04p:= STRTRAN(_cCond04o,_xPos16,"_xcPos16")
            _cCond04q:= STRTRAN(_cCond04p,_xPos17,"_xcPos17")
            _cCond04r:= STRTRAN(_cCond04q,_xPos18,"_xcPos18")
            _cCond04s:= STRTRAN(_cCond04r,_xPos19,"_xcPos19")
            _cCond04t:= STRTRAN(_cCond04s,_xPos20,"_xcPos20")
            
			lcCond04:= &_cCond04t
			If lcCond04
				cCond04:= cPos04
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 04: "+cPos04)
				cCond04:= "-"
			EndIf
			
		Else
			cCond04:= cPos04
		EndIf
	Else
		If !Empty(cPos04)
			alert("Atencao, acessorio nao disponível na posicao 04: "+cPos04)
			cCond04:= "-"
		Else
			cCond04:= ""
		EndIf
	EndIf  
		_cDDcr04  := iif(SZ0->Z0_DCR=="S",cCond04,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr04 := iif(SZ0->Z0_DCR=="N",cCond04,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf


If cPos05 == "-" .or. cPos05 = "--"
	cCond05 := cPos05
Else
	If dbSeek(xFilial("SZ0")+cPos05+cCod+"05")
		_cPos05c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc05  := alltrim(SZ0->Z0_DESCOP)
		_cDesc05c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig05 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal05:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc05d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond05:= SZ0->Z0_CONDICA

            _cCond05a:= STRTRAN(_cCond05,_xPos01,"_xcPos01")
            _cCond05b:= STRTRAN(_cCond05a,_xPos02,"_xcPos02")
            _cCond05c:= STRTRAN(_cCond05b,_xPos03,"_xcPos03")
            _cCond05d:= STRTRAN(_cCond05c,_xPos04,"_xcPos04")
            _cCond05e:= STRTRAN(_cCond05d,_xPos05,"_xcPos05")
            _cCond05f:= STRTRAN(_cCond05e,_xPos06,"_xcPos06")
            _cCond05g:= STRTRAN(_cCond05f,_xPos07,"_xcPos07")
            _cCond05h:= STRTRAN(_cCond05g,_xPos08,"_xcPos08")
            _cCond05i:= STRTRAN(_cCond05h,_xPos09,"_xcPos09")
            _cCond05j:= STRTRAN(_cCond05i,_xPos10,"_xcPos10")
            _cCond05k:= STRTRAN(_cCond05j,_xPos11,"_xcPos11")
            _cCond05l:= STRTRAN(_cCond05k,_xPos12,"_xcPos12")
            _cCond05m:= STRTRAN(_cCond05l,_xPos13,"_xcPos13")
            _cCond05n:= STRTRAN(_cCond05m,_xPos14,"_xcPos14")
            _cCond05o:= STRTRAN(_cCond05n,_xPos15,"_xcPos15")
            _cCond05p:= STRTRAN(_cCond05o,_xPos16,"_xcPos16")
            _cCond05q:= STRTRAN(_cCond05p,_xPos17,"_xcPos17")
            _cCond05r:= STRTRAN(_cCond05q,_xPos18,"_xcPos18")
            _cCond05s:= STRTRAN(_cCond05r,_xPos19,"_xcPos19")
            _cCond05t:= STRTRAN(_cCond05s,_xPos20,"_xcPos20")
            
			lcCond05:= &_cCond05t
			If lcCond05
				cCond05:= cPos05
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 05: "+cPos05)
				cCond05:= "-"
			EndIf
		Else
			cCond05:= cPos05
		EndIf
	Else
		If !Empty(cPos05)
			alert("Atencao, acessorio nao disponível na posicao 05: "+cPos05)
			cCond05:= "-"
		Else
			cCond05:= ""
		EndIf
	EndIf    
		_cDDcr05  := iif(SZ0->Z0_DCR=="S",cCond05,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr05 := iif(SZ0->Z0_DCR=="N",cCond05,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf


If cPos06 == "-" .or. cPos06 = "--"
	cCond06 := cPos06
Else
	If dbSeek(xFilial("SZ0")+cPos06+cCod+"06")
		_cPos06c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc06  := alltrim(SZ0->Z0_DESCOP)
		_cDesc06c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig06 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal06:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc06d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond06:= SZ0->Z0_CONDICA

            _cCond06a:= STRTRAN(_cCond06,_xPos01,"_xcPos01")
            _cCond06b:= STRTRAN(_cCond06a,_xPos02,"_xcPos02")
            _cCond06c:= STRTRAN(_cCond06b,_xPos03,"_xcPos03")
            _cCond06d:= STRTRAN(_cCond06c,_xPos04,"_xcPos04")
            _cCond06e:= STRTRAN(_cCond06d,_xPos05,"_xcPos05")
            _cCond06f:= STRTRAN(_cCond06e,_xPos06,"_xcPos06")
            _cCond06g:= STRTRAN(_cCond06f,_xPos07,"_xcPos07")
            _cCond06h:= STRTRAN(_cCond06g,_xPos08,"_xcPos08")
            _cCond06i:= STRTRAN(_cCond06h,_xPos09,"_xcPos09")
            _cCond06j:= STRTRAN(_cCond06i,_xPos10,"_xcPos10")
            _cCond06k:= STRTRAN(_cCond06j,_xPos11,"_xcPos11")
            _cCond06l:= STRTRAN(_cCond06k,_xPos12,"_xcPos12")
            _cCond06m:= STRTRAN(_cCond06l,_xPos13,"_xcPos13")
            _cCond06n:= STRTRAN(_cCond06m,_xPos14,"_xcPos14")
            _cCond06o:= STRTRAN(_cCond06n,_xPos15,"_xcPos15")
            _cCond06p:= STRTRAN(_cCond06o,_xPos16,"_xcPos16")
            _cCond06q:= STRTRAN(_cCond06p,_xPos17,"_xcPos17")
            _cCond06r:= STRTRAN(_cCond06q,_xPos18,"_xcPos18")
            _cCond06s:= STRTRAN(_cCond06r,_xPos19,"_xcPos19")
            _cCond06t:= STRTRAN(_cCond06s,_xPos20,"_xcPos20")
            
			lcCond06:= &_cCond06t
			If lcCond06
				cCond06:= cPos06
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 06: "+cPos06)
				cCond06:= "-"
			EndIf
			
		Else
			cCond06:= cPos06
		EndIf
	Else
		If !Empty(cPos06)
			alert("Atencao, acessorio nao disponível na posicao 06: "+cPos06)
			cCond06:= "-"
		Else
			cCond06:= ""
		EndIf
	EndIf  
		_cDDcr06  := iif(SZ0->Z0_DCR=="S",cCond06,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr06 := iif(SZ0->Z0_DCR=="N",cCond06,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos07 == "-" .or. cPos07 = "--"
	cCond07 := cPos07
Else
	If dbSeek(xFilial("SZ0")+cPos07+cCod+"07")
		_cPos07c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc07  := alltrim(SZ0->Z0_DESCOP)
		_cDesc07c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig07 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal07:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc07d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond07:= SZ0->Z0_CONDICA

            _cCond07a:= STRTRAN(_cCond07,_xPos01,"_xcPos01")
            _cCond07b:= STRTRAN(_cCond07a,_xPos02,"_xcPos02")
            _cCond07c:= STRTRAN(_cCond07b,_xPos03,"_xcPos03")
            _cCond07d:= STRTRAN(_cCond07c,_xPos04,"_xcPos04")
            _cCond07e:= STRTRAN(_cCond07d,_xPos05,"_xcPos05")
            _cCond07f:= STRTRAN(_cCond07e,_xPos06,"_xcPos06")
            _cCond07g:= STRTRAN(_cCond07f,_xPos07,"_xcPos07")
            _cCond07h:= STRTRAN(_cCond07g,_xPos08,"_xcPos08")
            _cCond07i:= STRTRAN(_cCond07h,_xPos09,"_xcPos09")
            _cCond07j:= STRTRAN(_cCond07i,_xPos10,"_xcPos10")
            _cCond07k:= STRTRAN(_cCond07j,_xPos11,"_xcPos11")
            _cCond07l:= STRTRAN(_cCond07k,_xPos12,"_xcPos12")
            _cCond07m:= STRTRAN(_cCond07l,_xPos13,"_xcPos13")
            _cCond07n:= STRTRAN(_cCond07m,_xPos14,"_xcPos14")
            _cCond07o:= STRTRAN(_cCond07n,_xPos15,"_xcPos15")
            _cCond07p:= STRTRAN(_cCond07o,_xPos16,"_xcPos16")
            _cCond07q:= STRTRAN(_cCond07p,_xPos17,"_xcPos17")
            _cCond07r:= STRTRAN(_cCond07q,_xPos18,"_xcPos18")
            _cCond07s:= STRTRAN(_cCond07r,_xPos19,"_xcPos19")
            _cCond07t:= STRTRAN(_cCond07s,_xPos20,"_xcPos20")
            
			lcCond07:= &_cCond07t
			If lcCond07
				cCond07:= cPos07
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 07: "+cPos07)
				cCond07:= "-"
			EndIf
			
		Else
			cCond07:= cPos07
		EndIf
	Else
		If !Empty(cPos07)
			alert("Atencao, acessorio nao disponível na posicao 07: "+cPos07)
			cCond07:= "-"
		Else
			cCond07:= ""
		EndIf
	EndIf     
		_cDDcr07  := iif(SZ0->Z0_DCR=="S",cCond07,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr07 := iif(SZ0->Z0_DCR=="N",cCond07,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos08 == "-" .or. cPos08 = "--"
	cCond08 := cPos08
Else
	If dbSeek(xFilial("SZ0")+cPos08+cCod+"08")
		_cPos08c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc08  := alltrim(SZ0->Z0_DESCOP)
		_cDesc08c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig08 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal08:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc08d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond08:= SZ0->Z0_CONDICA

            _cCond08a:= STRTRAN(_cCond08,_xPos01,"_xcPos01")
            _cCond08b:= STRTRAN(_cCond08a,_xPos02,"_xcPos02")
            _cCond08c:= STRTRAN(_cCond08b,_xPos03,"_xcPos03")
            _cCond08d:= STRTRAN(_cCond08c,_xPos04,"_xcPos04")
            _cCond08e:= STRTRAN(_cCond08d,_xPos05,"_xcPos05")
            _cCond08f:= STRTRAN(_cCond08e,_xPos06,"_xcPos06")
            _cCond08g:= STRTRAN(_cCond08f,_xPos07,"_xcPos07")
            _cCond08h:= STRTRAN(_cCond08g,_xPos08,"_xcPos08")
            _cCond08i:= STRTRAN(_cCond08h,_xPos09,"_xcPos09")
            _cCond08j:= STRTRAN(_cCond08i,_xPos10,"_xcPos10")
            _cCond08k:= STRTRAN(_cCond08j,_xPos11,"_xcPos11")
            _cCond08l:= STRTRAN(_cCond08k,_xPos12,"_xcPos12")
            _cCond08m:= STRTRAN(_cCond08l,_xPos13,"_xcPos13")
            _cCond08n:= STRTRAN(_cCond08m,_xPos14,"_xcPos14")
            _cCond08o:= STRTRAN(_cCond08n,_xPos15,"_xcPos15")
            _cCond08p:= STRTRAN(_cCond08o,_xPos16,"_xcPos16")
            _cCond08q:= STRTRAN(_cCond08p,_xPos17,"_xcPos17")
            _cCond08r:= STRTRAN(_cCond08q,_xPos18,"_xcPos18")
            _cCond08s:= STRTRAN(_cCond08r,_xPos19,"_xcPos19")
            _cCond08t:= STRTRAN(_cCond08s,_xPos20,"_xcPos20")
            
			lcCond08:= &_cCond08t
			If lcCond08
				cCond08:= cPos08
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 08: "+cPos08)
				cCond08:= "-"
			EndIf
			
		Else
			cCond08:= cPos08
		EndIf
	Else
		If !Empty(cPos08)
			alert("Atencao, acessorio nao disponível na posicao 08: "+cPos08)
			cCond08:= "-"
		Else
			cCond08:= ""
		EndIf
	EndIf   
		_cDDcr08  := iif(SZ0->Z0_DCR=="S",cCond08,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr08 := iif(SZ0->Z0_DCR=="N",cCond08,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos09 == "-" .or. cPos09 = "--"
	cCond09 := cPos09
Else
	If dbSeek(xFilial("SZ0")+cPos09+cCod+"09")
		_cPos09c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc09  := alltrim(SZ0->Z0_DESCOP)
		_cDesc09c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig09 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal09:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc09d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond09:= SZ0->Z0_CONDICA

            _cCond09a:= STRTRAN(_cCond09,_xPos01,"_xcPos01")
            _cCond09b:= STRTRAN(_cCond09a,_xPos02,"_xcPos02")
            _cCond09c:= STRTRAN(_cCond09b,_xPos03,"_xcPos03")
            _cCond09d:= STRTRAN(_cCond09c,_xPos04,"_xcPos04")
            _cCond09e:= STRTRAN(_cCond09d,_xPos05,"_xcPos05")
            _cCond09f:= STRTRAN(_cCond09e,_xPos06,"_xcPos06")
            _cCond09g:= STRTRAN(_cCond09f,_xPos07,"_xcPos07")
            _cCond09h:= STRTRAN(_cCond09g,_xPos08,"_xcPos08")
            _cCond09i:= STRTRAN(_cCond09h,_xPos09,"_xcPos09")
            _cCond09j:= STRTRAN(_cCond09i,_xPos10,"_xcPos10")
            _cCond09k:= STRTRAN(_cCond09j,_xPos11,"_xcPos11")
            _cCond09l:= STRTRAN(_cCond09k,_xPos12,"_xcPos12")
            _cCond09m:= STRTRAN(_cCond09l,_xPos13,"_xcPos13")
            _cCond09n:= STRTRAN(_cCond09m,_xPos14,"_xcPos14")
            _cCond09o:= STRTRAN(_cCond09n,_xPos15,"_xcPos15")
            _cCond09p:= STRTRAN(_cCond09o,_xPos16,"_xcPos16")
            _cCond09q:= STRTRAN(_cCond09p,_xPos17,"_xcPos17")
            _cCond09r:= STRTRAN(_cCond09q,_xPos18,"_xcPos18")
            _cCond09s:= STRTRAN(_cCond09r,_xPos19,"_xcPos19")
            _cCond09t:= STRTRAN(_cCond09s,_xPos20,"_xcPos20")
            
			lcCond09:= &_cCond09t
			If lcCond09
				cCond09:= cPos09
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 09: "+cPos09)
				cCond09:= "-"
			EndIf
			
		Else
			cCond09:= cPos09
		EndIf
	Else
		If !Empty(cPos09)
			alert("Atencao, acessorio nao disponível na posicao 09: "+cPos09)
			cCond09:= "-"
		Else
			cCond09:= ""
		EndIf
	EndIf  
		_cDDcr09  := iif(SZ0->Z0_DCR=="S",cCond09,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr09 := iif(SZ0->Z0_DCR=="N",cCond09,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos10 == "-" .or. cPos10 = "--"
	cCond10 := cPos10
Else
	If dbSeek(xFilial("SZ0")+cPos10+cCod+"10")
		_cPos10c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc10  := alltrim(SZ0->Z0_DESCOP)
		_cDesc10c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig10 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal10:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc10d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond10:= SZ0->Z0_CONDICA

            _cCond10a:= STRTRAN(_cCond10,_xPos01,"_xcPos01")
            _cCond10b:= STRTRAN(_cCond10a,_xPos02,"_xcPos02")
            _cCond10c:= STRTRAN(_cCond10b,_xPos03,"_xcPos03")
            _cCond10d:= STRTRAN(_cCond10c,_xPos04,"_xcPos04")
            _cCond10e:= STRTRAN(_cCond10d,_xPos05,"_xcPos05")
            _cCond10f:= STRTRAN(_cCond10e,_xPos06,"_xcPos06")
            _cCond10g:= STRTRAN(_cCond10f,_xPos07,"_xcPos07")
            _cCond10h:= STRTRAN(_cCond10g,_xPos08,"_xcPos08")
            _cCond10i:= STRTRAN(_cCond10h,_xPos09,"_xcPos09")
            _cCond10j:= STRTRAN(_cCond10i,_xPos10,"_xcPos10")
            _cCond10k:= STRTRAN(_cCond10j,_xPos11,"_xcPos11")
            _cCond10l:= STRTRAN(_cCond10k,_xPos12,"_xcPos12")
            _cCond10m:= STRTRAN(_cCond10l,_xPos13,"_xcPos13")
            _cCond10n:= STRTRAN(_cCond10m,_xPos14,"_xcPos14")
            _cCond10o:= STRTRAN(_cCond10n,_xPos15,"_xcPos15")
            _cCond10p:= STRTRAN(_cCond10o,_xPos16,"_xcPos16")
            _cCond10q:= STRTRAN(_cCond10p,_xPos17,"_xcPos17")
            _cCond10r:= STRTRAN(_cCond10q,_xPos18,"_xcPos18")
            _cCond10s:= STRTRAN(_cCond10r,_xPos19,"_xcPos19")
            _cCond10t:= STRTRAN(_cCond10s,_xPos20,"_xcPos20")
            
			lcCond010:= &_cCond10t
			If lcCond10
				cCond10:= cPos10
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 10: "+cPos10)
				cCond10:= "-"
			EndIf
			
		Else
			cCond10:= cPos10
		EndIf
	Else
		If !Empty(cPos10)
			alert("Atencao, acessorio nao disponível na posicao 10: "+cPos10)
			cCond10:= "-"
		Else
			cCond10:= ""
		EndIf
	EndIf 
		_cDDcr10  := iif(SZ0->Z0_DCR=="S",cCond10,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr10 := iif(SZ0->Z0_DCR=="N",cCond10,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos11 == "-" .or. cPos11 = "--"
	cCond11 := cPos11
Else
	If dbSeek(xFilial("SZ0")+cPos11+cCod+"11")
		_cPos11c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc11  := alltrim(SZ0->Z0_DESCOP)
		_cDesc11c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig11 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal11:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc11d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond11:= SZ0->Z0_CONDICA

            _cCond11a:= STRTRAN(_cCond11,_xPos01,"_xcPos01")
            _cCond11b:= STRTRAN(_cCond11a,_xPos02,"_xcPos02")
            _cCond11c:= STRTRAN(_cCond11b,_xPos03,"_xcPos03")
            _cCond11d:= STRTRAN(_cCond11c,_xPos04,"_xcPos04")
            _cCond11e:= STRTRAN(_cCond11d,_xPos05,"_xcPos05")
            _cCond11f:= STRTRAN(_cCond11e,_xPos06,"_xcPos06")
            _cCond11g:= STRTRAN(_cCond11f,_xPos07,"_xcPos07")
            _cCond11h:= STRTRAN(_cCond11g,_xPos08,"_xcPos08")
            _cCond11i:= STRTRAN(_cCond11h,_xPos09,"_xcPos09")
            _cCond11j:= STRTRAN(_cCond11i,_xPos10,"_xcPos10")
            _cCond11k:= STRTRAN(_cCond11j,_xPos11,"_xcPos11")
            _cCond11l:= STRTRAN(_cCond11k,_xPos12,"_xcPos12")
            _cCond11m:= STRTRAN(_cCond11l,_xPos13,"_xcPos13")
            _cCond11n:= STRTRAN(_cCond11m,_xPos14,"_xcPos14")
            _cCond11o:= STRTRAN(_cCond11n,_xPos15,"_xcPos15")
            _cCond11p:= STRTRAN(_cCond11o,_xPos16,"_xcPos16")
            _cCond11q:= STRTRAN(_cCond11p,_xPos17,"_xcPos17")
            _cCond11r:= STRTRAN(_cCond11q,_xPos18,"_xcPos18")
            _cCond11s:= STRTRAN(_cCond11r,_xPos19,"_xcPos19")
            _cCond11t:= STRTRAN(_cCond11s,_xPos20,"_xcPos20")
            
			lcCond011:= &_cCond11t
			If lcCond11
				cCond11:= cPos11
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 11: "+cPos11)
				cCond11:= "-"
			EndIf
			
		Else
			cCond11:= cPos11
		EndIf
	Else
		If !Empty(cPos11)
			alert("Atencao, acessorio nao disponível na posicao 11: "+cPos11)
			cCond11:= "-"
		Else
			cCond11:= ""
		EndIf
	EndIf   
		_cDDcr11  := iif(SZ0->Z0_DCR=="S",cCond11,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr11 := iif(SZ0->Z0_DCR=="N",cCond11,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos12 == "-" .or. cPos12 = "--"
	cCond12 := cPos12
Else
	If dbSeek(xFilial("SZ0")+cPos12+cCod+"12")
		_cPos12c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc12  := alltrim(SZ0->Z0_DESCOP)
		_cDesc12c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig12 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal12:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc12d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond12:= SZ0->Z0_CONDICA

            _cCond12a:= STRTRAN(_cCond12,_xPos01,"_xcPos01")
            _cCond12b:= STRTRAN(_cCond12a,_xPos02,"_xcPos02")
            _cCond12c:= STRTRAN(_cCond12b,_xPos03,"_xcPos03")
            _cCond12d:= STRTRAN(_cCond12c,_xPos04,"_xcPos04")
            _cCond12e:= STRTRAN(_cCond12d,_xPos05,"_xcPos05")
            _cCond12f:= STRTRAN(_cCond12e,_xPos06,"_xcPos06")
            _cCond12g:= STRTRAN(_cCond12f,_xPos07,"_xcPos07")
            _cCond12h:= STRTRAN(_cCond12g,_xPos08,"_xcPos08")
            _cCond12i:= STRTRAN(_cCond12h,_xPos09,"_xcPos09")
            _cCond12j:= STRTRAN(_cCond12i,_xPos10,"_xcPos10")
            _cCond12k:= STRTRAN(_cCond12j,_xPos11,"_xcPos11")
            _cCond12l:= STRTRAN(_cCond12k,_xPos12,"_xcPos12")
            _cCond12m:= STRTRAN(_cCond12l,_xPos13,"_xcPos13")
            _cCond12n:= STRTRAN(_cCond12m,_xPos14,"_xcPos14")
            _cCond12o:= STRTRAN(_cCond12n,_xPos15,"_xcPos15")
            _cCond12p:= STRTRAN(_cCond12o,_xPos16,"_xcPos16")
            _cCond12q:= STRTRAN(_cCond12p,_xPos17,"_xcPos17")
            _cCond12r:= STRTRAN(_cCond12q,_xPos18,"_xcPos18")
            _cCond12s:= STRTRAN(_cCond12r,_xPos19,"_xcPos19")
            _cCond12t:= STRTRAN(_cCond12s,_xPos20,"_xcPos20")
            
			lcCond012:= &_cCond12t
			If lcCond12
				cCond12:= cPos12
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 12: "+cPos12)
				cCond12:= "-"
			EndIf
			
		Else
			cCond12:= cPos12
		EndIf
	Else
		If !Empty(cPos12)
			alert("Atencao, acessorio nao disponível na posicao 12: "+cPos12)
			cCond12:= "-"
		Else
			cCond12:= ""
		EndIf
	EndIf    
		_cDDcr12  := iif(SZ0->Z0_DCR=="S",cCond12,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr12 := iif(SZ0->Z0_DCR=="N",cCond12,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos13 == "-" .or. cPos13 = "--"
	cCond13 := cPos13
Else
	If dbSeek(xFilial("SZ0")+cPos13+cCod+"13")
		_cPos13c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc13  := alltrim(SZ0->Z0_DESCOP)
		_cDesc13c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig13 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal13:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc13d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond13:= SZ0->Z0_CONDICA

            _cCond13a:= STRTRAN(_cCond13,_xPos01,"_xcPos01")
            _cCond13b:= STRTRAN(_cCond13a,_xPos02,"_xcPos02")
            _cCond13c:= STRTRAN(_cCond13b,_xPos03,"_xcPos03")
            _cCond13d:= STRTRAN(_cCond13c,_xPos04,"_xcPos04")
            _cCond13e:= STRTRAN(_cCond13d,_xPos05,"_xcPos05")
            _cCond13f:= STRTRAN(_cCond13e,_xPos06,"_xcPos06")
            _cCond13g:= STRTRAN(_cCond13f,_xPos07,"_xcPos07")
            _cCond13h:= STRTRAN(_cCond13g,_xPos08,"_xcPos08")
            _cCond13i:= STRTRAN(_cCond13h,_xPos09,"_xcPos09")
            _cCond13j:= STRTRAN(_cCond13i,_xPos10,"_xcPos10")
            _cCond13k:= STRTRAN(_cCond13j,_xPos11,"_xcPos11")
            _cCond13l:= STRTRAN(_cCond13k,_xPos12,"_xcPos12")
            _cCond13m:= STRTRAN(_cCond13l,_xPos13,"_xcPos13")
            _cCond13n:= STRTRAN(_cCond13m,_xPos14,"_xcPos14")
            _cCond13o:= STRTRAN(_cCond13n,_xPos15,"_xcPos15")
            _cCond13p:= STRTRAN(_cCond13o,_xPos16,"_xcPos16")
            _cCond13q:= STRTRAN(_cCond13p,_xPos17,"_xcPos17")
            _cCond13r:= STRTRAN(_cCond13q,_xPos18,"_xcPos18")
            _cCond13s:= STRTRAN(_cCond13r,_xPos19,"_xcPos19")
            _cCond13t:= STRTRAN(_cCond13s,_xPos20,"_xcPos20")
            
			lcCond013:= &_cCond13t
			If lcCond13
				cCond13:= cPos13
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 13: "+cPos13)
				cCond13:= "-"
			EndIf
			
		Else
			cCond13:= cPos13
		EndIf
	Else
		If !Empty(cPos13)
			alert("Atencao, acessorio nao disponível na posicao 13: "+cPos13)
			cCond13:= "-"
		Else
			cCond13:= ""
		EndIf
	EndIf    
		_cDDcr13  := iif(SZ0->Z0_DCR=="S",cCond13,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr13 := iif(SZ0->Z0_DCR=="N",cCond13,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf


If cPos14 == "-" .or. cPos14 = "--"
	cCond14 := cPos14
Else
	If dbSeek(xFilial("SZ0")+cPos14+cCod+"14")
		_cPos14c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc14  := alltrim(SZ0->Z0_DESCOP)
		_cDesc14c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig14 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal14:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc14d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond14:= SZ0->Z0_CONDICA

            _cCond14a:= STRTRAN(_cCond14,_xPos01,"_xcPos01")
            _cCond14b:= STRTRAN(_cCond14a,_xPos02,"_xcPos02")
            _cCond14c:= STRTRAN(_cCond14b,_xPos03,"_xcPos03")
            _cCond14d:= STRTRAN(_cCond14c,_xPos04,"_xcPos04")
            _cCond14e:= STRTRAN(_cCond14d,_xPos05,"_xcPos05")
            _cCond14f:= STRTRAN(_cCond14e,_xPos06,"_xcPos06")
            _cCond14g:= STRTRAN(_cCond14f,_xPos07,"_xcPos07")
            _cCond14h:= STRTRAN(_cCond14g,_xPos08,"_xcPos08")
            _cCond14i:= STRTRAN(_cCond14h,_xPos09,"_xcPos09")
            _cCond14j:= STRTRAN(_cCond14i,_xPos10,"_xcPos10")
            _cCond14k:= STRTRAN(_cCond14j,_xPos11,"_xcPos11")
            _cCond14l:= STRTRAN(_cCond14k,_xPos12,"_xcPos12")
            _cCond14m:= STRTRAN(_cCond14l,_xPos13,"_xcPos13")
            _cCond14n:= STRTRAN(_cCond14m,_xPos14,"_xcPos14")
            _cCond14o:= STRTRAN(_cCond14n,_xPos15,"_xcPos15")
            _cCond14p:= STRTRAN(_cCond14o,_xPos16,"_xcPos16")
            _cCond14q:= STRTRAN(_cCond14p,_xPos17,"_xcPos17")
            _cCond14r:= STRTRAN(_cCond14q,_xPos18,"_xcPos18")
            _cCond14s:= STRTRAN(_cCond14r,_xPos19,"_xcPos19")
            _cCond14t:= STRTRAN(_cCond14s,_xPos20,"_xcPos20")
            
			lcCond014:= &_cCond14t
			If lcCond14
				cCond14:= cPos14
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 14: "+cPos14)
				cCond14:= "-"
			EndIf
			
		Else
			cCond14:= cPos14
		EndIf
	Else
		If !Empty(cPos14)
			alert("Atencao, acessorio nao disponível na posicao 12: "+cPos14)
			cCond14:= "-"
		Else
			cCond14:= ""
		EndIf
	EndIf  
		_cDDcr14  := iif(SZ0->Z0_DCR=="S",cCond14,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr14 := iif(SZ0->Z0_DCR=="N",cCond14,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf                                                                       

If cPos15 == "-" .or. cPos15 = "--"
	cCond15 := cPos15
Else
	If dbSeek(xFilial("SZ0")+cPos15+cCod+"15")
		_cPos15c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc15  := alltrim(SZ0->Z0_DESCOP)
		_cDesc15c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig15 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal15:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc15d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond15:= SZ0->Z0_CONDICA

            _cCond15a:= STRTRAN(_cCond15,_xPos01,"_xcPos01")
            _cCond15b:= STRTRAN(_cCond15a,_xPos02,"_xcPos02")
            _cCond15c:= STRTRAN(_cCond15b,_xPos03,"_xcPos03")
            _cCond15d:= STRTRAN(_cCond15c,_xPos04,"_xcPos04")
            _cCond15e:= STRTRAN(_cCond15d,_xPos05,"_xcPos05")
            _cCond15f:= STRTRAN(_cCond15e,_xPos06,"_xcPos06")
            _cCond15g:= STRTRAN(_cCond15f,_xPos07,"_xcPos07")
            _cCond15h:= STRTRAN(_cCond15g,_xPos08,"_xcPos08")
            _cCond15i:= STRTRAN(_cCond15h,_xPos09,"_xcPos09")
            _cCond15j:= STRTRAN(_cCond15i,_xPos10,"_xcPos10")
            _cCond15k:= STRTRAN(_cCond15j,_xPos11,"_xcPos11")
            _cCond15l:= STRTRAN(_cCond15k,_xPos12,"_xcPos12")
            _cCond15m:= STRTRAN(_cCond15l,_xPos13,"_xcPos13")
            _cCond15n:= STRTRAN(_cCond15m,_xPos14,"_xcPos14")
            _cCond15o:= STRTRAN(_cCond15n,_xPos15,"_xcPos15")
            _cCond15p:= STRTRAN(_cCond15o,_xPos16,"_xcPos16")
            _cCond15q:= STRTRAN(_cCond15p,_xPos17,"_xcPos17")
            _cCond15r:= STRTRAN(_cCond15q,_xPos18,"_xcPos18")
            _cCond15s:= STRTRAN(_cCond15r,_xPos19,"_xcPos19")
            _cCond15t:= STRTRAN(_cCond15s,_xPos20,"_xcPos20")
            
			lcCond015:= &_cCond15t
			If lcCond15
				cCond15:= cPos15
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 15: "+cPos15)
				cCond15:= "-"
			EndIf
			
		Else
			cCond15:= cPos15
		EndIf
	Else
		If !Empty(cPos15)
			alert("Atencao, acessorio nao disponível na posicao 15: "+cPos15)
			cCond15:= "-"
		Else
			cCond15:= ""
		EndIf
	EndIf       
		_cDDcr15  := iif(SZ0->Z0_DCR=="S",cCond15,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr15 := iif(SZ0->Z0_DCR=="N",cCond15,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos16 == "-" .or. cPos16 = "--"
	cCond16 := cPos16
Else
	If dbSeek(xFilial("SZ0")+cPos16+cCod+"16")
		_cPos16c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc16  := alltrim(SZ0->Z0_DESCOP)
		_cDesc16c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig16 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal16:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc16d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond16:= SZ0->Z0_CONDICA

            _cCond16a:= STRTRAN(_cCond16,_xPos01,"_xcPos01")
            _cCond16b:= STRTRAN(_cCond16a,_xPos02,"_xcPos02")
            _cCond16c:= STRTRAN(_cCond16b,_xPos03,"_xcPos03")
            _cCond16d:= STRTRAN(_cCond16c,_xPos04,"_xcPos04")
            _cCond16e:= STRTRAN(_cCond16d,_xPos05,"_xcPos05")
            _cCond16f:= STRTRAN(_cCond16e,_xPos06,"_xcPos06")
            _cCond16g:= STRTRAN(_cCond16f,_xPos07,"_xcPos07")
            _cCond16h:= STRTRAN(_cCond16g,_xPos08,"_xcPos08")
            _cCond16i:= STRTRAN(_cCond16h,_xPos09,"_xcPos09")
            _cCond16j:= STRTRAN(_cCond16i,_xPos10,"_xcPos10")
            _cCond16k:= STRTRAN(_cCond16j,_xPos11,"_xcPos11")
            _cCond16l:= STRTRAN(_cCond16k,_xPos12,"_xcPos12")
            _cCond16m:= STRTRAN(_cCond16l,_xPos13,"_xcPos13")
            _cCond16n:= STRTRAN(_cCond16m,_xPos14,"_xcPos14")
            _cCond16o:= STRTRAN(_cCond16n,_xPos15,"_xcPos15")
            _cCond16p:= STRTRAN(_cCond16o,_xPos16,"_xcPos16")
            _cCond16q:= STRTRAN(_cCond16p,_xPos17,"_xcPos17")
            _cCond16r:= STRTRAN(_cCond16q,_xPos18,"_xcPos18")
            _cCond16s:= STRTRAN(_cCond16r,_xPos19,"_xcPos19")
            _cCond16t:= STRTRAN(_cCond16s,_xPos20,"_xcPos20")
            
			lcCond016:= &_cCond16t
			If lcCond16
				cCond16:= cPos16
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 16: "+cPos16)
				cCond16:= "-"
			EndIf
			
		Else
			cCond16:= cPos16
		EndIf
	Else
		If !Empty(cPos16)
			alert("Atencao, acessorio nao disponível na posicao 16: "+cPos16)
			cCond16:= "-"
		Else
			cCond16:= ""
		EndIf
	EndIf  
		_cDDcr16  := iif(SZ0->Z0_DCR=="S",cCond16,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr16 := iif(SZ0->Z0_DCR=="N",cCond16,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf
                    
If cPos17 == "-" .or. cPos17 = "--"
	cCond17 := cPos17
Else
	If dbSeek(xFilial("SZ0")+cPos17+cCod+"17")
		_cPos17c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc17  := alltrim(SZ0->Z0_DESCOP)
		_cDesc17c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig17 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal17:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc17d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond17:= SZ0->Z0_CONDICA

            _cCond17a:= STRTRAN(_cCond17,_xPos01,"_xcPos01")
            _cCond17b:= STRTRAN(_cCond17a,_xPos02,"_xcPos02")
            _cCond17c:= STRTRAN(_cCond17b,_xPos03,"_xcPos03")
            _cCond17d:= STRTRAN(_cCond17c,_xPos04,"_xcPos04")
            _cCond17e:= STRTRAN(_cCond17d,_xPos05,"_xcPos05")
            _cCond17f:= STRTRAN(_cCond17e,_xPos06,"_xcPos06")
            _cCond17g:= STRTRAN(_cCond17f,_xPos07,"_xcPos07")
            _cCond17h:= STRTRAN(_cCond17g,_xPos08,"_xcPos08")
            _cCond17i:= STRTRAN(_cCond17h,_xPos09,"_xcPos09")
            _cCond17j:= STRTRAN(_cCond17i,_xPos10,"_xcPos10")
            _cCond17k:= STRTRAN(_cCond17j,_xPos11,"_xcPos11")
            _cCond17l:= STRTRAN(_cCond17k,_xPos12,"_xcPos12")
            _cCond17m:= STRTRAN(_cCond17l,_xPos13,"_xcPos13")
            _cCond17n:= STRTRAN(_cCond17m,_xPos14,"_xcPos14")
            _cCond17o:= STRTRAN(_cCond17n,_xPos15,"_xcPos15")
            _cCond17p:= STRTRAN(_cCond17o,_xPos16,"_xcPos16")
            _cCond17q:= STRTRAN(_cCond17p,_xPos17,"_xcPos17")
            _cCond17r:= STRTRAN(_cCond17q,_xPos18,"_xcPos18")
            _cCond17s:= STRTRAN(_cCond17r,_xPos19,"_xcPos19")
            _cCond17t:= STRTRAN(_cCond17s,_xPos20,"_xcPos20")
            
			lcCond017:= &_cCond17t
			If lcCond17
				cCond17:= cPos17
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 17: "+cPos17)
				cCond17:= "-"
			EndIf
			
		Else
			cCond17:= cPos17
		EndIf
	Else
		If !Empty(cPos17)
			alert("Atencao, acessorio nao disponível na posicao 17: "+cPos17)
			cCond17:= "-"
		Else
			cCond17:= ""
		EndIf
	EndIf  
		_cDDcr17  := iif(SZ0->Z0_DCR=="S",cCond17,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr17 := iif(SZ0->Z0_DCR=="N",cCond17,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos18 == "-" .or. cPos18 = "--"
	cCond18 := cPos18
Else
	If dbSeek(xFilial("SZ0")+cPos18+cCod+"18")
		_cPos18c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc18  := alltrim(SZ0->Z0_DESCOP)
		_cDesc18c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig18 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal18:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc18d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond18:= SZ0->Z0_CONDICA

            _cCond18a:= STRTRAN(_cCond18,_xPos01,"_xcPos01")
            _cCond18b:= STRTRAN(_cCond18a,_xPos02,"_xcPos02")
            _cCond18c:= STRTRAN(_cCond18b,_xPos03,"_xcPos03")
            _cCond18d:= STRTRAN(_cCond18c,_xPos04,"_xcPos04")
            _cCond18e:= STRTRAN(_cCond18d,_xPos05,"_xcPos05")
            _cCond18f:= STRTRAN(_cCond18e,_xPos06,"_xcPos06")
            _cCond18g:= STRTRAN(_cCond18f,_xPos07,"_xcPos07")
            _cCond18h:= STRTRAN(_cCond18g,_xPos08,"_xcPos08")
            _cCond18i:= STRTRAN(_cCond18h,_xPos09,"_xcPos09")
            _cCond18j:= STRTRAN(_cCond18i,_xPos10,"_xcPos10")
            _cCond18k:= STRTRAN(_cCond18j,_xPos11,"_xcPos11")
            _cCond18l:= STRTRAN(_cCond18k,_xPos12,"_xcPos12")
            _cCond18m:= STRTRAN(_cCond18l,_xPos13,"_xcPos13")
            _cCond18n:= STRTRAN(_cCond18m,_xPos14,"_xcPos14")
            _cCond18o:= STRTRAN(_cCond18n,_xPos15,"_xcPos15")
            _cCond18p:= STRTRAN(_cCond18o,_xPos16,"_xcPos16")
            _cCond18q:= STRTRAN(_cCond18p,_xPos17,"_xcPos17")
            _cCond18r:= STRTRAN(_cCond18q,_xPos18,"_xcPos18")
            _cCond18s:= STRTRAN(_cCond18r,_xPos19,"_xcPos19")
            _cCond18t:= STRTRAN(_cCond18s,_xPos20,"_xcPos20")
            
			lcCond018:= &_cCond18t
			If lcCond18
				cCond18:= cPos18
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 18: "+cPos18)
				cCond18:= "-"
			EndIf
			
		Else
			cCond18:= cPos18
		EndIf
	Else
		If !Empty(cPos18)
			alert("Atencao, acessorio nao disponível na posicao 18: "+cPos18)
			cCond18:= "-"
		Else
			cCond18:= ""
		EndIf
	EndIf     
		_cDDcr18  := iif(SZ0->Z0_DCR=="S",cCond18,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr18 := iif(SZ0->Z0_DCR=="N",cCond18,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf

If cPos19 == "-" .or. cPos19 = "--"
	cCond19 := cPos19
Else
	If dbSeek(xFilial("SZ0")+cPos19+cCod+"19")
		_cPos19c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc19  := alltrim(SZ0->Z0_DESCOP)
		_cDesc19c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig19 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal19:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc19d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond19:= SZ0->Z0_CONDICA

            _cCond19a:= STRTRAN(_cCond19,_xPos01,"_xcPos01")
            _cCond19b:= STRTRAN(_cCond19a,_xPos02,"_xcPos02")
            _cCond19c:= STRTRAN(_cCond19b,_xPos03,"_xcPos03")
            _cCond19d:= STRTRAN(_cCond19c,_xPos04,"_xcPos04")
            _cCond19e:= STRTRAN(_cCond19d,_xPos05,"_xcPos05")
            _cCond19f:= STRTRAN(_cCond19e,_xPos06,"_xcPos06")
            _cCond19g:= STRTRAN(_cCond19f,_xPos07,"_xcPos07")
            _cCond19h:= STRTRAN(_cCond19g,_xPos08,"_xcPos08")
            _cCond19i:= STRTRAN(_cCond19h,_xPos09,"_xcPos09")
            _cCond19j:= STRTRAN(_cCond19i,_xPos10,"_xcPos10")
            _cCond19k:= STRTRAN(_cCond19j,_xPos11,"_xcPos11")
            _cCond19l:= STRTRAN(_cCond19k,_xPos12,"_xcPos12")
            _cCond19m:= STRTRAN(_cCond19l,_xPos13,"_xcPos13")
            _cCond19n:= STRTRAN(_cCond19m,_xPos14,"_xcPos14")
            _cCond19o:= STRTRAN(_cCond19n,_xPos15,"_xcPos15")
            _cCond19p:= STRTRAN(_cCond19o,_xPos16,"_xcPos16")
            _cCond19q:= STRTRAN(_cCond19p,_xPos17,"_xcPos17")
            _cCond19r:= STRTRAN(_cCond19q,_xPos18,"_xcPos18")
            _cCond19s:= STRTRAN(_cCond19r,_xPos19,"_xcPos19")
            _cCond19t:= STRTRAN(_cCond19s,_xPos20,"_xcPos20")
            
			lcCond019:= &_cCond19t
			If lcCond19
				cCond19:= cPos19
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 19: "+cPos19)
				cCond19:= "-"
			EndIf
			
		Else
			cCond19:= cPos19
		EndIf
	Else
		If !Empty(cPos19)
			alert("Atencao, acessorio nao disponível na posicao 19: "+cPos19)
			cCond19:= "-"
		Else
			cCond19:= ""
		EndIf
	EndIf
		_cDDcr19  := iif(SZ0->Z0_DCR=="S",cCond19,"") // Cria codigo DCR que será impresso no cmpo código do produto na Danfe 
		_cDCDcr19 := iif(SZ0->Z0_DCR=="N",cCond19,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf
                   
If cPos20 == "-" .or. cPos20 = "--"
	cCond20 := cPos20
Else
	If dbSeek(xFilial("SZ0")+cPos20+cCod+"20")
		_cPos20c  := SZ0->Z0_POSICAO //saber qual a descricao da posição, se "ALI", para tratar na hora de criar a estrutura
		_cDesc20  := alltrim(SZ0->Z0_DESCOP)
		_cDesc20c := alltrim(SZ0->Z0_DESC_CO)
		_cObrig20 := SZ0->Z0_OBRIG                      //Se o produto eh obrigatorio na estrutura
		_cCodCal20:= SZ0->Z0_CALIBRA
		If SZ0->Z0_DESC_NF == "S"
    		_cDesc20d  := alltrim(SZ0->Z0_DESCOP) // Descricao para a Nota Fiscal (B1_desc)
        EndIf
		
		If !Empty(SZ0->Z0_CONDICA)
			_cCond20:= SZ0->Z0_CONDICA

            _cCond20a:= STRTRAN(_cCond20,_xPos01,"_xcPos01")
            _cCond20b:= STRTRAN(_cCond20a,_xPos02,"_xcPos02")
            _cCond20c:= STRTRAN(_cCond20b,_xPos03,"_xcPos03")
            _cCond20d:= STRTRAN(_cCond20c,_xPos04,"_xcPos04")
            _cCond20e:= STRTRAN(_cCond20d,_xPos05,"_xcPos05")
            _cCond20f:= STRTRAN(_cCond20e,_xPos06,"_xcPos06")
            _cCond20g:= STRTRAN(_cCond20f,_xPos07,"_xcPos07")
            _cCond20h:= STRTRAN(_cCond20g,_xPos08,"_xcPos08")
            _cCond20i:= STRTRAN(_cCond20h,_xPos09,"_xcPos09")
            _cCond20j:= STRTRAN(_cCond20i,_xPos10,"_xcPos10")
            _cCond20k:= STRTRAN(_cCond20j,_xPos11,"_xcPos11")
            _cCond20l:= STRTRAN(_cCond20k,_xPos12,"_xcPos12")
            _cCond20m:= STRTRAN(_cCond20l,_xPos13,"_xcPos13")
            _cCond20n:= STRTRAN(_cCond20m,_xPos14,"_xcPos14")
            _cCond20o:= STRTRAN(_cCond20n,_xPos15,"_xcPos15")
            _cCond20p:= STRTRAN(_cCond20o,_xPos16,"_xcPos16")
            _cCond20q:= STRTRAN(_cCond20p,_xPos17,"_xcPos17")
            _cCond20r:= STRTRAN(_cCond20q,_xPos18,"_xcPos18")
            _cCond20s:= STRTRAN(_cCond20r,_xPos19,"_xcPos19")
            _cCond20t:= STRTRAN(_cCond20s,_xPos20,"_xcPos20")
            
			lcCond020:= &_cCond20t
			If lcCond20
				cCond20:= cPos20
			Else
				alert("Atencao, acessorio nao permitido, favor verificar o cenario posicao 20: "+cPos20)
				cCond20:= "-"
			EndIf
			
		Else
			cCond20:= cPos20
		EndIf
	Else
		If !Empty(cPos20)
			alert("Atencao, acessorio nao disponível na posicao 20: "+cPos20)
			cCond20:= "-"
		Else
			cCond20:= ""
		EndIf
	EndIf          
		_cDDcr20  := iif(SZ0->Z0_DCR=="S",cCond20,"") // Cria codigo DCR que será impresso no campo código do produto na Danfe 
		_cDCDcr20 := iif(SZ0->Z0_DCR=="N",cCond20,"") // Cria codigo de complemento será impresso junto com a descricao na danfe 
	
EndIf


//Descricao do produto

_cCodnew:=alltrim(cCod)+alltrim(cCond01)+alltrim(cCond02)+alltrim(cCond03)+alltrim(cCond04)+alltrim(cCond05)+alltrim(cCond06)+alltrim(cCond07)+alltrim(cCond08)+alltrim(cCond09)+alltrim(cCond10)+alltrim(cCond11)+alltrim(cCond12)
_cCodnew+=alltrim(cCond13)+alltrim(cCond14)+alltrim(cCond15)+alltrim(cCond16)+alltrim(cCond17)+alltrim(cCond18)+alltrim(cCond19)+alltrim(cCond20)

_cCodCalib:=alltrim(cCod)+IIF(_cCodCal01=="S",alltrim(cCond01),"")+IIF(_cCodCal02=="S",alltrim(cCond02),"")+IIF(_cCodCal03=="S",alltrim(cCond03),"")+IIF(_cCodCal04=="S",alltrim(cCond04),"")+IIF(_cCodCal05=="S",alltrim(cCond05),"")+IIF(_cCodCal06=="S",alltrim(cCond06),"")+IIF(_cCodCal07=="S",alltrim(cCond07),"")+IIF(_cCodCal08=="S",alltrim(cCond08),"")+IIF(_cCodCal09=="S",alltrim(cCond09),"")+IIF(_cCodCal10=="S",alltrim(cCond10),"")+IIF(_cCodCal11=="S",alltrim(cCond11),"")+IIF(_cCodCal12=="S",alltrim(cCond12),"")
_cCodCalib+=IIF(_cCodCal13=="S",alltrim(cCond13),"")+IIF(_cCodCal141=="S",alltrim(cCond14),"")+IIF(_cCodCal15=="S",alltrim(cCond15),"")+IIF(_cCodCal16=="S",alltrim(cCond16),"")+IIF(_cCodCal17=="S",alltrim(cCond17),"")+IIF(_cCodCal18=="S",alltrim(cCond18),"")+IIF(_cCodCal19=="S",alltrim(cCond19),"")+IIF(_cCodCal01=="S",alltrim(cCond20),"")

// Descricao Producao
/*
cDescomp1:=alltrim(cDescomp)+IIF(_cDesc01<>"."," "+Alltrim(_cDesc01),"-")+IIF(_cDesc02<>"."," "+Alltrim(_cDesc02),"-")+IIF(_cDesc03<>"."," "+Alltrim(_cDesc03),"-")+IIF(_cDesc04<>"."," "+Alltrim(_cDesc04),"-")
cDescomp1+= IIF(_cDesc05<>"."," "+Alltrim(_cDesc05),"-")+IIF(_cDesc06<>"."," "+Alltrim(_cDesc06),"-")+IIF(_cDesc07<>"."," "+Alltrim(_cDesc07),"-")+IIF(_cDesc08<>"."," "+Alltrim(_cDesc08),"-")
cDescomp1+= IIF(_cDesc09<>"."," "+Alltrim(_cDesc09),"-")+IIF(_cDesc10<>"."," "+Alltrim(_cDesc10),"-")+IIF(_cDesc11<>"."," "+Alltrim(_cDesc11),"-")+IIF(_cDesc12<>"."," "+Alltrim(_cDesc12),"-")
cDescomp1+= IIF(_cDesc13<>"."," "+Alltrim(_cDesc13),"-")+IIF(_cDesc14<>"."," "+Alltrim(_cDesc14),"-")+IIF(_cDesc15<>"."," "+Alltrim(_cDesc15),"-")+IIF(_cDesc16<>"."," "+Alltrim(_cDesc16),"-")
cDescomp1+= IIF(_cDesc17<>"."," "+Alltrim(_cDesc17),"-")+IIF(_cDesc18<>"."," "+Alltrim(_cDesc18),"-")+IIF(_cDesc19<>"."," "+Alltrim(_cDesc19),"--")+IIF(_cDesc20<>"."," "+Alltrim(_cDesc20),"--")
*/
cDescomp1:=alltrim(cCod)+" "+Alltrim(_cDesc01c)+" "+Alltrim(_cDesc02c)+" "+Alltrim(_cDesc03c)+" "+Alltrim(_cDesc04c)+" "+Alltrim(_cDesc05c)+" "+Alltrim(_cDesc06c)
cDescomp1+= " "+Alltrim(_cDesc07c)+" "+Alltrim(_cDesc08c)+" "+Alltrim(_cDesc09c)+" "+Alltrim(_cDesc10c)+" "+Alltrim(_cDesc11c)+" "+Alltrim(_cDesc12c)
cDescomp1+= " "+Alltrim(_cDesc13c)+" "+Alltrim(_cDesc14c)+" "+Alltrim(_cDesc15c)+" "+Alltrim(_cDesc16c)+" "+Alltrim(_cDesc17c)+" "+Alltrim(_cDesc18c)
cDescomp1+= " "+Alltrim(_cDesc19c)+" "+Alltrim(_cDesc20c)

// Descricao Comercial
cDescomp2:=alltrim(cCod)+" "+Alltrim(_cDesc01c)+" "+Alltrim(_cDesc02c)+" "+Alltrim(_cDesc03c)+" "+Alltrim(_cDesc04c)+" "+Alltrim(_cDesc05c)+" "+Alltrim(_cDesc06c)
cDescomp2+= " "+Alltrim(_cDesc07c)+" "+Alltrim(_cDesc08c)+" "+Alltrim(_cDesc09c)+" "+Alltrim(_cDesc10c)+" "+Alltrim(_cDesc11c)+" "+Alltrim(_cDesc12c)
cDescomp2+= " "+Alltrim(_cDesc13c)+" "+Alltrim(_cDesc14c)+" "+Alltrim(_cDesc15c)+" "+Alltrim(_cDesc16c)+" "+Alltrim(_cDesc17c)+" "+Alltrim(_cDesc18c)
cDescomp2+= " "+Alltrim(_cDesc19c)+" "+Alltrim(_cDesc20c)

// Descricao Nota Fiscal
cDescomp3:=alltrim(cDescomp)+" "+Alltrim(_cDesc01d)+" "+Alltrim(_cDesc02d)+" "+Alltrim(_cDesc03d)+" "+Alltrim(_cDesc04d)+" "+Alltrim(_cDesc05d)+" "+Alltrim(_cDesc06d)
cDescomp3+= " "+Alltrim(_cDesc07d)+" "+Alltrim(_cDesc08d)+" "+Alltrim(_cDesc09d)+" "+Alltrim(_cDesc10d)+" "+Alltrim(_cDesc11d)+" "+Alltrim(_cDesc12d)
cDescomp3+= " "+Alltrim(_cDesc13d)+" "+Alltrim(_cDesc14d)+" "+Alltrim(_cDesc15d)+" "+Alltrim(_cDesc16d)+" "+Alltrim(_cDesc17d)+" "+Alltrim(_cDesc18d)
cDescomp3+= " "+Alltrim(_cDesc19d)+" "+Alltrim(_cDesc20d)

// Codigo que será impresso na Danfe (Grupo de DCR)
cDescDCR:=alltrim(_cDDcr01)+alltrim(_cDDcr02)+alltrim(_cDDcr03)+alltrim(_cDDcr04)+alltrim(_cDDcr05)+alltrim(_cDDcr06)+alltrim(_cDDcr07)+alltrim(_cDDcr08)+alltrim(_cDDcr09)+alltrim(_cDDcr10)+alltrim(_cDDcr11)+alltrim(_cDDcr12)
cDescDCR+=alltrim(_cDDcr13)+alltrim(_cDDcr14)+alltrim(_cDDcr15)+alltrim(_cDDcr16)+alltrim(_cDDcr17)+alltrim(_cDDcr18)+alltrim(_cDDcr19)+alltrim(_cDDcr20)

If !Empty(cDescDCR)
  cDescDCR:=alltrim(cCod)+cDescDCR
  
  cDescDCR1:=alltrim(_cDCDcr01)+alltrim(_cDCDcr02)+alltrim(_cDCDcr03)+alltrim(_cDCDcr04)+alltrim(_cDCDcr05)+alltrim(_cDCDcr06)+alltrim(_cDCDcr07)+alltrim(_cDCDcr08)+alltrim(_cDCDcr09)+alltrim(_cDCDcr10)+alltrim(_cDCDcr11)+alltrim(_cDDcr12)
  cDescDCR1+=alltrim(_cDCDcr13)+alltrim(_cDCDcr14)+alltrim(_cDCDcr15)+alltrim(_cDCDcr16)+alltrim(_cDCDcr17)+alltrim(_cDCDcr18)+alltrim(_cDCDcr19)+alltrim(_cDCDcr20)

Else 
  cDescDCR :=""
  cDescDCR1:=""
EndIf

If !MsgBox("Confirma?","Criar o produto: "+_cCodnew,"YesNo")
	Return
EndIf

dbSelectArea("SB1")
dbSetOrder(1)//C5_CLPEDCL
If dbSeek( xFilial("SB1")+_cCodNew )  //so entra se o no. do pedido ja existir.
	alert("Atencao produto ja cadastrado com estas configuracoes: "+_cCodNew)
	return
EndIf

//	MSGBOX("Geracao do pedido no: " +_cCodigo,"ALERT")

_aAutoSB1	:= 	{;
{"B1_FILIAL"	 , xFilial("SB1")   ,      },;
{"B1_COD"        , _cCodNew,"NaoVazio().And.ExistChav('SB1')" },;
{"B1_DESC"	     , cDescomp3	,      },;
{"B1_TIPO"	     , cTipo	,      },;
{"B1_LOCPAD"	 , cLocPad	,      },;
{"B1_GRUPO"	     , cGrupo	,      },;
{"B1_UM"	     , cUm   	,      },;
{"B1_PICM"	     , cPicm    ,      },;
{"B1_IPI"	     , cIPI  	,      },;
{"B1_POSIPI"	 , cPosIpi	,      },;
{"B1_CLSTATU"    , cClStatu	,      },;
{"B1_DESCOMP"    , cdesc,          },;
{"B1_CONTA"      , cConta,         },;
{"B1_NARRA"      , cDescomp1,      },;        
{"B1_CLESPEC"    , cClespec	,      },;  
{"B1_ORIGEM"     , cOrigem	,      },;
{"B1_CLGOP"      , cClgOp	,      },;
{"B1_CLSITE"     , cClSite	,      },;
{"B1_ANUENTE"    , cAnuente,       },;
{"B1_MIDIA"      , cMidia,         },;
{"B1_X_CODB"     , cCod,           },;
{"B1_X_VENDA"    , "N",            },;  
{"B1_GARANT"     , "2",            },;  
{"B1_X_PROJ"     , _cProjeto,      },;
{"B1_X_POS01"    , _xPos01,        },;
{"B1_X_POS02"    , _xPos02,        },;
{"B1_X_POS03"    , _xPos03,        },;
{"B1_X_POS04"    , _xPos04,        },;
{"B1_X_POS05"    , _xPos05,        },;
{"B1_X_POS06"    , _xPos06,        },;
{"B1_X_POS07"    , _xPos07,        },;
{"B1_X_POS08"    , _xPos08,        },;
{"B1_X_POS09"    , _xPos09,        },;
{"B1_X_POS10"    , _xPos10,        },;
{"B1_X_POS11"    , _xPos11,        },;
{"B1_X_POS12"    , _xPos12,        },;
{"B1_X_POS13"    , _xPos13,        },;
{"B1_X_POS14"    , _xPos14,        },;
{"B1_X_POS15"    , _xPos15,        },;
{"B1_X_POS16"    , _xPos16,        },;
{"B1_X_POS17"    , _xPos17,        },;
{"B1_X_POS18"    , _xPos18,        },;
{"B1_X_POS19"    , _xPos19,        },;
{"B1_X_POS20"    , _xPos20,        },;
{"B1_X_L01"      , cCond01,        },;
{"B1_X_L02"      , cCond02,        },;
{"B1_X_L03"      , cCond03,        },;
{"B1_X_L04"      , cCond04,        },;
{"B1_X_L05"      , cCond05,        },;
{"B1_X_L06"      , cCond06,        },;
{"B1_X_L07"      , cCond07,        },;
{"B1_X_L08"      , cCond08,        },;
{"B1_X_L09"      , cCond09,        },;
{"B1_X_L10"      , cCond10,        },; 
{"B1_X_L11"      , cCond11,        },;
{"B1_X_L12"      , cCond12,        },;
{"B1_X_L13"      , cCond13,        },;
{"B1_X_L14"      , cCond14,        },;
{"B1_X_L15"      , cCond15,        },;
{"B1_X_L16"      , cCond16,        },;
{"B1_X_L17"      , cCond17,        },;
{"B1_X_L18"      , cCond18,        },;
{"B1_X_L19"      , cCond19,        },;
{"B1_X_L20"      , cCond20,        },;
{"B1_X_DESCC"   , cDescomp2,      },; 
{"B1_CLANT"      , _cCodCalib,     },;   
{"B1_X_DCR"      , cDCR,           },;
{"B1_CLCFAM"     , cFamilia,       },;
{"B1_CLCGRP"     , cGrpCtb,        },;  
{"B1_X_FABRI"    , cFabri,         }}
                                       
// {"B5_UMIND"      , "1" ,           },; 
//{"B1_X_DDCR"     , cDescDCR,       },; 
//{"B1_X_CDCR"     , cDescDCR1,      },; 
lMSHelpAuto := .f.
lMsErroAuto := .f.
msExecAuto({|x,y,z|Mata010(x,y)},_aAutoSB1,3)

If lMsErroAuto
	mostraerro()
	lErro := .T.
	DisarmTransaction()
	Return
Else
	
	aCab := {	{"G1_COD"		,_cCodNew			,NIL},;
	{"G1_QUANT"		,1		     		,NIL},;
	{"NIVALT"		,"N"				,NIL}} //A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura
	
	
	aGets := {}
	aadd(aGets,	{"G1_COD"		,_cCodNew 			,NIL})
	aadd(aGets,	{"G1_COMP"		,cCod    			,NIL})
	aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
	aadd(aGets,	{"G1_QUANT"		,1					,NIL})
	aadd(aGets,	{"G1_PERDA"		,0					,NIL})
	aadd(aGets,	{"G1_INI"		,CTOD("01/01/10")	,NIL})
	aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
	aadd(aItem,aGets)
	
	
	If cCond01 <> "-" .or. cCond01 <> "--" //.and. _cObrig01 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond01+cCod+"01")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond01)
				Alert("Atencao, componente nao cadastrado no cenario 1: "+cCond01)
			EndIf
		EndIf
	EndIf
	
	If cCond02 <> "-" .or. cCond02 <> "--" //.and. _cObrig02 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond02+cCod+"02")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond02)
				Alert("Atencao, componente nao cadastrado no cenario 2: "+cCond02)
			EndIf
		EndIf
	EndIf
	
	If cCond03 <> "-" .or. cCond03 <> "--" //.and. _cObrig03 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond03+cCod+"03")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond03)
				Alert("Atencao, componente nao cadastrado no cenario 3: "+cCond03)
			EndIf
		EndIf
	EndIf
	
	If cCond04 <> "-" .or. cCond04 <> "--" //.and. _cObrig04 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond04+cCod+"04")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond04)
				Alert("Atencao, componente nao cadastrado no cenario 4: "+cCond04)
			EndIf
		EndIf
	EndIf
	
	If cCond05 <> "-" .or. cCond05 <> "-" //.and. _cObrig05 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond05+cCod+"05")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			Endif
		Else
			If !Empty(cCond05)
				Alert("Atencao, componente nao cadastrado no cenario 5: "+cCond05)
			EndIf
		EndIf
	EndIf
	
	If cCond06 <> "-" .or. cCond06 <> "--" //.and. _cObrig06 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond06+cCod+"06")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond06)
				Alert("Atencao, componente nao cadastrado no cenario 6: "+cCond06)
			EndIf
		EndIf
	EndIf
	
	If cCond07 <> "-" .or. cCond07 <> "-" //.and. _cObrig07 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond07+cCod+"07")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond07)
				Alert("Atencao, componente nao cadastrado no cenario 7: "+cCond07)
			EndIf
		EndIf
	EndIf
	
	If cCond08 <> "-" .or. cCond08 <> "--" // .and. _cObrig08 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond08+cCod+"08")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond08)
				Alert("Atencao, componente nao cadastrado no cenario 8: "+cCond08)
			EndIf
		EndIf
	EndIf
	
	If cCond09 <> "-" .or. cCond09 <> "--" //.and. _cObrig09 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond09+cCod+"09")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond09)
				Alert("Atencao, componente nao cadastrado no cenario 9: "+cCond09)
			EndIf
		EndIf
	EndIf
	
	If cCond10 <> "-" .or. cCond10 <> "--" //  .and. _cObrig10 <> "1"
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond10+cCod+"10")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond10)
				Alert("Atencao, componente nao cadastrado no cenario 10: "+cCond10)
			EndIf
		EndIf
	EndIf
	
	If cCond11 <> "-" .or. cCond11 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond11+cCod+"11")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond11)
				Alert("Atencao, componente nao cadastrado no cenario 11: "+cCond11)
			EndIf
		EndIf
	EndIf
	
	If cCond12 <> "-" .or. cCond12 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond12+cCod+"12")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond12)
				Alert("Atencao, componente nao cadastrado no cenario 12: "+cCond12)
			EndIf
		EndIf
	EndIf

	If cCond13 <> "-" .or. cCond13 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond13+cCod+"13")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond13)
				Alert("Atencao, componente nao cadastrado no cenario 13: "+cCond13)
			EndIf
		EndIf
	EndIf

	If cCond14 <> "-" .or. cCond14 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond14+cCod+"14")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond14)
				Alert("Atencao, componente nao cadastrado no cenario 14: "+cCond14)
			EndIf
		EndIf
	EndIf
	
	If cCond15 <> "-" .or. cCond15 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond15+cCod+"15")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond15)
				Alert("Atencao, componente nao cadastrado no cenario 15: "+cCond15)
			EndIf
		EndIf
	EndIf

	If cCond16 <> "-" .or. cCond16 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond16+cCod+"16")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond16)
				Alert("Atencao, componente nao cadastrado no cenario 16: "+cCond16)
			EndIf
		EndIf
	EndIf
	
	If cCond17 <> "-" .or. cCond17 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond17+cCod+"17")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond17)
				Alert("Atencao, componente nao cadastrado no cenario 17: "+cCond17)
			EndIf
		EndIf
	EndIf

	If cCond18 <> "-" .or. cCond18 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond18+cCod+"18")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond18)
				Alert("Atencao, componente nao cadastrado no cenario 18: "+cCond18)
			EndIf
		EndIf
	EndIf
	                                                                              
	If cCond19 <> "-" .or. cCond19 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond19+cCod+"19")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond19)
				Alert("Atencao, componente nao cadastrado no cenario 19: "+cCond19)
			EndIf
		EndIf
	EndIf
	                                                                   
	If cCond20 <> "-" .or. cCond20 <> "--" 
		dbSelectArea("SZ0")
		dbSetOrder(3)
		If dbSeek(xFilial("SZ0")+cCond20+cCod+"20")
			If !empty(SZ0->Z0_COMP001) // Quando terá alguma letra mas nao terá componente
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
		Else
			If !Empty(cCond20)
				Alert("Atencao, componente nao cadastrado no cenario 20: "+cCond20)
			EndIf
		EndIf
	EndIf
	
	dbSelectArea("SZ0")                                                           
	dbSetOrder(2)
	dbSeek(xFilial("SZ0")+cCod)
	While !Eof() .and. cCod == SZ0->Z0_CODIGO
		If !Empty(SZ0->Z0_POSICAO)
			dbSkip()
			Loop
		EndIf
		If !Empty(SZ0->Z0_CONDICA)
			cEspec   := SZ0->Z0_CONDICA

            cEspeca:= STRTRAN(cEspec,_xPos01,"_xcPos01")  
            cEspecb:= STRTRAN(cEspeca,_xPos02,"_xcPos02")
            cEspecc:= STRTRAN(cEspecb,_xPos03,"_xcPos03")
            cEspecd:= STRTRAN(cEspecc,_xPos04,"_xcPos04")
            cEspece:= STRTRAN(cEspecd,_xPos05,"_xcPos05")
            cEspecf:= STRTRAN(cEspece,_xPos06,"_xcPos06")
            cEspecg:= STRTRAN(cEspecf,_xPos07,"_xcPos07")
            cEspech:= STRTRAN(cEspecg,_xPos08,"_xcPos08")
            cEspeci:= STRTRAN(cEspech,_xPos09,"_xcPos09")
            cEspecj:= STRTRAN(cEspeci,_xPos10,"_xcPos10")
            cEspeck:= STRTRAN(cEspecj,_xPos11,"_xcPos11")
            cEspecl:= STRTRAN(cEspeck,_xPos12,"_xcPos12")
            cEspecm:= STRTRAN(cEspecl,_xPos13,"_xcPos13")
            cEspecn:= STRTRAN(cEspecm,_xPos14,"_xcPos14")
            cEspeco:= STRTRAN(cEspecn,_xPos15,"_xcPos15")
            cEspecp:= STRTRAN(cEspeco,_xPos16,"_xcPos16")            
            cEspecq:= STRTRAN(cEspecp,_xPos17,"_xcPos17")            
            cEspecr:= STRTRAN(cEspecq,_xPos18,"_xcPos18")            
            cEspecs:= STRTRAN(cEspecr,_xPos19,"_xcPos19")            
            cEspect:= STRTRAN(cEspecs,_xPos20,"_xcPos20")            
                        
			lEspec1  := &cEspect
			If lEspec1
				aGets := {}
				aadd(aGets,	{"G1_COD"		,_cCodNew           ,NIL})
				aadd(aGets,	{"G1_COMP"		,SZ0->Z0_COMP001	,NIL})
				aadd(aGets,	{"G1_TRT"		,SPACE(3)  			,NIL})
				aadd(aGets,	{"G1_QUANT"		,SZ0->Z0_QTDAS01    ,NIL})
				aadd(aGets,	{"G1_PERDA"		,0					,NIL})
				aadd(aGets,	{"G1_INI"		,CTOD("01/08/11")	,NIL})
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
				aadd(aItem,aGets)
			EndIf
			
		EndIf
		
		dbSelectArea("SZ0")
		dbSkip()
	EndDo
	
	ctipo := "NOVO"
	
	MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,3)
	// ser utilizada 3-Inclusao, 4- Alteracao e 5- Exclusao
	
	MSGALERT("Produto cadastrado com sucesso: "+_cCodNew,"SUCESSO","INFO")
	
	Sair()
	
EndIf

Return()
                          
USER FUNCTION XMata010() 
LOCAL aVetor := {} 
LOCAL cCodigo := "TESTE" 
PRIVATE lMsErroAuto := .F. 

//--- Exemplo: Inclusao --- // 
AADD(aVetor, {"B1_FILIAL", xFilial("SB1"), NIL}) 
AADD(aVetor, {"B1_COD", cCodigo, NIL}) 
AADD(aVetor, {"B1_DESC", "PRODUTO TESTE - ROTINA AUTOMATICA", NIL}) 
AADD(aVetor, {"B1_TIPO", "PA", NIL}) 
AADD(aVetor, {"B1_UM", "UN", NIL}) 
AADD(aVetor, {"B1_LOCPAD", "01", NIL}) 
AADD(aVetor, {"B1_ORIGEM", "0", NIL}) 
AADD(aVetor, {"B1_PICM", 0, NIL}) 
AADD(aVetor, {"B1_IPI", 0, NIL}) 
//AADD(aVetor, {"B1_CONTRAT", "N", NIL}) 
//AADD(aVetor, {"B1_XUSADO", "C", NIL}) 
AADD(aVetor, {"B1_LOCALIZ", "N", NIL}) 


lMsErroAuto := .F. 
MSExecAuto({|x, y| Mata010(x, y)}, aVetor, 3) 

IF lMsErroAuto 
     MostraErro() 
ELSE 
     Alert("Produto Incluido com sucesso!!!!") 
ENDIF 

RETURN NIL 
