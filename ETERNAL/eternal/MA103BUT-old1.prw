#Include 'Protheus.ch'
#INCLUDE 'ParmType.ch'
#INCLUDE 'FWBrowse.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "RWMAKE.CH"

User Function MA103BUT()
	Local aButtons := {}
	Local dEmisDe   := FirstDate(Date())
	Local dEmisAte  := LastDate(Date())
	Local nFinanc   := 2 // 1=Sim / 2=Não
	Local cPlaca    := Space(10)
	Local cCCODe    := Space(TamSX3("C7_XDOCCO")[1])
	Local cCCOAte   := Space(TamSX3("C7_XDOCCO")[1])

	aadd(aButtons, {'Pedidos de Compras – OLUC', {||  fnParams(@dEmisDe,@dEmisAte,@nFinanc,@cPlaca,@cCCODe,@cCCOAte)}, 'Pedidos de Compras – OLUC'})

Return (aButtons)

Static Function fnParams(dEmisDe, dEmisAte, nFinanc, cPlaca, cCCODe, cCCOAte)

	Local aPergs    := {}

	aAdd(aPergs,{1,"Data Emissão De",  dEmisDe ,"",".T.","",".T.",80,.F.})
	aAdd(aPergs,{1,"Data Emissão Até", dEmisAte,"",".T.","",".T.",80,.T.})
	aAdd(aPergs,{2,"Financeiro (Adiantamento)",nFinanc,{"1=Sim","2=Não"},090,".T.",.F.})
	aAdd(aPergs,{1,"Placa do Veículo",cPlaca,"",".T.","",".T.",20,.F.})
	aAdd(aPergs,{1,"CCO De",cCCODe,"",".T.","",".T.",30,.F.})
	aAdd(aPergs,{1,"CCO Até",cCCOAte,"",".T.","",".T.",30,.T.})

	//---------------------------------------------------------
	If ParamBox(aPergs,"Informe os parâmetros")

		dEmisDe  := MV_PAR01
		dEmisAte := MV_PAR02
		nFinanc  := Val(cValToChar(MV_PAR03))
		cPlaca   := AllTrim(MV_PAR04)
		cCCODe   := AllTrim(MV_PAR05)
		cCCOAte  := AllTrim(MV_PAR06)

		// chamar a função que marca os pedidos de compras.
		FnMarkPed()

	EndIf

Return

/*/{Protheus.doc} fnMarkPed()
    (long_description)
    @type  Static Function
    @author user
    @since 03/08/2026
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fnMarkPed()
	Local cQuery := ""
	Local nCont := 0
	Local cAliasSC7 := GetNextAlias()

	If CFORMUL == 'N' // PRECISA SER FORMULÁRIO PRÓPRIO
		FwAlertWarning("Essa operação exige que seja informado * Form. próprio = SIM *.",'Warning!!!')
		Return
	EndIf

	If Empty(CA100FOR)
		FwAlertWarning("Fornecedor não informado, Informe o fornecedor para prosseguir.",'Warning!!!')
		Return
	EndIf

	// Verificar se o fornecedor permite formulario proprio.
	if Posicione('SA2',1,xFilial("SA2")+CA100FOR+cLoja,"A2_XFPROP") != 'S'
		FwAlertWarning("Fornecedor não permite formulário próprio, verifique o cadastro do fornecedor informado - (A2_XFPROP).",'Warning!!!')
		Return
	EndIf

/*/------------------------------------------------------------
	MV_PAR01 -> Data Emissão De
	MV_PAR02 -> Data Emissão Até
	MV_PAR03 -> Financeiro
	1 = Sim
	2 = Não
	MV_PAR04 -> Placa
	MV_PAR05 -> CCO De
	MV_PAR06 -> CCO Até
	--------------------------------------------------------------*/

	cQuery := "       SELECT "
	cQuery += "       SC7.R_E_C_N_O_ AS RECNO, "
	cQuery += "       SC7.C7_FILIAL, "
	cQuery += "       SC7.C7_NUM, "
	cQuery += "       SC7.C7_ITEM, "
	cQuery += "       SC7.C7_PRODUTO, "
	cQuery += "       SC7.C7_DESCRI, "
	cQuery += "       SC7.C7_UM, "
	cQuery += "       SC7.C7_QUANT, "
	cQuery += "       SC7.C7_QUJE, "
	cQuery += "       SC7.C7_PRECO, "
	cQuery += "       SC7.C7_TOTAL, "
	cQuery += "       SC7.C7_EMISSAO, "
	cQuery += "       SC7.C7_DATPRF, "
	cQuery += "       SC7.C7_FORNECE, "
	cQuery += "       SC7.C7_LOJA, "
	cQuery += "       SC7.C7_CC, "
	cQuery += "       SC7.C7_BASEICM, "
	cQuery += "       SC7.C7_VALICM, "
	cQuery += "       SC7.C7_PICM, "
	cQuery += "       SC7.C7_BASEIPI, "
	cQuery += "       SC7.C7_VALIPI, "
	cQuery += "       SC7.C7_IPI, "
	cQuery += "       SC7.C7_VALIMP5, "
	cQuery += "       SC7.C7_VALIMP6, "
	cQuery += "       SC7.C7_ICMSRET, "
	cQuery += "       SC7.C7_COND, "
	cQuery += "       SC7.C7_TES, "
	cQuery += "       SC7.C7_LOCAL, "
	cQuery += "       SC7.C7_XDOCCO, "
	cQuery += "       SC7.C7_XPLACA, "
	cQuery += "       SC7.C7_XTPDOC, "
	cQuery += "       SC7.C7_RESIDUO, "
	cQuery += "       SE4.E4_DESCRI, "
	cQuery += "       SE4.E4_CTRADT "

	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "

	cQuery += " LEFT JOIN " + RetSqlName("SE4") + " SE4 "
	cQuery += "        ON SE4.E4_FILIAL  = SC7.C7_FILIAL "
	cQuery += "       AND SE4.E4_CODIGO  = SC7.C7_COND "
	cQuery += "       AND SE4.D_E_L_E_T_ = ' ' "
	//====================================================
	// Financeiro (Adiantamento)
	// SE4.E4_CTRADT
	//====================================================
	Do Case

	Case MV_PAR03 == 1      // Sim
		cQuery += " AND SE4.E4_CTRADT = 'S' "

	Case MV_PAR03 == 2      // Não
		cQuery += " AND (SE4.E4_CTRADT <> 'S' OR SE4.E4_CTRADT IS NULL) "
	EndCase

	cQuery += " WHERE SC7.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SC7.C7_XTPDOC  = 'O' "
	cQuery += "   AND SC7.C7_QUJE    = 0 "
	cQuery += "   AND SC7.C7_RESIDUO = ' ' "

	//====================================================
	// Data de emissão
	//====================================================
	cQuery += " AND SC7.C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' "
	cQuery += "                         AND '" + DTOS(MV_PAR02) + "' "

	//====================================================
	// CCO
	//====================================================
	cQuery += " AND SC7.C7_XDOCCO BETWEEN '" + ;
		AllTrim(MV_PAR05) + "' AND '" + ;
		AllTrim(MV_PAR06) + "' "

	//====================================================
	// Placa
	//====================================================
	cQuery += " AND SC7.C7_XPLACA = '" + AllTrim(MV_PAR04) + "' "

	//====================================================
	cQuery += " ORDER BY "
	cQuery += " SC7.C7_EMISSAO, "
	cQuery += " SC7.C7_NUM, "
	cQuery += " SC7.C7_ITEM "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

	count to nCont

	If !(cAliasSC7)->(!Eof())
		fMontaTelaPed(cAliasSC7)
	Else
		FWAlertInfo("Nenhum pedido encontrado.","Atenção")
	EndIf

Return

Static Function fMontaTelaPed(cAliasSC7)

	Local aAreaMT := FWGetArea()
	Local aCampos := {}
	Local aColunas := {}

	Private oDlgMark
	Private oMarkBrowse
	Private oPanGrid

	Private cAliasTmp := GetNextAlias()

	Private aTamanho := MsAdvSize()
	Private nJanLarg := aTamanho[5]
	Private nJanAltu := aTamanho[6]

	// Campos temporários

	aAdd(aCampos,{"OK","C",2,0})

	aAdd(aCampos,{"C7_FILIAL"   ,"C",TamSx3('C7_FILIAL')[1],0})
	aAdd(aCampos,{"C7_NUM"      ,"C",TamSx3('C7_NUM')[1],0})
	aAdd(aCampos,{"C7_EMISSAO"  ,"D",TamSx3('C7_EMISSAO')[1],0})
	aAdd(aCampos,{"C7_ITEM"     ,"C",TamSx3('C7_ITEM')[1],0})
	aAdd(aCampos,{"C7_PRODUTO"  ,"C",TamSx3('C7_PRODUTO')[1],0})
	aAdd(aCampos,{"C7_DESCRI"   ,"C",TamSx3('C7_DESCRI')[1],0})
	aAdd(aCampos,{"C7_QUANT"    ,"N",TamSx3('C7_QUANT')[1],2})
	aAdd(aCampos,{"C7_PRECO"    ,"N",TamSx3('C7_PRECO')[1],2})
	aAdd(aCampos,{"C7_TOTAL"    ,"N",TamSx3('C7_TOTAL')[1],2})
	aAdd(aCampos,{"C7_VLDESC"   ,"N",TamSx3('C7_VLDESC')[1],2})
	aAdd(aCampos,{"C7_COND"     ,"C",TamSx3('C7_COND')[1],0})
	aAdd(aCampos,{"C7_TES"      ,"C",TamSx3('C7_TES')[1],0})
	aAdd(aCampos,{"D1_CF"       ,"C",TamSx3('D1_CF')[1],0})
	aAdd(aCampos,{"C7_CC"       ,"C",TamSx3('C7_CC')[1],0})
	aAdd(aCampos,{"E4_CTRADT"   ,"C",TamSx3('E4_CTRADT')[1],0})
	aAdd(aCampos,{"C7_XPLACA"   ,"C",TamSx3('C7_XPLACA')[1],0})
	aAdd(aCampos,{"C7_XTPDOC"   ,"C",TamSx3('C7_XTPDOC')[1],0})
	aAdd(aCampos,{"C7_XDOCCO"   ,"C",TamSx3('C7_XDOCCO')[1],0})
	aAdd(aCampos,{"C7_FORNECE"  ,"C",TamSx3('C7_FORNECE')[1],0})
	aAdd(aCampos,{"C7_LOJA"     ,"C",TamSx3('C7_LOJA')[1],0})
	aAdd(aCampos,{"C7_LOCAL"    ,"C",TamSx3('C7_LOCAL')[1],0})
	aAdd(aCampos,{"C7_BASEICM"  ,"N",TamSx3('C7_BASEICM')[1],2})
	aAdd(aCampos,{"C7_VALICM"   ,"N",TamSx3('C7_VALICM')[1],2})
	aAdd(aCampos,{"C7_PICM"     ,"N",TamSx3('C7_PICM')[1],2})
	aAdd(aCampos,{"C7_BASEIPI"  ,"N",TamSx3('C7_BASEIPI')[1],2})
	aAdd(aCampos,{"C7_VALIPI"   ,"N",TamSx3('C7_VALIPI')[1],2})
	aAdd(aCampos,{"C7_IPI"      ,"N",TamSx3('C7_IPI')[1],2})
	aAdd(aCampos,{"C7_VALIMP5"  ,"N",TamSx3('C7_VALIMP5')[1],2})
	aAdd(aCampos,{"C7_VALIMP6"  ,"N",TamSx3('C7_VALIMP6')[1],2})
	aAdd(aCampos,{"C7_ICMSRET"  ,"N",TamSx3('C7_ICMSRET')[1],2})
	aAdd(aCampos,{"RECNO"  ,"N",10,2})

	// cria temporária

	oTempTable := FWTemporaryTable():New(cAliasTmp)
	oTempTable:SetFields(aCampos)
	oTempTable:Create()

	// popula
	Processa({|| fPopulaPed(cAliasSC7)},;
		"Carregando pedidos...")

	aColunas := fCriaColsPed()

	aRotina := MenuDef()

	DEFINE MSDIALOG oDlgMark TITLE "Pedidos de Compras - OLUC" ;
		FROM 000,000 TO nJanAltu,nJanLarg PIXEL

	// oPanGrid := TPanel():New(001,001,"",oDlgMark,,,,,,RGB(254,254,254),(nJanLarg/2),(nJanAltu/2))
	oPanGrid := tPanel():New(001, 001,"", oDlgMark,,,, RGB(000,000,000), RGB(254,254,254),(nJanLarg/2 - 13), (nJanAltu/2 - 45))

	oMarkBrowse := FWMarkBrowse():New()
	oMarkBrowse:SetAlias(cAliasTmp)
	oMarkBrowse:SetDescription("Pedidos de Compras")
	oMarkBrowse:SetFieldMark("OK")
	oMarkBrowse:SetTemporary(.T.)
	oMarkBrowse:SetColumns(aColunas)
	oMarkBrowse:DisableFilter()
	oMarkBrowse:SetOwner(oPanGrid)
	oMarkBrowse:Activate()

	ACTIVATE MSDIALOG oDlgMark CENTERED

	oTempTable:Delete()

	FWRestArea(aAreaMT)

Return

Static Function MenuDef()

	Local aMenuMark := {}

	ADD OPTION aMenuMark TITLE "Confirmar" ACTION "u_ConfirmaPed()" OPERATION 2 ACCESS 0
	ADD OPTION aMenuMark TITLE "Marcar/Desmarcar Todos" ACTION "u_MarkTodos()" OPERATION 2 ACCESS 0

Return aMenuMark

Static Function fCriaColsPed()
	Local nAtual    := 0
	Local aColunas  := {}
	Local aEstrut   := {}
	Local oColumn

	// Campos exibidos no FWMarkBrowse
	// {Campo temporária, Título, Tipo, Tamanho, Decimais, Picture}

	aAdd(aEstrut,{"C7_FILIAL","Filial"            ,"C",TamSx3('C7_FILIAL')[1],0,''})
	aAdd(aEstrut,{"C7_NUM"   ,"Pedido"            ,"C",TamSx3('C7_NUM')[1],0,''})
	aAdd(aEstrut,{"C7_EMISSAO","Data Emissão"     ,"D",TamSx3('C7_EMISSAO')[1],0,""})
	aAdd(aEstrut,{"C7_ITEM"  ,"Item"              ,"C",TamSx3('C7_ITEM')[1],0,''})
	aAdd(aEstrut,{"C7_PRODUTO","Produto"          ,"C",TamSx3('C7_PRODUTO')[1],0,''})
	aAdd(aEstrut,{"C7_DESCRI","Descrição Produto" ,"C",TamSx3('C7_DESCRI')[1],0,''})
	aAdd(aEstrut,{"C7_QUANT" ,"Quantidade"        ,"N",TamSx3('C7_QUANT')[1],2,"@E 999,999.99"})
	aAdd(aEstrut,{"C7_PRECO" ,"Valor Unitário"    ,"N",TamSx3('C7_PRECO')[1],2,"@E 999,999.99"})
	aAdd(aEstrut,{"C7_TOTAL" ,"Valor Total"       ,"N",TamSx3('C7_TOTAL')[1],2,"@E 999,999.99"})
	aAdd(aEstrut,{"C7_VLDESC","Desconto"          ,"N",TamSx3('C7_VLDESC')[1],2,"@E 999,999.99"})
	aAdd(aEstrut,{"C7_COND"  ,"Cond. Pagamento"   ,"C",TamSx3('C7_COND')[1],0,""})
	aAdd(aEstrut,{"C7_TES"   ,"TES"               ,"C",TamSx3('C7_TES')[1],0,""})
	aAdd(aEstrut,{"D1_CF"   ,"Cod. Fiscal"        ,"C",TamSx3('D1_CF')[1],0,""})
	aAdd(aEstrut,{"C7_CC"   ,"Centro de Custo"    ,"C",TamSx3('C7_CC')[1],0,""})
	aAdd(aEstrut,{"E4_CTRADT","Adiantamento"      ,"C",TamSx3('E4_CTRADT')[1],0,""})
	aAdd(aEstrut,{"C7_XPLACA","Placa"             ,"C",TamSx3('C7_XPLACA')[1],0,""})
	aAdd(aEstrut,{"C7_XTPDOC" ,"Tipo Docum."      ,"C",TamSx3('C7_XTPDOC')[1],0,""})
	aAdd(aEstrut,{"C7_XDOCCO" ,"CCO"              ,"C",TamSx3('C7_XDOCCO')[1],0,""})
	// aAdd(aEstrut,{"C7_FORNECE"  ,"Fornecedor"     ,"C",TamSx3('C7_FORNECE')[1],0,""})
	// aAdd(aEstrut,{"C7_LOJA"  ,"Loja"              ,"C",TamSx3('C7_LOJA')[1],0,""})
	// aAdd(aEstrut,{"C7_LOCAL"  ,"Local"            ,"C",TamSx3('C7_LOCAL')[1],0,""})

	// Criação das colunas

	For nAtual := 1 To Len(aEstrut)

		oColumn := FWBrwColumn():New()

		oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
		oColumn:SetTitle(aEstrut[nAtual][2])
		oColumn:SetType(aEstrut[nAtual][3])
		oColumn:SetSize(aEstrut[nAtual][4])
		oColumn:SetDecimal(aEstrut[nAtual][5])
		oColumn:SetPicture(aEstrut[nAtual][6])

		aAdd(aColunas,oColumn)

	Next

Return aColunas

Static Function fPopulaPed(cAliasSC7)

	DbSelectArea(cAliasSC7)

	(cAliasSC7)->(DbGoTop())

	While !(cAliasSC7)->(Eof())
		RecLock(cAliasTmp,.T.)
		(cAliasTmp)->OK          := " "
		(cAliasTmp)->RECNO   	 := (cAliasSC7)->RECNO
		(cAliasTmp)->C7_FILIAL   := (cAliasSC7)->C7_FILIAL
		(cAliasTmp)->C7_NUM      := (cAliasSC7)->C7_NUM
		(cAliasTmp)->C7_ITEM     := (cAliasSC7)->C7_ITEM
		(cAliasTmp)->C7_PRODUTO  := (cAliasSC7)->C7_PRODUTO
		(cAliasTmp)->C7_DESCRI   := (cAliasSC7)->C7_DESCRI
		(cAliasTmp)->C7_QUANT    := (cAliasSC7)->C7_QUANT
		(cAliasTmp)->C7_PRECO    := (cAliasSC7)->C7_PRECO
		(cAliasTmp)->C7_TOTAL    := (cAliasSC7)->C7_TOTAL
		(cAliasTmp)->C7_EMISSAO  := StoD((cAliasSC7)->C7_EMISSAO)
		(cAliasTmp)->C7_FORNECE  := (cAliasSC7)->C7_FORNECE
		(cAliasTmp)->C7_LOJA  	 := (cAliasSC7)->C7_LOJA
		(cAliasTmp)->C7_LOCAL    := (cAliasSC7)->C7_LOCAL
		(cAliasTmp)->C7_XDOCCO   := (cAliasSC7)->C7_XDOCCO
		(cAliasTmp)->C7_XPLACA   := (cAliasSC7)->C7_XPLACA
		(cAliasTmp)->C7_CC       := (cAliasSC7)->C7_CC
		(cAliasTmp)->C7_BASEICM  := (cAliasSC7)->C7_BASEICM
		(cAliasTmp)->C7_VALICM   := (cAliasSC7)->C7_VALICM
		(cAliasTmp)->C7_PICM     := (cAliasSC7)->C7_PICM
		(cAliasTmp)->C7_BASEIPI  := (cAliasSC7)->C7_BASEIPI
		(cAliasTmp)->C7_VALIPI   := (cAliasSC7)->C7_VALIPI
		(cAliasTmp)->C7_IPI      := (cAliasSC7)->C7_IPI
		(cAliasTmp)->C7_VALIMP5  := (cAliasSC7)->C7_VALIMP5
		(cAliasTmp)->C7_VALIMP6  := (cAliasSC7)->C7_VALIMP6
		(cAliasTmp)->C7_ICMSRET  := (cAliasSC7)->C7_ICMSRET
		(cAliasTmp)->C7_COND     := (cAliasSC7)->C7_COND
		(cAliasTmp)->C7_TES      := (cAliasSC7)->C7_TES
		(cAliasTmp)->D1_CF       := Posicione("SF4",1,xFilial("SF4")+(cAliasSC7)->C7_TES,"F4_CF")
		(cAliasTmp)->E4_CTRADT   := iif(Empty((cAliasSC7)->E4_CTRADT),"N",(cAliasSC7)->E4_CTRADT)
		(cAliasTmp)->(MsUnlock())

		(cAliasSC7)->(DbSkip())

	EndDo

Return

User Function MarkTodos()

	Local aAreaMakT   := FWGetArea()
	Local cMarca  := oMarkBrowse:Mark()
	Local lMarcar := .F.

	DbSelectArea(cAliasTmp)
	(cAliasTmp)->(DbGoTop())

	// Verifica se existe algum registro desmarcado
	While !(cAliasTmp)->(Eof())
		If Empty(AllTrim((cAliasTmp)->OK))
			lMarcar := .T.
			Exit
		EndIf
		(cAliasTmp)->(DbSkip())
	EndDo

	// Volta ao início
	(cAliasTmp)->(DbGoTop())

	// Marca ou desmarca todos
	While !(cAliasTmp)->(Eof())
		RecLock(cAliasTmp,.F.)
		(cAliasTmp)->OK := If(lMarcar,cMarca,"")
		MsUnlock()
		(cAliasTmp)->(DbSkip())
	EndDo

	(cAliasTmp)->(DbGoTop())
	oMarkBrowse:Refresh()
	FWRestArea(aAreaMakT)

Return


User Function ConfirmaPed()

	Local aAreaConf   := FWGetArea()
	Local cMarca      := oMarkBrowse:Mark()
	Local nItem       := 0
	Local nIncluidos  := 0
	Local nIgnorados  := 0
	Local aRateio     := {0,0,0}
	Local nSavNF  	 := MaFisSave()
	Local aColsBkp   := Aclone(Acols)

	DbSelectArea("SC7")
	SC7->(DbSetOrder(14)) // Índice Pedido + Item

	If Len(aCols) == 1 .And. Empty(AllTrim(aCols[1][fPosCampo("D1_COD")]))
		nItem := 1
	Else
		nItem := fProxItem()
	EndIf

	If !MaFisFound("NF")
		MaFisIni()
	endIf

	DbSelectArea(cAliasTmp)
	(cAliasTmp)->(DbGoTop())

	While !(cAliasTmp)->(Eof())

		If oMarkBrowse:IsMark(cMarca)

			If fJaExiste((cAliasTmp)->C7_NUM,(cAliasTmp)->C7_ITEM)

				nIgnorados++

			Else

				If SC7->(DbSeek(xFilial("SC7") + ;
						(cAliasTmp)->C7_NUM + ;
						(cAliasTmp)->C7_ITEM))

					NFePC2Acol( ;
						SC7->(RecNo()), ;
						nItem, ;
						SC7->C7_QUANT, ;
						StrZero(nItem,4), ;
						, ;
						@aRateio )

					fSetCampo(aCols[nItem],"D1_CF" ,Posicione("SF4",1,xFilial("SF4")+(cAliasTmp)->C7_TES,"F4_CF"))
					// Demais campos
					fSetCampo(aCols[nItem],"D1_CC"     ,(cAliasTmp)->C7_CC)
					fSetCampo(aCols[nItem],"D1_LOCAL"  ,(cAliasTmp)->C7_LOCAL)
					fSetCampo(aCols[nItem],"D1_FORNECE",CA100FOR)
					fSetCampo(aCols[nItem],"D1_LOJA"   ,CLOJA)
					fSetCampo(aCols[nItem],"D1_XDOCCO" ,(cAliasTmp)->C7_XDOCCO)
					fSetCampo(aCols[nItem],"D1_XPLACA" ,(cAliasTmp)->C7_XPLACA)

					nItem++
					nIncluidos++

				EndIf

			EndIf

		EndIf

		(cAliasTmp)->(DbSkip())

	EndDo

	If Len(Acols) == 0
		aCols:= aColsBKP
		MaFisRestore(nSavNF)
	EndIf

	If Type( "oGetDados" ) == "O"
		oGetDados:lNewLine:=.F.
		oGetDados:oBrowse:Refresh()
	EndIf

	oDlgMark:End()

	FWRestArea(aAreaConf)

	MsgInfo( ;
		"Processamento concluído."+CRLF+;
		"Incluídos: "+cValToChar(nIncluidos)+CRLF+;
		"Ignorados: "+cValToChar(nIgnorados))

Return
// User Function ConfirmaPed()

// 	Local aAreaConf   := FWGetArea()
// 	Local cMarca      := oMarkBrowse:Mark()
// 	Local nItem       := 0
// 	Local nIncluidos  := 0
// 	Local nIgnorados  := 0
// 	// Local aRateio     := {0,0,0}
// 	Local nSavNF  	 := MaFisSave()
// 	Local aColsBkp   := Aclone(Acols)
// 	Local lRet103Vpc	:= .T.
// 	Local lUsaFiscal := .T.
// 	Local lMt103Vpc
// 	Local nSldPed
// 	Local lUsaFiscal
// 	LOCAL aF4For := {}

// 	DbSelectArea("SC7")
// 	SC7->(DbSetOrder(14)) // Índice Pedido + Item

// 	If Len(aCols) == 1 .And. Empty(AllTrim(aCols[1][fPosCampo("D1_COD")]))
// 		nItem := 1
// 	Else
// 		nItem := fProxItem()
// 	EndIf

// 	DbSelectArea(cAliasTmp)
// 	(cAliasTmp)->(DbGoTop())

// 	While !(cAliasTmp)->(Eof())

// 		If oMarkBrowse:IsMark(cMarca)

// 			If fJaExiste((cAliasTmp)->C7_NUM,(cAliasTmp)->C7_ITEM)

// 				nIgnorados++

// 			Else

// 				If SC7->(DbSeek(xFilial("SC7") + ;
// 						(cAliasTmp)->C7_NUM + ;
// 						(cAliasTmp)->C7_ITEM))

// 					AAdd(aF4For,{.T.,SC7->C7_LOJA,SC7->C7_NUM,DTOC(SC7->C7_EMISSAO),If(SC7->C7_TIPO==2,"AE","PC")})

// 					nSldPed := SC7->C7_QUANT

// 					nItem++
// 					nIncluidos++

// 				EndIf

// 			EndIf

// 		EndIf

// 		(cAliasTmp)->(DbSkip())

// 	EndDo

// 	If !Empty(aF4For)

// 		Processa({||a103ProcJL(aF4For,1,CA100FOR,CLOJA,@lRet103Vpc,@lMt103Vpc,@nSldPed,lUsaFiscal,aGets,(lConsMedic .And. lNfMedic),aHeadSDE,@aColsSDE,aHeadSEV,aColsSEV,@lTxNeg,@nTaxaMoeda ) })

// 		If Len(Acols) == 0
// 			aCols:= aColsBKP
// 			MaFisRestore(nSavNF)
// 		EndIf
// 	EndIf

// 	If Type( "oGetDados" ) == "O"
// 		oGetDados:lNewLine:=.F.
// 		oGetDados:oBrowse:Refresh()
// 	EndIf

// 	oDlgMark:End()

// 	FWRestArea(aAreaConf)

// 	MsgInfo( ;
// 		"Processamento concluído."+CRLF+;
// 		"Incluídos: "+cValToChar(nIncluidos)+CRLF+;
// 		"Ignorados: "+cValToChar(nIgnorados))

// Return



// User Function ConfirmaPed()

// 	Local aAreaConf      := FWGetArea()
// 	Local cMarca     := oMarkBrowse:Mark()
// 	Local aLinha
// 	Local nItem      := 0
// 	Local nIncluidos := 0
// 	Local nIgnorados := 0

// 	// Calcula próximo item disponível
// 	if Len(aCols) == 1 .and. alltrim(acols[1][fPosCampo("D1_COD")]) == ""
// 		nItem := 1
// 	else
// 		nItem := fProxItem()
// 	endif

// 	If !MaFisFound("NF")
// 		MaFisIni()
// 	endIf

// 	DbSelectArea(cAliasTmp)
// 	(cAliasTmp)->(DbGoTop())

// 	While !(cAliasTmp)->(Eof())

// 		If oMarkBrowse:IsMark(cMarca)
// 			// Valida se já existe na grid
// 			If fJaExiste((cAliasTmp)->C7_NUM,(cAliasTmp)->C7_ITEM)
// 				nIgnorados++
// 			Else
// 				aLinha := fNovaLinha()
// 				// Cabeçalho da linha
// 				fSetCampo(aLinha,"D1_FILIAL" ,(cAliasTmp)->C7_FILIAL)
// 				fSetCampo(aLinha,"D1_ITEM"   ,StrZero(nItem,4))

// 				// Produto
// 				fSetCampo(aLinha,"D1_COD"    ,(cAliasTmp)->C7_PRODUTO)
// 				fSetCampo(aLinha,"D1_UM"     ,Posicione("SB1",1,xFilial("SB1")+(cAliasTmp)->C7_PRODUTO,"B1_UM"))

// 				// TES
// 				fSetCampo(aLinha,"D1_TES"    ,(cAliasTmp)->C7_TES)
// 				fSetCampo(aLinha,"D1_CF"     ,Posicione("SF4",1,xFilial("SF4")+(cAliasTmp)->C7_TES,"F4_CF"))

// 				// Quantidade e preço
// 				fSetCampo(aLinha,"D1_QUANT"  ,(cAliasTmp)->C7_QUANT)
// 				fSetCampo(aLinha,"D1_VUNIT"  ,(cAliasTmp)->C7_PRECO)

// 				// Pedido
// 				fSetCampo(aLinha,"D1_PEDIDO" ,(cAliasTmp)->C7_NUM)
// 				fSetCampo(aLinha,"D1_ITEMPC" ,(cAliasTmp)->C7_ITEM)

// 				// Demais campos
// 				fSetCampo(aLinha,"D1_CC"     ,(cAliasTmp)->C7_CC)
// 				fSetCampo(aLinha,"D1_LOCAL"  ,(cAliasTmp)->C7_LOCAL)
// 				fSetCampo(aLinha,"D1_FORNECE",CA100FOR)
// 				fSetCampo(aLinha,"D1_LOJA"   ,CLOJA)
// 				fSetCampo(aLinha,"D1_XDOCCO" ,(cAliasTmp)->C7_XDOCCO)
// 				fSetCampo(aLinha,"D1_XPLACA" ,(cAliasTmp)->C7_XPLACA)

// 				// Calcula total apenas para exibição
// 				fSetCampo(aLinha,"D1_TOTAL"  ,Round((cAliasTmp)->C7_QUANT * (cAliasTmp)->C7_PRECO,2))

// 				// fSetCampo(aLinha,"D1_BASEICM",(cAliasTmp)->C7_BASEICM)
// 				// fSetCampo(aLinha,"D1_VALICM" ,(cAliasTmp)->C7_VALICM)
// 				// fSetCampo(aLinha,"D1_PICM"   ,(cAliasTmp)->C7_PICM)
// 				// fSetCampo(aLinha,"D1_BASEIPI",(cAliasTmp)->C7_BASEIPI)
// 				// fSetCampo(aLinha,"D1_VALIPI" ,(cAliasTmp)->C7_VALIPI)
// 				// fSetCampo(aLinha,"D1_IPI"    ,(cAliasTmp)->C7_IPI)
// 				// fSetCampo(aLinha,"D1_VALIMP5",(cAliasTmp)->C7_VALIMP5)
// 				// fSetCampo(aLinha,"D1_VALIMP6",(cAliasTmp)->C7_VALIMP6)
// 				// fSetCampo(aLinha,"D1_ICMSRET",(cAliasTmp)->C7_ICMSRET)

// 				nItem++
// 				nIncluidos++
// 			EndIf
// 		EndIf
// 		(cAliasTmp)->(DbSkip())
// 	EndDo

// 	oDlgMark:End()
// 	FWRestArea(aAreaConf)

// 	MsgInfo("Processamento concluído."+CRLF+;
// 		"Incluídos: "+cValToChar(nIncluidos)+CRLF+;
// 		"Ignorados: "+cValToChar(nIgnorados))
// Return



Static Function fProxItem()

	Local nMaior := 0
	Local nX

	For nX := 1 To Len(aCols)
		If !Empty(fGetCampo(aCols[nX],"D1_ITEM"))
			nMaior := Max(nMaior,Val(fGetCampo(aCols[nX],"D1_ITEM")))
		EndIf
	Next

Return nMaior + 1

Static Function fJaExiste(cPedido,cItem)
	Local nX

	cItem := StrZero(Val(cItem),4)

	For nX := 1 To Len(aCols)
		If AllTrim(fGetCampo(aCols[nX],"D1_PEDIDO")) == AllTrim(cPedido) .And. AllTrim(fGetCampo(aCols[nX],"D1_ITEMPC")) == cItem
			Return .T.
		EndIf
	Next

Return .F.

Static Function fNovaLinha()

	Local nLinha

	nLinha := fLinhaLivre()

	If nLinha > 0
		Return aCols[nLinha]
	EndIf

	AAdd(aCols,AClone(aLinhaModelo))

	// limpa campos principais
	fSetCampo(aCols[Len(aCols)],"D1_ITEM","")
	fSetCampo(aCols[Len(aCols)],"D1_COD","")
	fSetCampo(aCols[Len(aCols)],"D1_QUANT",0)


Return aCols[Len(aCols)]

Static Function fLinhaLivre()
	Local n

	For n := 1 To Len(aCols)
		If Empty(fGetCampo(aCols[n],"D1_COD"))
			Return n
		EndIf
	Next

Return 0

Static Function fSetCampo(aLinha,cCampo,xValor)

	Local nPos := fPosCampo(cCampo)

	If nPos > 0
		aLinha[nPos] := xValor
	EndIf

Return

Static Function fGetCampo(aLinha,cCampo)

	Local nPos := fPosCampo(cCampo)

	If nPos > 0
		Return aLinha[nPos]
	EndIf

Return Nil

Static Function fPosCampo(cCampo)

Return AScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(cCampo)})

Return

Static Function a103procJL(aF4For,nOpc,cA100For,cLoja,lRet103Vpc,lMt103Vpc,nSldPed,lUsaFiscal,aGets,lNfMedic,aHeadSDE,aColsSDE,aHeadSEV, aColsSEV, lTxNeg, nTaxaMoeda)

	Local nx         := 0
	Local cItem		 := StrZero(1,Len(SD1->D1_ITEM))
	Local lZeraCols  := .T.
	Local aRateio    := {0,0,0}
	Local aMT103NPC  := {}
	Local aColsBkp   := Aclone(Acols)
	Local cPrdNCad   := ""
	Local nSavNF  	 := MaFisSave()
	Local n103TXPC	 := 0
	Local cSeekTXPC	 := ""
	Local nPosPc	 := GetPosSD1("D1_PEDIDO")
	Local nPosVlr	 := GetPosSD1("D1_VUNIT")
	Local aMT103FRE  := {}
	Local aCombo		:= {}
	Local nPsTpFrt		:= 0
	Local lvldFret 		:= SuperGetMV("MV_VALFRET",.F.,.F.)
	Local cFilSC7		:= xFilEnt(xFilial("SC7"),"SC7")
	Local lMT103NPC		:= ExistBlock("MT103NPC")
	Local lMT103TXPC	:= ExistBlock("MT103TXPC")
	Local lMT103FRE		:= ExistBlock("MT103FRE")
	Local cFilSB1		:= xFilial("SB1")
	Local cPCNum		:= ""
	Local aEstruSC7		:= SC7->( dbStruct() )
	Local nPosC7Qtd		:= aScan(aEstruSC7, {|x| AllTrim(x[1]) == "C7_QUANT"})
	Local lPeVldPc		:= .T.
	Local lPergBloq 	:= .F.
	Local aBkpImport 	:= {}
	Local aBkpDKDImport := {}
	Local lMT103PBLQ := .F.

	DEFAULT lUsaFiscal := .T.
	DEFAULT aGets      := {}
	DEFAULT lNfMedic   := .F.
	DEFAULT aHeadSDE   := {}
	DEFAULT aColsSDE   := {}

	If VALType("cQueryC7") <> "C"
		PRIVATE cQueryC7   := ""
	EndIf

	If ( nOpc == 1 )

		// PE para validação de carregamento do pedido de compras.
		If ExistBlock("M120vlpc")
			lPeVldPc := ExecBlock("M120vlpc",.F.,.F.,{@aF4For,lNfMedic,lUsaFiscal})
		EndIf
		If lPeVldPc

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))

			DbSelectArea("SC7")
			SC7->(DbSetOrder(14))

			For nx	:= 1 to Len(aF4For)
				If aF4For[nx][1]
					lPergBloq := .T.
					aBkpImport := aClone(aCols)
					aBkpDKDImport := aClone(aColsDKD)

					If lNfMedic
						cPCNum := aF4For[nx,6]
					Else
						cPCNum := aF4For[nx,3]
					Endif

					If Select("ITPC") > 0
						ITPC->(DbCloseArea())
					Endif

					cQry := StrTran(cQueryC7,"R_E_C_N_O_ RECSC7",	"R_E_C_N_O_ as RECNO, "+;
						"C7_NUM, "+;
						"C7_ITEM, "+;
						"C7_LOTPLS, "+;
						"C7_CODRDA, "+;
						"C7_PLOPELT, "+;
						"C7_PRODUTO, "+;
						"C7_TPFRETE, "+;
						"C7_MOEDA, "+;
						"C7_QUANT - C7_QUJE - C7_QTDACLA AS SLDPC ")

					cQry := StrTran(cQry,"WHERE ",	"WHERE C7_NUM = '" + cPCNum + "' AND "+;
						"C7_LOJA = '" + aF4For[nx,Iif(lNfMedic,5,2)] + "' AND ")


					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"ITPC",.T.,.T.)

					If Len(aEstruSC7) > 0 .And. nPosC7Qtd > 0
						TcSetField( "ITPC", "SLDPC", aEstruSC7[nPosC7Qtd,2], aEstruSC7[nPosC7Qtd,3], aEstruSC7[nPosC7Qtd,4] )
					EndIf

					DbSelectArea("ITPC")

					While ITPC->(!EOF())
						SC7->(DbGoTo(ITPC->RECNO))
						If lZeraCols
							aCols		:= {}
							aBkpImport  := {}
							aColsDKD	:= {}
							aBkpDKDImport := {}
							lZeraCols	:= .F.
							MaFisClear()

							If lVldFret .And. !Empty(ITPC->C7_TPFRETE) .And. MaFisFound("NF") .AND. Type("aNFEDanfe") == "A" .AND. Empty(aNfeDanfe[14])
								aCombo			:= CarregaTipoFrete()
								aNfeDanfe[14] := ITPC->C7_TPFRETE
								nPsTpFrt 		:= ascan(aCombo ,{|x| Substr(x,1,1) == Substr(aNFEDanfe[14],1,1)})
								If nPsTpFrt > 0
									oTpFrete:NAT := nPsTpFrt
									oTpFrete:refresh()
								EndIf
							ElseIf lVldFret .And. !Empty(ITPC->C7_TPFRETE) .And. !MaFisFound("NF")
								cTpFrete := ITPC->C7_TPFRETE
							EndIf
						EndIf

						If SB1->(DbSeek(cFilSB1 + ITPC->C7_PRODUTO))
							If RegistroOk("SB1",.F.)
								If lMt103Vpc
									lRet103Vpc := .T.
									lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
								EndIf

								If lRet103Vpc
									NfeJG2Acol(ITPC->RECNO,,ITPC->SLDPC,cItem,,@aRateio,aHeadSDE,@aColsSDE)
									cItem := SomaIt(cItem)
								EndIf
							ElseIf ExistBlock("MT103PBLQ")
								lMT103PBLQ := ExecBlock("MT103PBLQ",.F.,.F.,{ITPC->C7_PRODUTO})
								If lMT103PBLQ
									NfeJG2Acol( ITPC->RECNO, , ITPC->SLDPC, cItem, , @aRateio, aHeadSDE, @aColsSDE )
									cItem := SomaIt( cItem )
								Endif
							ElseIf lPergBloq .And. !MsgYesNo('STR0525' + AllTrim(ITPC->C7_NUM) + 'STR0526', 'STR0524') //O pedido de compra XXXX tem produtos bloqueados. Deseja importar apenas os produtos não bloqueados desse pedido?
								If Len(aBkpImport) > 0 .And. Empty(aBkpImport[1][2]) //Verifica se a primeira posição do aCols está vazia para não gravar linha em branco
									aCols := {}
								Else
									aCols := aBkpImport //Restaura aCols
									aColsDKD := aBkpDKDImport
								EndIf
								Exit
							Else
								lPergBloq := .F. //Pergunta apenas uma vez por pedido
							EndIf
						Else
							cPrdNCad += 'STR0061'+": "+ITPC->C7_NUM+"  "+'STR0063'+": "+ITPC->C7_PRODUTO+CHR(10)
						EndIf

						If ITPC->C7_MOEDA != 1
							cSeekTXPC := cFilSC7+cPCNum
						EndIf

						ITPC->(dbSkip())
					EndDo

					If Select("ITPC") > 0
						ITPC->(DbCloseArea())
					Endif
				EndIf
			Next nX

			//Exibe Lista dos Produtos não Cadastrados na Filial de Entrega
			If Len(cPrdNCad)>0 .And. !l103Auto
				Aviso("A103ProcJL",'STR0300'+CHR(10)+'STR0301'+CHR(10)+cPrdNCad,{"Ok"})
			EndIf

			//Restaura o Acols caso o mesmo estiver vazio
			If Len(Acols) == 0
				aCols:= aColsBKP
				MaFisRestore(nSavNF)
			Else
				//Ponto de entrada para manipular o array de multiplas naturezas por titulo no Pedido de Compras
				If lMT103NPC
					aMT103NPC := ExecBlock("MT103NPC",.F.,.F.,{aHeadSEV,aColsSEV})
					If (ValType(aMT103NPC) == "A")
						aColsSEV := aClone(aMT103NPC)
					EndIf
				EndIf

				//Ponto de entrada para alterar a moeda, taxa, e check box de taxa negociada de acordo com o Pedido de Compras
				If lMT103TXPC .And. !Empty(cSeekTXPC)
					If SC7->(DbSeek(cSeekTXPC))
						nPosItPc := aScan(aCols,{|x| AllTrim(x[nPosPc])==AllTrim(SC7->C7_NUM)})
						n103TXPC := ExecBlock("MT103TXPC",.F.,.F.)
						If ValType(n103TXPC) == "N"
							If n103TXPC > 0
								nTaxaMoeda := n103TXPC
							ElseIf nPosItPc > 0
								nTaxaMoeda := NoRound((aCols[nPosItPc][nPosVlr] / SC7->C7_PRECO),TamSx3("F1_TXMOEDA")[2])
							EndIf
							lTxNeg := .T.
							nMoedaCor := SC7->C7_MOEDA
						EndIf
					Endif
				EndIf

				//Impede que o item do PC seja deletado pela getdados da NFE na movimentacao das setas.
				If Type( "oGetDados" ) == "O"
					oGetDados:lNewLine:=.F.
					oGetDados:oBrowse:Refresh()
				EndIf

				//Ponto de entrada para manipular o array de Frete/Seguro/Despesa do Pedido de Compras
				If lMT103FRE
					aMT103FRE := ExecBlock("MT103FRE",.F.,.F.,aRateio)
					If (ValType(aMT103FRE) == "A")
						aRateio := aClone(aMT103FRE)
					EndIf
				EndIf

				//Rateio do valores de Frete/Seguro/Despesa do PC
				If lUsaFiscal
					Eval(bRefresh)
					lAtuDupPC := .T.
					Eval(bRefresh,6)
				Else
					aGets[SEGURO] := aRateio[1]
					aGets[VALDESP]:= aRateio[2]
					aGets[FRETE]  := aRateio[3]
				EndIf
			Endif
		Endif
	Endif

Return

Static Function NFeJG2Acol(nRecSC7,nItem,nSalPed,cItem,lPreNota,aRateio,aHeadSDE,aColsSDE,nPrUPreNf,lTColab)

	Local aArea		   := GetArea()
	Local aAreaSC7	   := SC7->(GetArea())
	Local aAreaSF4	   := SF4->(GetArea())
	Local aAreaSB1	   := SB1->(GetArea())
	Local aAreaSC1     := SC1->(GetArea())
	Local aAreaSTJ
	Local aRefSC7      := MaFisSXRef("SC7")

	Local cNGMNTNO	   := SuperGetMV("MV_NGMNTNO",.F.,"2")
	Local cNGMNTES	   := SuperGetMV('MV_NGMNTES', .F., 'N' )
	Local cMVARRPEDC   := SuperGetMV("MV_ARRPEDC", .F., "")
	Local lMNTD1OP	   := FindFunction( 'MNTD1OP' )
	Local lMNTD1ORDEM  := FindFunction( 'MNTD1ORDEM' )

	Local lRateioPC    := SuperGetMv("MV_NFEDAPC")
	Local lAllPC       := .T.
	Local lAltImpPreNf := .F.
	Local lMaFisFound  := MaFisFound()
	Local lMT103IPC	   := ExistBlock( "MT103IPC",,.T. )
	Local lMT103RCC	   := ExistBlock( "MT103RCC",,.T. )
	Local lMT103IP2	   := ExistBlock( "MT103IP2",,.T. )
	Local lRateioDE	   := .F.
	Local lTOPDRFRM    := FindFunction("A120RDFRM") .And. A120RDFRM("A103")

	Local nQuantPed    := 0
	Local nX           := 0
	Local nCntFor      := 0
	Local nValUnit     := 0
	Local nValFre      := 0
	Local nValDesc     := 0
	Local nValDesp     := 0
	Local nValSeg      := 0
	Local nValTot      := 0
	Local nPosQtd      := GetPosSD1("D1_QUANT")
	Local nPosQtd2     := GetPosSD1("D1_QTSEGUM")
	Local nPosTes      := GetPosSD1("D1_TES")
	Local nPosVunit    := GetPosSD1("D1_VUNIT")
	Local nPValFret	   := GetPosSD1("D1_VALFRE")
	Local nPValDesc	   := GetPosSD1("D1_VALDESC")
	Local nPValDesp	   := GetPosSD1("D1_DESPESA")
	Local nPValSeg	   := GetPosSD1("D1_SEGURO")
	Local nPVOrdem 	   := GetPosSD1("D1_ORDEM")
	Local nPMSIPC	   := GetNewPar("MV_PMSIPC",2)
	Local aVencReal    := {}
	Local dVencReal    := Ctod("")
	Local lXmlxped	   := .F.
	Local lPropFret    := SuperGetMV("MV_FRT103E",.F.,.T.)//Proporcionalização de frete.
	Local nBkp		   := 0
	Local lM103lRat    := SuperGetMv("MV_M103LRA",.F.,.F.)

	Local lDKD		   := ChkFile("DKD") .and. !Empty(aHeadDKD) //Tabela Complementar SD1
	local lExistC7CF   := SC7->(FieldPos("C7_CF")) > 0
	Local lTrbGen      := IIf(FindFunction("ChkTrbGen"),ChkTrbGen("SD1", "D1_IDTRIB"),.F.) // Verificacao tributos genericos

	DEFAULT aHeadSDE   := {}
	DEFAULT aColsSDE   := {}

	DEFAULT lPreNota := .F.
	DEFAULT lTColab  := .F.
	DEFAULT aRateio  := {0,0,0}

	If lTColab
		lXmlxped := SuperGetMV("MV_XMLXPED",.F.,.F.) //.T. = Mantém dados provenientes da NF, .F. = Assume dados provenientes do pedido de compra
	Endif

//-- Verifica a existencia do item do acols
	If nItem == Nil .Or. nItem > Len(aCols)
		aadd(aCols,Array(Len(aHeader)+1))
		For nX := 1 to Len(aHeader)
			If IsHeadRec(aHeader[nX][2])
				aCols[Len(aCols)][nX] := 0
			ElseIf IsHeadAlias(aHeader[nX][2])
				aCols[Len(aCols)][nX] := "SD1"
			ElseIf Trim(aHeader[nX][2]) == "D1_ITEM"
				aCols[Len(aCols)][nX] 	:= IIF(cItem<>Nil,cItem,StrZero(1,Len(SD1->D1_ITEM)))
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2], (aHeader[nX][10] <> "V") )
			EndIf
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
		Next nX
		nItem := Len(aCols)
	EndIf

//Posiciona registros
	dbSelectArea("SC7")
	SC7->(MsGoto(nRecSC7))

	lAllPC := SC7->C7_QUANT == nSalPed .And. Empty(SC7->C7_REAJUST)

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))

	If !lXmlxped
		nQuantPed:= SC7->C7_QUANT
		nValFre  := SC7->C7_VALFRE
		nValDesc := SC7->C7_VLDESC
		nValDesp := SC7->C7_DESPESA
		nValSeg  := SC7->C7_SEGURO
		If !Empty(cMVARRPEDC) .AND. AllTrim(Upper(cMVARRPEDC)) == "NOROUND"
			nValUnit := NoRound(NfePcReaj(SC7->C7_REAJUST,lReajuste),TamSX3('D1_VUNIT')[2])
			nValTot := NoRound(nSalPed*nValUnit,TamSX3('D1_TOTAL')[2])
		Else
			nValUnit := Round(NfePcReaj(SC7->C7_REAJUST,lReajuste),TamSX3('D1_VUNIT')[2])
			nValTot := Round(nSalPed*nValUnit,TamSX3('D1_TOTAL')[2])
		EndIf
	Else
		nValUnit := aCols[nItem][nPosVunit]
		nSalPed  := aCols[nItem][nPosQtd]
		nValFre	 := aCols[nItem][nPValFret]
		nValDesc := aCols[nItem][nPValDesc]
		nValDesp := IIF((nPValDesp > 0),aCols[nItem][nPValDesp],0)
		nValSeg  := IIF((nPValSeg > 0),aCols[nItem][nPValSeg],0)
		If !Empty(cMVARRPEDC)
			If AllTrim(Upper(cMVARRPEDC)) == "ROUND"
				nValTot := Round(nSalPed*nValUnit, TamSX3('D1_TOTAL')[2])
			ElseIf AllTrim(Upper(cMVARRPEDC)) == "NOROUND"
				nValTot := NoRound(nSalPed*nValUnit,TamSX3('D1_TOTAL')[2])
			EndIf
		Else
			nValTot := Round(nSalPed*nValUnit,TamSX3('D1_TOTAL')[2])
		EndIf
	EndIf

//Carrega os impostos do pedido de compra para o Doc.Entrada
	If lMaFisFound
		//Obtem a condicao de pagamento do pedido de compra
		If (l103Class .and. Empty(cCondicao)) .Or. !l103Class
			cCondicao := Iif(l103Auto .And. !Empty(cCondicao), cCondicao, SC7->C7_COND)
			aVencReal := Condicao(1,cCondicao,,M->dDEmissao) // O valor (parametro 1) não interessa neste momento, mas a funcão Condição() não retorna nada se o primeiro paramentro for 0 (zero), por esse motivo tive que chumbar um valor (1).
			If Len(aVencReal) > 0
				dVencReal := aVencReal[1][1]
			Else
				dVencReal := dDataBase
			EndIf
		EndIf

		MaFisIniLoad(nItem)
		For nX := 1 To Len(aRefSc7)
			Do Case
			Case aRefSC7[nX][2] == "IT_QUANT"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nSalPed,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_PRCUNI"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nValUnit,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_VALMERC"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],nValTot,nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_DESCONTO"
				If !lPreNota
					MaFisLoad(aRefSc7[nX][2],xMoeda(((nValDesc/nQuantPed)* nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_VALEMB"
				MaFisLoad(aRefSc7[nX][2],xMoeda(SC7->C7_VALEMB,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
			Case aRefSc7[nX][2] == "IT_SEGURO"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(((nValSeg/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[1] += xMoeda(((nValSeg/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_DESPESA"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(((nValDesp/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[2] += xMoeda(((nValDesp/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_FRETE"
				If lRateioPC
					MaFisLoad(aRefSc7[nX][2],xMoeda(((nValFre/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
				Else
					aRateio[3] += xMoeda(((nValFre/nQuantPed)*nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				EndIf
			Case aRefSc7[nX][2] == "IT_TES"
				If !Empty(SC7->C7_TES)
					dbSelectArea("SF4")
					SF4->(dbSetOrder(1))
					SF4->(DbSeek(xFilial("SF4")+SC7->C7_TES))
					MaFisLoad("IT_CF",MaFisCFO(nItem,SF4->F4_CF),nItem)
				EndIf
			Case aRefSc7[nX][2] == "IT_BASEICM"
				nD1BaseIcm := SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_BASEICM) .Or. SD1->D1_BASEICM == nD1BaseIcm
					If nD1BaseIcm <> 0
						MaFisLoad(aRefSc7[nX][2],nD1BaseIcm,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_ALIQICM"
				nD1Picm := SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_PICM) .Or. SD1->D1_PICM == nD1Picm
					If nD1Picm <> 0
						MaFisLoad(aRefSc7[nX][2],nD1Picm,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_VALICM"
				nD1ValIcm	:= SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_VALICM) .Or. SD1->D1_VALICM == nD1ValIcm
					If nD1ValIcm <> 0
						MaFisLoad(aRefSc7[nX][2],nD1ValIcm,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_BASEIPI"
				nD1BaseIpi	:= SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_BASEIPI) .Or. SD1->D1_BASEIPI == nD1BaseIpi
					If nD1BaseIpi <> 0
						MaFisLoad(aRefSc7[nX][2],nD1BaseIpi,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_ALIQIPI"
				nD1AliqIpi := SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_IPI) .Or. SD1->D1_IPI == nD1AliqIpi
					If nD1AliqIpi <> 0
						MaFisLoad(aRefSc7[nX][2],nD1AliqIpi,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			Case aRefSc7[nX][2] == "IT_VALIPI"
				nD1ValIpi	:= SC7->(FieldGet(FieldPos(aRefSc7[nX][1])))
				If !lPreNota .Or. Empty(SD1->D1_VALIPI) .Or. SD1->D1_VALIPI == nD1ValIpi
					If nD1ValIpi <> 0
						MaFisLoad(aRefSc7[nX][2],nD1ValIpi,nItem)
					Else
						lAltImpPreNf := .T.
					EndIf
				Else
					lAltImpPreNf := .T.
				EndIf
			OtherWise
				MaFisLoad(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
			EndCase
		Next nX
		MaFisEndLoad(nItem)
	Else
		//Obtem a condicao de pagamento do pedido de compra
		cCondicao := SC7->C7_COND
	EndIf

//Atualiza o acols com base no pedido de compras
	If !lPreNota
		if FwIsInCallStack("MATA103") .and. FwAliasInDic("DHR") .and. FindFunction("A103NatRen") .and. type("aHeadDHR") == "A" .and. type("aColsDHR") == "A"
			nBkp := n
		endif
		For nCntFor := 1 To Len(aHeader)
			Do Case
			Case Trim(aHeader[nCntFor,2]) == "D1_COD"
				aCols[nItem,nCntFor] := SC7->C7_PRODUTO
				//Atualiza a natureza de rendimento do item correspondente.
				if FwIsInCallStack("MATA103") .and. FwAliasInDic("DHR") .and. FindFunction("A103NatRen") .and. type("aHeadDHR") == "A" .and. type("aColsDHR") == "A"
					n := nItem
					A103NatRen(aHeadDHR,aColsDHR,.T.,.F.,,SC7->C7_PRODUTO)
				endif

				//Função responsável por retornar ncm definido na amarração prod x fornecedor
				Mt060CodFis(aCols[nItem,nCntFor],cA100For,cLoja)

			Case Trim(aHeader[nCntFor,2]) == "D1_REVISAO"
				aCols[nItem,nCntFor] := SC7->C7_REVISAO
			Case Trim(aHeader[nCntFor,2]) == "D1_TOTAL"
				aCols[nItem,nCntFor] := Round(nSalPed*Round(nValUnit,TamSX3('D1_VUNIT')[2]), TamSX3('D1_TOTAL')[2])
			Case Trim(aHeader[nCntFor,2]) == "D1_TES" .And. !Empty(SC7->C7_TES)
				aCols[nItem,nCntFor] := SC7->C7_TES
			Case Trim(aHeader[nCntFor,2]) == "D1_PEDIDO"
				aCols[nItem,nCntFor] := SC7->C7_NUM
			Case Trim(aHeader[nCntFor,2]) == "D1_QUANT" .Or. Trim(aHeader[nCntFor,2]) == "D1_SLDEXP"
				aCols[nItem,nCntFor] := nSalPed
			Case Trim(aHeader[nCntFor,2]) == "D1_VUNIT"
				aCols[nItem,nCntFor] := Round(nValUnit,TamSX3('D1_VUNIT')[2])
			Case Trim(aHeader[nCntFor,2]) == "D1_ITEMPC"
				aCols[nItem,nCntFor] := SC7->C7_ITEM
			Case Trim(aHeader[nCntFor,2]) == "D1_LOCAL"
				aCols[nItem,nCntFor] := SC7->C7_LOCAL
			Case Trim(aHeader[nCntFor,2]) == "D1_CC"
				aCols[nItem,nCntFor] := SC7->C7_CC
				If SC7->C7_RATEIO == "1" .And. lM103lRat
					aCols[nItem,nCntFor] := Space(Len(SC7->C7_CC)) // Limpa o conteúdo do campo devido a ativação do parametro MV_M103LRA.
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_OP"
				dbSelectArea("SC1")
				SC1->(dbSetOrder(1))
				SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
				If AllTrim(SC1->C1_ORIGEM) <> "MATA106" .And. (IIf(nPVOrdem > 0 ,Empty(aCols[nItem,nPVOrdem]) , .T.))
					aCols[nItem,nCntFor] := SC7->C7_OP
				EndIf

				// Integração com Sigamnt - carrega o campo OP
				If cNGMNTES == 'S' .And. Empty( aCols[nItem,nCntFor] ) .And. lMNTD1OP
					MNTD1OP( aHeader, aCols, nItem )
				EndIf

			Case Trim(aHeader[nCntFor,2]) == "D1_ITEMCTA"			// Item Contabil
				aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_ITEMCTA) .AND. SC7->C7_RATEIO !="1", SB1->B1_ITEMCC, SC7->C7_ITEMCTA )
				If SC7->C7_RATEIO == "1" .And. lM103lRat
					aCols[nItem,nCntFor] := Space(Len(SC7->C7_ITEMCTA)) // Limpa o conteúdo do campo devido a ativação do parametro MV_M103LRA.
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_CONTA"				// Conta Contabil
				aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_CONTA) .AND. SC7->C7_RATEIO !="1", SB1->B1_CONTA, SC7->C7_CONTA )
				If SC7->C7_RATEIO == "1" .And. lM103lRat
					aCols[nItem,nCntFor] := Space(Len(SC7->C7_CONTA)) // Limpa o conteúdo do campo devido a ativação do parametro MV_M103LRA.
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_CLVL"				// Classe de Valor
				aCols[nItem,nCntFor] := Iif( Empty(SC7->C7_CLVL) .AND. SC7->C7_RATEIO !="1", SB1->B1_CLVL, SC7->C7_CLVL )
				If SC7->C7_RATEIO == "1" .And. lM103lRat
					aCols[nItem,nCntFor] := Space(Len(SC7->C7_CLVL)) // Limpa o conteúdo do campo devido a ativação do parametro MV_M103LRA.
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_UM"
				aCols[nItem,nCntFor] := SC7->C7_UM
			Case Trim(aHeader[nCntFor,2]) == "D1_SEGUM"
				aCols[nItem,nCntFor] := SC7->C7_SEGUM
			Case Trim(aHeader[nCntFor,2]) == "D1_QTSEGUM"
				aCols[nItem,nCntFor] := IIF(SB1->B1_CONV <> 0 .And. aCols[nItem][nPosQtd] <> 0, ConvUm(SB1->B1_COD,aCols[nItem][nPosQtd],aCols[nItem][nPosQtd2],2),SC7->C7_QTSEGUM)
			Case Trim(aHeader[nCntFor,2]) == "D1_DESC"
				aCols[nItem,nCntFor] := SC7->C7_DESC
			Case Trim(aHeader[nCntFor,2]) == "D1_VALDESC"
				aCols[nItem,nCntFor] := xMoeda(((SC7->C7_VLDESC/SC7->C7_QUANT)* nSalPed) , SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			Case Trim(aHeader[nCntFor,2]) == "D1_RATEIO"
				aCols[nItem,nCntFor] := SC7->C7_RATEIO
				If SC7->C7_RATEIO == "1"
					lRateioDE	:= .T.
				Endif
			Case Trim(aHeader[nCntFor,2]) == "D1_VALFRE"
				If nPValFret > 0
					aCols[nItem,nCntFor] := if(lPropFret,xMoeda(((SC7->C7_VALFRE/SC7->C7_QUANT)* nSalPed),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA),xMoeda(SC7->C7_VALFRE,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA))
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_DESPESA"
				If nPValDesp > 0
					aCols[nItem,nCntFor] := xMoeda(((SC7->C7_DESPESA/SC7->C7_QUANT)* nSalPed) , SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				Endif
			Case Trim(aHeader[nCntFor,2]) == "D1_SEGURO"
				If nPValSeg > 0
					aCols[nItem,nCntFor] := xMoeda(((SC7->C7_SEGURO/SC7->C7_QUANT)* nSalPed) , SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
				Endif
			Case Trim(aHeader[nCntFor,2]) == "D1_CODGRP"
				aCols[nItem,nCntFor] := SB1->B1_GRUPO
			Case Trim(aHeader[nCntFor,2]) == "D1_CODITE"
				aCols[nItem,nCntFor] := SB1->B1_CODITE
			Case Trim(aHeader[nCntFor,2]) == "D1_CLASFIS"
				dbSelectArea("SF4")
				SF4->(dbSetOrder(1))
				SF4->(DbSeek(xFilial("SF4")+SC7->C7_TES))
				aCols[nItem,nCntFor] := SubStr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
			Case Trim(aHeader[nCntFor,2]) == "D1_IPI"
				If !Empty(SC7->C7_IPI)
					aCols[nItem,nCntFor] := SC7->C7_IPI
				Else
					aCols[nItem,nCntFor] := SB1->B1_IPI
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_PICM"
				If !Empty(SC7->C7_PICM)
					aCols[nItem,nCntFor] := SC7->C7_PICM
				Else
					aCols[nItem,nCntFor] := SB1->B1_PICM
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_ITEMMED"
				aCols[nItem,nCntFor] := If( !Empty( SC7->C7_CONTRA ) .And. !Empty( SC7->C7_MEDICAO ), "1", "2" )
				//Nota de empenho
			Case Trim(aHeader[nCntFor,2]) == "D1_CODNE"
				aCols[nItem,nCntFor] := SC7->C7_CODNE
			Case Trim(aHeader[nCntFor,2]) == "D1_ITEMNE"
				aCols[nItem,nCntFor] := SC7->C7_ITEMNE
			Case Trim(aHeader[nCntFor,2]) == "D1_DTVALID"
				If Rastro(SC7->C7_PRODUTO)
					If !lTColab
						aCols[nItem,nCntFor] := dDatabase + SB1->B1_PRVALID
					EndIf
				Else
					aCols[nItem,nCntFor] := Ctod( '' )
				EndIf
			Case Trim(aHeader[nCntFor,2]) == "D1_ORDEM"

				// Integração com Sigamnt - Carrega campo D1_ORDEM
				If lMNTD1ORDEM
					MNTD1ORDEM( aHeader, aCols, nItem )
				Else
					aAreaSC1 := SC1->(GetArea())

					dbSelectArea("SC1")
					SC1->(dbSetOrder(1))
					SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
					If AllTrim(SC1->C1_ORIGEM) <> "MATA106"
						If cNGMNTNO == "1"
							aAreaSC1 := SC1->(GetArea())
							aAreaSTJ := STJ->(GetArea())

							If !Empty(SC7->C7_OP)
								dbSelectArea("STJ")
								STJ->(dbSetOrder(1))

								cOPStj := SubStr(SC7->C7_OP,1,At("OS",SC7->C7_OP)-1)

								If !Empty(cOPStj) .And. STJ->(dbSeek(xFilial("STJ")+ cOPStj))
									aCols[nItem,nCntFor] := cOPStj
								EndIf
							Else
								dbSelectArea("SC1")
								SC1->(dbSetOrder(1))
								If SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
									dbSelectArea("STJ")
									STJ->(dbSetOrder(1))

									cOPStj := if(!empty(SC1->C1_OS),SC1->C1_OS,SubStr(SC1->C1_OP,1,At("OS",SC1->C1_OP)-1))

									If !Empty(cOPStj) .And. STJ->(dbSeek(xFilial("STJ")+ cOPStj))
										aCols[nItem,nCntFor] := cOPStj
										NGSDCHKORDEM(cOPStj,nItem)
									Endif
								Endif
							EndIf

							RestArea(aAreaSTJ)
							RestArea(aAreaSC1)
						EndIf
					Endif
					RestArea(aAreaSC1)
				Endif
				//Integração RM TOP x Protheus (Retenção/Dedução/Faturamento Direto)
			Case Type("lTOPDRFRM") <> "U" .And. lTOPDRFRM .And. Trim(aHeader[nCntFor,2]) == "D1_RETENCA"
				aCols[nItem,nCntFor] := SC7->C7_RETENCA-SC7->C7_QUJERET

			Case Type("lTOPDRFRM") <> "U" .And. lTOPDRFRM .And. Trim(aHeader[nCntFor,2]) == "D1_DEDUCAO"
				aCols[nItem,nCntFor] := SC7->C7_DEDUCAO-SC7->C7_QUJEDED

			Case Type("lTOPDRFRM") <> "U" .And. lTOPDRFRM .And. Trim(aHeader[nCntFor,2]) == "D1_FATDIRE"
				aCols[nItem,nCntFor] := SC7->C7_FATDIRE-SC7->C7_QUJEFAT
			EndCase
		Next nCntFor
		if FwIsInCallStack("MATA103") .and. FwAliasInDic("DHR") .and. FindFunction("A103NatRen") .and. type("aHeadDHR") == "A" .and. type("aColsDHR") == "A"
			n := nBkp
		endif
		FillCTBEnt("SC7",nItem)

		//Atualização de campos referente o modulo de Armazenagem - SIGAWMS
		If IntWMS(SC7->C7_PRODUTO)
			WmsAvalSD1("8","SD1",aCols,nItem,aHeader)
		EndIf

		If !lMaFisFound
			aRateio[1] += xMoeda(SC7->C7_SEGURO ,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			aRateio[2] += xMoeda(SC7->C7_DESPESA,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
			aRateio[3] += xMoeda(SC7->C7_VALFRE ,SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA)
		EndIf

		//Complementa o rateio da nota fiscal de saida com o rateio do pedido de compras
		If lRateioDE
			If Empty(aHeadSDE)
				dbSelectArea("SX3")
				SX3->(dbSetOrder(1))
				SX3->(DbSeek("SDE"))
				While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "SDE"
					IF X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"DE_CUSTO" $ SX3->X3_CAMPO
						AADD(aHeadSDE,{TRIM(x3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
					EndIf
					SX3->(dbSkip())
				EndDo
				//Adiciona os campos de Alias e Recno ao aHeader para WalkThru
				ADHeadRec("SDE",aHeadSDE)
			Endif

			cItemRat := IIF(cItem<>Nil,cItem,StrZero(nItem,Len(SD1->D1_ITEM)))
			RatPed2NF(aHeadSDE,@aColsSDE,cItemRat,nRecSC7)
		Endif
		If lDKD
			//Atualiza aColsDKD
			A103DKDATU(0,.T.)
		Endif
		// 1 - utilização a associação automática com o PMS
		// 2 - não utiliza a associação automática com o PMS
		// default: não utilizar a associação automática
		If IntePMS() .And. nPMSIPC == 1
			PMS103IPC(nItem)
		EndIf

		//Efetua a chamada dos pontos de entrada
		If ExistTemplate( "MT103IPC",,.T. ) .AND. HasTemplate("MT103IPC")
			ExecTemplate( "MT103IPC", .F., .F.,{nItem})
		EndIf

		//Agroindustria
		If FindFunction("OGXUtlOrig") .And. OGXUtlOrig()  //Encontra a função
			If FindFunction("OGX205") //Encontra a função
				OGX205() // Executa a função
			EndIf
		EndIf

		If lMT103IPC
			ExecBlock( "MT103IPC", .F., .F.,{nItem})
		EndIf

		If lMT103RCC
			aColsSDE := ExecBlock( "MT103RCC", .F., .F.,{aHeadSDE,aColsSDE})
		EndIf

		If lDKD
			//Atualiza aColsDKD
			A103DKDATU(0,.T.)
		Endif
	EndIf

//Quando ha TES no pedido de compra, deve-se recalcular os
//impostos carregados para verificar se nao ha novos impostos
//que devem ser calculados!
	If lMaFisFound
		Do Case
		Case cA100For+cLoja <> SC7->C7_FORNECE+SC7->C7_LOJA
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_ALIQICM",0,nItem)
			MaFisAlt("IT_ALIQIPI",0,nItem)
			If Empty(SC7->C7_TES)
				MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),nItem)
			Else
				MaFisAlt("IT_TES",SC7->C7_TES,nItem)
			EndIf
		Case Empty(SC7->C7_TES) .And. !Empty(RetFldProd(SB1->B1_COD,"B1_TE"))
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),nItem)
		Case Empty(SC7->C7_TES) .And. Empty(RetFldProd(SB1->B1_COD,"B1_TE")) .And. nPosTes > 0
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",IF( aCols[nItem,nPosTes] == Nil,CriaVar("D1_TES"),aCols[nItem,nPosTes] ),nItem,,,,,,dVencReal)
		Case !Empty(SC7->C7_TES)
			MaFisLoad("IT_TES","",nItem)
			MaFisAlt("IT_TES",SC7->C7_TES,nItem,,,,,,dVencReal)
			If lAllPC .And. !lAltImpPreNf
				// Quando for Relacionar o Pedido a Nf ou preço unitário da Pré-Nf for igual ao Pedido, entra na Rotina
				// Caso Preço Unitário da Pré-Nf for divergente do pedido, prevalece o preço da Pré-Nf mesmo que a quantidade do pedido seja igual.

				If nPrUPreNf == Nil .Or. (nPrUPreNf-SC7->C7_PRECO) == 0
					For nX := 1 To Len(aRefSc7)
						Do Case
						Case !("IT_BAS"$aRefSc7[nX][2] .Or. "IT_VAL"$aRefSc7[nX][2] .Or. "IT_ALIQ"$aRefSc7[nX][2])
							//Não fazer nada
						case !Empty(SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))))
							iF !(SUBSTR(aRefSc7[NX][2],4,3) $ 'BAS|VAL')
								MaFisAlt(aRefSc7[nX][2],SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),nItem)
							ELSE
								MaFisAlt(aRefSc7[nX][2],xMoeda(SC7->(FieldGet(FieldPos(aRefSc7[nX][1]))),SC7->C7_MOEDA,1,M->dDEmissao,,SC7->C7_TXMOEDA,),nItem)
							ENDif
						EndCase
					Next nX
				EndIf
			EndIf

			If lTColab
				ATriGenCol(nItem)
			EndIf
		EndCase

		//Tratamento do configurador de tributos a partir do CFOP
		if lExistC7CF .And. !Empty(SC7->C7_CF) .And. lTrbGen
			MaFisLoad("IT_CF","",nItem)
			MaFisAlt("IT_CF",SC7->C7_CF,nItem,,,,,,dVencReal)

			If lTColab
				ATriGenCol(nItem)
			EndIf
		endif

		//Ponto de entrada para tratamentos diversos após o recalculo de
		//impostos carregados a partir da TES correspondente
		If lMT103IP2
			ExecBlock( "MT103IP2", .F., .F.,{nItem})
		EndIf

		MaFisToCols(aHeader,aCols,Len(aCols),"MT100")
		aColsD1 := acols //Atualização necessária para que, o Array do Lançamento da Apuração de ICMS tenha o mesmos itens do acols da Nota Fiscal de Entrada.
	EndIf

	If cPaisLoc == "BRA" .And. Type("lIntermed") == "L" .And. lIntermed
		Eval(bRefresh,10)
	Endif

	If Type("bRefresh")=="B"
		Eval(bRefresh,6)
	EndIf

	RestArea(aAreaSB1)
	RestArea(aAreaSF4)
	RestArea(aAreaSC7)
	RestArea(aArea)
Return .T.
