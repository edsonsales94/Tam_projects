#include "rwmake.ch"       // incluido pelo assistente de conversao do AP6 IDE em 29/05/02

User Function RKY()	   // incluido pelo assistente de conversao do AP6 IDE em 29/05/02


Processa({||excl_sd4()},"Exclui empenhos sem op")

Processa({||proc_sc2()},"Ajusta empenhos de op")

Processa({||emp_sb2()},"Ajusta empenhos do SB2")


Static Function Proc_SC2()

dbselectarea("SC2")
dbgotop()
procregua( lastrec() )
while !eof()

   incproc("Processando op " + SC2->C2_NUM)

   ajus_sd4()

   dbselectarea("SC2")
   dbskip()

enddo

Static Function Ajus_SD4()

dbselectarea("SD4")
dbsetorder(2)
_ChaveD4:= xFilial() + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
dbseek(xFilial() + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
while !eof() .and. D4_FILIAL + subs(D4_OP,1,11) == _ChaveD4
	
	_nQuant:= SC2->C2_QUANT - SC2->C2_QUJE
	dbselectarea("SG1")
	dbsetorder(1)
	dbseek(xFilial() + SC2->C2_PRODUTO + SD4->D4_COD)
	if !eof()
	   reclock("SD4",.F.)
	   SD4->D4_QUANT:= _nQuant * SG1->G1_QUANT
	   msunlock()
	endif
	
	dbselectarea("SD4")
	dbskip()
	
enddo

Static Function Excl_SD4()

dbselectarea("SD4")
dbgotop()
procregua( lastrec() )
while !eof()

   incproc("Processando op " + SD4->D4_OP)
     
   dbselectarea("SC2")
   dbsetorder(1)
   dbseek( xFilial() + subs(SD4->D4_OP,1,11) )
   if eof()
      reclock("SD4",.F.)
      dbdelete()
      msunlock()
   endif

   dbselectarea("SD4")
   dbskip()
	
enddo

Static Function Emp_SB2()

_cFilial:= xFilial()
dbselectarea("SD4")
procregua( lastrec() )
dbsetorder(3)
dbseek( _cFilial )
while !eof() .and. D4_FILIAL == _cFilial
   _chave := D4_COD + D4_LOCAL
   _ntotal:= 0
   while D4_COD + D4_LOCAL == _chave

      incproc("Processando op " + SD4->D4_OP)
      _ntotal:= _ntotal + D4_QUANT
      dbskip()
   enddo

   dbselectarea("SB2")
   dbsetorder(1)
   dbseek( xFilial() + _chave )
   if !eof()
      reclock("SB2",.F.)
      SB2->B2_QEMP:= _ntotal
      msunlock()
   endif

   dbselectarea("SD4")

enddo
