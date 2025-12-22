#include "rwmake.ch"       // incluido pelo assistente de conversao do AP6 IDE em 29/05/02

User Function ACTES()	     // incluido pelo assistente de conversao do AP6 IDE em 29/05/02

_avet:= {}
aadd(_avet , "100938")
aadd(_avet , "100937")
aadd(_avet , "100945")
aadd(_avet , "100939")
aadd(_avet , "101335")
aadd(_avet , "101349")
aadd(_avet , "101352")
aadd(_avet , "101353")
aadd(_avet , "101354")
aadd(_avet , "101329")
aadd(_avet , "101330")
aadd(_avet , "101331")
aadd(_avet , "101332")
aadd(_avet , "101333")
aadd(_avet , "101334")
aadd(_avet , "101406")
aadd(_avet , "101405")
aadd(_avet , "101404")
aadd(_avet , "101403")
aadd(_avet , "101357")
aadd(_avet , "101356")
aadd(_avet , "101355")
aadd(_avet , "101633")
aadd(_avet , "101627")
aadd(_avet , "101628")
aadd(_avet , "101629")
aadd(_avet , "101630")
aadd(_avet , "101631")
aadd(_avet , "101632")
aadd(_avet , "101634")
aadd(_avet , "101635")
aadd(_avet , "101774")
aadd(_avet , "101775")
aadd(_avet , "101776")
aadd(_avet , "101777")
aadd(_avet , "101778")
aadd(_avet , "101779")
aadd(_avet , "101780")

Processa({||PROC_SD1()},"AJUSTA SD1")

Static Function Proc_SD1()

_nConta:= 0
dbselectarea("SD1")
dbsetorder(3)
dbseek("02" + "20030201")
procregua( lastrec() )
while !eof()

   incproc("Processando nota " + SD1->D1_DOC)
   if D1_FORNECE == "000067" .and. D1_TES == "010"

      _nPos:= ascan( _avet , SD1->D1_DOC )

      if !empty(_nPos)
	 _nConta:= _nConta + 1
	 reclock("SD1",.F.)
	 SD1->D1_TES:= "045"
	 msunlock()
      endif

   endif

   dbselectarea("SD1")
   dbskip()

enddo         

ALERT( STR(_nConta,5) )
