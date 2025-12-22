#INCLUDE "Rwmake.ch"

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
User Function MA120BUT()
	Local aBotao := {}
	
	AAdd( aBotao , { "PENDENTE", {|| u_INCOME01(.F.,aCols[n][13]) },"Follow Up","Follow Up"})
	AAdd( aBotao , { "S4WB014A", {|| u_INCOME03() },"Dt.Entrega","Dt.Entrega"})
	AAdd( aBotao , { "NOTE"    , {|| u_INCOME02("Justificativa da Compra","1","",CA120NUM,"","","",.T.,.T.,"",;
					  							AllTrim(Posicione("SZ6",1,xFilial("SZ6")+"1"+CA120NUM,"Z6_JUSTIFI")),;
												.T.,{.F.,'','','',''})},"Justificativa","Justificativa da Compra"})
	AAdd( aBotao , { "S4WB009N", {|| u_INCOME05("2",CA120NUM) },"Exporta Anexo","Exporta Anexo"})
	
Return aBotao
