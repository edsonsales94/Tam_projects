#include "protheus.ch"

/*/{Protheus.doc} cadpro

Tela de cadastro de projetos

@type function
@author Honda Lock
@since 01/10/2017

/*/

User Function cadpro()

DbSelectArea("SZH")
dbSetOrder(1)

AxCadastro("SZH","Cadastro de Projetos",".T.",".T.")

Return