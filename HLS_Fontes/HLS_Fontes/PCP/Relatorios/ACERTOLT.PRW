#include "rwmake.ch"

/*/{Protheus.doc} AcertoLt

Este relatório irá emitir uma relação de saldos por lote de produtos para acerto de saldos por lote.

@type function
@author Honda Lock
@since 01/10/2017

/*/

////////////////////////
User Function AcertoLt()
   ////////////////////////
   //
   Private wnRel       := "AcertoLt"
   Private Titulo      := "Acerto de Saldos por Lote"
   Private cDesc1      := "Este relatório irá emitir uma relação de saldos por lote de produtos."
   Private cDesc2      := ""
   Private cDesc3      := ""
   Private Tamanho     := "G"
   Private Limite      := 220
   Private lAbortPrint := .F.
   Private cString     := "SB1"
   Private lContinua   := .T.
   Private aReturn     := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
   Private Nomeprog    := "AcertoLt"
   Private nCntImpr    := 0
   Private cRodaTxt    := ""
   Private lRodape     := .T.
   Private cFiltro     := ""
   Private Li          := 66
   Private m_Pag       := 1
   Private Cabec1      := ""
   Private Cabec2      := ""
   Private nLastKey    := 0
   Private cPerg       := "ACSLOT    "
   Private aCampos     := {}
   Private cNomArq     := ""
   Private cIndArq1    := ""
   Private cArqSai     := ""              // Arquivo de Saida p/ Excel
   //
   Perguntas()                            // Criar as Perguntas
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
   cFiltro := IIf(!Empty(aReturn[7]), aReturn[7], "")
   //
   Processa({|| Processar()}, Titulo)
   //
   RptStatus({|lAbortPrint| Relatorio()}, Titulo)
   //
   If File(cArqSai) .And. Mv_Par04 == 1
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
Return (.T.)

///////////////////////////
Static Function Processar()
   ///////////////////////////
   //
   SB2->(DbSetOrder(1))                   // Saldos em Estoque
   SB8->(DbSetOrder(1))                   // Saldos por Lote
   SB9->(DbSetOrder(1))                   // Saldos Iniciais
   SBJ->(DbSetOrder(1))                   // Saldos Iniciais por Lote
   SB1->(DbSetOrder(1))                   // Produtos
   //
   cNomArq  := ""                         // Arquivo Temporario de Trabalho
   cIndArq1 := ""
   aCampos  := {}
   //
   Aadd(aCampos, {"CODPRO", "C", 15, 0})  // Codigo do Produto
   Aadd(aCampos, {"DESPRO", "C", 40, 0})  // Descricao do Produto
   Aadd(aCampos, {"CODLOC", "C", 02, 0})  // Codigo do Local ou Almoxarifado
   Aadd(aCampos, {"QTDSB9", "N", 15, 3})  // Quantidade do Saldo Inicial
   Aadd(aCampos, {"QTDSBJ", "N", 15, 3})  // Quantidade do Saldo Inicial por Lote
   Aadd(aCampos, {"DIFINI", "N", 15, 3})  // Quantidade da Diferencao do Saldo Inicial
   Aadd(aCampos, {"QTDSB2", "N", 15, 3})  // Quantidade do Saldo Atual
   Aadd(aCampos, {"QTDSB8", "N", 15, 3})  // Quantidade do Saldo Atual por Lote
   Aadd(aCampos, {"DIFATU", "N", 15, 3})  // Quantidade da Diferencao do Saldo Atual
   //
   If Select("TRB") > 0
      TRB->(DbCloseArea())
   Endif
   // //
   // cNomArq := CriaTrab(aCampos, .T.)
   // DbUseArea(.T.,, cNomArq, "TRB", .T., .F.)
   // //
   // cIndArq1 := CriaTrab(Nil, .F.)
   // cChavInd := "TRB->CODPRO + TRB->CODLOC"
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
   oTable:AddIndex( '01' , { "TRB->CODPRO + TRB->CODLOC" })
   // Crio a tabela no banco de dados
   oTable:Create()
   //------------------------------------
   //Pego o alias da tabela temporária
   //------------------------------------
   cNomArq := oTable:GetAlias()



   DbSelectArea("SB1")
   ProcRegua(SB1->(LastRec()))
   SB1->(DbSeek(xFilial("SB1") + Mv_Par01, .T.))
   //
   While SB1->(!Eof()) .And. SB1->B1_FILIAL == xFilial("SB1") .And. SB1->B1_COD <= Mv_Par02
      //
      IncProc("Saldos do Produto -> " + Alltrim(SB1->B1_COD))
      //
      If SB1->B1_RASTRO # "L"
         //
         SB1->(DbSkip())
         Loop
         //
      Endif
      //
      SB2->(DbSeek(xFilial("SB2") + SB1->B1_COD, .F.))
      //
      While SB2->(!Eof()) .And. SB2->B2_FILIAL == xFilial("SB2") .And. SB2->B2_COD == SB1->B1_COD
         //
         xCODPRO := SB2->B2_COD
         xDESPRO := SB1->B1_DESC
         xCODLOC := SB2->B2_LOCAL
         xQTDSB9 := 0
         xQTDSBJ := 0
         xQTDSB2 := SB2->B2_QATU
         xQTDSB8 := 0
         //
         GravarTRB()
         //
         SB2->(DbSkip())
         //
      Enddo
      //
      SB8->(DbSeek(xFilial("SB8") + SB1->B1_COD, .F.))
      //
      While SB8->(!Eof()) .And. SB8->B8_FILIAL == xFilial("SB8") .And. SB8->B8_PRODUTO == SB1->B1_COD
         //
         xCODPRO := SB8->B8_PRODUTO
         xDESPRO := SB1->B1_DESC
         xCODLOC := SB8->B8_LOCAL
         xQTDSB9 := 0
         xQTDSBJ := 0
         xQTDSB2 := 0
         xQTDSB8 := SB8->B8_SALDO
         //
         GravarTRB()
         //
         SB8->(DbSkip())
         //
      Enddo
      //
      SB9->(DbSeek(xFilial("SB9") + SB1->B1_COD, .F.))
      //
      While SB9->(!Eof()) .And. SB9->B9_FILIAL == xFilial("SB9") .And. SB9->B9_COD == SB1->B1_COD
         //
         If SB9->B9_DATA # Mv_Par03
            //
            SB9->(DbSkip())
            Loop
            //
         Endif
         //
         xCODPRO := SB9->B9_COD
         xDESPRO := SB1->B1_DESC
         xCODLOC := SB9->B9_LOCAL
         xQTDSB9 := SB9->B9_QINI
         xQTDSBJ := 0
         xQTDSB2 := 0
         xQTDSB8 := 0
         //
         GravarTRB()
         //
         SB9->(DbSkip())
         //
      Enddo
      //
      SBJ->(DbSeek(xFilial("SBJ") + SB1->B1_COD, .F.))
      //
      While SBJ->(!Eof()) .And. SBJ->BJ_FILIAL == xFilial("SBJ") .And. SBJ->BJ_COD == SB1->B1_COD
         //
         If SBJ->BJ_DATA # Mv_Par03
            //
            SBJ->(DbSkip())
            Loop
            //
         Endif
         //
         xCODPRO := SBJ->BJ_COD
         xDESPRO := SB1->B1_DESC
         xCODLOC := SBJ->BJ_LOCAL
         xQTDSB9 := 0
         xQTDSBJ := SBJ->BJ_QINI
         xQTDSB2 := 0
         xQTDSB8 := 0
         //
         GravarTRB()
         //
         SBJ->(DbSkip())
         //
      Enddo
      //
      SB1->(DbSkip())
      //
   Enddo
   //
Return (.T.)

///////////////////////////
Static Function GravarTRB()
   ///////////////////////////
   //
   TRB->(DbSeek(xCODPRO + xCODLOC, .F.))
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
         TRB->CODLOC := xCODLOC
         //
      Endif
      //
      TRB->QTDSB2 += xQTDSB2
      TRB->QTDSB8 += xQTDSB8
      TRB->DIFATU := (TRB->QTDSB2 - TRB->QTDSB8)
      TRB->QTDSB9 += xQTDSB9
      TRB->QTDSBJ += xQTDSBJ
      TRB->DIFINI := (TRB->QTDSB9 - TRB->QTDSBJ)
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
   Titulo := "Saldos em Estoque de " + Dtoc(Mv_Par03)
   Cabec1 := "Produto          Descricao do Produto                    Almox.   Saldo Inicial     Sal.Inic.Lote      Dif. Inicial       Saldo Atual     Sal.Atu.Lote         Dif. Atual  "
   Cabec2 := "                                                                      (SB9)              (SBJ)          (SB9 - SBJ)          (SB2)            (SB8)           (SB2 - SB8)  "
   //         XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX     999.999.999,999   999.999.999,999   999.999.999,999   999.999.999,999   999.999.999,999   999.999.999,999
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
   While TRB->(!Eof())
      //
      IncRegua()
      //
      If lAbortPrint
         Exit
      Endif
      //
      If Li > 58
         Li := Cabec(Titulo, Cabec1, Cabec2, Nomeprog, Tamanho, nTipo) + 1
      Endif
      //
      If Mv_Par06 == 1                 // Apenas Diferencas (1=Sim, 2=Nao)
         //
         If TRB->DIFINI == 0 .And. TRB->DIFATU == 0
            //
            TRB->(DbSkip())
            Loop
            //
         Endif
         //
      Endif
      //
      @ Li, 000 Psay Substr(TRB->CODPRO, 1, 15)
      @ Li, 017 Psay Substr(TRB->DESPRO, 1, 40)
      @ Li, 059 Psay Substr(TRB->CODLOC, 1, 2)
      @ Li, 066 Psay Transform(TRB->QTDSB9, "@E 999,999,999.999")
      @ Li, 084 Psay Transform(TRB->QTDSBJ, "@E 999,999,999.999")
      @ Li, 102 Psay Transform(TRB->DIFINI, "@E 999,999,999.999")
      @ Li, 120 Psay Transform(TRB->QTDSB2, "@E 999,999,999.999")
      @ Li, 138 Psay Transform(TRB->QTDSB8, "@E 999,999,999.999")
      @ Li, 156 Psay Transform(TRB->DIFATU, "@E 999,999,999.999")
      Li += 1
      //
      TRB->(DbSkip())
      //
      If TRB->(Eof())
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
   cArqSai := Alltrim(Mv_Par05)           // Arquivo de Saida Informado
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
   Aadd(aRegs,{cPerg,"01","Do Codigo do Produto         ?","","","mv_cha","C",15,0,0,"G","",;
      "Mv_Par01","","","","               ","","","","","","","","","","","","","","","","","","","","","SB1","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"02","Ate o Codigo do Produto      ?","","","mv_chb","C",15,0,0,"G","NaoVazio()",;
      "Mv_Par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"03","Data do Saldo do Estoque     ?","","","mv_chc","D",08,0,0,"G","",;
      "Mv_Par03","","","","31/05/07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"04","Mostrar Planilha Excel       ?","","","mv_chd","N",01,0,2,"C","",;
      "Mv_Par04","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"05","Arquivo de Saida p/ Excel    ?","","","mv_che","C",40,0,0,"G","NaoVazio()",;
      "Mv_Par05","","","","C:\TEMP\SALDOEST.DBF","","","","","","","","","","","","","","","","","","","","","DIR","","","","","","","","","","","","","","",""})
   Aadd(aRegs,{cPerg,"06","Apenas as Diferencas         ?","","","mv_chf","N",01,0,1,"C","",;
      "Mv_Par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
   DbSelectArea(sAlias)
   //
Return (.T.)

/////////////////////////////////////////////
Static Function AchaOrdem(_cArquivo, _cChave)
   /////////////////////////////////////////////
   //
   Local _sAlias := Alias()               // Area Corrente
   Local _cOrdem := "1"                   // Inicio da Pesquisa Sempre Pela Ordem "1"
   Local _nOrdem := 0                     // Ordem do Indice Desejado
   Local _lOkey  := .F.                   // Status de Indice Desejado Encontrado
   //
   SIX->(DbSetOrder(1))                   // Tabela de Indices do Sistema
   //
   _cChave := Upper(Alltrim(Strtran(_cChave, " ", "")))
   //
   SIX->(DbSeek(_cArquivo + _cOrdem, .F.))
   //
   While SIX->(!Eof()) .And. (SIX->INDICE == _cArquivo)
      //
      _nOrdem := (_nOrdem + 1)
      //
      If (Upper(Alltrim(Strtran(SIX->CHAVE, " ", ""))) == _cChave)
         //
         _lOkey := .T.
         Exit
         //
      Endif
      //
      SIX->(DbSkip())
      //
   Enddo
   //
   If !(_lOkey)
      _nOrdem := Val(_cOrdem)             // Retornar a Ordem Master Se Nao Encontrar
   Endif
   //
   DbSelectArea(_sAlias)
   //
Return (_nOrdem)
