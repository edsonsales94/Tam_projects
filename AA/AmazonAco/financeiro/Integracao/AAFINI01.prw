#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    \IntegrationService.wsdl
Gerado em        05/08/15 11:05:33
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function AAFINI01	
  	
Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSIntegrationServiceService
------------------------------------------------------------------------------- */

WSCLIENT WSIntegrationServiceService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD invokeIntegrationServiceFromExternalPortals
	WSMETHOD invokeIntegrationServiceFromSTS
	WSMETHOD invokeIntegrationServiceFromWorkFlowManager

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   carg0                     AS string
	WSDATA   carg1                     AS string
	WSDATA   carg2                     AS string
	WSDATA   creturn                   AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSIntegrationServiceService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20131106] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSIntegrationServiceService
Return

WSMETHOD RESET WSCLIENT WSIntegrationServiceService
	::carg0              := NIL 
	::carg1              := NIL 
	::carg2              := NIL 
	::creturn            := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSIntegrationServiceService
Local oClone := WSIntegrationServiceService():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:carg0         := ::carg0
	oClone:carg1         := ::carg1
	oClone:carg2         := ::carg2
	oClone:creturn       := ::creturn
Return oClone

// WSDL Method invokeIntegrationServiceFromExternalPortals of Service WSIntegrationServiceService

WSMETHOD invokeIntegrationServiceFromExternalPortals WSSEND carg0,carg1,carg2 WSRECEIVE creturn WSCLIENT WSIntegrationServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<invokeIntegrationServiceFromExternalPortals xmlns="http://service.integration.ds.com/">'
cSoap += WSSoapValue("arg0", ::carg0, carg0 , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("arg1", ::carg1, carg1 , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("arg2", ::carg2, carg2 , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</invokeIntegrationServiceFromExternalPortals>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://service.integration.ds.com/",,,; 
	"https://prd1da.experian.com/Integration/IntegrationService")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_INVOKEINTEGRATIONSERVICEFROMEXTERNALPORTALSRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,"xs") 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method invokeIntegrationServiceFromSTS of Service WSIntegrationServiceService

WSMETHOD invokeIntegrationServiceFromSTS WSSEND carg0 WSRECEIVE creturn WSCLIENT WSIntegrationServiceService
Local cSoap := "" , oXmlRet
'
BEGIN WSMETHOD

cSoap += ' <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
cSoap += ' <soapenv:Header>
cSoap += ' <ns1:Authentication xmlns:ns1="http://service.integration.ds.com/" soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0">
cSoap += ' YWljb25zdW1lckZpbmFuY2U6NDQxajZqazBnNjdu
cSoap += ' </ns1:Authentication></soapenv:Header>
cSoap += ' <soapenv:Body>
cSoap += ' <invokeIntegrationServiceFromSTS xmlns="http://service.integration.ds.com/">'
cSoap += ' <arg0 xmlns="">
//cSoap += WSSoapValue("arg0", ::carg0, carg0 , "string", .F. , .F., 0 , NIL, .F.)
cSoap += ::carg0
cSoap += ' </arg0>
cSoap += " </invokeIntegrationServiceFromSTS>"
cSoap += " </soapenv:Body> " 
cSoap += " </soapenv:Envelope> "

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://service.integration.ds.com/",,,; 
	"https://prd1da.experian.com/Integration/IntegrationService")

::Init()
::creturn            :=  WSAdvValue( oXmlRet,"_INVOKEINTEGRATIONSERVICEFROMSTSRESPONSE:_RETURN:TEXT","string",NIL,NIL,NIL,NIL,NIL,"xs") 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method invokeIntegrationServiceFromWorkFlowManager of Service WSIntegrationServiceService

WSMETHOD invokeIntegrationServiceFromWorkFlowManager WSSEND oWSarg0 WSRECEIVE NULLPARAM WSCLIENT WSIntegrationServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<invokeIntegrationServiceFromWorkFlowManager xmlns="http://service.integration.ds.com/">'
cSoap += WSSoapValue("arg0", ::oWSarg0, oWSarg0 , "moduleAssociatedInfo", .F. , .F., 0 , NIL, .F.) 
cSoap += "</invokeIntegrationServiceFromWorkFlowManager>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"DOCUMENT","http://service.integration.ds.com/",,,; 
	"https://prd1da.experian.com/Integration/IntegrationService")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.



