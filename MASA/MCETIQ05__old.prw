#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} User Function MCETIQ05
Exemplo de tela com marcação de dados
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com e https://tdn.totvs.com/display/public/framework/FWMarkBrowse
/*/

User Function MCETIQ05()
	Local aArea := FWGetArea()
	Local aPergs   := {}
	Local xPar0 := Space(15)
	Local xPar1 := Space(15)
	Private oDlgMark
	Private oPanGrid
	Private oMarkBrowse

	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Produto De", xPar0,  "", ".T.", "SZ7", ".T.", 80,  .F.})
//Se a pergunta for confirma, chama a tela
	If ParamBox(aPergs, "Informe os parametros")
		fMontaTela()
	EndIf

	RestArea(aArea)
Return

/*/{Protheus.doc} fMontaTela
Monta a tela com a marcação de dados
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fMontaTela()
	Local aArea         := GetArea()
	Local aCampos := {}
	Local oTempTable := Nil
	Local aColunas := {}
	Local cFontPad    := 'Tahoma'
	Local oFontGrid   := TFont():New(cFontPad,,-14)
	//Janela e componentes
	Private cAliasTmp := GetNextAlias()
	Private aRotina   := MenuDef()
	//Tamanho da janela
	Private aTamanho := MsAdvSize()
	Private nJanLarg := aTamanho[5]
	Private nJanAltu := aTamanho[6]

	//Adiciona as colunas que serão criadas na temporária
	aAdd(aCampos, {  'OK'         ,'C', tamsx3('Z7_OK')[1], tamsx3('Z7_OK')[2]}) //Flag para marcação
	aAdd(aCampos, {  'Z7_ETIQMAE' ,'C', tamsx3('Z7_ETIQMAE')[1], tamsx3('Z7_ETIQMAE')[2]}) //Produto
	aAdd(aCampos, {  'Z7_PAMASA'  ,'C', tamsx3('Z7_PAMASA')[1]	, tamsx3('Z7_PAMASA')[2] }) //Tipo
	aAdd(aCampos, {  'Z7_CODCLI'  ,'C', tamsx3('Z7_CODCLI')[1]	, tamsx3('Z7_CODCLI')[2] }) //Unid. Med.
	aAdd(aCampos, {  'Z7_DESCRI'  ,'C', tamsx3('Z7_DESCRI')[1]	, tamsx3('Z7_DESCRI')[2] }) //Descrição
	aAdd(aCampos, {  'Z7_QUANT'   ,'N', tamsx3('Z7_QUANT')[1]	, tamsx3('Z7_QUANT')[2]  }) //Descrição
	aAdd(aCampos, {  'Z7_OP'      ,'C', tamsx3('Z7_OP')[1]		, tamsx3('Z7_OP')[2]	 }) //Descrição
	aAdd(aCampos, {  'Z7_LOCAL'   ,'C', tamsx3('Z7_LOCAL')[1]	, tamsx3('Z7_LOCAL')[2]	 }) //Descrição

	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:Create()

	//Popula a tabela temporária
	Processa({|| fPopula()}, 'Processando...')

	//Adiciona as colunas que serão exibidas no FWMarkBrowse
	aColunas := fCriaCols()

	//Criando a janela
	DEFINE MSDIALOG oDlgMark TITLE 'Tela para Marcação de dados - Autumn Code Maker' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	//Dados
	// oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
	oMarkBrowse := FWMarkBrowse():New()
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:SetDescription('Produtos')
	oMarkBrowse:DisableFilter()
	oMarkBrowse:DisableConfig()
	oMarkBrowse:DisableSeek()
	oMarkBrowse:DisableSaveConfig()
	oMarkBrowse:SetFontBrowse(oFontGrid)
	oMarkBrowse:SetFieldMark('OK')
	oMarkBrowse:SetTemporary(.T.)
	oMarkBrowse:SetColumns(aColunas)
	//oMarkBrowse:AllMark()
	oMarkBrowse:SetOwner(oPanGrid)
	oMarkBrowse:Activate()
	ACTIVATE MsDialog oDlgMark CENTERED

	//Deleta a temporária e desativa a tela de marcação
	oTempTable:Delete()
	oMarkBrowse:DeActivate()

	RestArea(aArea)
Return

/*/{Protheus.doc} MenuDef
Botões usados no Browse
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Criação das opções
	ADD OPTION aRotina TITLE 'Imprimir'  ACTION 'u_ImpEtiq'     OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Parametros'  ACTION 'u_xFuncPar'     OPERATION 2 ACCESS 0
Return aRotina

/*/{Protheus.doc} xFuncPar
/*/
User Function xFuncPar()
	Local aPergs   := {}
	Local xPar0 := Space(15)

	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Nro. Etiqueta:", xPar0,  "", ".T.", "SZ7", ".T.", 80,  .F.})
    //Se a pergunta for confirma, chama a tela
	If ParamBox(aPergs, "Informe os parametros")
		fPopula()
		if ValType(oMarkBrowse) == "O"
			oMarkBrowse:Refresh()
		endif
	EndIf

Return

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fPopula()
	Local cQryDados := ''
	Local nTotal := 0
	Local nAtual := 0

	//Monta a consulta
	cQryDados += "SELECT * "        + CRLF
	cQryDados += "FROM SZ7010 SZ7 "        + CRLF
	cQryDados += "WHERE SZ7.D_E_L_E_T_ = ' ' AND Z7_ETIQMAE >= '" + MV_PAR01 + "' AND Z7_ETIQMAE <= '" + MV_PAR01 + "' "        + CRLF
	cQryDados += "ORDER BY Z7_ETIQMAE"        + CRLF
	PLSQuery(cQryDados, 'QRYDADTMP')

	//Definindo o tamanho da régua
	DbSelectArea('QRYDADTMP')
	Count to nTotal
	ProcRegua(nTotal)
	QRYDADTMP->(DbGoTop())

	//Enquanto houver registros, adiciona na temporária
	While ! QRYDADTMP->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		RecLock(cAliasTmp, .T.)
		(cAliasTmp)->OK := Space(2)
		(cAliasTmp)->Z7_ETIQMAE := QRYDADTMP->Z7_ETIQMAE
		(cAliasTmp)->Z7_PAMASA  := QRYDADTMP->Z7_PAMASA
		(cAliasTmp)->Z7_CODCLI  := QRYDADTMP->Z7_CODCLI
		(cAliasTmp)->Z7_DESCRI  := QRYDADTMP->Z7_DESCRI
		(cAliasTmp)->Z7_QUANT   := QRYDADTMP->Z7_QUANT
		(cAliasTmp)->Z7_OP      := QRYDADTMP->Z7_OP
		(cAliasTmp)->Z7_LOCAL   := QRYDADTMP->Z7_LOCAL
		(cAliasTmp)->(MsUnlock())

		QRYDADTMP->(DbSkip())
	EndDo
	QRYDADTMP->(DbCloseArea())
	(cAliasTmp)->(DbGoTop())
Return

/*/{Protheus.doc} fCriaCols
Função que gera as colunas usadas no browse (similar ao antigo aHeader)
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fCriaCols()
	Local nAtual       := 0
	Local aColunas := {}
	Local aEstrut  := {}
	Local oColumn

	//Adicionando campos que serão mostrados na tela
	//[1] - Campo da Temporaria
	//[2] - Titulo
	//[3] - Tipo
	//[4] - Tamanho
	//[5] - Decimais
	//[6] - Máscara
	aAdd(aEstrut, { 'Z7_ETIQMAE', "Cod. Etiqueta" , 'C', tamsx3('Z7_ETIQMAE')[1], tamsx3('Z7_ETIQMAE')[2], ''})
	aAdd(aEstrut, { 'Z7_PAMASA'	, "Cod. Masa    " , 'C', tamsx3('Z7_PAMASA')[1]	, tamsx3('Z7_PAMASA')[2] , ''})
	aAdd(aEstrut, { 'Z7_CODCLI' , "Cod. Cliente " , 'C', tamsx3('Z7_CODCLI')[1]	, tamsx3('Z7_CODCLI')[2] , ''})
	aAdd(aEstrut, { 'Z7_DESCRI' , "Descrição    " , 'C', tamsx3('Z7_DESCRI')[1]	, tamsx3('Z7_DESCRI')[2] , ''})
	aAdd(aEstrut, { 'Z7_QUANT'  , "Quantidade   " , 'N', tamsx3('Z7_QUANT')[1]	, tamsx3('Z7_QUANT')[2]  , ''})
	aAdd(aEstrut, { 'Z7_OP'     , "Ord. Produção" , 'C', tamsx3('Z7_OP')[1]		, tamsx3('Z7_OP')[2]	 , ''})
	aAdd(aEstrut, { 'Z7_LOCAL'  , "Armazém      " , 'C', tamsx3('Z7_LOCAL')[1]	, tamsx3('Z7_LOCAL')[2]	 , ''})

	//Percorrendo todos os campos da estrutura
	For nAtual := 1 To Len(aEstrut)
		//Cria a coluna
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
		oColumn:SetTitle(aEstrut[nAtual][2])
		oColumn:SetType(aEstrut[nAtual][3])
		oColumn:SetSize(aEstrut[nAtual][4])
		oColumn:SetDecimal(aEstrut[nAtual][5])
		oColumn:SetPicture(aEstrut[nAtual][6])

		//Adiciona a coluna
		aAdd(aColunas, oColumn)
	Next
Return aColunas

/*/{Protheus.doc} User Function ImpEtiq
Função acionada pelo botão continuar da rotina
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function ImpEtiq()
	Processa({|| fProcessa()}, 'Processando...')
Return

/*/{Protheus.doc} fProcessa
Função que percorre os registros da tela
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fProcessa()
	Local aArea     := FWGetArea()
	Local cMarca    := oMarkBrowse:Mark()
	Local nAtual    := 0
	Local nTotal    := 0
	Local nTotMarc := 0

	//Define o tamanho da régua
	DbSelectArea(cAliasTmp)
	(cAliasTmp)->(DbGoTop())
	Count To nTotal
	ProcRegua(nTotal)

	//Percorrendo os registros
	(cAliasTmp)->(DbGoTop())
	While ! (cAliasTmp)->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		//Caso esteja marcado
		If oMarkBrowse:IsMark(cMarca)
			nTotMarc++

			//Aqui dentro você pode fazer o seu processamento
			Alert((cAliasTmp)->Z7_ETIQMAE)

		EndIf

		(cAliasTmp)->(DbSkip())
	EndDo

	//Mostra a mensagem de término e caso queria fechar a dialog, basta usar o método End()
	// FWAlertInfo('Dos [' + cValToChar(nTotal) + '] registros, foram processados [' + cValToChar(nTotMarc) + '] registros', 'Atenção')
	//oDlgMark:End()

	FWRestArea(aArea)
Return
