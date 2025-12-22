#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR06

ExecBlock que retorna o DIGITO DA CONTA DO BANCO C. A PAGAR

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter,  DIGITO DA CONTA DO BANCO C. A PAGAR.

/*/

User Function PAGFOR06()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

Local _cDigito:='P'
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

//SetPrvt("_CDIGITO,_CX,_NX1,_NX2,_NX3,_NX4")
SetPrvt("_CX,_NX1,_NX2,_NX3,_NX4")
SetPrvt("_NX5,_NX6,_NX7,_NY,_NX,")
         

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR06 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna DIGITO DA CONTA DO BANCO C. A PAGAR              ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cDigito:= "P"         

If EMPTY(SE2->E2_CODBAR)      //SEM COD DE BARRAS
   _cDigito:= Substr(SA2->A2_NUMCON,9,2)
// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==>    __Return(_cDIGITO)
   Return(_cDIGITO)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
ELSE
   IF SUBSTR(SE2->E2_CODBAR,1,3)<>"237"
     _cDigito:= "0" 
// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==>      __Return(_cDIGITO)
Return(_cDIGITO)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
   ELSE
    _cX := SUBSTR(SE2->E2_CODBAR,37,7)
    // CALCULA O DIGITO                                  
      _nX1 := VAL( SUBSTR(_cX,1,1) ) *2
      _nX2 := VAL( SUBSTR(_cX,2,1) ) *7
      _nX3 := VAL( SUBSTR(_cX,3,1) ) *6
      _nX4 := VAL( SUBSTR(_cX,4,1) ) *5
      _nX5 := VAL( SUBSTR(_cX,5,1) ) *4
      _nX6 := VAL( SUBSTR(_cX,6,1) ) *3 
      _nX7 := VAL( SUBSTR(_cX,7,1) ) *2
      _nY := _nX1+_nX2+_nX3+_nX4+_nX5+_nX6+_nX7
      _nX := ( _nY % 11)
      IF _nX == 0
        _cDigito := 0
        _cDigito := ALLTRIM(strZERO(INT(_NX),1))
      Elseif _nX == 1
        _cDigito := "P"
      else
        _nX := 11 -_nX
        _cDigito:=ALLTRIM(strZERO(INT(_NX),1))
      endif

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==>    __Return(_cDIGITO)
Return(_cDIGITO)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
   ENDIF
ENDIF