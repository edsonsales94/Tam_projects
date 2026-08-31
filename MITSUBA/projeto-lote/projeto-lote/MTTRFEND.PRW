#INCLUDE 'PROTHEUS.CH'
#Include "TOTVS.CH"
#Include "FWMVCDef.ch"
/*/{Protheus.doc} M261BCHOI

/*/

#DEFINE CRLF ( chr(13)+chr(10) )

User Function MTTRFEND()
	// RpcSetType(3)
	// RpcSetEnv("01", '01', "admin", "MITECH1", "EST", GetEnvServer())
	// SetModulo("SIGAEST", "EST")
	Local aArea         := GetArea()
	Local aCampos := {}
	Local aColunas := {}
	Local cFontPad    := 'Tahoma'
	Local cFunBkp := FunName()
	Local oFontGrid   := TFont():New(cFontPad,,-14)
	Private cProdAtual := ''
	Private xXORDPROD := ''
	Private xXLote := ''
	//Janela e componentes
	Private oTempTable := Nil
	Private oPanGrid
	Private oMarkBrowse
	Private cAliasTmp := GetNextAlias()
	Private aRotina   := MenuDef()
	//Tamanho da janela
	Private aTamanho := MsAdvSize()
	Private nJanLarg := aTamanho[5]
	Private nJanAltu := aTamanho[6]
	//Fontes
	Private cFontUti    := "Tahoma"
	Private oFontMod    := TFont():New(cFontUti, , -38)
	Private oFontSub    := TFont():New(cFontUti, , -12)
	Private oFontSubN   := TFont():New(cFontUti, , -12, , .T.)
	Private oFontBtn    := TFont():New(cFontUti, , -12)
	Private oFontSay    := TFont():New(cFontUti, , -10)
	Private oFont := TFont():New('Courier new',,-18,.T.,.F.)
	Private oFont2 := TFont():New('Courier new',,-18,.T.,.T.)
	Private oFwLayer
	Private xxCod
	Private nQtdTransf := 0
	Private xxEndDest := ''

	xXORDPROD := SPACE(TAMSX3('CP_X_OP')[1])
	xXCODIGO := space(tamsx3('B2_COD')[1])
	nJanLarg:=1200
	nJanAltu:=600

	//Adiciona as colunas que serão criadas na temporária
	aAdd(aCampos, { 'OK', 'L', 1, 0}) //Flag para marcação
	aAdd(aCampos, { 'CP_X_OP', 'C', TamSX3("CP_X_OP")[1], 0}) //OP
	aAdd(aCampos, { 'CP_PRODUTO', 'C', TamSX3("CP_PRODUTO")[1], 0}) //Produto
	aAdd(aCampos, { 'CP_QUANT', 'N', TamSX3("CP_QUANT")[1], TamSX3("CP_QUANT")[2]}) //Fornecedor
	aAdd(aCampos, { 'XPAGO', 'N', TamSX3("CP_QUJE")[1], TamSX3("CP_QUJE")[2]}) //Fornecedor
	aAdd(aCampos, { 'XSALDO', 'N', TamSX3("CP_QUANT")[1], TamSX3("CP_QUANT")[2]}) //Fornecedor
	aAdd(aCampos, { 'CP_DESCRI', 'C', TamSX3("CP_DESCRI")[1], 0}) //Produto
	aAdd(aCampos, { 'CP_EMISSAO', 'C', TamSX3("CP_EMISSAO")[1], 0}) //Produto
	aAdd(aCampos, { 'CP_SOLICIT', 'C', TamSX3("CP_SOLICIT")[1], 0}) //Produto
	aAdd(aCampos, { 'CP_NUM', 'C', TamSX3("CP_NUM")[1], 0}) //Pedido
	aAdd(aCampos, { 'CP_ITEM', 'C', TamSX3("CP_ITEM")[1], 0}) //Pedido
	aAdd(aCampos, { 'CP_LOCAL', 'C', TamSX3("CP_LOCAL")[1], 0}) //Pedido

	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:AddIndex("1", {"CP_X_OP"} )
	oTempTable:Create()

	//Popula a tabela temporária
	Processa({|| fPopula('','')}, 'Processando...')

	//Adiciona as colunas que serão exibidas no FWMarkBrowse
	aColunas := fCriaCols()

	aSeek := {}
	cCampoAux := "CP_X_OP"
	aAdd(aSeek,{GetSX3Cache(cCampoAux, "X3_TITULO"), {{"", GetSX3Cache(cCampoAux, "X3_TIPO"), GetSX3Cache(cCampoAux, "X3_TAMANHO"), GetSX3Cache(cCampoAux, "X3_DECIMAL"), AllTrim(GetSX3Cache(cCampoAux, "X3_TITULO")), AllTrim(GetSX3Cache(cCampoAux, "X3_PICTURE"))}} } )
	// cCampoAux := "BF_LOTECTL"
	// aAdd(aSeek,{GetSX3Cache(cCampoAux, "X3_TITULO"), {{"", GetSX3Cache(cCampoAux, "X3_TIPO"), GetSX3Cache(cCampoAux, "X3_TAMANHO"), GetSX3Cache(cCampoAux, "X3_DECIMAL"), AllTrim(GetSX3Cache(cCampoAux, "X3_TITULO")), AllTrim(GetSX3Cache(cCampoAux, "X3_PICTURE"))}} } )

	//Criando a janela
	DEFINE MSDIALOG oDlgMark TITLE 'Pagamento Processo' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlgMark,.F.)
	oMarkBrowse:= FWMarkBrowse():New()

	//Adicionando 3 linhas, a de tÃ­tulo, a superior e a do calendÃ¡rio
	oFWLayer:addLine("TIT", 15, .F.)
	oFWLayer:addLine("COR", 85, .F.)

	//Adicionando as colunas das linhas
	oFWLayer:addCollumn("HEADERTEXT",   100, .T., "TIT")
	// oFWLayer:addCollumn("BLANKBTN",     050, .T., "TIT")

	oFWLayer:addCollumn("COLGRID",      100, .T., "COR")

	//Criando os paineis
	oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
	// oPanBut    := oFWLayer:GetColPanel("BLANKBTN",    "TIT")
	oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")

	//TÃ­tulos e SubTÃ­tulos
	oSayTitulo := TSay():New(15, 	005, {|| 'ORD. PRODUCAO:'}, 	oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// oSayTitulo := TSay():New(15, 	290, {|| 'Endereco:'},	oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSayTitulo := TSay():New(15, 150, {|| 'QRCODE:'}, 	oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSayTitulo := TSay():New(15, 400, {|| 'CODIGO:'}, 	oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// oSayTitulo := TSay():New(15,	395, {|| 'Quantidade:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )

	// cCombo1:= aItems[1]
	oTGet1 := TGet():New( 10,060,{|u| if( Pcount( )>0, xXORDPROD := u, xXORDPROD) },oDlgMark,80,20,"@!", ,0,,,.F.,,.T.,,.F.,/*{|| U_fExecBaix()}*/,.F.,.F.,,.F.,.F.,,'xXORDPROD',,,,,,, )
	oTGet1:bValid := {||  X_LOADCLI(oMarkBrowse,xXORDPROD,xXCODIGO,.F.)}

	xxQrCODE := space(100)
	oTGet2 := TGet():New( 10,190,{|u| if( Pcount( )>0, xxQrCODE := u, xxQrCODE) },oDlgMark,200,20,"@!", ,0,,,.F.,,.T.,,.F.,/*{|| U_fExecBaix()}*/,.F.,.F.,,.F.,.F.,,xxEndDest,,,, )
	oTGet2:bValid := {||  X_LOADCLI(oMarkBrowse,xXORDPROD,fRet(xxQrCODE),.T.) }
	// oTGet2:lReadOnly := IIF(Empty(xXORDPROD),.F.,.T.)

	oTGet3 := TGet():New( 10,440,{|u| if( Pcount( )>0, xXCODIGO := u, xXCODIGO) },oPanHeader,80,20,"@!", ,0,,,.F.,,.T.,,.F.,/*{|| x_loadCli(oBrowse,xXCODIGO)}*/,.F.,.F.,,.F.,.F.,,xXCODIGO,,,, )
	oTGet3:bValid := {||  X_LOADCLI(oMarkBrowse,xXORDPROD,xXCODIGO,.F.)}

	// nQtdTransf := 0//space(tamsx3('B2_QATU')[1])
	// oTGet4 := TGet():New( 10,430,{|u| if( Pcount( )>0, nQtdTransf := u, nQtdTransf) },oDlgMark,70,20,"@E 999999999", ,0,,,.F.,,.T.,,.F.,/*{|| x_loadCli(oBrowse,nQtdTransf)}*/,.F.,.F.,,.F.,.F.,,,,,, )

	// oBtnSair := TButton():New(014, 140, "Gerar coali",  oPanBut, {|| GeraCoal()}, 50, 012, , oFontBtn, , .T., , , , , , )
	// oBtnSair := TButton():New(014, 200, "Ver Coali"  ,  oPanBut, {|| VerCoali(2)}, 50, 012, , oFontBtn, , .T., , , , , , )
	// oBtnSair := TButton():New(014, 260, "Reimp. FIFO",  oPanBut, {|| FnImp01()}, 50, 012, , oFontBtn, , .T., , , , , , )

	//dialog com browse para defir as notas fiscais
	SetFunName(cFunBkp)
	//Dados
	// oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
	oMarkBrowse:SetDescription("Armazem 20 - Recebimento") //Titulo da Janela
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:oBrowse:SetDBFFilter(.T.)
	oMarkBrowse:oBrowse:SetUseFilter(.F.) //Habilita a utilização do filtro no Browse
	// oMarkBrowse:oBrowse:SetFixedBrowse(.T.)
	oMarkBrowse:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
	oMarkBrowse:SetAmbiente(.T.) //Habilita a utilização da funcionalidade Ambiente no Browse
	oMarkBrowse:SetTemporary(.T.) //Indica que o Browse utiliza tabela temporária
	oMarkBrowse:oBrowse:SetSeek(.T.,aSeek) //Habilita a utilização da pesquisa de registros no Browse
	oMarkBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padrão do Browse
	// oMarkBrowse:SetFieldMark('OK')
	oMarkBrowse:AddMarkColumns({||IIF((cAliasTmp)->OK,'LBOK','LBNO')},{|| (cAliasTmp)->OK:= !(cAliasTmp)->OK }, /*[ bHeaderClick]*/ )
	oMarkBrowse:SetTemporary(.T.)
	// oMarkBrowse:oBrowse:SetLineHeight(35)
	// oMarkBrowse::EditCell(.T.)
	oMarkBrowse:SetFontBrowse(oFontGrid)
	oMarkBrowse:SetOwner(oPanGrid)
	oMarkBrowse:SetColumns(aColunas)

	oMarkBrowse:Activate()
	ACTIVATE MsDialog oDlgMark CENTERED

	RestArea(aArea)
Return

/*/{Protheus.doc} MenuDef
Botões usados no Browse
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Criação das opções
	ADD OPTION aRotina TITLE 'Confirmar'  ACTION 'u_fExecBaix'     OPERATION 2 ACCESS 0
	// ADD OPTION aRotina TITLE 'Ver Nota'  ACTION  'u_fVerNota'     OPERATION 2 ACCESS 0

Return aRotina

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author EDSON SALES
@since 20/07/2022
/*/

Static Function fPopula(_cORD,_cCOD)
	Local nTotal := 0
	Local nAtual := 0
	Local cAliasNew := GetNextAlias()
	Local cFilter := ''

	DEFAULT _cORD := ''
	DEFAULT _cCOD := ''

	cFilter += "%"
	cFilter += " CP_QUANT > CP_QUJE  AND CP_STATUS ='' AND CP_PREREQU='S' "
	if !Empty(_cORD)
		cFilter += " AND CP_X_OP = '"+_cORD+"' "
	endIf
	if !Empty(_cCOD)
		cFilter += " AND CP_PRODUTO = '"+_cCOD+"' "
	endIf
	cFilter += "%"

	BeginSql Alias cAliasNew
		select CP_QUANT-CP_QUJE XSALDO, * 
        from %table:SCP% SCP
        where SCP.%NOTDEL% 
        AND  %EXP:cFilter%
        ORDER BY CP_X_OP
	EndSql

	//Definindo o tamanho da régua
	DbSelectArea(cAliasNew)
	Count to nTotal
	ProcRegua(nTotal)
	(cAliasNew)->(DbGoTop())

	//Enquanto houver registros, adiciona na temporária
	While ! (cAliasNew)->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		// cNotas := fBuscaNF((cAliasNew)->BF_PRODUTO,(cAliasNew)->B8_LOTECTL,(cAliasNew)->B8_DTVALID)
		RecLock(cAliasTmp, .T.)
		(cAliasTmp)->OK := IIF(Empty(_cCod), .F.,.T.)

		(cAliasTmp)->CP_X_OP := (cAliasNew)->CP_X_OP
		(cAliasTmp)->CP_PRODUTO 	:= (cAliasNew)->CP_PRODUTO
		(cAliasTmp)->CP_LOCAL 	:= (cAliasNew)->CP_LOCAL
		(cAliasTmp)->CP_DESCRI 	:= (cAliasNew)->CP_DESCRI
		(cAliasTmp)->CP_QUANT := (cAliasNew)->CP_QUANT
		(cAliasTmp)->XPAGO 	:= (cAliasNew)->CP_QUJE
		(cAliasTmp)->XSALDO := (cAliasNew)->XSALDO
		(cAliasTmp)->CP_EMISSAO := (cAliasNew)->CP_EMISSAO
		(cAliasTmp)->CP_NUM := (cAliasNew)->CP_NUM
		(cAliasTmp)->CP_ITEM := (cAliasNew)->CP_ITEM

		(cAliasTmp)->(MsUnlock())

		(cAliasNew)->(DbSkip())
	EndDo
	(cAliasNew)->(DbCloseArea())
	(cAliasTmp)->(DbGoTop())
Return

/*/{Protheus.doc} fCriaCols
Função que gera as colunas usadas no browse (similar ao antigo aHeader)
@author EDSON SALES
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

	// aAdd(aEstrut, { 'OK', 'Sel', 'L', 1, 0, ''})
	aAdd(aEstrut, { 'CP_X_OP'   , 'Op',         'C', TamSX3("CP_X_OP")[1], 0, ''})
	aAdd(aEstrut, { 'CP_PRODUTO', 'Produto',    'N', TamSX3("CP_PRODUTO")[1] ,0, ''})
	aAdd(aEstrut, { 'CP_QUANT'  , 'Quantidade', 'N', TamSX3("CP_QUANT")[1], TamSX3("CP_QUANT")[2], ''})
	aAdd(aEstrut, { 'XPAGO'     , 'Baixado',       'N', TamSX3("CP_QUJE")[1], TamSX3("CP_QUJE")[2], ''})
	aAdd(aEstrut, { 'XSALDO'    , 'Falta Baixar',      'N', TamSX3("CP_QUANT")[1], TamSX3("CP_QUANT")[2], ''})
	aAdd(aEstrut, { 'CP_DESCRI' , 'Descricao',  'C', TamSX3("CP_DESCRI")[1], 0, ''})
	aAdd(aEstrut, { 'CP_EMISSAO', 'Emissao',    'C', TamSX3("CP_EMISSAO")[1], 0, ''})
	aAdd(aEstrut, { 'CP_SOLICIT', 'Solicitante', 'C', TamSX3("CP_SOLICIT")[1], 0, ''})
	aAdd(aEstrut, { 'CP_NUM'   , 'Num SC',       'C', TamSX3("CP_NUM")[1], 0, ''})
	aAdd(aEstrut, { 'CP_ITEM'   , 'Item',       'C', TamSX3("CP_ITEM")[1], 0, ''})
	aAdd(aEstrut, { 'CP_LOCAL'   , 'Arm. Orig',       'C', TamSX3("CP_LOCAL")[1], 0, ''})

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

/*/{Protheus.doc} User Function fExecBaix
Função acionada pelo botão continuar da rotina
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

User Function fExecBaix()
	Processa({|| fProcessa()}, 'Processando...')
Return

/*/{Protheus.doc} fProcessa
Função que percorre os registros da tela
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

Static Function fProcessa()
	Local aArea     := FWGetArea()
	// Local cMarca    := oMarkBrowse:Mark()
	// Local nAtual    := 0
	Local nTotal    := 0
	Local nTotMarc := 0
	Local aCols := {}
	Private lTranfer := .T.

	//Define o tamanho da régua
	DbSelectArea(cAliasTmp)
	(cAliasTmp)->(DbGoTop())
	Count To nTotal
	ProcRegua(nTotal)

	//Percorrendo os registros
	(cAliasTmp)->(DbGoTop())
	While ! (cAliasTmp)->(EoF())
		// nAtual++
		// IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

		//Caso esteja marcado
		If (cAliasTmp)->OK
			nTotMarc++
			aadd(aCols,{;
				(cAliasTmp)->CP_X_OP,;
				(cAliasTmp)->CP_PRODUTO,;
				(cAliasTmp)->CP_DESCRI,;
				xXLote,;
				(cAliasTmp)->CP_QUANT,;
				(cAliasTmp)->XPAGO,;
				(cAliasTmp)->XSALDO,;
				(cAliasTmp)->CP_EMISSAO,;
				(cAliasTmp)->CP_SOLICIT,;
				(cAliasTmp)->CP_LOCAL,;
				(cAliasTmp)->CP_NUM,;
				(cAliasTmp)->CP_ITEM;
				})
		EndIf
		(cAliasTmp)->(DbSkip())
	EndDo

	// fBaixarSA()
	fTransferencia(aCols)

	FWRestArea(aArea)
Return

/*/{Protheus.doc} fRet
	(long_description)
	@type  Static Function
	@author user
	@since 18/03/2026
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function fRet(cValue)

	cValue := AllTrim(StrTran( cValue,';','/' ))
	cValue := StrTran( cValue,'}',';' )

	aArray1 := StrTokArr( cValue , ";" )

	if LEN(aArray1) >= 5
		xXCodigo := aArray1[1]
		nQtdTransf := val(aArray1[5])
		xXLote :=  aArray1[6]
	endif

Return xXCodigo

Static Function X_LOADCLI(oBrowse,_xORD, _xCOD,lQr)

	// LIMPA TEMPORARIA
	(cAliasTmp)->(AVZAP())
	fPopula(_xORD,_xCOD)
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:refresh()
	oMarkBrowse:GoTop(.T.)

	if lQr .AND. !Empty(xxQrCODE)
		u_fExecBaix()
		lQr := .F.

		// LIMPA TEMPORARIA
		(cAliasTmp)->(AVZAP())
		fPopula(_xORD,_xCOD)
		oMarkBrowse:SetAlias(cAliasTmp)
		oMarkBrowse:refresh()
		oMarkBrowse:GoTop(.T.)
	endif
	xXLote := ''
Return


/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author Edson Sales
	@since 06/04/2026
/*/
Static Function fBaixarSA()
	Local aCamposSCP
	Local aCamposSD3

	Local aRelProj
	Local cNum := "000001" // No.da Requisição
	Local cItem := "01" // No.do Item da Req.
	LOCAL aRetCQ := {}

	dbSelectArea("SCP")

	dbSetOrder(1)
	If SCP->(dbSeek(xFilial("SCP")+cNum+cItem))
		aCamposSCP := { {"CP_NUM" ,SCP->CP_NUM ,Nil },;
			{"CP_ITEM" ,SCP->CP_ITEM ,Nil },;
			{"CP_QUANT" ,SCP->CP_QUANT ,Nil }}

		aCamposSD3 := { {"D3_TM" ,"501" ,Nil },; //Tipo do Mov.
		{"D3_COD" ,SCP->CP_PRODUTO,Nil },;
			{"D3_LOCAL" ,SCP->CP_LOCAL ,Nil },;
			{"D3_DOC" ,"" ,Nil },; // Não.do Doutor.
		{"D3_EMISSAO" ,DDATABASE ,Nil }}


		//Dados para atualização do vinculo com pms (opcional)
		aRelProj := {}
		aAdd(aRelProj,{})
		aAdd(aRelProj[1],{"AFH_PROJET" ,"Projeto1 " ,Nil })
		aAdd(aRelProj[1],{"AFH_TAREFA" ,"01.01 " ,Nil })
		aAdd(aRelProj[1],{"AFH_QBAIX" ,1 ,Nil })

		aAdd(aRelProj,{})
		aAdd(aRelProj[2],{"AFH_PROJ" ,"Projeto2 " ,Nil })
		aAdd(aRelProj[2],{"AFH_TAREFA" ,"01.01 " ,Nil })
		aAdd(aRelProj[2],{"AFH_QBAIX" ,2 ,Nil })

		lMSHelpAuto := .F.
		lMsErroAuto := .F.

		MSExecAuto({|v,x,y,z,w| mata185(v,x,y,z,w)},aCamposSCP,aCamposSD3,1,,aRelProj) // 1 = BAIXA (ROT.AUT)

		If lMsErroAuto
			MostraErro()
		EndIF

	EndIf

Return

Static Function fTransferencia(aCols)
	Local aAuto     := {}
	Local aItem     := {}
	Local nX        := Nil
	Local cLog      := ""
	Local cOps      := ""
	Local cAliasNew := GetNextAlias()
	Local cDocumen  := GetSxeNum("SD3","D3_DOC")
	Local cUsuario  := RETCODUSR()
	Local nQuant 	:= 0
	Local xxEndDest := space(20)
	LOCAL nOpc1 := 0

	Local cLocaliz  := SPACE(TAMSX3("BE_LOCALIZ")[1])
	Local cNumseri  := SPACE(TAMSX3("D3_NUMSERI")[1])
	Local oDlg,oSay,oSay1
	Private oFwLayer
	Private oPanTitulo
	Private oPanGrid
	Private xCtrlLote := .F.

	aItem := {}
	aAuto     := {}

	for nx := 1 to len(aCols)

		oDlg:= TDialog():New(180,180,550,800,'Fazer Baixa',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		oSay1  := TSay():New(10,10,{|| 'Ord. Producao: '},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(10,105,{|| acols[nx,1]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)
		oSay1  := TSay():New(10,195,{|| 'Falta Baixar: '},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(10,275,{|| acols[nx,7]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(25,10,{|| 'Produto:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(25,105,{|| acols[nx,2]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		xCtrlLote := POSICIONE('SB1',1,XFILIAL('SB1')+acols[nx,2],'B1_RASTRO') == 'L'
		xxEnder := space(20)
		oSay1 := TSay():New(40,10,{|| 'Endereço Origem:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oEnd1  := TGet():New( 40,105,{ |u| If(PCount() > 0, xxEnder := u, xxEnder) },oDlg,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,xxEndDest,,,,.T.,.F. )
		oEnd1:CF3 :='SBE'
		oEnd1:lActive    := Iif(!xCtrlLote,.F.,.T.) // se não controla lote desativa

		oSay1 := TSay():New(55,10,{|| 'Lote:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		if !Empty(acols[nx,4])
			cLote := acols[nx,4]
			oSay1 := TSay():New(55,105,{|| acols[nx,4]},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		Else
			cLote := space(tamsx3('BF_LOTECTL')[1])
			oTGet1 := TGet():New(55,105,{|u| if( Pcount( )>0, cLote := u, cLote) },oDlg,70,009,"", ,0,,,.F.,,.T.,,.F.,/**/,.F.,.F.,,.F.,.F.,,,,,, )
			oTGet1:lActive    := Iif(!xCtrlLote,.F.,.T.) // se não controla lote desativa
		endif

		oSay1 := TSay():New(70,10,{|| 'Quantidade'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oTGet1 := TGet():New( 70,105,{|u| if( Pcount( )>0, nQuant := u, nQuant) },oDlg,70,009,"@E 999999999", ,0,,,.F.,,.T.,,.F.,/**/,.F.,.F.,,.F.,.F.,,,,,, )

		oSay1 := TSay():New(90,10,{|| 'Armazem Destino:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(90,105,{|| '10'},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(110,10,{|| 'Endereço Destino:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(110,105,{|| 'Padrao'},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		// if Empty(acols[nx,5])
		// 	oTGet2:lActive    := .F.
		// endif

		oTButton1 := TButton():New( 170, 115, "Baixar"	 ,oDlg,{|| oDlg:end(),AltOpt(@nOpc1,1)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton2 := TButton():New( 170, 165, "Cancelar"	 ,oDlg,{|| oDlg:end(),AltOpt(@nOpc1,2)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton3 := TButton():New( 170, 210, "Cancelar Tudo",oDlg,{|| oDlg:end(),AltOpt(@nOpc1,0)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		// ativa diálogo centralizado

		//Adicionando A QUANTIDADE E ENDEREÇO DESTINO

		oDlg:Activate()

		if nOpc1 == 1
			// 	DbSelectArea('SBF')
			// 	DbSetOrder(1)

			// 	if SBF->(MsSeek(xFilial('SBF')+'01'+Alltrim(xxEndDest)))
			// 		while !SBF->(EoF()) .and. AllTrim(SBF->BF_LOCALIZ) == Alltrim(xxEndDest)
			// 			if AllTrim(SBF->BF_PRODUTO) <> AllTrim(acols[nx,1])
			// 				FWAlertError(;
				// 					"Ja existe outro produto cadastrado neste endereco." + CRLF + ;
				// 					"Produto Cadastrado: " + AllTrim(SBF->BF_PRODUTO) + CRLF + ;
				// 					"Endereco: " + Alltrim(xxEndDest) + CRLF + CRLF + ;
				// 					"Cada endereco so pode conter um unico produto.", "Nao Enderecado!" )
			// 				return .F.
			// 			elseif AllTrim(SBF->BF_LOTECTL) <> AllTrim(acols[nx,6])
			// 				if !FWAlertYesNo(;
				// 						"O endereco informado ja esta vinculado a outro lote." + CRLF + ;
				// 						"Lote Existente: " + AllTrim(SBF->BF_LOTECTL) + CRLF + ;
				// 						"Lote Informado: " + AllTrim(acols[nx,6]) + CRLF + CRLF + ;
				// 						"deseja enderecar lotes diferentes no mesmo endereco ?","Atencao!!! Lote diferentes!" )
			// 					return .F.
			// 				Else
			// 					Exit
			// 				EndIf
			// 			else
			// 				if !FWAlertYesNo(;
				// 						"Ja existe um saldo produto informado neste endereco." + CRLF + ;
				// 						"Produto Informado: " + cValToChar(SBF->BF_PRODUTO) + CRLF + ;
				// 						"Saldo Existente: " + cValToChar(SBF->BF_QUANT) + CRLF + ;
				// 						"Saldo a Enderecar: " + cValToChar(nQuant)+ CRLF + CRLF + ;
				// 						"deseja enderecar o saldo de "+ cValToChar(nQuant) +" no endereco "+ Alltrim(xxEndDest) +" ?","Atencao!!! Saldo no endereco!" )
			// 					return .F.
			// 				Else
			// 					Exit
			// 				EndIf
			// 			endif
			// 			SBF->(DbSkip())
			// 		EndDo
			// 	endif
			_cLote := Iif(!Empty(cLote),cLote,acols[nx,4])
			aAdd(aItem,{acols[nx,1],; //OP
			acols[nx,2],; //CODIGO
			Iif(xCtrlLote,_cLote,''),; // LOTE
			(nQuant),;  // quantidade
			xxEnder,; // endereco orig
			Iif(xCtrlLote,POSICIONE('SB8',3,XFILIAL('SB8')+acols[nx,2]+'01'+acols[nx,4],'B8_LOTECTL'),CTOD('  /  /  ')),; // VALIDADE
			aCols[nX,10],;  //armazem ORIGEM
			'10',;  //armazem destino
			Iif(xCtrlLote,'PADRAO',''),;
				acols[nx,11],; // NUM SC
			acols[nx,12]; // ITEM SC
			}) // endereco destino

		elseif nOpc1 == 0
			return .F.
		endif

		if nOpc1 == 1
			excecTranf(aItem)
			nQuant := 0
			aItem := {}
		endif
	next nx

	// LIMPA TEMPORARIA
	(cAliasTmp)->(AVZAP())
	fPopula('','')
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:refresh()
	oMarkBrowse:GoTop(.T.)

	xXCodigo := space(tamsx3('B2_COD')[1])
	xXORDPROD:= space(100)
	xXLote := ''
	xxEndDest := ''
	nQtdTransf := 0
	nQuant := 0

Return .T.

/*/{Protheus.doc} nomeStaticFunction
	Alterar a opção
/*/
Static Function AltOpt(nOptAtu,nOpt)
	nOptAtu := nOpt
Return .T.

/*/{Protheus.doc} excecTranf
/*/
Static Function excecTranf(aItem)
	Local Ny := 0
	Local Ni := 0
	Local  aAuto := {}
	Local  aRelProj := {}
	Local CUN := ''
	Local aCamposSCP
	Local aCamposSD3

	Private  lMsErroAuto := .F.

	BeginTran()

	For Ny := 1 TO LEN(aItem)
		cUM := POSICIONE('SB1',1,XFILIAL('SB1')+aItem[Ny,1],'B1_UM')
		dbSelectArea("SCP")
		dbSetOrder(1)
		If SCP->(dbSeek(xFilial("SCP")+aItem[Ny,10]+aItem[Ny,11]))
			aCamposSCP := { {"CP_NUM" ,SCP->CP_NUM ,Nil },;
				{"CP_ITEM" ,SCP->CP_ITEM ,Nil },;
				{"CP_PRODUTO" 		,SCP->CP_PRODUTO,Nil },;
				{"CP_UM" ,cUM ,Nil },;
				{"CP_QUANT" ,aItem[Ny,4] ,Nil }}

			IF !xCtrlLote

				aCamposSD3 := { {"D3_TM" ,"501" ,Nil },; // Tipo do Mov.
					{"D3_COD" 		,SCP->CP_PRODUTO,Nil },;
					{"D3_LOCAL" 	,'01'  ,Nil },;  // SCP-CP_LOCAL
					{"D3_DOC" 	  	,"" ,Nil },; // No.do Docto.
					{"D3_QUANT"   ,aItem[Ny,4]     ,Nil }, ; // Quantidade
					{"D3_EMISSAO" ,DDATABASE ,Nil }}
					// {"D3_LOCAL" 	,,aItem[Ny,8]  ,Nil },;
			ELSE
				aCamposSD3 := { {"D3_TM" ,"501" ,Nil },; // Tipo do Mov.
					{"D3_COD" 		,SCP->CP_PRODUTO,Nil },;
					{"D3_LOCAL" 	,'01' ,Nil },;  // SCP-CP_LOCAL
					{"D3_DOC" 	  	,"" ,Nil },; // No.do Docto.
					{"D3_QUANT"   ,aItem[Ny,4]     ,Nil }, ; // Quantidade
					{"D3_LOTECTL" 	,aItem[Ny,3] ,Nil },; // No.do Docto.
					{"D3_DTVALID" 	,CTOD(aItem[Ny,6]) ,Nil },; // No.do Docto.
					{"D3_LOCALIZ"	,aItem[Ny,5] ,Nil },; // No.do Docto.
					{"D3_EMISSAO" ,DDATABASE ,Nil }}
			EndIF
			lMSHelpAuto := .F.
			lMsErroAuto := .F.

			MSExecAuto({|v,x,y,z,w| mata185(v,x,y,z,w)},aCamposSCP,aCamposSD3,1)   // 1 = BAIXA (ROT.AUT)

			If lMsErroAuto
				RollbackSx8()
				aLogAuto := GetAutoGRLog()
				Aviso("ATENCAO", "Nao foi possivel EFETUAR as transferencias.", {"OK"}, 2, "", , , , 1500)
				MostraErro()
				DisarmTransaction()
			EndIf

			If !lMsErroAuto
				FWAlertSuccess('Transferencia efetivada','Sucesso')
			EndIf
		EndIF

	Next Ny
	EndTran()

return
