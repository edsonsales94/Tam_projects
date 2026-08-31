#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*/
+-----------------------------------------------------------------------------------+
|  Programa   |  PLFATE02  |  Autor  | Adson Carlos           |  Data  |  07/10/13  |
|-----------------------------------------------------------------------------------|
|  Descricao  |  Retorna Codigo Calculado a partir do usuario logado                |
|-----------------------------------------------------------------------------------|
|  Uso        | Especifico para Clientes Microsiga                                  |
+-----------------------------------------------------------------------------------+
/*/
User Function PLFATE02()
	Local cPedSq  := Posicione("SZ5",1,xFilial("SZ5")+__CUSERID,"Z5_SEQPED")

	cNumPed := iif (Empty(cPedSq),GetSxeNum("SC5","C5_NUM"),GetSxeNum("00"+cPedSq,"C5_NUM",cFilAnt+"NUMLOJS"))

Return cNumPed