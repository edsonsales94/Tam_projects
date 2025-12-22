#Include "rwmake.ch"

User Function F070DESC()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada executado na validação do campo de desconto da baixa.
OBJETIVO 1: Permitir que somente alguns usuário possam conceder Desconto Financeiro
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

lRet := .T.
If ! __cUserID  $ GETMV("MV_DESCFIN")
	Aviso("Parâmetro", "Usuário NÃO autorizado a conceder Desconto Financeiro pelo parâmetro MV_DESCFIN.", {"Ok"}, 2)	
	lRet := .F.
EndIf

Return(lRet)