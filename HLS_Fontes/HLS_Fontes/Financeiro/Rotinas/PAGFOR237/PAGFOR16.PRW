#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

/*/{Protheus.doc} PAGFOR16

ExecBlock que retorna a modalidade de pagamanto para CNABS

@type function
@author Honda Lock
@since 01/10/2017

@return Caracter, modalidade de pagamanto para CNABS.

/*/

User Function PAGFOR16()        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("CTIPOPGT,_CTIPOPGT,")

//                                                                                                                                                                                                                                                                                                     /*/
// 旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴?
// ?uncao    ?PAGFOR16 ?VITOR LUIS FATTORI                   ?5/08/2006?
// 쳐컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴?
// ?xecBlock que retorna a modalidade de pagamanto para CNABS             ?
// 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
// ?so SigaFIN - Empresa Foxconn - CNAB                                   ?
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//

cTipoPGT := ""         // para armazenar o tipo correto

If EMPTY(SE2->E2_CODBAR)          // nao tem codigo de barras
   If SA2->A2_BANCO == "237" .AND. !EMPTY(SA2->A2_AGENCIA) // BANCO E AGENCIA BRADESCO
        IF EMPTY(SA2->A2_NUMCON) // NAO TEM CONTA 
              _cTipoPGT := "02"       // sem conta e sem barras, e Cheque OP
        Else //COM CONTA 
              _cTipoPGT := "05"   // sem barras com conta no Bradesco faz deposito
        ENDIF
   Else
		IF SE2->E2_MODSPB == "1" .or. SE2->E2_MODSPB == " "
        	IF SE2->E2_SALDO >= 5000.00
        		_cTipoPGT := "08"    // ted str
		    ELSE
	     		_cTipoPGT := "03"   // DOC
			ENDIF
		ELSEIF SE2->E2_MODSPB == "3"
			IF SE2->E2_SALDO >= 5000.00
        		_cTipoPGT := "08"    // ted str
		    ELSE
	     		_cTipoPGT := "03"   // DOC
			ENDIF
		ELSEIF SE2->E2_MODSPB == "2"
			IF SE2->E2_SALDO >= 5000.00
        		_cTipoPGT := "07"    // ted cip
		    ELSE
	     		_cTipoPGT := "03"   // DOC
			ENDIF
		ENDIF
   EndIf
Else
   _cTipoPGT := "31"   // com barras, titulos
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 15/06/04 ==> __Return(_cTipoPGT)
Return(_cTipoPGT)        // incluido pelo assistente de conversao do AP6 IDE em 15/06/04