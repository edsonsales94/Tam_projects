#Include "Protheus.ch"
#Include "ParmType.ch"
#Include "FWMvcDef.CH"

#Define ALIASM		"Z2A"
#Define ALIASD		"Z2A"
#Define MDLTITLE	"Calendário Necessidade Compras"
#Define MDLDATA 	"MDLHLAPCP02"
#Define MDLMASTER	"Z2A_MASTER"
#Define MDLDETAIL	"Z2A_DETAIL"
#Define FLDMASTER	"Z2A_FIILIAL|Z2A_ANO|"
#Define FLDDETAIL	"Z2A_MES|Z2A_DIAS|"
#Define VWMASTER	"VIEW_MASTER"
#Define VWDETAIL	"VIEW_DETAIL"

/*/{Protheus.doc} HLAPCP02

Rotina responsável pelo cadastro de período do cálculo de necessidade de compras [MRP]

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		01/03/2019
@version 	Protheus 12 - PCP

/*/
User Function HLAPCP02()

	Local oBrowse := FWMBrowse():New()
	
	oBrowse:SetAlias(ALIASM)
	
	oBrowse:SetDescription(MDLTITLE)
	
	oBrowse:Activate()
		
Return Nil

Static Function MenuDef()

	Local aRotina := {}
	
	ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.HLAPCP02" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.HLAPCP02" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.HLAPCP02" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.HLAPCP02" OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

	Local oStrutMaster	:= FWFormStruct(1, ALIASM, {|cField| AllTrim(cField) +"|" $ FLDMASTER})
	Local oStrutDetail	:= FWFormStruct(1, ALIASD, {|cField| AllTrim(cField) +"|" $ FLDDETAIL})
	Local oModel 		:= MPFormModel():New(MDLDATA,  /*bPre*/, /*bValid*/, /*bCommit*/, /*bCancel*/)
	
	oModel:AddFields(MDLMASTER, /*cOwner*/, oStrutMaster, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
	
	oModel:AddGrid(MDLDETAIL, MDLMASTER, oStrutDetail, /*bLinePre*/, /*bLinePost*/, /*bPre*/, /*bPost*/, /*bLoad*/)
	
	oModel:SetRelation(MDLDETAIL, {{"Z2A_FILIAL", "FWxFilial('Z2A')"}, {"Z2A_ANO", "Z2A_ANO"}}, Z2A->(IndexKey(1)))
	
	oModel:GetModel(MDLDETAIL):SetUniqueLine({"Z2A_MES"})
	
	oModel:GetModel(MDLMASTER):SetDescription("Calendário Necessidade Compras")
	oModel:GetModel(MDLDETAIL):SetDescription("Detalhe Calendário Necessidade Compras")

	oModel:SetDescription(MDLTITLE)
	
	oModel:SetPrimaryKey({})

Return oModel

Static Function ViewDef()

	Local oStrutMaster 	:= FWFormStruct(2, ALIASM, {|cField| AllTrim(cField) +"|" $ FLDMASTER})
	Local oStrutDetail 	:= FWFormStruct(2, ALIASD, {|cField| AllTrim(cField) +"|" $ FLDDETAIL})
	Local oModel   	 	:= FWLoadModel("HLAPCP02")	
	Local oView		 	:= FWFormView():New()
	
	oView:SetModel(oModel)

	oView:AddField(VWMASTER, oStrutMaster, MDLMASTER)
	oView:AddGrid(VWDETAIL,  oStrutDetail, MDLDETAIL)
		
	oView:CreateHorizontalBox("SUPERIOR", 15)
	oView:CreateHorizontalBox("INFERIOR", 85)

	oView:SetOwnerView(VWMASTER, "SUPERIOR")
	oView:SetOwnerView(VWDETAIL, "INFERIOR")

	oView:SetCloseOnOk({|| .T.})
	
Return oView