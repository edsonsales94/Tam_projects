#include "protheus.ch"
/*/{protheus.doc} prodproj
Axcadastro de projetos
@author Honda Lock
/*/
User Function PRODPROJ()

DbSelectArea("SZF")
//dbSetOrder(1)

AxCadastro("SZF","Cadastro de Projetos",".T.",".T.")

Return