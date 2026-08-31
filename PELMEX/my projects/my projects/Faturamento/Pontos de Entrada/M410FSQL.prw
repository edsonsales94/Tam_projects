#include "RWMAKE.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ M410FSQL   ¦ Autor ¦ JONATHAN WERMOUTH    ¦ Data ¦ 17/10/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descricao ¦ Ponto de Entrada que permite filtrar os pedidos de venda      ¦¦¦
¦¦¦           ¦ exibidos na mBrowse.                                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function M410FSQL()
	Local cFiltro := ""
	Local aArea   := GetArea()

	If cFilAnt == "10"
		SZ5->(dbSetOrder(1))
		If SZ5->(DbSeek(xFilial("SZ5")+__CUSERID) )
			While !(SZ5->(EOF())) .AND. SZ5->(Z5_FILIAL+Z5_IDUSER)==(xFilial("SZ5")+__CUSERID)
				If !(Empty(SZ5->Z5_CLIENTE))
					If empty(cFiltro)
						cFiltro := "C5_CLIENTE = '"+ SZ5->Z5_CLIENTE+"'"
					Else
						cFiltro += " OR C5_CLIENTE = '"+ SZ5->Z5_CLIENTE+"'"
					EndIf
				EndIf
				SZ5->(dbSkip())
			End
		EndIf
	EndIf
	RestArea(aArea)
Return cFiltro
