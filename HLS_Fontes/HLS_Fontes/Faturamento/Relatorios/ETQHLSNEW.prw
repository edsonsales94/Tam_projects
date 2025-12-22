#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include 'TopConn.ch'
#Include 'font.ch'
#Include 'RPTDEF.CH'
#Include 'TBICONN.CH'
#Include "RWMAKE.CH"
#Include "FWPrintSetup.ch"

/*/{protheus.doc} ETQHLS

Etiquetas Produtos c/ Codigo de Barras

@author Marcos Martins
@since  24/06/08

/*/

User Function ETQHLSNEW()

	//Local aIndexSD2	:= {}
	Local cQuery	:= ""
	//Local cFilMarkb := ""
	local aIndex	:= {{"D2CODHAB"},;
						{"D2NOTA"},;
						{"D2CLIENTE"},;
						{"C6ENTREGA"}}

	Private bPesqBrw	:= {|| U_tPESQBROW("Classificar Itens", "ZD2", 4, aIndNome)}
	Private bMarkRes	:= {|| tMARKRES()}
	Private bImpEtq		:= {|| tGERAETQ()}
	Private cIndSD2 	:= CriaTrab(NIL,.F.)
	Private _cProduto   := space(15)
	Private _cPerg      := "ETQHLSREV2"
	Private cMark       := GetMark()
	Private cCadastro   := OemToAnsi("Etiquetas de Inspeção")
	Private aRotina     := {	{ "Classificar", 		bPesqBrw, 0, 4}, ;
								{ "Marcar/Desmarcar", 	bMarkRes, 0, 0}, ;
								{ "Imprimir", 			bImpEtq,  0, 0}}
	Private cQrCode 	:= ""

	ValidPerg()

	If Pergunte(_cPerg, .T.)

		cQuery := "SELECT DISTINCT ""
		cQuery += "		C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN, C6_NOTA, C6_SERIE, C6_DATFAT, C6_ENTREG, C6_LOTEHAB, C6_ENDLINH, C6_ENDEST,C6_SEPEN, "
		cQuery += "		B1_TIPO, B1_DESC, B1_UM, B1_CODMATR, B1_DESCNF, B1_CODMODE, B1_REVISAO,B1_QE, "
		cQuery += "		D2_CLIENTE, D2_EMISSAO, "
		cQuery += "		A1_NREDUZ "
		cQuery += "FROM "+ RETSQLNAME('SD2') +" SD2 "
		cQuery += " 	INNER JOIN "+ RETSQLNAME('SB1') +" SB1 "
		cQuery += "			ON	SB1.B1_FILIAL = '"+ XFILIAL("SB1")+"' AND "
		cQuery += "    			SB1.B1_COD = SD2.D2_COD AND "
		cQuery += " 			SB1.D_E_L_E_T_ = ' ' "
		cQuery += " 	INNER JOIN "+ RETSQLNAME('SA1') +" SA1 "
		cQuery += "    		ON	SA1.A1_FILIAL ='"+ XFILIAL("SA1") +"' AND "
		cQuery += "				SA1.A1_COD = SD2.D2_CLIENTE AND "
		cQuery += "    			SA1.A1_LOJA = SD2.D2_LOJA AND "
		cQuery += " 		 	SA1.D_E_L_E_T_ = ' ' "
		cQuery += " 	INNER JOIN "+ RETSQLNAME('SC6') +" SC6 "
		cQuery += " 		ON	SC6.C6_FILIAL = '"+ XFILIAL("SC6") +"' AND "
		cQuery += "    			SC6.C6_NUM = SD2.D2_PEDIDO AND "
		cQuery += "    			SC6.C6_ITEM = SD2.D2_ITEMPV AND "
		cQuery += "    			SC6.C6_PRODUTO = SD2.D2_COD AND "
		cQuery += " 		 	SC6.D_E_L_E_T_ = ' ' "
		cQuery += "WHERE "
		cQuery += "		SD2.D2_FILIAL   = '01' AND "
		cQuery += "    	SD2.D2_DOC     	BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' AND "
		cQuery += "     SD2.D2_SERIE	BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' AND "
		cQuery += "     SD2.D2_COD     	BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' AND "
		cQuery += "     SD2.D2_EMISSAO 	BETWEEN '"+ DTOS(MV_PAR07) +"' AND '"+ DTOS(MV_PAR08) +"' AND "
		cQuery += "     (SD2.D2_LOTECTL = '' OR  SD2.D2_LOTECTL LIKE 'AUTO%' ) AND "
		cQuery += "     SD2.D2_TP IN ('PA','RV') AND "
		cQuery += "     SD2.D_E_L_E_T_  = ' ' "

		// cQuery+=" ORDER BY D2_COD "

		If Select("TMP") > 0

			DbSelectArea("TMP")
			DbCloseArea()

		Endif

		TCQUERY cQuery NEW ALIAS "TMP"

		//cTexto := "ETQHLS - Mensagem de Validação - Lote HLS "	+ CRLF
		//cTexto += "===============================================================================================                "	+ CRLF

		DbselectArea("TMP")
		DbGotop()

		XLOTE := ""

		If !Eof()
			XLOTE := U_PesqLote()
		Endif

		/*
		 While !Eof()

			//cTexto += "Nota    Pedido  Produto            Quantidade    Disponível         Falta   NF.Original   Série Original   Item Original"	+ CRLF
			//cTexto += "---------------------------------------------------------------------------------------------------------------"	+ CRLF
			//cTexto += "Nota: " + TMP->D2_DOC + " Emissao: " + TMP->D2_EMISSAO + " Pedido:" + TMP->D2_PEDIDO +  " Produto:" + TMP->D2_COD + " Quantidade:" + TMP->D2_QUANT  + " Lote_Erro:" + TMP->D2_LOTECTL + " " + CRLF
			//cNomArqLog	:= "\ETQHLS_" + DToS(Date()) + "_" +  StrTran(Time(), ":", "") + ".Log"
			//MemoWrite(cNomArqLog, cTexto)

			TMP->R_E_C_N_O_

			 Dbskip()

		 Enddo

		 If !Empty(Alltrim(cTexto))
		  Alert(cTexto)
		 Endif

		 DbSelectArea("TMP")
		DbcloseArea()
		*/

		If XLOTE <> ""

			cQuery := "UPDATE "+ RetSqlName("SD2") +" "
			cQuery += "SET "
			cQuery += "		D2_LOTECTL = '" + Alltrim(XLOTE) + "'
			cQuery += "WHERE "
			cQuery += "		D2_FILIAL ='01' AND "
			cQuery += "     D2_DOC     BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' AND "
			cQuery += "     D2_SERIE   BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' AND "
			cQuery += "     D2_COD     BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' AND "
			cQuery += "     D2_EMISSAO BETWEEN '"+ DTOS(MV_PAR07) +"' AND '"+ DTOS(MV_PAR08) +"' AND "
			cQuery += "     D2_TP IN ('PA','RV') AND "
			cQuery += "     (D2_LOTECTL = '' OR  D2_LOTECTL LIKE 'AUTO%' ) AND "
			cQuery += "		D_E_L_E_T_ = ' ' "

			TCSQLEXEC(cQuery)

		Endif

		//  Arquivo Temporario
		aCampos := {}

		aAdd(aCampos, {"D2OK",		"C", 02, 0})
		aAdd(aCampos, {"D2CLIENTE",	"C", 20, 0})
		aAdd(aCampos, {"D2DTEMISS",	"D", 10, 0})
		aAdd(aCampos, {"C6ENTREGA",	"D", 10, 0})     //campo adicionado na etiqueta para troca da data de emissão por data de entrega
		aAdd(aCampos, {"D2LOTEHAB",	"C", 15, 0})     //alteração solicitada por Rodrigo Cézar em 10/08/2020 -- aletardo por Luciano Lamberti
		aAdd(aCampos, {"D2NOTA",	"C", 06, 0})
		aAdd(aCampos, {"D2SERIE",	"C", 03, 0})
		aAdd(aCampos, {"D2ITEM",	"C", 02, 0})
		aAdd(aCampos, {"D2DTLTHLS",	"D", 08, 0})
		aAdd(aCampos, {"D2LOTEHLS",	"C", 10, 0})
		aAdd(aCampos, {"D2QUANT",	"N", 14, 2})
		aAdd(aCampos, {"D2UM",		"C", 02, 0})
		aAdd(aCampos, {"D2REVISAO",	"C", 10, 0})
		aAdd(aCampos, {"D2CODHAB",	"C", 30, 0})
		aAdd(aCampos, {"D2DESCNF",	"C", 40, 0})
		aAdd(aCampos, {"D2MODELO",	"C", 20, 0})
		aAdd(aCampos, {"D2ENDLIN",	"C", 20, 0})
		aAdd(aCampos, {"D2ENDEST",	"C", 20, 0})
		aAdd(aCampos, {"B1QE",		"N", 14, 2})
		aAdd(aCampos, {"D2XXX",		"C", 03, 0})

		Private cArqTMP := "" // CriaTrab(aCampos,.t.)

		// dbUseArea(.T.,,cArqTMP,"ZD2",.T.)
		// DbSelectArea("ZD2")

		// Instancio o objeto
		oTable  := FwTemporaryTable():New( "ZD2" )
		// Adiciono os campos na tabela
		oTable:SetFields( aCampos )
		aEval(aIndex,{|x,y| oTable:addIndex(cValtochar(y),x) })
		// Crio a tabela no banco de dados
		oTable:Create()
		//------------------------------------
		//Pego o alias da tabela temporária
		//------------------------------------
		cArqTMP := oTable:GetAlias()

		_lTop:=.F.

		Private cAlias  := ''

		#IFDEF TOP
			_lTop:=.T.
			cAlias := "XMP"
		#ENDIF

		If _lTop

			cQuery := "SELECT DISTINCT "
			cQuery += "		C6_NUM, C6_PRODUTO, C6_ITEM, C6_QTDVEN, C6_NOTA, C6_SERIE, C6_DATFAT, C6_ENTREG, C6_LOTEHAB, C6_ENDLINH, C6_ENDEST, C6_SEPEN, "
			cQuery += "		B1_TIPO, B1_DESC, B1_UM, B1_CODMATR, B1_DESCNF, B1_CODMODE, B1_REVISAO, B1_QE, "
			cQuery += "		D2_CLIENTE, D2_EMISSAO, "
			cQuery += "		A1_NREDUZ "
			cQuery += "FROM "+ RETSQLNAME('SD2') +" SD2 "
			cQuery += " 	INNER JOIN "+ RETSQLNAME('SB1') +" SB1 "
			cQuery += "			ON	SB1.B1_FILIAL = '"+ XFILIAL("SB1")+"' AND "
			cQuery += "    			SB1.B1_COD = SD2.D2_COD AND "
			cQuery += " 			SB1.D_E_L_E_T_ = ' ' "
			cQuery += " 	INNER JOIN "+ RETSQLNAME('SA1') +" SA1 "
			cQuery += "    		ON	SA1.A1_FILIAL ='"+ XFILIAL("SA1") +"' AND "
			cQuery += "				SA1.A1_COD = SD2.D2_CLIENTE AND "
			cQuery += "    			SA1.A1_LOJA = SD2.D2_LOJA AND "
			cQuery += " 		 	SA1.D_E_L_E_T_ = ' ' "
			cQuery += " 	INNER JOIN "+ RETSQLNAME('SC6') +" SC6 "
			cQuery += " 		ON	SC6.C6_FILIAL = '"+ XFILIAL("SC6") +"' AND "
			cQuery += "    			SC6.C6_NUM = SD2.D2_PEDIDO AND "
			cQuery += "    			SC6.C6_ITEM = SD2.D2_ITEMPV AND "
			cQuery += "    			SC6.C6_PRODUTO = SD2.D2_COD AND "
			cQuery += " 		 	SC6.D_E_L_E_T_ = ' ' "
			cQuery += "WHERE "
			cQuery += "		SD2.D2_FILIAL  = '01' AND "
			cQuery += "     SD2.D2_DOC     BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' AND "
			cQuery += "     SD2.D2_SERIE   BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' AND "
			cQuery += "     SD2.D2_COD     BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' AND "
			cQuery += "     SD2.D2_EMISSAO BETWEEN '"+ DTOS(MV_PAR07)+"' AND '"+ DTOS(MV_PAR08) +"' AND "
			cQuery += "     SD2.D_E_L_E_T_ = ' ' "
			// cQuery+=" ORDER BY D2_COD "

			If Select("XMP") > 0

				DbSelectArea("XMP")
				DbCloseArea()

			Endif

			TCQUERY cQuery NEW ALIAS "XMP"

			TCSetFIELD("XMP","D2_DTVALID","D")
			TCSetFIELD("XMP","D2_EMISSAO","D")
			TCSetFIELD("XMP","C6_ENTREG","D")

			// Grava Arquivo Temporario
			dbSelectArea("XMP")
			dbGotop()

			While !EOF()

				dbSelectArea("ZD2")

				RecLock("ZD2",.T.)
				Field->D2OK        := "  "
				Field->D2CLIENTE   := XMP->A1_NREDUZ
				Field->D2DTEMISS   := XMP->D2_EMISSAO
				Field->C6ENTREGA   := XMP->C6_ENTREG             // Luciano Lamberti 10/08/2020
				Field->D2LOTEHAB   := XMP->C6_LOTEHAB
				Field->D2NOTA      := SubStr(XMP->C6_NOTA, 1, 6)
				Field->D2SERIE     := XMP->C6_SERIE
				Field->D2ITEM      := XMP->C6_ITEM
				Field->D2DTLTHLS   := XMP->D2_EMISSAO+365
				Field->D2LOTEHLS   := XMP->C6_DATFAT+"01"
				Field->D2QUANT     := XMP->C6_QTDVEN
				Field->D2UM        := XMP->B1_UM
				Field->D2REVISAO   := XMP->C6_SEPEN
				Field->D2CODHAB    := XMP->B1_CODMATR
				Field->D2DESCNF    := XMP->B1_DESC
				Field->D2MODELO    := XMP->B1_CODMODE
				Field->D2ENDLIN    := XMP->C6_ENDLINH
				Field->D2ENDEST    := XMP->C6_ENDEST
				Field->B1QE        := XMP->B1_QE
				Field->D2XXX       := "..."
				MsUnLock("ZD2")

				dbSelectArea("XMP")

				dbskip()

			EndDo

		EndIf

		DbSelectArea("ZD2")
		/* DbCloseArea()

		dbUseArea(.T.,,"\SYSTEM\"+cArqTMP,"ZD2",.T.)

		Private cIndZD2  := CriaTrab(Nil,.F.)
		Private cIndZD21 := CriaTrab(Nil,.F.)
		Private cIndZD22 := CriaTrab(Nil,.F.)
		Private cIndZD23 := CriaTrab(Nil,.F.)

		IndRegua("ZD2", cIndZD2,  "D2CODHAB",,,  OemToAnsi("Criando Indice...") )
		IndRegua("ZD2", cIndZD21, "D2NOTA",,,    OemToAnsi("Criando Indice)...") )
		IndRegua("ZD2", cIndZD22, "D2CLIENTE",,, OemToAnsi("Criando Indice)...") )
		IndRegua("ZD2", cIndZD23, "C6ENTREGA",,, OemToAnsi("Criando Indice)...") )  // Luciano Lamberti 10/08/2020 */

		aIndNome:={}

		aAdd(aIndNome, {1, "Cod. HAB"})
		aAdd(aIndNome, {2, "Nota"})
		aAdd(aIndNome, {3, "Cliente"})
		aAdd(aIndNome, {4, "Dt.Emissao"})

		/* dbClearIndex()

		dbSetIndex(cIndZD2+OrdBagExt())
		dbSetIndex(cIndZD21+OrdBagExt())
		dbSetIndex(cIndZD22+OrdBagExt())
		dbSetIndex(cIndZD23+OrdBagExt()) */

		DbSetOrder(1)

		DbGoTop()

		aTela := {}

		aAdd(aTela, {"D2OK",		"", "OK"})
		aAdd(aTela, {"D2CODHAB",	"", "Cod. HAB"})
		aAdd(aTela, {"D2DESCNF",	"", "Descr. NF"})
		aAdd(aTela, {"D2DTEMISS",	"", "Emissão"})
		aAdd(aTela, {"D2LOTEHAB",	"", "Lote HAB"})
		aAdd(aTela, {"D2NOTA",		"", "Nota Fiscal"})
		aAdd(aTela, {"D2SERIE",		"", "Serie"})
		aAdd(aTela, {"D2ITEM",		"", "Item"})
		aAdd(aTela, {"D2DTLTHLS",	"", "Data Lote HLS"})
		aAdd(aTela, {"D2LOTEHLS",	"", "Lote HLS"})
		aAdd(aTela, {"D2QUANT",		"", "Quantidade"})
		aAdd(aTela, {"D2UM",		"", "UM"})
		aAdd(aTela, {"D2REVISAO",	"", "Revisão"})
		aAdd(aTela, {"D2MODELO",	"", "Modelo"})
		aAdd(aTela, {"D2ENDLIN",	"", "End. Linha"})
		aAdd(aTela, {"D2ENDEST",	"", "End. Estoque"})
		aAdd(aTela, {"D2CLIENTE",	"", "Cliente"})
		aAdd(aTela, {"B1QE",		"", "Embalagem"})
		aAdd(aTela, {"D2XXX",		"", "OK"})

		// Monta o Browse do Arquivo temporario somente para os campos informados na Matriz
		DbSelectArea("ZD2")

		DbGotop()

		MarkBrowse("ZD2", "D2OK",, aTela,, @cMark)

		/* DbSelectArea("ZD2")

		DbCloseArea()

		Ferase(cIndZD2+OrdBagExt())
		Ferase(cIndZD21+OrdBagExt())
		Ferase(cIndZD22+OrdBagExt())
		Ferase(cIndZD23+OrdBagExt()) */
		oTable:delete()

	EndIf

Return .T.

/*
	Cria o dicionario de perguntas
*/

Static Function ValidPerg()

	Local _sAlias 	:= Alias()
	Local aRegs 	:= {}
	Local i,j

	dbSelectArea("SX1")
	dbSetorder(1)
	aAdd(aRegs,{_cPerg,"01","Nota Fiscal  De  ?","","","mv_ch1" ,"C",09,0,0,"G","","MV_PAR01",""   ,"","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","",""})
	aAdd(aRegs,{_cPerg,"02","Nota Fiscal Ate  ?","","","mv_ch2" ,"C",09,0,0,"G","","MV_PAR02",""   ,"","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","",""})

	aAdd(aRegs,{_cPerg,"03","Serie  De  ?","","","mv_ch3" ,"C",03,0,0,"G","","MV_PAR03",""   ,"","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","",""})
	aAdd(aRegs,{_cPerg,"04","Serie Ate  ?","","","mv_ch4" ,"C",03,0,0,"G","","MV_PAR04",""   ,"","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","",""})

	aAdd(aRegs,{_cPerg,"05","Produto      De  ?","","","mv_ch5" ,"C",15,0,0,"G","","MV_PAR05",""   ,"","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","SB1",""})
	aAdd(aRegs,{_cPerg,"06","Produto     Ate  ?","","","mv_ch6" ,"C",15,0,0,"G","","MV_PAR06",""   ,"","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","SB1",""})
	aAdd(aRegs,{_cPerg,"07","DT. Emissão  De  ?","","","mv_ch7" ,"D",08,0,0,"G","","MV_PAR07",""   ,"","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","",""})
	aAdd(aRegs,{_cPerg,"08","DT. Emissão Ate  ?","","","mv_ch8" ,"D",08,0,0,"G","","MV_PAR08",""   ,"","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","",""})

	For i:=1 to Len(aRegs)

		If !dbSeek(_cPerg+aRegs[i,2])

			RecLock("SX1",.T.)

			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next

			SX1->( MsUnlock() )

		EndIf

	Next

	dbSelectArea(_sAlias)

Return Nil

/*
	Utilizado no markbrow do programa ETQHLS
*/
Static Function tMarkRES()

	Local cTexto := ""

	DbSelectArea("ZD2")

	DbGoTop()

	cTexto := AllTrim(cMark)

	IF AllTrim(ZD2->D2OK) == AllTrim(cMark)
		cTexto := "  "
	Endif

	While ZD2->(!Eof())

		Reclock("ZD2")
		Field->D2OK := cTexto
		MsUnlock()

		ZD2->(DbSkip())

	Enddo

	ZD2->(DbGoTop())

Return Nil

/*
	Executa a pesquisa dentro de um arquivo temporario
*/
//Static Function tPesqBrow(Titulo, ArqTmp, nOrdem, aIndNome)
User Function tPesqBrow(Titulo, ArqTmp, nOrdem, aIndNome)

	Local n 	 := 0
	Local nIndex := 0
	Local cCombo := Titulo
	Local aItems := {}

	For n := 1 To nOrdem

		DbSelectArea(ArqTmp)

		DbSetOrder(n)

		nPos := Ascan(aIndNome,{|x|x[1]==n})

		aAdd(aItems, Alltrim(Str(n)) +" "+ aIndNome[n, 2])

	Next n

	cPesPed := Space(75)

	@ 225,247 To 330,420 Dialog oDlgPesq Title OemToAnsi("Pesquisar")
	@ 02,07 Say "Opcao de pesquisa:" SIZE	 100,100
	@ 10,07 COMBOBOX cCombo ITEMS aItems SIZE 075,050
	@ 21,07 Say "Digite                 " size 100,100
	@ 29,07 Get cPesPed Size 075,050
	@ 40,30 BmpButton Type 1 Action Close(oDlgPesq)
	Activate Dialog oDlgPesq Centered

	DbSelectArea(ArqTmp)     // utilizando indice temporario

	For nIndex := 1 To nOrdem

		If Substr(cCombo, 1, 1) == Alltrim(Str(nIndex))

			DbSetOrder(nIndex)

			Exit

		Endif

	Next nIndex

	DbSeek(alltrim(cPesPed), .T.)

	SysRefresh()

Return Nil

/*
	Executa Impressao de Etiquetas
*/

Static Function tGeraETQ()

	Local nSeqEtq	:= 1								// incluido por Deivid Lima - 27/01/09
	Local cProdNF   := ""								// incluido por Deivid Lima - 27/01/09
	Local cNumNF    := ""								// incluido por Deivid Lima - 27/01/09
	Local I 		:= 0
	Local cQuant	:= 0
	Local nInteiro	:= 0
	Local nResto	:= 0
	Local nInt		:= 0

	Private cStartPath 	:= GetSrvProfString("Startpath","")
	Private aBitmap	 	:= cStartPath+"/LGHONDA.BMP"
	Private nPag     	:= 0		// Contador de Paginas
	Private nLin     	:= 0		// Contador de Linhas
	Private lImp     	:= .F.		// Indica se algo foi impresso
	//Private oPrint	 	:= 	():New("ETQHABNEW")       //ADD LUCIANO LAMBERTI		09/08/21
	Private nAltura  	:= 0
	Private nTotal   	:= 0
	Private nPerRet  	:= 0

	Private oPrinter:= FWMSPrinter():New("ETIQUETAS HONDA AUTOMOVEIS")

	oPrinter:SetPortrait()      // fixa impressao em Retrato
	//oPrinter:Setup()
	oPrinter:SetPaperSize(0, 150, 107)
	//oPrinter:SetMargin(001,001,001,001)
	//oPrinter:SetViewPDF(.T.)

	dbSelectArea("ZD2")

	dbGotop()

	While !EOF()

		If (ZD2->(IsMark("D2OK",ThisMark(),ThisInv())))

			// Imprime Etiquetas dos Itens Marcados
			If cProdNF <> ZD2->D2CODHAB .Or. cNumNF <> ZD2->D2NOTA		// incluido por Deivid Lima - 27/01/09

				cProdNF := ZD2->D2CODHAB								// incluido por Deivid Lima - 27/01/09
				cNumNF  := ZD2->D2NOTA									// incluido por Deivid Lima - 27/01/09
				nSeqEtq := 1											// incluido por Deivid Lima - 27/01/09

			Endif

			cQuant := PadL(AllTrim(Str(Round(ZD2->D2QUANT / ZD2->B1QE, 2))), 13, '0')

			If SubStr(cQuant, 11, 1) # "." .And. SubStr(cQuant, 12, 1) # "."
				cQuant :=PadL(AllTrim(Str(Round(ZD2->D2QUANT / ZD2->B1QE, 2))), 10, '0') +".00"
			ElseIf SubStr(cQuant,12,1) == "."
				cQuant :=PadL(AllTrim(Str(Round(ZD2->D2QUANT / ZD2->B1QE, 2))), 12, '0') +"0"
			EndIf

			nInteiro := Val(SubStr(cQuant, 1, 10))
			nResto   := ZD2->D2QUANT - (nInteiro * ZD2->B1QE)

			If nResto > 0
				nInt := nInteiro + 1
			Else
				nInt := nInteiro
			EndIf

			For I := 1 to nInteiro

				ImpEtq(ZD2->B1QE, nSeqEtq)								// alterado por Deivid Lima - 27/01/09

				nSeqEtq++												// incluido por Deivid Lima - 27/01/09

			Next I

			If nResto > 0

				ImpEtq(nResto, nSeqEtq)									// alterado por Deivid Lima - 27/01/09

				nSeqEtq++												// incluido por Deivid Lima - 27/01/09

			EndIf

		EndIf

		DbSelectArea("ZD2")

		DbSkip()

	EndDo

	oPrinter:EndPage()

	oPrinter:Preview()  // Visualiza antes de imprimir

	//Atualiza o Browse Excluindo as Etiquetas Impressas
	DbSelectArea("ZD2")

	DbGotop()

	While !Eof()

		If (ZD2->(IsMark("D2OK", ThisMark(), ThisInv())))

			RecLock("ZD2")
			DbDelete()
			MsUnlock()

		EndIf

		DbSelectArea("ZD2")

		DbSkip()

	Enddo

Return Nil

/*
	Impressao de Etiquetas
*/

Static Function ImpEtq(nQtdEtq, nSeq)

	Local cLote 	:= ""
	Local oFont8	:= TFont():New("Arial",9,08,.T.,.F.,5,,,.T.,.F.)
	Local oFont9   	:= TFont():New("Arial",9,09,.T.,.F.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont9n  	:= TFont():New("Arial",9,09,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont10	:= TFont():New("Arial",9,10,.T.,.F.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont10n	:= TFont():New("Arial",9,10,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont11  	:= TFont():New("Arial",9,11,.T.,.F.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont11n 	:= TFont():New("Arial",9,11,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont12  	:= TFont():New("Arial",9,12,.T.,.F.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont12n 	:= TFont():New("Arial",9,12,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont13  	:= TFont():New("Arial",9,13,.T.,.F.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont13n 	:= TFont():New("Arial",9,13,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	//Local oFont14  	:= TFont():New("Arial",9,14,.T.,.F.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont14n 	:= TFont():New("Arial",9,14,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	Local oFont16n	:= TFont():New("Arial",9,16,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	//Local oFont17n 	:= TFont():New("Arial",9,17,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	//Local oFont18n 	:= TFont():New("Arial",9,18,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	//Local oFont24n 	:= TFont():New("Arial",9,24,.T.,.T.,5,,,.T.,.F.,,,,,,oPrinter)
	//Local aCoords 	:= {2000,1900,1340,3280}
	//Local oBrush	:= TBrush():New("",4)
	//Local cCGCPict, cCepPict
	//Local _nItm
	//Local _ContaETQ:=0

	cQrCode := "Q"

	oPrinter:StartPage()

	_LI := 20
	//_CO   :=25
	_CO := 30 // ALTERADO LUCIANO LAMBERTI - 10-03-2020

	//Primeiro quadro - CLIENTE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//Ricardo - Alterado em: 17/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrinter:Say(_LI+3,_CO,OemToAnsi("Cliente"+space(30)+"Data Exp"+space(25)+"Lote Produção Honda"),oFont10)
	oPrinter:Say(_LI + 3, _CO + 001, OemToAnsi("Cliente"), 			 	oFont10n)
	oPrinter:Say(_LI + 3, _CO + 165, OemToAnsi("Data Exp"), 			oFont10n)
	oPrinter:Say(_LI + 3, _CO + 315, OemToAnsi("Lote Produção Honda"), 	oFont10n)

	//_LI += (40 * 0.25)

	//Ricardo - Alterado em: 17/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrinter:Say(_LI,_CO,space(50)+OemToAnsi(Substr(ZD2->D2LOTEHAB,1,15)),oFont13n)
	oPrinter:Say(_LI + 33, _CO + 295, OemToAnsi(Substr(ZD2->D2LOTEHAB, 1, 15)), oFont13n)

	//_LI += (25 * 0.25)

	oPrinter:Say(_LI + 48, _CO + 030, OemToAnsi("HONDA"),oFont16n)
	//oPrinter:Say(_LI+20,_CO,space(22)+StrZero(Day(ZD2->D2DTEMISS),2) +"/"+ StrZero(Month(ZD2->D2DTEMISS),2) +"/"+ Right(Str(Year(ZD2->D2DTEMISS)),4),oFont13n)
	oPrinter:Say(_LI + 57, _CO + 140, DToC(ZD2->C6ENTREGA), oFont13n) //Luciano 10/08/2020 StrZero(Day(ZD2->C6ENTREGA),2) +"/"+ StrZero(Month(ZD2->C6ENTREGA),2) +"/"+ Right(Str(Year(ZD2->C6ENTREGA)),4)

	//_LI += (60 * 0.25)

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrinter:Say(_LI,_CO,space(1)+OemToAnsi("Automóveis"),oFont12n)
	oPrinter:Say(_LI + 72, _CO + 20, OemToAnsi("Automóveis"), oFont14n)

	cTexto := Alltrim("L"+ AllTrim(ZD2->D2LOTEHAB))

	cQrCode += cTexto +";"

	//Ricardo - Alterado em: 24/02/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrinter:MSBAR("CODE128",1.0,5.1,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	//MSBAR("CODE128",1.0,5.1,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	//oPrinter:FWMSBAR("CODE128", 1.0, 5.1, cTexto, oPrinter, .F., Nil, Nil, 0.027, 1.2, Nil, Nil, "A", .F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	//oPrinter:FWMSBAR("CODE128", 1, 5, cTexto, oPrinter, .F., Nil, Nil, 0.027, 1.2, Nil, Nil, "A", .F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	oPrinter:Code128(_LI + 39, _CO + 260, cTexto, 1, 30, .F.,, 150)

	//_LI += (120 * 0.25)

	oPrinter:Line(_LI + 110, _CO, _LI + 110, _CO + 600)//Linha Horizontal
	oPrinter:Line(_LI, _CO + 135, _LI + 110, _CO + 135)  //Primeira Linha Vertical
	//oPrinter:Line(30,640,295,640)  //Segunda Linha Vertical

	//Segundo quadro - NOTA FISCAL ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	oPrinter:Say(_LI + 125, _CO, OemToAnsi("No.Doc. Fiscal (No. + Série + Sequência)"), oFont10)

	//_LI+=40

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrinter:Say(_LI,_CO,OemToAnsi(ZD2->D2NOTA+space(01)+SubStr(ZD2->D2SERIE,1,2)+space(01)+STRZERO((_nSeq),3)),oFont14n)
	oPrinter:Say(_LI + 148, _CO + 3, OemToAnsi(ZD2->D2NOTA +" "+ SubStr(ZD2->D2SERIE, 1, 2) +" "+ STRZERO(nSeq, 3)), oFont14n)

	cTexto := Alltrim("N"+ ZD2->D2NOTA + SubStr(ZD2->D2SERIE, 1, 2) + STRZERO(nSeq, 3))

	cQrCode += Alltrim("N"+ StrZero(Val(ZD2->D2NOTA),9) +" "+ SubStr(ZD2->D2SERIE, 1, 2) + STRZERO(nSeq, 3)) +";"

	//MSBAR("CODE128",3.9,8.3,cTexto,oPrinter,.F.,NIL,NIL,0.043,1.6,NIL,NIL,"A",.F.)
	//oPrinter:MSBAR("CODE128",2.5,5.5,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	//MSBAR("CODE128",2.5,5.5,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	//oPrinter:FWMSBAR("CODE128",2.5,5.5,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21

	oPrinter:Code128(_LI + 124, _CO + 280, cTexto, 1, 30, .F.,, 140)

	//_LI+=120

	oPrinter:Line(_LI + 190, _CO, _LI + 190, _CO + 600)//Linha Horizontal

	//Terceiro quadro - FORNECEDOR / LOTE ////////////////////////////////////////////////////////////////////////////////////////////////////////
	//oPrinter:Say(_LI,_CO,OemToAnsi("Fornecedor"+space(20)+"Lote Fabricação"+space(10)+"Quantidade"+space(20)+"Unid."),oFont10)
	oPrinter:Say(_LI + 210, _CO + 003, OemToAnsi("Fornecedor"),		 oFont11)
	oPrinter:Say(_LI + 210, _CO + 175, OemToAnsi("Lote Fabricação"), oFont11)
	oPrinter:Say(_LI + 210, _CO + 300, OemToAnsi("Quantidade"),		 oFont11)
	oPrinter:Say(_LI + 210, _CO + 425, OemToAnsi("Unid."),			 oFont11)

	//_LI+=40

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	If !Empty(ZD2->D2LOTEHLS)
		cLote := ZD2->D2LOTEHLS
		//oPrinter:Say(_LI,_CO,OemToAnsi("HONDA LOCK"+space(06)+ZD2->D2LOTEHLS+space(6)+AllTrim(Str(_nQtdEtq))+space(14)+ZD2->D2UM),oFont12n)
		//oPrinter:Say(_LI,_CO+2,OemToAnsi("HONDA LOCK"+space(06)+ZD2->D2LOTEHLS+space(6)+AllTrim(Str(nQtdEtq))+space(14)+ZD2->D2UM),oFont12n)


	Else
		cLote := Space(10)
		//oPrinter:Say(_LI,_CO,OemToAnsi("HONDA LOCK"+space(06)+space(10)+space(6)+AllTrim(Str(_nQtdEtq))+space(14)+ZD2->D2UM),oFont12n)
		//oPrinter:Say(_LI,_CO+2,OemToAnsi("HONDA LOCK"+space(06)+space(10)+space(6)+AllTrim(Str(nQtdEtq))+space(14)+ZD2->D2UM),oFont12n)


	EndIf

	oPrinter:Say(_LI + 230, _CO + 003, OemToAnsi("MINEBEA-AS SP"),		 		oFont13n)
	oPrinter:Say(_LI + 230, _CO + 175, OemToAnsi(cLote), 					oFont13n)
	oPrinter:Say(_LI + 230, _CO + 300, OemToAnsi(AllTrim(Str(nQtdEtq))),	oFont13n)
	oPrinter:Say(_LI + 230, _CO + 425, OemToAnsi(ZD2->D2UM),			 	oFont13n)

	cTexto := Alltrim("X"+"6380987"+ ZD2->D2LOTEHLS + PadL(AllTrim(Str(nQtdEtq)), 5, '0') + ZD2->D2UM)
	cDtTemp := SubStr(ZD2->D2LOTEHLS,7,2)+"/"+SubStr(ZD2->D2LOTEHLS,5,2)+"/"+SubStr(ZD2->D2LOTEHLS,1,4) //AAAAMMDD
	//cQrCode += Alltrim("X"+"6380987"+ ZD2->D2LOTEHLS + PadL(AllTrim(Str(nQtdEtq)), 10, '0') + ZD2->D2UM) +";"
	cQrCode += Alltrim("X"+"6380987"+ cDtTemp + PadL(AllTrim(Str(nQtdEtq)), 10, '0') + ZD2->D2UM) +";"

	//oPrinter:MSBAR("CODE128",4.6,0.9,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrinter para barcode - 09-08-21
	//MSBAR("CODE128",4.6,0.9,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrinter para barcode - 09-08-21
	//oPrinter:FWMSBAR("CODE128",4.6,0.9,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrinter para barcode - 09-08-21
	oPrinter:Code128(_LI + 245, _CO + 40, cTexto, 1, 30, .F.,, 250)

	//_LI += 200

	oPrinter:Line(_LI + 310, _CO, _LI + 310, _CO + 600)//Linha Horizontal

	//Quarto quadro - SEPPEN /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	oPrinter:Say(_LI + 330, _CO, OemToAnsi("Código SEPPEN"), oFont11)

	//_LI+=40

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrinter:Say(_LI,_CO,OemToAnsi(ZD2->D2REVISAO),oFont12n)
	oPrinter:Say(_LI + 350, _CO + 2, OemToAnsi(ZD2->D2REVISAO), oFont13n)

	cTexto := Alltrim("S"+ AllTrim(ZD2->D2REVISAO))

	cQrCode += cTexto +";"

	//oPrinter:MSBAR("CODE128",6.1,3.0,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrinter para barcode - 09-08-21
	//MSBAR("CODE128",6.1,3.0,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrinter para barcode - 09-08-21
	//oPrinter:FWMSBAR("CODE128",6.1,3.0,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)				//ADD LUCIANO oPrinter para barcode - 09-08-21
	oPrinter:Code128(_LI + 315, _CO + 150, cTexto, 1, 30, .F.,, 100)

	//_LI+=120

	oPrinter:Line(_LI + 380, _CO, _LI + 380, _CO + 600)//Linha Horizontal
	oPrinter:Line(_LI + 310, _CO + 400, _LI + 380, _CO + 400)  //Primeira Linha Vertical

	//Quinto quadro - PECA HAB ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	oPrinter:Say(_LI + 400, _CO, OemToAnsi("Código da Peça (Honda)"), oFont11)

	//_LI+=40

	//_cCodHAB:=""

	//Ricardo - Alterado em: 05/03/14 - Conforme Solicitação do Sr. Rodrigo/PCP-New Model
	//oPrinter:Say(_LI,_CO,OemToAnsi(ZD2->D2CODHAB),oFont13n)
	oPrinter:Say(_LI + 420, _CO + 2, OemToAnsi(ZD2->D2CODHAB), oFont13n)

	cTexto := Alltrim("P"+ AllTrim(ZD2->D2CODHAB))
	cQrCode += cTexto

	//oPrinter:MSBAR( "CODE128",8.3,0.9,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	//oPrinter:FWMSBAR( "CODE128",8.3,0.9,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	//oPrinter:FWMSBAR( "CODE128",_LI - 500, _CO + 200,cTexto,oPrinter,.F.,NIL,NIL,0.027,1.2,NIL,NIL,"A",.F.)			//ADD LUCIANO oPrinter para barcode - 09-08-21
	//oPrinter:Code128(_LI + 427, _CO + 50, cTexto, 1, 30, .F.,, 150) - ajustado LL 13-09-2021
	oPrinter:Code128(_LI + 427, _CO + 150, cTexto, 1, 30, .F.,, 200) // ajustado luciano para o cod de barras cliente 13-09-2021

	//_LI+=200

	oPrinter:Line(_LI + 493, _CO, _LI + 493, _CO + 600)//Linha Horizontal

	//Sexto quadro - DESCRIÇÃO PECA //////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=50

	oPrinter:Say(_LI + 510, _CO, OemToAnsi("Peça Descrição"), oFont11)

	//_LI+=40

	oPrinter:Say(_LI + 530, _CO, OemToAnsi(ZD2->D2DESCNF), oFont13n)

	//_LI+=120

	oPrinter:Line(_LI + 570, _CO, _LI + 570, _CO + 600) //Linha Horizontal

	//Setimo quadro - MODELO /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	oPrinter:Say(_LI + 590, _CO, OemToAnsi("Modelo Tipo Aplicação"),oFont11)

	//_LI+=40

	oPrinter:Say(_LI + 610, _CO , OemToAnsi(ZD2->D2MODELO), oFont13n)

	//_LI+=120

	//oPrinter:Line(_LI,_CO,_LI,1350)//Linha Horizontal

	//Oitavo quadro///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//_LI+=20

	//nLinAtu += 100
	//nPosVert +=500

	//oPrinter:Box(nLinAtu,nPosVert,nLinAtu+800,nPosVert+1080)



	//oPrinter:Say(_LI,_CO,OemToAnsi("Endereço na Linha"+space(50)+"Endereço de Estoque"),oFont9)
	//_LI+=40
	//oPrinter:Say(_LI,_CO,OemToAnsi(ZD2->D2ENDLIN+space(30)+ZD2->D2ENDEST),oFont12n)
	//_LI+=120

	//oPrinter:Line(_LI,_CO,_LI,1350)//Linha Horizontal
	oPrinter:Line(_LI + 570, _CO + 275, _LI + 800, _CO + 275)  //Primeira Linha Vertical

	//Imprime QRCODE
	oPrinter:QRCode(_LI + 750, _CO + 350, cQrCode, 80)

	//oPrinterer:QRCode(nLinAtu+010, nPosVert+500, MSBAR, 90)

	//Final da Impressão da Etiqueta//////////////////////////////////////////////////////////////////////////////////////////////////
	oPrinter:EndPage()

Return .T.

