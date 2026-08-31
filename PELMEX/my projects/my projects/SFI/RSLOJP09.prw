#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ RSLOJP09   ¦ Autor ¦ microsiga            ¦ Data ¦ 11/02/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦ Rotina para geração do registro do SFI (Reduções Z).          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function RSLOJP09()
	Local aSay    := {}
	Local aButton := {}
	Local nOpc    := 0
	Local cTitulo := "Geração do registro de Redução Z"
	Local cDesc1  := "Essa rotina irá geraros registros da tabela de redução Z (SFI),"
	Local cDesc2  := "conforma a loja e o período informado."
	Local cPerg   := PADR("RSLOJP09",Len(SX1->X1_GRUPO))

	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)

	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )

	aAdd( aButton, { 5, .T., {|x| Pergunte(cPerg)       }} )
	aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
	aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )

	FormBatch( cTitulo, aSay, aButton )

	If nOpc == 1
		Processa({|| RunProc() }, "Gerando redução Z")
	Endif

Return

Static Function RunProc()
	Local cQry, lFound

	// Cria query de filtro do relatório
	cQry := "SELECT D2_EMISSAO, D2_PDV, D2_SITTRIB, D2_TES, SUM(D2_TOTAL) AS D2_TOTAL, SUM(D2_BASEICM) AS D2_BASEICM,"
	cQry += " SUM(D2_VALICM) AS D2_VALICM, SUM(D2_DESCON) AS D2_DESCON, MAX(D2_DOC) AS D2_DOCMAX, MIN(D2_DOC) AS D2_DOCMIN"
	cQry += " FROM "+RetSQLName("SD2")+" SD2"
	cQry += " WHERE D_E_L_E_T_ = ' ' AND D2_PDV <> ' ' AND D2_TOTAL > 0"
	cQry += " AND D2_EMISSAO >= '"+Dtos(mv_par01)+"' AND D2_EMISSAO <= '"+Dtos(mv_par02)+"'"
	cQry += " AND D2_FILIAL = '"+mv_par03+"'"

	If !Empty(mv_par04)  // Se foi informado o PDV
		cQry += " AND D2_PDV = '"+mv_par04+"'"
	Endif

	cQry += " GROUP BY D2_EMISSAO, D2_PDV, D2_SITTRIB, D2_TES"
	cQry += " ORDER BY 1, 2, 3, 4"

	// Executa query para calcular o total de registros
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "RED", .T., .F. )

	TCSetField("RED","D2_EMISSAO","D",8,0)

	dbGoTop()
	While !Eof()
		dEmissao := D2_EMISSAO
		While !Eof() .And. dEmissao == D2_EMISSAO
			vRed := NumRed(D2_EMISSAO-1,D2_PDV)
			vAlq := { 0, 0, 0, 0, 0, 0, 0, 0}
			cPDV := D2_PDV
			While !Eof() .And. dEmissao == D2_EMISSAO .And. cPDV == D2_PDV

				vAlq[1] += D2_TOTAL
				vAlq[2] += D2_DESCON
				nPICM   := 0

				If Trim(D2_SITTRIB) == "I1"          // Isentos
					vAlq[3] += D2_TOTAL
				ElseIf Trim(D2_SITTRIB) == "N1"      // Não tributados
					vAlq[4] += D2_TOTAL
				ElseIf Trim(D2_SITTRIB) == "T0700"   // ICMS 7%
					vAlq[5] += D2_TOTAL
					nPICM   := 7
				ElseIf Trim(D2_SITTRIB) == "T1200"   // ICMS 12%
					vAlq[6] += D2_TOTAL
					nPICM   := 12
				ElseIf Trim(D2_SITTRIB) == "T1700"   // ICMS 17%
					vAlq[7] += D2_TOTAL
					nPICM   := 17
				Endif

				// Atualiza o valor do ICMS nos itens da nota fiscal de saída
				cQry := "UPDATE "+RetSQLName("SD2")+" SET"
				cQry += " D2_PICM = "+LTrim(Str(nPICM))+","
				cQry += " D2_VALICM = ROUND(D2_BASEICM * "+LTrim(Str(nPICM))+" / 100,2)"
				cQry += " WHERE D_E_L_E_T_ = ' '"
				cQry += " AND D2_FILIAL = '"+mv_par03+"'"
				cQry += " AND D2_EMISSAO = '"+Dtos(D2_EMISSAO)+"'"
				cQry += " AND D2_PDV = '"+D2_PDV+"'"
				cQry += " AND D2_SITTRIB = '"+D2_SITTRIB+"'"
				TCSqlExec(cQry)

				vAlq[8] += Round(D2_BASEICM * nPICM / 100,2)

				dbSkip()
			Enddo
			If vAlq[1] > 0
				If Empty(vRed) .Or. Impressora(cPDV)
					Loop
				Endif

				// Caso esteja atualizando somente as bases, não processa se não encontrar a redução Z
				SFI->(dbSetOrder(1))
				If !(lFound := SFI->(dbSeek(mv_par03+Dtos(dEmissao)+cPDV))) .And. mv_par05 == 2
					Loop
				Endif

				Begin Transaction

					RecLock("SFI",!lFound)

					// Caso esteja atualizando tudo
					If mv_par05 == 1
						SFI->FI_FILIAL  := mv_par03
						SFI->FI_DTMOVTO := dEmissao
						SFI->FI_NUMERO  := vRed[1] := Soma1(vRed[1])
						SFI->FI_PDV     := cPDV
						SFI->FI_CRO     := vRed[5]
						SFI->FI_SERPDV  := vRed[2]
						SFI->FI_NUMREDZ := vRed[3] := Soma1(vRed[3])
						SFI->FI_GTINI   := vRed[4]
						SFI->FI_VALCON  := vAlq[1]
						SFI->FI_DESC    := vAlq[2]
						SFI->FI_GTFINAL := SFI->FI_GTINI + SFI->FI_VALCON + SFI->FI_DESC
						SFI->FI_NUMINI  := vRed[6]
						SFI->FI_NUMFIM  := vRed[7]
						SFI->FI_SITUA   := "00"
						// SFI->FI_COO     := vRed[7]
					Endif

					SFI->FI_ISENTO  := vAlq[3]
					SFI->FI_NTRIB   := vAlq[4]
					SFI->FI_BAS7    := vAlq[5]
					SFI->FI_BAS12   := vAlq[6]
					SFI->FI_BAS17   := vAlq[7]
					SFI->FI_IMPDEBT := vAlq[8]
					MsUnLock()

				End Transaction

				dbSelectArea("RED")
			Endif
		Enddo
	Enddo
	dbCloseArea()

	// Atualiza o valor do ICMS no cabeçalho da nota fiscal de saída
	cQry := "UPDATE "+RetSQLName("SF2")+" SET F2_VALICM = SD2.D2_VALICM"
	cQry += " FROM "+RetSQLName("SF2")
	cQry += " INNER JOIN ("
	cQry += " SELECT SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SUM(SD2.D2_VALICM) AS D2_VALICM"
	cQry += " FROM "+RetSQLName("SD2")+" SD2"
	cQry += " WHERE SD2.D_E_L_E_T_ = ' '"
	cQry += " AND SD2.D2_FILIAL = '"+mv_par03+"'"
	cQry += " AND SD2.D2_EMISSAO >= '"+Dtos(mv_par01)+"'"
	cQry += " AND SD2.D2_EMISSAO <= '"+Dtos(mv_par02)+"'"
	cQry += " GROUP BY SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE"
	cQry += " ) SD2 ON SD2.D2_FILIAL = F2_FILIAL"
	cQry += " AND SD2.D2_DOC = F2_DOC"
	cQry += " AND SD2.D2_SERIE = F2_SERIE"
	cQry += " WHERE D_E_L_E_T_ = ' '"

	TCSQLExec(cQry)
Return

Static Function NumRed(dData,cPDV)
	Local nCount := 0
	Local vRed   := {}

	SFI->(dbSetOrder(1))

	While nCount < 21 .And. Empty(vRed)

		While !SFI->(dbSeek(mv_par03+Dtos(dData))) .And. nCount < 21
			nCount++
			dData--
		Enddo

		While !SFI->(Eof()) .And. mv_par03 == SFI->FI_FILIAL .And. dData == SFI->FI_DTMOVTO
			If cPDV == SFI->FI_PDV
				vRed := { SFI->FI_NUMERO, SFI->FI_SERPDV, AllTrim(SFI->FI_NUMREDZ), SFI->FI_GTFINAL, SFI->FI_CRO, D2_DOCMIN, D2_DOCMAX}
				Exit
			Endif
			SFI->(dbSkip())
		Enddo

		dData--
		nCount++
	Enddo

Return vRed

Static Function Impressora(cPDV)
	Local lRet := .T.

	SLG->(dbSetOrder(1))
	SLG->(dbSeek(mv_par03,.T.))
	While !SLG->(Eof()) .And. mv_par03 == SLG->LG_FILIAL
		If cPDV == SLG->LG_PDV  //.And. "MP2" $ SLG->LG_IMPFISC
			lRet := .F.
			Exit
		Endif
		SLG->(dbSkip())
	Enddo

Return lRet

Static Function ValidPerg(cPerg)
	u_InPutSx1(cPerg,"01",PADR("Da Emissao   ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_InPutSx1(cPerg,"02",PADR("Ate a Emissao",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_InPutSx1(cPerg,"03",PADR("Filial       ",29)+"?","","","mv_ch3","C", 2,0,0,"G","","   ","","","mv_par03")
	u_InPutSx1(cPerg,"04",PADR("PDV          ",29)+"?","","","mv_ch4","C", 4,0,0,"G","","   ","","","mv_par04")
	u_InPutSx1(cPerg,"05",PADR("Atualiza     ",29)+"?","","","mv_ch5","N", 1,0,0,"C","","   ","","","mv_par05","Tudo","","","","Bases")
Return