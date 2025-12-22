#Include "Rwmake.ch"
#Include "Protheus.ch"


User Function MDSQLSF2()

Local cQuery := ParamIXB[1]

cQuery := StrTran(cQuery,"'SPED'","'CTE'")

Return cQuery
