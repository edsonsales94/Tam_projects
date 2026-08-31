//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "RWMAKE.CH"
// #INCLUDE 'AGRAXFUN.CH'

//Constantes
#Define MAX_BUFFER     22     //Máximo de caracter por linha (buffer)
#Define MSECONDS_WAIT  5000   //Tempo de espera

//Variáveis Estáticas
Static cTitulo := "Integração Balança"

/*/{Protheus.doc} ETINTBA
Função para integração com a balança MVC modelo 1
@author Edson Sales  
@since 17/02/2026
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_ETINTBA()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/

User Function ETINTBA()
	Local aArea   := GetArea()
	Local oBrowse
	Local aSeek := {}

	aAdd(aSeek,{GetSX3Cache('Z3_NFISCAL',"X3_TITULO"), {{"", GetSX3Cache('Z3_NFISCAL', "X3_TIPO"), GetSX3Cache('Z3_NFISCAL', "X3_TAMANHO"), GetSX3Cache('Z3_NFISCAL', "X3_DECIMAL"), AllTrim(GetSX3Cache('Z3_NFISCAL', "X3_TITULO")), AllTrim(GetSX3Cache('Z3_NFISCAL', "X3_PICTURE")),1}} } )
	aAdd(aSeek,{GetSX3Cache('Z3_XPLACA', "X3_TITULO"), {{"", GetSX3Cache('Z3_XPLACA', "X3_TIPO"), GetSX3Cache('Z3_XPLACA', "X3_TAMANHO"), GetSX3Cache('Z3_XPLACA', "X3_DECIMAL"), AllTrim(GetSX3Cache('Z3_XPLACA', "X3_TITULO")), AllTrim(GetSX3Cache('Z3_XPLACA', "X3_PICTURE")),1}} } )
	aAdd(aSeek,{GetSX3Cache('Z3_NPESAG', "X3_TITULO"), {{"", GetSX3Cache('Z3_NPESAG', "X3_TIPO"), GetSX3Cache('Z3_NPESAG', "X3_TAMANHO"), GetSX3Cache('Z3_NPESAG', "X3_DECIMAL"), AllTrim(GetSX3Cache('Z3_NPESAG', "X3_TITULO")), AllTrim(GetSX3Cache('Z3_NPESAG', "X3_PICTURE")),1}} } )
	aAdd(aSeek,{GetSX3Cache('Z3_STATUS', "X3_TITULO"), {{"", GetSX3Cache('Z3_STATUS', "X3_TIPO"), GetSX3Cache('Z3_STATUS', "X3_TAMANHO"), GetSX3Cache('Z3_STATUS', "X3_DECIMAL"), AllTrim(GetSX3Cache('Z3_STATUS', "X3_TITULO")), AllTrim(GetSX3Cache('Z3_STATUS', "X3_PICTURE")),1}} } )
	aAdd(aSeek,{GetSX3Cache('Z3_DATAPES',"X3_TITULO"), {{"", GetSX3Cache('Z3_DATAPES', "X3_TIPO"), GetSX3Cache('Z3_DATAPES', "X3_TAMANHO"), GetSX3Cache('Z3_DATAPES', "X3_DECIMAL"), AllTrim(GetSX3Cache('Z3_DATAPES', "X3_TITULO")), AllTrim(GetSX3Cache('Z3_DATAPES', "X3_PICTURE")),1}} } )

	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()

	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("SZ3")
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetUseCaseFilter(.T.)

	// Pesquisa padrão
	oBrowse:SetSeek(.T.,aSeek)

	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)

	//Legendas
	oBrowse:AddLegend( "SZ3->Z3_STATUS == '1'", "YELLOW",   "Entrada/Saida Em Aberto" )
	oBrowse:AddLegend( "SZ3->Z3_STATUS == '2'", "GREEN",    "Finalizado" )
	oBrowse:AddLegend( "SZ3->Z3_STATUS == '3'", "BLACK",    "Encerrado - residuo" )

	//Ativa a Browse
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Edson Sales                                                  |
 | Data:  17/02/2026                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Nova Pesagem'    ACTION 'VIEWDEF.ETINTBA' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Retorno'         ACTION 'U_ETINTCOP()'    OPERATION 6                      ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'imprimir Ticket' ACTION 'U_ZImpPes()'     OPERATION 6                      ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Legenda'         ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Alterar'         ACTION 'U_ETINTALT()'    OPERATION 6                      ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'         ACTION 'VIEWDEF.ETINTBA' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Visualizar'      ACTION 'VIEWDEF.ETINTBA' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
 
Return aRot

User Function ETINTCOP()

    Private lRetorno := .T.

    if SZ3->Z3_STATUS != '1'
        FwAlertError('Só é possivel efetuar o retorno de uma pesagem Em Aberto.','Error')
        Return
    endif

    FWExecView( ;
        "Copiar registro", ;
        "ETINTBA", ;
        9 )

Return

User Function ETINTALT()

    Private lAltera := .T.

    FWExecView( ;
    "Alterar registro", ;
    "ETINTBA", ;
    MODEL_OPERATION_UPDATE )

Return
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Edson Sales                                                  |
 | Data:  17/02/2026                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()

    Local oModel      := Nil
    Local oStSZ3      := FWFormStruct(1, "SZ3")
    Local aCpoNoCopy  := {}
    // Local bVldPre     := {|oModel| U_FunVldMd(oModel)}
    // Local bVldPos     := {|oModel| U_FunVldMd(oModel)}
    Local bCommit     := {|oModel| u_zM1bCom(oModel)}

   fGatilhoSZ3(oStSZ3)

    oModel := MPFormModel():New( ;
        "ETINTBAM", ;
        /*bVldPre*/, ;
        /*bVldPos*/, ;
        bCommit, ;
        /* bCancel */ )

    oModel:AddFields("FORMSZ3", /* cOwner */, oStSZ3)

    oModel:SetPrimaryKey({ ;
        "Z3_FILIAL", ;
        "Z3_NPESAG", ;
        "Z3_MOVIMEN" })

    oModel:SetDescription("Modelo de Dados do Cadastro " + cTitulo)

    oModel:GetModel("FORMSZ3"):SetDescription( ;
        "Formulário do Cadastro " + cTitulo)

    // Executado quando o modelo é ativado e a tela é aberta
    oModel:SetActivate({|oModel| U_FunActMd(oModel)})

    // Campos que não serão carregados durante a cópia
    AAdd(aCpoNoCopy, "Z3_PESO")
    AAdd(aCpoNoCopy, "Z3_DATAPES")
    AAdd(aCpoNoCopy, "Z3_HRPESO")
    AAdd(aCpoNoCopy, "Z3_PESLIQ")
    AAdd(aCpoNoCopy, "Z3_DIFNF")
    AAdd(aCpoNoCopy, "Z3_DIFPERC")

    oModel:GetModel("FORMSZ3"):SetFldNoCopy(aCpoNoCopy)

Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Edson Sales                                                  |
 | Data:  17/02/2026                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("ETINTBA")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStSZ3 := FWFormStruct(2, "SZ3")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ3_NOME|SZ3_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
      
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SZ3", oStSZ3, "FORMSZ3")
    oView:AddOtherObject("VIEW_CAB", {|oPanel| CABEXT(oPanel)})
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("CAB",10)
    oView:CreateHorizontalBox("FORM",90)

    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SZ3', 'Tela de Pesagem' )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_CAB","CAB")
    oView:SetOwnerView("VIEW_SZ3","FORM")
Return oView
 
/*/{Protheus.doc} zMVC01Leg
Função para mostrar a legenda das rotinas MVC com grupo de produtos
@author Edson Sales  
@since 17/02/2026
@version 1.0
    @example
    u_zMVC01Leg()
/*/
 
User Function zMVC01Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_AMARELO",    "Entrada/Saida Em Aberto"   })
    AADD(aLegenda,{"BR_VERDE",      "Finalizado"                })
    AADD(aLegenda,{"BR_PRETO",      "Encerrado - residuo"       })
     
    BrwLegenda("Grupo de Produtos", "Procedencia", aLegenda)
Return

User Function FunActMd(oModel)

    Local oFormSZ3  := oModel:GetModel("FORMSZ3")
    Local nOperacao := oModel:GetOperation()
    Local lRet      := .T.

    Default lRetorno := .F.

    Do Case

    // A cópia precisa ser testada primeiro
    Case nOperacao == MODEL_OPERATION_INSERT .And. lRetorno

        oFormSZ3:SetValue("Z3_NPESAG", SZ3->Z3_NPESAG)
        oFormSZ3:SetValue("Z3_MOVIMEN", ;
            IIf(SZ3->Z3_MOVIMEN == "S", "E", "S"))
        oFormSZ3:SetValue("Z3_STATUS", "2")

    // Inclusão normal
    Case nOperacao == MODEL_OPERATION_INSERT

        oFormSZ3:SetValue("Z3_STATUS", "1")

    // Alteração
    Case nOperacao == MODEL_OPERATION_UPDATE

        // Regras da alteração

    EndCase

Return lRet


Static Function CABEXT(oPanel)

    Local oView      := FWViewActive()
    Local oModel      := FWModelActive()
    Local oFont8N     := TFONT():New("ARIAL",08,-11,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
    Local OSCRSCO 

    if oModel:GetOperation() > 1
        SetKey(VK_F5, {|| fPesarDT()})
    Endif

    SX3->(DbSetOrder(2))

    oPanel1 := oPanel
    oView:Refresh()

    oBtn  := TButton():New( 007, 007, "Pesar (F5)",oPanel,{|| U_fPesarDT(oModel,oView)}, 50,20,,,.F.,.T.,.F.,,.F.,,,.F. )

    //Cria CSS Defualt para os Botoes
    cCSSBtn1 := " QPushButton {"
    cCSSBtn1 += " background-color: rgb(49, 188, 216);"
    cCSSBtn1 += " border-style: outset; "
    cCSSBtn1 += " border-width: 1px;"
    cCSSBtn1 += " border-color: black;"
    cCSSBtn1 += " border-radius: 10px;"
    cCSSBtn1 += " font-weight: bold;"
    cCSSBtn1 += " }"

    oBtn:setCSS(cCSSBtn1)
    oBtn:Refresh()

Return

/*/
    Descricao: Executa Leitura de Pesos de Entrada Balança DIGITRON
/*/

User Function fPesarDT(oModel,oView)
    Local oFormSZ3 
    Local nOperacao := oModel:GetOperation()
	Local cText   := space(15)
	Local bAcao := {|lFim| xRetPeso(@lFim,@cText,@cPeso) }
	Local cTitulo := 'Lendo Pesagem da Balanca'
	Local cMsg := 'Peso ... '
	Local lAborta   := .T.
	Local lPort     := .F.
	Private nHdll := 0
    Default lRetorno := .F.

    oFormSZ3 := oModel:GetModel("FORMSZ3")
    cTipoMov := oFormSZ3:GetValue("Z3_MOVIMEN")
    if Empty(cTipoMov)
        msgbox("Informe o movimento ENTRADA/SAIDA",,"STOP")
    EndIf

	lPort := MSOpenPort(@nHdll,"COM3:9600,n,8,1")

	cPeso   := space(30)
	nPeso   := 0
	
    lPort := MsRead(nHdll,@cText)
	
    if !lPort
		msgbox("Nao foi possivel pegar informações da porta",,"STOP")
	Else
		nVezes := 0
		nEstab := 0
		cPeso  := "00000"
		Processa( bAcao, cTitulo,cMsg, lAborta )
	Endif

	nPeso := Val(cPeso)
	cPeso := transform(val(cPeso),"@E 999,999,999.99999")

    MsClosePort(nHdll)

    If oModel != Nil
        oFormSZ3 := oModel:GetModel("FORMSZ3")

        // Liberar os campos para gravar.
        // setar como manual para poder alterar os valores
         If oFormSZ3:SetValue("Z3_TIPLEIT", 'M')
        
            oFormSZ3:SetValue("Z3_PESO", nPeso)
            oFormSZ3:SetValue("Z3_PESLIQ", nPeso)
            oFormSZ3:SetValue("Z3_DATAPES", DDATABASE)
            oFormSZ3:SetValue("Z3_HRPESO", TIME())

            if lRetorno
                cMovOrig := IIf(cTipoMov == "S", "E", "S")
                nPesMvOr := Posicione('SZ3',3,xFilial('SZ3')+SZ3->Z3_NPESAG+cMovOrig,'Z3_PESO')

                // calcular a diferença
                if oFormSZ3:GetValue("Z3_OPERAC")=='C'
                 // COLETA SAI VAZIO E VOLTA CHEIO
                 // ENTRADA - SAIDA
                    nDifEntSai := nPesMvOr - oFormSZ3:GetValue("Z3_PESO") 
                else
                    // VENDA SAI CHEIO, E VOLTA COM MENO PESO.
                    // SAIDA - ENTRADA
                    nDifEntSai := nPesMvOr-SZ3->Z3_PESO
                endif

                oFormSZ3:SetValue("Z3_STATUS", '2')
                oFormSZ3:SetValue("Z3_DIFPES", nDifEntSai)
                // nDifPerc := (nDifPesNF / SZ3->Z3_PESO) * 100
                // oFormSZ3:SetValue("Z3_DIFNF", nDifPesNF)
                // oFormSZ3:SetValue("Z3_DIFPERC", nDifPerc)
            else
                oFormSZ3:SetValue("Z3_STATUS", '1')                
            endif
            // voltar para automatico para bloqueia os campos
            oFormSZ3:SetValue("Z3_TIPLEIT", 'A')
            oView:Refresh("VIEW_SZ3")
        Else
            MsgStop("Não foi possível atualizar o campo Z3_PESO.")
        EndIf

    EndIf
    
Return (npeso)

Static Function xRetPeso(lFim,cText,cPeso)
	Local lEnd := .f.

	nVezes := 0
	ProcRegua(10000)
	While !lEnd

		If lFim
			Exit
		EndIf

		MsRead(nHdll,@cText)
		nVezes ++
        // cText  := "D000160.D000160"
		if val(substr(cText,2,at(".",cText)-2)) >= 0 
            cPeso := substr(cText,2,at(".",cText)-2)
            //IncProc(cPeso)
            IncProc("Peso Liquido na Balança: " + transform(val(cPeso),"@E 999,999,999.99999"))
            lFim := .T.
        elseif nVezes >= 50
            msgbox("Nao foi possivel pegar informações do peso da balanca",,"Sem Peso...")
            lFim := .T.
        Endif
	Enddo

Return
User Function zM1bCom(oModel)

    Local aArea    := FWGetArea()
    Local cPesag   := oModel:GetValue("FORMSZ3", "Z3_NPESAG")
    Local cTipoMov := oModel:GetValue("FORMSZ3", "Z3_MOVIMEN")
    Local nOpc     := oModel:GetOperation()
    Local cMovOrig := ""
    Local lRet     := .T.

    Default lRetorno := .F.

    if oModel:GetValue("FORMSZ3", "Z3_PESO") <= 0
        FwAlertWarning('Peso inválido','Atencao !')
        Return .F.
    endif

    // Primeiro grava o novo registro da cópia
    FWFormCommit(oModel)

    // IMPRIMIR TICKET
    if nOpc==MODEL_OPERATION_INSERT .AND. ;
        FWAlertYesNo('Desesa fazer a imprissão do Ticket ?', 'Imprimir ?')
        U_ZImpPes()
    endif

    // Depois finaliza o registro original
    If nOpc == MODEL_OPERATION_INSERT .And. lRetorno


        cMovOrig := IIf(cTipoMov == "S", "E", "S")

        DbSelectArea("SZ3")
        SZ3->(DbSetOrder(3))

        If SZ3->(MsSeek(xFilial("SZ3") + cPesag + cMovOrig))

            RecLock("SZ3", .F.)
                SZ3->Z3_STATUS := "2"
            SZ3->(MsUnlock())

        EndIf
    EndIf

    FWRestArea(aArea)

Return lRet

Static Function fGatilhoSZ3(oStruct)

Local aGatilhos := {}
Local nAtual := 0

 //Adicionando um gatilho, do codigo para data
    aAdd(aGatilhos, FWStruTriggger( ;
        "Z3_PESONF",;                               //Campo Origem
        "Z3_DIFNF",;                                //Campo Destino
        "M->Z3_PESONF-M->Z3_PESO",;                 //Regra de Preenchimento
        .F.,;                                       //Irá Posicionar?
        "",;                                        //Alias de Posicionamento
        0,;                                         //Índice de Posicionamento
        '',;                                        //Chave de Posicionamento
        NIL,;                                       //Condição para execução do gatilho
        "01");                                      //Sequência do gatilho
    )

    aAdd(aGatilhos, FWStruTriggger( ;
        "Z3_PESONF",;                               //Campo Origem
        "Z3_DIFPERC",;                              //Campo Destino
        "((M->Z3_PESONF-M->Z3_PESO)/M->Z3_PESO) * 100",;        //Regra de Preenchimento
        .F.,;                                       //Irá Posicionar?
        "",;                                        //Alias de Posicionamento
        0,;                                         //Índice de Posicionamento
        '',;                                        //Chave de Posicionamento
        NIL,;                                       //Condição para execução do gatilho
        "01");                                      //Sequência do gatilho
    )


    //Percorrendo os gatilhos e adicionando na Struct
    For nAtual := 1 To Len(aGatilhos)
        oStruct:AddTrigger( ;
            aGatilhos[nAtual][01],; //Campo Origem
            aGatilhos[nAtual][02],; //Campo Destino
            aGatilhos[nAtual][03],; //Bloco de código na validação da execução do gatilho
            aGatilhos[nAtual][04];  //Bloco de código de execução do gatilho
        )
    Next

Return
