#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"
#Include "FWMVCDef.ch"

// NOME DO PC PA-ALMOX01
// NOME IMPRESSORA COMPARTILHADA ZD220-203
// CONFIGURAÇÃO LPT1 : net use LPT1: \\PA-ALMOX01\ZD220-203 senha /USER:usuario /PERSISTENT:YES


User Function MCETIQ05()
	// Local aArea := FwGetArea()
	Local lamb := RpcSetEnv('01','01')
	Local aPergs := {}
	Local nLargBtn   := 50
	Local aCampos := {}
	Local oTempTable := Nil
	Local aColunas := {}
	Local cFontPad    := 'Tahoma'
	Local oFontGrid   := TFont():New(cFontPad,,-14)
	//Janela e componentes
	Private oDlgMark
	Private oPanGrid
	Private oMarkBrowse
	Private cAliasTmp := GetNextAlias()
	Private aRotina   := MenuDef()
	//Tamanho da janela
	// Private aTamanho := MsAdvSize()
	// Private nJanLarg := aTamanho[5]
	// Private nJanAltu := aTamanho[6]

	//Objetos e componentes

	Private oFwLayer
	Private oPanTitulo
	Private oPanGrid2
	Private oParam
	Private aTFolder    := { 'Parâmetros', 'Agendamentos'}
	Private aBrowse   := {}
	Private cMrkObj     := "oMrk"
	Private cLmark      := "lMark"
	Private cCliente
	Private dDtIni
	Private dDtFim
	Private lPendApt    := .T.
	Private lPendEnt    := .T.
	Private lEntregue   := .T.

	//Cabeçalho
	Private oSayModulo, cSayModulo := 'Etiquetas COALI'
	Private oSayTitulo, cSayTitulo := 'Nro. Etiqueta Mae;'
	Private oSaySubTit, cSaySubTit := ''

	//Tamanho da janela
	Private aSize    := MsAdvSize(.F.)
	Private nJanLarg := 1600//aSize[5]
	Private nJanAltu := 380//aSize[6]

	//Fontes
	Private cFontUti    := "Tahoma"
	Private oFontMod    := TFont():New(cFontUti, , -38)
	Private oFontSub    := TFont():New(cFontUti, , -20)
	Private oFontSubN   := TFont():New(cFontUti, , -20, , .T.)
	Private oFontBtn    := TFont():New(cFontUti, , -14)
	Private oFontSay    := TFont():New(cFontUti, , -12)
	//Dados
	Private cRecSel := ""

	//DEFINE MSDIALOG  TITLE "Exemplo de Pulo do Gato"  FROM 0, 0 TO nJanAltu, nJanLarg PIXEL
	oDlgMark := TDialog():New(0, 0, nJanAltu, nJanLarg, 'Etiquetas COALI', , , , , CLR_BLACK, RGB(250, 250, 250), , , .T.)

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlgMark,.F.)

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
	oBtnSair   := TButton():New(006, 001, "Fechar", oPanSair, {|| oDlgMark:End()}, nLargBtn, 018, , oFontBtn, , .T., , , , , , )

	//Adiciona as colunas que serão criadas na temporária
	aAdd(aCampos, {  'OK'         ,'C', tamsx3('Z7_OK')[1], tamsx3('Z7_OK')[2]}) //Flag para marcação
	aAdd(aCampos, {  'Z7_ETIQMAE' ,'C', tamsx3('Z7_ETIQMAE')[1], tamsx3('Z7_ETIQMAE')[2]}) //Produto
	aAdd(aCampos, {  'Z7_PAMASA'  ,'C', tamsx3('Z7_PAMASA')[1]	, tamsx3('Z7_PAMASA')[2] }) //Tipo
	aAdd(aCampos, {  'Z7_CODCLI'  ,'C', tamsx3('Z7_CODCLI')[1]	, tamsx3('Z7_CODCLI')[2] }) //Unid. Med.
	aAdd(aCampos, {  'Z7_DESCRI'  ,'C', tamsx3('Z7_DESCRI')[1]	, tamsx3('Z7_DESCRI')[2] }) //Descrição
	aAdd(aCampos, {  'Z7_QUANT'   ,'C', tamsx3('Z7_QUANT')[1]	, tamsx3('Z7_QUANT')[2]  }) //Descrição
	aAdd(aCampos, {  'Z7_OP'      ,'C', tamsx3('Z7_OP')[1]		, tamsx3('Z7_OP')[2]	 }) //Descrição
	aAdd(aCampos, {  'Z7_LOCAL'   ,'C', tamsx3('Z7_LOCAL')[1]	, tamsx3('Z7_LOCAL')[2]	 }) //Descrição

	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:Create()

	//Popula a tabela temporária
	Processa({|| fPopula()}, 'Processando...')

	//Adiciona as colunas que serão exibidas no FWMarkBrowse
	aColunas := fCriaCols()

	oPanGrid2 := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
	oMarkBrowse := FWMarkBrowse():New()
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:SetDescription('Produtos')
	oMarkBrowse:DisableFilter()
	oMarkBrowse:DisableConfig()
	oMarkBrowse:DisableSeek()
	oMarkBrowse:DisableSaveConfig()
	oMarkBrowse:SetFontBrowse(oFontGrid)
	oMarkBrowse:SetFieldMark('OK')
	oMarkBrowse:SetTemporary(.T.)
	oMarkBrowse:SetColumns(aColunas)
	//oMarkBrowse:AllMark()
	oMarkBrowse:SetOwner(oPanGrid2)
	oMarkBrowse:Activate()
	ACTIVATE MsDialog oDlgMark CENTERED

	//Deleta a temporária e desativa a tela de marcação
	oTempTable:Delete()
	oMarkBrowse:DeActivate()


	//rodape - informa os parametros selecionados
	oGroup3  := TGroup():New(02,02,nJanAltu/12,nJanLarg/2-001,'Parâmetros Escolhidos',oPanRoda,,,.T.)
	oParam   := TSay():New(20, 10, {|| }, oGroup3, , , , , , .T., CLR_BLACK, , nJanLarg/2-070, 20, , , , , , .T.)
	oParam:SetText("Escolha os parâmetros para iniciar")

	oDlgMark:Activate(, , , .T., {|| .T.}, , )
Return

/*/{Protheus.doc} MenuDef
Botões usados no Browse
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/
 
Static Function MenuDef()
    Local aRotina := {}
      
    //Criação das opções
    ADD OPTION aRotina TITLE 'Continuar'  ACTION 'u_zExe229O'     OPERATION 2 ACCESS 0
Return aRotina

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/
 
Static Function fPopula()
    Local cQryDados := ''
    Local nTotal := 0
    Local nAtual := 0
 
    //Monta a consulta
    cQryDados += "SELECT TOP 3 * "        + CRLF
    cQryDados += "FROM SZ7010 SB1 "        + CRLF
    // cQryDados += "WHERE B1_FILIAL = '' AND B1_COD >= '" + MV_PAR01 + "' AND B1_COD <= '" + MV_PAR02 + "' AND SB1.D_E_L_E_T_ = ' ' "        + CRLF
    // cQryDados += "ORDER BY B1_COD"        + CRLF
    PLSQuery(cQryDados, 'QRYDADTMP')
 
    //Definindo o tamanho da régua
    DbSelectArea('QRYDADTMP')
    Count to nTotal
    ProcRegua(nTotal)
    QRYDADTMP->(DbGoTop())
 
    //Enquanto houver registros, adiciona na temporária
    While ! QRYDADTMP->(EoF())
        nAtual++
        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
 
        RecLock(cAliasTmp, .T.)
            (cAliasTmp)->OK := Space(2)
            (cAliasTmp)->Z7_ETIQMAE := QRYDADTMP->Z7_ETIQMAE
            (cAliasTmp)->Z7_PAMASA := QRYDADTMP->Z7_PAMASA
            (cAliasTmp)->Z7_CODCLI := QRYDADTMP->Z7_CODCLI
            (cAliasTmp)->Z7_DESCRI := QRYDADTMP->Z7_DESCRI
            (cAliasTmp)->Z7_QUANT := QRYDADTMP->Z7_QUANT
            (cAliasTmp)->Z7_OP := QRYDADTMP->Z7_OP
            (cAliasTmp)->Z7_LOCAL := QRYDADTMP->Z7_LOCAL

        (cAliasTmp)->(MsUnlock())
 
        QRYDADTMP->(DbSkip())
    EndDo
    QRYDADTMP->(DbCloseArea())
    (cAliasTmp)->(DbGoTop())
Return
 
/*/{Protheus.doc} fCriaCols
Função que gera as colunas usadas no browse (similar ao antigo aHeader)
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/
 
Static Function fCriaCols()
    Local nAtual       := 0 
    Local aColunas := {}
    Local aEstrut  := {}
    Local oColumn
     
    //Adicionando campos que serão mostrados na tela
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    aAdd(aEstrut, { 'Z7_ETIQMAE', "Cod. Etiqueta" , 'C', tamsx3('Z7_ETIQMAE')[1], tamsx3('Z7_ETIQMAE')[2], ''})
    aAdd(aEstrut, { 'Z7_PAMASA'	, "Cod. Masa    " , 'C', tamsx3('Z7_PAMASA')[1]	, tamsx3('Z7_PAMASA')[2] , ''})
    aAdd(aEstrut, { 'Z7_CODCLI' , "Cod. Cliente " , 'C', tamsx3('Z7_CODCLI')[1]	, tamsx3('Z7_CODCLI')[2] , ''})
    aAdd(aEstrut, { 'Z7_DESCRI' , "Descrição    " , 'C', tamsx3('Z7_DESCRI')[1]	, tamsx3('Z7_DESCRI')[2] , ''})
    aAdd(aEstrut, { 'Z7_QUANT'  , "Quantidade   " , 'C', tamsx3('Z7_QUANT')[1]	, tamsx3('Z7_QUANT')[2]  , ''})
    aAdd(aEstrut, { 'Z7_OP'     , "Ord. Produção" , 'C', tamsx3('Z7_OP')[1]		, tamsx3('Z7_OP')[2]	 , ''})
    aAdd(aEstrut, { 'Z7_LOCAL'  , "Armazém      " , 'C', tamsx3('Z7_LOCAL')[1]	, tamsx3('Z7_LOCAL')[2]	 , ''})
 
    //Percorrendo todos os campos da estrutura
    For nAtual := 1 To Len(aEstrut)
        //Cria a coluna
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
        oColumn:SetTitle(aEstrut[nAtual][2])
        oColumn:SetType(aEstrut[nAtual][3])
        oColumn:SetSize(aEstrut[nAtual][4])
        oColumn:SetDecimal(aEstrut[nAtual][5])
        oColumn:SetPicture(aEstrut[nAtual][6])
 
        //Adiciona a coluna
        aAdd(aColunas, oColumn)
    Next
Return aColunas

// Static Function xfImpPA()
// 	Local nX := 0
// 	Local cDir    := "\etiquetas\" //pasta criada no protheus_data
// 	Local cFile   :=""
// 	Local cLabel  := ""
// 	Local cAliasSZ7  := GETNEXTALIAS()
// 	Local cPrinterPath:= "" //compartilhamento da impressora na rede
// 	Local cSeqEtiq1 := GETMV('MV_SEQETQ')
// 	Local cNomePC := ComputerName()
// 	Local cDirLocal := "C:\TEMP\"
// 	Local nTotal := VAL(MV_PAR04)
// 	Local cPrinter := ALLTRIM(MV_PAR05)

// 	// if Empty(SB1->B1_XHALB)
// 	// 	Alert('Codigo do cliente está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
// 	// 	Return
// 	// endif

// 	// if Empty(SB1->B1_XNATCOD)
// 	// 	Alert('Codigo do país está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
// 	// 	Return
// 	// endif

// 	// if Empty(SB1->B1_XIDCLIE)
// 	// 	Alert('ID do cliente está vazio no cadastro do produto, verifique o cadastro.', 'Atenção!!!')
// 	// 	Return
// 	// endif

// 	// SEMMPRE QUE ALCANÇAR 9999 REINICIA A SEQUENCIA.
// 	// if cSeqEtiq1 == '99999999'
// 	// 	cSeqEtiq1 := '00000000'
// 	// endif

// 	cCliente:='SAMSUMG'

// 	dbselectarea('SB1')
// 	dbSetOrder(1)
// 	dbselectarea('SA7')
// 	dbSetOrder(2)
// 	dbselectarea('SA1')
// 	dbSetOrder(1)

// 	SB1->(MSSEEK(xFilial('SB1')+SC2->C2_PRODUTO))
// 	If SA7->(MSSEEK(xFilial('SA7')+SC2->C2_PRODUTO+SC2->C2_XCODCLI+SC2->C2_XLOJA))
// 		cProdCli := alltrim(SA7->A7_CODCLI)
// 	Else
// 		FwAlertWarning("Cliente "+alltrim(SC2->C2_XCODCLI)+" não encontrado nas SA1.",'Atenção!!!')
// 		Return
// 	EndIf

// 	If SA1->(MSSEEK(xFilial('SA1')+SC2->C2_XCODCLI+SC2->C2_XLOJA))
// 		if Empty(SA1->A1_NOMETIQ)
// 			FwAlertWarning("O Campo 'Abrev. Nome' na tebela  SA1 rotina Cadastro de Cliente não foi preenchido, ajuste o cadastro.",'Impressao Cancelada!!!')
// 			Return
// 		Else
// 			cCliente := alltrim(SA1->A1_NOMETIQ)
// 		endif
// 	EndIf
// 	BeginSQL ALIAS cAliasSZ7
// 		SELECT max(Z7_ETIQMAE) ULT_ETIQ FROM %table:SZ7%
// 	EndSQL

// 	cSeqEtiq1 := AllTRim((cAliasSZ7)->ULT_ETIQ) // sequencial da etiqueta MAE

// 	ProcRegua(nTotal)
// 	//Incrementa a mensagem na régua
// 	for nx := 1 to nTotal

// 		cSeqEtiq1 := SOMA1(space(2)+cSeqEtiq1)
// 		cSeqEtiq1 := cvaltochar(val(cSeqEtiq1))

// 		// verificar se ainda existe saldo para imprimir
// 		// se o saldo já impresso + a quantidade sendo imprimida fo maior que a quantidade da OP aborta a impressão.
// 		if (val(MV_PAR02) + SC2->C2_QTDETIQ) > SC2->C2_QUANT .or. val(MV_PAR02) > SC2->C2_QUANT
// 			FwAlertWarning('O Saldo da etiqueta '+ cSeqEtiq1 + ' ultrapassa o Saldo da OP.','Impressao Cancelada!!!')
// 			Return
// 		EndIf


// 		IncProc("Imprindo etiquetas " + cValToChar(nX) + " de " + cValToChar(nTotal) + "...")
// 		// BR30BN6108855AMASAC9D0301

// 		cQR := 	SB1->B1_COD+space(1)+;  // CODIGO PRODUTO
// 		AllTRim(cSeqEtiq1)+;                 // SEQUENCIA
// 		STRZERO(VAL(MV_PAR02),5)+;	    // QUANTIDADE
// 		STRZERO(VAL(SC2->C2_NUM),8)     // OP

// 		dbselectarea('SZ7')
// 		dbsetorder(1)

// 		RECLOCK('SZ7', .T.)
// 		SZ7->Z7_ETIQMAE := cSeqEtiq1
// 		SZ7->Z7_PAMASA 	:= SB1->B1_COD
// 		SZ7->Z7_CODCLI 	:= cProdCli
// 		SZ7->Z7_DESCRI 	:= alltrim(SB1->B1_DESC)
// 		SZ7->Z7_OP 		:= SC2->C2_NUM
// 		SZ7->Z7_MOLDE 	:= SC2->C2_XMOLDE
// 		SZ7->Z7_QUANT 	:= VAL(MV_PAR02)
// 		SZ7->Z7_LOCAL 	:= SC2->C2_LOCAL
// 		SZ7->Z7_QRMAE 	:= cQR
// 		SZ7->(MsUnlock())

// 		// FGRAVETIQ(cQR,cSeqEtiq1,cProdCli,MV_PAR02,SC2->C2_XMAQ,ddatabase,SC2->C2_NUM,SC2->C2_LOCAL,SC2->C2_XMOLDE,cCliente,;
// 			// alltrim(SB1->B1_DESC),SB1->B1_COD)

// 		cLabel:= ""
// 		cLabel+= ("CT~~CD,~CC^~CT~ ")
// 		cLabel+= (" ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA ")
// 		cLabel+= (" ^PR10,10 ")
// 		cLabel+= (" ~SD "+alltrim(MV_PAR03))
// 		cLabel+= ("^JUS^LRN^CI0^XZ ")
// 		cLabel+= (" ^XA ")
// 		cLabel+= (" ^MMT ")
// 		cLabel+= (" ^PW945 ")
// 		cLabel+= (" ^LL0650 ")
// 		cLabel+= (" ^LS0 ")
// 		cLabel+= (" ^FT32,211^A0N,42,38^FH\^FD"+cProdCli+"^FS ")
// 		cLabel+= (" ^FT356,91^A0N,42,38^FH\^FD"+cSeqEtiq1+"^FS ")
// 		cLabel+= (" ^FT365,469^A0N,33,31^FH\^FD"+MV_PAR02+"^FS ")
// 		cLabel+= (" ^FT704,623^A0N,37,52^FH\^FDRE:____^FS ")
// 		cLabel+= (" ^FT703,575^A0N,37,36^FH\^FDTURNO:____^FS ")
// 		cLabel+= (" ^FT702,526^A0N,37,33^FH\^FDMAQ: "+SC2->C2_XMAQ+"^FS ")
// 		cLabel+= (" ^FT702,477^A0N,37,36^FH\^FD"+"___"+right(dtoc(ddatabase),8)+" ^FS ")
// 		cLabel+= (" ^FT270,468^A0N,33,31^FH\^FDQTD: ^FS ")
// 		cLabel+= (" ^FT101,468^A0N,33,31^FH\^FD"+SC2->C2_NUM+"^FS ")
// 		cLabel+= (" ^FT269,512^A0N,33,31^FH\^FDALMOX: ^FS ")
// 		cLabel+= (" ^FT394,512^A0N,33,31^FH\^FD"+SC2->C2_LOCAL+"^FS ")
// 		cLabel+= (" ^FT152,512^A0N,33,31^FH\^FD"+SC2->C2_XMOLDE+"^FS ")
// 		cLabel+= (" ^FT36,512^A0N,33,31^FH\^FDMOLDE:^FS ")
// 		cLabel+= (" ^FT36,468^A0N,33,31^FH\^FDOP: ^FS ")
// 		cLabel+= (" ^FT35,627^A0N,80,141^FH\^FD"+cCliente+"^FS ")
// 		if len(alltrim(SB1->B1_DESC)) <= 45
// 			cLabel+= (" ^FT33,345^A0N,37,36^FH\^FD"+alltrim(SB1->B1_DESC)+"^FS ")
// 		else
// 			cLabel+= (" ^FT33,345^A0N,37,36^FH\^FD"+left(alltrim(SB1->B1_DESC),45)+"^FS ")
// 			cLabel+= (" ^FT33,406^A0N,37,36^FH\^FD"+substr(alltrim(SB1->B1_DESC),46)+"^FS ")
// 		endif
// 		cLabel+= (" ^FT34,150^A0N,42,38^FH\^FD"+SB1->B1_COD+"^FS ")
// 		cLabel+= (" ^FT34,91^A0N,42,38^FH\^FDMASA^FS ")
// 		cLabel+= (" ^FT682,313^BQN,2,8 ")
// 		cLabel+= (" ^FDLA,"+cQR+"^FS ")
// 		cLabel+= (" ^PQ1,0,1,Y^XZ ")

// 		impriRaw(cLabel,cPrinter,cSeqEtiq1)

// 		// atualizar a quantida ja impressa
// 		// para limitar a impressao ate fecha a quantidade da OP.
// 		nQtdAtu := SC2->C2_QTDETIQ + val(MV_PAR02)
// 		Reclock('SC2' , .F.)
// 		SC2->C2_QTDETIQ := nQtdAtu
// 		SC2->(msUnLock())
// 	next nX
// Return

// // User function ValidOp()
// // 	local lret:= .F.
// // 	dbselectarea('SC2')
// // 	dbsetorder(1)

// // 	if MSSEEK(xFilial('SC2')+MV_PAR01)
// // 		lRet := .T.
// // 	Else
// // 		Alert('Oderm de producao não localizada !!!')
// // 	EndIf

// // return lret

// // Static function FGRAVETIQ(_cQR,_cSeqEtiq1,_cProdCli,_nQuantid,_cXMAQ,_ddatabase,_numOP,_cArmaz,_cXMOLDE,_cCliente,_cDesc,_cCod)
// // Return

// // Exemplo de impressão RAW usando FWMSPrinter
// Static Function impriRaw(cZPL,cPrinter,cSeqEtiq1)

// 	Local oPrinter   := Nil
// 	Local cFileRel   := "RAW_ETIQUETA" // pode ser apenas identificador
// 	Local oPrintSetupParam := Nil
// 	Local lAdjustToLegacy   := .F.
// 	Local lDisableSetup     := .T.
// 	// Local oPrinter
// 	Local cLocal            := "c:\temp"
// 	Local nPrtType          := 2 // IMP_PDF > 6 || IMP_SPOOL > 2
// 	Local aDevice           := {}
// 	Local cSession          := GetPrinterSession()

// 	// Criar objeto FWMSPrinter em modo RAW
// 	oPrinter := FWMSPrinter():New(cFileRel, nPrtType, lAdjustToLegacy, '', lDisableSetup,.F.,NIL ,cPrinter ,.F. ,.T., .T. /*LRAW*/)

// 	// Aqui é só usar SAY, que em RAW escreve direto
// 	oPrinter:Say(0, 0, cZPL)

// 	oPrinter:Print()

// 	// PUTMV("MV_SEQETQ",cSeqEtiq1)
// Return
