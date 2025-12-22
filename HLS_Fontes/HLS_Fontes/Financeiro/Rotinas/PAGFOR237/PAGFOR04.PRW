#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR04

ExecBlock que retorna o digito da Agencia Contas a Pagar

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, Digito da agencia a pagar.

/*/

User Function PAGFOR04()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CAGENCIA,_CX,_NX,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR04 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna digito da Agencia Contas a Pagar                 ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cAGENCIA:= " "
_cX := ""
_Nx :=0

IF (EMPTY(SE2->E2_CODBAR) .AND. SA2->A2_BANCO=="237") .OR. ;
   (!EMPTY(SE2->E2_CODBAR) .AND. SUBSTR(SE2->E2_CODBAR,1,3)=="237")  
        
        If EMPTY(SE2->E2_CODBAR)      //SEM COD DE BARRAS
           _cX:=STRZERO(INT(VAL(SUBSTR(SA2->A2_AGENCIA,1,4))),4)
        ELSE
           IF SUBSTR(SE2->E2_CODBAR,1,3) <>"237"       // NAO E BRADESCO
              _cX:= "00000"
           ELSE
              _cX:= STRZERO(INT(VAL(SUBSTR(SE2->E2_CODBAR,20,4))),4)
           ENDIF
   // 08/11/99 - se tem codigo de barras, manda a agencia zerada
        ENDIF

   _nX := VAL( SUBSTR(_cX,1,1) ) *5
   _nX := _nX + VAL( SUBSTR(_cX,2,1) ) *4
   _nX := _nX +VAL( SUBSTR(_cX,3,1) ) *3
   _nX := _nX +VAL( SUBSTR(_cX,4,1) ) *2
   _nX := ( _nX % 11)

        IF _nX == 0 .OR. _nX == 1
           _cAGENCIA:= "0"
        ELSE
           _nX := 11 - _nX
           _cAGENCIA:= ALLTRIM(strZERO(INT(_NX),1))
        ENDIF

ELSE
  IF SUBSTR(SA2->A2_AGENCIA,5,1)==" "
     _cAGENCIA:=" "
  ELSE
     _cAGENCIA:=STRZERO(INT(VAL(SUBSTR(SA2->A2_AGENCIA,5,1))),1)
  ENDIF
ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cAGENCIA)
Return(_cAGENCIA)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
