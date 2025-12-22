#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR08

ExecBlock que retorna o NUMERO DA CARTEIRA PARA TITULOS COM CODIGO DE BARRAS E DO BRADESCO 

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, NUMERO DA CARTEIRA PARA TITULOS COM CODIGO DE BARRAS E DO BRADESCO .

/*/

User Function PAGFOR08()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CCARTEIRA,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR08 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna NUMERO DA CARTEIRA PARA TITULOS COM CODIGO DE    ?
// ?ARRAS E DO BRADESCO                                                   ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cCARTEIRA := ""

IF !EMPTY(SE2->E2_CODBAR) .AND. SUBSTR(ALLTRIM(SE2->E2_CODBAR),1,3)=="237"
    IF LEN(ALLTRIM(SE2->E2_CODBAR))>=44
        _cCARTEIRA := STRZERO(VAL(SUBSTR(ALLTRIM(SE2->E2_CODBAR),24,2)),3)
    ELSE
        _cCARTEIRA := STRZERO(VAL(SUBSTR(ALLTRIM(SE2->E2_CODBAR),9,1)+SUBSTR(ALLTRIM(SE2->E2_CODBAR),11,1)),3)
    ENDIF
ELSE
    _cCARTEIRA := REPLICATE("0",3)
ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cCARTEIRA)
Return(_cCARTEIRA)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04