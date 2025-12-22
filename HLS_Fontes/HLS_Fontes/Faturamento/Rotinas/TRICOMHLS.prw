#include "protheus.ch"

/*/{Protheus.doc} 

Tela de cadastro de Preços Trienio HLS

@type function
@author Honda Lock
@since 26/08/2022

/*/

User Function TRICOMHLS()

DbSelectArea("Z3A")
//dbSetOrder(1)

AxCadastro("Z3A","Rotina dos Preços e LND - HLS",".T.",".T.")

Return
