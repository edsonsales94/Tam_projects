#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

User Function MCETIQ06()
	// Local nLargBtn      := 50
	local nx :=0
	Private aBrowse:= {{.F.,'','','','','','','',''}}
	//Private aDadosBRW:= {{space(20),0}}
	Private aColunas:= {"Volume","Quantidade","NÂº do Lote"}
	Private lConfirm := .F.
	Private cProdAtual := ''
	//Objetos e componentes
	Private oDlg
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


	// RpcSetEnv('01','01')

	// cAlias    := "SZ7"
	// cArquivo  := RETSQLNAME('SZ7')
	// CheckFile(cAlias, cArquivo)

	cAno := cvaltochar(year(date()))

	//Cria a janela
	DEFINE MSDIALOG oDlg TITLE "Rastreabilidade - MASA DA AMAZONIA / "+cAno+" - v1.0.0.1"  FROM 200, 200 TO nJanAltu, nJanLarg PIXEL

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlg,.F.)

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
	oSayTitulo := TSay():New(004, 005, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSayTitulo := TSay():New(014, 005, {|| 'Produto:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// oSayTitulo := TSay():New(014, 250, {|| 'Matricula:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	cTGet1 := space(tamsx3('C2_PRODUTO')[1])
	oTGet1 := TGet():New( 014,080,{|u| if( Pcount( )>0, cTGet1 := u, cTGet1) },oDlg,120,20,"@!",,0,,,.F.,,.T.,,.F.,{|| x_load(cTGet1)},.F.,.F.,,.F.,.F.,,cTGet1,,,, )

	// cTGet2 := '      '//space(tamsx3('Z7_ETIQMAE')[1])
	// oTGet2 := TGet():New( 014,280,{|u| if( Pcount( )>0, cTGet2 := u, cTGet2) },oDlg,80,20,"@!",,0,,,.F.,,.T.,,.F.,{|| IIF(Empty(cTGet2),{|| Alert('Informe o RE'),.F.},.T.)},.F.,.F.,,.F.,.F.,,cTGet2,,,, )

	oBtnSair := TButton():New(014, 200, "Confirmar",  oPanBut, {|| FnImp01()}, 50, 012, , oFontBtn, , .T., , , , , , )

	//dialog com browse para defir as notas fiscais
	oBrowse := fwBrowse():New()
	oBrowse:lHeaderClick:=.F.
	oBrowse:setDataArray()

	oBrowse:disableConfig()
	oBrowse:disableReport() //DTC_NFEID,DTC_CODPRO,DTC_PESO,DTC_PESOM3,DTC_METRO3,DTC_VALOR,DTC_QTDVOL
	oBrowse:setOwner( oPanGrid )
	oBrowse:AddMarkColumns( {||IIF(aBrowse[oBrowse:nAt,01],'LBOK','LBNO')}, {|| INVERT() /*,aBrowse[oBrowse:nAt,01]:= !aBrowse[oBrowse:nAt,01]*/ }/*[ bLDblClick]*/, /*[ bHeaderClick]*/ )
	oBrowse:addColumn({"Ordem Producao" ,	{||aBrowse[oBrowse:nAt,02]}, "C", "@!"	, 1, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xVolume"    })
	oBrowse:addColumn({"Produto      "	, 	{||aBrowse[oBrowse:nAt,03]}, "C", "@!"	, 2, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xQtdLote"    })
	oBrowse:addColumn({"Cod. Resina  "  ,	{||aBrowse[oBrowse:nAt,04]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Desc Resina  "  , 	{||aBrowse[oBrowse:nAt,05]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Emissao   "		, 	{||aBrowse[oBrowse:nAt,06]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Maquina "  	 	, 	{||aBrowse[oBrowse:nAt,07]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Molde "			, 	{||aBrowse[oBrowse:nAt,08]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Cod. Cliente "  , 	{||aBrowse[oBrowse:nAt,09]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
// 2_OP,C2_PRODUTO ,C2_PRODUTO,B1_DESC,C2_EMISSAO,C2_XMAQ,C2_XMOLDE,C2_XCODCLI
	oBrowse:setArray( aBrowse )
	oBrowse:SetLocate() // Habilita a LocalizaÃ§Ã£o de registros

	oBrowse:activate( )

	Activate MsDialog oDlg Centered

Return

/*/{Protheus.doc} x_load()
	(long_description)
	@type  Static Function
	@author user
	@since 17/01/2026
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function x_load(cTGet1)
	local aEtiq :={}
	if !(cProdAtual == cTGet1)   // so vai recarregar a grid se mudar o produto
		dbselectarea('SB1')
		dbsetorder(1)
		if SB1->(MSSEEK(XFILIAL('SB1')+cTGet1)) .AND.!Empty(cTGet1)
			Processa({|| aEtiq := fPopula(cTGet1)}, 'Processando...')
			aBrowse := aEtiq
			oBrowse:setArray(aBrowse)
			oBrowse:SetLocate()
			oBrowse:refresh()

			cProdAtual := cTGet1
		elseif !Empty(cTGet1)
			FWAlertInfo('o PRODUTO informado não foi encontrado...', 'Atencao !')
		endif
	endif

Return .T.

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fPopula(_cetiq)
	Local cQryDados := ''
	Local nTotal := 0
	Local nAtual := 0
	Local aDadosEtq := {}

	//Monta a consulta
	cQryDados += " SELECT C2_OP,C2_NUM,C2_PRODUTO,B1_DESC,C2_EMISSAO,C2_XMAQ,C2_XMOLDE,C2_XCODCLI   FROM "+RETSQLNAME('SC2') +  " C2 "  + CRLF
	//cQryDados += "  INNER JOIN SD4010 D4 ON D4.D_E_L_E_T_='' AND D4_OP =C2_NUM+C2_ITEM+C2_SEQUEN AND D4_LOCAL = 'WP' "  + CRLF
	cQryDados += "  INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_='' AND B1_COD = C2_PRODUTO  "  + CRLF
	// cQryDados += "  INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_='' AND B1_COD = C2_PRODUTO AND B1.B1_DESC LIKE ('%0103-%')  "  + CRLF
	cQryDados += "  WHERE C2.D_E_L_E_T_='' AND C2_PRODUTO = '" + _cetiq +"' " + CRLF
	cQryDados += "  AND C2_QUJE < C2_QUANT "  + CRLF
	cQryDados += "  AND C2_DATRF ='' "  + CRLF
	cQryDados += "  AND C2_TPOP = 'F' "  + CRLF
	cQryDados += "  ORDER BY C2_NUM "

	PLSQuery(cQryDados, 'QRYDADTMP')

	//Definindo o tamanho da régua
	DbSelectArea('QRYDADTMP')
	Count to nTotal
	ProcRegua(nTotal)
	('QRYDADTMP')->(DbGoTop())

	//Enquanto houver registros, adiciona na temporária
	While ! ('QRYDADTMP')->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
		aadd(aDadosEtq,{.F.,;
			('QRYDADTMP')->C2_NUM, ;
			('QRYDADTMP')->C2_PRODUTO,;
			('QRYDADTMP')->C2_PRODUTO,;
			('QRYDADTMP')->B1_DESC,;
			('QRYDADTMP')->C2_EMISSAO,;
			('QRYDADTMP')->C2_XMAQ,;
			('QRYDADTMP')->C2_XMOLDE,;
			('QRYDADTMP')->C2_XCODCLI;
			})

		('QRYDADTMP')->(DbSkip())
	EndDo
	('QRYDADTMP')->(DbCloseArea())

Return aDadosEtq


/*/{Protheus.doc} aBrowse
	(long_description)
	@type  Static Function
	@author user
	@since 15/07/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/

Static Function INVERT()

	LOCAL NX := 0
	LOCAL lMark:=aBrowse[oBrowse:nAt,01]
	LOCAL nPos := oBrowse:nAt

	if lMark // SE TA MARCADO DESMARCA E OS OUTROS PERMANECEM DESMARCADOS
		for NX := 1 to LEN(aBrowse)
			aBrowse[NX,1] := .F.
		next
	Else // SE NÃO TA MARCADO MARCA O OQUE FOI CLICADO, OS OUTROS PERMANECEM DESMARCADOS
		for NX := 1 to LEN(aBrowse)
			if NX == nPos
				aBrowse[NX,1] := .T.
			Else
				aBrowse[NX,1] := .F.
			endif
		next
	endif
	oBrowse:Refresh(.F.)
	oBrowse:GoTo( oBrowse:nAt,.F.)
// 	oBrowse:refresh()
// 	oBrowse:GoTo( oBrowse:nAt, .F. )
Return

Static Function FnImp01()
	// Local aArea := FwGetArea()
	Local aRet := {}
	Local aPergs := {}
	Local aImp := {}
	Local cPrinter := ''
	Local nx
	Local lBrowMark := .F.

	for NX := 1 to LEN(aBrowse)
		if aBrowse[nx,1]
			lBrowMark := .T.
		endif
		if !lBrowMark
			msgStop('Nenhuma OP Foi Selecionada')
			return
		endif
	next nx

	dbselectarea('CB5')
	CB5->(DbGoTop())
	while !CB5->(EOF())
		if 'MCETIQ06' $ CB5->CB5_ROTINA  // fonte setado no cadastro de impressoras
			AADD(aImp, alltrim(CB5->CB5_PRINTR))
		endif
		CB5->(dbskip())
	EndDo

	aAdd(aPergs,{1,"Quant Etiqueta: " ,Space(4),"","!Empty(MV_PAR01)","","",0 ,.F.})
	aAdd(aPergs,{1,"Densidade: " ,'22',"","","","",0 ,.F.})
	// aAdd(aPergs,{2, "Impressora",cPrinter, {"ZT410","ZT411","ZM400"},     122, ".T.", .F.})
	aAdd(aPergs,{2, "Impressora",cPrinter, aImp, 122, ".T.", .F.})

	If !ParamBox(aPergs ,"Etiquetas ...",@aRet,,,,,,,,.F.,.T.)
		Return
	Else
		Processa( {|| xfImpPA() }, "Aguarde...","Imprimindo...",.F.)
	Endif

Return

Static Function xfImpPA()
	Local nX := 0
	Local cLabel  := ""
	Local cMsg := ''
	Local cData := ''
	Local cPrinter := ALLTRIM(MV_PAR03)
	Local cDtHoraAt := DTOC(DDATABASE) +'-'+ TIME()

	Local nOpc  := 0
	Local Nz := 0
	Local aBRW_OK := {}

	for Nz := 1 to LEN(aBrowse)
		if aBrowse[nZ,1]
			aadd(aBRW_OK ,aBrowse[nZ])
		endif
	next nZ

	cMsg += 'Verifique a data correta para impressao da etiqueta.' + CHR(13)+CHR(10)
	cMsg += 'Dia Atual : ' +DTOC(ddatabase) + CHR(13)+CHR(10)
	cMsg += 'Dia Seginte : ' +DTOC(DaySum(ddatabase,1)) + CHR(13)+CHR(10)


//nOpc := Aviso( "DevAdvPL", 'Mensagem', { "Sim", "Não", "Sim - Todos", "Não - Todos", 3, "Titulo da Descrição",, 'ROTINAAUTO', } )
//nOpc := Aviso( "DevAdvPL", 'Mensagem', { "Sim", "Não", "Sim - Todos", "Não - Todos" } )


	if cDtHoraAt >= DTOC(DDATABASE) + '-07:00:00' .AND. cDtHoraAt <= DTOC(DDATABASE) + '-14:59:00'
		cTurno := '2 Turno'
		cData := DTOC(ddatabase)
	elseif cDtHoraAt >= DTOC(DDATABASE) + '-15:00:00' .AND. cDtHoraAt <= DTOC(DDATABASE) + '-22:59:00'
		cTurno := '3 Turno'
		cData := DTOC(ddatabase)
	else
		cTurno := '1 Turno'
		IF left(TIME(),2) == '23'
			nOpc := Aviso( "Aviso", cMsg , { "Dia Atual","Dia seguinte"},	3, "Leia com atencao !!!",, 'ROTINAAUTO', .F.)
			If nOpc == 1
				cData := DTOC(ddatabase)
			ElseIf nOpc == 2
				cData := DTOC(DaySum(ddatabase,1))
			Endif
		endif
	endif

	cLabel:= ""

	cLabel+= (" CT~~CD,~CC^~CT~  ")
	cLabel+= (" ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR6,6 ")
	cLabel+= (" ~SD"+alltrim(MV_PAR02)) // desidade de impressão
	cLabel+= (" ^JUS^LRN^CI0^XZ  ")
	cLabel+= (" ^XA  ")
	cLabel+= (" ^MMT  ")
	cLabel+= (" ^PW449  ")
	cLabel+= (" ^LL0146  ")
	cLabel+= (" ^LS0  ")
	if len(alltrim(aBRW_OK[1,5]))  > 42
		cLabel+= (" ^FT7,47^A0N,17,16^FH\^FD"+left(alltrim(aBRW_OK[1,5]),42)+"^FS  ")
		cLabel+= (" ^FT7,71^A0N,17,16^FH\^FD"+substr(alltrim(aBRW_OK[1,5]),43)+"^FS  ")
	else
		cLabel+= (" ^FT7,47^A0N,17,16^FH\^FD"+alltrim(aBRW_OK[1,5])+"^FS  ")
	endif
	cLabel+= (" ^FT240,102^A0N,21,19^FH\^FD"+cData+"^FS  ")
	cLabel+= (" ^FT142,102^A0N,21,19^FH\^FD"+alltrim(aBRW_OK[1,7])+"^FS  ")
	cLabel+= (" ^FT358,102^A0N,21,19^FH\^FD"+cTurno+"^FS  ")
	cLabel+= (" ^FT7,102^A0N,21,19^FH\^FD"+alltrim(aBRW_OK[1,3])+"^FS  ")
	cLabel+= (" ^PQ"+alltrim(MV_PAR01))
	cLabel+= (",0,1,Y^XZ  ")

	// cLabel+= (" CT~~CD,~CC^~CT~ ")
	// cLabel+= (" ^XA   			")
	// cLabel+= (" ~TA000   		")
	// cLabel+= (" ~JSN   			")
	// cLabel+= (" ^LT35  		 	")
	// cLabel+= (" ^MNW   			")
	// cLabel+= (" ^MTT   			")
	// cLabel+= (" ^PON   			")
	// cLabel+= (" ^PMN   			")
	// cLabel+= (" ^LH0,0   		")
	// cLabel+= (" ^JMA   			")
	// cLabel+= (" ^PR2,2   		")
	// cLabel+= (" ~SD"+alltrim(MV_PAR02)) // desidade de impressão
	// cLabel+= (" ^JUS   			")
	// cLabel+= (" ^LRN   			")
	// cLabel+= (" ^CI27   		")
	// cLabel+= (" ^PA0,1,1,0   	")
	// cLabel+= (" ^XZ      		")
	// cLabel+= (" ^XA      		")
	// cLabel+= (" ^MMT     		")
	// cLabel+= (" ^PW449   		")
	// cLabel+= (" ^LL150   		")
	// cLabel+= (" ^LS0   			")

	// if len(alltrim(aBRW_OK[1,5]))  > 42
	// 	cLabel+= (" ^FT7,39^A0N,17,18^FH\^CI28^FD"+left(alltrim(aBRW_OK[1,5]),42)+"^FS^CI27   ")
	// 	cLabel+= (" ^FT7,64^A0N,17,18^FH\^CI28^FD"+substr(alltrim(aBRW_OK[1,5]),43)+"^FS^CI27   ")
	// else
	// 	cLabel+= (" ^FT7,39^A0N,17,18^FH\^CI28^FD"+left(alltrim(aBRW_OK[1,5]),42)+"^FS^CI27   ")
	// endif

	// cLabel+= (" ^FT240,95^A0N,21,20^FH\^CI28^FD"+cData+"^FS^CI27   ")
	// cLabel+= (" ^FT142,95^A0N,21,20^FH\^CI28^FD"+alltrim(aBRW_OK[1,5])+"^FS^CI27   ")
	// cLabel+= (" ^FT358,95^A0N,21,20^FH\^CI28^FD"+cTurno+"^FS^CI27   ")
	// cLabel+= (" ^FT7,95^A0N,21,20^FH\^CI28^FD"+alltrim(aBRW_OK[1,3])+"^FS^CI27   ")
	// cLabel+= (" ^PQ1,0,1,Y   ")
	// cLabel+= (" ^XZ   ")

	impriRaw(cLabel,cPrinter)
	// Next
Return


// User function tValProd()
// 	local lret:= .F.
// 	dbselectarea('SB1')
// 	dbsetorder(1)

// 	if MSSEEK(xFilial('SB1')+MV_PAR01)
// 		lRet := .T.
// 	Else
// 		Alert('Produto não localizado !!!')
// 	EndIf

// return lret

// Exemplo de impressão RAW usando FWMSPrinter
Static Function impriRaw(cZPL,cPrinter)

	Local oPrinter   := Nil
	Local cFileRel   := "RAW_ETIQUETA" // pode ser apenas identificador
	Local lAdjustToLegacy   := .F.
	Local lDisableSetup     := .T.
	Local aPrint          := GetImpWindows(.F.)
	Local nPrtType          := 2 // IMP_PDF > 6 || IMP_SPOOL > 2
	Local oPrintSetupParam := Nil
	Local aDevice           := {}
	Local cSession          := GetPrinterSession()
	// Local oPrinter
	// Local cLocal            := "c:\temp"

		// Criar objeto FWMSPrinter em modo RAW
		oPrinter := FWMSPrinter():New(cFileRel, nPrtType, lAdjustToLegacy, '', lDisableSetup,.F.,NIL ,cPrinter ,.F. ,.T., .T. /*LRAW*/)
		// oPrinter:setup()

		// Aqui é só usar SAY, que em RAW escreve direto
		oPrinter:Say(0, 0, cZPL)

		oPrinter:Print()

Return .T.
