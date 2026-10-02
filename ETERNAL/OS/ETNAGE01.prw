#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Define PAD_LEFT 0
#Define PAD_RIGHT 1
#Define PAD_CENTER 2
#Define COR_CINZA RGB(180,180,180)
#Define COR_AZULE RGB(0,95,153)
#Define COR_AZULC RGB(198,233,255)
#Define COR_PRETO RGB(0,0,0)
#Define COR_BRANCO RGB(255,255,255)
#Define COR_BORDA RGB(190,205,212)

User Function ETNAGE01()
	Local aArea := GetArea()
	Local aPerg := {}
	Local aRet := {}
	Local nTam := TamSX3("AB6_XVEICU")[1]
	Local cDe := Space(nTam)
	Local cAte := Space(nTam)
	Local dAgenda := Date()
	Local cTurno := Space(TamSX3("ZX0_TURNO")[1])
	Local lValido := .F.

	While !lValido
		aPerg := {}
		aAdd(aPerg, {1, "Do caminhao", cDe, "@!", "", "", "", 80, .F.})
		aAdd(aPerg, {1, "Ate o caminhao", cAte, "@!", "", "", "", 80, .T.})
		aAdd(aPerg, {1, "Data de agendamento", dAgenda, "", "", "", "", 80, .T.})
		aAdd(aPerg, {1, "Turno de agendamento", cTurno, "@!", "", "", "", 40, .T.})
		If !ParamBox(aPerg, "Programacao de coletas por caminhao", @aRet)
			RestArea(aArea)
			Return
		EndIf
		cDe := aRet[1]
		cAte := aRet[2]
		dAgenda := aRet[3]
		cTurno := ALLTRIM(aRet[4])
		Do Case
		Case Empty(cAte)
			MsgStop("Informe o caminhao final.")
		Case Empty(dAgenda)
			MsgStop("Informe a data de agendamento.")
		Case Empty(cTurno)
			MsgStop("Informe o codigo do turno cadastrado na ZX0.")
		Case !Empty(cDe) .And. cDe > cAte
			MsgStop("O caminhao inicial deve ser menor ou igual ao final.")
		Otherwise
			lValido := .T.
		EndCase
	EndDo
	Processa({|| fMontaRel(cDe,cAte,dAgenda,cTurno)}, "Gerando programacao...")
	RestArea(aArea)
Return

Static Function fMontaRel(cDe,cAte,dAgenda,cTurno)
	Local cAlias := GetNextAlias()
	Local cQuery := fQuery(cDe,cAte,dAgenda,cTurno)
	Local aGrupos := {}
	Local aGrupo := {}
	Local nGrupo := 0
	Local nI := 0
	Local cChave := ""
	Local cEndereco := ""
	Local cOcorrencia := ""
	Local cContato := ""
	Local cArquivo := ""
	Private nLinAtu := 0
	Private nTamLin := 10
	Private nLinFin := 780
	Private nColIni := 10
	Private nColFin := 550
	Private oPrintPvt := Nil
	Private dDataGer := Date()
	Private cHoraGer := Time()
	Private nPagAtu := 1
	Private cNomeUsr := UsrRetName(RetCodUsr())
	Private oFontDet := TFont():New("Arial",0,-9,.F.)
	Private oFontDetN := TFont():New("Arial",0,-10,.T.)
	Private oFontDetN2 := TFont():New("Arial",0,-12,.T.)
	Private oFontRod := TFont():New("Arial",0,-7,.F.)
	Private oFontTit := TFont():New("Arial",0,-16,.T.)
	Private oFontEmpN := TFont():New("Arial",0,-11,.T.)

	// SQL Oracle: LISTAGG mantido conforme a consulta validada.
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAlias, .F., .T.)
	While !(cAlias)->(Eof())
		// Separa tambem programacoes/equipes diferentes do mesmo veiculo.
		cChave := (cAlias)->AB6_XVEICU + (cAlias)->ZX2_COD
		nGrupo := AScan(aGrupos, {|a| a[9] == cChave})

		If nGrupo == 0
			aAdd(aGrupos, {(cAlias)->AB6_XVEICU, (cAlias)->AB6_XTPVEI, ;
				(cAlias)->ZX2_DTPRO, iif((cAlias)->TURNO=='M','Manha',iif((cAlias)->TURNO=='T','Tarde',iif((cAlias)->TURNO=='N','Noite',(cAlias)->TURNO))), fChar((cAlias)->MOTORISTA), ;
				fChar((cAlias)->AJUDANTES), {}, {}, cChave, ;
				fChar((cAlias)->ZX2_COD)})

			nGrupo := Len(aGrupos)
		EndIf

		aGrupo := aGrupos[nGrupo]
		If AScan(aGrupo[8], (cAlias)->AB6_NUMOS) == 0
			aAdd(aGrupo[8], (cAlias)->AB6_NUMOS)
		EndIf
		cEndereco := fChar((cAlias)->ABS_END)
		If !Empty((cAlias)->ABS_BAIRRO)
			cEndereco += "|" + AllTrim((cAlias)->ABS_BAIRRO)
		EndIf
		If !Empty((cAlias)->ABS_MUNIC)
			cEndereco += "|" + AllTrim((cAlias)->ABS_MUNIC) + " - " + AllTrim((cAlias)->ABS_ESTADO)
		EndIf
		If !Empty((cAlias)->ABS_CEP)
			cEndereco += "|" + AllTrim((cAlias)->ABS_CEP)
		EndIf
		cOcorrencia := fChar((cAlias)->AAG_DESCRI)
		If !Empty(fChar((cAlias)->AB7_MEMO1))
			cOcorrencia += "|" + fChar((cAlias)->AB7_MEMO1)
		EndIf
		cContato := fChar((cAlias)->U5_CONTAT)
		If !Empty(fChar((cAlias)->TELEFONES))
			cContato += "|" + fChar((cAlias)->TELEFONES)
		EndIf
		aAdd(aGrupo[7], {AllTrim((cAlias)->ZX3_ITEM), (cAlias)->AB6_NUMOS, ;
			fChar((cAlias)->A1_NOME) + "|" + MascCGC((cAlias)->A1_CGC), ;
			cContato, cOcorrencia, cEndereco})
		(cAlias)->(DbSkip())
	EndDo
	(cAlias)->(DbCloseArea())
	If Empty(aGrupos)
		MsgInfo("Nenhuma programacao encontrada para os filtros informados.")
		Return
	EndIf
	cArquivo := "ETNAGE01_" + DToS(dDataGer) + "_" + StrTran(cHoraGer,":","-")
	// Nao passar @oPrintPvt como objeto de setup.
	oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T.)
	oPrintPvt:SetResolution(72)
	oPrintPvt:SetPortrait()
	oPrintPvt:SetPaperSize(DMPAPER_A4)
	oPrintPvt:SetMargin(10,10,10,10)
	oPrintPvt:cPathPDF := GetTempPath()
	For nI := 1 To Len(aGrupos)
		aGrupo := aGrupos[nI]
		fImpCab()
		fDadosProgramacao(aGrupo)
		fOrdensServico(aGrupo)
		fImpRod()
	Next
	oPrintPvt:Preview()
	FreeObj(oPrintPvt)
	FreeObj(oFontDet)
	FreeObj(oFontDetN)
	FreeObj(oFontDetN2)
	FreeObj(oFontRod)
	FreeObj(oFontTit)
	FreeObj(oFontEmpN)
Return

Static Function fChar(uValor)
	If ValType(uValor) == "C" .Or. ValType(uValor) == "M"
		Return AllTrim(uValor)
	EndIf
Return ""

/*/{Protheus.doc} MascCGC((cAlias)->A1_CGC)
	(long_description)
	@type  Static Function
	@author user
	@since 02/10/2026
	@version version
	@param param_name, param_type, param_descr
	@return cRet, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function MascCGC(cCGC)
	Local cRet := ""
	Do Case
	Case Len(alltrim(cCGC)) == 11
		cRet := "CPF: " + SubStr(cCGC,1,3) + "." + SubStr(cCGC,4,3) + "." + SubStr(cCGC,7,3) + "-" + SubStr(cCGC,10,2)
	Case Len(alltrim(cCGC)) == 14
		cRet := "CNPJ: " + SubStr(cCGC,1,2) + "." + SubStr(cCGC,3,3) + "." + SubStr(cCGC,6,3) + "/" + SubStr(cCGC,9,4) + "-" + SubStr(cCGC,13,2)
	Otherwise
		cRet := cCGC
	EndCase
Return cRet

Static Function fQuery(cDe,cAte,dAgenda,cTurno)
	Local cSql := ""
	cSql += "SELECT ZX2.ZX2_FILIAL, ZX2.ZX2_COD , ZX2.ZX2_DTPRO, ZX2.ZX2_HORAP, ZX2.ZX2_EQUIPE, "
	cSql += " EQUIPE.ZX0_TURNO AS TURNO, EQUIPE.MOTORISTA, EQUIPE.AJUDANTES, "
	cSql += "SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC, AAG.AAG_DESCRI, AB7.AB7_MEMO1, "
	cSql += "AB6.AB6_XVEICU, AB6.AB6_XTPVEI, AB6.AB6_NUMOS, ZX3.ZX3_ITEM, "
	cSql += "AA3.AA3_CODLOC, ABS.ABS_DESCRI, ABS.ABS_END, ABS.ABS_BAIRRO, ABS.ABS_MUNIC, ABS.ABS_ESTADO, ABS.ABS_CEP, SU5.U5_CODCONT, SU5.U5_CONTAT, FONES.TELEFONES "
	cSql += "FROM " + RetSqlName("ZX2") + " ZX2 "
	cSql += "INNER JOIN " + RetSqlName("ZX3") + " ZX3 ON ZX3.ZX3_FILIAL=ZX2.ZX2_FILIAL AND ZX3.ZX3_ID_ZX2=ZX2.ZX2_COD AND ZX3.ZX3_VERSAO=ZX2.ZX2_VERSAO AND ZX3.D_E_L_E_T_=' ' "
	cSql += "INNER JOIN " + RetSqlName("AB6") + " AB6 ON AB6.AB6_FILIAL=ZX3.ZX3_FILIAL AND AB6.AB6_NUMOS=ZX3.ZX3_ID_OS AND AB6.D_E_L_E_T_=' ' "
	cSql += "INNER JOIN " + RetSqlName("AB7") + " AB7 ON AB7.AB7_FILIAL=AB6.AB6_FILIAL AND AB7.AB7_NUMOS=AB6.AB6_NUMOS AND AB7.AB7_CODCLI=AB6.AB6_CODCLI AND AB7.AB7_LOJA=AB6.AB6_LOJA AND AB7.D_E_L_E_T_=' ' "
	cSql += "INNER JOIN " + RetSqlName("AAG") + " AAG ON AAG.AAG_FILIAL='" + fSql(xFilial("AAG")) + "' AND AAG.AAG_CODPRB=AB7.AB7_CODPRB AND AAG.D_E_L_E_T_=' ' "
	cSql += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_FILIAL='" + fSql(xFilial("SA1")) + "' AND SA1.A1_COD=AB6.AB6_CODCLI AND SA1.A1_LOJA=AB6.AB6_LOJA AND SA1.D_E_L_E_T_=' ' "
	cSql += "LEFT JOIN " + RetSqlName("AA3") + " AA3 ON AA3.AA3_FILIAL='" + fSql(xFilial("AA3")) + "' AND AA3.AA3_CODPRO=AB7.AB7_CODPRO AND AA3.AA3_NUMSER=AB7.AB7_NUMSER AND AA3.AA3_CODCLI=AB7.AB7_CODCLI AND AA3.AA3_LOJA=AB7.AB7_LOJA AND AA3.D_E_L_E_T_=' ' "
	cSql += "LEFT JOIN " + RetSqlName("ABS") + " ABS ON ABS.ABS_FILIAL=AA3.AA3_FILIAL AND ABS.ABS_LOCAL=AA3.AA3_CODLOC AND ABS.D_E_L_E_T_=' ' "

	// Retorna um �nico contato:
	// 1. Contato informado no item da OS, se existir na SU5.
	// 2. Primeiro contato v�lido do cliente pela AC8.
	cSql += "LEFT JOIN " + RetSqlName("SU5") + " SU5 "
	cSql += " ON SU5.U5_FILIAL='" + fSql(xFilial("SU5")) + "' "
	cSql += " AND SU5.D_E_L_E_T_=' ' "

	cSql += " AND SU5.R_E_C_N_O_=COALESCE( "

	// Prioridade: contato do item da OS.
	cSql += " (SELECT MIN(COS.R_E_C_N_O_) "
	cSql += "    FROM " + RetSqlName("SU5") + " COS "
	cSql += "   WHERE COS.U5_FILIAL='" + fSql(xFilial("SU5")) + "' "
	cSql += "     AND COS.U5_CODCONT=AB7.AB7_CODCON "
	cSql += "     AND TRIM(COS.U5_CODCONT) IS NOT NULL "
	cSql += "     AND COS.D_E_L_E_T_=' '), "

	// Alternativa: primeiro contato v�lido do cliente.
	cSql += " (SELECT MIN(CCLI.R_E_C_N_O_) "
	cSql += "         KEEP (DENSE_RANK FIRST ORDER BY CCLI.U5_CODCONT) "
	cSql += "    FROM " + RetSqlName("AC8") + " AC8 "
	cSql += "   INNER JOIN " + RetSqlName("SU5") + " CCLI "
	cSql += "      ON CCLI.U5_FILIAL='" + fSql(xFilial("SU5")) + "' "
	cSql += "     AND CCLI.U5_CODCONT=AC8.AC8_CODCON "
	cSql += "     AND TRIM(CCLI.U5_CODCONT) IS NOT NULL "
	cSql += "     AND CCLI.D_E_L_E_T_=' ' "
	cSql += "   WHERE AC8.AC8_FILIAL='" + fSql(xFilial("AC8")) + "' "
	cSql += "     AND AC8.AC8_ENTIDA='SA1' "
	cSql += "     AND AC8.AC8_FILENT=SA1.A1_FILIAL "
	cSql += "     AND TRIM(AC8.AC8_CODENT)=SA1.A1_COD || SA1.A1_LOJA "
	cSql += "     AND AC8.D_E_L_E_T_=' ') "

	cSql += " ) "
	// Agregacao impede que varios telefones multipliquem os itens da OS.
	cSql += "LEFT JOIN ( SELECT TRIM(AGB.AGB_CODENT) AS CODCONT, "
	cSql += "LISTAGG(CASE WHEN TRIM(AGB.AGB_DDD) IS NOT NULL THEN '(' || TRIM(AGB.AGB_DDD) || ') ' END || TRIM(AGB.AGB_TELEFO), '; ') "
	cSql += "WITHIN GROUP (ORDER BY AGB.AGB_PADRAO, AGB.AGB_TIPO, AGB.AGB_CODIGO) AS TELEFONES "
	cSql += "FROM " + RetSqlName("AGB") + " AGB WHERE AGB.D_E_L_E_T_=' ' "
	cSql += "AND AGB.AGB_FILIAL='" + fSql(xFilial("AGB")) + "' AND AGB.AGB_ENTIDA='SU5' "
	cSql += "AND AGB.AGB_TIPO IN ('1','2','5') AND TRIM(AGB.AGB_TELEFO) IS NOT NULL "
	cSql += "GROUP BY TRIM(AGB.AGB_CODENT) ) FONES ON FONES.CODCONT=TRIM(SU5.U5_CODCONT) "
	cSql += "LEFT JOIN ( "
	cSql += "SELECT ZX0.ZX0_FILIAL, ZX0.ZX0_COD, ZX0.ZX0_TURNO, "
	cSql += "MAX(CASE WHEN ZX1.ZX1_TIPO='M' THEN TRIM(AA1.AA1_NOMTEC) END) AS MOTORISTA, "
	cSql += "LISTAGG(CASE WHEN ZX1.ZX1_TIPO='A' THEN TRIM(AA1.AA1_NOMTEC) END, ' / ') WITHIN GROUP (ORDER BY AA1.AA1_NOMTEC) AS AJUDANTES "
	cSql += "FROM " + RetSqlName("ZX0") + " ZX0 "
	cSql += "LEFT JOIN " + RetSqlName("ZX1") + " ZX1 ON ZX1.ZX1_FILIAL=ZX0.ZX0_FILIAL AND ZX1.ZX1_ID_ZX0=ZX0.ZX0_COD AND ZX1.ZX1_VERSAO=ZX0.ZX0_VERSAO AND ZX1.D_E_L_E_T_=' ' "
	cSql += "LEFT JOIN " + RetSqlName("AA1") + " AA1 ON AA1.AA1_FILIAL=ZX1.ZX1_FILIAL AND AA1.AA1_CODTEC=ZX1.ZX1_ID_AA1 AND AA1.D_E_L_E_T_=' ' "
	cSql += "WHERE ZX0.D_E_L_E_T_=' ' "
	cSql += "GROUP BY ZX0.ZX0_FILIAL, ZX0.ZX0_COD, ZX0.ZX0_TURNO "
	cSql += ") EQUIPE ON EQUIPE.ZX0_FILIAL=ZX2.ZX2_FILIAL AND EQUIPE.ZX0_COD=ZX2.ZX2_EQUIPE "
	cSql += "WHERE ZX2.D_E_L_E_T_=' ' "
	cSql += "AND ZX2.ZX2_FILIAL='" + fSql(xFilial("ZX2")) + "' "
	cSql += "AND ZX2.ZX2_DTPRO='" + DToS(dAgenda) + "' "
	cSql += "AND EQUIPE.ZX0_TURNO='" + fSql(cTurno) + "' "
	cSql += "AND AB6.AB6_XVEICU <= '" + fSql(cAte) + "' "
	If !Empty(cDe)
		cSql += " AND AB6.AB6_XVEICU >= '" + fSql(cDe) + "' "
	EndIf
	cSql += " ORDER BY AB6.AB6_XVEICU, ZX2.ZX2_DTPRO, EQUIPE.ZX0_TURNO, ZX2.ZX2_COD, ZX3.ZX3_ITEM "
Return cSql

Static Function fSql(cValor)
Return StrTran(cValor, "'", "''")

Static Function fImpCab()
	Local cTexto  := ""
	Local cLogo   := ""
	Local nLinCab := 035
	Local nColEmp  := nColIni + 90
	// Inicia uma nova página
	oPrintPvt:StartPage()
     /* O caminho ficará vazio por enquanto.
     * Exemplo futuro:
     * cLogo := ""
     */
	cLogo := "\system\lgmid01.png"
	If !Empty(cLogo)
		oPrintPvt:SayBitmap(20, 25, cLogo, 70, 60)
	EndIf
	// Razão social
	cTexto := "ETERNAL - INDUSTRIA, COMERCIO, SERV. E TRAT. DE RESIDUOS DA AMAZONIA LTDA"
	oPrintPvt:SayAlign(nLinCab,nColEmp,cTexto,oFontRod,nColFin - nColEmp,nTamLin,COR_PRETO,PAD_LEFT,0)
	// Endereço
	nLinCab += nTamLin
	cTexto := "RUA GUIANA FRANCESA, 1 - DISTRITO INDUSTRIAL II"
	oPrintPvt:SayAlign(nLinCab,nColEmp,cTexto,oFontRod,nColFin - nColEmp,nTamLin,COR_PRETO,PAD_LEFT,0)
	// Telefone, CNPJ e site
	nLinCab += nTamLin
	cTexto := "FONE: 92 3616-4700 / 3616-4706 - " +       "CNPJ: 84.527.274/0001-23 - "        +       "WWW.ETERNALAM.COM.BR"
	oPrintPvt:SayAlign(nLinCab,nColEmp,cTexto,oFontRod,nColFin - nColEmp,nTamLin,COR_PRETO,PAD_LEFT,0)
	// Espaço inferior do cabeçalho
	nLinCab += (nTamLin * 2)
	// Linha separadora
	oPrintPvt:Line(nLinCab,nColIni,nLinCab,nColFin,COR_AZULE)
	// Título do relatório
	nLinCab += nTamLin
	cTexto := "PROGRAMACAO DE COLETAS POR CAMINHAO"
	oPrintPvt:SayAlign(nLinCab,nColIni,cTexto,oFontTit,nColFin - nColIni,nTamLin + 5,COR_AZULE,PAD_CENTER,0)
	// Linha depois do título
	nLinCab += (nTamLin * 2)
	oPrintPvt:Line(nLinCab,nColIni,nLinCab,nColFin,COR_AZULE)
	// Primeira linha disponível para o próximo bloco
	nLinAtu := nLinCab + nTamLin
Return
Static Function fDadosProgramacao(aGrupo)
	Local nAltTit    := 18
	Local nAltLinha  := 28
	Local nLinIni    := nLinAtu
	Local nLinFim    := 0
	Local nCol1      := nColIni
	Local nCol2      := nColIni + 075
	Local nCol3      := nColIni + 290
	Local nCol4      := nColIni + 370
	Local nCol5      := nColFin
	Local oBrushAzul := TBrush():New(, COR_AZULE)
    /*
     * Título do bloco
    */
	nLinFim := nLinIni + nAltTit
	oPrintPvt:FillRect(;
		{nLinIni, nCol1, nLinFim, nCol5},;
		oBrushAzul;
		)
	oPrintPvt:SayAlign(nLinIni + 3, nCol1 + 5, ;
		"DADOS DA PROGRAMACAO", oFontDetN2, ;
		nCol5 - nCol1 - 160, nAltTit - 3, ;
		COR_BRANCO, PAD_LEFT, 0)

	oPrintPvt:SayAlign(nLinIni + 3, nCol5 - 150, ;
		"ROTA: " + aGrupo[10], oFontDetN2, ;
		145, nAltTit - 3, ;
		COR_BRANCO, PAD_RIGHT, 0)

    /*
     * Primeira linha
     * DATA | data da programacao | TURNO | codigo da equipe
     */
	nLinIni := nLinFim
	nLinFim := nLinIni + nAltLinha
	fFundoCampo(nLinIni, nLinFim, nCol1, nCol2)
	fFundoCampo(nLinIni, nLinFim, nCol3, nCol4)
	fTextoCelula(nLinIni, nCol1, nCol2, "DATA",       oFontDetN)
	fTextoCelula(nLinIni, nCol2, nCol3, DToC(SToD(aGrupo[3])), oFontDet)
	fTextoCelula(nLinIni, nCol3, nCol4, "TURNO",      oFontDetN)
	fTextoCelula(nLinIni, nCol4, nCol5, aGrupo[4],      oFontDet)
	fBordaLinha(nLinIni, nLinFim, nCol1, nCol5, ;
		{nCol2, nCol3, nCol4})
    /*
     * Segunda linha
     * CAMINHAO | veiculo da OS | MOTORISTA | nome do tecnico
     */
	nLinIni := nLinFim
	nLinFim := nLinIni + Max(nAltLinha, Max(Len(fQuebra(aGrupo[1],40)),Len(fQuebra(aGrupo[5],31))) * 12 + 14)
	fFundoCampo(nLinIni, nLinFim, nCol1, nCol2)
	fFundoCampo(nLinIni, nLinFim, nCol3, nCol4)
	fTextoCelula(nLinIni, nCol1, nCol2, "CAMINHAO",            oFontDetN)
	fTextoCelula(nLinIni, nCol2, nCol3, aGrupo[1], oFontDet)
	fTextoCelula(nLinIni, nCol3, nCol4, "MOTORISTA",           oFontDetN)
	fTextoCelula(nLinIni, nCol4, nCol5, aGrupo[5],       oFontDet)
	fBordaLinha(nLinIni, nLinFim, nCol1, nCol5, ;
		{nCol2, nCol3, nCol4})
    /*
     * Terceira linha
     * AJUDANTES separados por ; | TOTAL DE OS distintas
     */
	nLinIni := nLinFim
	nLinFim := nLinIni + Max(nAltLinha, Len(fQuebra(aGrupo[6], 40)) * 12 + 14)
	fFundoCampo(nLinIni, nLinFim, nCol1, nCol2)
	fFundoCampo(nLinIni, nLinFim, nCol3, nCol4)
	fTextoCelula(nLinIni, nCol1, nCol2, "AJUDANTES",                  oFontDetN)
	fTextoCelula(nLinIni, nCol2, nCol3, aGrupo[6], oFontDet)
	fTextoCelula(nLinIni, nCol3, nCol4, "TOTAL DE OS",                oFontDetN)
	fTextoCelula(nLinIni, nCol4, nCol5, AllTrim(Str(Len(aGrupo[8]))),                         oFontDet)
	fBordaLinha(nLinIni, nLinFim, nCol1, nCol5, ;
		{nCol2, nCol3, nCol4})
	// Atualiza a linha para o próximo bloco
	nLinAtu := nLinFim + 10
	FreeObj(oBrushAzul)
Return
Static Function fOrdensServico(aGrupo)
	Local aCols := {nColIni,53,113,237,323,458,nColFin}
	Local aCaps := {8,10,22,15,24,16}
	Local aTit := {"ORDEM", "ORDEM DE|SERVICO","NOME DO CLIENTE|CPF / CNPJ", "CONTATO","DESCRICAO DA|OCORRENCIA", "ENDERECO"}
	Local aLinhas := {}
	Local aLinha := {}
	Local nReg := 0
	Local nCol := 0
	Local nMax := 0
	Local nOffset := 0
	Local nParte := 0
	Local nDispon := 0
	Local nAlt := 0
	Local nL := 0
	Local oBrush := TBrush():New(,COR_AZULC)
	fTabCab(aCols,aTit)
	For nReg := 1 To Len(aGrupo[7])
		aLinha := aGrupo[7][nReg]
		aLinhas := {}
		nMax := 1
		For nCol := 1 To 6
			aAdd(aLinhas,fQuebra(aLinha[nCol],aCaps[nCol]))
			nMax := Max(nMax,Len(aLinhas[nCol]))
		Next
		nOffset := 0
		While nOffset < nMax
			nDispon := Int((nLinFin-nLinAtu-10)/12)
			If nDispon < 1 .Or. (nOffset == 0 .And. nMax <= 35 .And. nMax > nDispon)
				fImpRod()
				fImpCab()
				fDadosProgramacao(aGrupo)
				fTabCab(aCols,aTit)
				nDispon := Int((nLinFin-nLinAtu-10)/12)
			EndIf
			nParte := Min(nMax-nOffset,nDispon)
			nAlt := Max(26,nParte*12+10)
			If (nReg % 2) == 0
				oPrintPvt:FillRect({nLinAtu,nColIni,nLinAtu+nAlt,nColFin},oBrush)
			EndIf
			For nCol := 1 To 6
				For nL := 1 To nParte
					If nOffset+nL <= Len(aLinhas[nCol])
						oPrintPvt:SayAlign(nLinAtu+5+(nL-1)*12,aCols[nCol]+5, ;
							aLinhas[nCol][nOffset+nL],oFontDet,aCols[nCol+1]-aCols[nCol]-10, ;
							12,COR_PRETO,PAD_LEFT,0)
					EndIf
				Next
			Next
			fBordaLinha(nLinAtu,nLinAtu+nAlt,nColIni,nColFin, ;
				{aCols[2],aCols[3],aCols[4],aCols[5],aCols[6]})
			nLinAtu += nAlt
			nOffset += nParte
		EndDo
	Next
	FreeObj(oBrush)
Return

Static Function fTabCab(aCols,aTit)
	Local oBrush := TBrush():New(,COR_AZULE)
	Local nCol := 0
	oPrintPvt:FillRect({nLinAtu,nColIni,nLinAtu+18,nColFin},oBrush)
	oPrintPvt:SayAlign(nLinAtu+3,nColIni+5,"ORDENS DE SERVICO",oFontDetN, ;
		nColFin-nColIni-10,15,COR_BRANCO,PAD_LEFT,0)
	nLinAtu += 18
	oPrintPvt:FillRect({nLinAtu,nColIni,nLinAtu+52,nColFin},oBrush)
	For nCol := 1 To 6
		fTextoTab(nLinAtu,aCols[nCol],aCols[nCol+1],aTit[nCol],oFontDetN,COR_BRANCO,PAD_CENTER)
	Next
	fBordaLinha(nLinAtu,nLinAtu+52,nColIni,nColFin, ;
		{aCols[2],aCols[3],aCols[4],aCols[5],aCols[6]})
	nLinAtu += 52
	FreeObj(oBrush)
Return

Static Function fTextoCelula(nLinha,nInicio,nFim,cTexto,oFonte)
	Local aTexto := fQuebra(cTexto,Max(1,Int((nFim-nInicio-12)/5)))
	Local nI := 0
	For nI := 1 To Len(aTexto)
		oPrintPvt:SayAlign(nLinha+7+(nI-1)*12,nInicio+6,aTexto[nI], ;
			oFonte,nFim-nInicio-12,12,COR_PRETO,PAD_LEFT,0)
	Next
Return

Static Function fTextoTab(nLinha,nInicio,nFim,cTexto,oFonte,nCor,nAlinhamento)
	Local aTexto := fQuebra(cTexto,Max(1,Int((nFim-nInicio-10)/5)))
	Local nI := 0
	For nI := 1 To Len(aTexto)
		oPrintPvt:SayAlign(nLinha+5+(nI-1)*12,nInicio+5,aTexto[nI], ;
			oFonte,nFim-nInicio-10,12,nCor,nAlinhamento,0)
	Next
Return

Static Function fQuebra(cTexto,nMax)
	Local aRet := {}
	Local aPartes := {}
	Local cParte := ""
	Local nI := 0
	Local nCorte := 0
	cTexto := StrTran(fChar(cTexto),Chr(13)+Chr(10),"|")
	cTexto := StrTran(StrTran(cTexto,Chr(13),"|"),Chr(10),"|")
	aPartes := StrTokArr(cTexto,"|")
	For nI := 1 To Len(aPartes)
		cParte := AllTrim(aPartes[nI])
		While Len(cParte) > nMax
			nCorte := RAt(" ",Left(cParte,nMax))
			If nCorte <= 1
				nCorte := nMax
			EndIf
			aAdd(aRet,AllTrim(Left(cParte,nCorte)))
			cParte := AllTrim(SubStr(cParte,nCorte+1))
		EndDo
		aAdd(aRet,cParte)
	Next
	If Empty(aRet)
		aAdd(aRet,"")
	EndIf
Return aRet

Static Function fFundoCampo(nLinIni, nLinFim, nColIniAux, nColFimAux)
	Local oBrushCampo := TBrush():New(, COR_AZULC)
	oPrintPvt:FillRect(;
		{nLinIni, nColIniAux, nLinFim, nColFimAux},;
		oBrushCampo;
		)
	FreeObj(oBrushCampo)
Return
Static Function fBordaLinha(nLinIni, nLinFim, nColIniAux, nColFimAux, aColunas)
	Local nPosicao := 0
	// Linhas horizontais
	oPrintPvt:Line(;
		nLinIni, nColIniAux,;
		nLinIni, nColFimAux,;
		COR_BORDA;
		)
	oPrintPvt:Line(;
		nLinFim, nColIniAux,;
		nLinFim, nColFimAux,;
		COR_BORDA;
		)
	// Bordas externas
	oPrintPvt:Line(;
		nLinIni, nColIniAux,;
		nLinFim, nColIniAux,;
		COR_BORDA;
		)
	oPrintPvt:Line(;
		nLinIni, nColFimAux,;
		nLinFim, nColFimAux,;
		COR_BORDA;
		)
	// Divisões internas das colunas
	For nPosicao := 1 To Len(aColunas)
		oPrintPvt:Line(;
			nLinIni, aColunas[nPosicao],;
			nLinFim, aColunas[nPosicao],;
			COR_BORDA;
			)
	Next nPosicao
Return
/*---------------------------------------------------------------------*
 | Func:  fImpRod                                                      |
 | Desc:  Função que imprime o rodapé                                  |
 *---------------------------------------------------------------------*/
Static Function fImpRod()
    Local nLinRod   := nLinFin + nTamLin
    Local cTextoEsq := ''
    Local cTextoDir := ''
    //Linha Separatória
    oPrintPvt:Line(nLinRod, nColIni, nLinRod, nColFin, COR_CINZA)
    nLinRod += 3
    //Dados da Esquerda e Direita
    cTextoEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
    cTextoDir := "Página " + cValToChar(nPagAtu)
    //Imprimindo os textos
    oPrintPvt:SayAlign(nLinRod, nColIni,    cTextoEsq, oFontRod, 450, 12, COR_CINZA, PAD_LEFT,  0)
    oPrintPvt:SayAlign(nLinRod, nColFin-40, cTextoDir, oFontRod, 040, 12, COR_CINZA, PAD_RIGHT, 0)
    //Finalizando a página e somando mais um
    oPrintPvt:EndPage()
    nPagAtu++
Return
