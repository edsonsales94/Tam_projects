#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR05

ExecBlock que retorna a Conta do Banco a Pagar

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, Conta do Banco a Pagar.

/*/

User Function PAGFOR05()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CCTABAN,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR05 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna Conta do Banco a Pagar                           ?
// ?lterado em 11/11/99 - banco 399 tem 2 digitos na conta                ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cCTABAN := ""    

If EMPTY(SE2->E2_CODBAR)      //SEM COD DE BARRAS
	_cCTABAN := Substr(SA2->A2_NUMCON,1,08)
ELSE
   IF SUBSTR(SE2->E2_CODBAR,1,3) <> "237"
     _cCTABAN := REPLICATE("0",6) 
   ELSE
     _cCTABAN := SUBSTR(SE2->E2_CODBAR,37,7)
   ENDIF
ENDIF

_cCTABAN := strzero(int(val(_cCTABAN)),13)

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cCTABAN)
Return(_cCTABAN)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
