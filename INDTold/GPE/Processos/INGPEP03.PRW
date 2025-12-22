#INCLUDE "Protheus.ch"

*************************************************************************************
****** Rotina *************** INGPEP03 **********************************************
****** AUTOR  *************** Diego    **********************************************
****** Data   *************** 02/12/09 **********************************************
*************************************************************************************
*************************************************************************************
*************************************************************************************
User Function INGPEP03(nTipo)
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
Local xRet      := nil
Local cMat      := SRA->RA_MAT

if ValType(nTipo)="U"
	nTipo := 1
EndIf
nMeses := ((Year(dData) - Year(SRA->RA_ADMISSA)) * 12 ) +  (Month(dData) - Month(SRA->RA_ADMISSA) + 1)

//if nMeses <= 12
	nValPro := Round(SRA->RA_SALARIO / 12,2)
//EndIf

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
		cMat := ""
	EndIf
	SR3->(dbSkip())
EndDo

RestArea(aSra)
RestArea(aArea)

xRet := iIf(nTipo = 1,nValPro,nValDif)

Return xRet
