#Include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INDA040  ³ Autor ³ Ronilton O. Barros    ³ Data ³ 09.02.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de Rateio dos lancamentos da folha                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros usados na rotina                   ³
//³ mv_par01         Data de ?                    ³
//³ mv_par02         Data Ate?                    ³
//³ mv_par03         Matr. de ?                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User function INCTBP03()//INDA040()
	Local cCadastro := OemtoAnsi("Rateio dos Pre-Lancamentos da Folha")
	Local aSays     := {}
	Local aButtons  := {}
	Local cPerg     := Padr("IND040",Len(SX1->X1_GRUPO))
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays,OemToAnsi("Esta rotina ira ratear os pre-lancamentos com origem da folha  de  acordo") )
	AADD(aSays,OemToAnsi("com a tabela de rateio do SIATA, e  conforme  o  periodo  informado  pelo") )
	AADD(aSays,OemToAnsi("usuario.                                                                 ") )
	
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
	AADD(aButtons, { 1,.T.,{|o| Processa({|| Ratear() },"Rateio de Pre-Lancamento"), FechaBatch() }})
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
Return

Static Function Ratear()
	Local aDbf, cArq, cQuery, nRegis, cNumLin, cDocLote, cFile, lApaga
	Local cFile := "\CT2TMP" + GetDBExtension()
	Local cTmp  := "CT2"   //"TMP"  //<-- Quando for executar oficialmente, mudar o alias para CT2
	
	Private aRateio   := {}
	Private nTamLinha := TamSX3("CT2_LINHA")[1]
	Private nTamItemC := TamSX3("CT2_ITEMD")[1]
	
	If cTmp <> "CT2"
		//- Cria DBF temporario para guardar os registros do CT2 gerados pela rotina
		aDbf   := CT2->( dbStruct() )
		cArq   := CriaTrab( aDbf , .T. )
		Use &cArq Alias TMP New Exclusive
	Endif
	
	//- Verificando o numero do ultimo documento do lote = "008890" sublote = "001"
	cQuery := "SELECT MAX(CT2_DOC) CT2_DOC"
	cQuery += " FROM "+RetSQLName("CT2")
	cQuery += " WHERE D_E_L_E_T_ = ' '"
	cQuery += " AND CT2_FILIAL = '"+XFILIAL("CT2")+"'"
	cQuery += " AND CT2_DATA >= '"+Dtos(mv_par01)+"'"
	cQuery += " AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
	cQuery += " AND CT2_LOTE = '008890'"
	If cTmp == "CT2"
		cQuery += " AND CT2_TPSALD = '9'"
		cQuery += " AND CT2_SIATA = '  '"
	Endif
	cQuery += " AND (CT2_ITEMD <> '"+Space(TamSX3("CT2_ITEMD")[1])+"'"
	cQuery += " OR CT2_ITEMC <> '"+Space(TamSX3("CT2_ITEMC")[1])+"')"
	
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
	cDocLote:= StrZero(Val(CT2_DOC)+1,6)
	dbCloseArea()
	
	// Monta query filtrando os registros validos a serem reateados */
	// 008890 -> Lote da folha
	// 9 -> Pre-lancamento
	
	cQuery := "SELECT COUNT(*) SOMA"
	cQuery += " FROM "+RetSQLName("CT2")
	cQuery += " WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"'"
	cQuery += " AND D_E_L_E_T_ = ' '"
	cQuery += " AND CT2_DATA >= '"+Dtos(mv_par01)+"'"
	cQuery += " AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
	cQuery += " AND CT2_LOTE = '008890'"
	If cTmp == "CT2"
		cQuery += " AND CT2_TPSALD = '9'"
		cQuery += " AND CT2_SIATA = '  '"
	Endif
	cQuery += " AND (CT2_ITEMD <> '"+Space(TamSX3("CT2_ITEMD")[1])+"'"
	cQuery += " OR CT2_ITEMC <> '"+Space(TamSX3("CT2_ITEMC")[1])+"')"
	
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
	nRegis := SOMA
	dbCloseArea()
	
	cQuery := StrTran(cQuery,"COUNT(*) SOMA","*, R_E_C_N_O_ CT2_RECNO")
	cQuery += " ORDER BY CT2_DATA, CT2_SBLOTE, CT2_DOC, CT2_LINHA"
	
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,CHANGEQUERY(cQuery)), "QRY", .F., .T.)
	ProcRegua(nRegis)
	
	While !Eof()
		
		IncProc("Rateando...")
		
		If !Empty(mv_par03)
			If !Empty(CT2_ITEMD) .and. CT2_ITEMD <> mv_par03
				dbSkip()
				Loop
			Endif
			If !Empty(CT2_ITEMC) .and. CT2_ITEMC <> mv_par03
				dbSkip()
				Loop
			Endif
		Endif
		
		lApaga := .F.    // Define se exclui o lançamento contábil
		
		Rateia(CT2_ITEMD, "D", @cNumLin, @cDocLote, @lApaga, cTmp )  // Rateia o item contabil a debito
		Rateia(CT2_ITEMC, "C", @cNumLin, @cDocLote, @lApaga, cTmp )  // Rateia o item contabil a credito
		
		If lApaga
			//- Apaga o registro do CT2 pois será rateado
			dbSelectArea("CT2")
			dbGoTo(QRY->CT2_RECNO)
			RecLock("CT2",.F.)
			dbDelete()
			MsUnLock()
			dbSelectArea("QRY")
		Endif
		
		dbSkip()
	Enddo
	dbCloseArea()
	
	If cTmp <> "CT2"
		dbSelectArea("TMP")
		dbCloseArea()
		If File(cFile)
			FErase(cFile)
		Endif
		FRename(cArq+GetDBExtension(),cFile)
		
		cPath := GetTempPath()
		
		If File(StrTran(cPath+cFile,"\\","\"))
			FErase(StrTran(cPath+cFile,"\\","\"))
		Endif
		
		CpyS2T(cFile, cPath, .T.)
	Endif
	
Return

Static Function Rateia(cItemCta, cDC, cNumLin, cDocLote, lApaga, cTmp)
	Local cMatric, cDatarq, vProj, nSoma, nX, nY, vCT2, nPos, cFilSZ1
	
	CT2->(dbGoTo(QRY->CT2_RECNO))  // Devolve a posicao original do registro do CT2
	
	//- Verificando se o item ja foi rateado se esta informada a matricula
	If (cTmp <> "CT2" .Or. Empty(CT2->CT2_SIATA)) .And. !Empty(cItemCta)
		
		cMatric := Padr(SubStr(cItemCta,1,6),nTamItemC)
		cDatarq := SubStr(CT2_DATA,1,6)
		
		// Pesquisa se o FUNCIONÁRIO + ANO + MES já não foi rateado
		If ( nPos := AScan( aRateio , {|x| x[1]+x[2] == cMatric+cDatarq } ) ) == 0
			cFilSZ1 := XFILIAL("SZ1")
			vProj   := {}
			
			//- Rateia lancamentos a partir dos percentuais encontrados no SIATA
			SZ1->(dbSetOrder(2))
			SZ1->(dbSeek(cFilSZ1+cMatric+cDatarq,.T.))
			While !SZ1->(Eof()) .And. cFilSZ1+cMatric+cDatarq == SZ1->(Z1_FILIAL+Z1_MAT+SubStr(Dtos(Z1_DATA),1,6))
				AAdd( vProj , { SZ1->Z1_CC, 0, SZ1->Z1_PERC})
				SZ1->(dbSkip())
			Enddo
			
			// Adiciona os dados encontrados no vetor de rateio
			AAdd( aRateio , { cMatric, cDatarq, aClone(vProj)} )
			nPos := Len(aRateio)
		Endif
		
		If Empty(aRateio[nPos,3])   // Caso não tenha encontrado rateio para o funcionário no período
			dbSelectArea("QRY")
			Return cNumLin
		Endif
		
		vProj := aClone(aRateio[nPos,3])
		vCT2  := CopiaRegitro()  // Guarda os conteudos do campos do CT2
		nSoma := 0
		
		Begin Transaction
		
		If Len(vProj) > 1  // Caso o pre-lancamento gere dois ou mais registros
			vCT2[5] := cDocLote
			
			If cTmp == "CT2"
				lApaga := .T.
			Endif
		Endif
		
		//- Regrava os dados já rateados
		For nX:=1 To Len(vProj)
			
			dbSelectArea(cTmp)
			
			If Len(vProj) > 1 .Or. cTmp <> "CT2"
				RecLock(cTmp,.T.)
				For nY:=1 To (cTmp)->(FCount())
					FieldPut( nY , vCT2[nY] )
				Next
			Else
				RecLock(cTmp,.F.)
			Endif
			
			// Regrava os campos para acerto do rateio
			If cDC == "D"
				(cTmp)->CT2_CCD    := vProj[nX,1]
				(cTmp)->CT2_DEBITO := GravaConta(cDC)
			Else
				(cTmp)->CT2_CCC    := vProj[nX,1]
				(cTmp)->CT2_CREDIT := GravaConta(cDC)
			Endif
			(cTmp)->CT2_SIATA := "Rt"
			
			If Len(vProj) > 1  // Caso tenha mais de um registro
				// Calcula o valor do rateio
				vProj[nX,2] := Round(QRY->CT2_VALOR * vProj[nX,3],2)
				nSoma += vProj[nX,2]
				
				If nX == Len(vProj)  // Caso o pre-lancamento gere dois ou mais registros
					vProj[nX,2] += (QRY->CT2_VALOR - nSoma)  // Acerta a diferenca de centavos
				Endif
				
				If cNumLin == nil
					cNumLin:= StrZero(1,nTamLinha)
				Else
					cNumLin:= StrZero(Val(cNumLin)+1,nTamLinha)
				Endif
				
				If Val(cNumLin) > 998
					cDocLote:= StrZero(Val(cDocLote)+1,6)
					cNumLin:= StrZero(1,nTamLinha)
				Endif
				
				(cTmp)->CT2_DOC   := cDocLote
				(cTmp)->CT2_LINHA := cNumLin
				(cTmp)->CT2_VALOR := vProj[nX,2]
			Endif
			
			MsUnLock()
		Next
		
		End Transaction
		dbSelectArea("QRY")
	Endif
	
Return cNumLin

Static Function CopiaRegitro()
	Local x
	Local aRet := {}
	
	// Guarda os conteudos do campos do CT2
	For x:=1 To CT2->(FCount())
		AAdd( aRet , CT2->(FieldGet(x)) )
	Next
	
Return aClone(aRet)

Static Function GravaConta(cDC)
	Local cString := Trim(CT2_ORIGEM)
	Local cPesq   := "VERBA"
	Local nPIni   := At(cPesq,cString) + Len(cPesq)
	Local cVerba  := ""
	Local cRet    := If( cDC == "D" , CT2_DEBITO, CT2_CREDIT)
	Local nP 
	If nPIni > 0   // Caso tenha encontrada a posição da verba
	 	// Busca a verba usada no lançamento contábil
		For nP:=nPIni To Len(cString)
			If SubStr(cString,nP,1) $ "0123456789"
				cVerba += SubStr(cString,nP,1)
			Endif
		Next
		
		If !Empty(cVerba)   // Se conseguiu encontrar a verba
			SRV->(dbSetOrder(1))
			If SRV->(dbSeek(XFILIAL("SRV")+cVerba))
				If cDC == "D"
					If !Empty(CT2_CCD)
						If SubStr(CT2_CCD,1,1) == "6"   // Se for PROJETO
							cRet := If( Empty(SRV->RV_ACTADB), cRet, SRV->RV_ACTADB)
						Else
							cRet := If( Empty(SRV->RV_CTADEB), cRet, SRV->RV_CTADEB)
						Endif
					Endif
				Else
					If !Empty(CT2_CCC)
						If SubStr(CT2_CCC,1,1) == "6"   // Se for PROJETO
							cRet := If( Empty(SRV->RV_ACTACR ), cRet, SRV->RV_ACTACR )
						Else
							cRet := If( Empty(SRV->RV_CTACRED), cRet, SRV->RV_CTACRED)
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
	
Return cRet

Static Function ValidPerg(cPerg)
	Local i, j, aRegs, _sAlias := Alias()
	
	aRegs := {}
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	AADD(aRegs,{cPerg,"01","Da Data            ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","",;
					"","","","","","","","","","","","","","","","","","","","","   "})
	AADD(aRegs,{cPerg,"02","Ate a Data         ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","",;
					"","","","","","","","","","","","","","","","","","","","","   "})
	AADD(aRegs,{cPerg,"03","Do Colaborador               ?","","","mv_ch3","C",09,0,0,"G","","mv_par03",;
					"","","","","","","","","","","","","","","","","","","","","","","","","CTD"})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif
	Next
	dbSelectArea(_sAlias)
Return
