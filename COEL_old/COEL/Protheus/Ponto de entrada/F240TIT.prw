User Function F240TIT
lCHECK:= .T.
If CMODPGTO =="01"
   	//DbSelectArea("SE2TMP")
	//cCLIFOR := E2_FORNECE
	//cLOJA   := E2_LOJA
	DbSelectArea("SA2")
	DbSetOrder(1)
	If DbSeek(xFilial("SA2")+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)
       If A2_BANCO <> CPORT240   
       	  lCHECK := .F.
	   Endif	       
    Endif
Endif
Return(lCHECK)