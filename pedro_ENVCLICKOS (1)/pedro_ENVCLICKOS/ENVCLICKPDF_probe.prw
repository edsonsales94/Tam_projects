#include "protheus.ch"
#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"

#define LOGTAG "[ENVCLICKPDF] "

/*/{Protheus.doc} ENVCLICKPDF
    Gera UM PDF contendo N OS (grupo da ENVCLICKOS) usando o MESMO fluxo do ITFATR04.
    Mantém NovaPagina() e ListaOs(...) com as assinaturas ORIGINAIS.
    @param aRegs    , array: itens com Z1_FILIAL, Z1_CODIGO, Z1_TECNICO, Z1_CLIENTE, Z1_LOJA
    @param cFileBase, caractere: nome base do arquivo (SEM ".pdf")
    @param cOutDir  , caractere: diretório de saída
    @param lPreview , lógico  : .T. Preview (desktop) | .F. Print (REST)
    @return caminho completo do PDF gerado
/*/
User Function ENVCLICKPDF(aRegs, cFileBase, cOutDir, lPreview)
    Local cFileName       := AllTrim(cFileBase)
    Local cPathInServer   := IIf(Empty(cOutDir), '\relato\', cOutDir)
    Local n               := 0
    Local nRegs           := IIf(ValType(aRegs) == "A", Len(aRegs), 0)
    Local cFil            := ""
    Local cCod            := ""
    Local cReturn         := ""

    // === PRIVATES exatamente como no ITFATR04 ===
    Private nPagina       := 0
    Private nPagTot       := 0
    Private nHeight       := 75
    Private nWidght       := 90
    Private nLinha        := 0
    Private nColuna       := 0
    Private nColIni       := 010
    Private nColFin       := 580
    Private nEspacoLin    := 12
    Private oPrinter      := Nil
    Private aTexto        := {}

    // Fonts (mesmas do ITFATR04)
    Private oTFont08    := TFont():New('ARIAL',,-08,.F.)
    Private oTFont10    := TFont():New('ARIAL',,-10,.F.)
    Private oTFont10_N  := TFont():New('ARIAL',,-10,.T.)
    Private oTFont16    := TFont():New('ARIAL',,-16,.T.)
    Private oTFont14    := TFont():New('ARIAL',,-14,.T.)
    Private oTFont16_N  := TFont():New('ARIAL',,-16,.T.)
    Private oTFont12    := TFont():New('ARIAL',,-12,.T.)
    Private oTFont12_N  := TFont():New('ARIAL',,-12,.T.)

    oTFont10_N:Bold := .T.
    oTFont12_N:Bold := .T.
    oTFont16_N:Bold := .T.

    If PCount() < 4 ; lPreview := .F. ; EndIf
    If Upper(Right(cFileName,4)) == ".PDF"
        cFileName := Left(cFileName, Len(cFileName)-4)
    EndIf
    cPathInServer := FT__EnsureSlash(cPathInServer)

    // === PRINTER exatamente como no ITFATR04 ===
    oPrinter := FWMSPrinter():New(cFileName, IMP_PDF, .F., cPathInServer, .T.,,,,.F.,.F.,,.F.)
    oPrinter:SetParm("-RFS")
    oPrinter:cPathPDF := cPathInServer
    oPrinter:SetPortrait()

    // métricas como no ITFATR04
    nHeight := oPrinter:NPAGEHEIGHT
    nWidght := oPrinter:NPAGEWIDTH
    nHeight := nHeight-(nHeight*0.25)
    nWidght := nWidght-(nWidght*0.025)
    // nMaximo := 2300  // se o ITFATR04 usar, inclua aqui

    For n := 1 To nRegs
        cFil := AllTrim(aRegs[n]["Z1_FILIAL"])
        cCod := AllTrim(aRegs[n]["Z1_CODIGO"])

        // === Carrega SZ1/SA1/SA9 do mesmo jeito do ITFATR04 ===
        If ! __LoadOS__ENV(cFil, cCod)   // popula aTexto e variáveis globais usadas por ListaOs
            ConOut(LOGTAG + "WARN: OS não localizada (FIL="+cFil+" COD="+cCod+")")
            Loop
        EndIf

        // páginas estimadas para rodapé "Página X/Y"
        nPagTot := Max(1, CEILING(Len(aTexto) / 20))

        // === Chamadas exatamente como o ITFATR04 faz ===
        NovaPagina()  // sem parâmetros no ITFATR04
        // ListaOs com 11 parâmetros na ORDEM original
        ListaOs( SZ1->Z1_CODIGO, ;
                 SZ1->Z1_TECNICO, ;
                 RTrim(SA9->A9_NOME), ;
                 SZ1->Z1_CLIENTE, ;
                 RTrim(SA1->A1_NOME), ;
                 SZ1->Z1_APHRFIM, ;
                 SZ1->Z1_APHRALM, ;
                 SZ1->Z1_APHRINI, ;
                 SZ1->Z1_DATA, ;
                 SZ1->Z1_PROJETO, ;
                 SZ1->Z1_APTRANS )

        oPrinter:EndPage()
    Next

    If lPreview
        oPrinter:Preview()
    Else
        oPrinter:Print()
    EndIf

    cReturn := cPathInServer + cFileName + ".pdf"
Return cReturn

/*-----------------------------------------------*
| Helper: normaliza separadores de diretório      |
*------------------------------------------------*/
Static Function FT__EnsureSlash(cDir)
    Local cOut := AllTrim(cDir)
    If Empty(cOut)
        cOut := "\"
    EndIf
    cOut := StrTran(cOut, "/", "\")
    If Right(cOut,1) != "\"
        cOut += "\"
    EndIf
Return cOut

/*-----------------------------------------------*
| Loader: carrega SZ1/SA1/SA9 e texto da OS       |
|  — sem alterar as rotinas de layout             |
*------------------------------------------------*/
Static Function __LoadOS__ENV(cFil, cCod)
    Local aArea := GetArea()
    Local lOk   := .F.

    // Usa exatamente os aliases padrão do ITFATR04
    SZ1->(DbSelectArea("SZ1"))
    SZ1->(DbSetOrder(1))                // AJUSTE se seu TAG 1 não for FILIAL+Z1_CODIGO
    If SZ1->(DbSeek(cFil + cCod))
        SA1->(DbSelectArea("SA1"))
        SA1->(DbSetOrder(1))
        SA1->(DbSeek(xFilial("SA1")+SZ1->Z1_CLIENTE+SZ1->Z1_LOJA))

        SA9->(DbSelectArea("SA9"))
        SA9->(DbSetOrder(1))
        SA9->(DbSeek(xFilial("SA9")+SZ1->Z1_TECNICO))

        // Gera o array com o memo — a ListaOs usa esta 'aTexto' implícita
        aTexto := zMemoToA(SZ1->Z1_APTEXTO)

        lOk := .T.
    EndIf
    RestArea(aArea)
Return lOk

/*-----------------------------------------------*
| As rotinas a seguir devem ser copiadas          |
| IDÊNTICAS às do ITFATR04:                       |
|   - NovaPagina()                                 |
|   - ListaOs(...)                                 |
|   - zMemoToA(...)                                |
| Para facilitar o debug de "página em branco",    |
| a NovaPagina abaixo exibe a palavra PROBE.       |
*------------------------------------------------*/

// === NovaPagina ORIGINAL + "PROBE" visível ===
Static Function NovaPagina()
    // usa as PRIVATES já declaradas
    oPrinter:StartPage()
    nPagina += 1
    nLinha  := 010

    // PROBE para garantir que há conteúdo na página
    oPrinter:Say(100, 100, "PROBE", oTFont16_N)

    // (o restante do seu NovaPagina original vem aqui — logo, linhas, rodapé, etc.)
Return

// === ListaOs ORIGINAL (apenas chamamos exatamente igual) ===
Static Function ListaOs(cOsEletr,cTecnico,cNomeTec,cCodCli,cNomeCli,cHrSaida,cIntervalo,cHrEntrada,dDataOs,cProjeto,cTranslado)
    // (cole aqui a ListaOs original, sem alterar a lógica)
    // A versão mínima imprime ao menos o cabeçalho da OS e o tamanho do texto:
    nLinha  += nEspacoLin*1.5
    oPrinter:Say( nLinha, nColIni, "Ordem de Serviço: "+RTRIM(cOsEletr), oTFont10_N)
    nLinha  += nEspacoLin*1.5
    oPrinter:Say( nLinha, nColIni, "Executado por: "+RTRIM(cTecnico)+" - "+cNomeTec, oTFont10_N)
    nLinha  += nEspacoLin*1.5
    oPrinter:Say( nLinha, nColIni, "Cliente: "+RTRIM(cCodCli)+" - "+cNomeCli, oTFont10_N)

    // Linha separadora
    nLinha += nEspacoLin
    oPrinter:Line(nLinha , nColIni , nLinha, (nColFin - nColIni))

    // Corpo mínimo (mostra quantas linhas teríamos do memo)
    nLinha += nEspacoLin*2
    oPrinter:Say( nLinha, nColIni, "Linhas do texto (memo): " + cValToChar( Len(aTexto) ), oTFont10 )
Return

/*-----------------------------------------------*
| zMemoToA — versão compatível                    |
*------------------------------------------------*/
Static Function zMemoToA(xMemo)
    Local cTxt := IIf(ValType(xMemo)=="C", xMemo, MemoRead(xMemo))
    Local cSep := CRLF
    Local aOut := {}
    Local nPos := 0

    If Empty(cTxt)
        Return {}
    EndIf

    // normaliza quebras
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
