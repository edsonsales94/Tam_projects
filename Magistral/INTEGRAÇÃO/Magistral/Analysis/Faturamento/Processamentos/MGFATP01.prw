#Include "Protheus.Ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MGFATP01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 18/12/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de Monitoramento das Integrações                       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MGFATP01()
	Local cFiltro     := Nil
	Local aCores      := {	{"Z4_STATUS=='1'","ENABLE"    },; // INTEGRAÇÃO PENDENTE
							{"Z4_STATUS=='2'","BR_AMARELO"},; // INTEGRAÇÃO COM ERRO
							{"Z4_STATUS=='3'","DISABLE"   }}  // INTEGRAÇÃO PROCESSADA
	
	Private cCadastro := "Monitor de Integração"
	Private aRotina   := {}
	
	aAdd( aRotina, {"Pesquisar"     , "AxPesqui"    , 0, 1 , , .F.} )
	aAdd( aRotina, {"Visualizar"    , "AxVisual"    , 0, 2 , , .T.} )
	aAdd( aRotina, {"Importar"      , "u_MGFAT01Imp", 0, 3})
	aAdd( aRotina, {"Processar"     , "u_MGFAT01Trm", 0, 4})
	aAdd( aRotina, {"Exportar"      , "u_MGFAT01Exp", 0, 2})
	aAdd( aRotina, {"Hab.Orc.Erro"  , "u_MGHabOrcam", 0, 2})
	aAdd( aRotina ,{"Legenda"       , "u_MGFAT01Sem", 0, 2})
	
	mBrowse( ,,,,"SZ4",,,,,,aCores,,,,,,,.F.,cFiltro)
	
Return

User Function MGFAT01Trm(cAlias, nRecNo, nOpc)
	Local cOper, cIDFim
	Local aArea := (cAlias)->(GetArea())
	Local cPerg := "MGFATP0102"
	
	Private cLicenca := u_MGLicenca()    // Atualiza a licença
	
	Valid2Perg(cPerg)
	If Pergunte(cPerg,.T.)
		cOper  := LTrim(cValToChar(mv_par03))
		cIDFim := mv_par02
		
		SZ4->(dbSetOrder(1))
		SZ4->(dbSeek(XFILIAL("SZ4")+mv_par01,.T.))
		
		While !SZ4->(Eof()) .And. SZ4->Z4_FILIAL == XFILIAL("SZ4") .And. SZ4->Z4_ID <= cIDFim
			
			If !Empty(SZ4->Z4_REST) .And. SZ4->Z4_OPER == cOper
				EnviaDados(.T.,SZ4->Z4_ID)
			Endif
			
			SZ4->(dbSkip())
		Enddo
	Endif
	
	(cAlias)->(RestArea(aArea))
	
Return

User Function MGFAT01Imp(cAlias, nRecNo, nOpc)
	Local dDia, lOk
	Local aProc := {"Vendas","Cancelamento Vendas","Baixas","Cancelamento Baixas"}
	Local aLog  := {}
	Local cPerg := "MGFATP01"
	
	Private cLicenca := u_MGLicenca()    // Atualiza a licença
	
	Valid1Perg(cPerg)
	If Pergunte(cPerg,.T.)
		For dDia:=mv_par01 To mv_par02
			FWMsgRun(Nil, {|oSay| lOk := u_MGImporta(mv_par03,dDia) }, "Integração com o CONTROL", "Importando "+aProc[mv_par03]+" do dia "+DtoC(dDia)+"...")
			AAdd( aLog , lOk )   // Adiciona o retorno da importação
		Next
		If AScan( aLog , .F. ) == 0
			FWAlertSuccess("Importação concluída com sucesso !")
		ElseIf AScan( aLog , .T. ) == 0
			FWAlertError("Ocorreram erros na importação !")
		Else
			FWAlertInfo("Importação concluída com erros ocorridos em alguns dias !")
		Endif
	Endif

Return

User Function MGFAT01Exp(cAlias, nRecNo, nOpc)
	Local oJSon, cErro, cOper, aVendas, nX
	Local aExcel := {}
	Local cPerg  := "MGFATP0102"
	
	Valid2Perg(cPerg)
	If Pergunte(cPerg,.T.)
		cOper := LTrim(cValToChar(mv_par03))
		
		SZ4->(dbSetOrder(1))
		SZ4->(dbSeek(XFILIAL("SZ4")+mv_par01,.T.))
		
		While !SZ4->(Eof()) .And. SZ4->Z4_FILIAL == XFILIAL("SZ4") .And. SZ4->Z4_ID <= mv_par02
			
			If !Empty(SZ4->Z4_LOG) .And. SZ4->Z4_OPER == cOper
				oJSon := JSonObject():New()
				cErro := oJSon:fromJson(AllTrim(SZ4->Z4_LOG))
				If ValType(oJSon) <> "U" .And. ( cErro == Nil .Or. Empty(cErro) )
					aVendas := oJSon["Status"]
					For nX:=1 To Len(aVendas)
						AAdd( aExcel , { aVendas[nX]["NfVenda"], aVendas[nX]["SerieNF"], aVendas[nX]["Emissao"], aVendas[nX]["Log"]})
					Next
				Endif
			Endif
			
			SZ4->(dbSkip())
		Enddo
		
		If !Empty(aExcel)
			FWMsgRun(Nil, {|oSay| MontaExcel(aExcel,"Integração Control") }, "Integração Control", "Exportando para Excel...")
		Endif
	Endif

Return

Static Function EnviaDados(lLote,cID)
	Local aArea  := GetArea()
	Local cError := ""
	Local bError := ErrorBlock({ |oError| cError := oError:Description })
	Local lOk    := .T.
	
	Begin Sequence
		FWMsgRun(Nil, {|oSay| u_MGIntegra(lLote,cID) }, "Integração com o CONTROL", "Processando integração...")
	End Sequence
	
	//Restaurando bloco de erro do sistema
	ErrorBlock(bError)
	
	If !lLote .And. !Empty(cError)
		FWAlertError("Houve um erro na gravação: " + CRLF + CRLF + cError, "Integração com CONTROL")
		
		lOk := FWAlertYesNo("Continua a processar as demais integrações ?")
	EndIf
	
	RestArea(aArea)

Return lOk

User Function MGFAT01Sem( cAlias, nRecNo, nOpc )
	BRWLEGENDA(cCadastro,"Integração com Control",;
						{{"ENABLE"   ,"Integração pendente" },;
						{"BR_AMARELO","Integração com erro" },;
						{"DISABLE"   ,"Integração processada"}})
Return

User Function MGHabOrcam(cAlias, nRecNo, nOpc )
	Local nOk  := 0
	Local cQry := ""
	
	If FWAlertYesNo("Confirma habilitar orçamentos com erros de geração de nota ?")
		cQry += " FROM " + RetSQLName("SL1") + " SL1"
		cQry += " WHERE SL1.D_E_L_E_T_ = ' '"
		cQry += " AND SL1.L1_SITUA = 'ER'"
		
		If ContaReg(cQry) > 0
			FWMsgRun(Nil, {|oSay| nOk := TCSQLExec("UPDATE SL1 SET SL1.L1_SITUA = 'RX'" + cQry + ";") }, "Habilitar Orçamentos", "Processando gravação...")
			
			If nOk < 0
				FWAlertError("Ocorreu um erro na habilitação dos orçamentos: <br /><br /><strong>" + TCSQLError() + "</strong>")
			Else
				FWAlertSuccess("Orçamentos habilitados com sucesso !")
			Endif
		Else
			FWAlertWarning("Não existem registros com erros de geração de nota !")
		Endif
	Endif

Return

Static Function ContaReg(cQry)
	Local aArea := GetArea()
	Local cTmp  := GetNextAlias()
	Local nRet  := 0
	
	cQry := "SELECT COUNT(*) AS TOTAL " + cQry
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry),cTmp)
	nRet := (cTmp)->TOTAL
	dbCloseArea()
	RestArea(aArea)

Return nRet

Static Function MontaExcel(aExcel,cTabela)
	Local oExcel
	Local aCampos := {}
	Local cPath   := GetTempPath()
	
	If Empty(aExcel)
		FWAlertError("Não existem informações a serem exportadas para Excel")
		Return
	Endif
	
	If !ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		FWAlertError("Para executar essa rotina é necessário que o Excel esteja instalado nessa estação !")
		Return
	Endif
	
	AAdd( aCampos , {"Nota"   ,"F2_DOC"    ,"@!"})
	AAdd( aCampos , {"Serie"  ,"F2_SERIE"  ,"@!"})
	AAdd( aCampos , {"Emissão","F2_EMISSAO","@!"})
	AAdd( aCampos , {"Log"    ,"Z4_LOG"    ,"@!"})
	
	oExcel:= FWMsExcelEx():New()
	oExcel:SetCelBold(.T.)
	oExcel:SetCelFont('Arial')
	oExcel:SetCelSizeFont(10)
	
	MyWrkSheet(oExcel,cTabela,"Detalhes"  ,aCampos,aExcel)
	
	oExcel:Activate()
	
	cXLS := "\integracao_control_"+DtoS(dDataBase)+"_"+StrTran(Time(),":","")+".xml"
	oExcel:GetXMLFile(cXLS)
	
	If File(cPath+cXLS)
		FErase(cPath+cXLS)
	Endif
	
	CpyS2T(cXLS, cPath, .T.)
	
	cXLS := StrTran(cPath + cXLS,"\\","\")
	
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cXLS)
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
	oExcelApp:Destroy()

Return

Static Function MyWrkSheet(oExcel,cTabela,cWrkSheet,aHeader,aCols)
	Local nX, nY, aLinha, cCBox
	Local aCBox := {}
	
	oExcel:AddworkSheet(cWrkSheet)
	oExcel:AddTable (cWrkSheet,cTabela)
	
	// Monta o cabeçalho
	For nX:=1 To Len(aHeader)
		oExcel:AddColumn(cWrkSheet,cTabela,Trim(aHeader[nX,1]) ,;
		If(ValType(aCols[1,nX])=="N",3,1),;
		If(ValType(aCols[1,nX])=="N",2,1),;
		If(ValType(aCols[1,nX])=="N",.F.,),;
		If(ValType(aCols[1,nX])=="N",aHeader[nX,3],))
		
		// Campos com COMBOBOX
		If !Empty( cCBox := GetSx3Cache(aHeader[nX,2], 'X3_CBOX') )
			AAdd( aCBox , { nX, RetSX3Box(cCBox,,,1)} )
		Endif
	Next
	
	For nX:=1 To Len(aCols)
		aLinha := {}
		For nY:=1 To Len(aHeader)
			AAdd( aLinha , aCols[nX,nY] )
		Next
		
		For nY:=1 To Len(aCBox)
			aLinha[aCBox[nY,1]] := ValorCombo(aCBox[nY,2],aLinha[aCBox[nY,1]])
		Next
		
		oExcel:AddRow(cWrkSheet,cTabela,aClone(aLinha))
	Next

Return

Static Function ValorCombo(aCombo,cValor)
	Local nPos := AScan( aCombo , {|x| x[2] == cValor })
Return If( nPos > 0 , Trim(aCombo[nPos,3]), cValor)

Static Function Valid1Perg(cPerg)
	u_MGPutSX1(cPerg,"01",PADR("Da Data   ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","   ","","mv_par01")
	u_MGPutSX1(cPerg,"02",PADR("Ate a Data",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","   ","","mv_par02")
	u_MGPutSX1(cPerg,"03",PADR("Processa  ",29)+"?","","","mv_ch3","N", 1,0,0,"C","","   ","   ","","mv_par03","Vendas","","","","Canc.Vendas","","","Baixas","","","Canc.Baixas")
Return

Static Function Valid2Perg(cPerg)
	u_MGPutSX1(cPerg,"01",PADR("Do ID   ",29)+"?","","","mv_ch1","C",TamSX3("Z4_ID")[1],0,0,"G","","   ","   ","","mv_par01")
	u_MGPutSX1(cPerg,"02",PADR("Ate o ID",29)+"?","","","mv_ch2","C",TamSX3("Z4_ID")[1],0,0,"G","","   ","   ","","mv_par02")
	u_MGPutSX1(cPerg,"03",PADR("Processa",29)+"?","","","mv_ch3","N",                 1,0,0,"C","","   ","   ","","mv_par03","Vendas","","","","Canc.Vendas","","","Baixas","","","Canc.Baixas")
Return
