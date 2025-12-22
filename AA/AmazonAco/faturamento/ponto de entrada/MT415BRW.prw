#include "Protheus.ch"

User Function MT415BRW()
 

	SA3->(dbSetOrder(7))
	SA3->(dbSeek(XFILIAL("SA3")+RetCodUsr() ))
 
Return Nil

