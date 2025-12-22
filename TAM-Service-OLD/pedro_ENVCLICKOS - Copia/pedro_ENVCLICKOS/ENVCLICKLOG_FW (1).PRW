//Bibliotecas
#Include "PROTHEUS.ch"
#Include "TOPCONN.CH"

User Function ENVCLICKLOG()
   Local oDlgPulo, oFwLayer, oPanHeader, oPanSair, oPanGrid, oPanRoda
   Local oTFolder, oBtnSair, oGrpFiltros, oBrowseEnv
   Local aTFolder := { 'Envios', 'Aglutinacao' }

   // Cabecalho (ASCII)
   Local cSayModulo := 'ITV'
   Local cSayTitulo := 'INTEGRATVS SOLUCOES TECNOLOGICAS'
   Local cSaySubTit := 'Log de Envio de Agendas - Clicksign'

   // Tamanho janela
   Local aSize    := MsAdvSize(.F.)
   Local nJanLarg := aSize[5]
   Local nJanAltu := aSize[6]

   // Fontes
   Local cFontUti  := 'Tahoma'
   Local oFontMod  := TFont():New(cFontUti, , -38)
   Local oFontSub  := TFont():New(cFontUti, , -20)
   Local oFontSubN := TFont():New(cFontUti, , -20, , .T.)
   Local oFontBtn  := TFont():New(cFontUti, , -14)
   Local oFontSay  := TFont():New(cFontUti, , -12)

   // Filtros (variaveis de tela)
   Local dDtIni    := Date() - 15
   Local dDtFim    := Date()
   Local cTecnico  := Space(10)
   Local cProjeto  := Space(20)
   Local cContato  := Space(40)
   Local cStatus   := 'TODOS'

   // Dados mock para lista
   // Dados do grid (inicia com UMA linha mock vazia para evitar out-of-bounds)
   Local aEnv := { { Ctod(""), "", "", "", "", "", "" } }

   // Dialog principal
   oDlgPulo := TDialog():New(0, 0, nJanAltu, nJanLarg, 'Log de Envio - Clicksign', , , , , CLR_BLACK, RGB(250,250,250), , , .T.)

   // FWLayer
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

   oPanHeader := oFwLayer:GetColPanel('HEADERTEXT','TIT')
   oPanSair   := oFwLayer:GetColPanel('BTNSAIR'  ,'TIT')
   oPanGrid   := oFwLayer:GetColPanel('COLGRID'  ,'COR')
   oPanRoda   := oFwLayer:GetColPanel('RODGRID'  ,'ROD')

   // Header
   TSay():New(004,003,{|| cSayModulo},oPanHeader,'',oFontMod , , , , .T., RGB(149,179,215), ,200,30, , , , , , .F., , )
   TSay():New(004,045,{|| cSayTitulo},oPanHeader,'',oFontSub , , , , .T., RGB(031,073,125), ,300,30, , , , , , .F., , )
   TSay():New(014,045,{|| cSaySubTit},oPanHeader,'',oFontSubN, , , , .T., RGB(031,073,125), ,400,30, , , , , , .F., , )

   // Botao Fechar
   oBtnSair := TButton():New(006,001,'Fechar',oPanSair,{|| oDlgPulo:End()},060,018, ,oFontBtn, , .T., , , , , , )

   // Folder (Envios | Aglutinacao)
   oTFolder := TFolder():New(001,001,aTFolder,,oPanGrid,,,,.T.,,nJanLarg/2-001,nJanAltu/2-010)

   // Medidas internas
   Local nLargMax := nJanLarg/2-012
   Local nAltuMax := nJanAltu/2-100

   // ===== ABA 1: Envios =====
   // Grid a esquerda
   oBrowseEnv := TCBrowse():New(02,05,nLargMax*0.80,nAltuMax,,,, oTFolder:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

   oBrowseEnv:AddColumn( TCColumn():New('Data'       , {|| aEnv[oBrowseEnv:nAt,01]}, '@D') )
   oBrowseEnv:AddColumn( TCColumn():New('Envelope'   , {|| aEnv[oBrowseEnv:nAt,02]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Documento'  , {|| aEnv[oBrowseEnv:nAt,03]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Projeto'    , {|| aEnv[oBrowseEnv:nAt,04]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Tecnico'    , {|| aEnv[oBrowseEnv:nAt,05]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Contato(ID)', {|| aEnv[oBrowseEnv:nAt,06]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Situacao'   , {|| aEnv[oBrowseEnv:nAt,07]}, '@!') )
   oBrowseEnv:SetArray(aEnv)
   oBrowseEnv:Refresh()

   // Filtros a direita Ã¢â‚¬â€� todos com a MESMA largura (120,010), sem "Busca"
   TGroup():New(02,nLargMax*0.80+10 ,nAltuMax,nLargMax,'Defina o periodo e filtros. Campos em branco consideram todos.',oTFolder:aDialogs[1],,,.T.)

   TGet():New( 15, nLargMax*0.80+20, { |u| If(PCount()==0, dDtIni  , dDtIni   := u) }, oTFolder:aDialogs[1], 120,010, '@D',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'dDtIni'  ,,,,,,,'Data de',1)
   TGet():New( 40, nLargMax*0.80+20, { |u| If(PCount()==0, dDtFim  , dDtFim   := u) }, oTFolder:aDialogs[1], 120,010, '@D',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'dDtFim'  ,,,,,,,'Data ate',1)
   TGet():New( 65, nLargMax*0.80+20, { |u| If(PCount()==0, cTecnico, cTecnico := u) }, oTFolder:aDialogs[1], 120,010, '@!',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cTecnico',,,,,,,'Tecnico:',1)
   TGet():New( 90, nLargMax*0.80+20, { |u| If(PCount()==0, cProjeto, cProjeto := u) }, oTFolder:aDialogs[1], 120,010, '@!',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cProjeto',,,,,,,'Projeto:',1)
   TGet():New(115, nLargMax*0.80+20, { |u| If(PCount()==0, cContato, cContato := u) }, oTFolder:aDialogs[1], 120,010, '@!',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cContato',,,,,,,'Contato:',1)
   TGet():New(140, nLargMax*0.80+20, { |u| If(PCount()==0, cStatus , cStatus  := u) }, oTFolder:aDialogs[1], 120,010, '@!',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cStatus' ,,,,,,,'Status:',1)

   // Botoes subiram (onde ficava "Busca")
   TButton():New(165, nLargMax*0.80+20 , 'Atualizar', oTFolder:aDialogs[1], {|| aEnv := ENV_ZP7Busca(dDtIni, dDtFim, cTecnico, cProjeto, cContato, cStatus), ;
          If(Len(aEnv)==0, aEnv := { { Ctod(\"\"), \"\", \"\", \"\", \"\", \"\", \"\" } }, NIL), ;
          oBrowseEnv:SetArray(aEnv), oBrowseEnv:Refresh()}, 080,018, , oFontBtn, , .T., , , , , , )
   TButton():New(180, nLargMax*0.80+20, 'Limpar'   , oTFolder:aDialogs[1], {|| dDtIni := Date()-15, dDtFim := Date(), ;
          cTecnico := Space(10), cProjeto := Space(20), cContato := Space(40), cStatus := 'TODOS', ;
          aEnv := ENV_ZP7Busca(dDtIni, dDtFim, cTecnico, cProjeto, cContato, cStatus), ;
          If(Len(aEnv)==0, aEnv := { { Ctod(\"\"), \"\", \"\", \"\", \"\", \"\", \"\" } }, NIL), ;
          oBrowseEnv:SetArray(aEnv), oBrowseEnv:Refresh()}   , 080,018, , oFontBtn, , .T., , , , , , )

   // ===== ABA 2: Aglutinacao (placeholder) =====
   TSay():New(012,012,{|| 'Tela de Aglutinacao de OS e Envios customizados (proxima etapa).'}, oTFolder:aDialogs[2], '', oFontSay, , , , .T., CLR_BLACK, CLR_WHITE, 900, 12)

   // Rodape
   TSay():New(004,004,{|| 'Dica: clique direito abrira menu de acoes; duplo clique abrira os detalhes do envelope (na proxima etapa).'}, oPanRoda, '', oFontSay, , , , .T., CLR_BLACK, CLR_WHITE, 900, 12)

   ACTIVATE MSDIALOG oDlgPulo CENTERED
Return

/*/============================================================================
  ENV_ZP7Busca -> { Data, Envelope, Documento, Projeto, Tecnico, Contato, Status }
============================================================================/*/
static Function ENV_ZP7Busca(dDtIni, dDtFim, cTecnico, cProjeto, cContato, cStatus)
   Local aRet     := {}
   Local cSQL     := ""
   Local cTabela  := RetSqlName("ZP7")
   Local cAl      := ""
   Local cTec     := AllTrim(cTecnico)
   Local cPrj     := AllTrim(cProjeto)
   Local cCnt     := AllTrim(cContato)
   Local cSta     := AllTrim(cStatus)
   Local cDtDe    := DTOS(dDtIni)
   Local cDtAte   := DTOS(dDtFim)
   Local dTmp

   If Empty(dDtIni) .Or. Empty(dDtFim)
      Return aRet
   EndIf
   If dDtIni > dDtFim
      dTmp := dDtIni ; dDtIni := dDtFim ; dDtFim := dTmp
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
   conout(cSQL)
   cAl := MpSysOpenQuery(cSQL)
   If Empty(cAl)
      Return aRet
   EndIf

   (cAl)->(DbGoTop())
   While ! ( (cAl)->(EoF()) )
      AAdd(aRet, { ;
         _CtoDate((cAl)->ZP7_DTENV), ;
         (cAl)->ZP7_ENV, ;
         (cAl)->ZP7_DOC, ;
         (cAl)->ZP7_PROJ, ;
         (cAl)->ZP7_TEC, ;
         (cAl)->ZP7_CONTID, ;
         (cAl)->ZP7_STATUS ;
      })
      (cAl)->(DbSkip())
   EndDo
   (cAl)->(DbCloseArea())

Return aRet

/*/============================================================================
  Helpers
============================================================================/*/
Static Function _SqlSafe(cTxt)
   Local cOut := AllTrim(cTxt)
   cOut := StrTran(cOut, "'", "''")
Return cOut

Static Function _CtoDate(uVal)
   Local dRet := Ctod("")
   If ValType(uVal) == "D"
      dRet := uVal
   ElseIf ValType(uVal) == "C" .And. Len(uVal) == 8
      dRet := StoD(uVal)
   EndIf
Return dRet
