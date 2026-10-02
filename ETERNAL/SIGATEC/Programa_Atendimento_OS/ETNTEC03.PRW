
#include "totvs.ch"
#Include "TBICONN.ch"
#INCLUDE "topconn.ch"
#Include 'FWMVCDef.ch'
#INCLUDE "FWEVENTVIEWCONSTS.CH"

#Define ALIASD		""
#Define FLDMASTER	""
#Define FLDDETAIL	""
#Define MDLTITLE	"Equipes"
#Define MDLDATA 	"MDLETTEC03"
#Define MDLNAME		FunName()
#Define MDLMASTER	"MASTER"
#Define MDLDETAIL	"DETAIL"
#Define MDL2DETAIL	"DETAIL2"
#define MVC_MAIN_ID "ETNTEC03"


user function ETTCP03x()
	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'FAT'   USER "ADMIN" PASSWORD "99"
	DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE 'Janela Principal'
	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( u_ETNTEC03() , oMainWnd:End() )
	RESET ENVIRONMENT
Return nil


User Function ETNTEC03()
	Local oBrowse 
	Local cFunBkp:=FunName()
	Private aRotina :=MenuDef()
	Private lFilter    := .F. 

	SetFunName(MVC_MAIN_ID)
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZX0')
	oBrowse:SetDescription(MDLTITLE)
	//Legendas 0=Bloqueada;1=Ativa                                                                                                             
	oBrowse:AddLegend( " ZX0_STATUS !='1' ", "GREEN",	"Bloqueada" )
	oBrowse:AddLegend( " ZX0_STATUS =='1' ", "RED"  ,	"Ativa" )
	oBrowse:Activate()
	SetFunName(cFunBkp)

Return Nil
/*/ ROTINA DE  TECLA DE ATALHO F7/*/

Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina Title 'Visualizar' 					Action 'VIEWDEF.'+MVC_MAIN_ID     	OPERATION MODEL_OPERATION_VIEW ACCESS 0
	ADD OPTION aRotina Title 'Incluir' 					    Action 'VIEWDEF.'+MVC_MAIN_ID     	OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina Title 'Alterar' 			 		    Action 'VIEWDEF.'+MVC_MAIN_ID     	OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina Title 'Excluir' 			 		    Action 'VIEWDEF.'+MVC_MAIN_ID     	OPERATION MODEL_OPERATION_DELETE ACCESS 0 
	ADD OPTION aRotina Title 'Legenda'  					Action 'u_f_LegZT3()' 				OPERATION 6 ACCESS 0
Return aRotina

Static Function ModelDef()
	
	Local oStrutMaster	:= FWFormStruct(1, 'ZX0', ,)
	Local oStruFilho 	:= FwFormStruct(1,'ZX1')
	Local bPos 			:= NIL//{|oMdl| MDMVlPos( oMdl ) }	
	Local oModel 		:= MPFormModel():New(MDLDATA,/*bPre*/, bPos/*bPos*/,/*bCommit*/,/*bCancel*/)
	
	oModel:AddFields(MDLMASTER, /*cOwner*/, oStrutMaster, /*bPreValidacao*/, /*bPosValidacao*/, /*bLoad*/)

	oModel:SetPrimaryKey({'ZX0_FILIAL','ZX0_FORNEC','ZX0_LOJA'})
	oModel:SetDescription(MDLTITLE)	
	oModel:GetModel(MDLMASTER):SetDescription(MDLTITLE)
	oModel:AddGrid(MDLDETAIL,MDLMASTER,oStruFilho)

    oStruFilho:SetProperty('ZX1_ID_ZX0',  MODEL_FIELD_INIT		,   FwBuildFeature(STRUCT_FEATURE_INIPAD, M->ZX0_COD ))  //Ini Padrão

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS

    oModel:SetRelation(MDLDETAIL, {{'ZX1_FILIAL', 'ZX0_FILIAL'}, {'ZX1_ID_ZX0', 'ZX0_COD'}}, ('ZX1')->(IndexKey(1)))

	oModel:GetModel(MDLDETAIL):SetDescription("Itens")
    //Desativando a exclusão ,Update e Deleção das linhas
    // oModel:GetModel(MDLDETAIL):SetNoDeleteLine(.T.)
    // oModel:GetModel(MDLDETAIL):SetNoInsertLine(.T.)
    // oModel:GetModel(MDLDETAIL):SetNoUpdateLine(.T.)
	oModel:GetModel(MDLDETAIL):SetOptional(.T.)
    
Return oModel

Static Function ViewDef()

	Local oStrutMaster 	:= FWFormStruct(2, 'ZX0')
	Local oStruFilho 	:= FwFormStruct(2, 'ZX1')
	Local oModel   	 	:= FWLoadModel(MVC_MAIN_ID)
	Local oView		 	:= FWFormView():New()

	Private vMaster:="Vw_"+'ZX0'+"MASTER"
	Private vDetail:="Vw_"+'ZX1'+"DETAIL"

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField(vMaster, oStrutMaster, MDLMASTER)

	// CRIA A ESTRUTURA VISUAL DAS GRIDS
    oView:AddGrid(vDetail, oStruFilho, MDLDETAIL)

		
	oView:CreateHorizontalBox("SUPERIOR", 40)
    oView:CreateHorizontalBox("EMBAIXO" , 60)


	oView:SetOwnerView(vMaster, "SUPERIOR")
	oView:SetOwnerView(vDetail, "EMBAIXO")

	// DEFINE OS TÍTULOS DAS SUBVIEWS
    oView:EnableTitleView(vMaster)
    oView:EnableTitleView(vDetail, "itens", RGB(224, 30, 43))

    oView:SetViewProperty( vDetail , 'ENABLENEWGRID' ) 
    oView:SetViewProperty( vDetail, "GRIDNOORDER") 
    oView:SetViewProperty( vDetail, "GRIDFILTER", {.T.}) 
    oView:SetViewProperty( vDetail, "GRIDSEEK", {.T.})
    oStruFilho:RemoveField('ZX1_ID_ZX0')
    // oStruFilho:RemoveField('ZX1'+'_LOJA')
	//oView:AddIncrementField(vDetail, 'ZX1'+'_ITEM')
Return oView


/*/ Rotina de Criação de Equipe/*/
User  Function ETTCP03A(cTurnoAg,dDataAgenda,aEquiAdd,cModTransp)
    Local aArea         := GetArea()
    Local nOpcAuto      :=3
    Local mMaster       :=MDLMASTER
    Local mDetail       :=MDLDETAIL
    Local nX            :=0 
    Local cDescEquipe   :="Equipe para o dia "+Dtos(dDataAgenda)
    Local cNumSeq       :=fSeqNum(dDataAgenda,cTurnoAg)
    Local lRet          := .F. 

    Private aRotina     := MenuDef()	
    Private oModel      := FwLoadModel(MVC_MAIN_ID)
    Private lMsErroAuto := .F.

	oModel:SetOperation(nOpcAuto) // 3 - InclusÃ£o | 4 - AlteraÃ§Ã£o | 5 - ExclusÃ£o
	oModel:Activate() //ativa modelo

    oModel:GetModel(mMaster):SetValue("ZX0_FILIAL"  ,xFilial('ZX0') ) 
    oModel:GetModel(mMaster):SetValue("ZX0_COD"     ,cNumSeq        )
    oModel:GetModel(mMaster):SetValue("ZX0_TURNO"   ,cTurnoAg       )
    oModel:GetModel(mMaster):SetValue("ZX0_DESC"    ,cDescEquipe    )
    oModel:GetModel(mMaster):SetValue("ZX0_VERSAO"  ,"00001")
    oModel:GetModel(mMaster):SetValue("ZX0_STATUS"  ,"1")
    oModel:GetModel(mMaster):SetValue("ZX0_DTHORA"  ,FWTimeStamp(3)) 
    oModel:GetModel(mMaster):SetValue("ZX0_DTINI"   ,dDataAgenda)
    oModel:GetModel(mMaster):SetValue("ZX0_DTFIM"   ,dDataAgenda)
    oModel:GetModel(mMaster):SetValue("ZX0_XMDTRP"   ,cModTransp)


	lPrimeiro:=.t.
    For nX:=1 To Len(aEquiAdd)
        cTpMembro   :=aEquiAdd[nX][1]
        cCodMembro  :=aEquiAdd[nX][2]
        if lPrimeiro
            lPrimeiro:=.f.
        else 
            oModel:GetModel(mDetail):AddLine()
        Endif 
        oModel:GetModel(mDetail):SetValue("ZX1_FILIAL"  ,xFilial('ZX1') )
        oModel:GetModel(mDetail):SetValue("ZX1_ID_ZX0"  ,cNumSeq        )
        oModel:GetModel(mDetail):SetValue("ZX1_ID_AA1"  ,cCodMembro     )
        oModel:GetModel(mDetail):SetValue("ZX1_VERSAO"  ,"00001"        )
        oModel:GetModel(mDetail):SetValue("ZX1_TIPO"    ,cTpMembro      )
        oModel:GetModel(mDetail):SetValue("ZX1_STATUS"  ,"1"            )
    Next 

	If oModel:VldData() //validacao dos dados pelo modelo
		if oModel:CommitData() //gravacao dos dados
	        lRet := .T. 
        Else
            MsgStop('Erro', oModel:GetErrorMessage()[6])
        Endif 
	Else
		lMsErroAuto := .T. //seta variavel private como erro
		MsgStop('Erro', oModel:GetErrorMessage()[6])
	EndIf
	oModel:DeActivate() //desativa modelo	
    oModel:Destroy()
    RestArea(aArea)
Return lRet


/*/ Rotina que pega a Sequencia de numero para formação de Equipe/*/
Static Function fSeqNum(dDataAgenda,cTurnoAg)
    Local cBase     :=Right(Dtos(dDataAgenda),6) +cTurnoAg //AADDDD + Turno('M','T','N') 
    Local cSeq      :=StrZero(1,3)
    Local cNumero   :=cBase+cSeq
    ZX0->(DBSetOrder(1/*nOrdem*/))////ZX0_FILIAL, ZX0_COD, ZX0_VERSAO, R_E_C_N_O_, D_E_L_E_T_
    ZX0->(DbSeek(xFilial('ZX0')+cNumero))
    While  ZX0->(!Eof()) .and. ZX0->(DbSeek(xFilial('ZX0')+cNumero))
        cSeq:=soma1(cSeq,3)
        cNumero:=cBase+cSeq
    End
Return cNumero 



/*/ Rotina de Exclusão de Equipe/*/
User  Function ETTCP03B(cCodigo)
    Local lRet     := .F.
    Private aRotina     := MenuDef()	
    Private oModel      := FwLoadModel(MVC_MAIN_ID)
    Private lMsErroAuto := .F.

    // 1. Instancia o modelo da rotina desejada (exemplo usando uma rotina genérica ou sua customizada)
    If oModel <> Nil
        // 2. Define a operação como Exclusão (MODEL_OPERATION_DELETE = 5)
        If oModel:SetOperation(MODEL_OPERATION_DELETE)
            
            // 3. Ativa o modelo para carregar os dados do registro posicionado/informado
            // Nota: O alias principal da rotina deve estar posicionado no registro correto antes daativação,
            // ou você pode utilizar chaves de busca se o modelo permitir/posicionar via setValue na chave primária.
            DbSelectArea('ZX0') // Substitua pelo seu Alias
            ZX0->(DbSetOrder(1)) // Substitua pelo seu Índice
            If ZX0->(DbSeek(xFilial('ZX0') + cCodigo))
                If oModel:Activate()
                    // 4. Valida se o modelo pode ser gravado/excluído
                    If oModel:VldData()
                        // 5. Efetua a gravação efetiva (Exclusão no banco de dados)
                        oModel:CommitData()
                        lRet := .T.
                        ConOut("Registro excluído com sucesso via MVC!")
                    Else
                        // Pega os erros de validação do modelo
                        DisarmTransaction()
                        MostraErro() // Ou tratar o array de erro com oModel:GetErrorMessage()
                    EndIf
                    // 6. Desativa o modelo
                    oModel:DeActivate()
                EndIf
            Else
                ConOut("Registro não encontrado para exclusão.")
            EndIf
        EndIf
        // 7. Destriur o objeto do modelo
        oModel:Destroy()
    Else
        ConOut("Não foi possível carregar o Modelo de Dados.")
    EndIf
Return lRet



/*/Abre a View de Equepes  /*/
User Function ETTCP03C(cNumEquipe)
    Local aArea := FWGetArea()
    Local cFunBkp := FunName()
      
    DbSelectArea('ZX0')
    ZX0->(DbSetOrder(1)) //Filial + Código 
      
    //Se conseguir posicionar
    If ZX0->(DbSeek(FWxFilial('ZX0') + cNumEquipe))
        SetFunName("ETNTEC03")
        FWExecView('Visualizacao Equipe', "ETNTEC03", MODEL_OPERATION_VIEW)
        SetFunName(cFunBkp)
    EndIf
 
    FWRestArea(aArea)
Return
