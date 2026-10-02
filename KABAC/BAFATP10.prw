#include 'totvs.ch'

/*/{Protheus.doc} BAFATP10
        Rotina de importação de Pedido de venda para faturamento
    @type  Function
    @author user
    @since 27/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
//Ajuste para atender chamado 1213 - CADASTRAR PREÇOS PARA MOTOS PARA MESMO MODELO MAS ANO DIFERENTE E PREÇO DIFERENTE 
User Function BAFATP10()
	Local cArqSel
	
	// While !Empty( cArqSel := BAFAT10A() )
	// 	BAFAT10B(cArqSel)
	// Enddo
	cArqSel := BAFAT10A()
	BAFAT10B(cArqSel)

Return

Static Function BAFAT10A()
	Local cArqSel := ""
	Local cDirIni := GetTempPath()
	Local cTipArq := "Arquivos com separações (*.csv) | Arquivos texto (*.txt)"
	Local cTitulo := "Seleção de Arquivos para Processamento"
	Local lSalvar := .F.
	
	//Chama a função para buscar arquivos
	cArqSel := cGetFile('Arquivos CSV|*.CSV' , 'Selecione o Arquivo a ser importado, formato CSV',1,'C:\temp\',.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)

	
Return cArqSel

Static Function BAFAT10B(cArqSel)
	Local aArea  := GetArea()
	Local lRun   := .F.
	Local aPergs := {}
	
	Local aSep := {"; - Ponto e Virgula",", - Virgula","| - Pipe"}
	Local aDel := {", - Virgula",". - Ponto"}
	
	If !IsBlind()
		If !Empty(cArqSel)
			aAdd( aPergs ,{9,"Preencha os dados abaixo",200,    40,.T.})
			aAdd( aPergs ,{2,"Separador Campos:"       , 01, aSep ,100,"",.T.})
			aAdd( aPergs ,{2,"Delimitador Decimal:"    , 01, aDel ,100,"",.T.})
			
			If ParamBox(aPergs ,"Parametros de importação")//,,{|| bOKaRet(aRet)},Nil,,,,,,,)
				lRun := FwAlertYesNo("O arquivo selecionado foi: " + cArqSel, "Proseguir?","Deseja Prosseguir ?")
			Else
				FWAlertError("Cancelado pelo usuario")
			EndIF
		Else
			FWAlertError("Nenhum arquivo selecionado", "Atencao")
		EndIf
	EndIf
	
	If lRun .And. FATP1000(cArqSel)
		Private oProcess
		Private	xSeparador   := left( iIf( ValType(mv_par02)=='N',aSep[mv_par02], mv_par02) ,1)
		Private xDelimitador := left( iIf( ValType(mv_par03)=='N',aDel[mv_par03], mv_par03) ,1)
		
		oProcess := MsNewProcess():New( { || FATP10AA(cArqSel) } , "Processando Arquivo => " + cArqSel , "Aguarde..." , .F. )
		
		oProcess:Activate()
	EndIf
	
	RestArea(aArea)

Return Nil

Static Function FATP1000(xFile)
	Local lRun       := .F.
	Local cDrive     := ""
	Local cDiretorio := ""
	Local cNome      := ""
	Local cExtensao  := ""
	Local xFileName  := ""
	Local xHash      := MD5File(xFile,2)
	
	SplitPath( xFile, @cDrive, @cDiretorio, @cNome,  @cExtensao )
	
	xFileName := cNome +"1"+cExtensao
	
	SZ4->(dbSetOrder(2))
	If lRun := !SZ4->(dbSeek(xFilial("SZ4") + xFileName))
		// Pesquisa pelo hash caso o nome não tenha sido encontrado para garantir alterações no arquivo
		SZ4->(dbSetOrder(1))
		lRun := !SZ4->(dbSeek(xFilial("SZ4") + xHash))
	EndIf
	
	If lRun
		RecLock("SZ4",.T.)
		SZ4->Z4_FILIAL  := xFilial("SZ4")
		SZ4->Z4_HASH    := xHash
		SZ4->Z4_DATA    := dDataBase
		SZ4->Z4_HORA    := Time()
		SZ4->Z4_TIMESTA := FwTimeStamp(4)
		SZ4->Z4_FILE    := xFileName
		SZ4->Z4_USER    := RetCodUsr()+"|"+cUserName
		MsUnLock()
	ElseIf Empty(SZ4->Z4_TFINAL)
		FWAlertError("Arquivo informado em importação pelo Usuario => " + SZ4->Z4_USER )
	Else
		FWAlertError("Arquivo informado já importado em " + DTOC(SZ4->Z4_DATA) + " Pelo Usuario => " + SZ4->Z4_USER )
	EndIf

Return lRun

Static Function ShowMessage(x,y,t,u,p)
	eecview((xAlias)->MENSAGEM)
Return Nil

Static Function ShowLines(x,y,t,u,p)
	eecview((xAlias)->LINHAS)
Return Nil

//==========================================================================================================
//Processa Itens e gera os array para rotina automatica
Static Function FATP10AA(xFile)
	Local oFile
	Local aPedido := {}
	Local cMsg    := ""
	
	oProcess:SetRegua1(5)
	
	If !File(xFile)
		FWAlertError("Arquivo Informado não encontrado", xFile)
		return
	EndIf
	
	oFile := FWFileReader():New(xFile)
	
	If (oFile:Open())
		oProcess:IncRegua1("Lendo dados do arquivo => " + xFile)
		FATP10BB(oFile,aPedido)
		
		oProcess:IncRegua1("Processando dados")
		FATP10CC(aPedido,@cMsg)
		
		RecLock("SZ4",.F.)
		//SZ4->Z4_TPROCES := oJson:ToJson()
		SZ4->Z4_TFINAL  := FwTimeStamp(4)
		MsUnlock()
		
		ConOut("[BAFATP10][FATP10AA] Exibindo resultado do processamento!")
		
		oProcess:IncRegua1("Finalizado, Exibindo resultado do processamento")
		
		If !Empty(cMsg)
			//cMensagem := "Medições geradas com sucesso ! <br /><br /><strong>Medições: </strong>"+cPedidos
			FWAlertSuccess("Foram gerados com -sucessos os pedidos: <br /><br /><strong>Pedido(s): " + cMsg + "</strong>")
		Endif
		
		FATP10EE(aPedido)
		
		ConOut("[BAFATP10][FATP10AA] Tudo Finalizado!")
	EndIf

Return Nil

Static Function FATP10BB(oFile,aPedido)
	//Enquanto houver linhas a serem lidas
	Local aSC5, nPed, cKeyCmp, aDados, nSeq, cMsg
	Local nLine   := 0
	Local cLinAtu := ""
	Local nNumImp := GetMV("MV_XIMPIPV",.F.,300)
	Local cAnoModelo:=""
	Local cAnoFabric:=""
	Local dDataFab:=cTod("//")

	//Local cVIN    := ""
	
	ConOut("[BAFATP10][FATP10BB] Iniciando processamento do arquivo!")
	
	oProcess:SetRegua2(0)
	
	if nNumImp == 0
		nNumImp := 300
	EndIf
	
	RecLock('SZ4',.F.)
	
	While (oFile:HasLine())
		
		//Buscando o texto da linha atual
		oProcess:IncRegua2()
		
		cLinAtu := oFile:GetLine()
		
		SZ4->Z4_CONTENT += iIf(++nLine == 0,"",Chr(10)) + cLinAtu
		
		If nLine == 1
			ConOut("[BAFATP10][FATP10BB]Linha:" + cLinAtu)
			Loop
		Endif
		
		aDados  := StrToKArr(cLinAtu,xSeparador)
		
		aDados[ 3] := PADL(Alltrim(aDados[ 3]),TamSX3("A1_COD" )[1],"0")
		aDados[ 4] := PADL(Alltrim(aDados[ 4]),TamSX3("A1_LOJA")[1],"0")
		aDados[11] := PADR(Alltrim(Upper(aDados[11])),TamSX3("B1_COD" )[1])
		
		SA1->(dbSetOrder(1))
		cMsg := If( SA1->(dbSeek(XFILIAL("SA1")+aDados[3]+aDados[4])) , "", "CLIENTE NAO CADASTRADO")
		
		cKeyCmp := Left(aDados[2],1) + aDados[3] + aDados[4] + Left(aDados[6],3)
		aItem   := {}
		
		nPed := AScan( aPedido , {|x| x[6] == cKeyCmp .And. Len(x[2]) < nNumImp } )
		If nPed == 0
			aSC5 := {}
			aAdd(aSC5, {"C5_TIPO"   , Left(aDados[2],1) , Nil} )
			aAdd(aSC5, {"C5_CLIENTE", aDados[3]         , Nil} )
			aAdd(aSC5, {"C5_LOJACLI", aDados[4]         , Nil} )
			aAdd(aSC5, {"C5_CLIENT" , aDados[3]         , Nil} )
			aAdd(aSC5, {"C5_LOJAENT", aDados[4]         , Nil} )
			aAdd(aSC5, {"C5_TABELA" , aDados[5]         , Nil} )
			aAdd(aSC5, {"C5_CONDPAG", CalcCond(aDados[6]), Nil} )
			aAdd(aSC5, {"C5_EMISSAO", CTOD(aDados[7])   , Nil} )
			aAdd(aSC5, {"C5_TPFRETE", aDados[8]         , Nil} ) //TIPO DE FRETE
			aAdd(aSC5, {"C5_TRANSP" , aDados[9]         , Nil} )//VALIDAR APENAS PARA FAT DE MOTO - NOTA DE REMESSA
			
			If SC5->(FieldPos("C5_XFILE")) > 0
				aAdd(aSC5,  {"C5_XFILE"  , SZ4->Z4_FILE, Nil} )
			EndIf
			
			// Calcula o próximo sequencial para a chave
			nSeq := 1
			aEval( aPedido , {|x| If( x[6] == cKeyCmp , nSeq++, ) } )
			
			//                SC5          SC6 Sta  Msg  Line Chave    Item                             Seq
			AAdd( aPedido , { aClone(aSC5), {}, "", cMsg, "", cKeyCmp, StrZero(0,TamSX3("C6_ITEM")[1]), StrZero(nSeq,4)})
			nPed := Len(aPedido)
		Endif
		
		//verifica se tem tabela (verificar se tem ao menos 1, validar se tem mais de uma)
		//Alterado por Cleveson Lima 14/01/2025
		//DA1->(dbSetOrder(1))
		//Verifica se Produto tem VIN , Se tiver vai procurar o produto pela ANOMODELO ,
		cCodVin:=iif(Len(aDados[14])>=14 ,AllTrim(aDados[14]) ,'')
		cCodVin:=iif(Empty(cCodVin),cCodVin,PadR(cCodVin,TamSX3("C6_XVIN")[1]))
		cAnoModelo:=""
		cAnoFabric:=""
		dDataFab:=cTod("//")
		if !Empty(cCodVin)
			cAnoModelo:=u_AnoModVin(cCodVin)
			dDataFab:=u_DataFabVin(cCodVin)
			cAnoFabric:=u_AnoFabVin(dDataFab)
		Endif 

		// DA1->(DbOrderNickName("DA1EST"))
		// if FwCodEmp() =="02"
		// 	If DA1->(dbSeek(xFilial('DA1') + PadL(aDados[5],TamSx3('DA1_CODTAB')[1],'0') + PadR(aDados[11],TamSx3('DA1_CODPRO')[1]) + PadR(SA1->A1_EST,TamSx3('DA1_ESTADO')[1]) + cAnoModelo )) .And. DA1->DA1_PRCVEN > 0
		// 			nValor := DA1->DA1_PRCVEN
		// 	ElseIf (xDelimitador == ",")
		// 		nValor := val( StrTran(StrTran(aDados[10],".",""),",",".") )
		// 	Else
		// 		nValor := val( StrTran(aDados[10],",",""))
		// 	Endif
		// 	cAnoFabric:=""
		// else 
		// 	If DA1->(dbSeek(xFilial('DA1') + PadL(aDados[5],TamSx3('DA1_CODTAB')[1],'0') + PadR(aDados[11],TamSx3('DA1_CODPRO')[1]) + PadR(SA1->A1_EST,TamSx3('DA1_ESTADO')[1]) + cAnoModelo+cAnoFabric )) .And. DA1->DA1_PRCVEN > 0
		// 		nValor := DA1->DA1_PRCVEN
		// 	ElseIf (xDelimitador == ",")
		// 		nValor := val( StrTran(StrTran(aDados[10],".",""),",",".") )
		// 	Else
		// 		nValor := val( StrTran(aDados[10],",",""))
		// 	Endif		
		// Endif
		nValor:=0
		if !Empty(cCodVin)
			nValor:=u_GetBjPrc(xFilial('DA1'),aDados[5],aDados[11],SA1->A1_EST,cAnoModelo,cAnoFabric)
		elseif ! (PadL(aDados[5],3,"0")  $ "001/002")  
			nValor:=u_GetBjPrc(xFilial('DA1'),aDados[5],aDados[11],SA1->A1_EST,cAnoModelo,cAnoFabric,"3")
		Endif 

		if Empty(nValor) 
			If  (xDelimitador == ",")
				nValor := val( StrTran(StrTran(aDados[10],".",""),",",".") )
			Else
				nValor := val( StrTran(aDados[10],",",""))
			Endif
		Endif 

		cMsg := If( Empty(cMsg) .And. nValor <= 0 , "PRECO NAO CADASTRADO", cMsg)
		aPedido[nPed][7] := Soma1(aPedido[nPed][7])
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		cMsg := If( !MsSeek(xFilial("SB1")+aDados[11]) .And. Empty(cMsg) , "PRODUTO NAO CADASTRADO", cMsg)
		
		aadd(aItem, {"C6_ITEM"   , aPedido[nPed][7]       , Nil})
		aAdd(aItem, {"C6_PRODUTO", aDados[11]             , Nil} )
		aAdd(aItem, {"C6_DESCRI" , SB1->B1_DESC           , Nil} )
		aAdd(aItem, {"C6_UM"     , SB1->B1_UM             , Nil} )
		aAdd(aItem, {"C6_QTDVEN" , Val(aDados[12])        , Nil} )
		aAdd(aItem, {"C6_PRCVEN" , nValor                 , Nil} )
		aAdd(aItem, {"C6_VALOR"  , Val(aDados[12])*nValor , Nil} )
		aAdd(aItem, {"C6_OPER"   , aDados[13]             , Nil} )
		If Len(aDados) >= 14
			aAdd(aItem, {"C6_XVIN"   , AllTrim(aDados[14]) , Nil} )

		// If !Empty(AllTrim(aDados[14]))
		// 	cVIN := AllTrim(aDados[14])

			// CD9->(DBOrderNickname("VIN"))

			// If CD9->(DbSeek(xFilial("CD9") + cVIN))

			// 	If !FwAlertYesNo("O VIN [" + cVIN + "] já foi faturado anteriormente. Deseja continuar com a importação?", "VIN já faturado")
			// 		ApMsgInfo("Processamento cancelado pelo usuário.", "Importação cancelada")
			// 		Return 
			// 	EndIf
			// EndIf
			// EndIf
		 endif
		if Len(aDados) >= 15
			aAdd(aItem, {"C6_XMOTOR" , aDados[15]          , Nil} )
		EndIf
		if Len(aDados) >= 16
			aAdd(aItem, {"C6_XNUMSER", aDados[16]          , Nil} )
		EndIf
		
		aAdd(aItem, {"C6_DATFAT" , CtoD("")               , Nil} )
		aAdd(aItem, {"C6_CLI"    , aDados[3]              , Nil} )
		aAdd(aItem, {"C6_LOJA"   , aDados[4]              , Nil} )
		
		If SC6->(FieldPos("C6_XFLINE")) > 0
			aAdd(aItem, {"C6_XFLINE"  , Alltrim(Str(nLine)), Nil} )
		EndIf

		If SC6->(FieldPos("C6_XDFABR")) > 0 .AND. !Empty(dDataFab) .and. ValType(dDataFab) == "D"
			aAdd(aItem, {"C6_XDFABR"  , dDataFab , Nil} )
		EndIf

		AAdd( aPedido[nPed,2] , aClone(aItem) )
		
		aPedido[nPed,4] := If( Empty(aPedido[nPed,4]) , cMsg, aPedido[nPed,4])
		aPedido[nPed,5] += cLinAtu + Chr(10)
		
		ConOut("[BAFATP10][FATP10BB]Linha:" + cLinAtu)
	EndDo
	
	MsUnlock()
	
	ConOut("[BAFATP10][FATP10BB] processamento finalizado!")
	
	oFile:Close()

Return

Static Function FATP10CC(aPedido,cMsg)
	Local i
	
	ConOut("[BAFATP10][FATP10CC] Iniciando processamento dos pedidos!")
	oProcess:SetRegua2(Len(aPedido))
	
	For i:=1 To Len(aPedido)
		oProcess:IncRegua2("Gerando Pedido de venda do item")
		aPedido[i][3] := "Processando"
		aPedido[i][4] := If(Empty(aPedido[i][4]), FATP10DD(aPedido[i],@cMsg), aPedido[i][4])
		aPedido[i][3] := If(Empty(aPedido[i][4]), "OK", "ER")
	Next
	
	ConOut("[BAFATP10][FATP10CC] processamento dos pedidos finalizado!")

Return

Static Function FATP10DD(aPedido,cMsg)
	Local cLogErro := ""
	Local nOpcX, nI, nQtdVen, nPosPrd, nPosTES, nMCusto
	//Local nCount
	//Local aErroAuto := {}
	Local aCabec := aPedido[1]
	Local aItens := aPedido[2]
	Local nPosCli := AScan( aCabec , {|x| Trim(x[1])=="C5_CLIENTE" } )
	Local nPosLoj := AScan( aCabec , {|x| Trim(x[1])=="C5_LOJACLI" } )
	
	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .F.
	/*
	aSize(aCabec, Len(aCabec) + 1)
	aIns(aCabec,1)
	aCabec[1] := {"C5_NUM"    , GetSxeNum("SC5", "C5_NUM") ,      Nil}
	*/
	ConOut("[BAFATP10][FATP10DD]-Chamando rotina automatica!")
	ConOut("[BAFATP10][FATP10DD]- Total de Itens => ("+Alltrim(Str(Len(aItens)))+")")
	
	nOpcX := 3
	
	If nPosCli > 0 .And. nPosLoj > 0
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(XFILIAL("SA1")+aCabec[nPosCli,2]+aCabec[nPosLoj,2])
	Endif
	
	nMCusto := If(SA1->A1_MOEDALC > 0, SA1->A1_MOEDALC, Val(SuperGetMv("MV_MCUSTO")))
	
	AddField(aCabec,"C5_NUM"   ,{|| GetSxeNum("SC5", "C5_NUM") })
	AddField(aCabec,"C5_FILIAL",{|| xFilial("SC5") })
	
	SC5->(dbSetOrder(1))
	While SC5->(dbSeek(xFilial("SC5")+aCabec[2,2]))
		ConfirmSx8()
		aCabec[2,2] := GetSxeNum("SC5", "C5_NUM")
	Enddo
	
	AddField(aCabec,"C5_TIPOCLI", {|| SA1->A1_TIPO}, 0)
	
	GravaTabela("SC5",aCabec,"C5_FILIAL,C5_NUM")
	
	For nI:=1 To Len(aItens)
		nPosPrd := AScan( aItens[nI] , {|x| Trim(x[1])=="C6_PRODUTO" } )
		
		AddField(aItens[nI],"C6_NUM",{|| SC5->C5_NUM })
		AddField(aItens[nI],"C6_FILIAL",{|| SC5->C5_FILIAL })
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial("SB1")+aItens[nI][nPosPrd,2])
		
		AddField(aItens[nI],"C6_LOCAL",{|| If(Empty(SB1->B1_LOCPAD),"01",SB1->B1_LOCPAD) },0)
		nPosTES := AddField(aItens[nI],"C6_TES",{|| If(Empty(SB1->B1_TS),"501",SB1->B1_TS) },0)
		
		aDadosCfo := {}
		AAdd( aDadosCfo , { "OPERNF"  , "S"           })
		AAdd( aDadosCfo , { "TPCLIFOR", SA1->A1_TIPO  })
		AAdd( aDadosCfo , { "UFDEST"  , SA1->A1_EST   })
		AAdd( aDadosCfo , { "INSCR"   , SA1->A1_INSCR })
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		MsSeek(xFilial("SF4")+aItens[nI][nPosTES,2])
		
		AddField(aItens[nI],"C6_CF"     ,{|| MaFisCfo(,SF4->F4_CF,aDadosCfo) },0)
		AddField(aItens[nI],"C6_CLASFIS",{|| CodSitTri()                     },0)
		
		GravaTabela("SC6",aItens[nI],"C6_FILIAL,C6_NUM")
		
		CriaSB2( SC6->C6_PRODUTO, SC6->C6_LOCAL )
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)

		If ( SF4->F4_ESTOQUE == "S" )
			RecLock("SB2")
			SB2->B2_QPEDVEN += (SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP-SC6->C6_QTDRESE	)
			SB2->B2_QPEDVE2 += ConvUM(SB2->B2_COD, SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP-SC6->C6_QTDRESE, 0, 2)
			MsUnLock()
		EndIf
		If ( SF4->F4_DUPLIC == "S" )
			nQtdVen := SC6->C6_QTDVEN - SC6->C6_QTDEMP - SC6->C6_QTDENT
			If ( nQtdVen > 0 )
				RecLock("SA1")
				SA1->A1_SALPED += xMoeda( nQtdVen * SC6->C6_PRCVEN , SC5->C5_MOEDA , nMCusto , SC5->C5_EMISSAO )
				MsUnLock()
			EndIf
		EndIf
	Next
	
	If !(SC5->C5_NUM $ cMsg)
		cMsg += If( Empty(cMsg) , "", ", ") + SC5->C5_NUM
	Endif
	
	ConfirmSx8()
	
	//MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)
	
	ConOut("[BAFATP10][FATP10DD]-Rotina automatica finalizada!")
	
	if lMsErroAuto
		ConOut("[BAFATP10][FATP10DD]-Erro na inclusao!")
		cLogErro := MostraErro("\error")
		ConOut("[BAFATP10][FATP10DD]" + cLogErro)
	Else
		DbCommitAll()
	EndIf

Return cLogErro

Static Function CalcCond(cCond)
	Local nPos
	Local aCond := {}
	Local cRet  := ""
	Local aCondLog

	//Se Empresa for KTM usar Condição da Planilha 
	if FWCodEmp() == "02"
		Return PADL(Alltrim(cCond),3,'0')
	Endif 
	If SB1->B1_GRUPO == "VPEC"    // Grupo de Peças
		cRet := GetMV("MV_XTECPAG",.F.,"")
	Else
		AAdd( aCond , Separa(GetMV("MV_XNO",.F.," | "),"|",.F.) )   // Norte
		AAdd( aCond , Separa(GetMV("MV_XNE",.F.," | "	),"|",.F.) )   // Nordeste
		AAdd( aCond , Separa(GetMV("MV_XCO",.F.," | "),"|",.F.) )   // Centro-Oeste
		AAdd( aCond , Separa(GetMV("MV_XSE",.F.," | "),"|",.F.) )   // Sudeste
		AAdd( aCond , Separa(GetMV("MV_XSU",.F.," | "),"|",.F.) )   // Sul
		aCondLog:=U_BJFTA03E(SA1->(Recno()))
		if Empty(aCondLog)
			nPos := AScan( aCond , {|x| SA1->A1_EST $x[2]} )
			If nPos > 0
				cRet := aCond[nPos,1]
			Endif
		else 
			//Pega Condição de pagamento pela tabela ZTF
			cRet := aCondLog[1]
		Endif 
	Endif
	
	cRet := PADR(If(Empty(cRet),cCond,cRet),TamSX3("C5_CONDPAG")[1])

Return cRet

Static Function AddField(aArray,cField,bValor,nPosInc)
	Local nPosFld := AScan( aArray , {|x| Trim(x[1]) == cField } )
	
	Default nPosInc := 1
	
	If nPosFld == 0
		nPosFld := nPosInc
		If nPosFld == 0
			AAdd( aArray , Nil )
			nPosFld := Len(aArray)
		Else
			aSize(aArray,Len(aArray)+1)
			aIns( aArray , nPosFld )
		Endif
		aArray[nPosFld] := { cField, Eval(bValor), Nil}
	Endif

Return nPosFld

Static Function GravaTabela(cAlias,aCampos,cNoFields)
	Local nC, nPos
	
	RecLock(cAlias,.T.)
	For nC:=1 To (cAlias)->(FCount())
		If !((cAlias)->(FieldName(nC)) $ cNoFields)
			(cAlias)->(FieldPut( nC , CriaVar(FieldName(nC),.T.) ))
		Endif
	Next
	
	For nC:=1 To Len(aCampos)
		nPos := (cAlias)->(FieldPos(aCampos[nC,1]))
		If nPos > 0
			(cAlias)->(FieldPut( nPos , aCampos[nC,2] ))
		Endif
	Next
	MsUnLock()

Return

Static Function FATP10EE(aPedido)
	Local oTempTable := FWTemporaryTable():New()
	Local aColumns := {}
	Local I
	
	aFields := {}
	aAdd(aFields, {"STATUS"   ,  "C", 02, 0})
	aAdd(aFields, {"CHAVE"    ,  "C", 20, 0})
	aAdd(aFields, {"MENSAGEM" ,  "M", 10, 0})
	aAdd(aFields, {"LINHAS"   ,  "M", 10, 0})
	
	AAdd(aColumns,FWBrwColumn():New())
	AAdd(aColumns,FWBrwColumn():New())
	AAdd(aColumns,FWBrwColumn():New())
	AAdd(aColumns,FWBrwColumn():New())
	
	aColumns[1]:SetData( &("{|| STATUS}") )
	aColumns[1]:SetTitle("Status")
	aColumns[1]:SetSize(12)
	aColumns[1]:SetDecimal(0)
	
	aColumns[2]:SetData( &("{|| CHAVE}") )
	aColumns[2]:SetTitle("Chave")
	aColumns[2]:SetSize(12)
	aColumns[2]:SetDecimal(0)
	
	aColumns[3]:SetData( &("{|| MENSAGEM}") )
	aColumns[3]:SetTitle("Mensagem")
	aColumns[3]:SetSize(50)
	aColumns[3]:SetDecimal(0)
	aColumns[3]:BLDBLClick := {|x,y,t,u,p|  ShowMessage(x,y,t,u,p) }
	
	aColumns[4]:SetData( &("{|| LINHAS}") )
	aColumns[4]:SetTitle("Linhas")
	aColumns[4]:SetSize(50)
	aColumns[4]:SetDecimal(0)
	aColumns[4]:BLDBLClick := {|x,y,t,u,p|  ShowLines(x,y,t,u,p) }
	
	//Define as colunas usadas
	oTempTable:SetFields( aFields )
	
	//Efetua a criação da tabela
	oTempTable:Create()
	
	Private xAlias := oTempTable:GetAlias()
	
	For I := 1 To Len(aPedido)
		RecLock(xAlias, .T.)
		(xAlias)->STATUS   := aPedido[i,3]
		(xAlias)->CHAVE    := aPedido[i,6]+aPedido[i,8]
		(xAlias)->MENSAGEM := aPedido[i,4]
		(xAlias)->LINHAS   := aPedido[i,5]
		MsUnlock()
	Next
	
	Private odMark := FWMBrowse():New() //crio o browse
	
	//odMark := FWMarkBrowse():New() //crio o browse
	odMark:SetAlias(xAlias) //set alias utilizado odMark:SetDescription("Strings Approval")
	
	odMark:AddLegend({|| (xAlias)->STATUS == "OK" },"GREEN")
	odMark:AddLegend({|| (xAlias)->STATUS != "OK"},"RED")
	odMark:SetColumns(aColumns)
	odMark:SetTemporary(.T.)
	odMark:SetUseFilter(.T.) //Using Filter
	
	odMark:SetMenuDef("")
	
	odMark:Activate()
	
	oTempTable:Delete()

Return Nil

/*/ Retorno o ano do modelo conforme o chassi/*/
User Function AnoModVin(cChassi)
	Local cAnoModelo 	:= ""
	Local cCodAno		:=iif(Len(cChassi)>=10,SubStr(cChassi,10,1),'') 
	Local jTabela       := jsonObject():new()
	jTabela["R"]:="2024"
	jTabela["S"]:="2025"
	jTabela["T"]:="2026"
	jTabela["V"]:="2027"
	jTabela["W"]:="2028"
	jTabela["X"]:="2029"
	jTabela["Y"]:="2030"
	jTabela["1"]:="2031"
	jTabela["2"]:="2032"
	jTabela["3"]:="2033"
	jTabela["4"]:="2034"
	jTabela["5"]:="2035"
	jTabela["6"]:="2036"
	jTabela["7"]:="2037"
	jTabela["8"]:="2038"
	jTabela["9"]:="2039"
	jTabela["A"]:="2040"
	jTabela["B"]:="2041"
	jTabela["C"]:="2042"
	jTabela["D"]:="2043"
	jTabela["E"]:="2044"
	jTabela["F"]:="2045"
	jTabela["G"]:="2046"
	jTabela["H"]:="2047"
	jTabela["J"]:="2048"
	jTabela["K"]:="2049"
	jTabela["L"]:="2050"
	jTabela["M"]:="2051"
	jTabela["N"]:="2052"
	jTabela["P"]:="2053"
	If valtype(jTabela:GetJsonObject(cCodAno))=="C" 
		cAnoModelo := jTabela:GetJsonObject(cCodAno)
	Endif 
Return cAnoModelo  

/*/ Pega Data de Fabricaçção do Vin na SZ1/*/
User Function DataFabVin(cChassi)
Local dDtFabric:=cTod("//")
	SZ1->(DbSetOrder(1))//Z1_FILIAL, Z1_VIN, R_E_C_N_O_, D_E_L_E_T_
	if SZ1->(DbSeek("01"+cChassi))
		dDtFabric:=iif( !Empty(SZ1->Z1_DTPRODU)	,SZ1->Z1_DTPRODU  	, dDtFabric)
		dDtFabric:=iif( Empty(dDtFabric)		,SZ1->Z1_DTINCLU 	, dDtFabric)
	Endif 
Return dDtFabric

/*/ Pega o Ano de Fabricação /*/
User Function AnoFabVin(dtFabric)
Local cAnoFabric:=""
	if !Empty(dtFabric).and.valtype(dtFabric)=="D" 
		cAnoFabric:=Year2Str(dtFabric)
	Endif 
Return cAnoFabric

/*/ Rotina que retorna o preço de motos  conforme conforme produto + estado + ano modelo + ano fabricação /*/
User Function GetBjPrc(pFilial,pTabela,pProduto,pUF,pAnoModelo,pAnoFabric,cValida)
Local nValor 	:= 0
Local cTabela	:= PadL(pTabela		,TamSx3('DA1_CODTAB')[1],'0')
Local cProduto	:= PadR(pProduto	,TamSx3('DA1_CODPRO')[1])
Local cUF		:= PadR(pUF			,TamSx3('DA1_ESTADO')[1])
Local cAnoModelo , cAnoFabric

Default cValida:=GetMV("KD_VLR_TAB",.F.,'1')//1=Valida somente Ano Modelo;2=Valida Ano Modelo e Ano Fabricação;3=Não valida Ano Modelo e Ano Fabricação

Default pAnoModelo := ""
Default pAnoFabric := ""

	cAnoModelo := PadR(pAnoModelo ,TamSx3('DA1_XANOMD')[1]," ") 
	cAnoFabric := PadR(pAnoFabric ,TamSx3('DA1_XANOFB')[1]," ")

	DA1->(DbOrderNickName("DA1EST"))
	if (cValida == "2")
		if   DA1->(dbSeek(pFilial + cTabela + cProduto + cUF + cAnoModelo + pAnoFabric )) .And. DA1->DA1_PRCVEN > 0
			nValor := DA1->DA1_PRCVEN
		endif
	elseif cValida == "1"
		if   DA1->(dbSeek(pFilial + cTabela + cProduto + cUF + cAnoModelo )) .And. DA1->DA1_PRCVEN > 0
			nValor := DA1->DA1_PRCVEN
		endif 	
	elseif cValida == "3"
		if   DA1->(dbSeek(pFilial + cTabela + cProduto + cUF  )) .And. DA1->DA1_PRCVEN > 0
			nValor := DA1->DA1_PRCVEN
		endif
	Endif 

	// if FwCodEmp() =="02" .and. DA1->(dbSeek(pFilial + cTabela + cProduto + cUF + pAnoModelo )) .And. DA1->DA1_PRCVEN > 0
	// 	nValor := DA1->DA1_PRCVEN
	// elseif FwCodEmp() =="01" .and. DA1->(dbSeek(pFilial + cTabela + cProduto + cUF + pAnoModelo + pAnoFabric )) .And. DA1->DA1_PRCVEN > 0
	// 	nValor := DA1->DA1_PRCVEN
	// Endif

Return nValor

/*/ Rotina para uso no gatilho do campo C6_XDFABR para retorna o preço da moto conforme o vin e tabela de preço ano modelo e ano fabricação/*/
User Function GatPrcMoto(pTabela,pProduto,pCliente,pLoja,cCodVin)
Local nValor 	:= 0
Local cAnoModelo:=u_AnoModVin(cCodVin)
Local dDataFab	:=u_DataFabVin(cCodVin)
Local cAnoFabric:=u_AnoFabVin(dDataFab)
Local cUF		:=Posicione("SA1",1,xFilial("SA1")+pCliente+pLoja,'A1_EST')
nValor:=PrecoMoto(xFilial("DA1"),pTabela,pProduto,cUF,cAnoModelo,cAnoFabric)
Return nValor
