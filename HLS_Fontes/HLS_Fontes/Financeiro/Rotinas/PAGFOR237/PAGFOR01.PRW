#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR01

ExecBlock que retorna CNPJ do fornecedor

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, CNPJ do fornecedor.

/*/

User Function PAGFOR01()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CCTABAN,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR01?VITOR LUIS FATTORI                    ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna CNPJ do fornecedor                               ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cCTABAN := ""         //

IF !EMPTY(SA2->A2_CGC)
   IF LEN(alltrim(SA2->A2_CGC))>=14
      _cCTABAN := SA2->A2_CGC        //CGC
   ELSE
      _cCTABAN := ALLTRIM(SA2->A2_CGC)         // CPF
      _cCTABAN := SUBSTR(_cCTABAN,1,LEN(_cCTABAN)-2) + ;
                  "0000"+ ;
                  SUBSTR(_cCTABAN,LEN(_cCTABAN)-1,2)
   endif
      _cCTABAN := alltrim(_cCTABAN)
      _cCTABAN := repl("0",15-len(_cCTABAN)) + _cCTABAN
ELSE
	_cCTABAN := "111111111111111" 
ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cCTABAN)
Return(_cCTABAN)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
