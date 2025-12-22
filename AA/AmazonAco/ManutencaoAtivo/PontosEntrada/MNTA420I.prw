#INCLUDE 'totvs.ch'

User Function MNTA420I()
    Local aRot := aClone(ParamIXB[1])
    
    xPos := aScan(aRot,{|x| x[01] == "Imprimir"})
    if(xPos > 0)
      aRot[xPos][02] := "U_AAMNTR01"
    Else
      Aadd(aRot,{"Impressao", "U_AAMNTR01()" , 0 , 8,0})
    EndIf
    //Aadd(aRot,{"Impressao", "U_XYZ()" , 0 , 8,0})

Return aRot


