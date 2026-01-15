//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Resina x Fornecedor"

/*/{Protheus.doc} MSPRDFN
Função para cadastros de Abastecimentos dos veículos
@author Atilio
@since 13/09/2020
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_MSPRDFN()
    @obs Os campos chave usado entre cabeçalho e grid são: SZA_IDSEQ (Código Sequencial), SZA_NOTFIS (Nota Fiscal), ZA_COD (Valor)
/*/

User Function MSPRDFN()
	Local aArea   := GetArea()
	Local oBrowse

	cAlias    := "SZA"
	cArquivo  := 'SZA010'
	CheckFile(cAlias, cArquivo)

	//Cria um browse para a SZA
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SZA")
	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}

	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.MSPRDFN' OPERATION 1 ACCESS 0 //OPERATION 1  MODEL_OPERATION_VIEW
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.MSPRDFN' OPERATION 3 ACCESS 0 //OPERATION 3  MODEL_OPERATION_INSERT
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.MSPRDFN' OPERATION 4 ACCESS 0 //OPERATION 4  MODEL_OPERATION_UPDATE
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.MSPRDFN' OPERATION 5 ACCESS 0 //OPERATION 5  MODEL_OPERATION_DELETE
Return aRot

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'SZA', {|cCampo| AllTRim(cCampo) $ "ZA_COD;ZA_DESC;"})
	Local oStruGrid := fModStruct()

	 //Blocos de código nas validações
    // Local bVldPre := {|| u_zM1bPre()} //Antes de abrir a Tela
    Local bVldPos := {|oModel| fValidGrid(oModel)} //Validação ao clicar no Confirmar
    // Local bVldCom := {|| u_zM1bCom()} //Função chamadao ao cancelar
    // Local bVldCan := {|| u_zM1bCan()} //Função chamadao ao cancelar

	oStruCab:SetProperty('ZA_COD',  MODEL_FIELD_OBRIGAT, .T. )                                                                          //Campo Obrigatóri
	oStruGrid:SetProperty('ZA_CODFOR',  MODEL_FIELD_OBRIGAT, .T. )                                                                          //Campo Obrigatóri

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	oModel := MPFormModel():New('MSPRDFNM', /*bPreValidacao*/, bVldPos , /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldSZA', NIL, oStruCab)
	oModel:AddGrid('MdGridSZA', 'MdFieldSZA', oStruGrid, , )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridSZA', {;
		{'ZA_FILIAL', 'xFilial("SZA")'},;
		{"ZA_COD"   ,  "ZA_COD"},;
		{"ZA_DESC",  "ZA_DESC"};
		}, SZA->(IndexKey(1)))

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridSZA"):SetMaxLine(9999)
	oModel:SetDescription("Cadastro")
	oModel:SetPrimaryKey({"ZA_FILIAL", "ZA_COD", "ZA_CODFOR"})
	SZA->(IndexKey(1))
Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('MSPRDFN')
	Local oStruCab  := FWFormStruct(2, "SZA", {|cCampo| AllTRim(cCampo) $ "ZA_COD;ZA_DESC;"})
	Local oStruGRID := fViewStruct()

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma área de Field vinculando a estrutura do cabeçalho com MDFieldSZA, e uma Grid vinculando com MdGridSZA
	oView:AddField('VIEW_SZA', oStruCab, 'MdFieldSZA')
	oView:AddGrid ('GRID_SZA', oStruGRID, 'MdGridSZA' )

	//O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
	oView:CreateHorizontalBox("MAIN", 25)
	oView:CreateHorizontalBox("GRID", 75)

	//Vincula o MAIN com a VIEW_SZA e a GRID com a GRID_SZA
	oView:SetOwnerView('VIEW_SZA', 'MAIN')
	oView:SetOwnerView('GRID_SZA', 'GRID')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o SZA_ITEM
	oView:AddIncrementField('GRID_SZA', 'ZA_SEQ')
Return oView

//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'SZA')
Return oStruct

//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
	Local cCampoCom := "ZA_COD;ZA_DESC;"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "SZA", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct

//Função que faz a validação da grid
Static Function fValidGrid(oModel)
	Local lRet     := .T.
	// Local nDeletados := 0
	Local nLinAtual :=0
	Local oModelGRID := oModel:GetModel('MdGridSZA')
	Local oModelMain := oModel:GetModel('MdFieldSZA')
	Local cChavePK := oModelGRID:GetValue("ZA_FILIAL")+oModelMain:GetValue("ZA_COD")+oModelGRID:GetValue("ZA_CODFOR")
	Local cCodigo  := oModelMain:GetValue("ZA_COD")
	Local cAliasTRB := GetNextAlias()
	// Local nValorGrid := 0
	// Local cPictVlr   := PesqPict('SZA', 'ZA_COD')
	NCONT := 0
	//Percorrendo todos os itens da grid
	For nLinAtual := 1 To oModelGRID:Length()
		//Posiciona na linha
		oModelGRID:GoLine(nLinAtual)
		if !oModelGRID:IsDeleted() .and. cChavePK == oModelGRID:GetValue("ZA_FILIAL")+oModelMain:GetValue("ZA_COD")+oModelGRID:GetValue("ZA_CODFOR")
			NCONT++
		endif

		IF NCONT >= 2
			Alert('Registro já inserido, não é possivel inserir registro duplicado.','Atencao' )
			lRet :=.F.
		EndIf

	Next nLinAtual
	
	BeginSQL ALIAS cAliasTRB

		select Count(*) QTD from %TABLE:SZA% SZA
		where SZA.%NOTDEL% AND ZA_COD = %exp:cCodigo%

	EndSQL

	IF (cAliasTRB)->(QTD) > 0 .AND. INCLUI
		Alert('o Código '+cCodigo+',já existe no cadastro, encontre o código no browse e altere para amarra à um novo fornecedor.','Atencao' )
		lRet :=.F.
	EndIf

	// //Se o tamanho da Grid for igual ao número de itens deletados, acusa uma falha
	// If oModelGRID:Length()==nDeletados
	//     lRet :=.F.
	//     Help( , , 'Dados Inválidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha válida!"})
	// EndIf

	// If lRet
	//     //Se o valor digitado no cabeçalho (valor da NF), não bater com o valor de todos os abastecimentos digitados (valor dos itens da Grid), irá mostrar uma mensagem alertando, porém irá permitir salvar (do contrário, seria necessário alterar lRet para falso)
	//     If nValorMain != nValorGrid
	//         //lRet := .F.
	//         MsgAlert("O valor do cabeçalho (" + Alltrim(Transform(nValorMain, cPictVlr)) + ") tem que ser igual o valor dos itens (" + Alltrim(Transform(nValorGrid, cPictVlr)) + ")!", "Atenção")
	//     EndIf
	// EndIf

Return lRet
