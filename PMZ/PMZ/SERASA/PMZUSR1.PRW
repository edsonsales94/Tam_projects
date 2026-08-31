
#INCLUDE 'PROTHEUS.CH'
#Include "TOTVS.ch"
#Include "TopConn.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "RPTDEF.CH"
    
/*---------------------------------------------------------------------------*
 | Data       : 16/02/2026                                                   |
 | Rotina     : PMZUSR1                                                      |
 | Responsável: Edson Pedro                                                  |
 | Descrição  : Rotina Cadastro de usuario para integração Sarasa            |
 *---------------------------------------------------------------------------*/

Static cTitulo := "Usuario p/ integ. Sarasa"
 
/*/{Protheus.doc} PMZUSR1
/*/
 
User Function PMZUSR1()
    Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
     
    SetFunName("PMZUSR1")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de Cadastro de Ordem de Serviços Amazonaves
    oBrowse:SetAlias("SZ2")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    // oBrowse:AddLegend( "SZ2->Z2_STATUS == 'A'", "GREEN",  "Apontado" )
    // oBrowse:AddLegend( "SZ2->Z2_STATUS == 'P'", "BLUE",    "Pendente" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("SZ2->Z2_CODUSER >= '000000' .And. SZ2->Z2_CODUSER <= 'ZZZZZZ'")
     
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
    Local aRotina := {}
     
    //Adicionando opções
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.PMZUSR1' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.PMZUSR1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.PMZUSR1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.PMZUSR1' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
 
Return aRotina
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Edson Sales                                                  |
 | Data:  16/02/2026                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
    Local oStSZ2 := FWFormStruct(1, "SZ2")
    Local aGatilhos := {}
    Local nAtual
 
    //Adicionando um gatilho, do codigo para descrição
    aAdd(aGatilhos, FWStruTriggger( ;
        "Z2_CODUSER",;                              //Campo Origem
        "Z2_NOMEUSR",;                              //Campo Destino
        "UsrRetName(M->Z2_CODUSER)",;               //Regra de Preenchimento
        .F.,;                                       //Irá Posicionar?
        "",;                                        //Alias de Posicionamento
        0,;                                         //Índice de Posicionamento
        '',;                                        //Chave de Posicionamento
        NIL,;                                       //Condição para execução do gatilho
        "01");                                      //Sequência do gatilho
    )
  
    //Percorrendo os gatilhos e adicionando na Struct
    For nAtual := 1 To Len(aGatilhos)
        oStSZ2:AddTrigger( ;
            aGatilhos[nAtual][01],; //Campo Origem
            aGatilhos[nAtual][02],; //Campo Destino
            aGatilhos[nAtual][03],; //Bloco de código na validação da execução do gatilho
            aGatilhos[nAtual][04];  //Bloco de código de execução do gatilho
        )
    Next
     
    //Criação da estrutura de dados utilizada na interface
     
    //Editando características do dicionário
    oStSZ2:SetProperty('Z2_CODUSER',MODEL_FIELD_WHEN,FwBuildFeature(STRUCT_FEATURE_WHEN,iif(inclui,'.T.','.F.')))                                 //Modo de Edição
    // oStSZ2:SetProperty('Z2_CODUSER',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("SZ2", "Z2_CODUSER")'))         //Ini Padrão
    // oStSZ2:SetProperty('Z2_DESC',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->Z2_DESC), .F., .T.)'))   //Validação de Campo
    // oStSZ2:SetProperty('Z2_DESC',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("PMZUSR1M",, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSZ2",/*cOwner*/,oStSZ2)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z2_FILIAL','Z2_CODUSER'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)

    //Validação para não alterar OS Fechadas
    // oModel:SetVldActivate({ |oModel| fPreVld(oModel) })
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSZ2"):SetDescription("Formulário do Cadastro "+cTitulo)

Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Edson Sales                                                  |
 | Data:  16/02/2026                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruSZ2    := SZ2->(DbStruct())
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("PMZUSR1")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSZ2 := FWFormStruct(2, "SZ2")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ2_NOME|SZ2_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
    aStruSZ2 :=aStruSZ2
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SZ2", oStSZ2, "FORMSZ2")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SZ2', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SZ2","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruSZ2)
        cCampoAux := Alltrim(aStruSZ2[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "Z2_CODUSER;"
            oStSZ2:RemoveField(cCampoAux)
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
    AADD(aLegenda,{"BR_VERDE",  "Apontado"    })
    AADD(aLegenda,{"BR_AZUL",    "Pendente"      })
     
    BrwLegenda('Status Apontamento', "Status", aLegenda)
Return

Static Function fPreVld(oModel)
Local lRet         := .T.
Local nOpc        := oModel:GetOperation()  

    If(nOpc == MODEL_OPERATION_UPDATE .and. SZ2->Z2_STATUS == 'A')

        lRet := .F.

        Help(,,'O.S Fechada','Não é permitida a alteração de O.S Fechada',,1,0,,,,,,{'Não Altera'})

    EndIf

Return(lRet)
