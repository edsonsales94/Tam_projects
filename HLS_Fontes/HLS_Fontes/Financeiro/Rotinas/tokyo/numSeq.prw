#include "rwmake.ch"

/*/{Protheus.doc} numSeq

Altera o campo do parametro MV_NUMSEQB.

@type function
@author Honda Lock
@since 01/11/2017

@return Caracter, Conteudo do campo MV_NUMSEQB.

/*/

user Function numSeq()
      
    Local _cRet := ""
    
    _cRet := alltrim(getmv("MV_NUMSEQB"))
    
    dbselectarea("SX6")
    dbsetorder(1)
    dbseek(xfilial()+"MV_NUMSEQB")
    
    if !eof()
       dbselectarea("SX6")
       reclock("SX6",.f.)
       SX6->X6_CONTEUD:=strzero((val(_cRet)+1),5)
       msUnlock()
    endif    

Return(_cRet)