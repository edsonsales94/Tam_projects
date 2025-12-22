//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Apuração de beneficios"

/*/{Protheus.doc} PAAPURA
Função para cadastros de Abastecimentos dos veículos
@author Edson Sales
@since 13/04/2025
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_PAAPURA()
    @obs Os campos chave usado entre cabeçalho e grid são: ZZ2_IDSEQ (Código Sequencial), ZZ2_NOTFIS (Nota Fiscal), ZZ2_VALOR (Valor)
/*/

User Function PAAPURA()
	Local aArea   := GetArea()
	Local oBrowse
	// local lamb := RpcSetEnv('01','01')
	// se não for usuario FV não deixa entrar na rotina... em  desenvolvimento
	// if !(__cUserID ==  "000303")
	// 	Alert('Rotina em desenvolvimento...',   'Atencao')
	// 	return
	// endif
	// U_fProcBen()

	DbSelectArea('ZZ2')
	ZZ2->(dbSetOrder(3))

	cCondicao := ''//"ZZ2_CODIGO == '0001'"

	//Cria um browse para a ZZ2
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZ2")
	oBrowse:SetDescription(cTitulo)
	oBrowse:SetFilterDefault(cCondicao)
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRot := {}

	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.PAAPURA' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.PAAPURA' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.PAAPURA' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.PAAPURA' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Processar'  ACTION 'U_fProcBen'      OPERATION 6 ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Imp. Relatório'  ACTION 'U_PAAPUR01'      OPERATION 6 ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Verba Desc. Alim.'  ACTION 'U_GerVerb'      OPERATION 6 ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Gerar ticket'  ACTION 'RptStatus({|| U_LayTicket()}, "Aguarde...", "Executando rotina...")'     OPERATION 6 ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'ZZ2', {|cCampo| AllTRim(cCampo) $ "ZZ2_FILIAL;ZZ2_CC;ZZ2_DATADE;ZZ2_DATATE;ZZ2_DTLANC"})
	Local oStruGrid := fModStruct()

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	oModel := MPFormModel():New('PAAPURAM',{|oModel| fValidGrid(oModel)} /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldZZ2', NIL, oStruCab)
	oModel:AddGrid('MdGridZZ2', 'MdFieldZZ2', oStruGrid, , )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridZZ2', {;
		{"ZZ2_FILIAL",  "ZZ2_FILIAL"},;
		{"ZZ2_CC",  "ZZ2_CC"},;
		{"ZZ2_DATADE",  "ZZ2_DATADE"},;
		{"ZZ2_DATATE",  "ZZ2_DATATE"};
		}, ZZ2->(IndexKey(1)))
	// {"ZZ2_NOME", "ZZ2_NOME"},;

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridZZ2"):SetMaxLine(9999)
	oModel:SetDescription("Apuracao dos beneficios")
	oModel:SetPrimaryKey({"ZZ2_FILIAL","ZZ2_DATADE","ZZ2_DATATE","ZZ2_CC"})

Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('PAAPURA')
	Local oStruCab  := FWFormStruct(2, "ZZ2", {|cCampo| AllTRim(cCampo) $ "ZZ2_FILIAL;ZZ2_CC;ZZ2_DATADE;ZZ2_DATATE;ZZ2_DTLANC"})
	Local oStruGRID := fViewStruct()

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	//Cria o View
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//Cria uma área de Field vinculando a estrutura do cabeçalho com MDFieldZZ2, e uma Grid vinculando com MdGridZZ2
	oView:AddField('VIEW_ZZ2', oStruCab, 'MdFieldZZ2')
	oView:AddGrid ('GRID_ZZ2', oStruGRID, 'MdGridZZ2' )

	//O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
	oView:CreateHorizontalBox("MAIN", 25)
	oView:CreateHorizontalBox("GRID", 75)

	//Vincula o MAIN com a VIEW_ZZ2 e a GRID com a GRID_ZZ2
	oView:SetOwnerView('VIEW_ZZ2', 'MAIN')
	oView:SetOwnerView('GRID_ZZ2', 'GRID')
	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZZ2_ITEM
	oView:AddIncrementField('GRID_ZZ2', 'ZZ2_CODIGO')

	oView:SetViewProperty("GRID_ZZ2", "GRIDSEEK",    {.T.})
	oView:SetViewProperty("GRID_ZZ2", "GRIDFILTER",  {.T.})
Return oView

//Função chamada para montar o modelo de dados da Grid
Static Function fModStruct()
	Local oStruct
	oStruct := FWFormStruct(1, 'ZZ2')
Return oStruct

//Função chamada para montar a visualização de dados da Grid
//"ZZ2_FILIAL;ZZ2_DATADE,ZZ2_DATATE;ZZ2_CC;ZZ2_MAT;ZZ2_NOME;ZZ2_CARGO;ZZ2_OBS;"
Static Function fViewStruct()
	Local cCampoCom := "ZZ2_DTLANC"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "ZZ2", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct

//Função que faz a validação da grid
Static Function fValidGrid(oModel)
	Local lRet     := .T.
	Local oModelGRID := oModel:GetModel('MdGridZZ2')
	// Local oModelMain := oModel:GetModel('MdFieldZZ2')
	// Local cCodAusencia := oModelMain:GetValue("ZZ2_CODAUS")
	// Local cPictVlr   := PesqPict('ZZ2', 'ZZ2_CODAUS')
	Local nLinAtual := 0

	// //Percorrendo todos os itens da grid
	For nLinAtual := 1 To oModelGRID:Length()
		//Posiciona na linha
		oModelGRID:GoLine(nLinAtual)
		dbselectarea('SR8')
		SR8->(dbSetOrder(1))
		POSICIONE("SR8",1,XFILIAL("SR8")+ZZ2->ZZ2_CODAUS,"RCM_DESCRI")

		//Se a linha for excluida for a do codigo 0001, vou substituir o codigo do proximo item
		If oModelGRID:IsDeleted()
			if oModelGRID:GetValue("ZZ2_CODIGO") == '0001'
				lDel0001 := .T.
			EndIf
		EndIf
		if lDel0001 .AND. oModelGRID:GetValue("ZZ2_CODIGO") != '0001'
			oModel:SetValue("ZZ2_CODIGO", '0001')
			lDel0001 := .F.
		endif

	Next nLinAtual

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



// SELECT RA_DEMISSA,RA_CC,R8_DATAINI,R8_DATAFIM,R8_DURACAO AUSENCIA,(30 - R8_DURACAO) [DIAS TRABALHADO] ,* FROM SRA010 RA
// LEFT JOIN SR8010 R8 ON RA_MAT=R8_MAT
// WHERE RA_CC ='1206' AND RA_MAT='015183' 
// AND R8_DATAINI >= '20241209' AND R8_DATAFIM <='20241223'
// AND R8_DATAFIM !=''

// SELECT TOP 1000 * FROM SRV010

// 	SELECT TOP 1000 * FROM SR8010
// 	WHERE  R8_MAT='015183' 


/*
Função para processar o beneficio de acordo com o mês informado.
Verificar os dias trabalhados e as ausencias, para caulcular os valores
dos beneficios e descontos. 
*/
User function fProcBen()

	Local aPergs := {}

	cFilOrDe  :=  '  '
	cFilOrAte :=  '  '
	cCCusto   := '    '
	dDataDe   := FirstDate(dDatabase)
	dDataAt   := LastDate(dDatabase)
	cMatDe    := '      '
	cMatAte   := 'ZZZZ  '
	cDiasUt	  := '  '

	aAdd(aPergs ,{1,"Periodo de:",dDataDe,"","","","",55,.F.})
	aAdd(aPergs ,{1,"Periodo ate:" ,dDataAt,"","","","",55,.F.})
	aAdd(aPergs ,{1,"Filial de:" ,cFilOrDe,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"Filial ate:" ,cFilOrAte,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"C. Custo de:" ,cCCusto,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"C. Custo ate:" ,cCCusto,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"Matricula de:" ,cMatDe,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"Matricula ate:" ,cMatAte,"","","CTT","",55,.F.})
	aAdd(aPergs ,{2,"Gerar Apred\Estag:",1,{'SIM','NAO'},55,"",.F.})
	aAdd(aPergs ,{9,"Informe a quantidade de dias úteis, a serem pagos.",150,7,.T.})
	aAdd(aPergs ,{1,"Qtd dias Uteis:" ,cDiasUt,"","","","",55,.F.})

	If ParamBox(aPergs, "Informe os parametros")
		oProcess := MsNewProcess():New({|| fIniProc(oProcess)}, "Processando...", "Aguarde...", .T.)
		oProcess:Activate()
	else
		return
	endif

return

static function fIniProc(oObj)
	Local aArea := GETAREA()
	Local nDiasMes := 0
	Local nDiasAuse := 0
	Local nDiasTick := 0
	Local nDiasApagar := val(Mv_PAR11)
	Local nDiaUtiAus := 0
	Local nDiaUtiTrab := 0
	Local cQry := ''
	// Local cAlias := 'TRB'
	Local cCodigo := '0000'
	Local lInclui := .T.
	Local nAtual := 0
	Local nTotal := 0
	Local nVlrCestaAprendiz := 0
	Local lDireito := .T.
	Local lAdvertencia := .F.
	Local cObserv := ''

	cQry += " SELECT RA_FILIAL,RA_ADMISSA,RA_XAPREST,RA_XMARITI,RA_MENSIND,RA_MAT,RA_CC,RA_NOME,RA_NATURAL,RJ_DESC,isnull(R8_DATAINI ,'') INICIO_AUS,isnull(R8_DATAFIM ,'') FIM_AUS,R8_DURACAO,TIT_CODTIQ,R8_TIPOAFA "
	cQry += " FROM " +RetSQLName('SRA') +" RA "
	cQry += " LEFT JOIN "+ RetSQLName('SR8')+" R8 ON R8.D_E_L_E_T_='' AND RA_FILIAL=R8_FILIAL AND RA_MAT=R8_MAT AND (( R8_DATAINI BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(Mv_PAR02)+"'   "
	cQry += " OR R8_DATAFIM BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(MV_PAR02)+"') OR ( R8_DATAINI < FORMAT(getdate(), 'yyyymmdd', 'en-US') AND R8_DATAFIM = '' )) "
	cQry += " LEFT JOIN SRJ010 RJ ON  RJ.D_E_L_E_T_='' AND RA_CODFUNC=RJ_FUNCAO"
	cQry += " LEFT JOIN TIT010 TI ON  TI.D_E_L_E_T_='' AND TIT_MAT=RA_MAT AND TIT_DATA  BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(MV_PAR02)+"' "
	cQry += " WHERE RA.D_E_L_E_T_='' AND RA_DEMISSA=''    " //--AND R8_MAT='000867'
	cQry += " AND RA_FILIAL BETWEEN '"+MV_PAR03+ "' AND '"+MV_PAR04+"'   "
	cQry += " AND RA_CC BETWEEN '"+MV_PAR05+ "' AND '"+MV_PAR06+"'   "
	cQry += " AND RA_MAT BETWEEN '"+MV_PAR07+ "' AND '"+MV_PAR08+"'   "
	cQry += " GROUP BY RA_FILIAL,RA_MAT,R8_DATAINI,RA_MENSIND,R8_DATAFIM,RA_CC,R8_DURACAO,RJ_DESC,RA_NATURAL,RA_NOME,RA_ADMISSA,RA_XAPREST,TIT_CODTIQ,R8_TIPOAFA,RA_XMARITI  "

	Count TO nTotal
	oObj:SetRegua1(nTotal)

	// valida o periodo se já existe processo entre as datas
	// caso exista processo
	lvalidper := validPer()

	// se retorna .F. e porque foi encontrados processo na data informada para o mesmo C.C
	if ! lvalidper
		FWAlertWarning('O periodo informado já foi processado, verifique as datas do parametros', 'Atenção')
		Return
	endif

	If Select('TMP1') > 0
		TMP1->(DbCloseArea())
	EndIf

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TMP1", .T., .T. )

	TMP1->(dbgotop())
	While !TMP1->(EOF())
		cObserv := ''
		lDireito := .T.
		nAtual++
		oObj:IncRegua1("Analizando Matricula " + ALLTRIM(TMP1->RA_MAT) + ' - '+cValToChar(nAtual)+'/'+cValToChar(nTotal)+ "...")

		nDiasMes := DateDiffDay(Mv_PAR01,MV_PAR02)+1

		if nDiasMes > 31 .or. nDiasMes < 28
			if nDiasMes > 31
				FWAlertWarning('Periodo mensal maior que um periodo apropriado de trabalho, verifique os parametros...','Atencao')
			else
				FWAlertWarning('Periodo mensal menor que um periodo minimo apropriado de trabalho, verifique os parametros...','Atencao')
			endif
			Return
		endif

		nDiasAuse := 0

		if !Empty(TMP1->INICIO_AUS) .or. !Empty(TMP1->FIM_AUS)
			// verificar se a ausencia iniciou dentro do periodo
			if SToD(TMP1->(INICIO_AUS)) > Mv_PAR01
				dDtIniAus := SToD(TMP1->(INICIO_AUS))
			Else
				dDtIniAus := Mv_PAR01
			EndIf

			// verificar se a ausencia finalizou dentro do periodo
			if  !Empty(TMP1->(FIM_AUS))
				if SToD(TMP1->(FIM_AUS)) < MV_PAR02
					dDtFimAus := SToD(TMP1->(FIM_AUS))
				Else
					dDtFimAus := MV_PAR02
				EndIf
			else
				dDtFimAus := MV_PAR02
			endif

			// afastamento por tempo indeterminado
			if TMP1->(R8_DURACAO) == 999 .and. TMP1->RA_FILIAL != '04'
				nDiasAuse := 99
			else
				// calcula os dias de ausencia, dentro do periodo.
				if TMP1->RA_FILIAL != '04'
					nDiasAuse := DateDiffDay(dDtIniAus,dDtFimAus)
				else
					nDiasAuse := DateDiffDay(STOD(TMP1->INICIO_AUS),dDtFimAus)
				endIf

				if !Empty(TMP1->R8_TIPOAFA) // SE FOR FERIAS GRAVAR NA OBSERVAÇÃO QTD DE DIAS DAS FERIAS
					cObserv += 'Quantidade de dias corridos das Ferias ou afast. '+ cvaltochar(nDiasAuse)
				endif
			endif

			/* 
			Filial 04 perde o direito acima 120 dias
			nas demais filiais perde o direito em acima de 15 dias.
			*/

			if TMP1->RA_FILIAL == '04'
				// se o func. afastado 15 ou mais dias e não for ferias ou doença ou mais de 120 é não é por doença
				if (nDiasAuse > 15 .and. !(TMP1->R8_TIPOAFA $ '001|004') ) .or. (nDiasAuse > 120 .and. TMP1->R8_TIPOAFA== '004')
					TMP1->(dbSkip())
					loop
				endif
			else
				// se o func. afastado 15 ou mais dias e não for ferias
				if nDiasAuse > 15 .and. TMP1->R8_TIPOAFA != '001'
					TMP1->(dbSkip())
					loop
				endif
			endif

			// quantidade de dias uteis de ausencia
			dDtAtu := dDtIniAus
			While dDtAtu <= dDtFimAus

				//Se a data atual for uma data Válida
				If dDtAtu == DataValida(dDtAtu)
					nDiaUtiAus++
				EndIf
				dDtAtu := DaySum(dDtAtu, 1)
			EndDo

		endif

		// SE O FUNCIONARIO MARITIMO OU FANTASMA
		if TMP1->RA_XMARITI $ '1|3'
			TMP1->(dbSkip())
			loop
		endif

		// quantidade de dias uteis de trabalhados no periodo processado.
		dDtAtu := MV_PAR01
		While dDtAtu <= MV_PAR02
			//Se a data atual for uma data Válida
			If dDtAtu == DataValida(dDtAtu)
				nDiaUtiTrab++
			EndIf
			dDtAtu := DaySum(dDtAtu, 1)
		EndDo

		// quantidades de dias trabalhados.
		// nDiasTick := nDiasMes - nDiasAuse
		nDiasTick := iif(Empty(nDiasApagar),nDiaUtiTrab - nDiaUtiAus,nDiasApagar - nDiaUtiAus)

		// verificar se possui ADVERTENCIA
		if !Empty(TMP1->TIT_CODTIQ)
			lAdvertencia := .T.
			cObserv += 'Advertencia ou supensao'
		else
			lAdvertencia := .F.
		endif

		DbSelectArea('ZZ1')
		ZZ1->(dbSetOrder(1))

		if MsSeek(TMP1->RA_FILIAL+ALLTRIM(TMP1->RA_CC)+ALLTRIM(TMP1->RA_MENSIND)) //ALLTRIM(TMP1->RA_MENSIND)

			// while !ZZ1->(EOF()) .AND. TMP1->RA_FILIAL+ALLTRIM(TMP1->RA_CC)==ZZ1->ZZ1_FILIAL+ZZ1->ZZ1_CC
			// if TMP1->RA_MENSIND == iif(ZZ1->ZZ1_SINDIC=='N','2','1')

			oObj:SetRegua2(nTotal)
			oObj:IncRegua2("Gravando registro" + cValToChar(nAtual) + " de " +cValToChar(nTotal) + "...")

			iF TMP1->RA_XAPREST == '1'
				if MV_PAR09 == 1 // considera aprendiz e estagiario para o ticket
					nVlrCestaAprendiz := ZZ1->ZZ1_VLRCES/2
				else
					nVlrCestaAprendiz:=0
					TMP1->(dbSkip())
					loop
				endif
			else
				nVlrCestaAprendiz:=0
			endIf

			// SEMPRE VERIFICAR SE A MATRICULA ATUAL JÁ FOI INCLUSA PARA SOMAR AS QUANTIDADES DE DIAS.
			// ISSO PODE OCORRE  QUANDO O A MATRICULA TIVER MAIS DE UMAS INCLUSAO DE AUSENCIA.
			DbSelectArea('ZZ2')
			ZZ2->(dbSetOrder(1))
			***********
			// caso nesse mesmo periodo tenha mais de uma ocorrecia de ausencia, para aglutinar a ja existente
			If MsSeek(TMP1->RA_FILIAL+ALLTRIM(TMP1->RA_CC)+TMP1->RA_MAT+DtoS(MV_PAR01)+DtoS(MV_PAR02))
				// se a ausencia não for por tempo indeterminado.
				if TMP1->(R8_DURACAO) != 999
					nDiasAuse :=    ZZ2->ZZ2_AUSENC + nDiasAuse
				endif
				_cCod := ZZ2->ZZ2_CODIGO
				lInclui := .F.
			else
				lInclui := .T.
			EndIf

			// só incrementa se for inclusão
			if lInclui
				cCodigo := SOMA1(cCodigo)
				// (cAlias)->(dbCloseArea())
			endif

			// Se tiver advertencia e não recebe café e nem alimentacao não grava o colaborador
			// if lAdvertencia .and. ZZ1->ZZ1_VLRCAF == 0 .AND. ZZ1->ZZ1_VLRALI==0
			// 	lDireito := .F.
			// else
			// 	lDireito := .T.
			// endIf

			// SE TIVER MENOS DE 30 DIAS DA ADIMISSÃO.
			if (!DateDiffDay(dDatabase, stod(TMP1->RA_ADMISSA)) >= 30)
				cObserv += '- 30 dias trabalhados apartir da admissao'
				// menos de 30 dias tarbalhados e o contrato não comtempla café e nem alimentação não grava.
				*
				// if ZZ1->ZZ1_VLRCAF == 0 .AND. ZZ1->ZZ1_VLRALI==0
				// 	lDireito := .F.
				// else
				// 	lDireito := .T.
				// endif
			EndIf

			nVlrAliment := ZZ1->ZZ1_VLRALI
			nVlrCafe := ZZ1->ZZ1_VLRCAF

			if lDireito
				Begin Transaction
					***********
					RECLOCK('ZZ2', lInclui )
					ZZ2->ZZ2_FILIAL := TMP1->RA_FILIAL
					ZZ2->ZZ2_CODIGO := IIF(lInclui,cCodigo,_cCod)
					ZZ2->ZZ2_MAT := TMP1->RA_MAT
					ZZ2->ZZ2_CC  := TMP1->RA_CC
					ZZ2->ZZ2_NOME := TMP1->RA_NOME
					ZZ2->ZZ2_CARGO := TMP1->RJ_DESC
					// ZZ2->ZZ2_AUSENC := iif(nDiasAuse>99,99,nDiasAuse)
					ZZ2->ZZ2_AUSENC := iif(nDiasAuse>99,99,nDiaUtiAus)
					ZZ2->ZZ2_SINDIC := ZZ1->ZZ1_SINDIC

					if TMP1->RA_XMARITI $ '2|4|5' .or. alltrim(TMP1->RA_CC) $ '1205|1223'  // verificar se o colaborador tem mais de 1 mes trabalhado aparti da admissao
						// se Alojado, Equip. volante ou escala zera tudo
						if TMP1->RA_XMARITI $ '2|5'
							nVlrAliment := 0
							nVlrCafe := 0
							cObserv += 'Alojado ou escala.'
						endif

						// tratativa para zerar valor alimentação para os cc e coloborador que não são equipe volante
						iF alltrim(TMP1->RA_CC) $ '1205|1223'
							if TMP1->RA_XMARITI == '4'
								nVlrAliment := ZZ1->ZZ1_VLRALI
								nVlrCafe := ZZ1->ZZ1_VLRCAF
								cObserv += 'Equipe volante'
							else
								nVlrAliment := 0
								nVlrCafe 	:= 0

							endif
						endif
					endif

					// afastamento por tempo indeterminado ou advertencia ou maritimo perde a cesta.
					if (TMP1->(R8_DURACAO) == 999 .or. lAdvertencia) .or.;
							(!DateDiffDay(dDatabase, stod(TMP1->RA_ADMISSA)) >= 30)
						cDircesta := '2'
						nVlrCesta := 0

						// se nao verifica pelo contrato se tem direito.
					elseif ZZ1->ZZ1_VLRCES>0
						iF ZZ1->ZZ1_CONCES == '1'
							cDircesta := '1'
						else
							cDircesta := '2'
							nVlrCesta := 0
						EndIF
						// se tiver direito verifica se o valor é o do contrato ou se for aprendiz
						// o valor vem da variavel nVlrCestaAprendiz
						if Empty(nVlrCestaAprendiz)
							nVlrCesta := ZZ1->ZZ1_VLRCES
						else
							nVlrCesta := nVlrCestaAprendiz
						endif
					else
						cDircesta := '2'
						nVlrCesta := 0
					endif
					// se tiver advertencia ou suspensão perde a cesta.
					ZZ2->ZZ2_CESTA := cDircesta
					ZZ2->ZZ2_VLRCES :=nVlrCesta
					ZZ2->ZZ2_OBS := cObserv

					// desconto cesta
					// if ZZ1->ZZ1_PERCCE > 0
					// 	ZZ2->ZZ2_DESCCE := ZZ1->ZZ1_PERCCE*ZZ2_VLRCES
					// else
					// 	ZZ2->ZZ2_DESCCE := 0
					// endif

					ZZ2->ZZ2_ALIMEN :=  IIF(nVlrAliment>0,'1','2')
					ZZ2->ZZ2_DIASAL := IIF(nVlrAliment>0,nDiasTick,0)
					ZZ2->ZZ2_VLRALI := nVlrAliment
					ZZ2->ZZ2_TOTALI := nVlrAliment * nDiasTick
					// desconto alimentação
					// if ZZ1->ZZ1_PERCAL > 0
					// 	ZZ2->ZZ2_DESCAL := ZZ1->ZZ1_PERCAL*ZZ2->ZZ2_TOTALI
					// else
					// 	ZZ2->ZZ2_DESCAL :=0
					// endif

					ZZ2->ZZ2_CAFE := IIF(nVlrCafe>0,'1','2')
					ZZ2->ZZ2_DIASCA := IIF(nVlrCafe>0,nDiasTick,0)
					ZZ2->ZZ2_VLRCAF := nVlrCafe
					ZZ2->ZZ2_TOTCAF := nVlrCafe * nDiasTick
					// desconto cafe
					// if ZZ1->ZZ1_PERCCA > 0
					// 	ZZ2_DESCCA := ZZ1->ZZ1_PERCCA * ZZ2->ZZ2_TOTCAF
					// else
					// 	ZZ2->ZZ2_DESCCA :=0
					// endif

					nDesconto := ZZ1->ZZ1_DESCPE
					iF ZZ1->ZZ1_TPDESC == '1' // SE FOR PERCENTUAL
						if ZZ1->ZZ1_DESSOB == '1' // SOB CESTA
							ZZ2->ZZ2_DESCON :=  ZZ2->ZZ2_VLRCES * nDesconto
						ElseiF ZZ1->ZZ1_DESSOB == '2' // SOB ALIMENTAÇÃO
							ZZ2->ZZ2_DESCON :=  ZZ2->ZZ2_TOTALI * nDesconto
						ElseiF ZZ1->ZZ1_DESSOB == '3' // SOB CAFE
							ZZ2->ZZ2_DESCON :=  ZZ2->ZZ2_TOTCAF * nDesconto
						ElseIf ZZ1->ZZ1_DESSOB == '4' // SOB VALOR TOTAL
							ZZ2->ZZ2_DESCON :=  ZZ2->ZZ2_TOTAL * nDesconto
						endIf
					elseiF ZZ1->ZZ1_TPDESC == '2' // SE FOR VALOR FIXO
						ZZ2->ZZ2_DESCON := nDesconto
					Else
						ZZ2->ZZ2_DESCON := 0
					endif

					ZZ2->ZZ2_DATADE	:= MV_PAR01
					ZZ2->ZZ2_DATATE := MV_PAR02
					ZZ2->ZZ2_DTLANC := dDatabase
					ZZ2->ZZ2_ADMISS := stod(TMP1->RA_ADMISSA)
					// ZZ2->ZZ2_TOTDES := ZZ2->ZZ2_DESCCE+ZZ2->ZZ2_DESCAL+ZZ2_DESCCA
					ZZ2->ZZ2_TOTAL := ZZ2->ZZ2_TOTALI+ZZ2->ZZ2_VLRCES+ZZ2->ZZ2_TOTCAF
					ZZ2->ZZ2_CODAUS := TMP1->R8_TIPOAFA
					ZZ2->ZZ2_ADVERT := TMP1->TIT_CODTIQ
					ZZ2->(MSUNLOCK())
					cObserv := ''
				End Transaction
			endif

			nDiaUtiTrab := 0
			nDiaUtiAus 	:= 0
			// endif
			// ZZ1->(DbSkip())
			// EndDo
		endif
		ZZ2->(dbCloseArea())
		TMP1->(dbSkip())
	EndDo
	TMP1->(dbCloseArea())
	RestArea(aArea)

return

static Function validPer()
	Local cAlias := GetnextAlias()
	Local nCount := 0
	Local lRet := .T.

	BeginsQL ALIAS cAlias
		select * from %Table:ZZ2% ZZ2
		WHERE ZZ2.%notdel% 
		AND ZZ2_FILIAL BETWEEN %exp:Mv_PAR03% AND %exp:Mv_PAR04%  
		AND ZZ2_CC BETWEEN %exp:Mv_PAR05% AND %exp:Mv_PAR06% AND 
		(ZZ2_DATADE BETWEEN %exp:Mv_PAR01% AND %exp:Mv_PAR02% OR 
		ZZ2_DATATE BETWEEN %exp:Mv_PAR01% AND %exp:Mv_PAR02%)
	ENDSQL

	Count to nCount
	if nCount >0
		lRet := .F.
	endIf

Return lRet

/*/{Protheus.doc} /*/
User Function LayTicket()
Local cFile := ""
Local nH
Local cLSUP5 :='LSUP5'
Local cCodUsr    := RetCodUsr()
Local cNomUsr    :=substr(UsrRetName(cCodUsr)+ space(8),1,8)
Local CSEQ := '000000'
Local  cAlias := 'TRB2' 
local nSubTotal :=0
local nTotal:=0
local nAtual:=0
Local nDiasUteis := 0
Local dDataLiber
Local cTipArq :=''
Local cTitulo :=''
Local cPasta := ''

//TFileDialog - Selecionando uma pasta
    cTipArq := ""
    cTitulo := "Seleção de Pasta para Salvar arquivo"
    // cPasta := tFileDialog(;
    //     cTipArq,;                  // Filtragem de tipos de arquivos que serão selecionados
    //     cTitulo,;                  // Título da Janela para seleção dos arquivos
    //     ,;                         // Compatibilidade
    //     'C:\',;                  // Diretório inicial da busca de arquivos
    //     .F.,;                  // Se for .T., será uma Save Dialog, senão será Open Dialog
    //     GETF_RETDIRECTORY;         // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
    // )
	cPasta := cGetFile( '' , 'Selecione uma pasta', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

	if Empty(cPasta)
		Return
	endif

	cFile := cPasta +"\Layout_ticket"+DTOS(ZZ2->ZZ2_DTLANC)+".txt"

nH := fCreate(cFile)
If nH == -1
   MsgStop("Falha ao criar arquivo - erro "+str(ferror()))
   Return
Endif

cDataLanc   := dtos(ZZ2->ZZ2_DTLANC)
cDatade := dtos(ZZ2->ZZ2_DATADE)
cDatate := dtos(ZZ2->ZZ2_DATATE)
cCC := ZZ2->ZZ2_CC

BeginsQL ALIAS cAlias
	SELECT Count(*) cont  FROM %Table:ZZ2% ZZ2
	WHERE ZZ2.%notdel% and ZZ2_DTLANC=%EXP:cDataLanc%
	and ZZ2_CC = %exp:cCC% and ZZ2_DATADE=%exp:cDatade%
	and ZZ2_DATATE=%exp:cDatate%
	ENDSQL

	nTotal := (cAlias)->(cont)
	SetRegua(nTotal)

	DbSelectArea('ZZ2')
	ZZ2->(dbSetOrder(3))
	***********
	nDiasUteis	:= DateWorkDay(ZZ2->ZZ2_DTLANC, ZZ2->ZZ2_DTLANC+6)
	dDataLiber	:= DaySum(ZZ2->ZZ2_DTLANC, nDiasUteis)
	CSEQ := SOMA1(CSEQ)

	cEmpresa := AllTRim(posicione("ZZ1",1,ZZ2->ZZ2_FILIAL+ZZ2->ZZ2_CC,'ZZ1_LOCENT'))
	cInterlocutor := posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_GESTOR')
	cLogra 		  := posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_LOGRA')
	cEnd 		  := alltrim(posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_ENDERE'))
	cNum 		  := alltrim(posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_NUMERO'))
	cBairro       := alltrim(posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_BAIRRO'))
	cCidade       := alltrim(posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_CIDADE'))
	cEstado       := alltrim(posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_UF'))
	cCep       	  := alltrim(posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_CEP'))
	cComple       := alltrim(posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC,'ZZ1_COMPLE'))

	fWrite(nH,cLSUP5+cNomUsr+space(11)+dtos(dDatabase)+time()+"LAYOUT-"+dtoc(ZZ2->ZZ2_DTLANC)+SPACE(107)+ chr(13)+chr(10) )

	fWrite(nH,'TA020A3999070036';
		+SUBSTR(FwFilialName('01','01',1),1,24);
		+space(6)+dtos(ZZ2->ZZ2_DTLANC)+;
		dtos(dDataLiber)+;
		space(17)+;
		strzero(month(MonthSub(dDatabase, 1)),2)+;
		space(19)+'04'+'33'+space(48) +;
		'SUP'+space(3)+;
		CSEQ+chr(13)+chr(10) )

// // caso nesse mesmo periodo tenha mais de uma ocorrecia de ausencia, para aglutinar a ja existente
// 	SM0->(dbseek('01'+ZZ2->ZZ2_FILIAL))
// 	CLOGRA := SUBSTR(SM0->M0_ENDENT,AT(' ',SM0->M0_ENDENT)+1,LEN(SM0->M0_ENDENT))
// 	CLOGRA := SUBSTR(CLOGRA,1,AT(',',CLOGRA)-1)
// 	CSEQ := SOMA1(CSEQ)

// // Escreve o texto mais a quebra de linha CRLF
// 	fWrite(nH,'TA022'+;
// 		SUBSTR(cEmpresa+SPACE(26),1,26)+; // NOME EMPRESA // empresa
// 	iif('RUA' $ SM0->M0_ENDENT,'RUA ',iif('TV' $ SM0->M0_ENDENT,'TV  ','AV  '))+; // TIPO LOGRADOURO
// 	CLOGRA +SPACE(30-LEN(CLOGRA))+;  // LOGRADOURO
// 	SUBSTR(alltrim(SUBSTR(SM0->M0_ENDENT,AT(',',SM0->M0_ENDENT)+1,LEN(SM0->M0_ENDENT)))+space(6),1,6)+; // NUMERO
// 	SUBSTR(SM0->M0_COMPENT,1,10)+	;  // COMPLEMENTO
// 	SUBSTR(SM0->M0_CIDENT,1,25)+; //MUNICIPIO
// 	SUBSTR(SM0->M0_BAIRENT,1,15)+; // BAIRRO
// 	SUBSTR(SM0->M0_CEPENT,1,5)+; // CEP
// 	SUBSTR(SM0->M0_ESTENT,1,2)+; //ESTADO
// 	SUBSTR(cInterlocutor,1,20)+; // INTERLOCUTOR
// 	SUBSTR(SM0->M0_CEPENT,5,3)+; // COMPLEMENTO DO CEP
// 	SPACE(7)+;
// 		CSEQ+;
// 		chr(13)+chr(10))

// caso nesse mesmo periodo tenha mais de uma ocorrecia de ausencia, para aglutinar a ja existente
// Escreve o texto mais a quebra de linha CRLF
CSEQ := SOMA1(CSEQ)
	fWrite(nH,'TA022'+;
	SUBSTR(cEmpresa+SPACE(26),1,26)+; // NOME EMPRESA // empresa
	substr(alltrim(cLogra)+space(4),1,4)+; // TIPO LOGRADOURO
	cEnd +SPACE(30-LEN(cEnd))+;  // ENDERECO
	SUBSTR(alltrim(cNum)+space(6),1,6)+; // NUMERO
	substr(alltrim(cComple)+space(10),1,10)+	;  // COMPLEMENTO
	SUBSTR(alltrim(cCidade)+space(25),1,25)+; //MUNICIPIO
	SUBSTR(alltrim(cBairro)+space(15),1,15)+; // BAIRRO
	SUBSTR(cCep,1,5)+; // CEP
	SUBSTR(cEstado,1,2)+; //ESTADO
	SUBSTR(AllTRim(cInterlocutor)+space(20),1,20)+; // INTERLOCUTOR
	SUBSTR(cCep,5,3)+; // COMPLEMENTO DO CEP
	SPACE(7)+;
		CSEQ+;
		chr(13)+chr(10))

	// Escreve o texto mais a quebra de linha CRLF
	// registro do funcionario
	cSeek := XFILIAL('ZZ2')+ZZ2->ZZ2_CC+dtos(ZZ2->ZZ2_DTLANC)+dtos(ZZ2->ZZ2_DATADE)+dtos(ZZ2->ZZ2_DATATE)
	if MsSeek(cSeek) 
		while !ZZ2->(EOF()) .and. cSeek == XFILIAL('ZZ2')+ZZ2->ZZ2_CC+dtos(ZZ2->ZZ2_DTLANC)+dtos(ZZ2->ZZ2_DATADE)+dtos(ZZ2->ZZ2_DATATE)

			lMostraTicket := .T.

			// total dos beneficios por colaborador
			if '.' $ cvaltochar(ZZ2->ZZ2_TOTAL)
				cTotal := right('000000000'+cvaltochar(ZZ2->ZZ2_TOTAL),9)
			else
				cTotal := right('000000000'+cvaltochar(ZZ2->ZZ2_TOTAL)+'00',9)
			endIf
			
			// se não tiver direito não sai no ticket
			if ZZ2->ZZ2_CESTA =='2' .AND. ZZ2->ZZ2_CAFE=='2' .AND. ZZ2->ZZ2_ALIMEN=='2'
				lMostraTicket := .F.
			endif
			//Incrementa a mensagem na régua
			nAtual++
			IncRegua()
			if lMostraTicket
				dDataNasc := posicione('SRA',1,ZZ2->ZZ2_FILIAL+ZZ2->ZZ2_MAT,'RA_NASC')
				cDataNasc := day2str(dDataNasc)+month2str(dDataNasc)+year2str(dDataNasc)
				CSEQ := SOMA1(CSEQ)

				fWrite(nH,'TA023'+;
					SUBSTR(ZZ2->ZZ2_CC+SPACE(26),1,26)+; // DEPARTAMENTO
				strzero(val(ZZ2->ZZ2_MAT),12)+; // CODIGO FUNCIONARIO
				cDataNasc+;
					SPACE(18)+;
					SUBSTR(cEmpresa+SPACE(26),1,26)+; // NOME EMPRESA
				'00101'+;
					cTotal+;
					'A'+; //PRODUTO
				'E'+; //ELETRONICO
				SUBSTR(AllTRim(ZZ2->ZZ2_NOME)+space(20),1,30)+space(6)+; // NOME FUNCIONARIO
				substr(posicione('SRA',1,XFILIAL('SRA')+ZZ2->ZZ2_MAT,'RA_CIC')+space(11),1,11)+; // CPF FUNCIONARIO
				CSEQ+;
					chr(13)+chr(10))

				nSubTotal += ZZ2->ZZ2_TOTAL
			endIf

			ZZ2->(DbSkip())
		EndDo
	endIf

	// sub total geral dos beneficios por c. custo
	if '.' $ cvaltochar(nSubTotal)
		cSubTotal := right('00000000000000'+cvaltochar(nSubTotal),14)
	else
		cSubTotal := right('000000000000'+cvaltochar(nSubTotal)+'00',14)
	endIf

	CSEQ := SOMA1(CSEQ)
	fWrite(nH,'TA029'+;
		strzero(nTotal,8)+;
		cSubTotal+;
		space(131)+;
		CSEQ+;
		chr(13)+chr(10))

	fWrite(nH,'LSUP9'+;
		'00000001'+;
		'00000001'+;
		strzero(nTotal,8)+;
		space(277)+;
		chr(13)+chr(10))


	(cAlias)->(dbCloseArea())
	ZZ2->(dbCloseArea())

	fClose(nH)

	Msginfo("Arquivo criado :" + cFile)

Return

/*
gatilhos para atualizar os valores dos campos em caso haja algum ajuste.
*/
User Function fGatZZ2()

Local nTot
Local oGatilho  := FWModelActive()
Local nValcesta := oGatilho:GetValue('MdGridZZ2', 'ZZ2_VLRCES')
Local cCafe 	:= oGatilho:GetValue('MdGridZZ2', 'ZZ2_CAFE') 
Local nDiasCafe := oGatilho:GetValue('MdGridZZ2', 'ZZ2_DIASCA') 
Local nValcafe 	:= oGatilho:GetValue('MdGridZZ2', 'ZZ2_VLRCAF') 
Local nTotCafe 	:= oGatilho:GetValue('MdGridZZ2', 'ZZ2_TOTCAF') 
Local nValAlim 	:= oGatilho:GetValue('MdGridZZ2', 'ZZ2_VLRALI') 
Local nTotAlim 	:= oGatilho:GetValue('MdGridZZ2', 'ZZ2_TOTALI') 
Local nDiasAlim := oGatilho:GetValue('MdGridZZ2', 'ZZ2_DIASAL') 
Local cCesta 	:= oGatilho:GetValue('MdGridZZ2', 'ZZ2_CESTA') 
Local cAlimenta := oGatilho:GetValue('MdGridZZ2', 'ZZ2_ALIMEN') 
Local nZZ2_desc := oGatilho:GetValue('MdGridZZ2', 'ZZ2_DESCON') 

DbSelectArea('ZZ1')
ZZ1->(dbSetOrder(1))
ZZ1->(MsSeek(xfilial('ZZ2')+ZZ2->ZZ2_CC+ZZ2->ZZ2_SINDIC))

// ALTERAÇÃO NOS DIREITO DOS BENEFICIOS
if cCesta == '2'
	nValcesta := 0
Else
	nValcesta := ZZ1->ZZ1_VLRCES
endif

if cCafe == '2'
	nValcafe := 0
	nDiasCafe := 0
Else
	nValcafe := ZZ1->ZZ1_VLRCAF 
	nTotCafe := ZZ1->ZZ1_VLRCAF * nDiasCafe
endif

if cAlimenta == '2'
	nValAlim := 0
	nDiasAlim := 0
Else
	nValAlim := ZZ1->ZZ1_VLRALI 
	nTotAlim := ZZ1->ZZ1_VLRALI * nDiasAlim
endif

// ALTERAÇÃO NOS VALORES DOS BENEFICIOS
if Empty(nValcesta)
	cCesta := '2'
Else
	cCesta := '1'
endif

if Empty(nValcafe) 
	cCafe := '2'
Else
	cCafe := '1'
endif

if Empty(nValAlim)
	cAlimenta := '2'
Else
	cAlimenta := '1'
endif

// ATUALIZAÇÃO DOS DESCONTOS

nDesconto := ZZ1->ZZ1_DESCPE
iF ZZ1->ZZ1_TPDESC == '1' // SE FOR PERCENTUAL
	if ZZ1->ZZ1_DESSOB == '1' // SOB CESTA
		nZZ2_desc :=  nValcesta * nDesconto
	ElseiF ZZ1->ZZ1_DESSOB == '2' // SOB ALIMENTAÇÃO
		nZZ2_desc :=  nTotAlim * nDesconto
	ElseiF ZZ1->ZZ1_DESSOB == '3' // SOB CAFE
		nZZ2_desc :=  nTotCafe * nDesconto
	ElseIf ZZ1->ZZ1_DESSOB == '4' // SOB VALOR TOTAL
		nZZ2_desc :=  M->ZZ2_TOTAL * nDesconto
	endIf
elseiF ZZ1->ZZ1_TPDESC == '2' // SE FOR VALOR FIXO
	nZZ2_desc := nDesconto
Else
	nZZ2_desc := 0
endif

oGatilho:SetValue('MdGridZZ2', 'ZZ2_VLRCES',nValcesta	)
oGatilho:SetValue('MdGridZZ2', 'ZZ2_CAFE'	,cCafe 		) 
oGatilho:SetValue('MdGridZZ2', 'ZZ2_DIASCA',nDiasCafe 	) 
oGatilho:SetValue('MdGridZZ2', 'ZZ2_VLRCAF',nValcafe 	) 
oGatilho:SetValue('MdGridZZ2', 'ZZ2_TOTCAF',nTotCafe 	) 
oGatilho:SetValue('MdGridZZ2', 'ZZ2_VLRALI',nValAlim 	) 
oGatilho:SetValue('MdGridZZ2', 'ZZ2_TOTALI',nTotAlim 	) 
oGatilho:SetValue('MdGridZZ2', 'ZZ2_DIASAL',nDiasAlim  )  
oGatilho:SetValue('MdGridZZ2', 'ZZ2_CESTA'	,cCesta 	) 
oGatilho:SetValue('MdGridZZ2', 'ZZ2_ALIMEN',cAlimenta  ) 
oGatilho:SetValue('MdGridZZ2', 'ZZ2_DESCON',nZZ2_desc  ) 

// VALOR TOTAL
nTot := nValcesta+nTotCafe+nTotAlim

Return nTot


/*/{Protheus.doc} nomeFunction
/*/
User Function GerVerb()

	default crlf := CHR(13)+CHR(10)
	Local aArea   := GetArea()
	Local cMsg    := "As Verbas serao gerada para filial -> "+ZZ2->ZZ2_FILIAL +', C. Custo -> '+ZZ2->ZZ2_CC +crlf
	Local nOpc    := 0
	local cPeriodo := space(6)
	Local dDtRef
	Local aPergs := {}

	dDataDe   := FirstDate(dDatabase)

	aAdd(aPergs ,{1,"Periodo folha:",dDataDe,"","","","",55,.F.})

	If ParamBox(aPergs, "Informe o periodo")
		cPeriodo := substr(dtos(MV_PAR01),1,6)
		dDtRef := LastDate(MV_PAR01)
	else
		return
	EndIf


	cMsg += 'para o periodo da folha-> '+ cPeriodo + ', periodo do beneficio-> '+ LEFT(DTOS(ZZ2->ZZ2_DATADE),6) + CRLF + CRLF
	cMsg += 'Deseja gerar as verbas  ? '
	//Mensagem média com botões
	nOpc := Aviso("Gerar verbas de descontos", cMsg, {"Sim", "Nao"}, 2, "Gerar verbas")

	If nOpc == 1

		DBSelectArea('RFQ')
		RFQ->(DBSetOrder(1))

		DBSelectArea('RGB')
		RGB->(DBSetOrder(1))

		If RFQ->(MsSeek(XFILIAL('RFQ')+'00001'+cPeriodo+'01'+DTOS(mv_par01)+DTOS(lastdate(mv_par01))))
			if RFQ->RFQ_STATUS <> '1'
				FWAlertWarning('É necessário que o periódo esteja em ABERTO para gravar as verbas...','Periodo fechado')
				return
			endif
		else
			FWAlertWarning('O periódo não foi encontrado, verifique se o periódo já está cadastrado...','Periodo Nao encontrado')
			return
		EndIf

		cTRB := GetnextAlias()

		ZZ2->(DBSetOrder(3))
		cSeek := ZZ2->ZZ2_FILIAL+ZZ2->ZZ2_CC+DTOS(ZZ2->ZZ2_DTLANC)+DTOS(ZZ2->ZZ2_DATADE)+DTOS(ZZ2->ZZ2_DATATE)

		If ZZ2->(MsSeek(cSeek))
			while !ZZ2->(EOF()) .AND. cSeek == ZZ2->ZZ2_FILIAL+ZZ2->ZZ2_CC+DTOS(ZZ2->ZZ2_DTLANC)+DTOS(ZZ2->ZZ2_DATADE)+DTOS(ZZ2->ZZ2_DATATE)

				if SELECT(cTRB) > 0
					(cTRB)->(DbCloseArea())
				endif

				BeginSQL Alias cTRB
					select count(*) nReg
						from RGB010
					where D_E_L_E_T_='' 
					and RGB_FILIAL=%exp:ZZ2->ZZ2_FILIAL%
					and RGB_PERIOD =%exp:cPeriodo% 
					and RGB_MAT=%EXP:ZZ2->ZZ2_MAT%
					and RGB_PD='428'
				EndSql

				if (cTRB)->nReg > 0
					(cTRB)->(dbSkip())
					loop
				endif

				RecLock('RGB', .T.)

				RGB->RGB_FILIAL := '01'
				RGB->RGB_PROCES := '00001'
				RGB->RGB_PERIOD := cPeriodo
				RGB->RGB_SEMANA := '01'
				RGB->RGB_ROTEIR := 'FOL'
				RGB->RGB_MAT    := ZZ2->ZZ2_MAT
				RGB->RGB_PD	    := '428'
				RGB->RGB_TIPO1  := 'V'
				RGB->RGB_VALOR  := ZZ2->ZZ2_DESCON
				RGB->RGB_DTREF  := dDtRef
				RGB->RGB_CC 	:= ZZ2->ZZ2_CC

				ZZ2->(MsUnLock())
				ZZ2->(DbSkip())
			EndDo
			RGB->(DbCloseArea())
			FWAlertSuccess('Verbas geradas...','Sucesso !!!')
		Else
			FWAlertWarning('Falha ao tentar gravar verbas...','Falha !!!')
		EndIf
	EndIf

	RestArea(aArea)
Return
