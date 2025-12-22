#Include "rwmake.ch"

User Function LJ7020()

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada executado na Entrada da Venda Assistida.
OBJETIVO 1: Chamada para tornar a variavel 'nDescPer' PUBLICA e inicia-lá, será utilizada no PE LJ7001;
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

Local lRet := .T.
Public nDescPer	:= 0

IF PARAMIXB[01]$ 'BOLETO/COND.NEGOCIADA' .And. lRet
   //lRet := .F.
ENDIF

Return lRet