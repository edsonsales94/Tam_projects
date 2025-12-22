#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function PRODAASearch()	
Return

WSRESTFUL PROD1Search DESCRIPTION "Servico para listar PRODUTOS AA via Search"

WSMETHOD GET DESCRIPTION "Listar PRODUTOS X TABELA DE PRECO por usuario" WSSYNTAX "/PROD1SEARCH/{usuario}/{search}" 
END WSRESTFUL

WSMETHOD GET WSSERVICE PROD1Search
	Private jsonObject := Nil
	Private aArray := {}
    Private aSearch := ""
    Private aUsuario := ""
    aUsuario := ::AURLPARMS[1]
                 
	RpcSetType(3)
    RpcSetEnv('01','01')
    ::SetContentType("application/json")
	
    cQry := " SELECT TOP 20 SB1.B1_COD, B1_DESC, SB1.B1_TS, SB1.B1_LOCPAD, SB1.B1_UM, B2_QATU "
    cQry += " FROM "+RetSQLName("SB1")+" SB1 (NOLOCK) "
    cQry += " INNER JOIN "+RETSQLNAME("SB2")+" SB2 ON (SB2.D_E_L_E_T_ = '' AND B2_FILIAL = '01' AND B2_LOCAL = '14' AND B2_COD = B1_COD) "
    cQry += " WHERE SB1.D_E_L_E_T_ = '' AND SB1.B1_MSBLQL = '2' "

   IF Len(SELF:AURLPARMS) >= 2
        aSearch := ::AURLPARMS[2]
        cQry += " AND (lower(SB1.B1_COD) LIKE lower('%"+aSearch+"%') OR lower(SB1.B1_DESC) LIKE lower('%"+aSearch+"%'))"
    endif

    xdTb2 := MpSysOpenQUery(cQry)
    While !(xdTb2)->(Eof())
        jsonObject =  JsonObject():new()
        jsonObject["codigo"] := AllTrim((xdTb2)->B1_COD)
        jsonObject["descricao"] := AllTrim((xdTb2)->B1_DESC)
        jsonObject["um"] := AllTrim((xdTb2)->B1_UM)
        JsonObject["tes"] := AllTrim((xdTb2)->B1_TS)
        jsonObject["preco"] := 0
        jsonObject["local"] := AllTrim((xdTb2)->B1_LOCPAD)
        jsonObject["tabela"] := ""
        jsonObject["quantidadeEstoque"] := (xdTb2)->B2_QATU
        AAdd(aArray, jsonObject)
        (xdTb2)->( DbSkip() ) 
    EndDO
    cJson := FWJsonSerialize(aArray)
    ::SetResponse(cJson)
Return(.T.)
