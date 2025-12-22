#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
¦¦¦ Função    ¦ MA410MNU   ¦ Autor ¦ Jhonatan  ¦ Data ¦ 12/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada para inclusão de novas opções no pedido venda¦¦¦
*/

User Function MA410MNU()
        

	Aadd(aRotina,{ "Liberação de Credito e estoque",	"MATA456"	    ,0,4,0 ,NIL} )  
	Aadd(aRotina,{ "Nf-e Sefaz"                    , 	"SPEDNFE"       ,0,4,0 ,NIL} )
	Aadd(aRotina,{ "Ct-e Os"                       , 	"GTPT001"       ,0,4,0 ,NIL} )
	Aadd(aRotina,{ "Nfs-e"                         ,	"FISA022"       ,0,4,0 ,NIL} ) 
	Aadd(aRotina,{ "Pre-CTeOs"                     ,	"U_PREOSCTE()"  ,0,4,0 ,NIL} ) 
	Aadd(aRotina,{ "Pre-NFe"                       ,	"U_PREDANFE()"  ,0,4,0 ,NIL} )
	
 
Return
