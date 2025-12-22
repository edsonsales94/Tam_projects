#include "totvs.ch"


/*
*/

User Function AA410PES(xTipo)
   Local xPQt := aScan(aHeader, {|x| Alltrim(x[02]) == 'C6_QTDVEN' } )
   //Local xPQt := aScan(aHeader, {|x| Alltrim(x[02]) == 'CK_QTDVEN' } )
   Local nI
   Local xVar := ""
   Local nValue := 0

   Default xTipo := "V"

   If xTipo == "O"
      xPQt := aScan(aHeader, {|x| Alltrim(x[02]) == 'CK_QTDVEN' } )
	  xVar := "M->CJ_XTOTAL"
   Else
      xPQt := aScan(aHeader, {|x| Alltrim(x[02]) == 'C6_QTDVEN' } )
      xVar := "M->C5_XTOTAL"
   EndIf
   
   If xPQt > 0
      &(xVar) := 0
	  if xTipo == "O"
	    aar := TMP1->(GetArea())
		TMP1->(dbGoTop())
	    While !TMP1->(EOf())
			If  !TMP1->CK_FLAG 
		    &(xVar) += TMP1->CK_QTDVEN
			nValue +=  TMP1->CK_QTDVEN 
		    endif
			TMP1->(dbSkip())
		Enddo
		TMP1->(RestArea(aar))
	  Else
		For nI := 01 To Len(aCols)
			&(xVar) += aCols[nI][xPQt]
			nValue += aCols[nI][xPQt]
		Next	  
	  EndIf
   EndIf
Return nValue
