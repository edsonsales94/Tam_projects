/*/{protheus.doc}mt110grv
Ponto de entrada na gravacao da solicitacao de compras
@author Honda Lock
/*/

User Function MT110GRV()

Local aArea     := GetArea()
Local cRet := .T.

//GRAVA O NOME DA FUNCAO NA Z03
//U_CFGRD001(FunName())

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?nvia Workflow para aprovacao da Solicitacao de Compras ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If INCLUI .OR. ALTERA //Verifica se e Inclusao ou Alteracao da Solicitacao
	MsgRun("Enviando Workflow para Aprovador da Solicita豫o, Aguarde...","",{|| CursorWait(), U_COMRD003() ,CursorArrow()})
EndIf
RestArea(aArea)

Return cRet