/*---------------------------------------------------------------------------*
 | Data       : 18/12/2023                                                   |
 | Rotina     : PEZXJ01                                                      |
 | Responsável: Edson Pedro                                                  |
 | Descrição  : Rotina Monitor Integracao RFID x PROTHEUS                    |
 *---------------------------------------------------------------------------*/

//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "Protheus.ch"

Static cTitulo := "Monitor Integracao RFID x PROTHEUS"
 
/*/{Protheus.doc} PEZXJ01
/*/
 
User Function PEZXJ01()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()

	Local aPergs   := {}
    local cStatus :='P'
    local cCondicao := ''
	local aStatus  := {'P=Pendentes','A=Apontados','E=Erro','T=Todos'}

    FnParam(@aPergs,@cStatus,@cCondicao,@aStatus)
     
    SetFunName("PEZXJ01")

    // aSeek:={}
    aFields:={}

    // aAdd(aSeek,{GetSX3Cache('ZZJ_CODETI', "X3_TITULO"), {{"", GetSX3Cache('ZZJ_CODETI', "X3_TIPO"), GetSX3Cache('ZZJ_CODETI', "X3_TAMANHO"), GetSX3Cache('ZZJ_CODETI', "X3_DECIMAL"), AllTrim(GetSX3Cache('ZZJ_CODETI', "X3_TITULO")), AllTrim(GetSX3Cache('ZZJ_CODETI', "X3_PICTURE"))}} } )
	// aAdd(aSeek,{GetSX3Cache('ZZJ_OP', "X3_TITULO"), {{"", GetSX3Cache('ZZJ_OP', "X3_TIPO"), GetSX3Cache('ZZJ_OP', "X3_TAMANHO"), GetSX3Cache('ZZJ_OP', "X3_DECIMAL"), AllTrim(GetSX3Cache('ZZJ_OP', "X3_TITULO")), AllTrim(GetSX3Cache('ZZJ_OP', "X3_PICTURE"))}} } )
	// aAdd(aSeek,{GetSX3Cache('ZZJ_PRODUT', "X3_TITULO"), {{"", GetSX3Cache('ZZJ_PRODUT', "X3_TIPO"), GetSX3Cache('ZZJ_PRODUT', "X3_TAMANHO"), GetSX3Cache('ZZJ_PRODUT', "X3_DECIMAL"), AllTrim(GetSX3Cache('ZZJ_PRODUT', "X3_TITULO")), AllTrim(GetSX3Cache('ZZJ_PRODUT', "X3_PICTURE"))}} } )
	// aAdd(aSeek,{GetSX3Cache('ZZJ_PRODUT', "X3_TITULO"), {{"", GetSX3Cache('ZZJ_PRODUT', "X3_TIPO"), GetSX3Cache('ZZJ_PRODUT', "X3_TAMANHO"), GetSX3Cache('ZZJ_PRODUT', "X3_DECIMAL"), AllTrim(GetSX3Cache('ZZJ_PRODUT', "X3_TITULO")), AllTrim(GetSX3Cache('ZZJ_PRODUT', "X3_PICTURE"))}} } )

	aAdd(aFields,{GetSX3Cache('ZZJ_CODETI',     "X3_CAMPO"),GetSX3Cache('ZZJ_CODETI',     "X3_TITULO"), GetSX3Cache('ZZJ_CODETI', "X3_TIPO"), GetSX3Cache('ZZJ_CODETI', "X3_TAMANHO"),     GetSX3Cache('ZZJ_CODETI', "X3_DECIMAL"), AllTrim(GetSX3Cache('ZZJ_CODETI', "X3_PICTURE"))})
	aAdd(aFields,{GetSX3Cache('ZZJ_OP', "X3_CAMPO"),GetSX3Cache('ZZJ_OP', "X3_TITULO"), GetSX3Cache('ZZJ_OP', "X3_TIPO"), GetSX3Cache('ZZJ_OP', "X3_TAMANHO"), GetSX3Cache('ZZJ_OP', "X3_DECIMAL"), AllTrim(GetSX3Cache('ZZJ_OP', "X3_PICTURE"))})
	aAdd(aFields,{GetSX3Cache('ZZJ_PRODUT', "X3_CAMPO"),GetSX3Cache('ZZJ_PRODUT', "X3_TITULO"), GetSX3Cache('ZZJ_PRODUT', "X3_TIPO"), GetSX3Cache('ZZJ_PRODUT', "X3_TAMANHO"), GetSX3Cache('ZZJ_PRODUT', "X3_DECIMAL"), AllTrim(GetSX3Cache('F2_XNUMPRO', "X3_PICTURE"))})
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
    
    //Setando a tabela de Cadastro de Ordem de Serviços Amazonaves
    oBrowse:SetAlias("ZZJ")
    oBrowse:SetFilterDefault(cCondicao)
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
    oBrowse:SetDBFFilter(.T.)
	oBrowse:SetUseFilter(.T.) //Habilita a utilização do filtro no Browse
	oBrowse:SetFixedBrowse(.T.)
	oBrowse:SetFieldFilter(aFields)
    // oBrowse:SetSeek(.T.,aSeek)
    
    // chamar parametros prcionando F12
    // oBrowse:bKeyDown := {|nKey|  If(nKey == 123, Refiltra(oBrowse,aPergs,cStatus,cCondicao,aStatus),  NIL)}
    // Habilita filtro padrão
    oBrowse:SetFilterDefault(cCondicao)
    //Legendas
    oBrowse:AddLegend( "ZZJ->ZZJ_STATUS == 'A'", "GREEN",  "Apontado"             )
    oBrowse:AddLegend( "ZZJ->ZZJ_STATUS == 'P'", "BLUE",   "Pendente Apontamento" )
    oBrowse:AddLegend( "ZZJ->ZZJ_STATUS == 'E'", "RED",    "Erro Apontamento"     )
          
    SetKey(VK_F12 , { || Refiltra(oBrowse,aPergs,cStatus,cCondicao,aStatus) })
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: EDSON SALES                                                  |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRotina := {}
     
    //Adicionando opções
    ADD OPTION aRotina TITLE 'Apontar'    ACTION 'U_PEAPONT' OPERATION 6 ACCESS 0 //OPERATION X
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRotina TITLE 'Legenda'    ACTION 'u_xLegend'       OPERATION 6                      ACCESS 0 //OPERATION X
    // ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    // ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    // ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRotina
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStZZJ := FWFormStruct(1, "ZZJ")
     
    //Editando características do dicionário
    // oStZZJ:SetProperty('ZZJ_PRODUT',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    // oStZZJ:SetProperty('ZZJ_PRODUT',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZJ", "ZZJ_PRODUT")'))         //Ini Padrão
    // oStZZJ:SetProperty('ZZJ_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZZJ_DESC), .F., .T.)'))   //Validação de Campo
    // oStZZJ:SetProperty('ZZJ_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("PEZXJ01M",, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZZJ",/*cOwner*/,oStZZJ)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZZJ_FILIAL','ZZJ_PRODUT'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)

    //Validação para não alterar OS Fechadas
    // oModel:SetVldActivate({ |oModel| fPreVld(oModel) })
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZZJ"):SetDescription("Formulário do Cadastro "+cTitulo)

Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruZZJ    := ZZJ->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("PEZXJ01")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZZJ := FWFormStruct(2, "ZZJ")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZJ_NOME|SZZJ_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_ZZJ", oStZZJ, "FORMZZJ")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_ZZJ', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_ZZJ","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruZZJ)
        cCampoAux := Alltrim(aStruZZJ[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "ZZJ_PRODUT;"
            oStZZJ:RemoveField(cCampoAux)
        EndIf
    Next
    */
Return oView

/*/{Protheus.doc} xLegend
Função para mostrar a legenda
@author Atilio
@since 31/07/2016
@version 1.0
    @example
    u_xLegend()
/*/

User Function xLegend()
	Local aLegenda := {}

	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",  "Apontado"                  })
	AADD(aLegenda,{"BR_AZUL",   "Pendente apontamento"      })
	AADD(aLegenda,{"BR_RED",    "Erro Apontamento"          })

	BrwLegenda('Status Apontamento', "Status", aLegenda)
Return

Static Function fPreVld(oModel)
	Local lRet         := .T.
	Local nOpc        := oModel:GetOperation()

	If(nOpc == MODEL_OPERATION_UPDATE .and. ZZJ->ZZJ_STATUS == 'A')

		lRet := .F.

		Help(,,'O.S Fechada','Não é permitida a alteração de O.S Fechada',,1,0,,,,,,{'Não Altera'})

	EndIf

Return(lRet)


/*/{Protheus.doc} FnParam
@author user
@since 19/02/2026

/*/
Static Function FnParam(aPergs,cStatus,cCondicao,aStatus)
	aPergs := {}
	aAdd(aPergs, {2, "Status OP:",  cStatus, aStatus,80, ".T.", .F.})
	If ParamBox(aPergs, "Informe os parametros")
		Do Case
		Case MV_PAR01 == "T"
			cCondicao := ""

		Case MV_PAR01 == "P"
			cCondicao := "ZZJ->ZZJ_STATUS == 'P'"

		Case MV_PAR01 == "A"
			cCondicao := "ZZJ->ZZJ_STATUS == 'A'"

		Case MV_PAR01 == "E"
			cCondicao := "ZZJ->ZZJ_STATUS == 'E'"
		EndCase
	EndIF
Return

Static Function Refiltra(oBrowse,aPergs,cStatus,cCondicao,aStatus)

	FnParam(@aPergs,@cStatus,@cCondicao,@aStatus)

	oBrowse:SetFilterDefault(cCondicao)
	oBrowse:Refresh()

Return
