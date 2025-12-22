#include "rwmake.ch"       // incluido pelo assistente de conversao do AP6 IDE em 29/05/02

User Function CCOM01A()        // incluido pelo assistente de conversao do AP6 IDE em 29/05/02

Processa({||PROC_SC7()},"Reajusta Precos")

Static Function Proc_SC7()

dbselectarea("SC7")
dbgotop()
while !eof()

   incproc("Processando pedido " + SC7->C7_NUM)

   if C7_MOEDA == 1 .or. C7_QUJE >= C7_QUANT
      dbskip()
      loop
   endif
   
   _nfator:= 0
   _nPreco:= 0
   Dbselectarea("SM2")
   Dbsetorder(1)
   IF Dbseek(DdataBase)
      do Case
	 case SC7->C7_MOEDA==2
              _nfator:= SM2->M2_MOEDA2
	 case SC7->C7_MOEDA==3
              _nfator:= SM2->M2_MOEDA3
	 case SC7->C7_MOEDA==4
              _nfator:= SM2->M2_MOEDA4
	 case SC7->C7_MOEDA==5
              _nfator:= SM2->M2_MOEDA5
	 case SC7->C7_MOEDA==6
              _nfator:= SM2->M2_MOEDA6
	 case SC7->C7_MOEDA==7
              _nfator:= SM2->M2_MOEDA7
	 case SC7->C7_MOEDA==8
              _nfator:= SM2->M2_MOEDA8
	 case SC7->C7_MOEDA==9
              _nfator:= SM2->M2_MOEDA9
      endcase
      
      _nPreco:= Round(SC7->C7_PRECO2 * _nfator,4)

   Endif

   if !empty(_nPreco)
      reclock("SC7",.F.)
      SC7->C7_PRECO:= _nPreco
      SC7->C7_TOTAL:= _nPreco * SC7->C7_QUANT
      msunlock()
   endif

   dbselectarea("SC7")
   dbskip()

enddo
