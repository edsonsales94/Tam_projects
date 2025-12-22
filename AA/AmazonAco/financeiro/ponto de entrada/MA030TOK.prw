

#include "Protheus.ch"
#include "rwmake.ch"  

User Function MA030TOK()
Local lRetorno := .T.

If M->A1_XATAVAR = "A" .AND. EMPTY(M->A1_VEND) 
		Alert("Favor informar o Vendedor deste cliente!")
		Return .F.
Endif

Return lRetorno 