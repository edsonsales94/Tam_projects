#include "rwmake.ch"
                   
/*
+-----------+------------+-------+------------------------+------+------------+
¦ Função    ¦ MSCOMG02   ¦ Autor ¦ Orismar Silvar         ¦ Data ¦ 10/02/2014 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Exibe o Nome do Cliente ou Fornecedor na tela do Pedido de      ¦
¦           ¦ Compra.                                                         ¦
¦           ¦                                                           		¦
+-----------+-----------------------------------------------------------------+
*/

User Function MSCOMG02()
	Local _Ret := ""
	If (SC5->C5_TIPO $ "B/D")
		_Ret := POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NOME") //FORNECEDOR
	Else
		_Ret := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME") //CLIENTE
	EndIf
Return(_Ret)
