
User Function ATUSB5()



   Processa({|| _TrocaAll()},"Atualiza campo Codigo de Tributação no complemento de produtos B5_CODTRAM")


Return()



Static Function _TrocaAll()

dbSelectArea("SB5")
dbSetOrder(1)                          // filial + produto
dbGotop()
ProcRegua(RecCount())

While !Eof()
	
//	_cVend   := SA1->A1_VEND           
	_cCodigo := SB5->B5_COD 	
		
	IncProc("SB5 - Complemento de Produtos: "+_cCodigo+" ")
	           
	
    dbSelectArea("SB1")
    dbSetOrder(1)                          // Produto
	If dbseek(xFilial("SB1")+_cCodigo)
	   
	   If SB1->B1_TIPO == "MP"
	      dbSelectArea("SB5")
		  RecLock("SB5",.F.)
	      SB5->B5_CODTRAM := "N013"
	      MsUnlock()              
	   ElseIf SB1->B1_TIPO == "MC"
	      dbSelectArea("SB5")
		  RecLock("SB5",.F.)
	      SB5->B5_CODTRAM := "A012"
	      MsUnlock()                   
   	   ElseIf SB1->B1_TIPO == "AT"
	      dbSelectArea("SB5")
		  RecLock("SB5",.F.)
	      SB5->B5_CODTRAM := "A011"
	      MsUnlock()              
	   EndIf
	   
	EndIf                   
	
	dbSelectArea("SB5")
	dbSkip()
EndDo
                   
Return()
                          

