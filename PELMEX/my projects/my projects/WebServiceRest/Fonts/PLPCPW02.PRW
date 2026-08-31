#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
/*#include 'PROTHEUS.CH'
#include 'APWEBSRV.CH'
#include 'Topconn.ch'
*/ 
/************************************************************************************
* WebService......: WS_ORDEMPRODUCAO
* Objetivo........: WebService para Consulta para Apontamento de Produção
* Autor...........: Stan Lee Lopes
* Data............: 09/08/2019
* Alterado........: 
*/

WSRESTFUL ValidaOP DESCRIPTION "Valida OP"

WSDATA OP AS STRING
//WSDATA SITUACAO AS STRING

WSMETHOD GET DESCRIPTION "Serviço de Consulta para Apontamento de Produção" WSSYNTAX "/ValidaOP || /ValidaOP/{OP}"

END WSRESTFUL

// O metodo GET nao precisa necessariamente receber parametros de querystring, por exemplo:
// WSMETHOD GET WSSERVICE sample 
WSMETHOD GET WSRECEIVE OP WSSERVICE ValidaOP
	Local cOP := Self:OP     
	Local cMsg := ""

	// define o tipo de retorno do método
	::SetContentType("application/json")

	// verifica se recebeu parametro pela URL
	// exemplo: http://localhost:8080/sample/1
	If Len(::aURLParms) > 0
		//Valida o Apontamento
		//u_PROCD3(cOP) 

		// --> Transforma o objeto de produtos em uma string json
		//cJson := FWJsonSerialize(oObjCom)
		// --> Envia o JSON Gerado para a aplicação Client
		cMsg := "Deu certo"
		::SetResponse(cMsg)

	Else
		// as propriedades da classe receberão os valores enviados por querystring
		// exemplo: http://localhost:8080/sample?startIndex=1&count=10
		DEFAULT ::OP := "810000", ::SITUACAO := "ENCONTRADO"

		cMsg := "OP não encontrada."
		// exemplo de retorno de uma lista de objetos JSON
		::SetResponse(cMsg)
	EndIf     

Return .T.