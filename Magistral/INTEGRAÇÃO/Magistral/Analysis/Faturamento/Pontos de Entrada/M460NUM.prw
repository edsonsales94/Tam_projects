#Include "Rwmake.ch"

//====================================================================================================================\\
/*/{Protheus.doc}M460NUM
====================================================================================================================
@description 
O ponto de entrada é executado após a seleção da série na rotina de documento de saída. 
Seu objetivo é permitir a troca da série e do número do documento através de customização local.
O número do documento de saída pode ser alterado através da variável Private cNumero e a série pela variável cSerie.LOCALIZAÇÃO : 

EM QUE PONTO :  

Parâmetros:
Nome		Tipo	 Obrigatório Descrição


==================================================================================================================
Customizações:
Cliente: Super Terminais
==================================================================================================================
@author		TAM194 - ARLINDO NETO
@version	1.0
@since		28/04/2014
@return		Nil, Nil, Nil
@obs
Áreas utilizadas: 

/*/
//====================================================================================================================\\

User Function M460NUM()
	
	If IsInCallStack("ProcJson") .Or. IsInCallStack("U_MGVendaUnica")
		cNumero := cNumNF
	EndIf
	
Return
