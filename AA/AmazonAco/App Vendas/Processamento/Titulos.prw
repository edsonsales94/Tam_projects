#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function TituRel()	
Return

WSRESTFUL TituRel DESCRIPTION "Servico para relatorio de titulos"

WSMETHOD GET DESCRIPTION "Relatorio de titulos - contas a receber por emissao" WSSYNTAX "/TituRel/{cod}/{loja}/{status}/{dataInicio}/{dataFim}" 
END WSRESTFUL

WSMETHOD GET WSSERVICE TituRel
	Private jsonObject := Nil
    Private jsonObject1 := Nil
	Private aArray := {}
    Private aArray1 := {}
    Private aCod := ::AURLPARMS[1]
    Private aLoja := ::AURLPARMS[2]
    Private aStatus := ::AURLPARMS[3]
    Private dDataInicio := ::AURLPARMS[4]
    Private dDataFim	:= ::AURLPARMS[5]
    
	RpcSetType(3)
    RpcSetEnv('01','01')
    ::SetContentType("application/json")
    cQry := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_NUMNOTA, E1_MOEDA, E1_EMISSAO, E1_VENCTO, "
    cQry += " E1_VENCREA, E1_MOVIMEN, E1_VALOR, E1_SALDO, E1_BAIXA, E1_VALLIQ"
    cQry += " FROM "+RetSQLName("SE1")+" SE1(NOLOCK) "
    cQry += " WHERE  E1_STATUS = '"+aStatus+"'  "
    cQry += " AND D_E_L_E_T_ = '' AND E1_CLIENTE = '"+aCod+"' AND E1_LOJA = '"+aLoja+"' "
    cQry += " AND E1_EMISSAO BETWEEN '"+dDataInicio+"' and '"+dDataFim+"' "
    cQry += " ORDER BY E1_EMISSAO DESC, E1_NUM, E1_PARCELA "
    xdTb2 := MpSysOpenQUery(cQry)
    While !(xdTb2)->(Eof())
        jsonObject =  JsonObject():new()
        aArray1 := {}
        jsonObject["filial"] := AllTrim((xdTb2)->E1_FILIAL)
        jsonObject["prefixo"] := AllTrim((xdTb2)->E1_PREFIXO)
        jsonObject["numero"] := AllTrim((xdTb2)->E1_NUM)
        jsonObject["parcela"] := AllTrim((xdTb2)->E1_PARCELA)
        jsonObject["tipo"] := AllTrim((xdTb2)->E1_TIPO)
        jsonObject["nota"] := AllTrim((xdTb2)->E1_NUMNOTA)
        jsonObject["moeda"] := (xdTb2)->E1_MOEDA
        jsonObject["emissao"] := DToC(SToD((xdTb2)->E1_EMISSAO))
        jsonObject["vencimento"] := DToC(SToD((xdTb2)->E1_VENCTO))
        jsonObject["vencimentoReal"] := DToC(SToD((xdTb2)->E1_VENCREA))
        jsonObject["ultMovimento"] := DToC(SToD((xdTb2)->E1_MOVIMEN))
        
        jsonObject["valor"] := (xdTb2)->E1_VALOR
        jsonObject["valorLiquido"] := (xdTb2)->E1_VALLIQ
        jsonObject["saldo"] := (xdTb2)->E1_SALDO
        jsonObject["baixa"] := DToC(SToD((xdTb2)->E1_BAIXA))
        
        AAdd(aArray, jsonObject)
        (xdTb2)->( DbSkip() ) 
    EndDO
    cJson := FWJsonSerialize(aArray)
    ::SetResponse(cJson)
Return(.T.)