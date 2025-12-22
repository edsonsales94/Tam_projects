#Include "rwmake.ch"

User Function LJ7010()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto de entrada executdo pelo botão "Zera Pagamentos"
OBJETIVO 1: Caso seja SERVIÇO não irá zerar os pagamentos devidos não-conformidade com a Reserva
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

nColUm      := AScan( aHeader , {|x| Trim(x[2]) == "LR_UM" })
lSrv		:= .F.

If SubStr(SLF->LF_ACESSO,3,1) == "S"    	// Se o usuário for CAIXA
	
	For I:=1 to Len(Acols)
		
		If Acols[I][nColUM] == "SV"
			lSrv := .T.
		Endif
		
	Next
	
	If lSrv
		Aviso("Atenção","Favor temporariamente não zerar pagamento devido o SERVIÇO !!!",{"OK"},2)
	Else
		Lj7ZeraPgtos()							//	Função padrão do Sistema
	EndIf

Else
	Lj7ZeraPgtos()							//	Função padrão do Sistema
EndIf

Return()
