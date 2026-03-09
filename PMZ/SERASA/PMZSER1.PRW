#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/*
impressão de etiqueta COALI
*/
Static cTitulo := "Integ. Sarasa"

User Function PMZSER1()
	// Local nLargBtn      := 50
	Local aArea   := GetArea()
	Local cFunBkp := FunName()
	Local oBrowse
	Private cProdAtual := ''
	Private cTGet1 := ''
	Private aItems:= {'CODIGO','CNPJ','CPF'}
	//Objetos e componentes
	Private oDlg
	Private oFwLayer
	Private oPanGrid
	//CabeÃ§alho
	Private oSayTitulo, cSayTitulo := 'Pesquisar por:'
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

	// cAlias    := "SZ7"
	// cArquivo  := RETSQLNAME('SZ7')
	// CheckFile(cAlias, cArquivo)

	//Cria a janela
	cAno := cvaltochar(year(date()))

	//Cria a janela
	DEFINE MSDIALOG oDlg TITLE "Clientes Integracao - v1.0.0.1"  FROM 0, 0 TO nJanAltu, nJanLarg PIXEL

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlg,.F.)

	//Adicionando 3 linhas, a de tÃ­tulo, a superior e a do calendÃ¡rio
	oFWLayer:addLine("TIT", 10, .F.)
	oFWLayer:addLine("COR", 90, .F.)

	//Adicionando as colunas das linhas
	oFWLayer:addCollumn("HEADERTEXT",   050, .T., "TIT")
	// oFWLayer:addCollumn("BLANKBTN",     050, .T., "TIT")

	oFWLayer:addCollumn("COLGRID",      100, .T., "COR")

	//Criando os paineis
	oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
	// oPanBut    := oFWLayer:GetColPanel("BLANKBTN",    "TIT")
	oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")

	//TÃ­tulos e SubTÃ­tulos
	oSayTitulo := TSay():New(004, 005, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSayTitulo := TSay():New(015, 005, {|| 'Tipo:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSayTitulo := TSay():New(015, 0120, {|| 'Cod. Cliente:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// oSayTitulo := TSay():New(014, 250, {|| 'Matricula:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )

	cCombo1:= aItems[1]
	oCombo1 := TComboBox():New(10,040,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,60,20,oDlg,,/*{||Alert('Mudou item da combo')}*/,,,,.T.,,,,,,,,,'cCombo1')
	oCombo1:bValid := {||  fgetPict(cCombo1) }

	// cTGet1 := space(tamsx3('A1_CGC')[1])
	oTGet1 := TGet():New( 10,170,{|u| if( Pcount( )>0, cTGet1 := u, cTGet1) },oDlg,120,20,"@!", ,0,,,.F.,,.T.,,.F.,/*{|| x_loadCli(oBrowse,cTGet1)}*/,.F.,.F.,,.F.,.F.,,cTGet1,,,, )
	oTGet1:bValid := {||  X_LOADCLI(oBrowse, cTGet1,cCombo1) }

	// oBtnSair := TButton():New(014, 140, "Gerar coali",  oPanBut, {|| GeraCoal()}, 50, 012, , oFontBtn, , .T., , , , , , )
	// oBtnSair := TButton():New(014, 200, "Ver Coali"  ,  oPanBut, {|| VerCoali(cTGet1)}, 50, 012, , oFontBtn, , .T., , , , , , )
	// oBtnSair := TButton():New(014, 260, "Reimp. FIFO",  oPanBut, {|| FnImp01()}, 50, 012, , oFontBtn, , .T., , , , , , )

	//dialog com browse para defir as notas fiscais
	SetFunName(cFunBkp)

	oBrowse := FWMBrowse():New()

	oBrowse:SetAlias("SA1")
	oBrowse:SetDescription(cTitulo)

// Define o painel onde o browse será exibido
	oBrowse:SetOwner(oPanGrid)

	oBrowse:Activate()
	Activate MsDialog oDlg Centered

	RestArea(aArea)

Return

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: eDSON SALES                                                  |
 | Data:  31/07/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRotina := {}
     
    //Adicionando opções
	ADD OPTION aRotina TITLE 'Atualizar'    ACTION 'u_fncAtual' OPERATION 6 ACCESS 0 //OPERATION 6
    // ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.PMZSER1' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    // ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.PMZSER1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    // ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.PMZSER1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.PMZSER1' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
 
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
     
    //Criação da estrutura de dados utilizada na interface
    Local oStSA1 := FWFormStruct(1, "SA1")
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("PMZSER1M",, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSA1",/*cOwner*/,oStSA1)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'A1_FILIAL','A1_COD','A1_LOJA'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)

    //Validação para não alterar OS Fechadas
    // oModel:SetVldActivate({ |oModel| fPreVld(oModel) })
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSA1"):SetDescription("Formulário do Cadastro "+cTitulo)

Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Edson Sales                                                  |
 | Data:  16/02/2026                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local aStruSA1    := SA1->(DbStruct())
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("PMZSER1")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSA1 := FWFormStruct(2, "SA1")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SA1_NOME|SA1_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
    aStruSA1 := aStruSA1
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
	
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SA1", oStSA1, "FORMSA1")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SA1', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_SA1","TELA")
   
Return oView

Static Function X_LOADCLI(oBrowse, cCodigo,_cCombo1)
	Local cFilter := ""
    If ValType(oBrowse) == "O"

        If !Empty(AllTrim(cCodigo))
			if _cCombo1 == 'CODIGO'
				cFilter := "A1_COD == '" + AllTrim(cCodigo) + "'"
			Else
				cFilter := "A1_CGC == '" + AllTrim(cCodigo) + "'"
			endif
            oBrowse:SetFilterDefault( cFilter )
        Else
			cFilter := ""
            oBrowse:SetFilterDefault(cFilter)
        EndIf
        oBrowse:Refresh()
    EndIf

Return

/*/{Protheus.doc} fgetPict(cCombo1)
	atualizar tamanho do Tget pelo tipo escolido no combobox
/*/
Static Function fgetPict(_cCombo1)
	
	if _cCombo1 == 'CPF'
		cTGet1 := Space(11)
	Elseif _cCombo1 == 'CNPJ'
		cTGet1 := Space(14)
	Else
		cTGet1 := Space(8)
	endif
	
	oDlg:Refresh()
Return


/*/
(Consultar API Serasa)
@type user function
@author Edson Sales
@since 16/02/2026
/*/
User Function fncAtual()
	local lAMb      := RpcSetEnv('01','01')
    Local cToken := u_PMZTOKEN() // buscar token
	Local aRet := {}
	Local aPergs := {}
	Local cTipo := ''
	Local aTp := {'1=Basico PF','2=Basico PJ','3=Completo PF','4=Completo PJ'}

	if !lAMb
		Return
	endif

	aAdd(aPergs,{2, "Tipo Rel:.",cTipo, aTp,     122, ".T.", .F.})
    // aAdd(aPergs,{1,"Quant. Produto: ",Space(8),"","!Empty(MV_PAR01)","","",0 ,.F.})

	If !ParamBox(aPergs ,"Etiquetas ...",@aRet,,,,,,,,.F.,.T.)
		Return
	Else
		Processa( {|| xConsult(cToken) }, "Aguarde...","Atualizando....",.F.)
	Endif
Return

/*/{Protheus.doc} xConsult
	(long_description)
	@type  Static Function
	
	@author Edson Sales
	@since 16/02/2026
/*/
Static Function xConsult(xTkn)
	// 
	Local aArea     := FWGetArea()
	Local cURL      := "https://uat-api.serasaexperian.com.br/"
	// local cPath     := "credit-services/person-information-report/v1/creditreport"
	local cPath     := ""
	Local oConsult
	Local aHeaders := {}
	Local jResponse
	Default cUsr := ""
	Default cPsw := ""

	DBSELECTAREA('SZ2')
	SZ2->(DBSETORDER(1))
	if SZ2->(msSeek(xFilial('SZ2')+__cUserID))
		xDiasBas := SZ2-> Z2_DIASBAS 
		xDiasCom := SZ2-> Z2_DIASCOM
	EndIf

	if MV_PAR01 =='1'
		cRel := "ANOTACOES_COMPLETAS,LOCALIZACAO_PF"
		cNameRel := "PERFIL_DE_CREDITO_BASICO_PF"
	endif
	cEstado := 'AM'// SA1->A1_EST
		
	cPath := "credit-services/person-information-report/v1/creditreport"
	cPath += "?optionalFeatures=" + cRel
	cPath += "&reportName=" + cNameRel
	cPath += "&federalUnit=" + cEstado
	

	// Adiciona header Authorization
	aAdd(aHeaders, "Authorization: Bearer " + xTkn)
	aAdd(aHeaders, "X-Document-Id: 01491787279")//+ AllTrim(SA1->A1_CGC))
	aAdd(aHeaders, "Content-Type: application/json")
	aAdd(aHeaders, "Origin: protheus-api")
	aAdd(aHeaders, "X-Retailer-Document-Id: 22763502008353")

	// //Instancia o WS
	oConsult   := FWRest():New(cURL)
	oConsult:SetPath(cPath)
    // oConsult:SetPostParams(cBody)

	//Define a url
	// oConsult:setPath("token?grant_type=password&password=" + cUsr + "&username=" + cPsw)
	If oConsult:get(aHeaders)

		//Pega o JSON de resposta, e pega o token
		jResponse := JsonObject():New()
		jResponse:FromJson(oConsult:cResult)

		//Pega o Token de acesso
		// cToken := Iif( ValType(jResponse['accessToken']) != "U", jResponse['accessToken'], "")
	else
		MsgStop(oConsult:getLastError())
	EndIf
	RestArea(aArea)
Return 
