#include "protheus.ch"

/*/{Protheus.doc} REGFER

Cadastro de Resgistro de Ferramental.

@type function
@author Honda Lock
@since 01/10/2017

/*/

User Function REGFER()

DbSelectArea("SZJ")
dbSetOrder(1)

AxCadastro("SZJ","Registro Ferramental",".T.",".T.")   

/*IF SZJ->ZJ_OUTRO == .T. 
SZJ->ZJ_OUTROS = .T.
ELSE 
SZJ->ZJ_OUTROS = .F.  */


Return                                         