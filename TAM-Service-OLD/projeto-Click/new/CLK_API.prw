#Include "protheus.ch"
#Include "totvs.ch"
#Include "json.ch"
#include 'fileio.ch'

// Leia da SX6:
//  MV_CKS_URL = "https://sandbox.clicksign.com"  (ou produção)
//  MV_CKS_TKN = "<seu access token>"

Static Function _Cfg()
   Local cUrl := AllTrim(GetMV("MV_CKS_URL"))
   Local cTok := AllTrim(GetMV("MV_CKS_TKN"))
   If Empty(cUrl) ; cUrl := "https://sandbox.clicksign.com" ; EndIf
   Return { cUrl, cTok }
EndFunc

// ---- helpers HTTP (substitua pelo seu client: FWRest/tHTTPClient/etc.) ----
Static Function _HttpPostJson(cUrl, hBody)
   Local oJson := JsonObject():New()
   Local cResp := ""
   oJson:Set(hBody)
   // >>> troque pela sua função de POST JSON
   // cResp := MeuHttpPostJson(cUrl, oJson:ToJson())
   cResp := ""  // placeholder
   Return IIf(Empty(cResp), {=>}, JsonObject():New():FromJson(cResp))
EndFunc

Static Function _HttpPostMultipart(cUrl, aParts)
   // aParts: { {"campo","valor","tipo"}, ... } tipo: "text"|"file"
   // >>> troque pela sua função multipart/form-data
   Return {=>}
EndFunc

Static Function _FileToB64(cPath)
   Local cBin := MemoRead(cPath)
   // troque por sua função equivalente se necessário
   Return Base64Encode(cBin)
EndFunc

// ---------------------------------------------------------------------------
// API Clicksign
// ---------------------------------------------------------------------------
Static Function _CksCreateSigner(cEmail, cName)
   Local aCfg := _Cfg()
   Local cUrl := aCfg[1] + "/api/v1/signers?access_token=" + aCfg[2]
   Local h := {=>}
   h["signer"] := {=>}
   h["signer"]["email"] := cEmail
   h["signer"]["name"]  := cName
   Local r := _HttpPostJson(cUrl, h)
   If HB_HHasKey(r,"signer") .and. HB_HHasKey(r["signer"],"key")
      Return r["signer"]["key"]
   EndIf
Return ""

Static Function _CksCreateDocumentFromFile(cPdfPath, lSequence)
   Local aCfg := _Cfg()
   Local cUrl := aCfg[1] + "/api/v1/documents?access_token=" + aCfg[2]
   Local h := {=>}
   h["document"] := {=>}
   h["document"]["content_base64"]  := _FileToB64(cPdfPath)
   h["document"]["mimetype"]        := "application/pdf"
   h["document"]["locale"]          := "pt-BR"
   h["document"]["auto_close"]      := .T.
   h["document"]["sequence_enabled"]:= IIf(lSequence,.T.,.F.)
   Local r := _HttpPostJson(cUrl, h)
   If HB_HHasKey(r,"document") .and. HB_HHasKey(r["document"],"key")
      Return r["document"]["key"]
   EndIf
Return ""

// Vincula signer ao documento, com grupo (ZP8_GRUPO)
Static Function _CksAddSignerToDoc(cDocKey, cSignerKey, nGroup)
   Local aCfg := _Cfg()
   Local cUrl := aCfg[1] + "/api/v1/lists?access_token=" + aCfg[2]
   Local h := {=>}
   h["list"] := {=>}
   h["list"]["document_key"] := cDocKey
   h["list"]["signer_key"]   := cSignerKey
   h["list"]["sign_as"]      := "sign"
   If nGroup > 0 ; h["list"]["group"] := nGroup ; EndIf
   Return _HttpPostJson(cUrl, h)
EndFunc

// (Opcional) notificação
Static Function _CksNotify(cRequestKey)
   Local aCfg := _Cfg()
   Local cUrl := aCfg[1] + "/api/v1/notifications?access_token=" + aCfg[2]
   Local h := {=>}
   h["request_signature_key"] := cRequestKey
   Return _HttpPostJson(cUrl, h)
EndFunc

// ---------------------------------------------------------------------------
// Função pública para enviar um documento do Projeto para assinatura
// cPdfPath: caminho do PDF; lNotify: .T. para notificar por e-mail
// ---------------------------------------------------------------------------
User Function CKS_SEND(cProj, cA1, cLoja, cPdfPath, lNotify)
   Local aSigners := _CarregaSignersDoProjeto(cProj, cA1, cLoja)  // { {Nome,Email,Grupo}, ... }
   Local lSeq     := _HasOrderFlag(cProj,cA1,cLoja)               // da sua rotina existente
   Local cDocKey  := ""
   Local cSKey    := ""

   If Empty(cPdfPath) .or. !File(cPdfPath)
      MsgStop("Informe um PDF válido para enviar.","Clicksign")
      Return
   EndIf

   cDocKey := _CksCreateDocumentFromFile(cPdfPath, lSeq)
   If Empty(cDocKey)
      MsgStop("Falha ao criar documento na Clicksign.","Clicksign")
      Return
   EndIf

   AEval(aSigners, {|s|  // s = {Nome,Email,Grupo}
      cSKey := _CksCreateSigner(s[2], s[1])
      If !Empty(cSKey)
         _CksAddSignerToDoc(cDocKey, cSKey, s[3])
         If lNotify
            // Notificação depende da “request_signature_key”; alguns fluxos retornam essa key
            // quando você cria a “list”. Você pode notificar pela própria Clicksign UI/Webhook.
         EndIf
      EndIf
   })

   MsgInfo("Documento enviado: " + cDocKey, "Clicksign")
Return

// Monte os signers a partir da sua query AC8+SU5+ZP8 já usada na tela:
Static Function _CarregaSignersDoProjeto(cProj, cA1, cLoja)
   Local aRet := {}
   // Reaproveite _LoadAll do seu fonte atual: pegue Nome,Email,Grupo (somente quem tem email)
   // Exemplo:
   // AAdd(aRet, { cNome, cEmail, nGrupo })
Return aRet
