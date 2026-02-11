//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
   
//Variáveis Estáticas
Static cTitulo := "Cadastro de carteira"
   
/*/{Protheus.doc} MCCART1
Função para cadastros de Carteira
@author Edson Sales
@since 13/09/2026
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_MCCART1()
    @obs Os campos chave usado entre cabeçalho e grid são: ZX_CLIENTE (Código Sequencial), ZX_NOMCLI (Nota Fiscal), ZX_PERIODO (Valor)
/*/
  
User Function MCCART1()
    Local aArea   := GetArea()
    Local oBrowse
       
    //Cria um browse para a SZX
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SZX")
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()
       
    RestArea(aArea)
Return Nil
  
Static Function MenuDef()
    Local aRot := {}
       
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MCCART1' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.MCCART1' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MCCART1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MCCART1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot
  
Static Function ModelDef()
    //Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
    Local oModel      := NIL
    Local oStruCab     := FWFormStruct(1, 'SZX', {|cCampo| AllTRim(cCampo) $ "ZX_CLIENTE;ZX_NOMCLI;ZX_PERIODO;"})
    Local oStruGrid := fModStruct()
  
    //Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
    oModel := MPFormModel():New('MCCART1M', /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )
  
    //Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
    oModel:AddFields('MdFieldSZX', NIL, oStruCab)
    oModel:AddGrid('MdGridSZX', 'MdFieldSZX', oStruGrid, , )
  
    //Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
    oModel:SetRelation('MdGridSZX', {;
            {'ZX_FILIAL', 'xFilial("SZX")'},;
            {"ZX_CLIENTE",  "ZX_CLIENTE"},;
            {"ZX_NOMCLI", "ZX_NOMCLI"},;
            {"ZX_PERIODO",  "ZX_PERIODO"};
        }, SZX->(IndexKey(1)))
      
    //Definindo outras informações do Modelo e da Grid
    oModel:GetModel("MdGridSZX"):SetMaxLine(9999)
    oModel:SetDescription("Atualização Controle de Combustível")
    oModel:SetPrimaryKey({"ZX_FILIAL", "ZX_CLIENTE", "ZX_PERIODO"})
  
Return oModel
  
Static Function ViewDef()
    //Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
    Local oView        := NIL
    Local oModel    := FWLoadModel('MCCART1')
    Local oStruCab  := FWFormStruct(2, "SZX", {|cCampo| AllTRim(cCampo) $ "ZX_CLIENTE;ZX_NOMCLI;ZX_PERIODO;"})
    Local oStruGRID := fViewStruct()
  
    //Define que no cabeçalho não terá separação de abas (SXA)
    oStruCab:SetNoFolder()
  
    //Cria o View
    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
  
    //Cria uma área de Field vinculando a estrutura do cabeçalho com MDFieldSZX, e uma Grid vinculando com MdGridSZX
    oView:AddField('VIEW_SZX', oStruCab, 'MdFieldSZX')
    oView:AddGrid ('GRID_SZX', oStruGRID, 'MdGridSZX' )
  
    //O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)
  
    //Vincula o MAIN com a VIEW_SZX e a GRID com a GRID_SZX
    oView:SetOwnerView('VIEW_SZX', 'MAIN')
    oView:SetOwnerView('GRID_SZX', 'GRID')
    oView:EnableControlBar(.T.)
  
    //Define o campo incremental da grid como o ZX_SEQ
    oView:AddIncrementField('GRID_SZX', 'ZX_SEQ')
Return oView
  
//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
    Local oStruct
    oStruct := FWFormStruct(1, 'SZX')
Return oStruct
  
//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
    Local cCampoCom := "ZX_CLIENTE;ZX_NOMCLI;ZX_PERIODO;"
    Local oStruct
  
    //Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
    oStruct := FWFormStruct(2, "SZX", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct
  
//Função que faz a validação da grid
Static Function fValidGrid(oModel)
    Local lRet     := .T.
    Local nDeletados := 0
    Local nLinAtual :=0
    Local oModelGRID := oModel:GetModel('MdGridSZX')
    Local oModelMain := oModel:GetModel('MdFieldSZX')
    Local nValorMain := oModelMain:GetValue("ZX_PERIODO")
    Local nValorGrid := 0
    Local cPictVlr   := PesqPict('SZX', 'ZX_PERIODO')
  
    //Percorrendo todos os itens da grid
    For nLinAtual := 1 To oModelGRID:Length() 
        //Posiciona na linha
        oModelGRID:GoLine(nLinAtual) 
          
        //Se a linha for excluida, incrementa a variável de deletados, senão irá incrementar o valor digitado em um campo na grid
        If oModelGRID:IsDeleted()
            nDeletados++
        Else
            nValorGrid += NoRound(oModelGRID:GetValue("SZX_TCOMB"), 4)
        EndIf
    Next nLinAtual
  
    //Se o tamanho da Grid for igual ao número de itens deletados, acusa uma falha
    If oModelGRID:Length()==nDeletados
        lRet :=.F.
        Help( , , 'Dados Inválidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha válida!"})
    EndIf
  
    If lRet
        If nValorMain != nValorGrid
            //lRet := .F.
            MsgAlert("O valor do cabeçalho (" + Alltrim(Transform(nValorMain, cPictVlr)) + ") tem que ser igual o valor dos itens (" + Alltrim(Transform(nValorGrid, cPictVlr)) + ")!", "Atenção")
        EndIf
    EndIf
  
Return lRet
