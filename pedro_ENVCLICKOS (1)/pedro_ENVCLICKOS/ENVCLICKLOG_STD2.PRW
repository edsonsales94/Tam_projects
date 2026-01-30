// ============================================================================
//  ENVCLICKLOG_STD2.PRW — Tela de LOG Clicksign seguindo padrões do ITVSA010
//  Etapa 1: SOMENTE LAYOUT (sem integrações / sem leitura/gravação)
//  Autor: Assistente do Pedro (Ceriazera squad)
//  Observação: evita DCTOGET/COMBOBOX. Usa TDialog, FWLayer, TSay, TButton, TFolder, TGet():New
// ============================================================================

#Include "PROTHEUS.ch"

/*/{Protheus.doc} ENVCLICKLOGSTD2
    Tela de LOG de envios (Clicksign) — somente layout.
    Para executar: U_ENVCLICKLOGSTD2()
/*/

User Function ENVCLICKLOGSTD2()
    // ===== Variáveis de objetos/controles ===== (todas declaradas no topo)
    Local oDlgPulo
    Local oFwLayer
    Local oPanHeader
    Local oPanSair
    Local oPanGrid
    Local oPanRoda
    Local oTFolder
    Local oBtnSair
    Local oGrpFiltros

    // ===== Abas =====
    Local aTFolder := { 'Parâmetros', 'Envios' }

    // ===== Cabeçalho =====
    Local oSayModulo, cSayModulo := 'CLK'
    Local oSayTitulo, cSayTitulo := 'KODIGOS SISTEMAS'
    Local oSaySubTit, cSaySubTit := 'Log de Envio de Agendas — Clicksign (Layout)'

    // ===== Janela =====
    Local aSize    := MsAdvSize(.F.)
    Local nJanLarg := aSize[5]
    Local nJanAltu := aSize[6]

    // ===== Fontes =====
    Local cFontUti  := "Tahoma"
    Local oFontMod  := TFont():New(cFontUti, , -38)
    Local oFontSub  := TFont():New(cFontUti, , -20)
    Local oFontSubN := TFont():New(cFontUti, , -20, , .T.)
    Local oFontBtn  := TFont():New(cFontUti, , -14)
    Local oFontSay  := TFont():New(cFontUti, , -12)

    // ===== Dados de tela (filtros) =====
    Local dDtIni    := Date() - 15
    Local dDtFim    := Date()
    Local cTecnico  := Space(10)
    Local cProjeto  := Space(20)
    Local cContato  := Space(40)
    Local cStatus   := "Todos"        // manteremos como string simples por enquanto
    Local cBusca    := Space(60)

    // ===== Janela principal (mesmo approach do ITVSA010) =====
    oDlgPulo := TDialog():New(0, 0, nJanAltu, nJanLarg, 'Log de Envio — Clicksign', , , , , CLR_BLACK, RGB(250, 250, 250), , , .T.)

    // ===== FW Layer =====
    oFwLayer := FwLayer():New()
    oFwLayer:Init(oDlgPulo,.F.)

    // Linhas
    oFwLayer:AddLine("TIT", 10, .F.)
    oFwLayer:AddLine("COR", 70, .F.)
    oFwLayer:AddLine("ROD", 20, .F.)

    // Colunas
    oFwLayer:AddCollumn("HEADERTEXT",  050, .T., "TIT")
    oFwLayer:AddCollumn("BLANKBTN",    040, .T., "TIT")
    oFwLayer:AddCollumn("BTNSAIR",     010, .T., "TIT")
    oFwLayer:AddCollumn("COLGRID",     100, .T., "COR")
    oFwLayer:AddCollumn("RODGRID",     100, .T., "ROD")

    // Painéis
    oPanHeader := oFwLayer:GetColPanel("HEADERTEXT", "TIT")
    oPanSair   := oFwLayer:GetColPanel("BTNSAIR"   , "TIT")
    oPanGrid   := oFwLayer:GetColPanel("COLGRID"   , "COR")
    oPanRoda   := oFwLayer:GetColPanel("RODGRID"   , "ROD")

    // ===== Cabeçalho (TSay) =====
    oSayModulo := TSay():New(004, 003, {|| cSayModulo}, oPanHeader, "", oFontMod  , , , , .T., RGB(149,179,215), , 200, 30, , , , , , .F., , )
    oSayTitulo := TSay():New(004, 045, {|| cSayTitulo}, oPanHeader, "", oFontSub  , , , , .T., RGB(031,073,125), , 300, 30, , , , , , .F., , )
    oSaySubTit := TSay():New(014, 045, {|| cSaySubTit}, oPanHeader, "", oFontSubN , , , , .T., RGB(031,073,125), , 400, 30, , , , , , .F., , )

    // ===== Botões (TButton como no ITVSA010) =====
    oBtnSair := TButton():New(006, 001, "Fechar", oPanSair, {|| oDlgPulo:End()}, 050, 018, , oFontBtn, , .T., , , , , , )

    // ===== Folder =====
    oTFolder := TFolder():New( 001,001,aTFolder,,oPanGrid,,,,.T.,,nJanLarg/2-001,nJanAltu/2-010 )

    // ===== Grupo de filtros (lado direito do Folder 1) =====
    Local nLargMax := nJanLarg/2-012
    Local nAltuMax := nJanAltu/2-100

    oGrpFiltros := TGroup():New(02,nLargMax*0.80+10 ,nAltuMax,nLargMax,;
        'Defina o período e filtros. Campos em branco consideram todos.',;
        oTFolder:aDialogs[1],,,.T.)

    // --- Data inicial ---
    oGet3 := TGet():New( 15, nLargMax*0.80+20, { | u | If( PCount() == 0, dDtIni, dDtIni := u ) }, oGrpFiltros, ;
        060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtIni",,,,,,,"Data de",1 )
    // --- Data final ---
    oGet4 := TGet():New( 40, nLargMax*0.80+20, { | u | If( PCount() == 0, dDtFim, dDtFim := u ) }, oGrpFiltros, ;
        060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtFim",,,,,,,"Data até",1 )

    // --- Técnico ---
    oGetTec := TGet():New( 65, nLargMax*0.80+20, { | u | If( PCount() == 0, cTecnico, cTecnico := u ) }, oGrpFiltros, ;
        120, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cTecnico",,,,,,,"Técnico:",1 )

    // --- Projeto ---
    oGetPrj := TGet():New( 90, nLargMax*0.80+20, { | u | If( PCount() == 0, cProjeto, cProjeto := u ) }, oGrpFiltros, ;
        120, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cProjeto",,,,,,,"Projeto:",1 )

    // --- Contato ---
    oGetCtt := TGet():New(115, nLargMax*0.80+20, { | u | If( PCount() == 0, cContato, cContato := u ) }, oGrpFiltros, ;
        150, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cContato",,,,,,,"Contato:",1 )

    // --- Status (string simples por enquanto) ---
    oGetSts := TGet():New(140, nLargMax*0.80+20, { | u | If( PCount() == 0, cStatus, cStatus := u ) }, oGrpFiltros, ;
        120, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cStatus",,,,,,,"Status:",1 )

    // --- Busca livre ---
    oGetBus := TGet():New(165, nLargMax*0.80+20, { | u | If( PCount() == 0, cBusca, cBusca := u ) }, oGrpFiltros, ;
        200, 010, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cBusca",,,,,,,"Busca:",1 )

    // Botões de ação (como no ITVSA010, usando TButton)
    oBtnAtual := TButton():New(190, nLargMax*0.80+20, "Atualizar", oGrpFiltros, {|| FWAlert("Atualizar (layout)")}, 060, 018, , oFontBtn, , .T., , , , , , )
    oBtnLimpa := TButton():New(190, nLargMax*0.80+90, "Limpar"   , oGrpFiltros, {|| FWAlert("Limpar (layout)")}   , 060, 018, , oFontBtn, , .T., , , , , , )

    // ===== Folder 2: Envios (placeholder visual por enquanto) =====
    oSayGrid := TSay():New(012, 012, {|| "⟶ GRADE (TCBrowse) virá na Etapa 2 — colunas: Data, Hora, Envelope, Documento, Projeto, Técnico, Contato(ID), Qtde OS, Situação, Mensagem."}, oTFolder:aDialogs[2], "", oFontSay, , , , .T., CLR_BLACK, CLR_WHITE, 900, 12)

    // ===== Rodapé =====
    oSayRod := TSay():New(004, 004, {|| "Dica: clique direito abrirá menu de ações; duplo clique abrirá os detalhes do envelope (na próxima etapa)."}, oPanRoda, "", oFontSay, , , , .T., CLR_BLACK, CLR_WHITE, 900, 12)

    ACTIVATE MSDIALOG oDlgPulo CENTERED

Return
