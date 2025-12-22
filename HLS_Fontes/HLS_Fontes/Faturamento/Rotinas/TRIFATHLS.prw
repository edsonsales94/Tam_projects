#include "protheus.ch"

/*/{Protheus.doc} rotina do Trienio Faturamento HLS

Tela de cadastro de Rotina do Trienio Faturamento HLS

@type function
@author Honda Lock
@since 15/08/2022

/*/

User Function TRIFATHLS()

DbSelectArea("Z3A")
//dbSetOrder(1)

AxCadastro("Z3A","Rotina do Trienio Faturamento HLS",".T.",".T.")

Return
