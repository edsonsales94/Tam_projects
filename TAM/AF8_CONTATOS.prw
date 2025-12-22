#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "TopConn.ch"
#Include "Colors.ch"

Static nMAX_GROUP := 9 // grupos 1..9

// ==================================================================
User Function PROJ_CONTATOS(cProjIn, cA1In, cLojaIn, cOrigem, nAgdId)

   Local cProj  := ""
   Local cA1    := ""
   Local cLoja  := ""
   Default cOrigem := "PROJ"       // "PROJ" (chamada padrão) | "AGENDA" (vinda da agenda)
   Default nAgdId  := 0            // id da agenda quando vier da agenda (por enquanto não usamos)

   // (opcional) guardar p/ uso futuro (ZP9 etc.)
   Private cCtxOrigem := Upper(AllTrim(cOrigem))
   Private nAgdRecno  := nAgdId

   If !Empty(cProjIn) ; cProj := AllTrim(cProjIn) ; EndIf
   If !Empty(cA1In)   ; cA1   := AllTrim(cA1In)   ; EndIf
   If !Empty(cLojaIn) ; cLoja := AllTrim(cLojaIn) ; EndIf

   If Empty(cA1) .and. Select("AF8")>0 .and. AF8->(Used())
      If AF8->(FieldPos("AF8_CLIENT"))>0 ; cA1   := AllTrim(AF8->AF8_CLIENT) ; EndIf
      If AF8->(FieldPos("AF8_LOJA"))  >0 ; cLoja := AllTrim(AF8->AF8_LOJA)   ; EndIf
      If Empty(cProj) .and. AF8->(FieldPos("AF8_PROJET"))>0 ; cProj := AllTrim(AF8->AF8_PROJET) ; EndIf
   EndIf
   If Empty(cA1)
      If ! MsGet( , , "Cliente (A1_COD):", @cA1 ) ; Return ; EndIf
      cA1 := AllTrim(cA1)
   EndIf

   // ---------- estado ----------
   Private oDlg, oLbx, oBtnBuscar, oBtnReload, oLblNone, oChkOrd
   Private oGetProj, oGetA1, oGetLoja
   Private cInProj, cInA1, cInLoja, cVar, lOrd, aAll

   cInProj := cProj
   cInA1   := cA1
   cInLoja := cLoja
   cVar    := ""
   lOrd    := .F.
   aAll    := {}      // {CONTID, CODENT, NOME, EMAIL, NGRUPO}

   Conout(">> PROJ_CONTATOS_DLG chamada por: " + IIf(Empty(cOrigem),"?",cOrigem))
   // tela principal mais larga
   DEFINE MSDIALOG oDlg TITLE "Contatos do Cliente" FROM 120,50 TO 700,1250 PIXEL
      @ 08, 10  SAY "Projeto:" OF oDlg PIXEL
      @ 06, 50  MSGET oGetProj VAR cInProj PICTURE "@!" SIZE 65,11 OF oDlg PIXEL

      @ 08,125 SAY "Cliente:" OF oDlg PIXEL
      @ 06,165 MSGET oGetA1   VAR cInA1   PICTURE "@!" SIZE 40,11 OF oDlg PIXEL

      @ 08,214 SAY "Loja:"    OF oDlg PIXEL
      @ 06,240 MSGET oGetLoja VAR cInLoja PICTURE "@!" SIZE 20,11 OF oDlg PIXEL

      @ 06,265 BUTTON oBtnBuscar  PROMPT "Buscar"     SIZE 70,12 OF oDlg PIXEL ;
         ACTION MsAguarde({|| ;
            _LoadAll(cInProj,cInA1,cInLoja,@aAll,@lOrd), ;
            _RefreshGrid(oDlg,oLbx,oLblNone,@aAll), ;
            IIf( ValType(oChkOrd)=="O", oChkOrd:Refresh(), NIL ), ;
            oDlg:Refresh() }, "Processando","Buscando...")

      @ 06,345 BUTTON oBtnReload  PROMPT "Recarregar" SIZE 80,12 OF oDlg PIXEL ;
         ACTION MsAguarde({|| ;
            _LoadAll(cInProj,cInA1,cInLoja,@aAll,@lOrd), ;
            _RefreshGrid(oDlg,oLbx,oLblNone,@aAll), ;
            IIf( ValType(oChkOrd)=="O", oChkOrd:Refresh(), NIL ), ;
            oDlg:Refresh() }, "Processando","Recarregando...")

      @ 06,440 CHECKBOX oChkOrd VAR lOrd PROMPT "Ativar ordenação das assinaturas (segue grupos 1 -> 2 -> 3)" ;
         SIZE 360,12 OF oDlg PIXEL ;
         ON CLICK {|| _OnToggleOrd(cInProj, cInA1, cInLoja, @lOrd, @aAll, oDlg, oLbx, oLblNone) }

      // Grade: Nome | Email | Grupo | (espaçador)
      @ 32, 10 LISTBOX oLbx VAR cVar FIELDS ;
         HEADER "Nome","Email","Grupo","" ;
         SIZE 900,220 OF oDlg PIXEL ;
         COLSIZES 150,100,20,999   
      oLbx:bLine      := {|| _LBLine(oLbx,@aAll) }
      oLbx:bLDblClick := {|| _EditaLinha(oLbx, cInProj, @aAll), _RefreshGrid(oDlg,oLbx,oLblNone,@aAll) }

      @ 260, 12 SAY oLblNone PROMPT "Nenhum registro encontrado." SIZE 220,12 OF oDlg PIXEL COLOR CLR_GRAY

      _RefreshGrid(oDlg,oLbx,oLblNone,@aAll)

      @ 280, 800 BUTTON "Fechar" SIZE 60,14 OF oDlg PIXEL ACTION oDlg:End()

      // auto-busca inicial
      If !Empty(cInA1)
         MsAguarde({|| ;
            _LoadAll(cInProj,cInA1,cInLoja,@aAll,@lOrd), ;
            _RefreshGrid(oDlg,oLbx,oLblNone,@aAll), ;
            IIf( ValType(oChkOrd)=="O", oChkOrd:Refresh(), NIL ), ;
            oDlg:Refresh() }, "Processando","Buscando...")
      EndIf
   ACTIVATE MSDIALOG oDlg CENTERED
Return

// ==================================================================
Static Function _OnToggleOrd(cProj,cA1,cLoja,lOrd,aAll,oDlg,oLbx,oLblNone)
   _ApplyOrderFlagToLinks(cProj,cA1,cLoja,lOrd)   // grava 1/0 em todas as linhas ZP8 do projeto
   _LoadAll(cProj,cA1,cLoja,@aAll,@lOrd)
   _RefreshGrid(oDlg,oLbx,oLblNone,@aAll)
   If ValType(oDlg) == "O" ; oDlg:Refresh() ; EndIf
Return NIL

// ==================================================================
Static Function _RefreshGrid(oDlg,oLbx,oLblNone,aAll)
   If oLbx != NIL
      oLbx:SetArray(aAll)
      oLbx:bLine := {|| _LBLine(oLbx,@aAll) }
      oLbx:nAt := IIf(Len(aAll)>0, 1, 0)
      oLbx:Refresh()
   EndIf
   If oLblNone != NIL
      If Len(aAll)==0 ; oLblNone:Show() ; Else ; oLblNone:Hide() ; EndIf
   EndIf
   If oDlg != NIL ; oDlg:Refresh() ; EndIf
Return

Static Function _LBLine(oLbx,aAll)
   Local n := oLbx:nAt
   Local nLen := Len(aAll)
   If n<=0 .or. n>nLen
      Return { "", "", "", "" }
   EndIf
   Return { aAll[n,3], aAll[n,4], cValToChar(aAll[n,5]), "" } // Nome, Email, Grupo, spacer
Return

// ==================================================================
// Carrega contatos (AC8 + SU5) e vínculo (ZP8). Ignora FILIAL para vinculação.
Static Function _LoadAll(cProj,cA1,cLoja,aAll,lOrd)
   Local cAlias := ""
   Local cQuery := ""
   Local cLike  := ""

   aAll := {}
   lOrd := _HasOrderFlag(cProj,cA1,cLoja)

   cLike := IIf(Empty(cLoja), AllTrim(cA1)+" %", AllTrim(cA1)+" "+AllTrim(cLoja)+"%")

   // usa subquery agregada de ZP8 (por projeto/cliente/loja/contato) ? evita duplicados e ignora FILIAL
   cQuery  := "SELECT "
   cQuery += "  AC8.AC8_CODCON AS CONTID, "
   cQuery += "  AC8.AC8_CODENT AS CODENT, "
   cQuery += "  ISNULL(SU5.U5_CONTAT,'') AS NOME, "
   cQuery += "  ISNULL(SU5.U5_EMAIL,'')  AS EMAIL, "
   cQuery += "  ISNULL(ZV.GRUPO,0)       AS GRUPO "
   cQuery += "FROM " + RetSqlName("AC8") + " AC8 WITH (NOLOCK) "
   cQuery += "LEFT JOIN ( "
   cQuery += "   SELECT (RTRIM(ZP8_A1COD)+' '+RTRIM(ZP8_A1LOJA)) AS CODENT, "
   cQuery += "          ZP8_CONTID, MAX(ISNULL(ZP8_GRUPO,0)) AS GRUPO "
   cQuery += "     FROM " + RetSqlName("ZP8") + " WITH (NOLOCK) "
   cQuery += "    WHERE D_E_L_E_T_ IN ('',' ') "
   cQuery += "      AND ZP8_CODPRO = '" + AllTrim(cProj) + "' "
   cQuery += "    GROUP BY (RTRIM(ZP8_A1COD)+' '+RTRIM(ZP8_A1LOJA)), ZP8_CONTID "
   cQuery += ") ZV ON ZV.CODENT = AC8.AC8_CODENT AND ZV.ZP8_CONTID = AC8.AC8_CODCON "
   cQuery += "LEFT JOIN " + RetSqlName("SU5") + " SU5 WITH (NOLOCK) ON "
   cQuery += "     SU5.D_E_L_E_T_ IN ('',' ') "
   // cQuery += " AND SU5.U5_FILIAL = '" + FWxFilial("SU5") + "' "
   cQuery += " AND SU5.U5_CODCONT = AC8.AC8_CODCON "
   cQuery += "WHERE AC8.D_E_L_E_T_ IN ('',' ') "
   cQuery += "  AND AC8.AC8_ENTIDA = 'SA1' "
   cQuery += "  AND AC8.AC8_CODENT LIKE '" + cLike + "' "
   cQuery += "ORDER BY SU5.U5_CONTAT, AC8.AC8_CODCON"

   ConOut("SQL >>> " + cQuery)

   cAlias := MpSysOpenQuery(cQuery)
   If Empty(cAlias) .or. Select(cAlias)==0 .or. !( (cAlias)->(Used()) )
      MsgStop("Não foi possível abrir a consulta de contatos.","Contatos do Cliente")
      Return
   EndIf

   (cAlias)->(DbGoTop())
   Do While !(cAlias)->(EoF())
      AAdd(aAll, { ;
         AllTrim((cAlias)->CONTID), ; // 1
         AllTrim((cAlias)->CODENT), ; // 2
         AllTrim((cAlias)->NOME ),  ; // 3
         AllTrim((cAlias)->EMAIL),  ; // 4
         _ToNum((cAlias)->GRUPO)    ; // 5 (numérico)
      })
      (cAlias)->(DbSkip())
   EndDo
   (cAlias)->(DbCloseArea())
Return

// ==================================================================
// Duplo clique: editar Grupo (numérico). 0 = remover vínculo.
Static Function _EditaLinha(oLbx, cProj, aAll)
   Local n := oLbx:nAt
   Local cCont := ""
   Local cEnt  := ""
   Local cNome := ""
   Local cMail := ""
   Local nGrupo := 0
   Local oD, oG, lOk

   lOk := .F.
   If n<=0 .or. n>Len(aAll) ; Return .F. ; EndIf

   cCont  := aAll[n,1]
   cEnt   := aAll[n,2]
   cNome  := aAll[n,3]
   cMail  := aAll[n,4]
   nGrupo := _ToNum(aAll[n,5])

   DEFINE MSDIALOG oD TITLE "Vincular/Desvincular (Grupo)" FROM 0,0 TO 180,560 PIXEL
      @ 12, 16 SAY "Nome:"   OF oD PIXEL
      @ 12, 60 SAY cNome     OF oD PIXEL
      @ 36, 16 SAY "E-mail:" OF oD PIXEL
      @ 36, 60 SAY cMail     OF oD PIXEL

      @ 72, 16 SAY "Grupo (1..9 / 0=remover):" OF oD PIXEL
      @ 70,210 MSGET oG VAR nGrupo PICTURE "9" SIZE 28,18 OF oD PIXEL

      @ 100,350 BUTTON "Salvar"   SIZE 70,20 OF oD PIXEL ACTION (lOk:=.T., oD:End())
      @ 100,430 BUTTON "Cancelar" SIZE 80,20 OF oD PIXEL ACTION oD:End()
      oD:bStart := {|| oG:SetFocus() }
   ACTIVATE MSDIALOG oD CENTERED

   If !lOk
      Return .F.
   EndIf

   If !(nGrupo >= 0 .and. nGrupo <= nMAX_GROUP)
      MsgStop("Grupo inválido. Use 1.." + cValToChar(nMAX_GROUP) + " ou 0 para remover.","Validação")
      Return .F.
   EndIf

   If nGrupo == 0
      If _ZP8_Delete(cProj,cEnt,cCont)
         aAll[n,5] := 0
      EndIf
   Else
      If _ZP8_Upsert(cProj,cEnt,cCont, nGrupo, -1, cNome,cMail) // -1 = não altera ORDEM
         aAll[n,5] := nGrupo
      EndIf
   EndIf
Return .T.

// ==================================================================
// Lê “flag” de ordem: existe qualquer ZP8_ORDEM > 0 ? (ignora FILIAL)
Static Function _HasOrderFlag(cProj,cA1,cLoja)
   Local cSql  := ""
   Local cAl   := ""
   Local lRes  := .F.

   cSql  := "SELECT TOP 1 1 AS FLAG FROM " + RetSqlName("ZP8") + " WITH (NOLOCK) "
   cSql += "WHERE D_E_L_E_T_ IN ('',' ') "
   cSql += "  AND ZP8_CODPRO = '" + AllTrim(cProj) + "' "
   cSql += "  AND ZP8_A1COD  = '" + AllTrim(cA1)   + "' "
   cSql += "  AND ZP8_A1LOJA = '" + AllTrim(cLoja) + "' "
   cSql += "  AND ISNULL(ZP8_ORDEM,0) > 0 "

   cAl := MpSysOpenQuery(cSql)
   If !Empty(cAl) .and. Select(cAl)>0 .and. (cAl)->(Used())
      lRes := !( (cAl)->(EoF()) )
      (cAl)->(DbCloseArea())
   EndIf
Return lRes

// ==================================================================
// Aplica ordem para TODAS as linhas do projeto (ZP8_ORDEM = 1/0) — ignora FILIAL
Static Function _ApplyOrderFlagToLinks(cProj,cA1,cLoja,lFlag)
   Local nVal := IIf(lFlag, 1, 0)

   DbSelectArea("ZP8")
   If ZP8->(Select())==0
      ZP8->(dbUseArea(.T.,, "ZP8", "ZP8", .T., .F.))
   EndIf

   ZP8->(DbGoTop())
   While !ZP8->(EoF())
      If ZP8->ZP8_CODPRO==cProj .and. ;
         ZP8->ZP8_A1COD==cA1 .and. ZP8->ZP8_A1LOJA==cLoja .and. ZP8->(Deleted())==.F.
         If RecLock("ZP8", .F.)
            If ZP8->(FieldPos("ZP8_ORDEM"))>0 ; ZP8->ZP8_ORDEM := nVal ; EndIf
            MsUnlock()
         EndIf
      EndIf
      ZP8->(DbSkip())
   EndDo
Return

// ==================================================================
Static Function _SplitCodEnt(cCodEnt)
   Local c := AllTrim(cCodEnt), n := At(" ", c)
   Local cA1 := c, cLoja := ""
   If n>0 ; cA1 := SubStr(c,1,n-1) ; cLoja := AllTrim(SubStr(c,n+1)) ; EndIf
Return {cA1,cLoja}

// ==================================================================
// UPSERT que ignora FILIAL ao localizar registro (evita duplicação)
Static Function _ZP8_Upsert(cProj,cCodEnt,cCont,nGrupo,nOrdem,cNome,cMail)
   Local cFil  := IIf(Empty(xFilial("ZP8")), FWxFilial("ZP8"), xFilial("ZP8"))
   Local aSL   := _SplitCodEnt(cCodEnt)
   Local cA1   := aSL[1]
   Local cLoja := aSL[2]
   Local lOk   := .T.

   BeginTran()
   DbSelectArea("ZP8")
   If ZP8->(Select())==0
      ZP8->(dbUseArea(.T.,, "ZP8", "ZP8", .T., .F.))
   EndIf

   ZP8->(DbGoTop())
   While !ZP8->(EoF()) .and. ;
         !( ZP8->ZP8_CODPRO==cProj .and. ;
            ZP8->ZP8_A1COD==cA1 .and. ;
            ZP8->ZP8_A1LOJA==cLoja .and. ;
            ZP8->ZP8_CONTID==cCont )
      ZP8->(DbSkip())
   EndDo

   If ZP8->(EoF())
      lOk := RecLock("ZP8", .T.)
      If lOk
         If ZP8->(FieldPos("ZP8_FILIAL"))>0 ; ZP8->ZP8_FILIAL := cFil ; EndIf
         ZP8->ZP8_CODPRO := cProj
         ZP8->ZP8_A1COD  := cA1
         ZP8->ZP8_A1LOJA := cLoja
         ZP8->ZP8_CONTID := cCont
      EndIf
   Else
      lOk := RecLock("ZP8", .F.)
   EndIf

   If lOk
      If ZP8->(FieldPos("ZP8_GRUPO"))>0 ; ZP8->ZP8_GRUPO := _ToNum(nGrupo) ; EndIf
      If nOrdem >= 0 .and. ZP8->(FieldPos("ZP8_ORDEM"))>0 ; ZP8->ZP8_ORDEM := _ToNum(nOrdem) ; EndIf
      If ZP8->(FieldPos("ZP8_NOME")) >0 ; ZP8->ZP8_NOME  := cNome ; EndIf
      If ZP8->(FieldPos("ZP8_EMAIL"))>0 ; ZP8->ZP8_EMAIL := cMail ; EndIf
      MsUnlock()
   EndIf

   If lOk ; EndTran() ; Else ; EndTran(.F.) ; EndIf
Return lOk

// ==================================================================
Static Function _ZP8_Delete(cProj,cCodEnt,cCont)
   Local aSL   := _SplitCodEnt(cCodEnt)
   Local cA1   := aSL[1]
   Local cLoja := aSL[2]

   DbSelectArea("ZP8")
   If ZP8->(Select())==0
      ZP8->(dbUseArea(.T.,, "ZP8", "ZP8", .T., .F.))
   EndIf

   ZP8->(DbGoTop())
   While !ZP8->(EoF()) .and. ;
         !( ZP8->ZP8_CODPRO==cProj .and. ;
            ZP8->ZP8_A1COD==cA1 .and. ;
            ZP8->ZP8_A1LOJA==cLoja .and. ;
            ZP8->ZP8_CONTID==cCont )
      ZP8->(DbSkip())
   EndDo

   If !ZP8->(EoF())
      If RecLock("ZP8", .F.)
         MsDelete()
         MsUnlock()
      EndIf
   EndIf
Return .T.

// ==================================================================
Static Function _ToNum(uVal)
   Local c
   If ValType(uVal) == "N" ; Return uVal ; EndIf
   c := AllTrim(cValToChar(uVal))
   If Empty(c) ; Return 0 ; EndIf
   Return Val(c)
Return 0
