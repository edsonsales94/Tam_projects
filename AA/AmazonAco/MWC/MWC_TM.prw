#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"
#include "fwcommand.ch"



//====================================================================================================================\\
/*/{Protheus.doc}MWC_TM
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
User Function MWC_TM()
return


WSRESTFUL TM DESCRIPTION "Serviço de Consulta Tipos de Movimentacao"

WSMETHOD GET DESCRIPTION "Retornar os tipos de movimentação de estoque" WSSYNTAX "/TM || /TM/"

End WsRestful


WsMethod Get  WSSERVICE TM
Local oTm := JsonObject():New()
Local aAreaSM0 := SM0->(GetArea())
Local nX   := 0

//RpcSetType(3)
//ldOk := RpcSetEnv('01','01')
::SetContentType("application/json")

//conout(ldOk)
xdTbl := MpSysOpenQUery("SELECT * FROM "+RetSQLName("SF5")+" WHERE D_E_L_E_T_=''  ")
oTM["TM"] :={}
//Percorre todos as condicoes e faz a montagem do array de fornecedores
While !(xdTbl)->(Eof())
		nX++
		Aadd(oTM["TM"],JsonObject():New())
			oTM["TM"][nX]['codigo']	        := Alltrim((xdTbl)->F5_CODIGO)
			oTM["TM"][nX]['descricao']      := Alltrim((xdTbl)->F5_TEXTO)
	(xdTbl)->(dbSkip())
EndDo

cReturn := FWJsonSerialize(oTM, .F., .F., .T.)
	//ConOut( cReturn)
::SetResponse(EncodeUtf8(cReturn))

MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)


RestArea(aAreaSM0)

Return .T.
