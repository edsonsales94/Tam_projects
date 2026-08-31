#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RESTFUL.CH"

User Function MaxAuth(lForca)
	local lAMb      := RpcSetEnv('01','01AM031')
	Local cUrl := SuperGetMv("XX_MAXURL",.f.,"https://intext-oerp.solucoesmaxima.com.br:81/api/v2/")
	Local nTimeOut := 120
	Local aHeadOut := {}
	Local cHeadRet := ""
	Local sPostRet := ""
	Local cBody := ''
	Local oObj := Nil
	Local cFileToken := 'MaxToken.txt'
	Local cFileDTExp := 'MaxDtExp.txt'
	Local cDtExp := ""
	Local cHrExp := ""
	Local lAuth := .F.
	Local cToken := ""

	Local oRestClient := FWRest():New(cUrl)

	Default lForca := .F.

	//oRestClient:setPath(SuperGetMv("XX_MAXVER",.f.,'v1')+"/Login/")
	oRestClient:setPath("Login/")


	If lForca
		FErase(cFileToken)
		FErase(cFileDTExp)
	EndIf

	If !File(cFileToken) .OR. !File(cFileDTExp)
		lAuth := .T.
	Else
		cDtExp := MemoRead(cFileDTExp)
		cHrExp := SubStr(cDtExp,9)
		cDtExp := SubStr(cDtExp,1,8)

		If DToS(Date())+Time() > cDtExp+cHrExp
			lAuth := .T.
		ElseIf ElapTime(Time(), cHrExp) < "00:02:00"
			lAuth := .T.
		EndIf
	EndIf

	If lAuth
		// cBody += '{'
		// cBody += '  "login": "'+SuperGetMv("XX_MAXUSER",.f.,'PC7IovTNBumZ0YGGdaqSh4TXewxLfxpaQu6W2zIfMU4=')+'",'
		// cBody += '  "password": "'+SuperGetMv("XX_MAXPASS",.f.,'XC9D2SWJnGArIQ/iLhUE/UwtprTApXfQWDyNkTCyJRU=')+'"'
		// cBody += '}'
		cBody += '{'
		cBody += '  "login": "'+SuperGetMv("XX_MAXUSER",.f.,'FrnZJ9VAc8flbMkEQZiAT8PNnj5PIz6DSEwD6XaCL2w=')+'",'
		cBody += '  "password": "'+SuperGetMv("XX_MAXPASS",.f.,'quBlfRil/obKv+6P9ZyYEp/LlV94zmJPD5F9m8vVtyXBeRXfOwYBLYK3JcO5YgOA')+'"'
		cBody += '}'
		aadd(aHeadOut,'Content-Type: application/json')

		oRestClient:SetPostParams("body")
		oRestClient:SetPostParams(cBody)


		if oRestClient:Post(aHeadOut)
			//ALERT(oRestClient:GetResult())
			conout("HttpPost Ok")
			sPostRet := oRestClient:GetResult()
			If FWJsonDeserialize(sPostRet,@oObj)
				If SubStr(oRestClient:GetLastError(),1,3) == '200' .and. ValType(oObj) == "O"
					ConOut("sPostRet")
					ConOut(sPostRet)
					cDtExp := StrTran(SubStr(oObj:DATA_EXPIRACAO,1,10),"-","")
					cHrExp := SubStr(oObj:DATA_EXPIRACAO,12,8)
					cToken := oObj:TOKEN_DE_ACESSO
					MemoWrite(cFileToken, cToken)
					MemoWrite(cFileDTExp, cDtExp+cHrExp)
				Else
					varinfo("HttpPost Failed.", sPostRet)
				EndIf
			Else
				Count("Erro no Deserialize!")
			EndIf
		else
			Conout("Erro")
			conout(oRestClient:GetLastError())
			conout(oRestClient:GetResult())
			//ALERT(oRestClient:GetResult())
			//ALERT(oRestClient:GetLastError())
		Endif
	Else
		cToken := MemoRead(cFileToken)
	EndIf

//	msgStop(cToken)

Return(cToken)
