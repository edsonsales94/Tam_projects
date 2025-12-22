#Include "rwmake.ch"
#Include "topconn.ch"
//+-------------------------------------------------------------------------------------------------
//| Programa..: HlbCtbP6
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá gerar arquivo texto referente aos dados
//|             para análise de compras
//+-------------------------------------------------------------------------------------------------

User Function HlbCtbP6()
	//+-------------------------------------------------------------------------------
	//| Declaracoes de variaveis
	//+-------------------------------------------------------------------------------
	Local nOpcao  := 0
	Local aSay    := {}
	Local aButton := {}
	Local cDesc1  := OemToAnsi("Este programa ira gerar arquivo texto referente aos dados ")
	Local cDesc2  := OemToAnsi("para análise de compras")

	Local cDesc3  := OemToAnsi("Confirma execucao?")
	Local o       := Nil
	Local oWnd    := Nil
	Local cMsg    := ""

	Private Titulo    := OemToAnsi("Geracao de registro de compras")
	Private lEnd      := .F.
	Private NomeProg  := "HlbCtbP6"
	Private lCopia    := .F.
	Private cPerg     := "HLB006"
	Private cArq := Space(50), cFilDe := Space(02), cFilAte := Space(02), cDIde := Space(12), cDIate := Space(12)
	Private cFornDe := Space(06), cFornAte := Space(06), cProdDe := Space(15), cProdAte := Space(15)
	Private dDataDe := AvcTod("//"), dDataAte := AvcTod("//")

	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, Space(80))
	aAdd( aSay, Space(80))
	aAdd( aSay, Space(80))
	aAdd( aSay, cDesc3 )

	//aAdd(aButton, { 5,.T.,{|| Pergunte(cPerg,.T.) } } )
	aAdd(aButton, { 5,.T.,{||  cArq := ValidPerg() } } )
	aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
	aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( Titulo, aSay, aButton )

	If nOpcao == 1
		Processa({|| ArqHlb06() }, "Aguarde...", "Processando informações...", .T. )
	Endif

Return

//+-------------------------------------------------------------------------------------------------
//| Programa..: ArqHlb06()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Coleta de dados da tabela de notas fiscais de entrada - SF1 e SD1
//+-------------------------------------------------------------------------------------------------
*--------------------------*
Static Function ArqHlb06()
	*--------------------------*
	Local cArqTransf
	Local cTexto := Space(45)
	Local aImp:={}, cCod, cDI:="", cInv := Space(14), cForn :=Space(14)
	Local aNaoExiste := {}

	Local nExtQtde, nExtFob, nExtFrete, nExtSeguro
	Local dExtDtBl := "", cExtNumDI := "", dExtDtDI := "", dExtDtVenc := ""
	Local nExtPVenc := 0, cExtMFob := "", cExtMFrete := "", cExtMSeguro := ""
	Private cInd

	If !Empty(cArq)
		GeraArq()
		Ext->(dbGoTop())
	EndIf

	SE2->(dbSetOrder(6))//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO

	GeraArqTemp()
	Trb->(dbGoTop())

	ProcRegua(Trb->(LastRec()))

	nCont := 1
	While !Trb->(Eof())
		IncProc("Processando Nota: "+Trb->F1_DOC)

		cDI := Padr(Trb->F1_NRDI, 15  )
		//cDI := Padr(Trb->F1_NRDI, Len(Ext->NR_DI)  )

		Store 0 To nExtQtde, nExtFob, nExtFrete, nExtSeguro

		dExtDtBl    := Space(10)
		cExtNumDI   := Space(10)
		dExtDtDI    := Space(10)
		dExtDtVenc  := Space(10)
		nExtPVenc   := 0
		cExtMFob    := "790"
		cExtMFrete  := "790"
		cExtMSeguro := "790"
		//cCod := Left(Posicione("SB1",1,xFilial("SB1")+Trb->D1_COD,"B1_COD"),Len(Ext->CD_PART_NU))
		cCod := Left(Posicione("SB1",1,xFilial("SB1")+Trb->D1_COD,"B1_COD"),15)

		If !Empty(cDI) .and. !Empty(cArq)
			If Ext->(dbSeek(cDI+cCod))
				cExtNumDI	:= Ext->NR_DI								//DI
				cInv		:= Ext->INVOICE         					//INVOICE
				dExtDtBl	:= ctd(Ext->DT_BL)							//DATA BL
				dExtDtDI	:= ctd(Ext->DT_DI)      					//REGISTRO DI
				dExtDtVenc	:= ctd(Ext->DT_VENCIME) 					//VENCIMENTO
				nExtPVenc	:= Int(Ext->PRAZO_VENC)						//PRAZO

				nExtQtde	:= Ext->QTD									//QUANTIDADE
				nExtFob		:= Ext->FOB									//VALOR FOB
				cExtMFob	:= If(Ext->FOB # 0,Ext->MOEDA_FOB,"790")	//MOEDA FOB

				nExtFrete	:= Ext->FRETE								//FRETE
				cExtMFrete	:= If(Ext->FRETE #0,Ext->MOEDA_FRET,"790")	//MOEDA FRETE

				nExtSeguro	:= Ext->SEGURO								//SEGURO
				cExtMSeguro	:= If(Ext->SEGURO#0,Ext->MOEDA_SEGU,"790")	//MOEDA SEGURO
			Else
				If (nPos := Ascan(aNaoExiste,{|x| x[2] = cDI .and. x[3] = cCod})) = 0
					cDescricao := Posicione("SB1",1,xFilial("SB1")+Trb->D1_COD,"B1_DESC")
					AADD(aNaoExiste,{StrZero(nCont,8),cDI,cCod,Trb->D1_COD,cDescricao})
					nCont++
				EndIf
			EndIf
		EndIf

		lAchou := SE2->(dbSeek(xFilial("SE2")+Trb->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)))

		cUM   := Posicione("SAH",1,xFilial("SAH")+Trb->D1_UM,"AH_COD_SIS")
		cCnpj := Posicione("SM0",1,"01"+Trb->F1_FILIAL,"M0_CGC")
		cD1Cf := If(Alltrim(Trb->D1_CF) == "000","1949",Trb->D1_CF)

		cCar := "."

		AADD(aImp,{Trb->D1_COD													,;  //01 - Código do Produto
			SPACE(14)													,;  //02 - Código da Divisão
			Trb->F1_FORNECE												,;  //03 - Código do Fornecedor
			SPACE(14)													,;  //04 - Lançamento Contábil
			cInv														,;  //05 - Invoice
			If(!Empty(cDI),dExtDtBl,Space(10))							,;  //06 - Data da BL
			If(!Empty(cDI),cDI,Left(Trb->F1_DOC,14))					,;  //07 - Número da DI
			If(!Empty(cDI),dExtDtDI,Stod(Trb->F1_DTDIGIT))				,;  //08 - Data de Registro da DI
			Trb->F1_DOC													,;  //09 - Número da Nota de Entrada
			Trb->F1_DTDIGIT												,;  //10 - Data de Entrada da Nota
			cD1Cf														,;  //11 - CFOP
			If(!Empty(cDI),dExtDtVenc,SE2->E2_VENCREA)					,;  //12 - Data de Vencimento Médio
			If(!Empty(cDI),StrZero(nExtPVenc,4),If(lAchou,StrZero(SE2->E2_VENCREA-Stod(Trb->F1_EMISSAO),4),Repl("0",4))),;  //13 - Prazo de Vencimento Médio
			TiraPonto(Trb->D1_QUANT,17,3,".")							,;  //14 - Quantidade
			TiraPonto(If(!Empty(cDI),nExtFob,Trb->D1_TOTAL),18,2,cCar)	,;  //15 - Valor (FOB ou Nacional)
			If(!Empty(cDI),cExtMFob,"790")								,;  //16 - Moeda FOB
			TiraPonto(If(!Empty(cDI),nExtFrete,0),18,2,cCar)			,;  //17 - Frete
			TiraPonto(If(!Empty(cDI),nExtSeguro,0),18,2,cCar)			,;  //18 - Seguro
			If(!Empty(cDI),cExtMFrete,"790")							,;  //19 - Moeda Frete
			If(!Empty(cDI),cExtMSeguro,"790")							,;  //20 - Moeda Seguro
			TiraPonto(Trb->D1_II,18,2,".")								,;  //21 - II
			TiraPonto(Trb->D1_VALICM,18,2,".")							,;  //22 - ICMS
			TiraPonto(Trb->D1_PIS,18,2,".")								,;  //23 - PIS
			TiraPonto(Trb->D1_COFINS,18,2,".")							,;  //24 - Cofins
			cUM															,;  //25 - Unidade de Medida
			cCnpj})															//26 - CNPJ

		Trb->(dbSkip())
		lCopia := .T.
	End

	If !Empty(cArq)
		Ferase(cInd)
		Ext->(dbCloseArea())
	EndIf
	Trb->(dbCloseArea())

	aSort(aImp,,,{|x,y| x[09]+x[10]+x[01] < y[09]+y[10]+y[01]})

	ProcRegua(Len(aImp))

	SET CENTURY ON

	For nX:=1 to Len(aImp)

		IncProc("Gerando arquivo da invoice :"+aImp[nX][5])

		cTexto := Space(312)//(315)
		cTexto := Stuff(cTexto,001,015,PadR(Alltrim(aImp[nX][01]),15))  //Produto
		cTexto := Stuff(cTexto,016,029,PadR(Alltrim(aImp[nX][02]),14))  //Divisão
		cTexto := Stuff(cTexto,030,043,PadR(Alltrim(aImp[nX][03]),14))  //Fornecedor
		cTexto := Stuff(cTexto,044,057,PadR(Alltrim(aImp[nX][04]),14))  //Lanc. Contábil
		cTexto := Stuff(cTexto,058,071,PadR(Alltrim(aImp[nX][05]),14))  //Invoice
		cTexto := Stuff(cTexto,072,081,PadR(aImp[nX][06],10))           //Data da BL
		cTexto := Stuff(cTexto,082,095,PadR(Alltrim(aImp[nX][07]),14))  //Nro DI
		cTexto := Stuff(cTexto,096,105,PadR(aImp[nX][08],10))           //Data da Imp
		cTexto := Stuff(cTexto,106,119,PadR(Alltrim(aImp[nX][09]),14))  //Nfe
		cTexto := Stuff(cTexto,120,129,PadR(Stod(aImp[nX][10]),10))     //Data de entrada
		cTexto := Stuff(cTexto,130,134,PadR(Alltrim(aImp[nX][11]),05))  //CFOP
		cTexto := Stuff(cTexto,135,144,PadR(aImp[nX][12],10))     //Vencimento
		cTexto := Stuff(cTexto,145,148,PadR(aImp[nX][13],04))           //Prazo
		cTexto := Stuff(cTexto,149,165,PadR(Alltrim(aImp[nX][14]),17))  //Quantidade
		cTexto := Stuff(cTexto,166,182,PadR(Alltrim(aImp[nX][15]),17))  //FOB
		cTexto := Stuff(cTexto,183,185,PadR(Alltrim(aImp[nX][16]),03))  //Moeda FOB
		cTexto := Stuff(cTexto,186,202,PadR(Alltrim(aImp[nX][17]),17))  //Frete
		cTexto := Stuff(cTexto,203,219,PadR(Alltrim(aImp[nX][18]),17))  //Seguro
		cTexto := Stuff(cTexto,220,222,PadR(Alltrim(aImp[nX][19]),03))  //Moeda Frete
		cTexto := Stuff(cTexto,223,225,PadR(Alltrim(aImp[nX][20]),03))  //Moeda Seguro
		cTexto := Stuff(cTexto,226,242,PadR(Alltrim(aImp[nX][21]),17))  //II
		cTexto := Stuff(cTexto,243,259,PadR(Alltrim(aImp[nX][22]),17))  //ICMS
		cTexto := Stuff(cTexto,260,276,PadR(Alltrim(aImp[nX][23]),17))  //PIS
		cTexto := Stuff(cTexto,277,293,PadR(Alltrim(aImp[nX][24]),17))  //COFINS
		cTexto := Stuff(cTexto,294,295,PadR(Alltrim(aImp[nX][25]),02))  //UNIDADE DE MEDIDA
		cTexto := Stuff(cTexto,296,312,PadR(Alltrim(aImp[nX][26]),17))  //CNPJ

		Grava(cTexto,,"Compras")

	Next nX

	Grava("",.T.,"Compras")

	SET CENTURY OFF

	If Len(aNaoExiste) > 0

		ProcRegua(Len(aNaoExiste))

		For nX := 1 to Len(aNaoExiste)

			IncProc("Gerando arquivo de divergencia, DI :"+aNaoExiste[nX][2])

			cTexto := Space(40)
			cTexto := Stuff(cTexto,001,010,Padr(aNaoExiste[nX][1],10))
			cTexto := Stuff(cTexto,011,025,Padr(aNaoExiste[nX][2],12))
			cTexto := Stuff(cTexto,026,047,Padr(aNaoExiste[nX][3],20))
			cTexto := Stuff(cTexto,048,064,Padr(aNaoExiste[nX][4],15))
			cTexto := Stuff(cTexto,065,109,Padr(aNaoExiste[nX][5],45))

			Grava(cTexto,,"DivergenciaDI")
		Next nX

		Grava(cTexto,.T.,"DivergenciaDI")
	EndIf

Return

//+-------------------------------------------------------------------------------------------------
//| Programa..: ValidPerg()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 09/03/06
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grupo de perguntas para consulta
//+-------------------------------------------------------------------------------------------------

***********************************
Static Function ValidPerg()
	***********************************
	Local cExt := "Arquivos TXT | *.TXT"
	Local cAux := ""


	PutSX1(cPerg,"01","   Filial de     : ","","","mv_ch1","C",02,0,0,"G","","","","","mv_par01")
	PutSX1(cPerg,"02","   Filial Ate    : ","","","mv_ch2","C",02,0,0,"G","","","","","mv_par02")
	PutSX1(cPerg,"03","   Data de       : ","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
	PutSX1(cPerg,"04","   Data Ate      : ","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
	PutSX1(cPerg,"05","   Fornecedor de : ","","","mv_ch5","C",06,0,0,"G","","","","","mv_par05")
	PutSX1(cPerg,"06","   Fornecedor Ate: ","","","mv_ch6","C",06,0,0,"G","","","","","mv_par06")
	PutSX1(cPerg,"07","   Produto de    : ","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07")
	PutSX1(cPerg,"08","   Produto Ate   : ","","","mv_ch8","C",15,0,0,"G","","","","","mv_par08")
	PutSX1(cPerg,"09","   Arq.Import    : ","","","mv_ch9","C",50,0,0,"G","","","","","mv_par09")

	Pergunte(cPerg,.F.)

	cFilDe   := mv_par01
	cFilAte  := mv_par02
	dDataDe  := mv_par03
	dDataAte := mv_par04
	cFornDe  := mv_par05
	cFornAte := mv_par06
	cProdDe  := mv_par07
	cProdAte := mv_par08


	@ 000, 000 To 380,350 Dialog oTela Title OemToAnsi("Parametros de Compras")

	@ 010, 015 Say "Filial de      : "
	@ 025, 015 Say "Filial Ate     : "
	@ 040, 015 Say "Data de        : "
	@ 055, 015 Say "Data Ate       : "
	@ 070, 015 Say "Fornecedor de  : "
	@ 085, 015 Say "Fornecedor Ate : "
	@ 100, 015 Say "Produto de     : "
	@ 115, 015 Say "Produto Ate    : "
	@ 130, 015 Say "DI de          : "
	@ 145, 015 Say "DI Ate         : "
	@ 160, 015 Say "Arquivo Import : "

	@ 010, 060 Get cFilDe     Size 40,010 Picture "@!"
	@ 025, 060 Get cFilAte    Size 40,010 Picture "@!"
	@ 040, 060 Get dDataDe    Size 40,010 Picture "@!"
	@ 055, 060 Get dDataAte   Size 40,010 Picture "@!"
	@ 070, 060 Get cFornDe    Size 40,010 Picture "@!"
	@ 085, 060 Get cFornAte   Size 40,010 Picture "@!"
	@ 100, 060 Get cProdDe    Size 60,010 Picture "@!"
	@ 115, 060 Get cProdAte   Size 60,010 Picture "@!"
	@ 130, 060 Get cDIde      Size 60,010 Picture "@!"
	@ 145, 060 Get cDIate     Size 60,010 Picture "@!"
	@ 160, 060 Get cArq       Size 80,010 Picture "@!"
	@ 160, 140 Button "..."   Size 10,10 ;
		Action If(Empty(cAux:=AllTrim(cGetFile(cExt,cExt,,,.T.,1))),;
		Nil, cArq:=Left(cAux+Space(50),50))


	@ 180, 020 BmpButton Type 01 Action If(ValidaArq(@cArq),(nOpc := 1,oTela:End()),)
	@ 180, 060 BmpButton Type 02 Action oTela:End()

	Activate Dialog oTela Centered

	mv_par01 := cFilDe
	mv_par02 := cFilAte
	mv_par03 := dDataDe
	mv_par04 := dDataAte
	mv_par05 := cFornDe
	mv_par06 := cFornAte
	mv_par07 := cProdDe
	mv_par08 := cProdAte

Return cArq

*-------------------------------*
Static Function ValidaArq(cArq)
	*-------------------------------*
	Local cAux := cArq
	Local lTem := .T.

	If !Empty(cAux)
		cAux := Upper(AllTrim(cAux))
		If !("." $ cAux)
			cAux += ".TXT"
			If !(lTem := File(cAux))
				cAux := StrTran(cAux,".TXT",".DBF")
				lTem := File(cAux)
			Endif
		Else
			lTem := File(cAux)
		Endif

		If !lTem
			Alert("Arquivo de Origem não existe !")
			Return .F.
		Endif

		cArq := cAux
	Endif

Return .T.


//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 17/05/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grava as informações coletadas em arquivo texto na pasta especificada
//+-------------------------------------------------------------------------------------------------

****************************************
Static Function Grava(cTxt,lFecha,cArq)
	****************************************
	Local cFileName, cTmpFile, cPath, cString := cTxt

	cPath := "\Transfer price\"
	cFileName := cPath +cArq+".txt"
	cTmpFile  := cPath +cArq+".tmp"


	If lFecha == NIL .Or. lFecha == .F.
		If !File(cTmpFile)
			fHandle:=FCREATE(cTmpFile)
		Else
			fHandle := FOPEN(cTmpFile,2)
		Endif
		cString := cTxt+CHR(13)+CHR(10)
		FSEEK(fHandle,0,2)
		FWRITE(fHandle,cString)
		FCLOSE(fHandle)
	Else
		If File(cFileName)
			FErase(cFileName)
		Endif
		FRename(cTmpFile, cFileName)
		If lCopia
			MsgInfo("Foi gerado arquivo de Compras, arquivo: "+cFileName,"Informacao")
			//MsgInfo("Processo finalizado com sucesso!","Final")
		Else
			MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
		EndIf

	Endif

Return

*-------------------------------------------------------------------*
Static Function TiraPonto( nValor,nTam,nDec,cCar )
	*-------------------------------------------------------------------*
	nValor := Str(nValor,nTam,nDec )
	nValor := Replicate("0",18-len(Alltrim(nValor)))+Alltrim(nValor)
Return StrTran( nValor,cCar,'' )

*---------------------------------------------------------------------*
Static Function GeraArqTemp(nTipo,xcFilial,cDoc,cSerie,cForn,cLoja)
	*---------------------------------------------------------------------*
	Local cQry := ""

	cQry := " SELECT F1_FILIAL, F1_EMISSAO, F1_DTDIGIT, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, "
	cQry += " F1_NRDI, F1_ZZINVO, D1_COD, D1_UM, D1_CF, SUM(D1_QUANT) D1_QUANT, SUM(D1_TOTAL) D1_TOTAL, "
	cQry += " SUM(D1_II) D1_II, SUM(D1_VALICM) D1_VALICM, SUM(D1_VALIMP5) D1_PIS, SUM(D1_VALIMP6) D1_COFINS "
	cQry += " FROM "+RetSqlName("SF1")+" F1, "+RetSqlName("SD1")+" D1 "
	cQry += " WHERE F1.D_E_L_E_T_ <> '*' AND D1.D_E_L_E_T_ <> '*' "
	cQry += " AND F1_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "
	cQry += " AND F1_EMISSAO BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"' "
	cQry += " AND F1_FORNECE BETWEEN '"+cFornDe+"' AND '"+cFornAte+"' "
	cQry += " AND F1_NRDI BETWEEN '"+cDIde+"' AND '"+cDIate+"' "
	cQry += " AND F1_TIPO = 'N' "
	cQry += " AND D1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "
	cQry += " AND D1_CF NOT IN ('1201','3302') "
	cQry += " AND D1_FILIAL = F1_FILIAL "
	cQry += " AND D1_DOC = F1_DOC "
	cQry += " AND D1_SERIE = F1_SERIE "
	cQry += " AND D1_FORNECE = F1_FORNECE "
	cQry += " AND D1_LOJA = F1_LOJA "
	cQry += " AND EXISTS( SELECT * FROM "+RetSqlName("SB1")
	cQry += " WHERE D_E_L_E_T_ <> '*' "
	cQry += " AND B1_FILIAL = D1_FILIAL "
	cQry += " AND B1_COD = D1_COD "
	cQry += " AND B1_TIPO NOT IN ('EX','ML') ) "
	cQry += " GROUP BY F1_FILIAL, F1_EMISSAO, F1_DTDIGIT, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_NRDI, F1_ZZINVO, D1_COD, D1_UM, D1_CF "
	cQry += " ORDER BY F1_FILIAL, F1_NRDI,F1_FORNECE,F1_LOJA,F1_DOC,F1_SERIE "

	TCQuery cQry Alias Trb New

Return

//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 13/07/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Lê o arquivo TXT e gera estrutura em DBF
//+-------------------------------------------------------------------------------------------------

Static Function GeraArq()
	Local aMat := {},cArqTxt, cArqDbf
	Local cDI, cInv, cDtBl, cDtDI, cDtVenc, cPart
	Local nPrazo, nQtd, nFob, cMFob, nFrete, cMFrete
	Local nSeguro, cMSeguro
	Local aStruct := {{"NR_DI"     ,"C",15,0},;
		{"INVOICE"   ,"C",15,0},;
		{"DT_BL"     ,"C",10,0},;
		{"DT_DI"     ,"C",10,0},;
		{"DT_VENCIME","C",10,0},;
		{"PRAZO_VENC","N",04,0},;
		{"QTD"       ,"N",17,3},;
		{"FOB"       ,"N",17,2},;
		{"MOEDA_FOB" ,"C",03,0},;
		{"FRETE"     ,"N",17,2},;
		{"MOEDA_FRET","C",03,0},;
		{"SEGURO"    ,"N",17,2},;
		{"MOEDA_SEGU","C",03,0},;
		{"CD_PART_NU","C",20,0}}


	aadd(aMat,{"LINHA","C",155})

	// cArqTxt := CriaTrab(aMat,.T.)
	// Use (cArqTxt) Alias Wrk new
	//
	// dbSelectArea("Wrk")
	// Append From (cArq) Sdf
	// Wrk->(dbGoTop())

	// Instancio o objeto
	oTable  := FwTemporaryTable():New( "Wrk" )
	// Adiciono os campos na tabela
	oTable:SetFields( aMat )
	// Adiciono os índices da tabela
	// oTable:AddIndex( '01' , { "NR_DI+CD_PART_NU+INVOICE" })
	// Crio a tabela no banco de dados
	oTable:Create()
	//------------------------------------
	//Pego o alias da tabela temporária
	//------------------------------------
	cArqTxt := oTable:GetAlias()

	// cArqDbf := CriaTrab(aStruct,.T.)
	// If Select("Ext") <> 0
	//   dbCloseArea("Ext")
	// EndIf
	// dbUseArea(.T.,,cArqDbf,"Ext")
	// cInd:= CriaTrab(Nil,.F.)
	// IndRegua("Ext",cInd,"NR_DI+CD_PART_NU+INVOICE",,,"Selecionando registros...")

	// Instancio o objeto
	oTable2  := FwTemporaryTable():New( "Ext" )
	// Adiciono os campos na tabela
	oTable2:SetFields( aStruct )
	// Adiciono os índices da tabela
	oTable2:AddIndex( '01' , { "NR_DI+CD_PART_NU+INVOICE" })
	// Crio a tabela no banco de dados
	oTable2:Create()
	//------------------------------------
	//Pego o alias da tabela temporária
	//------------------------------------
	cArqDbf := oTable2:GetAlias()


	While !Wrk->(Eof())
		//0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111
		//0000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223333333333444444444455555
		//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
		//06/0492266-8  HLB002/06-P   01/04/200629/04/200605/05/2006003000000000000001000000000000200000002200000000000000000222000000000000000110220 ED-9900016-000

		cDI		:= Alltrim(SubStr(Wrk->LINHA,001,014))			// DI
		cInv	:= Alltrim(SubStr(Wrk->LINHA,015,014))			// INVOICE
		cDtBl	:= SubStr(Wrk->LINHA,029,010)					// DATA BL
		cDtDI	:= SubStr(Wrk->LINHA,039,010)						// DATA DI
		cDtVenc	:= SubStr(Wrk->LINHA,049,010)						// DATA VENCIMENTO
		nPrazo	:= Val(Alltrim(SubStr(Wrk->LINHA,059,004)))	// PRAZO VENCIMENTO
		nQtd	:= Val(Alltrim(SubStr(Wrk->LINHA,063,017)))	// QUANTIDADE
		nFob	:= Val(Alltrim(SubStr(Wrk->LINHA,080,017)))	// VALOR FOB
		cMFob	:= Alltrim(SubStr(Wrk->LINHA,097,003))	  		// MOEDA FOB
		nFrete	:= Val(Alltrim(SubStr(Wrk->LINHA,100,017)))	// VALOR FRETE
		cMFrete	:= Alltrim(SubStr(Wrk->LINHA,117,003))			// MOEDA FRETE
		nSeguro	:= Val(Alltrim(SubStr(Wrk->LINHA,120,017)))	// VALOR SEGURO
		cMSeguro:= Alltrim(SubStr(Wrk->LINHA,137,003))			// MOEDA SEGURO
		cPart	:= Alltrim(SubStr(Wrk->LINHA,140,015))			// CÓDIGO PRODUTO

		If !Ext->(dbSeek(cDI+cPart+cInv))
			RecLock("Ext",.T.)
			Ext->NR_DI      := cDI
			Ext->INVOICE    := cInv
			Ext->DT_BL      := cDtBl
			Ext->DT_DI      := cDtDI
			Ext->DT_VENCIME := cDtVenc
			Ext->PRAZO_VENC := nPrazo
			Ext->QTD        := nQtd
			Ext->FOB        := nFob
			Ext->MOEDA_FOB  := cMFob
			Ext->FRETE      := nFrete
			Ext->MOEDA_FRET := cMFrete
			Ext->SEGURO     := nSeguro
			Ext->MOEDA_SEGU := cMSeguro
			Ext->CD_PART_NU := cPart
			Ext->(MsUnlock())
		Else
			RecLock("Ext",.F.)
			Ext->QTD        := Ext->QTD			+ nQtd
			Ext->FOB        := Ext->FOB			+ nFob
			Ext->FRETE      := Ext->FRETE			+ nFrete
			Ext->SEGURO     := Ext->SEGURO		+ nSeguro
			Ext->CD_PART_NU := Ext->CD_PART_NU	+ cPart
			Ext->(MsUnlock())
		EndIf
		Wrk->(dbSkip())
	End
	Wrk->(dbCloseArea())

Return

Static Function ctd(xData)

	xData := SubStr(xData,7,4)+SubStr(xData,4,2)+SubStr(xData,1,2)

Return Stod(xData)
