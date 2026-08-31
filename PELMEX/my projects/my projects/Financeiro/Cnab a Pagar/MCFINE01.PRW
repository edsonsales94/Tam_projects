#INCLUDE "rwmake.ch"

/*_____________________________________________________________________________________
¦ Função    ¦ MCFINE01   ¦ Autor ¦ MICROSIGA			   ¦ Data ¦ 00/00/0000 |
+-----------+------------+-------+---------------------------------+------+------------+
¦ Descriçäo ¦ Retorna o tipo da conta para o CNAB do Bradesco para TED e DOC           ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

user function MCFINE01()
 
    cTipo :=""
    cTipCta :=""  
    
   	FIL->(dbSetOrder(1))                            
	If FIL->(dbSeek(XFILIAL("FIL")+SE2->E2_FORNECE+SE2->E2_LOJA+"1"+SE2->E2_FORBCO+SE2->E2_FORAGE+SE2->E2_FORCTA))
		cTipo := FIL->FIL_TIPCTA
	Else
		FIL->(dbgotop())
		If FIL->(dbSeek(XFILIAL("FIL")+SE2->E2_FORNECE+SE2->E2_LOJA+"2"+SE2->E2_FORBCO+SE2->E2_FORAGE+SE2->E2_FORCTA))
			cTipo:= FIL->FIL_TIPCTA
		Endif
	Endif   
	
	IF cTipo =="2"
		cTipCta :="PP"
	Else
		cTipCta :="CC" 
	ENDIF
                                                                  
return cTipCta
