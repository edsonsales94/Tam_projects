/*---------------------------------------------------------------------------*
 | Data       : 18/12/2023                                                   |
 | Rotina     : PEZXJ01                                                      |
 | Responsável: Edson Pedro                                                  |
 | Descrição  : Rotina de Cadastro de Ordem de Serviço Amazonaves            |
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
     
    SetFunName("PEZXJ01")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de Cadastro de Ordem de Serviços Amazonaves
    oBrowse:SetAlias("ZZJ")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "ZZJ->Z4_XSTATUS == 'A'", "GREEN",  "Em Aberto" )
    oBrowse:AddLegend( "ZZJ->Z4_XSTATUS == 'E'", "RED",    "Fechado" )
    oBrowse:AddLegend( "ZZJ->Z4_XSTATUS == 'P'", "BLUE",    "Fechado" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("ZZJ->ZZJ_COD >= '000000' .And. ZZJ->ZZJ_COD <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: eDSON SALES                                                  |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_xLegend'       OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
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
    Local oStZZJ := FWFormStruct(1, "ZZJ")
     
    //Editando características do dicionário
    // oStZZJ:SetProperty('ZZJ_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    // oStZZJ:SetProperty('ZZJ_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZJ", "ZZJ_COD")'))         //Ini Padrão
    // oStZZJ:SetProperty('ZZJ_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZZJ_DESC), .F., .T.)'))   //Validação de Campo
    // oStZZJ:SetProperty('ZZJ_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("PEZXJ01M",, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZZJ",/*cOwner*/,oStZZJ)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z4_FILIAL','Z4_COD'})
     
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
        If Alltrim(cCampoAux) $ "ZZJ_COD;"
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
    AADD(aLegenda,{"BR_VERDE",       "Em Aberto"    })
    AADD(aLegenda,{"BR_VERMELHO",    "Fechado"      })
    AADD(aLegenda,{"BR_AZUL"    ,    "Fechado"      })
     
    BrwLegenda('Status Apontamento', "Status", aLegenda)
Return

Static Function fPreVld(oModel)
Local lRet         := .T.
Local nOpc        := oModel:GetOperation()  

    If(nOpc == MODEL_OPERATION_UPDATE .and. ZZJ->Z4_XSTATUS == '2')

        lRet := .F.

        Help(,,'O.S Fechada','Não é permitida a alteração de O.S Fechada',,1,0,,,,,,{'Não Altera'})

    EndIf

Return(lRet)
