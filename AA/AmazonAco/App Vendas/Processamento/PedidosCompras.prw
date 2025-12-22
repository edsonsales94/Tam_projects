#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

User Function APROVPEDCOM()	

   ujd = GetData("000374","20200801","20210304",{"01","05"})
   conout(ujd)
   ujd := GetDataPedido("047318","000374",{"01","05"})//
   conout(ujd)
Return

WSRESTFUL APROVPEDCOM DESCRIPTION "Servico para listagem de pedidos de compras a serem aprovados"

WSMETHOD GET DESCRIPTION "Listagem de pedidos de compras por codigo de usuario" WSSYNTAX "/APROVPEDCOM/{dtInicio}/{dtFim}/{usuario}/{emp01|emp02|...|empnn}/{numPedido}"
WSMETHOD POST DESCRIPTION "Aprovacao de pedidos de compras" WSSYNTAX "/APROVPEDCOM" 

END WSRESTFUL

WSMETHOD GET WSSERVICE APROVPEDCOM
//	Local jsonObject := Nil
//	Local aArray := {}
    Local cUsuario := ""
    Local dtInicio 	:= ""
    Local dtFim		:= ""
    Local cNumPedido := ""
	Local aEmpresas := {}
	Local xJson := ""
    
    dtInicio  	:= ::AURLPARMS[1]
    dtFim 		:= ::AURLPARMS[2]
    cUsuario 	:= ::AURLPARMS[3]
	
    aEmpresas := iIf(Len(::AURLPARMS) > 3,StrToKArr(::AURLPARMS[4],";"), {FwCodEmp()} )
	
	IF Len(::AURLPARMS) > 4
	   cNumPedido := ::AURLPARMS[5]
	   xJson := GetDataPedido(cNumPedido,cUsuario,aEmpresas)
	Else
	   xJson := GetData(cUsuario,dtInicio,dtFim,aEmpresas)
	   conout(xJson)
	EndIf
    ::SetResponse(xJson)
/*
    ::SetContentType("application/json")
    IF Len(::AURLPARMS) > 3
    	cNumPedido := ::AURLPARMS[4]
    	 cQry := " SELECT C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_PRECO, C7_TOTAL, C7_UM  "
    	 cQry += " FROM "+RetSQLName("SC7")+" SC7 (NOLOCK) "
    	 cQry += " INNER JOIN "+RetSQLName("SAK")+" SAK (NOLOCK)  "
    	 cQry += " ON (AK_USER = '"+cUsuario+"' AND SAK.AK_LIMMAX >= C7_TOTAL AND SAK.D_E_L_E_T_ = '')  "
    	 cQry += " WHERE SC7.D_E_L_E_T_ = '' AND SC7.C7_NUM = '"+cNumPedido+"' "
    	 xdTb2 := MpSysOpenQUery(cQry)
    	 While !(xdTb2)->(Eof())
	        jsonObject =  JsonObject():new()
	        jsonObject["item"] := AllTrim((xdTb2)->C7_ITEM )
	        jsonObject["produto"] := AllTrim((xdTb2)->C7_PRODUTO)
	        jsonObject["descricao"] := AllTrim((xdTb2)->C7_DESCRI)
	        jsonObject["quantidade"] := TRANSFORM((xdTb2)->C7_QUANT,"@E 999,999,999.99")
	        jsonObject["precoUnit"] := TRANSFORM((xdTb2)->C7_PRECO,"@E 999,999,999.99")
	        jsonObject["precoTotal"] := TRANSFORM((xdTb2)->C7_TOTAL,"@E 999,999,999.99")
	        jsonObject["um"] := AllTrim((xdTb2)->C7_UM)
	        AAdd(aArray, jsonObject)
	        (xdTb2)->( DbSkip() ) 
	       EndDO
    cJson := FWJsonSerialize(aArray)
    ::SetResponse(cJson)
    ELSE
	    cQry := " SELECT SCR.R_E_C_N_O_ as documento, SCR.CR_NUM, SCR.CR_FILIAL,  "
	    cQry += " SCR.CR_TOTAL AS CR_TOTAL, SCR.CR_EMISSAO AS CR_EMISSAO, A2_NOME, E4_DESCRI "
	    cQry += " FROM "+RETSQLNAME("SCR")+" SCR   " 
	    cQry += " INNER JOIN "+RETSQLNAME("SAK")+" SAK ON  SAK.D_E_L_E_T_=''  AND SAK.AK_USER=SCR.CR_USER  " 
	    cQry += " INNER JOIN( SELECT A2_NOME,C7_NUM,C7_FILIAL,E4_DESCRI FROM "+RETSQLNAME("SC7")+" SC7 " 
	    cQry += " INNER JOIN "+RETSQLNAME("SA2")+" SA2 ON SA2.D_E_L_E_T_='' AND SA2.A2_COD=SC7.C7_FORNECE "
	    cQry += " INNER JOIN "+RETSQLNAME("SE4")+" SE4 ON SE4.D_E_L_E_T_='' AND SE4.E4_CODIGO=SC7.C7_COND "
	    cQry += " WHERE SC7.D_E_L_E_T_='' GROUP BY A2_NOME,C7_NUM,C7_FILIAL,E4_DESCRI"
	    cQry += " ) AS SC7 ON  SC7.C7_FILIAL=SCR.CR_FILIAL AND SC7.C7_NUM=SCR.CR_NUM "
	    cQry += " WHERE SCR.D_E_L_E_T_='' "
	    cQry += " AND SCR.CR_STATUS IN ('02') "
	    cQry += " AND (AK_USER = '"+cUsuario+"')  "
	    cQry += " AND SCR.CR_EMISSAO>='"+dtInicio+"' AND SCR.CR_EMISSAO<='"+dtFim+"' " 
	    xdTb2 := MpSysOpenQUery(cQry)
	    While !(xdTb2)->(Eof())
	        jsonObject =  JsonObject():new()
	        jsonObject["filial"] := AllTrim((xdTb2)->CR_FILIAL )
	        jsonObject["documeto"] := (xdTb2)->documento
	        jsonObject["numeroPedido"] := AllTrim((xdTb2)->CR_NUM )
	        jsonObject["nomeFornecedor"] := AllTrim((xdTb2)->A2_NOME)
	        jsonObject["descriCondPag"] := AllTrim((xdTb2)->E4_DESCRI)
	        jsonObject["total"] := TRANSFORM((xdTb2)->CR_TOTAL,"@E 999,999,999.99")
	        jsonObject["emissao"] := DToC(SToD((xdTb2)->CR_EMISSAO))
	        AAdd(aArray, jsonObject)
	        (xdTb2)->( DbSkip() ) 
	    EndDO
	    cJson := FWJsonSerialize(aArray)
	    ::SetResponse(cJson)
    EndIf
*/
Return(.T.)


WSMETHOD POST WSSERVICE APROVPEDCOM
    Local lPost := .T.
	Local cBody
	Local cReturn := '{"error":"Not Implemented"}'
	Local cdProduto := ""
	Local cdOpcao   := ""
	Local cError    := ""
	//Local cError    := ""

	Private aErros  :={}
	cBody := ::GetContent()
	aRetornos := _Libera(cBody)
	For nX :=1 To Len(aRetornos)
		conout(aRetornos[nx][1])
	Next nX
	cReturn := FWJsonSerialize(FRetProd(aRetornos), .F., .F., .T.)
	conout(cReturn)
	::SetResponse(cReturn)
return (.T.)

Static Function GetData(cUsuario,dtInicio,dtFim,xEmpresas)

   Local cQry := ""
   Local oJson :=JsonObject():new()
   Local jsonObject := Nil
   Local nI := 0
   Local aArray := {}
   Local nI
   For nI := 1 To Len(xEmpresas)

		RpcSetEnv(xEmpresas[nI])
		
		cQry := " SELECT SCR.R_E_C_N_O_ as documento, SCR.CR_NUM, SCR.CR_FILIAL,  "
		cQry += " SCR.CR_TOTAL AS CR_TOTAL, SCR.CR_EMISSAO AS CR_EMISSAO, A2_NOME, E4_DESCRI "
		cQry += " FROM "+RETSQLNAME("SCR")+" SCR   " 
		cQry += " INNER JOIN "+RETSQLNAME("SAK")+" SAK ON  SAK.D_E_L_E_T_=''  AND SAK.AK_USER=SCR.CR_USER  " 
		cQry += " INNER JOIN( SELECT A2_NOME,C7_NUM,C7_FILIAL,E4_DESCRI FROM "+RETSQLNAME("SC7")+" SC7 " 
		cQry += " INNER JOIN "+RETSQLNAME("SA2")+" SA2 ON SA2.D_E_L_E_T_='' AND SA2.A2_COD=SC7.C7_FORNECE "
		cQry += " INNER JOIN "+RETSQLNAME("SE4")+" SE4 ON SE4.D_E_L_E_T_='' AND SE4.E4_CODIGO=SC7.C7_COND "
		cQry += " WHERE SC7.D_E_L_E_T_='' GROUP BY A2_NOME,C7_NUM,C7_FILIAL,E4_DESCRI"
		cQry += " ) AS SC7 ON  SC7.C7_FILIAL=SCR.CR_FILIAL AND SC7.C7_NUM=SCR.CR_NUM "
		cQry += " WHERE SCR.D_E_L_E_T_='' "
		cQry += " AND SCR.CR_STATUS IN ('02') "
		cQry += " AND (AK_USER = '"+cUsuario+"')  "
		cQry += " AND SCR.CR_EMISSAO>='"+dtInicio+"' AND SCR.CR_EMISSAO<='"+dtFim+"' " 
		xdTb2 := MpSysOpenQUery(cQry)
		While !(xdTb2)->(Eof())
			jsonObject =  JsonObject():new()
			jsonObject["empresa"] := xEmpresas[nI]
			jsonObject["filial"] := AllTrim((xdTb2)->CR_FILIAL )
			jsonObject["documeto"] := (xdTb2)->documento
			jsonObject["numeroPedido"] := AllTrim((xdTb2)->CR_NUM )
			jsonObject["nomeFornecedor"] := AllTrim((xdTb2)->A2_NOME)
			jsonObject["descriCondPag"] := AllTrim((xdTb2)->E4_DESCRI)
			jsonObject["total"] := TRANSFORM((xdTb2)->CR_TOTAL,"@E 999,999,999.99")
			jsonObject["emissao"] := DToC(SToD((xdTb2)->CR_EMISSAO))
			AAdd(aArray, jsonObject)
			(xdTb2)->( DbSkip() ) 
		EndDo
		RpcClearEnv()
		
    Next nI
	oJson:Set(aArray)
	xJson := oJson:ToJson()

	
	if Len(xJson) == 2
	   xJson := FWJsonSerialize(aArray)
	EndIf
return xJson

static function GetDataPedido(xNumPedido,cUsuario,xEmpresas)
   
   Local cQry := ""
   Local oJson :=JsonObject():new()
   Local jsonObject := Nil
   Local nI := 0
   Local aArray := {}
   
   For nI := 1 To Len(xEmpresas)
       RpcSetEnv(xEmpresas[nI])
	   
	   cQry := " SELECT C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_PRECO, C7_TOTAL, C7_UM  "
	   cQry += " FROM "+RetSQLName("SC7")+" SC7 (NOLOCK) "
	   cQry += " INNER JOIN "+RetSQLName("SAK")+" SAK (NOLOCK)  "
	   cQry += " ON (AK_USER = '"+cUsuario+"' AND SAK.AK_LIMMAX >= C7_TOTAL AND SAK.D_E_L_E_T_ = '')  "
	   cQry += " WHERE SC7.D_E_L_E_T_ = '' And SC7.C7_NUM = '"+xNumPedido+"' "
	   
	   xdTb2 := MpSysOpenQUery(cQry)
	   While !(xdTb2)->(Eof())
		  jsonObject := JsonObject():new()
		  //jsonObject["empresa"] := xEmpresas[nI]
		  jsonObject["item"] := AllTrim((xdTb2)->C7_ITEM )
		  jsonObject["produto"] := AllTrim((xdTb2)->C7_PRODUTO)
		  jsonObject["descricao"] := AllTrim((xdTb2)->C7_DESCRI)
		  jsonObject["quantidade"] := TRANSFORM((xdTb2)->C7_QUANT,"@E 999,999,999.99")
		  jsonObject["precoUnit"] := TRANSFORM((xdTb2)->C7_PRECO,"@E 999,999,999.99")
		  jsonObject["precoTotal"] := TRANSFORM((xdTb2)->C7_TOTAL,"@E 999,999,999.99")
		  jsonObject["um"] := AllTrim((xdTb2)->C7_UM)
		  AAdd(aArray, jsonObject)
		  (xdTb2)->( DbSkip() ) 
	   EndDo
	   RpcClearEnv()
   Next
   
   oJson:Set(aArray)
   xJson := oJson:ToJson()
	if Len(xJson) == 2
	   xJson := FWJsonSerialize(aArray)
	EndIf
   
return xJson

Static Function _Libera(cdJson)
	Local odLiberacao  := Nil
	Local lSucesso := .F.	
	Local aRetorno := {}


	lOK := .T.
	cMessage := ""
	//conoUt(cdJson)
	If Empty(cdJson)
		cMessage := "JSON invalido!"
		aAdd(aRetorno,{"400",u_NoAcento(cMessage),lSucesso})
	Else
		If FWJsonDeserialize(cdJson,@odLiberacao)
			aRetorno := aClone(FLibera(odLiberacao))
		Else
			lOK := .F.
			cMessage := "Falha ao Efetuar a Leitura do JSON"
			aAdd(aRetorno,{"400",u_NoAcento(cMessage),lSucesso})
		EndIf
		MemoWrite("C:\Users\Administrator\Desktop\Jsons\"+Dtos(dDataBase)+"T"+StrTran(Time(),':','-')+".txt",cdJson)
	EndIf
	Conout('Retornando')
Return aRetorno

Static Function Flibera(odLiberacao)
	Local cMessage := ""
	Local aRetorno := {}
	Local lSucesso := .F.
	Local nOpc     := Iif(Alltrim(odLiberacao:aprova)=="true",2,3)
	Local cUser    := Alltrim(odLiberacao:userAprov)
	Local nRecno   := Val(odLiberacao:documento)
	
	RpcSetEnv(odLiberacao:empresa, odLiberacao:filial)

	SCR->(dbClearFilter())
	SCR->(DbGoto(nRecno))
	PCLibera("SCR",SCR->(Recno()),nOpc,cUser,@aRetorno)

Return aRetorno


Static Function PCLibera(cAlias,nReg,nOpc,cUser,aRetorno)
    Local aArea		:= GetArea()
	Local aCposObrig:= {"D1_ITEM","D1_COD","D1_QUANT","D1_VUNIT","D1_PEDIDO","D1_ITEMPC","C7_QUANT","C7_PRECO","C7_QUJE",""}
	Local aHeadCpos := {}
	Local aHeadSize := {}
	Local aArrayNF	:= {}
	Local aCampos   := {}
	Local aRetSaldo := {}
	Local cObs 		:= ""
	Local ca097User := cUser
	Local cTipoLim  := ""
	Local CRoeda    := ""
	Local cAprov    := ""
	Local cName     := ""
	Local cSavColor := ""
	Local cGrupo	:= ""
	Local cCodLiber := SCR->CR_APROV
	Local cDocto    := SCR->CR_NUM
	Local cTipo     := SCR->CR_TIPO
	Local cFilDoc   := SCR->CR_FILIAL
	Local dRefer 	:= dDataBase
	Local cPCLib	:= ""
	Local cPCUser	:= ""
	Local lSucesso  := .F.

	Local lMta097   := ExistBlock("MTA097")
	Local lAprov    := .F.
	Local lLiberou	:= .F.
	Local lLibOk    := .F.
	Local lContinua := .T.
	Local lShowBut  := .T.
	Local lOGpaAprv := SuperGetMv("MV_OGPAPRV",.F.,.F.)

	Local nSavOrd   := IndexOrd()
	Local nSaldo    := 0
	Local nSalDif	:= 0
	Local nTotal    := 0
	Local nMoeda	:= 1
	Local nX        := 1
	Local nRecnoAS400:= 1

	Local oDlg
	Local oDataRef
	Local oSaldo
	Local oSalDif
	Local oBtn1
	Local oBtn2
	Local oBtn3
	Local oQual

	Local aSize := {0,0}

	Local lUsaACC := If(FindFunction("WebbConfig"),WebbConfig(),.F.)

	If ExistBlock("MT097LIB")
		ExecBlock("MT097LIB",.F.,.F.)
	EndIf

	If ExistBlock("MT097LOK")
		lContinua := ExecBlock("MT097LOK",.F.,.F.)
		If ValType(lContinua) # 'L'
			lContinua := .T.
		Endif
	EndIf

	If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
        aAdd(aRetorno,{"404",FWNoAccent("Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."),lSucesso})
        lContinua := .F.
	ElseIf lContinua .And. SCR->CR_STATUS$"01"
        aAdd(aRetorno,{"404",FWNoAccent("Esta operaç?o n?o poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"),lSucesso})
		//Aviso("A097BLQ",STR0083,{STR0031}) //Esta operaç?o n?o poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)"
		lContinua := .F.
	EndIf

	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		//? Monta o Header com os titulos do TWBrowse             ?
		//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		dbSelectArea("SX3")
		dbSetOrder(2)
		For nx	:= 1 to Len(aCposObrig)
			If MsSeek(aCposObrig[nx])
				AADD(aHeadCpos,AllTrim(X3Titulo()))
				AADD(aHeadSize,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
				AADD(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
			Else
				AADD(aHeadCpos,"Divergencia") // "Divergencia"
				AADD(aCampos,{" ","C"})
			EndIf
		Next

		dbSelectArea("SAL")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		//? Inicializa as variaveis utilizadas no Display.               ?
		//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		aRetSaldo := MaSalAlc(cCodLiber,dRefer)
		nSaldo 	  := aRetSaldo[1]
		CRoeda 	  := A097Moeda(aRetSaldo[2])
		cName  	  := UsrRetName(ca097User)
		nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)

		Do Case
		Case SAK->AK_TIPO == "D"
			cTipoLim :=OemToAnsi("Diario") // "Diario"
		Case  SAK->AK_TIPO == "S"
			cTipoLim := OemToAnsi("Semanal") //"Semanal"
		Case  SAK->AK_TIPO == "M"
			cTipoLim := OemToAnsi("Mensal") //"Mensal"
		Case  SAK->AK_TIPO == "A"
			cTipoLim := OemToAnsi("Anual") //"Anual"
		EndCase
		If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"

			dbSelectArea("SC7")
			dbSetOrder(1)
			MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
			cGrupo := SC7->C7_APROV

			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

			dbSelectArea("SAL")
			dbSetOrder(3)
			MsSeek(xFilial("SAL")+SC7->C7_APROV+SAK->AK_COD)

			If Eof()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
				//? Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ?
				//| transferido por Aus?ncia Temporária ou Transfer?ncia superior e o aprovador |
				//| de destino n?o fizer parte do Grupo de Aprovaç?o.                           |
				//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
				If !Empty(SCR->(FieldPos("CR_USERORI")))
					dbSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APRORI)
				EndIf
			EndIf

			If lOGpaAprv
				If Eof()
                    aAdd(aRetorno,{"404",FWNoAccent("O aprovador n?o foi encontrado no grupo de aprovaç?o deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovaç?o "),lSucesso})
                    //SetRestFault(404, STR0087+SC7->C7_APROV+CRLF+STR0090, .T.)
					//Aviso("A097NOAPRV",STR0087+SC7->C7_APROV+CRLF+STR0090,{"Ok"}) // "O aprovador n?o foi encontrado no grupo de aprovaç?o deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovaç?o "
					lContinua := .F.
				EndIf
			Endif
			//lContinua := .T.
		EndIf

		If SAL->AL_LIBAPR != "A"
			lAprov := .T.
			cAprov := OemToAnsi("VISTO/LIVRE") // "VISTO / LIVRE"
		EndIf
		nSalDif := nSaldo - IIF(lAprov,0,nTotal)
		If (nSalDif) < 0
            aAdd(aRetorno,{"404",FWNoAccent("Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."),lSucesso})
            //SetRestFault(404,STR0041, .T.)
			//Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
			lContinua := .F.
		EndIf
	EndIf

	If lContinua

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		//? Inicializa a gravacao dos lancamentos do SIGAPCO          ?
		//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		PcoIniLan("000055")

		If nOpc == 2 .Or. nOpc == 3
			SCR->(dbClearFilter())
			SCR->(dbGoTo(nReg))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//?Esta Rotina posiciona o Browse no proximo registro valido  ?
			//?para o filtro "Nao Aprovados" pois em AS400 Top 2 apos     ?
			//?a liberacao o Browse sempre era posicionado no final do    ?
			//?arquivo.                                                   ?
			//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			#IFDEF TOP
				If TcSrvType() == "AS/400"
					dbSelectArea("SCR")
					Do While !Eof()
						SCR->(dbSkip())
						If  MV_PAR01 == 1 .And. ( SCR->CR_FILIAL == xFilial("SCR") .And. SCR->CR_USER == ca097User .And. SCR->CR_STATUS == "02" )
							aArea		:= GetArea()
							nRecnoAS400 := SCR->(Recno())
							Exit
						EndIf
					EndDo
					SCR->(dbGoTo(nReg))
				EndIf
			#ENDIF

			If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
				lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)),SCR->CR_TIPO)
			EndIf
			If lLibOk
				Begin Transaction
					If lMta097 .And. nOpc == 2
						If ExecBlock("MTA097",.F.,.F.)
							lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
						EndIf
					Else
						lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
					EndIf
					If !lLiberou .And. !Empty(SCR->CR_DATALIB) 
						aAdd(aRetorno,{"200","O pedido foi aprovado com sucesso, porem existem outros niveis para aprovacao!",.T.})
					EndIf
					If lLiberou
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
						//? Grava os lancamentos nas contas orcamentarias SIGAPCO    ?
						//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
						aAdd(aRetorno,{"200","Operacao executada com sucesso!",.T.})
//						PcoDetLan("000055","02","MATA097")

						If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
							If SuperGetMv("MV_EASY")=="S" .AND. SC7->(FieldPos("C7_PO_EIC"))<>0 .And. !Empty(SC7->C7_PO_EIC)
								If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. SW2->(FieldPos("W2_CONAPRO"))<>0 .AND. !Empty(SW2->W2_CONAPRO)
									Reclock("SW2",.F.)
									SW2->W2_CONAPRO := "L"
									MsUnlock()
								EndIf
							EndIf
							dbSelectArea("SC7")
							cPCLib := SC7->C7_NUM
							cPCUser:= SC7->C7_USER
							While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
								Reclock("SC7",.F.)
								SC7->C7_CONAPRO := "L"
								MsUnlock()
								If ExistBlock("MT097APR")
									ExecBlock("MT097APR",.F.,.F.)
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
								//? Grava os lancamentos nas contas orcamentarias SIGAPCO    ?
								//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//								PcoDetLan("000055","01","MATA097")
								dbSkip()
							EndDo

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
							//? Integracao ACC envia aprovacao do pedido            ?
							//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//							dbSkip(-1)
//							If lUsaACC .And. !Empty(SC7->C7_ACCNUM)
///								If IsBlind()
//									Webb533(SC7->C7_NUM)
//								Else
//									MsgRun("Aguarde","comunicando aprovacao ao portal",{|| Webb533(SC7->C7_NUM)})	//Aguarde, comunicando aprovaç?o ao portal... ## Portal ACC
//								EndIf
//							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
							//? Envia e-mail ao comprador ref. Liberacao do pedido para compra- 034?
							//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//							MEnviaMail("034",{cPCLib,SCR->CR_TIPO},cPCUser)
						EndIf
					EndIf
				End Transaction
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
				//? Finaliza a gravacao dos lancamentos do SIGAPCO            ?
				//?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//				PcoFinLan("000055")
			Else
				Help(" ",1,"A097LOCK")
			Endif
			If cTipo == "NF"
				SF1->(MsUnlockAll())
			ElseIf cTipo == "PC" .Or. cTipo == "AE"
				SC7->(MsUnlockAll())
			ElseIf cTipo == "CP"
				SC3->(MsUnlockAll())
			ElseIf cTipo == "MD"
				CND->(MsUnlockAll())
			EndIf
		EndIf
		dbSelectArea("SCR")
		dbSetOrder(1)

		#IFDEF TOP
			If TcSrvType() == "AS/400"
				set filter to  &(cXFiltraSCR)

				If MV_PAR01 == 1
					SCR->(dbGoTo(nRecnoAS400))
				EndIf
			Else
			#ENDIF
			#IFDEF TOP
			EndIf
		#ENDIF

//		PcoFreeBlq("000055")
	EndIf
	dbSelectArea("SC7")
	If ExistBlock("MT097END")
		ExecBlock("MT097END",.F.,.F.,{cDocto,cTipo,nOpc,cFilDoc})
	EndIf
	RestArea(aArea)

Return Nil

Static Function FRetProd(aErros)
Local oJsonRet := JsonObject():New()

oJsonRet["erros"] :={}
ConOut(str(Len(aErros)))

For nX:=1 To Len(aErros)
Aadd(oJsonRet["erros"],JsonObject():New())
	oJsonRet["erros"][nX]['sucesso'] 		:= Iif(aErros[nX][3],"true","false")
	oJsonRet["erros"][nX]['codigoProduto'] 	:= aErros[nX][1]
	oJsonRet["erros"][nX]['descricaoErro'] 	:= aErros[nX][2]
Next nX
Return oJsonRet
