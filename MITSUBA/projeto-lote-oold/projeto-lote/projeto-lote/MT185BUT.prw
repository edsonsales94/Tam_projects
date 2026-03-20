#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PRTOPDEF.CH'
#INCLUDE 'TBICONN.CH'

User Function MT185BUT()

	Local aButton := {}

	aAdd(aButton, {'SALDO ENDERECO',{|| fVERSALDO() /*funcao_customizada ()*/ },'SALDO ENDERECO','SALDO ENDERECO'})

Return aButton

Static Function fVERSALDO()
	lOCAL i
	Local aRet    := {}
	Local cQry0   := ""
	Local aLotes:= {}
	Private ENTER:= char(13) + char(10)

    cQry0 := " SELECT BF_PRODUTO,BF_LOCALIZ,BF_QUANT,BF_LOTECTL,B8_DTVALID  " +ENTER
    cQry0 += " FROM "+RetSqlName("SBF")+" (NOLOCK) SBF " +ENTER
    cQry0 += " INNER JOIN SB8010 SB8 ON SB8.D_E_L_E_T_ ='' AND SB8.B8_PRODUTO=SBF.BF_PRODUTO " +ENTER
	cQry0 += " AND SBF.BF_LOTECTL=SB8.B8_LOTECTL AND BF_LOCAL=B8_LOCAL " +ENTER
    cQry0 += " WHERE BF_PRODUTO =  '"+ SCP->CP_PRODUTO   +"'"  +ENTER
    cQry0 += " AND BF_QUANT > 0 "+ENTER
    cQry0 += " AND BF_LOCAL ='01' "+ENTER
    cQry0 += " ORDER BY BF_QUANT ASC "+ENTER

	//dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry0), "TMQ", .T., .F. )
	aGetLotes:={}
	MpSysOpenQUery(cQry0,"TMX")

	While !TMX->(Eof())
		AADD(aGetLotes,{TMX->BF_PRODUTO,TMX->BF_LOCALIZ,TMX->BF_QUANT,TMX->BF_LOTECTL,STOD(TMX->B8_DTVALID)})
		TMX->(dbSkip())
	EndDo
	
	GetLotes(aGetLotes)
	
	TMX->(dbCloseArea())

Return



Static Function GetLotes(aBrowse)
	Local nLargBtn      := 50
	Local oDlgLote
	//Objetos e componentes
	Private oDlgLote
	Private oFwLayer
	Private oPanTitulo
	Private oPanGrid
	//Cabeçalho
	Private oSayTitulo, cSayTitulo := 'Saldo Por endeco '
	Private oSaySubTit, cSaySubTit := 'Produto: ' +Alltrim(SCP->CP_PRODUTO)
	//Tamanho da janela

	//Fontes
	Private cFontUti    := "Tahoma"
	Private oFontMod    := TFont():New(cFontUti, , -38)
	Private oFontSub    := TFont():New(cFontUti, , -12)
	Private oFontSubN   := TFont():New(cFontUti, , -12, , .T.)
	Private oFontBtn    := TFont():New(cFontUti, , -12)
	Private oFontSay    := TFont():New(cFontUti, , -10)

	//Cria a janela
	Private aSize := MsAdvSize(.F.)
	Private nJanLarg := aSize[5] / 2
    Private nJanAltu := aSize[6] / 2

	// DEFINE MSDIALOG oDlgLote TITLE "Saldos enderecos/Lotes"  FROM 200, 200 TO 800, 800 PIXEL
    DEFINE MSDIALOG oDlgLote TITLE "Saldos Endere�os/Lotes" ;
        FROM ( (aSize[6] - nJanAltu) ), ( (aSize[5] - nJanLarg) / 2 ) ;
        TO ( (aSize[6] + nJanAltu)  ), ( (aSize[5] + nJanLarg) / 2 ) PIXEL

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlgLote,.F.)

	//Adicionando 3 linhas, a de título, a superior e a do calendário
	oFWLayer:addLine("TIT", 10, .F.)
	oFWLayer:addLine("COR", 90, .F.)

	//Adicionando as colunas das linhas
	oFWLayer:addCollumn("HEADERTEXT",   050, .T., "TIT")
	oFWLayer:addCollumn("BLANKBTN",     050, .T., "TIT")

	oFWLayer:addCollumn("COLGRID",      100, .T., "COR")
	//Criando os paineis
	oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
	oPanBut    := oFWLayer:GetColPanel("BLANKBTN",    "TIT")

	oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")

	//Títulos e SubTítulos
	oSayTitulo := TSay():New(004, 05, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	oSaySubTit := TSay():New(014, 05, {|| cSaySubTit}, oPanHeader, "", oFontSubN, , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )

	//Parametros para preenchimento das etiquetas
	// oSayEtiqDe := TSay():New(001, 001, {|| "Volume de :"}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// cTGet1 := space(3)
	// oTGet1 := TGet():New( 01,45,{|u|if(PCount()==0,cTGet1,cTGet1:=u)},oPanPar,30,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )
	// oSayTitulo := TSay():New(001, 100, {|| "Volume até:"}, oPanPar, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// cTGet2 := space(3)
	// oTGet2 := TGet():New( 01,145,{|u|if(PCount()==0,cTGet2,cTGet2:=u)},oPanPar,30,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet2,,,, )
	// oSaySubTit := TSay():New(001, 180, {|| "Lote:"}, oPanPar, "", oFontSub, , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// cTGet3 := space(20)
	// oTGet3 := TGet():New( 01,205,{|u|if(PCount()==0,cTGet3,cTGet3:=u)},oPanPar,50,10,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet3,,,, )

	// //Criando os botões
	// oBtnRep := TButton():New(006, 001, "Replicar",  oPanBut, {|| replicar()}, 30, 012, , oFontBtn, , .T., , , , , , )
	// oBtnSel := TButton():New(006, 040, "Seleciona Tudo",  oPanBut, {|| SelectAll()}, 50, 012, , oFontBtn, , .T., , , , , , )
	oBtnSair := TButton():New(006, 100, "Sair",  oPanBut, {|| oDlgLote:End()}, 30, 012, , oFontBtn, , .T., , , , , , )


	//dialog com browse para definição dos lotes
	oBrowseLotes := fwBrowse():New()
	//oBrowseLotes:SetColumns(aColunas)

	oBrowseLotes:lHeaderClick:=.F.
	oBrowseLotes:setDataArray()

	oBrowseLotes:disableConfig()
	oBrowseLotes:disableReport()
	oBrowseLotes:setOwner( oPanGrid )
	// oBrowseLotes:AddMarkColumns( {||IIF(aBrowse[oBrowseLotes:nAt,01],'LBOK','LBNO')}, {||aBrowse[oBrowseLotes:nAt,01]:= !aBrowse[oBrowseLotes:nAt,01] }/*[ bLDblClick]*/, /*[ bHeaderClick]*/ )
	oBrowseLotes:addColumn({"Produto"       , {||aBrowse[oBrowseLotes:nAt,01]}, "C", "@!"    		 , 0, 10 ,     , .F. ,/*vldLot()*/, .F.,, ,, .F., .T., , "xProd"    })
	oBrowseLotes:addColumn({"Endereco"      , {||aBrowse[oBrowseLotes:nAt,02]}, "N", "@!"            , 0, 10 , 2   , .F. , , .F.,,            ,, .F., .T., , "xEnder"   })
	oBrowseLotes:addColumn({"Quantidade"    , {||aBrowse[oBrowseLotes:nAt,03]}, "C", "@E 999,999.99" , 0, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xQuant"   })
	oBrowseLotes:addColumn({"Lote"          , {||aBrowse[oBrowseLotes:nAt,04]}, "C", "@!"            , 0, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowseLotes:addColumn({"Validade"      , {||aBrowse[oBrowseLotes:nAt,05]}, "D", "@!"            , 0, 10 ,     , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowseLotes:setArray( aBrowse )
	oBrowseLotes:SetLocate() // Habilita a Localização de registros
	oBrowseLotes:setEditCell( .T. , { || vldLot() } )
	//oBrowseLotes:SetEditCell( .T. )                 // indica que o grid é editavel
	//oBrowseLotes:acolumns[4]:ledit     := .T.
	//oBrowseLotes:acolumns[4]:cReadVar:= 'aBrowse[oBrowseLotes:nAt,4]'
	//oBrowseLotes:acolumns[5]:ledit     := .T.
	//oBrowseLotes:acolumns[5]:cReadVar:= 'aBrowse[oBrowseLotes:nAt,5]'
	//oBrowseLotes:setInsert( .F. )
	//oBrowseLotes:SetDelete( .F., {||DeleteLine()} )
	//oBrowseLotes:setLineOk( { || chkLineOk() } )
	//oBrowseLotes:setAfterAddLine( { || posIncLine() } )

	oBrowseLotes:activate( )

	Activate MsDialog oDlgLote Centered

Return(aBrowse)

Static Function SelectAll()
	Local i
	Local lMark:= aBrowse[1,1]
	For i:= 1 to len(aBrowse)
		aBrowse[i,1]:= !lMark
	Next
	oBrowseLotes:refresh()
Return

/*
Static Function posIncLine()
	If oBrowseLotes:at() == len(aBrowseLotes)
		aBrowseLotes[ oBrowseLotes:at() , oBrowseLotes:GetColByID("xLote"    ):nOrder ] := space(20)
		aBrowseLotes[ oBrowseLotes:at() , oBrowseLotes:GetColByID("xQtdLote" ):nOrder ] := 0
	Endif
Return
Static Function DeleteLine()
	//Exclui o segundo elemento do Array (Deixa o segundo elemento como Nil)
    aDel(aBrowseLotes, oBrowseLotes:at() )
    //Redimensiona o Array
    aSize(aBrowseLotes, Len(aBrowseLotes)-1)
	oBrowseLotes:setArray(aBrowseLotes)	// Forço o Browse a ler os novos valores informados.
    oBrowseLotes:Refresh()				// Refresh do Grid
Return
*/

Static Function vldLot()
	Local i
	Local lRet:= .t.
	//Lote Repetido
	/*
	If !empty(aBrowseLotes[ oBrowseLotes:at() , oBrowseLotes:GetColByID("xLote"    ):nOrder ])
		cLote:= aBrowseLotes[ oBrowseLotes:at() , oBrowseLotes:GetColByID("xLote"    ):nOrder ]
		nPosLote:= aScan(aBrowseLotes,{|x| x[1] == cLote })
		If nPosLote > 0 .and. nPosLote != oBrowseLotes:at()
			If !MsgYesNo("Lote "+cLote+" já foi informado para outro volume. Confirma? ")
				lRet:= .F.
			Endif
		Endif
	Endif
	*/
	//Quantidade do lote excede quantidade do volume
	/*
	nQtdTot:=0
	For i:= 1 to len(aBrowseLotes)
		If nQtdTot + aBrowseLotes[i,2] > nQtdVol
			MsgStop("Quantidade excede o total do volume! Informe uma quantidde menor para este lote.")
			lRet:= .F.
			Exit
		Endif
		nQtdTot+= aBrowseLotes[i,2]
	Next
	*/

Return lRet
