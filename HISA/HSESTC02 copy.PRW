//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Produtos com lotes vencidos"
 
/*/{Protheus.doc} HSESTC02
@author Edson Sales
Email: edson.pedro@totvs.com.br
@since 31/07/2025
/*/
 
User Function HSESTC02()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("HSESTC02")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Regras de controle de lote
    oBrowse:SetAlias("SZZ")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    // oBrowse:AddLegend( "SZZ->ZZ1_COD <= '000005'", "GREEN",    "Menor ou igual a 5" )
    // oBrowse:AddLegend( "SZZ->ZZ1_COD >  '000005'", "RED",    "Maior que 5" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("SZZ->ZZ1_COD >= '000000' .And. SZZ->ZZ1_COD <= 'ZZZZZZ'")
     
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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.HSESTC02' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    // ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Transferir'    ACTION 'VIEWDEF.HSESTC02' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Estornar'    ACTION 'VIEWDEF.HSESTC02' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    // ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.HSESTC02' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
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
    Local oStSZZ := FWFormStruct(1, "SZZ")
     
    //Editando características do dicionário
    // oStSZZ:SetProperty('ZZ1_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
    // oStSZZ:SetProperty('ZZ1_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("SZZ", "ZZ1_COD")'))         //Ini Padrão
    // oStSZZ:SetProperty('ZZ1_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZZ1_DESC), .F., .T.)'))   //Validação de Campo
    // oStSZZ:SetProperty('ZZ1_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("SZZMODEL",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("SZZMASTER",/*cOwner*/,oStSZZ)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZZ_FILIAL','ZZ_COD','ZZ_LOCORI','ZZ_LOCDEST','ZZ_DTPROC'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("SZZMASTER"):SetDescription("Formulário do Cadastro "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Edson Sales                                                  |
 | Email: edson.pedro@totvs.com.br                                     |
 | Data:  18/07/2025                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruSZZ    := SZZ->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("HSESTC02")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSZZ := FWFormStruct(2, "SZZ")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZZ1_NOME|SZZ1_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SZZ", oStSZZ, "SZZMASTER")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SZZ', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SZZ","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruSZZ)
        cCampoAux := Alltrim(aStruSZZ[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "ZZ1_COD;"
            oStSZZ:RemoveField(cCampoAux)
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

Static Function GerTransf()

    Alert('Tranferido ...')
Return
