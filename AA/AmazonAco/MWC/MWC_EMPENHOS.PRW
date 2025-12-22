#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include "TBICONN.ch"
#include "fwcommand.ch"



User Function MWC_EMPENHO()
return


WSRESTFUL EMPENHO DESCRIPTION "Serviço de Consulta Tipos de Movimentacao"

WSDATA Ordem AS String
WSMETHOD GET DESCRIPTION "Retornar os tipos de movimentação de estoque" WSSYNTAX "/EMPENHO/ || /EMPENHO/"

End WsRestful


WsMethod Get  WSRECEIVE Ordem WSSERVICE EMPENHO 
Local oEmps := JsonObject():New()
Local nX   := 0
local cOrdem

//RpcSetType(3)
//ldOk := RpcSetEnv('01','01')
::SetContentType("application/json")


If Len(::aURLParms) > 0
    cOrdem := ::aURLParms[01]
    lLabel := .T.
Else
    cOrdem := "" 
EndIf   

//conout(ldOk)
xdTbl := MpSysOpenQUery("SELECT * FROM "+RetSQLName("SD4")+" SD4 INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_COD = D4_COD AND SB1.D_E_L_E_T_ = ''  WHERE SD4.D_E_L_E_T_='' AND D4_FILIAL = '"+XFILIAL("SD4")+"' AND D4_OP = '"+cOrdem+"' ")
oEmps["itens"] :={}
//Percorre todos as condicoes e faz a montagem do array de fornecedores
While !(xdTbl)->(Eof())
		nX++
		Aadd(oEmps["itens"],JsonObject():New())

			oEmps["itens"][nX]['codigo']	     := Alltrim((xdTbl)->D4_COD)
			oEmps["itens"][nX]['descricao']      := Alltrim((xdTbl)->B1_DESC)
            oEmps["itens"][nX]['trt']            := Alltrim((xdTbl)->D4_TRT)
            oEmps["itens"][nX]['UM']             := Alltrim((xdTbl)->B1_UM)
            oEmps["itens"][nX]['quantidade']     := (xdTbl)->D4_QUANT
	(xdTbl)->(dbSkip())
EndDo

cReturn := FWJsonSerialize(oEmps, .F., .F., .T.)
	//ConOut( cReturn)
::SetResponse(EncodeUtf8(cReturn))

MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)


Return .T.
