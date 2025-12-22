#include "protheus.ch"

/*/{Protheus.doc} Resina x Perdas

Tela de cadastro de Resina x Perdas

@type function
@author Honda Lock
@since 05/12/2019

/*/

User Function CADRESPE()

DbSelectArea("Z2J")
//dbSetOrder(1)

AxCadastro("Z2J","Cadastro de Perda de Resinas",".T.",".T.")

Return