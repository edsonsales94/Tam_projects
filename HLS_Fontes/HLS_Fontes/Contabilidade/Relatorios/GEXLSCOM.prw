#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
/*/{protheus.doc}GEXLSCOM
Gera planilha/relatorio conferencia de compra
@author Ricardo Borges
@since 21/01/2014
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GEXLSCOM      º Autor ³Ricardo Borges º Data ³   21/01/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Gera Planilha/Relatorio Conferência de Compras - CTB       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HONDA LOCK                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEXLSCOM()

	SetPrvt("cPerg,nOpc_,cCad_,aSay_,aButt_,aCampos,lAbortPrint,TipoAfas,aArea_")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cPerg       := "GEXLCO" // Nome do arquivo de perguntas do SX1
	cCad_		:= ""
	nOpc_		:= 0
	aSay_		:= {}
	aButt_		:= {}
	aCampos 	:= {}
	lAbortPrint := .F.
	TipoAfas    := ""
	aArea_      := GetArea()

	//Processamento
	cCad_		:= "** Gera Planilha/Relatorio Conferência de Compras - CTB **"

	aAdd( aSay_, "Este programa tem como objetivo gerar uma planilha em  " )
	aAdd( aSay_, "Excel, com informações para Conferência de Compras - CTB " )
	//aAdd( aSay_, "Versus as Notas de Devolução da Honda Lock-SP." )

	aAdd( aButt_, { 5,.T.,{|| Pergunte(cPerg,.T.)    }})
	aAdd( aButt_, { 1,.T.,{|| FechaBatch(),nOpc_ := 1 }})
	aAdd( aButt_, { 2,.T.,{|| FechaBatch()            }})

	//Verifica Perguntas
	Pergunte(cPerg,.F.)

	//Monta Tela Inicial
	FormBatch( cCad_, aSay_, aButt_ )

	If nOpc_ == 1
		Processa( {|| RunReport() }, "Processando..." )
	Endif

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunReport ³ Autor ³Isamu Kawakami/JCGouveia³Data ³ 15.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Geracao da Planilha                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem

	aCampos := {}

	AADD(aCampos,{"FILIAL"    ,  	"C", 002,0})

	AADD(aCampos,{"FORNECE"   ,  	"C", 006,0})

	AADD(aCampos,{"LOJA"      ,  	"C", 002,0})

	AADD(aCampos,{"DESCFOR"   ,   	"C", 003,0})

	AADD(aCampos,{"DTENTRADA" ,  	"C", 008,0})

	AADD(aCampos,{"LOCAL" 	  ,   	"C", 002,0})

	AADD(aCampos,{"ESTOQUESN"   ,  	"C", 001,0})

	AADD(aCampos,{"NFENTRA"   ,  	"C", 009,0})

	AADD(aCampos,{"CODPRODUTO",   	"C", 015,0})

	AADD(aCampos,{"DESCPROD",   	"C", 120,0})

	AADD(aCampos,{"DESCPRODPC",   	"C", 080,0})

	AADD(aCampos,{"VLINVOICE"   ,  	"N", 019,2})

	AADD(aCampos,{"DTDEVOL"	  ,   	"C", 008,0})
	AADD(aCampos,{"TESDEVOL"  ,   	"C", 003,0})

	AADD(aCampos,{"QTDEVOL"   ,  	"N", 017,0})
	AADD(aCampos,{"TOTDEVOL"  ,  	"N", 019,2})

	AADD(aCampos,{"CUSTOENTRA",   	"N", 017,2})

	AADD(aCampos,{"ITEM"      ,  	"C", 006,0})


	If Select("EXC") > 0
		DBSelectArea("EXC")
		DBCloseArea()
	Endif

	// cArqEXC := CriaTrab(aCampos,.t.)
	// dbUseArea(.T.,,cArqEXC,"EXC",.T.)

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "EXC" )
	// Adiciono os campos na tabela
	oTable:SetFields( aCampos )
	// Adiciono os índices da tabela
	// oTable:AddIndex( '01' , { cIndxKEY })
	// Crio a tabela no banco de dados
	oTable:Create()

	//------------------------------------
	//Pego o alias da tabela temporária
	//------------------------------------
	cArqEXC := oTable:GetAlias()

	_cFornec	:=	mv_par01
	_cLoja 		:=	mv_par02
	_DtIni		:=	mv_par03
	_DtFim		:=	mv_par04


	cQuery := " SELECT DISTINCT D1_FORNECE Codigo_Fornecedor, A2_NOME Descricao_Fornecedor,  "

	cQuery += " CONVERT(VARCHAR(12),(CAST(D1_DTDIGIT AS DATETIME)),103) Data_Entrada,  "

	cQuery += " C7_LOCAL Armazem, D1_TES Tes, F4_ESTOQUE Movimenta_Estoque, F1_DOC Nota_Fiscal,  "

	cQuery += " C7_ITEM Item_PC, D1_COD Produto, B1_DESC Descricao_Produto, C7_DESCRI Descricao_Produto_PC, "

	cQuery += " C7_TOTAL Valor_Invoice, D1_TOTAL Valor_Estoque, FT_TOTAL Total_NF, C7_OBS Observacao_PC,  "

	cQuery += " CASE WHEN C7_MOEDA = '1' THEN 'REAL' "
	cQuery += " WHEN C7_MOEDA = '2' THEN 'DOLAR' "
	cQuery += " WHEN C7_MOEDA = '3' THEN 'UFIR' "
	cQuery += " WHEN C7_MOEDA = '4' THEN 'EURO' "
	cQuery += " WHEN C7_MOEDA = '5' THEN 'YEN' "
	cQuery += " ELSE ''  "
	cQuery += " END AS Tipo_Taxa,  "

	cQuery += " C7_TXMOEDA Taxa_PC_DI, D1_DESPESA Despesas, D1_PEDIDO Pedido_Compra, D1_CF CFOP,  "

	cQuery += " X5_DESCRI Descricao_CFOP, D1_CONTA Conta_Contabil, C7_VLDESC Desconto_PC, C7_DESPESA Despesa_PC, "

	cQuery += " C7_SEGURO Seguro_PC, F1_NRDI DI, F1_SREF INVOICE, D1_LOJA  "

	cQuery += " FROM " + RetSqlName("SF1") + " SF1 "

	cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 "
	cQuery += " ON F1_DOC = D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA "

	cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += " ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "

	cQuery += " INNER JOIN " + RetSqlName("SC7") + " SC7 "
	cQuery += " ON C7_NUM = D1_PEDIDO AND C7_PRODUTO = D1_COD "

	cQuery += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
	cQuery += " ON D1_TES = F4_CODIGO "

	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += " ON D1_COD = B1_COD "

	cQuery += " INNER JOIN " + RetSqlName("SFT") + " SFT "
	cQuery += " ON FT_CLIEFOR = D1_FORNECE AND FT_LOJA = D1_LOJA AND FT_NFISCAL = D1_DOC AND FT_SERIE = D1_SERIE AND FT_PRODUTO = D1_COD "

	cQuery += " INNER JOIN " + RetSqlName("SX5") + " SX5 "
	cQuery += " ON X5_TABELA = '13' AND X5_CHAVE = D1_CF "

	cQuery += " WHERE SF1.F1_FILIAL = '" + xFilial("SF1") + "' AND "

	If !Empty(_cFornec)
		cQuery += " SD1.D1_FORNECE = '" + _cFornec + "' AND "
		cQuery += " SD1.D1_LOJA    = '" + _cLoja   + "' AND "
	Endif

	cQuery += " D1_DTDIGIT BETWEEN '"+DTOS(_DtIni)+"' AND '"+DTOS(_DtFim)+"' AND "  //--WHERE F1_EMISSAO BETWEEN '20140201' AND '20140228'

	cQuery += " X5_TABELA = '13' "

	cQuery += " AND SF1.D_E_L_E_T_ = '' "
	cQuery += " AND SD1.D_E_L_E_T_ = '' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' "
	cQuery += " AND SC7.D_E_L_E_T_ = '' "
	cQuery += " AND SB1.D_E_L_E_T_ = '' "
	cQuery += " AND SFT.D_E_L_E_T_ = '' "
	cQuery += " AND SF4.D_E_L_E_T_ = ''  "
	cQuery += " AND SX5.D_E_L_E_T_ = '' "

	cQuery += " ORDER BY 1,2,3,4,5,6,7,8 "

	TcQuery cQuery Alias TSD1 New

	DbSelectArea("TSD1")
	TSD1->(DbGoTop())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//SetRegua(RecCount())
	ProcRegua( TSD1-> ( RecCount() ) )

	//ApMsgAlert( strzero( TSD1->( RecCount() ), 9 ) )

	TSD1->(DbGoTop())

	While TSD1->(!Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//TESTAR
		//If lAbortPrint
		//Exit
		//Endif

		Reclock("EXC",.T.)

		EXC->Filial 	:= TSD1->FILIAL
		EXC->FORNECE 	:= TSD1->FORNECE
		EXC->LOJA		:= TSD1->LOJA

		MsUnlock()

		TSD1->(DbSkip())

		//Atualiza Regua
		IncProc("Gerando Planilha......")

	Enddo

	TSD1->(DbCloseArea())


	Processa({||_fOpenXLS01(cArqEXC)},"Abrindo Excel.....")

	dbclosearea("EXC")
	Ferase(cArqEXC + OrdBagExt())

	RestArea(aArea_)

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³_fOpenXLS01 ³ Autor ³ Ricardo Borges      ³ Data ³ 21.02.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Chamada da Planilha Excell                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _fOpenXLS01(cArqTRC)

	Local cDirDocs	:= MsDocPath()
	Local cPath		:= AllTrim(GetTempPath())

	//³Copia DBF para pasta TEMP do sistema operacional da estacao ³

	If FILE(cArqTRC+".DBF")
		COPY FILE (cArqTRC+".DBF") TO (cPath+cArqTRC+".DBF")
	EndIf

	If !ApOleClient("MsExcel")
		MsgStop("MsExcel nao instalado.")
		Return
	EndIf

	//³Cria link com o excel³
	oExcelApp := MsExcel():New()

	//³Abre uma planilha³
	oExcelApp:WorkBooks:Open(cPath+cArqTRC+".DBF")
	oExcelApp:SetVisible(.T.)

Return

//Fim da Rotina

//Fim do Programa
