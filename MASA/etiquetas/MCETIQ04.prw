#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

User Function MCETIQ04()
	// Local nLargBtn      := 50
	// local nx :=0
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
	oBrowse:addColumn({"Descricao"      ,	{||aBrowse[oBrowse:nAt,04]}, "C", "@!"	, 1, 120 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Quantidade" 	, 	{||aBrowse[oBrowse:nAt,05]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Emissao   "		, 	{||aBrowse[oBrowse:nAt,06]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Saldo Etiqueta ", 	{||aBrowse[oBrowse:nAt,07]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowse:addColumn({"Cod. Cliente "  , 	{||aBrowse[oBrowse:nAt,08]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	// oBrowse:addColumn({"Emissao "			, 	{||aBrowse[oBrowse:nAt,08]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
// 2_OP,C2_PRODUTO ,B1_DESC,C2_EMISSAO,C2_XMAQ,C2_XMOLDE,C2_XCODCLI
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
	cQryDados += " SELECT C2_QTDETIQ,C2_OP,C2_NUM,C2_PRODUTO ,B1_DESC,C2_EMISSAO,C2_XMAQ,C2_XMOLDE,C2_XCODCLI,C2_QUANT   FROM "+RETSQLNAME('SC2') +  " C2 (NOLOCK) "  + CRLF
	//cQryDados += "  INNER JOIN SD4010 D4 ON D4.D_E_L_E_T_='' AND D4_OP =C2_NUM+C2_ITEM+C2_SEQUEN AND D4_LOCAL = 'WP' "  + CRLF
	cQryDados += "  INNER JOIN SB1010 B1 (NOLOCK) ON B1.D_E_L_E_T_='' AND B1_COD = C2_PRODUTO "  + CRLF
	// cQryDados += "  INNER JOIN SB1010 B1 ON B1.D_E_L_E_T_='' AND B1_COD = AND B1.B1_DESC LIKE ('%0103-%')  "  + CRLF
	cQryDados += "  WHERE C2.D_E_L_E_T_='' AND C2_PRODUTO = '" + _cetiq +"' " + CRLF
	cQryDados += "  AND C2_QUJE    < C2_QUANT "  + CRLF
	cQryDados += "  AND C2_QTDETIQ < C2_QUANT "  + CRLF // QUANTIDADE JÁ IMPRESSAS
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
			('QRYDADTMP')->B1_DESC,;
			('QRYDADTMP')->C2_QUANT,;
			('QRYDADTMP')->C2_EMISSAO,;
			('QRYDADTMP')->C2_QUANT - ('QRYDADTMP')->C2_QTDETIQ,;
			('QRYDADTMP')->C2_XCODCLI;
			})
		// ('QRYDADTMP')->C2_XMOLDE,;

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
	// oBrowse:Refresh()
	oBrowse:GoTo(1,.T.)
// 	oBrowse:refresh()
// 	oBrowse:GoTo( oBrowse:nAt, .F. )
Return

Static Function FnImp01()
	// Local aArea := FwGetArea()
	Local aRet := {}
	Local aPergs := {}
	Local aImp := {}
	Local cPrinter := ''
	// RpcSetEnv('01','01')

	dbselectarea('CB5')
	CB5->(DbGoTop())
	while !CB5->(EOF())
		if 'MCETIQ04' $ CB5->CB5_ROTINA  // fonte setado no cadastro de impressoras
			AADD(aImp, alltrim(CB5->CB5_PRINTR))
		endif
		CB5->(dbskip())
	EndDo

	aAdd(aPergs,{1,"Quant. Produto: ",Space(8),"","!Empty(MV_PAR01)","","",0 ,.F.})
	aAdd(aPergs,{1,"Densidade: " ,'22',"","","","",0 ,.F.})
	aAdd(aPergs,{1,"Quant Etiqueta: " ,Space(4),"","!Empty(MV_PAR03)","","",0 ,.F.})
	// aAdd(aPergs,{2, "Impressora",cPrinter, {"ZT411","ZT410","ZM400"},     122, ".T.", .F.})
	aAdd(aPergs,{2, "Impressora",cPrinter, aImp,     122, ".T.", .F.})

	If !ParamBox(aPergs ,"Etiquetas ...",@aRet,,,,,,,,.F.,.T.)
		Return
	Else
		Processa( {|| xfImpPA() }, "Aguarde...","Imprimindo...",.F.)
	Endif

	// aAdd(aPergs,{1,"Quant Etiqueta: " ,Space(4),"","!Empty(MV_PAR03)","","",0 ,.F.})
	// aAdd(aPergs,{1,"Densidade: " ,'22',"","","","",0 ,.F.})
	// aAdd(aPergs,{2, "Impressora",cPrinter, {"ZT410","ZT411","ZM400"},     122, ".T.", .F.})
	// // aAdd(aPergs,{2, "Impressora",cPrinter, aImp, 122, ".T.", .F.})

	// If !ParamBox(aPergs ,"Etiquetas ...",@aRet,,,,,,,,.F.,.T.)
	// 	Return
	// Else
	// 	Processa( {|| xfImpPA() }, "Aguarde...","Imprimindo...",.F.)
	// Endif

Return


Static Function xfImpPA()
	Local nX := 0
	// Local cDir    := "\etiquetas\" //pasta criada no protheus_data
	// Local cFile   :=""
	Local cLabel  := ""
	Local cAliasSZ7  := GETNEXTALIAS()
	// Local cPrinterPath:= "" //compartilhamento da impressora na rede
	// Local cSeqEtiq1 := GETMV('MV_SEQETQ')
	Local cSeqEtiq1 := ''
	// Local cNomePC := ComputerName()
	// Local cDirLocal := "C:\TEMP\"
	Local nTotal := VAL(MV_PAR03)
	Local cPrinter := ALLTRIM(MV_PAR04)

	cCliente:=''

	dbselectarea('SB1')
	dbSetOrder(1)
	dbselectarea('SA7')
	dbSetOrder(2)
	dbselectarea('SA1')
	dbSetOrder(1)

	if !U_ValidOp() // valida e posiciona na op
		Return
	endif

	SB1->(MSSEEK(xFilial('SB1')+SC2->C2_PRODUTO))
	If SA7->(MSSEEK(xFilial('SA7')+SC2->C2_PRODUTO+SC2->C2_XCODCLI+SC2->C2_XLOJA))
		cProdCli := alltrim(SA7->A7_CODCLI)
	Else
		FwAlertWarning("Cliente "+alltrim(SC2->C2_XCODCLI)+" não encontrado nas SA1.",'Atenção!!!')
		Return
	EndIf

	If SA1->(MSSEEK(xFilial('SA1')+SC2->C2_XCODCLI+SC2->C2_XLOJA))
		if Empty(SA1->A1_NOMETIQ)
			FwAlertWarning("O Campo 'Abrev. Nome' na tebela  SA1 rotina Cadastro de Cliente não foi preenchido, ajuste o cadastro.",'Impressao Cancelada!!!')
			Return
		Else
			cCliente := alltrim(SA1->A1_NOMETIQ)
		endif
	EndIf
	BeginSQL ALIAS cAliasSZ7
		SELECT max(Z7_ETIQMAE) ULT_ETIQ FROM %table:SZ7% (NOLOCK)
	EndSQL

	cSeqEtiq1 := AllTRim((cAliasSZ7)->ULT_ETIQ) // sequencial da etiqueta MAE

	ProcRegua(nTotal)
	//Incrementa a mensagem na régua
	for nx := 1 to nTotal

		cSeqEtiq1 := SOMA1(space(2)+cSeqEtiq1)
		cSeqEtiq1 := cvaltochar(val(cSeqEtiq1))

		// verificar se ainda existe saldo para imprimir
		// se o saldo já impresso + a quantidade sendo imprimida fo maior que a quantidade da OP aborta a impressão.
		if (val(MV_PAR01) + SC2->C2_QTDETIQ) > SC2->C2_QUANT .or. val(MV_PAR01) > SC2->C2_QUANT
			FwAlertWarning('O Saldo da etiqueta '+ cSeqEtiq1 + ' ultrapassa o Saldo da OP.','Impressao Cancelada!!!')
			Return
		EndIf


		IncProc("Imprindo etiquetas " + cValToChar(nX) + " de " + cValToChar(nTotal) + "...")
		// BR30BN6108855AMASAC9D0301

		cQR := 	SB1->B1_COD+space(1)+;  // CODIGO PRODUTO
		AllTRim(cSeqEtiq1)+;                 // SEQUENCIA
		STRZERO(VAL(MV_PAR01),5)+;	    // QUANTIDADE
		STRZERO(VAL(SC2->C2_NUM),8)     // OP

		// FGRAVETIQ(cQR,cSeqEtiq1,cProdCli,MV_PAR01,SC2->C2_XMAQ,ddatabase,SC2->C2_NUM,SC2->C2_LOCAL,SC2->C2_XMOLDE,cCliente,;
			// alltrim(SB1->B1_DESC),SB1->B1_COD)

		cLabel:= ""
		cLabel+= ("CT~~CD,~CC^~CT~ ")
		cLabel+= (" ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA ")
		cLabel+= (" ^PR10,10 ")
		cLabel+= (" ~SD"+alltrim(MV_PAR02))
		cLabel+= ("^JUS^LRN^CI0^XZ ")
		cLabel+= (" ^XA ")
		cLabel+= (" ^MMT ")
		cLabel+= (" ^PW945 ")
		cLabel+= (" ^LL0650 ")
		cLabel+= (" ^LS0 ")
		cLabel+= (" ^FT32,211^A0N,42,38^FH\^FD"+cProdCli+"^FS ")
		cLabel+= (" ^FT356,91^A0N,42,38^FH\^FD"+cSeqEtiq1+"^FS ")
		cLabel+= (" ^FT365,469^A0N,33,31^FH\^FD"+MV_PAR01+"^FS ")
		cLabel+= (" ^FT704,623^A0N,37,52^FH\^FDRE:____^FS ")
		cLabel+= (" ^FT703,575^A0N,37,36^FH\^FDTURNO:____^FS ")
		cLabel+= (" ^FT702,526^A0N,37,33^FH\^FDMAQ: "+SC2->C2_XMAQ+"^FS ")
		cLabel+= (" ^FT702,477^A0N,37,36^FH\^FD"+"___"+right(dtoc(ddatabase),8)+" ^FS ")
		cLabel+= (" ^FT270,468^A0N,33,31^FH\^FDQTD: ^FS ")
		cLabel+= (" ^FT101,468^A0N,33,31^FH\^FD"+SC2->C2_NUM+"^FS ")
		cLabel+= (" ^FT269,512^A0N,33,31^FH\^FDALMOX: ^FS ")
		cLabel+= (" ^FT394,512^A0N,33,31^FH\^FD"+SC2->C2_LOCAL+"^FS ")
		cLabel+= (" ^FT152,512^A0N,33,31^FH\^FD"+SC2->C2_XMOLDE+"^FS ")
		cLabel+= (" ^FT36,512^A0N,33,31^FH\^FDMOLDE:^FS ")
		cLabel+= (" ^FT36,468^A0N,33,31^FH\^FDOP: ^FS ")
		cLabel+= (" ^FT35,627^A0N,80,141^FH\^FD"+cCliente+"^FS ")
		if len(alltrim(SB1->B1_DESC)) <= 45
			cLabel+= (" ^FT33,345^A0N,37,36^FH\^FD"+alltrim(SB1->B1_DESC)+"^FS ")
		else
			cLabel+= (" ^FT33,345^A0N,37,36^FH\^FD"+left(alltrim(SB1->B1_DESC),45)+"^FS ")
			cLabel+= (" ^FT33,406^A0N,37,36^FH\^FD"+substr(alltrim(SB1->B1_DESC),46)+"^FS ")
		endif
		cLabel+= (" ^FT34,150^A0N,42,38^FH\^FD"+SB1->B1_COD+"^FS ")
		cLabel+= (" ^FT34,91^A0N,42,38^FH\^FDMASA^FS ")
		cLabel+= (" ^FT682,313^BQN,2,8 ")
		cLabel+= (" ^FDLA,"+cQR+"^FS ")
		cLabel+= (" ^PQ1,0,1,Y^XZ ")

		if impriRaw(cLabel,cPrinter)
			dbselectarea('SZ7')
			dbsetorder(1)

			RECLOCK('SZ7', .T.)
			SZ7->Z7_ETIQMAE := cSeqEtiq1
			SZ7->Z7_PAMASA 	:= SB1->B1_COD
			SZ7->Z7_CODCLI 	:= cProdCli
			SZ7->Z7_DESCRI 	:= alltrim(SB1->B1_DESC)
			SZ7->Z7_OP 		:= SC2->C2_NUM
			SZ7->Z7_MOLDE 	:= SC2->C2_XMOLDE
			SZ7->Z7_QUANT 	:= VAL(MV_PAR01)
			SZ7->Z7_LOCAL 	:= SC2->C2_LOCAL
			SZ7->Z7_QRCODE1 := cQR
			SZ7->Z7_CLIENTE := cCliente
			SZ7->(MsUnlock())

			// atualizar a quantida ja impressa
			// para limitar a impressao ate fecha a quantidade da OP.
			nQtdAtu := SC2->C2_QTDETIQ + val(MV_PAR01)
			Reclock('SC2' , .F.)
			SC2->C2_QTDETIQ := nQtdAtu
			SC2->(msUnLock())
		endif
	next nX
Return


User function ValidOp()
	local lret:= .F.
	dbselectarea('SC2')
	dbsetorder(1)

	if MSSEEK(xFilial('SC2')+aBrowse[oBrowse:nAt,02])
		lRet := .T.
	Else
		Alert('Oderm de producao não localizada !!!')
	EndIf

return lret


// Exemplo de impressão RAW usando FWMSPrinter
// Static Function impriRaw(cZPL,cPrinter)

// 	Local oPrinter   := Nil
// 	// Local cPrinter   := ALLTRIM(MV_PAR12)// Nome cadastrado no Local de Impressão
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

// Return


// Exemplo de impressão RAW usando FWMSPrinter
Static Function impriRaw(cZPL,cPrinter)

	Local oPrinter   := Nil
	Local cFileRel   := "RAW_ETIQUETA" // pode ser apenas identificador
	Local lAdjustToLegacy   := .F.
	Local lDisableSetup     := .T.
	// Local aPrint          := GetImpWindows(.F.)
	Local nPrtType          := 2 // IMP_PDF > 6 || IMP_SPOOL > 2
	// Local cSession          := GetPrinterSession()
	// Local aDevice           := {}
	// Local oPrintSetupParam := Nil
	// Local oPrinter
	// Local cLocal            := "c:\temp"

	// Criar objeto FWMSPrinter em modo RAW
	oPrinter := FWMSPrinter():New(cFileRel, nPrtType, lAdjustToLegacy, '', lDisableSetup,.F.,NIL ,cPrinter ,/*verificar se melhora a velocidade*/.F. ,.T., .T. /*LRAW*/)
	// oPrinter:setup()

	// Aqui é só usar SAY, que em RAW escreve direto
	oPrinter:Say(0, 0, cZPL)

	oPrinter:Print()

Return .T.

Return
