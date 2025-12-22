#include "Protheus.ch"
#include "rwmake.ch"   
/*/{Protheus.doc} MA410MNU

Ponto de entrada inclusão de botões na enchoicebar

@author Ectore Cecato - Totvs IP
@since 	02/10/2019

/*/


User Function MA410MNU()
	
	aAdd(aRotina, {"Exc. PV Lote", "U_HLAFAT01()", 0, 9, 0, Nil})
	aadd(aRotina, {'Pedido venda/devol - CSV ','U_HLAFAT02' , 0 , 6,0,NIL})
	
Return Nil      
