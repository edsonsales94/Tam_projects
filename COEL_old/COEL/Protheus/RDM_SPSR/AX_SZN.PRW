#include "rwmake.ch"

User Function AX_SZN()

/*
®------------------------------------------------------------------------------®
|Programa  | AX_SZN   | Autor | ROGERIO BATISTA       | Data |28.11.06         |
®------------------------------------------------------------------------------®
|Descricao | Tabela de cadastro de Comissoes Coelmatic por Cod. Grupo          |
®------------------------------------------------------------------------------®
*/

If SM0->M0_CODIGO <> "03"
	Return()
Else
	AxCadastro("SZN","Tabela de Comissoes por Codigo",".T.",".T.")
EndIf

Return(nil)

