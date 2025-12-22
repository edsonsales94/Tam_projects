#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR07

ExecBlock que retorna o NUMERO DO PAGAMENTO

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, NUMERO DO PAGAMENTO.

/*/

User Function PAGFOR07()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CNUMERO,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR07 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna NUMERO DO PAGAMENTO (PARTE CGC+PREF.+TITULO+PARC.?
// ?ANCO BRADESCO FAZ CONSISTENCIA DO NUMERO DE PAGAMENTO EFETUADO, MAS   ?
// ?AO LEVA EM CONSIDERACAO O FORNECEDOR. NO CASO DA NF SERIE UNI 000030, ?
// ?E PAGA PARA UM FORNECEDOR, NAO PODERA SER PAGA NOVAMENTE, MESMO PARA  ?
// ?UTRO FORNECEDOR. ENVIAMOS PARA ISSO OS 6 ULTIMOS DIGITOS DO FORNECEDOR?
// ?OMO PARTE DO NUMERO DO PAGAMENTO. AINDA PODEREMOS TER PROBLEMAS, MAS  ?
// ? O QUE TEM MENOR POSSIBILIDADE. P/ SE ENVIAR O CODIGO DO FORNECEDOR,  ?
// ?AO TEMOS ESPACO PARA A LOJA. SE FOREM AS PRIMEIRAS POSICOES DO CGC,   ?
// ?EREMOS PROBLEMAS COM FILIAIS.                                         ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cNUMERO := ""

_cNUMERO := SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_NUM + SE2->E2_PARCELA

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cNUMERO)
Return(_cNUMERO)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
