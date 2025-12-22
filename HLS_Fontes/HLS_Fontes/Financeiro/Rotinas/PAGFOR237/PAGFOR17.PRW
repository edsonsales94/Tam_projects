#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR16

ExecBlock que retorna INFORMACOES COMPLEMENTARES P/ CNABS

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, INFORMACOES COMPLEMENTARES P/ CNABS.

/*/

User Function PAGFOR17()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CINFCOMP,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR17 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna INFORMACOES COMPLEMENTARES P/ CNABS              ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFIN - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

_cInfComp := ""        // para armazenar informacoes complementares
                       // posicao 374 inicio 382 fim, o resto e branco

IF EMPTY(SE2->E2_CODBAR) .AND. SA2->A2_BANCO <> "237" //SEM CODIGO BARRA E BANCO DIFERENTE BRADESCO

	IF SM0->M0_CGC == SA2->A2_CGC  //SE CGC IGUAL CGC CABECALHO CNAB 
    	_cInfComp := "D" //DOC D COM CREDITO EM CONTA CORRENTE
	ELSE
		_cInfComp := "C" //DOC C COM CREDITO EM CONTA CORRENTE 
	ENDIF
	
	_cInfComp := _cInfComp + "000000"
	
  /*	IF SA2->A2_SCTPCC == "1"
		_cInfComp := _cInfComp + "0101"	
	ELSE
		IF SUBSTR(_cInfComp,1,1) == "D"
			_cInfComp := _cInfComp + "0101"
		ELSE		
			_cInfComp := _cInfComp + "1102"
		ENDIF */
  //	ENDIF
//ELSE
   _cInfComp := Substr(SE2->E2_CODBAR,20,25)
ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cInfComp)
Return(_cInfComp)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04