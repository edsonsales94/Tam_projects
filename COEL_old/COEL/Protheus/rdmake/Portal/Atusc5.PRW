
User Function ATUSC5()



   Processa({|| _TrocaAll()},"Atualiza campo específico de Cod.Usuario (C5_CODUSR) com relação ao vendedor cadastrado")


Return()



Static Function _TrocaAll()

dbSelectArea("SC5")
dbSetOrder(1)                          // filial + produto
//dbSeek(xFilial("SC5")+"52361 ")
dbGoTop()
ProcRegua(RecCount())

While !Eof()
	             
	If !empty(SC5->C5_CODUSR) 
	    If SC5->C5_CODUSR <> "000000"
	   	 dbSkip()
         Loop                    
        EndIf
    EndIf  
    

	_cVend   := SC5->C5_VEND1           
	_cPv     := SC5->C5_NUM
		
	IncProc("SC5 - Pedido: "+_cPv+" ")
	           
	
    dbSelectArea("SA3")
    dbSetOrder(1)                          // Produto
	If dbseek(xFilial("SA3")+_cVend)
	
		RecLock("SC5",.F.)
	    SC5->C5_CODUSR  := SA3->A3_CODUSR
	    MsUnlock()
	EndIf                   
	
	dbSelectArea("SC5")
	dbSkip()
EndDo
                   
Return()
                          

