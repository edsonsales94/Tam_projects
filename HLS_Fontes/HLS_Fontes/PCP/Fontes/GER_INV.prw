
/*/{Protheus.doc} GER_INV

Gera o inventário com base no SB2.

@type function
@author Honda Lock
@since 01/10/2017

/*/

User Function GER_INV()
//Local ltem :=.t.,nI:="000001"
Local ltem :=.t.,nI:=1
DBSELECTAREA("SB2")
SB2->(DBSETORDER(1)) 
DBSELECTAREA("SB7")
SB7->(DBSETORDER(2))
DBSELECTAREA("SB8")
SB8->(DBSETORDER(1))      
DBSELECTAREA("SB1")
SB1->(DBSETORDER(1))  
SB1->(DBGOTOP())
WHILE (!SB1->(EOF()) .AND. XFILIAL("SB1") == SB1->B1_FILIAL)        
      IF SB1->B1_TIPO $ "PA/PI/MP/EM" 
         IF SB1->B1_RASTRO == "N"     
             IF SB2->(DBSEEK(XFILIAL("SB2")+SB1->B1_COD))
				 WHILE (!SB2->(EOF()) .AND. XFILIAL("SB2") == SB2->B2_FILIAL .AND. SB2->B2_COD == SB1->B1_COD)
					IF SB2->B2_QATU != 0
					    RECLOCK("SB7",.T.)  
					    SB7->B7_FILIAL := SB1->B1_FILIAL
					    SB7->B7_COD    := SB1->B1_COD
				    	SB7->B7_LOCAL  := SB2->B2_LOCAL
					    SB7->B7_TIPO   := SB1->B1_TIPO 
					    SB7->B7_DATA   := CTOD("08/01/09") 
					    //SB7->B7_DATA   :=  "20080701"
					    SB7->B7_DOC    := STRZERO(NI++,6)   
					    sb7->b7_quant  := 0 //sb2->b2_qatu
					    SB7->B7_LOTECTL:= SB8->B8_LOTECTL
					    SB7->B7_DTVALID:= SB8->B8_DTVALID
            	        MSUNLOCK("SB7")                  
         			ENDIF
         			SB2->(DBSKIP())
				 END
			 ENDIF
         ELSE 
			 LTEM := .T.
           	 IF SB8->(DBSEEK(XFILIAL("SB8")+SB1->B1_COD))		 	 		 	 
				WHILE (!SB8->(EOF()) .AND. XFILIAL("SB8") == SB8->B8_FILIAL .AND. SB8->B8_PRODUTO == SB1->B1_COD)
					IF SB8->B8_SALDO != 0        
					    IF !SB7->(DBSEEK(XFILIAL("SB7")+SPACE(6)+SB8->B8_LOTECTL+SB8->B8_PRODUTO+SB8->B8_LOCAL)) 
						    RECLOCK("SB7",.T.)  
						    SB7->B7_FILIAL := SB1->B1_FILIAL
						    SB7->B7_COD    := SB1->B1_COD
					    	SB7->B7_LOCAL  := SB8->B8_LOCAL
						    SB7->B7_TIPO   := SB1->B1_TIPO
						    SB7->B7_LOTECTL:= SB8->B8_LOTECTL
						    SB7->B7_DTVALID:= SB8->B8_DTVALID
					    	sb7->b7_quant  := 0 //sb8->b8_saldo
						    SB7->B7_DATA   := CTOD("08/01/09")
						    //SB7->B7_DATA   :=  "20080701"
						    SB7->B7_DOC    := STRZERO(NI++,6) 
	                    	MSUNLOCK("SB7")                  
		                    ltem := .f.
		                  ENDIF
					ENDIF
					SB8->(DBSKIP())
		 		END  
			 Endif
	         IF LTEM   // PODE TER NO SB2 E NAO TEM LOTE
             	IF SB2->(DBSEEK(XFILIAL("SB2")+SB1->B1_COD))		 	 
					 WHILE (!SB2->(EOF()) .AND. XFILIAL("SB2") == SB2->B2_FILIAL .AND. SB2->B2_COD == SB1->B1_COD)
						IF SB2->B2_QATU != 0
						    RECLOCK("SB7",.T.)  
						    SB7->B7_FILIAL := SB1->B1_FILIAL
						    SB7->B7_COD    := SB1->B1_COD
					    	SB7->B7_LOCAL  := SB2->B2_LOCAL
					    	SB7->B7_TIPO   := SB1->B1_TIPO
						    SB7->B7_DATA   := CTOD("08/01/09")  
						    //SB7->B7_DATA   :=  "20080701"
						    SB7->B7_DOC    := STRZERO(NI++,6)
    					    sb7->b7_quant  := 0 //sb2->b2_qatu						    
//						    SB7->B7_LOTECTL:= SB8->B8_LOTECTL
//						    SB7->B7_DTVALID:= SB8->B8_DTVALID
            		        MSUNLOCK("SB7")                  
        	 			ENDIF
    	     			SB2->(DBSKIP())
					 END
				ENDIF				
		     Endif  
	     ENDIF
	  ENDIF
      SB1->(dbskip())
END
Return nil