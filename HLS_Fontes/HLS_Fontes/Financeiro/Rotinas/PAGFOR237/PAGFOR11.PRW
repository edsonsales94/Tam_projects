#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR11

ExecBlock que retorna o retorna a data limite para desconto.

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, data limite para desconto.

/*/

User Function PAGFOR11()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?

SetPrvt("_CDATA,")

//                                                                                                                                                                                                                                                                                                     /*/
// ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ?
// ?uncao    ?PAGFOR11 ?VITOR LUIS FATTORI                   ?5/08/2006?
// ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ?
// ?etorna a data limite para desconto                                    ?
// ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
// ?        ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ?
// ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
// ?Programador    ? Data  ?Motivo da Alteracao                         ?
// ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
// ?Patricia       ?7/11/99? So fornece a data se existir um desconto   ?
// ?               ?3/12/99? Data de Pagamento e Limite para desconto   ?
// ?               ?       ?lterada para digitacao manual. Ao chamar ro-?
// ?               ?       ?ina, chama primeiro tela para data de paga- ?
// ?               ?       ?ento.                                       ?
// ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//

_cDATA := "00000000"

IF !EMPTY(SE2->E2_CODBAR)
   IF (VAL( SUBSTR(SE2->E2_CODBAR,10,10)) )   > 0
      IF ((VAL( SUBSTR(SE2->E2_CODBAR,10,10))/100) - SE2->E2_SALDO) > 0
         _cDATA := Str( Year(SE2->E2_VENCREA),4)+StrZero( Month(SE2->E2_VENCREA),2 )+ ;
         StrZero( Day(SE2->E2_VENCREA) ,2)      
      ENDIF
   endif
ENDIF


// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cDATA)
Return(_cDATA)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
