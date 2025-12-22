#include "rwmake.ch"

User Function EXPORT()

if sm0->m0_codigo != "01" 
   msgbox("Esta rotina so pode ser executada na empresa COEL")
   return                 
ElseIf sm0->m0_codfil != "01"
   msgbox("Esta rotina so pode ser executada na empresa COEL")
   return                 
endif

@ 200,1 TO 400,450 DIALOG oDlg TITLE "Consolidacao de Movimentacao"
@ 5,10 TO 75,215
@15,018 SAY "Esta rotina ira consolidar as movimentacoes de estoque"
@35,018 SAY "geradas na tabela SZM"

@ 80,018 BMPBUTTON TYPE 01 ACTION Processa( {|| Proc_SZM() })
@ 80,058 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED
Return

Static Function PROC_SZM()
Local _dDatFec:= getmv("MV_ULMES")

_cOK:= "S"

_cImp:= " "

dbselectarea("SZM")
ProcRegua( lastrec() )
dbsetorder(1)
dbseek(xFilial() + _cImp)
while !eof()

  incProc(OemToAnsi("Processando Nota " + ZM_NFES + ZM_DOCSERI))

  _nTPM:= 3

  aVetor:= {}
  lMsErroAuto:= .F.
  lMshelpAuto:= .t.

  _dDatMov:= if(SZM->ZM_DATA <= _dDatFec, _dDatFec + 1, SZM->ZM_DATA)

  aVetor:= { { "D3_TM"    , SZM->ZM_TM      , NIL } ,;
	     { "D3_COD"       , SZM->ZM_COD     , NIL } ,;      
	     { "D3_DOC"       , SUBS(SZM->ZM_DOCSERI,1,6), NIL } ,;	     
	     { "D3_LOCAL"     , SZM->ZM_LOCAL   , NIL } ,;
	     { "D3_EMISSAO"   , _dDatMov        , NIL },;
	     { "D3_QUANT"     , SZM->ZM_QUANT   , NIL } }

  MSExecAuto( {|x,y| mata240(x,y)},aVetor,_nTPM)  // Inclusao

  If lMsErroAuto
     _cImpOK:= "X"
     _cOK   := "N"
   //  if SZM->ZM_IMPOK == " X"
     	Mostraerro()
   //  endif
  else
     _cImpOK:= "S"
  endif

  reclock("SZM",.f.)
  SZM->ZM_IMPOK:= _cImpOK
  msunlock()

  dbselectarea("SZM")
  dbseek(xFilial() + _cImp)

enddo

dbselectarea("SZM")
dbseek(xFilial() + "X")
while !eof() 
   reclock("SZM",.f.)
   SZM->ZM_IMPOK:= " X"
   msunlock()

   dbseek(xFilial() + "X")
enddo

if _cOK == "N"
   Alert("Houve problemas com algum movimento. Verifique Tabela SZM")
endif
