#Include "PROTHEUS.CH"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"
/*/{Protheus.doc} User Function ENVCLICKPDF
    Gera UM PDF contendo N OS (grupo da ENVCLICKOS).
    @param aRegs    , array de JsonObject (mínimo: Z1_FILIAL, Z1_CODIGO, Z1_CLIENTE, Z1_LOJA)
    @param cFileBase, caractere: nome base do arquivo (sem .pdf)
    @param cOutDir  , caractere: diretório de saída
    @param lPreview , lógico  : .F. no servidor (default)
    @return caminho completo do PDF gerado
/*/
User Function ENVCLICKPDF(aRegs, cFileBase, cOutDir, lPreview)
    Local i               := 0
    Local cPathOut        := ""
    Local cFileNameNoExt  := ""
    Local oIt             := NIL
    Local oTFont08, oTFont10, oTFont10_N, oTFont12, oTFont12_N, oTFont14, oTFont16, oTFont16_N


    // ——— PRIVATES usados por NovaPagina()/ListaOs() ———
    Private cPathInServer := cDirOut
    Private nPagina       := 0
    Private nPagTot       := 0
    Private nHeight       := 75
    Private nWidght       := 90
    Private nLinha        := 0
    Private nColuna       := 0
    Private nColIni       := 010
    Private nColFin       := 580
    Private nEspacoLin    := 12
    Private oPrinter      := NIL
    Private aTexto        := {}

    // ——— fontes (iguais às da ITFATR04) ———
    oTFont08   := TFont():New('ARIAL',,-08,.F.)
    oTFont10   := TFont():New('ARIAL',,-10,.F.)
    oTFont10_N := TFont():New('ARIAL',,-10,.T.)
    oTFont16   := TFont():New('ARIAL',,-16,.T.)
    oTFont14   := TFont():New('ARIAL',,-14,.T.)
    oTFont16_N := TFont():New('ARIAL',,-16,.T.)
    oTFont12   := TFont():New('ARIAL',,-12,.T.)
    oTFont12_N := TFont():New('ARIAL',,-12,.T.)
    oTFont10_N:Bold := .T.
    oTFont12_N:Bold := .T.
    oTFont16_N:Bold := .T.

    // ——— prepara spool PDF ———
    If Empty(AllTrim(cDirOut))
        cDirOut := "\SPOOL\OSCLICK\"
    EndIf
    MakeDir(cDirOut) // sem drama: se já existir, ignora
    cFileNameNoExt := If(Upper(Right(AllTrim(cFile),4))==".PDF", ;
                         Left(AllTrim(cFile), Len(AllTrim(cFile))-4), ;
                         AllTrim(cFile))

    oPrinter := FWMSPrinter():New(cFileNameNoExt, IMP_PDF, .F., cDirOut, .T.,,,,.F.,.F.,,.F.)
    oPrinter:SetParm("-RFS")
    oPrinter:oLandscape := .F.
    oPrinter:nShadow    := 0
    oPrinter:lNoAsk     := .T.
    oPrinter:Setup()
    oPrinter:SetMargins(nColIni, nColFin, 0, 0)
    oPrinter:Default()
    oPrinter:SetLineWidth(02)
    oPrinter:DisableDrawing()

    // ——— imprime cada OS em sequência (uma ou mais páginas por OS, conforme o texto) ———
    For i := 1 To Len(aItems)
        Local cOsEletr   := ""
        Local cTecnico   := ""
        Local cNomeTec   := ""
        Local cCodCli    := ""
        Local cLoja      := ""
        Local cNomeCli   := ""
        Local cHrEntrada := ""
        Local cIntervalo := ""
        Local cHrSaida   := ""
        Local dDataOs    := Ctod("")  // data
        Local cProjeto   := ""
        Local cTranslado := ""
        Local cMemo      := ""

        // 1) Extrai dados da fonte que vier (JsonObject ou RECNO)
        If ValType(aItems[i]) == "N"
            // Via RECNO da SZ1
            SZ1->(DbSetOrder(1))
            SZ1->(DbGoTo(aItems[i]))
            If (SZ1)->(EoF())
                Loop
            EndIf
            cOsEletr   := AllTrim(SZ1->Z1_CODIGO)
            cTecnico   := AllTrim(SZ1->Z1_TECNICO)
            cCodCli    := AllTrim(SZ1->Z1_CLIENTE)
            cLoja      := AllTrim(SZ1->Z1_LOJA)
            cHrEntrada := AllTrim(SZ1->Z1_APHRINI)
            cIntervalo := AllTrim(SZ1->Z1_APHRALM)
            cHrSaida   := AllTrim(SZ1->Z1_APHRFIM)
            dDataOs    := SZ1->Z1_DATA
            cProjeto   := AllTrim(SZ1->Z1_PROJETO)
            cTranslado := AllTrim(SZ1->Z1_APTRANS)
            cMemo      := AllTrim(SZ1->Z1_APTEXTO)
        Else
            // Via objeto (formato do ENVCLICKOS)
            oIt        := aItems[i]
            cOsEletr   := AllTrim(oIt["Z1_CODIGO"])
            cTecnico   := AllTrim(oIt["Z1_TECNICO"])
            cCodCli    := AllTrim(oIt["Z1_CLIENTE"])
            cLoja      := AllTrim(oIt["Z1_LOJA"])
            cHrEntrada := AllTrim(oIt["Z1_APHRINI"])
            cIntervalo := AllTrim(oIt["Z1_APHRALM"])
            cHrSaida   := AllTrim(oIt["Z1_APHRFIM"])
            dDataOs    := If(ValType(oIt["Z1_APDATA"])=="D", oIt["Z1_APDATA"], StoD(AllTrim(oIt["Z1_APDATA"])))
            cProjeto   := AllTrim(oIt["Z1_PROJETO"])
            cTranslado := AllTrim(oIt["Z1_APTRANS"])
            cMemo      := AllTrim(oIt["Z1_APTEXTO"])
        EndIf

        // 2) Resolve nomes (SA1/SA9)
        SA1->(DbSetOrder(1))
        If SA1->(DbSeek(xFilial("SA1") + cCodCli + cLoja))
            cNomeCli := RTrim(SA1->A1_NOME)
        EndIf
        SA9->(DbSetOrder(1))
        If SA9->(DbSeek(xFilial("SA9") + cTecnico))
            cNomeTec := RTrim(SA9->A9_NOME)
        EndIf

        // 3) Quebra do memo em linhas
        aTexto := zMemoToA(cMemo, 124, CRLF, .T.)

        // 4) Renderiza página(s) usando o mesmo layout
        NovaPagina()
        ListaOs(cOsEletr, cTecnico, cNomeTec, cCodCli, cNomeCli, ;
                cHrSaida, cIntervalo, cHrEntrada, dDataOs, cProjeto, cTranslado)
        oPrinter:EndPage()
    Next

    // 5) Finaliza o spool
    If lPreview
        oPrinter:Preview()
    Else
        oPrinter:Print()
    EndIf

    cPathOut := cDirOut + cFileNameNoExt + ".PDF"
Return cPathOut
