//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Regras controle de lotes"
 
/*/{Protheus.doc} HSESTC01
Exemplo de Modelo 1 para cadastro
@author Edson Sales
Email: edson.pedro@totvs.com.br
@since 18/07/2025
/*/
 
User Function HSESTC01()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("HSESTC01")

    cAlias    := "SZX"
    cArquivo  := "SZX020"
    CheckFile(cAlias, cArquivo)
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Regras de controle de lote
    oBrowse:SetAlias("SZX")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    // oBrowse:AddLegend( "SZX->ZZ1_COD <= '000005'", "GREEN",    "Menor ou igual a 5" )
    // oBrowse:AddLegend( "SZX->ZZ1_COD >  '000005'", "RED",    "Maior que 5" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("SZX->ZZ1_COD >= '000000' .And. SZX->ZZ1_COD <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Edson Sales                                                  |
 | Email: edson.pedro@totvs.com.br                                     |
 | Data:  18/07/2025                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.HSESTC01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    // ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.HSESTC01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.HSESTC01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.HSESTC01' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Edson Sales                                           |
 | Email: edson.pedro@totvs.com.br                                     |
 | Data:  18/07/2025                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStSZX := FWFormStruct(1, "SZX")
         
    //Editando características do dicionário
    // oStSZX:SetProperty('ZZ1_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    // oStSZX:SetProperty('ZZ1_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("SZX", "ZZ1_COD")'))         //Ini Padrão
    // oStSZX:SetProperty('ZZ1_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZZ1_DESC), .F., .T.)'))   //Validação de Campo
    // oStSZX:SetProperty('ZZ1_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("SZXMODEL",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("SZXMASTER",/*cOwner*/,oStSZX)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZX_FILIAL','ZX_LOCORI','ZX_LOCDEST'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("SZXMASTER"):SetDescription("Formulário do Cadastro "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Edson Sales                                                  |
 | Email: edson.pedro@totvs.com.br                                     |
 | Data:  18/07/2025                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    // Local aStruSZX    := SZX->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("HSESTC01")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSZX := FWFormStruct(2, "SZX")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SZX", oStSZX, "SZXMASTER")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SZX', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SZX","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruSZX)
        cCampoAux := Alltrim(aStruSZX[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "ZZ1_COD;"
            oStSZX:RemoveField(cCampoAux)
        EndIf
    Next
    */
Return oView
 
/*/{Protheus.doc} zMod1Leg
Função para mostrar a legenda
@author Edson Sales
Email: edson.pedro@totvs.com.br
@since 18/07/2025
/*/
 
// User Function zMod1Leg()
//     Local aLegenda := {}
     
//     //Monta as cores
//     AADD(aLegenda,{"BR_VERDE",        "Menor ou igual a 5"  })
//     AADD(aLegenda,{"BR_VERMELHO",    "Maior que 5"})
     
//     BrwLegenda(cTitulo, "Status", aLegenda)
// Return
