#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER CHR(10) + CHR(13)

/*/{Protheus.doc} User Function M410ALOK
	Valida a alteração do pedido de venda.
	@type  User Function
	@author matheus.vinicius
	@since 23/09/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function M410ALOK()
    Local lRet := .T.
    
	If !Inclui
		//utilizado pelo App-ACD-Integratvs
		lRet := u_XETQA99(3)
	EndIf
	
Return lRet
