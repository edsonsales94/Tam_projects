#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "Protheus.ch"

User Function tValCod(xcFilial,xGrupo,xCodProd)
    Local aArea     := FwGetArea()
    Local lRet      := .F.
    
    DbSelectArea("SB1")
    DbSetOrder(4)
    If SB1->(DbSeek(xFilial("SB1")+Alltrim(xGrupo)+Padr(xCodProd,TamSx3("B1_COD")[1],"")))
        lRet:= .T.
    EndIf 
   
FwRestArea(aArea)
Return lRet
