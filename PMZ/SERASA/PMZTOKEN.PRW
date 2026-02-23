#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"
#Include "Totvs.ch"

/*/{Protheus.doc} nomeFunction
(long_description)
@type user function
@ Função responsavel por gerar token SERASA.
@author Edson Sales
@since 16/02/2026

/*/
User Function PMZTOKEN()
	local lAMb      := RpcSetEnv('01','01')
	Local aArea     := FWGetArea()
	local cUsr      := "67fd225566e6f27fa26e8e88"
	local cPsw      := "3717164e9v2Pci-595e-43de-8c92-4099dc9b18dd"
	Local cURL      := "https://uat-api.serasaexperian.com.br/security/"
	local cPath     := "iam/v1/client-identities/login"
	Local oRestToken
	Local cToken := ""
	Local aHeaders := {}
	Local jResponse
	Default cUsr := ""
	Default cPsw := ""

	if !lAMb
		Return
	endif

	cAuth := cUsr + ":" + cPsw
	cAuth := Encode64(cAuth)

	cBody := '{'
	cBody += '"client_id":"' + cUsr + '",'
	cBody += '"client_secret":"' + cPsw + '"'
	cBody += '}'

	// Adiciona header Authorization
	aAdd(aHeaders, "Authorization: Basic " + cAuth)
	aAdd(aHeaders, "Content-Type: application/json")

	//Instancia o WS
	oRestToken   := FWRest():New(cURL)
	oRestToken:SetPath(cPath)
    oRestToken:SetPostParams(cBody)

	//Define a url
	// oRestToken:setPath("token?grant_type=password&password=" + cUsr + "&username=" + cPsw)
	If oRestToken:Post(aHeaders)

		//Pega o JSON de resposta, e pega o token
		jResponse := JsonObject():New()
		jResponse:FromJson(oRestToken:cResult)

		//Pega o Token de acesso
		cToken := Iif( ValType(jResponse['accessToken']) != "U", jResponse['accessToken'], "")
	EndIf
	RestArea(aArea)
Return cToken
