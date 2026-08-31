// #INCLUDE "FINA260.ch"
#INCLUDE "PROTHEUS.CH"


/*	Conciliacao Jogue Limpo x SC7 */
User Function xFINA260()

	Local nSavInd := IndexOrd()
	Local nSavRec	:= Recno()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 		 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aRotina := MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabe‡alho da tela de baixas		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cCadastro := 'Conciliação Jogue Limpo' //"Conciliação DDA"

	If !FDdaInUse()
		Alert ('O tratamento para DDA - Débito Direto Autorizado não está corretamente implementado.'+CHR(13)+;  //"O tratamento para DDA - Débito Direto Autorizado não está corretamente implementado."
		'Por favor, execute o atualizador U_UPDFIN com data posterior a 01/10/09')      //"Por favor, execute o atualizador U_UPDFIN com data posterior a 01/10/09."
		Return
	Endif

	// cAlias    := "SZ2"
	// cArquivo  := "SZ2010"
	// CheckFile(cAlias, cArquivo)
	dbSelectArea("SZ2")
	dbSetOrder(1)
	dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endere‡a a Fun‡„o de BROWSE				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SZ2",,,,,,u_Fa260Leg())

	dbSelectArea("SZ2")
	dbSetOrder(nSavInd)
	dbGoTo(nSavRec)

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³F260Conc  ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 01/10/09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Conciliacao DDA - Debito Direto Autorizado                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ F260Conc()                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ FINA260                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F260Conc(nOpx)

	Local aArea		:= GetArea()
	Local lOk		:= .F.
	Local aSays		:= {}
	Local aButtons	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                    P A R A M E T R O S                       ³
//³--------------------------------------------------------------³
//³MV_PAR01: Considera Filiais Abaixo                            ³
//³MV_PAR02: Filial De                                           ³
//³MV_PAR03: Filial Ate                                          ³
//³MV_PAR04: Emissao De                                          ³
//³MV_PAR05: Emissao Ate                                         ³
//³MV_PAR06: Produto De                                          ³
//³MV_PAR07: Produto Ate                                         ³
//³MV_PAR08: Loja De			                                 ³
//³MV_PAR09: Loja Ate		                                     ³
//³MV_PAR10: Considera Vencto ou Vencto Real                     ³
//³MV_PAR11: Dt. de Processamento do Arquivo DDA De              ³
//³MV_PAR12: Dt. de Processamento do Arquivo DDA Ate             ³
//³MV_PAR13: Avancar Dias (Vencto + nDias)                       ³
//³MV_PAR14: Retroceder Dias (Vencto - nDias)                    ³
//³MV_PAR15: Diferenca a Menor                                   ³
//³MV_PAR16: Diferenca a Maior                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega fun‡„o Pergunte                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("XFIN260",.F.)

	aADD(aSays,'Esta rotina tem como objetivo a conciliação das informações importadas através de')
	aADD(aSays,'processamento de arquivo de coleta Jogue Limpo com os dados dos   ')
	aADD(aSays,'pedidos de compras (tabela SC7) para validar integridades da operações.')

	aADD(aButtons, { 5,.T.,{|| Pergunte("XFIN260",.T. ) } } )
	aADD(aButtons, { 1,.T.,{|| lOk := .T.,FechaBatch()}} )
	aADD(aButtons, { 2,.T.,{|| FechaBatch() }} )
	FormBatch( cCadastro, aSays, aButtons ,,,535)

	If lOk
		Processa({|lEnd| F260Gera(nOpx)})  // Chamada com regua
	Endif

	RestArea(aArea)

Return .T.

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ F260Gera ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 01/10/09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Conciliacao DDA - Debito Direto Autorizado                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ F260Gera(nOpx)                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä
	±±³ Uso      ³ FINA260                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä ä
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ± ±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßüßüßüßüßüßüßüßüßüßüßüßüßüßüßü
*/
Static Function F260Gera(nOpx)

	Local cRecTRB
	Local cIndex	:= " "
	Local lSaida	:= .F.
	Local nOpca		:= 0
	Local aCores 	:= {}
	Local cVarQ := "  "
	Local oTitulo
	// Local oBtn
	Local oDlg
	Local cArqRec1 := ""
	Local cArqRec2 := ""
	Local cArqRec3	:= ""
	Local cArqRec4 := ""
	Local cArqRec5 := ""
	Local cArqRec6 := ""
	Local cArqRec7 := ""
	Local dDtIni	:= CTOD("01/01/1980","ddmmyy")
	Local dDtFin	:= CTOD("01/01/1980","ddmmyy")

	Local lQuery	:= .F.
	Local cQuery := ""
	Local cAliasSZ2 := ""

	Local cCampos := ""
	Local nX := 0
	Local nRecSC7	:= 0
	Local nRecSZ2	:= 0
	Local nRecTrb  := 0
	Local cChave	:= ""
	Local lConc := .F.

	Local oOk	:= LoadBitmap( GetResources(), "ENABLE"		)	//Nivel 1
	Local oN2	:= LoadBitmap( GetResources(), "BR_AZUL"	)	//Nivel 2
	Local oN3	:= LoadBitmap( GetResources(), "BR_PRETO"	)	//Nivel 3
	Local oN4	:= LoadBitmap( GetResources(), "BR_CINZA"	)	//Nivel 4
	Local oN5	:= LoadBitmap( GetResources(), "BR_AMARELO"	)	//Nivel 5
	Local oNo	:= LoadBitmap( GetResources(), "DISABLE"	)	//Nivel 6

	Local nScan := 0
	// Local lOk := nil
	Local aTab := {}
	Local lDup := .F.

	Local nNivel:= 6

	Aadd(aCores,oOk)
	Aadd(aCores,oN2)
	Aadd(aCores,oN3)
	Aadd(aCores,oN4)
	Aadd(aCores,oN5)
	Aadd(aCores,oNo)

//Array que conterao os registros lockados com o usuario
	Private aRLockSC7 := {}
	Private aRLocksSZ2 := {}

//Verifico se o parametro Vencto de/Ate nao esta vazio
	dDtIni	:= Max(dDtIni,Iif(Empty(mv_par04),dDtIni,mv_par04))
	dDtFin	:= Max(dDtFin,Iif(Empty(mv_par05),dDtFin,mv_par05))

	#IFDEF TOP
		If TcSrvType() == "AS/400"
			lQuery := .F.
		Else
			lQuery := .T.
		Endif
	#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	F260CRIARQ(@cArqRec1,@cArqRec2,@cArqRec3,@cArqRec4,@cArqRec5,@cArqRec6,@cArqRec7)

//Filtra dados do SZ2 - Conciliacao DDA
	If lQuery

		SZ2->(dbSetOrder(1)) //Filial+Fornecedor+Loja+Vencto+Titulo
		cChave		:= SZ2->(IndexKey())
		cAliasSZ2	:= GetNextAlias()
		aStru			:= SZ2->(dbStruct())
		cCampos		:= ""
		cFilIn 		:= F260Filial()

		aEval(aStru,{|x| cCampos += ","+AllTrim(x[1])})

		cQuery := "SELECT " + SubStr(cCampos,2) + ", R_E_C_N_O_ RECNOSZ2 "
		cQuery += "FROM " + RetSqlName("SZ2") + " SZ2 WHERE "
		cQuery +=      "Z2_FILIAL IN " + FormatIn(cFilIn,"/") + " AND "

		cQuery +=      "Z2_EMISSAO BETWEEN '"  + DTOS(dDtIni) + "' AND '" + DTOS(dDtFin) + "' AND "
		cQuery +=      "D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY " + SqlOrder(cChave)

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZ2,.T.,.T.)

		For nX :=  1 To Len(aStru)
			If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
				TcSetField(cAliasSZ2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX

	Else
		//CODEBASE
		cAliasSZ2 := "NEWSZ2"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra o SE5 por Banco/Ag./Cta                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Select(cAliasSZ2) == 0
			ChkFile("SZ2",.F.,cAliasSZ2)
		Else
			DbSelectArea(cAliasSZ2)
		EndIf
		DbSetOrder(1)
		cChave	:= IndexKey()
		cIndex	:= CriaTrab(nil,.f.)
		If mv_par01 == 1 // Considera filiais
			cQuery += "Z2_FILIAL >= '" + mv_par02 + "' .AND. "
			cQuery += "Z2_FILIAL <= '" + mv_par03 + "' .AND. "
		Else
			cQuery += "Z2_FILIAL == '" + xFilial("SZ2") + "' .AND. "
		EndIf

		cQuery += "Z2_EMISSAO >= '" + DTOS(dDtIni) + "' .AND. "
		cQuery += "Z2_EMISSAO <= '" + DTOS(dDtFin) + "' "

		IndRegua("NEWSZ2",cIndex,cChave,,cQuery, 'Selecionando Registros...') //"Selecionando Registros..."
		DbSelectArea("NEWSZ2")
		nIndexSz2 :=RetIndex("SZ2","NEWSZ2")
		#IFNDEF TOP
			dbSetIndex(cIndex+OrdBagExt())
		#ENDIF
		dbSetorder(1)
		dbGoTop()
	EndIf

	If (cAliasSZ2)->(Bof()) .or. (cAliasSZ2)->(Eof())
		Help(" ",1,"NORECSZ2",,'Nenhum registro SZ2 encontrado'+CHR(10)+'Por favor, verifique parametrização',1,0) //"Nenhum registro SZ2 encontrado"###"Por favor, verifique parametrização"
		lSaida := .T.
	Else

		While !((cAliasSZ2)->(Eof()))

			If !F260Verif(cAliasSZ2)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava dados no arquivo de trabalho³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("TRB")
				RecLock("TRB",.T.)

				cRecTRB := StrZero(TRB->(RecNo()))

				TRB->SEQMOV := SubStr(cRecTRB,-5)
				TRB->SEQCON := ""// (cAliasSZ2)->Z2_COLETA

				//------------------------------------------------------
				// Dados da Jogue Limpo (SZ2)
				//------------------------------------------------------
				TRB->CCO_SZ2 := (cAliasSZ2)->Z2_CCO
				TRB->CGC_SZ2 := (cAliasSZ2)->Z2_CGC
				TRB->NOME_SZ2 := (cAliasSZ2)->Z2_NOME
				TRB->LIT_SZ2 := (cAliasSZ2)->Z2_QUANT
				TRB->PLA_SZ2 := (cAliasSZ2)->Z2_PLACA
				TRB->DT_SZ2  := (cAliasSZ2)->Z2_EMISSAO

				//------------------------------------------------------
				// Controle
				//------------------------------------------------------
				TRB->REC_SZ2 := If(lQuery,;
					(cAliasSZ2)->RECNOSZ2,;
					(cAliasSZ2)->(RecNo()))

				TRB->OK := 6       // Não conciliado

				MsUnlock()
			Endif
			(cAliasSZ2)->(dbSkip())
		Enddo

	Endif


	//Filtra dados do SC7 - pedidos de compras
	If !lSaida

		//----------------------------------------------------------------------
		// Filtra dados do SC7 - Pedidos de Compra
		//----------------------------------------------------------------------

		If lQuery

			cAliasSC7 := GetNextAlias()
			aStru      := SC7->(dbStruct())
			cFilIn     := F260Filial()

			cQuery := ""

			cQuery += " SELECT "
			cQuery += "     SC7.C7_FILIAL, "
			cQuery += "     SC7.C7_NUM, "
			cQuery += "     SC7.C7_ITEM, "
			cQuery += "     SC7.C7_PRODUTO, "
			cQuery += "     SC7.C7_EMISSAO, "
			cQuery += "     SC7.C7_QUANT, "
			cQuery += "     SC7.C7_XDOCCO, "
			cQuery += "     SC7.C7_XPLACA, "
			cQuery += "     SC7.C7_FORNECE, "
			cQuery += "     SC7.C7_LOJA, "
			cQuery += "     SA2.A2_CGC, "
			cQuery += "     SA2.A2_NOME, "
			cQuery += "     SC7.R_E_C_N_O_ RECNOSC7 "

			cQuery += " FROM " + RetSqlName("SC7") + " SC7 "

			cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 "
			cQuery += "   ON SA2.D_E_L_E_T_ = ' ' "
			// cQuery += "    AND SA2.A2_FILIAL = SC7.C7_FILIAL "
			cQuery += "   AND SA2.A2_COD    = SC7.C7_FORNECE "
			cQuery += "   AND SA2.A2_LOJA   = SC7.C7_LOJA "

			cQuery += " WHERE "

			cQuery += " SC7.C7_XDOCCO <> ' ' AND "
			cQuery += " SC7.C7_FILIAL IN " + FormatIn(cFilIn,"/") + " AND "
			cQuery += " SC7.C7_EMISSAO BETWEEN '" + DTOS(dDtIni) + "' AND '" + DTOS(dDtFin) + "' AND "
			cQuery += " SC7.C7_PRODUTO BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' AND "

			cQuery += " SC7.D_E_L_E_T_ = ' ' "

			cQuery += " ORDER BY "
			cQuery += " SC7.C7_EMISSAO, "
			cQuery += " SC7.C7_NUM, "
			cQuery += " SC7.C7_ITEM "

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

			For nX := 1 To Len(aStru)

				If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0

					TcSetField(cAliasSC7,;
						aStru[nX][1],;
						aStru[nX][2],;
						aStru[nX][3],;
						aStru[nX][4])

				EndIf

			Next

		Else

			cAliasSC7 := "NEWSC7"

			If Select(cAliasSC7) == 0
				ChkFile("SC7",.F.,cAliasSC7)
			Else
				DbSelectArea(cAliasSC7)
			EndIf

			cIndex := CriaTrab(NIL,.F.)

			If mv_par01 == 1
				cQuery :=" SC7.C7_XDOCCO <> ' ' .AND. "
				cQuery := "C7_FILIAL >= '" + mv_par02 + "' .AND. "
				cQuery += "C7_FILIAL <= '" + mv_par03 + "' .AND. "

			Else

				cQuery := "C7_FILIAL == '" + xFilial("SC7") + "' .AND. "

			EndIf

			cQuery += "DTOS(C7_EMISSAO) >= '" + DTOS(dDtIni) + "' .AND. "
			cQuery += "DTOS(C7_EMISSAO) <= '" + DTOS(dDtFin) + "' .AND. "
			cQuery += "C7_PRODUTO >= '" + mv_par06 + "' .AND. "
			cQuery += "C7_PRODUTO <= '" + mv_par07 + "' .AND. "

			// cQuery += "D_E_L_E_T_ == ' ' "

			cChave := "C7_XDOCCO+C7_NUM+C7_ITEM"

			IndRegua("NEWSC7",;
				cIndex,;
				cChave,;
				,;
				cQuery,;
				"Selecionando Registros...")

			DbSelectArea("NEWSC7")

			nIndexSC7 := RetIndex("SC7","NEWSC7")

			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF

			dbSetOrder(nIndexSC7+1)
			dbGoTop()

		EndIf

		While !(cAliasSC7)->(Eof())

			//=========================================================
			// Guarda informações para localizar duplicidades
			//=========================================================

			aAdd(aTab,{ ;
				(cAliasSC7)->C7_FILIAL, ;
				(cAliasSC7)->C7_XDOCCO, ;
				(cAliasSC7)->A2_CGC, ;
				(cAliasSC7)->C7_QUANT, ;
				(cAliasSC7)->C7_XPLACA, ;
				Iif(lQuery,(cAliasSC7)->RECNOSC7,(cAliasSC7)->(Recno())) })

			(cAliasSC7)->(DbSkip())

		EndDo

		(cAliasSC7)->(DbGoTop())

		If (cAliasSC7)->(Bof()) .Or. (cAliasSC7)->(Eof())

			Help(" ",1,"NORECSC7",,;
				"Nenhum Pedido de Compra encontrado."+CRLF+;
				"Verifique os parâmetros.",1,0)

			lSaida := .T.

		Else

			DbSelectArea(cAliasSC7)

			While !(cAliasSC7)->(Eof())

				//-------------------------------------------------------
				// Grava registro da SC7 na TRB
				//-------------------------------------------------------

				DbSelectArea("TRB")

				RecLock("TRB",.T.)

				cRecTRB := StrZero(TRB->(Recno()))

				TRB->PED_SC7 := (cAliasSC7)->C7_NUM
				TRB->DT_SC7  := (cAliasSC7)->C7_EMISSAO
				TRB->CCO_SC7 := AllTrim((cAliasSC7)->C7_XDOCCO)
				TRB->CGC_SC7 := (cAliasSC7)->A2_CGC
				TRB->LIT_SC7 := (cAliasSC7)->C7_QUANT
				TRB->PLA_SC7 := AllTrim((cAliasSC7)->C7_XPLACA)

				TRB->REC_SC7 := If(lQuery,(cAliasSC7)->RECNOSC7,(cAliasSC7)->(Recno()))

				TRB->OK := 6

				MsUnlock()

				//-------------------------------------------------------
				// Variáveis auxiliares
				//-------------------------------------------------------

				cCCO     := TRB->CCO_SC7
				cCNPJ    := TRB->CGC_SC7
				nLitro   := TRB->LIT_SC7
				cPlaca   := TRB->PLA_SC7
				dEmissao := TRB->DT_SC7

				nRecSC7 := TRB->REC_SC7
				nRecTrb := TRB->(Recno())

				//-------------------------------------------------------
				// Verifica duplicidade da SC7
				//-------------------------------------------------------

				If ((nScan := aScan(aTab,{|x| ;
						x[1] == (cAliasSC7)->C7_FILIAL .And. ;
						x[2] == (cAliasSC7)->C7_XDOCCO .And. ;
						x[3] == (cAliasSC7)->A2_CGC .And. ;
						x[4] == (cAliasSC7)->C7_QUANT .And. ;
						x[5] == (cAliasSC7)->C7_XPLACA .And. ;
						x[6] <> If(lQuery,(cAliasSC7)->RECNOSC7,(cAliasSC7)->(Recno())) }))) > 0

					lDup := .T.

					(cAliasSC7)->(DbSkip())

					Loop

				EndIf

				//-------------------------------------------------------
				// A partir daqui entra a procura na SZ2
				//-------------------------------------------------------

				//------------------------------------------------------
				// Procura na SZ2
				//------------------------------------------------------


				DbSelectArea("TRB")
				DbSetOrder(1)          // Índice: CCO_SZ2

				nRecno := Recno()

				If DbSeek(cCCO)

					While !TRB->(Eof()) .And. alltrim(TRB->CCO_SZ2) == alltrim(cCCO)

						nNivel := 6

						//--------------------------------------------------
						// Nível 1
						// CCO + CNPJ + Litragem + Placa
						//--------------------------------------------------

						If ALLTRIM(TRB->CCO_SZ2) == ALLTRIM(cCCO) .And. TRB->CGC_SZ2 == cCNPJ .And. TRB->LIT_SZ2 == nLitro .And. TRB->PLA_SZ2 == cPlaca //.And. Empty(TRB->SEQCON)

							if !empty(posicione('SZ2',1,xFilial('SZ2')+TRB->CCO_SZ2,'SZ2->Z2_CONCJL'))
								nNivel := 1
							else
								nNivel := 5
							EndIf
							nRecno := Recno()
							Exit

							//--------------------------------------------------
							// Nível 2 BR_AZUL
							// CCO + CNPJ + Litragem
							//--------------------------------------------------

						ElseIf ALLTRIM(TRB->CCO_SZ2) == ALLTRIM(cCCO) .And. TRB->CGC_SZ2 == cCNPJ .And. TRB->LIT_SZ2 == nLitro //.And. Empty(TRB->SEQCON)

							nNivel := 2
							nRecno := Recno()
							Exit

							//--------------------------------------------------
							// Nível 3 BR_PRETO
							// CCO + CNPJ
							//--------------------------------------------------

						ElseIf ALLTRIM(TRB->CCO_SZ2) == ALLTRIM(cCCO) .And. TRB->CGC_SZ2 == cCNPJ //.And. Empty(TRB->SEQCON)

							nNivel := 3
							nRecno := Recno()
							Exit

							//--------------------------------------------------
							// Nível 4 BR_BRANCO
							// Somente CCO
							//--------------------------------------------------

						ElseIf ALLTRIM(TRB->CCO_SZ2) == ALLTRIM(cCCO) //.And. Empty(TRB->SEQCON)

							nNivel := 4
							nRecno := Recno()
							Exit

						EndIf

						DbSkip()

					EndDo

					//------------------------------------------------------
					// Encontrou possibilidade de conciliação
					//------------------------------------------------------

					If nNivel < 6

						If F260Lock(.T.,aRLockSC7,aRLocksSZ2,nRecSC7,TRB->REC_SZ2)

							DbGoTo(nRecTrb)

							DbDelete()

							DbGoTo(nRecno)

							RecLock("TRB")

							TRB->SEQCON := SubStr(cRecTRB,-5)

							TRB->PED_SC7 := (cAliasSC7)->C7_NUM
							TRB->DT_SC7  := (cAliasSC7)->C7_EMISSAO
							TRB->CCO_SC7 := (cAliasSC7)->C7_XDOCCO
							TRB->CGC_SC7 := (cAliasSC7)->A2_CGC
							TRB->LIT_SC7 := (cAliasSC7)->C7_QUANT
							TRB->PLA_SC7 := (cAliasSC7)->C7_XPLACA

							TRB->REC_SC7 := If(lQuery,(cAliasSC7)->RECNOSC7,(cAliasSC7)->(Recno()))

							TRB->OK := nNivel

							MsUnlock()

						EndIf

					EndIf

				EndIf

				(cAliasSC7)->(DbSkip())

			EndDo

			If lDup
				Alert("Existe mais de uma chave possivel para a conciliação automática, por este motivo a conciliação de alguns títulos deverá ser feita de forma manual.")
			EndIf

			DbSelectArea("TRB")
			DbSetOrder(7)        // SEQMOV+CCO_SZ2
			DbGoTop()

			//-----------------------------------------------------------
			// Calcula dimensões da janela
			//-----------------------------------------------------------
			aSize := MSADVSIZE()

			DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL
			oDlg:lMaximized := .T.

			// Painel inferior
			oPanel := TPanel():New( 0, 0, '', oDlg, , .T., .T., , , aSize[5], 45, .T., .T. )
			oPanel:Align := CONTROL_ALIGN_BOTTOM

			// Definições de tamanho e espaçamento
			nWidth  := 75   // largura dos botões
			nHeight := 20    // altura dos botões
			nSpace  := 10    // espaçamento entre eles
			nRight  := aSize[5]/3 + (100)   // posição inicial da direita (ajuste conforme largura do diálogo)


			nTopBut := 10
			oFont := TFont():New('Courier new',,-14,.T.)
			oSay1:= TSay():New(01,01,{||"Para "+iif(nOpx==1,"Conciliar","Desconciliar")+" apenas um registro basta um duplo clique, sobre a linha."},oPanel,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

			// Botão Fechar (último à direita)
			oBtnCancel := TButton():New( 10, nRight, "Fechar", oPanel, ;
				{|| nOpca := 0, oDlg:End()}, nWidth, nHeight, , , .F., .T., .F., , .F. )

			// Botão Legenda (à esquerda do Fechar)
			oBtnLeg := TButton():New( 10, nRight - (nWidth + nSpace), "Legenda", oPanel, ;
				{|| F260LEGTRB()}, nWidth, nHeight, , , .F., .T., .F., , .F. )

			// Botão Conciliar/Desconciliar (à esquerda da Legenda)
			if nopx == 1
				oBtnConfirm := TButton():New( 10, nRight - 2*(nWidth + nSpace), "Conciliar Tudo", oPanel, ;
					{|| nOpca := 1, oDlg:End()}, nWidth, nHeight, , , .F., .T., .F., , .F. )
			else
				oBtnConfirm := TButton():New( 10, nRight - 2*(nWidth + nSpace), "Desconciliar Tudo", oPanel, ;
					{|| nOpca := 1, oDlg:End()}, nWidth, nHeight, , , .F., .T., .F., , .F. )
			endif
			// DEFINE SBUTTON FROM 10,250 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oPanel
			// DEFINE SBUTTON FROM 10,280 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oPanel

			// DEFINE SBUTTON oBtn FROM 10,310 TYPE 15 ;
				// 	ACTION (F260Pesq(oTitulo)) ENABLE OF oPanel

			// DEFINE SBUTTON oBtn2 FROM 10,340 TYPE 11 ;
				// 	ACTION (F260LEGTRB()) ENABLE PIXEL OF oPanel

			// oBtn:cToolTip  := "Pesquisa"
			// oBtn:cCaption  := "Pesquisa"

			// oBtn2:cToolTip := "Legenda"
			// oBtn2:cCaption := "Legenda"

			oPanel:Align := CONTROL_ALIGN_BOTTOM

			@ 01.0,.5 LISTBOX oTitulo VAR cVarQ FIELDS ;
				HEADER "",;
				"Seq.",;
				"Dt.Coleta",;
				"CCO",;
				"CNPJ",;
				"Nome",;
				"Litragem",;
				"Placa",;
				"Pedido",;
				"Dt.Pedido",;
				"CCO",;
				"CNPJ",;
				"Litragem",;
				"Placa" ;
				COLSIZES ;
				12,;
				GetTextWidth(0,"SEQ"),;
				GetTextWidth(0,"99/99/9999"),;
				GetTextWidth(0,"000000000"),;
				GetTextWidth(0,"00.000.000/0000-00"),;
				GetTextWidth(0,"Fornecedor Jogue Limpo"),;
				GetTextWidth(0,"999.999,999"),;
				GetTextWidth(0,"ABC1D23"),;
				GetTextWidth(0,"999999"),;
				GetTextWidth(0,"99/99/9999"),;
				GetTextWidth(0,"000000000"),;
				GetTextWidth(0,"00.000.000/0000-00"),;
				GetTextWidth(0,"999.999,999"),;
				GetTextWidth(0,"ABC1D23") ;
				SIZE 345,400 ;
				ON DBLCLICK (F260Marca(oTitulo,nOpx),oTitulo:Refresh()) ;
				NOSCROLL

			oTitulo:bLine := {|| { ;
				aCores[TRB->OK],;
				TRB->SEQMOV,;
				TRB->DT_SZ2,;
				TRB->CCO_SZ2,;
				TRB->CGC_SZ2,;
				TRB->NOME_SZ2,;
				Transform(TRB->LIT_SZ2,"@E 999,999.999"),;
				TRB->PLA_SZ2,;
				TRB->PED_SC7,;
				TRB->DT_SC7,;
				TRB->CCO_SC7,;
				TRB->CGC_SC7,;
				Transform(TRB->LIT_SC7,"@E 999,999.999"),;
				TRB->PLA_SC7 ;
				}}

			oTitulo:Align := CONTROL_ALIGN_ALLCLIENT

			ACTIVATE MSDIALOG oDlg CENTERED


			If nOpca == 1

				BEGIN TRANSACTION

					DbSelectArea("TRB")
					DbGoTop()

					While !TRB->(Eof())

						nRecSC7 := TRB->REC_SC7
						nRecSZ2 := TRB->REC_SZ2

						// Houve conciliação ou cancelamento de conciliação, então atualiza os registros do SC7 e SZ2
						// nOpx == 1 è conciliação, então verrifico se os campos estão vazios para poder  conciliar.
						// nOpx == 2 è Canlear conciliação, então verrifico se os campos não estão vazios para poder cancelar.
						DbSelectArea("SC7")
						SC7->(dbSetOrder(1))
						SC7->(dbGoto(nRecSC7))

						DbSelectArea("SZ2")
						SZ2->(dbGoto(nRecSZ2))

						lVal := iif(nOpx==1,(empty(SC7->C7_XCONCJL) .and. Empty(SZ2->Z2_CONCJL)),(!empty(SC7->C7_XCONCJL) .and. !Empty(SZ2->Z2_CONCJL)))
						If (nRecSC7 > 0 .And. nRecSZ2 > 0) .and. lVal

							//----------------------------------------------------
							// Atualiza Pedido de Compra (SC7)
							//----------------------------------------------------

							if nOpx == 1
								xConc := cValToChar(YEAR(DATE()))+cValToChar(DAY(DATE()))
								cMSG := "Conciliação automática realizada com sucesso!"
							else
								cMSG := "Cancelamento de conciliação realizado com sucesso!"
								xConc := ""
							endif

							DbSelectArea("SC7")
							SC7->(dbSetOrder(1))
							SC7->(dbGoto(nRecSC7))
							If RecLock("SC7",.F.)
								// Exemplo
								SC7->C7_XCONCJL  := xConc
								MsUnlock()
							EndIf

							//----------------------------------------------------
							// Atualiza SZ2
							//----------------------------------------------------

							DbSelectArea("SZ2")
							SZ2->(dbGoto(nRecSZ2))
							If RecLock("SZ2",.F.)
								// Exemplo
								SZ2->Z2_CONCJL := xConc
								lConc := .T.
								MsUnlock()

							EndIf
						else
							if !lConc // se não houve conciliação ou cancelamento
								if nOpx == 1
									cMSG := "Não registro para conciliar!"
								else
									cMSG := "Não registros para cancelar a conciliação!"
								endif
							endif
						EndIf

						DbSelectArea("TRB")
						DbSkip()
					EndDo
				END TRANSACTION

				If lConc
					FWAlertSuccess(cMSG, 'SUCCESS!')
				Else
					FwAlertWarning(cMsg,'WARNING!')
				EndIf
			EndIf
		EndIf
	EndIf

	//Destravar os registros do SC7 e SZ2 antes de sair
	F260Lock(.F.,aRLockSC7,aRLocksSZ2,,,,.T.)

	//Finalizar o arquivo de trabalho
	dbSelectArea("TRB")
	Set Filter To
	dbCloseArea()
	Ferase(cArqRec1+ GetDBExtension())
	Ferase(cArqRec1+OrdBagExt())
	Ferase(cArqRec2+OrdBagExt())
	Ferase(cArqRec3+OrdBagExt())
	Ferase(cArqRec4+OrdBagExt())
	Ferase(cArqRec5+OrdBagExt())
	Ferase(cArqRec6+OrdBagExt())
	Ferase(cArqRec7+OrdBagExt())
	IF SELECT("NEWSZ2") != 0
		dbSelectArea( "NEWSZ2" )
		dbCloseArea()
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
	ENDIF
	IF SELECT("NEWSC7") != 0
		dbSelectArea( "NEWSC7" )
		dbCloseArea()
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
	ENDIF

	dbSelectArea("SZ2")
	dbSetOrder(1)

Return .T.

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³F260CriArq³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 01/10/09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³Cria Estrutura do arquivo de trabalho   						  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe	 ³F260CriArq() 															  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Nome do indice 1 (passado por referenc)				  ³±±
	±±³			 ³ ExpC2 = Nome do indice 2 (passado por referenc)				  ³±±
	±±³			 ³ ExpC3 = Nome do indice 3 (passado por referenc)				  ³±±
	±±³			 ³ ExpC4 = Nome do indice 4 (passado por referenc)				  ³±±
	±±³			 ³ ExpC5 = Nome do indice 5 (passado por referenc)				  ³±±
	±±³			 ³ ExpC6 = Nome do indice 6 (passado por referenc)				  ³±±
	±±³			 ³ ExpC7 = Nome do indice 7 (passado por referenc)				  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³Generico																	  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F260CriArq(cArqRec1,cArqRec2,cArqRec3,cArqRec4,cArqRec5,cArqRec6,cArqRec7)

	Local aDbStru := {}

	Local nTamCCO   := TamSX3("Z2_CCO")[1]
	Local nTamCGC   := TamSX3("Z2_CGC")[1]
	Local nTamNome  := TamSX3("Z2_NOME")[1]
	Local nTamPlaca := TamSX3("Z2_PLACA")[1]
	Local nTamPed   := TamSX3("C7_NUM")[1]

	//---------------------------------------------------------
	// Controle
	//---------------------------------------------------------

	AAdd(aDbStru,{"SEQMOV" ,"C",05,0})
	AAdd(aDbStru,{"SEQCON" ,"C",05,0})

	//---------------------------------------------------------
	// Campos da SZ2 (Jogue Limpo)
	//---------------------------------------------------------

	AAdd(aDbStru,{"DT_SZ2"   ,"D",08,0})
	AAdd(aDbStru,{"CCO_SZ2"  ,"C",nTamCCO,0})
	AAdd(aDbStru,{"CGC_SZ2"  ,"C",nTamCGC,0})
	AAdd(aDbStru,{"NOME_SZ2" ,"C",nTamNome,0})
	AAdd(aDbStru,{"LIT_SZ2"  ,"N",15,3})
	AAdd(aDbStru,{"PLA_SZ2"  ,"C",nTamPlaca,0})

	//---------------------------------------------------------
	// Campos do SC7
	//---------------------------------------------------------

	AAdd(aDbStru,{"PED_SC7" ,"C",nTamPed,0})
	AAdd(aDbStru,{"DT_SC7"  ,"D",08,0})
	AAdd(aDbStru,{"CCO_SC7" ,"C",09,0})                 // C7_XDOCCO
	AAdd(aDbStru,{"CGC_SC7" ,"C",14,0})                 // A2_CGC
	AAdd(aDbStru,{"LIT_SC7" ,"N",15,3})
	AAdd(aDbStru,{"PLA_SC7" ,"C",08,0})                 // C7_XPLACA

	//---------------------------------------------------------
	// Auxiliares
	//---------------------------------------------------------

	AAdd(aDbStru,{"REC_SZ2" ,"N",09,0})
	AAdd(aDbStru,{"REC_SC7" ,"N",09,0})
	AAdd(aDbStru,{"OK"      ,"N",01,0})

	//---------------------------------------------------------
	// Chaves para pesquisa
	//---------------------------------------------------------

	AAdd(aDbStru,{"KEY_SZ2","C",60,0})
	AAdd(aDbStru,{"KEY_SC7","C",60,0})

	//---------------------------------------------------------

	cArqRec1 := CriaTrab(aDbStru,.T.)
	cArqRec2 := Left(CriaTrab(NIL,.F.),7)+"A"
	cArqRec3 := Left(CriaTrab(NIL,.F.),7)+"B"
	cArqRec4 := Left(CriaTrab(NIL,.F.),7)+"C"
	cArqRec5 := Left(CriaTrab(NIL,.F.),7)+"D"
	cArqRec6 := Left(CriaTrab(NIL,.F.),7)+"E"
	cArqRec7 := Left(CriaTrab(NIL,.F.),7)+"F"

	dbUseArea(.T.,,cArqRec1,"TRB",.F.,.F.)

	//---------------------------------------------------------
	// Índices SZ2
	//---------------------------------------------------------

	IndRegua("TRB",cArqRec1,"CCO_SZ2+CGC_SZ2+DTOS(DT_SZ2)",,,;
		"Selecionando Registros...")

	IndRegua("TRB",cArqRec2,"CCO_SZ2+PLA_SZ2",,,;
		"Selecionando Registros...")

	IndRegua("TRB",cArqRec3,"KEY_SZ2",,,;
		"Selecionando Registros...")

	//---------------------------------------------------------
	// Índices SC7
	//---------------------------------------------------------

	IndRegua("TRB",cArqRec4,"CCO_SC7+CGC_SC7+DTOS(DT_SC7)",,,;
		"Selecionando Registros...")

	IndRegua("TRB",cArqRec5,"CCO_SC7+PLA_SC7",,,;
		"Selecionando Registros...")

	IndRegua("TRB",cArqRec6,"KEY_SC7",,,;
		"Selecionando Registros...")

	//---------------------------------------------------------
	// Índice Geral
	//---------------------------------------------------------

	IndRegua("TRB",cArqRec7,"SEQMOV+KEY_SZ2+KEY_SC7",,,;
		"Selecionando Registros...")

	DbClearIndex()

	DbSetIndex(cArqRec1 + OrdBagExt())
	DbSetIndex(cArqRec2 + OrdBagExt())
	DbSetIndex(cArqRec3 + OrdBagExt())
	DbSetIndex(cArqRec4 + OrdBagExt())
	DbSetIndex(cArqRec5 + OrdBagExt())
	DbSetIndex(cArqRec6 + OrdBagExt())
	DbSetIndex(cArqRec7 + OrdBagExt())

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F260Marca ³ Autor ³ Mauricio Pequim Jr	  ³ Data ³ 02/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Troca o flag para marcado ou nao,aceitando valor.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto da ListBox da conciliacao DDA   				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ F260Marca 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F260Marca(oTitulo,nOpx)

	Local oDlg1
	Local lRet      := .T.
	Local lIsSZ2    := .F.
	Local lIsSC7    := .F.
	Local nOpca1    := 0
	Local nSequen   := 0

	Local nRecSC7   := 0
	Local nRecSZ2   := 0
	Local nRecOrig  := 0

	// Local cSeqMov   := ""

	Local cCCO      := ""
	Local cCGC      := ""
	Local nLitros   := 0
	Local cPlaca    := ""
	Local dData     := Ctod("")

	Local cPedido   := ""

	Local nReconc := TRB->OK

	If nReconc == 6 .Or. nReconc == 5

		// se a função for de desconciliação
		if nOpx == 2
			Return .F.
		endif

		DEFINE MSDIALOG oDlg1 FROM 69,70 TO 160,331 TITLE "Conciliação Jogue Limpo" PIXEL

		@ 0,2 TO 22,165 OF oDlg1 PIXEL

		@ 7,98 MSGET nSequen ;
			PICTURE "99999" ;
			VALID (nSequen > 0 .And. nSequen <= TRB->(RecCount())) ;
			SIZE 20,10 OF oDlg1 PIXEL

		@ 8,8 SAY "Sequência a Conciliar" SIZE 90,7 OF oDlg1 PIXEL

		DEFINE SBUTTON FROM 29,71 TYPE 1 ;
			ACTION ( nOpca1:=1 ,;
			IIf(nSequen>0 .And. nSequen<=TRB->(RecCount()),oDlg1:End(),nOpca1:=0) ) ;
			ENABLE OF oDlg1

		DEFINE SBUTTON FROM 29,99 TYPE 2 ;
			ACTION oDlg1:End() ;
			ENABLE OF oDlg1

		ACTIVATE MSDIALOG oDlg1 CENTERED

		If nOpca1 == 1

			//----------------------------------------------------
			// Registro original
			//----------------------------------------------------

			nRecOrig := TRB->(RecNo())

			//----------------------------------------------------
			// Descobre de qual tabela partiu
			//----------------------------------------------------

			If TRB->REC_SZ2 > 0

				lIsSZ2 := .T.

				cCCO    := TRB->CCO_SZ2
				cCGC    := TRB->CGC_SZ2
				nLitros := TRB->LIT_SZ2
				cPlaca  := TRB->PLA_SZ2
				dData   := TRB->DT_SZ2

				nRecSZ2 := TRB->REC_SZ2

			endIf

			If TRB->REC_SC7 > 0

				lIsSC7 := .T.

				cPedido := TRB->PED_SC7
				cCCO    := TRB->CCO_SC7
				cCGC    := TRB->CGC_SC7
				nLitros := TRB->LIT_SC7
				cPlaca  := TRB->PLA_SC7
				dData   := TRB->DT_SC7

				nRecSC7 := TRB->REC_SC7

			EndIf

			//----------------------------------------------------
			// Vai para o registro escolhido
			//----------------------------------------------------

			DbSelectArea("TRB")
			DbGoto(nSequen)

			If lIsSZ2 .AND. lIsSC7

				nRecSC7 := TRB->REC_SC7
				nRecSZ2 := TRB->REC_SZ2


				//----------------------------------------------------
				// Registro já conciliado
				//----------------------------------------------------

				If TRB->OK == 1

					Help(" ",1,"JACONCIL",,;
						"Tentativa de conciliar com movimento já conciliado",1,0)

					DbGoto(nRecOrig)

					oTitulo:Refresh()

					Return .F.

				EndIf

				//----------------------------------------------------
				// Não permite SZ2 x SZ2 ou SC7 x SC7
				//----------------------------------------------------

				If lIsSZ2 .And. !lIsSC7

					Help(" ",1,"NOCONC",,;
						"Selecione um Pedido do Protheus.",1,0)

					DbGoto(nRecOrig)

					oTitulo:Refresh()

					Return .F.

				EndIf

				If lIsSC7 .And. !lIsSZ2

					Help(" ",1,"NOCONC",,;
						"Selecione uma Coleta da Jogue Limpo.",1,0)

					DbGoto(nRecOrig)

					oTitulo:Refresh()

					Return .F.

				EndIf

				//----------------------------------------------------
				// Tenta travar os dois registros
				//----------------------------------------------------

				If F260Lock(.T.,;
						aRLockSC7,;
						aRLocksSZ2,;
						nRecSC7,;
						nRecSZ2,;
						.T.)
					//--------------------------------------------------------
					// Validação do CCO
					//--------------------------------------------------------

					If AllTrim(TRB->CCO_SC7) <> AllTrim(TRB->CCO_SZ2)

						Help(" ",1,"NOCCO",,;
							"Os CCOs são diferentes.",1,0)

						F260Lock(.F.,aRLockSC7,aRLocksSZ2,nRecSC7,nRecSZ2)

						DbGoto(nRecOrig)

						oTitulo:Refresh()

						Return .F.

					EndIf


					//--------------------------------------------------------
					// Validação do CNPJ
					//--------------------------------------------------------

					If AllTrim(TRB->CGC_SC7) <> AllTrim(TRB->CGC_SZ2)

						Help(" ",1,"NOCGC",,;
							"Os CNPJs são diferentes.",1,0)

						F260Lock(.F.,aRLockSC7,aRLocksSZ2,nRecSC7,nRecSZ2)

						DbGoto(nRecOrig)

						oTitulo:Refresh()

						Return .F.

					EndIf


					//--------------------------------------------------------
					// Validação da Placa
					//--------------------------------------------------------

					If Upper(AllTrim(TRB->PLA_SC7)) <> Upper(AllTrim(TRB->PLA_SZ2))

						Help(" ",1,"NOPLACA",,;
							"As placas são diferentes.",1,0)

						F260Lock(.F.,aRLockSC7,aRLocksSZ2,nRecSC7,nRecSZ2)

						DbGoto(nRecOrig)

						oTitulo:Refresh()

						Return .F.

					EndIf


					//--------------------------------------------------------
					// Validação da Quantidade
					//--------------------------------------------------------

					If TRB->LIT_SC7 <> TRB->LIT_SC7

						Help(" ",1,"NOLITRO",,;
							"As litragems são diferentes.",1,0)

						F260Lock(.F.,aRLockSC7,aRLocksSZ2,nRecSC7,nRecSZ2)

						DbGoto(nRecOrig)

						oTitulo:Refresh()

						Return .F.

					EndIf


					//--------------------------------------------------------
					// Conciliação Manual
					//--------------------------------------------------------

					If lIsSZ2 .and. lIsSC7

						xConc := cValToChar(YEAR(DATE()))+cValToChar(DAY(DATE()))

						//----------------------------------------------------
						// Registro escolhido é SC7
						//----------------------------------------------------

						DbSelectArea("TRB")

						DbGoto(nRecOrig)

						RecLock("TRB")
						TRB->OK := 1
						MsUnlock()

						DbSelectArea("SC7")
						SC7->(dbSetOrder(1))
						SC7->(dbGoto(nRecSC7))
						If RecLock("SC7",.F.)
							// Exemplo
							SC7->C7_XCONCJL  := xConc
							MsUnlock()
						EndIf

						//----------------------------------------------------
						// Atualiza SZ2
						//----------------------------------------------------

						DbSelectArea("SZ2")
						SZ2->(dbGoto(nRecSZ2))
						If RecLock("SZ2",.F.)
							// Exemplo
							SZ2->Z2_CONCJL := xConc
							MsUnlock()
						EndIf
					EndIf
					// If lIsSZ2

					// 	//----------------------------------------------------
					// 	// Registro escolhido é SC7
					// 	//----------------------------------------------------

					// 	cPedido := TRB->PED_SC7

					// 	DbSelectArea("TRB")

					// 	// DbDelete()

					// 	DbGoto(nRecOrig)

					// 	RecLock("TRB")

					// TRB->SEQCON := cSeqMov

					// TRB->PED_SC7 := cPedido
					// TRB->DT_SC7  := TRB->DT_SC7
					// TRB->CCO_SC7 := TRB->CCO_SC7
					// TRB->CGC_SC7 := TRB->CGC_SC7
					// TRB->LIT_SC7 := TRB->LIT_SC7
					// TRB->PLA_SC7 := TRB->PLA_SC7

					// TRB->REC_SC7 := nRecSC7
					// 	TRB->OK := 1
					// 	MsUnlock()
					// Else

					// 	//----------------------------------------------------
					// 	// Registro escolhido é SZ2
					// 	//----------------------------------------------------

					// 	RecLock("TRB")

					// 	TRB->SEQCON := cSeqMov

					// 	TRB->DT_SZ2   := dData
					// 	TRB->CCO_SZ2  := cCCO
					// 	TRB->CGC_SZ2  := cCGC
					// 	TRB->NOME_SZ2 := TRB->NOME_SZ2
					// 	TRB->LIT_SZ2  := nLitros
					// 	TRB->PLA_SZ2  := cPlaca

					// 	TRB->REC_SZ2 := nRecSZ2

					// 	TRB->OK := 1

					// 	MsUnlock()

					// 	DbGoto(nRecOrig)

					// 	// DbDelete()

					// 	MsUnlock()

				EndIf

				oTitulo:Refresh()

				Return .T.

			EndIf
		EndIf

	Else

		// se a função for de conciliação
		if nOpx == 2
			Return .F.
		endif

		DEFINE MSDIALOG oDlg1 FROM 69,70 TO 165,331 ;
			TITLE "Cancelar Conciliação" PIXEL

		@ 0,2 TO 28,128 OF oDlg1 PIXEL

		@ 7,9 SAY "Esta movimentação já se encontra conciliada." ;
			SIZE 115,7 OF oDlg1 PIXEL

		@ 14,9 SAY "Deseja cancelar a conciliação ?" ;
			SIZE 100,7 OF oDlg1 PIXEL

		DEFINE SBUTTON FROM 32,71 TYPE 1 ;
			ACTION (nOpca1:=1,oDlg1:End()) ;
			ENABLE OF oDlg1

		DEFINE SBUTTON FROM 32,99 TYPE 2 ;
			ACTION (oDlg1:End()) ;
			ENABLE OF oDlg1

		ACTIVATE MSDIALOG oDlg1 CENTERED

		If nOpca1 == 1

			nRecOrig := Val(TRB->SEQMOV)
			nSeqSC7  := Val(TRB->SEQCON)

			nRecSC7 := TRB->REC_SC7
			nRecSZ2 := TRB->REC_SZ2

			//--------------------------------------------------
			// Limpa os dados do SC7 conciliado
			//--------------------------------------------------

			DbSelectArea("SC7")
			SC7->(dbSetOrder(1))

			IF SC7->(DBSEEK(XFILIAL('SC7')+TRB->PED_SC7))
				If RecLock("SC7",.F.)
					SC7->C7_XCONCJL := Space(Len(SC7->C7_XCONCJL))
					SC7->(MsUnlock())
				EndIf
			EndIf

			DbSelectArea("SZ2")
			SZ2->(dbSetOrder(1))
			IF SZ2->(DBSEEK(XFILIAL('SC7')+SC7->C7_XDOCCO))
				If RecLock("SZ2",.F.)
					SZ2->Z2_CONCJL := Space(Len(SZ2->Z2_CONCJL))
					SZ2->(MsUnlock())
				ENdIf
			EndIf

			DbSelectArea("TRB")
			DbGoTo(nRecOrig)
			If RecLock("TRB",.F.)
				TRB->OK      := 5
				TRB->(MsUnlock())
			EndIf

			//--------------------------------------------------
			// Libera os locks
			//--------------------------------------------------

			F260Lock(.F.,;
				aRLockSC7,;
				aRLocksSZ2,;
				nRecSC7,;
				nRecSZ2)

		EndIf

	EndIf

	oTitulo:Refresh()

Return lRet


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o	 ³F260Alte  ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03/10/09 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Programa de Alteracao da Conciliacao DDA   					  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe	 ³ F260Alte(ExpC1,ExpN1,ExpN2)										  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Alias do arquivo											  ³±±
	±±³			 ³ ExpN1 = Numero do registro 										  ³±±
	±±³			 ³ ExpN2 = Numero da opcao selecionada 							  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// User Function F260Alte(cAlias,nReg,nOpc)

// 	Local aCpos	:= {}
// 	Local cTudoOK := ".T."

// 	If FIG->( EOF()) .or. xFilial("FIG") # FIG->FIG_FILIAL
// 		Help(" ",1,"ARQVAZIO")
// 		Return .T.
// 	Endif

// 	If !F260Verif()
// 		Help(" ",1,"NOALTER",,'Este registro não permite alterações. Apenas titulos com dados a verificar podem sofrer alteração. Vide Legenda.',1,0)
// 		Return .T.
// 	Endif

// 	Aadd(aCpos,"FIG_FORNEC")
// 	Aadd(aCpos,"FIG_LOJA")
// 	Aadd(aCpos,"FIG_NOMFOR")
// 	Aadd(aCpos,"FIG_CODBAR")
// 	Aadd(aCpos,"FIG_TITULO")
// 	Aadd(aCpos,"FIG_VENCTO")

// 	lAltera:=.T.

// 	nOpca := AxAltera(cAlias,nReg,nOpc,,aCpos,4,,cTudoOK)

// Return

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³F260Pesq  ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³04.10.09  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Tela de pesquisa           										  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpO1 = Objeto da ListBox da conciliacao DDA   				  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Generico 																  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F260Pesq(oTitulo)

	Local nRecno		:= 0
	Local aPesqui		:={}
	Local cSeek			:= ""
	Local nIndex		:= 1

	dbSelectArea("TRB")
	nRecno	:= Recno()
	nIndex	:= IndexOrd()

	aAdd(aPesqui,{'Fornecedor DDA + Loja DDA + Vencto. DDA + Titulo DDA',1})
	aAdd(aPesqui,{'Fornecedor DDA + Loja DDA + Titulo DDA + Vencto. DDA',2})
	aAdd(aPesqui,{'Titulo DDA',3})
	aAdd(aPesqui,{'Fornecedor SE2 + Loja SE2 + Vencto. SE2 + Titulo SE2',4})
	aAdd(aPesqui,{'Fornecedor SE2 + Loja SE2 + Titulo SE2 + Vencto. SE2',5})
	aAdd(aPesqui,{'Titulo SE2',6})

	WndxPesqui(,aPesqui,cSeek,.F.)

	dbSelectArea("TRB")
	dbSetOrder(nIndex)

//Caso não tenha achado, volto para o registro de partida
	IF TRB->(EOF())
		TRB->(dbgoto(nRecno))
	Endif

	oTitulo:Refresh()

Return Nil


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³FA260Leg()³ Autor ³ Mauricio Pequim Jr.   ³ Data ³04.10.09  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Tela de Legenda - Browse   										  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpN1 = Recno do registro posicionado no browse				  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Generico 																  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FA260Leg(nReg)

	Local uRetorno := {}
	Local aLegBrw := {}

	Aadd(aLegBrw, {"ENABLE" , 'SZ2 Conciliado'})			//"SZ2 Conciliado"
	Aadd(aLegBrw, {"BR_VERMELHO", 'SZ2 Não Conciliado'})	//"SZ2 Não Conciliado"
	// Aadd(aLegBrw, {"BR_AMARELO",'SZ2 Verificar dados'})	//"SZ2 Verificar dados"


	If nReg = Nil	// Chamada direta da funcao onde nao passa, via menu Recno eh passado
		uRetorno := {}

		Aadd(uRetorno, { '!EMPTY(SZ2->Z2_CONCJL)'	, aLegBrw[1][1] } )
		Aadd(uRetorno, { 'EMPTY(SZ2->Z2_CONCJL)'	, aLegBrw[2][1] } )
		// Aadd(uRetorno, { 'F260VERIF()'				, aLegBrw[3][1] } )

	Else

		BrwLegenda(cCadastro, "Legenda", aLegBrw)
	Endif
Return uRetorno


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³F260LegTrb³ Autor ³ Mauricio Pequim Jr.   ³ Data ³04.10.09  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Tela de Legenda - Tela Conciliacao								  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ 																			  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Generico 																  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F260LegTrb()

	Local aLegConc := {}
	Local nY     	:= 0
	Local nX     	:= 0
	Local aBmp[9]
	// Local aSays[9]
	Local oDlgLeg

	Aadd(aLegConc, {"ENABLE"		, 'Conciliado: CCO OK + CNPJ OK + Litragem + Placa OK'})	//"Conciliado: CCO OK + CNPJ OK + Litragem OK Placa OK"
	Aadd(aLegConc, {"BR_AZUL"		, 'Adverg. Placa: CCO OK + CNPJ OK + Litragem OK Placa IN'})	//"Conciliado: CCO OK + CNPJ OK + Litragem OK Placa IN"
	Aadd(aLegConc, {"BR_PRETO"		, 'Adv. Litr. e Placa: CCO OK + CNPJ OK + Litragem IN Placa IN'})	//"Conciliado: CCO OK + CNPJ OK + Litragem IN Placa IN"
	Aadd(aLegConc, {"BR_BRANCO"		, 'Adv.CNPJ, Litr. e Placa: CCO OK + CNPJ IN + Litragem IN Placa IN'})	//"Conciliado: CCO OK + CNPJ IN + Litragem IN Placa IN"
	Aadd(aLegConc, {"BR_AMARELO"	, 'Ag. Conciliacao: CCO OK + CNPJ OK + Litragem OK Placa OK'})	//"Conciliado: CCO OK + CNPJ OK + Litragem OK Placa OK"

	Aadd(aLegConc, {"DISABLE"		, 'Não Conciliado'})	//"Não Conciliado"

	DEFINE MSDIALOG oDlgLeg FROM 0,0 TO (Len(aLegConc)*20)+110, 500 TITLE cCadastro OF oMainWnd PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ä Ä Ä Ä Ä Ä Ä Ä¿
	//³No onclick do usuario a tela sera fechada³
	//À Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Ä Á
	oDlgLeg:bLClicked:= {||oDlgLeg:End()}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fonte especifico para a descricao das legendas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	DEFINE FONT oBold2 NAME "Arial" SIZE 0, -11 BOLD

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Desenho de fundo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 0, 0 BITMAP RESNAME "PROJETOAP" OF oDlgLeg SIZE 35,155 NOBORDER WHEN .F. PIXEL

	@ 11,35 TO 013,400 LABEL '' OF oDlgLeg PIXEL
	@ 03,37 SAY 'Legenda' OF oDlgLeg PIXEL SIZE 150,009 FONT oBold		//"Legenda"
	For nX := 1 to Len(aLegConc)
		@ 20+((nX-1)*10),43 BITMAP aBmp[nX] RESNAME aLegConc[nX][1] OF oDlgLeg SIZE 20,10 PIXEL NOBORDER
		@ 20+((nX-1)*10),53 SAY If((nY+=1)==nY,aLegConc[nY][2]+If(nY==Len(aLegConc),If((nY:=0)==nY,"",""),""),"") OF oDlgLeg PIXEL
	Next nX
	nY := 0
	@ 120,37 SAY 'OK - Valor Exato' OF oDlgLeg PIXEL SIZE 150,009 FONT oBold2 		//"OK - Valor Exato"
	@ 130,37 SAY 'IN - Valor dentro do intervalo definido' OF oDlgLeg PIXEL SIZE 150,009 FONT oBold2 		//"IN - Valor dentro do intervalo definido"

	ACTIVATE MSDIALOG oDlgLeg CENTERED

Return(NIL)

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³F260Verif ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³04.10.09  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Verificacao de status do registro DDA com necessidade de   ³±±
	±±³          ³ de verificacao de dados                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpC1 = Alias do SZ2 (arquivo de dados DDA)					  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ä Ä Ä Ä Ä Ä Ä Ä Á
	±±³ Uso		 ³ Generico 																  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F260Verif(cAliasSZ2)

	Local lRet := .F.

	DEFAULT cAliasSZ2 := "SZ2"

	If Empty((cAliasSZ2)->Z2_CCO)    .Or. ;
			Empty((cAliasSZ2)->Z2_CGC)    .Or. ;
			Empty((cAliasSZ2)->Z2_QUANT)  .Or. ;
			Empty((cAliasSZ2)->Z2_PLACA)  .Or. ;
			Empty((cAliasSZ2)->Z2_EMISSAO)

		lRet := .T.

	EndIf

Return lRet

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³F260Filial³ Autor ³ Mauricio Pequim Jr.   ³ Data ³04.10.09  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Montagem da String de filiais a serem utilizadas no 		  ³±±
	±±³          ³ processo de filtragem dados - TOP                          ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                            					  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Generico 																  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F260Filial()
	Local cFilIn	:= ""
	Local nInc		:= 0
	Local aSM0 		:= AdmAbreSM0()

//Considero filiais do intervalo e arquivos exclusivos
	If mv_par01 == 1 .and. !Empty(xFilial("SZ2"))
		//Arquivos Exclusivos
		For nInc := 1 To Len( aSM0 )
			If aSM0[nInc][2] >= mv_par02 .and. aSM0[nInc][2] <= mv_par03
				cFilIn += aSM0[nInc][2] + "/"
			EndIf
		Next
	Else
		cFilIn := xFilial("SZ2")
	Endif

Return cFilIn


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o	 ³F260Lock  ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³04.10.09  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Funcao para controle de travamento e destravamento dos     ³±±
	±±³          ³ registros utilizados por um determinado usuario            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpL1 = Rotina para travamento dos registros do SE2 e FIG  ³±±
	±±³          ³ ExpA2 = Array p/ guardar registros SE2 em uso pelo usuario ³±±
	±±³          ³ ExpA3 = Array p/ guardar registros FIG em uso pelo usuario ³±±
	±±³          ³ ExpN4 = Numero do registro do SE2 que se quer travar       ³±±
	±±³          ³ ExpN5 = Numero do registro do FIG que se quer travar       ³±±
	±±³          ³ ExpL6 = Mostra Help em caso de nao travamento do registro  ³±±
	±±³          ³ ExpL7 = Destravamento de todos os registros                ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Generico 																  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function F260Lock(lLock,aRLockSC7,aRLocksSZ2,nRecnoSC7,nRecnoSZ2,lHelp,lTodos)

	Local aArea	:= GetArea()
	Local nPosRec
	Local lSc7	:= .F.
	Local lSZ2	:= .F.
	Local lRet	:= .F.

	DEFAULT lLock := .F.		//Travamento ou destravamento dos registros
	DEFAULT lHelp := .F.		//Mostra help ou nao
	DEFAULT lTodos:= .F.		//Libera todos os registros
	DEFAULT aRLockSC7:={}	//Array de registros do SC7 lockados com o usuario
	DEFAULT aRLocksSZ2:={}	//Array de registros do SZ2 lockados com o usuario

	If lTodos
		//Destrava todos os registros - Final do processamento
		AEval(aRLockSC7,{|x,y| SC7->(MsRUnlock(x))})
		aRLockSC7:={}

		AEval(aRLocksSZ2,{|x,y| SZ2->(MsRUnlock(x))})
		aRLocksSZ2:={}

	Else
		//Controle de marcacao ou desmarcaao dos titulos
		If nRecnoSC7 <> Nil
			SC7->(MsGoto(nRecnoSC7))
			lSc7	:= .T.
		Endif

		If nRecnoSZ2 <> Nil
			SZ2->(MsGoto(nRecnoSZ2))
			lSZ2	:= .T.
		Endif

		If lLock //Rotina chamada para travamento dos registros do SC7 e SZ2

			//A conciliacao somente sera permitida quando os registros do SC7 e SZ2 puderem ser travados
			//Caso um deles esteja em uso por outro terminal, nao sera permitida a conciliacao
			If lSc7 .and. lSZ2
				If SC7->(MsRLock()) .and. SZ2->(MsRLock())
					AAdd(aRLockSC7, SC7->(Recno()))
					AAdd(aRLocksSZ2, SZ2->(Recno()))
					lRet	:=	.T.
				ElseIf lHelp
					MsgAlert('Um dos registros reçacionados está sendo utilizado em outro terminal e não pode ser utilizado na Conciliação DDA')		//"Um dos registros reçacionados está sendo utilizado em outro terminal e não pode ser utilizado na Conciliação DDA"
				Endif
			Endif
		Else
			If lSc7 .and. lSZ2
				//Destravo registro no SC7
				SC7->(MsRUnlock(SC7->(Recno())))
				If (nPosRec:=Ascan(aRlockSC7,SC7->(Recno()))) > 0
					Adel(aRlockSC7,nPosRec)
					aSize(aRlockSC7,Len(aRlockSC7)-1)
				Endif
				//Destravo registro no SZ2
				SZ2->(MsRUnlock(SZ2->(Recno())))
				If (nPosRec:=Ascan(aRlocksSZ2,SZ2->(REcno()))) > 0
					Adel(aRlocksSZ2,nPosRec)
					aSize(aRlocksSZ2,Len(aRlocksSZ2)-1)
				Endif
			Endif
		Endif
	Endif

	If aArea <> Nil
		RestArea(aArea)
	Endif

Return lRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³F260PicCgc| Autor ³ Mauricio Pequim Jr	  ³ Data ³02/10/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a picture do CGC ou CPF                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ F260PicCgc()				                               	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA260	 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
// user Function F260PicCgc()
// 	Local cPict := ""
// 	If Len(Alltrim(M->FIG_CNPJ)) > 12
// 		cPict := "@R 99.999.999/9999-99"
// 	else
// 		cPict := "@R 999.999.999-99"
// 	endif
// 	cPict := cPict + "%C"

// Return cPict




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FDDAInUse	ºAutor  ³Mauricio Pequim Jr. º Data ³  28/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificar o tratamento de DDA						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico - DDA				                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FDdaInUse()

//Controla o uso do DDA - Debito Direto Autorizado no Sistema)
	Local lDdaInUse := cPaisLoc == "BRA"

Return lDdaInUse


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³MenuDef   ³ Autor ³ Mauricio Pequim Jr    ³ Data ³29/09/09  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Parametros do array a Rotina:                               ³±±
	±±³          ³1. Nome a aparecer no cabecalho                             ³±±
	±±³          ³2. Nome da Rotina associada                                 ³±±
	±±³          ³3. Reservado                                                ³±±
	±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
	±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
	±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
	±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
	±±³          ³    4 - Altera o registro corrente                          ³±±
	±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
	±±³          ³5. Nivel de acesso                                          ³±±
	±±³          ³6. Habilita Menu Funcional                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
	Local aRotina := {{ 'Pesquisar'		,"AxPesqui"		, 0 , 1 },;		//"Pesquisar"
	{ 'Visualizar'	,"AxVisual"		, 0 , 2 },;		//"Visualizar"
	{ 'Conciliar'		,"U_F260Conc(1)", 0 , 6 },;		//"Conciliar"
	{ 'Desconciliar'	,"U_F260Conc(2)", 0 , 6 },;		//"Cancelar"
	{"Exclui Esse"	,"AxDeleta"		, 0 , 5 },;		//"Deletar"
	{ 'Importar CSV'	,"U_zImpCSv"	, 0 , 6 , ,.F. },;//"Importar CSV"
	{ 'Legenda'		,"U_FA260Leg"	, 0 , 6 , ,.F. } }//"Legenda"
	// { 'Alterar'	,"U_F260Alte"	, 0 , 4 }		,;//"Alterar"
	// { 'Excluir Varios',"U_F260ExclSZ2"	, 0 , 6 , ,.F. },;//"Legenda"

Return(aRotina)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AdmAbreSM0()
	Local aArea			:= SM0->( GetArea() )
	Local aAux			:= {}
	Local aRetSM0		:= {}
	Local lFWLoadSM0	:= .T.
	Local lFWCodFilSM0 	:= .T.

	If lFWLoadSM0
		aRetSM0	:= FWLoadSM0()
	Else
		DbSelectArea( "SM0" )
		SM0->( DbGoTop() )
		While SM0->( !Eof() )
			aAux := { 	SM0->M0_CODIGO,;
				IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
				"",;
				"",;
				"",;
				SM0->M0_NOME,;
				SM0->M0_FILIAL }

			aAdd( aRetSM0, aClone( aAux ) )
			SM0->( DbSkip() )
		End
	EndIf

	RestArea( aArea )
Return aRetSM0


//==============================================================
// Posições do Array - CSV Jogue Limpo
//==============================================================
	Static nPosColeta   := 1  // Coluna A
	Static nPosDtColeta := 2  // Coluna B
	Static nPosCNPJ     := 3  // Coluna C
	Static nPosNome     := 4  // Coluna D
	Static nPosPlaca    := 5  // Coluna E
	Static nPosVolume   := 6  // Coluna F
	Static nPosUF       := 7  // Coluna G
	Static nPosRegiao   := 8  // Coluna H
	Static nPosCCO      := 9  // Coluna I
	Static nPosPreco    := 10 // Coluna J
	Static nPosMotivo   := 11 // Coluna K


/******************************************************************************/
/*/{Protheus.doc} zImpCSV
Função para importar informações de coletas da Jogue Limpo via CSV
@author Edson
@since 27/07/2026
@version 1.0
@type function
/*/
/******************************************************************************/

User Function zImpCSV()

	Local aArea := GetArea()

	Private cArqOri := ""

	// Seleção do arquivo
	cArqOri := tFileDialog( ;
		"CSV files (*.csv)", ;
		"Seleção de Arquivos", ;
		, ;
		, ;
		.F., ;
		)

	If !Empty(cArqOri)

		If File(cArqOri) .And. ;
				Upper(SubStr(cArqOri, RAt(".", cArqOri) + 1, 3)) == "CSV"

			Processa({|| fImporta()}, "Importando...")

		Else

			MsgStop( ;
				"Arquivo e/ou extensão inválida!", ;
				"Atenção" ;
				)

		EndIf

	EndIf

	RestArea(aArea)

Return


/*----------------------------------------------------------------------------*
 | Func: fImporta                                                            |
 | Desc: Importa as coletas da Jogue Limpo para a SZ2                         |
 *----------------------------------------------------------------------------*/

Static Function fImporta()

    Local aArea      := GetArea()
    Local cArqLog    := "zImpCSV_" + ;
                        dToS(Date()) + "_" + ;
                        StrTran(Time(), ":", "-") + ".log"

    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}

    Local oArquivo
    Local aLinhas

    Local cColeta    := ""
    Local dDtColeta  := Ctod("")
    Local cCNPJ      := ""
    Local cNome      := ""
    Local cPlaca     := ""
    Local nVolume    := 0
    Local cUF        := ""
    Local cRegiao    := ""
    Local cCCO       := ""
    Local cPreco     := ""
    Local cMotivo    := ""

    Local nImportados := 0
    Local nIgnorados  := 0

    Private cDirLog := GetTempPath() + "x_importacao\"
    Private cLog    := ""


    //==============================================================
    // Cria diretório do log
    //==============================================================

    If !ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf


    //==============================================================
    // Abre arquivo
    //==============================================================

    oArquivo := FWFileReader():New(cArqOri)

    If !oArquivo:Open()

        MsgStop( ;
            "Arquivo não pode ser aberto!", ;
            "Atenção" ;
        )

        RestArea(aArea)

        Return

    EndIf


    //==============================================================
    // Verifica conteúdo
    //==============================================================

    If oArquivo:EoF()

        oArquivo:Close()

        MsgStop( ;
            "Arquivo não tem conteúdo!", ;
            "Atenção" ;
        )

        RestArea(aArea)

        Return

    EndIf


    //==============================================================
    // Total de linhas
    //==============================================================

    aLinhas := oArquivo:GetAllLines()

    nTotLinhas := Len(aLinhas)

    ProcRegua(nTotLinhas)


    //==============================================================
    // Reabre arquivo
    //==============================================================

    oArquivo:Close()

    oArquivo := FWFileReader():New(cArqOri)

    oArquivo:Open()


    //==============================================================
    // Processamento
    //==============================================================

    While oArquivo:HasLine()

        nLinhaAtu++

        IncProc( ;
            "Analisando linha " + ;
            cValToChar(nLinhaAtu) + ;
            " de " + ;
            cValToChar(nTotLinhas) + "..." ;
        )


        //==========================================================
        // Lê linha
        //==========================================================

        cLinAtu := oArquivo:GetLine()

		if  ";;" $ cLinAtu
			cLinAtu := strtran(cLinAtu,';;',";n/a")
		endif

        aLinha := StrTokArr(cLinAtu, ";")

		if Len(aLinha) == 10
			aAdd(aLinha,"n/a")
		endif

        //==========================================================
        // Cabeçalho
        //==========================================================

        If nLinhaAtu == 1
            cLog += "- Lin" + ;
                    cValToChar(nLinhaAtu) + ;
                    ", cabeçalho não processado;" + CRLF

            Loop
        EndIf


        //==========================================================
        // Valida quantidade de colunas
        //==========================================================

        If Len(aLinha) < 11

            cLog += "- Lin" + ;
                    cValToChar(nLinhaAtu) + ;
                    ", linha inválida. Esperadas 11 colunas, encontradas " + ;
                    cValToChar(Len(aLinha)) + ";" + CRLF
            nIgnorados++
            Loop

        EndIf

        //==========================================================
        // Limpa variáveis
        //==========================================================

        cColeta   := AllTrim(aLinha[nPosColeta])
        cCNPJ     := AllTrim(aLinha[nPosCNPJ])
        cNome     := AllTrim(aLinha[nPosNome])
        cPlaca    := AllTrim(aLinha[nPosPlaca])
        cUF       := AllTrim(aLinha[nPosUF])
        cRegiao   := AllTrim(aLinha[nPosRegiao])
        cCCO      := AllTrim(aLinha[nPosCCO])
        cPreco    := AllTrim(aLinha[nPosPreco])
        cMotivo   := AllTrim(aLinha[nPosMotivo])


        //==========================================================
        // Data
        //==========================================================

        dDtColeta := fDataCSV(aLinha[nPosDtColeta])


        //==========================================================
        // Volume
        //==========================================================

        nVolume := fNumeroCSV(aLinha[nPosVolume])


        //==========================================================
        // CNPJ
        //==========================================================

        cCNPJ := StrTran(cCNPJ, ".", "")
        cCNPJ := StrTran(cCNPJ, "/", "")
        cCNPJ := StrTran(cCNPJ, "-", "")
        cCNPJ := StrTran(cCNPJ, " ", "")


        //==========================================================
        // Valida campos obrigatórios
        //==========================================================

        If Empty(cColeta)

            cLog += "- Lin" + ;
                    cValToChar(nLinhaAtu) + ;
                    ", coleta não informada;" + CRLF

            nIgnorados++

            Loop

        EndIf


        If Empty(cCCO)

            cLog += "- Lin" + ;
                    cValToChar(nLinhaAtu) + ;
                    ", CCO não informado;" + CRLF

            nIgnorados++

            Loop

        EndIf


        //==========================================================
        // SZ2
        //==========================================================

        DbSelectArea("SZ2")

        // IMPORTANTE:
        // Ajustar a ordem conforme o índice real da SZ2.
        //
        // Se o índice 1 for:
        // Z2_FILIAL + Z2_CCO
        //
        // pode utilizar:
        //
        // SZ2->(DbSetOrder(1))
        // If SZ2->(DbSeek(FWxFilial("SZ2") + cCCO))
        //
        // Aqui deixamos a verificação utilizando CCO.
        //==========================================================

        SZ2->(DbSetOrder(1))


        If SZ2->(DbSeek(FWxFilial("SZ2") + cCCO))

            cLog += "- Lin" + ;
                    cValToChar(nLinhaAtu) + ;
                    ", CCO [" + cCCO + ;
                    "] já cadastrado na SZ2;" + CRLF

            nIgnorados++

            Loop

        EndIf


        //==========================================================
        // Inclui registro
        //==========================================================

        RecLock("SZ2", .T.)

            SZ2->Z2_FILIAL  := xFilial("SZ2")
            SZ2->Z2_COLETA  := cColeta
            SZ2->Z2_EMISSAO := dDtColeta
            SZ2->Z2_CGC     := cCNPJ
            SZ2->Z2_NOME    := cNome
            SZ2->Z2_PLACA   := cPlaca
            SZ2->Z2_QUANT   := nVolume
            SZ2->Z2_UF      := cUF
            SZ2->Z2_REGIAO  := cRegiao
            SZ2->Z2_CCO     := cCCO
            SZ2->Z2_PRECO   := cPreco
            SZ2->Z2_MOTIVO  := cMotivo

            // Ainda não conciliado
            // SZ2->Z2_CONCJL := " "

        SZ2->(MsUnlock())


        //==========================================================
        // Log
        //==========================================================

        cLog += "+ Lin" + ;
                cValToChar(nLinhaAtu) + ;
                ", coleta [" + cColeta + ;
                "] CCO [" + cCCO + ;
                "] importada com sucesso;" + CRLF

        nImportados++

    EndDo


    //==============================================================
    // Fecha arquivo
    //==============================================================

    oArquivo:Close()


    //==============================================================
    // Resumo
    //==============================================================

    cLog := ;
        "PROCESSAMENTO FINALIZADO" + CRLF + ;
        "=========================" + CRLF + ;
        "Total de linhas: " + cValToChar(nTotLinhas) + CRLF + ;
        "Importados: " + cValToChar(nImportados) + CRLF + ;
        "Ignorados: " + cValToChar(nIgnorados) + CRLF + ;
        CRLF + ;
        cLog


    //==============================================================
    // Grava log
    //==============================================================

    If !Empty(cLog)

        MemoWrite( ;
            cDirLog + cArqLog, ;
            cLog ;
        )

        ShellExecute( ;
            "OPEN", ;
            cArqLog, ;
            "", ;
            cDirLog, ;
            1 ;
        )

    EndIf


    RestArea(aArea)

Return


/*----------------------------------------------------------------------------*
 | Func: fDataCSV                                                            |
 | Desc: Converte data do CSV para Date()                                    |
 *----------------------------------------------------------------------------*/

Static Function fDataCSV(cData)

    Local aData := {}
    Local dRet  := Ctod("")

    cData := AllTrim(cData)

    If Empty(cData)
        Return dRet
    EndIf

    aData := StrTokArr(cData, "/")

    If Len(aData) == 3

        dRet := StoD( ;
            aData[3] + ;
            StrZero(Val(aData[2]), 2) + ;
            StrZero(Val(aData[1]), 2) ;
        )

    EndIf

Return dRet


/*----------------------------------------------------------------------------*
 | Func: fNumeroCSV                                                          |
 | Desc: Converte número decimal do CSV para Numeric                         |
 *----------------------------------------------------------------------------*/

Static Function fNumeroCSV(cNumero)

    Local nRet := 0

    cNumero := AllTrim(cNumero)

    If Empty(cNumero)
        Return 0
    EndIf

    // CSV brasileiro: 5.000,00
    cNumero := StrTran(cNumero, ".", "")
    cNumero := StrTran(cNumero, ",", ".")

    nRet := Val(cNumero)

Return nRet

