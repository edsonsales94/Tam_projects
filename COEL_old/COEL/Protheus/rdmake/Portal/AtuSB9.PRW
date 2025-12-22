
User Function ATUSB9()



   Processa({|| _TrocaAll()},"Atualiza campo Codigo de Tributação no complemento de produtos B5_CODTRAM")


Return()



Static Function _TrocaAll()

dbSelectArea("SB9")
dbSetOrder(1)                          // filial + produto
dbGotop()
ProcRegua(RecCount())

While !Eof()
	
//	_cVend   := SA1->A1_VEND           
	_cCodigo := SB9->B9_COD 	
		
	IncProc("SB9 - Saldos iniciais: "+_cCodigo+" ")
	           
	
    dbSelectArea("SB1")
    dbSetOrder(1)                          // Produto
	If dbseek(xFilial("SB1")+_cCodigo)
	   
	   If !SB1->B1_TIPO $ "MC/MP/AT"
	      dbSelectArea("SB9")
		  RecLock("SB9",.f.)
           DbDelete()
          MsUnLock()           
	              
	   EndIf
	   
	EndIf                   
	
	dbSelectArea("SB9")
	dbSkip()
EndDo
                   
Return()
                          

