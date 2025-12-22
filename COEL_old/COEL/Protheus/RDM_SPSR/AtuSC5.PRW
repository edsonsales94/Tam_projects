
User Function ATUSC5()

	
Processa({|| _TrocaAll()},"Atualiza Codigo do usuário (Vendedor)")

Return()



Static Function _TrocaAll()


_cCnpj    := Space(14)
_cHoraIni := Time()
_cHoraFim := ''

TrocaSA1()
//TrocaSC5()
//TrocaSF2()

_cHoraFim := Time()
Aviso("ATUALIZA CODIGO DE USUARIO", "Final do Processo! Inicio: " + _cHoraIni + " / Final: " + _cHoraFim, {"OK"})

Return()


Static Function TrocaSA1()

dbSelectArea("SA1")
dbSetOrder(1)                          // Produto+Fornecedor+Loja
dbGotop()
ProcRegua(RecCount())

While !Eof()

	
	IncProc("SA1 - Cliente: "+SA1->A1_COD)
	 
    dbSelectArea("SA3")
    dbSetOrder(1)                          // Produto+Fornecedor+Loja
	If dbseek(xFilial("SA3")+SA1->A1_VEND)
	
		RecLock("SA1",.F.)
	    SA1->A1_CODUSR  := SA3->A3_CODUSR
	    MsUnlock()
	EndIf                   
	
	dbSelectArea("SA1")
	dbSkip()
EndDo
                   
Return()


Static Function TrocaSC5()
                          
dbSelectArea("SC5")
dbSetOrder(1)                          // Produto+Fornecedor+Loja
dbGotop()
ProcRegua(RecCount())

While !Eof()

	
	IncProc("SC5 - Pedido: "+SC5->C5_NUM)
	 
    dbSelectArea("SA3")
    dbSetOrder(1)                          // Produto+Fornecedor+Loja
	If dbseek(xFilial("SA3")+SC5->C5_VEND1)
	
		RecLock("SC5",.F.)
	    SC5->C5_CODUSR  := SA3->A3_CODUSR
	    MsUnlock()
	EndIf                   
	
	dbSelectArea("SC5")
	dbSkip()
EndDo
                   
Return()
                          
Static Function TrocaSF2()

dbSelectArea("SF2")
dbSetOrder(1)                          // Produto+Fornecedor+Loja
dbGotop()
ProcRegua(RecCount())

While !Eof()

	
	IncProc("SF2 - Nota Fiscal: "+SF2->F2_DOC)
	 
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
          
