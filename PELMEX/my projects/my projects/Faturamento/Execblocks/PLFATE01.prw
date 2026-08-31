#INCLUDE "protheus.ch"

User Function PLFATE01()
	Local lRetorn := .t.

	If alltrim(FunName())=="RPC"
		QOUT("SAIU PLFATE01")
		Return lRetorn
	EndIF
	if  SZ5->(DbSeek(xFilial("SZ5")+__CUSERID)) 
		lRetorn := SZ5->(DbSeek(xFilial("SZ5")+__CUSERID+M->C5_CLIENTE))    
		iF !LrETORN 
			APMSGINFO("Este Cliente não é válido para este usuario")
		ENDIF
	endif 

Return lRetorn