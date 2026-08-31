#Include "Protheus.ch"
#Include "AP5Mail.ch"
#Include "Tbiconn.ch"

Static cURL     := "http://189.126.142.178:8263/erp-octopus-1017/"  //"https://integracoesmagistral.tamosjuntos.com.br" //+cLicenca+"/"
Static nTimeOut := 360

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MGFATJ01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 14/11/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Serviço de importação das vendas do sistema Magistral         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MGFATJ01(aEmpFil)
	Local aProc := {}
	
	Default aEmpFil := { "01", "0201"}
	
	Private cLicenca := "1088"
	
	PREPARE ENVIRONMENT EMPRESA aEmpFil[1] FILIAL aEmpFil[2] MODULO "FAT" TABLES "SC5", "SC6", "SA1", "SB1"
	
	u_MGLicenca()   // Atualiza a licença
	
	AAdd( aProc , { .T., {|| IncVendas()  } } )   // Importa as vendas
	AAdd( aProc , { .F., {|| CancVendas() } } )   // Importa o cancelamento das vendas
	AAdd( aProc , { .F., {|| IncBaixas()  } } )   // Importa as baixas
	AAdd( aProc , { .F., {|| CancBaixas() } } )   // Importa o cancelamento das baixas
	AAdd( aProc , { .F., {|| GravaImp()   } } )   // Processa as integrações
	
	// Processa a execução das rotinas
	aEval( aProc , {|x| If( x[1] , Eval(x[2]) , ) } )
	
	RESET ENVIRONMENT
	
Return

User Function MGLicenca()
	Do Case
		Case cFilAnt == "0201" ; cLicenca := "1088"
		Case cFilAnt == "0202" ; cLicenca := "3657"
	EndCase
Return cLicenca

Static Function Autentica()
	Local oJSon, cErro, lOk, cPostRet
	Local aAutSPCF := Separa(GetMV("MV_XAUTMAG",.F.,"portalvendas|@erponlinerestapi2018"),"|",.F.)    // Usuário e Senha de Autenticação PRODAM
	Local cCredenc := "?username="+aAutSPCF[1]+"&password="+aAutSPCF[2]+"&grant_type=password"
	Local cPostPar := ""
	Local aHeadOut := {'Content-Type: application/json', 'Authorization: Basic UE9SVEFMX1ZFTkRBUzowMDI='}
	Local cCertCRT := ""   //"\certificado\Infostore_certificado.crt"   // <--- CERTIFICADO CRT (caso haja)
	Local cCertKEY := ""   //"\certificado\INFOSTORE.key"   // <--- CERTIFICADO KEY (caso haja)
	Local cHeadRet := ""
	Local cSenha1  := ""
	Local cToken   := ""
	
	cPostRet := HTTPSPost( cURL + "oauth/token"+cCredenc,cCertCRT, cCertKEY, cSenha1, "", cPostPar, nTimeOut, aHeadOut, @cHeadRet )
	
	If lOk := !( cPostRet == Nil .Or. Empty( cPostRet ) )
		// Cria o objeto JSON e popula ele a partir da string
		oJSon := JSonObject():New()
		cErro := oJSon:FromJson(cPostRet)
		
		If lOk := ( cErro == Nil .Or. Empty(cErro) )
			cToken := oJSon:GetJSonObject('access_token')
		ElseIf IsBlind()
		Else
			FWAlertWarning(cErro,"JSON PARSE ERROR")
		Endif
	Endif
	
Return cToken

Static Function IncVendas(dDiaProc,lExec)
	Local dAux   := dDataBase
	Local cParam := "api/v1/documentos/fiscais"
	Local lRet   := .F.
	
	Default dDiaProc := dDataBase - 1
	
	dDataBase := dDiaProc
	
	cParam += "?licenca="+cLicenca+"&dataEmissao="+DtoS(dDataBase)
	
	lRet := ImportaJSON(cParam,"1",lExec)
	
	dDataBase := dAux
	
Return lRet

Static Function CancVendas(dDiaProc,lExec)
	Local dAux   := dDataBase
	Local cParam := "api/v1/documentos/fiscais/cancelados"
	Local lRet   := .F.
	
	Default dDiaProc := dDataBase - 1
	
	dDataBase := dDiaProc
	
	cParam += "?licenca="+cLicenca+"&dataEmissao="+DtoS(dDataBase)
	
	lRet := ImportaJSON(cParam,"2",lExec)
	
	dDataBase := dAux
	
Return lRet

Static Function IncBaixas(dDiaProc,lExec)
	Local dAux   := dDataBase
	Local cParam := "api/v1/movimentos-financeiros/baixas"
	Local lRet   := .F.
	
	Default dDiaProc := dDataBase - 1
	
	dDataBase := dDiaProc
	
	cParam += "?licenca="+cLicenca+"&dataBaixa="+DtoS(dDataBase)
	
	lRet := ImportaJSON(cParam,"3",lExec)
	
	dDataBase := dAux
	
Return lRet

Static Function CancBaixas(dDiaProc,lExec)
	Local dAux   := dDataBase
	Local cParam := "api/v1/movimentos-financeiros/estornos"
	Local lRet   := .F.
	
	Default dDiaProc := dDataBase
	
	dDataBase := dDiaProc
	
	cParam += "?licenca="+cLicenca+"&dataBaixa="+DtoS(dDataBase)
	
	lRet := ImportaJSON(cParam,"4",lExec)
	
	dDataBase := dAux
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ImportaJSON ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 14/11/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa a importação das vendas do sistema Magistral         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ImportaJSON(cParam,cOper,lExec)
	Local nOk, nX, cEndereco
	Local cCert_CRT := ""  //GetMV("MV_XCERCRT",.F.,"\certificado\CERTIFICADO.crt")
	Local cCert_KEY := ""  //GetMV("MV_XCERKEY",.F.,"\certificado\CHAVE_PRIVADA_BOLECODE.key")
	Local cToken    := Autentica()
	Local cHeadRet  := ""
	Local cPostPar  := ""
	Local cSenha1   := "" //"senha1234"
	Local cErro     := ""
	Local nErros    := 0
	Local aHeadOut  := {}
	Local nPage     := 1    // Página corrente
	Local nTotal    := 1    // Total de páginas
	Local nSize     := 100   // Registros por página
	Local lProc     := .T.
	
	Default lExec := .T.
	
	Private aExec := {}
	
	//AAdd( aHeadOut, 'x-magistral-apikey: ' + cClient_ID )
	AAdd( aHeadOut, 'Content-Type: application/json' )
	AAdd( aHeadOut, 'Authorization: Bearer ' + cToken )
	
	While lProc .And. nPage <= nTotal
		cEndereco := cURL+cParam + "&page="+LTrim(cValToChar(nPage)) + "&size="+LTrim(cValToChar(nSize))
		cPostRet  := HTTPSGet( cEndereco, cCert_CRT, cCert_KEY, cSenha1, cPostPar, nTimeOut, aHeadOut, @cHeadRet )
		
		If cPostRet == Nil .Or. Empty( cPostRet )
			If IsBlind()
				u_fconout( "Fail HTTPSGet" )
			Else
				FWAlertError( "Fail HTTPSPost" )
			Endif
		ElseIf (nOk := Erros( cPostRet , cHeadRet )) < 0
			nErros++
			If nErros < 4
				// Força uma busca do acesso aos locations
				cPostRet := HTTPSGet( cURL, cCert_CRT, cCert_KEY, cSenha1, cPostPar, nTimeOut, aHeadOut, @cHeadRet )
				Sleep(1000)
			Endif
		ElseIf nOk > 0
			u_fconout( "OK HTTPSGet" )
			
			// Cria o objeto JSON e popula ele a partir da string
			TextToJSon(cPostRet,@cErro,cOper,@nTotal)
			
			If ( cErro == Nil .Or. Empty(cErro) )
			Else
				If IsBlind()
					u_fconout("JSON PARSE ERROR >>>" + cErro)
				Else
					FWAlertWarning(cErro,"JSON PARSE ERROR")
				Endif
			Endif
		Endif
		
		nPage++
	Enddo
	
	If lExec
		// Processa a execução das integrações
		For nX:=1 To Len(aExec)
			SZ4->(dbGoTo(aExec[nX]))   // Posiciona no registro
			ProcJson()
		Next
	Endif
	
Return !Empty(aExec)

Static Function TextToJSon(cPostRet,cErro,cOper,nTotal)
	Local oJSon    := JSonObject():New()
	
	cErro := oJSon:FromJson(cPostRet)
	
	If ValType(oJSon) <> "U" .And. ( cErro == Nil .Or. Empty(cErro) )
		
		If cOper $ "12"   // Faturamento
			// Atualiza o total de páginas a serem processadas
			If nTotal == 1 .And. oJSon["sucesso"]
				nTotal := oJSon["content"]["pages"]
			Endif
		Else              // Financeiro
			If nTotal == 1 .And. oJSon["pages"] <> Nil
				nTotal := oJSon["pages"]
			Endif
		Endif
		
		dbSelectArea("SZ4")
		//If !SZ4->(dbSeek(XFILIAL("SZ4")))
			Begin Transaction
			
			// Adiciona a importação na fila de processamento
			RecLock("SZ4",.T.)
			SZ4->Z4_FILIAL  := XFILIAL("SZ4")
			SZ4->Z4_ID      := GetSXENum("SZ4","Z4_ID")
			SZ4->Z4_DTDIGIT := dDataBase
			SZ4->Z4_DATA    := Date()
			SZ4->Z4_HORA    := Time()
			SZ4->Z4_ROTINA  := If( cOper $ "12" , "MATA410", "FINA070")
			SZ4->Z4_NOME    := If( cOper $ "12" , "Pedido de Venda", "Baixas a Receber")
			SZ4->Z4_STATUS  := "1"    // 1=Pendente;2=Erro;3=Processado
			SZ4->Z4_OPER    := cOper  // 1=Vendas, 2=Cancela Vendas, 3=Baixas, 4=Cancela Baixas
			SZ4->Z4_REST    := cPostRet
			MsUnLock()
			
			ConfirmSX8()
			
			End Transaction
		//Endif
		
		AAdd( aExec , SZ4->(Recno()) )    // Adiciona para execução
	Endif

Return

Static Function GravaImp()
	Local aArea := GetArea()
	Local cTmp  := GetNextAlias()
	
	BeginSQL Alias cTmp
		SELECT SZ4.%RecNo% AS Z4_RECNO
		FROM %Table:SZ4%  SZ4
		WHERE SZ4.%NotDel%
		AND SZ4.Z4_FILIAL = %Exp:XFILIAL("SZ4")%
		AND SZ4.Z4_STATUS <> '2'
		ORDER BY SZ4.%RecNo%
	EndSQL
	
	While (cTmp)->(Eof())
		
		SZ4->(dbGoTo((cTmp)->Z4_RECNO))   // Posiciona no registro
		
		ProcJson()
		
		(cTmp)->(dbSkip())
	Enddo
	(cTmp)->(dbCloseArea())
	RestArea(aArea)

Return

User Function MGIntegra(lLote,cID)
Return ProcJson(lLote,cID)

User Function MGImporta(nOpc,dDiaProc)
	Local lRet := .F.
	
	If nOpc == 1
		lRet := IncVendas(dDiaProc,.F.)
	ElseIf nOpc == 2
		lRet := CancVendas(dDiaProc,.F.)
	ElseIf nOpc == 3
		lRet := IncBaixas(dDiaProc,.F.)
	ElseIf nOpc == 4
		lRet := CancBaixas(dDiaProc,.F.)
	Endif

Return lRet

Static Function ProcJson(lLote,cID)
	Local oLOG
	Local oJSon  := JSonObject():New()
	Local aLOG   := {}
	Local cErro  := oJSon:FromJson(AllTrim(SZ4->Z4_REST))
	Local nErros := 0
	
	Default lLote := .F.
	Default cID   := ""
	
	lMsHelpAuto := .F.
	lMsErroAuto := .F.
	
	If ValType(oJSon) <> "U" .And. ( cErro == Nil .Or. Empty(cErro) )
		If SZ4->Z4_OPER == "1"      // Vendas
			cErro := GravaVenda(oJSon,aLOG,,,cID)
		ElseIf SZ4->Z4_OPER == "2"  // Cancela Vendas
			cErro := GravaCancel(oJSon,cID)
		ElseIf SZ4->Z4_OPER == "3"  // Baixas
			cErro := GravaBaixa(oJSon,aLOG,cID)
		ElseIf SZ4->Z4_OPER == "4"  // Cancela Baixas
			cErro := GravaEstor(oJSon)
		Endif
	Endif
	
	If !Empty(aLOG)
		aEval( aLOG , {|x| If( !Empty(x["Log"]) , nErros++,) } )   // Totaliza a quantidade de erros
		
		If nErros > 0
			oLOG := JsonObject():New()
			oLOG["Status"] := aLOG 
			
			cErro := FWJSonSerialize(oLOG,.F.,.T.,.T.)
		Endif
	Endif
	
	If nErros == 0 .And. lMsErroAuto
		If IsBlind()
			cErro := ResumeErro(MostraErro("\","Error.log"))
		Else
			cErro := MostraErro()
			cErro := ResumeErro(cErro)
		Endif
	Endif
	
	RecLock("SZ4",.F.)
	SZ4->Z4_STATUS := If( nErros > 0 .Or. lMsErroAuto .Or. !Empty(cErro) , "2", "3")     // 2=Erro;3=Processado
	SZ4->Z4_OBS    := If( nErros > 0 , "Erro no processo de integração", If( nErros == 0 .And. Empty(cErro) , "OK", cErro))
	SZ4->Z4_LOG    := If( Empty(aLOG) , "", cErro)
	MsUnLock()
	
	If !lLote .And. !IsBlind()
		If nErros == 0
			If Empty(cErro)
				FWAlertSuccess("Integração concluída com sucesso !")
			Else
				FWAlertError("<strong>Erro na integração:</strong><br /><br />" + cErro)
			Endif
		ElseIf nErros < Len(aLOG)
			FWAlertInfo("Integração parcialmente concluída ! <br /><br />Obs: <br />Consultar o campo de LOG da integração.")
		Else
			FWAlertError("<strong>Erro na integração:</strong><br /><br />" + cErro)
		Endif
	Endif

Return

User Function MGVendaUnica(cJSon,aItens,cErro,cID)
	Local aLOG  := {}
	Local oJSon := JSonObject():New()
	
	Default aItens := {}
	
	Private cLicenca := "1088"
	
	u_MGLicenca()   // Atualiza a licença
	
	cJSon := '{"sucesso":true,"content":{"data":[' + cJSon + ']}}'
	cErro := oJSon:FromJson(cJSon)
	
	GravaVenda(oJSon,aLOG,aItens,@cErro,cID)

Return Empty(cErro)

Static Function GravaVenda(oJSon,aLOG,aItens,cErro,cID)
	Local nX, nV, nI, nJ, aLinha, aCabVen, aIteVen, aFinVen, cVend, cCFOP, cItem, nQuant, nPreco, nTotal, aDadosCfo, cTES, nPos, aPvlNfs, aBloqueio, aPar, nItemNf, aNotas, cNota, cProduto
	Local cDocMG, cSerie, cCodCli, cLojCli, cTpoCli, cNFOrig, cSerOri, cItemOri, lOk, nRecSL1, cCampo, lPendente, nIte, nFld, cBanco, lFinanc, lPassa
	Local aArrSL1  := {}
	Local aArrSL2  := {}
	Local aArrSL4  := {}
	Local cCondPag := GetMV("MV_XCNDINT",.F.,"001")    // Condição de Pagamento padrão
	Local aVendas  := oJSon["content"]["data"]
	Local aFormas  := FwGetSX5("Z1")
	Local nTamDoc  := TamSX3("C6_NFORI"  )[1]
	Local nTamSer  := TamSX3("C6_SERIORI")[1]
	Local nTamIte  := TamSX3("C6_ITEMORI")[1]
	Local aBase    := {}
	Local aPend    := {}
	Local cIDInt   := ""
	Local lNota    := .F.
	Local cTipoNF  := "VA"
	Local cNumfis  := " "
	Local cImprime := "1N"
	Local cCGC     := " "
	Local cEspecie := " "
	Local lReproc  := aItens <> Nil .And. !Empty(aItens)     // Define se é um reprocessamento
	
	Default aItens := {}
	
	If !oJSon["sucesso"]
		AAdd( aLOG , JSonObject():New() )
		aLOG[1]["NfVenda"] := "Geral"
		aLOG[1]["SerieNF"] := "Geral"
		aLOG[1]["Emissao"] := CtoD("")
		aLOG[1]["Log"]     := cErro := "Erro na integracao"
		Return ""
	Endif
	
	Private aHeader := u_MGCriaHeader("SC6")
	Private aCols   := Nil
	
	For nI:=1 To Len(aHeader)
		AAdd( aBase , If( aHeader[nI,8] == "M", "", CriaVar(aHeader[nI,2],.T.) ))
	Next
	AAdd( aBase , .F. )
	
	For nV:=1 To Len(aVendas)
		
		cEspecie  := ""
		lPendente := .F.
		
		// Inicializa LOG da venda
		AAdd( aLOG , JsonObject():New() )
		
		aCabVen := aVendas[nV]["cabecalho"]
		aIteVen := aVendas[nV]["itens"]
		aFinVen := {}
		AAdd( aFinVen , aVendas[nV]["Financeiro"] )
		
		aLOG[nV]["NfVenda"] := cDocMG  := PADL(AllTrim(aCabVen["NfVenda"]),Len(SF2->F2_DOC),"0")
		aLOG[nV]["SerieNF"] := cSerie  := PADR(AllTrim(aCabVen["SerieNF"]),Len(SF2->F2_SERIE))
		aLOG[nV]["Emissao"] := CtoD(aCabVen["DataEmissao"])
		aLOG[nV]["Log"]     := ""
		
		// Processa a leitura das vendas importadas
		If Empty(aIteVen)
			aLOG[nV]["Log"] := "Venda não possui itens válidos"
			Loop
		Endif
		
		cNumfis := aCabVen["DocVenda"]
		cCFOP   := PADR(AllTrim(StrTran(aIteVen[1]["cfop"],".","")),TamSX3("C6_CF")[1])
		cBanco  := aCabVen["idCaixa"]
		
		// Posiciona no Cadastro da Operação por CFOP
		SZ5->(dbSetOrder(1))
		If !SZ5->(dbSeek(XFILIAL("SZ5")+cCFOP))
			aLOG[nV]["Log"] := "CFOP "+AllTrim(cCFOP)+" não cadastrado na integração"
			Loop
		ElseIf SZ5->Z5_TPNOTA $ "DB" .And. SZ5->Z5_ROTINA == "1"
			aLOG[nV]["Log"] := "Regra de CFOP "+AllTrim(cCFOP)+" não importar devolução/beneficiamento pelo Loja"
			Loop
		Endif
		
		cVend := PADL(aCabVen["LqVend"],Len(SA3->A3_COD),"0")
		
		If SZ5->Z5_TPNOTA $ "DB"    // Caso seja notas de devolução ou beneficiamento
			// Posiciona no Cadastro do Fornecedor
			SA2->(dbOrderNickName("IDCONTROL"))
			If !SA2->(dbSeek(XFILIAL("SA2")+aCabVen["ClienteVenda"]))
				aLOG[nV]["Log"] := "Fornecedor " +AllTrim(aCabVen["ClienteVenda"])+ " não existe"
				Loop
			Endif
			
			cCodCli := SA2->A2_COD
			cLojCli := SA2->A2_LOJA
			cTpoCli := "F"
		Else
			// Posiciona no Cadastro do Cliente
			SA1->(dbOrderNickName("IDCONTROL"))
			If !SA1->(dbSeek(XFILIAL("SA1")+aCabVen["ClienteVenda"]))
				aLOG[nV]["Log"] := "Cliente " +AllTrim(aCabVen["ClienteVenda"])+ " não existe"
				Loop
			Endif
			
			// Posiciona no Cadastro do Vendedor
			SA3->(dbSetOrder(1))
			If !SA3->(dbSeek(XFILIAL("SA3")+cVend))
				aLOG[nV]["Log"] := "Vendedor "+AllTrim(aCabVen["LqVend"])+" não existe"
				Loop
			Endif
			
			cCodCli := SA1->A1_COD
			cLojCli := SA1->A1_LOJA
			cTpoCli := SA1->A1_TIPO
		Endif
		
		// Identifica se a venda já foi gravada
		SF2->(dbSetOrder(1))   // F2_FILIAL+F2_DOC+F2_SERIE
		If !(lPassa := SF2->(dbSeek(XFILIAL("SF2")+cDocMG+cSerie)))
			// Identifica se a venda já processada como cancelada
			SF3->(dbSetOrder(5))
			SF3->(dbSeek(XFILIAL("SF3")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.))
			While !SF3->(Eof()) .And. XFILIAL("SF3")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA == SF3->F3_FILIAL+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
				If Left(SF3->F3_CFO,1) >= "5" .And. !Empty(SF3->F3_XID) .And. !Empty(SF3->F3_DTCANC)
					lPassa := .T.
					Exit
				Endif
				SF3->(dbSkip())
			Enddo
		Endif
		
		If lPassa
			Loop   // Passa para a próxima venda
		Endif
		
		// Cria a série da nota na tabela SX5, caso não exista
		CriaSerie(cFilAnt,cSerie)
		
		lMsHelpAuto := .T.
		lMsErroAuto := .F.
		
		dDataBase := CtoD(aCabVen["DataEmissao"])

		aArrSL1 := {}
		aArrSL2 := {}
		
		// Caso seja uma venda do Loja
		If SZ5->Z5_ROTINA == "1"
			lNota   := ALLTRIM(cSerie)+"=SPED" $ GETMV("MV_ESPECIE") 	
			nRecSL1 := 0
			aAux    := {}
			cItem   := StrZero(0,TamSX3("L2_ITEM")[1])
			
			// Identifica ser a venda já foi gravada
			SL1->(dbOrderNickName("CONTROL"))   // L1_FILIAL+L1_XDOCCTR+L1_XSERCTR
			If SL1->(dbSeek(XFILIAL("SL1")+cDocMG+cSerie))
				If SL1->L1_SITUA == "OK"    // Caso a venda já tenha sido processada
					Loop   // Passa para a próxima venda
				Else
					nRecSL1 := SL1->(Recno())
				Endif
			Endif
			
			For nX:=1 To Len(aIteVen)
				cProduto := PADR(StrZero(Val(aIteVen[nX]["ProdVenda"]),10),Len(SB1->B1_COD))
				
				// Posiciona no Cadastro do Produto
				SB1->(dbSetOrder(1))
				If !SB1->(dbSeek(XFILIAL("SB1")+cProduto))
					aLOG[nV]["Log"] += If( Empty(aLOG[nV]["Log"]) , "", ", ") + "Produto " +Trim(cProduto)+ " não existe"
					Loop
				Endif
				
				aLinha := {}
				AAdd( aLinha , {"LR_ITEM"   , cItem:=Soma1(cItem)       , NIL} )
				AAdd( aLinha , {"LR_PRODUTO", SB1->B1_COD               , NIL} )
				AAdd( aLinha , {"LR_DESCRI" , SB1->B1_DESC              , NIL} )
				AAdd( aLinha , {"LR_LOCAL"  , SB1->B1_LOCPAD            , NIL} )
				AAdd( aLinha , {"LR_UM"     , SB1->B1_UM                , NIL} )
				AAdd( aLinha , {"LR_TABELA" , "001" /*aIteVen[nX]["TabelaVenda"]*/, NIL} )
				AAdd( aLinha , {"LR_DESCPRO", aIteVen[nX]["DescProd"]   , NIL} )
				AAdd( aLinha , {"LR_VEND"   , SA3->A3_COD               , NIL} )
				AAdd( aLinha , {"LR_QUANT"  , aIteVen[nX]["QuantVenda"] , NIL} )
				AAdd( aLinha , {"LR_VRUNIT" , aIteVen[nX]["ValorUnit"]  , NIL} )
				AAdd( aLinha , {"LR_VLRITEM", aIteVen[nX]["ValorTotal"] , NIL} )
				AAdd( aLinha , {"LR_DESC"   , aIteVen[nX]["PercDesc"]   , NIL} )
				AAdd( aLinha , {"LR_VALDESC", aIteVen[nX]["ValDesc"]    , NIL} )
				AAdd( aLinha , {"LR_PRCTAB" , aIteVen[nX]["ValorUnit"]  , NIL} )
				AAdd( aLinha , {"LR_FDTENTR", dDataBase                 , NIL} )
				
				cTES := MaTesInt(2,SZ5->Z5_OPER,cCodCli,cLojCli,If(SZ5->Z5_TPNOTA$"DB","F","C"),SB1->B1_COD,"LR_TES")
				
				SF4->(dbSetOrder(1))
				SF4->(MsSeek(xFilial("SF4")+cTES))
				
				aDadosCfo := {}
				AAdd( aDadosCfo , { "OPERNF"  , "S"           })
				AAdd( aDadosCfo , { "TPCLIFOR", cTpoCli       })
				AAdd( aDadosCfo , { "UFDEST"  , SA1->A1_EST   })
				AAdd( aDadosCfo , { "INSCR"   , SA1->A1_INSCR })
				
				cCFOP := MaFisCfo(,SF4->F4_CF,aDadosCfo)
				
				AAdd( aLinha , {"LR_TES"    , cTES       , NIL} )
				AAdd( aLinha , {"LR_CF"     , cCFOP      , NIL} )
				
				If lNota
					AAdd( aLinha , {"LR_VENDIDO", "S" 	                , NIL} )
					AAdd( aLinha , {"LR_DOC"     , cDocMG		        , NIL} )
					AAdd( aLinha , {"LR_SERIE"   , cSerie		        , NIL} )
					cTipoNF  := "VD"
				Endif
				
				// Atribui o conteúdo informado nos campos
				nIte := Len(aArrSL2) + 1
				If nIte <= Len(aItens)
					For nI:=1 To Len(aItens[nIte])
						nFld := AScan( aLinha , {|x| Trim(x[1]) == Trim(aItens[nIte][nI,1]) } )
						If nFld > 0
							aLinha[nFld,2] := aItens[nIte][nI,2]    // Atribui o valor informado
						Endif
					Next
				Endif
				
				If !lPendente .And. !lReproc
					lPendente := ( Trim(aIteVen[nX]["cfop"]) <> Trim(cCFOP) )
				Endif
				
				// Adiciona os campos da pendência
				AAdd( aAux , {})
				AAdd( aAux[Len(aAux)] , { "LR_CFORI" , aIteVen[nX]["cfop"], Nil} )
				
				AAdd( aArrSL2 , aClone(aLinha) )
			Next
			
			If !Empty(aArrSL2)
				aArrSL4 := {}
				
				AAdd( aArrSL1 , { "LQ_VEND"   , SA3->A3_COD   , NIL} )
				AAdd( aArrSL1 , { "LQ_CONDPG" , cCondPag      , NIL} )
				AAdd( aArrSL1 , { "LQ_FORMA"  , FormaPag(aFormas,aFinVen[1]["FormaPag"])   , NIL} )
				AAdd( aArrSL1 , { "LQ_COMIS"  , aCabVen["VendaComissao"] , NIL} )
				AAdd( aArrSL1 , { "LQ_CLIENTE", cCodCli       , NIL} )
				AAdd( aArrSL1 , { "LQ_LOJA"   , cLojCli       , NIL} )
				AAdd( aArrSL1 , { "LQ_NOMCLI" , SA1->A1_NOME  , NIL} )
				AAdd( aArrSL1 , { "LQ_TIPOCLI", cTpoCli       , NIL} )
				AAdd( aArrSL1 , { "LQ_VLRTOT" , aCabVen["TotalVenda"]       , NIL} )
				AAdd( aArrSL1 , { "LQ_DESCONT", aCabVen["ValorDesconto"]    , NIL} )
				AAdd( aArrSL1 , { "LQ_VLRLIQ" , aCabVen["ValorLiquido"]     , NIL} )
				AAdd( aArrSL1 , { "LQ_NROPCLI", aCabVen["PedidoVenda"]      , NIL} )
				AAdd( aArrSL1 , { "LQ_DTLIM"  , CtoD(aCabVen["DataVenda"])  , NIL} )
				AAdd( aArrSL1 , { "LQ_DINHEIR", aCabVen["ValorVenda"]       , NIL} )
				AAdd( aArrSL1 , { "LQ_VLRDEBI", aCabVen["DebitoVenda"]      , NIL} )
				AAdd( aArrSL1 , { "LQ_EMISSAO", CtoD(aCabVen["DataEmissao"]), NIL} )
				AAdd( aArrSL1 , { "LQ_XDOCCTR" , cDocMG       , Nil} )
				AAdd( aArrSL1 , { "LQ_XSERCTR" , cSerie       , Nil} )
				
				For nX:=1 To Len(aFinVen)
					aLinha := {}
					aAdd( aLinha, {"L4_DATA"    , CtoD(aFinVen[nX]["Vencimento"]) , NIL} )
					aAdd( aLinha, {"L4_VALOR"   , aFinVen[nX]["ValorFim"]   , NIL} )
					aAdd( aLinha, {"L4_FORMA"   , FormaPag(aFormas,aFinVen[nX]["FormaPag"])   , NIL} )
					aAdd( aLinha, {"L4_ADMINIS" , aFinVen[nX]["AdmCartao"]  , NIL} )
					aAdd( aLinha, {"L4_MOEDA"   , Val(aFinVen[nX]["MoedaVenda"]), NIL} )
					aAdd( aLinha, {"L4_XIDINT"  , aFinVen[nX]["IdTitulo"]   , NIL} )
					aAdd( aLinha, {"L4_FORMAID" , " " , NIL} )
					
					aAdd( aArrSL4, aClone(aLinha) )
				Next
				
				If lPendente
					// Adiciona em todos os itens as colunas pendentes
					For nI:=1 To Len(aAux)
						For nJ:=1 To Len(aAux[nI])
							AAdd( aArrSL2[nI] , aAux[nI][nJ] )
						Next
					Next
					
					AAdd( aArrSL1 , { "LQ_HORA"   , aCabVen["HoraVenda"] } )
					// AAdd( aArrSL1 , { "LQ_FORMA"   , FormaPag(aFormas,aFinVen[1]["FormaPag"])   , NIL} )
					AAdd( aArrSL1 , { "LQ_KEYNFCE", aCabVen["ChaveNF"]   } )
					AAdd( aArrSL1 , { "LQ_OPERADO", BancoIntegra(aCabVen["idCaixa"]) } )
					AAdd( aArrSL1 , { "LQ_ESPECIE", If( lNota , "NFM", cEspecie)         } )
					AAdd( aArrSL1 , { "LQ_NUMCFIS", If( lNota , "", aCabVen["DocVenda"]) } )
					
					AAdd( aPend , { "1", aClone(aArrSL1) , aClone(aArrSL2), aClone(aArrSL4), FWJSonSerialize(aVendas[nV],.F.,.T.,.T.)})
					Loop
				Endif
				
				SetFunName("LOJA701")
				
				nModulo    := 5       // Define como módulo do Faturamento
				lFiscal    := .F.
				INCLUI     := .T.
				ALTERA     := .F.
				lAutomatoX := .F.
				
				//BeginTran()
				
				If nRecSL1 == 0
					SA1->(dbSetOrder(1))
					
					// Posicina no registro inicial da filial
					dbSelectArea("SL1")
					dbSetOrder(1)
					dbSeek(XFILIAL("SL1"),.T.)
					
					MSExecAuto({|a,b,c,d,e,f,g,h,i,j,k| LOJA701(a,b,c,d,e,f,g,h,i,j,k)},.F.,3,"","",{},aArrSL1,aArrSL2,aArrSL4,.T.,Nil,"VD")
				Endif
				
				If lMsErroAuto
					If nRecSL1 == 0
						RollBackSX8()
					Endif
				Else
					SL1->(dbOrderNickName("CONTROL"))   // L1_FILIAL+L1_XDOCCTR+L1_XSERCTR
					If SL1->(dbSeek(XFILIAL("SL1")+cDocMG+cSerie))
						If lNota
							cNumfis  := ""  //aCabVen["DocVenda"]
							cImprime := "2S"
							cCGC     := SA1->A1_CGC
							cEspecie := "NFM"
	
						Endif
						
						RecLock("SL1",.F.)
						
						If nRecSL1 > 0
							For nX:=1 To Len(aArrSL1)
								cCampo := StrTran(aArrSL1[nX,1],"LQ_","L1_")
								If (nPos := FieldPos(cCampo)) > 0
									FieldPut( nPos , aArrSL1[nX,2] )
								Endif
							Next
						Endif
						
						SL1->L1_DOC     := cDocMG
						SL1->L1_SERIE   := cSerie
						SL1->L1_NUMCFIS := cNumfis 
						SL1->L1_EMISNF  := CtoD(aCabVen["DataEmissao"])
						SL1->L1_HORA    := aCabVen["HoraVenda"]
						SL1->L1_KEYNFCE := aCabVen["ChaveNF"]
						SL1->L1_TIPO    := "V"
						SL1->L1_OPERADO := BancoIntegra(aCabVen["idCaixa"])
						SL1->L1_SITUA   := "RX"
						SL1->L1_CGCCLI  := cCGC
						SL1->L1_ESPECIE := cEspecie
						SL1->L1_IMPRIME := cImprime
						SL1->L1_TPORC   := "E"
						SL1->L1_XID     := cID
						
						MsUnLock()
						
						nI := 0
						SL2->(dbSetOrder(1))
						SL2->(dbSeek(SL1->L1_FILIAL+SL1->L1_NUM,.T.))
						While !SL2->(Eof()) .And. SL2->L2_FILIAL+SL2->L2_NUM == SL1->L1_FILIAL+SL1->L1_NUM
							
							nI++
							If nI <= Len(aArrSL2)
								RecLock("SL2",.F.)
								
								If nRecSL1 > 0
									For nX:=1 To Len(aArrSL2[nI])
										If (nPos := FieldPos(aArrSL2[nI][nX,1])) > 0
											FieldPut( nPos , aArrSL2[nI][nX,2] )
										Endif
									Next
								Else
									If (nPos := AScan(aArrSL2[nI] , {|x| x[1] == "LR_CF" })) > 0
										SL2->L2_CF := aArrSL2[nI][nPos,2]
									Endif
								Endif
								
								MsUnLock()
							Endif
							
							SL2->(dbSkip())
						Enddo
						
						nI := 0
						SL4->(dbSetOrder(1))
						SL4->(dbSeek(SL1->L1_FILIAL+SL1->L1_NUM,.T.))
						While !SL4->(Eof()) .And. SL4->L4_FILIAL+SL4->L4_NUM == SL1->L1_FILIAL+SL1->L1_NUM
							
							nI++
							cIDInt := If( nI <= Len(aFinVen) , aFinVen[nI]["IdTitulo"], cIDInt)
							
							RecLock("SL4",.F.)
							
							If nRecSL1 > 0 .And. nI <= Len(aArrSL4)
								For nX:=1 To Len(aArrSL4[nI])
									If (nPos := FieldPos(aArrSL4[nI][nX,1])) > 0
										FieldPut( nPos , aArrSL4[nI][nX,2] )
									Endif
								Next
							Endif
							
							SL4->L4_XIDINT := cIDInt
							MsUnLock()
							
							SL4->(dbSkip())
						Enddo
					Endif
					
					//EndTran()
				Endif
			Endif
		Else
			lOk     := .T.
			lFinanc := .F.
			
			//BeginTran()
			
			// Identifica ser a venda já foi gravada
			SC5->(dbOrderNickName("CONTROL"))   // C5_FILIAL+C5_XDOCCTR+C5_XSERCTR
			If SC5->(dbSeek(XFILIAL("SC5")+cDocMG+cSerie))
				// Processa o estorno dos pedidos itens liberados
				SC6->(dbSetOrder(1))
				SC6->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.T.))
				While !SC6->(Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
					//Posiciona na liberação do item do pedido e enquanto houver dados estorna a liberação
					SC9->(dbSetOrder(1))
					SC9->(dbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM,.T.))
					While !SC9->(Eof()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM
						If Empty(SC9->C9_NFISCAL)
							SC9->(a460Estorna(.T.))
						Endif
						SC9->(dbSkip())
					Enddo
					SC6->(dbSkip())
				Enddo
			Else
				aAux  := {}
				aCols := {}
				cItem := StrZero(0,TamSX3("C6_ITEM")[1])
				
				For nX:=1 To Len(aIteVen)
					cProduto := PADR(StrZero(Val(aIteVen[nX]["ProdVenda"]),10),Len(SB1->B1_COD))
					cNFOrig  := If( Empty(aIteVen[nX]["Nforig"   ]) , "", PADL(AllTrim(aIteVen[nX]["Nforig"   ]),nTamDoc,"0"))
					cSerOri  := If( Empty(aIteVen[nX]["Serieorig"]) , "", PADR(AllTrim(aIteVen[nX]["Serieorig"]),nTamSer,"0"))
					cItemOri := aIteVen[nX]["Itemorig"]
					cItemOri := StrZero(If( Empty(cItemOri) , 1, Val(cItemOri)),nTamIte)
					
					// Posiciona no Cadastro do Produto
					SB1->(dbSetOrder(1))
					If !SB1->(dbSeek(XFILIAL("SB1")+cProduto))
						aLOG[nV]["Log"] += If( Empty(aLOG[nV]["Log"]) , "", ", ") + "Produto " +Trim(cProduto)+ " não existe"
						lOk := .F.
						Loop
					Endif
					
					// Atribui o conteúdo informado nos campos
					If nX <= Len(aItens)
						// Pesquisa os campos Nota, série e item da NF de origem
						For nI:=1 To Len(aItens[nX])
							If Trim(aItens[nX][nI,1]) == "C6_NFORI"
								cNFOrig := aItens[nX][nI,2]
							ElseIf Trim(aItens[nX][nI,1]) == "C6_SERIORI"
								cSerOri := aItens[nX][nI,2]
							ElseIf Trim(aItens[nX][nI,1]) == "C6_ITEMORI"
								cItemOri := aItens[nX][nI,2]
							Endif
						Next
					Endif
					
					If Empty(cNFOrig)
						lPendente := lPendente .Or. SZ5->Z5_TPNOTA $ "DB"   // Define como pendente caso seja devolução e não tenha documento de origem
					Else
						dbSelectArea("SD1")
						dbSetOrder(1)   // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
						If !SD1->(dbSeek(XFILIAL("SD1")+cNFOrig+cSerOri+cCodCli+cLojCli+cProduto+cItemOri))
							//aLOG[nV]["Log"] += If( Empty(aLOG[nV]["Log"]) , "", ", ") + "Documento de origem não existe: " +Trim(cNFOrig+" / "+cSerOri+" - Item "+cItemOri)
							//lOk := .F.
							lPendente := .T.
							Loop
						Endif
					Endif
					
					dbSelectArea("SB2")
					SB2->(dbSetOrder(1))
					If !SB2->(dbSeek(xFilial('SB2')+SB1->B1_COD+SB1->B1_LOCPAD))
						CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
					EndIf
					
					nQuant := aIteVen[nX]["QuantVenda"]
					nPreco := aIteVen[nX]["ValorUnit"]
					nTotal := A410Arred(nQuant * nPreco,"C6_VALOR")
					
					aLinha := {}
					AAdd( aLinha , { "C6_ITEM"    , cItem:=Soma1(cItem) , Nil} )
					AAdd( aLinha , { "C6_PRODUTO" , SB1->B1_COD         , Nil} )
					AAdd( aLinha , { "C6_DESCRI"  , SB1->B1_DESC        , Nil} )
					AAdd( aLinha , { "C6_QTDVEN"  , nQuant              , Nil} )
					AAdd( aLinha , { "C6_PRCTAB"  , nPreco              , Nil} )
					AAdd( aLinha , { "C6_PRCVEN"  , nPreco              , Nil} )
					AAdd( aLinha , { "C6_VALOR"   , nTotal              , Nil} )
					AAdd( aLinha , { "C6_ENTREG"  , dDataBase           , Nil} )
					AAdd( aLinha , { "C6_UM"      , SB1->B1_UM          , Nil} )
					
					If !Empty(SB1->B1_SEGUM)
						AAdd( aLinha , { "C6_SEGUM"   , SB1->B1_SEGUM   , Nil} )
					Endif
					
					AAdd( aLinha , { "C6_QTDLIB"  , nQuant              , Nil} )
					AAdd( aLinha , { "C6_LOCAL"   , SB1->B1_LOCPAD      , Nil} )
					AAdd( aLinha , { "C6_CLI"     , cCodCli             , Nil} )
					AAdd( aLinha , { "C6_LOJA"    , cLojCli             , Nil} )
					AAdd( aLinha , { "C6_OPER"    , SZ5->Z5_OPER        , Nil} )
					
					aDadosCfo := {}
					AAdd( aDadosCfo , { "OPERNF"  , "S"           })
					
					If SZ5->Z5_TPNOTA $ "DB"
						AAdd( aDadosCfo , { "TPCLIFOR", cTpoCli       })
						AAdd( aDadosCfo , { "UFDEST"  , SA2->A2_EST   })
						AAdd( aDadosCfo , { "INSCR"   , SA2->A2_INSCR })
					Else
						AAdd( aDadosCfo , { "TPCLIFOR", cTpoCli       })
						AAdd( aDadosCfo , { "UFDEST"  , SA1->A1_EST   })
						AAdd( aDadosCfo , { "INSCR"   , SA1->A1_INSCR })
					Endif
					
					If !Empty(cNFOrig)
						AAdd( aLinha , { "C6_NFORI"   , cNFOrig       , Nil} )
						AAdd( aLinha , { "C6_SERIORI" , cSerOri       , Nil} )
						AAdd( aLinha , { "C6_ITEMORI" , cItemOri      , Nil} )
					Endif
					
					// Monta estrutura para cálculo do TES Inteligente
					AAdd( aCols , aClone(aBase) )
					
					For nI:=1 To Len(aLinha)
						If (nPos := AScan( aHeader , {|x| Trim(x[2]) == aLinha[nI,1] })) > 0
							aCols[nX,nPos] := aLinha[nI,2]
						Endif
					Next
					
					n    := nX
					cTES := MaTesInt(2,SZ5->Z5_OPER,cCodCli,cLojCli,If(SZ5->Z5_TPNOTA$"DB","F","C"),SB1->B1_COD,"C6_TES")
					
					SF4->(dbSetOrder(1))
					SF4->(MsSeek(xFilial("SF4")+cTES))
					
					lFinanc := lFinanc .Or. SF4->F4_DUPLIC == "S"    // Define se gera financeiro
					
					cCFOP := MaFisCfo(,SF4->F4_CF,aDadosCfo)
					
					AAdd( aLinha , { "C6_TES"     , cTES                , Nil} )
					AAdd( aLinha , { "C6_CF"      , cCFOP               , Nil} )
					
					// Atribui o conteúdo informado nos campos
					nIte := Len(aArrSL2) + 1
					If nIte <= Len(aItens)
						For nI:=1 To Len(aItens[nIte])
							nFld := AScan( aLinha , {|x| Trim(x[1]) == Trim(aItens[nIte][nI,1]) } )
							If nFld > 0
								aLinha[nFld,2] := aItens[nIte][nI,2]    // Atribui o valor informado
							Endif
						Next
					Endif
					
					If !lPendente .And. !lReproc
						lPendente := ( Trim(aIteVen[nX]["cfop"]) <> Trim(cCFOP) )
					Endif

					// Adiciona os campos da pendência
					AAdd( aAux , {})
					AAdd( aAux[Len(aAux)] , { "C6_CFORI" , aIteVen[nX]["cfop"], Nil} )
					
					AAdd( aArrSL2 , aClone(aLinha) )
				Next
				
				If lOk
					If !Empty(aArrSL2)
						If lPendente
							// Adiciona em todos os itens as colunas pendentes
							For nI:=1 To Len(aAux)
								For nJ:=1 To Len(aAux[nI])
									AAdd( aArrSL2[nI] , aAux[nI][nJ] )
								Next
							Next
						Endif
						
						AAdd( aArrSL1 , { "C5_TIPO"    , SZ5->Z5_TPNOTA  , Nil} )
						AAdd( aArrSL1 , { "C5_CLIENTE" , cCodCli         , Nil} )
						AAdd( aArrSL1 , { "C5_LOJACLI" , cLojCli         , Nil} )
						AAdd( aArrSL1 , { "C5_CLIENT"  , cCodCli         , Nil} )
						AAdd( aArrSL1 , { "C5_LOJAENT" , cLojCli         , Nil} )
						AAdd( aArrSL1 , { "C5_EMISSAO" , dDataBase       , Nil} )
						AAdd( aArrSL1 , { "C5_CONDPAG" , cCondPag        , Nil} )
						AAdd( aArrSL1 , { "C5_VEND1"   , SA3->A3_COD     , Nil} )
						//AAdd( aArrSL1 , { "C5_TABELA"  , u_BJCodTab("")  , Nil} )
						AAdd( aArrSL1 , { "C5_MOEDA"   , 1               , Nil} )
						AAdd( aArrSL1 , { "C5_TIPOCLI" , cTpoCli         , Nil} )
						AAdd( aArrSL1 , { "C5_TIPLIB"  , "2"             , Nil} )
						AAdd( aArrSL1 , { "C5_LIBEROK" , "S"             , Nil} )
						AAdd( aArrSL1 , { "C5_ESPECI1" , cEspecie        , Nil} )
						AAdd( aArrSL1 , { "C5_XDOCCTR" , cDocMG          , Nil} )
						AAdd( aArrSL1 , { "C5_XSERCTR" , cSerie          , Nil} )
						AAdd( aArrSL1 , { "C5_XID"     , cID             , Nil} )
					Endif
					
					nModulo    := 5       // Define como módulo do Faturamento
					
					// Posicina no registro inicial da filial
					dbSelectArea("SC5")
					dbSetOrder(1)
					dbSeek(XFILIAL("SC5"),.T.)
					
					If lPendente
						AAdd( aArrSL1 , { "C5_KEYNFCE", aCabVen["ChaveNF"]   } )
						AAdd( aArrSL1 , { "C5_BANCO"  , aCabVen["idCaixa"]   } )
						
						AAdd( aPend , { "2", aClone(aArrSL1) , aClone(aArrSL2), {}, FWJSonSerialize(aVendas[nV],.F.,.T.,.T.)})
						Loop
					Endif
					
					MSExecAuto({|x,y,Z| Mata410(x,y,Z)}, aArrSL1, aArrSL2, 3)
				Endif
			Endif
				
			If lMsErroAuto .Or. !lOk
				RollBackSX8()
			Else
				cNumPed   := SC5->C5_NUM
				aPvlNfs   := {}
				aBloqueio := {}
				aNotas    := {}
				
				// Liberacao de pedido
				LiberaPedido(aPvlNfs)  //Ma410LbNfs(2,aPvlNfs,aBloqueio)
				// Checa itens liberados
				Ma410LbNfs(1,aPvlNfs,aBloqueio)
				
				//aPar, nItemNf, aNotas, cNota
				If !Empty(aPvlNfs) .And. Empty(aBloqueio)
					aPar    := Array(30)
					nItemNf := a460NumIt(cSerie)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Carrega os parâmentros da rotina de geração da nota fiscal   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Pergunte("MT460A",.F.)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Carrega parametros do programa                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX:=1 To Len(aPar)
						aPar[nX] := &("mv_par"+StrZero(nX,2))
					Next
					
					AAdd(aNotas,{})
					
					// Efetua as quebras de acordo com o número de itens
					For nX:=1 To Len(aPvlNfs)
						If Len(aNotas[Len(aNotas)])>=nItemNf
							aadd(aNotas,{})
						EndIf
						aadd(aNotas[Len(aNotas)],aClone(aPvlNfs[nX]))
					Next nX
					
					INCLUI := .T.
					cNumNF := cDocMG
					
					// Gera as notas de acordo com a quebra
					For nX := 1 To Len(aNotas)
						cNota := MaPvlNfs(aNotas[nX],cSerie,aPar[01]==1,aPar[02]==1,aPar[03]==1,aPar[04]==1,aPar[05]==1,aPar[07],aPar[08],aPar[15]==1,aPar[16]==2)

						// Processa a gravação do livro fiscal
						SF2->(dbSetOrder(1))
						If SF2->(dbSeek(XFILIAL("SF2")+cDocMG+cSerie))
							GravaLivroFiscal(aCabVen["ChaveNF"])
							GravaCtaRec(aFinVen,cBanco,lFinanc)
							
							nI := 0
							// Pesquisa as parcelas do Contas a Receber
							SE1->(dbSetOrder(1))
							SE1->(dbSeek(XFILIAL("SE1")+SF2->F2_SERIE+SF2->F2_DOC,.T.))
							While !SE1->(Eof()) .And. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == XFILIAL("SE1")+SF2->F2_SERIE+SF2->F2_DOC
								nI++
								cIDInt := If( nI <= Len(aFinVen) , aFinVen[nI]["IdTitulo"], cIDInt)
								RecLock("SE1",.F.)
								SE1->E1_XIDINT := cIDInt
								MsUnLock()
								SE1->(dbSkip())
							Enddo
						Endif
					Next nX
				Else
					aLOG[nV]["Log"] := "Pedido de venda bloqueado: " + cNumPed
				Endif
			Endif
			
			If lMsErroAuto
			Else
				//EndTran()
			Endif
		Endif
		
		If lMsErroAuto
			If lReproc
				cErro := MostraErro()
			Else
				cErro := MostraErro("\","Error.log")
			Endif
			aLOG[nV]["Log"] := cErro
			
			//DisarmTransaction()
		Else
			cErro := aLOG[nV]["Log"]
		Endif
	Next
	
	GravaPendentes(aPend)

Return ""

Static Function GravaLivroFiscal(cF2_CHVNFE,cF2_CODNFE,cF3_CODRSEF,cF3_DESCRET)
	Local cSeek := SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA
	
	Default cF2_CODNFE  := ""
	Default cF3_CODRSEF := "100"
	Default cF3_DESCRET := "Autorizado o uso da NF-e"
	
	RecLock("SF2",.F.)
	SF2->F2_FIMP   := "S"
	SF2->F2_CHVNFE := cF2_CHVNFE
	SF2->F2_CODNFE := cF2_CODNFE
	MsUnLock()
	
	SF3->(dbSetOrder(5))
	SF3->(dbSeek(XFILIAL("SF3")+cSeek,.T.))
	While !SF3->(Eof()) .And. XFILIAL("SF3")+cSeek == SF3->F3_FILIAL+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
		If Left(SF3->F3_CFO,1) >= "5"
			RecLock("SF3",.F.)
			SF3->F3_CODRET  := "T"           // Transmitido
			SF3->F3_CODRSEF := cF3_CODRSEF
			SF3->F3_DESCRET := cF3_DESCRET
			SF3->F3_CHVNFE  := cF2_CHVNFE
			SF3->F3_CODNFE  := cF2_CODNFE
			MsUnLock()
		Endif
		SF3->(dbSkip())
	Enddo
	
	// Processa a gravação dos itens do livro fiscal
	SFT->(dbSetOrder(1))
	SFT->(dbSeek(XFILIAL("SFT")+"S"+cSeek,.T.))
	While !SFT->(Eof()) .And. XFILIAL("SFT")+"S"+cSeek == SFT->FT_FILIAL+SFT->FT_TIPOMOV+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA
		RecLock("SFT",.F.)
		SFT->FT_CHVNFE := cF2_CHVNFE
		SFT->FT_CODNFE := cF2_CODNFE
		MsUnLock()
		SFT->(dbSkip())
	Enddo
	
Return

Static Function GravaCancel(oJSon,cID)
	Local nV, cSerie, cNF, dCanc, cSeek
	Local dAux    := dDataBase
	Local aVendas := oJSon["content"]["data"]
	Local cErro   := ""
	Local lRet    := .F.
	
	If !oJSon["sucesso"]
		Return "Erro na integracao"
	Endif
	
	SL1->(dbSetOrder(2))     // L1_FILIAL+L1_SERIE+L1_DOC+L1_PDV
	
	For nV:=1 To Len(aVendas)
		dCanc  := CtoD(aVendas[nV]["DataEmissao"])
		cSerie := PADR(aVendas[nV]["SerieNF"],Len(SL1->L1_SERIE))
		cNF    := PADL(AllTrim(aVendas[nV]["NfVenda"]),Len(SL1->L1_DOC),"0")
		
		If !Empty(dCanc)
			If SL1->(dbSeek(XFILIAL("SL1")+cSerie+cNF))
				dbSelectArea("SF2")
				
				SetFunName("LOJA701")
				
				cSeek      := SL1->L1_SERIE+SL1->L1_DOC+SL1->L1_CLIENTE+SL1->L1_LOJA
				dDataBase  := dCanc
				nModulo    := 5       // Define como módulo do Faturamento
				lFiscal    := .F.
				INCLUI     := .F.
				ALTERA     := .F.
				lAutomatoX := .F.
				cCadastro  := "Exclusao N.F./Orcam."
				aRotina    := {	{ "Pesquisar","AxPesqui", 0 , 1 , , .F.},;
								{ "Excluir","Lj140Exc"  , 0 , 5 , , .T.},;
								{ "Interromper Canc.","Lj140CCanc()", 0 , 5 , , .T.} }
				
				BeginTran()
				
				// Prepara o orçamento para exclusão
				RecLock("SL1",.F.)
				SL1->L1_TPORC := "E"     // Origem da venda assistida
				SL1->L1_SITUA := "X2"    // Autorizado pela SEFAZ (para evitar comunicar com o TSS)
				MsUnLock()
				
				lRet := LJ140Exc( "SL1", SL1->(Recno()), 2,, .T., SL1->L1_FILIAL, SL1->L1_NUM )
				lRet := lRet .And. Empty(SL1->L1_DOC) .And. Empty(SL1->L1_DOCPED)
				
				If lRet .Or. !lMsErroAuto
					SF3->(dbSetOrder(5))
					SF3->(dbSeek(XFILIAL("SF3")+cSeek,.T.))
					While !SF3->(Eof()) .And. XFILIAL("SF3")+cSeek == SF3->F3_FILIAL+SF3->F3_SERIE+SF3->F3_NFISCAL+SF3->F3_CLIEFOR+SF3->F3_LOJA
						If Left(SF3->F3_CFO,1) >= "5"
							RecLock("SF3",.F.)
							SF3->F3_XID := cID
							MsUnLock()
						Endif
						SF3->(dbSkip())
					Enddo
					
					EndTran()
				Else
					DisarmTransaction()
					cErro := "Venda nao foi cancelada"
					Exit
				Endif
			ElseIf Empty(cErro)
				cErro := "Orcamento nao encontrado"
			Endif
		Else
			cErro := "Nao foi possivel converter a data do cancelamento: " + aCabVen["DataEmissao"] + " !"
		Endif
	Next
	
	dDataBase := dAux    // Restaura a data-base do sistema
	
Return cErro

Static Function FormaPag(aFormas,cForma)
	Local cRet := ""
	Local nPos := AScan( aFormas , {|x| Trim(x[3]) == Trim(cForma) } )
	
	If nPos > 0
		cRet := Trim(aFormas[nPos,4])
	Endif
	If Empty(cRet)
		cRet := "R$"
	Endif

Return cRet

Static Function GravaBaixa(oJSon,aLOG,cID)
	Local cIDTitulo, nX, aBaixa, cSeek
	Local cMain := "data"
	
	For nX:=1 To Len(oJSon[cMain])
		
		// Inicializa LOG da venda
		AAdd( aLOG , JsonObject():New() )
		
		cIDTitulo := PADR(AllTrim(oJSon[cMain][nX]["idtitulo"]),TamSX3("E1_XIDINT" )[1])
		cBcoInt   := PADR(AllTrim(oJSon[cMain][nX]["idbanco" ]),TamSX3("A6_XBCOINT")[1])
		
		If cLicenca == "3657" .And. cBcoInt == "CX1"
			cBcoInt := "CXE"
		Endif
		
		aLOG[nX]["idTitulo"] := Trim(cIDTitulo)
		aLOG[nX]["dtbaixa" ] := CtoD(oJSon[cMain][nX]["dtbaixa"])
		aLOG[nX]["valor"   ] := oJSon[cMain][nX]["valor"]
		aLOG[nX]["Log"]      := ""
		
		SE1->(dbOrderNickName("IDCONTROL"))    // E1_FILIAL+E1_FILORIG+E1_XIDINT
		If SE1->(dbSeek(XFILIAL("SE1")+cFilAnt+cIDTitulo))
			If SE1->E1_SALDO > 0
				SA6->(dbOrderNickName("IDCONTROL"))    // A6_FILIAL+A61_XBCOINT
				If SA6->(dbSeek(XFILIAL("SE1")+cBcoInt))
					aBaixa := {}
					AAdd( aBaixa , {"E1_PREFIXO"  ,SE1->E1_PREFIXO                    ,Nil    } )
					AAdd( aBaixa , {"E1_NUM"      ,SE1->E1_NUM                        ,Nil    } )
					AAdd( aBaixa , {"E1_PARCELA"  ,SE1->E1_PARCELA                    ,Nil    } )
					AAdd( aBaixa , {"E1_TIPO"     ,SE1->E1_TIPO                       ,Nil    } )
					AAdd( aBaixa , {"AUTMOTBX"    ,"NOR" /*oJSon[cMain][nX]["motbx"]*/,Nil    } )
					AAdd( aBaixa , {"AUTBANCO"    ,SA6->A6_COD                        ,Nil    } )
					AAdd( aBaixa , {"AUTAGENCIA"  ,SA6->A6_AGENCIA                    ,Nil    } )
					AAdd( aBaixa , {"AUTCONTA"    ,SA6->A6_NUMCON                     ,Nil    } )
					AAdd( aBaixa , {"AUTDTBAIXA"  ,CtoD(oJSon[cMain][nX]["dtbaixa"])  ,Nil    } )
					AAdd( aBaixa , {"AUTDTCREDITO",CtoD(oJSon[cMain][nX]["dtbaixa"])  ,Nil    } )    // dtcredito
					AAdd( aBaixa , {"AUTHIST"     ,oJSon[cMain][nX]["historico"]      ,Nil    } )
					AAdd( aBaixa , {"AUTJUROS"    ,oJSon[cMain][nX]["juros"]          ,Nil,.T.} )
					AAdd( aBaixa , {"AUTMULTA"    ,oJSon[cMain][nX]["multa"]          ,Nil,.T.} )
					AAdd( aBaixa , {"AUTDESCONTO" ,oJSon[cMain][nX]["desconto"]       ,Nil,.T.} )
					AAdd( aBaixa , {"AUTVALREC"   ,oJSon[cMain][nX]["valor"]          ,Nil    } )
					
					MSExecAuto({|x,y| Fina070(x,y) }, aBaixa, 3)
					
					If lMsErroAuto
						aLOG[nX]["Log"] := MostraErro("\","Error.log")
					Else
						cSeek := XFILIAL("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA
						
						// Processa a atualização do ID na baixa
						SE5->(dbSetOrder(7))    // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
						SE5->(dbSeek(cSeek,.T.))
						While !SE5->(Eof()) .And. SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == cSeek
							If !(SE5->E5_SITUACA $ "C") .And. Empty(SE5->E5_XID)
								RecLock("SE5",.F.)
								SE5->E5_XID := cID
								MsUnLock()
							Endif
							SE5->(dbSkip())
						Enddo
					Endif
				Else
					aLOG[nX]["Log"] := "Banco não encontrado " + Trim(cBcoInt)
				Endif
			Endif
		Else
			aLOG[nX]["Log"] := "Titulo não encontrado " + Trim(cIDTitulo)
		Endif
	Next

Return ""

Static Function GravaEstor(oJSon)
	Local nC, cIDTitulo, cBcoInt, dDiaCanc
	Local cMain  := "baixas"
	Local aBaixa := {}
	Local aCanc  := oJSon["content"]["data"]
	Local cRet   := ""
	
	If !oJSon["sucesso"]
		Return "Erro na integracao"
	Endif
    
	For nC:=1 To Len(aCanc)
		cIDTitulo := PADR(AllTrim(aCanc[nC]["idtitulo"]),TamSX3("E1_XIDINT" )[1])
		cBcoInt   := BancoIntegra(PADR(AllTrim(aCanc[nC]["idBanco" ]),TamSX3("A6_XBCOINT")[1]))
		dDiaCanc  := StoD(StrTran(PADR(aCanc[nC]["timestampMovimentacao"],10),"-",""))
		
		SE1->(dbOrderNickName("IDTITULO"))    // E1_FILIAL+E1_XIDINT
		If SE1->(dbSeek(XFILIAL("SE1")+cIDTitulo))
			SA6->(dbOrderNickName("BCOINT"))    // A6_FILIAL+A61_XBCOINT
			If SA6->(dbSeek(XFILIAL("SE1")+cBcoInt))
				AAdd( aBaixa , {"E1_PREFIXO"  ,SE1->E1_PREFIXO          ,Nil    } )
				AAdd( aBaixa , {"E1_NUM"      ,SE1->E1_NUM              ,Nil    } )
				AAdd( aBaixa , {"E1_PARCELA"  ,SE1->E1_PARCELA          ,Nil    } )
				AAdd( aBaixa , {"E1_TIPO"     ,SE1->E1_TIPO             ,Nil    } )
				AAdd( aBaixa , {"AUTMOTBX"    ,oJSon[cMain]["motbx"]    ,Nil    } )
				AAdd( aBaixa , {"AUTBANCO"    ,SA6->A6_COD              ,Nil    } )
				AAdd( aBaixa , {"AUTAGENCIA"  ,SA6->A6_AGENCIA          ,Nil    } )
				AAdd( aBaixa , {"AUTCONTA"    ,SA6->A6_NUMCON           ,Nil    } )
				AAdd( aBaixa , {"AUTDTBAIXA"  ,CtoD(oJSon[cMain]["dtbaixa"])  ,Nil    } )
				AAdd( aBaixa , {"AUTDTCREDITO",CtoD(oJSon[cMain]["dtbaixa"])  ,Nil    } )   // "dtcredito"
				AAdd( aBaixa , {"AUTHIST"     ,oJSon[cMain]["historico"],Nil    } )
				AAdd( aBaixa , {"AUTJUROS"    ,oJSon[cMain]["juros"]    ,Nil,.T.} )
				AAdd( aBaixa , {"AUTMULTA"    ,oJSon[cMain]["multa"]    ,Nil,.T.} )
				AAdd( aBaixa , {"AUTDESCON"   ,oJSon[cMain]["desconto"] ,Nil,.T.} )
				AAdd( aBaixa , {"AUTVALREC"   ,oJSon[cMain]["valor"]    ,Nil    } )
				
				MSExecAuto({|x,y| Fina070(x,y) }, aBaixa, "5" /*oJSon[cMain]["tpmov"]*/, Nil, oJSon[cMain]["nOpbaixa"])
			Else
				cRet := "Banco não encontrado " + Trim(cBcoInt)
			Endif
		Else
			cRet := "Titulo não encontrado " + Trim(cIDTitulo)
		Endif
	Next

Return cRet

Static Function Erros(cMessage,cHead)
	Local cValor
	Local oJSon := JSonObject():New()
	Local cErro := oJSon:FromJson(cMessage)
	Local cCod  := oJSon:GetJSonObject('codigo')
	Local aCmp  := oJSon:GetJSonObject('campos')
	Local cMsg  := oJSon:GetJSonObject('mensagem')
	Local cMens := ""
	
	If (cCod <> Nil .And. cCod <> "200") .Or. cErro <> Nil
		cMens := If( cCod <> Nil , cCod + " - ", "") + If( cMsg <> Nil , cMsg, "Não foram retornados dados válidos")
	Endif
	
	If aCmp <> Nil .And. !Empty(aCmp) .And. !Empty(cMens)
		cValor := aCmp[1]['valor']
		cMsg   := aCmp[1]["mensagem"]
		cMens  += EncodeUTF8("<br /><br />" + cMsg + "<br />Conteudo: " + cValor)
	Endif
	
	If !Empty(cMens)
		If IsBlind()
			u_fConOut("ERRO 1 >>> " + cMens)
		Else
			FWAlertWarning(cMens)
		Endif
		Return -1
	Endif
	
	If "INVALID URI" $ Upper(cMessage)
		If IsBlind()
			u_fConOut("ERRO 2 >>> " + cMessage)
		Endif
		Return -1
	Endif
	If "NOT AUTHORIZED" $ Upper(cMessage)
		If IsBlind()
			u_fConOut("ERRO 2 >>> " + cMessage)
		Endif
		Return -1
	Endif
	
	If !( "200" $ Upper(cHead) )  // Se não existir o OK
		If IsBlind()
			u_fConOut("ERRO 3 >>> " + cHead)
		Else
			FWAlertWarning(cHead,"JSON PARSE ERROR")
		Endif
		Return 0
	Endif
	
Return 1

Static Function BancoIntegra(cBanco)
	If cLicenca == "3657" .And. cBanco == "CX1"
		cBanco := "CXF"
	Endif
Return cBanco

Static Function ResumeErro(cErro)
Local nPos, cLinha, cAux
Local lCopia := .T.
Local cRet   := ""
Local cBkp   := ""

Default cErro := ""
cAux := cErro

Return cErro    // Alterado para retornar o erro completo

While (nPos := At(Chr(13)+Chr(10),cErro)) > 0   // Procura a quebra de linha na variável
	cLinha := SubStr(cErro,1,nPos-1)   // Copia a linha do erro
	//qout(cLinha)
	If !("HELP:" $ cLinha)
		If !("Sua senha" $ cLinha)   // Não processa essas linhas
			If "Tabela " $ cLinha  // Ao encontrar essa referência, então pára a cópia pois o erro já foi todo copiado
				lCopia := .F.
			ElseIf "Invalido"  $ cLinha   // Ao encontrar essa referência, então encontrou a causa do erro
				cRet += " " + AllTrim(cLinha)   // Copia as partes relevantes do erro
				Exit   // Sai pois o erro já foi todo lido
			Endif
			
			If lCopia
				cRet += " " + AllTrim(cLinha)   // Copia as partes relevantes do erro
			Endif
			
			If "Erro " $ cLinha
				cBkp += If( Empty(cBkp) , "", " / ") + Trim(cLinha)
			Endif
		Endif
	EndIf
	
	cErro := SubStr(cErro,nPos+2,Len(cErro))  // Apaga a linha da variavel
Enddo

If Empty(cRet)   // Caso não tenha definida mensagem válida
	If Empty(cBkp)
		cRet := AllTrim(StrTran(StrTran(Upper(cAux),Chr(13)+Chr(10),""),"HELP:",""))
	Else
		cRet := cBkp
	Endif
Endif

Return cRet

Static Function LiberaPedido(aPvlNfs)
	Local lLiber, lTransf, cAliasSC6, cQuery, aRegistros, nQtdLib
	Local lAvCred := .F.    // Desativa a avaliação de Crédito
	Local lAvEst  := .F.    // Desativa a avaliação de Estoque
	Local lQuery  := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se não há itens liberados, libera!                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(aPvlNfs)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Carrega perguntas do MATA440                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Pergunte("MTA440",.F.)
		lLiber := MV_PAR02 == 1
		lTransf:= MV_PAR01 == 1  
		#IFDEF TOP
			lQuery := .T.
			cAliasSC6 := "Ma410PvlNfs"
		
			cQuery := "SELECT SC6.R_E_C_N_O_ C6RECNO,SC5.R_E_C_N_O_ C5RECNO,"
			cQuery += "SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_QTDVEN,SC6.C6_QTDEMP,SC6.C6_QTDENT,"
			cQuery += "SC6.C6_ENTREG,SC6.C6_BLQ "
			cQuery += " FROM "+RetSqlName("SC6")+" SC6,"
			cQuery += RetSqlName("SC5")+" SC5 "
			cQuery += " WHERE SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND "
			cQuery += " SC6.C6_NUM ='"+SC5->C5_NUM+"' AND "
			cQuery += " SC6.C6_BLQ NOT IN ('S ','R ') AND "
			cQuery += " (SC6.C6_QTDVEN-SC6.C6_QTDEMP-SC6.C6_QTDENT)>0 AND "
			cQuery += " SC6.D_E_L_E_T_ = ' ' AND "
			cQuery += " SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
			cQuery += " SC5.C5_NUM=SC6.C6_NUM AND "
			cQuery += " SC5.D_E_L_E_T_ = ' ' "
	
			cQuery := ChangeQuery(cQuery)
	
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),cAliasSC6)
	
			TcSetField(cAliasSC6,"C6_ENTREG","D",8,0)
			If TamSX3("C6_QTDVEN")[2] > 8
				TcSetField(cAliasSC6,"C6_QTDVEN","N",TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2])
			EndIf
		#ELSE
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC5->C5_NUM)
		#ENDIF
		While (cAliasSC6)->(!Eof()) .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6") .And. (cAliasSC6)->C6_NUM == SC5->C5_NUM 
		
			aRegistros := {}
	
			While (cAliasSC6)->(!Eof()) .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6") .And. (cAliasSC6)->C6_NUM == SC5->C5_NUM
				If !AllTrim((cAliasSC6)->C6_BLQ) $ "SR"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Calcula a Quantidade Liberada                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nQtdLib := ( (cAliasSC6)->C6_QTDVEN - ( (cAliasSC6)->C6_QTDEMP + (cAliasSC6)->C6_QTDENT ) )
					If nQtdLib > 0
						If RecLock("SC5")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Posiciona item do pedido de venda                                       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
							If ( lQuery )
								SC6->(MsGoto((cAliasSC6)->C6RECNO))
							Else
								SC6->(MsGoto((cAliasSC6)->(RecNo())))
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Recalcula a Quantidade Liberada                                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RecLock("SC6")
							nQtdLib := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )
							If nQtdLib > 0
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica o tipo de Liberacao                                            ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If ( SC5->C5_TIPLIB == "1" )
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Libera por Item de Pedido                                               ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									Begin Transaction
										MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,lAvCred,lAvEst,lLiber,lTransf)
									End Transaction
								Else
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Libera por Pedido                                                       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
									Begin Transaction
										RecLock("SC6")
										SC6->C6_QTDLIB := nQtdLib
										MsUnLock()
										aadd(aRegistros,SC6->(RecNo()))
									End Transaction
								EndIf
							EndIf
							SC6->(MsUnLock())
						EndIf
					EndIf
				EndIf
				dbSelectArea(cAliasSC6)
				dbSkip()
			EndDo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Libera por Total de Pedido                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( Len(aRegistros) > 0 )
				Begin Transaction
					SC6->(MGMaAvLibPed(SC5->C5_NUM,lLiber,lTransf,.F.,aRegistros,Nil,Nil,lAvCred,lAvEst))
				End Transaction
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o Flag do Pedido de Venda                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Begin Transaction
				SC6->(MaLiberOk({SC5->C5_NUM},.F.))
			End Transaction
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Controle de cancelamento por solicitacao do usuario                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(cAliasSC6)
		EndDo
		
		If lQuery
			dbSelectArea(cAliasSC6)
			dbCloseArea()
			dbSelectArea("SC6")
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Carrega perguntas do MATA410                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Pergunte("MTA410",.F.)
	Endif
	
Return

Static Function MGMaAvLibPed(cNumPed,lLiber,lTransf,lLiberOk,aRegistros,bBlock,lEstLib,lAvCred,lAvEst,nVlrCred)

Local aArea    := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSF4 := SF4->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSC9 := SC9->(GetArea())
Local aEmpenho := {{},{}}
Local lRetorno := .F.
Local lBloqueio:= .F.
Local lLibEst  := .F.
Local lLibCred := .F.
Local lCredito := .F.
Local lEstoque := .F.
Local lFind	   := .F.
Local nX       := 0
Local nQtdLib  := 0
Local nCredito := nVlrCred
Local nSldOrdSep := 0
Local lFATTRVSA1 := ExistBlock("FATTRVSA1")

lLiberOk := .T.
DEFAULT nVlrCred   := 0
DEFAULT aRegistros := {}
DEFAULT lAvCred    := .T.
DEFAULT lAvEst     := .T.
DEFAULT lEstLib    := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MEMORIA DE CALCULO DO ARRAY aEmpenho                                    ³
//³                                                                        ³
//³[1] - SA1                                                               ³
//³[1][1] - Registro                                                       ³
//³[1][2] - A1_SALPEDL                                                     ³
//³[2] - SB2                                                               ³
//³[2][1] - Registro                                                       ³
//³[2][2] - B2_RESERVA                                                     ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Registros                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")
dbSetOrder(1)
lFind := MsSeek(xFilial("SC5")+cNumPed)

If lFind
	lRetorno := RecLock("SC5")
	If !( SC5->C5_TIPO$"BD" )
		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		lTrvSA1 := IIf(cPaisLoc == "BRA" .And. lFATTRVSA1, ExecBlock("FATTRVSA1", .F., .F., {xFilial("SA1"), SA1->A1_COD, SA1->A1_LOJA}), .T.)
		If lTrvSA1
			lRetorno := RecLock("SA1")
		EndIf
	Else
		dbSelectArea("SA2")
		dbSetOrder(1)
		MsSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		lRetorno := RecLock("SA2")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o tipo de processamento                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aRegistros) > 0
		lLibEst  := .T.
		lLibCred := .T.
		For nX := 1 To Len(aRegistros)
			nSldOrdSep := 0
			SC6->(MsGoto(aRegistros[nX]))
			lRetorno := RecLock("SC6")
			If ( lRetorno )
				If lEstLib
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica a necessidade de estorno da liberacao                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nSldOrdSep := FtGtSldOS()
					nQtdLib := SC6->C6_QTDEMP - nSldOrdSep
					If nQtdLib > 0
						MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil,@nCredito)
						RecLock("SC6")
						SC6->C6_QTDLIB := nQtdLib
					Else
						nQtdLib := SC6->C6_QTDLIB
					EndIf
				Else
					nQtdLib := SC6->C6_QTDLIB
				EndIf
				lCredito := .F. .Or. !lAvCred
				lEstoque := .F. .Or. !lAvEst
				MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf,@aEmpenho,bBlock,Nil,Nil,Nil,@nCredito)
			Else
				lCredito := .F.
				lEstoque := .F.
			EndIf
			lLibCred := lCredito .And. lLibCred
			lLibEst  := lEstoque .And. lLibEst
			If ( !lLibEst .And. !lLibCred )
				nX := Len(aRegistros)+1
			EndIf
		Next nX
	Else
		lLibEst  := .T.
		lLibCred := .T.
		lBloqueio:= .F.
		dbSelectArea("SC6")
		dbSetOrder(1)
		MsSeek(xFilial("SC6")+SC5->C5_NUM,.F.)
		While ( !Eof() .And. xFilial("SC6") == SC6->C6_FILIAL .And.;
				SC5->C5_NUM    == SC6->C6_NUM )
			lRetorno := RecLock("SC6")
			If ( lRetorno )
				AAdd(aRegistros,SC6->(RecNo()))
				If !lBloqueio
					lCredito := .F. .Or. !lAvCred
					lEstoque := .F. .Or. !lAvEst
					MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf,@aEmpenho,bBlock,Nil,Nil,Nil,@nCredito)
				EndIf
			Else
				lCredito := .F.
				lEstoque := .F.
			EndIf
			lLibCred := lCredito .And. lLibCred
			lLibEst  := lEstoque .And. lLibEst
			If ( !lLibEst .And. !lLibCred )
				lBloqueio := .T.
			EndIf
			dbSelectArea("SC6")
			dbSkip()
		EndDo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os dados com base no processamento anterior                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lEstoque := .T.
	For nX := 1 To Len(aRegistros)
		nSldOrdSep := 0
		SC6->(MsGoto(aRegistros[nX]))
		RecLock("SC6")
		If ( !lLibEst .Or. !lLibCred )
			lRetorno := .F.
			If lEstLib
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a necessidade de estorno da liberacao                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSldOrdSep := FtGtSldOS()
				nQtdLib := SC6->C6_QTDEMP - nSldOrdSep
				If nQtdLib > 0
					MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil,@nVlrCred)
				Else
					nQtdLib := SC6->C6_QTDLIB
				EndIf
			Else
				nQtdLib := SC6->C6_QTDLIB
			EndIf
			lCredito := lLibCred
			lEstoque := (lLibCred .And. lLibEst) .Or. (lLibEst .And. lEstoque .And. SuperGetMv("MV_RESEST"))
			MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,lCredito .And. lAvCred,lEstoque .And. lAvEst,lLiber,lTransf,,bBlock,Nil,Nil,Nil,@nVlrCred)
			Do Case
			Case lLibCred <> lCredito .And. lLibCred
				lLibCred := .F.
			Case lLibEst <> lEstoque .And. lLibEst
				lLibEst := .F.
			EndCase
		Else
			MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTransf,,bBlock,Nil,Nil,Nil,@nVlrCred)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se Todos os Itens foram Liberados                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( SC6->C6_QTDVEN > SC6->C6_QTDEMP + SC6->C6_QTDENT .And. lLiberOk .And. AllTrim(SC6->C6_BLQ)<>"R" )
			lLiberOk := .F.
		EndIf
	Next nX
EndIf

RestArea(aAreaSC9)
RestArea(aAreaSA1)
RestArea(aAreaSF4)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aArea)
Return(lRetorno)

Static Function CriaSerie(cFilSX5,cSerie)
	Local cSX5 := "SX5"
	Local cTab := '01'

	Default cFilSX5 := FWxFilial(cSX5)
	
	(cSX5)->(dbSetOrder(1))
	If !(cSX5)->(DbSeek(cFilSX5 + '00' + cTab))
		RecLock(cSX5, .T.)
		(cSX5)->X5_FILIAL  := cFilSX5
		(cSX5)->X5_TABELA  := '00'
		(cSX5)->X5_CHAVE   := cTab
		(cSX5)->X5_DESCRI  := 'SÉRIES DE N. FISCAIS'
		(cSX5)->X5_DESCSPA := 'SERIES DE FACTURAS'
		(cSX5)->X5_DESCENG := 'INVOICE SERIES'
		MsUnLock()
	Endif
	
	If !(cSX5)->(DbSeek(cFilSX5 + cTab + cSerie))
		RecLock(cSX5, .T.)
		(cSX5)->X5_FILIAL  := cFilSX5
		(cSX5)->X5_TABELA  := cTab
		(cSX5)->X5_CHAVE   := cSerie
		(cSX5)->X5_DESCRI  := StrZero(1,TamSX3('F2_DOC')[1])
		(cSX5)->X5_DESCSPA := (cSX5)->X5_DESCRI
		(cSX5)->X5_DESCENG := (cSX5)->X5_DESCRI
		MsUnLock()
	Endif
  
Return

Static Function GravaPendentes(aPend)
	Local nP, nI, aArrSL1, aArrSL2, aArrSL4, nPDoc, nPSer, nPIte, nPVen, nPFor, lSZ6, lSZ7, lSZ8, cCmpDoc, cCmpSer, cCmpIte
	Local aSL1 := {}
	Local aSL2 := {}
	Local aSL4 := {}
	
	Private cJSon
	
	SZ6->(dbSetOrder(2))
	SZ7->(dbSetOrder(1))
	SZ8->(dbSetOrder(1))
	
	For nP:=1 To Len(aPend)
		
		aSL1 := {}
		aSL2 := {}
		aSL4 := {}
		
		If aPend[nP,1] == "1"
			MontaOrcamento(aSL1,aSL2,aSL4)
			cCmpDoc := "LQ_XDOCCTR"
			cCmpSer := "LQ_XSERCTR"
			cCmpIte := "LR_ITEM"
		Else
			MontaPedido(aSL1,aSL2,aSL4)
			cCmpDoc := "C5_XDOCCTR"
			cCmpSer := "C5_XSERCTR"
			cCmpIte := "C6_ITEM"
		Endif
		
		aArrSL1 := aClone(aPend[nP,2])
		cJSon   := If( ValType(aPend[nP,5]) == "C" , aPend[nP,5], "")
		
		nPDoc := AScan( aArrSL1 , {|x| x[1] == cCmpDoc } )
		nPSer := AScan( aArrSL1 , {|x| x[1] == cCmpSer } )
		lSZ6  := !SZ6->(dbSeek(XFILIAL("SZ6")+aArrSL1[nPDoc,2]+aArrSL1[nPSer,2]))
		GravaTabela("SZ6",lSZ6,aArrSL1,aSL1)
		If lSZ6
			ConfirmSX8()
		Endif
		
		aArrSL2 := aClone(aPend[nP,3])
		For nI:=1 To Len(aArrSL2)
			nPIte := AScan( aArrSL2[nI] , {|x| x[1] == cCmpIte } )
			lSZ7  := !SZ7->(dbSeek(XFILIAL("SZ7")+SZ6->Z6_NUM+aArrSL2[nI][nPIte,2]))
			GravaTabela("SZ7",lSZ7,aArrSL2[nI],aSL2)
		Next
		
		aArrSL4 := aClone(aPend[nP,4])
		For nI:=1 To Len(aArrSL4)
			nPVen := AScan( aArrSL4[nI] , {|x| x[1] == "L4_DATA"  } )
			nPFor := AScan( aArrSL4[nI] , {|x| x[1] == "L4_FORMA" } )
			lSZ8  := !SZ8->(dbSeek(XFILIAL("SZ8")+SZ6->Z6_NUM+DtoS(aArrSL4[nI][nPVen,2])+aArrSL4[nI][nPFor,2]))
			GravaTabela("SZ8",lSZ8,aArrSL4[nI],aSL4)
		Next
	Next

Return

Static Function MontaPedido(aSL1,aSL2,aSL4)
	
	// Monta a relação de gravação entre o orçamento e tabela de pendência
	//AAdd( aSL1 , { "Z6_FILIAL" , ""          , {| | XFILIAL("SZ6")        } })
	AAdd( aSL1 , { "Z6_NUM"    , ""          , {|| NextNumber(lGrv)      } })
	AAdd( aSL1 , { "Z6_STATUS" , ""          , {|| "1"                   } })
	AAdd( aSL1 , { "Z6_TIPO"   , ""          , {|| "2"                   } })
	AAdd( aSL1 , { "Z6_TIPONF" , "C5_TIPO"   , {||                       } })
	AAdd( aSL1 , { "Z6_CLIENTE", "C5_CLIENTE", {||                       } })
	AAdd( aSL1 , { "Z6_LOJA"   , "C5_LOJACLI", {||                       } })
	AAdd( aSL1 , { "Z6_VEND"   , "C5_VEND1"  , {||                       } })
	AAdd( aSL1 , { "Z6_COND"   , "C5_CONDPAG", {||                       } })
	AAdd( aSL1 , { "Z6_EMISSAO", "C5_EMISSAO", {||                       } })
	AAdd( aSL1 , { "Z6_DTLIM"  , "C5_EMISSAO", {||                       } })
	//AAdd( aSL1 , { "Z6_PEDCLI" , "LQ_NROPCLI", {||                       } })
	AAdd( aSL1 , { "Z6_DOC"    , "C5_XDOCCTR", {||                       } })
	AAdd( aSL1 , { "Z6_SERIE"  , "C5_XSERCTR", {||                       } })
	//AAdd( aSL1 , { "Z6_NRCUPOM", "LQ_NUMCFIS", {||                       } })
	AAdd( aSL1 , { "Z6_ESPECIE", "C5_ESPECI1", {||                       } })
	//AAdd( aSL1 , { "Z6_TOTAL"  , "LQ_VLRTOT" , {||                       } })
	//AAdd( aSL1 , { "Z6_VALDESC", "LQ_DESCONT", {||                       } })
	//AAdd( aSL1 , { "Z6_VLRLIQ" , "LQ_VLRLIQ" , {||                       } })
	//AAdd( aSL1 , { "Z6_DINHEIR", "LQ_DINHEIR", {||                       } })
	//AAdd( aSL1 , { "Z6_DEBITO" , "LQ_VLRDEBI", {||                       } })
	//AAdd( aSL1 , { "Z6_COMIS"  , "LQ_COMIS"  , {||                       } })
	AAdd( aSL1 , { "Z6_OPERADO", "C5_BANCO"  , {||                       } })
	//AAdd( aSL1 , { "Z6_HORA"   , "LQ_HORA"   , {||                       } })
	AAdd( aSL1 , { "Z6_CHVNFE" , "C5_KEYNFCE", {||                       } })
	AAdd( aSL1 , { "Z6_REST"   , ""          , {|| cJSon                 } })
	AAdd( aSL1 , { "Z6_ID"     , ""          , {|| SZ4->Z4_ID            } })
	
	//AAdd( aSL2 , { "Z7_FILIAL" , ""          , {|| XFILIAL("SZ7")        } })
	AAdd( aSL2 , { "Z7_NUM"    , ""          , {|| NextNumber(.F.)       } })
	AAdd( aSL2 , { "Z7_ITEM"   , "C6_ITEM"   , {||                       } })
	AAdd( aSL2 , { "Z7_PRODUTO", "C6_PRODUTO", {||                       } })
	AAdd( aSL2 , { "Z7_DESCRI" , "C6_DESCRI" , {||                       } })
	AAdd( aSL2 , { "Z7_UM"     , "C6_UM"     , {||                       } })
	AAdd( aSL2 , { "Z7_QUANT"  , "C6_QTDVEN" , {||                       } })
	AAdd( aSL2 , { "Z7_PRECO"  , "C6_PRCVEN" , {||                       } })
	AAdd( aSL2 , { "Z7_TOTAL"  , "C6_VALOR"  , {||                       } })
	AAdd( aSL2 , { "Z7_LOCAL"  , "C6_LOCAL"  , {||                       } })
	AAdd( aSL2 , { "Z7_ENTREGA", "C6_ENTREG" , {||                       } })
	AAdd( aSL2 , { "Z7_OPER"   , "C6_OPER"   , {||                       } })
	AAdd( aSL2 , { "Z7_TES"    , "C6_TES"    , {||                       } })
	AAdd( aSL2 , { "Z7_CF"     , "C6_CF"     , {||                       } })
	AAdd( aSL2 , { "Z7_CFORI"  , "C6_CFORI"  , {||                       } })
	//AAdd( aSL2 , { "Z7_DESC"   , "LR_DESC"   , {||                       } })
	//AAdd( aSL2 , { "Z7_VALDESC", "LR_VALDESC", {||                       } })
	AAdd( aSL2 , { "Z7_PRCTAB" , "C6_PRCTAB" , {||                       } })
	
	AAdd( aSL2 , { "Z7_NFORIG" , "C6_NFORI"  , {||                       } })
	AAdd( aSL2 , { "Z7_SERIORI", "C6_SERIORI", {||                       } })
	AAdd( aSL2 , { "Z7_ITEMORI", "C6_ITEMORI", {||                       } })
	
Return

Static Function MontaOrcamento(aSL1,aSL2,aSL4)
	
	// Monta a relação de gravação entre o orçamento e tabela de pendência
	//AAdd( aSL1 , { "Z6_FILIAL" , ""          , {| | XFILIAL("SZ6")        } })
	AAdd( aSL1 , { "Z6_NUM"    , ""          , {|| NextNumber(lGrv)      } })
	AAdd( aSL1 , { "Z6_STATUS" , ""          , {|| "1"                   } })
	AAdd( aSL1 , { "Z6_TIPO"   , ""          , {|| "1"                   } })
	AAdd( aSL1 , { "Z6_TIPONF" , ""          , {|| "N"                   } })
	AAdd( aSL1 , { "Z6_CLIENTE", "LQ_CLIENTE", {||                       } })
	AAdd( aSL1 , { "Z6_LOJA"   , "LQ_LOJA"   , {||                       } })
	AAdd( aSL1 , { "Z6_VEND"   , "LQ_VEND"   , {||                       } })
	AAdd( aSL1 , { "Z6_COND"   , "LQ_CONDPG" , {||                       } })
	AAdd( aSL1 , { "Z6_EMISSAO", "LQ_EMISSAO", {||                       } })
	AAdd( aSL1 , { "Z6_DTLIM"  , "LQ_DTLIM"  , {||                       } })
	AAdd( aSL1 , { "Z6_PEDCLI" , "LQ_NROPCLI", {||                       } })
	AAdd( aSL1 , { "Z6_DOC"    , "LQ_XDOCCTR", {||                       } })
	AAdd( aSL1 , { "Z6_SERIE"  , "LQ_XSERCTR", {||                       } })
	AAdd( aSL1 , { "Z6_NRCUPOM", "LQ_NUMCFIS", {||                       } })
	AAdd( aSL1 , { "Z6_ESPECIE", "LQ_ESPECIE", {||                       } })
	AAdd( aSL1 , { "Z6_TOTAL"  , "LQ_VLRTOT" , {||                       } })
	AAdd( aSL1 , { "Z6_VALDESC", "LQ_DESCONT", {||                       } })
	AAdd( aSL1 , { "Z6_VLRLIQ" , "LQ_VLRLIQ" , {||                       } })
	AAdd( aSL1 , { "Z6_DINHEIR", "LQ_DINHEIR", {||                       } })
	AAdd( aSL1 , { "Z6_DEBITO" , "LQ_VLRDEBI", {||                       } })
	AAdd( aSL1 , { "Z6_COMIS"  , "LQ_COMIS"  , {||                       } })
	AAdd( aSL1 , { "Z6_OPERADO", "LQ_OPERADO", {||                       } })
	AAdd( aSL1 , { "Z6_HORA"   , "LQ_HORA"   , {||                       } })
	AAdd( aSL1 , { "Z6_CHVNFE" , "LQ_KEYNFCE", {||                       } })
	AAdd( aSL1 , { "Z6_REST"   , ""          , {|| cJSon                 } })
	AAdd( aSL1 , { "Z6_ID"     , ""          , {|| SZ4->Z4_ID            } })
	
	//AAdd( aSL2 , { "Z7_FILIAL" , ""          , {|| XFILIAL("SZ7")        } })
	AAdd( aSL2 , { "Z7_NUM"    , ""          , {|| NextNumber(.F.)       } })
	AAdd( aSL2 , { "Z7_ITEM"   , "LR_ITEM"   , {||                       } })
	AAdd( aSL2 , { "Z7_PRODUTO", "LR_PRODUTO", {||                       } })
	AAdd( aSL2 , { "Z7_DESCRI" , "LR_DESCRI" , {||                       } })
	AAdd( aSL2 , { "Z7_UM"     , "LR_UM"     , {||                       } })
	AAdd( aSL2 , { "Z7_QUANT"  , "LR_QUANT"  , {||                       } })
	AAdd( aSL2 , { "Z7_PRECO"  , "LR_VRUNIT" , {||                       } })
	AAdd( aSL2 , { "Z7_TOTAL"  , "LR_VLRITEM", {||                       } })
	AAdd( aSL2 , { "Z7_LOCAL"  , "LR_LOCAL"  , {||                       } })
	AAdd( aSL2 , { "Z7_ENTREGA", "LR_FDTENTR", {||                       } })
	//AAdd( aSL2 , { "Z7_OPER"   ,
	AAdd( aSL2 , { "Z7_TES"    , "LR_TES"    , {||                       } })
	AAdd( aSL2 , { "Z7_CFORI"  , "LR_CFORI"  , {||                       } })
	AAdd( aSL2 , { "Z7_CF"     , "LR_CF"     , {||                       } })
	AAdd( aSL2 , { "Z7_DESC"   , "LR_DESC"   , {||                       } })
	AAdd( aSL2 , { "Z7_VALDESC", "LR_VALDESC", {||                       } })
	AAdd( aSL2 , { "Z7_PRCTAB" , "LR_PRCTAB" , {||                       } })
	//Z7_NFORIG 
	//Z7_SERIORI
	//Z7_ITEMORI
	
	//AAdd( aLinha , {"LR_DESCPRO", aIteVen[nX]["DescProd"]   , NIL} )
	
	//AAdd( aSL4, { "Z8_FILIAL" , ""          , {|| XFILIAL("SZ8")        } })
	AAdd( aSL4 , { "Z8_NUM"    , ""          , {|| NextNumber(.F.)       } })
	AAdd( aSL4 , { "Z8_DATA"   , "L4_DATA"   , {||                       } })
	AAdd( aSL4 , { "Z8_VALOR"  , "L4_VALOR"  , {||                       } })
	AAdd( aSL4 , { "Z8_FORMA"  , "L4_FORMA"  , {||                       } })
	AAdd( aSL4 , { "Z8_ADMINIS", "L4_ADMINIS", {||                       } })
	AAdd( aSL4 , { "Z8_MOEDA"  , "L4_MOEDA"  , {||                       } })
	AAdd( aSL4 , { "Z8_ID"     , "L4_XIDINT" , {||                       } })

Return

Static Function GravaTabela(cTab,lGrv,aDados,aCmp)
	Local nJ, nPos
	Local cFil := If( SubStr(cTab,1,1) == "S" , SubStr(cTab,2,2), cTab) + "_FILIAL"
	
	RecLock(cTab,lGrv)
	For nJ:=1 To Len(aCmp)
		If Empty(aCmp[nJ,2])
			FieldPut( FieldPos(aCmp[nJ,1]) , Eval( aCmp[nJ,3] ) )
		ElseIf (nPos := AScan( aDados , {|x| x[1] == aCmp[nJ,2] } ) ) > 0
			FieldPut( FieldPos(aCmp[nJ,1]) , aDados[nPos,2] )
		Endif
	Next
	FieldPut( FieldPos(cFil) , XFILIAL(cTab) )
	MsUnLock()

Return

Static Function NextNumber(lNovo)
	Local aArea
	Local cRet := SZ6->Z6_NUM
	
	If lNovo
		aArea := SZ6->(GetArea())
		cRet  := CriaVar("Z6_NUM",.T.)
		
		SZ6->(dbSetOrder(1))
		While SZ6->(dbSeek(XFILIAL("SZ6")+cRet))
			ConfirmSX8()
			cRet := CriaVar("Z6_NUM",.T.)
		Enddo
		
		SZ6->(RestArea(aArea))
	Endif

Return cRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Rotina    ¦ GravaCtaRec¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 25/03/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Regrava o contas a receber com origem do faturamento          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GravaCtaRec(aFinVen,cBanco,lFinanc)
	Local cCodCli, cLojCli, aSE1
	Local aArea   := SE1->(GetArea())
	Local cParc   := StrZero(0,TamSX3("E1_PARCELA")[1])
	Local aParc   := {}
	Local nX      := 1
	Local aFormas := FwGetSX5("Z1")
	
	Local cPortador := BancoIntegra(cBanco)
	
	// Pesquisa as parcelas do Contas a Receber já gravadas para excluí-las
	SE1->(dbSetOrder(1))
	SE1->(dbSeek(XFILIAL("SE1")+SF2->F2_SERIE+SF2->F2_DOC,.T.))
	While !lMsErroAuto .And. !SE1->(Eof()) .And. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == XFILIAL("SE1")+SF2->F2_SERIE+SF2->F2_DOC
		
		RecLock("SE1",.F.)
		SE1->E1_TIPO   := "NF"
		SE1->E1_ORIGEM := "FINA040"
		MsUnLock()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
		//³Monta o array com as informacoes para a gravacao do titulo           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ
		aSE1 := {	{"E1_FILIAL"	,xFilial("SE1")											,Nil},;
					{"E1_PREFIXO"	,SE1->E1_PREFIXO										,Nil},;
					{"E1_NUM"	  	,SE1->E1_NUM											,Nil},;
					{"E1_PARCELA" 	,SE1->E1_PARCELA										,Nil},;
					{"E1_TIPO"	 	,SE1->E1_TIPO											,Nil},;
					{"E1_CLIENTE" 	,SE1->E1_CLIENTE										,Nil},;
					{"E1_LOJA"	  	,SE1->E1_LOJA											,Nil},;
					{"E1_EMISSAO" 	,SE1->E1_EMISSAO										,Nil},;
					{"E1_VENCTO"  	,SE1->E1_VENCTO											,Nil},;
					{"E1_VENCREA" 	,SE1->E1_VENCREA										,Nil},;
					{"E1_MOEDA" 	,SE1->E1_MOEDA											,Nil} }
		
		//Exclusao do Titulo a Receber
		MSExecAuto({|x,y| Fina040(x,y)},aSE1, 5) //Exclusao
		
		SE1->(dbSkip())
	Enddo
	
	If lMsErroAuto
		Return .F.
	ElseIf !lFinanc
		Return .T.
	Endif
	
	For nX:=1 To Len(aFinVen)
		AAdd( aParc , { CtoD(aFinVen[nX]["Vencimento"]), FormaPag(aFormas,aFinVen[nX]["FormaPag"]), aFinVen[nX]["AdmCartao"], aFinVen[nX]["ValorFim"]})
	Next
	
	ASort( aParc ,,, {|x,y| Dtos(x[1])+x[2] <= Dtos(y[1])+y[2] })   // Ordena por Vencimento + Forma Pagamento
	
	SA1->(dbSetOrder(1))
	SA6->(dbSetOrder(1))
	SA6->(dbSeek(XFILIAL("SA6")+cPortador))
	
	For nX:=1 To Len(aParc)
		SA1->(dbSeek(XFILIAL("SA1")+SA1->A1_COD+SA1->A1_LOJA))
		
		cCodCli := SA1->A1_COD
		cLojCli := SA1->A1_LOJA
		//cNomCli := SA1->A1_NREDUZ
		cParc   := Soma1(cParc)
		cTipo   := If(Empty(aParc[nX,2]),"R$",aParc[nX,2])
		cNature := LjMExeParam("MV_NATOUTR")
		
		// Pesquisa os dados da Administradora Financeira
		If !Empty(aParc[nX,3]) .And. SAE->(dbSeek(XFILIAL("SAE")+PADR(aParc[nX,3],Len(SAE->AE_COD)))) .And. SAE->AE_FINPRO <> "S"
			If !Empty(SAE->AE_CODCLI) .And. SA1->(dbSeek(XFILIAL("SA1")+SAE->AE_CODCLI+"01"))
				cCodCli := SA1->A1_COD
				cLojCli := SA1->A1_LOJA
				//cNomCli := SA1->A1_NREDUZ
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
		//³Monta o array com as informacoes para a gravacao do titulo           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ
		aSE1 := {	{"E1_FILIAL"	,xFilial("SE1")						,Nil},;
					{"E1_PREFIXO"	,SF2->F2_SERIE						,Nil},;
					{"E1_NUM"	  	,SF2->F2_DOC						,Nil},;
					{"E1_PARCELA" 	,cParc								,Nil},;
					{"E1_TIPO"	 	,cTipo								,Nil},;
					{"E1_NATUREZ" 	,cNature							,Nil},;
					{"E1_PORTADO" 	,cPortador							,Nil},;
					{"E1_CLIENTE" 	,cCodCli							,Nil},;
					{"E1_LOJA"	  	,cLojCli							,Nil},;
					{"E1_EMISSAO" 	,SF2->F2_EMISSAO					,Nil},;
					{"E1_VENCTO"  	,aParc[nX,1]						,Nil},;
					{"E1_VENCREA" 	,DataValida(aParc[nX,1])			,Nil},;
					{"E1_MOEDA" 	,1									,Nil},;
					{"E1_ORIGEM"	,"MATA460"							,Nil},;
					{"E1_FLUXO"		,"S"								,Nil},;
					{"E1_VALOR"	  	,aParc[nX,4]						,Nil},;
					{"E1_VLRREAL"  	,aParc[nX,4]						,Nil},;
					{"E1_FORMREC"  	,cTipo								,Nil},;
					{"E1_HIST"		,"INTEGRACAO CONTROL"				,Nil} }
		
		If Trim(cTipo) == "R$"
			aadd(aSE1, {"E1_AGEDEP", SA6->A6_AGENCIA, Nil } )
			aadd(aSE1, {"E1_CONTA" , SA6->A6_NUMCON , NIL } )
		Endif
		
		//Inclusao do Titulo a Receber
		MSExecAuto({|x,y| Fina040(x,y)},aSE1, 3) //Inclusao
		
		If lMsErroAuto .Or. !BaixaSE1(SE1->E1_EMISSAO,.F.)
			Exit
		Endif
	Next
	
	SE1->(RestArea(aArea))
	
Return !lMsErroAuto

// Baixa AUTOMATICA do Contas a Receber quando for DINHEIRO
Static Function BaixaSE1(dCredito,lNoAvista)
	Local aArea   := SE1->(GetArea())
	Local cFilAux := cFilAnt
	Local dDatAux := dDataBase
	Local aVet    := {}
	
	SE1->(dbSetOrder(1))
	
	cFilAnt   := If( Empty(SE1->E1_FILIAL) , SE1->E1_FILORIG, SE1->E1_FILIAL)  // Posiciona na filial do título
	dDataBase := dCredito
	
	aAdd( aVet, { "E1_PREFIXO"   , SE1->E1_PREFIXO  , Nil } )
	aAdd( aVet, { "E1_NUM"       , SE1->E1_NUM      , Nil } )
	aAdd( aVet, { "E1_PARCELA"   , SE1->E1_PARCELA  , Nil } )
	aAdd( aVet, { "E1_TIPO"      , SE1->E1_TIPO     , Nil } )
	aAdd( aVet, { "E1_CLIENTE"   , SE1->E1_CLIENTE  , Nil } )
	aAdd( aVet, { "E1_LOJA"      , SE1->E1_LOJA     , Nil } )
	aAdd( aVet, { "AUTMOTBX"     , "NOR"            , Nil } )
	aAdd( aVet, { "AUTJUROS"     , 0                , Nil,.T.} )
	aAdd( aVet, { "AUTMULTA"     , 0                , Nil,.T.} )
	aAdd( aVet, { "AUTDESCONT"   , 0                , Nil } )
	aAdd( aVet, { "AUTBANCO"     , SA6->A6_COD      , Nil } )
	aAdd( aVet, { "AUTAGENCIA"   , SA6->A6_AGENCIA  , Nil } )
	aAdd( aVet, { "AUTCONTA"     , SA6->A6_NUMCON   , Nil } )
	aAdd( aVet, { "AUTDTBAIXA"   , dDataBase        , Nil } )
	aAdd( aVet, { "AUTDTCREDITO" , dDataBase        , Nil } )
	aAdd( aVet, { "AUT_HIST"     , "RECEBIMENTO A VISTA" , Nil} )
	aAdd( aVet, { "AUTVALREC"    , SE1->E1_SALDO   , Nil  } )
	
	MsExecAuto({|x,y| FINA070(x,y) } , aVet, 3)
	
	cFilAnt   := cFilAux  // Restaura a filial do título
	dDataBase := dDatAux  // Restaura a data-base do sistema
	
	If lMsErroAuto
		If IsBlind()
			AutoGrLog( "Data.........: " + DtoC(Date()) )
			AutoGrLog( "Hora.........: " + Time() )
			AutoGrLog( "Aonde........: Baixa CR " )
			AutoGrLog( "Ordem........: " + SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_PARCELA)
		Else
			MostraErro()
		Endif
	Endif
	SE1->(RestArea(aArea))

Return !lMsErroAuto
