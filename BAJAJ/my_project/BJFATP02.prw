#include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ BJFATP02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 26/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Reenvio do XML para os clientes                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function BJFATP02(cF2_DOC,cF2_SERIE)
	Local oTmp, cTab, cMarca, nX, cFile, cNome, aAnx, cPath
	Local cDir    := "\ANXBAJAJ"
	Local aCampos := {}
	Local aFields := {}
	Local cErro   := ""
	Local lOk     := .F.
	Local nGerado := 0
	Local nEnvios := 0
	Local lProc   := .F.
	Local cPerg   := "BJFATP02"
	Local aFiles  := {}
	
	Default cF2_DOC   := ""
	Default cF2_SERIE := ""
	
	// Cria os diretórios de configuração para exportação das tabelas
	If !ExistDir(cDir)
		MakeDir(cDir)
	Endif
	
	If !Empty(cF2_DOC) .And. !Empty(cF2_SERIE)
		EnviaEmail(cF2_DOC,cF2_SERIE,cDir+"\")
		Return
	Endif
	
	ValidPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	Endif
	
	Default nDoc := 1
	
	cPath := GetTempPath()
	
	// Monta os arquivos a serem anexados
	AAdd( aFiles, { "Gerando XML da NF-e "  , {|| Trim((cTab)->F2_CHVNFE) + ".xml" }} )
	AAdd( aFiles, { "Gerando DANFE da NF-e ", {|| Trim((cTab)->F2_CHVNFE) + ".pdf" }} )
	
	//-------------------
	// Criação do objeto
	//-------------------
	oTmp := FWTemporaryTable():New()
	
	//--------------------------
	// Monta os campos da tabela
	//--------------------------
	AAdd( aCampos , { "E1_OK"     , "C", 2, 0})
	AAdd( aCampos , { "F2_DOC"    , "C", 0, 0})
	AAdd( aCampos , { "F2_SERIE"  , "C", 0, 0})
	AAdd( aCampos , { "F2_EMISSAO", "D", 0, 0})
	AAdd( aCampos , { "F2_VALBRUT", "N", 0, 0})
	AAdd( aCampos , { "A1_XEMAIL" , "C", 0, 0})
	AAdd( aCampos , { "F2_CHVNFE" , "C", 0, 0})
	
	AAdd( aFields, { aCampos[1,1], ," ","@!"} )
	For nX:=2 To Len(aCampos)
		aCampos[nX,3] := TamSX3(aCampos[nX,1])[1]
		aCampos[nX,4] := TamSX3(aCampos[nX,1])[2]
		AAdd( aFields, { aCampos[nX,1], ,FWX3Titulo(aCampos[nX,1]),X3Picture(aCampos[nX,1])} )
	Next
	
	oTmp:SetFields( aCampos )
	oTmp:AddIndex("01", {"F2_DOC","F2_SERIE"} )
	
	//------------------
	// Criação da tabela
	//------------------
	oTmp:Create()
	
	//------------------------------------
	// Pego o alias da tabela temporária
	//------------------------------------
	cTab := oTmp:GetAlias()
	
	//------------------------------------
	// Executa a consulta para leitura da tabela
	//------------------------------------
	FWMsgRun(Nil, {|oSay| FiltraNotas(cTab) }, "Aguarde...", "Filtrando notas")
	
	(cTab)->(dbGoTop())
	If (cTab)->(Bof()) .And. (cTab)->(Eof())
		FWAlertError("Não foram encontrados registros para os parâmetros informados !")
	Else
		//---------------------------------
		// Exibe as notas para seleção
		//---------------------------------
		If lProc := SelecRegistros(cTab,@cMarca,"Seleção de Notas",aFields)
			(cTab)->(dbGoTop())
			While !(cTab)->(Eof())
				
				If (cTab)->E1_OK <> cMarca
					(cTab)->(dbSkip())
					Loop
				Endif
				
				aAnx := {}
				// Processa a geração dos anexos
				For nX:=1 To Len(aFiles)
					cNome := Eval( aFiles[nX,2] )
					
					// Identifica se o arquivo existe no servidor e continua o processo
					cFile := cDir + "\" + cNome
					If lOk := File(cFile)
						
						// Identifica se o arquivo existe na máquina local e exclui
						cFile := cPath + cNome
						If File(cFile)
							FErase(cFile)
						Endif
						
						// Copia o arquivo fiscal para a máquina local
						If IsBlind()
							lOk := CpyT2S(cFile, cDir, .T.)
						Else
							FWMsgRun(Nil, {|oSay| lOk := CpyT2S(cFile, cDir, .T.) }, "Aguarde...", "Copiando Documento para o servidor")
						Endif
					Endif
					
					If lOk
						AAdd( aAnx , cDir+"\"+cNome )
					Endif
				Next
				
				If Len(aAnx) > 0
					nGerado++
					If IsBlind()
						lOk := u_BJSendMail(Trim((cTab)->A1_XEMAIL), "Documentos da NF-e " + (cTab)->F2_DOC + " / " + (cTab)->F2_SERIE, "Envio de Documentos da NF-e. <br /><br /><strong>Favor não responder esse e-mail.</strong><br /><br />", aAnx, @cErro)
					Else
						FWMsgRun(Nil, {|oSay| lOk := u_BJSendMail(Trim((cTab)->A1_XEMAIL), "Documentos da NF-e " + (cTab)->F2_DOC + " / " + (cTab)->F2_SERIE, "Envio de Documentos da NF-e. <br /><br /><strong>Favor não responder esse e-mail.</strong><br /><br />", aAnx, @cErro) }, "Envio de Documentos Fiscais", "Enviando e-mail de Documentos da NF-e " + (cTab)->F2_DOC + " / " + (cTab)->F2_SERIE)
					Endif
					If lOk
						nEnvios++
					Endif
				Endif
				
				(cTab)->(dbSkip())
			Enddo
		Endif
	Endif
	
	//---------------------------------
	// Exclui a tabela
	//---------------------------------
	oTmp:Delete()
	
	If lProc
		If nGerado > 0 .And. nEnvios > 0
			FWAlertSuccess("Envio de XML concluídos com sucesso! <br /><br />"+;
							"Notas processadas: " + LTrim(cValToChar(nGerado))+"<br />"+;
							"Notas enviadas: " + LTrim(cValToChar(nEnvios)))
		Else
			FWAlertError("Ocorreu erro na geração e envio dos XMLs ! <br /><br />" + cErro)
		Endif
	Endif
	
Return

Static Function FiltraNotas(cTab)
	Local cQry, nX, nPos
	Local aArea := GetArea()
	Local cTmp  := GetNextAlias()
	
	cQry := "SELECT (CASE WHEN SA1.A1_XEMAIL = ' ' THEN SA1.A1_EMAIL ELSE SA1.A1_XEMAIL END) AS A1_XEMAIL, SF2.*"
	cQry += " FROM " + RetSQLName("SF2") + " SF2"
	cQry += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA"
	cQry += " WHERE SF2.D_E_L_E_T_ = ' '"
	cQry += " AND SF2.F2_FILIAL = '"+XFILIAL("SF2")+"'"
	cQry += " AND SF2.F2_EMISSAO >= '"+DtoS(mv_par01)+"'"
	cQry += " AND SF2.F2_EMISSAO <= '"+DtoS(mv_par02)+"'"
	cQry += " AND SF2.F2_DOC >= '" + mv_par03 + "'"
	cQry += " AND SF2.F2_DOC <= '" + mv_par04 + "'"
	cQry += " AND SF2.F2_CLIENTE >= '" + mv_par05 + "'"
	cQry += " AND SF2.F2_CLIENTE <= '" + mv_par06 + "'"
	cQry += " AND SF2.F2_CHVNFE <> ' '"
	cQry += " ORDER BY SF2.F2_DOC, SF2.F2_SERIE"
	
	DbUseArea(.t.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)), cTmp )
	
	TCSetField(cTmp,"F2_EMISSAO","D",8,0)
	
	(cTmp)->(dbGoTop())
	While !(cTmp)->(Eof())
		
		RecLock(cTab,.T.)
		For nX:=1 To (cTab)->(FCount())
			If (nPos := (cTmp)->(FieldPos((cTab)->(FieldName(nX))))) > 0
				FieldPut( nX , (cTmp)->(FieldGet(nPos)) )
			Endif
		Next
		MsUnLock()
		
		(cTmp)->(dbSkip())
	Enddo
	(cTmp)->(dbCloseArea())
	RestArea(aArea)

Return

Static Function SelecRegistros(cTab,cMarca,cLegenda,aFields,cCampo)
	Local oSlc, oBtn1, oBtn2, oMark
	Local lExec := .F.
	
	Default cCampo := "E1_OK"
	
	cMarca := GetMark()
	
	//---------------------------------
	// Exibe as notas para seleção
	//---------------------------------
	DEFINE MSDIALOG oSlc TITLE cLegenda FROM 00,00 TO 400,700 PIXEL
	
	oMark := MsSelect():New( cTab, cCampo,,aFields,, cMarca, { 001, 001, 170, 350 } ,,, )
	
	oMark:oBrowse:Refresh()
	oMark:bAval               := { || Marcar( cTab , cMarca , cCampo ), oMark:oBrowse:Refresh() }
	oMark:oBrowse:lHasMark    := .T.
	oMark:oBrowse:lCanAllMark := .T.
	//oMark:oBrowse:bAllMark    := { || MarcaTodos( cMarca ) }     
	
	DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oSlc:End()) ENABLE
	DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oSlc:End()) ENABLE
	
	ACTIVATE MSDIALOG oSlc CENTERED

Return lExec

Static Function Marcar(cTab,cMarca,cCampo)
	Local nPos := (cTab)->(FieldPos(cCampo))
	Local cMrk := (cTab)->(FieldGet(nPos))
	
	RecLock(cTab,.F.)
	(cTab)->( FieldPut( nPos , If( cMrk <> cMarca , cMarca, Space(Len(cMrk))) ) )
	MsUnLock()
	
Return

Static Function EnviaEmail(cF2_DOC,cF2_SERIE,cPath)
	Local cFile, cEmail, nF, nTimes
	Local aAnexo  := {}
	Local aFile   := {}
	Local cFilSF2 := XFILIAL("SF2")
	
	Private lEnvio := .F.
	
	AAdd( aFile , { "xml", {|a,b| u_BJSpedXML(SF2->F2_DOC,SF2->F2_SERIE,a,b) }, "" })
	AAdd( aFile , { "pdf", {|a,b| u_BJDANFE(  SF2->F2_DOC,SF2->F2_SERIE,a,b) }, "\"})
	
	u_fConout(Replicate("=",80))
	u_fConout("*** INICIADO ENVIO DO E-MAIL DA FILIAL "+cFilSF2+" - NOTA " + cF2_DOC+" / "+cF2_SERIE)
	
	SF2->(dbSetOrder(1))
	If SF2->(dbSeek(cFilSF2+cF2_DOC+cF2_SERIE)) .And. !Empty(SF2->F2_CHVNFE)
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			For nF:=1 To Len(aFile)
				// Processa a criação do arquivo a ser anexado
				If File( cFile := Trim(SF2->F2_CHVNFE) + "." + aFile[nF,1] )
					FErase(cFile)
				Endif
				If Eval( aFile[nF,2] , aFile[nF,3], cFile )
					// Exclui arquivo da pasta de anexos
					If File(cPath+cFile)
						FErase(cPath+cFile)
					Endif
					
					Sleep(2500)   // Pausa de 3 segundos antes de renomear o arquivo
					
					nTimes := 0
					While !File(cPath+cFile) .And. FRename(aFile[nF,3]+cFile,cPath+cFile) <> 0 .And. nTimes < 20   // Processa até 20x para anexar
						Sleep(500)   // Aguarda 1/2 segundo
						nTimes++
					Enddo
					
					If File(cPath+cFile)
						AAdd( aAnexo , cPath+cFile )
					Endif
					
					u_fConout(">>> ANEXADO " + Upper(aFile[nF,1]) + " " + cFile)
				Else
					u_fConout(">>> ERRO NA GERACAO DO " + Upper(aFile[nF,1]))
				Endif
			Next
			
			If Len(aAnexo) > 0
				If Empty(cEmail:=Trim(/*"roniltonob@gmail.com"*/ SA1->A1_EMAIL))
					u_fConout(">>> ERRO: CLIENTE COM EMAIL VAZIO")
				Else
					Enviando(cEmail,aAnexo)
				Endif
				If Empty(cEmail:=Trim(GetMV("MV_XEMAIL",.F.,""/*"neriane.tavares@totvs.com.br"*/)))
					u_fConout(">>> ERRO: PARAMETRO MV_XEMAIL COM EMAIL VAZIO")
				Else
					Enviando(cEmail,aAnexo)
				Endif
				
				lEnvio := .F.
				
				// Exclui os arquivos anexados
				For nF:=1 To Len(aAnexo)
					If File(aAnexo[nF])
						FErase(aAnexo[nF])
					Endif
				Next
			Else
				u_fConout(">>> ERRO: SEM ANEXOS PARA ENVIO")
			Endif
		Else
			u_fConout(">>> ERRO: CLIENTE NAO LOCALIZADO")
		Endif
	Else
		u_fConout(">>> ERRO: NF NAO LOCALIZADA OU CHAVE VAZIA")
	Endif
	
	u_fConout("*** FINALIZADO ENVIO DO E-MAIL DA FILIAL "+cFilSF2+" - NOTA " + cF2_DOC+" / "+cF2_SERIE)
	u_fConout(Replicate("=",80))

Return

Static Function Enviando(cEmail,aAnexo)
	Local cErro := ""
	Local lOk   := .T.
	
	If lEnvio   // Caso tenha sido envido um e-mail anterior
		Sleep(14000)    // Pausa de 14 segundos antes de iniciar o envio do e-mail
	Endif
	
	u_fConout(">>> INICIADO ENVIO DO E-MAIL")
	
	lOk := u_BJSendMail(Trim(cEmail),;
						"Documentos da NF-e " + SF2->F2_DOC + " / " + SF2->F2_SERIE,;
						"Envio de Documentos da NF-e. <br /><br /><strong>Favor não responder esse e-mail.</strong><br /><br />",;
						aAnexo,;
						@cErro)
	
	RecLock("SF2",.F.)
	If SF2->F2_XEMAENV $ " 0"   // Se ainda não processou
		SF2->F2_XEMAENV := If( lOk , "3", "1")   // Grava sucesso ou erro no envio
	Else
		If SF2->F2_XEMAENV == "1"    // Se já processou e deu erro
			SF2->F2_XEMAENV := If( lOk , "2", "1")  // Grava parcial ou erro no envio
		Else   // Se já processou com sucesso
			SF2->F2_XEMAENV := If( lOk , "3", "2")  // Grava sucesso ou parcial
		Endif
	Endif
	SF2->F2_XMSGLOG := cErro
	MsUnLock()
	
	lEnvio := .T.    // Atualiza como e-mail enviado
	
	u_fConout(">>> STATUS: " + SF2->F2_XEMAENV + " - " + If(lOk,"E-MAIL ENVIADO COM SUCESSO","ERRO " + cErro))

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 26/07/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Monta o grupo de perguntas da rotina                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	u_BJPutSX1(cPerg,"01",PADR("Da Emissao        ",29)+"?","","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par01")
	u_BJPutSX1(cPerg,"02",PADR("Ate a Emissao     ",29)+"?","","","mv_ch2","D",08,0,0,"G","","   ","","","mv_par02")
	u_BJPutSX1(cPerg,"03",PADR("Da Nota           ",29)+"?","","","mv_ch3","C",09,0,0,"G","","   ","","","mv_par03")
	u_BJPutSX1(cPerg,"04",PADR("Ate a Nota        ",29)+"?","","","mv_ch4","C",09,0,0,"G","","   ","","","mv_par04")
	u_BJPutSX1(cPerg,"05",PADR("Do Cliente        ",29)+"?","","","mv_ch5","C",06,0,0,"G","","SA1","","","mv_par05")
	u_BJPutSX1(cPerg,"06",PADR("Ate o Cliente     ",29)+"?","","","mv_ch6","C",06,0,0,"G","","SA1","","","mv_par06")
Return
