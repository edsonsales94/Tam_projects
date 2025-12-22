#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function HistCom()	
Return

WSRESTFUL HistCom DESCRIPTION "Servico para listar Historico de compras do cliente"

WSMETHOD GET DESCRIPTION "Listar historico de compras do clientes" WSSYNTAX "/HISTCOM/{codigo}/{loja}" 
END WSRESTFUL

WSMETHOD GET WSSERVICE HistCom
	Private jsonObject := Nil
	Private aArray := {}
    Private cCodigo := ""
    Private cLoja := ""
    
	RpcSetType(3)
    RpcSetEnv('01','01')
    ::SetContentType("application/json")
    aCodigo := ::AURLPARMS[1]
    aLoja := ::AURLPARMS[2]

    cQry := " SELECT C5_NUM D2_PEDIDO, D2_ITEM, D2_FILIAL, D2_COD, D2_UM, D2_QUANT, D2_PRCVEN, D2_TOTAL, "
    cQry += " B1_DESC, 'PEDIDO' TIPO, D2_EMISSAO "
    cQry += " FROM  "+RetSQLName("SD2")+" SD2 (NOLOCK) "
    cQry += " INNER JOIN "+RetSQLName("SB1")+" SB1 (NOLOCK) "
    cQry += " ON (SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '') "
    cQry += " INNER JOIN "+RetSQLName("SC5")+" SC5 (NOLOCK) ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO "
    cQry += " AND SC5.D_E_L_E_T_ = '' "
    cQry += " WHERE SD2.D_E_L_E_T_ = '' AND D2_CLIENTE = '"+aCodigo+"'  AND D2_LOJA = '"+aLoja+"' "
    cQry += " AND D2_TIPO = 'N' ORDER BY D2_EMISSAO DESC"
    xdTb2 := MpSysOpenQUery(cQry)
    While !(xdTb2)->(Eof())
        jsonObject =  JsonObject():new()
        jsonObject["pedido"] := AllTrim((xdTb2)->D2_PEDIDO)
        jsonObject["item"] := AllTrim((xdTb2)->D2_ITEM)
        jsonObject["filial"] := AllTrim((xdTb2)->D2_FILIAL)
        jsonObject["codigo"] := AllTrim((xdTb2)->D2_COD)
        jsonObject["um"] := AllTrim((xdTb2)->D2_UM)
        jsonObject["quantidade"] := (xdTb2)->D2_QUANT
        jsonObject["precoUnit"] := (xdTb2)->D2_PRCVEN
        jsonObject["precoTotal"] := (xdTb2)->D2_TOTAL
        jsonObject["produto"] := AllTrim((xdTb2)->B1_DESC)
        JsonObject["emissao"] := DToC(SToD((xdTb2)->D2_EMISSAO))

        AAdd(aArray, jsonObject)
        (xdTb2)->( DbSkip() ) 
    EndDO
    cJson := FWJsonSerialize(aArray)
    ::SetResponse(cJson)
Return(.T.)