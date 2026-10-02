#include "totvs.ch"
#Include "TBICONN.ch"
#INCLUDE "topconn.ch"
#Include 'FWMVCDef.ch'
#INCLUDE "FWEVENTVIEWCONSTS.CH"

#Define ALIASD		""
#Define FLDMASTER	""
#Define FLDDETAIL	""
#Define MDLTITLE	"Progração de Rotas de Atendimento"
#Define MDLDATA 	"MDLETTEC02"
#Define MDLNAME		FunName()
#Define MDLMASTER	"MASTER"
#Define MDLDETAIL	"DETAIL"
#Define MDL2DETAIL	"DETAIL2"
#define MVC_MAIN_ID "ETNTEC02"


user function ETTCP02x()
	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'FAT'   USER "ADMIN" PASSWORD "99"
	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO 'TEC'   USER "ADMIN" PASSWORD "Amazonas2027*!"
	DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE 'Janela Principal'
	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( u_ETNTEC02() , oMainWnd:End() )
	RESET ENVIRONMENT
Return nil


User Function ETNTEC02()
	Local oBrowse 
	Local cFunBkp:=FunName()
	Private aRotina :=MenuDef()
	Private cTabMaster :="ZX2"
	Private cTabDetail :="ZX3"
	Private lFilter    := .F. 

	SetFunName(MVC_MAIN_ID)
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabMaster)
	oBrowse:SetDescription(MDLTITLE)
	//P=Prevista;A=Agendada;R=Remarcada;E=Executada;N=Não Executada;C=Cancelada 
	oBrowse:AddLegend( " ZX2_STATUS =='P' ", "GREEN",	"Prevista" )
	oBrowse:AddLegend( " ZX2_STATUS =='A' ", "RED"  ,	"Agendada" )
	oBrowse:AddLegend( " ZX2_STATUS =='R' ", "RED"  ,	"Remarcada" )
	oBrowse:AddLegend( " ZX2_STATUS =='E' ", "GREEN"  ,	"Executada" )
	oBrowse:AddLegend( " ZX2_STATUS =='N' ", "RED"  ,	"Não Executada" )
	oBrowse:AddLegend( " ZX2_STATUS =='C' ", "RED"  ,	"Cancelada" )
	oBrowse:Activate()
	SetFunName(cFunBkp)

Return Nil
/*/ ROTINA DE  TECLA DE ATALHO F7/*/

Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina Title 'Visualizar' 					Action 'VIEWDEF.'+MVC_MAIN_ID     	OPERATION MODEL_OPERATION_VIEW ACCESS 0
	ADD OPTION aRotina Title 'Programação' 					Action 'u_ETTECP01()'     	        OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina Title 'Alterar' 			 		    Action 'VIEWDEF.'+MVC_MAIN_ID     	OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina Title 'Excluir' 			 		    Action 'VIEWDEF.'+MVC_MAIN_ID     	OPERATION MODEL_OPERATION_DELETE ACCESS 0 
	ADD OPTION aRotina Title 'Legenda'  					Action 'u_f_LegZT3()' 				OPERATION 6 ACCESS 0
Return aRotina

Static Function ModelDef()
	
	Local oStrutMaster	:= FWFormStruct(1, cTabMaster, ,)
	Local oStruFilho 	:= FwFormStruct(1,cTabDetail)
	Local bPos 			:= {|oMdl| MDMVlPos( oMdl ) }	
	Local bPre 			:= nil //- <bPre>: Bloco de código de pré-validação. Executado antes de qualquer alteração nos dados. Deve retornar .T. ou .F..
    Local bCommit 		:= nil //{|| fFazCommit()} //- <bCommit>: Bloco de código responsável por persistir os dados. Se não informado, o padrão é FWFormCommit(Self).
    Local bCancel 		:= Nil //- <bCancel>: Bloco de código para tratar o cancelamento da edição. O padrão é FWFormCancel(Self).
	Local oModel 		:= MPFormModel():New(MDLDATA,bPre/*bPre*/, bPos/*bPos*/,bCommit/*bCommit*/,bCancel/*bCancel*/)
	
	oModel:AddFields(MDLMASTER, /*cOwner*/, oStrutMaster, /*bPreValidacao*/, /*bPosValidacao*/, /*bLoad*/)

    //oStrutMaster:SetProperty("ZX2_COD"  ,  MODEL_FIELD_INIT		,   FwBuildFeature(STRUCT_FEATURE_INIPAD, iif(Empty(M->zx22) u_fSeqZX2Num()) ))  //Ini Padrão
    //oStrutMaster:SetProperty('ZX2_COD'  ,  MODEL_FIELD_WHEN       ,   FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    oStrutMaster:SetProperty('ZX2_DTPRO',  MODEL_FIELD_WHEN       ,   FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))      //Modo de Edição
    oStrutMaster:SetProperty('ZX2_TURNOP', MODEL_FIELD_WHEN       ,   FwBuildFeature(STRUCT_FEATURE_WHEN,    'Iif(INCLUI, .T., .F.)'))      //Modo de Edição

	oModel:SetPrimaryKey({cTabMaster+'_FILIAL',cTabMaster+'_FORNEC',cTabMaster+'_LOJA'})
	oModel:SetDescription(MDLTITLE)	
	oModel:GetModel(MDLMASTER):SetDescription(MDLTITLE)
	oModel:AddGrid(MDLDETAIL,MDLMASTER,oStruFilho)

    oStruFilho:SetProperty(cTabDetail+"_ID_ZX2",  MODEL_FIELD_INIT		,   FwBuildFeature(STRUCT_FEATURE_INIPAD, M->ZX2_COD ))  //Ini Padrão

    oStruFilho:SetProperty(cTabDetail+"_VERSAO",  MODEL_FIELD_INIT		,   FwBuildFeature(STRUCT_FEATURE_INIPAD, M->ZX2_VERSAO ))  //Ini Padrão
    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS

    oModel:SetRelation(MDLDETAIL, {{cTabDetail+"_FILIAL", cTabMaster+"_FILIAL"}, {cTabDetail+"_ID_ZX2", cTabMaster+"_COD"}}, (cTabDetail)->(IndexKey(1)))

	oModel:GetModel(MDLDETAIL):SetDescription("Itens")
    //Desativando a exclusão ,Update e Deleção das linhas
    // oModel:GetModel(MDLDETAIL):SetNoDeleteLine(.T.)
    // oModel:GetModel(MDLDETAIL):SetNoInsertLine(.T.)
    // oModel:GetModel(MDLDETAIL):SetNoUpdateLine(.T.)
	oModel:GetModel(MDLDETAIL):SetOptional(.T.)
    
Return oModel

Static Function ViewDef()

	Local oStrutMaster 	:= FWFormStruct(2, cTabMaster)
	Local oStruFilho 	:= FwFormStruct(2, cTabDetail)
	Local oModel   	 	:= FWLoadModel(MVC_MAIN_ID)
	Local oView		 	:= FWFormView():New()

	Private vMaster:="Vw_"+cTabMaster+"MASTER"
	Private vDetail:="Vw_"+cTabDetail+"DETAIL"

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField(vMaster, oStrutMaster, MDLMASTER)

    // //Adiciona o campo de A1_NOME
    // cCampo:="A1_NOME"
    // oStruFilho:AddField(;
    //     RetTitle(cCampo),;                                                                    // [01]  C   Titulo do campo
    //     RetTitle(cCampo),;                                                                    // [02]  C   ToolTip do campo
    //     cCampo,;                                                                              // [03]  C   Id do Field
    //     GetSx3Cache( cCampo, "X3_TIPO" ),;                                                                                       // [04]  C   Tipo do campo
    //     TamSX3(cCampo)[1],;                                                                   // [05]  N   Tamanho do campo
    //     GetSx3Cache( cCampo , "X3_DECIMAL" ),;                                                                                         // [06]  N   Decimal do campo
    //     Nil,;                                                                                       // [07]  B   Code-block de validação do campo
    //     Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
    //     {},;                                                                                        // [09]  A   Lista de valores permitido do campo
    //     .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
    //     FwBuildFeature( STRUCT_FEATURE_INIPAD, "U_fGetOS(M->ZX3_ID_OS,'SA1','A1_NOME')" ),;   // [11]  B   Code-block de inicializacao do campo
    //     .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    //     .T.)                                                                                        // [14]  L   Indica se o campo é virtual

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
    oStruFilho:RemoveField(cTabDetail+'_ID_ZX2')
    oStruFilho:RemoveField(cTabDetail+'_VERSAO')
	oView:AddIncrementField(vDetail, cTabDetail+'_ITEM')
    oView:addUserButton("*Equipe",  "MAGIC_BMP", {|| u_ETTCP03C(ZX2->ZX2_EQUIPE)}, /*cToolTip*/, /*nShortCut*/, /*aOptions*/,                                     /*lShowBar*/)
 
Return oView


/*/ Rotina de Criação de Equipe/*/
User  Function ETTCP02A(cTurnoAg,dDataAgenda,cNumEquipe,aOS,cNumSeq)
    Local aArea         := GetArea()
    Local nOpcAuto      :=3
    Local mMaster       :=MDLMASTER
    Local mDetail       :=MDLDETAIL
    Local nX            :=0 
    //Local cNumSeq       :=fSeqZX2Num(dDataAgenda,cTurnoAg)
    Local lRet          := .F. 
    Local cCodMot       :=""
    Local cCodVei       :=""

	Private cTabMaster :="ZX2"
	Private cTabDetail :="ZX3"

    Private aRotina     := MenuDef()	
    Private oModel      := FwLoadModel(MVC_MAIN_ID)
    Private lMsErroAuto := .F.

	oModel:SetOperation(nOpcAuto) // 3 - InclusÃ£o | 4 - AlteraÃ§Ã£o | 5 - ExclusÃ£o
	oModel:Activate() //ativa modelo

    oModel:GetModel(mMaster):SetValue("ZX2_FILIAL"  ,xFilial("ZX2") ) 
    oModel:GetModel(mMaster):SetValue("ZX2_COD"     ,cNumSeq        )
    oModel:GetModel(mMaster):SetValue("ZX2_TURNOP"  ,cTurnoAg       )
    oModel:GetModel(mMaster):SetValue("ZX2_ID_ZTA"  ,cNumSeq        )
    oModel:GetModel(mMaster):SetValue("ZX2_VERSAO"  ,"00001")
    oModel:GetModel(mMaster):SetValue("ZX2_STATUS"  ,"P")
    oModel:GetModel(mMaster):SetValue("ZX2_EMISSA"  ,FWTimeStamp(3)) 
    oModel:GetModel(mMaster):SetValue("ZX2_DTPRO"   ,dDataAgenda)
    oModel:GetModel(mMaster):SetValue("ZX2_HORAP"   ,Left(Time(),TamSx3("ZX2_HORAP")[1]))
    oModel:GetModel(mMaster):SetValue("ZX2_EQUIPE"  ,cNumEquipe)
    Begin Transaction
        //Marca Equipe como Prevista 
        ZX0->(DbSetOrder(1))//ZX0_FILIAL, ZX0_COD, ZX0_VERSAO, R_E_C_N_O_, D_E_L_E_T_
        if !Empty(cNumEquipe) .and. ZX0->(DbSeek(xFilial("ZX0")+cNumEquipe))
            if ZX0->(RecLock("ZX0",.F.))
                ZX0->ZX0_STATUS:="1"
                ZX0->(MsUnLock())
            Endif 
        Endif 

        //Pegar aqui codigo do Motorista e veiculo 
        cCodMot       :=Posicione("ZX1",1,ZX0->ZX0_FILIAL+ZX0->ZX0_COD+ZX0->ZX0_VERSAO+"M",'ZX1_ID_AA1') //ZX1_FILIAL+ZX1_ID_ZX0+ZX1_VERSAO+ZX1_ID_AA1+ZX1_TIPO
        cCodVei       :=Posicione("ZX1",1,ZX0->ZX0_FILIAL+ZX0->ZX0_COD+ZX0->ZX0_VERSAO+"V",'ZX1_ID_AA1') //ZX1_FILIAL+ZX1_ID_ZX0+ZX1_VERSAO+ZX1_ID_AA1+ZX1_TIPO

        lPrimeiro:=.t.
        For nX:=1 To Len(aOS)
            cNumOS  :=aOS[nX]
            if lPrimeiro
                lPrimeiro:=.f.
            else 
                oModel:GetModel(mDetail):AddLine()
            Endif 

            oModel:GetModel(mDetail):SetValue("ZX3_FILIAL"  ,xFilial("ZX3") )
            oModel:GetModel(mDetail):SetValue("ZX3_ID_ZX2"  ,cNumSeq        )
            oModel:GetModel(mDetail):SetValue("ZX3_ID_OS"   ,cNumOS         )
            oModel:GetModel(mDetail):SetValue("ZX3_VERSAO"  ,"00001"        )
            oModel:GetModel(mDetail):SetValue("ZX3_ITEM"    ,StrZero(nX,4)  )
            oModel:GetModel(mDetail):SetValue("ZX3_STATUS"  ,"A"            )
            AB6->(DbSetOrder(1))//AB6_FILIAL, AB6_NUMOS, R_E_C_N_O_, D_E_L_E_T_
            if AB6->(DbSeek(xFilial("AB6")+cNumOS))
                if AB6->(RecLock("AB6",.F.))
                    AB6->AB6_XSTATU:= IIF(AB6->AB6_XSTATU=="N","R","A")
                    AB6->AB6_XVEICU:=cCodVei
                    AB6->AB6_XMOTOR:=cCodMot
                    AB6->AB6_XDTAGE:=dDataAgenda
                    AB6->AB6_XTURNO:=cTurnoAg          
                    AB6->AB6_XROTA :=cNumSeq
                    AB6->(MsUnLock())
                Endif 
            Endif 
        Next 

        If oModel:VldData() //validacao dos dados pelo modelo
            if oModel:CommitData() //gravacao dos dados
                lRet := .T. 
            Else
                DisarmTransaction()
                MsgStop('Erro', oModel:GetErrorMessage()[6])
            Endif 
        Else
            DisarmTransaction()
            lMsErroAuto := .T. //seta variavel private como erro
            MsgStop('Erro', oModel:GetErrorMessage()[6])
        EndIf
    End Transaction
	oModel:DeActivate() //desativa modelo	
    oModel:Destroy()
    RestArea(aArea)
Return lRet


/*/ Rotina de Exclusão de Equipe/*/
User  Function ETTCP02B(cCodigo)
    Local lRet     := .F.
	Private cTabMaster :="ZX2"
	Private cTabDetail :="ZX3"

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
            DbSelectArea("ZX2") // Substitua pelo seu Alias
            ZX2->(DbSetOrder(1)) // Substitua pelo seu Índice
            If ZX2->(DbSeek(xFilial("ZX2") + cCodigo))
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


Static Function fFazCommit()
    Local aArea  := FWGetArea()
    Local oModel := FWModelActive()
    Local lRet   := .T.
 
    //Aqui você pode fazer as operações antes de gravar
 
    //Aciona o commit dos dados preenchidos no formulário
	if !INCLUI .AND. !ALTERA  //Se for exclusão 
		//lRet:=fDelApuracao(ZT3->ZT3_MSIDEN)
	else 
    	FWFormCommit(oModel)
	Endif 

    FWRestArea(aArea)
Return lRet

/*/ Deleta o título do financeiro/*/

Static Function MDMVlPos( oModel )    
   Local nOperation := oModel:GetOperation()
   Local lRet := .T.        
   Local oModAual	 := FwModelActive()
   Local oModelZX2
   Local oModelZX3
   Local nAtual
   lOCAL cNumEquipe :=""
   LocAL cNumOS     :=""
        if ValType(oModAual)=="O"
            oModelZX2 := oModAual:GetModel(MDLMASTER)
            if ValType(oModelZX2)=="O"
                cNumEquipe:=oModelZX2:GetValue("ZX2_EQUIPE")
                //Marca Equipe como Prevista 
                ZX0->(DbSetOrder(1))//ZX0_FILIAL, ZX0_COD, ZX0_VERSAO, R_E_C_N_O_, D_E_L_E_T_
                if !Empty(cNumEquipe) .and. ZX0->(DbSeek(xFilial("ZX0")+cNumEquipe))
                    if ZX0->(RecLock("ZX0",.F.))
                        ZX0->ZX0_STATUS:=IIF( ( nOperation == MODEL_OPERATION_DELETE ),'1','')
                        ZX0->(MsUnLock())
                    Endif 
                Endif 
            Endif 
            oModelZX3 := oModAual:GetModel(MDLDETAIL)
            if ValType(oModelZX3)=="O"
                For nAtual := 1 To oModelZX3:Length()
                    //Posiciona na linha atual
                    oModelZX3:GoLine(nAtual)
                    cNumOS:=oModelZX3:GetValue("ZX3_ID_OS")
                    lLineDel:=oModelZX3:IsDeleted(nAtual) 

                    AA6->(DbSetOrder(1))
                    if AB6->(DbSeek(xFilial("AB6")+cNumOS))
                        if AB6->(RecLock("AB6",.F.))
                            If lLineDel .or. ( nOperation == MODEL_OPERATION_DELETE )                            
                                AB6->AB6_XSTATU:="N"
                                AB6->AB6_XVEICU:=""
                                AB6->AB6_XMOTOR:=""
                                AB6->AB6_XDTAGE:=ctod("//")
                                AB6->AB6_XTURNO:=""
                                AB6->AB6_XROTA :=""
                            else 
                                AB6->AB6_XSTATU:=oModelZX3:GetValue("ZX3_STATUS")
                            Endif 
                            AB6->(MsUnLock())
                        Endif 
                    Endif 
                Next
                oModelZX3:GoLine(1)
            Endif 
   EndIf
oModAual  :=nil 
oModelZX2 :=nil 
oModelZX3 :=nil 

Return( lRet )


User Function fGetOS(cOS,cTabela,cCampo)
Local xValor 
    AB6->(DbSetOrder(1))
    AB7->(DbSetOrder(1))
    SA1->(DbSetOrder(1))
    AAG->(DbSetOrder(1))
    AA3->(DbSetOrder(1))
    ABS->(DbSetOrder(1))
    if AB6->(DBSeek(xFilial("AB6")+cOS))

        if cTabela =="AB6" 
            Return xValor:=iif( AB6->(FieldPos(cCampo))>0,AB6->&(cCampo),nil)
        Endif 

        if cTabela =="SA1" .and. SA1->(DBSeek(xFilial("SA1")+AB6->AB6_CODCLI+AB6->AB6_LOJA))
            Return xValor:= AB6->AB6_CODCLI+"/"+AB6->AB6_LOJA +"-"+iif( SA1->(FieldPos(cCampo))>0,SA1->&(cCampo),nil)
        Endif 

        if AB7->(DBSeek(xFilial("AB7")+cOS))//AB7_FILIAL, AB7_NUMOS, AB7_ITEM, R_E_C_N_O_, D_E_L_E_T_
            if cTabela =="AB7" 
                Return xValor:=iif( AB7->(FieldPos(cCampo))>0,AB7->&(cCampo),nil)
            Endif 

            if cTabela =="AAG" .and. AAG->(DBSeek(xFilial("AAG")+AB7->AB7_CODPRB))//AAG_FILIAL, AAG_CODPRB, R_E_C_N_O_, D_E_L_E_T_
                Return xValor:=iif( AAG->(FieldPos(cCampo))>0,AAG->&(cCampo),nil)
            Endif 
            if AA3->(DBSeek(xFilial("AA3")+AB7->AB7_CODCLI+AB7->AB7_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER))//AA3_FILIAL, AA3_CODCLI, AA3_LOJA, AA3_CODPRO, AA3_NUMSER, AA3_FILORI, R_E_C_N_O_, D_E_L_E_T_
                if cTabela =="AA3" 
                    Return xValor:=iif( AA3->(FieldPos(cCampo))>0,AA3->&(cCampo),nil)
                Endif 
                if cTabela =="ABS"  .AND. ABS->(DBSeek(xFilial("ABS")+AA3->AA3_CODLOC))//ABS_FILIAL+ABS_LOCAL 
                    Return xValor:= iif( ABS->(FieldPos(cCampo))>0,ABS->&(cCampo),nil)
                Endif 
            Endif 
       Endif 
    Endif 
Return nil 
