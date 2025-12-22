#Include "Protheus.Ch"
#Include "Tbiconn.ch"

Static lFTP       := .F.     // Habilita / Desabilita
Static __cPathSrv := "\tecsinapse\entrada\pedidos_vendas"
Static __aMsg     := {"","","",""}

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ BJFATA01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 17/09/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de Monitoramento de integrações com o TECSINAPSE       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function BJFATA01()
	Local cFiltro := Nil
	Local aCores  := Nil
	Local aRotImp := {}
	
	Private cCadastro := "Monitor de Integração Protheus x TECSINAPSE"
	Private aRotina   := {}
	
	AAdd( aRotImp , { "Arquivo", "u_FATA01Arq('SZ0',Recno(),2)", 0 , 2} )
	AAdd( aRotImp , { "Pasta"  , "u_FATA01Dir('SZ0',Recno(),2)", 0 , 2} )
	
	aAdd( aRotina, {"Pesquisar"    , "AxPesqui", 0 , 1 , , .F.} )
	aAdd( aRotina, {"Visualizar"   , "AxVisual", 0 , 2 , , .T.} )
	aAdd( aRotina, {"Gerar XMLs"   , "u_FATA01Ger('SZ0',Recno(),4)",0,4})
	aAdd( aRotina, {"Reenviar XML" , "u_FATA01XML('SZ0',Recno(),4)",0,4})
	aAdd( aRotina, {"Abrir XML"    , "u_FATA01Vis('SZ0',Recno(),2)",0,2})
	aAdd( aRotina, {"Importar XML" , aRotImp ,0,3})
	If lFTP
		aAdd( aRotina, {"Salvar FTP"   , "u_FATA01FTP('SZ0',Recno(),2)",0,2})
	Endif
	aAdd( aRotina, {"Executar Fila", "u_FATA01Fil('SZ0',Recno(),2)",0,2})
	//aAdd( aRotina ,{"Legenda"    , "u_FATA01Legend", 0, 2})
	
	mBrowse( ,,,,"SZ0",,,,,,aCores,,,,,,,.F.,cFiltro)
	
Return

User Function FATA01Ger(cAlias, nRecNo, nOpc)
	Local aRet   := {}
	Local aPergs := {}
	Local cTempo := PADR(GetMV("MV_XULTPRC",.F.,Transform(DtoS(dDataBase),"@R 9999-99-99") +" "+ Time()),20)
	
	aAdd( aPergs ,{9,"Arquivos a gerar para o TECSINAPSE",200, 40,.T.})
	
	aAdd( aPergs ,{4,"Clientes:"         ,.T.,""       ,90,"",.F.})
    aAdd( aPergs ,{4,"Produtos:"         ,.T.,""       ,90,"",.F.})
    aAdd( aPergs ,{4,"Estoque:"          ,.T.,""       ,90,"",.F.})
    aAdd( aPergs ,{4,"Tabelas de Preços:",.T.,""       ,90,"",.F.})
    aAdd( aPergs ,{4,"Status de Pedidos:",.T.,""       ,90,"",.F.})
	aAdd( aPergs ,{1,"Último processamento: ",cTempo ,"","","","",110,.T.})
    
	If ParamBox(aPergs ,"Geração de Arquivos TECSINAPSE",aRet,/*{|| bOKaRet(aRet)}*/,/*aButtons*/,,,,,,,)
		FWMsgRun(Nil, {|oSay| u_FATW01Proc({aRet[2],aRet[3],aRet[4],aRet[5],aRet[6],aRet[7]}) }, "Aguarde...", "Geração de Arquivos TECSINAPSE")
		FWAlertSuccess("Concluída a geração do(s) arquivo(s) XML !")
	Endif
	
Return

User Function FATA01XML(cAlias, nRecNo, nOpc)
	Local cXML, nHdl
	Local bBlock := ErrorBlock( { |e| ChecErro(e) } )
	Local cMens  := ""
	Local cPath  := AllTrim(SZ0->Z0_PATH)
	Local cFile  := AllTrim(SZ0->Z0_FILE)
	//Local aPasta := Separa(Lower(If(Right(cPath,1)=="\",PADR(cPath,Len(cPath)-1),cPath)),"\",.F.)
	Local lGera  := .T.
	
	If File(cPath+cFile)
		If lGera := FWAlertYesNo("O arquivo já existe, deseja gerar novamente ?")
			FErase(cPath+cFile)
		Endif
	Endif
	
	If lGera 
		If Empty( cXML := AllTrim( SZ0->Z0_XML ) )
			FWAlertError("O XML dessa integração não possui conteúdo válido !")
			Return
		Endif
		
		nHdl := FCREATE(cPath+cFile,0)
		If FERROR() != 0
			FWAlertError("Erro na Abertura do arquivo XML: "+LTrim(Str(FERROR())),"Geração de XML")
			Return
		Endif
	Endif
	
	Begin Sequence
		If lGera
			MsgRun(" Gerando arquivo XML ","Aguarde...",{|| FWrite(nHdl,cXML+CRLF) })
			FCLOSE(nHdl)
		Endif
		If lFTP
			MsgRun(" Transmitindo XML para o FTP ","Aguarde...",{|| u_FTPConnection(aPasta[Len(aPasta)],{{cPath+cFile,cFile}},@cMens) })
		Endif
	Recover
		cMens := "Erro na geração do XML"
	End Sequence
	
	ErrorBlock(bBlock)
	
	If Empty(cMens) .And. !File(cFile)
		cMens := "Erro na geração do XML"
	Endif
	
	If Empty(cMens)
		FWAlertSuccess("Arquivo XML gerado com sucesso !","Geração de XML")
	Else
		FWAlertError(cMens,"Geração de XML")
	Endif
	
Return

User Function FATA01Vis(cAlias, nRecNo, nOpc)
	Local lOk := .F.
	
	FWMsgRun(Nil, {|oSay| lOk := OpenXML() }, "Abertura do XML", "Abrindo XML. Aguarde...")
	
	If !lOk
		FWAlertError("Não foi possível abrir o arquivo XML !")
	Endif

Return

Static Function OpenXML()
	Local nHdl
	Local cTemp := GetTempPath()
	Local cPath := AllTrim(SZ0->Z0_PATH)
	Local cFile := AllTrim(SZ0->Z0_FILE)
	Local lOk   := .F.
	
	If File(cTemp+cFile)
		FErase(cTemp+cFile)
	Endif
	
	// Caso o arquivo não exista no caminho padrão
	If File(cPath+cFile)
		lOk := CpyS2T(cPath+cFile, cTemp)
	Else
		nHdl := FCREATE(cTemp+cFile,0)
		FWrite(nHdl,AllTrim(SZ0->Z0_XML)+CRLF)
		FCLOSE(nHdl)
		
		lOk := File(cTemp+cFile)
	Endif
	
	If lOk
		ShellExecute("OPEN", cFile, "", cTemp, 1)
	Endif

Return lOk

User Function FATA01Arq(cAlias, nRecNo, nOpc)
	Local aFile  := {}
	Local aRet   := {}
	Local aPergs := {}
	
	aAdd( aPergs ,{9,"Busca de Arquivo do Pedido TECSINAPSE",200, 40,.T.})
	aAdd( aPergs ,{6,"Aponte o arquivo:",Space(200),"","","",100,.F.,"Todos os arquivos (*.xml) |*.xml"})
	
	If ParamBox(aPergs ,"Importar Pedidos de Venda",aRet,/*{|| bOKaRet(aRet)}*/,/*aButtons*/,,,,,,,)
		aFile := SeparaCaminho()
		
		FWMsgRun(Nil, {|oSay| ImpPedido(aFile[1],aFile[2]) }, "Aguarde...", "Importando Pedido de Venda")   //Mala direta - ORIGEM
		
		ExibeMensagem()
	Endif
	
Return

User Function FATA01Dir(cAlias, nRecNo, nOpc)
	Local aArea    := (cAlias)->(GetArea())
	Local aFile    := { __cPathSrv+"\", Nil}
	Local aSays    := {}
	Local aButtons := {}
	Local nOpcA    := 0
	
	If IsBlind()
		ImpPedido(aFile[1],aFile[2])
	Else
		AADD(aSays, "Importaçao dos pedidos de venda do Tecsinapse conforme" )
		AADD(aSays, "arquivos salvos na pasta: " + __cPathSrv )
		
		cCadastro := "Importar dos Pedidos Tecsinapse"
		
		AADD(aButtons, { 1,.T.,{|o| nOpcA:=1, o:oWnd:End() } } )
		AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
		
		FormBatch( cCadastro, aSays, aButtons )
		
		If nOpcA == 1
			FWMsgRun(Nil, {|oSay| ImpPedido(aFile[1],aFile[2]) }, "Aguarde...", "Importando Pedidos de Venda")
			
			ExibeMensagem()
		Endif
	Endif
	
	(cAlias)->(RestArea(aArea))
	
Return

Static Function ExibeMensagem()
	Local cMsg := ""
	
	If !IsBlind()
		If !Empty(__aMsg[2])
			cMsg += "<strong>Pedido(s) de venda(s) gerado(s)/processado(s)" + If( Empty(__aMsg[1]) , " com sucesso:", ":")+"</strong>"
			cMsg += "<br /><br />Pedido(s): <strong><font face='Arial' size=3 color=RED>"+__aMsg[2]+"</font></strong>"
			cMsg += If(Empty(__aMsg[3]),"", "<br /><br />Obs: Pedido possui bloqueio de liberação.")
		ElseIf !Empty(__aMsg[4])
			cMsg += "<strong>Pedido(s) adicionado(s) com sucesso a fila de processamento:</strong>"
			cMsg += "<br /><br />Pedido(s): <strong><font face='Arial' size=3 color=RED>" + __aMsg[4] + "</font></strong>"
		Endif
		
		If !Empty(__aMsg[1])
			__aMsg[1] := "<strong>Ocorreu um erro durante o processo: <br /><br /><strong>Pedido(s): "+__aMsg[1]+"</strong>"
		Endif
		
		If !Empty(__aMsg[1]) .And. !Empty(cMsg)    // Caso haja erros e gravações
			FWAlertInfo(cMsg + "<br /><br />" + __aMsg[1],"ATENÇÃO")
		ElseIf Empty(__aMsg[1])
			FWAlertSuccess(cMsg,"ATENÇÃO")
		ElseIf Empty(cMsg)
			FWAlertError(__aMsg[1],"ATENÇÃO")
		Endif
	Endif

Return

User Function FATA01FTP(cAlias, nRecNo, nOpc)
	
	If FWAlertYesNo("Confirma a gravação desse XML no FTP ?","Salvar no FTP")
		FWMsgRun(Nil, {|oSay| u_BJMontaXML(lFTP) }, "Salvar no FTP", "Salvando no FTP. Aguarde...")
	Endif
	
Return

User Function FATA01Fil(cAlias, nRecNo, nOpc)
	Local nX, oTmp
	Local aArea   := GetArea()
	Local cTmp    := GetNextAlias()
	Local aCampos := FWSX3Util():GetAllFields("SZ6")     // Retorna todos os campos ativos para a tabela
	Local aFields := {}
	
	BeginSql Alias cTmp
		
		SELECT SZ6.R_E_C_N_O_ AS Z6_RECNO
		FROM %Table:SZ6% SZ6
		WHERE SZ6.%NotDel%
		AND SZ6.Z6_STATUS <> '3'
		ORDER BY SZ6.Z6_PRIORI, SZ6.Z6_DTIMP, SZ6.Z6_HRIMP
		
	EndSql
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		(cTmp)->(dbCloseArea())
		RestArea(aArea)
		FWAlertWarning("Não existem pedidos na fila para serem processados !")
		Return
	Endif
	
	//-------------------
	// Criação do objeto
	//-------------------
	oTmp := FWTemporaryTable():New()
	
	//--------------------------
	// Monta os campos da tabela
	//--------------------------
	For nX:=1 To Len(aCampos)
		AAdd( aFields, { aCampos[nX], GetSx3Cache(aCampos[nX], 'X3_TIPO'), GetSx3Cache(aCampos[nX], 'X3_TAMANHO'), GetSx3Cache(aCampos[nX], 'X3_DECIMAL')} )
	Next
	
	oTmp:SetFields( aFields )
	//oTmp:AddIndex("01", {"F2_DOC","F2_SERIE"} )
	
	//------------------
	// Criação da tabela
	//------------------
	oTmp:Create()
	
	//------------------------------------
	// Pego o alias da tabela temporária
	//------------------------------------
	cTab := oTmp:GetAlias()
	
	While !(cTmp)->(Eof())
		SZ6->(dbGoTo((cTmp)->Z6_RECNO))    // Posiciona no registro
		RecLock(cTab,.T.)
		For nX:=1 To Len(aFields)
			FieldPut( nX , SZ6->(FieldGet(nX)) )
		Next
		MsUnLock()
		(cTmp)->(dbSkip())
	Enddo
	(cTmp)->(dbCloseArea())
	
	(cTab)->(dbGoTop())
	
	If FWAlertYesNo("Confirma a execução da fila de importação de pedidos ?","Fila de Pedidos")
		FWMsgRun(Nil, {|oSay| u_BJExecFila() }, "Fila de Pedidos", "Executando fila. Aguarde...")
	Endif
	
	//---------------------------------
	// Exclui a tabela
	//---------------------------------
	oTmp:Delete()
	
Return

Static Function SeparaCaminho(cCaminho)
	Local nX   := 0
	Local aRet := { "", {}}
	
	Default cCaminho := AllTrim(mv_par02)
	
	For nX:=Len(cCaminho) To 1 Step -1
		If SubStr(cCaminho,nX,1) == "\"
			aRet[1]   := SubStr(cCaminho,1,nX)
			AAdd( aRet[2] , { SubStr(cCaminho,nX+1,Len(cCaminho)), ""} )
			Exit
		Endif
	Next
	
	If Empty(aRet[2])
		AAdd( aRet[2] , { cCaminho, ""})
	Endif

Return aRet

User Function BJExecFila()
	Local aArea  := GetArea()
	Local cTmp   := GetNextAlias()
	
	BeginSql Alias cTmp
		
		SELECT SZ6.R_E_C_N_O_ AS Z6_RECNO
		FROM %Table:SZ6% SZ6
		WHERE SZ6.%NotDel%
		AND SZ6.Z6_STATUS <> '3'
		ORDER BY SZ6.Z6_PRIORI, SZ6.Z6_DTIMP, SZ6.Z6_HRIMP
		
	EndSql
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		If IsBlind()
			u_fConout(">>> Nao existem pedidos na fila para serem processados !")
		Else
			FWAlertWarning("Não existem pedidos na fila para serem processados !")
		Endif
	Else
		While !(cTmp)->(Eof())
			
			SZ6->(dbGoTo((cTmp)->Z6_RECNO))   // Posiciona no registro
			
			ImpPedido("",{},Trim(SZ6->Z6_XML))
			
			(cTmp)->(dbSkip())
		Enddo
		
		ExibeMensagem()
	Endif
	
	(cTmp)->(dbCloseArea())
	
	RestArea(aArea)

Return

Static Function ImpPedido(cSrv,aDir,cXML)
	Local cFile, nX, oXML, nOrigem, lMove
	Local cPath    := "\XMLFISCAL\"
	Local cFilAux  := cFilAnt
	Local aErros   := {}
	Local cError   := ""
	Local cWarning := ""
	
	Default cSrv   := cPath
	Default aDir   := Directory(cSrv + "*.XML","D")
	Default cXML   := ""
	
	Private cFilProc := GetMV("MV_XTECFIL",.F.,"03")   // Filiais a serem processadas
	Private aHeader  := u_BJCriaHeader("SC6")
	Private aSaldos  := {}
	
	// Configura a filial padrão de integração
	If Len(cFilAnt) == Len(cFilProc)
		ConfigEmpresa(cFilProc)
	Endif
	
	cSrv := AllTrim(cSrv)
	
	If !Empty(cXML)
		cHash := MD5(Trim(cXML),2)
		oXML  := XmlParser( cXML, "_", @cError, @cWarning )
		
		If Empty(cError) //Caso não tenha ocorrido erro
			ProcXML(oXML,cXML,cHash,@cError)
		Else
			AAdd( aErros , cError)
		Endif
	ElseIf !ExistDir(cSrv)
		AAdd( aErros , "Caminho informado não foi localizado: "+AllTrim(cSrv)+" !" )
	ElseIf !Empty(aDir)
		
		If !ExistDir(cPath)
			MakeDir(cPath)
		Endif
		
		// Cria a pasta para onde serão movidos os arquivos lidos
		If !ExistDir(cSrv+"Lidos")
			MakeDir(cSrv+"Lidos")
		Endif
		
		For nX:=1 To Len(aDir)
			cError  := ""
			cFile   := AllTrim(cSrv + aDir[nX,1])
			nOrigem := If( ":" $ cFile , 2, 0)
			u_fConout(">>> Lendo arquivo " + cFile)
			If File(cFile,nOrigem)
				
				If ":" $ cFile    // Caso o caminho seja de origem externa
					If File(cPath+aDir[nX,1])
						FErase(cPath+aDir[nX,1])
					Endif
					If CpyT2S(cFile, cPath,.F.)
						cFile  := cPath + aDir[nX,1]
					Else
						cError := "Falha na copia do arquivo para o servidor"
					EndIf
				Endif
				
				cWarning := ""
				cHash    := MD5FILE( cFile )
				oXML     := XmlParserFile( cFile, "_", @cError, @cWarning )
				
				If Empty(cError) //Caso não tenha ocorrido erro
					ProcXML(oXML,LoadFile(cFile),cHash,@cError,aDir[nX,1],@lMove)
					If lMove
						u_fConout(">>> Movendo arquivo " + cFile)
						// Apaga o arquivo destino caso exista
						If File(cSrv+"lidos\"+aDir[nX,1])
							FErase(cSrv+"lidos\"+aDir[nX,1])
						Endif
						FRename(cFile,cSrv+"lidos\"+aDir[nX,1])   // Move o arquivo para a pasta Lidos
					Endif
				Endif
			Else
				cError := "Arquivo informado nao foi localizado !"
			Endif
			
			If !Empty(cError) .And. IsBlind()
				u_fConout("Ocorreu um erro durante o processo: "+cError)
			Endif
			
			AAdd( aErros , cError )
		Next
	Else
		AAdd( aErros , "Nao foram encontrados arquivos no caminho informado !" )
	Endif
	
	aEval( aErros , {|x| If( !Empty(x) .And. !(Trim(x) $ __aMsg[1]) , __aMsg[1] += If( Empty(__aMsg[1]) , "", ", ") + Trim(x), ) } )
	
	ConfigEmpresa(cFilAux)   // Restaura a filial

Return cError

Static Function ProcXML(oXML,cXML,cHash,cError,cFile,lMove)
	Local nI, nY, aItems, cItem, cOperacao, nQuant, nQtdLib, nPreco, cIteOri, aLinha, aDadosCfo, nPos, cTES, nSaveSX8
	Local cDrive, cDir, cNome, cExt, cFalha
	Local lFila     := !IsInCallStack("u_BJExecFila")   // Gravação da fila de processamento
	Local aSC5      := {}
	Local aSC6      := {}
	Local aPvlNfs   := {}
	Local aBloqueio := {}
	Local aLib      := {}
	Local cTransp   := GetMV("MV_XTECTRP",.F.,"")
	Local cCondPag  := GetMV("MV_XTECPAG",.F.,"001")
	Local cOpeGar   := GetMV("MV_XTECGAR",.F.,"01")
	Local cOpePrd   := GetMV("MV_XTECOPE",.F.,"01")
	Local cCodCli   := PADR(oXML:_Pedido:_cab_pedido:_CodigoCliente:text,TamSX3("A1_COD")[1])
	Local cLojCli   := PADR(oXML:_Pedido:_cab_pedido:_LojaCliente:text,TamSX3("A1_LOJA")[1])
	Local cPedCli   := PADR(AllTrim(oXML:_Pedido:_cab_pedido:_PedidoPortal:text),TamSX3("C5_XPEDORI")[1])
	Local cDatPed   := PADR(oXML:_Pedido:_cab_pedido:_DataHoraPedidoPortal:text,10)
	Local cHorPed   := AllTrim(StrTran(oXML:_Pedido:_cab_pedido:_DataHoraPedidoPortal:text,cDatPed,""))
	Local cTpoPed   := Upper(Trim(oXML:_Pedido:_cab_pedido:_TipoPed:text))
	Local cNumPed   := ""
	Local lLiberOk  := .T.
	
	Private aCols   := {}
	
	Default cFile := ""
	
	u_fConout(">>> Gravando arquivo " + cFile)
	
	lMove := .F.
	
	dbSelectArea("SA1")
	dbSelectArea("SA4")
	dbSelectArea("SC5")
	dbSelectArea("SZ6")
	dbSelectArea("SZ7")
	
	If Empty(cPedCli)
		cError := "Numero do pedido nao e valido"
	ElseIf lFila .And. SZ6->(dbSeek(XFILIAL("SZ6")+cPedCli))  // Na gravação da fila valida se o pedido já foi importado
		lMove  := .T.
		cError := "Pedido de venda ja foi importado"
	Else
		SA1->(dbSetOrder(1))
		If Empty(cCodCli) .Or. !SA1->(dbSeek(XFILIAL("SA1")+cCodCli+cLojCli))
			cCodCli := PADR(oXML:_Pedido:_cab_pedido:_CodigoCliente:text,TamSX3("A1_XDEALER")[1])
			SA1->(dbOrderNickName("DEALER"))
			If Empty(cCodCli) .Or. !SA1->(dbSeek(XFILIAL("SA1")+cCodCli))
				cError := "Cliente do pedido nao esta cadastrado"
			Endif
		Endif
	Endif
	
	If !Empty(cError) //Caso não tenha ocorrido erro
		Return .F.
	ElseIf lFila     // Se for gravar a fila de processamento
		//Realiza a separação do arquivo ja devolvendo extensão, pasta, etc
		SplitPath(cFile, @cDrive, @cDir, @cNome, @cExt)
		
		// Adiciona o registro de pedido importado
		RecLock("SZ0",.T.)
		SZ0->Z0_FILIAL  := XFILIAL("SZ0")
		SZ0->Z0_ID      := CriaVar("Z0_ID"  ,.T.)
		SZ0->Z0_ROTINA  := "MATA410"
		SZ0->Z0_DATA    := CriaVar("Z0_DATA",.T.)
		SZ0->Z0_HORA    := CriaVar("Z0_HORA",.T.)
		SZ0->Z0_USER    := __cUserID
		SZ0->Z0_PATH    := cDrive + cDir
		SZ0->Z0_FILE    := cNome + cExt
		SZ0->Z0_XML     := cXML
		SZ0->Z0_PASTA   := "pedidos"
		SZ0->Z0_PREFIXO := "pedidos"
		SZ0->Z0_OPER    := "2"    // 1=Arq.Enviado, 2=Arq.Recebido
		SZ0->Z0_HASH    := cHash
		MsUnLock()
		
		ConfirmSX8()
		
		// Processa a gravação da fila de processamento do pedido
		RecLock("SZ6",.T.)
		SZ6->Z6_FILIAL  := XFILIAL("SZ6")
		SZ6->Z6_PEDIDO  := cPedCli
		SZ6->Z6_CLIENTE := cCodCli
		SZ6->Z6_LOJA    := cLojCli
		SZ6->Z6_TIPO    := cTpoPed
		SZ6->Z6_PRIORI  := Posicione("SZ7",4,XFILIAL("SZ7")+cTpoPed,"Z7_PRIORI")    // Pesquisa a prioridade
		SZ6->Z6_DTIMP   := StoD(StrTran(cDatPed,"-",""))
		SZ6->Z6_HRIMP   := cHorPed
		SZ6->Z6_XML     := cXML
		SZ6->Z6_FILE    := cFile
		SZ6->Z6_STATUS  := "1"    // Pendente
		MsUnLock()
		
		lMove := .T.
		
		If IsBlind()
			u_fConout("Pedido " + Trim(cPedCli) + " adicionado com sucesso a fila de processamento de pedidos !")
		Else
			__aMsg[4] += If( Empty(__aMsg[4]) , "", ", ") + Trim(cPedCli)
		Endif
		
		Return .T.
	Endif
	
	// Pesquisa se o pedido já foi importado
	SC5->(dbOrderNickName("PEDORI"))
	If SC5->(dbSeek(XFILIAL("SC5")+cPedCli))
		cNumPed := SC5->C5_NUM
	Endif
	
	lMsErroAuto := .F.
	
	If Empty(cNumPed)
		aItems := oXML:_Pedido:_itm_pedido
		If ValType(aItems) <> "A"
			aItems := {}
			AAdd( aItems , oXML:_Pedido:_itm_pedido )
		Endif
		
		cItem     := StrZero(0,TamSX3("C6_ITEM")[1])
		cOperacao := If( cTpoPed == "N" , cOpePrd, cOpeGar)
		
		For nY:=1 To Len(aItems)
			
			SB1->(dbSetOrder(1))
			If !SB1->(dbSeek(XFILIAL("SB1")+PADR(aItems[nY]:_CodigoProduto:text,TamSX3("B1_COD")[1])))
				cError := "Produto " + Trim(aItems[nY]:_CodigoProduto:text) + " não cadastrado no sistema !"
				aSC6   := {}
				Exit
			Endif
			
			nQuant  := Val( aItems[nY]:_QtdePortal:text )
			nPreco  := Val( aItems[nY]:_PrecoPortal:text )
			cIteOri := aItems[nY]:_ItemPortal:text
			nQtdLib := 0  //SaldoPedido(aSaldos,nQuant)   // Calcula a quantidade a liberar para o item
			
			aLinha := {}
			AAdd( aLinha , { "C6_ITEM"    , cItem:=Soma1(cItem) , Nil} )
			AAdd( aLinha , { "C6_PRODUTO" , SB1->B1_COD         , Nil} )
			AAdd( aLinha , { "C6_DESCRI"  , SB1->B1_DESC        , Nil} )
			AAdd( aLinha , { "C6_QTDVEN"  , nQuant              , Nil} )
			AAdd( aLinha , { "C6_PRCTAB"  , nPreco              , Nil} )
			AAdd( aLinha , { "C6_PRCVEN"  , nPreco              , Nil} )
			AAdd( aLinha , { "C6_VALOR"   , nQuant * nPreco     , Nil} )
			AAdd( aLinha , { "C6_ENTREG"  , dDataBase           , Nil} )
			AAdd( aLinha , { "C6_UM"      , SB1->B1_UM          , Nil} )
			
			If !Empty(SB1->B1_SEGUM)
				AAdd( aLinha , { "C6_SEGUM"   , SB1->B1_SEGUM   , Nil} )
			Endif
			
			AAdd( aLinha , { "C6_QTDLIB"  , nQtdLib             , Nil} )
			AAdd( aLinha , { "C6_LOCAL"   , SB1->B1_LOCPAD      , Nil} )
			AAdd( aLinha , { "C6_CLI"     , SA1->A1_COD         , Nil} )
			AAdd( aLinha , { "C6_LOJA"    , SA1->A1_LOJA        , Nil} )
			
			AAdd( aLinha , { "C6_XITEORI" , cIteOri             , Nil} )
			AAdd( aLinha , { "C6_OP"      , cOperacao           , Nil} )
			
			aDadosCfo := {}
			AAdd( aDadosCfo , { "OPERNF"  , "S"           })
			AAdd( aDadosCfo , { "TPCLIFOR", SA1->A1_TIPO  })
			AAdd( aDadosCfo , { "UFDEST"  , SA1->A1_EST   })
			AAdd( aDadosCfo , { "INSCR"   , SA1->A1_INSCR })
			
			AAdd( aCols , Array(Len(aHeader)+1) )
			For nI:=1 To Len(aHeader)
				aCols[nY,nI] := CriaVar(aHeader[nI,2],.T.)
			Next
			aCols[nY,Len(aHeader)+1] := .F.
			For nI:=1 To Len(aLinha)
				If (nPos := AScan( aHeader , {|x| Trim(x[2]) == aLinha[nI,1] }))
					aCols[nY,nPos] := aLinha[nI,2]
				Endif
			Next
			
			n    := nY
			cTES := MaTesInt(2,cOperacao,SA1->A1_COD,SA1->A1_LOJA,"C",SB1->B1_COD,"C6_TES")
			
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+cTES))
			
			AAdd( aLinha , { "C6_TES"     , cTES                , Nil} )
			AAdd( aLinha , { "C6_CF"      , MaFisCfo(,SF4->F4_CF,aDadosCfo) , Nil} )
			
			AAdd( aSC6 , aClone(aLinha) )
		Next
		
		If !Empty(aSC6)
			// Variavel que controla numeracao
			nSaveSX8 := GetSx8Len()
			cNumPed  := ""
			
			SC5->(dbSetOrder(1))
			While Empty(cNumPed) .Or. SC5->(dbSeek(XFILIAL("SC5")+cNumPed))
				ConfirmSX8()
				cNumPed := GetSXENum("SC5","C5_NUM")   // Pega o próximo pedido de venda
			Enddo
			
			RollBAckSx8()
			
			AAdd( aSC5 , { "C5_NUM"     , cNumPed         , Nil} )
			AAdd( aSC5 , { "C5_TIPO"    , "N"             , Nil} )
			AAdd( aSC5 , { "C5_CLIENTE" , SA1->A1_COD     , Nil} )
			AAdd( aSC5 , { "C5_LOJACLI" , SA1->A1_LOJA    , Nil} )
			AAdd( aSC5 , { "C5_CLIENT"  , SA1->A1_COD     , Nil} )
			AAdd( aSC5 , { "C5_LOJAENT" , SA1->A1_LOJA    , Nil} )
			AAdd( aSC5 , { "C5_EMISSAO" , dDataBase       , Nil} )
			AAdd( aSC5 , { "C5_CONDPAG" , cCondPag        , Nil} )
			AAdd( aSC5 , { "C5_TABELA"  , u_BJCodTab("")  , Nil} )
			AAdd( aSC5 , { "C5_MOEDA"   , 1               , Nil} )
			AAdd( aSC5 , { "C5_TIPOCLI" , SA1->A1_TIPO    , Nil} )
			AAdd( aSC5 , { "C5_TIPLIB"  , "2"             , Nil} )
			AAdd( aSC5 , { "C5_LIBEROK" , "S"             , Nil} )
			AAdd( aSC5 , { "C5_XPEDORI" , cPedCli         , Nil} )
			
			// Pesquisa a transportadora
			SA4->(dbSetOrder(1))
			If !Empty(cTransp) .And. SA4->(dbSeek(XFILIAL("SA4")+cTransp))
				AAdd( aSC5 , { "C5_TRANSP" , cTransp      , Nil} )
			Endif
			
			u_fConout("Gravando pedido " + cNumPed)
			MSExecAuto({|x,y,Z| Mata410(x,y,Z)}, aSC5, aSC6, 3)
			
			If lMsErroAuto
				// Confirma SX8
				While ( GetSx8Len() > nSaveSX8 )
					RollBAckSx8()
				Enddo
				
				If IsBlind()
					cFalha := ResumeErro(MostraErro("\","Error.log"))
					u_fConout(">>> " + cFalha)
					cError += If( Empty(cError) , "", ", ") + cFalha
				Else
					MostraErro()
					cError += If( Empty(cError) , "", ", ") + Trim(cPedCli)
				Endif
			Else
				cNumPed := SC5->C5_NUM
				
				// Confirma SX8
				While ( GetSx8Len() > nSaveSX8 )
					ConfirmSX8()
				Enddo
				
				// Liberacao de pedido
				//Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
				// Checa itens liberados
				//Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
				// Carrega os itens do pedido
				//CarregaPedido(cNumPed,aLib)
			Endif
		Endif
	Endif
	
	If !lMsErroAuto
		CarregaPedido(cNumPed,aLib)
		
		// Processa a liberação dos itens aptos
		For nI:=1 To Len(aLib)
			
			SC6->(dbGoTo(aLib[nI,1]))   // Posiciona no registro
			
			// Posiciona no Cadastro do Produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+SC6->C6_PRODUTO))
			
			nQtdLib := SaldoPedido(aSaldos,aLib[nI,2] - aLib[nI,3])   // Calcula a quantidade a liberar para o item
			
			If nQtdLib > 0
				u_BJMaLibDoFat(;
						SC6->(RecNo()),; //nRegSC6
						nQtdLib,;        //nQtdaLib
						,;               //lCredito
						,;               //lEstoque
						.T.,;            //lAvCred
						.T.,;            //lAvEst
						.F.,;            //lLibPar
						.F.;             //lTrfLocal
				)
				
				aLib[nI,3] := Liberado()   // Recalcula a quantidade liberada para o item
			Endif
		Next
		
		If AScan( aLib , {|x| x[2] > 0 })  // Caso tenha itens em aberto
			// Identifica se o pedido foi totalmente liberado
			aEval( aLib , {|x| lLiberOk := ( lLiberOk .And. x[3] >= x[2] ) } )
			
			//Define que o pedido foi liberado
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := If( lLiberOk , "S", " ")
			MsUnlock()
		Endif
		
		// Atualiza o status da integração
		SZ6->(dbSetOrder(1))
		If SZ6->(dbSeek(XFILIAL("SZ6")+cPedCli))
			RecLock("SZ6",.F.)
			SZ6->Z6_STATUS := If( lLiberOk , "3", "2")    // Processado ou Pendente
			MsUnLock()
		Endif
		
		If !IsBlind()
			__aMsg[2] += If( Empty(__aMsg[2]) , "", ", ") + Trim(cPedCli)
			
			If Empty(__aMsg[3])
				__aMsg[3] := If(Empty(aBloqueio).And.!Empty(aPvlNfs),"", "Obs: Pedido possui bloqueio de liberação.")
			Endif
		Endif
	Endif

Return !lMsErroAuto

Static Function CarregaPedido(cNumPed,aLib)
	
	// Posiciona no Pedido de Venda
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(XFILIAL("SC5")+cNumPed))
	
	// Posiciona nos Itens do Pedido de Venda
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.T.))
	While !SC6->(Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
		
		AAdd( aLib , { SC6->(Recno()), SC6->C6_QTDVEN - SC6->C6_QTDENT, Liberado()})
		
		SC6->(dbSkip())
	Enddo

Return

Static Function SaldoPedido(aSaldos,nQuant)
	Local nQtdLib := 0
	Local nPos    := AScan( aSaldos , {|x| x[1] == XFILIAL("SB2")+SB1->B1_COD+SB1->B1_LOCPAD } )
	
	If nQuant > 0
		If nPos == 0
			AAdd( aSaldos , { XFILIAL("SB2")+SB1->B1_COD+SB1->B1_LOCPAD, 0})
			nPos := Len(aSaldos)
			
			SB2->(dbSetOrder(1))
			If SB2->(dbSeek(aSaldos[nPos,1]))
				aSaldos[nPos,2] := Max(0,SB2->B2_QATU - SB2->B2_RESERVA)
			Endif
		Endif
		
		// Calcula a quantidade a liberar para o item
		nQtdLib := If( nQuant <= aSaldos[nPos,2] , nQuant, aSaldos[nPos,2])
		// Atualiza o saldo disponível para o item
		aSaldos[nPos,2] := Max(0,aSaldos[nPos,2] - nQtdLib)
		// Ajusta a quantidade a liberar caso esteja zeradot	
		nQtdLib := If( nQtdLib == 0 , nQuant, nQtdLib)
	Endif

Return nQtdLib

Static Function Liberado()
	Local cSeek := SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM
	Local nRet  := 0
	
	SC9->(dbSetOrder(1))
	SC9->(dbSeek(cSeek,.T.))
	While !SC9->(Eof()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO+SC9->C9_ITEM == cSeek
		If Empty(SC9->C9_NFISCAL+SC9->C9_BLCRED+SC9->C9_BLEST)
			nRet += SC9->C9_QTDLIB
		Endif
		SC9->(dbSkip())
	Enddo

Return nRet

/*User Function FATA01Legend( cAlias, nRecNo, nOpc )
	BRWLEGENDA(cCadastro,"Integração EAI Protheus",;
								{{"ENABLE","Integração pendente" },;
								{"BR_AMARELO","Integração processada com ressalvas" },;
								{"DISABLE","Integração processada"}})
Return*/

Static Function ConfigEmpresa(cFil)
	cFilAnt := PADR(AllTrim(cFil),Len(SA1->A1_FILIAL))
	
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))
	
Return

Static Function LoadFile(cFile)
	Local cRet := ""
	
	If File(cFile)
		fHandle := FT_FUSE(cFile)
		FT_FGOTOP()
		While !FT_FEOF()
			cRet += FT_FREADLN()
			FT_FSKIP()
		Enddo
		FT_FUSE()
	Endif

Return cRet

Static Function ResumeErro(cErro)
Local nPos, cLinha, cAux
Local lCopia := .T.
Local cRet   := ""
Local cBkp   := ""

Default cErro := ""
cAux := cErro

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

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATA01Start¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 02/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicia o serviço de atualização do JOB                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATA01Start(aParam)
	Local aFile := { __cPathSrv+"\", Nil}
	
	Default aParam := {"01","01"}
	
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO "FAT" TABLES "SB1", "SB2", "SA1", "DA1"
	
	u_fConout(Replicate("=",80))
	u_fConout("Iniciada importacao dos XMLs dos Pedidos ")
	ImpPedido(aFile[1],aFile[2])
	u_fConout("Finalizada importacao dos XMLs dos Pedidos ")
	u_fConout(Replicate("=",80))
	
	RESET ENVIRONMENT
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATA01Start¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 02/01/2025 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicia o serviço de atualização do JOB                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATA01Exec(aParam)
	
	Default aParam := {"01","01"}
	
	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2] MODULO "FAT" TABLES "SB1", "SB2", "SA1", "DA1"
	
	u_fConout(Replicate("=",80))
	u_fConout("Iniciada Execucao da fila de Pedidos")
	u_BJExecFila()
	u_fConout("Finalizada Execucao da fila de Pedidos")
	u_fConout(Replicate("=",80))
	
	RESET ENVIRONMENT
	
Return
