#Include "Protheus.ch"
#Include "RwMake.ch"
//#Include "FINR170.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR170  ³ Autor ³Marcel Borges Ferreira ³ Data ³ 15/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Borderos para cobranca / pagamentos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR170                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PlFinR09()

	//Local oReport

	//If FindFunction("TRepInUse") .And. TRepInUse()
	//	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//	//³Interface de impressao                                                  ³
	//	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//	oReport:=ReportDef()
	//	oReport:PrintDialog()
	//Else
	U_PlFinR9a()

	//EndIf

Return                                                              

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR170  ³ Autor ³ Wagner Xavier          ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Borderos para cobranca / pagamentos              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR170(void)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Prograd.³ALTERACAO                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³29.06.98³      ³Mauricio³Nro de titulos com 12 posicoes                 ³±±
±±³20.08.98³xxxxxx³Alice   ³Tratamento de filiais                          ³±±
±±³14.10.98³xxxxxx³Andreia ³Alteracao no lay-out para ativar set century   ³±±
±±³29.06.98³      ³Mauricio³Nro de titulos com 12 posicoes                 ³±±
±±³15.03.99³xxxxxx³Julio   ³Correcao na Busca de Bordero consid. Filiais...³±±
±±³30.03.99³META  ³Julio   ³Verificacao nso Parametros de Tamanho do Rel.  ³±±
±±³06.07.99³      ³Mauricio³Tratar drivers impressoras idem cabec()        ³±±
±±³02.08.99³META  ³Julio   ³Interpretar MV_CRNEG e MV_CPNEG                ³±±
±±³09.09.99³23811A³Mauricio³Corrigir impressao da empresa no rodap‚        ³±±
±±³24.11.99³xxxxxx³Mauricio³Corrigir tratamento Filial De/Ate              ³±±
±±³14.02.03³XXXXXX³Eduardo Ju³Inclusao de Queries p/ filtros em TOPCONNECT.³±±
±±³11.08.06³		³Menon   ³Inclusao da Data de Emissao do Bordero.			³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PlFinR9a() 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cDesc1  := "Este programa tem a funcao de emitir os borderos de cobran‡a"
	Local cDesc2  := "ou pagamentos gerados pelo usuario."
	Local cDesc3  := ""
	Local wnrel
	Local cString := "SEA"
	Local nOpca	  := 0
	Local aPergs := {}
	Local nI := 0
	Local nCount := 0

	Private tamanho  := "P"

	Private cabec1
	Private cabec2
	Private titulo   := "Emissao de Borderos"
	Private aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
	Private nomeprog := "PLFINR09"
	Private aLinha   := { },nLastKey := 0
	Private cPerg    := PADR("PLFINR09",LEN(SX1->X1_GRUPO))
	Private cComple1 := Space(79)
	Private cComple2 := Space(79)
	Private cComple3 := Space(79)   

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DBSelectArea("SX1")
	DBSetOrder(1) //FILIAL+VARIAVEL


	If (TAMSX3("E1_CLIENTE")[1] + TAMSX3("E1_LOJA")[1] > 8) .or.;
	(TAMSX3("E2_FORNECE")[1] + TAMSX3("E2_LOJA")[1] > 8) .or.;
	(TAMSX3("E1_PARCELA")[1] + TAMSX3("E2_PARCELA")[1] > 4)
		tamanho := "M"
	EndIf

	IF DBSeek("FIN170")             
		For nI := 1 To 10
			If SX1->X1_GRUPO == 'PLFINR09'
				nCount++
			Else
				Exit
			EndIf
			SX1->(DBSkip())
		Next
	EndIf

	If nCount <> 8
		IF DBSeek("FIN170")
			For nI := 1 To nCount
				If SX1->X1_GRUPO == 'PLFINR09'
					RecLock("SX1")
					DBDelete()
					MSUnlock()
				Else
					Exit
				EndIf
				SX1->(DBSkip())
			Next
		EndIf
	EndIf

	Aadd(aPergs,{"Qual carteira ?","¿Cual Cartera ?","Wich Portfolio?","mv_ch01","N",1,0,2,"C",,"mv_par01","Receber","Cobrar","Receivable","","","Pagar","Pagar","Payable","","","","","","","","","","","","","","","","","","","S",""})
	Aadd(aPergs,{"Bordero Inicial ?","¿De Bordero ?","Initial Bordero ?","mv_ch02","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})
	Aadd(aPergs,{"Bordero Final ?","¿Ate Bordero ?","To Bordero ?","mv_ch03","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})
	Aadd(aPergs,{"Considera Filiais ?","¿Consd. Sucursales ?","Consider Branches ?","mv_ch04","N",1,0,1,"C",,"mv_par04","Sim","Si","Yes","","","Não","No","No","","","","","","","","","","","","","","","","","","","S",""})
	Aadd(aPergs,{"Da Filial ?","¿De Sucursal ?", "From Branch ?","mv_ch05","C",2,0,0,"G",,"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})
	Aadd(aPergs,{"Ate a Filial ?","¿A Sucursal ?","To Branch ?","mv_ch06","C",2,0,0,"G",,"mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","S",""})
	Aadd(aPergs,{"Qual Moeda ?","¿Cual Moneda ?","Wich Currency ?","mv_ch07","N",2,0,1,"C",,"mv_par07","Moeda 1","Moneda 1","Currency 1","","","Moeda 2","Moneda 2","Moneda 2","","","Moeda 3","Moneda 3","Currency 3","","","Moeda 4","Moneda 4","Currency 4","","","Moeda 5","Moneda 5","Currency 5","","","","S",""})
	Aadd(aPergs,{"Outras Moedas ?","¿Otras Monedas ?","Other Currencies ?","mv_ch08","N",1,0,1,"C",,"mv_par08","Converter","Convertir","Convert","","","Não Imprimir","No Imprimir","Do Not Print","","","","","","","","","","","","","","","","","","","S",""})

	//AjustaSx1("PLFINR09",aPergs)

	pergunte("PLFINR09",.F.)   

	AtualHelp()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                        ³
	//³ mv_par01        	// Carteira (R/P)                          ³
	//³ mv_par02        	// Numero do Bordero Inicial               ³
	//³ mv_par03        	// Numero do Bordero Final                 ³
	//³ mv_par04        	// considera filial                        ³
	//³ mv_par05        	// da filial                               ³
	//³ mv_par06        	// ate a filial                            ³
	//³ mv_par07        	// moeda                                   ³
	//³ mv_par08        	// imprime outras moedas                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := "PLFINR09"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

	If nLastKey == 27
		Return
	EndIf

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	EndIf

	DEFINE MSDIALOG oDlg FROM  92,70 TO 221,463 TITLE "Mensagem Complementar" PIXEL  //  "Mensagem Complementar"
	@ 09, 02 SAY "Linha 1" SIZE 24, 7 OF oDlg PIXEL  //"Linha 1"
	@ 24, 02 SAY "Linha 2" SIZE 25, 7 OF oDlg PIXEL  //"Linha 2"
	@ 38, 03 SAY "Linha 3" SIZE 25, 7 OF oDlg PIXEL  //"Linha 3"
	@ 07, 31 MSGET cComple1 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
	@ 21, 31 MSGET cComple2 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL
	@ 36, 31 MSGET cComple3 Picture "@S48" SIZE 163, 10 OF oDlg PIXEL

	DEFINE SBUTTON FROM 50, 139 TYPE 1 ENABLE OF oDlg ACTION (nOpca:=1,oDlg:End())
	DEFINE SBUTTON FROM 50, 167 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpca#1
		cComple1 := ""
		cComple2 := ""
		cComple3 := ""
	EndIf

	RptStatus({|lEnd| PlFinR9b(@lEnd,wnRel,cString)},Titulo)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA170Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Borderos para cobranca / pagamentos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA170Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd     -  A‡Æo do CodeBlock                              ³±±
±±³          ³ wnRel    -  T¡tulo do relat¢rio                            ³±±
±±³          ³ cString  -  Mensagem                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PlFinR9b(lEnd,wnRel,cString)
	Local cCodigo,cNome,nValor:=0,nValTot:=0,dVencto
	Local nContador := 0
	Local cbcont,CbTxt
	Local nAbat     := 0
	Local cLoja            
	Local cFilDe,cFilAte
	Local nRegEmp   //:= SM0->(RecNo())
	Local aTam      := Iif(mv_par01==1,TAMSX3("E1_CLIENTE"),TAMSX3("E2_FORNECE"))
	Local aColu     := {}
	Local ndecs     := Msdecimais(mv_par07)
	Local cCampo    := If(mv_par01==1,"E1_PARCELA","E2_PARCELA")
	Local cChave, nX
	Local cCampoSea := "SEA->EA_FILIAL"  
	Local cCondWhile:= ""
	Local nRecno	:= 0 
	Local lAchou	:= .F.
	Local cNumCheque:= ""
	Local lMostraChq:= .F.
	Local nFiltro	:= 0
	Local cChaveAnt	:= ""
	Local lUltRodape:= .F.
	Local cFilOrig	:= ""
	Local cFilterUser:=aReturn[7]

	//#IFDEF TOP
	Local aStru	:= SEA->(dbStruct())
	Local nI	:= 0
	Local cOrder:= ""
	//#ELSE
	Local lAchouFil := .F.
	//#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt    := SPACE(10)
	cbcont   := 0
	li       := 80
	m_pag    := 1

	If Empty(mv_par02)
		If Empty(mv_par03)
			//sem filtro de Numero de Bordero
			nFiltro := 0
		Else
			//Ate o Bornero Y
			nFiltro := 3	
		EndIf
	Else
		If Empty(mv_par03)
			//Iniciando no Bordero N
			nFiltro := 1
		Else
			//Iniciando no Bordero N ate o Bordero Y
			nFiltro := 2
		EndIf
	EndIf
	nContador := 0

	dbSelectArea("SEA")
	dbSetOrder(1)

	#IFDEF TOP

	cOrder := SqlOrder(IndexKey())
	cQuery := "SELECT * "
	cQuery += "  FROM "+	RetSqlName("SEA")
	cQuery += " WHERE " 

	If mv_par04 == 2 // Somente filial corrente
		cQuery += "EA_FILIAL = '"+ xFilial("SEA") + "' AND "
	Else
		cQuery += "EA_FILIAL Between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
	Endif

	If nFiltro # 0
		Do Case
			Case nFiltro == 1
			cQuery += "EA_NUMBOR >= '" + mv_par02 + "' AND "			
			Case nFiltro == 2
			cQuery += "EA_NUMBOR >= '" + mv_par02 + "' AND "
			cQuery += "EA_NUMBOR <= '" + mv_par03 + "' AND "
			Case nFiltro == 3
			cQuery += "EA_NUMBOR <= '" + mv_par03 + "' AND "
		EndCase
	Endif

	If mv_par01 == 1
		cQuery += "EA_CART = 'R' AND "
	EndIf

	If mv_par01 == 2
		cQuery += "EA_CART = 'P' AND "
	EndIf   

	cQuery += "EA_TIPO NOT IN ('" + MV_CRNEG + "','" + MV_CPNEG + "','" + MVABATIM + "')  AND "    
	cQuery += "D_E_L_E_T_ <> '*' "   

	cQuery += " ORDER BY " + cOrder
	cQuery := ChangeQuery(cQuery)

	dbSelectArea("SEA")
	dbCloseArea()
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SEA', .F., .T.)

	For nX := 1 to Len(aStru)
		If aStru[nX,2] != 'C'
			TCSetField('SEA', aStru[nX,1], aStru[nX,2],aStru[nX,3],aStru[nX,4])
		EndIf
	Next

	dbSelectArea("SEA")
	dbGotop()
	If EOF() .AND. BOF()
		DbCloseArea()
		ChkFile("SEA")
		dbSetOrder(1)
		Return
	Endif

	#ENDIF	

	SetRegua(RecCount())

	If mv_par04 == 1
		cFilDe  := mv_par05
		cFilAte := mv_par06
	Else
		cFilDe  := xFilial("SEA")
		cFilAte := xFilial("SEA")
	EndIf

	dbSelectArea("SM0")
	dbSeek(cEmpAnt+cFilDe,.T.) //ROM



	aColu := IIF (aTam[1] > 6,;
	TamParcela(cCampo,{040,041,066,067,077,079,095},;
	{041,042,067,068,078,080,096},;
	{042,043,068,069,079,081,097}),;							
	TamParcela(cCampo,{026,027,052,053,063,065,079},;
	{027,028,053,054,064,066,080},;
	{028,029,054,055,065,067,081}))

	While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
		cFilAnt := M0_CODFIL		// Mudar filial atual temporariamente

		dbSelectArea("SEA")

		#IFNDEF TOP
		dbSeek(xFilial("SEA")+IIf(nFiltro==1 .Or. nFiltro == 2, mv_par02,""), .T.)
		If EOF()
			DbSelectArea("SM0")
			DbSkip()
			Loop
		Else
			lAchouFil := .T.
		EndIf
		#ENDIF     

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Existe a possibilidade ser gerado um bordero para varias     ³
		//³ filiais                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		#IFDEF TOP
		If nFiltro # 0
			Do Case
				Case nFiltro == 1
				cCondWhile := "EA_NUMBOR >= mv_par02"
				Case nFiltro == 2
				cCondWhile := "(EA_NUMBOR >= mv_par02 .And. "
				cCondWhile += "EA_NUMBOR <= mv_par03)"
				Case nFiltro == 3
				cCondWhile := "EA_NUMBOR <= mv_par03"
			EndCase
		Else
			cCondWhile:=".T."
		Endif
		#ELSE
		If nFiltro # 0
			Do Case
				Case nFiltro == 1
				cCondWhile := "EA_NUMBOR >= mv_par02"
				Case nFiltro == 2
				cCondWhile := "(EA_NUMBOR >= mv_par02 .And. "
				cCondWhile += "EA_NUMBOR <= mv_par03)"
				Case nFiltro == 3
				cCondWhile := "EA_NUMBOR <= mv_par03"
			EndCase
		Else
			cCondWhile:=".T."			
		Endif
		cCondWhile += " .and. EA_FILIAL == xFilial()"
		#ENDIF				 

		While !Eof() .And. &(cCondWhile)

			If ( lEnd )
				@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"  //"CANCELADO PELO OPERADOR"
				Exit
			EndIf

			IncRegua()

			If ( Empty(EA_NUMBOR) )
				dbSkip()
				Loop
			EndIf

			// Considera filtro do usuario                                  ³
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSelectArea("SEA")
				dbSkip()
				Loop
			Endif			

			If ( mv_par01 == 1 .and. EA_CART = "P" )
				dbSkip()
				Loop
			EndIf

			If ( mv_par01 == 2 .and. EA_CART = "R" )
				dbSkip()
				Loop
			EndIf

			If SEA->EA_TIPO $ MV_CRNEG+"/"+MV_CPNEG+"/"+MVABATIM
				dbSkip()
				Loop
			Endif	

			lAchou := .F.
			If ( mv_par01 == 1 )
				If Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SE1"))
					cChave 	 := xFilial("SE1")+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)
				Else
					cChave 	 := xFilial("SE1")+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)
					cCampoSea := "SEA->EA_FILORIG"
				Endif	

				// posiciono no titulo ORIGINAL (principal com tipo)
				dbSelectArea( "SE1" )
				dbSeek( cChave+SEA->EA_TIPO )
				While !Eof() .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) == cChave+SEA->EA_TIPO
					If SE1->E1_NUMBOR == SEA->EA_NUMBOR
						lAchou := .T.
						Exit
					Else
						dbSkip()
					Endif
				Enddo
				//Caso não tenha achado titulo no SE1, desconsidera para o bordero
				If !lAchou
					dbSelectArea("SEA")
					dbSkip()
					Loop
				Endif			

				If(cPaisLoc<>"BRA" .And. SE1->E1_TIPO $ +IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE))
					nValor:= xMoeda(SE1->E1_VALOR+SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,mv_par07,,ndecs+1)			
				Else
					nValor:= xMoeda(IIF(SE1->E1_SALDO == 0, SE1->E1_VALOR, SE1->E1_SALDO)+SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,mv_par07,,ndecs+1)
				EndIf

				dVencto:= E1_VENCTO
				cCodigo:= E1_CLIENTE
				cLoja	 := E1_LOJA
				If cPaisLoc == "PAR" .And. FieldPos("E1_NUMCHQ") > 0 .And. AllTrim(E1_ORIGEM) == "LOJA010"			   
					cNumCheque  := E1_NUMCHQ
					lMostraChq  := .T.
				EndIf   
				nRecno := Recno()
				If xFilial("SA1") <> Space(2)
					cFilOrig := SE1->E1_FILORIG
				Else
					cFilOrig := xFilial("SA1")
				EndIf
				dbSelectArea( "SA1" )
				dbSeek(cFilOrig+cCodigo+cLoja)
				cNome  := SubStr(A1_NOME,1,25)
				dbSelectArea("SEA")
				If !(SEA->EA_TIPO $ MV_CRNEG+"/"+MVABATIM)
					// procura pelos abatimentos do titulo (sem tipo, para pegar todos)
					dbSelectArea("SE1")
					dbSeek( cChave )
					While !Eof() .and. &cCampoSea+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)==SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se deve imprimir outras moedas³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If mv_par08 == 2 // nao imprime
							If SE1->E1_MOEDA != mv_par07 //verifica moeda do campo=moeda parametro
								dbSkip()
								Loop
							Endif	
						Endif

						If SE1->(E1_CLIENTE+E1_LOJA) != cCodigo+cLoja
							dbSkip()
							Loop
						Endif					

						If SE1->E1_TIPO $ MV_CRNEG+"/"+MVABATIM
							nAbat += xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,mv_par07,,ndecs+1)
						Endif
						dbSkip()
					Enddo
				Endif
			Else
				If Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SE2"))
					cChave 	 := xFilial("SE2")+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)
				Else
					cChave 	 := SEA->(EA_FILORIG+EA_PREFIXO+EA_NUM+EA_PARCELA)
					cCampoSea := "SEA->EA_FILORIG"
				Endif	
				cLoja := Iif ( Empty(SEA->EA_LOJA) , "" , SEA->EA_LOJA )
				dbSelectArea( "SE2" )
				dbSeek(cChave+SEA->EA_TIPO+SEA->EA_FORNECE + cLoja )
				While !Eof() .and. SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) == ;
				cChave+SEA->(EA_TIPO+EA_FORNECE+EA_LOJA)
					If SE2->E2_NUMBOR == SEA->EA_NUMBOR
						lAchou := .T.
						Exit
					Else
						dbSkip()
					Endif
				Enddo
				//Caso não tenha achado titulo no SE1, desconsidera para o bordero
				If !lAchou
					dbSelectArea("SEA")
					dbSkip()
					Loop
				Endif			

				If(cPaisLoc<>"BRA" .And. SE2->E2_TIPO $ IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE))
					nValor:=xMoeda(SE2->E2_VALOR+SE2->E2_SDACRES-SE2->E2_SDDECRE,SE2->E2_MOEDA,mv_par07,,ndecs+1)
				Else
					nValor:=xMoeda(IIF(SE2->E2_SALDO == 0, SE2->E2_VALOR, SE2->E2_SALDO)+SE2->E2_SDACRES-SE2->E2_SDDECRE,SE2->E2_MOEDA,mv_par07,,ndecs+1)
				EndIf

				dVencto:=E2_VENCTO
				cCodigo:=E2_FORNECE
				nRecno := Recno()
				dbSelectArea( "SA2" )
				dbSeek(xFilial("SA2")+cCodigo+cLoja)
				cNome  :=SubStr(A2_NOME,1,25)
				dbSelectArea("SEA")
				If !(SEA->EA_TIPO $ MV_CPNEG+"/"+MVABATIM)
					// procura pelos abatimentos do titulo (sem tipo, para pegar todos)
					dbSelectArea("SE2")
					dbSeek( cChave )
					While !Eof() .and. &cCampoSea+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA)==SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se deve imprimir outras moedas³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If mv_par08 == 2 // nao imprime
							If SE2->E2_MOEDA != mv_par07 //verifica moeda do campo=moeda parametro
								dbSkip()
								Loop
							Endif	
						Endif

						If SE2->E2_TIPO $ MV_CPNEG+"/"+MVABATIM .AND. SEA->EA_FORNECE==SE2->E2_FORNECE
							nAbat += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,mv_par07,,ndecs+1)
						Endif
						dbSkip()
					Enddo
				Endif
			EndIf
			// volta ao titulo ORIGINAL (principal com tipo)
			dbSelectArea(IIF(mv_par08 == 1, "SE1","SE2"))
			dbGoTo(nRecno)
			dbSelectArea( "SEA" )
			If  nValor > 0
				If ( li > 55 )  .Or. cChaveAnt#SEA->EA_FILIAL+SEA->EA_NUMBOR
					If cChaveAnt==SEA->EA_FILIAL+SEA->EA_NUMBOR//( m_pag != 1 )
						li++                              

						@li, 0 PSAY REPLICATE("-",IIf(aTam[1] > 6,TamParcela(cCampo,96,97,98),TamParcela(cCampo,81,82,83)))
					EndIf
					If cChaveAnt#SEA->EA_FILIAL+SEA->EA_NUMBOR .And. !Empty(cChaveAnt)
						PlFinR9d(SM0->M0_NOMECOM, nValTot, aTam, cCampo, li, aColu, nContador)
						lUltRodape := .F.
						nValTot:=0
						nContador:=0
					EndIf
					li++
					li++				
					PlFinR9c(lMostraChq, cChaveAnt#SEA->EA_FILIAL+SEA->EA_NUMBOR)
					lUltRodape := .T.
					m_pag++
					cChaveAnt:=SEA->EA_FILIAL+SEA->EA_NUMBOR
				EndIf
				li++
				@li, 0 PSAY "|"
				If lMostraChq
					@li, 1 PSAY cNumCheque
				Else			
					@li, 1 PSAY EA_PREFIXO
					@li, 5 PSAY EA_NUM
				EndIf   
				@li,17 PSAY "|"
				@li,18 PSAY TamParcela(cCampo,Left(EA_PARCELA,1),Left(EA_PARCELA,2),Left(EA_PARCELA,3))
				@li,TamParcela(cCampo,19,20,21) PSAY "|"
				@li,TamParcela(cCampo,20,21,22) PSAY cCodigo
				@li,aColu[1] PSAY "|"
				@li,aColu[2] PSAY cNome
				@li,aColu[3] PSAY "|"
				@li,aColu[4] PSAY dVencto
				@li,aColu[5] PSAY "|"
				@li,aColu[6] PSAY (nValor - nAbat) Picture PesqPict("SE1","E1_VALOR",14,MV_PAR07)
				@li,aColu[7] PSAY "|"
				nValTot += nValor - nAbat
				nContador ++
				nAbat := 0
			EndIf
			dbSkip()
		EndDo
		#IFDEF TOP
		Exit
		#ELSE		
		If Empty(xFilial("SEA"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		#ENDIF	
	Enddo

	SM0->(dbGoto(nRegEmp))
	cFilAnt := SM0->M0_CODFIL

	If lUltRodape
		PlFinR9d(SM0->M0_NOMECOM, nValTot, aTam, cCampo, li, aColu, nContador)
	EndIf

	#IFDEF TOP
	dbSelectArea("SEA")
	DbCloseArea()
	chkfile("SEA")
	#ENDIF

	#IFNDEF TOP
	If !lAchouFil
		Set Device to Screen
		Help(" ",1,"NOBORDERO")
		SM0->(dbGoto(nRegEmp))
		cFilAnt := SM0->M0_CODFIL
		dbSelectArea("SEA")
		dbSetOrder(1)
		Set Filter to
		Return
	Endif
	#ENDIF

	Set Device To Screen
	dbSelectArea("SE1")
	dbSetOrder(1)
	Set Filter To

	If aReturn[5] = 1
		Set Printer To
		dbCommit()
		Ourspool(wnrel)
	EndIf
	MS_FLUSH()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fr170cabec³ Autor ³ Wagner Xavier         ³ Data ³ 24.05.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cabecalho do Bordero                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³fr170cabec()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PlFinR9c(lMostraChq, lNew)

	Local lWin    := .f.
	Local aTam    := Iif(mv_par01==1,TAMSX3("E1_CLIENTE"),TAMSX3("E2_FORNECE"))
	Local cCampo  := If(mv_par01==1,"E1_PARCELA","E2_PARCELA")
	Local aCabec

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa o Cabec() para impressão da página de parâmetros.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTam 	 	:= 132
	dDataRef := dDataBase
	lPerg 	:= If(GetMv("MV_IMPSX1") == "S" ,.T.,.F.)
	cNomPrg 	:= Alltrim(nomeprog)
	aCabec   :=	{"__LOGOEMP__"}

	Cabec(Titulo, "", "", cNomPrg, tamanho, nTam, aCabec)


	If m_pag == 1

		If TYPE("__DRIVER") == "C"
			If "DEFAULT"$__DRIVER
				lWin := .T.
			EndIf
		EndIf

		If GetMV("MV_CANSALT",,.T.) // Saltar uma página na impressão
			If GetMv("MV_SALTPAG",,"S") != "N"
				Setprc(0,0)
			EndIf	
		Endif	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	(TAMSX3("E1_CLIENTE")[1] + TAMSX3("E1_LOJA")[1] > 8) .or.;
		(TAMSX3("E2_FORNECE")[1] + TAMSX3("E2_LOJA")[1] >8) .or.;
		(TAMSX3("E1_PARCELA")[1] + TAMSX3("E2_PARCELA")[1] > 4)
			nLargura:=132
			@ 0,0 PSay AvalImp(132)
		Else
			nLargura:=080
			@ 0,0 PSay AvalImp(80)
		EndIf

	EndIf	

	dbSelectArea("SA6")
	dbSeek(xFilial("SA6")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON)

	If lNew
		@ 5, 0 PSAY __PrtLeft("AO "+SA6->A6_NOME) //"AO "
		@ 6, 0 PSAY __PrtLeft("AGENCIA "+SA6->A6_AGENCIA + " C/C"+SEA->EA_NUMCON)  // "AGENCIA "###" C/C "
		@ 7, 0 PSAY __PrtLeft(ALLTRIM(SA6->A6_BAIRRO)+" - "+ALLTRIM(SA6->A6_MUN)+" - "+ALLTRIM(SA6->A6_EST))
		@ 8, 0 PSAY __PrtLeft("BORDERO NRO "+SEA->EA_NUMBOR+" - "+"Emitido em: "+DTOC(SEA->EA_DATABOR))  //"BORDERO NRO "###"Emitido em: "
		If mv_par01 == 1
			@ 9, 0 PSAY __PrtLeft("Solicitamos proceder o recebimento das duplicatas abaixo relacionadas")  //"Solicitamos proceder o recebimento das duplicatas abaixo relacionadas"
			@10, 0 PSAY __PrtLeft("CREDITANDO-NOS os valores correspondentes.")  //"CREDITANDO-NOS os valores correspondentes."
		Else
			@ 9, 0 PSAY __PrtLeft("Solicitamos proceder o pagamento das duplicatas abaixo relacionadas")  //"Solicitamos proceder o pagamento das duplicatas abaixo relacionadas"
			@10, 0 PSAY __PrtLeft("DEBITANDO-NOS os valores correspondentes.")  //"DEBITANDO-NOS os valores correspondentes."
		EndIf
		li:=11
		If ( !Empty ( cComple1 ) )
			@li++, 0 PSAY __PrtLeft(cComple1)
		EndIf
		If	( !Empty ( cComple2 ) )
			@li++, 0 PSAY __PrtLeft(cComple2)
		EndIf
		If !Empty ( cComple3 )
			@li++ , 0 PSAY __PrtLeft(cComple3)
		EndIf
		li+=2
	Else
		li:=5                         
	EndIf

	@li, 0 PSAY REPLICATE("-",IIf(aTam[1] > 6 , TamParcela(cCampo,96,97,98), TamParcela(cCampo,79,80,81)))
	li++
	If lMostraChq              
		@li, 0 PSAY "|"+IIf(aTam[1] > 6,TamParcela(cCampo,"NUM CHEQUE      |P|CODIGO              |R A Z A O   S O C I A L  | VENCTO   |         VALOR   |","NUM CHEQUE      |PC|CODIGO              |R A Z A O   S O C I A L  | VENCTO   |         VALOR   |","NUM CHEQUE      |PRC|CODIGO              |R A Z A O   S O C I A L  | VENCTO   |         VALOR   |"),TamParcela(cCampo,"NUM CHEQUE      |P|CODIGO|R A Z A O   S O C I A L  | VENCTO   |         VALOR |","NUM CHEQUE      |PC|CODIGO|R A Z A O   S O C I A L  | VENCTO   |         VALOR |","NUM CHEQUE      |PRC|CODIGO|R A Z A O   S O C I A L  | VENCTO   |         VALOR |"))  //"NUM CHEQUE      |P|CODIGO|R A Z A O   S O C I A L  | VENCTO   |         VALOR |"		
	Else       
		@li, 0 PSAY "|"+IIf(aTam[1] > 6,TamParcela(cCampo,"NUM DUPLIC      |P|CODIGO              |R A Z A O   S O C I A L  | VENCTO   |         VALOR   |","NUM DUPLIC      |PC|CODIGO              |R A Z A O   S O C I A L  | VENCTO   |         VALOR   |","NUM DUPLIC      |PRC|CODIGO              |R A Z A O   S O C I A L  | VENCTO   |         VALOR   |"),TamParcela(cCampo,"NUM DUPLIC      |P|CODIGO|R A Z A O   S O C I A L  | VENCTO   |         VALOR |","NUM DUPLIC      |PC|CODIGO|R A Z A O   S O C I A L  | VENCTO   |         VALOR |","NUM DUPLIC      |PRC|CODIGO|R A Z A O   S O C I A L  | VENCTO   |         VALOR |"))  //"NUM DUPLIC      |P|CODIGO|R A Z A O   S O C I A L  | VENCTO |         VALOR   |"
	EndIf   
	li++                                  
	@li, 0 PSAY "|"+REPLICATE("-",IIF(aTam[1]>6,TamParcela(cCampo,94,95,96),TamParcela(cCampo,78,79,80)))+"|"
	dbSelectArea( "SEA" )     

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fr170cabec³ Autor ³ Adilson H Yamaguchi   ³ Data ³ 09.05.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rodape                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³f170Rodape()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PlFinR9d(cEmpresa, nValTot, aTam, cCampo, li, aColu, nContador)
	If ( nValTot != 0 )
		While ( li <= 49 .and. nValTot != 0 )
			li++
			@li, 0 PSAY "|"
			@li,17 PSAY "|"
			@li,TamParcela(cCampo,19,20,21) PSAY "|"
			@li,aColu[1] PSAY "|"
			@li,aColu[3] PSAY "|"
			@li,aColu[5] PSAY "|"
			@li,aColu[7] PSAY "|"
		Enddo
		li++   

		@li, 0 PSAY "|"+REPLICATE("-",IIF(aTam[1]>6,TamParcela(cCampo,94,95,96),TamParcela(cCampo,78,79,80)))+"|"
		li++
		If mv_par01 == 1
			@li, 0 PSAY "|   TOTAL DA RELACAO A CREDITO DE NOSSA CONTA CORRENTE         "+IIF(aTam[1]>6,Space(14),"")+TamParcela(cCampo,"|"," |","  |")+;
			Transform(nValTot,PesqPict("SE1","E1_VALOR",15,MV_PAR07))+IIF(aTam[1]>6,"  |", "|")  //"@E 9999,999,999.99")+"|"  //"|   TOTAL DA RELACAO A CREDITO DE NOSSA CONTA CORRENTE       "
		Else
			@li, 0 PSAY "|   TOTAL DA RELACAO A DEBITO DE NOSSA CONTA CORRENTE          "+IIF(aTam[1]>6,Space(14),"")+TamParcela(cCampo,"|"," |","  |")+;
			Transform(nValTot,PesqPict("SE1","E1_VALOR",15,MV_PAR07))+IIF(aTam[1]>6,"  |", "|")			//Transform(nValTot,"@E 9999,999,999.99")+"|"  //"|   TOTAL DA RELACAO A DEBITO DE NOSSA CONTA CORRENTE        "
		EndIf
		li ++

		@li, 0 PSAY "|   QUANTIDADE  DE TITULOS IMPRESSOS                           "+IIF(aTam[1]>6,Space(14),"")+TamParcela(cCampo,"|"," |","  |")  //"|   QUANTIDADE  DE TITULOS IMPRESSOS                         "
		@li, aColu[6] PSAY nContador PICTURE "@E 99999999999999"
		@li, aColu[7] PSAY "|"

		li++
		@li, 0 PSAY "|"+REPLICATE("-",iif(aTam[1]>6,TamParcela(cCampo,94,95,96),TamParcela(cCampo,78,79,80)))+"|"
		li+=2
		@li, 0 PSAY "Data: " + DTOC(dDataBase)  //"Data: "
		@li,35 PSAY "Atenciosamente"  //"Atenciosamente"
		li+=1
		@li,35 PSAY cEmpresa
		li+=2
		@li,35 PSAY REPLICATE("-",Len(Trim(cEmpresa)))
		li++
		@li,0  PSAY " "
	EndIf 
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtualHelp ºAutor  ³Ricardo A. Canteras º Data ³10.02.2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza help das perguntas do relatório                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR170                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtualHelp()

	Local aArea 	:= GetArea()
	Local aHelpPor	:= {}       
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {} 
	Local aExiste  := {}          

	aExiste  := AP5GetHelp(".FIN17008.")

	If Empty(aExiste)                     
		//ÚÄÄÄÄÄÄ¿
		//³HELP'S³
		//ÀÄÄÄÄÄÄÙ  
		// Portugues
		Aadd(aHelpPor,"Selecione se a carteira a ser " )
		Aadd(aHelpPor,"considerada para impressão do " )
		Aadd(aHelpPor,"borderô gerado é 'a Receber' " )
		Aadd(aHelpPor,"ou 'a Pagar'." )	
		// Espanhol
		Aadd(aHelpSpa,"Indique si la cartera que ser " )
		Aadd(aHelpSpa,"considerada para impresion del " )
		Aadd(aHelpSpa,"bordero generado es 'por Cobrar'" )
		Aadd(aHelpSpa,"o 'a Pagar'." )	
		// Ingles
		Aadd(aHelpEng,"Indicate if the portfolio to be " )
		Aadd(aHelpEng,"considered for the printing of the " )
		Aadd(aHelpEng,"generated bordero is 'Receivable' " )
		Aadd(aHelpEng,"or 'Payable'." )	

		PutHelp("P.FIN17001.",aHelpPor,aHelpEng,aHelpSpa,.T.)                          
		aHelpPor	:= {}
		aHelpSpa	:= {}
		aHelpEng	:= {}                                                                 

		// Portugues
		Aadd(aHelpPor,"Informe o número inicial do intervalo " )
		Aadd(aHelpPor,"de números de borderôs gerados pelo " )
		Aadd(aHelpPor,"sistema, a serem considerados para " )
		Aadd(aHelpPor,"a emissão do relatório." )
		// Espanhol
		Aadd(aHelpSpa,"Digite el numero inicial del intervalo " )
		Aadd(aHelpSpa,"de numeros de borderos generados por el " )
		Aadd(aHelpSpa,"sistema que se debe considerar para la " )
		Aadd(aHelpSpa,"emision del informe. " )
		// Ingles
		Aadd(aHelpEng,"Enter the initial number of the numbers " )
		Aadd(aHelpEng,"interval related to borderos generated " )
		Aadd(aHelpEng,"by the system that must be considered " )
		Aadd(aHelpEng,"when issuing the report." )

		PutHelp("P.FIN17002.",aHelpPor,aHelpEng,aHelpSpa,.T.)
		aHelpPor	:= {}
		aHelpSpa	:= {}
		aHelpEng	:= {}                                                                 

		Aadd(aHelpPor,"Informe o número final do intervalo " )
		Aadd(aHelpPor,"de números de borderôs gerados pelo " )
		Aadd(aHelpPor,"sistema, a serem considerados para " )
		Aadd(aHelpPor,"a emissão do relatório." )
		// Espanhol
		Aadd(aHelpSpa,"Digite el numero final del intervalo " )
		Aadd(aHelpSpa,"de numeros de borderos generados por " )
		Aadd(aHelpSpa,"el sistema que se debe considerar para " )
		Aadd(aHelpSpa,"la emision del informe. " )
		// Ingles
		Aadd(aHelpEng,"Enter the final number of the numbers " )
		Aadd(aHelpEng,"interval related to borderos generated " )
		Aadd(aHelpEng,"by the system that must be considered " )
		Aadd(aHelpEng,"when issuing the report." )

		PutHelp("P.FIN17003.",aHelpPor,aHelpEng,aHelpSpa,.T.)
		aHelpPor	:= {}
		aHelpSpa	:= {}
		aHelpEng	:= {}                                                                 

		// Portugues
		Aadd(aHelpPor,"Selecione a opção 'Sim' para que a " )
		Aadd(aHelpPor,"geração do relatório considere as " )
		Aadd(aHelpPor,"filiais a serem informadas nos campos " )
		Aadd(aHelpPor,"a seguir, ou 'Não' caso deseja imprimir " )
		Aadd(aHelpPor,"apenas os dados da filial atual." )		
		// Espanhol
		Aadd(aHelpSpa,"Elija la opcion 'Si' para que la " )
		Aadd(aHelpSpa,"generacion del informe considere las " )
		Aadd(aHelpSpa,"sucursales que se deben informar en los " )
		Aadd(aHelpSpa,"campos a seguir, o 'No' si desea imprimir " )
		Aadd(aHelpSpa,"apenas los datos de la cucursal actual." )
		// Ingles
		Aadd(aHelpEng,"Select the option 'Yes' so that the reports " )
		Aadd(aHelpEng,"generation can consider the branches to be " )
		Aadd(aHelpEng,"entered in the following fields. If you want " )
		Aadd(aHelpEng,"to print just the data about the current " )
		Aadd(aHelpEng,"branch, select 'No'." )

		PutHelp("P.FIN17004.",aHelpPor,aHelpEng,aHelpSpa,.T.)	
		aHelpPor	:= {}
		aHelpSpa	:= {}
		aHelpEng	:= {}                                                                 

		// Portugues
		Aadd(aHelpPor,"Caso a resposta do parâmetro anterior " )
		Aadd(aHelpPor,"'Considera Filiais?' seja igual  a 'Sim'," )
		Aadd(aHelpPor,"Informe o código inicial do intervalo de " )
		Aadd(aHelpPor,"números de filiais da sua empresa, a serem " )
		Aadd(aHelpPor,"considerados na geração do relatório." )

		// Espanhol
		Aadd(aHelpSpa,"Si la respuesta del parametro anterior " )
		Aadd(aHelpSpa,"'¿Considera Sucursales?' es igual a 'Si'," )
		Aadd(aHelpSpa,"digite el codigo inicial del intervalo de " )
		Aadd(aHelpSpa,"numeros de sucursales de su empresa que se " )
		Aadd(aHelpSpa,"debe considerar en la generacion del informe." )

		// Ingles
		Aadd(aHelpEng,"In case the answer given to the previous " )
		Aadd(aHelpEng,"parameter ('Cons. Branches Below?') is 'Yes'," )
		Aadd(aHelpEng,"enter in this field the initial code of your " )	
		Aadd(aHelpEng,"company´s branches number interval to be " )	
		Aadd(aHelpEng,"considered when generating the report." )		

		PutHelp("P.FIN17005.",aHelpPor,aHelpEng,aHelpSpa,.T.)
		aHelpPor	:= {}
		aHelpSpa	:= {}
		aHelpEng	:= {}                                                                 

		// Portugues
		Aadd(aHelpPor,"Caso a resposta do parâmetro anterior " )
		Aadd(aHelpPor,"'Considera Filiais?' seja igual  a 'Sim'," )
		Aadd(aHelpPor,"Informe o código final do intervalo de " )
		Aadd(aHelpPor,"números de filiais da sua empresa, a serem " )
		Aadd(aHelpPor,"considerados na geração do relatório." )

		// Espanhol
		Aadd(aHelpSpa,"Si la respuesta del parametro anterior " )
		Aadd(aHelpSpa,"'¿Considera Sucursales?' es igual a 'Si'," )
		Aadd(aHelpSpa,"digite el codigo final del intervalo de " )
		Aadd(aHelpSpa,"numeros de sucursales de su empresa que se " )
		Aadd(aHelpSpa,"debe considerar en la generacion del informe." )

		// Ingles
		Aadd(aHelpEng,"In case the answer given to the previous " )
		Aadd(aHelpEng,"parameter ('Cons. Branches Below?') is 'Yes'," )
		Aadd(aHelpEng,"enter in this field the final code of your " )	
		Aadd(aHelpEng,"company´s branches number interval to be " )	
		Aadd(aHelpEng,"considered when generating the report." )			

		PutHelp("P.FIN17006.",aHelpPor,aHelpEng,aHelpSpa,.T.)
		aHelpPor	:= {}
		aHelpSpa	:= {}
		aHelpEng	:= {}                                                                 

		// Portugues
		Aadd(aHelpPor,"Selecione em qual moeda deve ser emitido " )
		Aadd(aHelpPor,"o relatório." )	
		// Espanhol
		Aadd(aHelpSpa,"Elija la moneda en la cual se debe emitir " )
		Aadd(aHelpSpa,"el informe." )	
		// Ingles
		Aadd(aHelpEng,"Select the currency in which the report " )
		Aadd(aHelpEng,"will be issued." )	

		PutHelp("P.FIN17007.",aHelpPor,aHelpEng,aHelpSpa,.T.)
		aHelpPor	:= {}
		aHelpSpa	:= {}
		aHelpEng	:= {}                                                                 

		// Portugues
		Aadd(aHelpPor,"Selecione a opção 'Converter' caso " )
		Aadd(aHelpPor,"queira que títulos em outras moedas " )
		Aadd(aHelpPor,"sejam considerados ou 'Não imprimir'," )
		Aadd(aHelpPor,"caso contrário." )	
		// Espanhol
		Aadd(aHelpSpa,"Elija la opcion 'Convertir' si desea " )
		Aadd(aHelpSpa,"que los titulos cotizados en otras " )
		Aadd(aHelpSpa,"monedas sean considerados, o en caso " )
		Aadd(aHelpSpa,"contrario, elija 'No imprimir'." )	
		// Ingles
		Aadd(aHelpEng,"Select the option 'Convert' in case " )
		Aadd(aHelpEng,"you want to consider bills in other " )
		Aadd(aHelpEng,"currencies, or 'Don´t print' for the " )
		Aadd(aHelpEng,"opposite." )	

		PutHelp("P.FIN17008.",aHelpPor,aHelpEng,aHelpSpa,.T.)

	EndIf

	RestArea(aArea)

Return
