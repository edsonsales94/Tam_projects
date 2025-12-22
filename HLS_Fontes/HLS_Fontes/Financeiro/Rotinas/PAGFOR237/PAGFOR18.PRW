#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR18

ExecBlock que retorna a conta do banco com 7 digitos e sem o digito de verificacao da conta bancaria

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, conta do banco com 7 digitos.

/*/

User Function PAGFOR18()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_cCONTA,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR14 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?etorna a conta do banco com 7 digitos e sem o digito de verificacao   ?
// ?a conta bancaria                                                      ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Maittra - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//
    
_cConta:=space(7)

_cConta := subs(ALLTRIM(SA6->A6_NUMCON),1,len(ALLTRIM(SA6->A6_NUMCON))-1)
_cConta := subs(_cConta,1,7)
_cConta := repl('0',7-len(_cConta))+_cConta 


// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cNUMERO)
Return(_cConta)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

