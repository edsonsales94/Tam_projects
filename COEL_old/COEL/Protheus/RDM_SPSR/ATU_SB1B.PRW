#include "rwmake.ch"

User Function ATU_SB1B()

SetPrvt("_CARQTRB,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ATU_SB1B  ³ Autor ³Rogerio Batista        ³ Data ³04/04/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza campo B1_MRP                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            com base na estrutura do PA/PI                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/



SetPrvt("WB1_COD,WB1_DESC,WB1_TIPO,WB1_POSIPI,WB1_X_DCR")


dbSelectArea("SB1")
dbSetOrder(1)

While .T.
      WB1_COD     := SPACE(15)
      
      @ 0,0 TO 160,400 DIALOG oDlg1 TITLE "Pesquisa Produto"
      @ 12,010 SAY "CODIGO DO PRODUTO"
      @ 12,070 GET WB1_COD  PICTURE "@!"   F3("SB1") SIZE 40,15
      @ 57,015 BMPBUTTON TYPE 1 ACTION RunProc()
      @ 57,060 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
      ACTIVATE DIALOG oDlg1 CENTERED
      EXIT
ENDDO

Return

Static Function RunProc()  

DbSelectArea("SG1")
DbSetOrder(1)
DbSeek(xFilial("SG1")+WB1_COD)

While !Eof() .AND. SG1->G1_COD == WB1_COD
	
	IncProc("Atualizando produtos"+SG1->G1_COMP)
	
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1")+SG1->G1_COMP)       
				RecLock("SB1",.f.)
				SB1->B1_MRP := "S"
				MsUnLock()
		EndIf
	
	dbSelectArea("SG1")
	DbSkip()

EndDo
MsgBox("Alteracao Gravada Com Sucesso!","Atençao","INFO" ) 
Return()
