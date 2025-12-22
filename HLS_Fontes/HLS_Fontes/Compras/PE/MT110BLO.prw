/*/{protheus.doc}mt110blo
Ponto de entrada para aprovacao da solicitação de compras
@author Honda Lock
/*/
User Function MT110BLO()

Local lRet1 := .T.

//GRAVA O NOME DA FUNCAO NA Z03
//U_CFGRD001(FunName())

If __CUSERID <> SC1->C1_CODAPRO
	MsgAlert("Usuário não autorizado a aprovar esta solicitação.","Atenção!")
	lRet1 := .F.
EndIf

Return(lRet1)