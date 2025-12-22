
User Function ATUSCJ()



   Processa({|| _TrocaAll()},"Atualiza campo específico de Cod.Usuario (CJ_X_ID) com relação ao vendedor cadastrado")


Return()



Static Function _TrocaAll()

dbSelectArea("SCJ")
dbSetOrder(1)                          // filial + produto
//dbSeek(xFilial("SC5")+"52361 ")
dbGoTop()
ProcRegua(RecCount())

While !Eof()
	             
	If !empty(SCJ->CJ_X_ID) 
	    If SCJ->CJ_X_ID <> "000000"
	   	 dbSkip()
         Loop                    
        EndIf
    EndIf  
    

	_cVend   := SCJ->CJ_CLVEND         
	_cPv     := SCJ->CJ_NUM
		
	IncProc("SCJ - OrcamentoÇ "+_cPv+" ")
	           
	
    dbSelectArea("SA3")
    dbSetOrder(1)                          // Produto
	If dbseek(xFilial("SA3")+_cVend)
	
		RecLock("SCJ",.F.)
	    SCJ->CJ_X_ID  := SA3->A3_CODUSR
	    MsUnlock()
	EndIf                   
	
	dbSelectArea("SCJ")
	dbSkip()
EndDo
                   
Return()
                          

