#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"  
#define DMPAPER_LETTER 1 		&& Letter 8 1/2 x 11 in
#define DMPAPER_LETTERSMALL 2 	&& Letter Small 8 1/2 x 11 in
#define DMPAPER_TABLOID 3 		&& Tabloid 11 x 17 in
#define DMPAPER_LEDGER 4 		&& Ledger 17 x 11 in
#define DMPAPER_LEGAL 5 		&& Legal 8 1/2 x 14 in
#define DMPAPER_STATEMENT 6 	&& Statement 5 1/2 x 8 1/2 in
#define DMPAPER_EXECUTIVE 7 	&& Executive 7 1/4 x 10 1/2 in
#define DMPAPER_A3 8 			&& A3 297 x 420 mm
#define DMPAPER_A4 9 			&& A4 210 x 297 mm
#define DMPAPER_A4SMALL 10 		&& A4 Small 210 x 297 mm
#define DMPAPER_A5 11 			&& A5 148 x 210 mm
#define DMPAPER_B4 12			&& B4 250 x 354
#define DMPAPER_B5 13			&& B5 182 x 257 mm
#define DMPAPER_FOLIO 14		&& Folio 8 1/2 x 13 in
#define DMPAPER_QUARTO 15		&& Quarto 215 x 275 mm
#define DMPAPER_10X14 16		&& 10x14 in
#define DMPAPER_11X17 17		&& 11x17 in
#define DMPAPER_NOTE 18			&& Note 8 1/2 x 11 in

/*/{Protheus.doc} ³ETQEMPDA4

Etiquetas de Itens Empenhados por Ordem de Produção 

@type function
@author Marcos Martins
@since 14/10/08

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ETQEMPDA4 º Autor ³Marcos Martins      º Data ³   14/10/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiquetas de Itens Empenhados por Ordem de Produção        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HONDA LOCK                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ETQEMPDA4()
	Private cPerg		:= "ETQEMP"
	Private nLastKey	:= 0
	Private _nL	   		:= 0
	Private _nC			:= 0
/*
 Perguntas
 =========
 MV_PAR01 - Lado Desejado ? 	LEFT - Papel Branco / RIGHT - Papel Verde / NENHUM - Papel Amarelo
 MV_PAR02 - OP de ?
 MV_PAR03 - OP Ate ?
*/
	ValidPerg(cPerg)
	If Pergunte(cPerg, .T.)
		If nLastKey != 27
			Processa({|| CursorWait(), GeraETQ(), CursorArrow()}, "Imprimindo...")
		EndIf		  
	EndIf		
Return()

***********************************************************************************************************************************************************************************************
// Funcao principal responsavel pela impressão.
***********************************************************************************************************************************************************************************************
Static Function GeraETQ()
	Local cLado			:= IIf(MV_PAR01 == 1, "L", IIf(MV_PAR01 == 2, "R", "N"))
	
	Private oPrint
	Private _nTotQtd	:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta impressora para BMPs                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:= TAVPrinter():New( "ETIQUETAS ALMOXARIFADO" )
	oPrint:SetPortrait()      // fixa impressao em Retrato
	oPrint:Setup()
	oPrint:setPaperSize( DMPAPER_A4 ) && Incluido esta linha para efetuar o tratamento do tamanho do formulario que se imprime as etiquetas. Dia 27/08/2010

	// Imprime etiquetas dos componentes empenhados da Ordem de Producao
	
	xNomeGrp	:= {}
	xCodProd	:= {}
	xQtdProd	:= {}
	xLoteCtl	:= {}
	xCodCor		:= {}
	
	cGrupo		:= ""
	cLote		:= ""
	cCodCor		:= ""
	
	SD4->(dbSetOrder(2))
	SD4->(dbSeek(xFilial("SD4") + Left(AllTrim(MV_PAR02), 6)))

	Do While SD4->(!Eof()) .And. Left(AllTrim(SD4->D4_OP), 6) >= Left(AllTrim(MV_PAR02), 6) .And. Left(AllTrim(SD4->D4_OP), 6) <= Left(AllTrim(MV_PAR03), 6)
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial("SB1") + SD4->D4_COD))
		
		dbSelectArea("SC2")
		SC2->(dbSetOrder(1))
		If SC2->(dbSeek(xFilial("SC2") + AllTrim(SD4->D4_OP)))
			cCodCor := ""
			
			SBM->(dbSetOrder(1))
			SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO))
			cGrupo := SBM->BM_GRUPO + "-" + SBM->BM_DESC
		EndIf
		
		If (AllTrim(SB1->B1_TIPO) == "PI" .And. SB1->B1_ZZCOR <> "1") .Or. (Left(AllTrim(SB1->B1_COD), 6) == "RESINA") .Or. SB1->B1_LADO != cLado
			SD4->(dbSkip())
			Loop
		EndIf
		
		dbSelectArea("SB8")
		SB8->(dbSetOrder(1))
		If SB8->(dbSeek(cSeekSB8 := xFilial("SB8") + SB1->B1_COD + SD4->D4_LOCAL, .T.))
			Do While SB8->(!Eof()) .And. cSeekSB8 == SB8->(B8_FILIAL + B8_PRODUTO + B8_LOCAL)
				If AllTrim(SB8->B8_ORIGLAN) == "MI" .And. SB8->B8_SALDO > 0
					cLote := SB8->B8_LOTECTL
				EndIf
				
				SB8->(dbSkip())
			EndDo
		EndIf
		
		AADD(xCodProd,	SD4->D4_COD)
		AADD(xQtdProd,	SD4->D4_QUANT)
		AADD(xLoteCtl,	cLote)
		AADD(xNomeGrp,	cGrupo)
		AADD(xCodCor,	cCodCor)
		cLote := ""
		
		dbSelectArea("SD4")
		SD4->(dbSkip())
	EndDo()
	
	xCodOld		:= ""
	xGrpOld		:= ""
	xCorOld		:= ""
	_nTotQtd	:= 0	
	For _xI := 1 to Len(xCodProd)
		If !Empty(xCodOld) .And. xCodOld # xCodProd[_xI]
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1") + xCodOld))
			
			GravaEtq()
			
			_nTotQtd := 0
		EndIf
		
		_nTotQtd	+= xQtdProd[_xI]
		xCodOld		:= xCodProd[_xI]
		xGrpOld		:= xNomeGrp[_xI]
		cLote		:= xLoteCtl[_xI]
		xCorOld		:= xCodCor[_xI]
	Next 
	
	If _nTotQtd > 0 .And. !Empty(xCodOld)
	   dbSelectArea("SB1")
	   SB1->(dbSetOrder(1))
	   SB1->(dbSeek(xFilial("SB1") + xCodOld))
       GravaEtq()
    Endif
	
	oPrint:EndPage()
	
	oPrint:Preview()  // Visualiza antes de imprimir
Return()

Static Function GravaEtq()
	// Imprime etiquetas do produto
	_cQuant		:= PadL(AllTrim(Str(Round(_nTotQtd / SB1->B1_QE, 02))), 13, '0')
	If SubStr(_cQuant, 11, 01) != "." .And. SubStr(_cQuant, 12, 01) != "."
		_cQuant	:= PadL(AllTrim(Str(Round(_nTotQtd / SB1->B1_QE, 02))), 10, '0') + ".00"
	ElseIf SubStr(_cQuant, 12, 01) == "."
		_cQuant	:= PadL(AllTrim(Str(Round(_nTotQtd / SB1->B1_QE, 02))), 12, '0') + "0"
	EndIf
	_nInteiro	:= Val(SubStr(_cQuant, 01, 10))
	_nResto		:= _nTotQtd-(_nInteiro * SB1->B1_QE)
	If _nResto > 0
		_nInt	:= _nInteiro+1
	Else
		_nInt	:= _nInteiro
	EndIf

	For I := 1 to _nInteiro
		ImpEtq(SB1->B1_QE, I, cLote, @_nL, @_nC, xGrpOld, xCorOld)
	Next
	
	If _nResto > 0
		ImpEtq(_nResto, I, cLote, @_nL, @_nC, xGrpOld, xCorOld)
	EndIf
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpEtq   ³ Autor ³ Marcos Martins        ³ Data ³ 24.06.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Etiquetas                                      ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico HONDA LOCK                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpEtq(_nQtdEtq,_nSeq,_cLote,_nL,_nC,xGrpOld,xCorOld)
	Local oFont8
	Local oFont10
	Local oFont10n
	Local oFont16
	Local oFont16n
	Local oFont14
	Local aCoords := {2000,1900,1340,3280}
	Local oBrush
	Local cCGCPict, cCepPict
	Local _nItm
	Local _ContaETQ:=0
	Local cTexto := ""
	
	oFont8   := TFont():New("Arial", 9, 08, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont9   := TFont():New("Arial", 9, 09, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont9n  := TFont():New("Arial", 9, 09, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont10  := TFont():New("Arial", 9, 10, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont10n := TFont():New("Arial", 9, 10, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont11  := TFont():New("Arial", 9, 11, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont11n := TFont():New("Arial", 9, 11, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont12  := TFont():New("Arial", 9, 12, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont12n := TFont():New("Arial", 9, 12, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont13  := TFont():New("Arial", 9, 13, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont14  := TFont():New("Arial", 9, 14, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont14n := TFont():New("Arial", 9, 14, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont16n := TFont():New("Arial", 9, 16, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont17n := TFont():New("Arial", 9, 17, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont18n := TFont():New("Arial", 9, 18, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont21n := TFont():New("Arial", 9, 21, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont24n := TFont():New("Arial", 9, 24, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	
	oBrush := TBrush():New("",4)

	If _nL == 1 .And. _nC == 1
		_nL := 1
		_nC := 2
	ElseIf _nL == 1 .And. _nC == 2
		_nL := 2
		_nC := 1
	ElseIf _nL == 2 .And. _nC == 1
		_nL := 2
		_nC := 2
	ElseIf _nL == 2 .And. _nC == 2
		_nL := 3
		_nC := 1
	ElseIf _nL == 3 .And. _nC == 1
		_nL := 3
		_nC := 2
	Else
		_nL := 1
		_nC := 1
	EndIf

	If _nL == 1 .And. _nC == 1
		oPrint:StartPage()
	EndIf

	//oPrint:StartPage()
	If _nL == 1 .And. _nC == 1
		_LI			:= 0
		_CO			:= 0
		_LIMSBAR	:= 0
		_COMSBAR	:= 0
	ElseIf _nL == 1 .And. _nC == 2
		_LI			:= 0
		_CO			:= 1150
		_LIMSBAR	:= 0
		_COMSBAR	:= 9.7
	ElseIf _nL == 2 .And. _nC == 1
		_LI			:= 1165 && 1065 && Incrementado 100 pontos a mais para que este efetue o pulo correto na nova pagina A4 - Dia 27/08/2010
		_CO			:= 0
		_LIMSBAR	:= 9.9 && 9  && Incrementado .9 pontos a mais para que este efetue o pulo correto na nova pagina A4 ( Codigo de Barras ) - Dia 27/08/2010
		_COMSBAR	:= 0
	ElseIf _nL == 2 .And. _nC == 2
		_LI			:= 1165 && 1065 && Incrementado 100 pontos a mais para que este efetue o pulo correto na nova pagina A4 - Dia 27/08/2010
		_CO			:= 1150
		_LIMSBAR	:= 9.9 && 9  && Incrementado .9 pontos a mais para que este efetue o pulo correto na nova pagina A4 ( Codigo de Barras ) - Dia 27/08/2010
		_COMSBAR	:= 9.7
	ElseIf _nL == 3 .And. _nC == 1
		_LI			:= 2330 && 2130 && Incrementado 200 pontos a mais para que este efetue o pulo correto na nova pagina A4 - Dia 27/08/2010
		_CO			:= 0
		_LIMSBAR	:= 19.8 && 18   && Incrementado 1.8 pontos a mais para que este efetue o pulo correto na nova pagina A4 ( Codigo de Barras ) - Dia 27/08/2010
		_COMSBAR	:= 0
	ElseIf _nL == 3 .And. _nC == 2
		_LI			:= 2330 && 2130 && Incrementado 200 pontos a mais para que este efetue o pulo correto na nova pagina A4 - Dia 27/08/2010
		_CO			:= 1150
		_LIMSBAR	:= 19.8 && 18   && Incrementado 1.8 pontos a mais para que este efetue o pulo correto na nova pagina A4 ( Codigo de Barras ) - Dia 27/08/2010
		_COMSBAR	:= 9.7
	EndIf

	//deslocamento - margens
	_LI += 20
	_CO += 50
	
	oPrint:Box(_LI + 18, _CO + 18, _LI + 1033, _CO + 1113)
	oPrint:Box(_LI + 23, _CO + 23, _LI + 1028, _CO + 1108)
	
	_LI += 20
	_CO += 25

	oPrint:Say(_LI + 10, _CO + (1090 / 2), "ALMOXARIFADO HLS", oFont24n,,, 1, 2)
	_LI += 100
	//Grupo DA PECA ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI, _CO, _LI,_CO + 1090)								//Linha Horizontal
	oPrint:Say(_LI, _CO + (1090 / 2),"ENTREGAR:" + AllTrim(SubStr(xGrpOld, 1, 35)), oFont13,,, 1, 2)
	_LI += 50
	//Primeiro quadro - NOME DA PECA ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	oPrint:Say(_LI, _CO + (1090 / 2), "NOME DA PEÇA", oFont13,,, 1, 2)
	_LI += 50
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	_LI += 50
	oPrint:Say(_LI - 20,_CO + (1090 / 2), AllTrim(SubStr(SB1->B1_DESCNF, 1, 40)), oFont17n,,, 1, 2)
	_LI += 70
	//Segundo quadro - CODIGO DA PECA ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI, _CO, _LI,_CO + 1090)//Linha Horizontal
	oPrint:Say(_LI,_CO + (750 / 2), "CÓDIGO HONDA LOCK", oFont13,,, 1, 2)
	oPrint:Say(_LI,_CO + 750 + ((1090 - 750) / 2), "LADO", oFont13,,, 1, 2)
	oPrint:Line(_LI, _CO + 750, _LI + 170, _CO + 750)					//Linha Vertical
	oPrint:Line(_LI, _CO + 755, _LI + 170, _CO + 755)					//Linha Vertical
	_LI += 50
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	_LI += 50
	oPrint:Say(_LI - 20, _CO + (750 / 2), AllTrim(SB1->B1_COD), oFont21n,,, 1, 2)
	If SB1->B1_LADO $ "LR"
		oPrint:Say(_LI - 20, _CO + 750 + ((1090 - 750) / 2), AllTrim(SB1->B1_LADO), oFont21n,,, 1, 2)
	EndIf
	_LI += 70
	//Terceiro quadro - CODIGO CLIENTE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	oPrint:Say(_LI,_CO + (1090 / 2), "CÓDIGO DE BARRAS DO CÓDIGO HONDA LOCK", oFont13,,, 1, 2)
	_LI += 50
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	_LI += 50
	cTexto := SB1->B1_COD
	MSBAR("CODE128", _LIMSBAR + 5.4, _COMSBAR + 1.5, cTexto, oPrint, .F., NIL, NIL, 0.027, 0.8, NIL, NIL, "A", .F.)
	_LI += 70
	//Quarto quadro - DATA DA PRODUCAO + LOTE///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)//Linha Horizontal
	oPrint:Line(_LI, _CO + (1090 / 2),		_LI + 345, _CO + (1090 / 2))		//Linha Vertical
	oPrint:Line(_LI, _CO + (1090 / 2) + 5,	_LI + 345, _CO + (1090 / 2) + 5)	//Linha Vertical
	oPrint:Say(_LI, _CO + (1090 / 4) * 1, "DATA DE FORNECIMENTO", oFont11,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 4) * 3, "NÚMERO DO LOTE - HLS", oFont11,,, 1, 2)
	_LI += 50
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)//Linha Horizontal
	_LI += 50
	oPrint:Say(_LI - 20, _CO + (1090 / 4), DToC(ddatabase), oFont21n,,, 1, 2)
	oPrint:Say(_LI - 20, _CO + (1090 / 4) * 3, AllTrim(_cLote), oFont21n,,, 1, 2)
	_LI += 70
	//Ultimo quadro - Quantidades///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI,_CO, _LI, _CO + 1090)//Linha Horizontal
	oPrint:Line(_LI, _CO + (1090 / 4),			_LI + 175, _CO + (1090 / 4))			//Linha Vertical
	oPrint:Line(_LI, _CO + (1090 / 4) + 5,		_LI + 175, _CO + (1090 / 4) + 5)		//Linha Vertical
	oPrint:Line(_LI, _CO + (1090 / 4) * 3,		_LI + 175, _CO + (1090 / 4) * 3)		//Linha Vertical
	oPrint:Line(_LI, _CO + (1090 / 4) * 3 + 5,	_LI + 175, _CO + (1090 / 4) * 3 + 5)	//Linha Vertical
	oPrint:Say(_LI, _CO + (1090 / 8) * 1, "CAPACIDADE",		oFont11,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 3, "QUANTIDADE",		oFont11,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 5, "SEQUENCIA",		oFont11,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 7, "RESPONSAVEL",	oFont11,,, 1, 2)
	_LI += 50
	oPrint:Line(_LI, _CO,_LI,_CO+1090)//Linha Horizontal
	_LI += 50
	oPrint:Say(_LI, _CO + (1090 / 8) * 1, cValToChar(SB1->B1_QE), oFont18n,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 3, cValToChar(_nQtdEtq), oFont18n,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 5, cValToChar(_nSeq) + "/" + cValToChar(_nInt), oFont18n,,, 1, 2)
	_LI += 70
	
	If _nL == 3 .And. _nC == 2
		oPrint:EndPage()      
	EndIf
Return(.T.)

*************************************************************************************************************************************************************************
&& Funcao para criar as perguntas no arquivo SX1
*************************************************************************************************************************************************************************
Static Function ValidPerg()
	Local aAreaATU	:= GetArea()
	Local aAreaSX1	:= SX1->(GetArea())
	Local aRegs		:= {}
	Local nI		:= 0
	Local nJ        := 0
	
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	cPerg := PadR(cPerg, Len(X1_GRUPO))
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Lado (Cor do Papel) ?",	"Lado (Cor do Papel) ?",	"Lado (Cor do Papel) ?",	"mv_ch1", "N", 01, 0, 0, "C", "", "MV_PAR01", "LEFT(Branco)",	"", "", "", "", "RIGHT(Verde)",	"", "", "", "", "NENHUM(Amarelo)",	"", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
	aAdd(aRegs, {cPerg, "02", "OP de ?",				"OP de ?",					"OP de ?",					"mv_ch2", "C", 13, 0, 0, "G", "", "MV_PAR02", "",				"", "", "", "", "",				"", "", "", "", "",					"", "", "", "", "", "", "", "", "", "", "", "", "", "SC2"	})
	aAdd(aRegs, {cPerg, "03", "OP Ate ?",				"OP Ate ?",					"OP Ate	?",					"mv_ch3", "C", 13, 0, 0, "G", "", "MV_PAR03", "",				"", "", "", "", "",				"", "", "", "", "",					"", "", "", "", "", "", "", "", "", "", "", "", "", "SC2"	})
	
	For nI := 1 to Len(aRegs)
		If !SX1->(dbSeek(cPerg + aRegs[nI, 2]))
			RecLock("SX1", .T.)
			For nJ := 1 To FCount()
				If nJ <= Len(aRegs[nI])
					FieldPut(nJ, aRegs[nI, nJ])
				EndIf
			Next nJ
			SX1->(MsUnlock())
		EndIf
	Next nI
	
	RestArea(aAreaSX1)
	RestArea(aAreaATU)
Return
