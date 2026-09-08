#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
¦¦¦ Função    ¦ MA410MNU   ¦ Autor ¦ claudio  ¦ Data ¦ 29/04/2026 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada para inclusão de novas opções no pedido venda¦¦¦
*/

User Function MA410MNU()
        

	Aadd(aRotina,{ "Liberação de Credito e estoque",	"MATA456"	,0,4,0 ,NIL} )  
	Aadd(aRotina,{ "Boleto BB (CR)",	"U_SAFINR01()"	,0,4,0 ,NIL} ) 
	Aadd(aRotina,{ "Boleto Bradesco (CR)",	"U_ARFINR02()"	,0,4,0 ,NIL} ) 
	Aadd(aRotina,{ "Nfe Sefaz",	"SPEDNFE"	,0,4,0 ,NIL} ) 
	//Aadd(aRotina,{ "Nfs-e",	"FISA022"	,0,4,0 ,NIL} ) 
	
 
Return
