#include "rwmake.ch"

/*/{Protheus.doc} SE2CODBAR

Reinicia o MV_NUMSEQB.

@type function
@author Honda Lock
@since 01/11/2017

@return Caracter, Conteudo em branco.

/*/

user function zeraSeq()
                
    Local _cRet := space(6)
      
    dbselectarea("SX6")
    dbsetorder(1)
    dbseek(xfilial()+"MV_NUMSEQB")  
    reclock("SX6",.f.)
    SX6->X6_CONTEUD:="00001"
    msUnlock()
    
Return(_cRet)