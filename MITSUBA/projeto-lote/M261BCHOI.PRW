#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} M261BCHOI

/*/
User Function M261BCHOI()

	local aButtons := {}

	aAdd(aButtons,{'* Ler QRCode', {|| lerQrCod()}, OemToAnsI('* Ler QRCode')})

Return aButtons


/*/{Protheus.doc} 
/*/
Static Function lerQrCod()

	Local cTGet1 := Space(11) // Variavel do tipo caracter
	Local oDlg,oSay1,oTGet1
	// Local lHasButton := .T.

	oDlg := TDialog():New(180,180,450,660,'Leitura do QR CODE',,,,, ,CLR_WHITE,,,.T.)
	oSay1:= TSay():New(10,10,{||'QR CODE'},oDlg,,,,,,.T.,,CLR_WHITE,150,20)
	// oGet1 := TGet():New( 10, 40, { | u | If( PCount() == 0, cGet1, cGet1 := u ) },oDlg, 0120, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet1",,,,lHasButton  )
	oTGet1 := TGet():New(10,40,  {|u|if(PCount()==0,cTGet1,cTGet1:=u)},oDlg,150,010, "@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )

	oTButton2 := TButton():New( 115,170, "Confirmar",oDlg,{||AtuAcols(cTGet1),oDlg:End()}, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1 := TButton():New( 115,210, "Sair",     oDlg,{|| oDlg:End()}, 20,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oDlg:Activate()
Return

/*/{Protheus.doc} AtuAcols   
/*/
Static Function AtuAcols(cOp)
	Local cAliasNew := GetNextAlias()
	Local cLocaliz  := SPACE(TAMSX3("BE_LOCALIZ")[1])
	Local cNumseri  := SPACE(TAMSX3("D3_NUMSERI")[1])
	Local aCols := {}
	Local nx := 0

	BeginSql Alias cAliasNew
            SELECT D4_FILIAL
                ,D4_COD
                ,D4_LOCAL
                ,D4_LOTECTL
                ,D4_DTVALID
                ,D4_NUMLOTE
                ,SUM(D4_QUANT) AS D4_QUANT 
                ,B1_DESC
                ,B1_UM
                ,B1_LOCPAD
            FROM %table:SC2% SC2
            INNER JOIN %table:SD4% SD4 ON D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND C2_FILIAL = D4_FILIAL AND SD4.D_E_L_E_T_ = '' AND D4_QUANT > 0
            INNER JOIN %table:SB1% SB1 ON B1_COD = D4_COD AND LEFT(B1_FILIAL,LEN(B1_FILIAL)) = LEFT(D4_FILIAL,LEN(B1_FILIAL))
            WHERE SC2.D_E_L_E_T_ = '' AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN= %Exp:cOp%
            GROUP BY  D4_FILIAL,D4_COD,D4_LOCAL,D4_LOTECTL,D4_DTVALID,D4_NUMLOTE,B1_DESC,B1_UM,B1_LOCPAD
			ORDER BY D4_DTVALID
	EndSql

	If !(cAliasNew)->(Eof())
		aCols := {}
		While !(cAliasNew)->(Eof())

			if (cAliasNew)->B1_LOCPAD == (cAliasNew)->D4_LOCAL
				(cAliasNew)->(dbskip())
				loop
			endif
			
			aadd(aCols,{(cAliasNew)->D4_COD,;
				(cAliasNew)->B1_DESC,;
				(cAliasNew)->B1_UM,;
				(cAliasNew)->B1_LOCPAD,;
				cLocaliz,;
				(cAliasNew)->D4_COD,; 
				(cAliasNew)->B1_DESC,;
				(cAliasNew)->B1_UM,;
				(cAliasNew)->D4_LOCAL,;
				cLocaliz,;
				cNumseri,;
				(cAliasNew)->D4_LOTECTL,;
				(cAliasNew)->D4_NUMLOTE,;
				stod((cAliasNew)->D4_DTVALID),;
				0,;
				(cAliasNew)->D4_QUANT,;
				0,;
				"",;
				"",;
				(cAliasNew)->D4_LOTECTL,;
				stod((cAliasNew)->D4_DTVALID),;
				"",;
				"SD3",;
				0,;
				.F.})

			(cAliasNew)->(dbSkip())
		EndDo
		GetLotes(aCols)

		// for nx := 1 to len(aCols)
		// 	aCols[nx,14] := POSICIONE('SB8',3,XFILIAL('SB8')+aCols[nx,1]+aCols[NX,4]+aCols[NX,12], 'B8_DTVALID')
		// 	aCols[nx,21] := POSICIONE('SB8',3,XFILIAL('SB8')+aCols[nx,1]+aCols[NX,4]+aCols[NX,12], 'B8_DTVALID')
		// 	aCols[nx,20] := aCols[nx,12]
		// next nx
		
	Else
		FWAlertWarning('Ordem de produ��o n�o encontrada ou ja apontada e n�o possui saldos de empennho.','Aten��o')
	EndIf
Return


Static Function GetLotes(aCols)
	// Local nLargBtn      := 50
	// Local oDlgLote
	// Private aCols:= aClone(aColsLotes)
	//Private aColsLotes:= {{space(20),0}}
	// Private aColunas:= {"Volume","Quantidade","Nº do Lote"}
	//Objetos e componentes
	Private oDlgLote
	Private oFwLayer
	Private oPanTitulo
	Private oPanGrid
	//Cabeçalho
	Private oSayTitulo, cSayTitulo := 'Pagamento de producao'
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
	DEFINE MSDIALOG oDlgLote TITLE "Pick List de Separa�ao"  FROM 100, 0 TO nJanAltu, nJanLarg PIXEL

	//Criando a camada
	oFwLayer := FwLayer():New()
	oFwLayer:init(oDlgLote,.F.)

	//Adicionando 3 linhas, a de título, a superior e a do calendário
	oFWLayer:addLine("TIT", 10, .F.)
	// oFWLayer:addLine("PAR", 10, .F.)
	oFWLayer:addLine("COR", 90, .F.)

	//Adicionando as colunas das linhas
	oFWLayer:addCollumn("HEADERTEXT",   0, .T., "TIT")
	oFWLayer:addCollumn("BLANKBTN",     100, .T., "TIT")

	// oFWLayer:addCollumn("COLPAR",       085, .T., "PAR")
	// oFWLayer:addCollumn("BTNREP",       015, .T., "PAR")

	oFWLayer:addCollumn("COLGRID",      100, .T., "COR")

	//Criando os paineis
	oPanHeader := oFWLayer:GetColPanel("HEADERTEXT", "TIT")
	oPanBut    := oFWLayer:GetColPanel("BLANKBTN",    "TIT")
	// oPanPar    := oFWLayer:GetColPanel("COLPAR"	, 	 "PAR")
	// oPanRep    := oFWLayer:GetColPanel("BTNREP"	, 	 "PAR")
	oPanGrid   := oFWLayer:GetColPanel("COLGRID",    "COR")

	//Títulos e SubTítulos
	oSayTitulo := TSay():New(004, 05, {|| cSayTitulo}, oPanHeader, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )
	// oSaySubTit := TSay():New(014, 05, {|| cSaySubTit}, oPanHeader, "", oFontSubN, , , , .T., RGB(031, 073, 125), , 100, 30, , , , , , .F., , )

	// //Parametros para preenchimento das etiquetas
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
	oBtnSair := TButton():New(006, 600, "Confirmar",  oPanBut, {|| oDlgLote:End()}, 30, 012, , oFontBtn, , .T., , , , , , )


	//dialog com browse para definição dos lotes
	oBrowseLotes := fwBrowse():New()
	//oBrowseLotes:SetColumns(aColunas)

	oBrowseLotes:lHeaderClick:=.F.
	oBrowseLotes:setDataArray()

	oBrowseLotes:disableConfig()  
	
	oBrowseLotes:disableReport()
	oBrowseLotes:setOwner( oPanGrid )
	
	// oBrowseLotes:AddMarkColumns( {||IIF(aCols[oBrowseLotes:nAt,01],'LBOK','LBNO')}, {||aCols[oBrowseLotes:nAt,01]:= !aCols[oBrowseLotes:nAt,01] }/*[ bLDblClick]*/, /*[ bHeaderClick]*/ )
	oBrowseLotes:addColumn({"Codigo" 	, {||aCols[oBrowseLotes:nAt,01]}, "C", "@!"	 , 0, 10 ,    , .F. ,,  .F.,, ,, .F., .T., , "xCodigo"    })
	oBrowseLotes:addColumn({"Descricao" , {||aCols[oBrowseLotes:nAt,02]}, "C", "@!"  , 1, 30 ,    , .F. , , .F.,, ,, .F., .T., , "xDescricao"    })
	oBrowseLotes:addColumn({"UM" 		, {||aCols[oBrowseLotes:nAt,03]}, "C", "@!"  , 0, 10 ,    , .F. , , .F.,, "__ReadVar",, .F., .T., , "xUnid"    })
	oBrowseLotes:addColumn({"Arm. Orig ", {||aCols[oBrowseLotes:nAt,04]}, "C", "@!"  , 0, 10 ,    , .F. , , .F.,, "__ReadVar",, .F., .T., , "xLocOri"  })
	oBrowseLotes:addColumn({"End Orig."   , {||aBrowse[oBrowseLotes:nAt,05]}, "C", "@!"  , 1, 10 ,    , .T. , , .F.,, "__ReadVar",, .F., .T., , "xData"    })
	// oBrowseLotes:addColumn({"Lote ", 	  {||aCols[oBrowseLotes:nAt,11]}, "C", "@!"  , 0, 15 ,    , .T. , , .F.,, "__ReadVar",, .F., .T., , "xLote"    })
	oBrowseLotes:addColumn({"Arm. Dest ", {||aCols[oBrowseLotes:nAt,09]}, "C", "@!"  , 0, 10 ,    , .F. , , .F.,, "__ReadVar",, .F., .T., , "xLocDest" })
	// oBrowseLotes:addColumn({"End. Dest ", {||aCols[oBrowseLotes:nAt,10] := 'PADRAO' }, "C", "@!"  , 0, 15 ,    , .T. , , .F.,, "__ReadVar",, .F., .T., , "xEndDest" })
	oBrowseLotes:addColumn({"Quantidade ",{||aCols[oBrowseLotes:nAt,16]}, "N", "@R 999999999999999"  , 0, 14 , , .T. , , .F.,, "__ReadVar",, .F., .T., , "cQtd"})
	oBrowseLotes:setArray( aCols )
	oBrowseLotes:SetLocate() // Habilita a Localização de registros
	oBrowseLotes:setEditCell( .T. , { || .T. } )
	// oBrowseLotes:SetEditCell( .T. )                 // indica que o grid é editavel

	oBrowseLotes:acolumns[5]:ledit     := .T.
	oBrowseLotes:acolumns[5]:cReadVar:= 'aCols[oBrowseLotes:nAt,05]'
	// oBrowseLotes:acolumns[6]:ledit     := .T.
	// oBrowseLotes:acolumns[6]:cReadVar:= 'aCols[oBrowseLotes:nAt,11]'
	// oBrowseLotes:acolumns[8]:ledit     := .T.
	// oBrowseLotes:acolumns[8]:cReadVar:= 'aCols[oBrowseLotes:nAt,10]'
	// oBrowseLotes:acolumns[6]:ledit     := .T.
	// oBrowseLotes:acolumns[6]:cReadVar:= 'aCols[oBrowseLotes:nAt,16]'

	oBrowseLotes:activate( )

	Activate MsDialog oDlgLote Centered

Return(aCols)



Static Function vldLot()
	// Local i
	Local lRet:= .t.
	//Lote Repetido
	/*
	If !empty(aColsLotes[ oBrowseLotes:at() , oBrowseLotes:GetColByID("xLote"    ):nOrder ])
		cLote:= aColsLotes[ oBrowseLotes:at() , oBrowseLotes:GetColByID("xLote"    ):nOrder ]
		nPosLote:= aScan(aColsLotes,{|x| x[1] == cLote })
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
	For i:= 1 to len(aColsLotes)
		If nQtdTot + aColsLotes[i,2] > nQtdVol
			MsgStop("Quantidade excede o total do volume! Informe uma quantidde menor para este lote.")
			lRet:= .F.
			Exit
		Endif
		nQtdTot+= aColsLotes[i,2]
	Next
	*/

Return lRet
