// ============================================================================
//  ENVCLICKLOG_FW_FIX.PRW — Layout da tela de LOG (Clicksign) usando FWLayer/TFolder
//  Etapa 1: SOMENTE LAYOUT (sem integrações / sem leitura/gravação)
//  Autor: Assistente do Pedro (Ceriazera squad)
//  Correções: removidos placeholders inválidos e parâmetros em branco; uso de @ BUTTON/ SAY
// ============================================================================

#Include "Protheus.ch"

/*
   Acesso sugerido: U_ENVCLICKLOGFW() (para não conflitar com versões anteriores)
*/

User Function ENVCLICKLOGFW()
   Local oDlgPulo     := Nil
   Local oFWLayer     := Nil
   Local oPanHeader   := Nil
   Local oPanSair     := Nil
   Local oPanGrid     := Nil
   Local oPanRoda     := Nil
   Local nJanLarg     := 1200
   Local nJanAltu     := 700
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

   DEFINE MSDIALOG oDlgPulo TITLE "Log de Envio de Agendas — Clicksign (FW)" FROM 0,0 TO nJanAltu, nJanLarg PIXEL

      // Camada/Layers básicas (sem firula)
      oFWLayer := FwLayer():New()
      oFWLayer:Init(oDlgPulo,.F.)

      // Linhas e colunas
      oFWLayer:AddLine("TIT", 10, .F.)
      oFWLayer:AddLine("COR", 80, .F.)
      oFWLayer:AddLine("ROD", 10, .F.)

      oFWLayer:AddCollumn("HEADERTEXT", 080, .T., "TIT")
      oFWLayer:AddCollumn("BTNSAIR",    020, .T., "TIT")
      oFWLayer:AddCollumn("COLGRID",    100, .T., "COR")
      oFWLayer:AddCollumn("RODGRID",    100, .T., "ROD")

      // Painéis
      oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
      oPanSair   := oFWLayer:GetColPanel("BTNSAIR"   , "TIT")
      oPanGrid   := oFWLayer:GetColPanel("COLGRID"   , "COR")
      oPanRoda   := oFWLayer:GetColPanel("RODGRID"   , "ROD")

      // Cabeçalho simples
      @ 006,004 SAY "Módulo: Clicksign  —  Log de Envio de Agendas (Layout - Etapa 1)" OF oPanHeader SIZE 600,012 PIXEL

      // Botão Fechar (usar sintaxe de comando para evitar confusão de parâmetros)
      @ 004,004 BUTTON PROMPT "Fechar" SIZE 060,018 OF oPanSair PIXEL ACTION ( oDlgPulo:End() )

      // Folder com duas páginas: Parâmetros / Envios
      // Assinatura simplificada do TFolder: New(nTop, nLeft, aPrompts, aDialogs, oWnd, nWidth, nHeight, lPixel)
      oTFolder := TFolder():New( 001, 001, aTFolder, , oPanGrid, nJanLarg-20, nJanAltu-120, .T. )

      // ----- Folder 1: Parâmetros -----
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

      // ----- Folder 2: Envios -----
      // Por ora, só um placeholder textual para evitar dúvidas de assinatura do TCBrowse.
      @ 012,012 SAY "⟶ Aqui entra a GRADE (TCBrowse) com colunas: Data, Hora, Envelope, Documento, Projeto, Técnico, Contato(ID), Qtde OS, Situação, Mensagem." ;
         SIZE 900,012 OF oTFolder:aDialogs[2] PIXEL

      // Rodapé simples com dica
      @ 004,004 SAY "Dica: duplo clique abrirá o detalhe do envelope; clique direito abrirá menu de ações (na próxima etapa)." OF oPanRoda SIZE 900,012 PIXEL

   ACTIVATE MSDIALOG oDlgPulo CENTERED

Return
