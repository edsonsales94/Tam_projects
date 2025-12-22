#Include "Rwmake.ch"

User Function LJ7011()

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada executado na mudança de Pasta na Venda Assistida.
OBJETIVO 1: Chamada para verificar se o USUÁRIO é CAIXA, caso seja, não permite o acesso a pasta de mercadorias;
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

Private lRet := .T.

If SubStr(SLF->LF_ACESSO,3,1) == "S"
	MsgAlert("Usuário CAIXA não é pode acessar a Tela de Vendas !","ATENÇÃO !!!")
	lRet := .F.
Endif

Return(lRet)

