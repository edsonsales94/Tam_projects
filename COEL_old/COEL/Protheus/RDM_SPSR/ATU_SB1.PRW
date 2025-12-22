#include "rwmake.ch"

User Function ATU_SB1()

SetPrvt("_CARQTRB,")

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ATU_SB1  ³ Autor ³Rogerio Batista        ³ Data ³04/04/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Limpa Cadastro de produtos e estruturas                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            com base no campo B1_CLSTATU == "F"                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/



SetPrvt("WB1_COD,WB1_DESC,WB1_TIPO,WB1_POSIPI,WB1_X_DCR")


DbSelectArea("SB1")
DbGoTop()
ProcRegua(RecCount())

While !Eof()
	
	IncProc("Limpando Arquivo Produtos"+SB1->B1_COD)
	
	If SB1->B1_CLSTATU == "F"  
	   
		dbSelectArea("SB2")
		dbSetOrder(1)
		If dbSeek(xFilial("SB2")+SB1->B1_COD) 
		   If SB2->B2_QATU <= 0
		   	   RecLock("SB2",.f.)
		   	   DbDelete()
		       MsUnLock()
		       
		       dbSelectArea("SB1")
    		   RecLock("SB1",.f.)
	     	   DbDelete()
		       MsUnLock()           
		                
	       Else
	  //	     MsgBox("Produto com saldo em estoque, nao pode ser excluido! "+SB1->B1_COD,"Atençao","INFO" ) 
		     dbSelectArea("SB1")
		     dbSkip()
		     Loop
		   EndIf
        Else
		   RecLock("SB1",.f.)
		   //SB1->B1_MSBLQL := "1"
		   DbDelete()
		   MsUnLock()           
		EndIf
		
		
		dbSelectArea("SG1")
		dbSetOrder(1)
		If dbSeek(xFilial("SG1")+SB1->B1_COD)       
		
			While !Eof() .AND. SB1->B1_COD == SG1->G1_COD
				RecLock("SG1",.f.)
				DbDelete()
				MsUnLock()
				dbSkip()
				Loop
			EndDo     

		EndIf
	
	EndIf     
	
	dbSelectArea("SB1")
	DbSkip()
EndDo

Return()
