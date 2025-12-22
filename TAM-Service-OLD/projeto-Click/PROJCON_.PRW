//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
   
//Variáveis Estáticas
Static cTitulo := "Projeto x contatos"
   
/*/{Protheus.doc} PROJCON
Função para cadastros de Projeto x contatos 
@author Atilio
@since 13/09/2020
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_PROJCON()
    @obs Os campos chave usado entre cabeçalho e grid são: ZP8_CODPRO (Código Sequencial), ZP8_CLIENT (Nota Fiscal), ZP8_VALOR (Valor)
/*/
  
User Function PROJCON()
       Local aArea := GetArea()
    Local oBrowse

    // Cria o browse vinculado ao modelo MVC
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZP8") // tabela base
    oBrowse:SetDescription(cTitulo)
    // oBrowse:SetOrder(1) // índice primário (ex: ZP8010)
    // oBrowse:SetFieldMark("ZP8_CODPRO") // campo principal
    oBrowse:SetModel("PROJCON") // vincula ao MODELDEF
    oBrowse:Activate()

    RestArea(aArea)
Return Nil
  
Static Function MenuDef()
    Local aRot := {}
       
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.PROJCON' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.PROJCON' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.PROJCON' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.PROJCON' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot
  
Static Function ModelDef()
    //Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
    Local oModel      := NIL
    Local oStruCab     := FWFormStruct(1, 'ZP8', {|cCampo| AllTRim(cCampo) $ "ZP8_CODPRO;ZP8_DESCPR;"})
    Local oStruGrid := fModStruct()
  
    //Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
    oModel := MPFormModel():New('PROJCONM', /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )
  
    //Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
    oModel:AddFields('MdFieldZP8', NIL, oStruCab)
    oModel:AddGrid('MdGridZP8', 'MdFieldZP8', oStruGrid, , )
  
    //Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
    oModel:SetRelation('MdGridZP8', {;
            {'ZP8_FILIAL', 'xFilial("ZP8")'},;
            {"ZP8_CODPRO",  "ZP8_CODPRO"};
        }, ZP8->(IndexKey(1)))
      
    //Definindo outras informações do Modelo e da Grid
    oModel:GetModel("MdGridZP8"):SetMaxLine(9999)
    oModel:SetDescription("Atualização Controle de Combustível")
    // oModel:SetPrimaryKey({"ZP8_FILIAL", "ZP8_CODPRO"})
  
Return oModel
  
Static Function ViewDef()
    //Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
    Local oView        := NIL
    Local oModel    := FWLoadModel('PROJCON')
    Local oStruCab  := FWFormStruct(2, "ZP8", {|cCampo| AllTRim(cCampo) $ "ZP8_CODPRO;ZP8_DESCPR;"})
    Local oStruGRID := fViewStruct()
  
    //Define que no cabeçalho não terá separação de abas (SXA)
    oStruCab:SetNoFolder()
  
    //Cria o View
    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
  
    //Cria uma área de Field vinculando a estrutura do cabeçalho com MDFieldZP8, e uma Grid vinculando com MdGridZP8
    oView:AddField('VIEW_ZP8', oStruCab, 'MdFieldZP8')
    oView:AddGrid ('GRID_ZP8', oStruGRID, 'MdGridZP8' )
  
    //O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)
  
    //Vincula o MAIN com a VIEW_ZP8 e a GRID com a GRID_ZP8
    oView:SetOwnerView('VIEW_ZP8', 'MAIN')
    oView:SetOwnerView('GRID_ZP8', 'GRID')
    oView:EnableControlBar(.T.)
  
    //Define o campo incremental da grid como o ZP8_ITEM
    oView:AddIncrementField('GRID_ZP8', 'ZP8_SEQ')
Return oView
  
//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
    Local oStruct
    oStruct := FWFormStruct(1, 'ZP8')
Return oStruct
  
//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
    Local cCampoCom := "ZP8_CODPRO;ZP8_DESCPR;"
    Local oStruct
  
    //Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
    oStruct := FWFormStruct(2, "ZP8", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct
  
//Função que faz a validação da grid
// Static Function fValidGrid(oModel)
//     Local lRet     := .T.
//     Local nDeletados := 0
//     Local nLinAtual :=0
//     Local oModelGRID := oModel:GetModel('MdGridZP8')
//     Local oModelMain := oModel:GetModel('MdFieldZP8')
//     Local nValorMain := oModelMain:GetValue("ZP8_VALOR")
//     Local nValorGrid := 0
//     Local cPictVlr   := PesqPict('ZP8', 'ZP8_VALOR')
  
//     //Percorrendo todos os itens da grid
//     For nLinAtual := 1 To oModelGRID:Length() 
//         //Posiciona na linha
//         oModelGRID:GoLine(nLinAtual) 
          
//         //Se a linha for excluida, incrementa a variável de deletados, senão irá incrementar o valor digitado em um campo na grid
//         If oModelGRID:IsDeleted()
//             nDeletados++
//         Else
//             nValorGrid += NoRound(oModelGRID:GetValue("ZP8_TCOMB"), 4)
//         EndIf
//     Next nLinAtual
  
//     //Se o tamanho da Grid for igual ao número de itens deletados, acusa uma falha
//     If oModelGRID:Length()==nDeletados
//         lRet :=.F.
//         Help( , , 'Dados Inválidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha válida!"})
//     EndIf
  
//     If lRet
//         //Se o valor digitado no cabeçalho (valor da NF), não bater com o valor de todos os Projeto x contatos digitados (valor dos itens da Grid), irá mostrar uma mensagem alertando, porém irá permitir salvar (do contrário, seria necessário alterar lRet para falso)
//         If nValorMain != nValorGrid
//             //lRet := .F.
//             MsgAlert("O valor do cabeçalho (" + Alltrim(Transform(nValorMain, cPictVlr)) + ") tem que ser igual o valor dos itens (" + Alltrim(Transform(nValorGrid, cPictVlr)) + ")!", "Atenção")
//         EndIf
//     EndIf
  
// Return lRet
