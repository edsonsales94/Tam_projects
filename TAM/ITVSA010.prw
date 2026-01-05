//Bibliotecas
#Include "PROTHEUS.ch"
#Include "TOPCONN.CH"

//status agenda
static STATUS_AGENDAMENTO      := u_stsAgenda()
static STATUS_CONFIRMADA       := u_stsConfirmado()
static STATUS_PENDENTE_ENTREGA := u_stsApontado()


//Legendas agendas
static oStAptPend  := LoadBitmap(GetResources(),'QMT_NO')
static oStEntPend  := LoadBitmap(GetResources(),'QMT_COND')
static oStEntConf  := LoadBitmap(GetResources(),'QMT_OK')

/*/{Protheus.doc} User Function ITVSA010
    Cadastro de Agendas
    @type  Function
    @author matheus.vinicius@totvspartners.com.br
    @since 13/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function ITVSA010()
	Local bCriaCheck := {|nI,lCheck,nLinha,nColuna,cLabel,cLmark| fCriaChk(nI,lCheck,nLinha,nColuna,cLabel,cLmark) }
	Local nLargBtn   := 50
	Local nI         := Nil

	//Objetos e componentes
	Private oDlgPulo
	Private oFwLayer
	Private oPanTitulo
	Private oPanGrid
	Private oParam
	Private aTFolder    := { 'Parâmetros', 'Agendamentos'}
	Private aRecursos   := {}
	Private cMrkObj     := "oMrk"
	Private cLmark      := "lMark"
	Private cCliente
	Private dDtIni
	Private dDtFim
	Private lPendApt    := .T.
	Private lPendEnt    := .T.
	Private lEntregue   := .T.

	//Cabeçalho
	Private oSayModulo, cSayModulo := 'ITV'
	Private oSayTitulo, cSayTitulo := 'INTEGRATVS SOLUCOES TECNOLOGICAS'
	Private oSaySubTit, cSaySubTit := 'Cadastro de Agendamentos'

	//Tamanho da janela
	Private aSize    := MsAdvSize(.F.)
	Private nJanLarg := aSize[5]
	Private nJanAltu := aSize[6]

	//Fontes
	Private cFontUti    := "Tahoma"
	Private oFontMod    := TFont():New(cFontUti, , -38)
	Private oFontSub    := TFont():New(cFontUti, , -20)
	Private oFontSubN   := TFont():New(cFontUti, , -20, , .T.)
	Private oFontBtn    := TFont():New(cFontUti, , -14)
	Private oFontSay    := TFont():New(cFontUti, , -12)

	//Dados
	Private aBrowse := {{Nil,"","","","","","","","","","",Nil}}
	Private cRecSel := ""

	//DEFINE MSDIALOG  TITLE "Exemplo de Pulo do Gato"  FROM 0, 0 TO nJanAltu, nJanLarg PIXEL
	oDlgPulo := TDialog():New(0, 0, nJanAltu, nJanLarg, 'Cadastro de Agendas', , , , , CLR_BLACK, RGB(250, 250, 250), , , .T.)

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlgPulo,.F.)

	//Adicionando 3 linhas, a de título, a superior e a do calendário
	oFWLayer:addLine("TIT", 10, .F.)
	oFWLayer:addLine("COR", 70, .F.)
	oFWLayer:addLine("ROD", 20, .F.)

	//Adicionando as colunas das linhas
	oFWLayer:addCollumn("HEADERTEXT",   050, .T., "TIT")
	oFWLayer:addCollumn("BLANKBTN",     040, .T., "TIT")
	oFWLayer:addCollumn("BTNSAIR",      010, .T., "TIT")
	oFWLayer:addCollumn("COLGRID",      100, .T., "COR")
	oFWLayer:addCollumn("RODGRID",      100, .T., "ROD")

	//Criando os paineis
	oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
	oPanSair   := oFWLayer:GetColPanel("BTNSAIR",    "TIT")
	oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")
	oPanRoda   := oFWLayer:GetColPanel("RODGRID" ,   "ROD")

	//Títulos e SubTítulos
	oSayModulo := TSay():New(004, 003, {|| cSayModulo}, oPanHeader, "", oFontMod,  , , , .T.,;
		RGB(149, 179, 215), , 200, 30, , , , , , .F., , )
	oSayTitulo := TSay():New(004, 045, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T.,;
		RGB(031, 073, 125), , 200, 30, , , , , , .F., , )
	oSaySubTit := TSay():New(014, 045, {|| cSaySubTit}, oPanHeader, "", oFontSubN, , , , .T.,;
		RGB(031, 073, 125), , 300, 30, , , , , , .F., , )

	//Criando os botões
	oBtnSair   := TButton():New(006, 001, "Fechar", oPanSair, {|| oDlgPulo:End()}, nLargBtn, 018, , oFontBtn, , .T., , , , , , )

	//cria os folders
	oTFolder := TFolder():New( 001,001,aTFolder,,oPanGrid,,,,.T.,,nJanLarg/2-001,nJanAltu/2-010 )
	//largura e altura maxima do folder
	nLargMax := nJanLarg/2-012
	nAltuMax := nJanAltu/2-100

	//cria o grupo 1 do folder 1 - recursos a serem marcados
	oGrp1Fld1  := TGroup():New(02,02 ,nAltuMax,nLargMax*0.80, 'Escolha os Recursos',oTFolder:aDialogs[1],,,.T.)

	//cria os checkbox - recursos a serem marcados
	nLinha  := 12
	nColuna := 15
	getRecursos()
	For nI := 1 to len(aRecursos)
		//cria as variaveis lCheck como privadas. serão usadas no checkbox
		SetPrvt(cLmark + cValToChar(nI))
		&(cLmark + cValToChar(nI)) := .F.

		//cria o check box
		Eval(bCriaCheck,nI,&(cLmark + cValToChar(nI)),nLinha,nColuna,aRecursos[nI,1],cLmark + cValToChar(nI))

		if mod(nI,12) == 0
			nLinha  := 12
			nColuna += 130
		else
			nLinha += 12
		endif

	Next nI

	//cria o grupo 2 do folder 1
	oGrp2Fld1  := TGroup():New(02,nLargMax*0.80+10 ,nAltuMax,nLargMax,;
		'Defina o período e cliente. Caso o cliente esteja em branco serão considerados todos.',;
		oTFolder:aDialogs[1],,,.T.)

	dDtIni := FirstDate(ddatabase)
	oGet3 := TGet():New( 15, nLargMax*0.80+20, { | u | If( PCount() == 0, dDtIni, dDtIni := u ) },oGrp2Fld1, ;
		060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtIni",,,,,,,"Data de",1  )

	dDtFim := LastDate(ddatabase)
	oGet4 := TGet():New( 40, nLargMax*0.80+20, { | u | If( PCount() == 0, dDtFim, dDtFim := u ) },oGrp2Fld1, ;
		060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtFim",,,,,,,"Data até",1  )

	cCliente := CriaVar("C5_CLIENTE",.F.)
	oGet1 := TGet():New( 65, nLargMax*0.80+20, { | u | If( PCount() == 0, cCliente, cCliente := u ) },oGrp2Fld1, ;
		060, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cCliente",,,,,,,"Cliente:",1  )
	oGet1:Cf3 := "SA1"

	//cria as variaveis lCheck como privadas. serão usadas no checkbox
	Eval(bCriaCheck,cvaltochar(len(aRecursos)+1),lPendApt ,095,nLargMax*0.80+20,'Pendente Apontamento','LPENDAPT')
	Eval(bCriaCheck,cvaltochar(len(aRecursos)+2),lPendEnt ,110,nLargMax*0.80+20,'Pendente Entrega'    ,'LPENDENT')
	Eval(bCriaCheck,cvaltochar(len(aRecursos)+3),lEntregue,125,nLargMax*0.80+20,'Os Confirmada'       ,'LENTREGUE')

	oCalcular := TButton():New(145, nLargMax*0.80+20 , "Carregar!" , oGrp2Fld1, {|| MsgRun( "Atualizando agenda...", "Atenção", {|| getAgenda()})}, 35, 018, , oFontBtn, , .T., , , , , , )

	oCnfOs    := TButton():New(05, nJanLarg/2-165, "Confirma OS", oTFolder:aDialogs[2], {|| TelaConfOs(.F.)}, 050, 018, , oFontBtn, , .T., , , , , , )
	oCnfOs    := TButton():New(05, nJanLarg/2-110, "Est Conf OS", oTFolder:aDialogs[2], {|| TelaConfOs(.T.)}, 050, 018, , oFontBtn, , .T., , , , , , )
	oIncAgend := TButton():New(05, nJanLarg/2-055, "Nova Agenda", oTFolder:aDialogs[2], {|| telaAgenda()   }, 050, 018, , oFontBtn, , .T., , , , , , )

	//cria o browse do folder 2
	oBrowse := TCBrowse():New( 25 , 05, nJanLarg/2-10, nJanAltu/3-038,,,, oTFolder:aDialogs[2],,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
	oBrowse:AddColumn(TCColumn():New(""              , {|| aBrowse[oBrowse:nAt,01]},    ,,,"LEFT"  , nJanLarg/4*0.01,.T.,.F.,,          ,,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Data"          , {|| aBrowse[oBrowse:nAt,02]} ,"@D",,,"LEFT"  , nJanLarg/4*0.10,.F.,.F.,,{|| .F. },,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Dia"           , {|| aBrowse[oBrowse:nAt,03]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Cliente"       , {|| aBrowse[oBrowse:nAt,04]} ,"@!",,,"LEFT"  , nJanLarg/4*0.18,.F.,.F.,,         ,,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Loja"          , {|| aBrowse[oBrowse:nAt,05]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Cód. Projeto"  , {|| aBrowse[oBrowse:nAt,06]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Descr. Projeto", {|| aBrowse[oBrowse:nAt,07]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Hr Início"     , {|| aBrowse[oBrowse:nAt,08]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Hr Fim"        , {|| aBrowse[oBrowse:nAt,09]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oBrowse:AddColumn(TCColumn():New("Recurso"       , {|| aBrowse[oBrowse:nAt,10]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )

	oBrowse:bRClicked    := { |o,x,y| MenuPop(o,x,y) }
	oBrowse:bLClicked    := { || }
	oBrowse:bHeaderClick := { || Ordena(oBrowse) }

	//rodape - informa os parametros selecionados
	oGroup3  := TGroup():New(02,02,nJanAltu/12,nJanLarg/2-001,'Parâmetros Escolhidos',oPanRoda,,,.T.)
	oParam   := TSay():New(20, 10, {|| }, oGroup3, , , , , , .T., CLR_BLACK, , nJanLarg/2-070, 20, , , , , , .T.)
	oParam:SetText("Escolha os parâmetros para iniciar")

	oDlgPulo:Activate(, , , .T., {|| .T.}, , )

Return

/*/{Protheus.doc} MenuPop
    Clica menu de opcoes ao clicar com o botao direito
    @type  Function
    @author matheus.vinicius
    @since 13/04/2022
/*/
Static Function MenuPop(o,x,y)
	Local oMenuItem  := {}

	MENU oMenu POPUP
	aAdd( oMenuItem, MenuAddItem("Visualizar Agendamento",,, .T.,,,, oMenu,{ || telaAgenda("VISUALIZAR")     },,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Editar Agendamento"    ,,, .T.,,,, oMenu,{ || telaAgenda("ALTERAR")        },,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Copiar Agendamento"    ,,, .T.,,,, oMenu,{ || telaAgenda("COPIAR")         },,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Confirmar Agendamento" ,,, .T.,,,, oMenu,{ || ConfAgend()                  },,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Excluir Agendamento"   ,,, .T.,,,, oMenu,{ || telaAgenda("EXCLUIR")        },,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Env. Email"            ,,, .T.,,,, oMenu,{ || EnviaEmail()                 },,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Excluir Apontamento"   ,,, .T.,,,, oMenu,{ || ExclApt(aBrowse[oBrowse:nAt])},,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Alt Texto Apontado"    ,,, .T.,,,, oMenu,{ || AltText(aBrowse[oBrowse:nAt])},,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Alt Projeto Apontado"  ,,, .T.,,,, oMenu,{ || telaAgenda("ALTPRJ")         },,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Alt Produto Apontado"  ,,, .T.,,,, oMenu,{ || telaAgenda("ALTPRD")         },,,,,{||.T.} ) )
	aAdd( oMenuItem, MenuAddItem("Imprimir OS"           ,,, .T.,,,, oMenu,{ || imprimirOS()                 },,,,,{||.T.} ) )
	// aAdd( oMenuItem, MenuAddItem("Alterar Contatos..."   ,,, .T.,,,, oMenu,{ || _ActAlterarContatos()        },,,,,{||_AltCtt_Enabled() } ) )
	ENDMENU

	oMenu:Activate( Iif( x > oBrowse:NCLIENTWIDTH, oBrowse:NCLIENTWIDTH/2, x ) , 21 + oBrowse:nRowPos, o )
Return

/*/{Protheus.doc} Ordena
    Ordena agendas pela data
    @type  Function
    @author matheus.vinicius
    @since 13/04/2022
/*/
Static Function Ordena(oObjeto)
	oObjeto:aArray :=ASORT(oObjeto:aArray, , , { | x,y | x[oObjeto:ColPos] < y[oObjeto:ColPos] } )
	oObjeto:Refresh()
Return

/*/{Protheus.doc} getRecursos
    Busca os recursos ativos
    @type  Function
    @author matheus.vinicius
    @since 13/04/2022
/*/
Static Function getRecursos()
	aRecursos := {}
	SA9->(DbSetOrder(2))
	SA9->(DbGoTop())
	While !SA9->(EOF())
		If SA9->A9_ATIVO == "S"
			aAdd(aRecursos,{SA9->A9_TECNICO+" - "+TRIM(SA9->A9_NOME),SA9->A9_TECNICO})
		EndIf
		SA9->(DbSkip())
	Enddo
Return

/*/{Protheus.doc} fCriaChk
    Cria checkbox dinamicamente
    @type  Function
    @author matheus.vinicius
    @since 13/04/2022
/*/
static function fCriaChk(nI,lmark,nLinha,nColuna,cLabel,cLmark)
	SetPrvt(cMrkObj + cValToChar(nI))
	&(cMrkObj + cValToChar(nI)) := TCheckBox():New(nLinha - 01,nColuna,cLabel,{||lmark},oTFolder:aDialogs[1],110,210,,,,,,,,.T.,,,)
	&(cMrkObj + cValToChar(nI)):bSetGet := {|| &(cLmark) }
	&(cMrkObj + cValToChar(nI)):bLClicked := {||  &(cLmark) :=! &(cLmark) }
	&(cMrkObj + cValToChar(nI)):bWhen := {|| .T. }
return

/*/{Protheus.doc} getAgenda
    Busca as agendas cadastradas
    @type  Function
    @author matheus.vinicius
    @since 13/04/2022
/*/
static function getAgenda()
	Local oLegenda := ""
	Local dAgeData := Nil
	Local cAgeClie := ""
	Local cAgeLoja := ""
	Local cAgeProj := ""
	Local cAgeDesc := ""
	Local cAgeHrIn := ""
	Local cAgeHrFi := ""
	Local cAgeHrTt := ""
	Local cAgeHrAl := ""
	Local cAgeTecn := ""
	Local cAgeTran := ""
	Local cAgeObsr := ""
	Local cAgCodig := ""
	Local cAgeStat := ""
	Local cAgProd  := ""
	Local cLocate  := ""
	Local nRecno   := Nil

	AtuRodPar()
	aBrowse := {}

	if empty(cRecSel)
		MsgStop('Selecione ao menos um recurso.', 'Atenção')
		aBrowse := {{Nil,"","","","","","","","","","",Nil}}
		atuBrowse()
		return
	endif

	if !lPendApt .and. !lPendEnt .and. !lEntregue
		MsgStop('Selecione ao menos um status.', 'Atenção')
		aBrowse := {{Nil,"","","","","","","","","","",Nil}}
		atuBrowse()
		return
	endif

	//Z1_FILIAL, Z1_DATA, Z1_TECNICO, R_E_C_N_O_, D_E_L_E_T_
	SZ1->(DbSetOrder(2))
	SZ1->(DbSeek(xFilial("SZ1") + dtos(dDtIni), .T. ))

	AF8->(DbSetOrder(1))

	While !SZ1->(EOF()) .and. SZ1->Z1_DATA >= dDtIni .AND. SZ1->Z1_DATA <= dDtFim
		If !(Rtrim(SZ1->Z1_TECNICO) $ cRecSel)
			SZ1->(DbSkip())
			loop
		EndIf

		If !empty(cCliente) .and. !(cCliente $ SZ1->Z1_CLIENTE)
			SZ1->(DbSkip())
			loop
		EndIf

		If !lPendEnt .AND. SZ1->Z1_STATUS == STATUS_PENDENTE_ENTREGA
			SZ1->(DbSkip())
			loop
		EndIf

		If !lEntregue .AND. SZ1->Z1_STATUS == STATUS_CONFIRMADA
			SZ1->(DbSkip())
			loop
		EndIf

		If !lPendApt .AND. SZ1->Z1_STATUS $ STATUS_PENDENTE_ENTREGA+STATUS_CONFIRMADA
			SZ1->(DbSkip())
			loop
		EndIf

		If AF8->(dbSeek(xFilial("AF8")+SZ1->Z1_PROJETO))
            /*apontado*/                  /*confirmado*/
			If SZ1->Z1_STATUS == STATUS_PENDENTE_ENTREGA .OR. SZ1->Z1_STATUS == STATUS_CONFIRMADA
				oLegenda := If( SZ1->Z1_STATUS == STATUS_PENDENTE_ENTREGA , oStEntPend, oStEntConf)
				cLocate  := SZ1->Z1_APLOCAL
				cAgeHrTt := SZ1->Z1_APHRTOT
				cAgeHrAl := SZ1->Z1_APHRALM
				cAgeHrIn := SZ1->Z1_APHRINI
				cAgeHrFi := SZ1->Z1_APHRFIM
				cAgeTran := SZ1->Z1_APTRANS
				cAgeObsr := SZ1->Z1_APTEXTO
			Else //agendado
				oLegenda := oStAptPend
				cLocate  := SZ1->Z1_AGLOCAL
				cAgeHrTt := SZ1->Z1_AGHRTOT
				cAgeHrAl := SZ1->Z1_AGHRALM
				cAgeHrIn := SZ1->Z1_AGHRINI
				cAgeHrFi := SZ1->Z1_AGHRFIM
				cAgeTran := SZ1->Z1_AGTRANS
				cAgeObsr := SZ1->Z1_AGTEXTO
			EndIf

			dAgeData := SZ1->Z1_DATA
			cAgeClie := SZ1->Z1_CLIENTE
			cAgeLoja := SZ1->Z1_LOJA
			cAgeProj := AF8->AF8_PROJET
			cAgeDesc := AF8->AF8_DESCRI
			cAgeTecn := SZ1->Z1_TECNICO
			cAgCodig := SZ1->Z1_CODIGO
			nRecno   := SZ1->(RECNO())
			cAgProd  := SZ1->Z1_PRODUTO
			cAgeStat := SZ1->Z1_STATUS

			aAdd(aBrowse,{;
				oLegenda,;                                             //01
			dAgeData,;                                             //02
			DiaSemana(dAgeData),;                                  //03
			cAgeClie,;                                             //04
			cAgeLoja,;                                             //05
			cAgeProj,;                                             //06
			cAgeDesc,;                                             //07
			cAgeHrIn,;                                             //08
			cAgeHrFi,;                                             //09
			Posicione("SA9",1,xFilial("SA9")+cAgeTecn,"A9_NOME"),; //10
			cAgeTran,;                                             //11
			cAgeObsr,;                                             //12
			cAgeTecn,;                                             //13
			cAgCodig,;                                             //14
			cAgeStat,;                                             //15
			nRecno,;                                               //16
			cLocate,;                                              //17
			cAgProd,;                                              //18
			cAgeHrTt,;                                             //19
			cAgeHrAl})                                             //20
		EndIf
		SZ1->(dbSkip())
	Enddo

	aBrowse := aSort(aBrowse,,,{ |x,y| dtos(x[2])+x[8] < dtos(y[2])+y[8] })

	if len(aBrowse) == 0
		MsgInfo('Sem agendas para o período informado.', 'Atenção')
	endif

	atuBrowse()
return

/*/{Protheus.doc} atuBrowse
    Refresh browse de agendas
    @type  Function
    @author matheus.vinicius
    @since 13/04/2022
/*/
static function atuBrowse()
	oBrowse:SetArray(aBrowse)
	oBrowse:Refresh()
	if len(aBrowse) >= 1 .and. aBrowse[1,1] <> Nil
		oTFolder:ShowPage(2)
		oBrowse:SetFocus()
	endif
return

/*/{Protheus.doc} AtuRodPar
    atualiza rodape com os parametros informados
    @type  Function
    @author matheus.vinicius
    @since 13/04/2022
/*/
static function AtuRodPar()
	Local nI := 1
	Local cTexto := ""

	cRecSel := ""

	For nI := 1 to len(aRecursos)
		If empty(cTexto)
			cTexto += "Recursos: "
		EndIf
		If &("lMark"+cvaltochar(nI))
			cTexto  += aRecursos[nI,1]+", "
			cRecSel += aRecursos[nI,2]+","
		EndIf
	Next nI

	cTexto += CRLF
	cTexto += "Período de "+dtoc(dDtIni)+" até "+dtoc(dDtFim)

	cRecSel += left(cRecSel,len(cRecSel)-1)

	If !empty(cCliente)
		cTexto += CRLF
		cTexto += "Cliente: "+cCliente
	EndIf

	oParam:SetText(cTexto)

return

/*/{Protheus.doc} telaAgenda
    Interface para manutençaõ de agendas
    @type  Function
    @author matheus.vinicius
    @since 13/04/2022
/*/
Static Function telaAgenda(cOper)
	Local cTitulo  := 'Cadastro de Agenda'

	//variaves de posição dos objetos
	Local nLinha  := 050
	Local nColuna := 015
	Local nColini := 015

	Private cCodPrj  := Space(TamSx3("AF8_PROJET")[1])
	Private cDesPrj  := Space(TamSx3("AF8_DESCRI")[1])
	Private cClient  := ""
	Private cLoja    := ""
	Private cHrIni   := Space(TamSx3("Z1_AGHRINI")[1])
	Private cHrFim   := Space(TamSx3("Z1_AGHRFIM")[1])
	Private cHrTransl:= Space(TamSx3("Z1_AGTRANS")[1])
	Private cLocAten := Space(3)
	Private cAtivi   := CriaVar("B1_DESC",.F.)
	Private cRecurso := Space(TamSx3("A9_TECNICO")[1])
	Private aRecurso := {{"","",""}}
	Private aContatos:= {{"","","",""}}
	Private dDtAgend := ddatabase
	Private nRecnoId := 0
	Private cOperac  := ""

	Private cNewPrj  := Space(TamSx3("AF8_PROJET")[1])
	Private cRevPrj  := Space(TamSx3("AFC_REVISA")[1])
	Private cNewDPr  := Space(TamSx3("AF8_DESCRI")[1])
	Private cAtivid  := Space(TamSx3("AFC_EDT")[1])
	Private aAtivid  := {{"","",""}}
	Private oBtnAltCtt := Nil

	Default cOper    := "INCLUIR"

	//forçada a variavel cOper pois a variavel nao estava sendo reconhecida na funcao de exclusao
	cOperac := cOper

	If cOperac $ "ALTERAR,EXCLUIR" .and. aBrowse[oBrowse:nAt,15] $ 'ZY'
		MsgStop('O status da agenda não permite esta operação.', 'Atenção')
		return
	ElseIf cOperac $ "ALTPRJ" .and. aBrowse[oBrowse:nAt,15] <> STATUS_AGENDA_OS_MIGRADA
		MsgStop('O status da agenda não permite esta operação.', 'Atenção')
		return
	ElseIf cOperac $ "ALTPRD" .and. !(aBrowse[oBrowse:nAt,15] $ 'ZY')
		MsgStop('O status da agenda não permite esta operação.', 'Atenção')
		return
	Endif

	If cOperac <> "INCLUIR"
		cCodPrj  := aBrowse[oBrowse:nAt,06]
		cDesPrj  := aBrowse[oBrowse:nAt,07]
		cClient  := aBrowse[oBrowse:nAt,03]
		cLoja    := aBrowse[oBrowse:nAt,04]
		cHrIni   := aBrowse[oBrowse:nAt,08]
		cHrFim   := aBrowse[oBrowse:nAt,09]

		cHrTransl:= aBrowse[oBrowse:nAt,11]
		cAtivi   := aBrowse[oBrowse:nAt,12]
		cRecurso := aBrowse[oBrowse:nAt,13]
		aRecurso := {{cRecurso,aBrowse[oBrowse:nAt,10],aBrowse[oBrowse:nAt,18]}}

		cLocAten := aBrowse[oBrowse:nAt,17]

		if cOperac $ "ALTERAR,EXCLUIR,VISUALIZAR,ALTPRJ"
			dDtAgend := aBrowse[oBrowse:nAt,02]
		endif

		nRecnoId := aBrowse[oBrowse:nAt,16]
	EndIf

	DEFINE MSDIALOG oDlg TITLE cTitulo  From 5,15 To 40,135 OF oMainWnd

	@ nLinha ,nColuna MSGET cCodPrj F3 "AF8" Picture PesqPict("AF8","AF8_PROJET") When( !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD") ) Valid (VldIncAgd()) SIZE 40,09 OF oDlg PIXEL
	@ nLinha-10, nColuna SAY "Cód. Projeto" SIZE 040, 019 OF oDlg PIXEL

	@ nLinha,nColuna+=050 MSGET cDesPrj  /*F3 "AF8"*/ Picture PesqPict("AF8","AF8_DESCRI") When(.F.) Valid (VldIncAgd()) SIZE 150,09 OF oDlg PIXEL
	@ nLinha-10, nColuna SAY "Descr. Projeto" SIZE 040, 019 OF oDlg PIXEL

	@ nLinha,nColuna+=200 MSGET dDtAgend /*F3 "AF8"*/ Picture "@D" When(!Empty(cCodPrj) .AND.  !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD") ) Valid (VldIncAgd()) SIZE 40,09 OF oDlg PIXEL
	@ nLinha-10, nColuna SAY "Data Agenda" SIZE 040, 019 OF oDlg PIXEL

	@ nLinha,nColuna+=050 MSGET cHrIni   /*F3 "AF8"*/ Picture PesqPict("SZ1","Z1_AGHRINI" ) When(!Empty(cCodPrj) .AND.  !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD") ) Valid (VldIncAgd()) SIZE 08,09 OF oDlg PIXEL
	@ nLinha-10, nColuna SAY "Hora Início" SIZE 040, 019 OF oDlg PIXEL

	@ nLinha,nColuna+=050 MSGET cHrFim   /*F3 "AF8"*/ Picture PesqPict("SZ1","Z1_AGHRINI" ) When(!Empty(cCodPrj) .AND.  !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD") ) Valid (VldIncAgd()) SIZE 08,09 OF oDlg PIXEL
	@ nLinha-10, nColuna SAY "Hora Término" SIZE 040, 019 OF oDlg PIXEL

	@ nLinha,nColuna+=050 MSGET cLocAten F3 "ZCQ"  Picture PesqPict("SZ1","Z1_AGLOCAL") When(!Empty(cCodPrj) .AND.  !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD") ) Valid (VldIncAgd()) SIZE 40,09 OF oDlg PIXEL
	@ nLinha-10, nColuna SAY "Local Atendimento" SIZE 080, 019 OF oDlg PIXEL

	oGrp1Fld1  := TGroup():New(nLinha-020, 010, nLinha+022, nColuna+50, 'Informe o projeto',oDlg ,,,.T.)

	nLinha  += 025
	nColFim := nColuna
	nColuna := nColini

	oTMultiget1 := tMultiget():new( nLinha, 015, {| u | if( pCount() > 0, cAtivi := u, cAtivi ) }, oDlg, nColFim, 60, , , , , , .T.,,,,,,,,,,,,"Atividade",1 )
	oTMultiget1:lReadOnly := (cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD")

	nLinha  += 085

	@ nLinha   , nColuna MSGET cRecurso F3 "SA9" Picture PesqPict("SA9","A9_TECNICO") When(!Empty(cCodPrj) .AND.  !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD") ) Valid (VldIncAgd()) SIZE 40,09 OF oDlg PIXEL
	@ nLinha-10, nColuna SAY "Cód. Recurso" SIZE 040, 019 OF oDlg PIXEL

	@ nLinha-5, nColuna+180 BUTTON oBtnAltCtt ;
		PROMPT "Adicionar" SIZE 50,18 OF oDlg PIXEL ;
		ACTION ( U_AddCont(cCodPrj, cClient, cLoja, "AGENDA", nRecnoId) ) ;
		WHEN ( !Empty(AllTrim(cCodPrj)) .and. !Empty(AllTrim(cClient)) .and. ;
		!(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD") )
	// @ nLinha-5, nColuna+060 BUTTON oBtnAltCtt ;
		//     PROMPT "Alterar Contatos" SIZE 50,18 OF oDlg PIXEL ;
		//     ACTION ( U_PROJ_CONTATOS(cCodPrj, cClient, cLoja, "AGENDA", nRecnoId) ) ;
		//     WHEN ( !Empty(AllTrim(cCodPrj)) .and. !Empty(AllTrim(cClient)) .and. ;
		//     !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD") )

	nLinha  += 015
	oRecurso := TCBrowse():New( nLinha , nColini, 170, 80,,,, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
	oRecurso:AddColumn(TCColumn():New("Código"  , {|| aRecurso[oRecurso:nAt,01]} ,"@D",,,"LEFT"  , nJanLarg/4*0.10,.F.,.F.,,{|| .F. },,.F.,) )
	oRecurso:AddColumn(TCColumn():New("Nome"    , {|| aRecurso[oRecurso:nAt,02]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oRecurso:AddColumn(TCColumn():New("Produto" , {|| aRecurso[oRecurso:nAt,03]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oRecurso:SetArray(aRecurso)

	oContatos := TCBrowse():New( nLinha , nColini+180, 170, 80,,,, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
	oContatos:AddColumn(TCColumn():New("Ordem"  , {|| aContatos[oContatos:nAt,01]} ,"@D",,,"LEFT"  , nJanLarg/4*0.10,.F.,.F.,,{|| .F. },,.F.,) )
	oContatos:AddColumn(TCColumn():New("Grupo"  , {|| aContatos[oContatos:nAt,02]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oContatos:AddColumn(TCColumn():New("Nome"   , {|| aContatos[oContatos:nAt,03]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
	oContatos:AddColumn(TCColumn():New("Email"  , {|| aContatos[oContatos:nAt,04]} ,"@!",,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )	
	ASort(aContatos,,, {|a,b| ;
       IIf( a[2] == b[2], ;        // Mesmo GRUPO?
            a[1] < b[1], ;         // Ordena pela ORDEM
            a[2] < b[2] ) })       // Senão, ordena pelo GRUPO
	oContatos:SetArray(aContatos)

	if !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD")
		oContatos:bLDblClick := {|| VldIncAgd("EXCLUIRCONTATO") }
	endif
	if !(cOperac $ "VISUALIZAR,ALTPRJ,ALTPRD")
		oRecurso:bLDblClick := {|| VldIncAgd("EXCLUIRECURSO") }
	endif
	if !(cOperac $ "VISUALIZAR,ALTPRJ")
		oRecurso:bRClicked  := {|| TrocaProduto() }
	endif

	if cOperac $ "ALTPRJ"
		nColuna := (nColfim-nColini)/2
		nColuna -= 070
		nLinha -= 015

		@ nLinha,nColuna+=080 MSGET cNewPrj F3 "AF8" Picture PesqPict("AF8","AF8_PROJET") When( (cOperac $ "ALTPRJ") ) Valid (VldIncAgd()) SIZE 40,09 OF oDlg PIXEL
		@ nLinha-10, nColuna SAY "Novo Projeto" SIZE 040, 019 OF oDlg PIXEL

		@ nLinha,nColuna+=050 MSGET cNewDPr  /*F3 "AF8"*/ Picture PesqPict("AF8","AF8_DESCRI") When(.F.) Valid (VldIncAgd()) SIZE 150,09 OF oDlg PIXEL
		@ nLinha-10, nColuna SAY "Descr. Projeto" SIZE 040, 019 OF oDlg PIXEL

		nLinha  += 025
		nColuna -= 050

		@ nLinha,nColuna MSGET cAtivid F3 "AF9_AG" Picture PesqPict("AF8","AF8_PROJET") When( (cOperac $ "ALTPRJ") ) Valid (VldIncAgd()) SIZE 40,09 OF oDlg PIXEL
		@ nLinha-10, nColuna SAY "Atividades" SIZE 040, 019 OF oDlg PIXEL

		@ nLinha,nColuna+=050 MSGET cRevPrj F3 "AF8" Picture PesqPict("AF8","AF8_PROJET") When( .F. ) Valid (VldIncAgd()) SIZE 40,09 OF oDlg PIXEL
		@ nLinha-10, nColuna SAY "Revisao Atual" SIZE 040, 019 OF oDlg PIXEL

		nLinha += 015
		oAtivid := TCBrowse():New( nLinha ,nColuna , 170, 50,,,, oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,,)
		oAtivid:AddColumn(TCColumn():New("Código"        , {|| aAtivid[oAtivid:nAt,01]} ,"@D"    ,,,"LEFT"  , nJanLarg/4*0.10,.F.,.F.,,{|| .F. },,.F.,) )
		oAtivid:AddColumn(TCColumn():New("Nome"          , {|| aAtivid[oAtivid:nAt,02]} ,"@!"    ,,,"LEFT"  , nJanLarg/4*0.15,.F.,.F.,,         ,,.F.,) )
		oAtivid:SetArray(aAtivid)

		oAtivid:bLDblClick := {|| VldIncAgd("EXCLUIRATIVIDADE") }
		oAtivid:bRClicked  := {||  }
	EndIf

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| (If( !(cOperac $ "VISUALIZAR") , if( TudoOk(), (GrvAgenda(),oDlg:End()) ,.T. ) ,oDlg:End())) } ,{||oDlg:End()}) CENTERED
Return

/*/{Protheus.doc} VldIncAgd
    Validacoes de campos na Inclusão e Alteração de Agenda
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
/*/
Static Function VldIncAgd(cReadVar)
	Local lRet       := .T.
	Local nI         := Nil
	Local aBkp       := {}
	Default cReadVar := ReadVar()

	If cReadVar == "CCODPRJ"
		AF8->(DbSetOrder(1))
		If AF8->(DbSeek(xfilial("AF8")+cCodPrj))
			If !AF8->AF8_FASE $ ('01','02','03')
				MsgStop('A fase atual do projeto não permite marcação de agendas.', 'Atenção')
				lRet := .F.
			ElseIf empty(AF8->AF8_CODCFP)
				MsgStop('O codigo CFP nao esta informado no cadastro do projeto. Informe para incluir a agenda.', 'Atenção')
				lRet := .F.
			ElseIf empty(Replace(AF8->AF8_XTRANS,":",""))
				MsgStop('O translado nao esta informado no cadastro do projeto. Informe para incluir a agenda.', 'Atenção')
				lRet := .F.
			Else
				cDesPrj   := AF8->AF8_DESCRI
				cHrIni    := "08:00"
				cHrFim    := "18:00"
				cClient   := AF8->AF8_CLIENT
				cLoja     := AF8->AF8_LOJA
				cHrTransl := AF8->AF8_XTRANS

				If ValType(oBtnAltCtt) == "O"
					If !Empty(AllTrim(cCodPrj)) .and. !Empty(AllTrim(cClient))
						oBtnAltCtt:Enable()
					Else
						oBtnAltCtt:Disable()
					EndIf
				EndIf
			Endif

			// carregar os contatos na grid de contatos da agenda.
			// Edson Sales *** 31/12/2025
			ZP8->(DbSetOrder(1))
			If ZP8->(DbSeek(xFilial("ZP8")+cCodPrj))
				while !ZP8->(Eof()) .and. AllTrim(cCodPrj) == AllTrim(ZP8->ZP8_CODPRO)
					if empty(aContatos[1,1])
						aContatos := {}
					endif
					aAdd(aContatos,{ZP8->ZP8_ORDEM,ZP8->ZP8_GRUPO,ZP8->ZP8_NOME,ZP8->ZP8_EMAIL})
					ZP8->(dbSkip())
				Enddo

				if !empty(aContatos[1,1])					
				ASort(aContatos,,, {|a,b| ;
					IIf( a[2] == b[2], ;        // Mesmo GRUPO?
							a[1] < b[1], ;         // Ordena pela ORDEM
							a[2] < b[2] ) })       // Senão, ordena pelo GRUPO
					oContatos:SetArray(aContatos)
					oContatos:Refresh()
				Else
					MsgStop('Não Há contatos vinculados no projeto, verifique o cadastro (Projeto x Entidade)', 'Atenção')
					lRet := .F.
				EndIf

			EndIf

		Else
			MsgStop('Projeto não cadastrado. Informe um código válido.', 'Atenção')
			lRet := .F.
		EndIf
	ElseIf cReadVar $ "CHRINI,CHRFIM"
		If val(replace(cHrIni,":","")) > val(replace(cHrFim,":",""))
			MsgStop('O horário inicial não pode ser maior que o horário final.', 'Atenção')
			lRet := .F.
		ElseIf (val(left(cHrIni,2)) > 23 .or. val(left(cHrIni,2)) < 0) .or. (val(right(cHrIni,2)) > 60 .or. val(right(cHrIni,2)) < 0)
			lRet := .F.
		ElseIf (val(left(cHrFim,2)) > 23 .or. val(left(cHrFim,2)) < 0) .or. (val(right(cHrFim,2)) > 60 .or. val(right(cHrFim,2)) < 0)
			lRet := .F.
		EndIf
	ElseIf cReadVar == "CHRTRANSL"
		If (val(left(cHrTransl,2)) > 23 .or. val(left(cHrTransl,2)) < 0) .or. (val(right(cHrTransl,2)) > 60 .or. val(right(cHrTransl,2)) < 0)
			lRet := .F.
		EndIf
	ElseIf cReadVar == "CLOCATEN"
		ZCQ->(DbSetOrder(1))
		If !ZCQ->(DbSeek(xfilial("ZCQ")+cClient+cLoja+cLocAten)) .AND. cLocAten <> "001"
			MsgStop('O local informado não está vinculado ao cliente do projeto selecionado.', 'Atenção')
			lRet := .F.
		Else
			If ZCQ->ZCQ_IDSEQ == "001"
				cHrTransl := "00:00"
			EndIf
		EndIf
	ElseIf cReadVar == "CRECURSO"
		SA9->(DbSetOrder(1))
		If SA9->(DbSeek(xFilial("SA9")+cRecurso)) .and. SA9->A9_ATIVO <> "C"
			If !empty(SA9->A9_XPROD)
				If Ascan(aRecurso,{|x| x[1] == cRecurso}) == 0
					if empty(aRecurso[1,1])
						aRecurso := {}
					endif
					aAdd(aRecurso,{SA9->A9_TECNICO,SA9->A9_NOME,SA9->A9_XPROD})
					oRecurso:SetArray(aRecurso)
					oRecurso:Refresh()
				EndIF
			Else
				MsgStop('Informe o produto no cadastro do Recurso.', 'Atenção')
				lRet := .F.
			EndIf
		Else
			MsgStop('Recurso não cadastrado ou recurso bloqueado. Informe um código válido.', 'Atenção')
			lRet := .F.
		EndIf
	ElseIf cReadVar == "EXCLUIRECURSO" .and. !empty(aRecurso[1,1]) .and. MsgYesNo('Deseja excluir este recurso?', "Atenção")
		aBkp := aRecurso
		aRecurso := {{"","",""}}
		For nI := 1 to len(aBkp)
			If nI <> oRecurso:nAt
				if empty(aRecurso[1,1])
					aRecurso := {}
				endif
				aAdd(aRecurso,{aBkp[nI,1],aBkp[nI,2],aBkp[nI,3]})
			EndIf
		Next nI
		oRecurso:SetArray(aRecurso)
		oRecurso:Refresh()

		// Exclusão do contato na grid
		// Edson *** 31/12/2025
	ElseIf cReadVar == "EXCLUIRCONTATO" .and. !empty(aContatos[1,1]) .and. MsgYesNo('Deseja excluir este contato?', "Atenção")
		aBkp := aContatos
		aContatos := {{"","","",""}}
		For nI := 1 to len(aBkp)
			If nI <> oContatos:nAt
				if empty(aContatos[1,1])
					aContatos := {}
				endif
				aAdd(aContatos,{aBkp[nI,1],aBkp[nI,2],aBkp[nI,3],aBkp[nI,4]})
			EndIf
		Next nI		
		ASort(aContatos,,, {|a,b| ;
		IIf( a[2] == b[2], ;        // Mesmo GRUPO?
			a[1] < b[1], ;         // Ordena pela ORDEM
			a[2] < b[2] ) })       // Senão, ordena pelo GRUPO
		oContatos:SetArray(aContatos)
		oContatos:Refresh()
	ElseIf cReadVar == "CNEWPRJ"
		AF8->(DbSetOrder(1))

		AF8->(DbSeek(xfilial("AF8")+cCodPrj))
		aAdd(aBkp,AF8->AF8_CLIENT)

		If AF8->(DbSeek(xfilial("AF8")+cNewPrj))
			If !AF8->AF8_FASE $ ('01','02','03')
				MsgStop('A fase atual do projeto não permite marcação de agendas.', 'Atenção')
				lRet := .F.
			ElseIf empty(AF8->AF8_CODCFP)
				MsgStop('O codigo CFP nao esta informado no cadastro do projeto. Informe para incluir a agenda.', 'Atenção')
				lRet := .F.
			ElseIf AF8->AF8_CLIENT <> aBkp[1]
				MsgStop('O projeto deve pertencer ao cliente informado na agenda', 'Atenção')
				lRet := .F.
			Else
				cNewDPr := AF8->AF8_DESCRI
				cRevPrj := AF8->AF8_REVISA
				cAtivid := Space(TamSx3("AFC_EDT")[1])
				aAtivid := {{"","",""}}
				oAtivid:SetArray(aAtivid)
			Endif
		Else
			MsgStop('Projeto não cadastrado. Informe um código válido.', 'Atenção')
			lRet := .F.
		EndIf
	ElseIf cReadVar == "CATIVID"
		AF9->(DbSetOrder(1))
		If AF9->(DbSeek(xFilial("AF9")+cNewPrj+cRevPrj+cAtivid))
			If Ascan(aAtivid,{|x| x[1] == cAtivid}) == 0
				if empty(aAtivid[1,1])
					aAtivid := {}
				endif
				aAdd(aAtivid,{AF9->AF9_TAREFA,AF9->AF9_DESCRI})
				oAtivid:SetArray(aAtivid)
				oAtivid:Refresh()
			EndIF
		Else
			MsgStop('Atividade não cadastrada. Informe um código válido.', 'Atenção')
			lRet := .F.
		EndIf
	ElseIf cReadVar == "EXCLUIRATIVIDADE" .and. !empty(aAtivid[1,1]) .and. MsgYesNo('Deseja excluir esta atividade?', "Atenção")
		aBkp := aAtivid
		aAtivid := {{"","",""}}
		For nI := 1 to len(aBkp)
			If nI <> oAtivid:nAt
				if empty(aAtivid[1,1])
					aAtivid := {}
				endif
				aAdd(aAtivid,{aBkp[nI,1],aBkp[nI,2],aBkp[nI,3]})
			EndIf
		Next nI
		oAtivid:SetArray(aAtivid)
		oAtivid:Refresh()
	EndIf

Return lRet

/*/{Protheus.doc} TrocaProduto
    Troca o Produto referente ao recurso selecionado
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
/*/
Static Function TrocaProduto()
	Local cProduto   := aRecurso[oRecurso:nAt,03]
	Local cRet       := aRecurso[oRecurso:nAt,03]

	SB1->(DbSetOrder(1))

	DEFINE MSDIALOG oExecFunc FROM  140,000 TO 250,200 TITLE "Informe o Produto" PIXEL
	@ 05,05 TO 38,100 LABEL "Informe o código do produto." OF oExecFunc PIXEL

	oGet1      := TGet():New( 015,008,{|u| If(PCount()>0,cProduto:=u,cProduto)},oExecFunc,090,013,'',;
		{||SB1->(DbSeek(xFilial("SB1")+cProduto))},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cProduto",,)
	oGet1:cF3 := "SB1"

	oBtn1      := TButton():New( 042,008,"Confirmar",oExecFunc,{|| cRet:=cProduto,oExecFunc:End()},030,010,,,,.T.,,"",,,,.F. )

	ACTIVATE MSDIALOG oExecFunc CENTERED ON INIT()

	aRecurso[oRecurso:nAt,03] := cRet
	oRecurso:Refresh()

Return cRet

/*/{Protheus.doc} TudoOk
    Validacoes confirmação na Inclusão e Alteração de Agenda
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
    */
Static Function TudoOk()
    Local lRet := .T.
    Local nI   := Nil
    
    If cOperac == "EXCLUIR"
        return lRet
    EndIf

    if cOperac <> "EXCLUIR" .and. (empty(cCodPrj) .or. empty(cDesPrj).or. empty(cClient) .or. empty(cLoja) .or. empty(cHrIni) .or. empty(cHrFim) .or. empty(cLocAten) .or. empty(cAtivi) .or. empty(aRecurso[1,1]))
        MsgStop('Todos os campos são obrigatórios.', 'Atenção')
       lRet := .F.
        return lRet
    endif

    SZ1->(DbSetOrder(2))
    For nI := 1 to len(aRecurso)
        If SZ1->(DbSeek(xFilial("SZ1")+dtos(dDtAgend)+aRecurso[nI,1]))
            While !SZ1->(EOF()) .AND.SZ1->Z1_TECNICO == cRecurso .and. SZ1->Z1_DATA == dDtAgend
                If SZ1->Z1_CLIENTE == cClient .and. (SZ1->Z1_AGHRINI >= cHrIni .or. (SZ1->Z1_AGHRFIM == cHrFim .and. SZ1->Z1_AGHRINI == cHrIni)) .and. SZ1->(Recno()) <> nRecnoId
                    MsgStop('Já existe agendamento para o cliente e recurso na data e horário informados.', 'Atenção')
                    lRet := .F.
                    exit
                EndIf
                SZ1->(DbSkip())
            Enddo
        EndIf
    Next nI
Return lRet

/*/{Protheus.doc} GrvAgenda
    Grava o agendamento na tabela SZP
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
/*/
Static Function GrvAgenda()
	Local aRet    := {.T.}
	Local nI      := Nil
	Local cCodAtv := ""

	If cOperac == "ALTPRJ"
		BEGIN TRANSACTION

			//armazena as atividades
			For nI := 1 to len(aAtivid)
				cCodAtv += (aAtivid[ni,1]+",")
			Next nI

			SZ1->(DbSetOrder(1))
			SZ1->(DbGoTo(nRecnoId))

			//somente troca projeto se ainda nao foi confirmada
			If SZ1->Z1_STATUS <> STATUS_CONFIRMADA
				RECLOCK( 'SZ1', .F. )
				SZ1->Z1_PROJETO := cNewPrj
				SZ1->Z1_RECEITA := u_vlrHrAgenda(SZ1->Z1_TECNICO,cNewPrj,SZ1->Z1_CLIENTE, SZ1->Z1_LOJA,SZ1->Z1_DATA,SZ1->Z1_PRODUTO,{},.F.) * SZ1->Z1_CTOTAP
				SZ1->Z1_CUSTO   := u_custoHrAgenda(SZ1->Z1_TECNICO,SZ1->Z1_RECEITA,SZ1->Z1_CTOTAP)
				MSUNLOCK()

				//pendencia - apontar atividades
			EndIf

		END TRANSACTION

	ElseIf cOperac == "ALTPRD"
		For nI := 1 to len(aRecurso)
			SZ1->(DbSetOrder(1))
			SZ1->(DbGoTo(nRecnoId))
			Reclock(SZ1,.F.)
			SZ1->Z1_PRODUTO := aRecurso[nI,3]
			MsUnLock()
		Next nI
	Else
		BEGIN TRANSACTION
			For nI := 1 to len(aRecurso)
				//grava agenda
				aRet := u_recAgenda(cOperac,aRecurso[nI,1],dDtAgend,cCodPrj,cHrIni,cHrFim,cAtivi,"A",aRecurso[nI,3],nRecnoId,cHrTransl,cLocAten)
				If !aRet[1]
					MsgStop(aRet[2], "Atenção")
					DisarmTransaction()
				EndIf
			Next nI
		END TRANSACTION
	EndIf


	If aRet[1]
		MsgInfo('Operação realizada com sucesso!', 'Cadastro de Agendas')
		MsgRun( "Atualizando agenda...", "Atenção", {|| getAgenda()})
	EndIf
Return aRet[1]

/*/{Protheus.doc} ConfAgend
    Atualiza o status da agenda para confirmada.
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
/*/
Static Function ConfAgend()

	if !(empty(aBrowse[oBrowse:nAt,15]) .or. aBrowse[oBrowse:nAt,15] == STATUS_AGENDAMENTO)
		MsgStop("O status da agenda não permite confirmação do agendamento!", "Atenção")
		return
	endif

	SZ1->(DbSetOrder(1))
	SZ1->(DbGoto(aBrowse[oBrowse:nAt,16]))
	If SZ1->(RECNO()) == aBrowse[oBrowse:nAt,16]
		Reclock("SZ1",.F.)
		SZ1->Z1_STATUS := STATUS_AGENDAMENTO
		MsUnlock()
	EndIf

	MsgInfo("Agendamento confirmado com sucesso!", 'Atenção')

	MsgRun( "Atualizando agenda...", "Atenção", {|| getAgenda()})
Return

/*/{Protheus.doc} EnviaEmail
    Envia email com o agendamento para confirmação
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
/*/
Static Function EnviaEmail()
	Local cExecute := "/c ipm.note /m "
	Local cAlias   := GetNextAlias()
	Local aAgendas := {}
	Local nI       := Nil
	Local cLocal   := ""

	if !(empty(aBrowse[oBrowse:nAt,15]) .or. aBrowse[oBrowse:nAt,15] == STATUS_PENDENTE_ENTREGA .or. aBrowse[oBrowse:nAt,15] == STATUS_CONFIRMADA)
		MsgStop("O status da agenda não permite envio do email!", "Atenção")
		return
	endif

	SZ1->(DbSetOrder(1))

	SA1->(DbSetOrder(1))
	If !SA1->(DbSeek(xFilial("SA1")+aBrowse[oBrowse:nAt,04]+aBrowse[oBrowse:nAt,05]))
		MsgInfo('Cliente não encontrado.', 'Atenção')
	ElseIf empty(SA1->A1_EMAIL)
		MsgInfo('Não existe e-mail informado no cadastro do cliente. Revise o cadastro.', 'Atenção')
	EndIf

	cAssunto  := "Confirmação de Agenda %0D%0A"
	cMensagem := 'Olá! Tudo bem?! %0D%0A'+"%0D%0A"
	cMensagem += "Podemos confirmar a agenda abaixo? %0D%0A"+"%0D%0A"

	If MsgYesNo('Deseja enviar todas as agendas pendentes de envio do cliente posicionado?', 'Atenção')
		cQry := " SELECT SZ1.R_E_C_N_O_ AS R_E_C_N_O_ FROM " + RetSqlName("SZ1") + " SZ1 (NOLOCK) "
		cQry += "	WHERE "
		cQry += "	SZ1.D_E_L_E_T_ = '' AND Z1_CLIENTE = '"+SA1->A1_COD+"' AND Z1_STATUS IN ('','"+STATUS_AGENDAMENTO+"')"

		DBUseArea(.T., "TOPCONN", TCGenQry(NIL,NIL,cQry), (cAlias) , .F., .T. )
		While !(cAlias)->(EOF())
			SZ1->(DbGoTo( (cAlias)->R_E_C_N_O_ ))

			cLocal := if(SZ1->Z1_AGLOCAL  == "001","Remoto",;
				Posicione("ZCQ",1,xFilial("ZCQ")+SZ1->(Z1_CLIENTE+Z1_LOJA+Z1_AGLOCAL),"ZCQ_END"))

			cMensagem += "Consultor: "   +Posicione("SA9",1,xFilial("SA9")+SZ1->Z1_TECNICO,"A9_NOME") +"%0D%0A"
			cMensagem += "Data: "        +dtoc(SZ1->Z1_DATA)+"%0D%0A"
			cMensagem += "Hora Início:  "+SZ1->Z1_AGHRINI   +"%0D%0A"
			cMensagem += "Hora Término: "+SZ1->Z1_AGHRFIM   +"%0D%0A"
			cMensagem += "Local: "       +cLocal            +"%0D%0A"
			cMensagem += "Atividade: "   +SZ1->Z1_AGTEXTO   +"%0D%0A"+"%0D%0A"+"%0D%0A"

			aAdd(aAgendas,SZ1->(RECNO()))

			(cAlias)->(DbSkip())
		Enddo
		(cAlias)->(DbCloseArea())

	Else
		SZ1->(DbGoto(aBrowse[oBrowse:nAt,16]))

		cLocal := if(SZ1->Z1_AGLOCAL == "001","Remoto",;
			Posicione("ZCQ",1,xFilial("ZCQ")+aBrowse[oBrowse:nAt,04]+aBrowse[oBrowse:nAt,05]+aBrowse[oBrowse:nAt,17],"ZCQ_END"))

		aAdd(aAgendas,aBrowse[oBrowse:nAt,16])
		cMensagem += "Consultor: "   +aBrowse[oBrowse:nAt,10]      +"%0D%0A"
		cMensagem += "Data: "        +dtoc(aBrowse[oBrowse:nAt,02])+"%0D%0A"
		cMensagem += "Hora Início:  "+aBrowse[oBrowse:nAt,08]      +"%0D%0A"
		cMensagem += "Hora Término: "+aBrowse[oBrowse:nAt,09]      +"%0D%0A"
		cMensagem += "Local: "       +cLocal                       +"%0D%0A"
		cMensagem += "Atividade: "   +aBrowse[oBrowse:nAt,12]      +"%0D%0A"+"%0D%0A"+"%0D%0A"
	EndIf

	cMensagem += 'Qualquer dúvida, estamos a disposição! %0D%0A'

	cExecute += '"'+rtrim(SA1->A1_EMAIL)
	cExecute += '?subject='+'Confirmacao de Agendamento'
	cExecute += '&body='+cMensagem+'"'

	ShellExecute("OPEN", "outlook.exe", cExecute, "", 1)

	SZ1->(DbSetOrder(2))
	For nI := 1 to len(aAgendas)
		SZ1->(DbGoto(aAgendas[nI]))
		Reclock("SZ1",.F.)
		SZ1->Z1_STATUS := STATUS_AGENDAMENTO
		MsUnlock()
	Next nI

	MsgRun( "Atualizando agenda...", "Atenção", {|| getAgenda()})

Return

/*/{Protheus.doc} TelaConfOs
    Interface para confirmar/estornar o recebimento de uma OS.
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
/*/
Static Function TelaConfOs(lEstorna)
	Local nI       := Nil
	Local cVar     := Nil
	Local cTitulo  := if(lEstorna,'Exclusão de ','')+'Confirmação de Ordem de Serviço'

	Local aTamanho := MsAdvSize() //retorna o tamanho disponivel para uma tela
	Local aButtons := {}
	Local nJanLarg := aTamanho[5] //5 -> Coluna final dialog (janela)
	Local nJanAltu := aTamanho[6] //6 -> Linha final dialog (janela)

	//define posicao das colunas
	Local aHeader  := {" ","Data","Dia", "Cliente", "Loja","Projeto","Hr Início","Hr Fim","Intervalo","Total","Recurso","Os Elet","Descr. Projeto","Local Atend."}
	Local nPosOS   := 12
	Local nPosSel  := 01
	Local nPosLoc  := 14

	Local oOk  := LoadBitmap( GetResources(), "LBOK" )
	Local oNo  := LoadBitmap( GetResources(), "LBNO" )

	//variaveis utilizadas pelo listbox
	Private lMark       := .F.

	Private oDlg        := Nil
	Private oLbx        := Nil
	Private aVetor      := {}
	Private nTotRec     := 0
	Private nTotItens   := 0

	Aadd( aButtons, {"HISTORIC", {|| aVetor[oLbx:nAt,nPosLoc] := TrocaLocal(aVetor[oLbx:nAt,nPosOs],aVetor[oLbx:nAt,nPosLoc])}, "Alterar Local Atendimento...", "Alterar Local Atendimento" , {|| .T.}} )

	SZ1->(DbSetOrder(1))

	//verifica se possui os´s para serem confirmadas
	For nI := 1 to len(aBrowse)
		If (aBrowse[nI,1] == oStEntPend .and. !lEstorna) .or.  (aBrowse[nI,1] == oStEntConf .and. lEstorna)
			If SZ1->(DbSeek(xFilial("SZ1")+aBrowse[nI,14]))
				aAdd(aVetor,{;
					.F.,;
					aBrowse[nI,02],;
					aBrowse[nI,03],;
					aBrowse[nI,04],;
					aBrowse[nI,05],;
					aBrowse[nI,06],;
					aBrowse[nI,08],;
					aBrowse[nI,09],;
					aBrowse[nI,20],;
					aBrowse[nI,19],;
					aBrowse[nI,10],;
					aBrowse[nI,16],;
					aBrowse[nI,07],;
					aBrowse[nI,17],;
					})
			EndIf
		EndIf
	Next nI

	If len(aVetor) == 0
		MsgStop("Não existem os's para serem confirmadas.", 'Atenção')
		return
	EndIf

	DEFINE FONT oFnt3 NAME "Arial" BOLD
	DEFINE FONT oFont NAME "Arial" SIZE 0, -9 BOLD

	DEFINE MSDIALOG oDlgCnfOs TITLE cTitulo  From 5,15 TO nJanAltu,nJanLarg PIXEL

	nAltIni := aTamanho[1]
	nAltFim := nJanAltu/2

	@ 075,05 LISTBOX oLbx VAR cVar FIELDS HEADER aHeader[1],aHeader[2],aHeader[3],aHeader[4],aHeader[5],aHeader[6],aHeader[7],aHeader[8],aHeader[9],aHeader[10],aHeader[11],;
		aHeader[12],aHeader[13],aHeader[14] SIZE nJanLarg/2-05,160 OF oDlgCnfOs PIXEL ON CHANGE VldSelecao() ON dblClick( Seleciona(oLbx:nAt,@aVetor,@oLbx,nPosSel) )

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5],;
		aVetor[oLbx:nAt,6],;
		aVetor[oLbx:nAt,7],;
		aVetor[oLbx:nAt,8],;
		aVetor[oLbx:nAt,9],;
		aVetor[oLbx:nAt,10],;
		aVetor[oLbx:nAt,11],;
		aVetor[oLbx:nAt,12],;
		aVetor[oLbx:nAt,13],;
		aVetor[oLbx:nAt,14]}}

	oPerFim := TGet():New( 240, 005, { | u | If( PCount() == 0, nTotItens, nTotItens:= u ) },oDlgCnfOs,060, 012, "@E 999,999,999.99",,;
		0, 16777215,,.F.,,.T.,,.F.,{||.F.},.F.,.F.,,.F.,.F. ,,"nTotItens",,,,.f.,,,"Qtd. Selecionados",2)


	ACTIVATE MSDIALOG oDlgCnfOs ON INIT EnchoiceBar(oDlgCnfOs,;
		{|| IIf(ValidMarK(aVetor,nPosOS,nPosSel,lEstorna),(oDlgCnfOs:End()), ) },;
		{||oDlgCnfOs:End()},;
		,;
		@aButtons) CENTERED
Return

/*/{Protheus.doc} VldSelecao
    Valida o registro selecionado
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022 
/*/
Static Function VldSelecao()
return(.T.)

/*/{Protheus.doc} Seleciona
    Marca/desmarca o registro posicionado.
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022 
/*/
Static Function Seleciona(nPos,aVetor,oLbx,nPosSel)

	aVetor[nPos][nPosSel] := !aVetor[nPos][nPosSel]

	If aVetor[nPos,nPosSel]
		nTotItens++
	Else
		nTotItens--
	EndIf

	oPerFim:Refresh()
	oLbx:Refresh()

Return

/*/{Protheus.doc} ValidMarK
    Valida os registros confrmados.
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
/*/
Static Function ValidMarK(aVetor,nPosOS,nPosSel,lEstorna)
	Local lRet := .T.

	If Ascan(aVetor,{|x| x[nPosSel] }) == 0
		MsgStop("Selecione ao menos um registro para confirmar.", "ROMANEIO")
		lRet := .F.
	Else
		Msgrun( "Confirmando os's...", 'Aguarde', {||GravaMark(aVetor,nPosOS,lEstorna,nPosSel)} )
	Endif

Return(lRet)

/*/{Protheus.doc} GravaMark
   Grava os registros marcados.
    @type  Function
    @author matheus.vinicius
    @since 26/08/2022
/*/
Static Function GravaMark(aVetor,nPosOS,lEstorna,nPosSel)
	Local i    := Nil
	Local lRet := .T.

	BEGIN TRANSACTION
		For i := 1 to len(aVetor)
			If aVetor[i,nPosSel]
				if !u_ConfirmaOS(aVetor[i,nPosOS],lEstorna)
					DisarmTransaction()
					lRet := .F.
					break
				endif
			EndIF
		Next
	END TRANSACTION

	MsgRun( "Atualizando agenda...", "Atenção", {|| getAgenda()})
Return

/*/{Protheus.doc} ExclApt
   Exclui o apontamento de uma os não confirmada
    @type  Function
    @author matheus.vinicius
    @since 01/11/2022
/*/
Static Function ExclApt(aItem)
	if aItem[1] <> oStEntPend
		MsgStop('O status da agenda não permite a exclusão!', 'Atenção')
		return
	endif

	SZ1->(DbSetOrder(1))
	SZ1->(DbGoTo(aItem[16]))

	Reclock("SZ1",.F.)
	SZ1->Z1_STATUS := .F.
	MsUnlock()

	//excluir apontamento por atividdade

	MsgInfo('Operação realizada com sucesso!', 'Exclusão de Apontamento')
	MsgRun( "Atualizando agenda...", "Atenção", {|| getAgenda()})

Return

/*/{Protheus.doc} fSalvExc
   Gera arquivo excel
    @type  Function
    @author matheus.vinicius
    @since 03/01/2023
/*/
Static Function fSalvExc(aLog)
	Local cFileName       := "IFATA01-"+Dtos(MSDate())+"-"+StrTran(Time(),":","")
	Local cPathInServer   := GetTempPath()+cFileName+".xls"
	Local nI := Nil

	cGuia   := "Log IFATA01"
	cTabela := cGuia+" Periodo: "+MV_PAR01

	oFWMsExcel := FWMSExcel():New()
	oFWMsExcel:AddworkSheet(cGuia)
	oFWMsExcel:AddTable(cGuia,cTabela)

	oFWMsExcel:AddColumn(cGuia,cTabela,"Erros",1,1) //1 = Modo Texto

	For nI := 1 to len(aLog)
		oFWMsExcel:AddRow(cGuia,cTabela,{aLog[nI]})
	Next nI

	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cPathInServer)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open(cPathInServer)
	oExcel:SetVisible(.T.)
	oExcel:Destroy()

Return

/*/{Protheus.doc} SendWahts
   Monta texto a ser enviado para o whatsapp
    @type  Function
    @author matheus.vinicius
    @since 03/01/2023
/*/
Static Function SendWahts()
	Local cText     := ""
	Local cRecAtual := ""
	Local nI        := Nil
	Local aAgenda   := aBrowse

	if empty(aBrowse)
		MsgStop('Não foram encontradas agendas. Utilize a opção carregar.', 'Atenção')
		return
	endif

	aAgenda := ASORT( aAgenda,,, {|x,y| x[10]+dtos(x[2])+x[8] < y[10]+dtos(y[2])+y[8] } )

	SA9->(DbSetOrder(1))

	For nI := 1 to len(aAgenda)
		if cRecAtual <> aAgenda[nI,13]
			If SA9->(DbSeek(xFilial("SA9")+cRecAtual)) .and. !empty(cText)
				TelaWhats(cText,"55"+Rtrim(SA9->A9_TELCONT))
			EndIf
			cRecAtual := aAgenda[nI,13]
			cText := ""
		endif

		cText += "%0a"+dtoc(aAgenda[nI,2])+"%0a"
		cText += "Projeto: "+RTRIM(aAgenda[nI,7])+"%0a"
		cText += aAgenda[nI,8]+"-"+aAgenda[nI,9]+"%0a"
		cText += if(aAgenda[nI,17] == "000",'presencial','remoto')+"%0a"
		cText += 'Atividade: '+FwNoAccent(aAgenda[nI,12])+"%0a"

		if !empty(cText) .and. nI == len(aAgenda)
			If SA9->(DbSeek(xFilial("SA9")+aAgenda[nI,13])) .and. !empty(cText)
				TelaWhats(cText,"55"+Rtrim(SA9->A9_TELCONT))
			EndIf
		endif
	Next nI

Return

/*/{Protheus.doc} TelaWahts
   Exibe interface para envio de agenda pelo whatsapp
    @type  Function
    @author matheus.vinicius
    @since 03/01/2023
/*/
Static Function TelaWhats(cTexto,cPhone)
	DEFINE DIALOG oDlg TITLE "Envio de Agenda - "+SA9->A9_NOME FROM 180,180 TO 550,700 PIXEL

	// Prepara o conector WebSocket
	PRIVATE oWebChannel := TWebChannel():New()
	nPort := oWebChannel:connect()

	// Cria componente
	PRIVATE oWebEngine := TWebEngine():New(oDlg, 0, 0, 100, 100,, nPort)
	oWebEngine:bLoadFinished := {|self,url| conout("Termino da carga do pagina: " + url) }
	oWebEngine:navigate("https://wa.me/"+cPhone+"?text="+"Olá! Gostaria de confirmar as agendas abaixo: %0a "+cTexto)
	oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT

	ACTIVATE DIALOG oDlg CENTERED
Return

/*/{Protheus.doc} TrocaLocal
    Troca local de atendimento na tela de confirmacao de OS
    @type  Function
    @author matheus.vinicius
    @since 02/02/2023
/*/
Static Function TrocaLocal(cOsElet,cLocalAtend)
	Local nOpc := 0

	SZ1->(dBSetOrder(1))
	If SZ1->(DbSeek(xFilial("SZ1")+cOsElet))
		If AF8->(DbSeek(xFilial("AF8")+SZ1->Z1_PROJETO))

			DEFINE MSDIALOG oTelaLocal FROM  140,000 TO 250,200 TITLE "Local de atendimento" PIXEL
			@ 05,05 TO 38,100 LABEL "Informe o local de atendimento." OF oTelaLocal PIXEL

			oGet1      := TGet():New( 015,008,{|u| If(PCount()>0,cLocalAtend:=u,cLocalAtend)},oTelaLocal,090,013,'',;
				{|| ZCQ->(DbSeek(xfilial("ZCQ")+SZ1->(Z1_CLIENTE+Z1_LOJA)+cLocalAtend))  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLocalAtend",,)

			oBtn1      := TButton():New( 042,008,"Executar",oTelaLocal,{|| IIF(!Empty(cLocalAtend),(nOpc:=1,oTelaLocal:End()),;
				MsgStop("Informe o local de atendimento!","Atencao"))},030,010,,,,.T.,,"",,,,.F. )

			oBtn2      := TButton():New( 042,050,"Cancelar",oTelaLocal,{|| oTelaLocal:End()},030,010,,,;
				,.T.,,"",,,,.F. )

			ACTIVATE MSDIALOG oTelaLocal CENTERED ON INIT()

			If nOpc == 1
				RecLock('SZ1', .F.)
				SZ1->Z1_APLOCAL := cLocalAtend
				If cLocalAtend == "001"
					SZ1->Z1_APTRANS := "00:00"
				Else
					SZ1->Z1_APTRANS := AF8->AF8_XTRANS
				EndIf
				MsUnlock()
			EndIf
		EndIf
	Else
		MsgStop('Os nao encontrada, nao sera possivel trocar o translado.', 'atencao')
	EndIf

Return cLocalAtend

/*/{Protheus.doc} ImprimirOS
    Imprime a os posicionada
    @type  Static Function
    @author matheus.vinicius
    @since 07/06/2023
/*/
Static Function ImprimirOS()
	Local cOrigem := ""
	if aBrowse[oBrowse:nAt,01] <> oStEntPend .and. aBrowse[oBrowse:nAt,01] <> oStEntConf
		MsgStop('O status da agenda não permite a impressão!', 'Atenção')
		return
	endif

	MSGRUN( 'Imprimindo os...', 'ITVSA010', {|| cOrigem := u_ITFATR04(aBrowse[oBrowse:nAt,14])} )

	if !empty(cOrigem)
		CpyS2T(cOrigem, "C:\TEMP" )
	endif
Return

/*/{Protheus.doc} AltText
    Altera Texto Os Apontada
    @type  Static Function
    @author matheus.vinicius
    @since 03/07/2023
/*/
Static Function AltText(aItem)
	Local aTamanho  := MsAdvSize()
	Local nJanLarg  := aTamanho[5]/2.5
	Local nJanAltu  := aTamanho[6]/2.5
	Local nAltFim   := nJanAltu/2
	Local nTamBtn   := 50
	Local lConfirm  := .F.
	Local cTextOs   := ""

	if aItem[1] <> oStEntPend
		MsgStop('O status da agenda não permite a exclusão!', 'Atenção')
		return
	endif

	SZ1->(DbSetOrder(1))
	SZ1->(DbGoTo(aItem[16]))

	cTextOs := SZ1->Z1_APTEXTO

	DEFINE MsDialog oDlgTexto TITLE "Texto Os Apontada" FROM 000,000 TO nJanAltu,nJanLarg PIXEL

	oTMultiget1 := tMultiget():new(01,01,{| u | if( pCount() > 0, cTextOs := u, cTextOs )},oDlgTexto,nJanlarg*0.50,nAltFim*0.85,,,,,,.T.)

	@nAltFim*0.88, (nJanLarg/2)-((nTamBtn*1)+03) BUTTON oBtnConf PROMPT "Confirmar" SIZE nTamBtn, 013 OF oDlgTexto PIXEL ACTION (lConfirm := .T., oDlgTexto:End())

	ACTIVATE MsDialog oDlgTexto CENTERED

	If lConfirm
		RECLOCK( 'SZ1', .F. )
		SZ1->Z1_APTEXTO := cTextOs
		MSUNLOCK()
	EndIf

Return


Static Function _AgendaBuildQuery_ZP8(cCodPrj, cA1Cod, cA1Loja)
	Local cLike := IIf( Empty(cA1Loja), AllTrim(cA1Cod) + " %", AllTrim(cA1Cod) + " " + AllTrim(cA1Loja) + "%" )
	Local cSub  := ""
	Local cSQL  := ""

	cSub := ;
		"SELECT (RTRIM(ZP8_A1COD)+' '+RTRIM(ZP8_A1LOJA)) AS CODENT, " + ;
		"       ZP8_CONTID, MAX(ISNULL(ZP8_GRUPO,0)) AS GRUPO " + ;
		"  FROM " + RetSqlName('ZP8') + " WITH (NOLOCK) " + ;
		" WHERE D_E_L_E_T_ IN ('',' ') " + ;
		"   AND ZP8_CODPRO = '" + AllTrim(cCodPrj) + "' " + ;
		" GROUP BY (RTRIM(ZP8_A1COD)+' '+RTRIM(ZP8_A1LOJA)), ZP8_CONTID "

	// Principal: AC8 (entidade/contato do cliente) + SU5 (dados do contato) + ZV (grupo)
	cSQL := ;
		"SELECT " + ;
		"  ISNULL(SU5.U5_CONTAT,'') AS NOME, " + ;
		"  ISNULL(SU5.U5_EMAIL,'')  AS EMAIL, " + ;
		"  ISNULL(ZV.GRUPO,0)       AS GRUPO " + ;
		"FROM " + RetSqlName('AC8') + " AC8 WITH (NOLOCK) " + ;
		"LEFT JOIN ( " + cSub + " ) ZV " + ;
		"       ON ZV.CODENT     = AC8.AC8_CODENT " + ;
		"      AND ZV.ZP8_CONTID = AC8.AC8_CODCON " + ;
		"LEFT JOIN " + RetSqlName('SU5') + " SU5 WITH (NOLOCK) " + ;
		"       ON SU5.D_E_L_E_T_ IN ('',' ') " + ;
		"      AND SU5.U5_CODCONT = AC8.AC8_CODCON " + ;
		"WHERE AC8.D_E_L_E_T_ IN ('',' ') " + ;
		"  AND AC8.AC8_ENTIDA = 'SA1' " + ;
		"  AND AC8.AC8_CODENT LIKE '" + cLike + "' " + ;
		"ORDER BY SU5.U5_CONTAT"

Return cSQL

Static Function _AgendaFetchList_ZP8(cCodPrj, cA1Cod, cA1Loja)
	Local aRet := {}
	Local cQry := _AgendaBuildQuery_ZP8(cCodPrj, cA1Cod, cA1Loja)
	Local cAl  := MpSysOpenQuery(cQry)

	If !Empty(cAl) .and. Select(cAl)>0 .and. (cAl)->(Used())
		(cAl)->(DbGoTop())
		Do While !(cAl)->(EoF())
			AAdd(aRet, { ;
				AllTrim((cAl)->NOME ), ; // 1 Nome
			AllTrim((cAl)->EMAIL), ; // 2 Email
			Val(cValToChar((cAl)->GRUPO)) ; // 3 Grupo
			})
			(cAl)->(DbSkip())
		EndDo
		(cAl)->(DbCloseArea())
	EndIf
Return aRet

Static Function AGENDA_CONTATOS_DLG_READ(cCodPrj, cA1Cod, cA1Loja)
	Local aDados := _AgendaFetchList_ZP8(cCodPrj, cA1Cod, cA1Loja)
	Local oDlg   := Nil
	Local oGrid  := Nil
	Local lEmpty := ( Len(aDados) == 0 )

	DEFINE MSDIALOG oDlg TITLE "Contatos do Projeto" FROM 2,10 TO 26,120 PIXEL
	@ 006,010 SAY "Projeto:"      OF oDlg
	@ 006,090 SAY AllTrim(cCodPrj) OF oDlg
	@ 016,010 SAY "Cliente/Loja:" OF oDlg
	@ 016,090 SAY AllTrim(cA1Cod)+" "+AllTrim(cA1Loja) OF oDlg

	// Mensagem amigável quando não há dados
	If lEmpty
		@ 030,010 SAY "Nenhum contato encontrado para este Projeto/Cliente." OF oDlg
	EndIf

	// Grid com colunas seguras para array vazio
	oGrid := TCBrowse():New( 050,010, 170,560,,,, oDlg )
	oGrid:SetArray( aDados )

	oGrid:AddColumn( TCColumn():New("Nome", ;
		{|| IIf( (Len(aDados) >= oGrid:nAt) .and. (oGrid:nAt > 0), ;
		aDados[oGrid:nAt,1], "" ) } ) )

	oGrid:AddColumn( TCColumn():New("E-mail", ;
		{|| IIf( (Len(aDados) >= oGrid:nAt) .and. (oGrid:nAt > 0), ;
		aDados[oGrid:nAt,2], "" ) } ) )

	oGrid:AddColumn( TCColumn():New("Grupo", ;
		{|| IIf( (Len(aDados) >= oGrid:nAt) .and. (oGrid:nAt > 0), ;
		aDados[oGrid:nAt,3], 0 ) } ) )

	ACTIVATE MSDIALOG oDlg CENTERED
Return .T.
