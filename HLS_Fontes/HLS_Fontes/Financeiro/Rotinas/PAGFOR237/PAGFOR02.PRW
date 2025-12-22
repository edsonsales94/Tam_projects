#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR02

ExecBlock que retorna Banco a pagar.

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, Banco a pagar.

/*/

User Function PAGFOR02()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CBANCO,")

// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR02 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna Banco a Pagar                                    ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFin - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cbanco := ""         // para armazenar o tipo correto

If EMPTY(SE2->E2_CODBAR)      //SEM COD DE BARRAS
   _cbanco := SA2->A2_BANCO  //BANCO DO CADASTRO DE FORNECEDORES
ELSE
   _cbanco := SUBSTR(SE2->E2_CODBAR,1,3) //BANCO IGUAL AO AO DO CODIGO BARRAS
ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cbanco)
Return(_cbanco)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04
