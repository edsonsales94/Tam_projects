//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL wsEtiquetas
Exemplo de Webservice usando REST
@author Atilio
@since 07/04/2022
@version 1.0
@see https://tdn.totvs.com/display/public/framework/WSRESTFUL
@obs 
 
    **** Apoie nosso projeto, se inscreva em https://www.youtube.com/TerminalDeInformacao ****
/*/

WSRESTFUL wsEtiquetas DESCRIPTION 'WebService Cadastro de Produtos'
	//Atributos
	WSDATA CODETI   AS STRING
	WSDATA DTINICIO AS STRING
	WSDATA DTFIM    AS STRING
	WSDATA limit    AS INTEGER
	WSDATA page     AS INTEGER

	//Métodos
	// GET'S
	WSMETHOD GET  CODETI    DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/wsEtiquetas/GET_ETIQ?{CODETI}' PATH 'GET_ETIQ'  PRODUCES APPLICATION_JSON
	WSMETHOD GET  ETIQ_ALL  DESCRIPTION 'Retorna todos os registros'    WSSYNTAX '/wsEtiquetas/GET_ETIQ_ALL?{limit, page}' PATH 'GET_ETIQ_ALL' PRODUCES APPLICATION_JSON
	WSMETHOD GET  DTINICIO    DESCRIPTION 'Retorna todos os registros por data'    WSSYNTAX '/wsEtiquetas/GET_ETIQ_DATA?{DTINICIO,DTFIM,limit, page}' PATH 'GET_ETIQ_DATA' PRODUCES APPLICATION_JSON

	// WSMETHOD GET  ETIQ_ALL DESCRIPTION 'Retorna todos os registros'     WSSYNTAX '/wsEtiquetas/GET_ETIQ_ALL?{updated_at, limit, page}' PATH 'GET_ETIQ_ALL' PRODUCES APPLICATION_JSON
	// POST
	WSMETHOD POST NEW_APONT	DESCRIPTION 'Insere apontamento'	WSSYNTAX '/wsEtiquetas/new'	PATH 'new'	CONSUMES APPLICATION_JSON	PRODUCES APPLICATION_JSON
	// WSMETHOD POST NEW DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/wsEtiquetas/new'                               PATH 'new'           PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ID
Busca registro via ID
@author Atilio
@since 07/04/2022
@version 1.0
@param id, Caractere, String que será pesquisada através do MsSeek
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

WSMETHOD GET CODETI WSRECEIVE CODETI WSSERVICE wsEtiquetas
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local cAliasWS   := 'CB0'

	//Se o CODETI estiver vazio
	If Empty(::CODETI)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorCodEti']  := 'CODETI'
		jResponse['error']    := 'CODETI vazio'
		jResponse['solution'] := 'Informe o CODETI'
	Else
		DbSelectArea(cAliasWS)
		(cAliasWS)->(DbSetOrder(1))

		//Se não encontrar o registro
		If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::CODETI))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID002'
			jResponse['error']    := 'ID não encontrado'
			jResponse['solution'] := 'Código ID não encontrado na tabela ' + cAliasWS
		Else
			//Define o retorno
			jResponse['filial'] 		:= (cAliasWS)->CB0_FILIAL
			jResponse['pedido'] 		:= (cAliasWS)->CB0_PEDVEN
			jResponse['itemPedido'] 	:= POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_ITEMPV')
			jResponse['emissaoPedido'] 	:= Posicione('SC5',1, xFilial('SC5')+(cAliasWS)->CB0_PEDVEN,'C5_EMISSAO')
			jResponse['dataEntrega'] 	:= Posicione('SC6',1, xFilial('SC6')+(cAliasWS)->CB0_PEDVEN+POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_ITEMPV'),'C6_ENTREG')

			jResponse['codigoCliente']	:= (cAliasWS)->CB0_CLI
			jResponse['nomeCliente'] 	:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_NOME')
			jResponse['lojacli'] 		:= (cAliasWS)->CB0_LOJACL
			jResponse['endereco']		:= (cAliasWS)->CB0_LOCALI
			jResponse['ufCliente'] 		:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_EST')
			jResponse['cidadeCliente'] 	:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_MUN')

			jResponse['etiqueta'] 		:= (cAliasWS)->CB0_CODETI
			jResponse['tipo'] 			:= (cAliasWS)->CB0_TIPO
			jResponse['dataEtiqueta']	:= (cAliasWS)->CB0_DTNASC
			jResponse['op'] 			:= (cAliasWS)->CB0_OP
			jResponse['emissoOp'] 		:= POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_EMISSAO')
			jResponse['produto'] 		:= (cAliasWS)->CB0_CODPRO
			jResponse['descricaoProduto']:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_DESC')
			jResponse['unidadeMedida']	:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_UM')
			jResponse['grupo'] 			:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_GRUPO')
			jResponse['quantidade']		:= (cAliasWS)->CB0_QTDE
			jResponse['armazemPedido']	:= (cAliasWS)->CB0_LOCAL
			// jResponse['valid'] 			:= (cAliasWS)->CB0_DTVLD
			// jResponse['etiq2'] 			:= (cAliasWS)->CB0_CODETI2
		EndIf
	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(jResponse:toJSON())
Return lRet

/*/{Protheus.doc} WSMETHOD GET ALL
Busca todos os registros através de paginação
@author Atilio
@since 07/04/2022
@version 1.0
@param updated_at, Caractere, Data de alteração no formato string 'YYYY-MM-DD' (somente se tiver o campo USERLGA / USERGA na tabela)
@param limit, Numérico, Limite de registros que irá vir (por exemplo trazer apenas 100 registros)
@param page, Numérico, Número da página que irá buscar (se existir 1000 registros dividido por 100 terá 10 páginas de pesquisa)
@obs Codigo gerado automaticamente pelo Autumn Code Maker
 
    Poderia ser usado o FWAdapterBaseV2(), mas em algumas versões antigas não existe essa funcionalidade
    então a paginação foi feita manualmente
 
@see http://autumncodemaker.com
/*/

// WSMETHOD GET ETIQ_ALL WSRECEIVE updated_at, limit, page WSSERVICE wsEtiquetas
WSMETHOD GET ETIQ_ALL WSRECEIVE limit, page WSSERVICE wsEtiquetas
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local cQueryTab  := ''
	Local nTamanho   := 10
	Local nTotal     := 0
	Local nPags      := 0
	Local nPagina    := 0
	Local nAtual     := 0
	Local oRegistro
	Local cAliasWS   := 'CB0'

	//Efetua a busca dos registros
	cQueryTab := " SELECT " + CRLF
	cQueryTab += "     TAB.R_E_C_N_O_ AS TABREC " + CRLF
	cQueryTab += " FROM " + CRLF
	cQueryTab += "     " + RetSQLName(cAliasWS) + " TAB " + CRLF
	cQueryTab += " WHERE " + CRLF
	cQueryTab += "     TAB.D_E_L_E_T_ = '' " + CRLF
	// If ! Empty(::updated_at)
	//     cQueryTab += "     AND ((CASE WHEN SUBSTRING(B1_USERLGA, 03, 1) != ' ' THEN " + CRLF
	//     cQueryTab += "        CONVERT(VARCHAR,DATEADD(DAY,((ASCII(SUBSTRING(B1_USERLGA,12,1)) - 50) * 100 + (ASCII(SUBSTRING(B1_USERLGA,16,1)) - 50)),'19960101'),112) " + CRLF
	//     cQueryTab += "        ELSE '' " + CRLF
	//     cQueryTab += "     END) >= '" + StrTran(::updated_at, '-', '') + "') " + CRLF
	// EndIf
	cQueryTab += " ORDER BY " + CRLF
	cQueryTab += "     TABREC " + CRLF
	TCQuery cQueryTab New Alias 'QRYALL'

	//Se não encontrar registros
	If QRYALL->(EoF())
		//SetRestFault(500, 'Falha ao consultar registros') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'ETIQ_ALL'
		jResponse['error']    := 'Registro(s) nao encontrado(s)'
		jResponse['solution'] := 'A consulta de registros nao retornou nenhuma informacao'
	Else
		jResponse['objects'] := {}

		//Conta o total de registros
		Count To nTotal
		QRYALL->(DbGoTop())

		//O tamanho do retorno, será o limit, se ele estiver definido
		If ! Empty(::limit)
			nTamanho := ::limit
		EndIf

		//Pegando total de páginas
		nPags := NoRound(nTotal / nTamanho, 0)
		nPags += Iif(nTotal % nTamanho != 0, 1, 0)

		//Se vier página
		If ! Empty(::page)
			nPagina := ::page
		EndIf

		//Se a página vier zerada ou negativa ou for maior que o máximo, será 1
		If nPagina <= 0 .Or. nPagina > nPags
			nPagina := 1
		EndIf

		//Se a página for diferente de 1, pula os registros
		If nPagina != 1
			QRYALL->(DbSkip((nPagina-1) * nTamanho))
		EndIf

		//Adiciona os dados para a meta
		jJsonMeta := JsonObject():New()
		jJsonMeta['total']         := nTotal
		jJsonMeta['current_page']  := nPagina
		jJsonMeta['total_page']    := nPags
		jJsonMeta['total_items']   := nTamanho
		jResponse['meta'] := jJsonMeta

		//Percorre os registros
		While ! QRYALL->(EoF())
			nAtual++

			//Se ultrapassar o limite, encerra o laço
			If nAtual > nTamanho
				Exit
			EndIf

			//Posiciona o registro e adiciona no retorno
			DbSelectArea(cAliasWS)
			(cAliasWS)->(DbGoTo(QRYALL->TABREC))

			oRegistro := JsonObject():New()
			//Define o retorno
			//Define o retorno
			oRegistro['filial'] 		:= (cAliasWS)->CB0_FILIAL
			oRegistro['pedido'] 		:= (cAliasWS)->CB0_PEDVEN
			oRegistro['itemPedido'] 	:= POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_ITEMPV')
			oRegistro['emissaoPedido'] 	:= Posicione('SC5',1, xFilial('SC5')+(cAliasWS)->CB0_PEDVEN,'C5_EMISSAO')
			oRegistro['dataEntrega'] 	:= Posicione('SC6',1, xFilial('SC6')+(cAliasWS)->CB0_PEDVEN+POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_ITEMPV'),'C6_ENTREG')

			oRegistro['codigoCliente']	:= (cAliasWS)->CB0_CLI
			oRegistro['nomeCliente'] 	:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_NOME')
			oRegistro['lojacli'] 		:= (cAliasWS)->CB0_LOJACL
			oRegistro['endereco']		:= (cAliasWS)->CB0_LOCALI
			oRegistro['ufCliente'] 		:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_EST')
			oRegistro['cidadeCliente'] 	:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_MUN')

			oRegistro['etiqueta'] 		:= (cAliasWS)->CB0_CODETI
			oRegistro['tipo'] 			:= (cAliasWS)->CB0_TIPO
			oRegistro['dataEtiqueta']	:= (cAliasWS)->CB0_DTNASC
			oRegistro['op'] 			:= (cAliasWS)->CB0_OP
			oRegistro['emissoOp'] 		:= POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_EMISSAO')
			oRegistro['produto'] 		:= (cAliasWS)->CB0_CODPRO
			oRegistro['descricaoProduto']:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_DESC')
			oRegistro['unidadeMedida']	:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_UM')
			oRegistro['grupo'] 			:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_GRUPO')
			oRegistro['quantidade']		:= (cAliasWS)->CB0_QTDE
			oRegistro['armazemPedido']	:= (cAliasWS)->CB0_LOCAL
			// oRegistro['valid'] 			:= (cAliasWS)->CB0_DTVLD
			// oRegistro['etiq2'] 			:= (cAliasWS)->CB0_CODETI2

			// oRegistro['etiqueta'] := (cAliasWS)->CB0_CODETI
			// oRegistro['dtnasc'] := (cAliasWS)->CB0_DTNASC
			// oRegistro['tipo'] := (cAliasWS)->CB0_TIPO
			// oRegistro['produto'] := (cAliasWS)->CB0_CODPRO
			// oRegistro['descprod'] := POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_DESC')
			// oRegistro['um'] := POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_UM')
			// oRegistro['grupo'] := POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_GRUPO')
			// oRegistro['qtd'] := (cAliasWS)->CB0_QTDE
			// oRegistro['local'] := (cAliasWS)->CB0_LOCAL
			// oRegistro['ender'] := (cAliasWS)->CB0_LOCALI
			// oRegistro['valid'] := (cAliasWS)->CB0_DTVLD
			// oRegistro['etiq2'] := (cAliasWS)->CB0_CODETI2
			// oRegistro['fornec'] := (cAliasWS)->CB0_FORNEC
			// oRegistro['lojafor'] := (cAliasWS)->CB0_LOJAFO
			// oRegistro['pedven'] := (cAliasWS)->CB0_PEDVEN
			// oRegistro['cliente'] := (cAliasWS)->CB0_CLI
			// oRegistro['lojacli'] := (cAliasWS)->CB0_LOJACL

			aAdd(jResponse['objects'], oRegistro)

			QRYALL->(DbSkip())
		EndDo
	EndIf
	QRYALL->(DbCloseArea())

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(jResponse:toJSON())

Return lRet

// WSMETHOD GET ETIQ_ALL WSRECEIVE updated_at, limit, page WSSERVICE wsEtiquetas
WSMETHOD GET DTINICIO WSRECEIVE DTINICIO,DTFIM,limit, page WSSERVICE wsEtiquetas
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local cQueryTab  := ''
	Local nTamanho   := 10
	Local nTotal     := 0
	Local nPags      := 0
	Local nPagina    := 0
	Local nAtual     := 0
	Local oRegistro
	Local cAliasWS   := 'CB0'

	//Efetua a busca dos registros
	cQueryTab := " SELECT " + CRLF
	cQueryTab += "     TAB2.R_E_C_N_O_ AS TABREC " + CRLF
	cQueryTab += " FROM " + CRLF
	cQueryTab += "     " + RetSQLName(cAliasWS) + " TAB2 " + CRLF
	cQueryTab += " WHERE " + CRLF
	cQueryTab += "     TAB2.D_E_L_E_T_ = '' " + CRLF
	///&DTFIM=20180218
	If !Empty(::DTINICIO) .And. !Empty(::DTFIM) // SE PREECHER AS DUAS FAZ O BETEWEEN PRA PEGAR O RANGER
		cQueryTab += "   AND TAB2.CB0_DTNASC BETWEEN '" + ::DTINICIO + "' AND '" + ::DTFIM + "'" + CRLF
	ElseIf !Empty(::DTINICIO) // SE NÃO VERIFICA SE FOI INFORMADO DATA DE.
		cQueryTab += "   AND TAB2.CB0_DTNASC = '" + ::DTINICIO + "'" + CRLF
	ElseIf !Empty(::DTFIM)  // SE NÃO VERIFICA SE FOI INFORMADO DATA ATE.
		cQueryTab += "   AND TAB2.CB0_DTNASC = '" + ::DTFIM + "'" + CRLF
	else
		// como o parametro não foi informado, forço a query com uma data futura pra não trazer nada.
		cQueryTab += "   AND TAB2.CB0_DTNASC = '" + dtos(date()+365) + "'" + CRLF
	EndIf

	cQueryTab += " ORDER BY " + CRLF
	cQueryTab += "     TABREC " + CRLF
	TCQuery cQueryTab New Alias 'QRYDATA'

	//Se não encontrar registros
	If QRYDATA->(EoF())
		//SetRestFault(500, 'Falha ao consultar registros') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		cError := iif(Empty(::DTINICIO) .And. Empty(::DTFIM),'Os parametros DTINICIO/DTFIM, nao foram informados','Registro(s) nao encontrado(s)')
		jResponse['errorId']  := 'DTINICIO/DTFIM'
		jResponse['error']    := cError
		jResponse['solution'] := 'A consulta de registros nao retornou nenhuma informacao'
	Else
		jResponse['objects'] := {}

		//Conta o total de registros
		Count To nTotal
		QRYDATA->(DbGoTop())

		//O tamanho do retorno, será o limit, se ele estiver definido
		If ! Empty(::limit)
			nTamanho := ::limit
		EndIf

		//Pegando total de páginas
		nPags := NoRound(nTotal / nTamanho, 0)
		nPags += Iif(nTotal % nTamanho != 0, 1, 0)

		//Se vier página
		If ! Empty(::page)
			nPagina := ::page
		EndIf

		//Se a página vier zerada ou negativa ou for maior que o máximo, será 1
		If nPagina <= 0 .Or. nPagina > nPags
			nPagina := 1
		EndIf

		//Se a página for diferente de 1, pula os registros
		If nPagina != 1
			QRYDATA->(DbSkip((nPagina-1) * nTamanho))
		EndIf

		//Adiciona os dados para a meta
		jJsonMeta := JsonObject():New()
		jJsonMeta['total']         := nTotal
		jJsonMeta['current_page']  := nPagina
		jJsonMeta['total_page']    := nPags
		jJsonMeta['total_items']   := nTamanho
		jResponse['meta'] := jJsonMeta

		//Percorre os registros
		While ! QRYDATA->(EoF())
			nAtual++

			//Se ultrapassar o limite, encerra o laço
			If nAtual > nTamanho
				Exit
			EndIf

			//Posiciona o registro e adiciona no retorno
			DbSelectArea(cAliasWS)
			(cAliasWS)->(DbGoTo(QRYDATA->TABREC))

			oRegistro := JsonObject():New()
			//Define o retorno

			oRegistro['filial'] 		:= (cAliasWS)->CB0_FILIAL
			oRegistro['pedido'] 		:= (cAliasWS)->CB0_PEDVEN
			oRegistro['itemPedido'] 	:= POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_ITEMPV')
			oRegistro['emissaoPedido'] 	:= Posicione('SC5',1, xFilial('SC5')+(cAliasWS)->CB0_PEDVEN,'C5_EMISSAO')
			oRegistro['dataEntrega'] 	:= Posicione('SC6',1, xFilial('SC6')+(cAliasWS)->CB0_PEDVEN+POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_ITEMPV'),'C6_ENTREG')

			oRegistro['codigoCliente']	:= (cAliasWS)->CB0_CLI
			oRegistro['nomeCliente'] 	:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_NOME')
			oRegistro['lojacli'] 		:= (cAliasWS)->CB0_LOJACL
			oRegistro['endereco']		:= (cAliasWS)->CB0_LOCALI
			oRegistro['ufCliente'] 		:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_EST')
			oRegistro['cidadeCliente'] 	:= posicione('SA1',1, xFilial('SA1')+(cAliasWS)->CB0_CLI+(cAliasWS)->CB0_LOJACL,'A1_MUN')

			oRegistro['etiqueta'] 		:= (cAliasWS)->CB0_CODETI
			oRegistro['tipo'] 			:= (cAliasWS)->CB0_TIPO
			oRegistro['dataEtiqueta']	:= (cAliasWS)->CB0_DTNASC
			oRegistro['op'] 			:= (cAliasWS)->CB0_OP
			oRegistro['emissoOp'] 		:= POSICIONE('SC2',1,XFILIAL('SC2')+(cAliasWS)->CB0_OP,'C2_EMISSAO')
			oRegistro['produto'] 		:= (cAliasWS)->CB0_CODPRO
			oRegistro['descricaoProduto']:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_DESC')
			oRegistro['unidadeMedida']	:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_UM')
			oRegistro['grupo'] 			:= POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_GRUPO')
			oRegistro['quantidade']		:= (cAliasWS)->CB0_QTDE
			oRegistro['armazemPedido']	:= (cAliasWS)->CB0_LOCAL
			// oRegistro['valid'] 			:= (cAliasWS)->CB0_DTVLD
			// oRegistro['etiq2'] 			:= (cAliasWS)->CB0_CODETI2

			// oRegistro['etiqueta'] := (cAliasWS)->CB0_CODETI
			// oRegistro['dtnasc'] := (cAliasWS)->CB0_DTNASC
			// oRegistro['tipo'] := (cAliasWS)->CB0_TIPO
			// oRegistro['produto'] := (cAliasWS)->CB0_CODPRO
			// oRegistro['descprod'] := POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_DESC')
			// oRegistro['um'] := POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_UM')
			// oRegistro['grupo'] := POSICIONE('SB1',1,XFILIAL('SB1')+(cAliasWS)->CB0_CODPRO,'B1_GRUPO')
			// oRegistro['qtd'] := (cAliasWS)->CB0_QTDE
			// oRegistro['local'] := (cAliasWS)->CB0_LOCAL
			// oRegistro['ender'] := (cAliasWS)->CB0_LOCALI
			// oRegistro['valid'] := (cAliasWS)->CB0_DTVLD
			// oRegistro['etiq2'] := (cAliasWS)->CB0_CODETI2
			// oRegistro['fornec'] := (cAliasWS)->CB0_FORNEC
			// oRegistro['lojafor'] := (cAliasWS)->CB0_LOJAFO
			// oRegistro['pedven'] := (cAliasWS)->CB0_PEDVEN
			// oRegistro['cliente'] := (cAliasWS)->CB0_CLI
			// oRegistro['lojacli'] := (cAliasWS)->CB0_LOJACL

			aAdd(jResponse['objects'], oRegistro)

			QRYDATA->(DbSkip())
		EndDo
	EndIf
	QRYDATA->(DbCloseArea())

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(jResponse:toJSON())

Return lRet

// rota post
WSMETHOD POST NEW_APONT WSSERVICE wsEtiquetas

	Local lRet      := .T.
	Local oJsonIn   := Nil
	Local oJsonOut  := JsonObject():New()
	Local cBody     := Self:GetContent()
	Local cAliasWS  := 'ZZJ'

	// Valida Body
	If Empty(cBody)
		Self:SetStatus(400)
		oJsonOut['error'] := 'Body vazio'
		Self:SetResponse(oJsonOut:ToJson())
		Return lRet
	EndIf

	// Converte JSON
	oJsonIn := JsonObject():New()
	oJsonIn:FromJson(cBody)

	// Validação básica
	If !oJsonIn:HasProperty('etiqueta') .or.!oJsonIn:HasProperty('operador')
		Self:SetStatus(400)
		oJsonOut['error'] := 'Campo etiqueta ou operador não informado.'
		Self:SetResponse(oJsonOut:ToJson())
		Return lRet
	EndIf

	DbSelectArea(cAliasWS)
	DbSetOrder(1)

	// Evita duplicidade
	If (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + oJsonIn['etiqueta']))
		Self:SetStatus(409)
		oJsonOut['error'] := 'Etiqueta já existe'
		Self:SetResponse(oJsonOut:ToJson())
		Return lRet
	Else
		DbSelectArea('CB0')
		DbSetOrder(1)
		IF CB0->(MSEEK(xFilial('CB0')+oJsonIn['etiqueta']))
			RecLock(cAliasWS, .T.)
			(cAliasWS)->ZZJ_FILIAL := CB0_FILIAL
			(cAliasWS)->ZZ7_CODETI := CB0_CODETI
			(cAliasWS)->ZZ7_PRODUT := CB0_CODPRO
			(cAliasWS)->ZZ7_DESC   := POSICIONE('SB1',1,XFILIAL('SB1')+CB0->CB0_CODPRO,'B1_DESC')
			(cAliasWS)->ZZ7_OP     := CB0_OP
			(cAliasWS)->ZZ7_QUANT   := CB0_QTDE
			(cAliasWS)->ZZ7_DATA:=  CB0_DTNASC
			(cAliasWS)->ZZ7_HORA :=  LEFT(TIME(),5)
			(cAliasWS)->ZZ7_STATUS:=  'I'
			(cAliasWS)->ZZ7_CODOPE:=  oJsonIn['operador']
			MsUnlock()
		else
			Self:SetStatus(409)
			oJsonOut['error'] := 'Etiqueta não existe na CB0'
			Self:SetResponse(oJsonOut:ToJson())
			Return lRet
		EndIf
	EndIf


	oJsonOut['success'] := .T.
	oJsonOut['message'] := 'Etiqueta apontada com sucesso'

	Self:SetStatus(201)
	Self:SetContentType('application/json')
	Self:SetResponse(oJsonOut:ToJson())

Return lRet
