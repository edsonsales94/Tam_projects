//#INCLUDE "MATA060.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} AAMATA370Clientes
Evento usado pela rotina MATA010 para o relacionamento Produto x Cliente.

Importante: Use somente a função Help para exibir mensagens ao usuario, pois apenas o help
é tratado pelo MVC. 

Documentação sobre eventos do MVC: http://tdn.totvs.com/pages/viewpage.action?pageId=269552294

@type classe
 
@author Diego Rafael
@since 08/07/2020
@version P12.1.17
 
/*/


CLASS AAMATA370Clientes FROM FWModelEvent

    DATA cIDSA7Grid
	
	DATA aSitHist
	
	DATA lECommerce
	DATA lHistTab

	METHOD New() CONSTRUCTOR
	
	METHOD getCodProduto()
	METHOD getRefGrade()
	METHOD VldDelete()
	METHOD GridLinePosVld()
	METHOD Before()
	METHOD ModelPosVld()
ENDCLASS

//-----------------------------------------------------------------
METHOD New(cIDGrid) CLASS AAMATA370Clientes
Default cIDGrid := 'MdGridSA7'
	::cIDSA7Grid := cIDGrid
	::aSitHist := {}		

Return

METHOD getCodProduto(oModel) CLASS AAMATA370Clientes	
Return oModel:GetValue("SB1MASTER", "B1_COD")

METHOD getRefGrade(oModel) CLASS AAMATA370Clientes
Return ""


/*/{Protheus.doc} ModelPosVld
Executa a validação do modelo antes de realizar a gravação dos dados.
Se retornar falso, não permite gravar.

@type metodo
 
@author Diego Rafael
@since 08/07/2020
@version P12.1.17
 
/*/
METHOD ModelPosVld(oModel, cID) CLASS AAMATA370Clientes
Local lRet		:= .T.
Local oGrid
Local cProduto
Local cFornece
Local cLoja
		
	oGrid     := oModel:GetModel(::cIDSA7Grid)
	cProduto := ::getCodProduto(oModel)
	
	If oModel:GetOperation() # MODEL_OPERATION_DELETE
		/*
        If Empty(cProduto) .And. Empty(::getRefGrade(oModel))
			Help(" ",1,"A060OBRIGA")
			lRet := .F.
		EndIf
        */
	Else	
		lRet := ::VldDelete(oModel)		
	EndIf
	

Return lRet


/*/{Protheus.doc} VldDelete
Valida se o Cliente pode ser excluido.

@type metodo
 
@author Diego Rafael
@since 08/07/2020
@version P12.1.17
 
/*/
METHOD VldDelete(oModel, cID) CLASS AAMATA370Clientes
Local oGrid
Local lRet := .T.
Local nLineAtu
Local cFornece
Local cLoja
Local nX
Local cProduto
Local aAreaQEK := QEK->(GetArea())
Local aAreaQF4 := QF4->(GetArea())
Local aAreaSB1 := SB1->(GetArea())

If cID == ::cIDSA7Grid		
		oGrid := oModel:GetModel(::cIDSA7Grid)
		nLineAtu := oGrid:GetLine()		
		cProduto := ::getCodProduto(oModel)
			
		QEK->(dbSetOrder(1))
		QF4->(dbSetOrder(1))
		
		For nX := 1 To oGrid:Length()
			oGrid:GoLine(nX)
				
			cFornece := oGrid:GetValue("A7_CLIENTE")
			cLoja := oGrid:GetValue("A7_LOJA")			
		Next nX
			
		oGrid:GoLine(nLineAtu)
EndIf
	
RestArea(aAreaSB1)
RestArea(aAreaQF4)
RestArea(aAreaQEK)	
Return lRet

/*/{Protheus.doc} GridLinePosVld
Pós Validação da linha.

@type metodo
 
@author Diego Rafael
@since 08/07/2020
@version P12.1.17
 
/*/
METHOD GridLinePosVld(oSubModel, cID, nLine) CLASS AAMATA370Clientes
Local lRet := .T.
Local oModel
Local oView := FWViewActive()
	
	If cID == ::cIDSA7Grid
		oModel := oSubModel:GetModel()				
		
	EndIf	
Return lRet


/*/{Protheus.doc} Before
Metodo executado antes da gravação de cada linha do grid e dentro da transação.
Nesse momento é gravado o historico de alterações e obtido os dados para integração com o QIE

@type metodo
 
@author Diego Rafael
@since 08/07/2020
@version P12.1.17
 
/*/
METHOD Before(oSubModel,cID,cAlias,lNewRecord) CLASS AAMATA370Clientes
	
	If cID == ::cIDSA7Grid 
		If oSubModel:GetModel():GetOperation() == MODEL_OPERATION_INSERT
		   oSubModel:LoadValue("A7_DESCLI", oSubModel:GetModel():GetValue("SB1MASTER","B1_DESC"))
		EndIf				
	EndIf
	
Return
