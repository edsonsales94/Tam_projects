
User Function ATUSB1()



   Processa({|| _TrocaAll()},"Atualiza campo Codigo de Tributação no complemento de produtos B5_CODTRAM")


Return()



Static Function _TrocaAll()

dbSelectArea("SB1")
dbSetOrder(1)                          // filial + produto
dbGotop()
ProcRegua(RecCount())

While !Eof()
	
//	_cVend   := SA1->A1_VEND           
	_cCodigo := SB1->B1_COD 	
		
	IncProc("SB1 - Cadastro de Produtos: "+_cCodigo+" ")
	           
	
    dbSelectArea("DA1")
    dbSetOrder(2)                          // Produto
	If dbseek(xFilial("DA1")+_cCodigo)
	   
	   If !EMPTY(DA1->DA1_FRETE)
	      dbSelectArea("SB1")
		  RecLock("SB1",.F.)
	      SB1->B1_CUSTD := DA1->DA1_FRETE
	      MsUnlock()              
	   EndIf
	   
	EndIf                   
	
	dbSelectArea("SB1")
	dbSkip()
EndDo
                   
Return()
                          

