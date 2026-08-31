#Include "Protheus.ch"

Static nPosDOri   := 2              //Descricao do Produto Origem
Static nPosUMOri  := 3              //Unidade de Medida Origem
Static nPosLOCOri := 4              //Armazem Origem
Static nPosLcZOri := 5              //Localizacao Origem

Static nPosDDes   := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),7,6)   //Descricao do Produto Destino
Static nPosUMDes  := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),8,7)   //Unidade de Medida Destino
Static nPosLOCDes := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),9,8)   //Armazem Destino
Static nPosLcZDes := 10             //Localizacao Destino
Static nPosNSer   := 11             //Numero de Serie
Static nPosLoTCTL := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),12,9)  //Lote de Controle
Static nPosNLOTE  := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),13,10) //Numero do Lote
Static nPosDTVAL  := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),14,11) //Data Valida
Static nPosPotenc := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),15,12) //Potencia do Lote
Static nPosQUANT  := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),16,13) //Quantidade
Static nPosQTSEG  := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),17,14) //Quantidade na 2a. Unidade de Medida
Static nPosEstor  := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),18,15) //Estornado
Static nPosNumSeq := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),19,16) //Sequencia
Static nPosLotDes := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),20,17) //Lote Destino
Static nPosDtVldD := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),21,18) //Data Valida de Destino
Static nPosCODOri := 1
Static nPosCODDes := Iif(!__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3()),6,5)   //Codigo do Produto Destino

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PLESTE03   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/07/2017 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock de carga dos itens para a transferência mod. II     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PLESTE03()

	Static oMarked	:= LoadBitmap(GetResources(),'LBOK')

	Local oDlgEsp
	Local oLbx
	Local lFornece  := .F.
	Local aRotina	:= {{OemtoAnsi("Itens NF Entrada"),"A410ProcDv",0,4}}
	Local nOpca     := 0
	Local aHSF1     := {}
	Local aSF1      := {}
	Local aCpoSF1   := {}
	Local dDataDe   := CToD('  /  /  ')
	Local dDataAte  := CToD('  /  /  ')
	Local nCnt      := 0
	Local nPosDoc   := 0
	Local nPosSerie := 0
	Local cDocSF1   := ''
	Local cIndex    := ''
	Local cQuery    := ''
	Local lUsaNewKey:= TamSX3("F2_SERIE")[1] == 14 // Verifica se o novo formato de gravacao do Id nos campos _SERIE esta em uso
	Local cPerg     := PADR("PLESTE03",Len(SX1->X1_GRUPO))

	Private cFornece := CriaVar("F1_FORNECE",.F.)
	Private cLoja    := CriaVar("F1_LOJA",.F.)

	Private lForn    := .T.

	If Inclui
		//-- Valida filtro de retorno de doctos fiscais.
		If StaticCall(MATN410A,A410FRet,@lFornece,@dDataDe,@dDataAte,@lForn)
			If lFornece
				aAdd( aHSF1, ' ' )
				SX3->(DbSetOrder(1))
				SX3->(DbSeek("SF1"))
				While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SF1"
					If  SX3->X3_BROWSE == "S" .And. SX3->X3_CONTEXT <> "V"
						aAdd( aHSF1, IIf( lUsaNewKey .And. AllTrim(SX3->X3_CAMPO) == 'F1_SERIE' , "Id de Controle" ,  X3Titulo() )  )
						aAdd( aCpoSF1, SX3->X3_CAMPO )
						//-- Armazena a posicao do documento e serie
						If AllTrim(SX3->X3_CAMPO) == 'F1_DOC'
							nPosDoc := Len(aHSF1)
						ElseIf AllTrim(SX3->X3_CAMPO) == 'F1_SERIE'
							nPosSerie := Len(aHSF1)
						EndIf
					EndIf
					SX3->(DbSkip())
				EndDo

				//-- Retorna as notas que atendem o filtro.
				aSF1 := StaticCall(MATN410A,A410RetNF,aCpoSF1,dDataDe,dDataAte,lForn,lFornece)

				If !Empty(aSF1)
					DEFINE MSDIALOG oDlgEsp TITLE OemToAnsi("Itens do Doctos. de Entrada") FROM 00,00 TO 330,600 PIXEL
					oLbx:= TWBrowse():New( 030, 000, 300, 135, NIL, ;
					aHSF1, NIL, oDlgEsp, NIL, NIL, NIL,,,,,,,,,, "ARRAY", .T. )
					oLbx:SetArray( aSF1 )
					oLbx:bLDblClick  := { || { StaticCall(MATN410A,A410SelIt,oLbx:nAT,aSF1,cFornece,cLoja,nPosDoc,nPosSerie),oLbx:DrawSelect() }}
					oLbx:bLine := {|| aSF1[oLbx:nAT]}
					ACTIVATE MSDIALOG oDlgEsp ON INIT EnchoiceBar(oDlgEsp,{|| Iif(A410Check(aSF1),nOpca := 1,), Iif(nOpca == 1,oDlgEsp:End(), MsgInfo("Teste de Mensagem","INFO"))},{||oDlgEsp:End()}) CENTERED
					//-- Processa Devolucao
					If nOpca == 1
						For nCnt := 1 To Len(aSF1)
							If Upper(Trim(aSF1[nCnt,1]:cName)) == "LBOK"
								#IFDEF TOP
								cDocSF1 += "( SD1.D1_DOC = '" + aSF1[nCnt,nPosDoc] + "' AND SD1.D1_SERIE = '" + aSF1[nCnt,nPosSerie] + "' ) OR "
								#ELSE
								cDocSF1 += "( SD1->D1_DOC == '" + aSF1[nCnt,nPosDoc] + "' .And. SD1->D1_SERIE == '" + aSF1[nCnt,nPosSerie] + "' ) .Or. "
								#ENDIF
							EndIf
						Next nCnt
						If !Empty(cDocSF1)
							#IFDEF TOP
							cDocSF1 := SubStr(cDocSF1,1,Len(cDocSF1)-3) + " )"
							#ELSE
							cDocSF1 := SubStr(cDocSF1,1,Len(cDocSF1)-5) + " )"
							#ENDIF
						EndIf

						ValidPerg(cPerg)
						If Pergunte(cPerg,.T.)
							ESTE03Grava(lFornece,cFornece,cLoja,cDocSF1)
						Endif
					EndIf
				Else
					Aviso(OemToAnsi("Atencao!"),OemToAnsi("Nenhum documento encontrado, favor verificar os dados informados  ..."),{OemToAnsi("Ok")}, 2)
				EndIf
			Else
				DbSelectArea("SF1")
				cIndex := CriaTrab(NIL,.F.)
				cQuery := " SF1->F1_FILIAL == '" + xFilial("SF1") + "' "
				cQuery += " .And. SF1->F1_FORNECE == '" + cFornece + "' "
				cQuery += " .And. SF1->F1_LOJA    == '" + cLoja    + "' "
				cQuery += " .And. DtoS(SF1->F1_EMISSAO) >= '" + DtoS(dDataDe)  + "'"
				cQuery += " .And. DtoS(SF1->F1_EMISSAO) <= '" + DtoS(dDataAte) + "' "
				If lForn
					cQuery += " .And. !(SF1->F1_TIPO $ 'DB') "
				Else
					cQuery += " .And. SF1->F1_TIPO $ 'DB'
				EndIf

				IndRegua("SF1",cIndex,SF1->(IndexKey()),,cQuery)

				If SF1->(!Eof())
					MaWndBrowse(0,0,300,600,OemToAnsi("Itens do Doctos. de Entrada"),"SF1",,aRotina,,,,.T.,,,,,,.F.)
				Else
					Aviso(OemToAnsi("Atencao!"),OemToAnsi("Nenhum documento encontrado, favor verificar os dados informados  ..."),{OemToAnsi("Ok")}, 2)
				EndIf
				RetIndex( "SF1" )
				FErase( cIndex+OrdBagExt() )
			EndIf
		EndIf
	EndIf

	//Inclui := !Inclui
	Pergunte("MTA260",.F.)

Return .T.

Static Function ESTE03Grava(lFornece,cFornece,cLoja,cDocSF1)
	Local aArea     := GetArea()
	Local aAreaSX3  := SX3->(GetArea())
	Local aAreaSF1  := SF1->(GetArea())
	Local aAreaSD1  := SD1->(GetArea())

	Local lQuery    := .F.
	Local nOpcA     := 0
	Local nX        := 0

	Local cAliasSD1 := "SD1"
	Local cAliasSB1 := "SB1"
	Local cQuery    := ""

	Default lFornece := .F.
	Default cFornece := SF1->F1_FORNECE
	Default cLoja    := SF1->F1_LOJA
	Default cDocSF1  := ''

	If SoftLock("SF1")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos itens da Nota Fiscal de Devolucao/Retorno          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD1")
		dbSetOrder(1)

		lQuery    := .T.
		cAliasSD1 := "QRYSD1"
		cAliasSB1 := "QRYSD1"
		aStruSD1  := SD1->(dbStruct())
		cQuery    := "SELECT SD1.*,B1_DESC,B1_UM,B1_SEGUM "
		cQuery    += "FROM "+RetSqlName("SD1")+" SD1, "
		cQuery    += RetSqlName("SB1")+" SB1 "
		cQuery    += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' AND "

		If !lFornece
			cQuery += "SD1.D1_DOC = '"+SF1->F1_DOC+"' AND "
			cQuery += "SD1.D1_SERIE = '"+SF1->F1_SERIE+"' AND "
		Else
			If !Empty(cDocSF1)
				cQuery += " ( "
				cQuery += cDocSF1 + " AND "
			EndIf
		EndIf
		cQuery    += "SD1.D1_FORNECE = '"+cFornece+"' AND "
		cQuery    += "SD1.D1_LOJA = '"+cLoja+"' AND "
		cQuery    += "SD1.D_E_L_E_T_=' ' AND "

		cQuery    += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND "
		cQuery    += "SB1.B1_COD = SD1.D1_COD AND "
		cQuery    += "SB1.D_E_L_E_T_=' ' "

		cQuery    += "ORDER BY "+SqlOrder(SD1->(IndexKey()))

		cQuery    := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)

		For nX := 1 To Len(aStruSD1)
			If aStruSD1[nX][2]<>"C"
				TcSetField(cAliasSD1,aStruSD1[nX][1],aStruSD1[nX][2],aStruSD1[nX][3],aStruSD1[nX][4])
			EndIf
		Next nX

		While !Eof() .And. (cAliasSD1)->D1_FILIAL == xFilial("SD1") .And. (cAliasSD1)->D1_FORNECE == cFornece .And. (cAliasSD1)->D1_LOJA == cLoja .And.;
		If(!lFornece,(cAliasSD1)->D1_DOC == SF1->F1_DOC .And. (cAliasSD1)->D1_SERIE == SF1->F1_SERIE,.T.)
			AddItem((cAliasSD1)->D1_COD,(cAliasSD1)->D1_QUANT,(cAliasSD1)->D1_LOCAL,(cAliasSD1)->D1_LOTECTL,(cAliasSD1)->D1_LOTECTL)
			dbSelectArea(cAliasSD1)
			dbSkip()
		EndDo

		If ( lQuery )
			dbSelectArea(cAliasSD1)
			dbCloseArea()
			ChkFile("SC6",.F.)
			dbSelectArea("SC6")
		Else
			If lFornece
				RetIndex( "SD1" )
			EndIf
		EndIf
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Destrava Todos os Registros                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsUnLockAll()

	RestArea(aAreaSX3)
	RestArea(aAreaSF1)
	RestArea(aAreaSD1)
	RestArea(aArea)

Return( nOpcA )

Static Function AddItem(cProduto,nQuant,cLcOri,cLoteOri,cLoteDes)
	Local nTam      := aColsBlank()   // Adiciona nova linha
	Local cEndereco := PADR(GetMv("MV_XENDTRN",.F.,"TRANSITORIO"),Len(SBF->BF_LOCALIZ))	

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(XFILIAL("SB1")+cProduto))

	aCols[nTam,nPosCODOri] := cProduto
	aCols[nTam,nPosDOri]   := SB1->B1_DESC
	aCols[nTam,nPosUMOri]  := SB1->B1_UM
	aCols[nTam,nPosLOCOri] := cLcOri
	aCols[nTam,nPosQUANT]  := nQuant
	aCols[nTam,nPosQTSEG]  := ConvUm(SB1->B1_COD,aCols[n,nPosQUANT],aCols[n,nPosQTSEG],2)

	If !__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3())
		aCols[nTam,nPosLcZOri] := cEndereco
		If Rastro(cProduto)
			aCols[nTam,nPosLoTCTL] := cLoteOri
		Else
			aCols[nTam,nPosLoTCTL] := Space(Len(cLoteOri))
		Endif
	EndIf

	aCols[nTam,nPosCODDes] := cProduto
	aCols[nTam,nPosDDes]   := SB1->B1_DESC
	aCols[nTam,nPosUMDes]  := SB1->B1_UM
	aCols[nTam,nPosLOCDes] := mv_par01

	If !__lPyme .Or. (FindFunction("LocalizS3") .And. LocalizS3())
		aCols[nTam,nPosLcZDes] := mv_par02
	EndIf

	If Rastro(cProduto)
		aCols[nTam,nPosLotDes] := cLoteDes
	Else
		aCols[nTam,nPosLotDes] := Space(Len(cLoteDes))
	Endif

Return

Static Function aColsBlank()
	Local nX, cCampo, nTam

	If Len(aCols) > 1 .Or. !Empty(aCols[1,1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do ACols (Visualiza‡„o)     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aCols, Array(Len(aHeader)+1))
	Endif

	nTam := Len(aCols)

	For nX:=1 To Len(aHeader)
		cCampo := Alltrim(aHeader[nX,2])
		If IsHeadRec(aHeader[nX][2])
			aCols[nTam,nX] := 0
		ElseIf IsHeadAlias(aHeader[nX][2])
			aCols[nTam,nX] := "SD3"  //cAlias
		ElseIf aHeader[nX,8] == 'C'
			aCols[nTam,nX] := Space(aHeader[nX,4])
		ElseIf aHeader[nX,8] == 'N'
			aCols[nTam,nX] := 0
		ElseIf aHeader[nX,8] == "D" .And. cCampo != "D3_DTVALID"
			aCols[nTam,nX] := dDataBase
		ElseIf aHeader[nX,8] == "D" .And. cCampo == "D3_DTVALID"
			aCols[nTam,nX] := CriaVar("D3_DTVALID")
		ElseIf aHeader[nX,8] == 'M'
			aCols[nTam,nX] := ''
		Else
			aCols[nTam,nX] := .F.
		EndIf
	Next nX
	aCols[nTam,Len(aHeader)+1] := .F.

Return nTam

Static Function ValidPerg(cPerg)
	Local nTam := TamSX3("BF_LOCALIZ")[1]

	u_InPutSX1(cPerg,"01",PADR("Almoxarifado destino",29)+"?","","","mv_ch1","C",   2,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Endereco destino    ",29)+"?","","","mv_ch2","C",nTam,0,0,"G","","","","","mv_par02")
Return
