#include "rwmake.ch"

/*/{protheus.doc}RelSalOP
Relatorio de Saldos de Empenhos de Ordens de Producao
@author Paulo Roberto de Oliveira
@since 13/06/08
/*/

//
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Programa ...: RelSalOP                             Modulo : Sigapcp     //
//                                                                          //
//  Autor ......: Paulo Roberto de Oliveira            Data ..: 13/06/08    //
//                                                                          //
//  Descricao ..: Relatorio de Saldos de Empenhos de Ordens de Producao     //
//                                                                          //
//  Uso ........: Especifico do Planejamento e Controle de Producao         //
//                                                                          //
//  Observacao .: Emissao de um relatorio demonstrativo saldos de empenhos  //
//                de ordens de producao indisponiveis para apontamento      //
//                                                                          //
//  Atualizacao : 13/06/08 - Paulo Roberto de Oliveira                      //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
//

////////////////////////
User Function RelSalOP()
   ////////////////////////
   //
   Private wnRel       := "RelSalOP"
   Private Titulo      := "Saldos de Empenhos"
   Private cDesc1      := "Este relatório irá emitir um relatório de saldos dos empenhos de ordens"
   Private cDesc2      := "de produção indisponíveis para o apontamento das mesmas.               "
   Private cDesc3      := ""
   Private Tamanho     := "M"
   Private Limite      := 130
   Private lAbortPrint := .F.
   Private cString     := "SC2"
   Private lContinua   := .T.
   Private aReturn     := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
   Private Nomeprog    := "RelSalOP"
   Private nCntImpr    := 0
   Private cRodaTxt    := ""
   Private lRodape     := .T.
   Private cFiltro     := ""
   Private aOrdem      := {}
   Private Li          := 66
   Private m_Pag       := 1
   Private Cabec1      := ""
   Private Cabec2      := ""
   Private nLastKey    := 0
   Private cPerg       := "RSALOP    "
   Private aCampos     := {}
   Private cArqSai     := ""              // Arquivo de Saida p/ Excel
   Private cNomArq     := ""
   Private cIndArq1    := ""
   Private cTipOrd     := ""
   Private cPesqIni    := ""
   Private cPesqFim    := ""
   Private cPesqCpo    := ""
   //
   Perguntas()                            // Criar e Verificar Perguntas
   //
   Pergunte(cPerg, .F.)
   //
   wnRel := SetPrint(cString, wnRel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., aOrdem,, Tamanho)
   //
   If nLastKey == 27
      Return (.T.)
   Endif
   //
   SetDefault(aReturn, cString)
   //
   If nLastKey == 27
      Return (.T.)
   Endif
   //
   If Mv_Par01 > Mv_Par02 .Or. Empty(Mv_Par02) .Or. Mv_Par03 > Mv_Par04 .Or. Empty(Mv_Par04) .Or.;
         Mv_Par07 > Mv_Par08 .Or. Empty(Mv_Par08) .Or. Mv_Par09 > Mv_Par10 .Or. Empty(Mv_Par10)
      //
      MsgBox("Existem Parâmetros Informados Incorretamente !!!", "Atenção !!!", "INFO")
      //
   Else
      //
      cFiltro := IIf(!Empty(aReturn[7]), aReturn[7], "")
      //
      Processa({|| Processar()}, Titulo)
      //
      RptStatus({|lAbortPrint| Relatorio()}, Titulo)
      //
      If File(cArqSai) .And. Mv_Par13 == 1
         //
         If !ApOleClient("MsExcel")
            MsgBox("Microsoft Excel Não Instalado !!!", "Atenção !!!", "INFO")
         Else
            //
            oExcelApp := MsExcel():New()
            oExcelApp:WorkBooks:Open(cArqSai)
            oExcelApp:SetVisible(.T.)
            //
         Endif
         //
      Endif
      //
   Endif
   //
Return (.T.)

///////////////////////////
Static Function Processar()
   ///////////////////////////
   //
   SA1->(DbSetOrder(1))                   // Clientes
   SA2->(DbSetOrder(1))                   // Fornecedores
   CTT->(DbSetOrder(1))                   // Centros de Custo (CTB)
   SI3->(DbSetOrder(1))                   // Centros de Custo (CON)
   SB1->(DbSetOrder(1))                   // Produtos
   SB2->(DbSetOrder(1))                   // Saldos em Estoque
   SC2->(DbSetOrder(1))                   // Ordens de Producao
   SC5->(DbSetOrder(1))                   // Cabecalho de Pedidos de Venda
   SC6->(DbSetOrder(1))                   // Itens de Pedidos de Venda
   SD4->(DbSetOrder(2))                   // Empenhos
   //
   cNomArq  := ""                         // Arquivo Temporario de Faturamento por Vendedor
   cIndArq1 := ""
   aCampos  := {}
   //
   Aadd(aCampos, {"ORDPRO", "C", 13, 0})  // Numero da Ordem de Producao
   Aadd(aCampos, {"CODPRO", "C", 15, 0})  // Codigo do Produto Acabado
   Aadd(aCampos, {"DESPRO", "C", 40, 0})  // Descricao do Produto Acabado
   Aadd(aCampos, {"UNIMED", "C", 02, 0})  // Unidade de Medida do Produto Acabado
   Aadd(aCampos, {"CCUSTO", "C", 09, 0})  // Codigo do Centro de Custo
   Aadd(aCampos, {"DESCCU", "C", 40, 0})  // Descricao do Centro de Custo
   Aadd(aCampos, {"DATEMI", "D", 08, 0})  // Data de Emissao da Ordem de Producao
   Aadd(aCampos, {"DATPRV", "D", 08, 0})  // Data de Entrega Prevista da Ordem de Producao
   Aadd(aCampos, {"DATREA", "D", 08, 0})  // Data de Entrega Real da Ordem de Producao
   Aadd(aCampos, {"QTDORI", "N", 15, 3})  // Quantidade Original da Ordem de Producao
   Aadd(aCampos, {"QTDENT", "N", 15, 3})  // Quantidade Ja Entregue da Ordem de Producao
   Aadd(aCampos, {"QTDSAL", "N", 15, 3})  // Quantidade de Saldo a Entregar da Ordem de Producao
   Aadd(aCampos, {"PEDVEN", "C", 06, 0})  // Numero do Pedido de Venda
   Aadd(aCampos, {"ITEMPV", "C", 02, 0})  // Item do Pedido de Venda
   Aadd(aCampos, {"CODCLI", "C", 06, 0})  // Codigo do Cliente do Pedido de Venda
   Aadd(aCampos, {"LOJCLI", "C", 02, 0})  // Loja do Cliente do Pedido de Venda
   Aadd(aCampos, {"NOMCLI", "C", 40, 0})  // Nome do Cliente do Pedido de Venda
   Aadd(aCampos, {"CODCOM", "C", 15, 0})  // Codigo do Produto Componente Empenhado
   Aadd(aCampos, {"DESCOM", "C", 40, 0})  // Descricao do Produto Componente Empenhado
   Aadd(aCampos, {"UNICOM", "C", 02, 0})  // Unidade de Medida do Produto Camponente
   Aadd(aCampos, {"CODLOC", "C", 02, 0})  // Codigo do Local ou Almoxarifado do Produto Camponente
   Aadd(aCampos, {"SALEMP", "N", 15, 3})  // Quantidade do Saldo do Empenho do Componente
   Aadd(aCampos, {"SALEST", "N", 15, 3})  // Quantidade do Saldo em Estoque Atual do Componente
   Aadd(aCampos, {"SALFIN", "N", 15, 3})  // Quantidade do Saldo Final do Componente
   Aadd(aCampos, {"SITUAC", "C", 10, 0})  // Situacao do Saldo do Produto Componente
   //
   If Select("TRB") > 0
      TRB->(DbCloseArea())
   Endif
   //
   // cNomArq := CriaTrab(aCampos, .T.)
   // DbUseArea(.T.,, cNomArq, "TRB", .T., .F.)
   // //
   // cIndArq1 := CriaTrab(Nil, .F.)
   // cChavInd := "TRB->ORDPRO + TRB->CODPRO + TRB->CODCOM"
   // IndRegua("TRB", cIndArq1, cChavInd,,, "Selecionando Registros ...")
   // //
   // DbSelectArea("TRB")
   // DbSetIndex(cIndArq1 + OrdBagExt())

   // Instancio o objeto
   oTable  := FwTemporaryTable():New( "TRB" )
   // Adiciono os campos na tabela
   oTable:SetFields( aCampos )
   // Adiciono os índices da tabela
   oTable:AddIndex( '01' , { cChavInd })
   // Crio a tabela no banco de dados
   oTable:Create()
   //------------------------------------
   //Pego o alias da tabela temporária
   //------------------------------------
   cNomArq := oTable:GetAlias()

   //
   cPesqIni := Mv_Par01
   cPesqFim := Mv_Par02
   cPesqCpo := "SC2->(C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD)"
   //
   DbSelectArea("SC2")
   ProcRegua(SC2->(LastRec()))
   SC2->(DbSeek(xFilial("SC2") + cPesqIni, .T.))
   //
   While SC2->(!Eof()) .And. SC2->C2_FILIAL == xFilial("SC2") .And. &(cPesqCpo) <= cPesqFim
      //
      IncProc("Ordem de Produção -> " + SC2->C2_NUM)
      //
      If SC2->(C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD) < Mv_Par01 .Or. SC2->(C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD) > Mv_Par02 .Or.;
            SC2->C2_PRODUTO < Mv_Par03 .Or. SC2->C2_PRODUTO > Mv_Par04 .Or. Dtos(SC2->C2_EMISSAO) < Dtos(Mv_Par07) .Or.;
            Dtos(SC2->C2_EMISSAO) > Dtos(Mv_Par08) .Or. Dtos(SC2->C2_DATPRF) < Dtos(Mv_Par09) .Or. Dtos(SC2->C2_DATPRF) > Dtos(Mv_Par10)
         //
         SC2->(DbSkip())
         Loop
         //
      Endif
      //
      If Mv_Par11 == 1 .And. SC2->C2_TPOP # "F"
         //
         SC2->(DbSkip())               // Desprezar OP que Nao seja Firme
         Loop
         //
      Elseif Mv_Par11 == 2 .And. SC2->C2_TPOP # "P"
         //
         SC2->(DbSkip())               // Desprezar OP que Nao seja Prevista
         Loop
         //
      Endif
      //
      If Mv_Par12 == 1 .And. SC2->C2_SEQUEN # "001"
         //
         SC2->(DbSkip())               // Desprezar OP que Nao seja a Principal
         Loop
         //
      Endif
      //
      If Mv_Par05 == 1 .And. !Empty(SC2->C2_DATRF)
         //
         SC2->(DbSkip())               // Desprezar OP que Esteja Encerrada
         Loop
         //
      Elseif Mv_Par05 == 2 .And. Empty(SC2->C2_DATRF)
         //
         SC2->(DbSkip())               // Desprezar OP que Nao Esteja Encerrada
         Loop
         //
      Endif
      //
      If !Empty(cFiltro)               // Verifica Filtro do Usuario
         //
         DbSelectArea("SC2")
         If !(&cFiltro)
            //
            SC2->(DbSkip())
            Loop
            //
         Endif
         //
      Endif
      //
      xORDPRO := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD)
      xCODPRO := SC2->C2_PRODUTO
      xCCUSTO := SC2->C2_CC
      //
      SB1->(DbSeek(xFilial("SB1") + SC2->C2_PRODUTO, .F.))
      //
      xDESPRO := SB1->B1_DESCNF
      xUNIMED := SB1->B1_UM
      xDESCCU := "N/T"
      //
      CTT->(DbSeek(xFilial("CTT") + SC2->C2_CC, .F.))
      //
      If CTT->(Found())
         xDESCCU := CTT->CTT_DESC01
      Else
         //
         SI3->(DbSeek(xFilial("SI3") + SC2->C2_CC, .F.))
         //
         If SI3->(Found())
            xDESCCU := SI3->I3_DESC
         Endif
         //
      Endif
      //
      xDATEMI := SC2->C2_EMISSAO
      xDATPRV := SC2->C2_DATPRF
      xDATREA := SC2->C2_DATRF
      //
      xQTDORI := SC2->C2_QUANT
      xQTDENT := SC2->C2_QUJE
      xQTDSAL := (xQTDORI - xQTDENT)
      //
      If xQTDSAL < 0
         xQTDSAL := 0
      Endif
      //
      xPEDVEN := SC2->C2_PEDIDO
      xITEMPV := SC2->C2_ITEMPV
      xCODCLI := Space(6)
      xLOJCLI := Space(2)
      xNOMCLI := Space(40)
      //
      If !Empty(SC2->C2_PEDIDO)
         //
         SC5->(DbSeek(xFilial("SC5") + SC2->C2_PEDIDO, .F.))
         //
         If SC5->(Found())
            //
            xCODCLI := SC5->C5_CLIENTE
            xLOJCLI := SC5->C5_LOJACLI
            //
            If SC5->C5_TIPO $ "D,B,"   // Utiliza Fornecedor (Devolucao, Beneficiamento)
               //
               SA2->(DbSeek(xFilial("SA2") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, .F.))
               //
               xNOMCLI := SA2->A2_NOME
               //
            Else                       // Utiliza Cliente
               //
               SA1->(DbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, .F.))
               //
               xNOMCLI := SA1->A1_NOME
               //
            Endif
            //
         Endif
         //
      Endif
      //
      SD4->(DbSeek(xFilial("SD4") + SC2->C2_NUM + SC2->C2_ITEM, .F.))
      //
      While SD4->(!Eof()) .And. SD4->D4_FILIAL == xFilial("SD4") .And. Substr(SD4->D4_OP, 1, 8) == (SC2->C2_NUM + SC2->C2_ITEM)
         //
         SB1->(DbSeek(xFilial("SB1") + SD4->D4_COD, .F.))
         //
         xCODCOM := SD4->D4_COD
         xDESCOM := SB1->B1_DESCNF
         xUNICOM := SB1->B1_UM
         xCODLOC := SD4->D4_LOCAL
         xSALEMP := SD4->D4_QUANT
         //
         SB2->(DbSeek(xFilial("SB2") + SD4->D4_COD + SD4->D4_LOCAL, .F.))
         //
         xSALEST := SB2->B2_QATU
         xSALFIN := (xSALEST - xSALEMP)
         xSITUAC := ""
         //
         If xSALFIN >= 0 .Or. xSALEMP <= 0
            xSITUAC := "Saldo Ok"
         Else
            xSITUAC := "Sem Saldo"
         Endif
         //
         If (Mv_Par06 == 1 .And. xSITUAC == "Sem Saldo") .Or. Mv_Par06 == 2
            //
            GravarDados()           // Atualizacao dos Dados no Arquivo Temporario
            //
         Endif
         //
         SD4->(DbSkip())
         //
      Enddo
      //
      SC2->(DbSkip())
      //
   Enddo
   //
   SC2->(DbSetOrder(1))
   SD4->(DbSetOrder(1))
   //
Return (.T.)

/////////////////////////////
Static Function GravarDados()
   /////////////////////////////
   //
   TRB->(DbSeek(xORDPRO + xCODPRO + xCODCOM, .F.))
   //
   If TRB->(Found())                      // Alteracao
      _lGrava := .F.
   Else                                   // Inclusao
      _lGrava := .T.
   Endif
   //
   DbSelectArea("TRB")                    // Atualizar os Dados do Arquivo Temporario
   If TRB->(RecLock("TRB", _lGrava))
      //
      If _lGrava
         //
         TRB->ORDPRO := xORDPRO
         TRB->CODPRO := xCODPRO
         TRB->CODCOM := xCODCOM
         //
      Endif
      //
      TRB->DESPRO := xDESPRO
      TRB->UNIMED := xUNIMED
      TRB->CCUSTO := xCCUSTO
      TRB->DESCCU := xDESCCU
      TRB->DATEMI := xDATEMI
      TRB->DATPRV := xDATPRV
      TRB->DATREA := xDATREA
      TRB->QTDORI := xQTDORI
      TRB->QTDENT := xQTDENT
      TRB->QTDSAL := xQTDSAL
      TRB->PEDVEN := xPEDVEN
      TRB->ITEMPV := xITEMPV
      TRB->CODCLI := xCODCLI
      TRB->LOJCLI := xLOJCLI
      TRB->NOMCLI := xNOMCLI
      TRB->DESCOM := xDESCOM
      TRB->UNICOM := xUNICOM
      TRB->CODLOC := xCODLOC
      TRB->SALEMP := xSALEMP
      TRB->SALEST := xSALEST
      TRB->SALFIN := xSALFIN
      TRB->SITUAC := xSITUAC
      //
      TRB->(MsUnlock())
      //
   Endif
   //
Return (.T.)

///////////////////////////
Static Function Relatorio()
   ///////////////////////////
   //
   If Mv_Par11 == 1
      cTipOrd := "Firmes"
   Elseif Mv_Par11 == 2
      cTipOrd := "Previstas"
   Else
      cTipOrd := "Firmes e Previstas"
   Endif
   //
   If Mv_Par05 == 1
      cSitOrd := "Em Aberto"
   Elseif Mv_Par05 == 2
      cSitOrd := "Encerradas"
   Else
      cSitOrd := "Todas"
   Endif
   //
   Titulo := "Saldos de Empenhos de Ordens de Producao " + cTipOrd + " - " + cSitOrd
   Cabec1 := " Codigo do Prod.  Descricao do Produto                    Unid. Arma-   Saldo do     Saldo Atual    Saldo Final   Ocorrencia"
   Cabec2 := " Componente       Componente Empenhado                     Med.  zem     Empenho      em Estoque     do Estoque   do Saldo  "
   //          XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX   XX  9.999.999,999  9.999.999,999  9.999.999,999  XXXXXXXXXX
   Li     := 66
   nTipo  := IIf(aReturn[4] == 1, 15, 18)
   cTraco := Replicate("-", Limite)
   //
   SetPrc(0, 0)
   //
   DbSelectArea("TRB")                    // Impressao dos Dados
   SetRegua(TRB->(LastRec()))
   TRB->(DbGoTop())
   //
   cOrdPro := TRB->ORDPRO                 // Variaveis de Quebra
   nQtdIte := 0
   lPriVez := .T.
   //
   While TRB->(!Eof())
      //
      IncRegua()
      //
      If lAbortPrint
         Exit
      Endif
      //
      If Li > 57
         //
         Li := Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo) + 1
         lPriVez := .T.
         //
      Endif
      //
      If lPriVez
         //
         @ Li, 001 Psay "Ord. Producao : " + Alltrim(Transform(Substr(TRB->ORDPRO, 1, 13), "@ER XXXXXX-XX-XXX")) + "  Produto : " +;
            Alltrim(Substr(TRB->CODPRO, 1, 15)) + "-" + Substr(TRB->DESPRO, 1, 35) + "  Emissao : " + Dtoc(TRB->DATEMI) +;
            "  Qtde : " + Alltrim(Transform(TRB->QTDORI, "@E 9,999,999")) + " " + Substr(TRB->UNIMED, 1, 2)
         Li += 1
         @ Li, 001 Psay cTraco
         Li += 1
         //
         lPriVez := .F.
         //
      Endif
      //
      @ Li, 001 Psay Substr(TRB->CODCOM, 1, 15)
      @ Li, 018 Psay Substr(TRB->DESCOM, 1, 40)
      @ Li, 060 Psay Substr(TRB->UNICOM, 1, 2)
      @ Li, 065 Psay Substr(TRB->CODLOC, 1, 2)
      @ Li, 069 Psay Transform(TRB->SALEMP, "@E 9,999,999.999")
      @ Li, 084 Psay Transform(TRB->SALEST, "@E 9,999,999.999")
      @ Li, 099 Psay Transform(TRB->SALFIN, "@E 9,999,999.999")
      @ Li, 114 Psay Substr(TRB->SITUAC, 1, 10)
      Li += 1
      //
      nQtdIte += 1
      //
      TRB->(DbSkip())
      //
      If TRB->(Eof()) .Or. TRB->ORDPRO # cOrdPro
         //
         @ Li, 001 Psay cTraco
         Li += 1
         @ Li, 001 Psay "Total de Itens : " + Alltrim(Str(nQtdIte, 6))
         Li += 1
         @ Li, 001 Psay cTraco
         Li += 2
         //
         cOrdPro := TRB->ORDPRO
         nQtdIte := 0
         lPriVez := .T.
         //
         If TRB->(Eof()) .And. lRodape
            Roda(nCntImpr, cRodaTxt, Tamanho)
         Endif
         //
      Endif
      //
   Enddo
   //
   Set Device To Screen
   //
   If aReturn[5] == 1
      //
      Set Printer To
      DbCommitAll()
      OurSpool(wnRel)
      //
   Endif
   //
   Ms_Flush()
   //
   DbSelectArea("TRB")                    // Fechar Arquivo Temporario
   TRB->(DbCloseArea())
   //
   cArqSai := Alltrim(Mv_Par14)           // Arquivo de Saida Informado
   //
   If File(cArqSai)                       // Apagar Arquivo de Saida Anterior
      FErase(cArqSai)
   Endif
   //
   cArqTmp := cNomArq + ".DBF"            // Arquivo Temporario Auxiliar
   Copy File &cArqTmp To &cArqSai         // Copiar Arquivo de Dados de Saida
   //
   FErase(cNomArq + ".DBF")               // Apagar Arquivos Temporarios
   FErase(cIndArq1 + OrdBagExt())
   //
Return (.T.)

///////////////////////////
Static Function Perguntas()
   ///////////////////////////
   //
   Local sAlias := Alias()                // Variaveis Auxiliares
   Local aRegs  := {}
   //
   SX1->(DbSetOrder(1))                   // Perguntas do Sistema
   //
   Aadd(aRegs,{cPerg,"01","Da Ordem de Producao         ?","","","mv_cha","C",13,0,0,"G","",;
      "Mv_Par01","","","","             ","","","","","","","","","","","","","","","","","","","","","SC2","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"02","Ate a Ordem de Producao      ?","","","mv_chb","C",13,0,0,"G","NaoVazio()",;
      "Mv_Par02","","","","ZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SC2","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"03","Do Codigo do Produto         ?","","","mv_chc","C",15,0,0,"G","",;
      "Mv_Par03","","","","               ","","","","","","","","","","","","","","","","","","","","","SB1","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"04","Ate o Codigo do Produto      ?","","","mv_chd","C",15,0,0,"G","NaoVazio()",;
      "Mv_Par04","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"05","Situacao das Ord. de Prod.   ?","","","mv_che","N",01,0,1,"C","",;
      "Mv_Par05","Em Aberto","","","","","Encerradas","","","","","Todas","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"06","Apenas Empenhos S/ Saldo     ?","","","mv_chf","N",01,0,1,"C","",;
      "Mv_Par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"07","Da Data de Emissao           ?","","","mv_chg","D",08,0,0,"G","",;
      "Mv_Par07","","","","01/01/01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"08","Ate a Data de Emissao        ?","","","mv_chh","D",08,0,0,"G","NaoVazio()",;
      "Mv_Par08","","","","31/12/49","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"09","Da Data de Entrega Prevista  ?","","","mv_chi","D",08,0,0,"G","",;
      "Mv_Par09","","","","01/01/01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"10","Ate Data de Entrega Prev.    ?","","","mv_chj","D",08,0,0,"G","NaoVazio()",;
      "Mv_Par10","","","","31/12/49","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"11","Tipo de Ordem de Producao    ?","","","mv_chk","N",01,0,1,"C","",;
      "Mv_Par11","Firme","","","","","Prevista","","","","","Ambos","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"12","Apenas a OP Principal        ?","","","mv_chl","N",01,0,2,"C","",;
      "Mv_Par12","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"13","Mostrar Planilha Excel       ?","","","mv_chm","N",01,0,2,"C","",;
      "Mv_Par13","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"14","Arquivo de Saida p/ Excel    ?","","","mv_chn","C",40,0,0,"G","NaoVazio()",;
      "Mv_Par14","","","","C:\TEMP\RELSALOP.DBF","","","","","","","","","","","","","","","","","","","","","DIR","","","","","","","","","","","","","","",""})
   //
   For i := 1 To Len(aRegs)               // Gravar as Perguntas
      //
      SX1->(DbSeek(cPerg + aRegs[i, 2]))
      //
      If SX1->(!Found())
         //
         DbSelectArea("SX1")
         If SX1->(Reclock("SX1", .T.))
            //
            For j := 1 To FCount()
               //
               If j <= Len(aRegs[i])
                  FieldPut(j, aRegs[i, j])
               Endif
               //
            Next
            //
            SX1->(MsUnlock())
            //
         Endif
         //
      Endif
      //
   Next
   //
   For i := 1 To Len(aRegs)          // Regravar as Perguntas
      //
      SX1->(DbSeek(cPerg + aRegs[i, 2]))
      //
      If SX1->(Found()) .And. Empty(SX1->X1_CNT01)
         //
         DbSelectArea("SX1")
         If SX1->(Reclock("SX1", .F.))
            //
            If (i == 1 .Or. i == 3 .Or. i == 7 .Or. i == 9)
               SX1->X1_CNT01 := SX1->X1_CNT01
            Endif
            //
            If (i == 2)
               SX1->X1_CNT01 := "ZZZZZZZZZZZZZ"
            Endif
            //
            If (i == 4)
               SX1->X1_CNT01 := "ZZZZZZZZZZZZZZZ"
            Endif
            //
            If (i == 8 .Or. i == 10)
               SX1->X1_CNT01 := Dtoc(dDataBase)
            Endif
            //
            If i == 14
               SX1->X1_CNT01 := "C:\TEMP\RELSALOP.DBF"
            Endif
            //
            SX1->(MsUnlock())
            //
         Endif
         //
      Endif
      //
   Next
   //
   DbSelectArea(sAlias)
   //
Return (.T.)
