#Include 'Protheus.ch'

/*
Descricao : POnto de Entrada Desenvolvido para Retornar o Tipo RV a AProvacao Atual
*/

User FUnction MTA097S()
  Local lRet := .T.
   SCR->(RecLock('SCR',.F.))
    SCR->CR_TIPO := 'RV'
   SCR->(MsUnlock()) 
Return lRet

