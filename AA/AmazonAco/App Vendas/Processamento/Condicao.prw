#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function CONDICAO()	
Return

WSRESTFUL CONDICAO DESCRIPTION "Servico para listagem de condicoes de pagamentos"

WSMETHOD GET DESCRIPTION "Listagem de condicoes de pagamentos" WSSYNTAX "/CONDICAO" 
END WSRESTFUL

WSMETHOD GET WSSERVICE CONDICAO
	Private jsonObject := Nil
	Private aArray := {}
    Private cProduto := ""
    //cProduto := ::AURLPARMS[1]
	RpcSetType(3)
    RpcSetEnv('01','01')
    ::SetContentType("application/json")
    cQry := " SELECT E4_CODIGO, E4_COND, E4_DESCRI, E4_TIPO, E4_FILIAL "
    cQry += " FROM "+RetSQLName("SE4")+" SE4 (NOLOCK) "
    cQry += " WHERE SE4.D_E_L_E_T_ = '' "
    xdTb2 := MpSysOpenQUery(cQry)
    While !(xdTb2)->(Eof())
        jsonObject =  JsonObject():new()
        jsonObject["codigo"] := AllTrim((xdTb2)->E4_CODIGO )
        jsonObject["condicao"] := AllTrim((xdTb2)->E4_COND)
        jsonObject["descricao"] := AllTrim((xdTb2)->E4_DESCRI)
        jsonObject["filial"] := AllTrim((xdTb2)->E4_FILIAL)
        jsonObject["tipo"] := AllTrim((xdTb2)->E4_TIPO)
        AAdd(aArray, jsonObject)
        (xdTb2)->( DbSkip() ) 
    EndDO
    cJson := FWJsonSerialize(aArray)
    ::SetResponse(cJson)
Return(.T.)