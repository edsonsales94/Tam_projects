#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR10

ExecBlock que retorna o NOSSO NUMERO PARA TITULOS COM CODIGO DE BARRAS E DO BRADESCO   

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, NOSSO NUMERO PARA TITULOS COM CODIGO DE BARRAS E DO BRADESCO   .

/*/

User Function PAGFOR10()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CNNUM,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR10 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna NOSSO NUMERO PARA TITULOS COM CODIGO DE          ?
// ?ARRAS E DO BRADESCO                                                   ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cNNUM := ""

IF !EMPTY(SE2->E2_CODBAR) .AND. SUBSTR(ALLTRIM(SE2->E2_CODBAR),1,3)=="237"
    IF LEN(ALLTRIM(SE2->E2_CODBAR))>=44
        _cNNUM := STRZERO(VAL(SUBSTR(ALLTRIM(SE2->E2_CODBAR),28,9)),9)
    ELSE
        _cNNUM := STRZERO(VAL(SUBSTR(ALLTRIM(SE2->E2_CODBAR),14,7)+SUBSTR(ALLTRIM(SE2->E2_CODBAR),22,2)),9)
    ENDIF
ELSE
    _cNNUM := REPLICATE("0",9)
ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cNNUM)
Return(_cNNUM)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04