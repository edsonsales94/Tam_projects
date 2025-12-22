#INCLUDE "Protheus.ch"
#Include "vkey.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINA02                              º Data ³  16/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastros de Treinamentos                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function INFINA02
   Private cCadastro := "Cadastro de Treinamentos"
   Private cAlias1   := "SZ8"
   Private cAlias2   := "SZ6"
   Private aPos      := { 5, 0, 95, 320}
   Private aRotina   := { {"Pesquisar" ,"AxPesqui",0,1} ,;
                          {"Visualizar","u_FINA02Visual",0,2} ,;
                          {"Incluir"   ,"u_FINA02Inclui",0,3} ,;
                          {"Alterar"   ,"u_FINA02Inclui",0,4} ,;
                          {"Excluir"   ,"u_FINA02Visual",0,5} }
   Private nTamDoc   := TamSX3("F2_DOC")[1]

   dbSelectArea(cAlias1)
   dbSetOrder(1)

   mBrowse( 6,1,22,75,cAlias1)
Return

/////////////////////////////////////////////////
User function FINA02Visual(cAlias, nRecNo, nOpc )
	Local oPanelT
	Local nX       := 0
	Local nOpcA    := 0
	Local oDlg     := Nil
	Local oMainWnd := Nil
	Local oFontCou := TFont():New("Courier New",9,15,.T.,.F.,5,.T.,5,.F.,.F.)
	
	Private aGets     := {}
	Private aTela     := {}
	Private cJustific := ""
	Private bCampo    := { |nField| Field(nField) }
	Private Inclui    := .F.
	Private Altera    := .F.
	Private cFilSZ8   := xFilial(cAlias1)
	Private cFilSZ6   := xFilial(cAlias2)
	
	//+----------------------------------
	//| Inicia as variaveis para Enchoice
	//+----------------------------------
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	dbGoTo(nRecNo)
	For nX:= 1 To FCount()
		M->&(Eval(bCampo,nX)) := FieldGet(nX)
	Next nX
	
	/* Pesquisa a justificativa do treinamento */
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	If dbSeek(cFilSZ6+"5"+PADR(SZ8->Z8_CODIGO,nTamDoc))
		cJustific := Z6_JUSTIFI
	Else
		cJustific := CriaVar("Z6_JUSTIFI",.T.)
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 TO 35,81 OF oMainWnd
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,234 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM
	
	EnChoice(cAlias, nRecNo, nOpc,,,,,aPos,, 3,,,,oPanelT)
	
	@ 110,002 To 224,318 PROMPT "Descrição Detalhada" PIXEL OF oPanelT
	
	@ 120,006 SAY "Justificativa" PIXEL OF oPanelT
	@ 130,006 GET oJustific       VAR cJustific SIZE 308,90 PIXEL OF oPanelT MEMO READONLY
	oJustific:oFont := oFontCou
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,oDlg:End() },{|| oDlg:End() })
	
	// Se for exclusão
	If nOpc == 5 .And. nOpcA == 1
		Begin Transaction
		FINA02Grava(3)
		End Transaction
	Endif
	
Return

////////////////////////////////////////////////
User function FINA02Inclui(cAlias, nRecNo, nOpc )
	Local oPanelT
	Local nX       := 0
	Local nOpcA    := 0
	Local oDlg     := Nil
	Local oMainWnd := Nil
	Local oFontCou := TFont():New("Courier New",9,15,.T.,.F.,5,.T.,5,.F.,.F.)
	
	Private aGets     := {}
	Private aTela     := {}
	Private cJustific := ""
	Private bCampo    := { |nField| Field(nField) }
	Private Inclui    := (nOpc == 3)
	Private Altera    := (nOpc == 4)
	Private cFilSZ8   := xFilial(cAlias1)
	Private cFilSZ6   := xFilial(cAlias2)
	
	//+----------------------------------
	//| Inicia as variaveis para Enchoice
	//+----------------------------------
	dbSelectArea(cAlias1)
	dbSetOrder(1)
	dbGoTo(nRecNo)
	For nX:= 1 To FCount()
		If Inclui
			M->&(Eval(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
		Else
			M->&(Eval(bCampo,nX)) := FieldGet(nX)
		Endif
	Next nX
	
	/* Pesquisa a justificativa do treinamento */
	dbSelectArea(cAlias2)
	dbSetOrder(1)
	If Altera .And. dbSeek(cFilSZ6+"5"+PADR(SZ8->Z8_CODIGO,nTamDoc))
		cJustific := Z6_JUSTIFI
	Else
		cJustific := CriaVar("Z6_JUSTIFI",.T.)
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 TO 35,81 OF oMainWnd
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,234 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM
	
	EnChoice(cAlias, nRecNo, nOpc,,,,,aPos,, 3,,,,oPanelT)
	
	@ 110,002 To 224,318 PROMPT "Descrição Detalhada" PIXEL OF oPanelT
	
	@ 120,006 SAY "Justificativa" PIXEL OF oPanelT
	@ 130,006 GET oJustific       VAR cJustific SIZE 308,90 PIXEL OF oPanelT MEMO
	oJustific:oFont := oFontCou
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,;
														{|| nOpcA:= If( Obrigatorio(aGets,aTela) .And. FINA02VldOk() , 1, 0),;
														If( nOpcA == 1 ,oDlg:End(),)}, {|| nOpcA := 0, oDlg:End()})
	
	If nOpcA == 1
		Begin Transaction
		FINA02Grava(nOpc-2)
		If nOpc == 3
			ConfirmSX8()
		Endif
		End Transaction
	ElseIf nOpc == 3
		RollBackSX8()
	Endif
	
Return

///////////////////////////
Static function FINA02VldOk
   Local lRet := .T.

   If !( lRet := !Empty(cJustific) )
      Aviso("INVÁLIDO","Favor preencher a justificativa !",{"OK"},1)
   Endif

Return lRet

/////////////////////////
User function FINA02Valid
   Local lRet := .T.
   Local cVar := Trim(Upper(ReadVar()))
 
   If cVar == "M->Z8_CODIGO"
      lRet:= ExistChav("SZ8")
   ElseIf cVar == "M->Z8_DESCRI"
      lRet:= NaoVazio()
   Endif

Return lRet

////////////////////////////////////////
Static function FINA02Grava(nOpc,nRecNo)
  Local nUsado   := 0
  Local nDel     := 0
  Local nX       := 0
  Local nI       := 0
  Private bCampo := { |nField| FieldName(nField) }
  
  If nOpc == 1 //- Inclusao
     dbSelectArea(cAlias1)
     RecLock(cAlias1,.T.)
     For nX := 1 To FCount()
        If "FILIAL" $ FieldName(nX)
           FieldPut(nX,cFilSZ8)
        Else
           FieldPut(nX,M->&(Eval(bCampo,nX)))
        Endif
     Next nX
     MsUnLock()
     
     dbSelectArea(cAlias2)
     RecLock(cAlias2,.T.)
     (cAlias2)->Z6_FILIAL  := cFilSZ6
     (cAlias2)->Z6_TIPO    := "5"
     (cAlias2)->Z6_NUM     := M->Z8_CODIGO
     (cAlias2)->Z6_JUSTIFI := cJustific
     MsUnLock()
  Endif

  If nOpc == 2 //- Alteracao
     dbSelectArea(cAlias1)
     RecLock(cAlias1,.F.)
     For nX := 1 To FCount()
        If "FILIAL" $ FieldName(nX)
           FieldPut(nX,cFilSZ8)
        Else
           FieldPut(nX,M->&(Eval(bCampo,nX)))
        Endif
     Next nX
     MsUnLock()
  
     dbSelectArea(cAlias2)
     dbSetOrder(1)
     If dbSeek(cFilSZ6+"5"+PADR(SZ8->Z8_CODIGO,nTamDoc))
        RecLock(cAlias2,.F.)
     Else
        RecLock(cAlias2,.T.)
        (cAlias2)->Z6_FILIAL := cFilSZ6
        (cAlias2)->Z6_TIPO   := "5"
        (cAlias2)->Z6_NUM    := M->Z8_CODIGO
     Endif
     (cAlias2)->Z6_JUSTIFI := cJustific
     MsUnLock()
  Endif
  
  If nOpc == 3 //- Exclusao
     dbSelectArea(cAlias2)
     dbSetOrder(1)
     If dbSeek(cFilSZ6+"5"+PADR(SZ8->Z8_CODIGO,nTamDoc))
        RecLock(cAlias2,.F.)
        dbDelete()
        MsUnLock()
        FINA02X2Del(cAlias2)
     Endif

     dbSelectArea(cAlias1)
     RecLock(cAlias1,.F.)
     dbDelete()
     MsUnLock()
     FINA02X2Del(cAlias1)
  EndIf

Return

///////////////////////////////////
Static function FINA02X2Del(cFilSX2)
   Local aArea := GetArea()
   dbSelectArea("SX2")
   dbSetOrder(1)
   If dbSeek(cFilSX2)
      RecLock("SX2",.F.)
      SX2->X2_DELET:= SX2->X2_DELET + 1
      MsUnLock()
   Endif
   RestArea( aArea )
Return
