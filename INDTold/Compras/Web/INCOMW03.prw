#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INCOMW03 º Autor ³ ENER FREDES        º Data ³  18/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Follow Up do Pedido de Compra                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INDT                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INCOMW03(cFil,cNum)
	Local cQry, cDescFil, cBusca, cFollowUp
	Local cAlias      := "SC7"
	Local cHTML       := ""
	Local cJustifica  := ""
	Local cJustExcl   := ""
	Local aAnexos     := {}
	Local aAprova     := {}
	Local aIdioma     := u_INCOMWID("P")
	Local cServerHttpI:= Getmv("MV_WFHTTPI")
	
	Private nTamDoc  := TamSX3("F1_DOC")[1]
	
	cNum := StrZero(Val(cNum),TamSX3("C7_NUM")[1])
	cQry := " SELECT ISNULL(CTT_DESC01,' ') AS CTT_DESC01, ISNULL(CT1_DESC01,' ') AS CT1_DESC01, B1_TE,ISNULL(C1_CCAPRV,'') AS C1_CCAPRV, SC7.*"
	cQry += " FROM "+RetSQLName("SC7")+" SC7"
	cQry += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ' '"
	cQry += " LEFT OUTER JOIN "+RetSQLName("CTT")+" CTT ON C7_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ' '"
	cQry += " LEFT OUTER JOIN "+RetSQLName("CT1")+" CT1 ON C7_CONTA = CT1_CONTA AND CT1.D_E_L_E_T_ = ' '"
	cQry += " LEFT OUTER JOIN "+RetSQLName("SC1")+" SC1 ON C7_FILIAL = C1_FILIAL AND C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND SC1.D_E_L_E_T_ = ' '"
	cQry += " WHERE SC7.D_E_L_E_T_ = ' ' AND C7_FILIAL = '"+cFil+"' AND C7_NUM = '"+cNum+"'"
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),"TMPSC7",.F.,.T.)
	
	If TMPSC7->(Eof())
		dbCloseArea()
		DbSelectArea(cAlias)
		Return "Pedido de Compra não localizado !"
	Endif
	
	TcSetField("TMPSC7","C7_EMISSAO","D")
	
	If cFil = "01"
		cDescFil := "Manaus"
	ElseIf cFil = "02"
		cDescFil := "Brasilia"
	ElseIf cFil = "03"
		cDescFil := "Recife"
	Else
		cDescFil := "São Paulo"
	EndIf
	
	// Pesquisa a justificativa
	SZ6->(DbSetOrder(1))
	If SZ6->(DbSeek(TMPSC7->(C7_FILIAL+"1"+PADR(C7_NUM,nTamDoc))))
		cJustifica := SZ6->Z6_JUSTIFI
	EndIf
	
	// Pesquisa a justificativa do Fornecedor Exclusivo
	SZ6->(DbSetOrder(1))
	If SZ6->(DbSeek(TMPSC7->(C7_FILIAL+"E"+PADR(C7_NUM,nTamDoc))))
		cJustExcl := SZ6->Z6_JUSTIFI
	EndIf
	
	// Posiciona no Follow up
	SZD->(dbSetOrder(1))
	SZD->(dbSeek(TMPSC7->(C7_FILIAL+C7_NUM)))
	
	// Posiciona no Cadastro de Comprador
	SY1->(dbSetOrder(1))
	SY1->(dbSeek(XFILIAL("SY1")+SZD->ZD_COMP))
	
	cBusca := TMPSC7->(C7_FILIAL+"2"+PADR(C7_NUM,nTamDoc))
	
	// Pesquisa os anexos para o pedido de compra
	SZF->(DbSetOrder(1))
	SZF->(DbSeek(cBusca,.T.))
	While !SZF->(Eof()) .And. SZF->ZF_FILIAL+SZF->ZF_TIPO+SZF->ZF_NUM == cBusca
		AAdd( aAnexos , '<a href="'+Alltrim(cServerHttpI)+'/web/followup/'+SZF->ZF_ARQSRV+'"  target=”_blank” title="ARQUIVO">'+SZF->ZF_ARQSRV+'</a>')
		SZF->(DbSkip())
	Enddo
	
	// Pesquisa os aprovadores
	
	cQry := " SELECT * FROM " + RetSqlName("SCR")
	cQry += " WHERE D_E_L_E_T_ = ''
	cQry += " AND CR_FILIAL = '"+cFil+"'
	cQry += " AND CR_NUM = '"+cNum+"'
	cQry += " ORDER BY R_E_C_N_O_
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"SCRTMP",.T.,.T.)
	TcSetField("SCRTMP","CR_DATALIB","D")
	
	SCRTMP->(DbGotop())
	While !SCRTMP->(Eof())
		AAdd( aAprova , { Dtoc(SCRTMP->CR_DATALIB), Posicione("SAK",2,XFILIAL("SAK")+SCRTMP->CR_USER,"AK_NOME")})
		SCRTMP->(DbSkip())
	End
	SCRTMP->(DbCloseArea())
	DbSelectArea(cAlias)
	
	cHTML += '<p><div align="center"><font face="Arial" size=6 color=#0000FF>  <strong>Pedido de Compra</strong></font></div></p>'
	
	cHTML += ' <table border="0" width="80%" id="table0">'
	cHTML += MontaTab(1,{"Pedido de Compra:",TMPSC7->C7_NUM,"",""})
	cHTML += MontaTab(1,{"Comprador:",IIf(Empty(SY1->Y1_NOME),"Comprador não alocado",SY1->Y1_NOME),"",""})
	cHTML += MontaTab(1,{"Filial:",cDescFil,"Dt.Emissão",Dtoc(TMPSC7->C7_EMISSAO)})
	cHTML += MontaTab(1,{"Solicitação",TMPSC7->C7_NUMSC,"Requisitante",Posicione('SC1',1,cFil+TMPSC7->C7_NUMSC,"C1_SOLICIT")})
	cHTML += MontaTab(1,{"Fornecedor:",TMPSC7->C7_FORNECE + '/' + TMPSC7->C7_LOJA + " - " + Posicione("SA2",1,cFil+TMPSC7->(C7_FORNECE + C7_LOJA),"A2_NOME"),"",""})
	If Empty(TMPSC7->C1_CCAPRV)
		cHTML += MontaTab(1,{"C.Custo Aprovador",TMPSC7->C7_CC+" - "+Posicione("CTT",1,xFilial("CTT")+TMPSC7->C7_CC,"CTT_DESC01"),"Moeda",SuperGetMv("MV_MOEDA"+AllTrim(Str(TMPSC7->C7_MOEDA,2)))})
	Else
		cHTML += MontaTab(1,{"C.Custo Aprovador",TMPSC7->C1_CCAPRV+" - "+Posicione("CTT",1,xFilial("CTT")+TMPSC7->C1_CCAPRV,"CTT_DESC01"),"Moeda",SuperGetMv("MV_MOEDA"+AllTrim(Str(TMPSC7->C7_MOEDA,2)))})
	EndIf
	cHTML += '</table>'
	
	cHTML += '<DIV id=table>'
	cHTML += ' <table border="0" width="100%" id="table1">'
	cHTML += '<tr>'
	cHTML += ' 			<th width="10%">Cl.MCT</th>'
	cHTML += ' 			<th width="20%">Produto</th>'
	cHTML += ' 			<th width="5%">TES</th>'
	cHTML += ' 			<th width="10%">Conta Ctb</th>'
	cHTML += ' 			<th width="35%">Detalhe</th>'
	cHTML += ' 			<th width="10%">Quantidade</th>'
	cHTML += ' 			<th width="10%">Valor Unitário</th>'
	cHTML += ' 			<th width="10%">Valor Total</th>'
	cHTML += ' 			<th width="10%" >C.Custo</th>'
	cHTML += ' 			<th width="10%">Observação</th>'
	cHTML += '</tr>'
	
	cFollowUp := FollowUp(cDescFil,aIdioma)  // Busca os detalhes do Follow-Up
	
	While !TMPSC7->(Eof())
		SC1->(dbSetOrder(1))
		SC1->(dbSeek(TMPSC7->C7_FILIAL+TMPSC7->C7_NUMSC+TMPSC7->C7_ITEMSC))
		
		cHTML += '<tr>'
		cHTML += '<td><p align="left">'+TMPSC7->C7_CLVL+'</p></td>'
		cHTML += '<td><p align="left">'+TMPSC7->C7_DESCRI+'</p></td>'
		cHTML += '<td><p align="left">'+TMPSC7->B1_TE+'</p></td>'
		cHTML += '<td><p align="left">'+TMPSC7->C7_CONTA+'</p></td>'
		cHTML += '<td><p align="left">'+SC1->C1_DETALH+'</p></td>'
		cHTML += '<td><p align="right">'+Transform(TMPSC7->C7_QUANT,"@E 999,999,999.99")+'</p></td>'
		cHTML += '<td><p align="right">'+Transform(TMPSC7->C7_PRECO,"@E 999,999,999.99")+'</p></td>'
		cHTML += '<td><p align="right">'+Transform(TMPSC7->C7_TOTAL,"@E 999,999,999.99")+'</p></td>'
		cHTML += '<td><p align="left">'+TMPSC7->C7_CC+'</p></td>'
		cHTML += '<td><p align="left">'+TMPSC7->C7_OBS+'</p></td>'
		cHTML += '</tr>'
		
		TMPSC7->(DbSkip())
	Enddo
	
	cHTML += '</table>'
	
	If Len(aAnexos) > 0
		cHTML += ' <table border="0" width="50%" id="table2">'
		cHTML += '<tr>'
		cHTML += ' 			<th>Anexo</th>'
		cHTML += '</tr>'
		aEval( aAnexos , {|x| (cHTML += '<tr><td>'+x+'</td></tr>') })
		cHTML += '</table>'
	EndIf
	
	cHTML += ' <table border="0" width="50%" id="table3">'
	cHTML += '<tr>'
	cHTML += '	<th>Justificativa</th>'
	cHTML += '</tr>'
	cHTML += '<tr><td>'+cJustifica+'</td></tr>'
	cHTML += '</table>'
	
	If !Empty(cJustExcl)
		cHTML += '<table border="0" width="50%" id="table4">'
		cHTML += '<tr>'
		cHTML += '	<th>Justificativa Fornecedor Exclusivo</th>'
		cHTML += '</tr>'
		cHTML += '<tr><td>'+cJustExcl+'</td></tr>'
		cHTML += '</table>'
	EndIf
	
	// Pesquisa os aprovadores
	cHTML += '	<p><font color="#0000FF" >'+aIdioma[28]+'</font>'
	cHTML += ' <table border="0" width="80%" id="table5">'
	cHTML += MontaTab(3,{aIdioma[29],;
	aIdioma[30],;
	aIdioma[31],;
	aIdioma[32],;
	aIdioma[35],;
	aIdioma[34]},.T.)
	
	nIndex  := SCR->(IndexOrd())
	nRecno  := SCR->(Recno())
	cCR_NUM := PADR(cNum,TamSX3("CR_NUM")[1])
	
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(cFil+"PC"+cCR_NUM,.T.))
	While !SCR->(Eof()) .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == cFil+"PC"+cCR_NUM
		
		PswOrder(1)
		cText1 := UserName(SCR->CR_USER)
		cText2 := POSICIONE("SAK",1,"  "+SCR->CR_APROV,"AK_NOME")
		cHTML  += MontaTab(3,{	SCR->CR_NIVEL,;
								If( Empty(cText1) , "<font color=#e8eae8>n</font>", cText1),;
								nome(SCR->CR_STATUS),;
								cText2,;
								ToStr(SCR->CR_DATALIB),;
								If( Empty(SCR->CR_OBS) , "<font color=#e8eae8>n</font>", SCR->CR_OBS)})
		
		SCR->(DbSkip())
	Enddo               
	SCR->(dbSetOrder(nIndex))
	SCR->(dbGoTo(nRecno))
	
	cHTML += '</table></p>'
	
	cHTML += '</DIV>'
	
	cHTML += ' <br>'
	cHTML += '	<hr>'     // Linha divisoria
	cHTML += cFollowUp
	
	DbSelectArea("TMPSC7")
	DbCloseArea()
	
	DbSelectArea(cAlias)
	
Return cHTML

Static Function MontaTab(nTipo,vTexto,lCab)
	Local cHTML := ""
	
	lCab := If( lCab == Nil , .F., lCab)
	
	If nTipo == 1  // Itens do Pedido de Compra
		cHTML += '<tr>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="20%" ><font size="2"><b>'+vTexto[1]+'</b></font></'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="40%" align="Left"><font size="2" >'+vTexto[2]+'</font></'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="15%"><font size="2"><b>'+vTexto[3]+'</b></font></'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="25%" align="Left"><font size="2">'+vTexto[4]+'</font></'+If(lCab,'th','td')+'>'
		cHTML += '</tr>'
	ElseIf nTipo == 2     // Itens do Follow-up
		cHTML += '<tr>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="15%" >'+vTexto[1]+'</'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="20%" >'+vTexto[2]+'</'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="75%" >'+vTexto[3]+'</'+If(lCab,'th','td')+'>'
		cHTML += '</tr>'
	Else                  // Aprovadores
		cHTML += '<tr>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="08%" >'+vTexto[1]+'</'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="15%" >'+vTexto[2]+'</'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="20%" >'+vTexto[3]+'</'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="30%" >'+vTexto[4]+'</'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="20%" >'+vTexto[5]+'</'+If(lCab,'th','td')+'>'
		cHTML += ' 			<'+If(lCab,'th','td')+' width="30%" >'+vTexto[6]+'</'+If(lCab,'th','td')+'>'
		cHTML += '</tr>'
	Endif
	
Return cHTML

Static Function FollowUp(cDescFil,aIdioma)
	Local cQry, cText1, cText2, cDesc1
	Local aItens  := {}
	Local cAlias  := Alias()
	Local cBusca  := TMPSC7->C7_FILIAL+If(TMPSC7->C7_TIPO==1,"PC","AE")+TMPSC7->C7_NUM
	Local cHTML   := ""
	
	cHTML += '<title>'+aIdioma[1]+'</title>'
	cHTML += '</head>'
	cHTML += '<body>'
	cHTML += u_INCOMWST(.F.)
	cHTML += '<meta http-equiv="Content-Language" content="en-us">'
	cHTML += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'
	cHTML += '<form method="POST" action="">'
	
	cHTML += '<DIV id=typein>'
	cHTML += '	<p><font color="#0000FF" >'+aIdioma[42]+'</font>'
	
	If TMPSC7->C7_RESIDUO = 'S'
		cHTML += ' <h4><div align="center"><font color="#0000FF" face="Verdana"><strong>Status: Residuo</strong></font></div></h4>'
	EndIf
	
	//Inicio Pedido
	cQry := " Select * From "+RetSqlName("SZD") + " As SZD "
	cQry += " Where D_E_L_E_T_ <> '*' "
	cQry += " And SZD.ZD_PEDIDO = '" + TMPSC7->C7_NUM + "'"
	cQry += " And SZD.ZD_FILIAL = '" + TMPSC7->C7_FILIAL + "'"
	cQry += " Order By ZD_ITEM"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TABTMP", .T., .F. )
	
	TcSetField("TabTmp","ZD_DATA"   ,"D")
	TcSetField("TabTmp","ZD_DATREC" ,"D")
	TcSetField("TabTmp","ZD_DATEMB" ,"D")
	TcSetField("TabTmp","ZD_DATENTF","D")
	TcSetField("TabTmp","ZD_DATCHE" ,"D")
	TcSetField("TabTmp","ZD_DATAEF" ,"D")
	TcSetField("TabTmp","ZD_DATAEC" ,"D")
	TcSetField("TabTmp","ZD_DATENV" ,"D")
	
	If TABTMP->(Eof())
		cHTML += ' <p align = "center"> <font face=Tahoma Size=20pt><b>'+aIdioma[24]+'</b></font>'
	Else
		cHTML += ' <br>'
		cHTML += ' <br>'
		
		Set Date Format "dd/mm/yyyy"
		cHTML += ' <table border="0" width="80%" id="table2">'
		cHTML += MontaTab(1,{aIdioma[9],AllTrim(toStr(posicione("SC7",1, TMPSC7->(C7_FILIAL+C7_NUM),"C7_DATPRF"))),;
		aIdioma[10],AllTrim(TABTMP->ZD_CONHEC)})
		cHTML += MontaTab(1,{aIdioma[27],AllTrim(Posicione("SY1",1,xFilial("SY1")+TABTMP->ZD_COMP,"Y1_NOME")),"",""})
		cHTML += MontaTab(1,{aIdioma[25],AllTrim(toStr(TABTMP->ZD_DATAEF)),aIdioma[11],AllTrim(toStr(TABTMP->ZD_DATEMB))})
		cHTML += MontaTab(1,{aIdioma[12],AllTrim(toStr(TABTMP->ZD_DATCHE)),aIdioma[13],AllTrim(toStr(TABTMP->ZD_DATREC))})
		cHTML += MontaTab(1,{aIdioma[26],AllTrim(toStr(TABTMP->ZD_DATAEC)),aIdioma[14],AllTrim(TABTMP->ZD_TEMDIA)})
		cHTML += MontaTab(1,{aIdioma[15],AllTrim(TABTMP->ZD_INVOICE),aIdioma[16],AllTrim(TABTMP->ZD_DI)})
		cHTML += MontaTab(1,{aIdioma[17],AllTrim(TABTMP->ZD_STATUS),aIdioma[18],AllTrim(TABTMP->ZD_STAENT)})
		cHTML += MontaTab(1,{aIdioma[33],AllTrim(toStr(TABTMP->ZD_DATENV)),"",""})
		cHTML += '</table>'
		
		While !TABTMP->(EOF())
			cDesc1 := Posicione("SZD",1,TMPSC7->(C7_FILIAL+C7_NUM)+TABTMP->ZD_ITEM,"ZD_DESC")
			If !Empty(cDesc1)
				AAdd( aItens , { TABTMP->ZD_ITEM, ToStr(TABTMP->ZD_DATA), If( Empty(cDesc1) , "<font color=#e8eae8>n</font>", cDesc1)} )
			Endif
			TABTMP->(DbSkip())
		Enddo
		
		If !Empty(aItens)
			cHTML += '<DIV id=table>'
			
			cHTML += '	<p><font color="#0000FF" >'+aIdioma[43]+'</font>'
			cHTML += ' <table border="0" width="80%" id="table2">'
			
			cHTML += MontaTab(2,{"<b>&nbsp"+aIdioma[19]+"</b>","<b>&nbsp"+aIdioma[20]+"</b>","<b>&nbsp"+aIdioma[21]+"</b>"},.T.)
			
			aEval( aItens , {|x| cHTML += MontaTab(2,x) })
			
			cHTML += '</DIV>'
		Endif
	EndIf
	cHTML += '    </table>'
	
	TABTMP->(dbCloseArea())
	dbSelectArea(cAlias)
	
Return cHTML

Static Function ToStr(dDat)
Return If( Empty(dDat) , "", PADR(Dtoc(dDat),6)+Str(Year(dDat),4))

Static Function nome(cPa)
	If cPa = "01" .Or. cPa="1"
		Return "Nivel Bloqueado"
	Endif
	If cPa = "02" .Or. cPa="2"
		Return  "Aguardando Liberação"
	Endif
	If cPa = "03" .Or. cPa="3"
		Return "Pedido Aprovado"
	Endif
	If cPa = "04" .Or. cPa="4"
		Return "Pedido Bloqueado"
	Endif
	If cPa = "05" .Or. cPa="5"
		Return "Nivel Liberado"
	Endif
Return

Static Function UserName(cCodUsr)
	Local aUser, cUserAnt := " "
	PswOrder(1)               // (1) Codigo , (2) Nome
	If PswSeek(Alltrim(cCodUsr)) // Pesquisa usuário
		aUser := PswRet(1)        // Retorna Matriz com detalhes, acessos do Usuário
		cUserAnt := aUser[1][2]   // Retorna codigo do usuário [1] ou o Nome [2]
	Endif
Return cUserAnt
