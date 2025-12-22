#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR13

ExecBlock que retorna o valor do desconto de acordo com o codigo de Barras

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, valor do desconto de acordo com o codigo de Barras.

/*/

User Function PAGFOR13()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CNUMERO,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR13 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?etorna o valor do desconto de acordo com o codigo de Barras           ?
// ?e com CB, Valor do boleto-saldo                                       ?
// ?enao, 0, pois saldo ja esta considerando o desconto                   ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cNUMERO := 0

IF !EMPTY(SE2->E2_CODBAR)
   IF (VAL( SUBSTR(SE2->E2_CODBAR,10,10)) )  > 0

      _cNUMERO := (VAL( SUBSTR(SE2->E2_CODBAR,10,10)) ) - ;
                  (SE2->E2_SALDO*100)

      IF _cNUMERO < 0
         _cNUMERO := 0
      ENDIF

   ENDIF
ELSE
	_cNUMERO := SE2->E2_DECRESC * 100
ENDIF

_cNUMERO := StrZero(INT(_cNUMERO),15)

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cNUMERO)
Return(_cNUMERO)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04