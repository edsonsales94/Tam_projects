#Include "Font.ch"
#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

/*/{protheus.doc}xARMz
Altera o local do SB9 via reclock
@author HONDA LOCK
@since 
/*/

User Function xARMz()

Local xNum  := 0
Local xNum1 := 0

Dbselectarea("SB1")
DbsetOrder(1)
Dbgotop()

While SB1->(!Eof())
	
	xCOD := SB1->B1_COD
	xLOC := "01"
	
	Dbselectarea("SB9")
	DbSetOrder(1)
	DBseek(xFILIAL("SB9")+xCod+xLOC)
	
	If SB9->(Found())
		xNum1 += 1
	Else
		Reclock("SB9",.T.)
		SB9->B9_FILIAL := "01"		
		SB9->B9_COD    := xCOD
		SB9->B9_LOCAL  := "01"
		MsUnlock()
		xNUM += 1
	Endif

	SB1->(Dbskip())
	Loop
	
Enddo

Alert("Total - "+Str(xNUM)+"    "+"Total 1- "+Str(xNUM1))

Return()
