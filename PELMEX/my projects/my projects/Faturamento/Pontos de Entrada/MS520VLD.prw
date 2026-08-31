#include "RWMAKE.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MS520VLD   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 29/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descricao ¦ Ponto de Entrada de validação da exclusão da N. F. de Saída   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MS520VLD()
	Local lRet := .T.

	// Posiciona no item da nota fiscal
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE),.T.))

	// Posiciona no Pedido de Venda
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

	// Caso os campos de reserva não estejam preenchidos
	If Empty(SC5->C5_XORCRES) .Or. Empty(SC5->C5_XFILRES)
		Return lRet   // Sai da rotina pois não se trata de um nota de transferência
	Endif

	// Posiciona no item da nota de entrada de transferência
	SD1->(dbSetOrder(1))
	If SD1->(dbSeek(SC5->C5_XFILRES+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		If !Empty(SD1->D1_TES)    // Identifica se a nota foi classificada
			lRet := .F.
			Alert("Favor excluir a nota de transferência antes de excluir essa nota!")
		Endif
	Endif

Return lRet