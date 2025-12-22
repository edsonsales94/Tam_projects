// //Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function HSEST02()
	Local aArea   := GetArea()
	Local oBrowse

	cAlias    := "SZZ"
    cArquivo  := "SZZ020"
    CheckFile(cAlias, cArquivo)

	//Cria um browse para a SZZ
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SZZ')
	oBrowse:SetDescription('Tranferencia por Controle de Lote')
	//Legendas
	oBrowse:AddLegend( "SZZ->ZZ_STATUS == '2'", "GREEN",    "Aguardando Transf." )
	oBrowse:AddLegend( "SZZ->ZZ_STATUS == '1'", "RED",       "Tranferido" )

	oBrowse:SetFilterDefault('')
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}

	//Adicionando opções
	ADD OPTION aRot TITLE 'Efetivar'    ACTION 'U_GerTransf(1)' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.HSEST02' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Estornar'    ACTION 'U_GerTransf(2)' OPERATION 6 ACCESS 0 //OPERATION 4
	// ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.HSEST02' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'SZZ', {|cCampo| AllTRim(cCampo) $ "ZZ_FILIAL;ZZ_NUMPROC;ZZ_DTPROC;"})
	Local oStruGrid := fModStruct()

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	oModel := MPFormModel():New('HSEST02M', /*bPreValidacao*/, {|oModel| fValidGrid(oModel)}, /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldSZZ', NIL, oStruCab)
	oModel:AddGrid('MdGridSZZ', 'MdFieldSZZ', oStruGrid, , )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridSZZ', {;
		{'ZZ_FILIAL', 'xFilial("SZZ")'},;
		{"ZZ_NUMPROC",  "ZZ_NUMPROC"},;
		{"ZZ_DTPROC", "ZZ_DTPROC"};
		}, SZZ->(IndexKey(1)))

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridSZZ"):SetMaxLine(9999)
	oModel:SetDescription("Atualização Controle de Combustível")
	oModel:SetPrimaryKey({"ZZ_FILIAL", "ZZ_NUMPROC", "ZZ_COD"})

Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('HSEST02')
	Local oStruCab  := FWFormStruct(2, "SZZ", {|cCampo| AllTRim(cCampo) $ "ZZ_FILIAL;ZZ_NUMPROC;ZZ_DTPROC;"})
	Local oStruGRID := fViewStruct()

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma área de Field vinculando a estrutura do cabeçalho com MDFieldSZZ, e uma Grid vinculando com MdGridSZZ
	oView:AddField('VIEW_SZZ', oStruCab, 'MdFieldSZZ')
	oView:AddGrid ('GRID_SZZ', oStruGRID, 'MdGridSZZ' )

	//O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
	oView:CreateHorizontalBox("MAIN", 25)
	oView:CreateHorizontalBox("GRID", 75)

	//Vincula o MAIN com a VIEW_SZZ e a GRID com a GRID_SZZ
	oView:SetOwnerView('VIEW_SZZ', 'MAIN')
	oView:SetOwnerView('GRID_SZZ', 'GRID')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZZ_ITEM
	oView:AddIncrementField('GRID_SZZ', 'ZZ_ITEM')
Return oView

//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'SZZ')
Return oStruct

//Função chamada para montar a visualização de dados da Grid
Static Function fViewStruct()
	Local cCampoCom := "ZZ_FILIAL;ZZ_NUMPROC;ZZ_DTPROC;"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "SZZ", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct

//Função que faz a validação da grid
Static Function fValidGrid(oModel)
	Local lRet     := .T.
	// Local nDeletados := 0
	// Local nLinAtual :=0
	// Local oModelGRID := oModel:GetModel('MdGridSZZ')
	// Local oModelMain := oModel:GetModel('MdFieldSZZ')
	// Local nValorMain := oModelMain:GetValue("SZZ_VALOR")
	// Local nValorGrid := 0
	// Local cPictVlr   := PesqPict('SZZ', 'SZZ_VALOR')

	// //Percorrendo todos os itens da grid
	// For nLinAtual := 1 To oModelGRID:Length()
	//     //Posiciona na linha
	//     oModelGRID:GoLine(nLinAtual)

	//     //Se a linha for excluida, incrementa a variável de deletados, senão irá incrementar o valor digitado em um campo na grid
	//     If oModelGRID:IsDeleted()
	//         nDeletados++
	//     Else
	//         nValorGrid += NoRound(oModelGRID:GetValue("SZZ_TCOMB"), 4)
	//     EndIf
	// Next nLinAtual

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


User Function GerTransf(nOper) // 1 - incluir // 2 estornar - transferencia
	// Local nLargBtn      := 50
	local nx :=0
	local aForn := {}
	Private aBrowse:= {}
	//Private aDadosBRW:= {{space(20),0}}
	Private aColunas:= {"Volume","Quantidade","NÂº do Lote"}
	//Objetos e componentes
	Private oDlgLote
	Private oFwLayer
	Private oPanTitulo
	Private oPanGrid
	//CabeÃ§alho
	Private oSayTitulo, cSayTitulo := 'Selecione'
	//Tamanho da janela
	Private aSize := MsAdvSize(.F.)
	Private nJanLarg := aSize[5]
	Private nJanAltu := aSize[6]
	//Fontes
	Private cFontUti    := "Tahoma"
	Private oFontMod    := TFont():New(cFontUti, , -38)
	Private oFontSub    := TFont():New(cFontUti, , -12)
	Private oFontSubN   := TFont():New(cFontUti, , -12, , .T.)
	Private oFontBtn    := TFont():New(cFontUti, , -12)
	Private oFontSay    := TFont():New(cFontUti, , -10)

	dbSelectArea("SZZ")
	dbSetOrder(1)
	SZZ->(dbSeek(xFilial("SZZ")+SZZ->ZZ_NUMPROC))
	cNumProc := SZZ->ZZ_NUMPROC

	while !SZZ->(eof()) .AND. cNumProc == SZZ->ZZ_NUMPROC
		cUn := posicione('SB1',1,XFILIAL('SB1')+SZZ->ZZ_COD,'B1_UM')
		// if (nOper==1 .AND. SZZ->ZZ_STATUS == '2') .OR. (nOper==2 .AND. SZZ->ZZ_STATUS == '1')
		aadd(aBrowse,{.T.,SZZ->ZZ_COD,;
			SZZ->ZZ_DESC,;
			cUn,;
			SZZ->ZZ_QUANT,;
			SZZ->ZZ_LOCORI,;
			SZZ->ZZ_LOCDEST,;
			SZZ->ZZ_NUMLOTE,;
			SZZ->ZZ_DTVENC,;
			SZZ->ZZ_OBSERV,;
			SZZ->ZZ_STATUS,;
			SZZ->ZZ_NUMPROC,;
			ZZ_DOCSD3})
		// endif
		SZZ->(DbSkip())
	endDo

	if nOper==1 // EFETIVAR
		//Cria a janela
		if  aBrowse[1,11]=='1'
			fwAlertWarning('Todos os Produtos desse documento já tiveram suas tranferencias efetivadas .', 'Atenção !!!')
			Return
		endif

		DEFINE MSDIALOG oDlgLote TITLE "Lista de produto - por data lote"  FROM 00, 000 TO nJanAltu, nJanLarg PIXEL

		//Criando a camada
		oFwLayer := FwLayer():New()
		oFwLayer:init(oDlgLote,.F.)

		//Adicionando 3 linhas, a de tÃ­tulo, a superior e a do calendÃ¡rio
		oFWLayer:addLine("TIT", 20, .F.)
		oFWLayer:addLine("COR", 80, .F.)

		//Adicionando as colunas das linhas
		oFWLayer:addCollumn("HEADERTEXT",   050, .T., "TIT")
		oFWLayer:addCollumn("BLANKBTN",     050, .T., "TIT")

		oFWLayer:addCollumn("COLGRID",      100, .T., "COR")

		//Criando os paineis
		oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
		oPanBut    := oFWLayer:GetColPanel("BLANKBTN",    "TIT")
		oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")

		//TÃ­tulos e SubTÃ­tulos
		oSayTitulo := TSay():New(004, 05, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
		oBtnSair := TButton():New(006, 100, "Confirmar",  oPanBut, {|| oDlgLote:End()}, 30, 012, , oFontBtn, , .T., , , , , , )


		//dialog com browse para defir as notas fiscais
		oBrowseLotes := fwBrowse():New()
		oBrowseLotes:lHeaderClick:=.F.
		oBrowseLotes:setDataArray()

		oBrowseLotes:disableConfig()
		oBrowseLotes:disableReport() //DTC_NFEID,DTC_CODPRO,DTC_PESO,DTC_PESOM3,DTC_METRO3,DTC_VALOR,DTC_QTDVOL
		oBrowseLotes:setOwner( oPanGrid )
		oBrowseLotes:AddMarkColumns(            {||IIF(aBrowse[oBrowseLotes:nAt,01],'LBOK','LBNO')}, {|| .T.} /*,aBrowse[oBrowseLotes:nAt,01]:= !aBrowse[oBrowseLotes:nAt,01]*/ /*[ bLDblClick]*/, /*[ bHeaderClick]*/ )
		oBrowseLotes:addColumn({"Produto" , 	{||aBrowse[oBrowseLotes:nAt,02]}, "C", "@!"	, 1, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xVolume"    })
		oBrowseLotes:addColumn({"Desc"    ,	    {||aBrowse[oBrowseLotes:nAt,03]}, "C", "@!"	, 2, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xQtdLote"    })
		oBrowseLotes:addColumn({"UN"      ,	    {||aBrowse[oBrowseLotes:nAt,04]}, "C", "@!"	, 2, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xQtdLote"    })
		oBrowseLotes:addColumn({"Quant"   , 	{||aBrowse[oBrowseLotes:nAt,05]}, "N", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
		oBrowseLotes:addColumn({"Origem"  , 	{||aBrowse[oBrowseLotes:nAt,06]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
		oBrowseLotes:addColumn({"Destino" , 	{||aBrowse[oBrowseLotes:nAt,07]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
		oBrowseLotes:addColumn({"Lote"    , 	{||aBrowse[oBrowseLotes:nAt,08]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
		oBrowseLotes:addColumn({"Validade", 	{||aBrowse[oBrowseLotes:nAt,09]}, "D", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xDate"    })
		oBrowseLotes:addColumn({"Obs"     , 	{||aBrowse[oBrowseLotes:nAt,10]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xDate"    })
		oBrowseLotes:addColumn({"Status"  , 	{||aBrowse[oBrowseLotes:nAt,11]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xDate"    })
		oBrowseLotes:addColumn({"Doc SZZ"  , 	{||aBrowse[oBrowseLotes:nAt,12]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xDate"    })
		oBrowseLotes:addColumn({"Doc SD3"  , 	{||aBrowse[oBrowseLotes:nAt,13]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xDate"    })

		oBrowseLotes:setArray( aBrowse )
		oBrowseLotes:SetLocate() // Habilita a LocalizaÃ§Ã£o de registros

		oBrowseLotes:activate( )

		Activate MsDialog oDlgLote Centered
		aProd := {}
		for NX := 1 to LEN(aBrowse)
			if aBrowse[nx,1]
				aadd(aProd,aBrowse[nx])
			endif
		next nx
		u_ExecMT261(aProd,1)
	endif

	if nOper==2
		aProd := {}

		if aBrowse[1,11]=='2'
			fwAlertWarning('Não foi EFETIVADA a transferência desse documento, não há estorno a realizar.','Erro: Não há Estorno!')
			return
		endif

		if fwAlertYesNo('Estornar todos os itens do documento '+cNumProc +' ?','Estornar')
			for NX := 1 to LEN(aBrowse)
				if aBrowse[nx,1]
					aadd(aProd,aBrowse[nx])
				endif
			next nx
			u_ExecMT261(aProd,2)
		endif
	endif

Return(aForn)

/*/{Protheus.doc} zMod1Leg
Função para mostrar a legenda
@author Edson Sales
Email: edson.pedro@totvs.com.br
@since 18/07/2025
/*/

User Function zMod1Leg()
	Local aLegenda := {}

	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",       "Aguardando Transf."  })
	AADD(aLegenda,{"BR_VERMELHO",    "Tranferido"})

	BrwLegenda('Items Prcessados', "Status", aLegenda)
Return
