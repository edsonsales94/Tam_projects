//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Apuração de beneficios"

/*/{Protheus.doc} PAAPURA
Função para cadastros de Abastecimentos dos veículos
@author Atilio
@since 13/09/2020
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_PAAPURA()
    @obs Os campos chave usado entre cabeçalho e grid são: ZZ2_IDSEQ (Código Sequencial), ZZ2_NOTFIS (Nota Fiscal), ZZ2_VALOR (Valor)
/*/

User Function PAAPURA()
	Local aArea   := GetArea()
	Local oBrowse

	// se não for usuario FV não deixa entrar na rotina... em  desenvolvimento
	// if !(__cUserID ==  "000303")
	// 	Alert('Rotina em desenvolvimento...',   'Atencao')
	// 	return
	// endif

	// U_fProcBen()
	cCondicao := "ZZ2_CODIGO == '0001'"

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
	ADD OPTION aRot TITLE 'Imprimir'  ACTION 'U_PAAPUR01'      OPERATION 6 ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Gerar ticket'  ACTION 'RptStatus({|| U_LayTicket()}, "Aguarde...", "Executando rotina...")'     OPERATION 6 ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab     := FWFormStruct(1, 'ZZ2', {|cCampo| AllTRim(cCampo) $ "ZZ2_FILIAL;ZZ2_CC;ZZ2_DATADE;ZZ2_DATATE;ZZ2_DTLANC"})
	Local oStruGrid := fModStruct()

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	oModel := MPFormModel():New('PAAPURAM', /*bPreValidacao*/, /*{|oModel| fValidGrid(oModel)}*/, /*bCommit*/, /*bCancel*/ )

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
	oModel:SetPrimaryKey({"ZZ2_FILIAL","ZZ2_CC","ZZ2_DATADE","ZZ2_DATATE"})

Return oModel

Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oView        := NIL
	Local oModel    := FWLoadModel('PAAPURA')
	Local oStruCab  := FWFormStruct(2, "ZZ2", {|cCampo| AllTRim(cCampo) $ "ZZ2_FILIAL;ZZ2_CC;ZZ2_DATADE;ZZ2_DATATE;ZZ2_DTLAC"})
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
	Local cCampoCom := "ZZ2_DTLAC"
	Local oStruct

	//Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
	oStruct := FWFormStruct(2, "ZZ2", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct

//Função que faz a validação da grid
Static Function fValidGrid(oModel)
	Local lRet     := .T.
	Local oModelGRID := oModel:GetModel('MdGridZZ2')
	Local oModelMain := oModel:GetModel('MdFieldZZ2')
	Local cCodAusencia := oModelMain:GetValue("ZZ2_CODAUS")
	Local cPictVlr   := PesqPict('ZZ2', 'ZZ2_CODAUS')
	Local nLinAtual := 0

	// //Percorrendo todos os itens da grid
	For nLinAtual := 1 To oModelGRID:Length()
		//Posiciona na linha
		oModelGRID:GoLine(nLinAtual)
		dbselectarea('SR8')
		dbSetOrder(1)
		POSICIONE("SR8",1,XFILIAL("SR8")+ZZ2->ZZ2_CODAUS,"RCM_DESCRI")


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

	aAdd(aPergs ,{1,"Periodo de:",dDataDe,"","","","",55,.F.})
	aAdd(aPergs ,{1,"Periodo ate:" ,dDataAt,"","","","",55,.F.})
	aAdd(aPergs ,{1,"Filial de:" ,cFilOrDe,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"Filial ate:" ,cFilOrAte,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"C. Custo de:" ,cCCusto,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"C. Custo ate:" ,cCCusto,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"Matricula de:" ,cMatDe,"","","CTT","",55,.F.})
	aAdd(aPergs ,{1,"Matricula ate:" ,cMatAte,"","","CTT","",55,.F.})
	aAdd(aPergs ,{2,"Gerar Apred\Estag:",1,{'SIM','NAO'},55,"",.F.})


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
	Local nDiasTrab := 0
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

	cQry += " SELECT RA_FILIAL,RA_ADMISSA,RA_XAPREST,RA_MENSIND,RA_MAT,RA_CC,RA_NOME,RA_NATURAL,RJ_DESC,isnull(R8_DATAINI ,'') INICIO_AUS,isnull(R8_DATAFIM ,'') FIM_AUS,R8_DURACAO,TIT_CODTIQ,R8_TIPOAFA "
	cQry += " FROM " +RetSQLName('SRA') +" RA "
	cQry += " LEFT JOIN "+ RetSQLName('SR8')+" R8 ON R8.D_E_L_E_T_='' AND RA_FILIAL=R8_FILIAL AND RA_MAT=R8_MAT AND ( R8_DATAINI BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(Mv_PAR02)+"'   "
	cQry += " OR R8_DATAFIM BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(MV_PAR02)+"')   "
	cQry += " LEFT JOIN SRJ010 RJ ON  RJ.D_E_L_E_T_='' AND RA_CODFUNC=RJ_FUNCAO"
	cQry += " LEFT JOIN TIT010 TI ON  TI.D_E_L_E_T_='' AND TIT_MAT=RA_MAT AND TIT_DATA  BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(MV_PAR02)+"' "
	cQry += " WHERE RA.D_E_L_E_T_='' AND RA_DEMISSA=''    " //--AND R8_MAT='000867'
	cQry += " AND RA_FILIAL BETWEEN '"+MV_PAR03+ "' AND '"+MV_PAR04+"'   "
	cQry += " AND RA_CC BETWEEN '"+MV_PAR05+ "' AND '"+MV_PAR06+"'   "
	cQry += " AND RA_MAT BETWEEN '"+MV_PAR07+ "' AND '"+MV_PAR08+"'   "
	cQry += " GROUP BY RA_FILIAL,RA_MAT,R8_DATAINI,RA_MENSIND,R8_DATAFIM,RA_CC,R8_DURACAO,RJ_DESC,RA_NATURAL,RA_NOME,RA_ADMISSA,RA_XAPREST,TIT_CODTIQ,R8_TIPOAFA  "

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
			if TMP1->(R8_DURACAO) == 999
				nDiasAuse := 99
			else
				// calcula os dias de ausencia, dentro do periodo.
				nDiasAuse := DateDiffDay(dDtIniAus,dDtFimAus)
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

		// quantidade de dias uteis de trabalhados
		dDtAtu := MV_PAR01
		While dDtAtu <= MV_PAR02
			//Se a data atual for uma data Válida
			If dDtAtu == DataValida(dDtAtu)
				nDiaUtiTrab++
			EndIf
			dDtAtu := DaySum(dDtAtu, 1)
		EndDo

		// SEMPRE VERIFICAR SE A MATRICULA ATUAL JÁ FOI INCLUSA PARA SOMAR AS QUANTIDADES DE DIAS.
		// ISSO PODE OCORRE  QUANDO O A MATRICULA TIVER MAIS DE UMAS INCLUSAO DE AUSENCIA.
		DbSelectArea('ZZ2')
		dbSetOrder(1)
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
			// buscar ultimo codigo para gravar sequencial
			// BeginsQL ALIAS cAlias
			// 	SELECT MAX(ZZ2_CODIGO) CODIGO FROM %Table:ZZ2% ZZ2
			// 	WHERE ZZ2.%notdel% and ZZ2_MAT=%EXP:TMP1->RA_MAT%
			// ENDSQL

			// Count TO nCont
			// (cAlias)->(DbGoTop())
			// // ultimo codigo gravado
			// if nCont >0 .AND. !EMPTY((cAlias)->CODIGO)
			// 	cCodigo := (cAlias)->CODIGO
			// else
			// 	cCodigo :='0000'
			// EndIf

			cCodigo := SOMA1(cCodigo)
			// (cAlias)->(dbCloseArea())
		endif

		// quantidades de dias trabalhados.
		// nDiasTrab := nDiasMes - nDiasAuse
		nDiasTrab := nDiaUtiTrab - nDiaUtiAus
		nDiaUtiTrab := 0
		nDiaUtiAus 	:= 0
		// verificar se possui ADVERTENCIA
		if !Empty(TMP1->TIT_CODTIQ)
			lAdvertencia := .T.
			cObserv := 'Advertencia ou supensao'
		else
			lAdvertencia := .F.
		endif

		DbSelectArea('ZZ1')
		dbSetOrder(1)

		if MsSeek(TMP1->RA_FILIAL+ALLTRIM(TMP1->RA_CC)) //ALLTRIM(TMP1->RA_MENSIND)

			while !ZZ1->(EOF()) .AND. TMP1->RA_FILIAL+ALLTRIM(TMP1->RA_CC)==ZZ1->ZZ1_FILIAL+ZZ1->ZZ1_CC
				if TMP1->RA_MENSIND == iif(ZZ1->ZZ1_SINDIC=='N','2','1')

					oObj:SetRegua2(nTotal)
					oObj:IncRegua2("Gravando registro" + cValToChar(nAtual) + " de " +cValToChar(nTotal) + "...")

					iF TMP1->RA_XAPREST == '1'
						if MV_PAR09 == 1 // considera aprendiz e estagiario para o ticket
							nVlrCestaAprendiz := ZZ1->ZZ1_VLRCES/2
							lDireito := .T.
						else
							lDireito := .F.
						endif
					else
						nVlrCestaAprendiz:=0
					endIf

					// Se tiver advertencia e não recebe café e nem alimentacao não grava o colaborador
					if lAdvertencia .and. ZZ1->ZZ1_VLRCAF == 0 .AND. ZZ1->ZZ1_VLRALI==0
						lDireito := .F.
					else
						lDireito := .T.
					endIf

					// SE TIVER MENOS DE 30 DIAS DA ADIMISSÃO.
					if (!DateDiffDay(dDatabase, stod(TMP1->RA_ADMISSA)) >= 30)
						cObserv := '- 30 dias trabalhados apartir da admissao'
						// menos de 30 dias tarbalhados e o contrato não comtempla café e nem alimentação não grava.
						if ZZ1->ZZ1_VLRCAF == 0 .AND. ZZ1->ZZ1_VLRALI==0
							lDireito := .F.
						else
							lDireito := .T.
						endif
					EndIf

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
							ZZ2->ZZ2_OBS := cObserv
							ZZ2->ZZ2_AUSENC := nDiasAuse
							ZZ2->ZZ2_SINDIC := ZZ1->ZZ1_SINDIC

							// afastamento por tempo indeterminado ou advertencia perde a cesta.
							if (TMP1->(R8_DURACAO) == 999 .or. lAdvertencia) .or.;
									(!DateDiffDay(dDatabase, stod(TMP1->RA_ADMISSA)) >= 30)  // verificar se o colaborador tem mais de 1 mes trabalhado aparti da admissao
								cDircesta := '2'
								nVlrCesta := 0
								// se nao verifica pelo contrato se tem direito.
							elseif ZZ1->ZZ1_VLRCES>0
								cDircesta := '1'
								// se tiver direito verifica se o valor é o do contrato ou se for aprendiz
								// o valor vem da variavel nVlrCestaAprendiz
								if Empty(nVlrCestaAprendiz)
									nVlrCesta := ZZ1->ZZ1_VLRCES
								else
									nVlrCesta := nVlrCestaAprendiz
								endif
							else
								cDircesta := '2'
							endif
							// se tiver advertencia ou suspensão perde a cesta.
							ZZ2->ZZ2_CESTA := cDircesta
							ZZ2->ZZ2_VLRCES :=nVlrCesta

							// desconto cesta
							if ZZ1->ZZ1_PERCCE > 0
								ZZ2->ZZ2_DESCCE := ZZ1->ZZ1_PERCCE*ZZ2_VLRCES
							else
								ZZ2->ZZ2_DESCCE := 0
							endif
							// else
							// 	ZZ2->ZZ2_CESTA := '2'
							// 	ZZ2->ZZ2_VLRCES := 0
							// 	ZZ2->ZZ2_DESCCE := 0
							// endif

							ZZ2->ZZ2_ALIMEN :=  IIF(ZZ1->ZZ1_VLRALI>0,'1','2')
							ZZ2->ZZ2_DIASAL := IIF(ZZ1->ZZ1_VLRALI>0,nDiasTrab,0)
							ZZ2->ZZ2_VLRALI := ZZ1->ZZ1_VLRALI
							ZZ2->ZZ2_TOTALI := ZZ1->ZZ1_VLRALI * nDiasTrab
							// desconto alimentação
							if ZZ1->ZZ1_PERCAL > 0
								ZZ2->ZZ2_DESCAL := ZZ1->ZZ1_PERCAL*ZZ2->ZZ2_TOTALI
							else
								ZZ2->ZZ2_DESCAL :=0
							endif
							ZZ2->ZZ2_CAFE := IIF(ZZ1->ZZ1_VLRCAF>0,'1','2')
							ZZ2->ZZ2_DIASCA := IIF(ZZ1->ZZ1_VLRALI>0,nDiasTrab,0)
							ZZ2->ZZ2_VLRCAF := ZZ1->ZZ1_VLRCAF
							ZZ2->ZZ2_TOTCAF := ZZ1->ZZ1_VLRCAF * nDiasTrab
							// desconto cafe
							if ZZ1->ZZ1_PERCCA > 0
								ZZ2_DESCCA := ZZ1->ZZ1_PERCCA * ZZ2->ZZ2_TOTCAF
							else
								ZZ2->ZZ2_DESCCA :=0
							endif
							ZZ2->ZZ2_DATADE	:= MV_PAR01
							ZZ2->ZZ2_DATATE := MV_PAR02
							ZZ2->ZZ2_DTLANC := dDatabase
							ZZ2->ZZ2_TOTDES := ZZ2->ZZ2_DESCCE+ZZ2->ZZ2_DESCAL+ZZ2_DESCCA
							ZZ2->ZZ2_TOTAL := ZZ2->ZZ2_TOTALI+ZZ2->ZZ2_VLRCES+ZZ2->ZZ2_TOTCAF
							ZZ2->ZZ2_CODAUS := TMP1->R8_TIPOAFA
							ZZ2->ZZ2_ADVERT := TMP1->TIT_CODTIQ
							ZZ2->(MSUNLOCK())
							cObserv := ''
						End Transaction
					endif
				endif
				ZZ1->(DbSkip())
			EndDo
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
    cPasta := tFileDialog(;
        cTipArq,;                  // Filtragem de tipos de arquivos que serão selecionados
        cTitulo,;                  // Título da Janela para seleção dos arquivos
        ,;                         // Compatibilidade
        'C:\',;                  // Diretório inicial da busca de arquivos
        .F.,;                  // Se for .T., será uma Save Dialog, senão será Open Dialog
        GETF_RETDIRECTORY;         // Se não passar parâmetro, irá pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT será possível pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY será possível selecionar o diretório
    )

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
	dbSetOrder(3)
	***********
	nDiasUteis	:= DateWorkDay(ZZ2->ZZ2_DTLANC, ZZ2->ZZ2_DTLANC+6)
	dDataLiber	:= DaySum(ZZ2->ZZ2_DTLANC, nDiasUteis)
	CSEQ := SOMA1(CSEQ)

	cEmpresa := IIF(ZZ2_FILIAL=='01','1 PARENTE ANDRADE SEDE',;
		IIF(ZZ2_FILIAL=='02','2 PARENTE ANDRADE MA',;
		IIF(ZZ2_FILIAL=='03','3 PARENTE ANDRADE PA',;
		IIF(ZZ2_FILIAL=='04','4 PARENTE ANDRADE PE',;
		IIF(ZZ2_FILIAL=='05','5 PARENTE ANDRADE ES',;
		IIF(ZZ2_FILIAL=='06','6 PARENTE ANDRADE BH','';
		))))))

	cInterlocutor := posicione("ZZ1",1,xfilial('ZZ2')+ZZ2->ZZ2_FILIAL+ZZ2->ZZ2_CC,'ZZ1_GESTOR')

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

// caso nesse mesmo periodo tenha mais de uma ocorrecia de ausencia, para aglutinar a ja existente
	SM0->(dbseek('01'+ZZ2->ZZ2_FILIAL))
	CLOGRA := SUBSTR(SM0->M0_ENDENT,AT(' ',SM0->M0_ENDENT)+1,LEN(SM0->M0_ENDENT))
	CLOGRA := SUBSTR(CLOGRA,1,AT(',',CLOGRA)-1)
	CSEQ := SOMA1(CSEQ)

// Escreve o texto mais a quebra de linha CRLF
	fWrite(nH,'TA022'+;
		SUBSTR(cEmpresa+SPACE(26),1,26)+; // NOME EMPRESA // empresa
	iif('RUA' $ SM0->M0_ENDENT,'RUA ','AV  ')+; // TIPO LOGRADOURO
	CLOGRA +SPACE(30-LEN(CLOGRA))+;  // LOGRADOURO
	SUBSTR(alltrim(SUBSTR(SM0->M0_ENDENT,AT(',',SM0->M0_ENDENT)+1,LEN(SM0->M0_ENDENT)))+space(6),1,6)+; // NUMERO
	SUBSTR(SM0->M0_COMPENT,1,10)+	;  // COMPLEMENTO
	SUBSTR(SM0->M0_CIDENT,1,25)+; //MUNICIPIO
	SUBSTR(SM0->M0_BAIRENT,1,15)+; // BAIRRO
	SUBSTR(SM0->M0_CEPENT,1,5)+; // CEP
	SUBSTR(SM0->M0_ESTENT,1,2)+; //ESTADO
	SUBSTR(cInterlocutor,1,20)+; // INTERLOCUTOR
	SUBSTR(SM0->M0_CEPENT,5,3)+; // COMPLEMENTO DO CEP
	SPACE(7)+;
		CSEQ+;
		chr(13)+chr(10))

// Escreve o texto mais a quebra de linha CRLF
// registro do funcionario
	if MsSeek(XFILIAL('ZZ2')+ZZ2->ZZ2_CC+dtos(ZZ2->ZZ2_DTLANC)+dtos(ZZ2->ZZ2_DATADE)+dtos(ZZ2->ZZ2_DATATE))
		while !ZZ2->(EOF())
			//Incrementa a mensagem na régua
			nAtual++
			IncRegua()

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
				strzero(ZZ2->ZZ2_TOTAL,9)+;
				'A'+; //PRODUTO
			'E'+; //ELETRONICO
			SUBSTR(AllTRim(ZZ2->ZZ2_NOME)+space(20),1,30)+space(6)+; // NOME FUNCIONARIO
			substr(posicione('SRA',1,XFILIAL('SRA')+ZZ2->ZZ2_MAT,'RA_CIC')+space(11),1,11)+; // CPF FUNCIONARIO
			CSEQ+;
				chr(13)+chr(10))

			nSubTotal += ZZ2->ZZ2_TOTAL

			ZZ2->(DbSkip())
		EndDo
	endIf
	CSEQ := SOMA1(CSEQ)
	fWrite(nH,'TA029'+;
		strzero(nTotal,8)+;
		strzero(nSubTotal,14)+;
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
