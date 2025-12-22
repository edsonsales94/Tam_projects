#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR03

ExecBlock que retorna Agencia Contas a Pagar

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, Agencia a pagar.

/*/

User Function PAGFOR03()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CAGENCIA,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR03 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna Agencia Contas a Pagar                           ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cAGENCIA:= ""

If EMPTY(SE2->E2_CODBAR)      //SEM COD DE BARRAS
   _cAGENCIA:= SUBSTR(SA2->A2_AGENCIA,1,4) //AGENCIA DO CADASTRO DE FORNECEDORES
ELSE
   IF SUBSTR(SE2->E2_CODBAR,1,3) <>"237"       // NAO E BRADESCO
      _cAGENCIA:= "0" //SE CODIGO BARRA FOR BANCO BRADESCO AGENCIA E IGUAL A ZERO
   ELSE
      _cAGENCIA:= SUBSTR(SE2->E2_CODBAR,20,4)    //AGENCIA e na posicao 20,4 DO CODIGO BARRA
   ENDIF
ENDIF

_cAGENCIA := strzero(int(val(_cAGENCIA)),5)  

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cAGENCIA)
Return(_cAGENCIA)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
