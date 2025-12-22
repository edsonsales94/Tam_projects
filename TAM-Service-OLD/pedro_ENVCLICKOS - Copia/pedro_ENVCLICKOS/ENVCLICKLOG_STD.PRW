// ============================================================================
//  ENVCLICKLOG_STD.PRW — Tela de LOG Clicksign seguindo padrões do ITVSA010
//  Etapa 1: SOMENTE LAYOUT (sem integrações / sem leitura-gravação)
//  Autor: Assistente do Pedro (Ceriazera squad)
//  Padrões copiados do ITVSA010: TDialog + FWLayer + TFolder + TButton + TSay
// ============================================================================

#Include "PROTHEUS.ch"

/*/{Protheus.doc} ENVCLICKLOGSTD
    Tela de LOG de envios (Clicksign) — somente layout.
    Para executar: U_ENVCLICKLOGSTD()
/*/

User Function ENVCLICKLOGSTD()
    // ===== Variáveis de objetos/controles =====
    Private oDlgPulo
    Private oFWLayer
    Private oPanHeader
    Private oPanSair
    Private oPanGrid
    Private oPanRoda
    Private oTFolder
    Private oBtnSair
    Private aTFolder := { 'Parâmetros', 'Envios' }

    // ===== Cabeçalho =====
    Private oSayModulo, cSayModulo := 'CLK'
    Private oSayTitulo, cSayTitulo := 'KODIGOS SISTEMAS'
    Private oSaySubTit, cSaySubTit := 'Log de Envio de Agendas — Clicksign (Layout)'

    // ===== Janela =====
    Private aSize    := MsAdvSize(.F.)
    Private nJanLarg := aSize[5]
    Private nJanAltu := aSize[6]

    // ===== Fontes =====
    Private cFontUti  := "Tahoma"
    Private oFontMod  := TFont():New(cFontUti, , -38)
    Private oFontSub  := TFont():New(cFontUti, , -20)
    Private oFontSubN := TFont():New(cFontUti, , -20, , .T.)
    Private oFontBtn  := TFont():New(cFontUti, , -14)
    Private oFontSay  := TFont():New(cFontUti, , -12)

    // ===== Dados de tela (filtros) =====
    Private dIni      := Date() - 15
    Private dFim      := Date()
    Private cTec      := Space(10)
    Private cProj     := Space(20)
    Private cContato  := Space(40)
    Private cStatus   := "Todos"
    Private aStatus   := {"Todos","Enviado","Pendente","Erro","Cancelado"}
    Private cBusca    := Space(60)

    // ===== Janela principal (mesma abordagem do ITVSA010) =====
    oDlgPulo := TDialog():New(0, 0, nJanAltu, nJanLarg, 'Log de Envio — Clicksign', , , , , CLR_BLACK, RGB(250, 250, 250), , , .T.)

    // ===== FW Layer =====
    oFWLayer := FwLayer():New()
    oFWLayer:Init(oDlgPulo,.F.)

    // Linhas
    oFWLayer:AddLine("TIT", 10, .F.)
    oFWLayer:AddLine("COR", 70, .F.)
    oFWLayer:AddLine("ROD", 20, .F.)

    // Colunas
    oFWLayer:AddCollumn("HEADERTEXT",  050, .T., "TIT")
    oFWLayer:AddCollumn("BLANKBTN",    040, .T., "TIT")
    oFWLayer:AddCollumn("BTNSAIR",     010, .T., "TIT")
    oFWLayer:AddCollumn("COLGRID",     100, .T., "COR")
    oFWLayer:AddCollumn("RODGRID",     100, .T., "ROD")

    // Painéis
    oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
    oPanSair   := oFWLayer:GetColPanel("BTNSAIR"   , "TIT")
    oPanGrid   := oFWLayer:GetColPanel("COLGRID"   , "COR")
    oPanRoda   := oFWLayer:GetColPanel("RODGRID"   , "ROD")

    // ===== Cabeçalho (mesma sintaxe do ITVSA010 com TSay) =====
    oSayModulo := TSay():New(004, 003, {|| cSayModulo}, oPanHeader, "", oFontMod, , , , .T., ;
        RGB(149, 179, 215), , 200, 30, , , , , , .F., , )
    oSayTitulo := TSay():New(004, 045, {|| cSayTitulo}, oPanHeader, "", oFontSub, , , , .T., ;
        RGB(031, 073, 125), , 300, 30, , , , , , .F., , )
    oSaySubTit := TSay():New(014, 045, {|| cSaySubTit}, oPanHeader, "", oFontSubN, , , , .T., ;
        RGB(031, 073, 125), , 400, 30, , , , , , .F., , )

    // ===== Botões (TButton como no ITVSA010) =====
    oBtnSair := TButton():New(006, 001, "Fechar", oPanSair, {|| oDlgPulo:End()}, 050, 018, , oFontBtn, , .T., , , , , , )

    // ===== Folder =====
    oTFolder := TFolder():New( 001,001,aTFolder,,oPanGrid,,,,.T.,,nJanLarg/2-001,nJanAltu/2-010 )
        // Largura e altura máximas dentro do folder (mesma lógica do ITVSA010)
        Private nLargMax := nJanLarg/2-012
        Private nAltuMax := nJanAltu/2-100

        // ----- Folder 1: Parâmetros -----
        @ 012,012 SAY "Período:"                           SIZE 060,010 OF oTFolder:aDialogs[1] PIXEL
        @ 010,070 DCTOGET dIni PICTURE "@D"                SIZE 060,012 OF oTFolder:aDialogs[1] PIXEL
        @ 010,135 SAY "até"                                SIZE 020,012 OF oTFolder:aDialogs[1] PIXEL CENTER
        @ 010,160 DCTOGET dFim PICTURE "@D"                SIZE 060,012 OF oTFolder:aDialogs[1] PIXEL

        @ 010,240 SAY "Técnico:"                           SIZE 050,012 OF oTFolder:aDialogs[1] PIXEL RIGHT
        @ 010,292 MSGET    cTec  PICTURE "@!"              SIZE 080,012 OF oTFolder:aDialogs[1] PIXEL

        @ 010,380 SAY "Projeto:"                           SIZE 050,012 OF oTFolder:aDialogs[1] PIXEL RIGHT
        @ 010,432 MSGET    cProj PICTURE "@!"              SIZE 120,012 OF oTFolder:aDialogs[1] PIXEL

        @ 010,560 SAY "Contato:"                           SIZE 050,012 OF oTFolder:aDialogs[1] PIXEL RIGHT
        @ 010,612 MSGET    cContato PICTURE "@!"           SIZE 150,012 OF oTFolder:aDialogs[1] PIXEL

        @ 026,012 SAY "Status:"                            SIZE 050,012 OF oTFolder:aDialogs[1] PIXEL
        @ 024,062 COMBOBOX cStatus ITEMS aStatus           SIZE 120,012 OF oTFolder:aDialogs[1] PIXEL

        @ 042,012 SAY "Busca livre:"                       SIZE 070,012 OF oTFolder:aDialogs[1] PIXEL
        @ 040,082 MSGET cBusca PICTURE "@!"                SIZE 400,012 OF oTFolder:aDialogs[1] PIXEL

        @ 040,488 BUTTON PROMPT "Atualizar" SIZE 080,016 OF oTFolder:aDialogs[1] PIXEL ACTION ( FWAlert("Atualizar (layout)") )
        @ 040,572 BUTTON PROMPT "Limpar"    SIZE 060,016 OF oTFolder:aDialogs[1] PIXEL ACTION ( FWAlert("Limpar (layout)") )

        // ----- Folder 2: Envios (apenas placeholder visual por enquanto) -----
        @ 012,012 SAY "⟶ GRADE (TCBrowse) virá aqui na Etapa 2 — colunas: Data, Hora, Envelope, Documento, Projeto, Técnico, Contato(ID), Qtde OS, Situação, Mensagem." ;
            SIZE 900,012 OF oTFolder:aDialogs[2] PIXEL

    // ===== Rodapé =====
    @ 004,004 SAY "Dica: clique direito abrirá menu de ações; duplo clique abrirá os detalhes do envelope (na próxima etapa)." OF oPanRoda SIZE 900,012 PIXEL

    ACTIVATE MSDIALOG oDlgPulo CENTERED

Return
