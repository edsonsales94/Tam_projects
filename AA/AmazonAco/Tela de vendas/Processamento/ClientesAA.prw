#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function CLIENTES()
   Local xJ := '{"A1_LOJA":"01","A1_NOME":"DIEGO R O RAMOS","A1_NREDUZ":"DROR","A1_TIPO":"F","A1_END":"BRAZ ","A1_BAIRRO":"CASA VERDE","A1_EST":"SP","A1_MUN":"SAO PAULO","A1_INCISS":"N"}'

   RpcSetEnv('01','01')
   dd := _Post(xJ)
   xx := dd:ToJson()
   Conout(xx)
Return

WSRESTFUL CLIENTES DESCRIPTION "Servico para listar cliente"

WSMETHOD GET DESCRIPTION "Listar clientes de um vendedor com filtro por: nome, codigo ou cnpj" WSSYNTAX "/CLIENTES/{usuario}/{cod}" 
WSMETHOD POST DESCRIPTION "Inserir clientes " WSSYNTAX "/CLIENTES/" 

END WSRESTFUL

WSMETHOD POST WSSERVICE CLIENTES
   Local oRet := JsonObject():New()
   Local xBody := ""

   RpcSetEnv('01','01')
   ::SetContentType("application/json")
   xBody := ::GetContent()
   oRet := _Post(xBody)

   ::SetResponse(oRet:ToJson())

Return .T.
WSMETHOD GET WSSERVICE CLIENTES
	Private jsonObject := Nil
    Private jsonObject1 := Nil
	Private aArray := {}
    Private aArray1 := {}
    Private aCod := ""
    Private aUsuario := ""
    
	//RpcSetType(3)
    RpcSetEnv('01','01')
    ::SetContentType("application/json")
    aUsuario := ::AURLPARMS[1]
    cQry := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_TABELA, A1_COND, "
    cQry += " A1_LC, A1_MSALDO, A1_MCOMPRA, A1_VENCLC, A1_METR, A1_MATR, A1_TITPROT, A1_DTULTIT,  "
    cQry += " A1_DTULCHQ, A1_CHQDEVO, A1_RISCO, A1_END, A1_BAIRRO, A1_CEP, A1_EST, A1_MUN, A1_DDD, A1_TEL, A1_INSCR, ISNULL(contasReceber.qtdDivida, 0) AS qtdDivida "
    cQry += " FROM "+RetSQLName("SA1")+" SA1 (NOLOCK) "
    cQry += " LEFT JOIN (SELECT E1_CLIENTE, E1_LOJA, COUNT(*) AS qtdDivida FROM SE1010 (NOLOCK) "
    cQry += " WHERE D_E_L_E_T_ = '' AND E1_SALDO > 0 group by E1_CLIENTE, E1_LOJA ) AS contasReceber "
    cQry += " ON (contasReceber.E1_CLIENTE = A1_COD and contasReceber.E1_LOJA = A1_LOJA) "
    cQry += " WHERE SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL = '2' AND SA1.A1_VEND = '"+aUsuario+"'"
    IF Len(SELF:AURLPARMS) >= 2
        aCod := ::AURLPARMS[2]
        cQry += " AND SA1.A1_COD = '"+aCod+"'"
    endif
    xdTb2 := MpSysOpenQUery(cQry)
    While !(xdTb2)->(Eof())
        jsonObject =  JsonObject():new()
        aArray1 := {}
        jsonObject["filial"] := AllTrim((xdTb2)->A1_FILIAL )
        jsonObject["codigo"] := AllTrim((xdTb2)->A1_COD)
        jsonObject["loja"] := AllTrim((xdTb2)->A1_LOJA)
        jsonObject["nome"] := AllTrim((xdTb2)->A1_NOME)
        jsonObject["cnpj"] := AllTrim((xdTb2)->A1_CGC)
        jsonObject["tabela"] := AllTrim((xdTb2)->A1_TABELA)
        jsonObject["endereco"] := AllTrim((xdTb2)->A1_END)
        jsonObject["bairro"] := AllTrim((xdTb2)->A1_BAIRRO)
        jsonObject["cep"] := AllTrim((xdTb2)->A1_CEP)
        jsonObject["estado"] := AllTrim((xdTb2)->A1_EST)
        jsonObject["municipio"] := AllTrim((xdTb2)->A1_MUN)
        jsonObject["ddd"] := AllTrim((xdTb2)->A1_DDD)
        jsonObject["telefone"] := AllTrim((xdTb2)->A1_TEL)
        jsonObject["inscricao"] := AllTrim((xdTb2)->A1_INSCR)
        
        JsonObject["cond"] := AllTrim((xdTb2)->A1_COND)
        jsonObject["limiteCredito"] := (xdTb2)->A1_LC
        jsonObject["maximoSaldo"] := (xdTb2)->A1_MSALDO
        jsonObject["maximoCompra"] := (xdTb2)->A1_MCOMPRA
        jsonObject["vencimentoCredito"] := DToC(SToD((xdTb2)->A1_DTULTIT))
        jsonObject["atrasoMMedio"] := (xdTb2)->A1_METR
        jsonObject["atrasoMaior"] := (xdTb2)->A1_MATR
        JsonObject["chequeDevolucoesQuantidade"] := (xdTb2)->A1_CHQDEVO
        JsonObject["chequeDevolucoesDataUltima"] := DToC(SToD((xdTb2)->A1_DTULCHQ))
        JsonObject["titulosProtestadosQuantidade"] := (xdTb2)->A1_TITPROT
        JsonObject["titulosProtestadosDataUltima"] := DToC(SToD((xdTb2)->A1_DTULTIT))
        jsonObject["grauRisco"] := (xdTb2)->A1_RISCO
        
        jsonObject["qtdDivida"] := (xdTb2)->qtdDivida
        // cQry1 := " SELECT D2_PEDIDO, D2_ITEM, D2_FILIAL, D2_COD, D2_UM, D2_QUANT, D2_PRCVEN,D2_TOTAL, B1_DESC  "
        // cQry1 += " FROM  "+RetSQLName("SD2")+" SD2 (NOLOCK)  "
        // cQry1 += " INNER JOIN "+RetSQLName("SB1")+" SB1 (NOLOCK)  "
        // cQry1 += " ON (SD2.D2_COD = SB1.B1_COD) "
        // cQry1 += " WHERE SD2.D_E_L_E_T_ = '' AND D2_CLIENTE = '"+(xdTb2)->A1_COD+"' "
        // cQry1 += " AND D2_LOJA = '"+(xdTb2)->A1_LOJA+"' "
        // cQry1 += " ORDER BY D2_PEDIDO, D2_ITEM"
        // xdTb21 := MpSysOpenQUery(cQry1)
        // While !(xdTb21)->(Eof())
        //     jsonObject1 =  JsonObject():new()
        //     jsonObject1["pedido"] := AllTrim((xdTb21)->D2_PEDIDO)
        //     jsonObject1["item"] := AllTrim((xdTb21)->D2_ITEM)
        //     jsonObject1["filial"] := AllTrim((xdTb21)->D2_FILIAL)
        //     jsonObject1["codigo"] := AllTrim((xdTb21)->D2_COD)
        //     jsonObject1["um"] := AllTrim((xdTb21)->D2_UM)
        //     jsonObject1["quantidade"] := (xdTb21)->D2_QUANT
        //     jsonObject1["precoUnit"] := (xdTb21)->D2_PRCVEN
        //     jsonObject1["precoTotal"] := (xdTb21)->D2_TOTAL
        //     jsonObject1["produti"] := (xdTb21)->B1_DESC
        //     AAdd(aArray1, jsonObject1)
        //     (xdTb21)->( DbSkip() ) 
        // EndDO
        // JsonObject["historico"] := aArray1
        AAdd(aArray, jsonObject)
        (xdTb2)->( DbSkip() ) 
    EndDO
    cJson := FWJsonSerialize(aArray)
    ::SetResponse(cJson)
Return(.T.)



Static Function _Post(xBody)
   Local oRet := JsonObject():New()
   Local oJson := JsonObject():New()
   Local xNames := {}
   Local aSA1Auto := {}
   Local aAI0Auto := {}
   Local xName
   Local nI
   Private lMsErroAuto := .F.

   xRet := oJson:FromJson(xBody)
   if Empty(xRet)
      //aAdd(aSA1Auto,{"A1_COD" ,"XBX141" ,Nil})
      xNames := oJson:GetNames()
      aAdd(aSA1Auto,{"A1_LOJA" , oJson["A1_LOJA"] ,Nil})
      aAdd(aSA1Auto,{"A1_NOME" , oJson["A1_NOME"] ,Nil})

      For nI := 01 To Len(xNames)
         xNAme := xNames[nI]
         if !xName$"A1_LOJA#A1_NOME#A1_COD"
            aAdd(aSA1Auto,{xName , oJson[xName] ,Nil})
         EndIf
      Next
      //---------------------------------------------------------
      // Dados do Complemento do Cliente
      //---------------------------------------------------------
      aAdd(aAI0Auto,{"AI0_SALDO" ,0 ,Nil})
        
      //------------------------------------
      // Chamada para cadastrar o cliente.
      //------------------------------------
      nOpcAuto := 3
      MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aSA1Auto, nOpcAuto, aAI0Auto)

      If lMsErroAuto 
        lRet := lMsErroAuto
        xMsg := MostraErro("\","error.log")// não usar via JOB
        oRet["sucesso"] := .F.
        oRet["mensagem"] := xMsg
      Else
        oRet["sucesso"] := .T.
        oRet["mensagem"] := SA1->A1_COD + '/' + SA1->A1_LOJA
      EndIf

      /*aAdd(aSA1Auto,{"A1_NREDUZ" ,  ,Nil}) 
      aAdd(aSA1Auto,{"A1_TIPO" ,"F" ,Nil})
      aAdd(aSA1Auto,{"A1_END" ,"BRAZ LEME" ,Nil}) 
      aAdd(aSA1Auto,{"A1_BAIRRO" ,"CASA VERDE" ,Nil}) 
      aAdd(aSA1Auto,{"A1_EST" ,"SP" ,Nil})
      aAdd(aSA1Auto,{"A1_MUN" ,"SAO PAULO" ,Nil})
      aAdd(aSA1Auto,{"A1_INCISS" ,"N" ,Nil})
      aAdd(aSA1Auto,{"A1_GRPVEN" ,"000001" ,Nil})*/
   Else
      oRet["sucesso"] := .F.
      oRet["mensagem"] := xRet
   EndIf

   
Return oRet
