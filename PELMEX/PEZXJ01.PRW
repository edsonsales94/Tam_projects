//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Monitor Ordens de Produção"

/*/{Protheus.doc} PEZXJ01
Função para cadastros de Monitor Ordens de Produção
@author Edson
@since 31/12/2025
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_PEZXJ01()
    @obs Os campos chave usado entre cabeçalho e grid são: ZXJ_NUM (Código Sequencial), ZXJ_DOCAPO (Nota Fiscal), ZXJ_OP (Valor)
/*/

User Function PEZXJ01()
	Local aArea   := GetArea()
	Local oBrowse

	//Cria um browse para a ZXJ
    // Garante o índice correto
	DbSelectArea("ZXJ")
	DbSetOrder(1)
     
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZXJ")
	oBrowse:SetDescription(cTitulo)
	oBrowse:AddLegend( "ZXJ_STATUS=='1'", "GREEN"   , "Aguard. Apontamento" )
	oBrowse:AddLegend( "ZXJ_STATUS=='2'", "RED"     , "Apontado" )
	oBrowse:AddLegend( "ZXJ_STATUS=='3'", "BLUE"    , "Encerrada" )

	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}

	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	// ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_xLegend'       OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.PEZXJ01' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'ZXJ', {|cCampo| AllTRim(cCampo) $ "ZXJ_OP;"})
	Local oStruGrid := fModStruct()

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	oModel := MPFormModel():New('PEZXJ01M', {|oModel| fValidGrid(oModel,1)}, {|oModel| fValidGrid(oModel,2)}, {|oModel| fValidGrid(oModel,3)}/*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldZXJ', NIL, oStruCab)
	oModel:AddGrid('MdGridZXJ', 'MdFieldZXJ', oStruGrid, , )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridZXJ', {;
		{'ZXJ_FILIAL', 'xFilial("ZXJ")'},;
		{"ZXJ_OP",  "ZXJ_OP"};
		}, ZXJ->(IndexKey(1)))

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridZXJ"):SetMaxLine(9999)
	oModel:SetDescription("Atualização Controle de Combustível")
	oModel:SetPrimaryKey({"ZXJ_FILIAL","ZXJ_OP"})

Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('PEZXJ01')
	Local oStruCab  := FWFormStruct(2, "ZXJ", {|cCampo| AllTRim(cCampo) $ "ZXJ_OP;"})
	Local oStruGRID := fViewStruct()

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma área de Field vinculando a estrutura do cabeçalho com MDFieldZXJ, e uma Grid vinculando com MdGridZXJ
	oView:AddField('VIEW_ZXJ', oStruCab, 'MdFieldZXJ')
	oView:AddGrid ('GRID_ZXJ', oStruGRID, 'MdGridZXJ' )

	//O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
	oView:CreateHorizontalBox("MAIN", 25)
	oView:CreateHorizontalBox("GRID", 75)

	//Vincula o MAIN com a VIEW_ZXJ e a GRID com a GRID_ZXJ
	oView:SetOwnerView('VIEW_ZXJ', 'MAIN')
	oView:SetOwnerView('GRID_ZXJ', 'GRID')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZXJ_ITEM
	oView:AddIncrementField('GRID_ZXJ', 'ZXJ_SEQUEN')
Return oView

//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'ZXJ')
Return oStruct

//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
	Local cCampoCom := "ZXJ_OP;"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "ZXJ", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct

//Função que faz a validação da grid
Static Function fValidGrid(oModel,NOPC)
	Local lRet     := .T.
	Local nDeletados := 0
	Local nLinAtual :=0
	Local oModelGRID := oModel:GetModel('MdGridZXJ')
	Local oModelMain := oModel:GetModel('MdFieldZXJ')
	Local nValorMain := oModelMain:GetValue("ZXJ_OP")
	Local nValorGrid := 0
	Local cPictVlr   := PesqPict('ZXJ', 'ZXJ_OP')

	// if NOPC == 1
	//     ALERT('PREVALIDAÇÃO')
	// elseif NOPC==2
	//     ALERT('POSVALIDAÇÃO')
	// Else
	//     ALERT('BCOMIT')
	// endif

	// //Percorrendo todos os itens da grid
	// For nLinAtual := 1 To oModelGRID:Length()
	//     //Posiciona na linha
	//     oModelGRID:GoLine(nLinAtual)

	//     //Se a linha for excluida, incrementa a variável de deletados, senão irá incrementar o valor digitado em um campo na grid
	//     If oModelGRID:IsDeleted()
	//         nDeletados++
	//     Else
	//         nValorGrid += NoRound(oModelGRID:GetValue("ZXJ_TCOMB"), 4)
	//     EndIf
	// Next nLinAtual

	// //Se o tamanho da Grid for igual ao número de itens deletados, acusa uma falha
	// If oModelGRID:Length()==nDeletados
	//     lRet :=.F.
	//     Help( , , 'Dados Inválidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha válida!"})
	// EndIf

	// If lRet
	//     //Se o valor digitado no cabeçalho (valor da NF), não bater com o valor de todos os Monitor Ordens de Produção digitados (valor dos itens da Grid), irá mostrar uma mensagem alertando, porém irá permitir salvar (do contrário, seria necessário alterar lRet para falso)
	//     If nValorMain != nValorGrid
	//         //lRet := .F.
	//         MsgAlert("O valor do cabeçalho (" + Alltrim(Transform(nValorMain, cPictVlr)) + ") tem que ser igual o valor dos itens (" + Alltrim(Transform(nValorGrid, cPictVlr)) + ")!", "Atenção")
	//     EndIf
	// EndIf

Return lRet

User Function xLegend()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",     "Aguard. Apontamento"   })
    AADD(aLegenda,{"BR_VERMELHO",  "Apontado"      })
    AADD(aLegenda,{"BR_AZUL",      "Encerrado"      })
     
    BrwLegenda('Monitor Apontamento', "Status", aLegenda)
Return
