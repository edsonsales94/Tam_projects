#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#include 'tbiconn.ch'

user function WMC_ITENSTRANS()

//FwAlertInfo("Iniciando","OK")
Prepare Environment Empresa '01' Filial '01'

//Conout('Donne')
return

WSRESTFUL ITENSTRANS DESCRIPTION "Serviço de itens da tranaferencia por local"

WSMETHOD GET DESCRIPTION "Retornar os itens do local" WSSYNTAX "/ITENSTRANS/{local}"

End WsRestful

WsMethod Get WSSERVICE ITENSTRANS
	
	Local oItens := {}
	Local nX   := 0
	Local cLocal := ""
    Local cQry :=""

	If Len(::aURLParms) > 0
		cLocal := ::aURLParms[01]
    EndIf
	cReturn := ""

	//RpcSetType(3)
	//ldOk := RpcSetEnv('01','01')
	::SetContentType("application/json")
	//conout(ldOk)

	cQry += " SELECT BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL,  "
    cQry += " BF_QUANT, B1_TIPO, B1_UM,B1_DESC "
    cQry += " FROM "+RetSQLName("SBF")+" SBF (NOLOCK) "
    cQry += " INNER JOIN "+RetSQLName("SB1")+" SB1 (NOLOCK)  "
    cQry += " ON (SB1.D_E_L_E_T_ = '' AND B1_COD =  BF_PRODUTO  ) "
    cQry += " WHERE SBF.D_E_L_E_T_ = '' "
    cQry += " AND BF_QUANT > 0  "
	cQry += " AND BF_FILIAL = '"+XFILIAL("SBF")+' "
    cQry += " AND BF_LOCALIZ = '"+cLocal+"' "
    
    
    xdTbl :=MpSysOpenQUery(cQry)
    
	//Percorre todos os produtos
	While !(xdTbl)->(Eof())
		nX++
		Aadd(oItens,JsonObject():New())
		
		oItens[nX]['filial']	:= Alltrim((xdTbl)->BF_FILIAL)
		oItens[nX]['codigoProduto']	:= Alltrim((xdTbl)->BF_PRODUTO)
		oItens[nX]['unidadeMedida']	    := Alltrim((xdTbl)->B1_UM)
        oItens[nX]['tipoProduto']	:= Alltrim((xdTbl)->B1_TIPO)
        oItens[nX]['descricaoProduto']	:= Alltrim((xdTbl)->B1_DESC)
        oItens[nX]['armazen']	:= Alltrim((xdTbl)->BF_LOCAL)
		oItens[nX]['numeroLote']	:= Alltrim((xdTbl)->BF_LOTECTL)
		oItens[nX]['quantidade']	    := Alltrim((xdTbl)->BF_QUANT)
		
		(xdTbl)->(dbSkip())
	EndDo
	
	cReturn := FWJsonSerialize(oItens, .F., .F., .T.)
	//ConOut( cReturn)
	::SetResponse(EncodeUtf8(cReturn))

	MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".json",cReturn)
    
Return .T.




