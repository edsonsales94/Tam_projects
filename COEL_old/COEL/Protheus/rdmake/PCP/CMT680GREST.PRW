/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT680GREST ³ Autor ³Rogerio Oliveira     ³ Data ³14/01/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Ajusta SB2-B2-QEMP quando estorna uma producao por operacao ³±±
±±³Descri‡…o ³ na operacao 01                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ESPECIFICO COEL CONTROLES ELETRICOS LTDA                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"        

User Function MT680GREST()

Local _cAlias := Alias()
Local _nOrder := IndexOrd()
Local _nRecno := Recno()
 
dbSelectarea("SH6")


	If SH6->H6_OPERAC == "01" .and. SH6->H6_X_ES == "S"
		
		DbSelectArea("SC2")
		DbSetOrder(1) 
		If MsSeek(xFilial("SC2") + Substr(SH6->H6_OP,1,11))
			
			RecLock("SC2",.f.)
			SC2->C2_TPOP := "P"
			MsUnLock()
			
		EndIf
		
		dbSelectArea("SD4")
		dbSetOrder(2)
		dbSeek(xFilial("SD4")+SH6->H6_OP,.T.)
		While !Eof() .And. D4_FILIAL == xFilial("SD4") .And. D4_OP == SH6->H6_OP
			
			DbSelectArea("SB2")
			DbSetOrder(1)
			IF dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)
				RecLock("SB2",.f.)
				SB2->B2_QEMP    := SB2->B2_QEMP - SD4->D4_QTDEORI
				SB2->B2_QEMPPRE := SB2->B2_QEMPPRE + SD4->D4_QTDEORI
				MsUnLock()
				
			EndIf
			
			dbSelectArea("SD4")
			dbSkip()
			
		EndDo
	EndIf    
	
DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
DbGoTo(_nRecno)

Return(nil)

