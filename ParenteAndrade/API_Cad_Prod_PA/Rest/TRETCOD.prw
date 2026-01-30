#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "Protheus.ch"

User Function TRETCOD(cGrupo)
Local cRet   	:= "" 
Local cArea  	:= GetArea()
Local cQry   	:= ""
Local nTotal := 0 

cQry += "SELECT ISNULL(MAX( B1_COD) , B1_GRUPO + '000000') AS mNum"
cQry += "  FROM "+RetSQLName("SB1")+" WHERE D_E_L_E_T_ = ' ' "
cQry += "   AND B1_GRUPO = '" +Alltrim(cGrupo)+ "' "    
cQry += "   AND SUBSTRING(B1_COD,1,4) = '" +Alltrim(cGrupo)+ "' "    
cQry += " GROUP BY B1_GRUPO "
cQry := ChangeQuery(cQry)
  
//dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
TCQuery cQry New Alias "TMP"
Count to nTotal

If nTotal > 0
   cRet := iIf(TMP->(EOF()), Alltrim(cGrupo) + '000001' , Soma1( AllTrim(mNum) ) )
Else 
   cRet:= Alltrim(cGrupo) + '000001'
EndIf 
  
TMP->(dbCloseArea())

DbSelectArea("SB1")
DbSetOrder(1)
   If SB1->(DbSeek(xFilial("SB1")+cRet))
      While ! SB1->(Eof()) .And. Alltrim(SB1->B1_COD) == Alltrim(cRet)
         cRet:= Soma1(cRet) 
         SB1->(DbSkip())
      End 
   eNDiF 

FreeUsedCode()
Help := .T.	// Nao apresentar Help MayUse
While !FreeForUse("SB1",cRet,.F.)
   cRet := Soma1(cRet)
   Help := .T.	// Nao apresentar Help MayUse
End
Help := .F.	// Habilito o help novamente
RestArea(cArea) 
Return cRet
