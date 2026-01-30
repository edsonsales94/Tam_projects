#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "Protheus.ch"
#Include "TOTVS.ch"

User Function TRETCOD()//TRETCOD(cGrupo)
Local cRet   	:= "" 
Local cArea  	:= GetArea()
Local cQry   	:= ""
Local cCodProd:= GETMV("MV_XSEQCOD")
Local lAchou:=.F.

//cCodProd:= GetSxeNum("SB1","B1_COD") 

cQry += "SELECT B1_COD "//cQry += "SELECT RIGHT(TRIM(B1_COD),10) AS NEWCOD "
cQry += " FROM "+RetSQLName("SB1")+" AS A (NOLOCK) "
cQry += " WHERE D_E_L_E_T_ = ' ' "
cQry += " AND A.B1_COD='"+cCodProd+"' "    

cQry := ChangeQuery(cQry)
  
TCQuery cQry New Alias "TMP"
DbGotop()

DbSelectArea("SB1")
DbSetOrder(1)
While !TMP->(EOF()) //!SB1->(Eof()) .And. Alltrim(SB1->B1_COD) == Alltrim(cRet)
   cRet:= TMP->B1_COD
   If SB1->(DbSeek(xFilial("SB1")+cRet))
      lAchou:=.T.
      cRet:= Soma1(Alltrim(cRet))
      //PutMv("MV_XSEQCOD",cRet) 
   EndIf 
   TMP->(DbSkip())
End 
If !lAchou
   cRet:= Alltrim(cCodProd)
   //PutMv("MV_XSEQCOD",Soma1(cRet)) 
EndIf 
TMP->(dbCloseArea())


FreeUsedCode()
Help := .T.	// Nao apresentar Help MayUse
While !FreeForUse("SB1",cRet,.F.)
   cRet := Soma1(cRet)
   Help := .T.	// Nao apresentar Help MayUse
End
Help := .F.	// Habilito o help novamente
RestArea(cArea) 
Return cRet
