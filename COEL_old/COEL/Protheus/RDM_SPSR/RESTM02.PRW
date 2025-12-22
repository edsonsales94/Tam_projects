
User Function RESTM02()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RESTM02  ³ Autor ³ Rogerio Batista       ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para alterar os valores negativos a correto,      ³±±
±±³          ³ quando a filial for Sao Roque deve ser "01"                ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ EXECBLOCK nos campos D3_LOCAL                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

_dData  := GetMv("MV_ULMES")
_nVini  := 0


PROCESSA({|| _ProcArq()},"Processa Arquivos...")

Return()


Static Function _ProcArq()

  

dbselectArea("SB9")
dbSetOrder(1)
dbSeek(xFilial("SB9")+"00000000       ")
//dbGoTop()                                                  
ProcRegua(Reccount())

While !Eof() .AND. B9_FILIAL == xFilial("SB9")

	
	IncProc("Processando produto " + SB9->B9_COD)
	                                            
	
	If Dtos(SB9->B9_DATA) <> Dtos(_dData)
		DbSkip()
		Loop
	EndIf
	
	
	
	If SB9->B9_QINI == 0 
		
		_nVini := 0
	
	ElseIf SB9->B9_QINI < 0 .AND. SB9->B9_VINI1 < 0
	
	    _nVini := 0
	
	ElseIf SB9->B9_QINI>0 .AND. SB9->B9_VINI1<=0
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2")+SB9->B9_COD+SB9->B9_LOCAL)
			
			_nVini := SB2->B2_CM1*SB9->B9_QINI
			
		EndIf
	
	Else
	
		_nVini := SB9->B9_VINI1
	EndIf
	
	dbSelectArea("SB9")
	RecLock("SB9",.F.)
	SB9->B9_VINI1 := _nVini
	MsUnLock()
	
	dbSelectArea("SB9")
	dbSkip()
	
EndDo

Return
