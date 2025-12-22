#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"
#include "fwcommand.ch"

//====================================================================================================================\\
/*/{Protheus.doc}SC_LOGIN
====================================================================================================================
@description
LOCALIZAÇÃO :

EM QUE PONTO :

Parâmetros:
Nome		Tipo	 Obrigatório Descrição

==================================================================================================================
Customizações:
Cliente: IP
==================================================================================================================
@author		ARLINDO NETO
@version	1.0
@since		12/07/2018
@return		Nil, Nil, Nil
@obs
Áreas utilizadas:
/*/
//====================================================================================================================\\
User Function SC_LOGIN()
return


WSRESTFUL LOGIN DESCRIPTION "Serviço de Login de Usuarios"

WSMETHOD POST DESCRIPTION "Realizar o login de usuarios" WSSYNTAX "/LOGIN || /LOGIN/"

End WsRestful


WsMethod Post  WSSERVICE LOGIN
Local lPost := .T.
	Local cBody
	Private aErros   :={}
	
	cBody := ::GetContent()

	aRetornos := FWJsonSerialize(Login(cBody))
    
    //cReturn := FWJsonSerialize(u_FJsonRetorno(aRetornos[1],aRetornos[2]), .F., .F., .T.)
	::SetResponse(aRetornos)
	

Return lPost

Static Function Login(cdJson)
	Local odLogin  := Nil
	Local lSucesso := .F.	
	Local aRetorno := JsonObject():New()
    Local cLogin    := ""
    Local cPass:=""
	
	lOK := .T.
	cMessage := ""
	RpcSetType(3)
	ldOk := RpcSetEnv('01','01')

	If Empty(cdJson)
		cMessage := "JSON invalido!"
		aRetorno["codigoErro"] := "400"
		aRetorno["descricaoErro"] := cMessage
	Else
		If FWJsonDeserialize(cdJson,@odLogin)
            aRetorno := SCMLogin( odLogin:Login, odLogin:Senha )
		Else
			lOK := .F.
			cMessage := "Falha ao Efetuar a Leitura do JSON"
			aRetorno["codigoErro"] := "400"
			aRetorno["descricaoErro"] := cMessage
		EndIf
		MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(DATE())+"T"+StrTran(Time(),':','-')+".txt",cdJson)
	EndIf
Return aRetorno

static function SCMLogin(acUserLogin, acPassword)
	local cPwdEcm	:= ""	
	local cUsrEcm	:= ""
	local aErros	:= {}
	local lRet		:= .F.
	local lSucesso  := .F.
	local cTmpPwd	:= ""
	local oJson		:= JsonObject():New()
	local oJsonAux	:= JsonObject():New()

	cUsrEcm	:= Alltrim( acUserLogin )
	cPwdEcm := Alltrim( acPassword )
	

	PswOrder(2)
	If !PswSeek( acUserLogin, .T. )
        oJsonAux["codigoErro"]		:= "400"
        oJsonAux["descricaoErro"]	:= "Login Invalido"
        aAdd(aErros, oJsonAux)
        oJson["sucesso"]	:=	.F.
        oJson["erros"] 		:= aErros
    Else
        cTmpPwd := Decode64(cPwdEcm)
        If !PswName(cTmpPwd)
            oJsonAux["codigoErro"]		:= "400"
	        oJsonAux["descricaoErro"]	:= "Senha Invalida"
	        aAdd(aErros, oJsonAux)
	        oJson["sucesso"]	:=	.F.
	        oJson["erros"] 		:= aErros
        Else
            oJson["sucesso"] 	:= .T.
            oJsonAux["codigo"]	:= PswID()
            oJsonAux["nome"]	:= UsrFullName(PswID())
            oJsonAux["email"]	:= UsrRetMail(PswID())
            ///////-------------------------------------------------
            cQry := " SELECT A3_COD FROM "+RetSQLName("SA3")+" (NOLOCK) "
			cQry += " WHERE D_E_L_E_T_ = '' "
			cQry += " AND A3_CODUSR = '"+oJsonAux["codigo"]+"' "
			xdTb2 := MpSysOpenQUery(cQry)
			If !(xdTb2)->(Eof())
			    oJsonAux["codigoVendedor"] := AllTrim((xdTb2)->A3_COD)
			ELse
				oJsonAux["codigoVendedor"] := ""
			EndIf
            //////--------------------------------------------------

			///////-------------------------------------------------
            cQry := " SELECT AK_COD FROM "+RetSQLName("SAK")+" (NOLOCK) "
			cQry += " WHERE D_E_L_E_T_ = '' "
			cQry += " AND AK_USER = '"+oJsonAux["codigo"]+"' "
			xdTb2 := MpSysOpenQUery(cQry)
			If !(xdTb2)->(Eof())
			    oJsonAux["codigoAprovadorPC"] := AllTrim((xdTb2)->AK_COD)
			ELse
				oJsonAux["codigoAprovadorPC"] := ""
			EndIf


 			oJsonAux['administrador'] := FwIsAdmin(PswID())
            oJsonAux['acessos']       := {}

			xdTbl := MpSysOpenQUery("SELECT * FROM "+RetSQLName("SZN")+" WHERE D_E_L_E_T_='' AND ZN_USER = '"+Alltrim(PswID())+"' ")
			DBSELECTAREA(xdTbl)
			// QOUT("SELECT * FROM "+RetSQLName("SZN")+" WHERE D_E_L_E_T_='' AND ZN_USER = '"+Alltrim(aAllUsers[nPos][NDADOS][NCODUS])+"' ")
			
			//Percorre todos as condicoes e faz a montagem do array de fornecedores
			While !(xdTbl)->(Eof())
					
					aAdd(oJsonAux['acessos']   ,JsonObject():New())
					Atail(oJsonAux['acessos'] )['tela'    ]  := (xdTbl)->ZN_ACESSO
	
				(xdTbl)->(dbSkip())
			EndDo
			DBCLOSEAREA(xdTbl)


            //////--------------------------------------------------
            oJson["usuario"] := oJsonAux
        Endif 
    EndIf
    coNOUT(FWJsonSerialize(oJson))
return oJson

