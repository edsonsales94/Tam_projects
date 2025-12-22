#INCLUDE "Protheus.ch"

*************************************************************************************
****** Rotina *************** INGPEP02 **********************************************
****** AUTOR  *************** Diego    **********************************************
****** Data   *************** 02/12/09 **********************************************
*************************************************************************************
*************************************************************************************
*************************************************************************************
User Function INGPEP02(cMat)
************************************************************************************* 

 Local cVerbaPro := ""
 Local cVerbaDif := ""
 Local dData     := dDataBase
 Local aSra      := SRA->(GetArea())
 Local aSr3      := SR3->(GetArea())
 Local aArea     := GetArea()
 Local nValPro   := 0
 Local nValDif   := 0
 Local nMeses    := 0
 
 SRA->(dbSetOrder(1))

 if SRA->(dbSeek(xFilial("SRA")+cMat))
       nMeses := Val(SubStr(DTOS(dData),1,6)) - Val(SubStr(DTOS(SRA->RA_ADMISSA),1,6)) + 1
       
    if nMeses <= 12
       nValPro := Round(SRA->RA_SALARIO / 12,2)
    EndIf
    
    SR3->(dbSetOrder(1))
    SR3->(dbSeek(xFilial("SR3") + cMat))
    While !SR3->(EOF()) .And. xFilial("SR3") + cMat = SR3->R3_FILIAL + SR3->R3_MAT
	    
	    iF SubStr(DTOS(dDatabase),1,6) == SubStr(DTOS(SR3->R3_DATA),1,6) .And. SR3->R3_TIPO <> '001'
	       SR3->(dbSkip(-1))
	       
	       if nMeses > 12
	           nValDif := round(SRA->RA_SALARIO - SR3->R3_VALOR,2)
	          elseif nMeses <= 12	              
	              nValParc := Round(SR3->R3_VALOR / 12,2)
	              nValDif  := (Round(SRA->RA_SALARIO / 12,2) - nValParc) * (nMeses - 1)
	       EndIf
	       
	    EndIf
	    
	    SR3->(dbSkip())
	    
    EndDo
 EndIf
 
 RestArea(aSra)
 RestArea(aArea)
 
Return {nValPro,nValDif}

