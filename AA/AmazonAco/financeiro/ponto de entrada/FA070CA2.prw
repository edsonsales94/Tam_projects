#Include "rwmake.ch"

User Function FA070CA2()

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada executado ao final da rotina de cancelamento de baixa, após todos os dados terem sido gravados e já feita a contabilização.
OBJETIVO 1: Modificar as informações referente ao RECEBER NO LOCAL para liberação de uma nova baixa
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

If Alltrim(SE1->E1_TIPO) == "RL"
	
	Begin Transaction
	
	RecLock("SE1")
	SE1->E1_NATUREZ := "OUTROS"
	SE1->E1_DTRECEB := CTOD("  /  /  ")
	MsUnLock()
	
	End Transaction
	
EndIf

Return()	
