#include "protheus.ch"
#define enter chr(13)+chr(10)
#DEFINE UID	"TSSCONFIG" 
/*
*/
user function baixa_xml()	

	RpcSetType(3)
	RpcSetEnv('01','01')

	xRet := u_GetXML("3","000149095")


return

*/

User Function GetXML(pSerie,pNota)

Local cURL       	:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local oWS			:= nil
Local cRetorno   	:= ""
Local cIdEnt 		:= u_GetIdEnt(.T.)
Local cModalidade	:= ""
Local CXML			:= ""
Local CPROTOCOLO	:= ""
Local CXMLPROT	:= ""

If cIdEnt == "GetXML.prw - Erro na identificação da empresa."
	Return(cIdEnt)
EndIf

If Empty(cModalidade)
	oWS := WsSpedCfgNFe():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT    := cIdEnt
	oWS:nModalidade:= 0
	oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If oWS:CFGModalidade()
		cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
	Else
		cModalidade    := ""
	EndIf
EndIf

oWS:= WSNFeSBRA():New()
oWS:cUSERTOKEN        := "TOTVS"
oWS:cID_ENT           := cIdEnt
oWS:oWSNFEID          := NFESBRA_NFES2():New()
oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()

aAdd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := pSerie + pNota

oWS:nDIASPARAEXCLUSAO := 0
oWS:_URL := AllTrim(cURL)+"/NFeSBRA.apw"

If oWS:RETORNANOTASNX()
	If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
		CXML    	:= AllTrim(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[1]:oWSNFE:CXML)
		CPROTOCOLO	:= AllTrim(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[1]:oWSNFE:CPROTOCOLO)
		CXMLPROT	:= AllTrim(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[1]:oWSNFE:CXMLPROT)
		cRetorno	:= '<?xml version="1.0" encoding="UTF-8"?><nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">'
		cRetorno	+= CXML
		cRetorno	+= CXMLPROT
		cRetorno 	+= '</nfeProc>'
	EndIf
EndIf

Return(cRetorno)

