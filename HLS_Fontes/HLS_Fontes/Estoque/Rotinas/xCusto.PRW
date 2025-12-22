#Include "Font.ch"
#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

/*/{protheus.doc}xCusto
Altera o custo do SB9 via reclock
@author HONDA LOCK
@since 
/*/

User Function xCusto()

Local xNum := 0

Dbselectarea("SB9")
DbsetOrder(1)

//Dbselectarea("SZ2")
//DbsetOrder(1)

Dbgotop()

While SB9->(!Eof())
	
	If SB9->B9_DATA = Ctod("31/07/09")
		
		xCOD := SB9->B9_COD
		Dbselectarea("SZ2")
		DbSetOrder(1)
		DBseek(xFILIAL("SZ2")+xCod)
		
		If SZ2->(Found())
			Reclock("SB9",.F.)
			SB9->B9_CUSTD  := SZ2->Z2_VINI1
     		SB9->B9_VINI1  := (SZ2->Z2_VINI1*SB9->B9_QINI)
			MsUnlock()
			xNUM += 1
		Endif
	EndIf
   
	SB9->(Dbskip())
	Loop
	
Enddo

Alert("Total - "+Str(xNUM))

Return()
