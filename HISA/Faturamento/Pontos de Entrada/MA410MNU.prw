//Bibliotecas
#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include 'TopConn.ch'
 
/*/{Protheus.doc} User Function MA410MNU
	Adição de rotinas no menu de ações relacionadas do Browse de Pedido de Vendas.
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
User Function MA410MNU()
    Local aArea := GetArea()
     
    aAdd(aRotina,{ "Gerar Separação"  , "u_XETQA8C(.T.,SC5->C5_NUM)" , 0 , 4, 0, .F.})	
     
    RestArea(aArea)
Return
