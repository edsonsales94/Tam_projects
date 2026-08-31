#INCLUDE 'PROTHEUS.CH'
#Include "TOTVS.CH"
#Include "FWMVCDef.ch"
/*/{Protheus.doc} M261BCHOI

/*/
#DEFINE CRLF ( chr(13)+chr(10) )

User Function MTTRANS()
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
	Private xXQrCode1 := ''
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

	// nJanLarg:=1200
	// nJanAltu:=600

	//Adiciona as colunas que serão criadas na temporária
	aAdd(aCampos, { 'OK', 'L', 1, 0}) //Flag para marcação
	aAdd(aCampos, { 'BF_PRODUTO', 'C', TamSX3("BF_PRODUTO")[1], 0}) //Filial
	aAdd(aCampos, { 'B1_DESC', 'C', TamSX3("B1_DESC")[1], 0}) //Pedido
	aAdd(aCampos, { 'BF_QUANT', 'N', TamSX3("BF_QUANT")[1], TamSX3("BF_QUANT")[2]}) //Fornecedor
	aAdd(aCampos, { 'BF_LOCAL', 'C', TamSX3("BF_LOCAL")[1], 0}) //Produto
	aAdd(aCampos, { 'BF_LOCALIZ', 'C', TamSX3("BF_LOCALIZ")[1], 0}) //Produto
	aAdd(aCampos, { 'B8_LOTECTL', 'C', TamSX3("B8_LOTECTL")[1], 0}) //Produto
	aAdd(aCampos, { 'B8_DTVALID', 'C', TamSX3("B8_DTVALID")[1], 0}) //Produto
	aAdd(aCampos, { 'XNOTAS',     'C', 250, 0}) //NOTAS

	//Cria a tabela temporária
	oTempTable:= FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields( aCampos )
	oTempTable:AddIndex("1", {"BF_PRODUTO","B8_LOTECTL"} )
	oTempTable:Create()

	//Popula a tabela temporária
	Processa({|| fPopula('')}, 'Processando...')

	//Adiciona as colunas que serão exibidas no FWMarkBrowse
	aColunas := fCriaCols()

	aSeek := {}
	cCampoAux := "BF_PRODUTO"
	aAdd(aSeek,{GetSX3Cache(cCampoAux, "X3_TITULO"), {{"", GetSX3Cache(cCampoAux, "X3_TIPO"), GetSX3Cache(cCampoAux, "X3_TAMANHO"), GetSX3Cache(cCampoAux, "X3_DECIMAL"), AllTrim(GetSX3Cache(cCampoAux, "X3_TITULO")), AllTrim(GetSX3Cache(cCampoAux, "X3_PICTURE"))}} } )
	cCampoAux := "BF_LOTECTL"
	aAdd(aSeek,{GetSX3Cache(cCampoAux, "X3_TITULO"), {{"", GetSX3Cache(cCampoAux, "X3_TIPO"), GetSX3Cache(cCampoAux, "X3_TAMANHO"), GetSX3Cache(cCampoAux, "X3_DECIMAL"), AllTrim(GetSX3Cache(cCampoAux, "X3_TITULO")), AllTrim(GetSX3Cache(cCampoAux, "X3_PICTURE"))}} } )

	//Criando a janela
	DEFINE MSDIALOG oDlgMark TITLE 'Tela de transferencia 20 / 01' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL

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
	oSayTitulo := TSay():New(15, 	005, {|| 'QRCode:'}, 	oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// oSayTitulo := TSay():New(15, 	290, {|| 'Endereco:'},	oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSayTitulo := TSay():New(15, 	270, {|| 'Codigo:'}, 	oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// oSayTitulo := TSay():New(15,	395, {|| 'Quantidade:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )

	// cCombo1:= aItems[1]
	xXQrCode1 := space(100)
	oTGet1 := TGet():New( 10,040,{|u| if( Pcount( )>0, xXQrCode1 := u, xXQrCode1) },oDlgMark,220,20,"@!", ,0,,,.F.,,.T.,,.F.,/*{|| x_loadCli(oBrowse,xxEndDest)}*/,.F.,.F.,,.F.,.F.,,'xXQrCode1',,,,,,, )
	oTGet1:bValid := {||  X_LOADCLI(oMarkBrowse,fRet(xXQrCode1),.T.) }

	// xxEndDest := space(tamsx3('BF_LOCALIZ')[1])
	// oTGet2 := TGet():New( 10,0350,{|u| if( Pcount( )>0, xxEndDest := u, xxEndDest) },oDlgMark,120,20,"@!", ,0,,,.F.,,.T.,,.F.,{|| U_zVid46Ok()},.F.,.F.,,.F.,.F.,,xxEndDest,,,, )

	xXCodigo := space(tamsx3('B2_COD')[1])
	oTGet3 := TGet():New( 10,295,{|u| if( Pcount( )>0, xXCodigo := u, xXCodigo) },oPanHeader,90,20,"@!", ,0,,,.F.,,.T.,,.F.,/*{|| x_loadCli(oBrowse,xXCodigo)}*/,.F.,.F.,,.F.,.F.,,xXCodigo,,,, )
	oTGet3:bValid := {||  X_LOADCLI(oMarkBrowse,xXCodigo,.F.) }

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
	ADD OPTION aRotina TITLE 'Confirmar'  ACTION 'u_zVid46Ok'     OPERATION 2 ACCESS 0
	// ADD OPTION aRotina TITLE 'Ver Nota'  ACTION  'u_fVerNota'     OPERATION 2 ACCESS 0

Return aRotina

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


/*/{Protheus.doc} FECHAR/*/

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

Static Function fPopula(_cCod)
	Local nTotal := 0
	Local nAtual := 0
	Local cAliasNew := GetNextAlias()
	Local cFilterBF := ''
	Local cFilterB2 := ''

	DEFAULT _cCod := ''

	cFilterBF += "%"
	cFilterB2 += "%"
	if !Empty(_cCod)
		if !Empty(xXLote)
			cFilterBF += "BF_LOTECTL = '"+xXLote+"' AND "
		endif
		cFilterBF += "BF_PRODUTO = '"+_cCod+"'"

		cFilterB2 += "B2_COD = '"+_cCod+"'"
	else
		cFilterBF += "BF_PRODUTO != '' "
		cFilterB2 += "B2_COD != '' "
	endif
	cFilterB2 += "%"
	cFilterBF += "%"

	BeginSql Alias cAliasNew
        SELECT BF_PRODUTO,B1_DESC,BF_QUANT,BF_LOCAL,BF_LOCALIZ, B8_SALDO,BF_LOTECTL,B8_LOTECTL,B8_DTVALID 
		FROM SBF010 BF
            inner join %table:SB1% B1 ON B1.D_E_L_E_T_='' AND B1_COD = BF_PRODUTO
            LEFT JOIN %table:SB8% B8 ON B8.D_E_L_E_T_='' AND BF_PRODUTO=B8_PRODUTO and  BF_LOTECTL=B8_LOTECTL 
            and BF_LOCAL=B8_LOCAL AND B8_SALDO>0 
        WHERE BF.D_E_L_E_T_ ='' AND BF_LOCAL = '20' and BF_LOCALIZ = 'PADRAO' AND  %EXP:cFilterBF%

		UNION ALL 

		SELECT B2_COD,B1_DESC,B2_QATU,B2_LOCAL,'', '','','','' from %table:SB2% B2
		INNER JOIN %table:SB1% B1 ON B1.D_E_L_E_T_='' AND  B1_COD=B2_COD AND B1_RASTRO ='N' AND B1_LOCALIZ='N'
		WHERE B2.D_E_L_E_T_='' AND B2_LOCAL = '20'
		AND B2_QATU > 0 AND %EXP:cFilterB2%

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

		cNotas := fBuscaNF((cAliasNew)->BF_PRODUTO,(cAliasNew)->B8_LOTECTL,(cAliasNew)->B8_DTVALID)
		RecLock(cAliasTmp, .T.)
		(cAliasTmp)->OK := IIF(Empty(_cCod), .F.,.T.)
		(cAliasTmp)->BF_PRODUTO := (cAliasNew)->BF_PRODUTO
		(cAliasTmp)->B1_DESC 	:= (cAliasNew)->B1_DESC
		(cAliasTmp)->BF_QUANT 	:= (cAliasNew)->BF_QUANT
		(cAliasTmp)->BF_LOCAL 	:= (cAliasNew)->BF_LOCAL
		(cAliasTmp)->BF_LOCALIZ := (cAliasNew)->BF_LOCALIZ
		(cAliasTmp)->XNOTAS 	:= cNotas
		(cAliasTmp)->B8_LOTECTL := (cAliasNew)->B8_LOTECTL
		(cAliasTmp)->B8_DTVALID := (cAliasNew)->B8_DTVALID

		(cAliasTmp)->(MsUnlock())

		(cAliasNew)->(DbSkip())
	EndDo
	(cAliasNew)->(DbCloseArea())
	(cAliasTmp)->(DbGoTop())
Return

/*/{Protheus.doc} fCriaCols
Função que gera as colunas usadas no browse (similar ao antigo aHeader)
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
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
	aAdd(aEstrut, { 'BF_PRODUTO', 'Produto', 'C',10, 0, ''})
	aAdd(aEstrut, { 'B1_DESC'	, 'Descricao', 'C',  25, 0, ''})
	aAdd(aEstrut, { 'BF_QUANT'	, 'Quantidade', 'N', 8 ,TamSX3("BF_QUANT")[2], ''})
	aAdd(aEstrut, { 'BF_LOCAL'	, 'Armazen', 'C', TamSX3("BF_LOCAL")[1], 0, ''})
	aAdd(aEstrut, { 'BF_LOCALIZ', 'Endereco', 'C',  TamSX3("BF_LOCALIZ")[1], 0, ''})
	aAdd(aEstrut, { 'B8_LOTECTL', 'Lote', 'C', TamSX3("B8_LOTECTL")[1], 0, ''})
	aAdd(aEstrut, { 'B8_DTVALID', 'Validade', 'C',  TamSX3("B8_DTVALID")[1], 0, ''})
	aAdd(aEstrut, { 'XNOTAS'	,   'Notas Fiscais', 'C',  250, 0, ''})

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

/*/{Protheus.doc} User Function zVid46Ok
Função acionada pelo botão continuar da rotina
@author EDSON SALES
@since 20/07/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

User Function zVid46Ok()
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
				(cAliasTmp)->BF_PRODUTO,;
				(cAliasTmp)->B1_DESC,;
				(cAliasTmp)->BF_QUANT,;
				(cAliasTmp)->BF_LOCAL,;
				(cAliasTmp)->BF_LOCALIZ,;
				(cAliasTmp)->B8_LOTECTL,;
				dtoc(stod((cAliasTmp)->B8_DTVALID)),;
				nQtdTransf,;
				xxEndDest;
				})
		EndIf
		// (cAliasTmp)->B8_SALDO,;
			// (cAliasTmp)->B8_LOTECTL;

		(cAliasTmp)->(DbSkip())

	EndDo

	fTransferencia(aCols)

	FWRestArea(aArea)
Return

Static Function X_LOADCLI(oBrowse, cCodigo, lQr)
	Local cFilter := ""

	If !Empty(AllTrim(cCodigo))
		cFilter :=cCodigo
	Else
		cFilter := ""
	EndIf

	// LIMPA TEMPORARIA
	(cAliasTmp)->(AVZAP())
	fPopula(cFilter)
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:refresh()
	oMarkBrowse:GoTop(.T.)

	if lQr .AND. !Empty(xXQrCode1)
		u_zVid46Ok()
		lQr := .F.

		// LIMPA TEMPORARIA
		(cAliasTmp)->(AVZAP())
		cFilter:= ''
		fPopula(cFilter)
		oMarkBrowse:SetAlias(cAliasTmp)
		oMarkBrowse:refresh()
		oMarkBrowse:GoTop(.T.)
	endif
	xXLote := ''
Return


/*/{Protheus.doc} fBuscaNF
	(long_description)
	@type  Static Function
	@author Edson Sales
	@since 20/02/2026
/*/
Static Function fBuscaNF(_cProd,_cLote,_cValid)
	Local cAliasNF := GetNextAlias()

	if Empty(_cLote)
		Return
	endif

	BeginSql alias cAliasNF
		SELECT D1_DOC
		FROM SD1010 
		WHERE D1_COD = %exp:_cProd%
		AND D1_LOTECTL = %exp:_cLote%
		AND D1_DTVALID = %exp:_cValid%
		GROUP BY D1_DOC
	EndSql
	cNF := ''
	while !(cAliasNF)->(Eof())
		cNF += (cAliasNF)->D1_DOC +' / '
		(cAliasNF)->(DbSkip())
	EndDo
	cNF := SUBSTR(cNF,1,LEN(cNF)-3)
Return cNF

/*/{Protheus.doc} fTransferencia
aCols	Realiza transferencia dos produtos empenhados das ops firmadas
	@type  Static Function
	@author matheus.vinicius@tamservice.com.br
	@since 23/08/2023
/*/

// Static Function fTransferencia(aCols)
// 	Local aAuto     := {}
// 	Local aItem     := {}
// 	Local nX        := Nil
// 	Local cLog      := ""
// 	Local cOps      := ""
// 	Local cAliasNew := GetNextAlias()
// 	Local cDocumen  := GetSxeNum("SD3","D3_DOC")
// 	Local cUsuario  := RETCODUSR()
// 	LOCAL lTransf 	:= .F.

// 	Local cLocaliz  := SPACE(TAMSX3("BE_LOCALIZ")[1])
// 	Local cNumseri  := SPACE(TAMSX3("D3_NUMSERI")[1])

// 	aItem := {}
// 	aAuto     := {}

// 	for nx := 1 to len(aCols)

// 		if !Empty(acols[nx,9]) .and. !Empty(acols[nx,8]) .and. !Empty(acols[nx,1])
// 			DbSelectArea('SBF')
// 			DbSetOrder(1)

// 			if SBF->(MsSeek(xFilial('SBF')+'01'+Alltrim(acols[nx,9])))
// 				while !SBF->(EoF()) .and. AllTrim(SBF->BF_LOCALIZ) == Alltrim(acols[nx,9])
// 					if AllTrim(SBF->BF_PRODUTO) <> AllTrim(acols[nx,1])
// 						FWAlertError(;
// 							"Ja existe outro produto cadastrado neste endereco." + CRLF + ;
// 							"Produto Cadastrado: " + AllTrim(SBF->BF_PRODUTO) + CRLF + ;
// 							"Endereco: " + Alltrim(acols[nx,9]) + CRLF + CRLF + ;
// 							"Cada endereco so pode conter um unico produto.", "Nao Enderecado!" )
// 						return .F.
// 					elseif AllTrim(SBF->BF_LOTECTL) <> AllTrim(acols[nx,6])
// 						if !FWAlertYesNo(;
// 								"O endereco informado ja esta vinculado a outro lote." + CRLF + ;
// 								"Lote Existente: " + AllTrim(SBF->BF_LOTECTL) + CRLF + ;
// 								"Lote Informado: " + AllTrim(acols[nx,6]) + CRLF + CRLF + ;
// 								"deseja enderecar lotes diferentes no mesmo endereco ?","Atencao!!! Lote diferentes!" )
// 							return .F.
// 						Else
// 							Exit
// 						EndIf
// 					else
// 						if !FWAlertYesNo(;
// 								"Ja existe um saldo produto informado neste endereco." + CRLF + ;
// 								"Produto Informado: " + cValToChar(SBF->BF_PRODUTO) + CRLF + ;
// 								"Saldo Existente: " + cValToChar(SBF->BF_QUANT) + CRLF + ;
// 								"Saldo a Enderecar: " + Alltrim(cValToChar(acols[nx,8]))+ CRLF + CRLF + ;
// 								"deseja enderecar o saldo de "+ Alltrim(cValToChar(acols[nx,8])) +" no endereco "+ Alltrim(acols[nx,9]) +" ?","Atencao!!! Saldo no endereco!" )
// 							return .F.
// 						Else
// 							Exit
// 						EndIf
// 					endif
// 					SBF->(DbSkip())
// 				EndDo
// 			endif

// 			lTransf := .T.
// 			aAdd(aItem,{acols[nx,1],; //codigo
// 			acols[nx,2],; //descricao
// 			acols[nx,4],; // amrmazem orig
// 			acols[nx,5],; // endereco orig
// 			acols[nx,6],; // lote
// 			CTOD(acols[nx,7]),; // validade
// 			val(acols[nx,8]),;  // quantidade
// 			'01',;  //armazem destino
// 			acols[nx,9]}) // endereco destino
// 		endif
// 	next nx

// 	if lTransf
// 		excecTranf(aItem)

// 		// LIMPA TEMPORARIA
// 		(cAliasTmp)->(AVZAP())
// 		fPopula('')
// 		oMarkBrowse:SetAlias(cAliasTmp)
// 		oMarkBrowse:refresh()
// 		oMarkBrowse:GoTop(.T.)
// 	endif

// Return .T.
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


	aItem := {}
	aAuto     := {}

	for nx := 1 to len(aCols)

		oDlg:= TDialog():New(180,180,550,800,'Tranferir para Armazem 01',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

		oSay1  := TSay():New(10,10,{|| 'Produto: '},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(10,103,{|| acols[nx,1]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)
		oSay1  := TSay():New(10,195,{|| 'Saldo: '},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(10,235,{|| acols[nx,3]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(25,10,{|| 'Armazem Origem:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(25,103,{|| acols[nx,4]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(40,10,{|| 'Endereço Origem:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(40,103,{|| acols[nx,5]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(55,10,{|| 'Lote:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(55,103,{|| acols[nx,6]},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		oSay1 := TSay():New(70,10,{|| 'Quantidade'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)

		if acols[nx,8] > 0
			nQuant := acols[nx,8]
			oSay1 := TSay():New(70,103,{|| acols[nx,8]},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		Else
			oTGet1 := TGet():New( 70,103,{|u| if( Pcount( )>0, nQuant := u, nQuant) },oDlg,70,009,"@E 999999999", ,0,,,.F.,,.T.,,.F.,/**/,.F.,.F.,,.F.,.F.,,,,,, )
		endif

		oSay1 := TSay():New(90,10,{|| 'Armazem Destino:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oSay2  := TSay():New(90,103,{|| '01'},oDlg,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

		xxEndDest := space(20)
		oSay1 := TSay():New(110,10,{|| 'Endereço Destino:'},oDlg,,oFont,,,,.T.,,,400,300,,,,,,)
		oTGet2 := TGet():New( 110,103,{ |u| If(PCount() > 0, xxEndDest := u, xxEndDest) },oDlg,096,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,xxEndDest,,,,.T.,.F. )
		if !Empty(xXQrCode1)
			oTGet2:bValid := {||  oDlg:end(),iif(!Empty(xxEndDest),AltOpt(@nOpc1,1),AltOpt(@nOpc1,2)) }
		endif
		oTGet2:CF3 :='SBE'

		if Empty(acols[nx,5])
			oTGet2:lActive    := .F.
		endif

		lCtrlEnd := IIF(posicione('SB1',1,XFILIAL('SB1')+acols[nx,1],'B1_LOCALIZ')=='N',.F.,.T.)
		if Empty(xXQrCode1) .OR. !lCtrlEnd  // Sse não controlar endereço.
			oTButton1 := TButton():New( 170, 115, "Transferir"	 ,oDlg,{|| oDlg:end(),AltOpt(@nOpc1,1)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		endif
		oTButton2 := TButton():New( 170, 165, "Cancelar"	 ,oDlg,{|| oDlg:end(),AltOpt(@nOpc1,2)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton3 := TButton():New( 170, 210, "Cancelar Tudo",oDlg,{|| oDlg:end(),AltOpt(@nOpc1,0)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		// ativa diálogo centralizado

		//Adicionando A QUANTIDADE E ENDEREÇO DESTINO

		oDlg:Activate()

		if nOpc1 == 1
			DbSelectArea('SBF')
			DbSetOrder(1)

			if SBF->(MsSeek(xFilial('SBF')+'01'+Alltrim(xxEndDest)))
				while !SBF->(EoF()) .and. AllTrim(SBF->BF_LOCALIZ) == Alltrim(xxEndDest)
					if AllTrim(SBF->BF_PRODUTO) <> AllTrim(acols[nx,1])
						FWAlertError(;
							"Ja existe outro produto cadastrado neste endereco." + CRLF + ;
							"Produto Cadastrado: " + AllTrim(SBF->BF_PRODUTO) + CRLF + ;
							"Endereco: " + Alltrim(xxEndDest) + CRLF + CRLF + ;
							"Cada endereco so pode conter um unico produto.", "Nao Enderecado!" )
						return .F.
					elseif AllTrim(SBF->BF_LOTECTL) <> AllTrim(acols[nx,6])
						if !FWAlertYesNo(;
								"O endereco informado ja esta vinculado a outro lote." + CRLF + ;
								"Lote Existente: " + AllTrim(SBF->BF_LOTECTL) + CRLF + ;
								"Lote Informado: " + AllTrim(acols[nx,6]) + CRLF + CRLF + ;
								"deseja enderecar lotes diferentes no mesmo endereco ?","Atencao!!! Lote diferentes!" )
							return .F.
						Else
							Exit
						EndIf
					else
						if !FWAlertYesNo(;
								"Ja existe um saldo produto informado neste endereco." + CRLF + ;
								"Produto Informado: " + cValToChar(SBF->BF_PRODUTO) + CRLF + ;
								"Saldo Existente: " + cValToChar(SBF->BF_QUANT) + CRLF + ;
								"Saldo a Enderecar: " + cValToChar(nQuant)+ CRLF + CRLF + ;
								"deseja enderecar o saldo de "+ cValToChar(nQuant) +" no endereco "+ Alltrim(xxEndDest) +" ?","Atencao!!! Saldo no endereco!" )
							return .F.
						Else
							Exit
						EndIf
					endif
					SBF->(DbSkip())
				EndDo
			endif

			aAdd(aItem,{acols[nx,1],; //codigo
			acols[nx,2],; //descricao
			acols[nx,4],; // amrmazem orig
			acols[nx,5],; // endereco orig
			acols[nx,6],; // lote
			CTOD(acols[nx,7]),; // validade
			(nQuant),;  // quantidade
			'01',;  //armazem destino
			Alltrim(xxEndDest)}) // endereco destino
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
	fPopula('')
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:refresh()
	oMarkBrowse:GoTop(.T.)

	xXCodigo := space(tamsx3('B2_COD')[1])
	xXQrCode1:= space(100)
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
	Local  aItExec := {}
	Local CUN := ''
	Local cDocumen  := GetSxeNum("SD3","D3_DOC")
	Private  lMsErroAuto := .F.

	BeginTran()

	if Empty(aAuto)
		aadd(aAuto,{cDocumen,dDataBase})
	endif

	For Ny := 1 TO LEN(aItem)
		CUN := POSICIONE('SB1',1,XFILIAL('SB1')+aItem[Ny,1],'B1_UM')
		aItExec :={}
		//Origem
		aadd(aItExec,{"D3_COD"    , aItem[Ny,1]	, Nil})
		aadd(aItExec,{"D3_DESCRI" , aItem[Ny,2]	, Nil})
		aadd(aItExec,{"D3_UM"     , CUN			, Nil})
		aadd(aItExec,{"D3_LOCAL"  , aItem[Ny,3]	, Nil})
		aadd(aItExec,{"D3_LOCALIZ", aItem[Ny,4]	, Nil})

		//Destino
		aadd(aItExec,{"D3_COD"    ,  aItem[Ny,1]	  , Nil})
		aadd(aItExec,{"D3_DESCRI" ,  aItem[Ny,2]	  , Nil})
		aadd(aItExec,{"D3_UM"     ,  CUN		  , Nil})
		aadd(aItExec,{"D3_LOCAL"  ,  aItem[Ny,8]	  , Nil})
		aadd(aItExec,{"D3_LOCALIZ",  aItem[Ny,9]	  , Nil})

		//origem
		aadd(aItExec,{"D3_NUMSERI", ''				, Nil})
		aadd(aItExec,{"D3_LOTECTL",  aItem[Ny,5]		, Nil})
		aadd(aItExec,{"D3_NUMLOTE", ''				, Nil})
		aadd(aItExec,{"D3_DTVALID", aItem[Ny,6]		, Nil})

		aadd(aItExec,{"D3_POTENCI", 0				, Nil})
		aadd(aItExec,{"D3_QUANT"  ,  aItem[Ny,7]   	, Nil})

		aadd(aItExec,{"D3_QTSEGUM", 0             , Nil})
		aadd(aItExec,{"D3_ESTORNO", ""            , Nil})
		aadd(aItExec,{"D3_NUMSEQ" , ""            , Nil})

		//destino
		aadd(aItExec,{"D3_LOTECTL",  aItem[Ny,5]	  , Nil})
		aadd(aItExec,{"D3_NUMLOTE", ''		      , Nil})
		aadd(aItExec,{"D3_DTVALID", aItem[Ny,6]	  , Nil})

		aadd(aItExec,{"D3_ITEMGRD", ""                      		, Nil})
		aadd(aItExec,{"D3_OBS"    , "Transferencia recebimento" 	, Nil})
		aadd(aItExec,{"D3_CODLAN" , ""                      , Nil}) //cat83 prod origem
		aadd(aItExec,{"D3_CODLAN" , ""                      , Nil}) //cat83 prod destino
		aadd(aItExec,{"D3_USUARIO", UsrRetName(cUsuario)    , Nil})

		aAdd(aAuto,aItExec)
	Next Ny

	MSExecAuto({|x,y| MATA261(x,y)},aAuto, 3)

	If lMsErroAuto
		RollbackSx8()
		aLogAuto := GetAutoGRLog()
		Aviso("ATENCAO", "Nao foi possivel EFETUAR as transferencias.", {"OK"}, 2, "", , , , 1500)
		MostraErro()
		DisarmTransaction()

	EndIf

	If !lMsErroAuto
		EndTran()
		FWAlertSuccess('Transferencia efetivada','Sucesso')
	EndIf

Return
