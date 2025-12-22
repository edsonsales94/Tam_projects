#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function AAFATP90()
	Local xJson := '{"CABECALHO":{"CJ_NUM":"040529","CJ_CLIENTE":"001243","CJ_LOJA":"01","CJ_CLIENT":"001243","CJ_LOJAENT":"01","CJ_CONDPAG":"001","CJ_VEND1":"000040","CJ_TABELA":"","CJ_XCOTCLI":"01010101"},"ITENS":[{"CK_ITEM":"01","CK_PRODUTO":"47000003","descricao":"METALON 15 X 15 X 0.75 X  6.000 FF  (2 04)","CK_UM":"KG","CK_QTDVEN":10,"CK_PRCVEN":10.9,"CK_VALOR":109,"CK_LOCAL":"14","CK_TES":"502","CK_PESO":0},{"CK_ITEM":"02","CK_PRODUTO":"47000047","descricao":"METALON 15 X 15 X 0.75 X  6.000 FF  (2 04)","CK_UM":"KG","CK_QTDVEN":10,"CK_PRCVEN":15.9,"CK_VALOR":159,"CK_LOCAL":"14","CK_TES":"502","CK_PESO":0}]}'
	RpcSetEnv('01','01')
	oret := _Put(xJson)
	ConOUt(oRet:ToJson())
Return

	WSRESTFUL Orcamentos DESCRIPTION "Serviço REST para Orçamentos de compras"

		WSMETHOD GET DESCRIPTION "Retorna todos ou apenas um orçamento pelo número" WSSYNTAX "/ORCAMENTOS{usuario} || /ORCAMENTOS/{usuario}/{numero} || /ORCAMENTOS/{usuario}/{dataInicio}/{dataFim}/{status}/{cliente}"
		WSMETHOD POST DESCRIPTION "Inserir novo orçamento" WSSYNTAX "/ORCAMENTOS || /ORCAMENTOS/"
		WSMETHOD PUT DESCRIPTION "Atualizar orçamento" WSSYNTAX "/ORCAMENTOS/{usuario}/{numero}"
		WSMETHOD DELETE DESCRIPTION "DELETE orçamento" WSSYNTAX "/ORCAMENTOS/{usuario}/{numero}"

	END WSRESTFUL

WSMETHOD GET WSSERVICE Orcamentos

	Private jsonObject := Nil
	Private jsonObjectAux := Nil
	Private aArray := {}
	Private cNextAlias := GetNextAlias()
	Private cNumOrcamento := ""
	Private cUser := SELF:AURLPARMS[1]
	Private dDataInicio := Nil
	Private dDataFim	:= Nil
	Private cStatus		:= Nil
	Private cCliente	:= Nil
	RpcSetType(3)
	RpcSetEnv('01','01')
	::SetContentType("application/json")

	IF Len(SELF:AURLPARMS) = 2
		cNumOrcamento := SELF:AURLPARMS[2]
		cQry := " SELECT SCJ.CJ_FILIAL, SCJ.CJ_NUM, CJ_VALIDA, SCJ.CJ_CLIENTE, SCJ.CJ_CLIENT, SA1.A1_NOME as clientePagar,  "
		cQry += " SCJ.CJ_CONDPAG, SCJ.CJ_STATUS, SCJ.CJ_EMISSAO, SA11.A1_NOME as clienteReceber, SE4.E4_DESCRI as condicao,  "
		cQry += " SCJ.CJ_XCOTCLI,SCJ.CJ_VEND1 "
		cQry += " FROM "+RetSQLName("SCJ")+" SCJ (NOLOCK) "
		cQry += " INNER JOIN "+RetSQLName("SA1")+" SA1 (NOLOCK) ON (SA1.A1_COD = SCJ.CJ_CLIENTE) "
		cQry += " INNER JOIN "+RetSQLName("SA1")+" SA11 (NOLOCK) ON (SA11.A1_COD = SCJ.CJ_CLIENT) "
		cQry += " INNER JOIN "+RetSQLName("SE4")+" SE4 (NOLOCK) ON (SE4.E4_CODIGO = SCJ.CJ_CONDPAG) "
		cQry += " WHERE SCJ.D_E_L_E_T_ = '' "
		cQry += "   AND SA1.D_E_L_E_T_ = '' "
		cQry += "   AND SA1.A1_VEND = '"+cUser+"'
		cQry += "   AND SCJ.CJ_NUM = '"+cNumOrcamento+"'"

		xdTbl := MpSysOpenQUery(cQry)
		jsonObject =  JsonObject():new()
		IF !(xdTbl)->(Eof())

			jsonObject["filial"] := AllTrim((xdTbl)->CJ_FILIAL )
			jsonObject["numeroOrcamento"] := AllTrim((xdTbl)->CJ_NUM)
			jsonObject["clienteCodigo"] := AllTrim((xdTbl)->CJ_CLIENTE)
			jsonObject["clienteNome"] := AllTrim((xdTbl)->clientePagar)
			jsonObject["clienteCodigoReceber"] := AllTrim((xdTbl)->CJ_CLIENT)
			jsonObject["clienteNomeReceber"] := AllTrim((xdTbl)->clienteReceber)
			JsonObject["status"] := AllTrim((xdTbl)->CJ_STATUS)
			JsonObject["condicao"] := AllTrim((xdTbl)->CJ_CONDPAG)
			JsonObject["descricaoCondicao"] := AllTrim((xdTbl)->condicao)
			JsonObject["emissao"] := DToC(SToD((xdTbl)->CJ_EMISSAO))
			JsonObject["valida"] := DToC(SToD((xdTbl)->CJ_VALIDA))
			JsonObject["ordemcompra"] := AllTrim((xdTbl)->CJ_XCOTCLI)
			JsonObject["vendedor"] := AllTrim((xdTbl)->CJ_VEND1)

			cQry := "SELECT CK_FILIAL, CK_ITEM, CK_UM, CK_PRODUTO, CK_DESCRI, CK_QTDVEN, CK_PRCVEN, CK_VALOR, CK_LOCAL, CK_TES "
			cQry += "FROM "+RetSQLName("SCK")+" SCK (NOLOCK)"
			cQry +="WHERE SCK.D_E_L_E_T_ = '' AND SCK.CK_NUM = '"+cNumOrcamento+"'"
			xdTb2 := MpSysOpenQUery(cQry)
			While !(xdTb2)->(Eof())
				jsonObjectAux =  JsonObject():new()
				jsonObjectAux["filial"] := AllTrim((xdTb2)->CK_FILIAL )
				jsonObjectAux["item"] := AllTrim((xdTb2)->CK_ITEM)
				jsonObjectAux["produto"] := AllTrim((xdTb2)->CK_PRODUTO)
				jsonObjectAux["descricaoAux"] := AllTrim((xdTb2)->CK_DESCRI)
				jsonObjectAux["um"] := AllTrim((xdTb2)->CK_UM)
				jsonObjectAux["tes"] := AllTrim((xdTb2)->CK_TES)
				jsonObjectAux["local"] := AllTrim((xdTb2)->CK_LOCAL)
				jsonObjectAux["quantidade"] := (xdTb2)->CK_QTDVEN
				jsonObjectAux["precoUnitario"] := (xdTb2)->CK_PRCVEN
				jsonObjectAux["precoTotal"] := (xdTb2)->CK_VALOR
				AAdd(aArray, jsonObjectAux)
				(xdTb2)->( DbSkip() )
			EndDO
			JsonObject["itens"] := aArray
		ELSE
			jsonObject["status"] := "500"
			jsonObject["mensagem"] := "Orcamento nao encontrado!"
		ENDIF
		cJson := FWJsonSerialize(jsonObject)
		::SetResponse(cJson)
	ELSEIF Len(SELF:AURLPARMS) = 1
		BeginSQL Alias cNextAlias
			SELECT SCJ.CJ_FILIAL, SCJ.CJ_NUM, SCJ.CJ_CLIENTE, SA1.A1_NOME, SCJ.CJ_STATUS ,SCJ.CJ_XCOTCLI,SCJ.CJ_VEND1
			FROM %table:SCJ% SCJ (NOLOCK)
			INNER JOIN %table:SA1% SA1 (NOLOCK) ON (SA1.A1_COD = SCJ.CJ_CLIENTE)
			WHERE SCJ.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = ''
			AND SCJ.CJ_STATUS = 'A' 
			AND SA1.A1_VEND = %exp:cUser%
			ORDER BY SCJ.CJ_NUM DESC
		EndSQL
		(cNextAlias)->( DbGoTop() )
		While (cNextAlias)->( !Eof() )
			jsonObject =  JsonObject():new()
			jsonObject["filial"] := AllTrim((cNextAlias)->CJ_FILIAL )
			jsonObject["numeroOrcamento"] := AllTrim((cNextAlias)->CJ_NUM)
			jsonObject["clienteCodigo"] := AllTrim((cNextAlias)->CJ_CLIENTE)
			jsonObject["clienteNome"] := AllTrim((cNextAlias)->A1_NOME)
			JsonObject["status"] := AllTrim((cNextAlias)->CJ_STATUS)
			JsonObject["ordemcompra"] := AllTrim((cNextAlias)->CJ_XCOTCLI)
			JsonObject["vendedor"] := AllTrim((cNextAlias)->CJ_VEND1)
			(cNextAlias)->( DbSkip() )
			AAdd(aArray, jsonObject)
		EndDo
		cJson := FWJsonSerialize(aArray)
		::SetResponse(cJson)
	ELSE
		dDataInicio := SELF:AURLPARMS[2]
		dDataFim	:= SELF:AURLPARMS[3]
		cStatus		:= SELF:AURLPARMS[4]
		cQry := "SELECT SCJ.CJ_FILIAL, SCJ.CJ_NUM, CJ_EMISSAO, SCJ.CJ_CLIENTE, SCJ.CJ_CLIENT, SA1.A1_NOME as clientePagar,  "
		cQry += "SCJ.CJ_CONDPAG, SCJ.CJ_STATUS, SA11.A1_NOME as clienteReceber, SE4.E4_DESCRI as condicao, "
		cQry += "SCJ.CJ_XCOTCLI , SCJ.CJ_VEND1
		cQry += "FROM "+RetSQLName("SCJ")+" SCJ (NOLOCK) "
		cQry += "INNER JOIN "+RetSQLName("SA1")+" SA1 (NOLOCK) ON (SA1.A1_COD = SCJ.CJ_CLIENTE) "
		cQry += "INNER JOIN "+RetSQLName("SA1")+" SA11 (NOLOCK) ON (SA11.A1_COD = SCJ.CJ_CLIENT) "
		cQry += "INNER JOIN "+RetSQLName("SE4")+" SE4 (NOLOCK) ON (SE4.E4_CODIGO = SCJ.CJ_CONDPAG) "
		cQry += "WHERE SCJ.D_E_L_E_T_ = '' "
		cQry += "AND SA1.D_E_L_E_T_ = '' "
		cQry += "AND SA1.A1_VEND = '"+cUser+"' "
		cQry += " AND SCJ.CJ_EMISSAO BETWEEN '"+dDataInicio + "' and '"+ dDataFim+ "' "
		IF cStatus != 'T'
			cQry += " AND SCJ.CJ_STATUS = '"+cStatus +"' "
		EndIf
		IF len(SELF:AURLPARMS) = 5
			cCliente:= SELF:AURLPARMS[5]
			cQry += " AND SCJ.CJ_CLIENTE = '"+cCliente +"' "
		endif
		xdTbl := MpSysOpenQUery(cQry)
		(xdTbl)->( DbGoTop() )
		While (xdTbl)->( !Eof() )
			jsonObject =  JsonObject():new()
			jsonObject["filial"] := AllTrim((xdTbl)->CJ_FILIAL )
			jsonObject["numeroOrcamento"] := AllTrim((xdTbl)->CJ_NUM)
			jsonObject["clienteCodigo"] := AllTrim((xdTbl)->CJ_CLIENTE)
			jsonObject["clienteNome"] := AllTrim((xdTbl)->clientePagar)
			jsonObject["clenteDeEntregeCodigo"] := AllTrim((xdTbl)->CJ_CLIENT)
			jsonObject["clenteDeEntregeNome"] := AllTrim((xdTbl)->clienteReceber)
			JsonObject["status"] := AllTrim((xdTbl)->CJ_STATUS)
			JsonObject["emissao"] := DToC(SToD((xdTbl)->CJ_EMISSAO))
			JsonObject["ordemcompra"] := AllTrim((cNextAlias)->CJ_XCOTCLI)
			JsonObject["vendedor"] := AllTrim((cNextAlias)->CJ_VEND1)
			(xdTbl)->( DbSkip() )
			AAdd(aArray, jsonObject)
		EndDo
		cJson := FWJsonSerialize(aArray)
		::SetResponse(cJson)
	ENDIF
Return(.T.)

WSMETHOD PUT WSSERVICE Orcamentos

	Local cBody := Nil
	Local oOrcamento := Nil
	Local jsonObject := Nil
	Local cJson := Nil
	Local aux := 0
	Local cxitem := "01"
	Local cDoc   := ""
	Local aCabec := {}
	Local aItem  := {}
	Local aItens := {}
	Local oJson  := JsonObject():New()
	Local oRet :=  JsonObject():new()

	PRIVATE cMessage := ""
	PRIVATE lMsErroAuto := .F.
	//PRIVATE __LOCALDRIVE := "DBFCDX"
	//PRIVATE __CRDD := "TOPCONN"
	//RpcSetType(3)
	RpcSetEnv('01','01')
	::SetContentType("application/json")
	cBody := ::GetContent()

	oRet := _Put(cBody)

	cRet := oRet:ToJson()

	::SetResponse(cRet)
Return .T.


Static Function _Put(cReq)

	Local oJson := JsonObject():New()
	Local oRet  := JsonObject():New()
	Local cRet  := oJson:FromJson(cReq)
	Local oCabec := Nil
	Local nJ
	Local nPos
	Local aAux := {}
	Local nI
	Local aCabec := {}
	Local aItens := {}
	Local cxitem := "00"
	Local cOrcamen := ""

	If ValType(cRet)=="U"
		oCabec := oJson:GetJsonObject("CABECALHO")
		If ValType(oCabec)=="J"
			cOrcamen := oCabec["CJ_NUM"]
			aAux := oJson["ITENS"]

			aadd(aCabec,{"CJ_NUM",cOrcamen,Nil})

			SCJ->(dbSetOrder(1))
			If SCJ->(dbSeek(xFilial("SCJ") + cOrcamen))

				SCK->(dbSetOrder(1))
				SCK->(dbSeek(xFilial("SCK") + SCJ->CJ_NUM))

				While xFilial("SCK") + SCJ->CJ_NUM ==  SCK->CK_FILIAL + SCK->CK_NUM
					aLinha := {}
					nPos := aScan(aAux, {|x| x["CK_ITEM"] == SCK->CK_ITEM} )
					if(nPos == 0)
						//Marca para Deletar
						//aLinha := {}
						aadd(aLinha,{"LINPOS","CK_ITEM",SCK->CK_ITEM})
						aadd(aLinha,{"AUTDELETA","S",Nil})
					Else
						oItem := aAux[nPos]
						//Altera as informações
						aAdd(aLinha,{"CK_ITEM", SCK->CK_ITEM , Nil} )
						aadd(aLinha,{"CK_PRODUTO", oItem["CK_PRODUTO"],Nil})
						aadd(aLinha,{"CK_QTDVEN", oItem["CK_QTDVEN"],Nil})
						aadd(aLinha,{"CK_PRCVEN",oItem["CK_PRCVEN"],Nil})
						//aadd(aLinha,{"CK_PRUNIT",100,Nil})
						aadd(aLinha,{"CK_VALOR",oItem["CK_VALOR"],Nil})
						aadd(aLinha,{"CK_LOCAL",oItem["CK_LOCAL"],Nil})
						aadd(aLinha,{"CK_PESO",oItem["CK_PESO"],Nil})
						//aadd(aLinha,{"CK_TES","501",Nil})
					  /*
					  aNames := oItem:GetNames()
					  For nI := 01 To Len(aNames)
					    If Left(aNames[nI], 3) == "CK_"
							if(aNames[nI] == "CK_ITEM")
							  aAdd(aLinha, {"CK_ITEM", SCK->CK_ITEM , Nil} )
							Else
							  aAdd(aLinha, {aNames[nI], oItem[aNames[nI]], Nil} )
							EndIf
						EndIf
					  Next
					  */
						nLen := Len(aAux)
						// remove o elemento atual do aAux para permanecer apenas os que devem ser incluidos
						aDel(aAux , nPos)
						aSize(aAux, nLen - 1)
					EndIf

					cxitem := iif(SCK->CK_ITEM > cxitem, SCK->CK_ITEM, cxitem)

					If nPos==0
						aAdd(aItens,Nil)
						aIns(aItens,1)
						aItens[01]:=aClone(aLinha)
					Else
						aAdd(aItens, aLinha)
					EndIf

					SCK->(dbSkip())
				EndDo

				For nJ := 01 To Len(aAux)
					oItem := aAux[nJ]
					aNames := oItem:GetNames()
					cxItem := Soma1(cxitem)

					aLinha := {}
					aAdd(aLinha,{"CK_ITEM", cxitem, Nil})
					aadd(aLinha,{"CK_PRODUTO", oItem["CK_PRODUTO"],Nil})
					aadd(aLinha,{"CK_QTDVEN", oItem["CK_QTDVEN"],Nil})
					aadd(aLinha,{"CK_PRCVEN",oItem["CK_PRCVEN"],Nil})
					//aadd(aLinha,{"CK_PRUNIT",100,Nil})
					aadd(aLinha,{"CK_VALOR",oItem["CK_VALOR"],Nil})
					aadd(aLinha,{"CK_TES",GetMv("MV_XTSPOR",.F.,oItem["CK_TES"]),Nil})
					aadd(aLinha,{"CK_LOCAL",oItem["CK_LOCAL"],Nil})
					aadd(aLinha,{"CK_PESO",oItem["CK_PESO"],Nil})
					/*
					For nI := 01 To Len(aNames)
					   if(aNames[nI] != "CK_ITEM")
						  aAdd(aLinha, {aNames[nI], oItem[aNames[nI]], Nil} )
					   EndIf
					Next
					*/
					aAdd(aItens, aLinha)
				Next
				Private lMsErroAuto := .F.
				MATA415(aCabec,aItens,4)
				If !lMsErroAuto
					ConOut("Alterado com sucesso! "+cOrcamen)
					oRet["sucesso"] := .T.
					oRet["mensagem"] := "Orcamento Alterado com sucesso"
				Else
					ConOut("Erro na Alteracao!")
					xMsg := MostraErro("\","Error.log")
					ConOut(xMsg)
					//cMessage := FwNoAccent(u_MDResumeErro(xMsg))
					oRet["sucesso"] := .F.
					oRet["mensagem"] := xMsg//"Orcamento Alterado com sucesso"
					//cJson := FWJsonSerialize(cMessage) //MostraErro()
					//::SetResponse(cJson)
				EndIf

			Else
				oRet["sucesso"] := "false"
				oRet["mensagem"] := "Orcamento enviado Não encontrado"
			EndIf
		Else
			oRet["sucesso"] := "false"
			oRet["mensagem"] := "CABECALHO Não enviado"
		EndIf
	Else
		oRet["sucesso"] := "false"
		oRet["mensagem"] := cRet
	EndIf

Return oRet

WSMETHOD POST WSSERVICE Orcamentos
	Local cBody := Nil
	Local oOrcamento := Nil
	Local jsonObject := Nil
	Local cJson := Nil
	Local aux := 0
	Local cxitem := "01"
	Local cDoc   := ""
	Local aCabec := {}
	Local aItem := {}
	Local aItens := {}
	Local i
	PRIVATE cMessage := ""
	PRIVATE lMsErroAuto := .F.
	//PRIVATE __LOCALDRIVE := "DBFCDX"
	//PRIVATE __CRDD := "TOPCONN"
	//RpcSetType(3)
	RpcSetEnv('01','01')
	//RpcSetEnv('01','01',,,,,{"SD2","SF2","SL4"})
	::SetContentType("application/json")
	cBody := ::GetContent()
	IF FWJsonDeserialize(cBody, @oOrcamento)
		For aux := 1 to 1
			cDoc := GetSxeNum("SCJ","CJ_NUM")
			//RollBAckSx8()
			aadd(aCabec, {"CJ_NUM" 		,cDoc,Nil})
			aadd(aCabec, {"CJ_CLIENTE"  ,oOrcamento:cabecalho:CJ_CLIENTE		,Nil})
			aadd(aCabec, {"CJ_LOJA" 	,oOrcamento:cabecalho:CJ_LOJA			,Nil})
			aadd(aCabec, {"CJ_CLIENT" 	,oOrcamento:cabecalho:CJ_CLIENT			,Nil})
			aadd(aCabec, {"CJ_LOJAENT" 	,oOrcamento:cabecalho:CJ_LOJAENT		,Nil})
			aadd(aCabec, {"CJ_CONDPAG" 	,oOrcamento:cabecalho:CJ_CONDPAG		,Nil})
			aadd(aCabec, {"CJ_TXMOEDA" 	,1									    ,Nil})
			aadd(aCabec, {"CJ_VEND1" 	,oOrcamento:cabecalho:CJ_VEND1	    	,Nil})
			//aadd(aCabec, {"CJ_TABELA" 	,oOrcamento:cabecalho:CJ_TABELA	    	,Nil})
			aadd(aCabec, {"CJ_MENNOTA" 	,oOrcamento:cabecalho:CJ_MENNOTA        ,Nil})
			aadd(aCabec, {"CJ_XCOTCLI" 	,oOrcamento:cabecalho:CJ_XCOTCLI        ,Nil})

		Next aux
		aux := Len(oOrcamento:itens)
		For i := 1 to aux
			aItem := {}
			aadd(aItem, {"CK_ITEM" 		    ,cxitem,Nil})
			aadd(aItem, {"CK_PRODUTO" 		,oOrcamento:itens[i]:CK_PRODUTO		,Nil})
			aadd(aItem, {"CK_UM" 			,oOrcamento:itens[i]:CK_UM			,Nil})
			aadd(aItem, {"CK_QTDVEN" 		,oOrcamento:itens[i]:CK_QTDVEN		,Nil})
			aadd(aItem, {"CK_PRCVEN" 		,oOrcamento:itens[i]:CK_PRCVEN		,Nil})
			aadd(aItem, {"CK_VALOR" 		,oOrcamento:itens[i]:CK_VALOR		,Nil})
			aadd(aItem, {"CK_DESCONT" 		,oOrcamento:itens[i]:CK_DESCONT		,Nil})
			aadd(aItem, {"CK_VALDESC" 		,oOrcamento:itens[i]:CK_VALDESC     ,Nil})
			aadd(aItem, {"CK_PRUNIT" 		,oOrcamento:itens[i]:CK_PRUNIT		,Nil})
			aadd(aItem, {"CK_TES" 			,GetMv("MV_XTSPOR",.F.,oOrcamento:itens[i]:CK_TES)			,Nil})
			aadd(aItem, {"CK_LOCAL" 	    ,oOrcamento:itens[i]:CK_LOCAL		,Nil})

			aadd(aItens,aItem)
			cxitem := Soma1(cxitem, 2)
		Next i
		MATA415(aCabec,aItens,3)
		If !lMsErroAuto
			ConOut("Incluido com sucesso! "+cDoc)
			JsonObject = JsonObject():new()
			jsonObject["sucesso"] := "true"
			JsonObject["orcamento"] := cDoc
			cJson := FWJsonSerialize(jsonObject)
			::SetResponse(cJson)
		Else
			ConOut("Erro na inclusao!")
			cMessage := FwNoAccent(u_MDResumeErro(MostraErro("\","Error.log")))
			jsonObject =  JsonObject():new()
			jsonObject["sucesso"] := "false"
			jsonObject["mensagem"] := cMessage
			cJson := FWJsonSerialize(jsonObject)
			//cJson := FWJsonSerialize(cMessage) //MostraErro()
			::SetResponse(cJson)
		EndIf
	ELSE
		jsonObject =  JsonObject():new()
		jsonObject["erro"] := "500"
		jsonObject["mensagem"] := "Json inválido"
		cJson := FWJsonSerialize(jsonObject)
		::SetResponse(cJson)
	ENDIF
Return(.T.)


WSMETHOD DELETE WSSERVICE Orcamentos
	Local cBody := Nil
	Local oOrcamento := Nil
	Local jsonObject := Nil
	Local cJson := Nil
	Local aux := 0
	Local aCabec := {}
	Local aItem := {}
	Local aItens := {}
	Local i
	PRIVATE cMessage := ""
	PRIVATE lMsErroAuto := .F.
	RpcSetEnv('01','01')

	::SetContentType("application/json")
	cBody := ::GetContent()

	aadd(aCabec, {"CJ_NUM" 		,cNumOrcamento := SELF:AURLPARMS[2]			,Nil})
	MATA415(aCabec,aItens,5)

	If !lMsErroAuto
		ConOut("Deletado com sucesso! "+ SELF:AURLPARMS[2])
		JsonObject = JsonObject():new()
		jsonObject["sucesso"] := .T.
		JsonObject["mensagem"] := "Deletado com sucesso"
		cJson := JsonObject:ToJson()  //FWJsonSerialize(jsonObject)
		::SetResponse(cJson)
	Else
		ConOut("Erro na inclusao!")
		cMessage := FwNoAccent(u_MDResumeErro(MostraErro("\","Error.log")))
		jsonObject =  JsonObject():new()
		jsonObject["sucesso"] := .F.
		jsonObject["mensagem"] := cMessage
		cJson := JsonObject:ToJson() //FWJsonSerialize(jsonObject)
		//cJson := FWJsonSerialize(cMessage) //MostraErro()
		::SetResponse(cJson)
	EndIf

Return(.T.)
