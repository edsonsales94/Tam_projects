/* ============================================================================
   OSCLICKENV.PRW – Envio de OS apontadas para Clicksign – pré-seleção + PDF
   GET  /rest/osclickenv/api/kodigos/v1/click/os
   GET  /rest/osclickenv/api/kodigos/v1/click/os/pdf   (gera 1 PDF por grupo)
   - Janela fixa dos últimos 15 dias
   - SZ1 com Z1_STATUS = 'L' (Apontado) e Z1_APDATA na janela
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


WSMETHOD POST cancelEnvelope DESCRIPTION ;
    "Cancela envelope Clicksign e limpa SZ1.Z1_ZP7ENV" ;
    WSSYNTAX "/api/kodigos/v1/click/os/cancel" ;
    PATH     "/api/kodigos/v1/click/os/cancel"
END WSRESTFUL

/* -------------------------------- MÉTODOS --------------------------------- */
WSMETHOD POST testPdfOS WSRECEIVE WSREST OSCLICKENV
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

    // 2) Parse JSON 
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

    // 5) Geração do PDF 
    ConOut("[testPdfOS] Chamando U_ITFATR04(" + cValToChar(nRecno) + ")")
    cPdf := U_ITFATR04(nRecno)
    ConOut("[testPdfOS] Retorno U_ITFATR04: " + cPdf)

    // 6) Verificação de existência 
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
    Local aOS        := {}
    local nMarc

    ConOut(LOG_TAG + "INÍCIO /os/send v3")
    ConOut(LOG_TAG + "Janela => " + DToS(dIni) + " .. " + DToS(dFim))

    aGroups := FT_SelectGroupSZ1_ComContato(dIni, dFim)
    cDirOut := FT_GetOutDir()
    ConOut(LOG_TAG + "Saída PDF: " + cDirOut)

    For i := 1 To Len(aGroups)
        aOS := {} 
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

        If oItem:HasProperty("env_id") .and. oItem:HasProperty("doc_id") ;
        .and. !Empty(oItem["env_id"]) .and. !Empty(oItem["doc_id"])

            Grava_env( ;
                oItem["env_id"], ;      // ZP7_ENV
                oItem["doc_id"], ;      // ZP7_DOC
                cProj, ;                // ZP7_PROJ
                cTec,  ;                // ZP7_TEC
                oG["contato_id"], ;     // ZP7_CONTID
                "S" )                   // ZP7_STATUS (S = Enviado)

            //marca OS enviadas na SZ1
            ConOut(LOG_TAG + "DEBUG SZ1 mark: ValType(aRegs)=" + ValType(aRegs) + ;
                " len=" + IIf(ValType(aRegs)=="A", AllTrim(Str(Len(aRegs))), "-"))
            aOS := FT_GetOSCodes(oG["registros"])
            ConOut(LOG_TAG + "SZ1: qtde OS no grupo (pos-extracao)=" + AllTrim(Str(Len(aOS))))
            If Len(aOS) > 0
                nMarc := FT_SZ1_MarcaEnv(aOS, oItem["env_id"])
                ConOut(LOG_TAG + "SZ1: OS marcadas com env_id=" + AllTrim(Str(nMarc)))
            Else
                ConOut(LOG_TAG + "SZ1: WARN – grupo sem OS para marcar")
            EndIf

        Else
            ConOut(LOG_TAG + "Sem doc_id/env_id para gravar ZP7 (envelope ainda sem documento?).")
        EndIf

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
    Local oJsonRet        := JsonObject():New()
    Local dIni            := Date() - CKS_DAYSBACK
    Local dFim            := Date()
    Local aGroups         := {}
    Local aPdfs           := {}
    Local i               := 0
    Local oG              := NIL
    Local aRegs           := {}
    Local cProj           := ""
    Local cTec            := ""
    Local cContId         := ""
    Local cContNome       := ""
    Local cContEmail      := ""
    Local cCli            := ""
    Local cLoja           := ""
    Local cNomeCli        := ""
    Local cNomeTec        := ""
    Local cDtIniOS        := ""
    Local cDtFimOS        := ""
    Local cDirOut         := ""
    Local cFileBase       := ""
    Local cFilePath       := ""
    Local cFileName       := ""
    Local cFileNameNoExt  := ""
    Local lOkPdf          := .F.
    Local oItem           := NIL
    Local nSep            := 0

    ConOut(LOG_TAG + "INÍCIO GET /os/pdf (gerar PDFs)")
    ConOut(LOG_TAG + "Janela => dtini=" + DToS(dIni) + ", dtfim=" + DToS(dFim))

    // Agrupamento por Analista/Consultor + Projeto + Aprovador[Contato]
    aGroups := FT_SelectGroupSZ1_ComContato(dIni, dFim)

    // Diretório de saída (ex.: RootPath\SPOOL\OSCLICK\)
    cDirOut := FT_GetOutDir()
    ConOut(LOG_TAG + "Saída de PDF em: " + cDirOut)

    For i := 1 To Len(aGroups)

        oG        := aGroups[i]
        cProj     := oG["projeto"]
        cTec      := oG["tecnico"]
        cContId   := oG["contato_id"]
        cContNome := oG["contato_nome"]
        cContEmail:= oG["contato_email"]
        aRegs     := oG["registros"]

        If Len(aRegs) > 0

            cCli := aRegs[1]["Z1_CLIENTE"]
            cLoja:= aRegs[1]["Z1_LOJA"]

            // Janela real da OS (datas mínima e máxima dos registros do grupo)
            FT_MinMaxDatas(@aRegs, @cDtIniOS, @cDtFimOS)

            // Nomes "bonitos" para cliente e consultor
            cNomeCli := FT_GetNomeCliente(cCli, cLoja)
            cNomeTec := FT_Consultor(cTec) // se não mapear, retorna o próprio código

            // Padrão de nome exigido pela regra de negócio:
            // PROJETO + NOME CLIENTE + NOME CONSULTOR + DT INÍCIO + DT FIM
            cFileBase := FT_MakeDocName(cProj, cNomeCli, cNomeTec, cDtIniOS, cDtFimOS) + ".pdf"

            // Gera um CAMINHO único (evita sobreposição) mantendo o padrão de base
            cFilePath := FT_UniquePath(cDirOut, cFileBase)

            // Extrai apenas o NOME do arquivo (sem diretório)
            nSep      := Max(RAt("\", cFilePath), RAt("/", cFilePath))
            cFileName := SubStr(cFilePath, nSep + 1)

            // Alguns geradores esperam o nome SEM extensão
            cFileNameNoExt := AllTrim(cFileName)
            If Upper(Right(cFileNameNoExt, 4)) == ".PDF"
                cFileNameNoExt := SubStr(cFileNameNoExt, 1, Len(cFileNameNoExt) - 4)
            EndIf

            // Geração efetiva:
            // 1º parâmetro = diretório de saída
            // 2º parâmetro = APENAS o nome (sem diretório); aqui passamos SEM extensão por compatibilidade
            lOkPdf := FT_GeraPdfGrupo(cDirOut, cFileNameNoExt, oG)

            // Monta item de retorno (arquivo informado com .pdf, que é o que será salvo ao final)
            oItem := JsonObject():New()
            oItem["ok"]            := lOkPdf
            oItem["arquivo"]       := cDirOut + cFileNameNoExt + ".pdf"
            oItem["tecnico"]       := cTec
            oItem["projeto"]       := cProj
            oItem["contato_id"]    := cContId
            oItem["contato_nome"]  := cContNome
            oItem["contato_email"] := cContEmail
            oItem["qtde"]          := Len(aRegs)
            AAdd(aPdfs, oItem)

            ConOut(LOG_TAG + "PDF " + If(lOkPdf, "OK ", "ERRO ") + "=> " + (cDirOut + cFileNameNoExt + ".pdf") + ;
                          " (qtde=" + AllTrim(Str(Len(aRegs))) + ")")
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
    cSQL += "  Z1_APHRINI, Z1_APHRFIM, Z1_APHRALM, "   
    cSQL += "  Z1_AGHRINI, Z1_AGHRFIM, "             
    cSQL += "  Z1_APTRANS, "                         
    cSQL += "  Z1_APTEXTO "                            
    cSQL += "FROM " + cSZ1 + " WITH (NOLOCK) "
    cSQL += "WHERE D_E_L_E_T_ = '' "
    cSQL += "  AND Z1_STATUS  = '" + CKS_STATUS + "' "
    cSQL += "  AND Z1_APDATA BETWEEN '" + cDtI + "' AND '" + cDtF + "' "
    cSQL += "  AND ISNULL(RTRIM(Z1_ZP7ENV), '') = '' " 
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
            oRow["Z1_APHRALM"] := AllTrim( (cAliasQ)->( FieldGet( (cAliasQ)->( FieldPos("Z1_APHRALM") ) ) ) )
            oRow["Z1_APTRANS"] := AllTrim( (cAliasQ)->( FieldGet( (cAliasQ)->( FieldPos("Z1_APTRANS") ) ) ) )
            oRow["Z1_APTEXTO"] := AllTrim( (cAliasQ)->( FieldGet( (cAliasQ)->( FieldPos("Z1_APTEXTO") ) ) ) )


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

/* Gera caminho único se já existir arquivo com mesmo nome */
Static Function FT_UniquePath(cDirOut, cBaseName)
   Local cName   := AllTrim(cBaseName)
   Local cStem   := cName
   Local n       := 1
   Local cTry    := "" 

   // tira extensão .pdf se veio
   If Upper(Right(cStem,4)) == ".PDF"
      cStem := SubStr(cStem,1,Len(cStem)-4)
   EndIf

   // primeira tentativa
    cTry := cStem + ".pdf"

   // incrementa -001, -002... se colidir
   While File(cDirOut + cTry) .and. n < 1000
      n++
      cTry := cStem + "-" + PadL(AllTrim(Str(n)),3,"0") + ".pdf"
   EndDo

Return cDirOut + cTry


Static Function Grava_env(cEnvId, cDocId, cProj, cTec, cContId, cStatus, dDtEnv)
    Local cFil   := xFilial("ZP7")
    Local cSt    := IIf(Empty(cStatus), "S", Left(Upper(AllTrim(cStatus)),1))
    Local dEnv   := IIf(ValType(dDtEnv)=="D", dDtEnv, Date())
    Local cAliQ  := ""
    Local cSql   := ""
    Local nRec   := 0
    Local lUpd   := .F.
    Local lOk    := .F.

    ConOut(LOG_TAG + "ZP7.Grava_env INI env=" + AllTrim(cEnvId) + " doc=" + AllTrim(cDocId))

    // sanity
    If Empty(AllTrim(cEnvId)) .or. Empty(AllTrim(cDocId))
        ConOut(LOG_TAG + "ZP7.Grava_env ERRO: env/doc vazios"); Return .F.
    EndIf

    // abre ZP7 no MESMO PADRÃO do teu ITVSA010
    If Select("ZP7") == 0
        ConOut(LOG_TAG + "ZP7.Grava_env abrindo ZP7 (TOPCONN/RetSqlName)")
        DbUseArea(.T., "TOPCONN", RetSqlName("ZP7"), "ZP7", .T., .F.)
    EndIf
    If Select("ZP7") == 0
        ConOut(LOG_TAG + "ZP7.Grava_env ERRO: alias ZP7 indisponível"); Return .F.
    EndIf

    // procura REC da linha (SQL + MpSysOpenQuery), igual teu ITVSA010
    cSql  := "SELECT R_E_C_N_O_ AS REC FROM " + RetSqlName("ZP7") + " WITH (NOLOCK) "
    cSql += "WHERE D_E_L_E_T_ IN ('',' ') "
    cSql += "  AND ZP7_FILIAL = '" + cFil + "' "
    cSql += "  AND ZP7_ENV    = '" + AllTrim(cEnvId) + "' "
    cSql += "  AND ZP7_DOC    = '" + AllTrim(cDocId) + "' "

    cAliQ := MpSysOpenQuery(cSql)
    If !Empty(cAliQ) .and. Select(cAliQ) > 0 .and. (cAliQ)->(!EoF())
        nRec := (cAliQ)->REC
        ConOut(LOG_TAG + "ZP7.Grava_env encontrado REC=" + AllTrim(cValToChar(nRec)))
        (cAliQ)->(DbCloseArea())
        DbSelectArea("ZP7")
        ZP7->(DbGoTo(nRec))
        lUpd := .T.
    Else
        ConOut(LOG_TAG + "ZP7.Grava_env nao encontrou linha existente (vai incluir)")
        If !Empty(cAliQ) .and. Select(cAliQ) > 0
            (cAliQ)->(DbCloseArea())
        EndIf
        DbSelectArea("ZP7")
    EndIf

    // UPDATE ou INSERT com RecLock/MsUnlock (padrão do teu código)
    If lUpd
        ConOut(LOG_TAG + "ZP7.Grava_env UPDATE iniciando RecLock(.F.)")
        RecLock("ZP7", .F.)
            ZP7->ZP7_STATUS := cSt
            ZP7->ZP7_DTENV  := dEnv
            ZP7->ZP7_PROJ   := AllTrim(cProj)
            ZP7->ZP7_TEC    := AllTrim(cTec)
            ZP7->ZP7_CONTID := AllTrim(cContId)
        MsUnlock()
        ConOut(LOG_TAG + "ZP7.Grava_env UPDATE OK recno=" + AllTrim(cValToChar(ZP7->(RecNo()))))
        lOk := .T.
    Else
        ConOut(LOG_TAG + "ZP7.Grava_env INSERT iniciando RecLock(.T.)")
        RecLock("ZP7", .T.)
            ZP7->ZP7_FILIAL := cFil
            ZP7->ZP7_ENV    := AllTrim(cEnvId)
            ZP7->ZP7_DOC    := AllTrim(cDocId)
            ZP7->ZP7_DTENV  := dEnv
            ZP7->ZP7_STATUS := cSt
            ZP7->ZP7_PROJ   := AllTrim(cProj)
            ZP7->ZP7_TEC    := AllTrim(cTec)
            ZP7->ZP7_CONTID := AllTrim(cContId)
        MsUnlock()
        ConOut(LOG_TAG + "ZP7.Grava_env INSERT OK recno=" + AllTrim(cValToChar(ZP7->(RecNo()))))
        lOk := .T.
    EndIf

    ConOut(LOG_TAG + "ZP7.Grava_env FIM ok=" + IIf(lOk,"T","F"))
Return lOk

Static Function FT_GetOSCodes(aRegs)
    Local aOut   := {}     // saída (IDs únicos)
    Local nI     := 0
    Local oReg   := NIL
    Local cCod   := ""

    // Validação básica
    If ValType(aRegs) <> "A"
        ConOut(LOG_TAG + "FT_GetOSCodes: aRegs não é array (ValType=" + ValType(aRegs) + ")")
        Return aOut
    EndIf

    // Varredura e deduplicação
    For nI := 1 To Len(aRegs)
        oReg := aRegs[nI]

        // Esperamos JsonObject com a chave "Z1_CODIGO"
        If oReg:HasProperty("Z1_CODIGO")
            cCod := AllTrim(oReg["Z1_CODIGO"])

            // ignora vazios e evita duplicatas
            If !Empty(cCod) .and. AScan(aOut, cCod) == 0
                AAdd(aOut, cCod)
            EndIf
        Else
            conout("não tem prorpiedade")
        EndIf
    Next

    ConOut(LOG_TAG + "FT_GetOSCodes: retornando " + AllTrim(Str(Len(aOut))) + " OS unicas")
Return aOut

Static Function FT_SZ1_MarcaEnv(aOSCodes, cEnvId)
    Local nMarc := 0
    Local i     := 0
    Local cOS   := ""
    Local cKey  := ""

    ConOut(LOG_TAG + "SZ1.MarcaEnv INI env=" + AllTrim(cEnvId) + " qtOS=" + AllTrim(Str(Len(aOSCodes))))

    If Empty(AllTrim(cEnvId)) .or. ValType(aOSCodes) != "A" .or. Len(aOSCodes) == 0
        ConOut(LOG_TAG + "SZ1.MarcaEnv ERRO: parâmetros inválidos")
        Return 0
    EndIf

    // abre SZ1 se necessário (padrão TOPCONN do teu projeto)
    If Select("SZ1") == 0
        DbUseArea(.T., "TOPCONN", RetSqlName("SZ1"), "SZ1", .T., .F.)
    EndIf
    If Select("SZ1") == 0
        ConOut(LOG_TAG + "SZ1.MarcaEnv ERRO: alias SZ1 indisponível")
        Return 0
    EndIf

    DbSelectArea("SZ1")
    // Ordem 1 geralmente = xFilial("SZ1")+Z1_CODIGO (ajusta se a tua for outra)
    If IndexOrd() > 0
        SZ1->(DbSetOrder(1))
    EndIf

    For i := 1 To Len(aOSCodes)
        cOS  := AllTrim(cValToChar(aOSCodes[i]))
        If Empty(cOS)
            Loop
        EndIf

        cKey := xFilial("SZ1") + cOS
        If IndexOrd() > 0
            SZ1->(DbSeek(cKey))
            If ! SZ1->(Found())
                ConOut(LOG_TAG + "SZ1.MarcaEnv WARN: OS " + cOS + " não encontrada na ordem 1")
                Loop
            EndIf
        Else
            // sem índice: varre (volume costuma ser baixo por grupo)
            SZ1->(DbGoTop())
            While ! SZ1->(EoF()) .and. AllTrim(SZ1->Z1_CODIGO) != cOS
                SZ1->(DbSkip())
            EndDo
            If SZ1->(EoF())
                ConOut(LOG_TAG + "SZ1.MarcaEnv WARN: OS " + cOS + " não localizada (varredura)")
                Loop
            EndIf
        EndIf

        If ! Empty(AllTrim(SZ1->Z1_ZP7ENV))
            ConOut(LOG_TAG + "SZ1.MarcaEnv SKIP: OS " + cOS + " já marcada com env=" + AllTrim(SZ1->Z1_ZP7ENV))
            Loop
        EndIf

        RecLock("SZ1", .F.)
            SZ1->Z1_ZP7ENV := AllTrim(cEnvId)
        MsUnlock()
        nMarc++
        ConOut(LOG_TAG + "SZ1.MarcaEnv OK: OS " + cOS + " => env=" + AllTrim(cEnvId))
    Next

    ConOut(LOG_TAG + "SZ1.MarcaEnv FIM marcadas=" + AllTrim(Str(nMarc)))
Return nMarc

/* ------------------------------------------------------------------------ */
/* Cancela envelope no Clicksign (v3) e limpa SZ1.Z1_ZP7ENV                 */
/* POST /api/kodigos/v1/click/os/cancel                                     */
/* Body JSON: { "envelope": "<env_id>" }                                    */
/* ------------------------------------------------------------------------ */
WSMETHOD POST cancelEnvelope WSRECEIVE WSREST OSCLICKENV
    Local oJsonRet   := JsonObject():New()
    Local oBodyIn    := JsonObject():New()
    Local cBody      := ""
    Local cEnv       := ""
    Local lOk        := .F.
    Local oCanc      := NIL
    Local nLimpos    := 0

    ConOut(LOG_TAG + "INI POST /os/cancel")

    // 1) Body
    cBody := ::GetContent()
    ConOut(LOG_TAG + "/os/cancel Body(<=500)=" + Left(cBody,500))

    // 2) Parse JSON
    If ValType(oBodyIn:FromJson(cBody)) == "C"
        SetRestFault(400, "JSON inválido no corpo da requisição.", .T.)
        Return .F.
    EndIf

    // 3) envelope id
    cEnv := AllTrim(cValToChar(oBodyIn["envelope"]))
    If Empty(cEnv)
        cEnv := AllTrim(cValToChar(oBodyIn["env_id"]))  // alias
    EndIf

    If Empty(cEnv)
        SetRestFault(400, "Campo 'envelope' (ou 'env_id') é obrigatório.", .T.)
        Return .F.
    EndIf

    // 4) Cancelar no Clicksign (cancela todos os documentos do envelope)
    oCanc := FT_ClickV3_CancelEnvelope(cEnv)

    // 5) Limpar SZ1.Z1_ZP7ENV = "" para as OS que estejam com esse envelope
    nLimpos := FT_SZ1_ClearEnvById(cEnv)

    oJsonRet["ok"]            := oCanc["ok"]
    oJsonRet["env_id"]        := cEnv
    oJsonRet["docs_total"]    := oCanc["docs_total"]
    oJsonRet["docs_cancelados"] := oCanc["docs_cancelados"]
    oJsonRet["os_limpos"]     := nLimpos
    oJsonRet["http_log"]      := oCanc["http_log"]

    ::SetContentType("application/json")
    ::SetResponse(oJsonRet:ToJson())

    ConOut(LOG_TAG + "FIM /os/cancel env=" + cEnv + " cancelados=" + AllTrim(cValToChar(oCanc["docs_cancelados"])) + " os_limpos=" + AllTrim(cValToChar(nLimpos)))
Return .T.

/* Cancela todos os documentos de um envelope (v3) */
Static Function FT_ClickV3_CancelEnvelope(cEnvId)
    Local oRet     := JsonObject():New()
    Local aHttp    := {}
    Local aDocs    := {}
    Local cUrl     := ""
    Local cResp    := ""
    Local nCode    := 0
    Local cErr     := ""
    Local oJson    := JsonObject():New()
    Local oItem    := NIL
    Local i        := 0
    Local cDocId   := ""

    oRet["ok"]              := .F.
    oRet["docs_total"]      := 0
    oRet["docs_cancelados"] := 0
    oRet["http_log"]        := {}

    If Empty(AllTrim(cEnvId))
        AAdd(aHttp, {"param", 0, "env_id vazio"})
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    // 1) Listar documentos do envelope
    cUrl  := CKS_BASE_V3 + "/envelopes/" + AllTrim(cEnvId) + "/documents"
    cResp := FT__HttpJSON("GET", cUrl, "", @nCode, @cErr)
    AAdd(aHttp, {"list_docs", nCode, IIf(Empty(cResp), cErr, FT__LogTrunc(cResp))})
    ConOut(LOG_TAG + "v3 list_docs => " + AllTrim(Str(nCode)))

    If nCode < 200 .or. nCode >= 300 .or. Empty(AllTrim(cResp))
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    cResp := FT__SanitizeJson(cResp)
    If oJson:FromJson(cResp) == NIL
        oRet["http_log"] := aHttp
        Return oRet
    EndIf

    // Espera-se: oJson["data"] como array de objetos { type: "documents", id: "..." }
    If ValType(oJson["data"]) == "A"
        For i := 1 To Len(oJson["data"])
            oItem := oJson["data"][i]
            If ValType(oItem) == "O" .and. ValType(oItem["id"]) == "C"
                AAdd(aDocs, AllTrim(oItem["id"]))
            EndIf
        Next
    EndIf

    oRet["docs_total"] := Len(aDocs)

    // 2) Para cada documento, PATCH status=cancelled
    For i := 1 To Len(aDocs)
        cDocId := aDocs[i]

        oJson := JsonObject():New()

        // Body JSON:API
        Local oAttr := JsonObject():New()
        Local oData := JsonObject():New()
        Local oBody := JsonObject():New()

        oAttr["status"] := "canceled"  // conforme docs v3: Editar Documento (Cancelar ou Finalizar)
        oData["type"]       := "documents"
        oData["id"]         := cDocId
        oData["attributes"] := oAttr
        oBody["data"]       := oData

        cUrl  := CKS_BASE_V3 + "/envelopes/" + AllTrim(cEnvId) + "/documents/" + AllTrim(cDocId)
        cResp := FT__HttpJSON("PATCH", cUrl, oBody:ToJson(), @nCode, @cErr)
        AAdd(aHttp, {"cancel_doc " + AllTrim(cDocId), nCode, IIf(Empty(cResp), cErr, FT__LogTrunc(cResp))})
        ConOut(LOG_TAG + "v3 cancel_doc " + AllTrim(cDocId) + " => " + AllTrim(Str(nCode)))

        If nCode >= 200 .and. nCode < 300
            oRet["docs_cancelados"] := oRet["docs_cancelados"] + 1
        EndIf
    Next

    oRet["ok"]       := (oRet["docs_total"] > 0 .and. oRet["docs_total"] == oRet["docs_cancelados"])
    oRet["http_log"] := aHttp
Return oRet

/* Limpa SZ1.Z1_ZP7ENV = "" para todas as OS com esse envelope */
Static Function FT_SZ1_ClearEnvById(cEnvId)
    Local nLimpos := 0
    Local cAliQ   := ""
    Local cSql    := ""
    Local cFil    := xFilial("SZ1")
    Local nRec    := 0

    If Empty(AllTrim(cEnvId))
        Return 0
    EndIf

    // Abre SZ1 se necessário
    If Select("SZ1") == 0
        DbUseArea(.T., "TOPCONN", RetSqlName("SZ1"), "SZ1", .T., .F.)
    EndIf
    If Select("SZ1") == 0
        ConOut(LOG_TAG + "SZ1.ClearEnv ERRO: alias SZ1 indisponível")
        Return 0
    EndIf

    // Consulta somente os RECNO das OS com o envelope informado
    cSql  := "SELECT R_E_C_N_O_ AS REC FROM " + RetSqlName("SZ1") + " WITH (NOLOCK) "
    cSql += "WHERE D_E_L_E_T_ IN ('',' ') "
    cSql += "  AND Z1_FILIAL = '" + cFil + "' "
    cSql += "  AND RTRIM(ISNULL(Z1_ZP7ENV,'')) = '" + AllTrim(cEnvId) + "' "

    cAliQ := MpSysOpenQuery(cSql)

    If !Empty(cAliQ) .and. Select(cAliQ) > 0
        While !(cAliQ)->(EoF())
            nRec := (cAliQ)->REC
            DbSelectArea("SZ1")
            SZ1->(DbGoTo(nRec))
            RecLock("SZ1", .F.)
                SZ1->Z1_ZP7ENV := ""
            MsUnlock()
            nLimpos++
            (cAliQ)->(DbSkip())
        EndDo
        (cAliQ)->(DbCloseArea())
    EndIf

    ConOut(LOG_TAG + "SZ1.ClearEnv OK env=" + AllTrim(cEnvId) + " limpos=" + AllTrim(cValToChar(nLimpos)))
Return nLimpos
