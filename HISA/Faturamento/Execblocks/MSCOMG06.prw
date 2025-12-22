#include "rwmake.ch"
                   
/*
+-----------+------------+-------+------------------------+------+------------+
¦ Função    ¦ MSCOMG06   ¦ Autor ¦ Orismar Silvar         ¦ Data ¦ 05/05/2020 ¦
+-----------+------------+-------+------------------------+------+------------+
¦ Descriçäo ¦ Exibe o CNPJ/CPF do Cliente ou Fornecedor na tela do Pedido de  ¦
¦           ¦ Compra.                                                         ¦
¦           ¦                                                           	  ¦
+-----------+-----------------------------------------------------------------+
*/

User Function MSCOMG06()
	Local _Ret := ""
	If (M->C5_TIPO $ "B/D")
		_Ret := POSICIONE("SA2",1,XFILIAL("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_CGC") //FORNECEDOR
	Else
		_Ret := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_CGC") //CLIENTE
	EndIf
Return(_Ret)
