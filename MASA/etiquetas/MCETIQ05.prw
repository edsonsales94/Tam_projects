#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/*
impressão de etiqueta COALI
*/

User Function MCETIQ05()
	// Local nLargBtn      := 50
	local nx :=0
	local aForn := {}
	Private aBrowse:= {{.F.,'','','','','','','',''}}
	//Objetos e componentes
	Private oDlg
	Private oFwLayer
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

	// cAlias    := "SZ7"
	// cArquivo  := RETSQLNAME('SZ7')
	// CheckFile(cAlias, cArquivo)

	//Cria a janela
	cAno := cvaltochar(year(date()))

	//Cria a janela
	DEFINE MSDIALOG oDlg TITLE "Etiqueta COALI  - MASA DA AMAZONIA / "+cAno+" - v1.0.0.1"  FROM 200, 200 TO nJanAltu, nJanLarg PIXEL

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
	oSayTitulo := TSay():New(014, 005, {|| 'Nro. Etiqueta:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSayTitulo := TSay():New(014, 250, {|| 'Matricula:'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	cTGet1 := space(tamsx3('Z7_ETIQMAE')[1])
	oTGet1 := TGet():New( 014,080,{|u| if( Pcount( )>0, cTGet1 := u, cTGet1) },oDlg,120,20,"@!",,0,,,.F.,,.T.,,.F.,{|| x_load(cTGet1)},.F.,.F.,,.F.,.F.,,cTGet1,,,, )

	cTGet2 := '      '//space(tamsx3('Z7_ETIQMAE')[1])
	oTGet2 := TGet():New( 014,280,{|u| if( Pcount( )>0, cTGet2 := u, cTGet2) },oDlg,80,20,"@!",,0,,,.F.,,.T.,,.F.,{|| IIF(Empty(cTGet2),{|| Alert('Informe o RE'),.F.},.T.)},.F.,.F.,,.F.,.F.,,cTGet2,,,, )

	oBtnSair := TButton():New(014, 200, "Gerar coali",  oPanBut, {|| GeraCoal()}, 50, 012, , oFontBtn, , .T., , , , , , )
	oBtnSair := TButton():New(014, 260, "Ver Coali"  ,  oPanBut, {|| VerCoali(cTGet1)}, 50, 012, , oFontBtn, , .T., , , , , , )

	//dialog com browse para defir as notas fiscais
	oBrowse := fwBrowse():New()
	oBrowse:lHeaderClick:=.F.
	oBrowse:setDataArray()

	oBrowse:disableConfig()
	oBrowse:disableReport() //DTC_NFEID,DTC_CODPRO,DTC_PESO,DTC_PESOM3,DTC_METRO3,DTC_VALOR,DTC_QTDVOL
	oBrowse:setOwner( oPanGrid )
	oBrowse:AddMarkColumns( {||IIF(aBrowse[oBrowse:nAt,01],'LBOK','LBNO')}, {|| INVERT() /*,aBrowse[oBrowse:nAt,01]:= !aBrowse[oBrowse:nAt,01]*/ }/*[ bLDblClick]*/, /*[ bHeaderClick]*/ )
	oBrowse:addColumn({"Cod. Etiqueta" ,  	{||aBrowse[oBrowse:nAt,02]}, "C", "@!"	, 1, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xVolume"    })
	oBrowse:addColumn({"Cod. Masa    " , 	{||aBrowse[oBrowse:nAt,03]}, "C", "@!"	, 2, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xQtdLote"    })
	oBrowse:addColumn({"Cod. Cliente " ,  	{||aBrowse[oBrowse:nAt,04]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Descrição    " , 	{||aBrowse[oBrowse:nAt,05]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Quantidade   " , 	{||aBrowse[oBrowse:nAt,06]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Ord. Produção" , 	{||aBrowse[oBrowse:nAt,07]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Armazém      " , 	{||aBrowse[oBrowse:nAt,08]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })

	oBrowse:setArray( aBrowse )
	oBrowse:SetLocate() // Habilita a LocalizaÃ§Ã£o de registros

	oBrowse:activate( )

	Activate MsDialog oDlg Centered

	for NX := 1 to LEN(aBrowse)
		if aBrowse[nx,1]
			aadd(aForn,aBrowse[nx])
		endif
	next nx

Return(aForn)

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
	cQryDados += "SELECT * "        + CRLF
	cQryDados += "FROM SZ7010 SZ7 "        + CRLF
	cQryDados += "WHERE SZ7.D_E_L_E_T_ = ' ' AND Z7_ETIQMAE >= '" + _cetiq + "' AND Z7_ETIQMAE <= '" + _cetiq + "' "        + CRLF
	cQryDados += "and  Z7_COALI='' "        + CRLF
	cQryDados += "ORDER BY Z7_ETIQMAE"        + CRLF
	PLSQuery(cQryDados, 'QRYDADTMP')

	//Definindo o tamanho da régua
	DbSelectArea('QRYDADTMP')
	Count to nTotal
	ProcRegua(nTotal)
	('QRYDADTMP')->(DbGoTop())

	cUsuario := cTGet2 + ' - ' + UsrRetName(__cUserId)

	//Enquanto houver registros, adiciona na temporária
	While ! ('QRYDADTMP')->(EoF())
		nAtual++
		IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
		aadd(aDadosEtq,{.T.,;
			('QRYDADTMP')->Z7_ETIQMAE,;
			('QRYDADTMP')->Z7_PAMASA,;
			('QRYDADTMP')->Z7_CODCLI,;
			('QRYDADTMP')->Z7_DESCRI,;
			('QRYDADTMP')->Z7_QUANT,;
			('QRYDADTMP')->Z7_OP,;
			('QRYDADTMP')->Z7_LOCAL,;
			('QRYDADTMP')->Z7_MOLDE,;
			('QRYDADTMP')->Z7_CLIENTE,;
			cUsuario})

		('QRYDADTMP')->(DbSkip())
	EndDo
	('QRYDADTMP')->(DbCloseArea())

Return aDadosEtq



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

	dbselectarea('SZ7')
	dbsetorder(1)
	if SZ7->(MSSEEK(XFILIAL('SZ7')+cTGet1)) .AND.!Empty(cTGet1)
		Processa({|| aEtiq := fPopula(cTGet1)}, 'Processando...')
		aBrowse := aEtiq
		oBrowse:SetLocate()
		oBrowse:refresh()
	elseif !Empty(cTGet1)
		FWAlertInfo('A Etiqueta informada não foi encontrada...', 'Atencao !')
	endif

Return .T.

/*/{Protheus.doc} GeraCoal/*/
Static Function GeraCoal()
	Local xQtdQuebra := '      '
	Local aArea := FWGetArea()
	Local aPergs   := {}
	Local cPrinter := ''
	Local aImp := {}
	Local nx
	Local lBrowMark := .F.

	dbselectarea('CB5')
	while !CB5->(EOF())
		if 'MCETIQ05' $ CB5->CB5_ROTINA  // fonte setado no cadastro de impressoras
			AADD(aImp, alltrim(CB5->CB5_PRINTR))
		endif
		CB5->(dbskip())
	EndDo

	for NX := 1 to LEN(aBrowse)
		if aBrowse[nx,1]
			lBrowMark := .T.
		endif
		if !lBrowMark
			msgStop('Nenhuma OP Foi Selecionada')
			return
		endif
	next nx

	aAdd(aPergs,{1,"Quantidade: ",Space(4),"","!Empty(MV_PAR01)","","",0 ,.F.})
	aAdd(aPergs,{1,"Densidade: " ,'22',"","","","",0 ,.F.})
	// aAdd(aPergs,{2, "Impressora",cPrinter, {"ZT410","ZT411","ZM400"},     122, ".T.", .F.})
	aAdd(aPergs,{2,"Impressora",cPrinter, aImp,     122, ".T.", .F.})
	//Se a pergunta for confirma, chama a tela
	If ParamBox(aPergs, "Informe os parametros")
		xQtdQuebra := VAL(MV_PAR01)
		SaveCoaL(xQtdQuebra)
	EndIf

	RestArea(aArea)

Return Nil


/*/{Protheus.doc} aBrowsec/*/

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
	oBrowse:GoTo( oBrowse:nAt, .T. )
	// oBrowse:refresh()
Return

Static Function INVERT2()

	LOCAL NX := 0
	LOCAL lMark:=aBrw[oBrwCoali:nAt,01]
	LOCAL nPos := oBrwCoali:nAt

	if lMark // SE TA MARCADO DESMARCA E OS OUTROS PERMANECEM DESMARCADOS
		for NX := 1 to LEN(aBrw)
			aBrw[NX,1] := .F.
		next
	Else // SE NÃO TA MARCADO MARCA O OQUE FOI CLICADO, OS OUTROS PERMANECEM DESMARCADOS
		for NX := 1 to LEN(aBrw)
			if NX == nPos
				aBrw[NX,1] := .T.
			Else
				aBrw[NX,1] := .F.
			endif
		next
	endif
	oBrwCoali:GoTo( oBrwCoali:nAt, .T. )
	// oBrowse:refresh()
Return


Static Function SaveCoaL(_xQtdQuebra)
	// Local nX := 0
	Local cLabel  := ""
	Local CTMP  := GETNEXTALIAS()
	Local cQryDados := ''
	Local cPrinter := ALLTRIM(MV_PAR03)

	// abater a quantidade da COLALI do saldo da etiqueta MAE.
	AbatSald(_xQtdQuebra)

	if !aBrowse[1,1]
		FwAlertWarning('Nenhum Registro foi selecionado', 'Atenção!')
		Return
	EndIf

	cQryDados += "SELECT MAX(Z7_COALI) ULT_COALI  "        + CRLF
	cQryDados += "FROM SZ7010 SZ7 "        + CRLF
	cQryDados += "WHERE SZ7.D_E_L_E_T_ = ' ' "

	PLSQuery(cQryDados, CTMP)

	cCoali := cvaltochar(val(SOMA1(space(2)+alltrim((CTMP)->ULT_COALI)))) // incrementar o Numero do COALI.

	cQR := left(aBrowse[1,4],25)+;  // Cod. Cliente
	alltrim(aBrowse[1,2])+;			// Cod. Etiqueta Mae
	StrZero(_xQtdQuebra,5)+; 		// Quantidade
	cCoali							// Cod. COALI

	RECLOCK('SZ7', .T.)
	SZ7->Z7_ETIQMAE := aBrowse[1,2]
	SZ7->Z7_COALI   := cCoali
	SZ7->Z7_PAMASA 	:= aBrowse[1,3]
	SZ7->Z7_CODCLI 	:= aBrowse[1,4]
	SZ7->Z7_DESCRI 	:= aBrowse[1,5]
	SZ7->Z7_OP 		:= aBrowse[1,7]
	SZ7->Z7_QUANT 	:= _xQtdQuebra
	SZ7->Z7_LOCAL 	:= aBrowse[1,8]
	SZ7->Z7_MOLDE 	:= aBrowse[1,9]
	SZ7->Z7_QRCODE1	:= cQR
	SZ7->Z7_CLIENTE := aBrowse[1,10]
	SZ7->Z7_USUARIO := aBrowse[1,11]
	SZ7->(MsUnlock())

	cLabel:= ""

	cLabel+= (" CT~~CD,~CC^~CT~  ")
	cLabel+= (" ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR2,2")
	cLabel+= (" ~SD"+alltrim(MV_PAR02))
	cLabel+= ("^JUS^LRN^CI0^XZ  ")
	cLabel+= (" ^XA  ")
	cLabel+= (" ^MMT  ")
	cLabel+= (" ^PW945  ")
	cLabel+= (" ^LL0685  ")
	cLabel+= (" ^LS0  ")
	cLabel+= (" ^FT714,114^A0N,42,40^FH\^FD"+DTOC(ddatabase)+"^FS  ")
	// OP
	cLabel+= (" ^FT45,262^A0N,42,40^FH\^FDOP: ^FS  ")
	cLabel+= (" ^FT206,262^A0N,42,40^FH\^FD"+ALLTRIM(SZ7->Z7_OP)+"^FS  ")
	// QUANT
	cLabel+= (" ^FT45,312^A0N,42,40^FH\^FDQUANT: ^FS  ")
	cLabel+= (" ^FT206,312^A0N,42,40^FH\^FD"+;
		ALLTRIM(TRANSFORM(SZ7->Z7_QUANT,'@E 999.999'))+"^FS  ")
	// USUÁRIO
	cLabel+= (" ^FT45,362^A0N,29,26^FH\^FD"+AllTrim(SZ7->Z7_USUARIO)+"^FS  ")
	// cLabel+= (" ^FT45,262^A0N,42,40^FH\^FDQUANT: ^FS  ")
	// cLabel+= (" ^FT206,262^A0N,42,40^FH\^FD"+ALLTRIM(TRANSFORM(SZ7->Z7_QUANT,'@E 999.999'))+"^FS  ")
	// cLabel+= (" ^FT43,354^A0N,29,26^FH\^FD"+alltrim(SZ7->Z7_USUARIO)+"^FS  ")
	if len(alltrim(SZ7->Z7_DESCRI)) <= 48
		cLabel+= (" ^FT44,487^A0N,33,33^FH\^FD"+AllTRim(SZ7->Z7_DESCRI)+"^FS  ")
	else
		cLabel+= (" ^FT44,487^A0N,33,33^FH\^FD"+left(alltrim(SZ7->Z7_DESCRI),48)+"^FS  ")
		cLabel+= (" ^FT44,588^A0N,33,33^FH\^FD"+substr(alltrim(SZ7->Z7_DESCRI),49)+"^FS  ")
	endif
	cLabel+= (" ^FT346,200^A0N,42,40^FH\^FD"+SZ7->Z7_CODCLI+"^FS  ")
	cLabel+= (" ^FT45,434^A0N,33,28^FH\^FDNRO. ETIQUETA NORMAL^FS  ")
	cLabel+= (" ^FT369,433^A0N,33,50^FH\^FD"+AllTRim(SZ7->Z7_ETIQMAE)+"^FS  ")
	cLabel+= (" ^FT45,201^A0N,42,40^FH\^FD"+SZ7->Z7_PAMASA+"^FS  ")
	cLabel+= (" ^FT41,658^A0N,120,196^FH\^FD"+SZ7->Z7_CLIENTE+"^FS  ")
	cLabel+= (" ^FT46,117^A0N,42,40^FH\^FDCOALI - "+SZ7->Z7_COALI+"^FS  ")
	cLabel+= (" ^FT658,471^BQN,2,10  ")
	cLabel+= (" ^FDLA,"+cQR+"^FS  ")
	cLabel+= (" ^LRY^FO1,11^GB942,0,133^FS^LRN  ")
	cLabel+= (" ^PQ1,0,1,Y^XZ  ")

	impriRaw(cLabel,cPrinter)

Return

/*/{Protheus.doc} VerCoali /*/
Static Function VerCoali(_cEtiqueta)
	Local oBrw
	Local aDados := {}
	// Local nLargBtn      := 50
	Private aBrw:= {{.F.,'','','','','','','',''}}
	//Objetos e componentes
	Private oDlgCoali
	Private oFwCol 
	Private oPGridCoali
	//CabeÃ§alho
	Private oSayTit, cSayTitulo := 'Selecione'
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

	fCarregar(_cEtiqueta)

	//Cria a janela
	cAno := cvaltochar(year(date()))

	nAlt := (nJanAltu + 350) / 2
	nLarg := (nJanLarg + 600) / 2
	//Cria a janela
	DEFINE MSDIALOG oDlgCoali TITLE "COALI / "+cAno+" - v1.0.0.1"  FROM 200, 200 TO nAlt, nLarg PIXEL

	//Criando a camada
	oFwCol  := FwLayer():New()
	oFwCol :init(oDlgCoali,.F.)

	//Adicionando 3 linhas, a de tÃ­tulo, a superior e a do calendÃ¡rio
	oFWCol :addLine("TIT", 20, .F.)
	oFWCol :addLine("COR", 80, .F.)

	//Adicionando as colunas das linhas
	oFWCol :addCollumn("HEADERTEXT",   050, .T., "TIT")
	oFWCol :addCollumn("BLANKBTN",     050, .T., "TIT")

	oFWCol :addCollumn("COLGRID",      100, .T., "COR")

	//Criando os paineis
	oPanHeader 	:= oFWCol :GetColPanel("HEADERTEXT",  "TIT")
	oPButCoali	:= oFWCol :GetColPanel("BLANKBTN",    "TIT")
	oPGridCoali	:= oFWCol :GetColPanel("COLGRID",     "COR")

	//TÃ­tulos e SubTÃ­tulos
	oSayTit := TSay():New(004, 005, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSayTit := TSay():New(014, 005, {|| 'Etiquetas Coali - Geradas'}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	
	oBtnSair1 := TButton():New(004, 100, "Excluir"  ,  oPButCoali, {|| fExclCol() }, 50, 012, , oFontBtn, , .T., , , , , , )
	oBtnSair1 := TButton():New(004, 160, "Sair"     ,  oPButCoali, {|| oDlgCoali:end() }, 50, 012, , oFontBtn, , .T., , , , , , )
	// oBtnSair := TButton():New(024, 005, "Imprimir",  oPButCoali, {|| Alert('imprimindo selecionado')}, 50, 012, , oFontBtn, , .T., , , , , , )

	//dialog com browse para defir as notas fiscais
	oBrwCoali := fwBrowse():New()
	oBrwCoali:lHeaderClick:=.F.
	oBrwCoali:setDataArray()

	oBrwCoali:disableConfig()
	oBrwCoali:disableReport() //DTC_NFEID,DTC_CODPRO,DTC_PESO,DTC_PESOM3,DTC_METRO3,DTC_VALOR,DTC_QTDVOL
	oBrwCoali:setOwner( oPGridCoali )
	oBrwCoali:AddMarkColumns( {||IIF(aBrw[oBrwCoali:nAt,01],'LBOK','LBNO')}, {|| INVERT2() /*,aBrw[oBrwCoali:nAt,01]:= !aBrw[oBrwCoali:nAt,01]*/ }/*[ bLDblClick]*/, /*[ bHeaderClick]*/ )
	oBrwCoali:addColumn({"Cod. Etiqueta" ,	{||aBrw[oBrwCoali:nAt,02]}, "C", "@!"	, 1, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xVolume"    })
	oBrwCoali:addColumn({"Etiqueta Coali",	{||aBrw[oBrwCoali:nAt,03]}, "C", "@!"	, 1, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xVolume"    })
	oBrwCoali:addColumn({"Cod. Masa    " , 	{||aBrw[oBrwCoali:nAt,04]}, "C", "@!"	, 2, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xQtdLote"    })
	oBrwCoali:addColumn({"Cod. Cliente " ,	{||aBrw[oBrwCoali:nAt,05]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrwCoali:addColumn({"Descrição    " , 	{||aBrw[oBrwCoali:nAt,06]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrwCoali:addColumn({"Quantidade   " , 	{||aBrw[oBrwCoali:nAt,07]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	// oBrwCoali:addColumn({"Ord. Produção" , 	{||aBrw[oBrwCoali:nAt,07]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	// oBrwCoali:addColumn({"Armazém      " , 	{||aBrw[oBrwCoali:nAt,08]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })

	oBrwCoali:setArray( aBrw )
	oBrwCoali:SetLocate() // Habilita a LocalizaÃ§Ã£o de registros

	oBrwCoali:activate( )

	Activate MsDialog oDlgCoali Centered

Return


static function fCarregar(_cEtiMae)
	DbSelectArea('SZ7')
	dbsetorder(1)

	if SZ7->(MSSEEK(XFILIAL('SZ7')+_cEtiMae))
		aBrw := {}
		while !SZ7->(EOF()) .AND. AllTrim(_cEtiMae) == AllTrim(SZ7->Z7_ETIQMAE)
			if !Empty(SZ7->Z7_COALI)
				aAdd(aBrw,{.F.,;
							SZ7->Z7_ETIQMAE,;
							SZ7->Z7_COALI,;				
							SZ7->Z7_PAMASA,;				
							SZ7->Z7_CODCLI,;				
							SZ7->Z7_DESCRI,;				
							SZ7->Z7_QUANT,;				
				})	
			endif
			SZ7->(dbskip())
		endDo
		if Empty(aBrw)
			FwAlertWarning('Nenhuma etiqueta coali encontrada.','Atencao !!!')
			return
		endif
	else
		FwAlertWarning('Nenhuma etiqueta coali encontrada.','Atencao !!!')
		return
	endif
return
/*/{Protheus.doc} GeraCoal/*/
Static Function fExclCol()

	Local aArea := FWGetArea()
	Local aImp := {}
	Local nx
	Local xEti := ''
	Local lBrowMark := .F.
	
	dbselectarea('CB5')
	while !CB5->(EOF())
		if 'MCETIQ05' $ CB5->CB5_ROTINA  // fonte setado no cadastro de impressoras
			AADD(aImp, alltrim(CB5->CB5_PRINTR))
		endif
		CB5->(dbskip())
	EndDo
	
	//Z7_FILIAL+Z7_ETIQMAE+Z7_COALI
	DbSelectArea('SZ7')
	SZ7->(dbsetorder(2))
	for NX := 1 to LEN(aBrw)
		if aBrw[nx,1]
			xEti := aBrw[nx,2]
			if SZ7->(MSSEEK(XFILIAL('SZ7')+aBrw[nx,2]+aBrw[nx,3]))
				//Exclui o registro
				xQtdDel := aBrw[nx,7]
				RecLock('SZ7', .F.)
					DbDelete()  // SE DELETAR O COALI					
				SZ7->(MsUnlock())
				
			endif
			
			// ATUALIZA O SALDO DA ETIQUETA MAE			
			SZ7->(DbGoTop())
			SZ7->(dbsetorder(2))
			
			if SZ7->(MSSEEK(XFILIAL('SZ7')+aBrw[nx,2]))
				while !SZ7->(eof()) .AND. ALLTRIM(SZ7->Z7_ETIQMAE) == ALLTRIM(aBrw[nx,2])
					if Empty(SZ7->Z7_COALI)
						RECLOCK('SZ7' , .F.)
							SZ7->Z7_QUANT += xQtdDel
						SZ7->(MsUnlock())
						exit
					endif
					SZ7->(dbskip())
				EndDo
			endif	

			lBrowMark:= .T.
		endif
	next nx

	if !lBrowMark
		msgStop('Nenhuma etiqueta foi Selecionada')
		return
	endif

	fCarregar(xEti)
	oBrwCoali:setArray(aBrw)
	oBrwCoali:SetLocate()
	oBrwCoali:refresh()

	RestArea(aArea)

Return Nil


Static Function AbatSald(_nQuant)
	nsld := SZ7->Z7_QUANT-_nQuant
	RECLOCK('SZ7', .F.)
	SZ7->Z7_QUANT 	:= nsld
	SZ7->(MsUnlock())
Return

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




