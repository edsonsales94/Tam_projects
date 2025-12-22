#include "protheus.ch"

/*/{Protheus.doc} Kaizen

Tela de cadastro de Kaizen

@type function
@author Honda Lock
@since 01/10/2017

/*/

User Function Kaizen()

DbSelectArea("SZE")
//dbSetOrder(1)

AxCadastro("SZE","Cadastro de Kaizen",".T.",".T.")

Return