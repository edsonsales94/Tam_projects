
User Function ATUSA1()



   Processa({|| _TrocaAll()},"Atualiza campo específico de Cod.Usuario (A1_CODUSR) com relação ao vendedor cadastrado")


Return()



Static Function _TrocaAll()

dbSelectArea("SA1")
dbSetOrder(1)                          // filial + produto
dbGotop()
ProcRegua(RecCount())

While !Eof()
	
	_cVend   := SA1->A1_VEND           
	_cCodigo := SA1->A1_COD 	
		
	IncProc("SA1 - Cliente: "+_cCodigo+" ")
	           
	
    dbSelectArea("SA3")
    dbSetOrder(1)                          // Produto
	If dbseek(xFilial("SA3")+_cVend)
	
		RecLock("SA1",.F.)
	    SA1->A1_CODUSR  := SA3->A3_CODUSR
	    MsUnlock()
	EndIf                   
	
	dbSelectArea("SA1")
	dbSkip()
EndDo
                   
Return()
                          

