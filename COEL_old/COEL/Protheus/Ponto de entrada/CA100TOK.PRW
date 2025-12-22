#include "rwmake.ch"

User Function Ca100tok()

//MSGBOX("Debito e Credito nao conferem !","Atencao","INFO")

If !CLOTECONT $"8890"
	MSGBOX("Debito e Credito nao conferem !","Atencao","INFO")
	lRet := .f.
Else
	lRet := .t.
EndIf

Return(lRet)


