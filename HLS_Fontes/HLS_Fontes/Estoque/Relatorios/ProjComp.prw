#include "rwmake.ch"

/*/{protheus.doc}ProjComp
Relatorio de Projeção de Compras
@author HONDA LOCK
@since
/*/

////////////////////////
User Function ProjComp()
   ////////////////////////
   //
   Private wnRel       := "ProjComp"
   Private Titulo      := "Projeção de Compras"
   Private cDesc1      := "Este relatório irá emitir uma relação de produtos com projeção de"
   Private cDesc2      := "compras num determinado período anterior a data base atual e desta-"
   Private cDesc3      := "cará a projeção de duração do estoque para os meses seguintes.    "
   Private Tamanho     := "G"
   Private Limite      := 220
   Private lAbortPrint := .F.
   Private cString     := "SD2"
   Private lContinua   := .T.
   Private aReturn     := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
   Private Nomeprog    := "ProjComp"
   Private nCntImpr    := 0
   Private cRodaTxt    := ""
   Private lRodape     := .T.
   Private cFiltro     := ""
   Private Li          := 66
   Private m_Pag       := 1
   Private Cabec1      := ""
   Private Cabec2      := ""
   Private cMeses      := ""
   Private nLastKey    := 0
   Private cPerg       := "PROJCOMP"      // Pergunta Especifica
   Private aCampos     := {}
   Private lCodPais    := .F.             // Flag do Campo B1_CODPAIS (C, 3) Existente na Tabela SB1 (.T.) ou Nao (.F.)
   Private cNomArq     := ""              // Arquivo de Trabalho Temporario
   Private cIndArq1    := ""
   Private cIndArq2    := ""
   Private cArqSai     := ""              // Arquivo de Saida p/ Excel
   Private nMesesAnt   := 0               // Numero de Meses Anteriores p/ Apuracao
   //
   //Perguntas()                            // Criar e Verificar Perguntas
   //
   Pergunte(cPerg, .F.)
   //
   wnRel := SetPrint(cString, wnRel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)
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
   If Mv_Par17 >= 1 .And. Mv_Par17 <= 6
      nMeses := Mv_Par17
   Else
      nMeses := 6
   Endif
   //
   If Mv_Par01 > Mv_Par02 .Or. Empty(Mv_Par02) .Or. Mv_Par03 > Mv_Par04 .Or. Empty(Mv_Par04) .Or.;
         Mv_Par05 > Mv_Par06 .Or. Empty(Mv_Par06) .Or. Mv_Par12 > Mv_Par13 .Or. Empty(Mv_Par13) .Or.;
         Mv_Par15 > Mv_Par16 .Or. Empty(Mv_Par16)
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
      If File(cArqSai) .And. Mv_Par09 == 1
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
   SF2->(DbSetOrder(1))                   // Cabecalho de Notas Fiscais de Saida
   SD2->(DbSetOrder(5))                   // Itens de Notas Fiscais de Saida
   SB1->(DbSetOrder(1))                   // Produtos
   SB2->(DbSetOrder(1))                   // Saldos em Estoque
   SBM->(DbSetOrder(1))                   // Grupos de Produtos
   SF4->(DbSetOrder(1))                   // Tipos de Entrada/Saida
   SYA->(DbSetOrder(1))                   // Paises
   //
   cAnoMesRef := Substr(Dtos(dDataBase), 1, 6)                // Mes/Ano Atual (Ex.: "200706")
   dDataAux   := Stod(cAnoMesRef + "01")                      // Primeiro Dia do Mes Atual (Ex.: "20070601")
   dDatIniRef := (dDataAux - (nMeses * 30))                   // Data Inicial Retroativa a "N" Meses do Mes/Ano Atual (Ex.: "20061203")
   dDatIniRef := Stod(Substr(Dtos(dDatIniRef), 1, 6) + "01")  // Ajuste da Data Inicial p/ o Primeiro Dia do Mes (Ex.: "20061201")
   dDatFimRef := (dDataAux - 1)                               // Data Final p/ Apuracao (Ex.: "20070531")
   //
   cAnoMes01 := Space(6)             // Meses de Apuracao no Formato Ano/Mes ("AAAAMM")
   cAnoMes02 := Space(6)
   cAnoMes03 := Space(6)
   cAnoMes04 := Space(6)
   cAnoMes05 := Space(6)
   cAnoMes06 := Space(6)
   cAnoMes07 := Space(6)
   cAnoMes08 := Space(6)
   cAnoMes09 := Space(6)
   cAnoMes10 := Space(6)
   cAnoMes11 := Space(6)
   cAnoMes12 := Space(6)
   //
   For x := 1 To 12                  // Obtencao dos Meses de Apuracao
      //
      If x == 1 .And. x <= nMeses
         //
         cAnoMes01 := Substr(Dtos(dDatIniRef), 1, 6)
         //
      Elseif x == 2 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 45)
         cAnoMes02 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 3 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 75)
         cAnoMes03 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 4 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 105)
         cAnoMes04 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 5 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 135)
         cAnoMes05 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 6 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 165)
         cAnoMes06 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 7 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 195)
         cAnoMes07 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 8 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 225)
         cAnoMes08 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 9 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 255)
         cAnoMes09 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 10 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 285)
         cAnoMes10 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 11 .And. x <= nMeses
         //
         dDatRefer := (dDatIniRef + 315)
         cAnoMes11 := Substr(Dtos(dDatRefer), 1, 6)
         //
      Elseif x == 12 .And. x <= nMeses
         //
         cAnoMes12 := Substr(Dtos(dDatFimRef), 1, 6)
         //
      Endif
      //
   Next x
   //
   cMesAno01 := MudaMesAno(cAnoMes01)     // Obtencao do Cabecalho p/ os Meses no Formato Mes/Ano ("MMM/AAAA")
   cMesAno02 := MudaMesAno(cAnoMes02)
   cMesAno03 := MudaMesAno(cAnoMes03)
   cMesAno04 := MudaMesAno(cAnoMes04)
   cMesAno05 := MudaMesAno(cAnoMes05)
   cMesAno06 := MudaMesAno(cAnoMes06)
   cMesAno07 := MudaMesAno(cAnoMes07)
   cMesAno08 := MudaMesAno(cAnoMes08)
   cMesAno09 := MudaMesAno(cAnoMes09)
   cMesAno10 := MudaMesAno(cAnoMes10)
   cMesAno11 := MudaMesAno(cAnoMes11)
   cMesAno12 := MudaMesAno(cAnoMes12)
   //
   cMeses := Space(2) + cMesAno01 + Space(6) + cMesAno02 + Space(6) + cMesAno03 + Space(6) + cMesAno04 + Space(6) + cMesAno05 + Space(6) + cMesAno06 + Space(1)
   //
   If VerCodPais()                        // Verificar a Existencia do Campo Referente ao Codigo do Pais na Tabela de Produtos
      lCodPais := .T.
   Endif
   //
   cNomArq  := ""                         // Arquivo Temporario de Trabalho
   cIndArq1 := ""
   aCampos  := {}
   //
   Aadd(aCampos, {"CODPRO", "C", 15, 0})  // Codigo do Produto
   Aadd(aCampos, {"DESPRO", "C", 40, 0})  // Descricao do Produto
   Aadd(aCampos, {"UNIMED", "C", 02, 0})  // Unidade de Medida do Produto
   Aadd(aCampos, {"TIPPRO", "C", 02, 0})  // Tipo de Produto
   Aadd(aCampos, {"GRUPRO", "C", 04, 0})  // Grupo de Produto
   Aadd(aCampos, {"DESGRU", "C", 30, 0})  // Descricao do Grupo de Produtos
   Aadd(aCampos, {"CONS01", "N", 15, 3})  // Quantidade Consumida/Vendida no Mes 01
   Aadd(aCampos, {"CONS02", "N", 15, 3})  // Quantidade Consumida/Vendida no Mes 02
   Aadd(aCampos, {"CONS03", "N", 15, 3})  // Quantidade Consumida/Vendida no Mes 03
   Aadd(aCampos, {"CONS04", "N", 15, 3})  // Quantidade Consumida/Vendida no Mes 04
   Aadd(aCampos, {"CONS05", "N", 15, 3})  // Quantidade Consumida/Vendida no Mes 05
   Aadd(aCampos, {"CONS06", "N", 15, 3})  // Quantidade Consumida/Vendida no Mes 06
   Aadd(aCampos, {"QTDTOT", "N", 15, 3})  // Quantidade Consumida/Vendida Total
   Aadd(aCampos, {"NROMES", "N", 03, 0})  // Numero de Meses p/ a Media de Consumo
   Aadd(aCampos, {"QTDMED", "N", 15, 3})  // Quantidade Media de Consumo
   Aadd(aCampos, {"QTDEST", "N", 15, 3})  // Quantidade Atual em Estoque
   Aadd(aCampos, {"MESPRO", "N", 15, 3})  // Numero de Meses Projetados p/ Duracao do Estoque
   //
   If Select("TRB") > 0
      TRB->(DbCloseArea())
   Endif
   // //
   // cNomArq := CriaTrab(aCampos, .T.)
   // DbUseArea(.T.,, cNomArq, "TRB", .T., .F.)
   // //
   // cIndArq1 := CriaTrab(Nil, .F.)
   // cChavInd := "TRB->CODPRO"
   // //
   // IndRegua("TRB", cIndArq1, cChavInd,,, "Selecionando Registros ...")
   // //
   // DbSelectArea("TRB")
   // DbSetIndex(cIndArq1 + OrdBagExt())
   // //

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

   DbSelectArea("SD2")
   ProcRegua(SD2->(LastRec()))
   SD2->(DbSeek(xFilial("SD2") + Dtos(dDatIniRef), .T.))
   //
   While SD2->(!Eof()) .And. SD2->D2_FILIAL == xFilial("SD2") .And. Dtos(SD2->D2_EMISSAO) <= Dtos(dDatFimRef)
      //
      IncProc("Consumo / Vendas -> " + Dtoc(SD2->D2_EMISSAO))
      //
      If !(SD2->D2_TIPO $ "N,")        // Apenas NF do Tipo Normal
         //
         SD2->(DbSkip())
         Loop
         //
      Endif
      //
      If !Empty(cFiltro)               // Verifica Filtro do Usuario
         //
         DbSelectArea("SD2")
         If !(&cFiltro)
            //
            SD2->(DbSkip())
            Loop
            //
         Endif
         //
      Endif
      //
      SF2->(DbSeek(xFilial("SF2") + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA, .F.))
      //
      If SF2->(!Found())
         //
         SD2->(DbSkip())
         Loop
         //
      Endif
      //
      SA1->(DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA, .F.))
      //
      SB1->(DbSeek(xFilial("SB1") + SD2->D2_COD, .F.))
      //
      If SB1->(!Found())
         //
         SD2->(DbSkip())
         Loop
         //
      Endif
      //
      If SB1->B1_COD < Mv_Par01 .Or. SB1->B1_COD > Mv_Par02 .Or.;
            SB1->B1_TIPO < Mv_Par03 .Or. SB1->B1_TIPO > Mv_Par04 .Or.;
            SB1->B1_GRUPO < Mv_Par05 .Or. SB1->B1_GRUPO > Mv_Par06
         //
         SD2->(DbSkip())
         Loop
         //
      Endif
      //
      If lCodPais                      // Campo de Codigo de Pais Existente
         //
         SYA->(DbSeek(xFilial("SYA") + SB1->B1_CODPAIS, .F.))
         //
         If SB1->B1_CODPAIS < Mv_Par15 .Or. SB1->B1_CODPAIS > Mv_Par16
            //
            SD2->(DbSkip())
            Loop
            //
         Endif
         //
      Endif
      //
      SBM->(DbSeek(xFilial("SBM") + SB1->B1_GRUPO, .F.))
      //
      SF4->(DbSeek(xFilial("SF4") + SD2->D2_TES, .F.))
      //
      If SF4->(!Found())
         //
         SD2->(DbSkip())
         Loop
         //
      Endif
      //
      If SF4->F4_ESTOQUE # "S"         // Apenas TES c/ Movimentacao de Estoque
         //
         SD2->(DbSkip())
         Loop
         //
      Endif
      //
      xCODPRO := SB1->B1_COD
      xDESPRO := Upper(SB1->B1_DESC)
      xUNIMED := SB1->B1_UM
      xTIPPRO := SB1->B1_TIPO
      xGRUPRO := SB1->B1_GRUPO
      xDESGRU := Upper(SBM->BM_DESC)
      //
      xCONS01 := 0
      xCONS02 := 0
      xCONS03 := 0
      xCONS04 := 0
      xCONS05 := 0
      xCONS06 := 0
      xQTDTOT := 0
      xNROMES := 0
      xQTDMED := 0
      xQTDEST := 0
      xMESPRO := 0
      //
      cAnoMesFat := Substr(Dtos(SD2->D2_EMISSAO), 1, 6)    // Ano/Mes do Faturamento
      //
      If cAnoMesFat == cAnoMes01
         //
         xCONS01 := SD2->D2_QUANT
         xQTDTOT := SD2->D2_QUANT
         //
      Elseif cAnoMesFat == cAnoMes02
         //
         xCONS02 := SD2->D2_QUANT
         xQTDTOT := SD2->D2_QUANT
         //
      Elseif cAnoMesFat == cAnoMes03
         //
         xCONS03 := SD2->D2_QUANT
         xQTDTOT := SD2->D2_QUANT
         //
      Elseif cAnoMesFat == cAnoMes04
         //
         xCONS04 := SD2->D2_QUANT
         xQTDTOT := SD2->D2_QUANT
         //
      Elseif cAnoMesFat == cAnoMes05
         //
         xCONS05 := SD2->D2_QUANT
         xQTDTOT := SD2->D2_QUANT
         //
      Elseif cAnoMesFat == cAnoMes06
         //
         xCONS06 := SD2->D2_QUANT
         xQTDTOT := SD2->D2_QUANT
         //
      Endif
      //
      GravarTRB()
      //
      SD2->(DbSkip())
      //
   Enddo
   //
   SD2->(DbSetOrder(1))
   //
   DbSelectArea("TRB")                    // Calcular a Projecao do Estoque
   ProcRegua(TRB->(LastRec()))
   TRB->(DbGoTop())
   //
   While TRB->(!Eof())
      //
      IncProc("Projetando -> " + TRB->CODPRO)
      //
      SB1->(DbSeek(xFilial("SB1") + TRB->CODPRO, .F.))
      //
      xQTDTOT := TRB->QTDTOT           // Quantidade Total Consumida/Vendida
      xNROMES := 0                     // Numero de Meses p/ Media
      xQTDMED := 0                     // Quantidade Media Consumida/Vendida
      xQTDEST := SaldoAtual()          // Quantidade Atual em Estoque
      xMESPRO := 0                     // Numero de Meses Projetados p/ Duracao do Estoque
      //
      If (TRB->CONS01 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 1      // Se Existe Consumo ou Entra Mes Zerado p/ a Media
         xNROMES += 1
      Endif
      //
      If (TRB->CONS02 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 2
         xNROMES += 1
      Endif
      //
      If (TRB->CONS03 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 3
         xNROMES += 1
      Endif
      //
      If (TRB->CONS04 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 4
         xNROMES += 1
      Endif
      //
      If (TRB->CONS05 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 5
         xNROMES += 1
      Endif
      //
      If (TRB->CONS06 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 6
         xNROMES += 1
      Endif
      //
      xQTDMED := (xQTDTOT / IIf(xNROMES == 0, 1, xNROMES))
      //
      xMESPRO := (xQTDEST / IIf(xQTDMED == 0, 1, xQTDMED))
      //
      If Mv_Par08 == 1                 // Arredonda o Numero de Meses Projetados
         xMESPRO := Round(xMESPRO, 0)
      Endif
      //
      DbSelectArea("TRB")
      If TRB->(Reclock("TRB", .F.))
         //
         TRB->NROMES := xNROMES
         TRB->QTDMED := xQTDMED
         TRB->QTDEST := xQTDEST
         TRB->MESPRO := xMESPRO
         //
         TRB->(MsUnlock())
         //
      Endif
      //
      TRB->(DbSkip())
      //
   Enddo
   //
Return (.T.)

///////////////////////////
Static Function GravarTRB()
   ///////////////////////////
   //
   TRB->(DbSeek(xCODPRO, .F.))
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
         TRB->CODPRO := xCODPRO
         TRB->DESPRO := xDESPRO
         TRB->UNIMED := xUNIMED
         TRB->TIPPRO := xTIPPRO
         TRB->GRUPRO := xGRUPRO
         TRB->DESGRU := xDESGRU
         //
      Endif
      //
      TRB->CONS01 += xCONS01
      TRB->CONS02 += xCONS02
      TRB->CONS03 += xCONS03
      TRB->CONS04 += xCONS04
      TRB->CONS05 += xCONS05
      TRB->CONS06 += xCONS06
      TRB->QTDTOT += xQTDTOT
      //
      TRB->NROMES := xNROMES
      TRB->QTDMED := xQTDMED
      TRB->QTDEST := xQTDEST
      TRB->MESPRO := xMESPRO
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
      cOrdemImp := " - Por Codigo de Produto"
   Elseif Mv_Par11 == 2
      cOrdemImp := " - Por Descricao de Produto"
   Elseif Mv_Par11 == 3
      cOrdemImp := " - Por Quantidade Media de Consumo"
   Elseif Mv_Par11 == 4
      cOrdemImp := " - Por Meses p/ Duracao do Estoque"
   Else
      cOrdemImp := ""
   Endif
   //
   Titulo := "Projecao de Duracao do Estoque pelo Consumo de Vendas Referente a " + MudaMesAno(Substr(Dtos(dDataBase), 1, 6)) + cOrdemImp
   Cabec1 := "Codigo           Descricao do Produto                     Unid.   ------------------------- Quantidade Consumida  -----------------------     Quantidade   Nro. de    Quantidade     Quantidade  Meses p/ Duracao"
   //                                                                          "  XXX/9999      XXX/9999      XXX/9999      XXX/9999      XXX/9999      XXX/9999 "
   Cabec2 := "do Produto                                                         " + cMeses                                                                    + "       Total      Meses        Media       em Estoque     do Estoque   "
   //         XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XX    999.999.999   999.999.999   999.999.999   999.999.999   999.999.999   999.999.999    999.999.999     999    999.999.999,9   999.999.999     9.999.999,9
   Li     := 66
   nTipo  := IIf(aReturn[4] == 1, 15, 18)
   cTraco := Replicate("-", Limite)
   //
   SetPrc(0, 0)
   //
   If Mv_Par11 > 1                        // Ordem de Impressao (1=Codigo de Produto, 2=Descricao de Produto, 3=Media de Consumo, 4=Meses p/ Duracao do Estoque)
      //
      If Mv_Par11 == 2
         cChavInd := "TRB->DESPRO"
      Elseif Mv_Par11 == 3
         cChavInd := "Descend(Str(TRB->QTDMED, 15, 3))"
      Elseif Mv_Par11 == 4
         cChavInd := "Descend(Str(TRB->MESPRO, 15, 3))"
      Else
         cChavInd := "TRB->CODPRO"
      Endif
      //
      cIndArq2 := CriaTrab(Nil, .F.)
      IndRegua("TRB", cIndArq2, cChavInd,,, "Selecionando Registros...")
      //
      DbSelectArea("TRB")
      DbSetIndex(cIndArq2 + OrdBagExt())
      //
   Endif
   //
   nQtdMes01 := 0                         // Totais do Relatorio
   nQtdMes02 := 0
   nQtdMes03 := 0
   nQtdMes04 := 0
   nQtdMes05 := 0
   nQtdMes06 := 0
   nQtdTotal := 0
   nNroMeses := 0
   nQtdMedia := 0
   nQtdEstoq := 0
   nMesProje := 0
   //
   DbSelectArea("TRB")                    // Impressao dos Dados
   SetRegua(TRB->(LastRec()))
   TRB->(DbGoTop())
   //
   While TRB->(!Eof())
      //
      IncRegua()
      //
      If lAbortPrint
         Exit
      Endif
      //
      If Li > 56
         Li := Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo) + 1
      Endif
      //
      @ Li, 000 Psay Substr(TRB->CODPRO, 1, 15)
      @ Li, 017 Psay Substr(TRB->DESPRO, 1, 40)
      @ Li, 060 Psay Substr(TRB->UNIMED, 1, 2)
      //
      If nMeses >= 1
         @ Li, 066 Psay Transform(TRB->CONS01, "@E 999,999,999")
      Endif
      //
      If nMeses >= 2
         @ Li, 080 Psay Transform(TRB->CONS02, "@E 999,999,999")
      Endif
      //
      If nMeses >= 3
         @ Li, 094 Psay Transform(TRB->CONS03, "@E 999,999,999")
      Endif
      //
      If nMeses >= 4
         @ Li, 108 Psay Transform(TRB->CONS04, "@E 999,999,999")
      Endif
      //
      If nMeses >= 5
         @ Li, 122 Psay Transform(TRB->CONS05, "@E 999,999,999")
      Endif
      //
      If nMeses >= 6
         @ Li, 136 Psay Transform(TRB->CONS06, "@E 999,999,999")
      Endif
      //
      @ Li, 151 Psay Transform(TRB->QTDTOT, "@E 999,999,999")
      @ Li, 167 Psay Transform(TRB->NROMES, "@E 999")
      @ Li, 174 Psay Transform(TRB->QTDMED, "@E 999,999,999.9")
      @ Li, 190 Psay Transform(TRB->QTDEST, "@E 999,999,999")
      @ Li, 206 Psay Transform(TRB->MESPRO, "@E 9,999,999.9")
      Li += 1
      //
      nQtdMes01 += TRB->CONS01
      nQtdMes02 += TRB->CONS02
      nQtdMes03 += TRB->CONS03
      nQtdMes04 += TRB->CONS04
      nQtdMes05 += TRB->CONS05
      nQtdMes06 += TRB->CONS06
      nQtdTotal += TRB->QTDTOT
      nQtdEstoq += TRB->QTDEST
      //
      TRB->(DbSkip())
      //
      If TRB->(Eof())
         //
         nNroMeses := 0
         nQtdMedia := 0
         nMesProje := 0
         //
         If (nQtdMes01 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 1     // Se Existe Consumo ou Entra Mes Zerado p/ a Media
            nNroMeses += 1
         Endif
         //
         If (nQtdMes02 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 2
            nNroMeses += 1
         Endif
         //
         If (nQtdMes03 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 3
            nNroMeses += 1
         Endif
         //
         If (nQtdMes04 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 4
            nNroMeses += 1
         Endif
         //
         If (nQtdMes05 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 5
            nNroMeses += 1
         Endif
         //
         If (nQtdMes06 > 0 .Or. Mv_Par07 == 1) .And. nMeses >= 6
            nNroMeses += 1
         Endif
         //
         nQtdMedia := (nQtdTotal / IIf(nNroMeses == 0, 1, nNroMeses))
         nMesProje := (nQtdEstoq / IIf(nQtdMedia == 0, 1, nQtdMedia))
         //
         If Mv_Par08 == 1              // Arredonda o Numero de Meses Projetados
            nMesProje := Round(nMesProje, 0)
         Endif
         //
         If Li > 56
            Li := Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo) + 1
         Endif
         //
         Li += 1
         @ Li, 017 Psay "Total Apurado -------------------------------->"
         //
         If nMeses >= 1
            @ Li, 066 Psay Transform(nQtdMes01, "@E 999,999,999")
         Endif
         //
         If nMeses >= 2
            @ Li, 080 Psay Transform(nQtdMes02, "@E 999,999,999")
         Endif
         //
         If nMeses >= 3
            @ Li, 094 Psay Transform(nQtdMes03, "@E 999,999,999")
         Endif
         //
         If nMeses >= 4
            @ Li, 108 Psay Transform(nQtdMes04, "@E 999,999,999")
         Endif
         //
         If nMeses >= 5
            @ Li, 122 Psay Transform(nQtdMes05, "@E 999,999,999")
         Endif
         //
         If nMeses >= 6
            @ Li, 136 Psay Transform(nQtdMes06, "@E 999,999,999")
         Endif
         //
         @ Li, 151 Psay Transform(nQtdTotal, "@E 999,999,999")
         @ Li, 167 Psay Transform(nNroMeses, "@E 999")
         @ Li, 174 Psay Transform(nQtdMedia, "@E 999,999,999.9")
         @ Li, 190 Psay Transform(nQtdEstoq, "@E 999,999,999")
         @ Li, 206 Psay Transform(nMesProje, "@E 9,999,999.9")
         Li += 2
         @ Li, 017 Psay "(Do Tipo " + Alltrim(Mv_Par03) + " ao " + Alltrim(Mv_Par04) + ", do Grupo " + Alltrim(Mv_Par05) +;
            " ao " + Alltrim(Mv_Par06) + ", do Pais " + Alltrim(Mv_Par15) + " ao " + Alltrim(Mv_Par16) + ")"
         Li += 1
         //
         If lRodape
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
   cArqSai := Alltrim(Mv_Par10)           // Arquivo de Saida Informado
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
   FErase(cIndArq2 + OrdBagExt())
   //
Return (.T.)

////////////////////////////////////
Static Function MudaMesAno(_cAnoMes)
   ////////////////////////////////////
   //
   _cMesAno := Space(8)              // Retornar no Formato Mes/Ano ("MMM/AAAA")
   //
   If Substr(_cAnoMes, 5, 2) == "01"
      _cMesAno := "Jan/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "02"
      _cMesAno := "Fev/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "03"
      _cMesAno := "Mar/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "04"
      _cMesAno := "Abr/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "05"
      _cMesAno := "Mai/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "06"
      _cMesAno := "Jun/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "07"
      _cMesAno := "Jul/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "08"
      _cMesAno := "Ago/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "09"
      _cMesAno := "Set/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "10"
      _cMesAno := "Out/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "11"
      _cMesAno := "Nov/" + Substr(_cAnoMes, 1, 4)
   Elseif Substr(_cAnoMes, 5, 2) == "12"
      _cMesAno := "Dez/" + Substr(_cAnoMes, 1, 4)
   Endif
   //
Return (_cMesAno)

////////////////////////////
Static Function SaldoAtual()
   ////////////////////////////
   //
   Local xB2_QATU := 0                    // Saldo Atual do Produto
   //
   SB2->(DbSeek(xFilial("SB2") + SB1->B1_COD, .F.))
   //
   While SB2->(!Eof()) .And. SB2->B2_FILIAL == xFilial("SB2") .And. SB2->B2_COD == SB1->B1_COD
      //
      If Mv_Par14 == 1                 // Apenas o Local Padrao
         //
         If SB2->B2_LOCAL == SB1->B1_LOCPAD
            xB2_QATU += SB2->B2_QATU
         Endif
         //
      Else
         //
         If SB2->B2_LOCAL >= Mv_Par12 .And. SB2->B2_LOCAL <= Mv_Par13
            xB2_QATU += SB2->B2_QATU
         Endif
         //
      Endif
      //
      SB2->(DbSkip())
      //
   Enddo
   //
Return (xB2_QATU)

////////////////////////////
Static Function VerCodPais()
   ////////////////////////////
   //
   Local i        := 0                    // Variaveis Auxiliares
   Local lRetorno := .F.                  // Status de Campo Existente na Base ou Nao
   //
   DbSelectArea("SB1")                    // Produtos
   //
   For i := 1 To FCount()                 // Captar os Campos do Arquivo
      //
      cNomeCampo := Upper(Alltrim(FieldName(i)))
      cConteudo  := FieldGet(i)
      nPosicao   := FieldPos(cNomeCampo)
      //
      If (cNomeCampo == "B1_CODPAIS" .And. Len(cConteudo) == 3)
         //
         lRetorno := .T.
         Exit
         //
      Endif
      //
   Next
   //
   If !(lRetorno)
      MsgBox("Criar o Campo B1_CODPAIS (C, 3) na Tabela de Produtos (SB1) Referente ao Código do País !!!", "Atenção !!!", "INFO")
   Endif
   //
Return (lRetorno)

///////////////////////////
Static Function Perguntas()
   ///////////////////////////
   //
   Local sAlias := Alias()                // Variaveis Auxiliares
   Local aRegs  := {}
   //
   SX1->(DbSetOrder(1))                   // Perguntas do Sistema
   //
   Aadd(aRegs,{cPerg,"01","Do Codigo do Produto         ?","","","mv_cha","C",15,0,0,"G","",;
      "Mv_Par01","","","","               ","","","","","","","","","","","","","","","","","","","","","SB1","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"02","Ate o Codigo do Produto      ?","","","mv_chb","C",15,0,0,"G","NaoVazio()",;
      "Mv_Par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"03","Do Tipo de Produto           ?","","","mv_chc","C",02,0,0,"G","",;
      "Mv_Par03","","","","  ","","","","","","","","","","","","","","","","","","","","","02","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"04","Ate o Tipo de Produto        ?","","","mv_chd","C",02,0,0,"G","NaoVazio()",;
      "Mv_Par04","","","","ZZ","","","","","","","","","","","","","","","","","","","","","02","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"05","Do Grupo de Produtos         ?","","","mv_che","C",04,0,0,"G","",;
      "Mv_Par05","","","","    ","","","","","","","","","","","","","","","","","","","","","SBM","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"06","Ate o Grupo de Produtos      ?","","","mv_chf","C",04,0,0,"G","NaoVazio()",;
      "Mv_Par06","","","","ZZZZ","","","","","","","","","","","","","","","","","","","","","SBM","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"07","Entra Mes Zerado na Media    ?","","","mv_chg","N",01,0,2,"C","",;
      "Mv_Par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"08","Arredonda Projecao de Est.   ?","","","mv_chh","N",01,0,1,"C","",;
      "Mv_Par08","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"09","Mostrar Planilha Excel       ?","","","mv_chi","N",01,0,2,"C","",;
      "Mv_Par09","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"10","Arquivo de Saida p/ Excel    ?","","","mv_chj","C",40,0,0,"G","NaoVazio()",;
      "Mv_Par10","","","","C:\TEMP\PROJCOMP.DBF","","","","","","","","","","","","","","","","","","","","","DIR","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"11","Ordem de Impressao           ?","","","mv_chk","N",01,0,1,"C","",;
      "Mv_Par11","Codigo de Prod.","","","","","Descricao Prod.","","","","","Media Consumo","","","","","Meses Estoque","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"12","Do Armazem/Almoxarifado      ?","","","mv_chl","C",02,0,0,"G","",;
      "Mv_Par12","","","","  ","","","","","","","","","","","","","","","","","","","","","AL","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"13","Ate o Armazem/Almoxarifado   ?","","","mv_chm","C",02,0,0,"G","NaoVazio()",;
      "Mv_Par13","","","","ZZ","","","","","","","","","","","","","","","","","","","","","AL","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"14","Apenas o Local Padrao        ?","","","mv_chn","N",01,0,2,"C","",;
      "Mv_Par14","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"15","Do Codigo do Pais            ?","","","mv_cho","C",03,0,0,"G","",;
      "Mv_Par15","","","","   ","","","","","","","","","","","","","","","","","","","","","SYA","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"16","Ate o Codigo do Pais         ?","","","mv_chp","C",03,0,0,"G","NaoVazio()",;
      "Mv_Par16","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SYA","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"17","Nro. de Meses Retroativos    ?","","","mv_chq","N",02,0,0,"G","Entre(1,6)",;
      "Mv_Par17","","","","6","","","","","","","","","","","","","","","","","","","","","SYA","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"18","Do Fornecedor                ?","","","mv_chr","C",06,0,0,"G","NaoVazio()",;
      "Mv_Par18","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA2","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"19","Ate o Fornecedor             ?","","","mv_chs","C",06,0,0,"G","NaoVazio()",;
      "Mv_Par19","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","","","","","","","","","","","","","","","","","",""})





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
   /*For i := 1 To Len(aRegs)          // Regravar as Perguntas
    //
    SX1->(DbSeek(cPerg + aRegs[i, 2]))
    //
    If SX1->(Found()) .And. Empty(SX1->X1_CNT01)
       //
       DbSelectArea("SX1")
       If SX1->(Reclock("SX1", .F.))
          //
          If (i == 1 .Or. i == 3 .Or. i == 5 .Or. i == 12 .Or. i == 15)
             SX1->X1_CNT01 := SX1->X1_CNT01
          Endif
          //
          If i == 2
             SX1->X1_CNT01 := "ZZZZZZZZZZZZZZZ"
          Endif
          //
          If (i == 4 .Or. i == 13)
             SX1->X1_CNT01 := "ZZ"
          Endif
          //
          If i == 6
             SX1->X1_CNT01 := "ZZZZ"
          Endif
          //
          If (i == 7 .Or. i == 8 .Or. i == 9 .Or. i == 11 .Or. i == 14)
             SX1->X1_PRESEL := SX1->X1_PRESEL
          Endif
          //
          If i == 10
             SX1->X1_CNT01 := "C:\TEMP\PROJCOMP.DBF"
          Endif
          //
          If i == 16
             SX1->X1_CNT01 := "ZZZ"
          Endif
          //
          If i == 17
             SX1->X1_CNT01 := "6"
          Endif
          //
          SX1->(MsUnlock())
          //
       Endif
       //
    Endif
    //
   Next  */
   //
   DbSelectArea(sAlias)
   //
Return (.T.)
