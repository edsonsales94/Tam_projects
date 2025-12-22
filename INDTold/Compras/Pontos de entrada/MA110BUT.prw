#INCLUDE "rwmake.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120BUT  บAutor  ณEner Fredes         บ Data ณ  07.12.10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE usado para a inser็ใo de bot๕es na tela do Pedido de    บฑฑ 
ฑฑบ          ณ compra serแ usado para:                                    บฑฑ 
ฑฑบ          ณ * Executar a rotina INCOME01.prw para mostrar a tela para aบฑฑ 
ฑฑบ          ณ   digita็ใo do Follow-up do pedido e grava็ao na tabela SZDบฑฑ 
ฑฑบ          ณ * Executar a rotina INCOME03.prw para mostrar a tela para  บฑฑ 
ฑฑบ          ณ   a digita็ใo e valida็ใo da data de Entrega do pedido de  บฑฑ 
ฑฑบ          ณ   Compra ja esteja preenchida                              บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COMPRA - Pedido de Compra                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
   
User Function MA110BUT
	Local aBotao :={}                                                
	Local cPedido := CA110NUM
	AAdd(aBotao,{"BPMSRECI",{||u_INCOME01(.F.,aCols[n][13])},"Follow Up","Follow Up"})
	AAdd(aBotao,{"BPMSRECI",{||u_INCOME03()},"Entrega","Dt.Entrega"})
	AAdd(aBotao,{"BPMSRECI",{||u_INCOME02("1","",cPedido,"","","",.F.,"01"+cPedido,.T.,.F.)},"Objet/Justif","Objetivo e Justificativa"})
Return aBotao  

