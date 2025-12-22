
User Function ATUSF2()



   Processa({|| _TrocaAll()},"Atualiza campo específico de Cod.Usuario (F2_CODUSR) com relação ao vendedor cadastrado")


Return()



Static Function _TrocaAll()

dbSelectArea("SF2")
dbSetOrder(1)                          // filial + produto
//dbSeek(xFilial("SC5")+"52361 ")
dbGoTop()
ProcRegua(RecCount())

While !Eof()
	             
	If !empty(SF2->F2_CODUSR) 
	    If SF2->F2_CODUSR <> "000000"
	   	 dbSkip()
         Loop                    
        EndIf
    EndIf  
    

	_cVend   := SF2->F2_VEND1           
	_cPv     := SF2->F2_DOC
		
	IncProc("SF2 - Nota Fiscal: "+_cPv+" ")
	           
	
    dbSelectArea("SA3")
    dbSetOrder(1)                          // Produto
	If dbseek(xFilial("SA3")+_cVend)
	
		RecLock("SF2",.F.)
	    SF2->F2_CODUSR  := SA3->A3_CODUSR
	    MsUnlock()
	EndIf                   
	
	dbSelectArea("SF2")
	dbSkip()
EndDo
                   
Return()
                          

