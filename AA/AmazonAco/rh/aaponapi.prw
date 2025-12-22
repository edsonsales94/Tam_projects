#Include 'Prtopdef.ch'
#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
//-------------------------------------------------------------------
/***************************************************
FUNÇÂO AAPONAPI
** Busca os Relogios e ops IPS na tabela SP0
faz a integração de login para iniciar a ssesion,
a session é um token usado para acessar as demais
rotas enquanto estiver valida.
****************************************************/
//-------------------------------------------------------------------
User function AAPONAPI()
	local aHeader as array
	local oRest as object
	local nStatus as numeric
	local cError as char
	local jBody,cRel,cXIP
	local cSession := ""
	// Local aRep := {{'https://10.1.103.253'}}
	Local cAlias := GetNextAlias()

	// RpcSetType(3)
	// RpcSetEnv('01','01')

	// quary para buscar os relogios cadastrados e os seus iP's
	BeginSQL Alias cAlias
		SELECT 'REP'+P0_RELOGIO RELOGIO ,P0_XIP FROM %table:SP0% SP0 (NOLOCK)
		WHERE SP0.%NotDel% and P0_XIP != ''
	EndSql
	
    /*
	BeginSQL Alias cAlias
	SELECT 'REP'+P0_RELOGIO RELOGIO ,P0_XIP FROM SP0010 SP0 (NOLOCK)
		WHERE SP0.D_E_L_E_T_='' and P0_XIP != ''
    UNION ALL
    SELECT 'REP'+P0_RELOGIO RELOGIO ,P0_XIP FROM SP0070 SP0 (NOLOCK)
    WHERE SP0.D_E_L_E_T_='' and P0_XIP != ''
    UNION ALL
    SELECT 'REP'+P0_RELOGIO RELOGIO ,P0_XIP FROM SP0080 SP0 (NOLOCK)
    WHERE SP0.D_E_L_E_T_='' and P0_XIP !=''
	EndSql
    */


	dbGotop()

	// percorre os relogio encontrados tebela SP0
	while !(cAlias)->(EoF())

		aHeader := {}
		cRel := (calias)->RELOGIO
		cXIP := 'https://'+alltrim((calias)->P0_XIP)

		if cXIP == 'https://192.168.17.6'
			cXIP := cXIP+':9006'
		Endif

		oRest := FWRest():New(cXIP)

		//Endpoint
		oRest:setPath("/login.fcgi" )
		//Cabeçalho de requisição
		aAdd(aHeader,"Accept-Encoding: UTF-8")
		aAdd(aHeader,"Content-Type: application/json; charset=utf-8")

		// parametros da requisição.
		jBody := JsonObject():New()
		jBody["login"] := "admin"
		jBody["password"] := "admin"
		oRest:SetPostParams(jBody:toJson())
		oRest:SetChkStatus(.F.)

		if oRest:Post(aHeader)
			cError := ""
			nStatus := HTTPGetStatus(@cError)
			// se status for entre 200 e 299 conseguiu integrar.
			if nStatus >= 200 .And. nStatus <= 299
				if Empty(oRest:getResult())
					MsgInfo('Status',nStatus)
				else
					// resgata a session para acessar as rotas dos registros.
					cSession := oRest:getResult()
					// função que faz a requisição dos registros no relogio
					BuscReg(cSession,cXIP,cRel)
					MsgInfo('Result',oRest:getResult())
				endif
			else
				MsgStop(cError)
			endif
		else		
			MsgStop(oRest:getLastError())
		endif
		// encerrar a session atual.
		Encerrar(cSession,cXIP,cRel)
		(cAlias)->(dbSkip())
	endDo
return nil

/***************************************************
função que faz a requisição dos registros no relogio,
Edson Sales
20/12/2024
Parametros: Session / IP do relogio / nome do relogio.
****************************************************/
Static Function BuscReg(cSession,cXIP,cRel)

	Local oSession
	Local oRestBus
	Local aHeader := {}

	oRestBus := FWRest():New(cXIP)
	//Endpoint
	oSession := JsonObject():new()
	oSession:FromJson(cSession)
	cSession := oSession['session']

	oRestBus:setPath("/get_afd.fcgi?session=" +cSession )

	//Cabeçalho de requisição
	aAdd(aHeader,"Accept-Encoding: UTF-8")
	aAdd(aHeader,"Content-Type: application/json; charset=utf-8")

	if oRestBus:Post(aHeader)
		cError := ""
		nStatus := HTTPGetStatus(@cError)

		if nStatus >= 200 .And. nStatus <= 299

			if Empty(oRestBus:getResult())
				MsgInfo('Status',nStatus)
			else
				// retorna os registros do relogio.
				cRegistros := oRestBus:getResult()
				// função para escrever os registros em um arquivo TXT
				CriaTXT(cRegistros,cRel)
				MsgInfo('Result',oRestBus:getResult())
			endif
		else
			MsgStop(cError)
		endif
	else
		MsgStop(oRestBus:getLastError() )
	endif

Return

/***************************************************
Função CriaTXT
função para escrever os registros em um arquivo TXT.
Edson Sales
20/12/2024
****************************************************/
Static Function CriaTXT(cDados,cRelogio)
	Local nH
	Local cFile := "\system\"+cRelogio+".txt"

	if File( cFile, , .F. )
		FErase( cFile,, .F. )
	Endif
	nH := fCreate(cFile,,,.F.)
	If nH == -1
		MsgStop("Falha ao criar arquivo - erro "+str(ferror()))
		Return
	Endif

	fWrite(nH,cDados)

	fClose(nH)

	Msginfo("Arquivo criado :" + cFile)

Return

/***************************************************
Função para encerrar a session do relogio logado.
Edson Sales
23/12/2024
****************************************************/
Static Function Encerrar(cSession,cXIP,cRel)
	Local aHeader := {}
	local oRest as object
	local oSession as object
	local nStatus as numeric
	local cError as char


// sair da sessão
	oRest := FWRest():New(cXIP)
	oSession := JsonObject():new()
	oSession:FromJson(cSession)
	cSession := oSession['session']

	//Endpoint
	oRest:setPath("/logout.fcgi?session=" +cSession)

	//Cabeçalho de requisição
	aAdd(aHeader,"Accept-Encoding: UTF-8")
	aAdd(aHeader,"Content-Type: application/json; charset=utf-8")

	if oRest:Post(aHeader)
		cError := ""
		nStatus := HTTPGetStatus(@cError)

		if nStatus >= 200 .And. nStatus <= 299
			if Empty(oRest:getResult())
				MsgInfo('Status',nStatus)
			else
				// BuscReg(cSession,cXIP,cRel)
				MsgInfo('Result',oRest:getResult())
			endif
		else
			MsgStop(cError)
		endif
	else
		MsgStop(oRest:getLastError())
	endif
Return

// Static Function REPLOG(cREPLOG)
// 	local cFileLog := '\System\REPLOG.txt'
// 	// Abre o arquivo
// 	if File( cFileLog, , .F. )
// 		nHandle := fopen( cFileLog, 2 )
// 	else
// 		nHandle := fCreate(cFileLog,,,.F.)
// 	Endif
// 	If nHandle == -1
// 		return
// 	Else
// 		FSeek(nHandle, 0, 2)         	    // Posiciona no fim do arquivo
// 		FWrite(nHandle, cREPLOG, 10) 		// Insere texto no arquivo
// 		fclose(nHandle)                   	// Fecha arquivo
// 	Endif
// Return 
