/* ============================================================================
   OSCLICKENV.PRW – Envio de OS apontadas para Clicksign – pré-seleção + PDF
   GET  /rest/osclickenv/api/kodigos/v1/click/os
   GET  /rest/osclickenv/api/kodigos/v1/click/os/pdf   (gera 1 PDF por grupo)
   - Janela fixa dos últimos 15 dias
   - SZ1 com Z1_STATUS = 'L' (Apontado) e Z1_APDATA na janela
   - LIGAÇÃO EXATA por ID: SZ1.Z1_CODIGO = ZP9.ZP9_CODIGO 
   - AGRUPA por TECNICO + PROJETO + CONTATO (ID)
   ============================================================================ */

#Include "PROTHEUS.CH"
#Include "RESTFUL.CH"
#Include "RPTDEF.CH"
#Include "FWPrintSetup.ch"
#Include "TbiConn.ch"

// ------------------------------- PARÂMETROS ---------------------------------
#Define CKS_DAYSBACK 15      // janela fixa
#Define CKS_STATUS   "L"     // Apontado
#Define LOG_TAG       "[OSCLICKENV] "

// === Clicksign v3 (sandbox) – V3 ===
#Define CKS_BASE_V3      "https://sandbox.clicksign.com/api/v3"
#Define CKS_TOKEN        "026186fc-763e-49d7-a2df-1a8a0c17c10a" // <<< token teste
#Define CKS_TEST_EMAIL   "pedro.henriques@kodigos.com.br"        // <<<e-mail teste 
#Define _MAX_LOG_LEN  800

// ------------------------------- SERVICE ------------------------------------
WSRESTFUL OSCLICKENV DESCRIPTION "Envio de OS apontadas para Clicksign – pré-seleção"

    // GET sem parâmetros: últimos 15 dias, agrupado por TECNICO+PROJETO+CONTATO
    WSMETHOD GET listCandidatas DESCRIPTION ;
        "Lista OS apontadas (SZ1: Z1_STATUS='L') agrupadas por TECNICO+PROJETO+CONTATO" ;
        WSSYNTAX "/api/kodigos/v1/click/os" ;
        PATH     "/api/kodigos/v1/click/os"

    // GET sem parâmetros: mesmos dados, mas gerando 1 PDF por grupo
    WSMETHOD GET gerarPdfs DESCRIPTION ;
        "Gera 1 PDF por agrupamento (TECNICO+PROJETO+CONTATO) e retorna os caminhos" ;
        WSSYNTAX "/api/kodigos/v1/click/os/pdf" ;
        PATH     "/api/kodigos/v1/click/os/pdf"
    // GET criar envelope ? anexar documento ? incluir signatário ? enviar
    WSMETHOD GET enviarClick DESCRIPTION ;
        "Monta payload por grupo (Envelope v3) e retorna o que seria enviado" ;
        WSSYNTAX "/api/kodigos/v1/click/os/send" ;
        PATH     "/api/kodigos/v1/click/os/send"
    //teste usando o itfatr04
    WSMETHOD POST testPdfOS DESCRIPTION ;
        "Gera PDF da OS (via U_ITFATR04) a partir do RECNO da SZ1" ;
        WSSYNTAX "/api/kodigos/v1/click/os/testpdf" ;
        PATH     "/api/kodigos/v1/click/os/testpdf"

END WSRESTFUL

/* -------------------------------- MÉTODOS --------------------------------- */
WSMETHOD POST testPdfOS WSRECEIVE WSREST OSCLICKENV
    // --- DECLARAÇÕES (tudo no topo) ---
    Local oJsonRet  := JsonObject():New()
    Local oJsnBody  := JsonObject():New()
    Local cBody     := ""
    Local cRetJson  := ""
    Local nRecno    := 0
    Local cPdf      := ""
    Local lOk       := .F.
    Local cResp     := ""

    ConOut("[testPdfOS] INICIO")

    // 1) Body
    cBody := ::GetContent()
    ConOut("[testPdfOS] Body len=" + cValToChar(Len(cBody)))
    ConOut("[testPdfOS] Body(<=500): " + Left(cBody, 500))

    // 2) Parse JSON (padrão do teu código)
    cRetJson := oJsnBody:FromJson(cBody)
    If ValType(cRetJson) == "C" .And. !Empty(cRetJson)
        ConOut("[testPdfOS] FromJson=FALSE: " + cRetJson)
        SetRestFault(400, "Falha ao transformar JSON: " + cRetJson, .T.)
        Return .F.
    EndIf
    ConOut("[testPdfOS] FromJson=TRUE")

    // 3) Validação do campo obrigatório
    If !oJsnBody:HasProperty("recno") .OR. Empty(oJsnBody['recno'])
        ConOut("[testPdfOS] Falta 'recno' no JSON")
        SetRestFault(400, "Campo 'recno' obrigatório.", .T.)
        Return .F.
    EndIf

    // 4) RECNO
    nRecno := Val(AllTrim(cValToChar(oJsnBody['recno'])))
    ConOut("[testPdfOS] RECNO=" + cValToChar(nRecno))
    If nRecno <= 0
        ConOut("[testPdfOS] RECNO inválido")
        SetRestFault(400, "Valor de 'recno' inválido.", .T.)
        Return .F.
    EndIf

    // 5) Geração do PDF (chamada direta da tua função)
    ConOut("[testPdfOS] Chamando U_ITFATR04(" + cValToChar(nRecno) + ")")
    cPdf := U_ITFATR04(nRecno)
    ConOut("[testPdfOS] Retorno U_ITFATR04: " + cPdf)

    // 6) Verificação de existência (sem GetSrvProfString; tenta como veio)
    //    Primeiro como está; se não achar, tenta normalizar separadores.
    lOk := File(cPdf)
    ConOut("[testPdfOS] File(cPdf)       = " + If(lOk,"TRUE","FALSE"))
    If !lOk
        lOk := File(StrTran(cPdf, "/", "\"))
        ConOut("[testPdfOS] File(StrTran) = " + If(lOk,"TRUE","FALSE"))
    EndIf

    // 7) Resposta JSON
    oJsonRet['ok']    := lOk
    oJsonRet['recno'] := nRecno
    oJsonRet['pdf']   := cPdf
    If !lOk
        oJsonRet['err'] := "Arquivo pode ter sido gerado em caminho relativo do servidor (sem permissão/preview)."
    EndIf

    cResp := oJsonRet:ToJson()
    ConOut("[testPdfOS] RESP JSON: " + Left(cResp, 800))

    ::SetContentType("application/json")
    ::SetResponse(cResp)
Return

WSMETHOD GET enviarClick WSRECEIVE WSREST OSCLICKENV
    Local oJsonRet   := JsonObject():New()
    Local dIni       := Date() - CKS_DAYSBACK
    Local dFim       := Date()
    Local aGroups    := {}
    Local aOut       := {}
    Local i          := 0
    Local oG         := NIL
    Local cDirOut    := ""
    Local aRegs      := {}
    Local cProj      := ""
    Local cTec       := ""
    Local cCli       := ""
    Local cLoja      := ""
    Local cCliNome   := ""
    Local cTecNome   := ""
    Local cDtIniOS   := ""
    Local cDtFimOS   := ""
    Local cFileBase  := ""
    Local cFilePath  := ""
    Local oItem      := NIL

    ConOut(LOG_TAG + "INÍCIO /os/send v3")
    ConOut(LOG_TAG + "Janela => " + DToS(dIni) + " .. " + DToS(dFim))

    aGroups := FT_SelectGroupSZ1_ComContato(dIni, dFim)
    cDirOut := FT_GetOutDir()
    ConOut(LOG_TAG + "Saída PDF: " + cDirOut)

    For i := 1 To Len(aGroups)
        oG    := aGroups[i]
        aRegs := oG["registros"]
        If Len(aRegs) == 0
            Loop
        EndIf

        cProj    := oG["projeto"]
        cTec     := oG["tecnico"]
        cCli     := aRegs[1]["Z1_CLIENTE"]
        cLoja    := aRegs[1]["Z1_LOJA"]
        FT_MinMaxDatas(@aRegs, @cDtIniOS, @cDtFimOS)
        cCliNome := FT_GetNomeCliente(cCli, cLoja)
        cTecNome := FT_GetNomeConsultor(cTec)
        cFileBase:= FT_MakeDocName(cProj, cCliNome, cTecNome, cDtIniOS, cDtFimOS) + ".PDF"
        cFilePath:= cDirOut + cFileBase

        // garante PDF
        If !File(cFilePath)
            If !FT_GeraPdfGrupo(cDirOut, cFileBase, oG)
                ConOut(LOG_TAG + "ERRO ao gerar: " + cFilePath)
                Loop
            EndIf
        EndIf

        // === v3: criar envelope, anexar PDF, incluir signatário (email fixo), enviar
        oItem := FT_ClickV3_SendEnvelope(cFilePath, ;
                  "OS " + cProj + " - " + cCliNome + " - " + cTecNome + " (" + cDtIniOS + " a " + cDtFimOS + ")", ;
                  CKS_TEST_EMAIL, cCliNome)

        // anexa metadados úteis do nosso agrupamento
        oItem["tecnico"]       := cTec
        oItem["projeto"]       := cProj
        oItem["contato_id"]    := oG["contato_id"]
        oItem["contato_nome"]  := oG["contato_nome"]
        oItem["contato_email"] := oG["contato_email"]
        oItem["arquivo"]       := cFilePath
        oItem["qtde"]          := Len(aRegs)

        AAdd(aOut, oItem)
    Next

    oJsonRet["ok"]           := .T.
    oJsonRet["dtini"]        := DToS(dIni)
    oJsonRet["dtfim"]        := DToS(dFim)
    oJsonRet["total_grupos"] := Len(aGroups)
    oJsonRet["itens"]        := aOut
    oJsonRet["obs"]          := "Envio v3 com e-mail de teste fixo (override): " + CKS_TEST_EMAIL

    ::SetContentType("application/json")
    ::SetResponse(oJsonRet:toJson())

    ConOut(LOG_TAG + "FIM /os/send v3 – grupos=" + AllTrim(Str(Len(aGroups))))
Return .T.

WSMETHOD GET listCandidatas WSRECEIVE WSREST OSCLICKENV
   // Local lOk        := .T.
    Local oJsonRet   := JsonObject():New()
    Local dIni       := Date() - CKS_DAYSBACK
    Local dFim       := Date()
    Local aGroups    := {}
    Local aOut       := {}
    Local i          := 0
    Local oG         := NIL

    ConOut(LOG_TAG + "INÍCIO GET /os (candidatas)")
    ConOut(LOG_TAG + "Janela => dtini=" + DToS(dIni) + ", dtfim=" + DToS(dFim))

    aGroups := FT_SelectGroupSZ1_ComContato(dIni, dFim)

    For i := 1 To Len(aGroups)
        oG := aGroups[i]
        AAdd(aOut, oG) // já é JsonObject
    Next

    oJsonRet["ok"]           := .T.
    oJsonRet["dtini"]        := DToS(dIni)
    oJsonRet["dtfim"]        := DToS(dFim)
    oJsonRet["total_grupos"] := Len(aGroups)
    oJsonRet["grupos"]       := aOut

    ::SetContentType("application/json")
    ::SetResponse(oJsonRet:toJson())

    ConOut(LOG_TAG + "FIM GET /os total_grupos=" + AllTrim(Str(Len(aGroups))))
Return .T.

WSMETHOD GET gerarPdfs WSRECEIVE WSREST OSCLICKENV
    Local oJsonRet   := JsonObject():New()
    Local dIni       := Date() - CKS_DAYSBACK
    Local dFim       := Date()
    Local aGroups    := {}
    Local aPdfs      := {}
    Local i          := 0
    Local oG         := NIL
    Local aRegs      := {}
    Local cProj      := ""
    Local cTec       := ""
    Local cContId    := ""
    Local cContNome  := ""
    Local cContEmail := ""
    Local cCli       := ""
    Local cLoja      := ""
    Local cNomeCli   := ""
    Local cNomeTec   := ""
    Local cDtIniOS   := ""
    Local cDtFimOS   := ""
    Local cDirOut    := ""
    Local cFileBase  := ""
    Local cFilePath  := ""
    Local lOkPdf     := .F.
    Local oItem      := NIL

    ConOut(LOG_TAG + "INÍCIO GET /os/pdf (gerar PDFs)")
    ConOut(LOG_TAG + "Janela => dtini=" + DToS(dIni) + ", dtfim=" + DToS(dFim))

    aGroups := FT_SelectGroupSZ1_ComContato(dIni, dFim)
    cDirOut := FT_GetOutDir()  // dentro do RootPath\\SPOOL\\OSCLICK\\
    ConOut(LOG_TAG + "Saída de PDF em: " + cDirOut)

    For i := 1 To Len(aGroups)
        oG          := aGroups[i]
        cProj       := oG["projeto"]
        cTec        := oG["tecnico"]
        cContId     := oG["contato_id"]
        cContNome   := oG["contato_nome"]
        cContEmail  := oG["contato_email"]
        aRegs       := oG["registros"]

        If Len(aRegs) > 0
            cCli     := aRegs[1]["Z1_CLIENTE"]
            cLoja    := aRegs[1]["Z1_LOJA"]
            FT_MinMaxDatas(@aRegs, @cDtIniOS, @cDtFimOS)
            cNomeCli := FT_GetNomeCliente(cCli, cLoja)
            cNomeTec := FT_Consultor(cTec) // por ora, retorna o próprio código se não mapear

            // 4.1.3: PROJETO + NOME CLIENTE + NOME CONSULTOR + DT INÍCIO + DT FIM
            cFileBase := FT_MakeDocName(cProj, cNomeCli, cNomeTec, cDtIniOS, cDtFimOS) + ".pdf"
            cFilePath := cDirOut + cFileBase

            lOkPdf := FT_GeraPdfGrupo(cDirOut, cFileBase, oG)
        
            oItem := JsonObject():New()
            oItem["ok"]           := lOkPdf
            oItem["arquivo"]      := cFilePath
            oItem["tecnico"]      := cTec
            oItem["projeto"]      := cProj
            oItem["contato_id"]   := cContId
            oItem["contato_nome"] := cContNome
            oItem["contato_email"]:= cContEmail
            oItem["qtde"]         := Len(aRegs)
            AAdd(aPdfs, oItem)

            ConOut(LOG_TAG + "PDF " + If(lOkPdf, "OK ", "ERRO ") + "=> " + cFilePath + " (qtde=" + AllTrim(Str(Len(aRegs))) + ")")
        EndIf
    Next

    oJsonRet["ok"]           := .T.
    oJsonRet["dtini"]        := DToS(dIni)
    oJsonRet["dtfim"]        := DToS(dFim)
    oJsonRet["total_grupos"] := Len(aGroups)
    oJsonRet["total_pdfs"]   := Len(aPdfs)
    oJsonRet["pdfs"]         := aPdfs

    ::SetContentType("application/json")
    ::SetResponse(oJsonRet:toJson())

    ConOut(LOG_TAG + "FIM GET /os/pdf – grupos=" + AllTrim(Str(Len(aGroups))) + " pdfs=" + AllTrim(Str(Len(aPdfs))))
Return .T.

/* ------------------------------ HELPERS SQL ------------------------------- */
/* Seleciona SZ1 (apontadas na janela) e agrega por TECNICO+PROJETO+CONTATO.
   Para cada linha, procura contatos ATIVOS da agenda na ZP9:
   ZP9.ZP9_CODIGO = SZ1.Z1_CODIGO (match exato).
   Retorno: JsonObjects de grupo:
   {
     "tecnico","projeto","contato_id","contato_nome","contato_email",
     "qtde","registros":[ {...}, ... ]
   }
*/
Static Function FT_SelectGroupSZ1_ComContato(dIni, dFim)
    Local aGroups     := {}
    Local cSZ1        := RetSqlName("SZ1")
    Local cDtI        := DToS(dIni)
    Local cDtF        := DToS(dFim)
    Local cSQL        := ""
    Local cAliasQ     := ""
    Local nCount      := 0
    Local cTec        := ""
    Local cPrj        := ""
    Local cCli        := ""
    Local cLoja       := ""
    Local cAgdId      := ""
    Local aContatos   := {}   // { {id,nome,email}, ... }
    Local nCont       := 0
    Local cContId     := ""
    Local cContNome   := ""
    Local cContEmail  := ""
    Local oRow        := NIL

    ConOut(LOG_TAG + "FT_SelectGroupSZ1_ComContato – INÍCIO. dtini=" + cDtI + ", dtfim=" + cDtF)

    If Empty(cSZ1)
        ConOut(LOG_TAG + "ERRO: RetSqlName('SZ1') vazio (tabela não encontrada)")
        Return aGroups
    EndIf

    /* Carrega SZ1: status L e dentro da janela */
    cSQL  := "SELECT "
    cSQL += "  Z1_TECNICO, Z1_PROJETO, Z1_FILIAL, Z1_CODIGO, "
    cSQL += "  Z1_STATUS, Z1_APDATA, Z1_DATA, Z1_CLIENTE, Z1_LOJA, "
    cSQL += "  Z1_APHRINI, Z1_APHRFIM, Z1_AGHRINI, Z1_AGHRFIM "
    cSQL += "FROM " + cSZ1 + " WITH (NOLOCK) "
    cSQL += "WHERE D_E_L_E_T_ = '' "
    cSQL += "  AND Z1_STATUS  = '" + CKS_STATUS + "' "
    cSQL += "  AND Z1_APDATA BETWEEN '" + cDtI + "' AND '" + cDtF + "' "
    cSQL += "ORDER BY Z1_TECNICO, Z1_PROJETO, Z1_APDATA"

    ConOut(LOG_TAG + "SQL SZ1 => " + cSQL)

    cAliasQ := MpSysOpenQuery(cSQL)
    If Empty(cAliasQ) .or. Select(cAliasQ) == 0
        ConOut(LOG_TAG + "ERRO: MpSysOpenQuery não retornou alias válido (SZ1)")
        Return aGroups
    EndIf

    (cAliasQ)->(DbGoTop())
    While !( (cAliasQ)->(EoF()) )
        cTec   := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_TECNICO")) )) )
        cPrj   := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_PROJETO")) )) )
        cCli   := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_CLIENTE")) )) )
        cLoja  := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_LOJA")) )) )
        cAgdId := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_CODIGO")) )) )

        aContatos := FT_GetContatosAgendaByCodigo(cAgdId)
        For nCont := 1 To Len(aContatos)
            cContId    := aContatos[nCont,1]
            cContNome  := aContatos[nCont,2]
            cContEmail := aContatos[nCont,3]

            oRow := JsonObject():New()
            oRow["Z1_TECNICO"] := cTec
            oRow["Z1_PROJETO"] := cPrj
            oRow["Z1_FILIAL"]  := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_FILIAL")) )) )
            oRow["Z1_CODIGO"]  := cAgdId
            oRow["Z1_STATUS"]  := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_STATUS")) )) )
            oRow["Z1_APDATA"]  := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_APDATA")) )) )
            oRow["Z1_DATA"]    := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_DATA")) )) )
            oRow["Z1_CLIENTE"] := cCli
            oRow["Z1_LOJA"]    := cLoja
            oRow["Z1_APHRINI"] := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_APHRINI")) )) )
            oRow["Z1_APHRFIM"] := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_APHRFIM")) )) )
            oRow["Z1_AGHRINI"] := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_AGHRINI")) )) )
            oRow["Z1_AGHRFIM"] := AllTrim( (cAliasQ)->(FieldGet( (cAliasQ)->(FieldPos("Z1_AGHRFIM")) )) )
            oRow["CONT_ID"]    := cContId
            oRow["CONT_NOME"]  := cContNome
            oRow["CONT_EMAIL"] := cContEmail

            FT_GroupPush3(@aGroups, cTec, cPrj, cContId, cContNome, cContEmail, oRow)
        Next

        nCount++
        If (nCount % 1000) == 0
            ConOut(LOG_TAG + "Progresso SZ1: " + AllTrim(Str(nCount)) + " linhas...")
        EndIf

        (cAliasQ)->(DbSkip())
    EndDo

    (cAliasQ)->(DbCloseArea())
    ConOut(LOG_TAG + "FT_SelectGroupSZ1_ComContato – FIM. linhas=" + AllTrim(Str(nCount)) + ;
           " grupos=" + AllTrim(Str(Len(aGroups))))
Return aGroups

/* Contatos ATIVOS (ZP9_STATUS='A') da agenda (ZP9_CODIGO = SZ1.Z1_CODIGO).
   Retorna array { {id, nome, email}, ... } – nome/email vindos da SU5. */
Static Function FT_GetContatosAgendaByCodigo(cAgdId)
    Local aContatos := {}
    Local cZP9      := RetSqlName("ZP9")
    Local cSU5      := RetSqlName("SU5")
    Local cSQL      := ""
    Local cAliasQ   := ""
    Local cId       := ""
    Local cNome     := ""
    Local cEmail    := ""

    If Empty(cZP9) .or. Empty(cSU5)
        ConOut(LOG_TAG + "ERRO: RetSqlName ZP9/SU5 vazio")
        Return aContatos
    EndIf

    cSQL := ;
        "SELECT ZP9.ZP9_CONTID, " + ;
        "       ISNULL(SU5.U5_CONTAT,'') AS NOME, " + ;
        "       ISNULL(SU5.U5_EMAIL ,'') AS EMAIL " + ;
        "FROM " + cZP9 + " ZP9 WITH (NOLOCK) " + ;
        "LEFT JOIN " + cSU5 + " SU5 WITH (NOLOCK) " + ;
        "  ON SU5.D_E_L_E_T_ = '' AND SU5.U5_CODCONT = ZP9.ZP9_CONTID " + ;
        "WHERE ZP9.D_E_L_E_T_ = '' " + ;
        "  AND ZP9.ZP9_STATUS = 'A' " + ;
        "  AND ZP9.ZP9_CODIGO = '" + AllTrim(cAgdId) + "' " + ;
        "ORDER BY ZP9.ZP9_CONTID"

    ConOut(LOG_TAG + "SQL (ZP9 por CODIGO) => " + cSQL)

    cAliasQ := MpSysOpenQuery(cSQL)
    If Empty(cAliasQ) .or. Select(cAliasQ) == 0
        ConOut(LOG_TAG + "ERRO: MpSysOpenQuery não retornou alias válido (ZP9)")
        Return aContatos
    EndIf

    (cAliasQ)->(DbGoTop())
    While !( (cAliasQ)->(EoF()) )
        cId    := AllTrim( (cAliasQ)->(FieldGet(1)) )
        cNome  := AllTrim( (cAliasQ)->(FieldGet(2)) )
        cEmail := AllTrim( (cAliasQ)->(FieldGet(3)) )
        AAdd(aContatos, { cId, cNome, cEmail })
        (cAliasQ)->(DbSkip())
    EndDo
    (cAliasQ)->(DbCloseArea())
Return aContatos

/* ---------------------------- HELPERS DE GRUPO ---------------------------- */
Static Function FT_GroupPush3(aGroups, cTec, cProj, cContId, cContNome, cContEmail, oRow)
    Local i := 0
    Local oG := NIL
    // procura grupo
    For i := 1 To Len(aGroups)
        oG := aGroups[i]
        If oG["tecnico"] == cTec .and. oG["projeto"] == cProj .and. oG["contato_id"] == cContId
            AAdd(oG["registros"], oRow)
            oG["qtde"] := Len(oG["registros"])
            Return
        EndIf
    Next
    // cria novo
    oG := JsonObject():New()
    oG["tecnico"]       := cTec
    oG["projeto"]       := cProj
    oG["contato_id"]    := cContId
    oG["contato_nome"]  := cContNome
    oG["contato_email"] := cContEmail
    oG["registros"]     := {}
    oG["qtde"]          := 0
    AAdd(oG["registros"], oRow)
    oG["qtde"] := 1
    AAdd(aGroups, oG)
Return

/* ---------------------------- HELPERS ARQUIVO ----------------------------- */
Static Function FT_GetOutDir()
    Local cBase   := AllTrim(GetSrvProfString("Env","RootPath",""))
    //Local cSpool  := If(Empty(cBase), "", cBase + "\SPOOL")
    Local cDirOut := If(Empty(cBase), "\SPOOL\OSCLICK\", cBase + "\SPOOL\OSCLICK\")

    // Cria em duas etapas; se já existir, MakeDir() apenas retorna .F. e segue.
    If !Empty(cBase)
        MakeDir(cBase + "\SPOOL")
        MakeDir(cBase + "\SPOOL\OSCLICK")
    Else
        // Caso extremo: RootPath não definido – ainda assim tenta criar no relativo
        MakeDir("\SPOOL")
        MakeDir("\SPOOL\OSCLICK")
    EndIf

Return cDirOut

Static Function FT_SanitizeName(cName)
    Local c := AllTrim(cName)
    // remove acentos básicos e caracteres inválidos para nome de arquivo
    c := StrTran(c, " ", "_")
    c := StrTran(c, "/", "-")
    c := StrTran(c, "\\", "-")
    c := StrTran(c, ":", "-")
    c := StrTran(c, "*", "-")
    c := StrTran(c, "?", "-")
    c := StrTran(c, "<", "(")
    c := StrTran(c, ">", ")")
    c := StrTran(c, "|", "-")
Return c

/* Nome do documento: PROJETO + CLIENTE + CONSULTOR + DTINI + DTFIM (AAAAMMDD) */
Static Function FT_MakeDocName(cProj, cNomeCli, cNomeTec, cDtIni, cDtFim)
    Local c := AllTrim(cProj) + "_" + FT_SanitizeName(cNomeCli) + "_" + FT_SanitizeName(cNomeTec) + "_" + FT_SafeDToS(cDtIni) + "_" + FT_SafeDToS(cDtFim)
Return c

/* Calcula menor/maior Z1_APDATA no array de registros do grupo */
Static Function FT_MinMaxDatas(aRegs, cDtIni, cDtFim)
    Local n := 0
    Local cD := ""
    Local cMin := ""
    Local cMax := ""
    For n := 1 To Len(aRegs)
        cD := AllTrim(aRegs[n]["Z1_APDATA"])
        If Empty(cMin) .or. cD < cMin
            cMin := cD
        EndIf
        If Empty(cMax) .or. cD > cMax
            cMax := cD
        EndIf
    Next
    cDtIni := cMin
    cDtFim := cMax
Return

/* Busca nome do cliente (SA1) */
Static Function FT_GetNomeCliente(cA1, cLoja)
    Local cSA1 := RetSqlName("SA1")
    Local cSQL := ""
    Local cAli := ""
    Local cNom := ""
    If Empty(cSA1)
        Return ""
    EndIf
    cSQL := "SELECT TOP 1 A1_NOME FROM " + cSA1 + " WITH (NOLOCK) " + ;
            "WHERE D_E_L_E_T_ = '' AND A1_COD = '" + AllTrim(cA1) + "' AND A1_LOJA = '" + AllTrim(cLoja) + "'"
    cAli := MpSysOpenQuery(cSQL)
    If !Empty(cAli) .and. Select(cAli) > 0
        (cAli)->(DbGoTop())
        If !( (cAli)->(EoF()) )
            cNom := AllTrim( (cAli)->(FieldGet(1)) )
        EndIf
        (cAli)->(DbCloseArea())
    EndIf
Return cNom

/* Busca nome do consultor (por enquanto, retorna o próprio código do técnico) */
Static Function FT_Consultor(cTec)
Return AllTrim(cTec)

/* -------------------------- GERAÇÃO BÁSICA DE PDF ------------------------- */
/* Gera um PDF simplificado do grupo, listando as OS do período.
   - cDirOut: diretório (deve estar dentro do RootPath para evitar erro do FWMSPrinter)
   - cFile   : nome do arquivo (ex.: PROJ_CLIENTE_CONSULTOR_DtIni_DtFim.PDF)
   - oGroup  : JsonObject com chaves: tecnico, projeto, contato_*, registros[]
   Retorna .T. se gerou PDF; se falhar, tenta gravar .TXT com o mesmo conteúdo. */
/* Gera 1 PDF ÚNICO por grupo (usando layout ITFATR04) */
Static Function FT_GeraPdfGrupo(cDirOut, cFile, oGroup)
    Local lOk     := .F.
    Local aRegs   := oGroup["registros"]
    Local cPdfOut := ""

    // Gera o PDF agrupado reaproveitando o layout da ITFATR04
    // Observação: aRegs é o array de objetos criado pelos métodos GET (contém Z1_* completos)
    Begin Sequence
        cPdfOut := U_ITFATRGRP04(aRegs, cFile, cDirOut)
        lOk     := File(cPdfOut)
    Recover
        lOk     := .F.
    End Sequence
Return lOk

/* Date -> AAAAMMDD; se vier C, devolve como veio; senão "" */
Static Function FT_SafeDToS(u)
    Local c := ""
    If ValType(u) == "D"
        c := DToS(u)
    ElseIf ValType(u) == "C"
        c := AllTrim(u)
    EndIf
Return c


/* Clicksign v3: cria envelope, sobe PDF, adiciona signatário e envia.
   cPdfPath  : caminho local do PDF
   cNomeEnv  : nome do envelope (exibição)
   cEmail/cNomeSigner: signatário (aqui usamos override de teste)
   Retorna JsonObject com IDs e HTTP logs. */
Static Function FT_ClickV3_SendEnvelope(cPdfPath, cNomeEnv, cEmail, cNomeSigner)
    Local oRet     := JsonObject():New()
    Local aHttp    := {}
    Local cEnvId   := ""
    Local cDocId   := ""
    Local cSgnId   := ""
    Local cUrl     := ""
    Local cResp    := ""
    Local nCode    := 0
    Local cErr     := ""
    Local oAttr    := NIL
    Local oData    := NIL
    Local oBody    := NIL
    Local oJson    := NIL
    Local cB64     := ""
    Local cName
    Local cData 
    Local oRel, oDoc, oDocData, oSgn, oSgnData

    ConOut("inicio FT_ClickV3_SendEnvelope")

    // Defaults (sem default na assinatura)
    If Empty(cEmail)
        cEmail := CKS_TEST_EMAIL
    EndIf
    If Empty(cNomeSigner)
        cNomeSigner := "Teste KODIGOS"
    EndIf

    // retorno base
    oRet["ok"]        := .F.
    oRet["env_id"]    := ""
    oRet["doc_id"]    := ""
    oRet["signer_id"] := ""
    oRet["http_log"]  := {}

    /* ===== 1) Criar envelope ===== */
    oAttr := JsonObject():New()
    oAttr["name"] := cNomeEnv

    oData := JsonObject():New()
    oData["type"]       := "envelopes"
    oData["attributes"] := oAttr

    oBody := JsonObject():New()
    oBody["data"] := oData

    cUrl  := CKS_BASE_V3 + "/envelopes"
    cResp := FT__HttpJSON("POST", cUrl, oBody:ToJson(), @nCode, @cErr)
    AAdd(aHttp, {"create_env", nCode, IIf(Empty(cResp), cErr, FT__LogTrunc(cResp))})
    ConOut(LOG_TAG + "v3 create_env => " + AllTrim(Str(nCode)))

    If nCode < 200 .or. nCode >= 300
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    ConOut("antes de buscar data")

    If Empty(AllTrim(cResp))
        AAdd(aHttp, {"parse_env", 0, "Resposta vazia no create_env (201/204?)"})
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    cResp := FT__SanitizeJson(cResp)

    // Tenta parse com JsonObject
    oJson := JsonObject():New()
    If oJson:FromJson(cResp)
        If ValType(oJson["data"]) == "O" .and. ValType(oJson["data"]["id"]) == "C"
            cEnvId := AllTrim(oJson["data"]["id"])
        EndIf
    EndIf

    // Fallback por varredura textual
    If Empty(cEnvId)
        cEnvId := FT__JsonPickId(cResp)
    EndIf

    If Empty(cEnvId)
        AAdd(aHttp, {"parse_env", 0, "JSON sem data.id no create_env. Trecho: " + FT__LogTrunc(cResp)})
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    oRet["env_id"] := cEnvId

    ConOut("antes do Adicionar Documento")

    /* ===== 2) Adicionar documento (base64) ===== */
    cB64 := FT_FileToBase64(cPdfPath)
    cB64 := FT__B64Clean(cB64) // remove CR/LF/espaços do base64
    If Empty(cB64)
        AAdd(aHttp, {"add_doc", 0, "ERRO: base64 vazio"})
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    oAttr := JsonObject():New()

    cName := FT_JustFileName(cPdfPath)
    cName := Lower(cName)
    cData := "data:application/pdf;base64," + cB64
    oAttr["filename"]       := cName
    //oAttr["filename"] := FT_JustFileName(cPdfPath)
    //oAttr["filename"] := "documento.pdf"
    oAttr["content_base64"]  := cData
    //oAttr["mimetype"] := "application/pdf"

    oData := JsonObject():New()
    oData["type"]       := "documents"
    oData["attributes"] := oAttr

    oBody := JsonObject():New()
    oBody["data"] := oData

    ConOut("ADD_DOC filename=" + oAttr["filename"] + " b64_len=" + AllTrim(Str(Len(cB64))))

    cUrl  := CKS_BASE_V3 + "/envelopes/" + cEnvId + "/documents"
    cResp := FT__HttpJSON("POST", cUrl, oBody:ToJson(), @nCode, @cErr)
    AAdd(aHttp, {"add_doc", nCode, IIf(Empty(cResp), cErr, FT__LogTrunc(cResp))})
    ConOut(LOG_TAG + "v3 add_doc => " + AllTrim(Str(nCode)))

    If nCode < 200 .or. nCode >= 300
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    If Empty(AllTrim(cResp))
        AAdd(aHttp, {"parse_doc", 0, "Resposta vazia no add_doc"})
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    cResp := FT__SanitizeJson(cResp)

    oJson := JsonObject():New()
    If oJson:FromJson(cResp)
        If ValType(oJson["data"]) == "O" .and. ValType(oJson["data"]["id"]) == "C"
            cDocId := AllTrim(oJson["data"]["id"])
        EndIf
    EndIf
    If Empty(cDocId)
        cDocId := FT__JsonPickId(cResp)
    EndIf

    If Empty(cDocId)
        AAdd(aHttp, {"parse_doc", 0, "JSON sem data.id no add_doc. Trecho: " + FT__LogTrunc(cResp)})
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    oRet["doc_id"] := cDocId

    ConOut("antes do Adicionar Signatario")

    /* ===== 3) Adicionar signatário ===== */
    oAttr := JsonObject():New()
    oAttr["email"] := cEmail
    oAttr["name"]  := cNomeSigner

    oData := JsonObject():New()
    oData["type"]       := "signers"
    oData["attributes"] := oAttr

    oBody := JsonObject():New()
    oBody["data"] := oData

    cUrl  := CKS_BASE_V3 + "/envelopes/" + cEnvId + "/signers"
    cResp := FT__HttpJSON("POST", cUrl, oBody:ToJson(), @nCode, @cErr)
    AAdd(aHttp, {"add_signer", nCode, IIf(Empty(cResp), cErr, FT__LogTrunc(cResp))})
    ConOut(LOG_TAG + "v3 add_signer => " + AllTrim(Str(nCode)))

    If nCode < 200 .or. nCode >= 300
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    If Empty(AllTrim(cResp))
        AAdd(aHttp, {"parse_signer", 0, "Resposta vazia no add_signer"})
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    cResp := FT__SanitizeJson(cResp)

    oJson := JsonObject():New()
    If oJson:FromJson(cResp)
        If ValType(oJson["data"]) == "O" .and. ValType(oJson["data"]["id"]) == "C"
            cSgnId := AllTrim(oJson["data"]["id"])
        EndIf
    EndIf
    If Empty(cSgnId)
        cSgnId := FT__JsonPickId(cResp)
    EndIf

    If Empty(cSgnId)
        AAdd(aHttp, {"parse_signer", 0, "JSON sem data.id no add_signer. Trecho: " + FT__LogTrunc(cResp)})
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    oRet["signer_id"] := cSgnId

    ConOut("antes de enviar Requisitos")
/* ===== 3.1) Adicionar requisito (ligar signatário ao documento) ===== */
    oAttr := JsonObject():New()
    oAttr["action"]       := "agree"        // requisito de concordância/rubrica
   // oAttr["role"]        := "sign"   // papel do signatário
    oAttr["role"]   := "intervening"

    oData := JsonObject():New()
    oData["type"]        := "requirements"
    oData["attributes"]  := oAttr

    // relationships: document + signer
    oRel     := JsonObject():New()
    oDoc     := JsonObject():New()
    oDocData := JsonObject():New()
    oDocData["type"] := "documents"
    oDocData["id"]   := cDocId
    oDoc["data"]     := oDocData
    oRel["document"] := oDoc

    oSgn     := JsonObject():New()
    oSgnData := JsonObject():New()
    oSgnData["type"] := "signers"
    oSgnData["id"]   := cSgnId
    oSgn["data"]     := oSgnData
    oRel["signer"]   := oSgn

    oData["relationships"] := oRel

    oBody := JsonObject():New()
    oBody["data"] := oData

    cUrl  := CKS_BASE_V3 + "/envelopes/" + cEnvId + "/requirements"
    cResp := FT__HttpJSON("POST", cUrl, oBody:ToJson(), @nCode, @cErr)
    AAdd(aHttp, {"add_requirement", nCode, IIf(Empty(cResp), cErr, cResp)})
    ConOut(LOG_TAG + "v3 add_requirement => " + AllTrim(Str(nCode)))

    If nCode < 200 .or. nCode >= 300
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    ConOut("antes de Adicionar requisito de autenticacao")
/* ===== 3.2) Adicionar requisito de AUTENTICAÇÃO (ex.: token por e-mail) ===== */
    oAttr := JsonObject():New()
    oAttr["action"]   := "provide_evidence"
    // método de autenticação desejado (opções comuns: "email_token", "sms_token", "whatsapp_token", "pix", "certificate")
    // se sua conta exigir outro, ajuste aqui:
    oAttr["auth"] := "email"

    oData := JsonObject():New()
    oData["type"]       := "requirements"
    oData["attributes"] := oAttr

    // relaciona o MESMO documento e signatário usados no 3.1
    oRel     := JsonObject():New()
    oDoc     := JsonObject():New()
    oDocData := JsonObject():New()
    oDocData["type"] := "documents"
    oDocData["id"]   := cDocId
    oDoc["data"]     := oDocData
    oRel["document"] := oDoc

    oSgn     := JsonObject():New()
    oSgnData := JsonObject():New()
    oSgnData["type"] := "signers"
    oSgnData["id"]   := cSgnId
    oSgn["data"]     := oSgnData
    oRel["signer"]   := oSgn

    oData["relationships"] := oRel

    oBody := JsonObject():New()
    oBody["data"] := oData

    cUrl  := CKS_BASE_V3 + "/envelopes/" + cEnvId + "/requirements"
    cResp := FT__HttpJSON("POST", cUrl, oBody:ToJson(), @nCode, @cErr)
    AAdd(aHttp, {"add_auth_requirement", nCode, IIf(Empty(cResp), cErr, cResp)})
    ConOut(LOG_TAG + "v3 add_auth_requirement => " + AllTrim(Str(nCode)))

    If nCode < 200 .or. nCode >= 300
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    ConOut("antes de ativar envelope")

    /* ===== 4) Ativar envelope (status=running) ===== */
    oAttr := JsonObject():New()
    oAttr["status"] := "running"

    oData := JsonObject():New()
    oData["type"]       := "envelopes"
    oData["id"]         := cEnvId   
    oData["attributes"] := oAttr

    oBody := JsonObject():New()
    oBody["data"] := oData

    cUrl  := CKS_BASE_V3 + "/envelopes/" + cEnvId
    cResp := FT__HttpJSON("PATCH", cUrl, oBody:ToJson(), @nCode, @cErr)
    If nCode == 405 .or. nCode == 501 .or. nCode == 0 .or. Empty(cResp)
        cResp := FT__HttpJSON("PUT", cUrl, oBody:ToJson(), @nCode, @cErr)
    EndIf
    AAdd(aHttp, {"activate_env", nCode, IIf(Empty(cResp), cErr, FT__LogTrunc(cResp))})
    ConOut(LOG_TAG + "v3 activate_env => " + AllTrim(Str(nCode)))

    If nCode < 200 .or. nCode >= 300
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    ConOut("antes do Notificar")

    /* ===== 5) Notificar ===== */
    oAttr := JsonObject():New()
    oAttr["message"] := "Por favor, assinar a OS."

    oData := JsonObject():New()
    oData["type"]       := "notifications"
    oData["attributes"] := oAttr

    oBody := JsonObject():New()
    oBody["data"] := oData

    cUrl  := CKS_BASE_V3 + "/envelopes/" + cEnvId + "/notifications"
    cResp := FT__HttpJSON("POST", cUrl, oBody:ToJson(), @nCode, @cErr)
    AAdd(aHttp, {"notify_env", nCode, IIf(Empty(cResp), cErr, FT__LogTrunc(cResp))})
    ConOut(LOG_TAG + "v3 notify_env => " + AllTrim(Str(nCode)))

    oRet["ok"]       := (nCode >= 200 .and. nCode < 300)
    oRet["http_log"] := aHttp
Return oRet


Static Function FT__HttpJSON(cMethod, cUrl, cBody, nCode, cErr)
    Local aHead := {}
    Local cHeadRet := ""
    Local cResp := ""

    aHead := {}
    AAdd(aHead, "Authorization: " + CKS_TOKEN)                 // v3: token direto
    AAdd(aHead, "Accept: application/vnd.api+json")
    AAdd(aHead, "Content-Type: application/vnd.api+json")

    cErr  := ""
    nCode := 0

    // POST usa HTTPSPost (não exige cert se passar "" nos 3 primeiros params) — TDN. :contentReference[oaicite:1]{index=1}
    If Upper(AllTrim(cMethod)) == "POST"
        cResp := HTTPSPost(cUrl, "", "", "", "", cBody, 120, aHead, @cHeadRet, .F.)
    Else
        // PATCH / PUT via HTTPQuote (permite definir o método) — ver referências/threads TDN. :contentReference[oaicite:2]{index=2}
        cResp := HTTPQuote(cUrl, Upper(AllTrim(cMethod)), "", cBody, 120, aHead, @cHeadRet)
    EndIf

    // Captura status HTTP — TDN HTTPGetStatus. :contentReference[oaicite:3]{index=3}
    nCode := HTTPGetStatus(@cErr, .F.)
Return cResp

/* Extrai apenas o nome do arquivo de um caminho */
Static Function FT_JustFileName(cPath)
    Local c := AllTrim(cPath)
    Local n := Rat("\", c)
    If n == 0
        n := Rat("/", c)
    EndIf
    If n > 0
        c := SubStr(c, n+1)
    EndIf
Return c

/* Lê arquivo e retorna Base64 (usa a função disponível na tua build) */
Static Function FT_FileToBase64(cPath)
    Local nH     := FOpen(cPath)
    Local cBuf   := ""               // buffer acumulado
    Local cChunk := Space(65535)     // bloco de leitura
    Local nRead  := 0
    Local cB64   := ""

    If nH < 0
        Return ""
    EndIf

    // Lê em blocos até EOF
    While .T.
        nRead := FRead(nH, @cChunk, Len(cChunk))
        If nRead <= 0
            Exit
        EndIf
        cBuf += SubStr(cChunk, 1, nRead)
    EndDo

    FClose(nH)

    // Codifica em Base64 usando o que existir na tua AppMap
    Begin Sequence
        If      FindFunction("Encode64")      ; cB64 := Encode64(cBuf)
        ElseIf  FindFunction("Base64Encode")  ; cB64 := Base64Encode(cBuf)
        ElseIf  FindFunction("FWBase64Encode"); cB64 := FWBase64Encode(cBuf)
        ElseIf  FindFunction("MsToBase64")    ; cB64 := MsToBase64(cBuf)
        Else
            cB64 := "" // nenhuma função de base64 disponível
        EndIf
    Recover
        cB64 := ""
    End Sequence

Return cB64

/* Remove BOM, NUL e controles 0x00..0x1F (mantém TAB/LF/CR) */
Static Function FT__SanitizeJson(cJson)
    Local cOut := cJson
    Local n, cChr, cClean := ""

    // Remove BOM UTF-8 (EF BB BF)
    If Len(cOut) >= 3 .and. SubStr(cOut,1,3) == (Chr(239)+Chr(187)+Chr(191))
        cOut := SubStr(cOut,4)
    EndIf

    // Remove NUL (\0)
    cOut := StrTran(cOut, Chr(0), "")

    // Remove controles, exceto TAB (9), LF (10), CR (13)
    For n := 1 To Len(cOut)
        cChr := SubStr(cOut, n, 1)
        If Asc(cChr) >= 32 .or. cChr $ Chr(9)+Chr(10)+Chr(13)
            cClean += cChr
        EndIf
    Next

Return cClean

Static Function FT__LogTrunc(cStr)
    If Len(cStr) <= _MAX_LOG_LEN
        Return cStr
    EndIf
Return SubStr(cStr, 1, _MAX_LOG_LEN)

/* Fallback textual simples: pega data.id após a chave "data" */
Static Function FT__JsonPickId(cJson)
    Local c := cJson
    Local nData := FT__FindFrom(c, '"data"', 1)
    Local nId   := 0
    Local nBeg  := 0
    Local nEnd  := 0

    If nData > 0
        nId := FT__FindFrom(c, '"id":"', nData)
    Else
        nId := FT__FindFrom(c, '"id":"', 1)
    EndIf

    If nId > 0
        nBeg := nId + Len('"id":"')
        nEnd := FT__FindFrom(c, '"', nBeg)
        If nEnd > 0 .and. nEnd > nBeg
            Return SubStr(c, nBeg, nEnd - nBeg)
        EndIf
    EndIf

Return ""


/* Busca padrão a partir de um offset (1-based). Retorna 0 se não achar. */
Static Function FT__FindFrom(cText, cPattern, nStart)
    Local nPos := 0
    Local cSub := ""

    If nStart < 1
        nStart := 1
    EndIf

    If nStart > Len(cText)
        Return 0
    EndIf

    cSub := SubStr(cText, nStart)
    nPos := At(cPattern, cSub)
    If nPos > 0
        nPos := nPos + nStart - 1
    EndIf

Return nPos

Static Function FT__B64Clean(cB64)
    Local c := cB64
    c := StrTran(c, Chr(13), "") // CR
    c := StrTran(c, Chr(10), "") // LF
    c := StrTran(c, " ", "")     // espaços
Return c

/* Gera um filename seguro e com extensão .pdf */
Static Function FT__SafeFileName(cPath)
    Local cName := FT_JustFileName(cPath)
    Local cOut  := ""
    Local i     := 0
    Local cChr  := ""
    Local nDot  := 0
    Local cExt  := ""

    If Empty(AllTrim(cName))
        cName := "documento.pdf"
    EndIf

    // mantém apenas [A-Za-z0-9._-]
    For i := 1 To Len(cName)
        cChr := SubStr(cName, i, 1)
        If (cChr >= "A" .and. cChr <= "Z") .or. ;
           (cChr >= "a" .and. cChr <= "z") .or. ;
           (cChr >= "0" .and. cChr <= "9") .or. ;
           cChr == "." .or. cChr == "_" .or. cChr == "-"
            cOut += cChr
        Else
            cOut += "_" // troca acentos, espaços e símbolos
        EndIf
    Next

    // garante .pdf
    nDot := Rat(".", cOut)
    If nDot > 0
        cExt := Lower(SubStr(cOut, nDot+1))
        If cExt != "pdf"
            cOut := SubStr(cOut, 1, nDot-1) + ".pdf"
        EndIf
    Else
        cOut += ".pdf"
    EndIf

    // limita tamanho
    If Len(cOut) > 120
        cOut := SubStr(cOut, 1, 120)
    EndIf

    If Empty(AllTrim(cOut))
        cOut := "documento.pdf"
    EndIf
Return cOut
