
User Function ATUSD2()

	
Processa({|| _TrocaAll()},"Atualiza SD2 - Grupo contabil e Regime de tributacao")

Return()



Static Function _TrocaAll()


_cCnpj    := Space(14)
_cHoraIni := Time()
_cHoraFim := ''

TrocaSD2()
TrocaSD21()

_cHoraFim := Time()
Aviso("ATUALIZA ITENS DA NF DE SAIDA", "Final do Processo! Inicio: " + _cHoraIni + " / Final: " + _cHoraFim, {"OK"})

Return()


Static Function TrocaSD2()

dbSelectArea("SA1")
dbSetOrder(1)                        
dbGotop()
ProcRegua(RecCount())

While !Eof()

	
	IncProc("SA1 - Cliente: "+SA1->A1_COD)
	 
    dbSelectArea("SD2")
    dbSetOrder(9)                          // Produto+Fornecedor+Loja
	dbseek(xFilial("SD2")+SA1->A1_COD+SA1->A1_LOJA)
	
	While !EOF() .and. SD2->D2_CLIENTE+SD2->D2_LOJA == SA1->A1_COD+SA1->A1_LOJA
		RecLock("SD2",.F.)
	    SD2->D2_REGTRIB  := SA1->A1_REGTRIB
	    MsUnlock()
	    
	    dbSkip()
	    Loop      
	EndDo   
	
	dbSelectArea("SA1")
	dbSkip()
EndDo
                   
Return()


Static Function TrocaSD21()
                          
dbSelectArea("SB1")
dbSetOrder(1)                          // Produto+Fornecedor+Loja
dbGotop()
ProcRegua(RecCount())

While !Eof()

	
	IncProc("SB1 - PRODUTO: "+SB1->B1_COD)
	 
    dbSelectArea("SD2")
    dbSetOrder(1)                          // Produto+Fornecedor+Loja
	dbseek(xFilial("SD2")+SB1->B1_COD)
	
	While !Eof() .and. D2_COD == SB1->B1_COD
		RecLock("SD2",.F.)
	    SD2->D2_CLCGRP  := SB1->B1_CLCGRP
	    MsUnlock()                       
	 dbSkip()
	 Loop
	 EndDo
	
	dbSelectArea("SB1")
	dbSkip()
EndDo
                   
Return()
                          
          
