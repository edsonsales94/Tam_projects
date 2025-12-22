#include 'protheus.ch'
#include 'parmtype.ch'

User Function AALOJP02()
	Private aRotina := Menudef()
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SL1')
	oBrowse:Activate()	
	
Return Nil

Static Function ModelDef()
	Local oStruSL1 := FWFormStruct( 1, 'SL1' )
	Local oModel   := Nil

	oModel := MPFormModel():New('MAALOJP02' )
	
	oModel:AddFields( 'SL1MASTER', /*cOwner*/, oStruSL1)
	oModel:GetModel( 'SL1MASTER' ):SetDescription( 'Dados de Status de Orçamento' )

Return oModel

Static Function ViewDef()

	Local oStruSL1 := FWFormStruct( 2, 'SL1' ,{|cCampo|  Alltrim(cCampo)$"L1_XSTATUS,L1_XOBS,L1_XDTPREV"})
	Local oModel   := FWLoadModel( 'AALOJP02' )
	
	oView :=  FWFormView():New()
	oView:SetModel( oModel )
	
	oView:AddField( 'VIEW_SL1', oStruSL1, 'SL1MASTER' )
	
	oView:CreateHorizontalBox( 'TELA' , 100 )	
	oView:SetOwnerView( 'VIEW_ZL1', 'TELA' )

Return oView

Static Function Menudef()
	
   	aRotina := {}
	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.AALOJP02', 0, 2, 0, NIL } )
			
Return aRotina