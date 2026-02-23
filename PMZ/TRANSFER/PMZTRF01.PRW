//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} WSRESTFUL xWsTranfFil
Exemplo de Webservice usando REST
@author Edson Sales
@since 13/02/2026
@version 1.0
@see https://tdn.totvs.com/display/public/framework/WSRESTFUL
@obs 
 
    **** Apoie nosso projeto, se inscreva em https://www.youtube.com/TerminalDeInformacao ****
/*/

WSRESTFUL xWsTranfFil DESCRIPTION 'WebService Tranferencia entre filiais.'
	//Atributos
	WSDATA CODETI   AS STRING
	WSDATA DTINICIO AS STRING
	WSDATA DTFIM    AS STRING
	WSDATA limit    AS INTEGER
	WSDATA page     AS INTEGER

	// POST
	WSMETHOD POST tranfer_fil	DESCRIPTION 'Incluir tranferencia'	WSSYNTAX ' xWsTranfFil/tranfer_fil'	PATH 'tranfer_fil'	CONSUMES APPLICATION_JSON	PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD POST tranfer_fil WSRECEIVE WSSERVICE xWsTranfFil
	Local lRet              := .T.
	Local aDados            := {}
	Local cJson             := Self:GetContent()
	Local cError            := ''
	Local nLinha            := 0
	Local cDirLog           := '\rest1_logs\'
	Local cArqLog           := ''
	Local cErrorLog         := ''
	Local aLogAuto          := {}
	Local nCampo            := 0
	Local cSB1              := 'SB1'
	Local cAliasCB0         := GetNextAlias()
	Private jJson             := Nil
	Private jResponse         := JsonObject():New()
	Private lMsHelpAuto     := .T.
	Private lAutoErrNoFile  := .T.

	//Se não existir a pasta de logs, cria
	IF ! ExistDir(cDirLog)
		MakeDir(cDirLog)
	EndIF

	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	Self:SetContentType('application/json')
	jJson  := JsonObject():New()
	cError := jJson:FromJson(cJson)

	// Valida Body
	If Empty(cJson)
		Self:SetStatus(400)
		jResponse['error'] := 'Body vazio'
		Self:SetResponse(jResponse:ToJson())
		Return lRet
	EndIf

	// Validacao basica.
	If !jJson:HasProperty('produto') ;
			.or. !jJson:HasProperty('filOrig');
			.or. !jJson:HasProperty('locOrig');
			.or. !jJson:HasProperty('tesSaida');
			.or. !jJson:HasProperty('tesEntrada');
			.or. !jJson:HasProperty('filDest');
			.or. !jJson:HasProperty('locDest')

		Self:SetStatus(400)
		jResponse['error'] := 'algum campo obrigatorio não foi informado.'
		Self:SetResponse(jResponse:ToJson())
		Return lRet
	EndIf

	//Se tiver algum erro no Parse, encerra a execução
	IF ! Empty(cError)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW004'
		jResponse['error']    := 'Parse do JSON'
		jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

	Else
		DbSelectArea(cSB1)
		SB1->(DbSetOrder(1))

		//Adiciona os dados do ExecAuto
		cProduto :=    jJson:GetJsonObject('produto')
		nQuant   :=    jJson:GetJsonObject('quantidade')
		cOper    :=    jJson:GetJsonObject('operador')

		// ==============================
		// Pesquisa produto.
		// ==============================
		SB1->(msseek(xFilial(cSB1)+cProduto))

		If Empty(SB1->B1_COD)
			Self:SetStatus(404)
			jResponse['error'] := 'Produto informado não encontrado no PROTHEUS.'
			Self:SetResponse(EncodeUTF8(jResponse:ToJson()))
			Return .F.
		Else
			// FAZER EXEC AUTO NA ROTINA MATA311
			if zFazExec()
				Self:SetStatus(201)
				jResponse['success'] := .T.
				jResponse['message'] := 'Registro incluído com sucesso'
			Else
				Return .F.
			EndIf
		EndIf

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

/*
Exemplo de inclusão de uma solicitação de transferência via rotina automática
*/

User Function zFazExec()
	Local oModel
	Local aLog
	Local cMensLog
	Local nX
	local lRet := .F.

	cProdut := jJson:GetJsonObject('produto')
	cFilOrg := jJson:GetJsonObject('filOrig')
	cLocOrg := jJson:GetJsonObject('locOrig')
	cTesSai := jJson:GetJsonObject('tesSaida')
	cTesEnt := jJson:GetJsonObject('tesEntrada')
	cFilDes := jJson:GetJsonObject('filDest')
	cLocDes := jJson:GetJsonObject('locDest')

	// PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'admin' PASSWORD '' MODULO "EST"

	oModel := FWLoadModel("MATA311") //Carrega o modelo
	oModel:SetOperation(MODEL_OPERATION_INSERT) // Seta operação de inclusão
	oModel:Activate() // Ativa o Modelo

	//Cabeçalho da solicitacao
	oModel:SetValue( 'NNSMASTER', 'NNS_CLASS', '1' )
	oModel:SetValue( 'NNSMASTER', 'NNS_ESPECI', ' ' )

	//Itens da solicitação
	// produto e local de origem
	oModel:SetValue( 'NNTDETAIL', 'NNT_FILORI', '01' )
	oModel:SetValue( 'NNTDETAIL', 'NNT_PROD', 'PRO001' )
	oModel:SetValue( 'NNTDETAIL', 'NNT_LOCAL', '0A' )
	oModel:SetValue( 'NNTDETAIL', 'NNT_QUANT', 1 )

	// produto e local de destino
	oModel:SetValue( 'NNTDETAIL', 'NNT_FILDES', '01' )
	oModel:SetValue( 'NNTDETAIL', 'NNT_PRODD', 'PRO001' )
	oModel:SetValue( 'NNTDETAIL', 'NNT_LOCLD', '0B' )

	If oModel:VldData() //Validação do modelo
		oModel:CommitData() // Gravação do Modelo
		lRet := .T.
	Else

		aLog := oModel:GetErrorMessage() //Recupera o erro do model quando nao passou no VldData
		cMensLog := ''

//laco para gravar em string cLog conteudo do array aLog
		For nX := 1 to Len(aLog)
			If !Empty(aLog[nX])
				cMensLog += Alltrim(aLog[nX]) + CHR(13)+CHR(10)
			EndIf

		Next nX

		lMsErroAuto := .T. //seta variavel private como erro
		AutoGRLog(cMensLog) //grava log para exibir com funcao mostraerro
		// MostraErro()
		Self:SetStatus(404)
		jResponse['error'] := cMensLog
		Self:SetResponse(EncodeUTF8(jResponse:ToJson()))
		Return lRet
	EndIf

	oModel:DeActivate() //desativa modelo

Return lRet
