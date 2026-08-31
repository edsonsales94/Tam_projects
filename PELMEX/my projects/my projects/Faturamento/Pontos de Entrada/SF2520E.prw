#include "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ SF2520E    ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 29/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de exclusão da nota de saída                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function SF2520E()
	Local cAlias := Alias()

	// Posiciona no item da nota fiscal
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE),.T.))

	// Posiciona no Pedido de Venda
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

	// Caso os campos de reserva não estejam preenchidos
	If Empty(SC5->C5_XORCRES) .Or. Empty(SC5->C5_XFILRES)
		Return   // Sai da rotina pois não se trata de um nota de transferência
	Endif

	// Exclui os itens da nota de entrada
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(SC5->C5_XFILRES+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),.T.))
	While !SD1->(Eof()) .And. SC5->C5_XFILRES+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)

		RecLock("SD1",.F.)
		dbDelete()
		MsUnLock()

		SD1->(dbSkip())
	Enddo

	// Exclui o cabeçalho da nota de entrada
	SF1->(dbSetOrder(1))
	If SF1->(dbSeek(SC5->C5_XFILRES+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		RecLock("SF1",.F.)
		dbDelete()
		MsUnLock()
	Endif
	dbSelectArea(cAlias)

Return