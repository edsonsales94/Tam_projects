#INCLUDE "rwmake.ch"
/*/{protheus.doc}SF1140I  
Ponto de Entrada para manipular a data de classificacao da NF de entrada 								
@author Eduardo Franco
@since 09/01/2009
/*/

User Function SF1140I()
////////////////////////
//
Local aArea  := GetArea()
//
Dbselectarea("SF1")
Reclock("SF1",.F.)
//
SF1->F1_DTINCLU := DDATABASE
//
MSUnlock()
Dbselectarea("SF1")
//
RestArea(aArea)
//
Return()