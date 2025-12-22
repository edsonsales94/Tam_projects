#INCLUDE "rwmake.ch"

User Function SX5NOTA()
	Local cSerie := "3/32/31"
	Private lret
	
	if Alltrim(FunName()) <> "MATA103"
		If cEmpAnt=="01" .And. cFilAnt=="01" 
			If alltrim(x5_chave)#cSerie 
				lret:=.F.
			EndIf
		EndIf
	Else
		lret:=.T.
	Endif
Return(lret)