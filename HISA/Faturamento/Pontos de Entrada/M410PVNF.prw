/*/{Protheus.doc} User Function M410ALOK
	Ponto de entrada para validação, executado antes da rotina de geração de NF's
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
User Function M410PVNF()
    Local lRet := .T.

    //utilizado pelo App-ACD-Integratvs
	lRet := u_XETQA99(5)
    
Return lRet
