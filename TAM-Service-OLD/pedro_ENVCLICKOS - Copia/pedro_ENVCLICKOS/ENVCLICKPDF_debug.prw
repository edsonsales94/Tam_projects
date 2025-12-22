#define LOGTAG "[ENVCLICKPDF] "

/*/{Protheus.doc} ENVCLICKPDF
    Gera UM PDF contendo N OS (grupo da ENVCLICKOS), reaproveitando o layout do ITFATR04.
    @param aRegs    , array de JsonObject: cada item deve conter ao menos Z1_FILIAL, Z1_CODIGO, Z1_TECNICO, Z1_CLIENTE, Z1_LOJA
    @param cFileBase, caractere: nome base do arquivo (SEM ".pdf") — se vier com ".pdf", será removido
    @param cOutDir  , caractere: diretório de saída (será normalizado com "\\")
    @param lPreview , lógico  : .T. exibe preview; .F. gera silencioso (servidor/REST)
    @return caminho completo do PDF gerado
/*/
User Function ENVCLICKPDF(aRegs, cFileBase, cOutDir, lPreview)
    Local cPathInServer := IIf(Empty(cOutDir), "\\relato\\", cOutDir)
    Local cFileName     := AllTrim(cFileBase)
    Local n             := 0
    Local nRegs         := 0
    Local cFil          := ""
    Local cCod          := ""
    Local cNomCli       := ""
    Local cNomTec       := ""
    Local cHrSai        := ""
    Local cHrEnt        := ""
    Local cHrInt        := ""
    Local dDataOs       := Ctod("")
    Local cProj         := ""
    Local cTrans        := ""
    Local aTexto        := {}
    Local oErr          := Nil
    Local cReturnPath   := ""
    Local lHadAnyPage   := .F.
    Local lOkLoad       := .F.

    // Defaults
    If PCount() < 4 ; lPreview := .F. ; EndIf

    // Normalizações & logs
    If Upper(Right(cFileName,4)) == ".PDF"
        cFileName := Left(cFileName, Len(cFileName) - 4)
        ConOut(LOGTAG + "Removida extensão duplicada do nome do arquivo")
    EndIf
    cPathInServer := FT__EnsureSlash(cPathInServer)
    cReturnPath   := cPathInServer + cFileName + ".pdf"

    nRegs := IIf(ValType(aRegs) == "A", Len(aRegs), 0)
    ConOut(LOGTAG + "INICIO | outDir=" + cPathInServer + " file=" + cFileName + " regs=" + cValToChar(nRegs) + " preview=" + IIf(lPreview, "T", "F"))

    // --- Printer/contexto compartilhado (mesmo padrão do ITFATR04) ---
    Private oPrinter_   := Nil
    Private nPagina     := 0
    Private nColIni     := 010
    Private nColFin     := 580
    Private nTopo       := 060
    Private nRodape     := 780
    Private nLinha      := 0
    Private nEspacoLin  := 012

    // Fonts (como no ITFATR04 — usar SEMPRE nos :Say)
    Private oTFont08    := TFont():New('ARIAL',,-08,.F.)
    Private oTFont10    := TFont():New('ARIAL',,-10,.F.)
    Private oTFont10_N  := TFont():New('ARIAL',,-10,.T.)
    Private oTFont12    := TFont():New('ARIAL',,-12,.F.)
    Private oTFont12_N  := TFont():New('ARIAL',,-12,.T.)
    Private oTFont16_N  := TFont():New('ARIAL',,-16,.T.)

    oTFont10_N:Bold := .T.
    oTFont12_N:Bold := .T.
    oTFont16_N:Bold := .T.

    Begin Sequence
        oPrinter_ := FWMSPrinter():New(cFileName, IMP_PDF, .F., cPathInServer, .T.)
        oPrinter_:cPathPDF := cPathInServer
        oPrinter_:SetPortrait()
        oPrinter_:SetParm("-RFS")  // mesmo padrão de muitos ITFATR04 (silencioso)
        ConOut(LOGTAG + "Printer criado. PathPDF=" + oPrinter_:cPathPDF)

        For n := 1 To nRegs
            cFil := AllTrim(aRegs[n]["Z1_FILIAL"])
            cCod := AllTrim(aRegs[n]["Z1_CODIGO"])

            ConOut(LOGTAG + "OS[" + cValToChar(n) + "/" + cValToChar(nRegs) + "] FIL=" + cFil + " COD=" + cCod)

            // Carrega dados da OS (SZ1/SA1/SA9) — aderente ao ITFATR04
            lOkLoad := ITF4_LoadOS(cFil, cCod, @cNomCli, @cNomTec, @cHrSai, @cHrInt, @cHrEnt, @dDataOs, @cProj, @cTrans, @aTexto)
            If ! lOkLoad
                ConOut(LOGTAG + "WARN: OS não encontrada ou erro ao carregar dados (FIL=" + cFil + " COD=" + cCod + "). Pulando...")
                Loop
            EndIf

            ConOut(LOGTAG + "Dados carregados | Cliente=" + cNomCli + " Tec=" + cNomTec + " Data=" + DToC(dDataOs) + " TextoLinhas=" + cValToChar(Len(aTexto)))

            // Emite a OS (mesma sequência do ITFATR04): abre página, cabeçalho, corpo, fecha página
            NovaPagina(cCod, aRegs[n]["Z1_TECNICO"], cNomTec, aRegs[n]["Z1_CLIENTE"], cNomCli, ;
                       cHrSai, cHrInt, cHrEnt, dDataOs, cProj, cTrans)
            lHadAnyPage := .T.
            ListaOs(aTexto)
            ConOut(LOGTAG + "Emitida OS no PDF | COD=" + cCod)
        Next

        If lPreview
            ConOut(LOGTAG + "Finalização via Preview()")
            oPrinter_:Preview()
        Else
            ConOut(LOGTAG + "Finalização via Print()")
            oPrinter_:Print()
        EndIf
    Recover Using oErr
        ConOut(LOGTAG + "EXCEPTION: " + IIf(oErr == Nil, "NIL", oErr:Description))
    End Sequence

    // Pós-checagem
    If File(cReturnPath)
        ConOut(LOGTAG + "OK: arquivo criado em " + cReturnPath)
    Else
        ConOut(LOGTAG + "ERRO: arquivo nao encontrado em " + cReturnPath)
    EndIf
    If ! lHadAnyPage
        ConOut(LOGTAG + "WARN: nenhuma página foi emitida (verificar loop e StartPage/EndPage)")
    EndIf

Return cReturnPath


/*-----------------------------------------------*
| Helper: normaliza separadores de diretório      |
*------------------------------------------------*/
Static Function FT__EnsureSlash(cDir)
    Local cOut := AllTrim(cDir)
    If Empty(cOut)
        cOut := "\\"
    EndIf
    cOut := StrTran(cOut, "/", "\\")
    If Right(cOut,1) != "\\"
        cOut += "\\"
    EndIf
Return cOut


/*-----------------------------------------------*
| Helper: carrega dados da OS (SZ1/SA1/SA9)       |
*------------------------------------------------*/
Static Function ITF4_LoadOS(cFil, cCod, cNomCli, cNomTec, cHrSai, cHrInt, cHrEnt, dDataOs, cProj, cTrans, aTexto)
    Local lOk   := .F.
    Local aArea := GetArea()
    Local lSeek := .F.
    Local nTxt  := 0

    Default cNomCli := ""
    Default cNomTec := ""
    Default cHrSai  := ""
    Default cHrInt  := ""
    Default cHrEnt  := ""
    Default dDataOs := Ctod("")
    Default cProj   := ""
    Default cTrans  := ""
    Default aTexto  := {}

    ConOut(LOGTAG + "LoadOS: FIL=" + cFil + " COD=" + cCod)

    // SZ1 — Ajuste o TAG conforme seu dicionário (esperado: FILIAL+Z1_CODIGO)
    SZ1->(DbSelectArea("SZ1"))
    SZ1->(DbSetOrder(1))
    lSeek := SZ1->(DbSeek(cFil + cCod))
    ConOut(LOGTAG + "LoadOS: SZ1 Seek=" + IIf(lSeek, "T", "F"))

    If lSeek
        dDataOs := SZ1->Z1_DATA
        cProj   := SZ1->Z1_PROJETO
        cHrEnt  := SZ1->Z1_APHRINI
        cHrSai  := SZ1->Z1_APHRFIM
        cHrInt  := SZ1->Z1_APHRALM
        cTrans  := SZ1->Z1_APTRANS
        aTexto  := zMemoToA(SZ1->Z1_APTEXTO)

        // SA1 — Nome do cliente
        SA1->(DbSelectArea("SA1"))
        SA1->(DbSetOrder(1))
        If SA1->(DbSeek(xFilial("SA1") + SZ1->Z1_CLIENTE + SZ1->Z1_LOJA))
            cNomCli := RTrim(SA1->A1_NOME)
        EndIf

        // SA9 — Nome do técnico
        SA9->(DbSelectArea("SA9"))
        SA9->(DbSetOrder(1))
        If SA9->(DbSeek(xFilial("SA9") + SZ1->Z1_TECNICO))
            cNomTec := RTrim(SA9->A9_NOME)
        EndIf

        lOk := .T.
    EndIf

    nTxt := Len(aTexto)
    ConOut(LOGTAG + "LoadOS: OK=" + IIf(lOk, "T", "F") + " TextoLinhas=" + cValToChar(nTxt))

    RestArea(aArea)
Return lOk


/*-----------------------------------------------*
| Helper: quebra memo em array de linhas          |
*------------------------------------------------*/
Static Function zMemoToA(xMemo)
    Local cTxt := IIf(ValType(xMemo)=="C", xMemo, MemoRead(xMemo))
    Local cSep := CRLF
    Local aOut := {}
    Local nPos := 0

    If Empty(cTxt)
        Return {}
    EndIf

    cTxt := StrTran(cTxt, Chr(13)+Chr(10), cSep)
    cTxt := StrTran(cTxt, Chr(13), cSep)
    cTxt := StrTran(cTxt, Chr(10), cSep)

    While .T.
        nPos := At(cSep, cTxt)
        If nPos == 0
            AAdd(aOut, cTxt)
            Exit
        EndIf
        AAdd(aOut, SubStr(cTxt, 1, nPos-1))
        cTxt := SubStr(cTxt, nPos+Len(cSep))
    Enddo
Return aOut


/*-----------------------------------------------*
| Layout: abre nova página e imprime cabeçalho    |
*------------------------------------------------*/
Static Function NovaPagina(cOS, cTecCod, cTecNom, cCliCod, cCliNom, cHrSai, cHrInt, cHrEnt, dDataOs, cProj, cTrans)
    Private oPrinter_   // usa contexto da ENVCLICKPDF
    Private nPagina
    Private nColIni
    Private nColFin
    Private nTopo
    Private nLinha
    Private oTFont16_N
    Private oTFont12_N
    Private oTFont10

    nPagina++
    nLinha := nTopo

    oPrinter_:StartPage()
    ConOut(LOGTAG + "StartPage | OS=" + cOS)

    // Cabeçalho (usar fontes explícitas, como no ITFATR04)
    oPrinter_:Say(nLinha     , nColIni, "ORDEM DE SERVIÇO — " + DTOS(dDataOs), oTFont16_N)
    oPrinter_:Say(nLinha+015 , nColIni, "OS: " + cOS + "    Projeto: " + cProj, oTFont12_N)
    oPrinter_:Say(nLinha+030 , nColIni, "Cliente: " + cCliCod + " - " + cCliNom, oTFont10)
    oPrinter_:Say(nLinha+045 , nColIni, "Técnico: " + cTecCod + " - " + cTecNom, oTFont10)
    oPrinter_:Say(nLinha+060 , nColIni, "Entrada: " + cHrEnt + "  Intervalo: " + cHrInt + "  Saída: " + cHrSai, oTFont10)

    // Linha separadora
    oPrinter_:Line(nLinha+072, nColIni, nLinha+072, nColFin)

    nLinha := nLinha + 084
Return


/*-----------------------------------------------*
| Layout: imprime o corpo de texto da OS          |
*------------------------------------------------*/
Static Function ListaOs(aTexto)
    Local i := 0
    Private oPrinter_
    Private nLinha
    Private nRodape
    Private nTopo
    Private nEspacoLin
    Private nColIni
    Private nColFin
    Private oTFont10
    Private nPagina

    ConOut(LOGTAG + "ListaOs: linhas=" + cValToChar(Len(aTexto)))

    For i := 1 To Len(aTexto)
        // Se estourar a página, fecha e inicia nova (continuação da mesma OS)
        If (nLinha + nEspacoLin) > (nRodape - 20)
            oPrinter_:EndPage()
            ConOut(LOGTAG + "EndPage (quebra)")
            nPagina++
            nLinha := nTopo
            oPrinter_:StartPage()
            oPrinter_:Say(nLinha, nColIni, "Continuação da OS", oTFont10)
            oPrinter_:Line(nLinha+012, nColIni, nLinha+012, nColFin)
            nLinha += 024
        EndIf

        oPrinter_:Say(nLinha, nColIni, aTexto[i], oTFont10)
        nLinha += nEspacoLin
    Next

    // Fecha a última página desta OS
    oPrinter_:EndPage()
    ConOut(LOGTAG + "EndPage (final OS)")
Return
