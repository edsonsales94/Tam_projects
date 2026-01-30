/* ============================================================================
   ENVCLICKOS_UI.PRW — Layout da tela de LOG de envio de agendas (Clicksign)
   Etapa 1: SOMENTE LAYOUT (sem integrações / sem gravação / sem leitura DB)
   Autor: Assistente do Pedro (Ceriazera squad)
   Observações:
   • Próximas etapas adicionarão: carregar ZP7, cancelamento de envelope (API v3),
     aglutinação manual de OS e geração de envelope manual.
   • Em AdvPL, declarar TODAS as LOCAL no topo da função (padrão do Pedro).
   ============================================================================ */

#Include "Protheus.ch"

/*
   Acesso sugerido: U_ENVCLICKLOG() pelo configurador (SIGACFG) / menu custom.
*/

User Function ENVCLICKLOG()
   Local oDlg         := NIL
   Local oFont        := NIL
   Local dIni         := Date() - 15   // Período inicial (padrão 15 dias)
   Local dFim         := Date()        // Período final
   Local cTec         := Space(10)     // Técnico
   Local cProj        := Space(20)     // Projeto
   Local cContato     := Space(40)     // Contato (nome ou ID)
   Local cStatus      := "Todos"       // Filtro de status
   Local aStatus      := {"Todos","Enviado","Pendente","Erro","Cancelado"}
   Local cBusca       := Space(60)     // Busca livre
   Local aCols        := { ;           // Cabeçalhos da grade (layout)
                           "Data/Hora", ;
                           "Envelope", ;
                           "Documento", ;
                           "Projeto", ;
                           "Técnico", ;
                           "Contato (ID)", ;
                           "Qtde OS", ;
                           "Situação", ;
                           "Mensagem/Retorno" }
   Local aData        := {}            // Dados mock para layout (apenas visual)
   Local oBrw         := NIL           // Placeholder da grade (TCBrowse)
   Local oSayEmpty    := NIL           // Placeholder quando sem TCBrowse
   Local nW           := 1000          // Largura dialog (px)
   Local nH           := 560           // Altura dialog (px)
   Local nTopGrid     := 070           // Top da grade
   Local nBotGrid     := nH - 052      // Bottom da grade

   /* Dados de exemplo só para layout visual — serão removidos ao ligar no ZP7 */
   AAdd(aData, { Date(), Time(), "ENV-000123", "DOC-8899", "PRJ-001", "TEC-007", "CNT-55", 3, "Enviado", "OK" })
   AAdd(aData, { Date(), Time(), "ENV-000124", "DOC-8901", "PRJ-002", "TEC-021", "CNT-72", 2, "Pendente", "Aguardando assinatura" })

   /* Diálogo principal */
   DEFINE MSDIALOG oDlg TITLE "Log de Envio de Agendas — Clicksign" FROM 000,000 TO nH, nW PIXEL

      /* Fonte base opcional */
      // oFont := TFont():New("Segoe UI", 0, -12)
      // oDlg:SetFont(oFont)

      /* Linha de filtros (topbar) */
      @ 006,010 SAY "Período:" SIZE 060,010 OF oDlg PIXEL
      @ 004,070 DCTOGET dIni      PICTURE "@D"  SIZE 060,012 OF oDlg PIXEL
      @ 004,135 SAY "até"         SIZE 020,012 OF oDlg PIXEL CENTER
      @ 004,160 DCTOGET dFim      PICTURE "@D"  SIZE 060,012 OF oDlg PIXEL

      @ 004,230 SAY "Técnico:"    SIZE 050,012 OF oDlg PIXEL RIGHT
      @ 004,282 MSGET    cTec      PICTURE "@!" SIZE 070,012 OF oDlg PIXEL

      @ 004,360 SAY "Projeto:"    SIZE 050,012 OF oDlg PIXEL RIGHT
      @ 004,412 MSGET    cProj     PICTURE "@!" SIZE 080,012 OF oDlg PIXEL

      @ 004,500 SAY "Contato:"    SIZE 050,012 OF oDlg PIXEL RIGHT
      @ 004,552 MSGET    cContato  PICTURE "@!" SIZE 120,012 OF oDlg PIXEL

      @ 004,680 SAY "Status:"     SIZE 045,012 OF oDlg PIXEL RIGHT
      @ 004,728 COMBOBOX cStatus ITEMS aStatus SIZE 100,012 OF oDlg PIXEL

      @ 020,010 SAY "Busca livre:" SIZE 070,012 OF oDlg PIXEL
      @ 018,080 MSGET cBusca PICTURE "@!" SIZE 360,012 OF oDlg PIXEL
      @ 016,448 BUTTON PROMPT "Atualizar" SIZE 080,016 OF oDlg PIXEL ACTION ( FWAlert("Atualizar (em construção)") )
      @ 016,532 BUTTON PROMPT "Limpar"    SIZE 060,016 OF oDlg PIXEL ACTION ( FWAlert("Limpar filtros (em construção)") )

      /* Botões de ação (lado direito) — ainda sem regra */
      @ 016,610 BUTTON PROMPT "Gerar Envelope"    SIZE 100,016 OF oDlg PIXEL ACTION ( FWAlert("Gerar Envelope (layout) ") )
      @ 016,716 BUTTON PROMPT "Cancelar Envelope" SIZE 110,016 OF oDlg PIXEL ACTION ( FWAlert("Cancelamento (layout)") )
      @ 016,832 BUTTON PROMPT "Aglutinar OS"      SIZE 090,016 OF oDlg PIXEL ACTION ( FWAlert("Aglutinação manual (layout)") )

      /* Moldura da grade */
      @ 040,008 GROUP TO nBotGrid-6, nW-008 PROMPT "Envios para assinatura (layout)" OF oDlg PIXEL

      /* Placeholder visual da grade: se TCBrowse estiver disponível no ambiente,
         substitua este bloco pelo TCBrowse real na etapa 2. */
      @ nTopGrid+04, 012 SAY "⟶ Aqui entra a GRADE com colunas:" OF oDlg PIXEL SIZE 400,012
      @ nTopGrid+20, 012 SAY ( "  • " + aCols[1]  + "; " + aCols[2]  + "; " + aCols[3]  + "; " + aCols[4] ) OF oDlg PIXEL SIZE 900,012
      @ nTopGrid+32, 012 SAY ( "  • " + aCols[5]  + "; " + aCols[6]  + "; " + aCols[7]  + "; " + aCols[8]  + "; " + aCols[9] ) OF oDlg PIXEL SIZE 900,012

      /* Rodapé */
      @ nH-028,008 GROUP TO nH-008, nW-008 OF oDlg PIXEL
      @ nH-024,016 SAY "Dica: duplo clique abre o detalhe do envelope; clique direito abre menu de ações." OF oDlg PIXEL SIZE 540,012
      @ nH-026,nW-220 BUTTON PROMPT "Fechar" SIZE 070,016 OF oDlg PIXEL ACTION ( oDlg:End() )

   ACTIVATE MSDIALOG oDlg CENTERED

Return

/* ============================================================================
   ROTEIRO (próximas etapas)
   2) Conectar ZP7: carregar dados no aData via TopConn/DbUseArea e TCBrowse real.
   3) Cancelamento de envelope: botão chama rotina REST para Clicksign v3 (DELETE /envelopes/:id ou ação própria) + update ZP7.
   4) Aglutinação manual: janela auxiliar para selecionar OS (SZ1) e gerar novo envelope.
   5) Geração manual de envelope: chamar rotina já existente (ENVCLICKOS) com parâmetros custom.
   6) Context menu na grade: “Abrir no Clicksign”, “Copiar ID”, “Reenviar e-mail”, etc.
   7) Persistir filtros por usuário (SX6/UPRF) e salvar largura das colunas.
   ============================================================================ */
