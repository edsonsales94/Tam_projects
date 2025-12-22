#include "protheus.ch"

/*/{Protheus.doc} cadfer

Tela de cadastro de manutenção de ferramental

@type function
@author Honda Lock
@since 01/10/2017

/*/

User Function cadfer()

DbSelectArea("SZI")
dbSetOrder(1)

AxCadastro("SZI","Manutenção de Ferramental",".T.",".T.")

Return