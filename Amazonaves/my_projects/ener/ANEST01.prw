/*---------------------------------------------------------------------------*
 | Data       : 18/12/2023                                                   |
 | Rotina     : ANEST01                                                     |
 | Responsável: ENER FREDES                                                  |
 | Descrição  : Rotina de Cadastro de Ordem de Serviço Amazonaves            |
 *---------------------------------------------------------------------------*/

//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "Protheus.ch"
 
// User Function ANEST01()
//     Local cDelOk   := ".T."
//     Local cFunTOk  := ".T." //Pode ser colocado como "u_zVldTst()"
 
//     //Chamando a tela de cadastros
//     AxCadastro('SZ4', 'Cadastro de Ordem de Serviços Amazonaves', cDelOk, cFunTOk)
 
//Variáveis Estáticas
Static cTitulo := "Cadastro de Ordem de Serviços Amazonaves"
 
/*/{Protheus.doc} ANEST01
@author Atilio
@since 31/07/2016
/*/
 
User Function ANEST01()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("ANEST01")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de Cadastro de Ordem de Serviços Amazonaves
    oBrowse:SetAlias("SZ4")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "SZ4->Z4_XSTATUS == '1'", "GREEN",  "Em Aberto" )
    oBrowse:AddLegend( "SZ4->Z4_XSTATUS == '2'", "RED",    "Fechado" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("SZ4->SZ4_COD >= '000000' .And. SZ4->SZ4_COD <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ANEST01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_xLegend'       OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ANEST01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ANEST01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ANEST01' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
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
    Local oStSZ4 := FWFormStruct(1, "SZ4")
     
    //Editando características do dicionário
    // oStSZ4:SetProperty('SZ4_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    // oStSZ4:SetProperty('SZ4_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("SZ4", "SZ4_COD")'))         //Ini Padrão
    // oStSZ4:SetProperty('SZ4_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->SZ4_DESC), .F., .T.)'))   //Validação de Campo
    // oStSZ4:SetProperty('SZ4_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("ANEST01M",, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSZ4",/*cOwner*/,oStSZ4)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z4_FILIAL','Z4_COD'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)

    //Validação para não alterar OS Fechadas
    // oModel:SetVldActivate({ |oModel| fPreVld(oModel) })
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSZ4"):SetDescription("Formulário do Cadastro "+cTitulo)

Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruSZ4    := SZ4->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("ANEST01")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSZ4 := FWFormStruct(2, "SZ4")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SSZ4_NOME|SSZ4_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SZ4", oStSZ4, "FORMSZ4")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SZ4', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SZ4","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruSZ4)
        cCampoAux := Alltrim(aStruSZ4[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "SZ4_COD;"
            oStSZ4:RemoveField(cCampoAux)
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
    AADD(aLegenda,{"BR_VERDE",       "Em Aberto"    })
    AADD(aLegenda,{"BR_VERMELHO",    "Fechado"      })
     
    BrwLegenda('OS Amazonaves', "Status", aLegenda)
Return

Static Function fPreVld(oModel)
Local lRet         := .T.
Local nOpc        := oModel:GetOperation()  

    If(nOpc == MODEL_OPERATION_UPDATE .and. SZ4->Z4_XSTATUS == '2')

        lRet := .F.

        Help(,,'O.S Fechada','Não é permitida a alteração de O.S Fechada',,1,0,,,,,,{'Não Altera'})

    EndIf

Return(lRet)
