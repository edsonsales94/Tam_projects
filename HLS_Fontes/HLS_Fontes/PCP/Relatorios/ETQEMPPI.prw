#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} ETQEMPPI

Etiquetas de Itens Empenhados por Ordem de Produção. Baseado no fonte ETQEMP2, com a diferenca que imprime os PI

@type function
@author Leandro Nascimento
@since 16/09/13

/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ETQEMPPI º Autor ³ Leandro Nascimento º Data ³   16/09/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiquetas de Itens Empenhados por Ordem de Produção.       º±±
±±º          ³ Baseado no fonte ETQEMP2, com a diferenca que imprime os PIº±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ HONDA LOCK                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alteracao³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// U_ETQEMP2()
User Function ETQEMPPI()
	Local dMaiorData	:= CtoD("")
	Local aRegLog		:= {}

	Private cPerg		:= "ETQEMP2"
	Private nLastKey	:= 0
	Private _nL	   		:= 0
	Private _nC			:= 0
	Private cOPIni		:= ""
	Private cOPFim		:= ""
	Private cSelecaoOP	:= ""

	// OP nao encerradas e com saldo em aberto
	cQuery	:=	"Select "
	cQuery	+=			"TMP.* "
	cQuery	+=	"From ( "
	cQuery	+=			"Select "
	cQuery	+=					"SC2.C2_NUM OP, "
	cQuery	+=					"SC2.C2_PRODUTO, "
	cQuery	+=					"SC2.C2_DATPRI, "
	cQuery	+=					"SC2.C2_DATPRF, "
	cQuery	+=					"Sum(SC2.C2_QUANT - SC2.C2_QUJE) SALDO "
	cQuery	+=			"From "+RetSqlName("SC2")+" SC2 "
	cQuery	+=			"Where "
	cQuery	+=					"SC2.C2_FILIAL ='"	+ xFilial("SD4")	+ "' And "
	cQuery	+=					"SC2.C2_DATRF  ='        ' And "
	cQuery	+=					"SC2.D_E_L_E_T_= ' ' "
	cQuery	+=			"Group By "
	cQuery	+=					"SC2.C2_NUM, "
	cQuery	+=					"SC2.C2_PRODUTO, "
	cQuery	+=					"SC2.C2_DATPRI, "
	cQuery	+=					"SC2.C2_DATPRF "
	cQuery	+=			") as TMP "
	cQuery	+=	"Where "
	cQuery	+=			"TMP.SALDO > 0"
	cQuery	+=	"Order By "
	cQuery	+=			"TMP.OP"
	
	TCQUERY cQuery ALIAS "QrySC2" NEW
	
	TCSetField("QrySC2", "C2_DATPRI", "D")
	TCSetField("QrySC2", "C2_DATPRF", "D")
	
	cSelecaoOP	:= FormatIn(u_HLAPCP1A("QrySC2", @cOPIni, @cOPFim, @dMaiorData),";")
	
	QrySC2->(DBCloseArea())
	
/*
 Perguntas
 =========
 MV_PAR01 - Lado Desejado ? 	LEFT - Papel Branco / RIGHT - Papel Verde / NENHUM - Papel Amarelo
*/
	if cSelecaoOP != "('')"
		ValidPerg(cPerg)
		If Pergunte(cPerg, .T.)
			If nLastKey != 27
				Processa({|| GeraETQ(dMaiorData, @aRegLog)}, "Imprimindo...")
				if len(aRegLog) > 0
					GeraArqLog(aRegLog)
				endIf
			EndIf		  
		EndIf		
	EndIf		
Return()

***********************************************************************************************************************************************************************************************
// Funcao principal responsavel pela impressão.
***********************************************************************************************************************************************************************************************
Static Function GeraETQ(dMaiorData, aRegLog)
	Local cLado			:= IIf(MV_PAR01 == 1, "L", IIf(MV_PAR01 == 2, "R", "N"))
	Local nPos			:= 0
	
	Private oPrint
	Private _nTotQtd	:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta impressora para BMPs                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:= TAVPrinter():New( "ETIQUETAS ALMOXARIFADO" )
	oPrint:SetPortrait()      // fixa impressao em Retrato
	oPrint:Setup()
	// Imprime etiquetas dos componentes empenhados da Ordem de Producao
	
	xNomeGrp	:= {}
	xCodProd	:= {}
	xQtdProd	:= {}
	xLoteCtl	:= {}
	xCodCor		:= {}
	
	cGrupo		:= ""
	cLote		:= ""
	cCodCor		:= ""
	
	// Escolhe as ordem dos arquivos que serao manipulados
	// SD4 - Requisicoes Empenhadas
	SD4->(dbSetOrder(2))			// D4_FILIAL + D4_OP + D4_COD + D4_LOCAL
	// SB1 - Cadastrro de Produtos
	SB1->(dbSetOrder(1))			// B1_FILIAL + B1_COD
	// SC2 - Ordens de Producao
	SC2->(dbSetOrder(1))       		// C2_FILIAL + C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD
	// SBM - Grupo de Produtos
	SBM->(dbSetOrder(1))			// BM_FILIAL + BM_GRUPO
	// SB8 - Saldos por Lote
	SB8->(dbSetOrder(1))    		// B8_FILIAL + B8_PRODUTO + B8_LOCAL + DTOS(B8_DTVALID) + B8_LOTECTL + B8_NUMLOTE

	SD4->(dbSeek(xFilial("SD4") + Left(AllTrim(cOPIni), 6)))
	Do While SD4->(!Eof()) .And. Left(AllTrim(SD4->D4_OP), 6) >= Left(AllTrim(cOPIni), 6) .And. Left(AllTrim(SD4->D4_OP), 6) <= Left(AllTrim(cOPFim), 6)

		If Left(AllTrim(SD4->D4_OP), 6) $ cSelecaoOP
			SB1->(dbSeek(xFilial("SB1") + SD4->D4_COD))
			
			&& Inicio  do tratamento para náo imprimir os produtos quando o campo B1_ZZIMPET esteja igual a "N".
			&& Tratamento feito pelo Analista da Totvs IP - Alexandre J. Conselvan Fabrica de Software - Dia 19.07.2010.
			If SB1->B1_ZZIMPET = "N"
			 	dbSelectArea("SD4")
			 	dbSkip()
			 	Loop
			Endif	
			&& Final do Tratamento.
			
			If SC2->(dbSeek(xFilial("SC2") + AllTrim(SD4->D4_OP)))
				cCodCor := ""
				
				SBM->(dbSeek(xFilial("SBM") + SB1->B1_GRUPO))
				cGrupo := SBM->BM_GRUPO + "-" + SBM->BM_DESC
			EndIf
			
//			If (AllTrim(SB1->B1_TIPO) == "PI" .And. SB1->B1_ZZCOR <> "1") .Or. (Left(AllTrim(SB1->B1_COD), 6) == "RESINA") .Or. SB1->B1_LADO != cLado
//			If AllTrim(SB1->B1_TIPO) <> "PI" .Or. SB1->B1_LADO != cLado
//				SD4->(dbSkip())
//				Loop
//			EndIf
			
			cSeekSB8 := xFilial("SB8") + SB1->B1_COD + SD4->D4_LOCAL
			If SB8->(dbSeek(cSeekSB8, .T.))
				Do While SB8->(!Eof()) .And. SB8->(B8_FILIAL + B8_PRODUTO + B8_LOCAL) == cSeekSB8
					If AllTrim(SB8->B8_ORIGLAN) == "MI" .And. SB8->B8_SALDO > 0
						cLote := SB8->B8_LOTECTL
					EndIf
					
					SB8->(dbSkip())
				EndDo
			EndIf
			
			nPos := aScan(xCodProd, SD4->D4_COD)
			if nPos > 0
				xQtdProd[nPos] +=	D4_QUANT
			else
				aAdd(xCodProd,	SD4->D4_COD)
				aAdd(xQtdProd,	SD4->D4_QUANT)
				aAdd(xLoteCtl,	cLote)
				aAdd(xNomeGrp,	cGrupo)
				aAdd(xCodCor,	cCodCor)
			endIf
			cLote := ""
	/*
			aAdd(xCodProd,	SD4->D4_COD)
			aAdd(xQtdProd,	SD4->D4_QUANT)
			aAdd(xLoteCtl,	cLote)
			aAdd(xNomeGrp,	cGrupo)
			aAdd(xCodCor,	cCodCor)
			cLote := ""
	*/      
		EndIf
		dbSelectArea("SD4")
		SD4->(dbSkip())
	EndDo
	
	xCodOld		:= ""
	xGrpOld		:= ""
	xCorOld		:= ""
	_nTotQtd	:= 0	
	For _xI := 1 to Len(xCodProd)
		If !Empty(xCodOld) .And. xCodOld != xCodProd[_xI]
			SB1->(dbSeek(xFilial("SB1") +  xCodOld)) && xCodProd[_xI]))
			
			GravaEtq(dMaiorData, @aRegLog)
			
			_nTotQtd := 0
		EndIf
		
		_nTotQtd	+= xQtdProd[_xI]
		xCodOld		:= xCodProd[_xI]
		xGrpOld		:= xNomeGrp[_xI]
		cLote		:= xLoteCtl[_xI]
		xCorOld		:= xCodCor[_xI]
	Next _xI 
	
	If _nTotQtd > 0 .And. !Empty(xCodOld)
	   SB1->(dbSeek(xFilial("SB1") + xCodOld))
       GravaEtq(dMaiorData, @aRegLog)
    Endif
	
	oPrint:EndPage()
	
	oPrint:Preview()  // Visualiza antes de imprimir
Return()

***********************************************************************************************************************************************************************************************
// GravaEtq - Funcao auxiliar responsavel pela chamada da funcao para imprimir as etiquetas do produto.
***********************************************************************************************************************************************************************************************
Static Function GravaEtq(dMaiorData, aRegLog)
	Local nSaldo		:= 0
	Local cTexto		:= ""
	_nInteiro	:= 0
	_nResto		:= 0
	_nInt		:= 0


	
// 	SD4 - Requisicoes Empenhadas
// 	SD4->(dbSetOrder(2))			// D4_FILIAL + D4_OP + D4_COD + D4_LOCAL
// 	if SD4->(dbSeek(xFilial("SD4") + AllTrim(cOPFim)))
// 		dMaiorData	:= DToS(SD4->D4_DATA)
// 	endIf

	If SB1->B1_TIPO <> "MO"
		// SB2 - Saldos fisico e financeiro
		SB2->(dbSetOrder(1))			// B2_FILIAL + B2_COD + B2_LOCAL
		IF SB2->(DbSeek(xFilial("SB2") + SB1->B1_COD + "99"))
			nSaldo := SaldoSB2(.F., .F.)
		Endif   

		&& Novo tratamento para o saldo proveniente do novo conceito de produção da Ordem de produção.
		&& este tratamento foi implementado dia 03/10/2010 pelo analista Alexandre J. Conselvan da Totvs IP Campinas 
		&& O campo abaixo é ZZALMDF
		&&                   | | |-> "DF" -> Diferenciado
		&&                   | |-> "ALM" -> Almoxarifado
		&&					 |-> "ZZ" -> Campo personalizado 
		&&   Conteudo do Campo S ( SIM ) => Este produto tem o tratamento para os almoxarifados 99 e 85
		&&					   N ( NAO ) => Este produto não possui o tratamento para o almoxarifado 85 somente para o almoxarifado 99
		
		&&& If SB1->B1_ZZALMDF = "S"
		&&&  	IF SB2->(DbSeek(xFilial("SB2") + SB1->B1_COD + "85"))
		&&&  		nSaldo += SaldoSB2(.F., .F.)
		&&& 	Endif
		&&& Endif	
		&& Final do novo tratamento para buscar o valro do saldo do produto no almoxarifado 85

	Endif
		
	if nSaldo < 0
		nSaldo := 0
	endIf       
	
	// Saldo Por OP em Aberto
	cQuery	:=	"SELECT "
	cQuery	+=		"SUM(D4_QUANT) AS QtdEmAberto "
	cQuery	+=	"FROM "
	cQuery	+=		RETSQLNAME("SD4") + " SD4 "
	cQuery	+=	"WHERE "
	cQuery	+=		"D4_FILIAL = '"	+ xFilial("SD4")	+ "' AND "
	cQuery	+=		"D4_COD = '"	+ SB1->B1_COD		+ "' AND "
	cQuery	+=		"(Left(D4_OP,6) Not In "+cSelecaoOP+") AND "
	cQuery	+=		"D4_DATA <= '"	+ DtoS(dMaiorData)		+ "' AND "

	&& Novo tratamento para o saldo proveniente do novo conceito de produção da Ordem de produção.
	&& este tratamento foi implementado dia 03/10/2010 pelo analista Alexandre J. Conselvan da Totvs IP Campinas 

	cQuery	+=		"D4_QUANT > 0 AND D4_LOCAL IN ('99','85') AND D_E_L_E_T_ = ' ' "

	TCQUERY cQuery ALIAS "QrySD4" NEW    
	nSaldo -= QrySD4->QtdEmAberto

	QrySD4->(DBCloseArea())

	if _nTotQtd > nSaldo 
		_nTotQtd -= nSaldo		
		//nSaldo -= _nTotQtd
		_cQuant	:= PadL(cValToChar(Round(_nTotQtd / SB1->B1_QE, 02)), 13, '0')
		If SubStr(_cQuant, 11, 01) != "." .And. SubStr(_cQuant, 12, 01) != "."
			_cQuant	:= PadL(cValToChar(Round(_nTotQtd / SB1->B1_QE, 02)), 10, '0') + ".00"
		ElseIf SubStr(_cQuant, 12, 01) == "."
			_cQuant	:= PadL(cValToChar(Round(_nTotQtd / SB1->B1_QE, 02)), 12, '0') + "0"
		EndIf
		_nInteiro	:= Val(SubStr(_cQuant, 01, 10))
		_nResto		:= _nTotQtd - (_nInteiro * SB1->B1_QE)
		If _nResto > 0
			_nInt	:= _nInteiro + 1
		Else
			_nInt	:= _nInteiro
		EndIf

		&& Inicio  do tratamento para permitir que o produto possa a ter a quantidade via lote economico.
		&& Tratamento feito pelo Analista da Totvs IP - Alexandre J. Conselvan Fabrica de Software - Dia 19.07.2010.
		If SB1->B1_ZZQTDCO = "S"
			if _nResto < SB1->B1_QE .and. _nResto > 0  && Linhas Originais da Rotina && Implemtado a validacao do _nResto > 0 para que se imcremente + 1 na qtd de etiquetas.
				_nResto := 0 		&& Linhas Originais da Rotina
				_nInteiro ++     	&& Linhas Originais da Rotina
			endIf
	    Endif
	    && Final do tratamento do lote 

		For I := 1 to _nInteiro
			ImpEtq(SB1->B1_QE, I, cLote, @_nL, @_nC, xGrpOld, xCorOld)
			if aScan(aRegLog, {|x| x[1] == SB1->B1_COD .and. x[4] == _nInt}) == 0
				aAdd(aRegLog, {SB1->B1_COD, SB1->B1_DESCNF, SB1->B1_QE, _nInt})
			endIf
		Next I

		If _nResto > 0
			ImpEtq(_nResto, I, cLote, @_nL, @_nC, xGrpOld, xCorOld)
		EndIf
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
	Local oFont10
	Local oFont11
	Local oFont13
	Local oFont17N
	Local oFont18N
	Local oFont21N
	Local oFont24N
	Local oBrush
	Local _nItm		:= 0
	Local _ContaETQ	:= 0
	Local aCoords	:= {2000, 1900, 1340, 3280}
	Local cCGCPict	:= ""
	Local cCepPict	:= ""
	Local cTexto	:= ""
	
	oFont10  := TFont():New("Arial", 9, 10, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont11  := TFont():New("Arial", 9, 11, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont13  := TFont():New("Arial", 9, 13, .T., .F., 5,,, .T., .F.,,,,,, oPrint)
	oFont17N := TFont():New("Arial", 9, 17, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont18N := TFont():New("Arial", 9, 18, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont21N := TFont():New("Arial", 9, 21, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	oFont24N := TFont():New("Arial", 9, 24, .T., .T., 5,,, .T., .F.,,,,,, oPrint)
	
	oBrush := TBrush():New("", 4)

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
		_LI			:= 1065
		_CO			:= 0
		_LIMSBAR	:= 9
		_COMSBAR	:= 0
	ElseIf _nL == 2 .And. _nC == 2
		_LI			:= 1065
		_CO			:= 1150
		_LIMSBAR	:= 9
		_COMSBAR	:= 9.9
	ElseIf _nL == 3 .And. _nC == 1
		_LI			:= 2130
		_CO			:= 0
		_LIMSBAR	:= 18
		_COMSBAR	:= 0
	ElseIf _nL == 3 .And. _nC == 2
		_LI			:= 2130
		_CO			:= 1150
		_LIMSBAR	:= 18
		_COMSBAR	:= 9.7
	EndIf

	//deslocamento - margens
	_LI += 20
	_CO += 50
	
	oPrint:Box(_LI + 18, _CO + 18, _LI + 1033, _CO + 1113)
	oPrint:Box(_LI + 23, _CO + 23, _LI + 1028, _CO + 1108)
	
	_LI += 20
	_CO += 25

	oPrint:Say(_LI + 10, _CO + (1090 / 2), "PRODUÇÃO HLS", oFont24N,,, 1, 2)
	_LI += 100
	//Grupo DA PECA ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI, _CO, _LI,_CO + 1090)								//Linha Horizontal
//	oPrint:Say(_LI, _CO + (1090 / 2),"ENTREGAR:" + AllTrim(SubStr(xGrpOld, 1, 35)),			oFont13,,, 1, 2)
	_LI += 25
	//Primeiro quadro - NOME DA PECA ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	oPrint:Say(_LI, _CO + (1090 / 2), "NOME DA PEÇA",										oFont13,,, 1, 2)
	_LI += 50
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	_LI += 50
	oPrint:Say(_LI - 20,_CO + (1090 / 2), AllTrim(SubStr(SB1->B1_DESCNF, 1, 40)),				oFont17N,,, 1, 2)
	_LI += 70
	//Segundo quadro - CODIGO DA PECA ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI, _CO, _LI,_CO + 1090)//Linha Horizontal
	oPrint:Say(_LI,_CO + (750 / 2), "CÓDIGO HONDA LOCK",									oFont13,,, 1, 2)
	oPrint:Say(_LI,_CO + 750 + ((1090 - 750) / 2), "LADO",									oFont13,,, 1, 2)
	oPrint:Line(_LI, _CO + 750, _LI + 170, _CO + 750)					//Linha Vertical
	oPrint:Line(_LI, _CO + 755, _LI + 170, _CO + 755)					//Linha Vertical
	_LI += 50
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	_LI += 50
	oPrint:Say(_LI - 20, _CO + (750 / 2), AllTrim(SB1->B1_COD),								oFont21N,,, 1, 2)
	If SB1->B1_LADO $ "LR"
		oPrint:Say(_LI - 20, _CO + 750 + ((1090 - 750) / 2), AllTrim(SB1->B1_LADO),			oFont21N,,, 1, 2)
	EndIf
	_LI += 70
	//Terceiro quadro - CODIGO CLIENTE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)								//Linha Horizontal
	oPrint:Say(_LI,_CO + (1090 / 2), "CÓDIGO DE BARRAS DO CÓDIGO HONDA LOCK",				oFont13,,, 1, 2)
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
	oPrint:Say(_LI, _CO + (1090 / 4) * 1, "DATA DE FORNECIMENTO",							oFont11,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 4) * 3, "NÚMERO DO LOTE - HLS",							oFont11,,, 1, 2)
	_LI += 50
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)//Linha Horizontal
	_LI += 50
	oPrint:Say(_LI - 20, _CO + (1090 / 4), DToC(ddatabase),									oFont21N,,, 1, 2)
	oPrint:Say(_LI - 20, _CO + (1090 / 4) * 3, AllTrim(_cLote),								oFont21N,,, 1, 2)
	_LI += 70
	//Ultimo quadro - Quantidades///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	oPrint:Line(_LI,_CO, _LI, _CO + 1090)//Linha Horizontal
	oPrint:Line(_LI, _CO + (1090 / 4),			_LI + 175, _CO + (1090 / 4))			//Linha Vertical
	oPrint:Line(_LI, _CO + (1090 / 4) + 5,		_LI + 175, _CO + (1090 / 4) + 5)		//Linha Vertical
	oPrint:Line(_LI, _CO + (1090 / 4) * 3,		_LI + 175, _CO + (1090 / 4) * 3)		//Linha Vertical
	oPrint:Line(_LI, _CO + (1090 / 4) * 3 + 5,	_LI + 175, _CO + (1090 / 4) * 3 + 5)	//Linha Vertical
	oPrint:Say(_LI, _CO + (1090 / 8) * 1, "CAPACIDADE",										oFont10,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 3, "QUANTIDADE",										oFont10,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 5, "SEQUENCIA",										oFont10,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 7, "RESPONSAVEL",									oFont10,,, 1, 2)
	_LI += 50
	oPrint:Line(_LI, _CO, _LI, _CO + 1090)//Linha Horizontal
	_LI += 50
	oPrint:Say(_LI, _CO + (1090 / 8) * 1, cValToChar(SB1->B1_QE),							oFont18N,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 3, cValToChar(_nQtdEtq),								oFont18N,,, 1, 2)
	oPrint:Say(_LI, _CO + (1090 / 8) * 5, cValToChar(_nSeq) + "/" + cValToChar(_nInt),		oFont18N,,, 1, 2)
	_LI += 70
	
	If _nL == 3 .And. _nC == 2
		oPrint:EndPage()      
	EndIf
Return(.T.)

*************************************************************************************************************************************************************************
// Funcao para criar as perguntas no arquivo SX1
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

*************************************************************************************************************************************************************************
// GeraArqLog - Waldir Baldin - 06/07/2010 - Funcao para gerar o Arquivo de Log onde o operador selecionar e com o nome que desejar.
*************************************************************************************************************************************************************************
Static Function GeraArqLog(aRegLog)
	Local nI		:= 0
	Local cLinha	:= ""
	Local cTexto	:= ""
	Local cArqLog	:= ""
	Local cTipo		:= ""

	// Tipos de Arquivo
	cTipo := "*.TXT           | *.TXT |   "
	cTipo += "Todos os Arquivos *.* | *.* "

	cArqLog := allTrim(cGetFile(cTipo, "Selecione um Arquivo para Log"))
	if !empty(cArqLog)
		if at(".", cArqLog) == 0
			cArqLog += ".txt"					// Se não tem extensao, atribui como padrao a extensao ".txt".
		endIf

		cTexto := "Codigo           Nome da Peça                              Capacidade       Total  Qtde.Etq."	+ CRLF
		cTexto += "===============  ========================================  ==========  ==========  ========="	+ CRLF
		for nI := 1 to len(aRegLog)
			cLinha := allTrim(aRegLog[nI, 01]) + space(17 - len(allTrim(aRegLog[nI, 01])))
			cLinha += allTrim(aRegLog[nI, 02]) + space(42 - len(allTrim(aRegLog[nI, 02])))
			cLinha += transform(aRegLog[nI, 03], "@E 999,999.99") + space(02)
			cLinha += transform(aRegLog[nI, 03] * aRegLog[nI, 04], "@E 999,999.99") + space(02)
			cLinha += transform(aRegLog[nI, 04], "@E 9,999.999")
			cTexto += cLinha																						+ CRLF
		next nI
		cTexto += "____________________________________________________________________________________________"	+ CRLF		
		cTexto += CRLF + "Impresso em "
		cTexto += strZero(day(dDataBase), 02) + "/" + strZero(month(dDataBase), 02) + "/" + cValToChar(year(dDataBase))
		cTexto += " às " + time()																					+ CRLF
		cTexto += CRLF																								+ CRLF
		cTexto += "Conferente da(s) Etiqueta(s)"																	+ CRLF
		cTexto += CRLF + CRLF																						+ CRLF
		cTexto += "___________________________________          ____/____/______"									+ CRLF
		cTexto += CRLF + CRLF																						+ CRLF
		cTexto += "Conferente do(s) Apontamento(s)"																	+ CRLF
		cTexto += CRLF + CRLF																						+ CRLF
		cTexto += "___________________________________          ____/____/______"									+ CRLF
		MemoWrit(cArqLog, cTexto)

		Alert("Arquivo de log gerado como: " + cArqLog)
	endIf
Return