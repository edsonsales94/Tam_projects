#Include "Protheus.ch"
#Include "FWMVCDef.ch"

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Programa  ¦ PMFATC01   ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 18/06/2026 ¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Consulta de Clientes                                            ¦¦¦
¦¦+-----------+-----------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PMFATC01()
	Local oBrowse
	
	dbSelectArea("SZ3")
	dbSelectArea("SZ2")
	
	SZ2->(dbSetOrder(1))
	If !SZ2->(dbSeek(XFILIAL("SZ2")+__cUserID))
		FWAlertError("Usuário sem permissão para Consulta do SERASA !")
		Return
	Endif
	
	oBrowse := FWMBrowse():New()
	
	oBrowse:SetAlias("SA1")
	oBrowse:SetDescription("Consulta SERASA de Clientes")
	
	// Pesquisa padrão
	oBrowse:SetSeek(.T.)
	
	// Visualização MVC
	oBrowse:SetMenuDef("PMFATC01")
	
	oBrowse:Activate()

Return

Static Function MenuDef()
	Local aRotina := {}
	
	// Pesquisar
	ADD OPTION aRotina TITLE "Pesquisar" ;
		ACTION "SEARCH" ;
		OPERATION 1 ;
		ACCESS 0
	
	// Visualizar
	ADD OPTION aRotina TITLE "Visualizar" ;
		ACTION "VIEWDEF.PMFATC01" ;
		OPERATION 2 ;
		ACCESS 0
	
	// Nova Consulta
	ADD OPTION aRotina TITLE "Consulta Avulsa" ;
		ACTION "u_FATC01Cons(1)" ;
		OPERATION 100 ;
		ACCESS 0
	
	// Consulta Básica
	ADD OPTION aRotina TITLE "Consulta Básica" ;
		ACTION "u_FATC01Cons(2)" ;
		OPERATION 101 ;
		ACCESS 0
	
	// Consulta Completa
	ADD OPTION aRotina TITLE "Consulta Completa" ;
		ACTION "u_FATC01Cons(3)" ;
		OPERATION 102 ;
		ACCESS 0
	
	// Consulta Básica
	ADD OPTION aRotina TITLE "Atualiza Básica" ;
		ACTION "u_FATC01Cons(4)" ;
		OPERATION 103 ;
		ACCESS 0
	
	// Consulta Completa
	ADD OPTION aRotina TITLE "Atualiza Completa" ;
		ACTION "u_FATC01Cons(5)" ;
		OPERATION 104 ;
		ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oModel
	Local oStruct
	
	oStruct := FWFormStruct(1, "SA1")
	
	oModel := MPFormModel():New("MCLI001")
	
	oModel:AddFields("SA1MASTER", NIL, oStruct)

Return oModel

Static Function ViewDef()
	Local oView
	Local oModel
	Local oStruct
	
	oModel  := FWLoadModel("PMFATC01")
	oStruct := FWFormStruct(2, "SA1")
	
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	
	oView:AddField("VIEW_SA1", oStruct, "SA1MASTER")
	
	oView:CreateHorizontalBox("BOX01", 100)
	
	oView:SetOwnerView("VIEW_SA1", "BOX01")

Return oView

User Function FATC01Cons(nTipo)
	Local oDlg, oCbxRel, cTitulo, cJSon, cTipo, lAtual
	Local aRelatorios := {"Básico","Completo"}
	Local cRelatorio  := aRelatorios[1]
	Local cPessoa     := If( nTipo == 1 , " ", SA1->A1_PESSOA)
	Local cCliente    := If( nTipo == 1 , CriaVar("A1_NOME",.F.), SA1->A1_NOME)
	Local cCpf        := If( nTipo == 1 , CriaVar("A1_CGC" ,.F.), SA1->A1_CGC )
	Local cLegenda    := If( nTipo == 1 , "CNPJ/CPF", If( cPessoa == "J" , "CNPJ", "CPF"))
	Local cPicture    := If( nTipo == 1 , "@!", If( cPessoa == "J" , "@R 99.999.999/9999-99", "@R 999.999.999-99"))
	Local nRecno      := 0
	Local lAtualiza   := (nTipo < 2 .Or. nTipo > 3)
	Local cData       := DTOC(CtoD(''))
	Local cUsuario    := cUserName //RetCodUsr()
	Local nOpcA       := 0
	Local nOpcao      := 0
	
	If nTipo < 4 .And. !ExistBlock("PMZRSE01")
		FWAlertError("A rotina PMZRSE01 modelo de impressão da consulta não existe no sistema !")
		Return
	Endif
	
	Do Case
		Case nTipo == 1 ; cTitulo := "Consulta Avulsa"
		Case nTipo == 2 ; cTitulo := "Consulta Básica"
		Case nTipo == 3 ; cTitulo := "Consulta Completa" ; cRelatorio := aRelatorios[2]
		Case nTipo == 4 ; cTitulo := "Atualiza Básica"
		Case nTipo == 5 ; cTitulo := "Atualiza Completa" ; cRelatorio := aRelatorios[2]
	EndCase
	
	NroAcessos(1,@nRecno,lAtualiza)  // Posiciona na última consulta do usuário
	
	If nRecno > 0   // Caso já exista alguma consulta feita para o usuário
		cData := DTOC(SZ3->Z3_DATA)
	Endif
	
	If nTipo == 2 .Or. nTipo == 3
		ExisteConsulta(cCpf,cPessoa,If(nTipo==2,1,2),@cTipo,@nRecno,@lAtual)   // Verifica se já existe uma consulta para o CPF/CNPJ
		If nRecno == 0
			FWAlertWarning("Não existe registro para consulta desse " + If(cPessoa=="F","CPF: ","CNPJ: ") + Transform(cCpf,cPicture) )
			Return
		Endif
	Endif
	
	// Aproximadamente 1/3 da tela
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 500,700 PIXEL
	
	// Relatório
	@ 15,10 SAY "Qual relatório?" SIZE 80,10 OF oDlg PIXEL
	
	@ 28,10 MSCOMBOBOX oCbxRel VAR cRelatorio ITEMS aRelatorios SIZE 120,100 OF oDlg PIXEL WHEN nTipo==1
	
	// Cliente
	@ 55,10 SAY "Cliente" SIZE 60,10 OF oDlg PIXEL
	
	@ 68,10 MSGET cCliente SIZE 200,12 /*READONLY*/ OF oDlg PIXEL WHEN .F.
	
	// CPF
	@ 95,10 SAY cLegenda SIZE 60,10 OF oDlg PIXEL
	@ 108,10 MSGET cCpf Picture cPicture VALID CPFOk(cCpf,@cPessoa) SIZE 120,12 /*READONLY*/ OF oDlg PIXEL WHEN nTipo==1
	
	// Data Atual
	@ 135,10 SAY "Última Consulta" SIZE 60,10 OF oDlg PIXEL
	@ 148,10 MSGET cData SIZE 80,12 /*READONLY*/ OF oDlg PIXEL WHEN .F.
	
	// Usuário
	@ 175,10 SAY "Usuário" SIZE 60,10 OF oDlg PIXEL
	@ 188,10 MSGET cUsuario SIZE 150,12 /*READONLY*/ OF oDlg PIXEL WHEN .F.
	
	// Botão Confirmar
	@ 220,100 BUTTON "Confirmar" SIZE 60,18 OF oDlg PIXEL ACTION (nOpcao:=oCbxRel:nAt,If(nTipo==2.Or.nTipo==3.Or.lAtual.Or.NroAcessos(nOpcao,,lAtualiza).And.FWAlertYesNo("Confirma a consulta na base do SERASA ?"),(nOpcA:=1,oDlg:End()),))
	
	// Botão Sair
	@ 220,180 BUTTON "Sair" SIZE 60,18 OF oDlg PIXEL ACTION oDlg:End()
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpcA == 1
		ExisteConsulta(cCpf,cPessoa,nOpcao,@cTipo,@nRecno,@lAtual)   // Posiciona na última consulta para o CPF/CNPJ
		
		Do Case
			Case nTipo == 1   // Consulta Avulsa
				If lAtual .Or. ConnSERASA(cCpf,nOpcao,@cJSon)
					If lAtual .Or. GravaConsulta(cCpf,cTipo,cJSon)
						Imprime(nOpcao)
					Endif
				Endif
			Case nTipo == 2   // Consulta Básica
				Imprime(nOpcao)
			Case nTipo == 3   // Consulta Completa
				Imprime(nOpcao)
			Case nTipo == 4   // Atualiza Básica
				If ConnSERASA(cCpf,1,@cJSon)
					GravaConsulta(cCpf,If(cPessoa=="F","1","2"),cJSon)
				Endif
			Case nTipo == 5   // Atualiza Completa
				If ConnSERASA(cCpf,2,@cJSon)
					GravaConsulta(cCpf,If(cPessoa=="F","3","4"),cJSon)
				Endif
		EndCase
	Endif

Return

Static Function Imprime(nOpcao)
    Local oError
	Local cError := ""
	
	Local bErrorBlock := ErrorBlock({|oError| Break(oError)}) // Redireciona o erro para o RECOVER
	
	BEGIN SEQUENCE
		u_PMZRSE01(nOpcao)
	RECOVER USING oError
		// 1. Captura a descrição detalhada do erro (Stack trace)
		cError := "Erro: " + oError:Description + " na linha " + cValToChar(oError:ErrorStack)
	END SEQUENCE
	
	If !Empty(cError)
		FWAlertError(cError)
	Endif

Return

Static Function ExisteConsulta(cCpf,cPessoa,nOpcao,cTipo,nRecno,lAtual)
	
	cTipo  := If( nOpcao == 1 , If(cPessoa=="F","1","2"), If(cPessoa=="F","3","4"))    // 1=BASICO PF;2=BASICO PJ;3=COMPLETO PF;4=COMPLETO PJ
	nRecno := 0
	lAtual := .F.
	
	// Pesquisa a última consulta para o CPF/CNPJ + TIPO
	SZ3->(dbSetOrder(2))    // Z3_FILIAL+Z3_CGC+Z3_TIPO+DTOS(Z3_DATA)+Z3_HORA
	SZ3->(dbSeek(XFILIAL("SZ3")+cCpf+cTipo,.T.))
	While !SZ3->(Eof()) .And. SZ3->Z3_FILIAL+SZ3->Z3_CGC+SZ3->Z3_TIPO == XFILIAL("SZ3")+cCpf+cTipo
		nRecno := SZ3->(Recno())
		SZ3->(dbSkip())
	Enddo
	If nRecno > 0
		SZ3->(dbGoTo(nRecno))    // Posiciona no registro
		lAtual := ((Date() - SZ3->Z3_DATA) < 2)   // Verifica se houve consulta recente
	Endif

Return

Static Function CPFOk(cCpf,cPessoa)
	Local cPFJ := If( Len(AllTrim(cCpf)) < 14 , "F", "J")
	Local lRet := .F.
	
	If lRet := (CGC(cCpf) .And. A030CGC(cPFJ,cCpf))
		cPessoa := cPFJ
	Endif

Return lRet

Static Function NroAcessos(nOpc,nReg,lAtualiza)
	Local nDias := 30
	Local dDia  := Date()
	Local dIni  := dDia - nDias
	Local nQtde := 0
	Local lRet  := .T.
	
	nReg:= 0
	
	SZ3->(dbSetOrder(3))    // Z3_FILIAL+Z3_USUARIO+DTOS(Z3_DATA)+Z3_HORA
	SZ3->(dbSeek(XFILIAL("SZ3")+__cUserID+DtoS(dIni),.T.))
	While !SZ3->(Eof()) .And. XFILIAL("SZ3")+__cUserID == SZ3->Z3_FILIAL+SZ3->Z3_USUARIO
		nReg := SZ3->(Recno())
		If SZ3->Z3_DATA <= dDia
			If nDias > 0
				nQtde++
			Endif
		Endif
		SZ3->(dbSkip())
	Enddo
	
	If nReg > 0
		SZ3->(dbGoTo(nReg))   // Posiciona no registro mais recente
	Endif
	
	If nQtde > 0 .And. nQtde > If( nOpc == 1 , SZ2->Z2_DIASBAS, SZ2->Z2_DIASCOM)
		lRet := .F.
		If lAtualiza
			FWAlertError("Quantidade de acessos desse usuário nos últimos "+LTrim(cValToChar(nDias))+" dias já foi totalmente utilizada !")
		Endif
	Endif

Return lRet

Static Function ConnSERASA(cCpf,nOpcao,cJSon)
	Local cPessoa  := If( Len(AllTrim(cCpf)) < 14 , "F", "J")
	Local cURL     := u_URLPMZ() + "credit-services/" + If( cPessoa == "F" , "person-information-report/v1/creditreport", "business-information-report/v1/reports")
	Local cPostPar := ""
	Local aHeadOut := {}
	Local cCertCRT := ""
	Local cCertKEY := ""
	Local nTimeOut := 120
	Local cHeadRet := ""
	Local cSenha1  := ""
	Local cPostRet := ""
	Local cErro    := ""
	
	Local cConsulta := ""
	Local cToken    := ""
	Local lContinua := .F.
	
	FWMsgRun(Nil, {|oSay| cToken := u_Autenticacao(nil,nOpcao) }, "Integração SERASA", "Autenticando integração...")
	
	cJSon := ""
	
	If Empty(cToken)
		FWAlertError("Ocorreu um erro na autenticação no acesso ao SERASA !")
		Return .F.
	Endif

	If cPessoa == "F"
		cConsulta += "?optionalFeatures="+ If(nOpcao==1,"ANOTACOES_COMPLETAS","SCORE_POSITIVO,PARTICIPACAO_SOCIETARIA,LOCALIZACAO_PF,CONSULTAS_A_SERASA,RENDA_ESTIMADA")
		cConsulta += "&reportName="      + If(nOpcao==1,"PERFIL_DE_CREDITO_BASICO_PF","RELATORIO_INTERMEDIARIO_PF")
	Else
		cConsulta += "?optionalFeatures="+ If(nOpcao==1,"ANOTACOES_COMPLETAS","PARTICIPACOES,QSA_AVANCADO,SCORE_POSITIVO,FATURAMENTO_ESTIMADO_POSITIVO")
		cConsulta += "&reportName="      + If(nOpcao==1,"RELATORIO_BASICO_PJ","RELATORIO_AVANCADO_PJ")
	Endif
	cConsulta += "&federalUnit=AM"
	
	// If cPessoa == "F"
		// 	// cConsulta += "?optionalFeatures="+ If(nOpcao==1,"ANOTACOES_COMPLETAS","SCORE_POSITIVO,PARTICIPACAO_SOCIETARIA,LOCALIZACAO_PF,CONSULTAS_A_SERASA,RENDA_ESTIMADA")
		// 	// cConsulta += "&reportName="      + If(nOpcao==1,"PERFIL_DE_CREDITO_BASICO_PF","RELATORIO_INTERMEDIARIO_PF")
		// 	cConsulta += "?optionalFeatures="+ If(nOpcao==1,"ANOTACOES_COMPLETAS","SCORE,RENDA_ESTIMADA,ANOTACOES_CONSULTAS_SPC,COMPROMETIMENTO_RENDA,CAPACIDADE_PAGAMENTO,HISTORICO_PAGAMENTO,PONTUALIDADE_PAGAMENTO")
		// 	cConsulta += "&reportName="      + If(nOpcao==1,"PERFIL_DE_CREDITO_BASICO_PF","RELATORIO_AVANCADO_PF")
		// Else
		// 	cConsulta += "?optionalFeatures="+ If(nOpcao==1,"ANOTACOES_COMPLETAS","PARTICIPACOES,QSA_AVANCADO,SCORE_POSITIVO,FATURAMENTO_ESTIMADO_POSITIVO,FATURAMENTO_RECEBIVEIS,ANOTACOES_CONSULTAS_SPC_SOCIOS_ADMINISTRADORES")
		// 	cConsulta += "&reportName="      + If(nOpcao==1,"RELATORIO_BASICO_PJ","RELATORIO_AVANCADO_PJ")
		// Endif
		// cConsulta += "&federalUnit=AM"
	
	// -------------------------------------------------------------------
	// MONTA CABEÇALHO DO POST
	// -------------------------------------------------------------------
	AAdd(aHeadOut, 'X-Document-Id: ' + Trim(cCpf))
	AAdd(aHeadOut, 'Authorization: Bearer ' + cToken)
	AAdd(aHeadOut, 'Content-Type: application/json')   //; charset=iso-8859-1
	
	// -------------------------------------------------------------------
	// ENVIA PARA API
	// -------------------------------------------------------------------
	FWMsgRun(Nil, {|oSay| cPostRet := HTTPSGet(cURL + cConsulta, cCertCRT, cCertKEY, cSenha1, cPostPar, nTimeOut, aHeadOut, @cHeadRet) }, "Integração SERASA", "Consultando SERASA...")
	
	If lContinua := TextToJson(cPostRet,cErro)
		cJSon := cPostRet
	Endif
	
Return lContinua

Static Function TextToJson(cPostRet,cErro)
	Local oReport   := ""
	//Local cMensagem := ""
	//Local cIDFatura := ""
	Local oJSon     := Nil
	Local lRet      := .F.
	
	oJson := JSonObject():New()
	cErro := oJSon:fromJson(cPostRet)
	
	If oJson <> Nil .And. ( cErro == Nil .Or. Empty(cErro) )
		oReport := oJSon:GetJSonObject('reports')
		If lRet := (ValType(oReport) $ "OAJ")
		Else
			FWAlertError("Não houve retorno de dados válidos do SERASA !")
		Endif
		//cMensagem := DecodeUTF8(oJSon:GetJSonObject('message'),"cp1252")
		//cIDFatura := oJSon:GetJSonObject('idFatura')
	Endif

Return lRet

Static Function GravaConsulta(cCpf,cTipo,cJSon)
	Begin Transaction
	RecLock("SZ3",.T.)
	SZ3->Z3_FILIAL  := XFILIAL("SZ3")
	SZ3->Z3_CGC     := cCpf
	SZ3->Z3_DATA    := Date()
	SZ3->Z3_HORA    := Time()
	SZ3->Z3_TIPO    := cTipo
	SZ3->Z3_USUARIO := __cUserID
	SZ3->Z3_JSON    := cJSon
	MsUnLock()
	End Transaction
	FWAlertSuccess("Atualização gravada com sucesso !")
Return .T.

User Function Autenticacao(cURL,nOpcao)
    Local oJson, cErro, lOk, cPostRet
									// nOpcao = 2 -> consulta intermediaria PF usa o cliete Id diferente do cliente Id das demais consultas
    Local aAutPMZ  := iif(nOpcao != 2, Separa(GetMV("MV_XAUTPMZ", .F., "68113cc3cf59e55f141882eb|a803300ciJCIFm-a0b3-4fd8-8f6b-64e5b206ca98"), "|", .F.),;
						 Separa(GetMV("MV_XAUTPMZ", .F., "68113d1c315dd80bf25f03e5|12fee1eevsPBFq-c39a-49ff-8a06-79d90fd63a27"), "|", .F.))
    Local cPostPar := '{"client_id": "' + aAutPMZ[1] + '","client_secret": "' + aAutPMZ[2] + '"}'
    Local aHeadOut := {'Content-Type: application/json','Authorization: Basic '+Encode64(aAutPMZ[1]+":"+aAutPMZ[2])}
    Local cCertCRT := ""
    Local cCertKEY := ""
    Local nTimeOut := 120
    Local cHeadRet := ""
    Local cSenha1  := ""
    Local cToken   := ""

    Default cURL := u_URLPMZ()

    cPostRet := HTTPSPost(cURL + "security/iam/v1/client-identities/login", cCertCRT, cCertKEY, cSenha1, "", cPostPar, nTimeOut, aHeadOut, @cHeadRet)

    If lOk := !(cPostRet == Nil .Or. Empty(cPostRet))
        oJson := JSonObject():New()
        cErro := oJson:fromJson(cPostRet)

        If lOk := (cErro == Nil .Or. Empty(cErro))
            cToken := oJson:GetJSonObject("accessToken")
        EndIf
    EndIf

Return cToken

User Function URLPMZ()
    Local cURLH := GetMV("MV_XURLHOM", .F., "https://uat-api.serasaexperian.com.br/")
    Local cURLP := GetMV("MV_XURLPRD", .F., "https://api.serasaexperian.com.br/")
    Local cBase := GetMV("MV_XMODINT", .F., "1")
Return If(cBase == "1", cURLP, cURLH)
