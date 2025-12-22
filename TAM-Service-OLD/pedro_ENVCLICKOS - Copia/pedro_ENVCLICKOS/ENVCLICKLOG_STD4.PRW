// ============================================================================
//  ENVCLICKLOG_STD4.PRW — Layout da tela LOG Clicksign (padrão ITVSA010)
//  Ajustes: largura da grid; filtros dentro do Group; botoes reposicionados
//  Execute: U_ENVCLICKLOGSTD4()
// ============================================================================

#Include "PROTHEUS.ch"

User Function ENVCLICKLOGSTD4()
   Local oDlgPulo, oFwLayer, oPanHeader, oPanSair, oPanGrid, oPanRoda
   Local oTFolder, oBtnSair, oGrpFiltros, oBrowseEnv
   Local aTFolder := { 'Envios', 'Aglutinacao' }

   // Cabecalho (ASCII)
   Local cSayModulo := 'CLK'
   Local cSayTitulo := 'KODIGOS SISTEMAS'
   Local cSaySubTit := 'Log de Envio de Agendas - Clicksign (Layout)'

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
   Local aEnv := {}
   AAdd(aEnv, { Date(), Time(), 'ENV-000123', 'DOC-8899', 'PRJ-001', 'TEC-007', 'CNT-55', 3, 'ENVIADO' , 'OK' })
   AAdd(aEnv, { Date(), Time(), 'ENV-000124', 'DOC-8901', 'PRJ-002', 'TEC-021', 'CNT-72', 2, 'PENDENTE', 'AGUARDANDO ASSINATURA' })

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

   // Medidas internas (coluna direita)
   Local nLargMax := nJanLarg/2-012
   Local nAltuMax := nJanAltu/2-100

   // ===== ABA 1: Envios =====
   // Grid a esquerda — REDUZI a largura para nao invadir a coluna direita
   oBrowseEnv := TCBrowse():New(25,05,(nJanLarg/2-24), nJanAltu/2-060,,,, oTFolder:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
   oBrowseEnv:AddColumn( TCColumn():New('Data'            , {|| aEnv[oBrowseEnv:nAt,01]}, '@D') )
   oBrowseEnv:AddColumn( TCColumn():New('Hora'            , {|| aEnv[oBrowseEnv:nAt,02]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Envelope'        , {|| aEnv[oBrowseEnv:nAt,03]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Documento'       , {|| aEnv[oBrowseEnv:nAt,04]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Projeto'         , {|| aEnv[oBrowseEnv:nAt,05]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Tecnico'         , {|| aEnv[oBrowseEnv:nAt,06]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Contato(ID)'     , {|| aEnv[oBrowseEnv:nAt,07]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Qtde OS'         , {|| aEnv[oBrowseEnv:nAt,08]}, '@E 99') )
   oBrowseEnv:AddColumn( TCColumn():New('Situacao'        , {|| aEnv[oBrowseEnv:nAt,09]}, '@!') )
   oBrowseEnv:AddColumn( TCColumn():New('Mensagem/Retorno', {|| aEnv[oBrowseEnv:nAt,10]}, '@!') )
   oBrowseEnv:SetArray(aEnv)
   oBrowseEnv:Refresh()

   // Filtros a direita — agora DENTRO do GROUP (parent = oGrpFiltros)
   oGrpFiltros := TGroup():New(02, nLargMax*0.80+10, nAltuMax, nLargMax, ;
      'Defina o periodo e filtros. Campos em branco consideram todos.', ;
      oTFolder:aDialogs[1],,,.T.)

   // Todas as caixas com MESMA largura (120,010), labels preservados
   TGet():New( 15, 20, { |u| If(PCount()==0, dDtIni  , dDtIni   := u) }, oGrpFiltros, 120,010, '@D',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'dDtIni'  ,,,,,,,'Data de',1)
   TGet():New( 40, 20, { |u| If(PCount()==0, dDtFim  , dDtFim   := u) }, oGrpFiltros, 120,010, '@D',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'dDtFim'  ,,,,,,,'Data ate',1)
   TGet():New( 65, 20, { |u| If(PCount()==0, cTecnico, cTecnico := u) }, oGrpFiltros, 120,010, '@!',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cTecnico',,,,,,,'Tecnico:',1)
   TGet():New( 90, 20, { |u| If(PCount()==0, cProjeto, cProjeto := u) }, oGrpFiltros, 120,010, '@!',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cProjeto',,,,,,,'Projeto:',1)
   TGet():New(115, 20, { |u| If(PCount()==0, cContato, cContato := u) }, oGrpFiltros, 120,010, '@!',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cContato',,,,,,,'Contato:',1)
   TGet():New(140, 20, { |u| If(PCount()==0, cStatus , cStatus  := u) }, oGrpFiltros, 120,010, '@!',,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'cStatus' ,,,,,,,'Status:',1)

   // Botoes – reposicionados dentro do GROUP, lado a lado, evitando corte
   TButton():New(165, 20 , 'Atualizar', oGrpFiltros, {|| FWAlert('Atualizar (layout)')} , 080,018, , oFontBtn, , .T., , , , , , )
   TButton():New(165, 110, 'Limpar'   , oGrpFiltros, {|| FWAlert('Limpar (layout)')}    , 080,018, , oFontBtn, , .T., , , , , , )

   // ===== ABA 2: Aglutinacao (placeholder) =====
   TSay():New(012,012,{|| 'Tela de Aglutinacao de OS e Envios customizados (proxima etapa).'}, oTFolder:aDialogs[2], '', oFontSay, , , , .T., CLR_BLACK, CLR_WHITE, 900, 12)

   // Rodape
   TSay():New(004,004,{|| 'Dica: clique direito abrira menu de acoes; duplo clique abrira os detalhes do envelope (na proxima etapa).'}, oPanRoda, '', oFontSay, , , , .T., CLR_BLACK, CLR_WHITE, 900, 12)

   ACTIVATE MSDIALOG oDlgPulo CENTERED
Return
