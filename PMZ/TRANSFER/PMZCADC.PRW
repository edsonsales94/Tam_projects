//Bibliotecas
#INCLUDE 'PROTHEUS.CH'
#Include "TOTVS.ch"
#Include "TopConn.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "RPTDEF.CH"
    
/*---------------------------------------------------------------------------*
 | Data       : 24/02/2026                                                   |
 | Rotina     : PMZCADC                                                      |
 | Responsável: Edson Pedro                                                  |
 | Descrição  : Rotina Cadastro de coligada para tranf. entre filiais        |
 *---------------------------------------------------------------------------*/

Static cTitulo := "Vendas a coligadas."
 
/*/{Protheus.doc} PMZCADC
/*/
 
User Function PMZCADC()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("PMZCADC")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
    //Setando a tabela de Cadastro de Ordem de Serviços Amazonaves
    oBrowse:SetAlias("ZZ2")
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    // oBrowse:AddLegend( "ZZ2->Z2_STATUS == 'A'", "GREEN",  "Apontado" )
    // oBrowse:AddLegend( "ZZ2->Z2_STATUS == 'P'", "BLUE",    "Pendente" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("ZZ2->ZZ2_FILORI >= '000000' .And. ZZ2->ZZ2_FILORI <= 'ZZZZZZ'")
     
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
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.PMZCADC' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.PMZCADC' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.PMZCADC' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.PMZCADC' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
 
Return aRotina
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Edson Sales                                                  |
 | Data:  24/02/2026                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
    Local oStZZ2 := FWFormStruct(1, "ZZ2")
    Local aGatilhos := {}
    Local nAtual
     
    //Criação da estrutura de dados utilizada na interface
     
    //Editando características do dicionário
    // oStZZ2:SetProperty('ZZ2_FILORI',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    // oStZZ2:SetProperty('ZZ2_FILORI',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ2", "ZZ2_FILORI")'))         //Ini Padrão
    // oStZZ2:SetProperty('Z2_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->Z2_DESC), .F., .T.)'))   //Validação de Campo
    // oStZZ2:SetProperty('Z2_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("PMZCADCM",, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZZ2",/*cOwner*/,oStZZ2)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z2_FILIAL','ZZ2_FILORI','ZZ2_FILDES'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo do Cadastro "+cTitulo)

    //Validação para não alterar OS Fechadas
    // oModel:SetVldActivate({ |oModel| fPreVld(oModel) })
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZZ2"):SetDescription("Formulário do Cadastro "+cTitulo+ ' Orig x Dest.')

Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Edson Sales                                                  |
 | Data:  24/02/2026                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruZZ2    := ZZ2->(DbStruct())
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("PMZCADC")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZZ2 := FWFormStruct(2, "ZZ2")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'ZZ2_NOME|ZZ2_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
    aStruZZ2 :=aStruZZ2
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_ZZ2", oStZZ2, "FORMZZ2")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_ZZ2', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_ZZ2","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruZZ2)
        cCampoAux := Alltrim(aStruZZ2[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "ZZ2_FILORI;"
            oStZZ2:RemoveField(cCampoAux)
        EndIf
    Next
    */
Return oView
