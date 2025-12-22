#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
/*/{protheus.doc}GEXLSTRIA
Gera planilha de notas (Entrada-Honda)x(Devolução-HLS)
@author Ricardo Borges
@since 22/01/2014
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GEXLSTRIA    º Autor ³Ricardo Borges º Data ³   22/01/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Gera Planilha das Notas:(Entrada-Honda)x(Devolução-HLS)    º±±
±±º          ³ pelo Data de Entrada e por Fornecedor/Cliente Especificado.º±±
±±º          ³ No caso foi feito a priori p/HONDA-PAULINIA=000042-Loja=03 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HONDA LOCK                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GEXLSTRIA()

	SetPrvt("cPerg,nOpc_,cCad_,aSay_,aButt_,aCampos,lAbortPrint,TipoAfas,aArea_")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cPerg       := "GEXLST" // Nome do arquivo de perguntas do SX1
	cCad_		:= ""
	nOpc_		:= 0
	aSay_		:= {}
	aButt_		:= {}
	aCampos 	:= {}
	lAbortPrint := .F.
	TipoAfas    := ""
	aArea_      := GetArea()

	//Processamento
	cCad_		:= "** Gera Planilha de Notas Entrada x Devolução **"

	aAdd( aSay_, "Este programa tem como objetivo gerar uma planilha em  " )
	aAdd( aSay_, "Excell, com informações das Notas de Entrada do Fornecedor " )
	aAdd( aSay_, "Versus as Notas de Devolução da Honda Lock-SP." )

	aAdd( aButt_, { 5,.T.,{|| Pergunte(cPerg,.T.)    }})
	aAdd( aButt_, { 1,.T.,{|| FechaBatch(),nOpc_ := 1 }})
	aAdd( aButt_, { 2,.T.,{|| FechaBatch()            }})

	//Verifica Perguntas
	//ValidPerg(cPerg)
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

	/*
	NFORIG
	TESORIG
	DTENTRADA
	DTEMISSAO
	QTDORIG
	TOTORIG
	-------------------
	NFDEVOL
	DTDEVOL
	TESDEVOL
	QTDEVOL
	TOTDEVOL
	CODPRODUTO
	*/

	aCampos := {}

	AADD(aCampos,{"FILIAL"   ,  	"C", 002,0})
	AADD(aCampos,{"NFORIG"    ,  	"C", 009,0})
	AADD(aCampos,{"TESORIG"   ,   	"C", 003,0})
	AADD(aCampos,{"DTENTRADA" ,  	"C", 008,0})
	AADD(aCampos,{"DTEMISSAO" ,   	"C", 008,0})
	AADD(aCampos,{"QTDORIG"   ,  	"N", 017,0})
	AADD(aCampos,{"TOTORIG"   ,  	"N", 019,2})

	AADD(aCampos,{"NFDEVOL"   ,  	"C", 009,0})
	AADD(aCampos,{"DTDEVOL"	  ,   	"C", 008,0})
	AADD(aCampos,{"TESDEVOL"  ,   	"C", 003,0})
	AADD(aCampos,{"QTDEVOL"   ,  	"N", 017,0})
	AADD(aCampos,{"TOTDEVOL"  ,  	"N", 019,2})
	AADD(aCampos,{"CODPRODUTO",   	"C", 015,0})

	AADD(aCampos,{"CUSTOENTRA",   	"N", 017,2})
	AADD(aCampos,{"ITEM"      ,  	"C", 006,0})

	AADD(aCampos,{"FORNECE"   ,  	"C", 006,0})
	AADD(aCampos,{"LOJA"      ,  	"C", 002,0})

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

	_cFornec		:=	mv_par01
	_cLoja 		:=	mv_par02
	_DtIni		:=	mv_par03
	_DtFim		:=	mv_par04

	//dbSelectArea("SRA")
	//dbSetOrder(2)

	cQuery := " SELECT DISTINCT D2_FILIAL FILIAL, D2_NFORI NFORIG,D1_TES TESORIG,D1_DTDIGIT DTENTRADA, D1_EMISSAO DTEMISSAO,D1_QUANT QTDORIG, D1_TOTAL TOTORIG, D2_DOC NFDEVOL, D2_EMISSAO DTDEVOL, D2_TES TESDEVOL , D2_QUANT QTDEVOL, D2_TOTAL TOTDEVOL , D2_COD CODPRODUTO, D1_VUNIT CUSTOENTRA,  D1_ITEM ITEM, D1_FORNECE FORNECE, D1_LOJA LOJA "

	cQuery += " FROM " + RetSqlName("SD2") + " SD2 "

	cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 "

	cQuery += " ON D2_CLIENTE = D1_FORNECE AND D2_LOJA = D1_LOJA AND D2_NFORI = D1_DOC AND D2_SERIORI = D1_SERIE AND D2_COD = D1_COD "

	cQuery += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND "

	cQuery += " SD1.D1_FORNECE = '" + _cFornec + "' AND "

	cQuery += " SD1.D1_LOJA    = '" + _cLoja   + "' AND "

	cQuery += " D1_DTDIGIT BETWEEN '"+DTOS(_DtIni)+"' AND '"+DTOS(_DtFim)+"' AND "

	cQuery += " SD2.D_E_L_E_T_ = '' AND "

	cQuery += " SD1.D_E_L_E_T_ = '' "

	cQuery += " ORDER BY D2_NFORI , D2_COD, D1_VUNIT, D1_ITEM  "

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

	If TSD1->(!Eof())
		_XChave := TSD1->NFORIG + TSD1->CODPRODUTO + STR(TSD1->QTDORIG) + STR(TSD1->CUSTOENTRA) + TSD1->ITEM
		_lZera := .F.
	Endif

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
		EXC->NFORIG	    := TSD1->NFORIG
		EXC->TESORIG	:= TSD1->TESORIG
		EXC->DTENTRADA	:= TSD1->DTENTRADA
		EXC->DTEMISSAO	:= TSD1->DTEMISSAO

		If _lZera
			EXC->QTDORIG	:= 0
		Else
			EXC->QTDORIG	:= TSD1->QTDORIG
		Endif

		EXC->TOTORIG	:= TSD1->TOTORIG
		EXC->NFDEVOL	:= TSD1->NFDEVOL
		EXC->DTDEVOL	:= TSD1->DTDEVOL
		EXC->TESDEVOL	:= TSD1->TESDEVOL
		EXC->QTDEVOL	:= TSD1->QTDEVOL
		EXC->TOTDEVOL	:= TSD1->TOTDEVOL
		EXC->CODPRODUTO := TSD1->CODPRODUTO
		EXC->CUSTOENTRA := TSD1->CUSTOENTRA
		EXC->ITEM       := TSD1->ITEM

		EXC->FORNECE 	:= TSD1->FORNECE
		EXC->LOJA		:= TSD1->LOJA

		MsUnlock()

		TSD1->(DbSkip())

		IF _XChave = TSD1->NFORIG + TSD1->CODPRODUTO + STR(TSD1->QTDORIG) + STR(TSD1->CUSTOENTRA) + TSD1->ITEM
			_lZera:=.T.
		Else
			_lZera:=.F.
			_XChave := TSD1->NFORIG + TSD1->CODPRODUTO + STR(TSD1->QTDORIG) + STR(TSD1->CUSTOENTRA) + TSD1->ITEM
		Endif

		//Atualiza Regua
		IncProc("Gerando Planilha......")

	Enddo

	TSD1->(DbCloseArea())


	//---- SAIDAS SEM ENTRADA ------------------------

	cQuery := " SELECT D2_FILIAL FILIAL,D2_NFORI NFORIG,'' TESORIG,'' DTENTRADA, '' DTEMISSAO, '' QTDORIG, '' TOTORIG, D2_DOC NFDEVOL, D2_EMISSAO DTDEVOL, D2_TES TESDEVOL , D2_QUANT QTDEVOL, D2_TOTAL TOTDEVOL , D2_COD CODPRODUTO, '' CUSTOENTRA,  '' ITEM, D2_CLIENTE FORNECE, D2_LOJA LOJA "
	cQuery += " FROM " + RetSqlName("SD2") + " SD2 "

	cQuery += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND "
	cQuery += " SD2.D2_CLIENTE = '" + _cFornec + "' AND "
	cQuery += " SD2.D2_LOJA    = '" + _cLoja   + "' AND "
	cQuery += " D2_EMISSAO BETWEEN '"+DTOS(_DtIni)+"' AND '"+DTOS(_DtFim)+"' AND "
	cQuery += " D2_CF IN ('5905','5949','5921','5949','5915','5903','5909','5920','5949','5915','5949','5908','5911','5901','5901','5902','5920','5901','5913', "
	cQuery += " '5915','5902','5903','5949','6921','6920','5949','6949','5949','5901','5949','5949','5949','5913','5902','7101' ) "

	cQuery += " AND D2_NFORI = '' "
	cQuery += " AND D2_TP IN ('MP','PA') "
	cQuery += " AND SD2.D_E_L_E_T_  = '' "
	cQuery += " ORDER BY D2_CLIENTE, D2_DOC , D2_COD "

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

		Reclock("EXC",.T.)
		EXC->Filial 	:= TSD1->FILIAL
		EXC->NFORIG	    := TSD1->NFORIG

		EXC->TESORIG	:= "" //TSD1->TESORIG

		EXC->DTENTRADA	:= "" //TSD1->DTENTRADA
		EXC->DTEMISSAO	:= "" //TSD1->DTEMISSAO

		EXC->QTDORIG	:= 0  //TSD1->QTDORIG
		EXC->TOTORIG	:= 0  //TSD1->TOTORIG

		EXC->NFDEVOL	:= TSD1->NFDEVOL
		EXC->DTDEVOL	:= TSD1->DTDEVOL
		EXC->TESDEVOL	:= TSD1->TESDEVOL
		EXC->QTDEVOL	:= TSD1->QTDEVOL
		EXC->TOTDEVOL	:= TSD1->TOTDEVOL
		EXC->CODPRODUTO := TSD1->CODPRODUTO

		EXC->CUSTOENTRA := 0  //TSD1->CUSTOENTRA
		EXC->ITEM       := "" //TSD1->ITEM

		EXC->FORNECE 	:= TSD1->FORNECE
		EXC->LOJA		:= TSD1->LOJA

		MsUnlock()

		TSD1->(DbSkip())

		//Atualiza Regua
		IncProc("Gerando Planilha......")

	Enddo

	TSD1->(DbCloseArea())


	//---- FIM # SAIDAS SEM ENTRADA ------------------------


	//---- ENTRADAS SEM SAIDAS -----------------------

	cQuery := " SELECT D1_FILIAL FILIAL,D1_DOC NFORIG,D1_TES TESORIG,D1_DTDIGIT DTENTRADA, D1_EMISSAO DTEMISSAO,D1_QUANT QTDORIG, D1_TOTAL TOTORIG, '' NFDEVOL,'' DTDEVOL, '' TESDEVOL , '' QTDEVOL, '' TOTDEVOL , D1_COD CODPRODUTO, D1_VUNIT CUSTOENTRA,  D1_ITEM ITEM, D1_FORNECE FORNECE, D1_LOJA LOJA "

	cQuery += " FROM " + RetSqlName("SD1") + " SD1 "

	cQuery += " WHERE SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "

	cQuery += " SD1.D1_FORNECE = '" + _cFornec + "' AND "

	cQuery += " SD1.D1_LOJA    = '" + _cLoja   + "' AND "

	cQuery += " D1_DTDIGIT BETWEEN '"+DTOS(_DtIni)+"' AND '"+DTOS(_DtFim)+"' AND "

	cQuery += " D1_CF IN ('2949','1916','1902','1903','1903','1921','1921','1912','1949','1949','1949','1949','1949','1949','1554','1556','1902','1101','1921','1949','1916','1949','1949','1906','1901','1909','1913','1920','1908','1949','1902','1906','1901','1555','1912','1949') "

	cQuery += " AND D1_NFORI = '' "

	cQuery += " AND D1_TP IN ('MP','PA') "

	cQuery += " AND SD1.D_E_L_E_T_  = '' "

	cQuery += " ORDER BY D1_FORNECE, D1_DOC , D1_COD "

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

		Reclock("EXC",.T.)
		EXC->Filial 	:= TSD1->FILIAL
		EXC->NFORIG	    := TSD1->NFORIG
		EXC->TESORIG	:= TSD1->TESORIG
		EXC->DTENTRADA	:= TSD1->DTENTRADA
		EXC->DTEMISSAO	:= TSD1->DTEMISSAO
		EXC->QTDORIG	:= TSD1->QTDORIG
		EXC->TOTORIG	:= TSD1->TOTORIG

		EXC->NFDEVOL	:= "" //TSD1->NFDEVOL
		EXC->DTDEVOL	:= "" //TSD1->DTDEVOL
		EXC->TESDEVOL	:= "" //TSD1->TESDEVOL
		EXC->QTDEVOL	:= 0  //TSD1->QTDEVOL
		EXC->TOTDEVOL	:= 0  //TSD1->TOTDEVOL

		EXC->CODPRODUTO := TSD1->CODPRODUTO
		EXC->CUSTOENTRA := TSD1->CUSTOENTRA
		EXC->ITEM       := TSD1->ITEM

		EXC->FORNECE 	:= TSD1->FORNECE
		EXC->LOJA		:= TSD1->LOJA

		MsUnlock()

		TSD1->(DbSkip())

		//Atualiza Regua
		IncProc("Gerando Planilha......")

	Enddo

	TSD1->(DbCloseArea())

	//---- FIM # ENTRADAS SEM SAIDAS -----------------------


	Processa({||_fOpenExcel(cArqEXC)},"Abrindo Excel.....")

	dbclosearea("EXC")
	Ferase(cArqEXC + OrdBagExt())

	RestArea(aArea_)

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fOpemExcel³ Autor ³Claudio Torres          ³ Data ³ 11.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de Chamada da Planilha Excell                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function _fOpenExcel(cArqTRC)

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


//Fim da Rotina

//Fim do Programa

/*

SELECT DISTINCT D2_NFORI NFORIG,D1_TES TESORIG,D1_DTDIGIT DTENTRADA, D1_EMISSAO DTEMISSAO,D1_QUANT QTDORIG, D1_TOTAL TOTORIG, D2_DOC NFDEVOL, D2_EMISSAO DTDEVOL, D2_TES TESDEVOL , D2_QUANT QTDEVOL, D2_TOTAL TOTDEVOL , D2_COD CODPRODUTO FROM SD2010
INNER JOIN SD1010
ON D2_CLIENTE = D1_FORNECE AND D2_LOJA = D1_LOJA AND D2_NFORI = D1_DOC AND D2_SERIORI = D1_SERIE AND D2_COD = D1_COD
WHERE D1_DTDIGIT >= '20130401' AND D1_DTDIGIT <= '20131219'
AND D1_FORNECE = '000042'
AND SD2010.D_E_L_E_T_  = ' '
AND SD1010.D_E_L_E_T_  = ' '
ORDER BY D2_NFORI , D1_TES

*/
