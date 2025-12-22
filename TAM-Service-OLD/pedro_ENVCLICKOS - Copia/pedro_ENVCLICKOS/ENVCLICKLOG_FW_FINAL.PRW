//Bibliotecas
#Include "PROTHEUS.ch"
#Include "TOPCONN.CH"

/*/============================================================================
  Programa : ENVCLICKLOG
  Objetivo : Tela de Log de Envio (Clicksign) lendo ZP7 e somando OS na SZ1
  Notas    : - Datas (De/Até) obrigatórias (já vêm preenchidas).
             - Filtros opcionais: Técnico, Projeto, Contato, Status ("TODOS" ignora).
             - Consulta via MpSysOpenQuery(cSql).
             - Grid inicia com UMA linha mock vazia p/ evitar "array out of bounds".
             - Colunas visíveis: Data | Projeto | Tecnico | Contato(ID) | Qtde OS | Situacao
             - 7ª coluna oculta no array: Envelope (para uso no duplo clique futuramente).
             - TODAS as LOCAL declaradas no topo de cada função.
============================================================================/*/
User Function ENVCLICKLOG()
   // ===== DECLARAÇÕES (topo) =====
   Local oDlgPulo, oFwLayer, oPanHeader, oPanSair, oPanGrid, oPanRoda
   Local oTFolder, oBtnSair, oBtnCanc, oBrowseEnv
   Local aTFolder
   Local cSayModulo, cSayTitulo, cSaySubTit
   Local aSize, nJanLarg, nJanAltu
   Local cFontUti, oFontMod, oFontSub, oFontSubN, oFontBtn, oFontSay
   Local dDtIni, dDtFim, cTecnico, cProjeto, cContato, cStatus
   Local aEnv
   Local nLargMax, nAltuMax

   // ===== Valores =====
   aTFolder   := { 'Envios', 'Aglutinacao' }
   cSayModulo := 'ITV'
   cSayTitulo := 'INTEGRATVS SOLUCOES TECNOLOGICAS'
   cSaySubTit := 'Log de Envio de Agendas - Clicksign'

   aSize      := MsAdvSize(.F.)
   nJanLarg   := aSize[5]
   nJanAltu   := aSize[6]

   cFontUti   := 'Tahoma'
   oFontMod   := TFont():New(cFontUti, , -38)
   oFontSub   := TFont():New(cFontUti, , -20)
   oFontSubN  := TFont():New(cFontUti, , -20, , .T.)
   oFontBtn   := TFont():New(cFontUti, , -14)
   oFontSay   := TFont():New(cFontUti, , -12)

   dDtIni     := Date() - 15
   dDtFim     := Date()
   cTecnico   := Space(10)
   cProjeto   := Space(20)
   cContato   := Space(40)
   cStatus    := 'TODOS'

   // *** CRÍTICO: inicia com 1 linha MOCK VAZIA (6 visíveis + 1 oculta) ***
   aEnv       := { { Ctod(""), "", "", "", 0, "", "" } }

   nLargMax   := 0
   nAltuMax   := 0

   // ===== DIALOG =====
   oDlgPulo := TDialog():New(0, 0, nJanAltu, nJanLarg, 'Log de Envio - Clicksign', , , , , CLR_BLACK, RGB(250,250,250), , , .T.)

   // ===== LAYOUT =====
   oFwLayer := FwLayer():New()
   oFwLayer:Init(oDlgPulo,.F.)
   oFwLayer:AddLine('TIT', 10, .F.)
   oFwLayer:AddLine('COR', 70, .F.)
   oFwLayer:AddLine('ROD', 20, .F.)
   oFwLayer:AddCollumn('HEADERTEXT',  050, .T., 'TIT')
   oFwLayer:AddCollumn('BLANKBTN',    040, .T., 'TIT')
   oFwLayer:AddCollumn('BTNSAIR',     010, .T., 'TIT')
   oFwLayer:AddCollumn('COLGRID',     100, .T., 'COR')
   oFwLayer:AddCollumn('RODGRID',     100, .T., 'ROD')

   nLargMax := nJanLarg/2-012
   nAltuMax := nJanAltu/2-100

   oPanHeader := oFwLayer:GetColPanel('HEADERTEXT','TIT')
   oPanSair   := oFwLayer:GetColPanel('BTNSAIR'  ,'TIT')
   oPanGrid   := oFwLayer:GetColPanel('COLGRID'  ,'COR')
   oPanRoda   := oFwLayer:GetColPanel('RODGRID'  ,'ROD')

   // ===== Header =====
   TSay():New(004,003,{|| cSayModulo},oPanHeader,'',oFontMod , , , , .T., RGB(149,179,215), ,200,30)
   TSay():New(004,045,{|| cSayTitulo},oPanHeader,'',oFontSub , , , , .T., RGB(031,073,125), ,300,30)
   TSay():New(014,045,{|| cSaySubTit},oPanHeader,'',oFontSubN, , , , .T., RGB(031,073,125), ,400,30)

   // ===== Botões do cabeçalho =====
   oBtnSair := TButton():New(006,001,'Fechar',oPanSair,{|| oDlgPulo:End()},060,018, ,oFontBtn, , .T.)
   // Novo botão ao lado do Fechar (somente layout)
   oBtnCanc := TButton():New(006,070,'Cancelar Envelope', oPanSair, {|| FWAlert('Cancelamento (layout)')}, 120,018, , oFontBtn, , .T.)

   // ===== Folder =====
   oTFolder := TFolder():New(001,001,aTFolder,,oPanGrid,,,,.T.,,nJanLarg/2-001,nJanAltu/2-010)

   // ===== ABA 1: Envios =====
   // Grid à esquerda (MEDIDAS ORIGINAIS)
   oBrowseEnv := TCBrowse():New(25,05, nLargMax*0.80, nAltuMax, , , , oTFolder:aDialogs[1], , , , , {||}, , , , , , .F., , .T., , .F., , , )

   // Colunas visíveis (sem Envelope/Documento)
   oBrowseEnv:AddColumn( TCColumn():New('Data'       , {|| aEnv[oBrowseEnv:nAt,01]}, '@D') )
   oBrowseEnv:AddColumn( TCColumn():New('Projeto'    , {|| aEnv[oBrowseEnv:nAt,02]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Tecnico'    , {|| aEnv[oBrowseEnv:nAt,03]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Contato(ID)', {|| aEnv[oBrowseEnv:nAt,04]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Qtde OS'    , {|| aEnv[oBrowseEnv:nAt,05]}, '@E 9999') )
   oBrowseEnv:AddColumn( TCColumn():New('Situacao'   , {|| aEnv[oBrowseEnv:nAt,06]}, '@!') )
   // (aEnv[*,07] = Envelope, oculto, reservado para duplo clique futuramente)

   // Vincula o array inicial (mock) e pinta
   oBrowseEnv:SetArray(aEnv)
   oBrowseEnv:Refresh()

   // Filtros à direita (MEDIDAS ORIGINAIS)
   TGroup():New(02, nLargMax*0.80+10 , nAltuMax, nLargMax, ;
                'Defina o periodo e filtros. Campos em branco consideram todos.', ;
                oTFolder:aDialogs[1], , , .T.)

   TGet():New( 15, nLargMax*0.80+20, { |u| If(PCount()==0, dDtIni  , dDtIni   := u) }, oTFolder:aDialogs[1], 120,010, '@D')
   TGet():New( 40, nLargMax*0.80+20, { |u| If(PCount()==0, dDtFim  , dDtFim   := u) }, oTFolder:aDialogs[1], 120,010, '@D')
   TGet():New( 65, nLargMax*0.80+20, { |u| If(PCount()==0, cTecnico, cTecnico := u) }, oTFolder:aDialogs[1], 120,010, '@!')
   TGet():New( 90, nLargMax*0.80+20, { |u| If(PCount()==0, cProjeto, cProjeto := u) }, oTFolder:aDialogs[1], 120,010, '@!')
   TGet():New(115, nLargMax*0.80+20, { |u| If(PCount()==0, cContato, cContato := u) }, oTFolder:aDialogs[1], 120,010, '@!')
   TGet():New(140, nLargMax*0.80+20, { |u| If(PCount()==0, cStatus , cStatus  := u) }, oTFolder:aDialogs[1], 120,010, '@!')

   // Botões (mantidas as posições originais)
   TButton():New(165, nLargMax*0.80+20 , 'Atualizar', oTFolder:aDialogs[1], ;
      {|| aEnv := ENV_ZP7Busca(dDtIni, dDtFim, cTecnico, cProjeto, cContato, cStatus), ;
          If(Len(aEnv)==0, aEnv := { { Ctod(""), "", "", "", 0, "", "" } }, NIL), ;
          oBrowseEnv:SetArray(aEnv), oBrowseEnv:Refresh()}, ;
      080,018, , oFontBtn, , .T.)

   TButton():New(165, nLargMax*0.80+110, 'Limpar', oTFolder:aDialogs[1], ;
      {|| dDtIni := Date()-15, dDtFim := Date(), ;
          cTecnico := Space(10), cProjeto := Space(20), cContato := Space(40), cStatus := 'TODOS', ;
          aEnv := ENV_ZP7Busca(dDtIni, dDtFim, cTecnico, cProjeto, cContato, cStatus), ;
          If(Len(aEnv)==0, aEnv := { { Ctod(""), "", "", "", 0, "", "" } }, NIL), ;
          oBrowseEnv:SetArray(aEnv), oBrowseEnv:Refresh()}, ;
      080,018, , oFontBtn, , .T.)

   // ===== ABA 2: Aglutinacao (placeholder) =====
   TSay():New(012,012,{|| 'Tela de Aglutinacao de OS e Envios customizados (proxima etapa).'}, oTFolder:aDialogs[2], '', oFontSay, , , , .T., CLR_BLACK, CLR_WHITE, 900, 12)

   // Rodapé
   TSay():New(004,004,{|| 'Dica: clique direito abrira menu de acoes; duplo clique abrira detalhes (futuro).'}, oPanRoda, '', oFontSay, , , , .T., CLR_BLACK, CLR_WHITE, 900, 12)

   ACTIVATE MSDIALOG oDlgPulo CENTERED
Return

/*/============================================================================
  ENV_ZP7Busca -> { Data, Projeto, Tecnico, Contato, QtdeOS, Situacao, Envelope }
============================================================================/*/
User Function ENV_ZP7Busca(dDtIni, dDtFim, cTecnico, cProjeto, cContato, cStatus)
   // ===== DECLARAÇÕES (topo) =====
   Local aRet, cSQL, cTabela, cAl
   Local cTec, cPrj, cCnt, cSta
   Local cDtDe, cDtAte
   Local dData, cEnv, cProj, cTecx, cCont, cStat
   Local nQtdeOS, aOS

   // ===== Valores =====
   aRet    := {}
   cSQL    := ""
   cTabela := RetSqlName("ZP7")
   cAl     := ""
   cTec    := AllTrim(cTecnico)
   cPrj    := AllTrim(cProjeto)
   cCnt    := AllTrim(cContato)
   cSta    := AllTrim(cStatus)
   cDtDe   := DTOS(dDtIni)
   cDtAte  := DTOS(dDtFim)

   If Empty(dDtIni) .Or. Empty(dDtFim)
      Return aRet
   EndIf
   If dDtIni > dDtFim
      Local dTmp := dDtIni ; dDtIni := dDtFim ; dDtFim := dTmp
      cDtDe  := DTOS(dDtIni)
      cDtAte := DTOS(dDtFim)
   EndIf

   cSQL := ""
   cSQL += "SELECT ZP7.ZP7_DTENV, ZP7.ZP7_ENV, ZP7.ZP7_DOC, " + ;
           "       ZP7.ZP7_PROJ, ZP7.ZP7_TEC, ZP7.ZP7_CONTID, ZP7.ZP7_STATUS " + ;
           "  FROM " + cTabela + " ZP7 (NOLOCK) " + ;
           " WHERE ZP7.D_E_L_E_T_ = '' " + ;
           "   AND ZP7.ZP7_DTENV BETWEEN '" + cDtDe + "' AND '" + cDtAte + "' "

   If !Empty(cTec) ; cSQL += " AND ZP7.ZP7_TEC = '"    + _SqlSafe(cTec) + "' "  ; EndIf
   If !Empty(cPrj) ; cSQL += " AND ZP7.ZP7_PROJ = '"   + _SqlSafe(cPrj) + "' "  ; EndIf
   If !Empty(cCnt) ; cSQL += " AND ZP7.ZP7_CONTID = '" + _SqlSafe(cCnt) + "' "  ; EndIf
   If !Empty(cSta) .And. !(Upper(cSta) == "TODOS")
                    cSQL += " AND ZP7.ZP7_STATUS = '" + _SqlSafe(cSta) + "' "
   EndIf

   cSQL += " ORDER BY ZP7.ZP7_DTENV DESC, ZP7.ZP7_ENV DESC "

   cAl := MpSysOpenQuery(cSQL)
   If Empty(cAl)
      Return aRet
   EndIf

   (cAl)->(DbGoTop())
   While ! ( (cAl)->(EoF()) )
      // lê campos da ZP7
      dData := _CtoDate((cAl)->ZP7_DTENV)
      cEnv  := (cAl)->ZP7_ENV
      cProj := (cAl)->ZP7_PROJ
      cTecx := (cAl)->ZP7_TEC
      cCont := (cAl)->ZP7_CONTID
      cStat := (cAl)->ZP7_STATUS

      // Busca OS na SZ1 (preciso: Z1_ZP7ENV -> ZP7_ENV ; OS = Z1_CODIGO)
      aOS      := _BuscaOS_SZ1(cEnv)
      nQtdeOS  := Len(aOS)

      // Monta linha do grid (6 visíveis + 1 oculto)
      AAdd(aRet, { dData, cProj, cTecx, cCont, nQtdeOS, cStat, cEnv })

      (cAl)->(DbSkip())
   EndDo
   (cAl)->(DbCloseArea())

Return aRet

/*/============================================================================
  Cache e busca de OS por envelope (SZ1) — precisos, sem fallback desnecessário
============================================================================/*/
Static __aOSCache := {}  // { { cEnv, aOS }, ... }

Static Function _OSCachePut(cEnv, aOS)
   // ===== DECLARAÇÕES (topo) =====
   Local n
   n := AScan(__aOSCache, {|x| x[1] == cEnv})
   If n == 0
      AAdd(__aOSCache, { cEnv, aOS })
   Else
      __aOSCache[n][2] := aOS
   EndIf
Return

Static Function _OSCacheGet(cEnv)
   // ===== DECLARAÇÕES (topo) =====
   Local n, aRet
   n    := AScan(__aOSCache, {|x| x[1] == cEnv})
   aRet := {}
   If n > 0
      aRet := __aOSCache[n][2]
   EndIf
Return aRet

// Retorna lista de OS (Z1_CODIGO) para um envelope ZP7_ENV (via SZ1.Z1_ZP7ENV)
Static Function _BuscaOS_SZ1(cEnv)
   // ===== DECLARAÇÕES (topo) =====
   Local aOS, cTab, cSql, cAl2

   aOS  := {}
   If Empty(cEnv)
      Return aOS
   EndIf

   // cache primeiro
   aOS := _OSCacheGet(cEnv)
   If Len(aOS) > 0
      Return aOS
   EndIf

   cTab := RetSqlName("SZ1")
   cSql := "SELECT SZ1.Z1_CODIGO FROM " + cTab + " SZ1 (NOLOCK) " + ;
           " WHERE SZ1.D_E_L_E_T_ = '' AND SZ1.Z1_ZP7ENV = '" + _SqlSafe(cEnv) + "' " + ;
           " ORDER BY SZ1.Z1_CODIGO "

   cAl2 := MpSysOpenQuery(cSql)
   If !Empty(cAl2)
      (cAl2)->(DbGoTop())
      While ! ( (cAl2)->(EoF()) )
         AAdd(aOS, AllTrim((cAl2)->Z1_CODIGO))
         (cAl2)->(DbSkip())
      EndDo
      (cAl2)->(DbCloseArea())
   EndIf

   _OSCachePut(cEnv, aOS)
Return aOS

/*/============================================================================
  Helpers
============================================================================/*/
Static Function _SqlSafe(cTxt)
   // ===== DECLARAÇÕES (topo) =====
   Local cOut
   cOut := AllTrim(cTxt)
   cOut := StrTran(cOut, "'", "''")
Return cOut

Static Function _CtoDate(uVal)
   // ===== DECLARAÇÕES (topo) =====
   Local dRet
   dRet := Ctod("")
   If ValType(uVal) == "D"
      dRet := uVal
   ElseIf ValType(uVal) == "C" .And. Len(uVal) == 8
      dRet := StoD(uVal)
   EndIf
Return dRet
