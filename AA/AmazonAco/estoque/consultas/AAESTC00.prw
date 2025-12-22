#include "Protheus.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AAESTC00   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 23/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Consulta dados das puxadas                                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAESTC00()
	Local nX, oFolder
	Local nOpcA := 0
	Local aProd := {}
	
	Private oPuxa
	Private cCadastro := "Consulta de Puxadas"
	
	Private aFolTab := {}
	Private aFolder := {}
	Private aOpcTab := {}
	Private aFolCon := { "Cadastro", "Consulta"}
	Private bPasta  := {|a,b,c,d,e,f| MontaPasta(a,b,c,d,e,f) }
	Private aViews  := {}    // Vetor de consultas
	
	Private bRefresh := {||  }
	
	// Atribui os campos da Aba produtos
	AAdd( aProd , AddColuna("B1_COD"   ) )
	AAdd( aProd , AddColuna("B1_DESC"  ) )
	AAdd( aProd , AddColuna("B1_LOCPAD") )
	AAdd( aProd , AddColuna("B1_FABRIC") )
	AAdd( aProd , AddColuna("B1_UM"    ) )
	AAdd( aProd , AddColuna("ZW_SALDO" ) )

	// Carrega os registros do produto
	Carrega("SB1",aProd)
	
	// Atribui as pastas principais
	AAdd( aFolTab , { "SB1", "Produtos"       , Nil, aClone(aProd), {|a| Carrega("SB1",a) }, { "Produto", "Descricao", "Geral"}} )
	AAdd( aFolTab , { "SA4", "Transportadoras", Nil, Nil, Nil, Nil} )
	AAdd( aFolTab , { "SZF", "Motoristas"     , Nil, Nil, Nil, Nil} )
	AAdd( aFolTab , { "SZX", "Puxadas"        , Nil, Nil, Nil, Nil} )
	
	// Atribui as consultas de cada acima
	AAdd( aViews  , {|a,b,c| u_AAESTC01(TMPSB1->B1_COD,{20,5,500,215},a,b,c) } )
	AAdd( aViews  , {|a,b,c| u_AAESTC03(SA4->A4_COD   ,{20,5,500,215},a,b,c) } )
	AAdd( aViews  , {|a,b,c| u_AAESTC04(SZF->ZF_CODIGO,{20,5,500,215},a,b,c) } )
	AAdd( aViews  , {|a,b,c|  } )
	
	// Monta as pastas das tabelas
	aEval( aFolTab , {|x| AAdd( aFolder , x[2] ), AAdd( aOpcTab , 1 ) } )
	
	DEFINE MSDIALOG oPuxa TITLE cCadastro From 0,0 TO 39,150 OF oMainWnd
	
	// Desenha as Pastas das Principais
	oFolder := TFolder():New(015,002,aFolder,,oPuxa,,,,.T.,,590,275,)
	For nX:=Len(aFolder) To 1 Step -1
		Eval(bPasta,aFolTab[nX,1],oFolder:aDialogs[nX],nX,aFolTab[nX,4],aFolTab[nX,5],aFolTab[nX,6])
	Next
	
	ACTIVATE MSDIALOG oPuxa CENTERED ON INIT ( EnchoiceBar(oPuxa, {|| nOpcA := 1, If(nOpcA==1,,) }, {|| nOpcA:=0, oPuxa:End()} ) )
	
Return

Static Function MontaPasta(cAlias,oObj,nFolder,aCampos,bFuncao,aOpcPesq)
	
	// Desenha as Pastas dos Cadastros
	aFolTab[nFolder,3] := TFolder():New(005,002,aFolCon,,oObj,,,,.T.,,580,250,)
	
	aFolTab[nFolder,3]:bSetOption := {|nAtu| Consulta(nAtu,aFolTab[nFolder,3]:nOption,nFolder) }
	
	Eval(aViews[nFolder],aFolTab[nFolder,3]:aDialogs[2],aOpcTab[nFolder]==1,.T.)
	
	@ 020,530 BUTTON oImp PROMPT "Impressão" SIZE 35,18 ACTION Imprime(1,nFolder) OF aFolTab[nFolder,3]:aDialogs[2] MESSAGE "Imprime consulta" PIXEL
	@ 040,530 BUTTON oImp PROMPT "Excel"     SIZE 35,18 ACTION Imprime(2,nFolder) OF aFolTab[nFolder,3]:aDialogs[2] MESSAGE "Exporta Excel" PIXEL
	
	@ 070,530 SAY "Exibir puxadas:" OF aFolTab[nFolder,3]:aDialogs[2] PIXEL
	@ 080,530 RADIO oRadio VAR aOpcTab[nFolder] ITEMS "Todas","Com saldo" 3D SIZE 40,10 OF aFolTab[nFolder,3]:aDialogs[2];
	ON CHANGE MsgRun("Filtrando puxadas. Aguarde...",,{|| Eval(aViews[nFolder],aFolTab[nFolder,3]:aDialogs[2],aOpcTab[nFolder]==1,.F.) })
	
	BrowseTela(5,5,215,565,cAlias,aFolTab[nFolder,3]:aDialogs[1],aCampos,,,,,,,,,,,bFuncao,aOpcPesq)
   
Return

Static Function Consulta(nFldDst,nFldAtu,nFolder)
	Local lRet := .T.
	If nFldDst == 2  // Se estiver acessando a CONSULTA
		lRet := Eval(aViews[nFolder],aFolTab[nFolder,3]:aDialogs[2],aOpcTab[nFolder]==1,.F.)
	Endif
Return lRet

Static Function Imprime(nOpc,nFolder)
	Local cFile
	Local aItems := {}
	
	If nOpc == 1   // Imprime relatório
		If nFolder == 1
			aItems := u_GetProdPuxada(.F.)   // Carrega os itens atuais
			u_AAESTR03(TMPSB1->B1_COD,aItems)
		ElseIf nFolder == 2
			aItems := u_GetTranPuxada(.F.)   // Carrega os itens atuais
			u_AAESTR04("Transportadora", SA4->A4_COD, SA4->A4_NOME, aItems, .F.)
		ElseIf nFolder == 3
			aItems := u_GetMotoPuxada(.F.)   // Carrega os itens atuais
			u_AAESTR04("Motorista", SZF->ZF_CODIGO, SZF->ZF_NOME, aItems, .F.)
		Else
			MsgInfo("Impressão "+aFolTab[nFolder,2]+".")
		Endif
	Else           // Exporta para Excel
		If nFolder == 1
			aItems := u_GetProdPuxada(.T.)   // Carrega os itens atuais
			If Empty(aItems) .Or. Len(aItems) == 1 .And. Empty(aItems[1,1])
				MsgAlert("Não existem dados a exportar para Excel !")
			Else
				MsgRun("Gerando arquivo XLS. Aguarde...",,{|| cFile := Exporta("produto","Produto: "+SB1->B1_DESC,aItems) })
				MsgRun("Exportando XLS. Aguarde...",,{|| Copiando(cFile) })
			Endif
		ElseIf nFolder == 2
			aItems := u_GetTranPuxada(.T.)   // Carrega os itens atuais
			If Empty(aItems) .Or. Len(aItems) == 1 .And. Empty(aItems[1,1])
				MsgAlert("Não existem dados a exportar para Excel !")
			Else
				MsgRun("Gerando arquivo XLS. Aguarde...",,{|| cFile := Exporta("transportadora","Transportadora: "+SA4->A4_NOME,aItems) })
				MsgRun("Exportando XLS. Aguarde...",,{|| Copiando(cFile) })
			Endif
		ElseIf nFolder == 3
			aItems := u_GetMotoPuxada(.T.)   // Carrega os itens atuais
			If Empty(aItems) .Or. Len(aItems) == 1 .And. Empty(aItems[1,1])
				MsgAlert("Não existem dados a exportar para Excel !")
			Else
				MsgRun("Gerando arquivo XLS. Aguarde...",,{|| cFile := Exporta("motorista","Motorista: "+SZF->ZF_NOME,aItems) })
				MsgRun("Exportando XLS. Aguarde...",,{|| Copiando(cFile) })
			Endif
		Else
			MsgInfo("Excel "+aFolTab[nFolder,2]+".")
		Endif
	Endif
Return

Static Function BrowseTela(nLin1,;		//01
					 nCol1,;		//02
					 nCol2,;		//03
					 nLin2,;		//04
					 uAlias,;	//05
					 oDlg,;		//06
					 aCampos,;	//07
					 cFun,;		//08
					 cTopFun,;	//09
					 cBotFun,;	//10
					 aResource,;//11
					 lDic,;		//12
					 bViewReg,;	//13
					 oBrowse,;	//14
					 nFreeze,;	//15
					 aHeadOrd,;	//16
					 aCores,;	//17
					 bFuncao,;	//18
					 aOpcPesq)	//18
	
	Local aPesqui := {}
	Local aMyOrd  := {}
	Local lSeeAll := GetBrwSeeMode()
	Local lUseDetail := .F.
	Local cSeek   := xFilial(uAlias)
	Local cOrd    := Nil
	Local oOrd
	Local cCampo  := SPACE(40)
	Local lPesqOk := .T.
	
	DEFAULT bViewReg	:= {|| Nil }
	DEFAULT lDic    := .T.
	
	Private aOrd := {}
	
	lDic := If( aCampos <> Nil .And. !Empty(aCampos) , .F., lDic)
	
	If bFuncao <> Nil
		Eval(bFuncao,aCampos)
		uAlias := Alias()
	Endif
	
	If lPesqOk := SX2->(dbSeek(uAlias))    // Se existe o alias no dicionário de dados
		AxPesqOrd(uAlias,@aMyOrd,@lUseDetail,lSeeAll)
		
		// Monta o Array de Ordenações
		For nX:=1 To Len(aOrd)
			aOrd[nX] := AllTrim(aOrd[nX])
			AAdd( aPesqui , { aOrd[nX], aMyOrd[nX,1], aMyOrd[nX,2]} )
		Next
		
		(uAlias)->(dbSeek(xFilial()))
	ElseIf aOpcPesq <> Nil
		aOrd := aClone(aOpcPesq)
		
		// Monta o Array de Ordenações
		For nX:=1 To Len(aOrd)
			aOrd[nX] := AllTrim(aOrd[nX])
			AAdd( aPesqui , { aOrd[nX], nX, .T.} )
		Next
	Endif
	
	dbSelectArea(uAlias)
	dbGoTop()
	
	If lPesqOk .Or. aOpcPesq <> Nil
		@ nLin1,nCol1 COMBOBOX oOrd VAR cOrd ITEMS aOrd SIZE 150,36 PIXEL OF oDlg FONT oDlg:oFont;
		ON CHANGE If( lPesqOk , ((uAlias)->(dbSetOrder(aPesqui[oOrd:nAt][2])),oBrowse:Refresh()), )
		
		@ nLin1,nCol1+154 MSGET oBigGet VAR cCampo SIZE 180,10 PIXEL OF oDlg
		
		DEFINE SBUTTON FROM nLin1,nCol1+338 TYPE 1 OF oDlg ENABLE ACTION ;
		(If( lPesqOk , (uAlias)->(BrwPesqui(oBrowse,cSeek,@cCampo)),;
		(Carrega(Right(uAlias,3),aCampos,aPesqui[oOrd:nAt][2],cCampo), cCampo := Space(Len(cCampo)))),If(oBrowse<>Nil,oBrowse:SetFocus(),))
	Endif
	
	oBrowse := MaMakeBrow(oDlg,uAlias,{nLin1+15,nCol1,nLin2,nCol2},,lDic,aCampos,cFun,cTopFun,cBotFun,aResource,bViewReg,nFreeze,aHeadOrd,aCores)
	
Return

Static Function BrwPesqui(oBrowse,cSeek,cCampo)
	
	dbSeek(cSeek+AllTrim(cCampo),.T.)
	
	If oBrowse != Nil
		oBrowse:Refresh()
	EndIf
	
	cCampo := Space(Len(cCampo))
	
Return

Static Function Exporta(cFile,cLegenda,aItems)
	Local i, j, aLinha, nIni, nFim
	Local cArqTxt := cFile+".XLS"
	Local nHdl    := fCreate("\"+cArqTxt)
	Local cLinha  := ""
	Local aExport := {}
	
	// Adiciona os dados para exportação
	For i:=1 To Len(aItems)
		aLinha := {}
		nIni   := If( i == 1 , 2, 1)
		nFim   := Len(aItems[i]) - If( i == 1 , 0, 1)
		For j:=nIni To nFim
			AAdd( aLinha , Formata(aItems[i,j]) )
		Next
		AddExport(@aExport,aLinha)  // Atribui aLinha para aExport e zera a Linha
	Next
	
	cLinha := cLegenda+chr(13)+chr(10)
	
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf
	
	// Gera os dados no arquivo em excel
	For i:=1 To Len(aExport)
		cLinha := ""
		If ValType(aExport[i])<>"A"
			clinha += aExport[i]
		Else
			For j:=1 to Len(aExport[i])
				cLinha += aExport[i][j]+Chr(9)
			Next
		Endif
		
		cLinha += chr(13)+chr(10)
		
		If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
		EndIf
	Next
	fClose(nHdl)
	
Return cArqTxt

Static Function AddExport(aExport,aLinha)
	aAdd(aExport,Array(Len(aLinha)))
	aExport[Len(aExport)] := aClone(aLinha)
Return

Static Function Formata(xValor)
	Local cRet := ""
	
	If ValType(xValor) == "N"
		cRet := Transform(xValor,"@E 999,999,999.99")
	ElseIf ValType(xValor) == "D"
		cRet := Dtoc(xValor)
	ElseIf ValType(xValor) == "L"
		cRet := If( xValor , ".T.", ".F.")
	Else
		cRet := xValor
	Endif
	
Return cRet

Static Function Copiando(cArquivo)
	Local oExcelApp
	Local cPath := GetTempPath()
	
	If File(cPath+cArquivo)
		FErase(cPath+cArquivo)
	Endif
	
	CpyS2T("\"+cArquivo, cPath, .T.)
	
	oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
	oExcelApp:WorkBooks:Open(cPath+cArquivo)
	oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
	oExcelApp:Destroy()
Return

Static Function AddColuna(cCampo)
	// Posiciona no dicionário do campo
	SX3->(dbSetOrder(2))
	SX3->(dbSeek(cCampo))
Return SX3->({ X3_CAMPO, X3_PICTURE, X3_TITULO, X3_TAMANHO, X3_CONTEXT})

Static Function Carrega(cAlias,aCampos,nOpc,cSeek)
	Local cQry
	Local aField := {}
	Local cTrab  := "TMP"+cAlias
	
	Static cRet := ""
	
	// Se a tabela temporária ainda não tiver sido criada
	If Select(cTrab) == 0
		SX3->(dbSetOrder(2))
		For nX:=1 To Len(aCampos)
			SX3->(dbSeek(aCampos[nX,1]))
			AAdd( aField , SX3->({ X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL}) )
		Next
		cRet := CriaTrab(aField,.T.)
		Use &cRet Alias &cTrab New Exclusive
	Else
		dbSelectArea(cTrab)
		Zap  // Limpa a tabela
	Endif
	
	cQry := " SELECT SB1.B1_COD, SB1.B1_DESC, SB1.B1_LOCPAD, SB1.B1_FABRIC, SB1.B1_UM, SUM(SZW.ZW_SALDO) ZW_SALDO"
	cQry += " FROM "+RetSQLName("SB1")+" SB1 "
	cQry += " INNER JOIN "+RetSQLName("SZW")+" SZW ON SZW.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SZW.ZW_CODPRO "
	cQry += " WHERE SB1.D_E_L_E_T_ = ' '"
	cQry += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
	cQry += " AND SB1.B1_MSBLQL <> '1'"
	cQry += " AND EXISTS("
	cQry += " SELECT SZY.ZY_FILIAL"
	cQry += " FROM "+RetSQLName("SZY")+" SZY"
	cQry += " WHERE SZY.D_E_L_E_T_ = ' '"
	cQry += " AND SZW.ZW_FILIAL = SZY.ZY_FILIAL"
	cQry += " AND SZW.ZW_SERIE = SZY.ZY_SERIE"
	cQry += " AND SZW.ZW_LOJA = SZY.ZY_LOJA"
	cQry += " AND SZW.ZW_DOC = SZY.ZY_DOC"
	cQry += " AND SZW.ZW_CODPRO = SZY.ZY_CODPRO)"
	
	If cSeek <> Nil .And. !Empty(cSeek)  // Se definiu filtro
		Do Case
			Case nOpc == 1
				cQry += " AND SB1.B1_COD LIKE '%"+Alltrim(cSeek)+"%'"
			Case nopc == 2
				cQry += " AND SB1.B1_DESC LIKE '%"+Alltrim(cSeek)+"%'"
			Case nOpc == 3
				cQry += " AND SB1.B1_DESC LIKE '%"+Alltrim(cSeek)+"%' OR SB1.B1_COD LIKE '%"+Alltrim(cSeek)+"%')"
		EndCase
	Endif
	
	cQry += " GROUP BY SB1.B1_COD, SB1.B1_DESC, SB1.B1_LOCPAD, SB1.B1_FABRIC, SB1.B1_UM"
	cQry += " ORDER BY SB1.B1_COD"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TMPQRY", .T., .T. )
	dbGoTop()
	While !Eof()
		RecLock(cTrab,.T.)
		For nX:=1 To (cTrab)->(FCount())
			FieldPut( nX , TMPQRY->(FieldGet(FieldPos((cTrab)->(FieldName(nX))))) )
		Next
		MsUnLock()
		dbSelectArea("TMPQRY")
		dbSkip()
	Enddo
	dbCloseArea()
	dbSelectArea(cTrab)
	
	If Bof() .And. Eof()  // Se arquivo estiver vazio
		RecLock(cTrab,.T.)
		MsUnLock()
	Endif
	dbGoTop()
	
Return cRet

Static Function LeCoord()
	Local cLinha, x
	Local nPos := 1
	Local nTam := 3
	Local aRet := { 55, 545}
	
	If File("\COORD.TXT")
		nHdl := FT_FUSE("\COORD.TXT")
		FT_FGOTOP()
		cLinha := StrTran(FT_FREADLN(),",","")
		For x:=1 To Len(aRet)
			aRet[x] := Val(SubStr(cLinha,nPos,nTam))
			nPos += 3
		Next
		FT_FUSE()
	Endif
	
Return aRet