#INCLUDE "RWMAKE.CH"
/*/{protheus.doc}HLSCTB01
Funcao que retorna conta contabil
@author Honda Lock
/*/

User Function HLSCTB01()
 
 Local cConta := "" 
 cArea:=  GetArea() 

	If substr(SRZ->RZ_CC,1,3)=="301"
			cConta := "4502110011"
		ElseIf substr(SRZ->RZ_CC,1,3)=="302"
			cConta := "4502110011"
		ElseIf substr(SRZ->RZ_CC,1,3)=="303"  
			cConta := "4502110011"
		ElseIf substr(SRZ->RZ_CC,1,3)=="304"
			cConta := "4502110011"
		ElseIf substr(SRZ->RZ_CC,1,3)=="305"
			cConta := "4502110011"
		ElseIf substr(SRZ->RZ_CC,1,3)=="306" 
			cConta := "4502110011"
		ElseIf substr(SRZ->RZ_CC,1,3)=="101" 
			cConta := "4101310011" 
		ElseIf substr(SRZ->RZ_CC,1,3)=="102" 
			cConta := "4101310011"
		ElseIf substr(SRZ->RZ_CC,1,3)=="103"  
			cConta := "4101310011" 
		ElseIf substr(SRZ->RZ_CC,1,3)=="104"
			cConta := "4101310011"
		ElseIf substr(SRZ->RZ_CC,1,3)=="105"
			cConta := "4101310011" 
		ElseIf substr(SRZ->RZ_CC,1,3)=="106"
			cConta := "4101310011" 
		ElseIf substr(SRZ->RZ_CC,1,3)=="107" 
			cConta := "4101310011" 
		ElseIf substr(SRZ->RZ_CC,1,3)=="307"
			cConta := "4101310011"
		Else  
			cConta := "4101320011" 
	EndIf 
	  	
	RestArea(cArea)  	
	
Return(cConta)