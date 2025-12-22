#include "Protheus.ch"

User Function A415LIOK()
Local lRet       := .T.
Local nX         := 0

If !(FunName() $ "MATA415/MATA416")
	Return lRet
elseIf alltrim(FunName()) = "MATA415"
    //busca o peso 
    u_AA410PES("O")
    //refresh da enchoic do maligno
    oDlg := GetWndDefault()
    For nX := 1 To Len(oDlg:aControls)
        If ValType(oDlg:aControls[nX]) <> "U"
            oDlg:aControls[nX]:ReFresh()
        EndIf
    Next nX
EndIf

Return lRet
