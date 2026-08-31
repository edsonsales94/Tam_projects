#INCLUDE "RWMAKE.CH"

User Function PLEST05(cLocal)
Local Ret           := cLocal
Local xIdUsuario    := RetCodUsr()
Local xLocalOri     := cLocal
Local xLocalDest    := cLocal

If (xIdUsuario == "000093") .OR. (xIdUsuario == "000215")// .OR. (xIdUsuario == "000090")
	If (xLocalOri == "60") .OR. (xLocalDest == "60")
		Alert("Sem permissao para utilizar o armazem 60!")
		Ret := "01"
	EndIf
Else
	Ret := cLocal
EndIf
return Ret