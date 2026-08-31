#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"
#Include "TopConn.ch"
 
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
 
/*/{Protheus.doc} FBREST01
Ensinando Rest em ADVPL
@author Fernando Bueno
@since 13/04/2017
@version undefined
@type function
/*/
User Function FBREST01()	
Return
 
/*/{Protheus.doc} AUTHUSER
Definição da estrutura do webservice
@author Fernando Bueno
@since 13/04/2017
@type class
/*/
WSRESTFUL AUTHUSER DESCRIPTION "Serviço REST para manipulação de usuarios/vendedores"
WSDATA USR As String //String que vamos receber via URL
WSDATA PWD As String //String que vamos receber via URL
 
WSMETHOD GET DESCRIPTION "Retorna o usuário autenticado na URL" WSSYNTAX "/AUTHUSER || /AUTHUSER/{USR}{PWD}" //Disponibilizamos um método do tipo GET
 
END WSRESTFUL
 
 
/*/{Protheus.doc} GET
Processa as informações e retorna o json
@author Fernando Bueno
@since 13/04/2017
@version undefined
@param oSelf, object, Objeto contendo dados da requisição efetuada pelo cliente, tais como:
   - Parâmetros querystring (parâmetros informado via URL)
   - Objeto JSON caso o requisição seja efetuada via Request Post
   - Header da requisição
   - entre outras ...
@type Method
/*/
WSMETHOD GET WSRECEIVE USR,PWD WSSERVICE AUTHUSER
//--> Recuperamos o usuário informado via URL 
//--> Podemos fazer dessa forma ou utilizando o atributo ::aUrlParms, que é um array com os parâmetros recebidos via URL (QueryString)
Local cUsr 		:= Self:USR
Local cPwd 		:= Self:PWD
Local aArea			:= GetArea()
Local oObjCom		:= Nil
Local aDados := {}
Local cJson			:= ""
Local aArray := {}
 
// define o tipo de retorno do método
::SetContentType("application/json")
PswOrder(2)
If PswSeek( cUsr, .T. )
	aArray := PSWRET()[1] // Retorna vetor com informações do usuário
	//cPwd := Decode64(cPwd)
	cCodVen := bscCodVen(PSWRET()[1][1])
	If PSWNAME(cPwd) .AND. !Empty(cCodVen)
	 	aAdd(aArray, cCodVen)
		oObjCom := UsrVend():New(aArray)
    EndIF	
EndIf
 
 
// --> Transforma o objeto de produtos em uma string json
cJson := FWJsonSerialize(oObjCom)
// --> Envia o JSON Gerado para a aplicação Client
::SetResponse(cJson)
RestArea(aArea)
Return(.T.)
 
/****************************************************************
Aqui você pode fazer a consistência com o cadastro de vendedores
No caso utilizei o campo padrão A3_USUCORP para colocar o código 
de usuário
*****************************************************************/
Static Function bscCodVen(cCodUsr)
Local cQryAux := ""
Local cRet := ""
 
//Montando consulta de dados
cQryAux := ""
cQryAux += " SELECT A3_COD FROM SA3010 WHERE D_E_L_E_T_ = ' ' AND A3_MSBLQL <> '1' AND A3_USUCORP LIKE '%" + AllTrim(cCodUsr) + "%' "
conout(cQryAux)
cQryAux := ChangeQuery(cQryAux)
 
//Executando consulta e setando o total da régua
TCQuery cQryAux New Alias "QRY_AUX"
Count to nTotal
 
//Enquanto houver dados
QRY_AUX->(DbGoTop())
While ! QRY_AUX->(Eof())
	cRet := QRY_AUX->(A3_COD)
	QRY_AUX->(dbSkip())
EndDo
QRY_AUX->(dbCloseArea())
 
 
Return cRet