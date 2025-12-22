#include "ap5mail.ch"
#include "Protheus.Ch"
#include "TopConn.Ch"
#include "TBIConn.Ch"
#include "TbiCode.ch"

/*/{Protheus.doc} VISWFPROD

Tela de mauntencao de alçada do workflow de produtos.

@type function
@author Honda Lock
@since 01/10/2017

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VISWFPROD ³ Autor ³ Leandro Nascimento    ³ Data ³15/09/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Montagem da Tela para manutencao do controle de alcadas WF ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MP8 -                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VISWFPROD()

// Variaveis Locais da Funcao
Local aComboBx1	 	:= {}
Local oEdit1
Local oEdit2
Local oEdit3
Local oEdit4
Local oRadioGrp1

// Variaveis Private da Funcao
Private _oDlg
Private nRadioGrp1	:= 1
Private cEdit1	 	:= Space(30)
Private cEdit2	 	:= Space(15)
Private cEdit3	 	:= Space(10)
Private cEdit4	 	:= Space(02)
Private cComboBx1
Private aCampos   := {"ZB1_NIVEL","ZB1_STATUS","ZB1_OBS","ZB1_PROCES"}
Private cTipo := ""

// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

// Privates das NewGetDados
Private oGetDados
Private _aArea := GetArea()

Private aHead        := {}
Private aCols        := {}
*******************************************************************
// Verifica o acesso do usuário antes de abrir a tela de manutencao
*******************************************************************

//aComboBx1	 	:= {"Reenviar Nivel Atual"}


DEFINE MSDIALOG _oDlg TITLE "WorkFlow de Produtos" FROM C(178),C(181) TO C(485),C(789) PIXEL

// Cria as Groups do Sistema
@ C(002),C(109) TO C(033),C(300) LABEL "Dados" PIXEL OF _oDlg

// Cria Componentes Padroes do Sistema
@ C(001),C(005) TO C(033),C(060) LABEL "Tipo" PIXEL OF _oDlg
@ C(007),C(010) Radio oRadioGrp1 Var nRadioGrp1 Items "Atual","Histórico"  Size C(045),C(012) PIXEL OF _oDlg

@ C(002),C(062) Say "Produto" 				 Size C(035),C(008) COLOR CLR_BLACK 		PIXEL OF _oDlg
@ C(023),C(070) Button "Consultar" 			 Size C(030),C(009) ACTION (CarrDados()) 	PIXEL OF _oDlg

@ C(010),C(112) Say "Descrição" 			 Size C(054),C(008) COLOR CLR_BLACK 		PIXEL OF _oDlg
@ C(010),C(224) Say "Status" 				 Size C(021),C(008) COLOR CLR_BLACK 		PIXEL OF _oDlg
//@ C(010),C(276) Say "Status" 				 Size C(019),C(008) COLOR CLR_BLACK 		PIXEL OF _oDlg
@ C(010),C(062) MsGet oEdit1 Var cEdit1 F3 "SB1"	 Size C(041),C(009) COLOR CLR_BLACK 		PIXEL OF _oDlg
@ C(018),C(113) MsGet oEdit2 Var cEdit2 	 Size C(106),C(009) COLOR CLR_BLACK 		PIXEL OF _oDlg  When 1=0
@ C(018),C(223) MsGet oEdit3 Var cEdit3 	 Size C(049),C(009) COLOR CLR_BLACK 		PIXEL OF _oDlg  When 1=0
//@ C(018),C(276) MsGet oEdit4 Var cEdit4 	 Size C(020),C(009) COLOR CLR_BLACK 		PIXEL OF _oDlg  When 1=0
/*
@ C(141),C(030) ComboBox cComboBx1 Items aComboBx1 Size C(079),C(010) 					PIXEL OF _oDlg
@ C(142),C(007) Say "Ação =>" 				 Size C(022),C(008) COLOR CLR_BLACK 		PIXEL OF _oDlg
*/
@ C(140),C(200) Button "Reenviar Nivel Atual"	 Size C(050),C(012) ACTION (Reenvia())   PIXEL OF _oDlg

@ C(140),C(263) Button "Fechar"  			 Size C(037),C(012) ACTION (_oDlg:End())   PIXEL OF _oDlg

fGetDados()

ACTIVATE MSDIALOG _oDlg CENTERED

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³fGetDados() ³ Autor ³ Leandro Nascimento        ³ Data ³15/09/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGetDados()

Local nX			:= 0
Local nUsado        := 0
Local _nFlag 		:= 0

Public aAlter      	:= {""}
Public nSuperior   	:= C(037)
Public nEsquerda   	:= C(005)
Public nInferior   	:= C(136)
Public nDireita    	:= C(300)

Public nOpc        	:= 0

// Objeto no qual a MsNewGetDados sera criada
Public oWnd         := _oDlg
//aHead        := {}

*****************************************
// Carrega aHead
*****************************************
SX3->(DbSetOrder(2)) // Campo
For nX := 1 to Len(aCampos)
	
	If SX3->(DbSeek(aCampos[nX]))
		
		_cTit  := X3Titulo()
		
		Aadd(aHead,{ AllTrim(_cTit),;
		SX3->X3_CAMPO	,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO ,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID	,;
		SX3->X3_USADO	,;
		SX3->X3_TIPO	,;
		SX3->X3_F3 		,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX	,;
		SX3->X3_RELACAO})
		nUsado++
	Endif
Next nX

//oGetDados:=  MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita, nOpc, "AllwaysTrue", "AllwaysTrue", "",aAlter, 000, 999, , , , oWnd, aHead, NIL)
oGetDados:=  MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita, nOpc, "AllwaysTrue", "AllwaysTrue", "",, 000, 999, , , , oWnd, aHead)
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autor   ³ Leandro Nascimento     ³ Data ³15/09/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function C(nTam)

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return Int(nTam)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³CarrDados³ Autor   ³ Leandro Nascimento     ³ Data ³15/09/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao que carrega os dados no ACOLS de acordo com o param.  ³±±
±±³           ³ de SC ou PC informado pelo usuario.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function CarrDados()

Local cChaveZB1 := ""
//Local aCOLS 	:= {}
Local _nFlag 	:= 0 

aCOLS 	:= {}

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+cEdit1,.F.)

DbSelectArea("ZB1")
DbSetOrder(1)
DbSeek(xFilial("ZB1")+cEdit1,.F.)


****************
// Carrega Cabec
****************

If SB1->(dbSeek(xFilial("SB1") + Alltrim(cEdit1)))
	cEdit2 := SB1->B1_DESC
	If SB1->B1_ZZNIVWF = "1"
		cEdit3 := "Pendente"
	ElseIf SB1->B1_ZZNIVWF = "2"
		cEdit3 := "Aguard. Compras"
	ElseIf SB1->B1_ZZNIVWF = "3"
		cEdit3 := "Aguard. PCP"
	ElseIf SB1->B1_ZZNIVWF = "4"
		cEdit3 := "Aguard. Fiscal"
	ElseIf SB1->B1_ZZNIVWF = "5"
		cEdit3 := "Aguard. Contábi"
	ElseIf SB1->B1_ZZNIVWF = "6"
		cEdit3 := "Concluído"
	ElseIf SB1->B1_ZZNIVWF = "7"
		cEdit3 := "Lib. Manual"
	Endif
Else
	Alert("Produto Não Cadastrado!")
	Return
Endif


****************
// Carrega aCols
****************

If ZB1->(dbSeek(xFilial("ZB1") + Alltrim(cEdit1)))
	While ZB1->ZB1_COD == SB1->B1_COD .And. ZB1->(!Eof())
		If nRadioGrp1 == 1
			If Alltrim(SB1->B1_ZZIDWF) = Alltrim(ZB1->ZB1_PROCES)
				aAdd( aCOLS, Array(Len(aCampos)+1))
			Else
				ZB1->(dbSkip())
				loop
			Endif
		Else
			aAdd( aCOLS, Array(Len(aCampos)+1))
		Endif
		
		_nFlag := 0
		
		For i := 1 to Len(aCampos)
			aCOLS[Len(aCOLS),i] := ZB1->(FieldGet(FieldPos(aCampos[i])))
		Next i
		
		aCOLS[Len(aCOLS),i] := .F. // Nao esta deletado
		ZB1->(dbSkip())
		_nFlag := 0
	EndDo               

*****************************************
// Carrega aHead - 	RMMMB
*****************************************

nUsado        := 0       
Ahead 		  :={}

SX3->(DbSetOrder(2)) // Campo
For nX := 1 to Len(aCampos)
	
	If SX3->(DbSeek(aCampos[nX]))
		
		_cTit  := X3Titulo()
		
		Aadd(aHead,{ AllTrim(_cTit),;
		SX3->X3_CAMPO	,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO ,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID	,;
		SX3->X3_USADO	,;
		SX3->X3_TIPO	,;
		SX3->X3_F3 		,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX	,;
		SX3->X3_RELACAO})
		nUsado++
	Endif
Next nX
	             	
	// Atualiza o GetDados  
	If Len(Ahead) <> 0 .And. Len(aCols) <> 0
	   oGetDados := msNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita, nOpc, .F., .F., , , , , , , , , aHead, aCOLS)
	   //oGetDados:=  MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita, nOpc, "AllwaysTrue", "AllwaysTrue", "",aAlter, 000, 999, , , , oWnd, aHead, NIL)
       //oGetDados:=  MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita, nOpc, "AllwaysTrue", "AllwaysTrue", "",, 000, 999, , , , oWnd, aHead)
	Else 
	   Alert("Sem Processos WorkFlow para o Produto!")
	Endif
Else
	Alert("Sem Processos WorkFlow para o Produto!")
	fGetDados()
	Return
Endif

RestArea(_aArea)
Return
                                                                           

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³CarrDados³ Autor   ³ Leandro Nascimento     ³ Data ³15/09/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao que carrega os dados no ACOLS de acordo com o param.  ³±±
±±³           ³ informado pelo usuario.                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Reenvia()

Local lEncontrou := .F.
Local cDataA := Substring(dtos(date()),7,2)+"/"+Substring(dtos(date()),5,2)+"/"+Substring(dtos(date()),1,4)
Local cNomeUsr:= UsrFullName(RetCodUsr())

If Aviso('Reenviar WF', 'Deseja realmente realizar uma nova notificação para o Nivel Atual do Produto?', {'Sim', 'Nao'}) == 1
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+cEdit1,.F.)
	
	DbSelectArea("ZB1")
	DbSetOrder(1)
	DbSeek(xFilial("ZB1")+cEdit1,.F.)
	
	
	If ZB1->(dbSeek(xFilial("ZB1") + Alltrim(cEdit1)))
		While  ZB1->(!Eof()) .And. Alltrim(ZB1->ZB1_PROCES) == Alltrim(SB1->B1_ZZIDWF) .And. Alltrim(ZB1->ZB1_COD) == Alltrim(cEdit1)
			If ZB1->ZB1_STATUS == "2" 
				RecLock ("ZB1", .F.)
				ZB1->ZB1_SITUWF	:= "" //Reenviado WF
				ZB1->ZB1_OBS	:= " ** Nível Reenviado em: "+cDataA+" as : "+Time()+" Pelo Usuário: "+Alltrim(cNomeUsr)+" **"
				MsUnlock ()
				lEncontrou := .T.
			Endif
			ZB1->(dbSkip())
		EndDo
	Else
		Alert("Sem Processos WorkFlow para o Produto!")
		Return
	Endif
	
	If !lEncontrou
		Alert("Não foi possivel reenviar ou não existe processo pendente para o produto!")
	Else
		Alert("Nível atual será notificado em até 15 minutos sobre o processo pendente!")
	Endif
Endif

RestArea(_aArea)
Return

