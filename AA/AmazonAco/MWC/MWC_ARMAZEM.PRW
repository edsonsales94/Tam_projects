#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"
#include "fwcommand.ch"



//====================================================================================================================\\
/*/{Protheus.doc}MWC_ARMAZEM
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
@since		28/05/2018
@return		Nil, Nil, Nil
@obs
Áreas utilizadas:
/*/
//====================================================================================================================\\
User Function MWC_ARMAZEM()
return


WSRESTFUL ARMAZEM DESCRIPTION "Serviço de Consulta Almoxarifados"

WSMETHOD GET DESCRIPTION "Retornar os tipos de movimentação de estoque" WSSYNTAX "/ARMAZEM || /ARMAZEM/"

End WsRestful


WsMethod Get  WSSERVICE ARMAZEM
Local oAlmox   := JsonObject():New()
Local aAreaSM0 := {}
Local nX   := 0

//RpcSetType(3)
//ldOk := RpcSetEnv('01','01')
::SetContentType("application/json")

aAreaSM0 := SM0->(GetArea())

//conout(ldOk)
xdTbl := MpSysOpenQUery("SELECT NNR_CODIGO,	NNR_DESCRI FROM "+RetSQLName("NNR")+" WHERE D_E_L_E_T_='' AND NNR_FILIAL = '"+XFILIAL("NNR")+"' ORDER BY NNR_CODIGO ")
oAlmox["armazem"] :={}
//Percorre todos as condicoes e faz a montagem do array de fornecedores
While !(xdTbl)->(Eof())
		nX++
		Aadd(oAlmox["armazem"],JsonObject():New())
			oAlmox["armazem"][nX]['codigo']	        := Alltrim((xdTbl)->NNR_CODIGO)
			oAlmox["armazem"][nX]['descricao']      := Alltrim((xdTbl)->NNR_DESCRI)
	(xdTbl)->(dbSkip())
EndDo

cReturn := FWJsonSerialize(oAlmox, .F., .F., .T.)
	//ConOut( cReturn)
::SetResponse(EncodeUtf8(cReturn))

MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)


RestArea(aAreaSM0)

Return .T.
