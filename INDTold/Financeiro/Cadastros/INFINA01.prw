#INCLUDE "Protheus.ch"
#Include "vkey.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINA01 º Autor ³ Ronilton Barros    º Data ³  08/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastros de Viagens                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INFINA01()
   Private cCadastro := "Cadastro de Viagens"
   Private cAlias1   := "SZ7"
   Private cAlias2   := "SZ6"
   Private aPos      := { 5, 0, 95, 320}
   Private aRotina   := { {"Pesquisar" ,"AxPesqui",0,1} ,;
                          {"Visualizar","u_FINA01Visual",0,2} ,;
                          {"Incluir"   ,"u_FINA01Inclui",0,3} ,;
                          {"Alterar"   ,"u_FINA01Inclui",0,4} ,;
                          {"Excluir"   ,"u_FINA01Visual",0,5} }
   Private nTamDoc   := TamSX3("F2_DOC")[1]

   dbSelectArea(cAlias1)
   dbSetOrder(1)

   mBrowse( 6,1,22,75,cAlias1)
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FINA01Visual¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/12/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Visualização / Exclusão da Viagem                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FINA01Visual(cAlias, nRecNo, nOpc )
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
Private cFilSZ7   := xFilial(cAlias1)
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

/* Pesquisa a justificativa da viagem */
dbSelectArea(cAlias2)
dbSetOrder(1)
If dbSeek(cFilSZ6+"3"+PADR(SZ7->Z7_CODIGO,nTamDoc))
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
@ 130,006 GET oJustific       VAR cJustific SIZE 308,90 PIXEL OF oPanelT MEMO READONLY //WHEN .F.
oJustific:oFont := oFontCou

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpcA:=1,oDlg:End() },{|| oDlg:End() })

// Se for exclusão
If nOpc == 5 .And. nOpcA == 1
   Begin Transaction
      FINA01Grava(3)
   End Transaction
Endif
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FINA01Inclui¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/12/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inclusão / Alteração da Viagem                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FINA01Inclui(cAlias, nRecNo, nOpc )
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
Private cFilSZ7   := xFilial(cAlias1)
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

/* Pesquisa a justificativa da viagem */
dbSelectArea(cAlias2)
dbSetOrder(1)
If Altera .And. dbSeek(cFilSZ6+"3"+PADR(SZ7->Z7_CODIGO,nTamDoc))
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
                       {|| nOpcA := If( Obrigatorio(aGets,aTela) .And. FINA01VldOk() , 1, 0),;
                                    If( nOpcA == 1 ,oDlg:End(),)}, {|| nOpcA := 0, oDlg:End()})

If nOpca == 1
   Begin Transaction
      FINA01Grava(nOpc-2)
   End Transaction
Endif
Return

/******************************************************************************
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
+-----------------------------------------------------------------------------+
| ******************* FUNCOES GENERICA DESTE PROGRAMA ************************|
+-----------------------------------------------------------------------------+
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
******************************************************************************/
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FINA01VldOk ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/12/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida o campo memo Justificativa                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FINA01VldOk()
   Local lRet := .T.

   If !( lRet := !Empty(cJustific) )
      Aviso("INVÁLIDO","Favor preencher a justificativa !",{"OK"},1)
   Endif

Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FINA01Valid ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/12/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida os campos do cadastro de viagens                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FINA01Valid()
   Local lRet := .T.
   Local cVar := Trim(Upper(ReadVar()))

   If cVar == "M->Z7_CODIGO"
      lRet := ExistChav("SZ7")
   ElseIf cVar == "M->Z7_VIAJANT"
      If lRet := ExistCpo("CTD")
         M->Z7_NOME := Posicione("CTD",1,XFILIAL("CTD")+M->Z7_VIAJANT,"CTD_DESC01")
      Endif
   ElseIf cVar == "M->Z7_IDA"
      lRet := NaoVazio()
   ElseIf cVar == "M->Z7_VOLTA"
      If lRet := NaoVazio()
         If !( lRet := (M->Z7_VOLTA >= M->Z7_IDA) )
            Aviso("INVÁLIDO","A data do retorno não pode ser menor do que a partida !",{"OK"},1)
         Endif
      Endif
   Endif

Return(lRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FINA01Grava ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/12/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados da Viagem e justificativa                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ nOpc     -> Tipo da função (inclui,altera,exclui)             ¦¦¦
|¦¦           ¦ nRecNo   -> Numero do registro a ser gravado                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FINA01Grava(nOpc,nRecNo)
Local nUsado   := 0
Local nDel     := 0
Local nX       := 0
Local nI       := 0
Private bCampo := { |nField| FieldName(nField) }

//+----------------
//| Se for inclusao
//+----------------
If nOpc == 1
   //+------------------
   //| Grava o Cadastro de Viagens
   //+------------------
   dbSelectArea(cAlias1)
   RecLock(cAlias1,.T.)
   For nX := 1 To FCount()
      If "FILIAL" $ FieldName(nX)
         FieldPut(nX,cFilSZ7)
      Else
         FieldPut(nX,M->&(Eval(bCampo,nX)))
      Endif
   Next nX
   MsUnLock()

   //+------------------
   //| Grava a Justificativa
   //+------------------
   dbSelectArea(cAlias2)
   RecLock(cAlias2,.T.)
   (cAlias2)->Z6_FILIAL  := cFilSZ6
   (cAlias2)->Z6_TIPO    := "3"
   (cAlias2)->Z6_NUM     := M->Z7_CODIGO
   (cAlias2)->Z6_JUSTIFI := cJustific
   MsUnLock()
Endif

//+-----------------
//| Se for alteracao
//+-----------------
If nOpc == 2
   //+--------------------------------------
   //| Grava a Viagem conforme as alteracoes
   //+--------------------------------------
   dbSelectArea(cAlias1)
   RecLock(cAlias1,.F.)
   For nX := 1 To FCount()
      If "FILIAL" $ FieldName(nX)
         FieldPut(nX,cFilSZ7)
      Else
         FieldPut(nX,M->&(Eval(bCampo,nX)))
      Endif
   Next nX
   MsUnLock()

   //+--------------------------------------
   //| Grava o a Justificatica conforme as alteracoes
   //+--------------------------------------
   dbSelectArea(cAlias2)
   dbSetOrder(1)
   If dbSeek(cFilSZ6+"3"+PADR(SZ7->Z7_CODIGO,nTamDoc))
      RecLock(cAlias2,.F.)
   Else
      RecLock(cAlias2,.T.)
      (cAlias2)->Z6_FILIAL := cFilSZ6
      (cAlias2)->Z6_TIPO   := "3"
      (cAlias2)->Z6_NUM    := M->Z7_CODIGO
   Endif
   (cAlias2)->Z6_JUSTIFI := cJustific
   MsUnLock()
Endif

//+----------------
//| Se for exclucao
//+----------------
If nOpc == 3
   //+-------------------
   //| Deleta a Justificativa
   //+-------------------
   dbSelectArea(cAlias2)
   dbSetOrder(1)
   If dbSeek(cFilSZ6+"3"+PADR(SZ7->Z7_CODIGO,nTamDoc))
      RecLock(cAlias2,.F.)
      dbDelete()
      MsUnLock()
      FINA01X2Del(cAlias2)
   Endif

   //+----------------
   //| Deleta a Viagem
   //+----------------
   dbSelectArea(cAlias1)
   RecLock(cAlias1,.F.)
   dbDelete()
   MsUnLock()
   FINA01X2Del(cAlias1)
EndIf

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦FINA01X2Del ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 08/12/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Incrementa valores no X2_DELET                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FINA01X2Del(cFilSX2)
   Local aArea := GetArea()
   dbSelectArea("SX2")
   dbSetOrder(1)
   If dbSeek(cFilSX2)
      RecLock("SX2",.F.)
      SX2->X2_DELET := SX2->X2_DELET + 1
      MsUnLock()
   Endif
   RestArea( aArea )
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+--------------+-------+----------------------+------+----------+¦¦
¦¦¦ Função    ¦ FINA01Num    ¦ Autor ¦ Ener Fredes          ¦ Data ¦          ¦¦¦
¦¦+-----------+--------------+-------+----------------------+------+----------+¦¦
¦¦¦ Descriçäo ¦ Numero da ultima viagem cadastrada                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
USER Function FINA01Num()
   Local cQuery, cNum
   Local cAlias := Alias()

   cQry := " SELECT ISNULL(MAX(Z7_CODIGO),'0') NUMERO"
   cQry += " FROM "+RetSQLName("SZ7")+" WHERE Z7_FILIAL = '"+SZ7->(XFILIAL("SZ7"))+"' AND D_E_L_E_T_ = ' '"

   dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),"XXX",.F.,.T.)
   cNum := StrZero(Val(NUMERO)+1,6)
   DbCloseArea()
   DbselectArea(cAlias)

   Help := .T. // Nao apresentar Help MayUse
  
   While !FreeForUse("SZ7",cNum,.F.)
      cNum := Soma1(cNum)
      Help := .T. // Nao apresentar Help MayUse
   Enddo
  
   Help := .F. // Habilito o help novamente

Return cNum
