#include "totvs.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FWADAPTEREAI.CH"

#DEFINE ACCESS_VIZUALIZAR 1
#DEFINE ACCESS_INCLUIR 2
#DEFINE ACCESS_ALTERAR 3
#DEFINE ACCESS_EXCLUIR 4
#DEFINE ACCESS_COPIA 5


User Function MATA010M()
Return u_MATA010()
/*
User Function ITEM()
Return u_MATA010()
	
*/
User Function MATA010()

Local aParam := PARAMIXB
Local xRet := Nil
Local oObj := ''
Local cIdPonto := ''
Local cIdModel := ''
//Local lIsGrid := .F.
//Local nLinha := 0
//Local nQtdLinhas := 0
//Local cMsg := ''

If aParam <> NIL

   oObj := aParam[1]
   cIdPonto := aParam[2]
   cIdModel := aParam[3]

   If cIdPonto == 'MODELVLDACTIVE'
      oModel:= oObj
      nOpc := oModel:GetOperation()
	  AAModel370(oModel,nOpc)
	  xRet := .T.
   EndIf
EndIf

Return xRet



Static Function AAModel370(oModel, nOpc)
Local oStruSA7
Local aMATA060Access := {}

aAdd(aMATA060Access, {OP_PESQUISAR	, MPUserHasAccess("MATA370", OP_PESQUISAR)} )
aAdd(aMATA060Access, {OP_VISUALIZAR	, MPUserHasAccess("MATA370", OP_VISUALIZAR)} )
aAdd(aMATA060Access, {OP_INCLUIR	, MPUserHasAccess("MATA370", OP_INCLUIR)} )
aAdd(aMATA060Access, {OP_ALTERAR	, MPUserHasAccess("MATA370", OP_ALTERAR)} )
aAdd(aMATA060Access, {OP_EXCLUIR	, MPUserHasAccess("MATA370", OP_EXCLUIR)} )
aAdd(aMATA060Access, {OP_COPIA		, MPUserHasAccess("MATA370", OP_COPIA)} )
//Local aAux
//Local aVerify

	//ProdxFornecedor
	If IsAccessByOperation(nOpc, aMATA060Access)
		oStruSA7 := FWFormStruct(1,'SA7', {|cCampo| .T.})//MA061MldStruct(.T.)
		/*
		aAux :=	FwStruTrigger("A7_CLIENT","A7_LOJA","MTA010Proc()")
				
		oStruSA5:AddTrigger( ;
					aAux[1]  , ;  // [01] Id do campo de origem
					aAux[2]  , ;  // [02] Id do campo de destino
					aAux[3]  , ;  // [03] Bloco de codigo de validação da execução do gatilho
					aAux[4]  )    // [04] Bloco de codigo de execução do gatilho
		*/
		//--------------------------------------------------------------------------
		// HACK: Não mudar o id 'MdGridSA5' pois o fonte MATA060 faz diversas 
		// validações usando esse id de grid
		//--------------------------------------------------------------------------		
		oModel:AddGrid("MdGridSA7","SB1MASTER",oStruSA7)
		oModel:SetRelation('MdGridSA7', { { 'A7_FILIAL', 'xFilial("SA7")' }, { 'A7_PRODUTO', 'B1_COD' } }, SA7->(IndexKey(1)) )
		oModel:getModel('MdGridSA7'):SetOptional(.T.)
		oModel:GetModel("MdGridSA7"):SetDelAllLine(.T.)
		oModel:GetModel("MdGridSA7"):SetUniqueLine({'A7_CLIENTE','A7_LOJA','A7_CODCLI'})
		oModel:GetModel("MdGridSA7"):SetDelAllLine(.T.)
		oModel:InstallEvent("CLIENTE",,AAMATA370Clientes():New())
	EndIf	
Return

/*/{Protheus.doc} IsAccessByOperation
Analisa o array que guarda os acessos por operação da rotina 
e retorna se o usuario tem acesso a determinada operação ou não.

@param nOpc número da operação
@param aAccess array que já possui os controles de acordo com usuario e rotinas

@author Juliane Venteu
@since 02/03/2017
@version P12.1.17
 
/*/
Static Function IsAccessByOperation(nOpc, aAccess)
	Local lRet
	
		Do Case
			Case nOpc == OP_VISUALIZAR
				lRet  := aAccess[ACCESS_VIZUALIZAR][2]
				
			Case nOpc == OP_INCLUIR
				lRet  := aAccess[ACCESS_INCLUIR][2]
				
			Case nOpc == OP_ALTERAR
				lRet  := aAccess[ACCESS_ALTERAR][2]
				
			Case nOpc == OP_EXCLUIR
				lRet  := aAccess[ACCESS_EXCLUIR][2]
				
			Case nOpc == OP_COPIA
				lRet  := aAccess[ACCESS_COPIA][2]
				
			Otherwise
				lRet := .T.
		EndCase
		
Return lRet


Static Function ModelDef()
	Local oModel := FWLoadModel( 'MATA010' )
//Colocar um If para Habilitar somente no Faturamento	
	Local oStruSA7 := FWFormStruct(1,'SA7', {|cCampo| .T.})//MA061MldStruct(.T.)

	oStruSA7:SetProperty( 'A7_PRODUTO' , MODEL_FIELD_INIT,{||u_AA370INI()})
	oStruSA7:SetProperty( 'A7_PRODUTO' , MODEL_FIELD_OBRIGAT,.F.)
	oStruSA7:SetProperty( 'A7_PRODUTO' , MODEL_FIELD_VALID,{||.T.})
	oStruSA7:SetProperty( 'A7_CLIENTE' , MODEL_FIELD_VALID,{|| u_AA370VLDCPO()})
	oStruSA7:SetProperty( 'A7_LOJA' , MODEL_FIELD_VALID,{|| u_AA370VLDCPO()})

    //:SetProperty( 'ZA0_QTDMUS' , MODEL_FIELD_WHEN,'INCLUI')

		/*
		aAux :=	FwStruTrigger("A7_CLIENT","A7_LOJA","MTA010Proc()")
				
		oStruSA5:AddTrigger( ;
					aAux[1]  , ;  // [01] Id do campo de origem
					aAux[2]  , ;  // [02] Id do campo de destino
					aAux[3]  , ;  // [03] Bloco de codigo de validação da execução do gatilho
					aAux[4]  )    // [04] Bloco de codigo de execução do gatilho
		*/
		//--------------------------------------------------------------------------
		// HACK: Não mudar o id 'MdGridSA5' pois o fonte MATA060 faz diversas 
		// validações usando esse id de grid
		//--------------------------------------------------------------------------		
	oModel:AddGrid("MdGridSA7","SB1MASTER",oStruSA7)
	oModel:SetRelation('MdGridSA7', { { 'A7_FILIAL', 'xFilial("SA7")' }, { 'A7_PRODUTO', 'B1_COD' } }, SA7->(IndexKey(1)) )
	oModel:getModel('MdGridSA7'):SetOptional(.T.)
	oModel:GetModel("MdGridSA7"):SetDelAllLine(.T.)
	oModel:GetModel("MdGridSA7"):SetUniqueLine({'A7_CLIENTE','A7_LOJA','A7_CODCLI'})
	oModel:GetModel("MdGridSA7"):SetDelAllLine(.T.)
	oModel:InstallEvent("CLIENTE",,AAMATA370Clientes():New())

Return oModel

Static Function ViewDef()
Local oModel := FWLoadModel( 'AAMATA010' )
Local oView := FWLoadView( 'MATA010' )
//Local oStruZA6 := FWFormStruct( 2, 'ZA6' )  
Local oStruSA7 := FWFormStruct(2,'SA7', {|cCampo| .T.})//MA061MldStruct(.T.)


oView:SetModel(oModel)

oView:CreateHorizontalBox( 'BOXFORMSA7', 10)
oView:AddGrid('FORMSA7' , oStruSA7,'MdGridSA7')
oView:SetOwnerView('FORMSA7','BOXFORMSA7')
oView:EnableTitleView("FORMSA7", FwX2Nome("SA7"))

Return oView

User Function MTA010MNU()
   
	Local xPos 
	xPos := aScan(aRotina,{|x| x[02] == "A010Altera" })
	if xPos > 0
		aRotina[xPos][02] := "u_AAMA010Alter"
	EndIf

Return NIl

User Function AAMA010Alter(cAlias,nReg,nOpc)
	Local nOK
		
	nOK := (FWExecView ("Alteração", "AAMATA010",  MODEL_OPERATION_UPDATE,,{||.T.},,,,,,,))
	
	If ExistBlock("MT010CAN")
		nOk := StaticCall(MATA010M,NMt010Can,nOk,nOpc)
		ExecBlock("MT010CAN",.F.,.F.,{nOK})
	EndIf		
Return

User Function AAA370ProCli()
	//!A370PROCLI(M->A7_PRODUTO)
	Local lRetorna := .T.
	Local cChave := ""
	Local lIsInMvc := isInMvc()

	cChave += If(lIsInMVC,oGrid:GetValue("A7_CLIENTE"),M->A7_CLIENTE)
	cChave += If(lIsInMVC,oGrid:GetValue("A7_LOJA"),M->A7_LOJA)
	cChave += If(lIsInMVC,oGrid:GetValue("A7_PRODUTO"),M->A7_PRODUTO)

	if isInMvc()
		SA7->(dbSetOrder(1))
		SA7->(dbSeek(xFilial('SA7') + cChave ))	
	EndIf
   
Return lRetorna

User Function AA370VLDCPO()

Local lRet 	   := .T.
Local aAreaAnt := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local cCampo   := ReadVar()
Local cChave   := ""
Local oModel   := FWModelActive()
Local lIsInMVC := IsInMVC()
Local oGrid	   := If(lIsInMVC,oModel:GetModel("MdGridSA7"),NIL)

//If !Empty(oGrid:GetValue("A7_CLIENTE"))

cChave := oGrid:GetValue("A7_CLIENTE")
if !Empty(oGrid:GetValue("A7_LOJA"))
   cChave += oGrid:GetValue("A7_LOJA")
EndIf
/*If cCampo == "M->A7_CLIENTE"
	cChave := &(ReadVar())
	If !Empty(If(lIsInMVC,oGrid:GetValue("A7_LOJA"),M->A7_LOJA))
		cChave += If(lIsInMVC,oGrid:GetValue("A7_LOJA"),M->A7_LOJA)
	EndIf
ElseIf cCampo == "M->A7_LOJA" 
	If !Empty(If(lIsInMVC,oGrid:GetValue("A7_CLIENTE"),M->A7_CLIENTE))
		cChave += If(lIsInMVC,oGrid:GetValue("A7_CLIENTE"),M->A7_CLIENTE) +&(ReadVar())
	EndIf
EndIf
*/
lRet := ExistCpo("SA1",cChave,,,,!EMPTY( oGrid:GetValue("A7_LOJA") ))
//existcpo("SA1",M->A7_CLIENTE+RTRIM(M->A7_LOJA),,,,!EMPTY(M->A7_LOJA))                                                           

RestArea(aAreaSA1)
RestArea(aAreaAnt)
Return lRet

Static Function IsInMVC()
	Local oModel	  := FWModelActive()
	Local lIsInMVC	  := ValType(oModel) <> "U" .And. (oModel:GetID() == "ITEM" )
Return lIsInMVC

User Function AA370INI()
	Local oModel := FwModelActive()
	Local xRet := oModel:GetValue('SB1MASTER','B1_COD')
Return xRet
