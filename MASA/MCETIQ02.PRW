

#include "TOTVS.ch"
#INCLUDE "PROTHEUS.CH"
#include "Tbiconn.ch"
#include "rwmake.ch"
//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

// NOME DO PC PA-ALMOX01
// NOME IMPRESSORA COMPARTILHADA ZD220-203
// CONFIGURAÇÃO LPT1 : net use LPT1: \\PA-ALMOX01\ZD220-203 senha /USER:usuario /PERSISTENT:YES

/*
Etiqueta
*/

User Function MCETIQ02()
	Local aArea := FwGetArea()
	Local aReturn := {}
	Local aParambox := {}
	Local cPrinter := ''

	// RpcSetEnv('01','01')

	cProd := space(tamsx3("B1_COD")[1])
	cLote := space(tamsx3("D3_LOTECTL")[1])
	cFornece := space(tamsx3("A2_NOME")[1])
	cGrade := space(10)

	Aadd(aParambox,{1,"Produto.: ",cProd,"@!","u_fValProd()",'SB1',,120,.T.})
	// Aadd(aParambox,{1,"Lote.: ",cLote,"@!",'!EMPTY(MV_PAR02)','',,120,.T.})
	// Aadd(aParambox,{1,"Fornecedor.: ",cFornece,"@!",'!EMPTY(MV_PAR03)','SA1',,120,.T.})
	aAdd(aParambox,{1,"Qtd etiqueta: " ,Space(4),"",'!EMPTY(MV_PAR02)',"",,0 ,.F.})
	aAdd(aParambox,{1,"Maquina: " ,Space(12),"",'!EMPTY(MV_PAR03)',"",,0 ,.T.})
	aAdd(aParambox, {2, "Impressora",cPrinter, {"ZT410","ZM400"},     122, ".T.", .F.})
	aAdd(aParambox,{1,"Densidade: " ,Space(2),"",'!EMPTY(MV_PAR05)',"",,0 ,.F.})

	If !ParamBox(aParambox ,"Etiquetas ...",@aReturn,,,,,,,,.F.,.T.)
		Return
	Else
		Processa( {|| xfImpPA() }, "Aguarde...","Imprimindo...",.F.)
	Endif

	FwRestArea(aArea)

Return

Static Function xfImpPA()

	Local nX	  := 0
	Local nWait	  := 0
	Local cDir    := "\etiquetas\" //pasta criada no protheus_data
	Local cFile   :=""
	Local cLabel  := ""
	Local cPrinterPath := "" //compartilhamento da impressora na rede
	Local cNomePC := ComputerName()
	Local cDirLocal := "C:\TEMP\"
	Local cDtHoraAt := DTOC(DDATABASE) +'-'+ TIME()
	local cAliasSZA := GETNEXTALIAS()
	local aDadosBRW := {}
	local aForn := {}

	cAlias    := "SZA"
	cArquivo  := RETSQLNAME('SZA')
	CheckFile(cAlias, cArquivo)

	// 1T
	// 23:00 à 06:59
	// 2T
	// 07:00 à 14:59
	// 3t
	// 15:00 à 22:59

	if cDtHoraAt >= DTOC(DDATABASE) + '-07:00:00' .AND. cDtHoraAt <= DTOC(DDATABASE) + '-14:59:00'
		cTurno := '2T'
	elseif cDtHoraAt >= DTOC(DDATABASE) + '-15:00:00' .AND. cDtHoraAt <= DTOC(DDATABASE) + '-22:59:00'
		cTurno := '3T'
	else
		cTurno := '1T'
	endif

	cQryDados := " "
	cQryDados += " SELECT G1_COMP MP,B1A.B1_DESC DESC_MP,B1A.B1_XGRADE GRADE,B1.B1_COD PA,B1.B1_XHALB HALB FROM SB1010 B1 "
	cQryDados += " INNER JOIN SG1010 G1 ON G1.D_E_L_E_T_='' AND G1.G1_COD=B1_COD AND G1_XCODCLI <> '' "
	cQryDados += " INNER JOIN SB1010 B1A ON B1A.D_E_L_E_T_='' AND B1A.B1_COD=G1.G1_COMP  AND B1A.B1_DESC LIKE ('%0103-%') "
	cQryDados += " WHERE B1.D_E_L_E_T_='' AND B1.B1_COD ='" + MV_PAR01     +"' "

	PLSQuery(cQryDados, 'QRYDADTMP')

	DbSelectArea('QRYDADTMP')
	QRYDADTMP->(DbGoTop())

	if EMPTY(AllTRim(QRYDADTMP->(HALB))) .AND. !QRYDADTMP->(Eof())
		fWALERTWARNING('O Produto '+AllTRim(QRYDADTMP->(PA))+' não possui o codigo HALB no cadastro, cantate a engenharia.', 'Não imprime!!!')
		Return
	endif

	if EMPTY(AllTRim(QRYDADTMP->(GRADE))) .AND. !QRYDADTMP->(Eof())
		fWALERTWARNING('O Produto '+AllTRim(QRYDADTMP->(PA))+' não possui o codigo GRADE no cadastro, cantate a engenharia.', 'Não imprime!!!')
		Return
	endif

	cData := LEFT(DTOS(DDATABASE),4)+'.'+SUBSTR(DTOS(DDATABASE),5,2)+'.'+RIGHT(DTOS(DDATABASE),2)
	cDescMP := StrTran(AllTRim(QRYDADTMP->(DESC_MP)), "SAMSUNG", " ")
	cDescMP := StrTran(AllTRim(cDescMP), " - ", " ")
	cDescMP := StrTran(AllTRim(cDescMP), "  ", " ")


	/*  TELA PARA SELECIONAR FORNECEDOR*/

	BeginSQL ALIAS cAliasSZA
			SELECT ZA_CODFOR,ZA_DESCFOR,ZA_UL,ZA_FLAME FROM SZA010
			WHERE D_E_L_E_T_='' AND ZA_COD= %exp:QRYDADTMP->(MP)%
	EndSQL

	(cAliasSZA)->(dbGotop())
	while !(cAliasSZA)->(Eof())
		aadd(aDadosBRW,{.F.,Alltrim(ZA_CODFOR),Alltrim(ZA_DESCFOR),Alltrim(ZA_UL),AllTRim(ZA_FLAME)})
		(cAliasSZA)->(dbSkip())
	endDo

	if LEN(aDadosBRW) > 1
		aForn:= GetFonerc(aDadosBRW)
	else
		aForn := aDadosBRW
	endif

	******

	if MV_PAR04 == 'ZT410'
		cLabel+= (" CT~~CD,~CC^~CT~")
		cLabel+= (" ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA ")
		cLabel+= (" ^PR10,10 ")
		cLabel+= (" ^~SD"+ALLTRIM(MV_PAR05)+"^JUS^LRN^CI0^XZ")
		cLabel+= (" ^XA")
		cLabel+= (" ^MMT")
		cLabel+= (" ^PW485")
		cLabel+= (" ^LL0150")
		cLabel+= (" ^LS0")
		cLabel+= (" ^FT66,60^A0N,17,16^FH\^FDE1L4^FS") // FT67
		cLabel+= (" ^FT398,60^A0N,17,16^FH\^FD"+ AllTRim(QRYDADTMP->(GRADE)) +"^FS") // grade
		cLabel+= (" ^FT148,60^A0N,17,16^FH\^FD"+AllTRim(QRYDADTMP->(PA))+"^FS")
		cLabel+= (" ^FT294,60^A0N,17,16^FH\^FD"+AllTRim(aForn[1,5])+"^FS")
		cLabel+= (" ^FT393,105^A0N,17,16^FH\^FD"+ cData +"^FS")   // data
		cLabel+= (" ^FT66,105^A0N,17,16^FH\^FD"+AllTRim(QRYDADTMP->(HALB))+"^FS")
		cLabel+= (" ^FT195,105^A0N,17,16^FH\^FD"+AllTRim(cTurno)+"^FS")
		cLabel+= (" ^FT253,105^A0N,17,16^FH\^FD"+'MAQ:.'+ AllTRim(MV_PAR03)+"^FS")
		cLabel+= (" ^FT398,40^A0N,17,16^FH\^FD"+aForn[1,4]+"^FS") // lote
		cLabel+= (" ^FT66,40^A0N,17,16^FH\^FD"+aForn[1,3]+"^FS") // fronecedor
		cLabel+= (" ^FT66,82^A0N,17,16^FH\^FD"+cDescMP+"^FS") // descrição materia prima
		cLabel+= (" ^PQ1,0,1,Y^XZ")
	endif

	cPrinterPath:= "\\"+cNomePC+"\ZEBRA"

	cFile:= "etq_"+strtran('etiqueta_masa_mp',"/","-")+".txt"
	// cFile:= "etq_"+strtran('etiqueta_masa'+"-"+cvaltochar(nx),"/","-")+".txt"
	MemoWrite(cDir+cFile,cLabel )

	// se não existir o diretorio cria
	if !file(cDirLocal)
		MakeDir(cDirLocal)
	endif

	// se não existir o diretorio cria
	if !ExistDIr(cDir)
		MakeDir(cDir)
	endif

	// cExec:= 'cmd /c "COPY '+cDirLocal+cFile +' '+ cPrinterPath+'" '
	// CpyS2T(cDir+cFile, cDirLocal, .T. )
	ProcRegua(val(MV_PAR02))
	for nX := 1 to val(MV_PAR02)
		// nWait:= WaitRun(cExec,1)
		impriRaw(cLabel,cPrinter,cSeq)  
		*
	Next
	// if nWait == 0
	// 	// PUTMV("MV_SEQETQ",cSeq)
	// 	fErase(cDirLocal+cFile)
	// 	fErase(cDir+cFile)
	// endif
	// Encerra local de impressao
	// MSCBCLOSEPRINTER()

Return

User function fValProd()
	local lret:= .F.
	dbselectarea('SB1')
	dbsetorder(1)

	if MSSEEK(xFilial('SB1')+MV_PAR01)
		lRet := .T.
	Else
		Alert('Produto não localizado !!!')
	EndIf

return lret


Static Function GetFonerc(_aDadosBRW)
	// Local nLargBtn      := 50
	local nx :=0
	local aForn := {}
	Private aBrowse:= aClone(_aDadosBRW)
	//Private aDadosBRW:= {{space(20),0}}
	Private aColunas:= {"Volume","Quantidade","NÂº do Lote"}
	//Objetos e componentes
	Private oDlgLote
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

	//Cria a janela
	DEFINE MSDIALOG oDlgLote TITLE "Notas fiscais da CTE de Origem"  FROM 200, 200 TO 500, 800 PIXEL

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlgLote,.F.)

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
	oSayTitulo := TSay():New(004, 05, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oBtnSair := TButton():New(006, 100, "Confirmar",  oPanBut, {|| oDlgLote:End()}, 30, 012, , oFontBtn, , .T., , , , , , )


	//dialog com browse para defir as notas fiscais
	oBrowseLotes := fwBrowse():New()
	oBrowseLotes:lHeaderClick:=.F.
	oBrowseLotes:setDataArray()

	oBrowseLotes:disableConfig()
	oBrowseLotes:disableReport() //DTC_NFEID,DTC_CODPRO,DTC_PESO,DTC_PESOM3,DTC_METRO3,DTC_VALOR,DTC_QTDVOL
	oBrowseLotes:setOwner( oPanGrid )
	oBrowseLotes:AddMarkColumns( {||IIF(aBrowse[oBrowseLotes:nAt,01],'LBOK','LBNO')}, {|| INVERT() /*,aBrowse[oBrowseLotes:nAt,01]:= !aBrowse[oBrowseLotes:nAt,01]*/ }/*[ bLDblClick]*/, /*[ bHeaderClick]*/ )
	oBrowseLotes:addColumn({"Fornecedor"   , 	{||aBrowse[oBrowseLotes:nAt,02]}, "C", "@!"	, 1, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xVolume"    })
	oBrowseLotes:addColumn({"Desc Fornece" ,	{||aBrowse[oBrowseLotes:nAt,03]}, "C", "@!"	, 2, 10 ,     , .F. , , .F.,, ,, .F., .T., , "xQtdLote"    })
	oBrowseLotes:addColumn({"UL"   		   , 	{||aBrowse[oBrowseLotes:nAt,04]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowseLotes:addColumn({"Flame"   	   , 	{||aBrowse[oBrowseLotes:nAt,05]}, "C", "@!"	, 1, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })

	oBrowseLotes:setArray( aBrowse )
	oBrowseLotes:SetLocate() // Habilita a LocalizaÃ§Ã£o de registros

	oBrowseLotes:activate( )

	Activate MsDialog oDlgLote Centered

	for NX := 1 to LEN(aBrowse)
		if aBrowse[nx,1]
			aadd(aForn,aBrowse[nx])
		endif
	next nx

Return(aForn)

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
	LOCAL lMark:=aBrowse[oBrowseLotes:nAt,01]
	LOCAL nPos := oBrowseLotes:nAt

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
	oBrowseLotes:GoTo( oBrowseLotes:nAt, .T. )
	// oBrowseLotes:refresh()
Return



// Exemplo de impressão RAW usando FWMSPrinter
Static Function impriRaw(cZPL,cPrinter,cSeq)

	Local oPrinter   := Nil
	Local cFileRel   := "RAW_ETIQUETA" // pode ser apenas identificador
	Local oPrintSetupParam := Nil
	Local lAdjustToLegacy   := .F.
	Local lDisableSetup     := .T.
	// Local oPrinter
	Local cLocal            := "c:\temp"
	Local nPrtType          := 2 // IMP_PDF > 6 || IMP_SPOOL > 2
	Local aDevice           := {}
	Local cSession          := GetPrinterSession()

	// Criar objeto FWMSPrinter em modo RAW
	oPrinter := FWMSPrinter():New(cFileRel, nPrtType, lAdjustToLegacy, '', lDisableSetup,.F.,NIL ,cPrinter ,.F. ,.T., .T. /*LRAW*/)

	// Aqui é só usar SAY, que em RAW escreve direto
	oPrinter:Say(0, 0, cZPL)

	oPrinter:Print()

	PUTMV("MV_SEQETQ",cSeq)
Return
