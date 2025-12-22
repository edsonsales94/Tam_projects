// ============================================================================
//  ENVCLICKLOG_FW.PRW — Layout da tela de LOG (Clicksign) usando FWLayer/TFolder
//  Etapa 1: SOMENTE LAYOUT (sem integrações / sem leitura/gravação)
//  Autor: Assistente do Pedro (Ceriazera squad)
//  Observações:
//  • Estrutura inspirada no ITVSA010 (FWLayer + TFolder + TCBrowse + MenuPop).
//  • Mantém a regra do Pedro: TODAS as LOCAL no topo das funções.
// ============================================================================

#Include "Protheus.ch"
#Include "TopConn.ch"

/*
   Acesso sugerido: U_ENVCLICKLOGFW() (para não conflitar com versões anteriores)
*/

// ---------------------------------------------------------------------------
// Tela principal
// ---------------------------------------------------------------------------
User Function ENVCLICKLOGFW()
   Local oDlgPulo     := Nil
   Local oFWLayer     := Nil
   Local oPanHeader   := Nil
   Local oPanSair     := Nil
   Local oPanGrid     := Nil
   Local oPanRoda     := Nil
   Local oFontMod     := Nil
   Local oFontSub     := Nil
   Local oFontSubN    := Nil
   Local oFontBtn     := Nil
   Local oBtnSair     := Nil
   Local oSayModulo   := Nil
   Local oSayTitulo   := Nil
   Local oSaySubTit   := Nil
   Local nJanLarg     := 1200
   Local nJanAltu     := 700
   Local nLargMax     := 0
   Local nAltuMax     := 0
   Local aTFolder     := { 'Parâmetros', 'Envios' }
   Local oTFolder     := Nil

   // Filtros (apenas variáveis de tela)
   Local dIni         := Date() - 15
   Local dFim         := Date()
   Local cTec         := Space(10)
   Local cProj        := Space(20)
   Local cContato     := Space(40)
   Local cStatus      := "Todos"
   Local aStatus      := {"Todos","Enviado","Pendente","Erro","Cancelado"}
   Local cBusca       := Space(60)

   // Browse de Envios (somente layout/dummy)
   Private oBrowseEnv := Nil
   Private aBrowseEnv := {}
   Private oParamEnv  := Nil

   // Dados MOCK só para layout (remover quando ligar no ZP7)
   AAdd(aBrowseEnv, { Date(), Time(), "ENV-000123", "DOC-8899", "PRJ-001", "TEC-007", "CNT-55", 3, "Enviado", "OK", 123 })
   AAdd(aBrowseEnv, { Date(), Time(), "ENV-000124", "DOC-8901", "PRJ-002", "TEC-021", "CNT-72", 2, "Pendente", "Aguardando assinatura", 124 })

   // Diálogo principal
   DEFINE MSDIALOG oDlgPulo TITLE "Log de Envio de Agendas — Clicksign (FW)" FROM 0,0 TO nJanAltu, nJanLarg PIXEL

      // Fonts básicas
      oFontMod  := TFont():New("Segoe UI", 0, -16)
      oFontSub  := TFont():New("Segoe UI", 0, -12)
      oFontSubN := TFont():New("Segoe UI", 1, -11)
      oFontBtn  := TFont():New("Segoe UI", 1, -11)

      // Camada/Layers
      oFWLayer := FwLayer():New()
      oFWLayer:Init(oDlgPulo,.F.)

      // Linhas: título / corpo / rodapé
      oFWLayer:AddLine("TIT", 10, .F.)
      oFWLayer:AddLine("COR", 80, .F.)
      oFWLayer:AddLine("ROD", 10, .F.)

      // Colunas das linhas
      oFWLayer:AddCollumn("HEADERTEXT", 050, .T., "TIT")
      oFWLayer:AddCollumn("BLANKBTN",   040, .T., "TIT")
      oFWLayer:AddCollumn("BTNSAIR",    010, .T., "TIT")

      oFWLayer:AddCollumn("COLGRID",    100, .T., "COR")

      oFWLayer:AddCollumn("RODGRID",    100, .T., "ROD")

      // Painéis
      oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
      oPanSair   := oFWLayer:GetColPanel("BTNSAIR"   , "TIT")
      oPanGrid   := oFWLayer:GetColPanel("COLGRID"   , "COR")
      oPanRoda   := oFWLayer:GetColPanel("RODGRID"   , "ROD")

      // Cabeçalho
      oSayModulo := TSay():New(004, 003, {|| "Módulo: Clicksign"}, oPanHeader, "", oFontMod , , , , .T., RGB(149,179,215), , 200, 30, , , , , , .F., , )
      oSayTitulo := TSay():New(004, 120, {|| "Log de Envio de Agendas"}, oPanHeader, "", oFontSub , , , , .T., RGB(031,073,125), , 300, 30, , , , , , .F., , )
      oSaySubTit := TSay():New(014, 120, {|| "Layout — Etapa 1 (sem integrações)"}, oPanHeader, "", oFontSubN, , , , .T., RGB(031,073,125), , 300, 30, , , , , , .F., , )

      // Botão Sair
      TButton():New(006, 001, "Fechar", oPanSair, {|...| oDlgPulo:End()}, 60, 018, , oFontBtn, , .T.)

      // Folder com duas páginas: Parâmetros / Envios
      oTFolder := TFolder():New( 001,001,aTFolder,,oPanGrid,,,,.T.,,nJanLarg/2-001,nJanAltu/2-010 )

      // ----- Folder 1: Parâmetros -----
      // Dimensões máximas úteis
      nLargMax := nJanLarg/2-012
      nAltuMax := nJanAltu/2-100

      // Campos de filtro (layout)
      @ 012,012 SAY "Período:"                     SIZE 060,010 OF oTFolder:aDialogs[1] PIXEL
      @ 010,070 DCTOGET dIni PICTURE "@D"          SIZE 060,012 OF oTFolder:aDialogs[1] PIXEL
      @ 010,135 SAY "até"                          SIZE 020,012 OF oTFolder:aDialogs[1] PIXEL CENTER
      @ 010,160 DCTOGET dFim PICTURE "@D"          SIZE 060,012 OF oTFolder:aDialogs[1] PIXEL

      @ 010,240 SAY "Técnico:"                     SIZE 050,012 OF oTFolder:aDialogs[1] PIXEL RIGHT
      @ 010,292 MSGET    cTec  PICTURE "@!"        SIZE 080,012 OF oTFolder:aDialogs[1] PIXEL

      @ 010,380 SAY "Projeto:"                     SIZE 050,012 OF oTFolder:aDialogs[1] PIXEL RIGHT
      @ 010,432 MSGET    cProj PICTURE "@!"        SIZE 120,012 OF oTFolder:aDialogs[1] PIXEL

      @ 010,560 SAY "Contato:"                     SIZE 050,012 OF oTFolder:aDialogs[1] PIXEL RIGHT
      @ 010,612 MSGET    cContato PICTURE "@!"     SIZE 150,012 OF oTFolder:aDialogs[1] PIXEL

      @ 026,012 SAY "Status:"                      SIZE 050,012 OF oTFolder:aDialogs[1] PIXEL
      @ 024,062 COMBOBOX cStatus ITEMS aStatus     SIZE 120,012 OF oTFolder:aDialogs[1] PIXEL

      @ 042,012 SAY "Busca livre:"                 SIZE 070,012 OF oTFolder:aDialogs[1] PIXEL
      @ 040,082 MSGET cBusca PICTURE "@!"          SIZE 400,012 OF oTFolder:aDialogs[1] PIXEL

      @ 040,488 BUTTON PROMPT "Atualizar"          SIZE 080,016 OF oTFolder:aDialogs[1] PIXEL ;
         ACTION ( FWAlert("Atualizar (em construção)") )

      @ 040,572 BUTTON PROMPT "Limpar"             SIZE 060,016 OF oTFolder:aDialogs[1] PIXEL ;
         ACTION ( FWAlert("Limpar filtros (em construção)") )

      // Rodapé (parâmetros escolhidos)
      TGroup():New(02,02,nJanAltu/12,nJanLarg/2-001,'Parâmetros Escolhidos',oPanRoda,,,.T.)
      oParamEnv := TSay():New(20, 10, {|| ""}, oPanRoda, , , , , , .T., CLR_BLACK, CLR_WHITE, nLargMax, 20)
      AtuRodEnv(dIni,dFim,cTec,cProj,cContato,cStatus,cBusca)

      // ----- Folder 2: Envios -----
      // Grid TCBrowse (layout)
      oBrowseEnv := TCBrowse():New( 25 , 05, nJanLarg/2-10, nJanAltu/3-038,,,, oTFolder:aDialogs[2],,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)

      // Colunas (índices do array aBrowseEnv)
      oBrowseEnv:AddColumn(TCColumn():New("Data"            , {|| aBrowseEnv[oBrowseEnv:nAt,01]} ,"@D",,,"LEFT", nLargMax*0.10,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Hora"            , {|| aBrowseEnv[oBrowseEnv:nAt,02]} ,"@!",,,"LEFT", nLargMax*0.08,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Envelope"        , {|| aBrowseEnv[oBrowseEnv:nAt,03]} ,"@!",,,"LEFT", nLargMax*0.12,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Documento"       , {|| aBrowseEnv[oBrowseEnv:nAt,04]} ,"@!",,,"LEFT", nLargMax*0.10,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Projeto"         , {|| aBrowseEnv[oBrowseEnv:nAt,05]} ,"@!",,,"LEFT", nLargMax*0.12,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Técnico"         , {|| aBrowseEnv[oBrowseEnv:nAt,06]} ,"@!",,,"LEFT", nLargMax*0.10,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Contato (ID)"    , {|| aBrowseEnv[oBrowseEnv:nAt,07]} ,"@!",,,"LEFT", nLargMax*0.12,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Qtde OS"         , {|| aBrowseEnv[oBrowseEnv:nAt,08]} ,"@E 99",,,"RIGHT", nLargMax*0.08,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Situação"        , {|| aBrowseEnv[oBrowseEnv:nAt,09]} ,"@!",,,"LEFT", nLargMax*0.12,.F.,.F.))
      oBrowseEnv:AddColumn(TCColumn():New("Mensagem/Retorno", {|| aBrowseEnv[oBrowseEnv:nAt,10]} ,"@!",,,"LEFT", nLargMax*0.25,.F.,.F.))

      // Eventos do browse
      oBrowseEnv:bRClicked    := { |o,x,y| MenuPopEnv(o,x,y) }
      oBrowseEnv:bLClicked    := { || }
      oBrowseEnv:bHeaderClick := { || OrdenaEnv(oBrowseEnv) }

   ACTIVATE MSDIALOG oDlgPulo CENTERED

Return

// ---------------------------------------------------------------------------
// Atualiza rodapé com filtros (layout)
// ---------------------------------------------------------------------------
Static Function AtuRodEnv(dI,dF,cT,cP,cCtt,cSt,cBus)
   Local cTxt := "Período: " + DToC(dI) + " a " + DToC(dF) + ;
                 "  | Técnico: " + AllTrim(cT) + ;
                 "  | Projeto: " + AllTrim(cP) + ;
                 "  | Contato: " + AllTrim(cCtt) + ;
                 "  | Status: "  + AllTrim(cSt) + ;
                 "  | Busca: "   + AllTrim(cBus)
   If ValType(oParamEnv) == "O" .And. !Empty(oParamEnv)
      oParamEnv:SetText(cTxt)
   EndIf
Return

// ---------------------------------------------------------------------------
// Ordenação do browse (stub de layout)
// ---------------------------------------------------------------------------
Static Function OrdenaEnv(oBrw)
   // Apenas layout: poderia alternar por coluna clicada; por hora, só refresca
   If ValType(oBrw) == "O"
      oBrw:Refresh()
   EndIf
Return

// ---------------------------------------------------------------------------
// Menu de contexto (layout/stub)
// ---------------------------------------------------------------------------
Static Function MenuPopEnv(o,x,y)
   Local oMenuItem  := {}

   MENU oMenu POPUP
      aAdd( oMenuItem, MenuAddItem("Abrir no Clicksign"     ,,,,, .T.,,,, oMenu,{ || FWAlert("Abrir no Clicksign (layout)") },,,,,{||.T.} ) )
      aAdd( oMenuItem, MenuAddItem("Copiar ID do Envelope"  ,,,,, .T.,,,, oMenu,{ || FWAlert("Copiar ID (layout)")          },,,,,{||.T.} ) )
      aAdd( oMenuItem, MenuAddItem("Cancelar Envelope"      ,,,,, .T.,,,, oMenu,{ || FWAlert("Cancelar (layout)")           },,,,,{||.T.} ) )
      aAdd( oMenuItem, MenuAddItem("Reenviar e-mail"        ,,,,, .T.,,,, oMenu,{ || FWAlert("Reenviar (layout)")           },,,,,{||.T.} ) )
      aAdd( oMenuItem, MenuAddItem("Ver Histórico (ZP7)"    ,,,,, .T.,,,, oMenu,{ || FWAlert("Histórico (layout)")          },,,,,{||.T.} ) )
   ENDMENU

   oMenu:Activate( Iif( x > oBrowseEnv:NCLIENTWIDTH, oBrowseEnv:NCLIENTWIDTH/2, x ), y, oBrowseEnv )

Return
