//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Cadastro de Equipamentos"
 
/*/{Protheus.doc} MASEQUI
Função para cadastro de Grupo de Equipamentos (SZY), exemplo de Modelo 1 em MVC
@author Edson Sales
@since 20/07/2026
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_MASEQUI()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/
 
User Function MASEQUI()
    Local aArea   := GetArea()
    Local oBrowse

    cAlias    := "SZY"
    cArquivo  := "SZY010"
    CheckFile(cAlias, cArquivo)
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("SZY")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "SZY->ZY_USO  == 'S' .AND. SZY->ZY_OBSOL == 'N'", "GREEN" ,"EM USO"            )
    oBrowse:AddLegend( "SZY->ZY_USO  == 'S' .AND. SZY->ZY_OBSOL == 'S'", "YELLOW","OBSOLENTO EM USO"  )
    oBrowse:AddLegend( "SZY->ZY_USO  == 'N' .AND. SZY->ZY_OBSOL == 'S'", "RED"   ,"OBSOLENTO"          )
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Edson Sales                                           |
 | Data:  20/07/2026                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MASEQUI' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.MASEQUI' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MASEQUI' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MASEQUI' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Edson Sales                                           |
 | Data:  20/07/2026                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStSZY := FWFormStruct(1, "SZY")

    oStSZY:SetProperty('ZY_SERIAL',  MODEL_FIELD_OBRIGAT, .T.) //Exemplo de como setar uma propriedade de campo obrigatório) 
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("MASEQUIM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSZY",/*cOwner*/,oStSZY)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZY_FILIAL','ZY_SERIAL'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSZY"):SetDescription("Formulário do Cadastro "+cTitulo)
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Edson Sales                                                |
 | Data:  20/07/2026                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("MASEQUI")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSZY := FWFormStruct(2, "SZY")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZY_NOME|SZY_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SZY", oStSZY, "FORMSZY")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SZY', 'Dados do Grupo de Produtos' )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SZY","TELA")
Return oView
 
/*/{Protheus.doc} zMVC01Leg
Função para mostrar a legenda das rotinas MVC com grupo de produtos
@author Edson Sales
@since 20/07/2026
@version 1.0
    @example
    u_zMVC01Leg()
/*/
 
User Function zMVC01Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",      "ATIVO"  })
    AADD(aLegenda,{"BR_AMARELO",    "OBSOLENTO EM USO"  })
    AADD(aLegenda,{"BR_VERMELHO",   "OBSOLENTO"})
     
    BrwLegenda("Equipamentos de TI.", "Status", aLegenda)
Return
