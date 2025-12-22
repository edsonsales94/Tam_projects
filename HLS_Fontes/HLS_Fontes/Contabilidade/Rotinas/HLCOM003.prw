#include "rwmake.ch"
/*/{protheus.doc}HLCOM003
Funcao que retorna conta contabil
@author Honda Lock
/*/
User Function HLCOM003()

//D.I.

xCONTA := ""

IF ALLTRIM(SD1->D1_CF) $ "3556|3949" .AND. !EMPTY(SF1->F1_DUPL) 
	xConta := "4101400252"
ENDIF

IF ALLTRIM(SD1->D1_CF) != "3556" .OR. ALLTRIM(SD1->D1_CF) != "3949"
	xConta := "4101120011"
ENDIF	

IF ALLTRIM(SD1->D1_CF) $ "3556|3949" .AND. EMPTY(SF1->F1_DUPL) 
	xConta := "4101400252"
ENDIF


Return(xCONTA)