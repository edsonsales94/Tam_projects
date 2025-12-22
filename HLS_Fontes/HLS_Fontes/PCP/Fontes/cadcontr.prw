#include "protheus.ch"

/*/{Protheus.doc} cadcontr

Tela de cadastro de contratos

@type function
@author Honda Lock
@since 01/10/2017

/*/

User Function cadcontr()

DbSelectArea("SZE")
dbSetOrder(1)

AxCadastro("SZE","Cadastro de Contratos",".T.",".T.")

Return