#Include "rwmake.ch"
#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa  ³ afCmplNFE º Autor ³ Michel Sander      º Data ³ 27.05.11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.     ³ Ponto de Entrada para complemento das informacoes da     º±±
±±º           ³ nota fiscal de importacao.                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function afCmplNFE()

Local aArea     := GetArea()
Local lVerifyEX := .T.

Private	_oDlg1
Private oGetTrans

// GetDados
Private nSuperior    := C(050)						// Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Private nEsquerda    := C(004)						// Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Private nInferior    := C(110)						// Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Private nDireita     := C(183)						// Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
Private nOpcSF1      := 3							// 1- Visualizar, 2- Incluir, 3- Alterar, 4-Excluir
Private cLinhaOk     := "AllwaysTrue"				// Funcao executada para validar o contexto da linha atual do aCols
Private cTudoOk      := "AllwaysTrue"				// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Private cIniCpos     := ""							// Nome dos campos do tipo caracter que utilizarao incremento automatico.
Private aAlter       := {"D1_X_ADICA", "D1_X_ITADC"}	// Campos alteráveis da GetDados
Private nFreeze      := 000							// Campos estaticos na GetDados.
Private nMax         := 999							// Numero maximo de linhas permitidas. Valor padrao 99
Private cCampoOk     := "AllwaysTrue"				// Funcao executada na validacao do campo
Private cSuperApagar := ""							// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Private cApagaOk     := "AllwaysFalse"				// Funcao executada para validar a exclusao de uma linha do aCols
Private aHeaderSF1   := MontEstr(1)					// aHeader GetDados
Private aColsSF1     := {}							// aCols   GetDados

// Nota
Private cDocLoc2  := Space(TamSX3("F1_DOC")[1])
Private cSerieLoc := Space(TamSX3("F1_SERIE")[1])

//Transporte
Private nVolume  := 0
Private nPesoBru := 0
Private nPesoliq := 0

//Importação
Private dDataDi  := sTod("")
Private dDtDesem := sTod("")
Private cNDi     := Space(TamSX3("F1_XDI")[1])
Private cUFDesem := Space(TamSX3("F1_XUFDES")[1])
Private cLocDes  := Space(TamSX3("F1_XLCDES")[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Verifica se a nota fiscal refere-se a importação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
If FunName() == "MATA103"	// Foi acionado via inclução de Doc de Entrada - PE
	If SF1->F1_FORMUL = "S" .AND. Upper(AllTrim(SF1->F1_ESPECIE)) = "SPED" .And. !SF1->F1_TIPO $ "D,B"	// Diferente de devolução ou beneficiamento
		If SA2->(dbSeek(xFilial("SA2") + SF1->(F1_FORNECE + F1_LOJA)))
			If SA2->A2_EST <> "EX"
				lVerifyEX := .F.
			Else
				cDocLoc2  := SF1->F1_DOC
				cSerieLoc := SF1->F1_SERIE
				MontEstr(2) 
			EndIf
		EndIf
	Else
		lVerifyEX := .F.
	EndIf 
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Prepara digitacao dos dados de importação		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
If lVerifyEX
	@ C(090), C(001) To C(430), C(370) Dialog _oDlg1 Title "Dados Complementares"
	
	@ C(010), C(005) Say OemtoAnsi("Número DI") PIXEL OF _oDlg1
	@ C(010), C(045) MsGet oEdit1 Var cNDi  Size C(040), C(006) PIXEL OF _oDlg1
	
	@ C(010), C(090) Say OemtoAnsi("Emissao DI") PIXEL OF _oDlg1
	@ C(010), C(140) MsGet oEdit1 Var dDataDi Valid (dDataDi <= dDataBase) Size C(040), C(006) PIXEL OF _oDlg1
	
	@ C(020), C(005) Say OemtoAnsi("UF de Desembaraço") PIXEL OF _oDlg1
	@ C(020), C(045) MsGet oEdit1 Var cUFDesem F3 "12" VALID (!Empty(Tabela("12", cUFDesem, .F.))) Size C(019), C(006) PIXEL OF _oDlg1
	
	@ C(020), C(090) Say OemtoAnsi("Dt Desembaraço") PIXEL OF _oDlg1
	@ C(020), C(140) MsGet oEdit1 Var dDtDesem  Valid (dDtDesem <= dDataBase) Size C(040), C(006) PIXEL OF _oDlg1
	
	@ C(030), C(005) Say OemtoAnsi("Local Desembaraço") PIXEL OF _oDlg1
	@ C(030), C(045) MsGet oEdit1 Var cLocDes Size C(140), C(006) PIXEL OF _oDlg1
	
	oGetTrans := MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita, nOpcSF1, cLinhaOk, cTudoOk, cIniCpos, aAlter, nFreeze, nMax,;
												cCampoOk, cSuperApagar, cApagaOk, _oDlg1, aHeaderSF1, aColsSF1)
	CrgDadosEnt(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA,oGetTrans)
	
	@ C(130), C(055) Button OemtoAnsi("Cadastrar") Size C(037), C(012) Action(Grava(oGetTrans)) PIXEL OF _oDlg1
	@ C(130), C(095) Button OemtoAnsi("Cancelar") Size C(037), C(012) Action(_oDlg1:END()) PIXEL OF _oDlg1
	
	Activate Dialog _oDlg1 Centered
Endif

RestArea(aArea)

Return(.T.)


// Atualiza os campos no cabeçalho da nota de importacao
Static Function Grava(oGetTrans)

Local aAreaQ    := GetArea()
Local nRegAcols := Len(oGetTrans:aCols)
Local nB        := 0
Local nAdicao   := GdFieldPos("D1_X_ADICA", oGetTrans:aHeader)
Local nSeqAdi   := GdFieldPos("D1_X_ITADC", oGetTrans:aHeader)
Local nCodLoc   := GdFieldPos("D1_COD"    , oGetTrans:aHeader)
Local nItLoc    := GdFieldPos("D1_ITEM"   , oGetTrans:aHeader)
Local nRecAcl   := 5 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Atualiza os campos de importação na nota fiscal	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
DbSelectArea("SF1")
DbSetOrder(1)
If cDocLoc2 + cSerieLoc == SF1->(F1_DOC + F1_SERIE)
	RecLock("SF1", .F.)
		//Importação
		SF1->F1_XDI    := cNDI
		SF1->F1_XDTDI  := dDataDi
		SF1->F1_XUFDES := cUfDesem
		SF1->F1_XLCDES := cLocDes
		SF1->F1_XDTDES := dDtDesem       
		//SF1->F1_IMPORT := "S"
	MsUnlock()
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	For nB := 1 To nRegAcols
		If SD1->(dbSeek(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + oGetTrans:aCols[nB, nCodLoc] + oGetTrans:aCols[nB, nItLoc]))
			RecLock("SD1", .F.)
				SD1->D1_X_ADICA := oGetTrans:aCols[nB, nAdicao]
				SD1->D1_X_ITADC := oGetTrans:aCols[nB, nSeqAdi]
			MsUnLock()
			
			RecLock("CD5", .T.)
				CD5->CD5_FILIAL := xFilial("CD5")
				CD5->CD5_DOC    := SF1->F1_DOC
				CD5->CD5_SERIE  := SF1->F1_SERIE
				CD5->CD5_ESPEC  := SF1->F1_ESPECIE
				CD5->CD5_FORNEC := SF1->F1_FORNECE
				CD5->CD5_LOJA   := SF1->F1_LOJA
				CD5->CD5_TPIMP  := '0'
				CD5->CD5_DOCIMP := SF1->F1_XDI
				CD5->CD5_NDI    := SF1->F1_XDI
				CD5->CD5_DTDI   := SF1->F1_XDTDI
				CD5->CD5_LOCDES := SF1->F1_XLCDES
				CD5->CD5_UFDES  := SF1->F1_XUFDES
				CD5->CD5_DTDES  := SF1->F1_XDTDES
				CD5->CD5_CODEXP := SF1->F1_FORNECE
				CD5->CD5_NADIC  := SD1->D1_X_ADICA
				CD5->CD5_SQADIC := SD1->D1_X_ITADC
				CD5->CD5_CODFAB := SF1->F1_FORNECE
				CD5->CD5_ITEM   := SD1->D1_ITEM
				CD5->CD5_LOJEXP := SF1->F1_LOJA
				CD5->CD5_LOJFAB := SF1->F1_LOJA
				CD5->CD5_LOCAL  := "0"
				CD5->CD5_VTRANS := "1"
				CD5->CD5_INTERM := "1"
				
				If CD5->(FieldPos("CD5_VAFRMM")) > 0                                                                     
				   CD5->CD5_VAFRMM := SD1->D1_AFRMIMP
				EndIf                      
				
			MsUnlock()
		EndIf
	Next nB
	Close(_oDlg1)
Else
	Alert(" Nota não encontrada, verifique os parametros ")
EndIf

RestArea(aAreaQ)

Return()


// Carrega os dados para a tela de entrada
Static Function CrgDadosEnt(cDocLoc2, cSerieLoc, cFornLoc, cLojaLoc, oGetTrans)

Local aArea := GetArea()
Local lRet  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Prepara as variaveis da importação				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
If cDocLoc2 + cSerieLoc == SF1->(F1_DOC + F1_SERIE)
	//Importação
	cNDi     := Iif(!Empty(SF1->F1_XDI), SF1->F1_XDI, Space(TamSX3("F1_XDI")[1]))
	dDataDi  := Iif(!Empty(DToS(SF1->F1_XDTDI)), SF1->F1_XDTDI, SToD(""))
	cLocDes  := Iif(!Empty(SF1->F1_XLCDES), SF1->F1_XLCDES, Space(TamSX3("F1_XLCDES")[1]))
	cUFDesem := Iif(!Empty(SF1->F1_XUFDES), SF1->F1_XUFDES, Space(TamSX3("F1_XUFDES")[1]))
	dDtDesem := Iif(!Empty(DToS(SF1->F1_XDTDES)), SF1->F1_XDTDES, SToD(""))
	oGetTrans:aCols	:= MontEstr(2)
	_oDlg1:Refresh()
	oGetTrans:Refresh()
Else
	If !Empty(cDocLoc2 + cSerieLoc) 
		Alert(" Nota não encontrada, verifique os parametros ")
		lRet := .F.
	Else
		lRet := .T.
	EndIf
EndIf

RestArea(aArea)

Return(lRet)


// Montagem de aHEADER e aCOLS na tela de entrada
Static Function MontEstr(nOpcGet)

Local aArea   := GetArea()
Local aTabs   := {}
Local aCabDet := {}
Local _nN     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Montagem do aHEADER								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
If nOpcGet == 1	//aHeader
	dbSelectArea("SX3")
	aAdd(aTabs, {Alias(), IndexOrd(), Recno()})
	dbSetOrder(1)
	dbGoTop()
	MsSeek("SD1")
	
	aAdd(aCabDet, {"Item", "D1_ITEM", "@!", 4, 0, "", "", "C", "", ""})
	While SX3->(!Eof()) .And. (SX3->X3_ARQUIVO == "SD1")	// aHeader
	      If SD1->(FieldPos("D1_AFRMIMP")) > 0      
		     If AllTrim(X3_CAMPO) $ "D1_COD,D1_X_ADICA,D1_X_ITADC,D1_AFRMIMP"
			    aAdd(aCabDet, {AllTrim(X3_TITULO), AllTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "", "", X3_TIPO, "", ""})
		     EndIf
		  Else    
		     If AllTrim(X3_CAMPO) $ "D1_COD,D1_X_ADICA,D1_X_ITADC"
			    aAdd(aCabDet, {AllTrim(X3_TITULO), AllTrim(X3_CAMPO), X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "", "", X3_TIPO, "", ""})
		     EndIf
		  EndIf
		dbskip()
	EndDo
Else
	dbSelectArea("SD1")
	aAdd(aTabs, {Alias(), IndexOrd(), Recno()})
	dbSetOrder(1)
	If dbSeek(xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE))
		While !Eof("SD1") .And. SF1->(F1_DOC + F1_SERIE + F1_FORNECE) == SD1->(D1_DOC + D1_SERIE + D1_FORNECE)
		      If SD1->(FieldPos("D1_AFRMIMP")) > 0
			     aAdd(aCabDet, {SD1->D1_ITEM, SD1->D1_COD, SD1->D1_X_ADICA, SD1->D1_X_ITADC,SD1->D1_AFRMIMP, Recno(), .F.}) 
			  Else
			     aAdd(aCabDet, {SD1->D1_ITEM, SD1->D1_COD, SD1->D1_X_ADICA, SD1->D1_X_ITADC, Recno(), .F.}) 
			  EndIf   
			dbSkip()
		EndDo
	EndIf
EndIf

For _nN := 1 To Len(aTabs)
	dbSelectArea(aTabs [_nN, 1])
	dbSetOrder(aTabs[_nN, 2])
	dbGoto(aTabs[_nN, 3])
Next _nN

RestArea(aArea)

Return(aCabDet)
