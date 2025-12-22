#INCLUDE 'PROTHEUS.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "totvs.ch"
User Function M105BUT()
	Local aBot := {} // Obtém os botões padrão do sistema

	// Adiciona um novo botão ao array de botões
	aAdd(aBot, {'Prod. Alternativos', {|| U_AMNALTER(1) },'Prod. Alternativos' })

Return aBot
