#include "protheus.ch"

/*/{Protheus.doc} cadfer

Tela de cadastro de manutenção de ferramental

@type function
@author Honda Lock
@since 02/05/2022

/*/

User Function cadmol()

DbSelectArea("ZB2")
dbSetOrder(1)

AxCadastro("ZB2","Tabela de Moldes x Modelos",".T.",".T.")

Return
