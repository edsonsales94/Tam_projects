
User Function ATUSF2()

	
Processa({|| _TrocaAll()},"Atualiza campo com o Codigo do usuário (Vendedor)")

Return()



Static Function _TrocaAll()

dbSelectArea("SF2")
dbSetOrder(1)                          // Produto+Fornecedor+Loja
dbGotop()
ProcRegua(RecCount())

While !Eof()

	
	IncProc("SF2 - Nota Fiscal: "+SF2->F2_DOC)
	 
	If SF2->F2_VEND1 <> "10001 "
	   dbSkip()
	   Loop
	EndIf          
	
    dbSelectArea("SA3")
    dbSetOrder(1)                          // Produto+Fornecedor+Loja
	If dbseek(xFilial("SA3")+SF2->F2_VEND1)
	
		RecLock("SF2",.F.)
	    SF2->F2_CODUSR  := SA3->A3_CODUSR
	    MsUnlock()
	EndIf                   
	
	dbSelectArea("SF2")
	dbSkip()
EndDo
                   
Return()
                          

