#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function Cest23i()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

Processa({||RunProc()},"Acerta Saldo Financeiro SB2")// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Processa({||Execute(RunProc)},"Acerta Saldo Financeiro SB2")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 02/09/02 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SB2")
DbSetOrder(1)
DbSeek("01")
ProcRegua(RecCount())

While Eof() == .f. .And. SB2->B2_FILIAL == "01"

    IncProc(SB2->B2_FILIAL+" Acertando Custo Medio Produto "+SB2->B2_COD)

    DbSelectArea("SB9")
    DbSetOrder(1)
    DbSeek("01"+SB2->B2_COD+SB2->B2_LOCAL+"20020430") 

    RecLock("SB2",.f.)
      SB2->B2_CM1     := Round(SB9->B9_VINI1 / SB9->B9_QINI,4) 
      SB2->B2_VATU1   := Round(SB2->B2_QATU  * SB2->B2_CM1 ,2) 
      SB2->B2_CM2     := 0
      SB2->B2_VATU2   := 0
      SB2->B2_CM3     := 0
      SB2->B2_VATU3   := 0
      SB2->B2_CM4     := 0
      SB2->B2_VATU4   := 0
      SB2->B2_CM5     := 0
      SB2->B2_VATU5   := 0
    MsUnLock()

    DbSkip()
EndDo

DbSelectArea("SB2")
DbSetOrder(1)
DbSeek("02")
ProcRegua(RecCount())

While Eof() == .f. .And. SB2->B2_FILIAL == "02"

    IncProc(SB2->B2_FILIAL+" Acertando Custo Medio Produto "+SB2->B2_COD)

    DbSelectArea("SB9")
    DbSetOrder(1)
    DbSeek("02"+SB2->B2_COD+SB2->B2_LOCAL+"20020430") 

    RecLock("SB2",.f.)
      SB2->B2_CM1     := Round(SB9->B9_VINI1 / SB9->B9_QINI,4) 
      SB2->B2_VATU1   := Round(SB2->B2_QATU  * SB2->B2_CM1 ,2) 
      SB2->B2_CM2     := 0
      SB2->B2_VATU2   := 0
      SB2->B2_CM3     := 0
      SB2->B2_VATU3   := 0
      SB2->B2_CM4     := 0
      SB2->B2_VATU4   := 0
      SB2->B2_CM5     := 0
      SB2->B2_VATU5   := 0
    MsUnLock()

    DbSkip()
EndDo


Return
