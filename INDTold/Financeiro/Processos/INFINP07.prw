#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INFINP07   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 16/04/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de geração dos dados da contabilidade para o MCT       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01         Da Data                      ?
//³ mv_par02         Ate a Data                   ?
//³ mv_par03         Do Projeto                   ?
//³ mv_par04         Ate o Projeto                ?
//³ mv_par05         Cons. Filiais abaixo         ?
//³ mv_par06         Da Filial                    ?
//³ mv_par07         Ate a Filial                 ?
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿


User Function INFINP07()
	Local cPerg     := PADR("INFINP07",Len(SX1->X1_GRUPO))
	Local cCadastro := OemtoAnsi("Exportação Dados do MCT")
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays,OemToAnsi("Esta rotina irá exportar os dados do MCT para uma base paralela para posterior") )
	AADD(aSays,OemToAnsi("manutenção das informações. Os dados serão exportados conforme parâmetros. ") )
	
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
		Processa({|| RunProc() },"Exportação dados do MCT")
	EndIf
	
Return

Static Function RunProc()
	Local cQry, cArq, cInd, cKey, cOrigem, cQuebra, cSequen, cFiltro, nV, cSZ3, dDtDispo
	
	// Monta query de filtro dos registros da Base MCT
	cSZ3 := " FROM "+RetSQLName("SZ3")+" SZ3"
	cSZ3 += " WHERE SZ3.D_E_L_E_T_ = ' '"
	cSZ3 += " AND SZ3.Z3_DTDISPO >= '"+Dtos(mv_par01)+"' AND SZ3.Z3_DTDISPO <= '"+Dtos(mv_par02)+"'"
	cSZ3 += " AND SZ3.Z3_CC >= '"+mv_par03+"' AND SZ3.Z3_CC <= '"+mv_par04+"'"
	cSZ3 += " AND SZ3.Z3_REGBLQ NOT IN ('3','4')"
	
	If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
		cSZ3 += " AND SZ3.Z3_FILORIG >= '"+mv_par06+"' AND SZ3.Z3_FILORIG <= '"+mv_par07+"'"
	Else
		cSZ3 += " AND SZ3.Z3_FILORIG = '"+xFilial("SZ3")+"'"
	Endif
	
	// Processa a exclusão da base paralela do MCT
	cQry := "UPDATE SZ3 SET SZ3.D_E_L_E_T_ = '*'" + cSZ3
	
	If TCSQLExec(cQry) < 0   // Caso tenha dado erro na gravação
		Alert("TCSQLError() " + TCSQLError())
		Return
	Endif
	
	// Processa a atualização/exclusão da base paralela do MCT
	cQry := "UPDATE SZ0 SET SZ0.D_E_L_E_T_ = (CASE WHEN SZ3.Z3_REGS > 0 THEN ' ' ELSE '*' END), SZ0.Z0_VALOR = SZ3.Z3_VALOR"
	cQry += " FROM "+RetSQLName("SZ0")+" SZ0"
	cQry += " INNER JOIN ("
	cQry += "	SELECT SZ3.Z3_CHAVE,"
	cQry += "	SUM("
	cQry += "		CASE "
	cQry += "			WHEN SZ3.Z3_ATIVO = 'N' OR SZ3.D_E_L_E_T_ = '*' THEN 0"
	cQry += "			WHEN SZ3.Z3_RECPAG = 'P' THEN SZ3.Z3_VALOR"
	cQry += "			ELSE -SZ3.Z3_VALOR END) AS Z3_VALOR,"
	cQry += "	SUM(CASE WHEN SZ3.D_E_L_E_T_ = ' ' THEN 1 ELSE 0 END) AS Z3_REGS "
	cQry += "	FROM "+RetSQLName("SZ3")+" SZ3"
	cQry += "	WHERE SZ3.Z3_DTDISPO >= '"+Dtos(mv_par01)+"' AND SZ3.Z3_DTDISPO <= '"+Dtos(mv_par02)+"'"
	cQry += "	AND SZ3.Z3_ROTINA <> 'GPEM670'"
	cQry += "	GROUP BY SZ3.Z3_CHAVE"
	cQry += ") SZ3 ON SZ3.Z3_CHAVE = SZ0.Z0_CHAVE"
	cQry += " WHERE SZ0.D_E_L_E_T_ = ' '"

	If TCSQLExec(cQry) < 0   // Caso tenha dado erro na gravação
		Alert("TCSQLError() " + TCSQLError())
		Return
	Endif
	
	// Filtra os dados a serem exportados para base paralela do MCT
	cQry := "SELECT COUNT(*) SOMA"
	cQry += " FROM "+RetSQLName("CT2")+" CT2"
	cQry += " WHERE D_E_L_E_T_ = ' '"
	cQry += " AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
	cQry += " AND ((CT2_CCD >= '"+mv_par03+"' AND CT2_CCD <= '"+mv_par04+"')"
	cQry += " OR (CT2_CCC >= '"+mv_par03+"' AND CT2_CCC <= '"+mv_par04+"'))"
	
	If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
		cQry += " AND CT2_FILIAL >= '"+mv_par06+"' AND CT2_FILIAL <= '"+mv_par07+"'"
	Else
		cQry += " AND CT2_FILIAL = '"+xFilial("CT2")+"'"
	Endif
	
	// Rotina de Busca de Dados --> INFINP04.PRW
	Processa({|| cArq := u_INFINP04("TMP",cQry,"D",.T.,.T.,.T.) },"Filtro de Dados","Filtrando Saidas...")
	
	If TMP->(Bof() .And. Eof())   // Caso não tenha encontrado registros válidos
		TMP->(dbCloseArea())
		Return
	Endif
	
	SZ0->(dbSetOrder(1))
	SZ3->(dbSetOrder(1))
	
	// Calcula o próximo sequêncial para a gravação
	cQry := "SELECT ISNULL(MAX(Z3_CHAVE),'"+StrZero(0,TamSX3("Z3_CHAVE")[1])+"') AS Z3_CHAVE"
	cQry += " FROM "+RetSQLName("SZ3")+" SZ3"
	cQry += " WHERE SZ3.D_E_L_E_T_ = ' '"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TBS", .T., .F. )
	cSequen := Z3_CHAVE
	dbCloseArea()
	
	ProcRegua(TMP->(RecCount()))
		
	// Processa duas vezes por conta da quebra do índice
	For nV:=1 To 2
		dbSelectArea("TMP")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ordenando o arquivo gerado por classe de valor  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cInd := CriaTrab(NIL ,.F.)
		
		If nV == 1
			cKey    := "E5_ROTINA+E5_FILORIG+E5_ITEMCTA+E5_CLVL+E5_CC+Dtos(E5_DTDISPO)"
			cFiltro := "E5_ROTINA == 'GPEM670 '"
		Else
			cKey    := "E5_ROTINA+E5_FILORIG+E5_PREFIXO+E5_NUMERO+E5_CLIFOR+E5_LOJA+E5_TIPO+E5_PARCELA+E5_CLVL+E5_CC+E5_ITEMCTA+E5_ITEM+Dtos(E5_DTDISPO)"
			cFiltro := "E5_ROTINA <> 'GPEM670 '"
		Endif
		
		IndRegua("TMP",cInd,cKey,,cFiltro,"Selecionando Registros...")
	
		dbGoTop()
		While !TMP->(Eof())
			
			dDtDispo := TMP->E5_DTDISPO
			cOrigem  := TMP->E5_ROTINA
			cSequen  := Soma1(cSequen)
			nTotal   := 0
			
			If Trim(cOrigem) == "MATA100"
				cQuebra := TMP->(E5_FILORIG+E5_PREFIXO+E5_NUMERO+E5_CLIFOR+E5_LOJA)
				While !TMP->(Eof()) .And. cOrigem+cQuebra == TMP->(E5_ROTINA+E5_FILORIG+E5_PREFIXO+E5_NUMERO+E5_CLIFOR+E5_LOJA)
					nTotal += GravaRegistro(cSequen,@dDtDispo)
				Enddo
				GravaDocumento(cSequen,dDtDispo,nTotal)
			ElseIf Trim(cOrigem) == "FINA050"
				cQuebra := TMP->(E5_FILORIG+E5_PREFIXO+E5_NUMERO+E5_CLIFOR+E5_LOJA+E5_TIPO+E5_PARCELA)
				While !TMP->(Eof()) .And. cOrigem+cQuebra == TMP->(E5_ROTINA+E5_FILORIG+E5_PREFIXO+E5_NUMERO+E5_CLIFOR+E5_LOJA+E5_TIPO+E5_PARCELA)
					nTotal += GravaRegistro(cSequen,@dDtDispo)
				Enddo
				GravaDocumento(cSequen,dDtDispo,nTotal)
			ElseIf Trim(cOrigem) == "GPEM670"
				cQuebra := TMP->(E5_FILORIG+E5_ITEMCTA)
				While !TMP->(Eof()) .And. cOrigem+cQuebra == TMP->(E5_ROTINA+E5_FILORIG+E5_ITEMCTA)
					GravaRegistro(cSequen,@dDtDispo)
				Enddo
			ElseIf Trim(cOrigem) == "FINA100"
				GravaRegistro(cSequen,@dDtDispo)
			Else
				IncProc()
				TMP->(dbSkip())
			Endif
			
		Enddo
		
		TMP->(dbClearIndex())
		FErase(cInd+OrdBagExt())
	Next
	TMP->(dbCloseArea())
	FErase(cArq+GetDBExtension())
	
	MsgInfo("Gravação concluída com sucesso!")
	
Return

Static Function GravaRegistro(cChave,dDtDispo)
	Local nX, nPos, nRet
	Local cSeek  := TMP->(E5_FILORIG+E5_NUMERO+E5_PREFIXO+E5_TIPO+E5_PARCELA+E5_CLIFOR+E5_LOJA+Dtos(E5_DTDISPO))
	Local lAchou := SZ3->(dbSeek(cSeek))    // Pesquisa se o registro já existe
	
	dDtDispo := If( dDtDispo < TMP->E5_DTDISPO , dDtDispo, TMP->E5_DTDISPO)
	
	IncProc()
	
	If !lAchou .Or. SZ3->Z3_REGBLQ <> "3"   // Se não achou ou achou e não está bloqueado
		RecLock("SZ3",!lAchou)
		For nX:=1 To TMP->(FCount())
			If (nPos := SZ3->(FieldPos(StrTran(TMP->(FieldName(nX)),"E5_","Z3_")))) > 0   // Se o campo existir na tabela de manutenção
				FieldPut( nPos , TMP->(FieldGet(nX)) )
			Endif
		Next
		SZ3->Z3_CHAVE  := cChave
		SZ3->Z3_REGBLQ := "1"   // Registro não bloqueado para alteração
		SZ3->Z3_ATIVO  := "S"   // Registro ativo: S=Sim, N=Não
		SZ3->Z3_VALHOR := If( Trim(Z3_CLVL) == "001" , CalcTempo(Z3_ITEMCTA,Z3_CC), 0)
		MsUnLock()
	Endif
	
	nRet := SZ3->Z3_VALOR * If( SZ3->Z3_RECPAG == "P", 1, -1)
	
	TMP->(dbSkip())
Return nRet

Static Function GravaDocumento(cChave,dDtDispo,nTotal)
	Local nX, nPos, cSeek, lAchou
	
	TMP->(dbSkip(-1))
	
	IncProc()
	
	cSeek  := TMP->(E5_FILORIG+E5_NUMERO+E5_PREFIXO+E5_TIPO+E5_PARCELA+E5_CLIFOR+E5_LOJA+Dtos(dDtDispo))
	lAchou := SZ0->(dbSeek(cSeek))    // Pesquisa se o registro já existe
	
	If !lAchou .Or. SZ0->Z0_REGBLQ <> "3"   // Se não achou ou achou e não está bloqueado
		RecLock("SZ0",!lAchou)
		For nX:=1 To TMP->(FCount())
			If (nPos := SZ0->(FieldPos(StrTran(TMP->(FieldName(nX)),"E5_","Z0_")))) > 0   // Se o campo existir na tabela de manutenção
				FieldPut( nPos , TMP->(FieldGet(nX)) )
			Endif
		Next
		SZ0->Z0_DTDISPO := dDtDispo
		SZ0->Z0_CHAVE   := cChave
		SZ0->Z0_REGBLQ  := "1"   // Registro não bloqueado para alteração
		SZ0->Z0_ATIVO   := "S"   // Registro ativo: S=Sim, N=Não
		SZ0->Z0_VALOR   := nTotal
		SZ0->Z0_NOMFOR  := Posicione("SA2",1,TMP->(E5_FILORIG+E5_CLIFOR+E5_LOJA),"A2_NOME")
		MsUnLock()
	Endif
	
	TMP->(dbSkip())
Return

Static Function CalcTempo(cItem,cCC,nMeses,nHoras)
	Local cQry
	Local cAlias := Alias()
	Local nRet   := If( nHoras == Nil , 0, nHoras)
	
	If nRet == 0
		cQry := "SELECT SUM(SZ1.Z1_PERC * 180) AS Z1_PERC"
		cQry += " FROM "+RetSQLName("SZ1")+" SZ1"
		cQry += " WHERE SZ1.D_E_L_E_T_ = ' '"
		cQry += " AND SZ1.Z1_FILIAL = '"+XFILIAL("SZ1")+"'"
		cQry += " AND SZ1.Z1_DATA >= '"+Dtos(FirstDay(mv_par01))+"'"
		cQry += " AND SZ1.Z1_DATA <= '"+Dtos(LastDay(mv_par02))+"'"
		
		If cItem <> Nil   // Caso tenha sido informado o item contábil, filtra por esse campo
			cQry += " AND SZ1.Z1_MAT = '"+cItem+"'"
		Endif
		If cCC <> Nil   // Caso tenha sido informado o centro de custo, filtra por esse campo
			cQry += " AND SZ1.Z1_CC = '"+cCC+"'"
		Endif
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMPSZ1", .T., .F. )
		nRet := Z1_PERC / If( nMeses <> Nil .And. nMeses > 0 , nMeses, 1)
		dbCloseArea()
		dbSelectArea(cAlias)
	Endif
	
Return nRet

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data                   ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data                ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Do Projeto                ",29)+"?","","","mv_ch3","C", 9,0,0,"G","","CTT","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate o Projeto             ",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Considera Filiais a baixo ",29)+"?","","","mv_ch5","N", 1,0,0,"C","","   ","","","mv_par05","Sim","","","","Nao")
	u_INPutSX1(cPerg,"06",PADR("Da Filial                 ",29)+"?","","","mv_ch6","C", 2,0,0,"G","","   ","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Ate a Filial              ",29)+"?","","","mv_ch7","C", 2,0,0,"G","","   ","","","mv_par07")
Return
