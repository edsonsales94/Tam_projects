#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function SALDOEND()	
Return

WSRESTFUL SALDOEND DESCRIPTION "Servico para listar saldo por endereco de um produto"

WSMETHOD GET DESCRIPTION "Listar saldo por endereco de um produto" WSSYNTAX "/SALDOEND/{produto}" 
END WSRESTFUL

WSMETHOD GET WSSERVICE SALDOEND
	Private jsonObject := Nil
	Private aArray := {}
    Private cProduto := ""
    cProduto := ::AURLPARMS[1]
	RpcSetType(3)
    RpcSetEnv('01','01')
    ::SetContentType("application/json")
    cQry := " SELECT B2_FILIAL, B2_COD, B2_LOCAL, B2_QATU "
    cQry += " FROM "+RetSQLName("SB2")+" SB2 (NOLOCK) "
    cQry += " WHERE SB2.D_E_L_E_T_ = '' AND SB2.B2_COD = '"+cProduto+"'"
    xdTb2 := MpSysOpenQUery(cQry)
    While !(xdTb2)->(Eof())
        jsonObject =  JsonObject():new()
        jsonObject["filial"] := AllTrim((xdTb2)->B2_FILIAL )
        jsonObject["produto"] := AllTrim((xdTb2)->B2_COD)
        jsonObject["armazen"] := AllTrim((xdTb2)->B2_LOCAL)
        jsonObject["quantidade"] := (xdTb2)->B2_QATU
        AAdd(aArray, jsonObject)
        (xdTb2)->( DbSkip() ) 
    EndDO
    cJson := FWJsonSerialize(aArray)
    ::SetResponse(cJson)
Return(.T.)