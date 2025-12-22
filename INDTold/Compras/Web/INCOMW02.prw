#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F04FORM5  º Autor ³ ENER FREDES        º Data ³  18/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Follow Up da Solicitação de Compras                        º±±
±±º          ³                                                            º±±
#############################################################################
/*/
User Function INCOMW02(cFil,cNum)
	Local cQry, cDescFil, cJustifica, cDetalhe, cComprador
	Local cHTML   := ""
	Local aAnexos := {}
	Local aItens  := {}
	Local cServerHttp := Getmv("MV_SERHTTP")
	Local y
	Local x  
	
	cNum := StrZero(Val(cNum),TamSX3("C1_NUM")[1])
	
	cQry := " SELECT CTT_DESC01, CT1_DESC01, B1_TE, Y1_NOME, SC1.*"
	cQry += " FROM "+RetSQLName("SC1")+" SC1"
	cQry += " INNER JOIN "+RetSQLName("CTT")+" CTT ON CTT.D_E_L_E_T_ = ' ' AND C1_CC = CTT_CUSTO"
	cQry += " INNER JOIN "+RetSQLName("CT1")+" CT1 ON CT1.D_E_L_E_T_ = ' ' AND C1_CONTA = CT1_CONTA"
	cQry += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON SB1.D_E_L_E_T_ = ' ' AND C1_PRODUTO = B1_COD"
	cQry += " LEFT OUTER JOIN "+RetSQLName("SY1")+" SY1 ON SY1.D_E_L_E_T_ = ' ' AND C1_CODCOMP = Y1_COD"
	cQry += " WHERE SC1.D_E_L_E_T_ = ' '"
	cQry += " AND C1_FILIAL = '"+cFil+"'"
	cQry += " AND C1_NUM = '"+cNum+"'"
	cQry += " ORDER BY C1_FILIAL, C1_NUM, C1_ITEM"
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,ChangeQuery(cQry)),"TMPSC1",.F.,.T.)
	
	If Eof() .And. Bof()   // Se não encontrou registros validos
		dbCloseArea()
		Return "Solicitação não Localizada"
	EndIf

	TcSetField("TMPSC1","C1_EMISSAO","D")
	
	dbGoTop()
	
	SY1->(DbSetOrder(1))
	If SY1->(DbSeek(xFilial("SY1")+TMPSC1->C1_CODCOMP))
		cComprador := SY1->Y1_NOME
	Else
		cComprador := TMPSC1->Y1_NOME
	EndIf
	
	If cFil = "01"
		cDescFil := "Manaus"
	ElseIf cFil = "02"
		cDescFil := "Brasilia"
	ElseIf cFil = "03"
		cDescFil := "Recife"
	Else
		cDescFil := "São Paulo"
	EndIf
	
	SZ6->(DbSetOrder(1))
	If SZ6->(DbSeek(cFil+"2"+cNum))
		cJustifica := SZ6->Z6_JUSTIFI
	Else
		cJustifica := ""
	EndIf
	
	SZF->(DbSetOrder(1))
	SZF->(DbSeek(cFil+"1"+cNum))
	While !SZF->(Eof()) .And. SZF->(ZF_FILIAL+ZF_TIPO+ZF_NUM) = cFil+"1"+cNum
		AAdd(aAnexos,{'<a href="http://'+cServerHttp+'/'+SZF->ZF_ARQSRV+'" title="ARQUIVO">'+SZF->ZF_ARQSRV+'</a>' })
		SZF->(DbSkip())
	Enddo
	
	cHTML += '<p><div align="center"><font face="Arial" size=6 color=#0000FF>  <strong>Solicitação de Compra</strong></font></div></p>'//Requisicao de Compra
	
	cHTML += ' <table border="0" width="80%" id="table2">
	cHTML += MontaTab("Solicitacao de Compra:",TMPSC1->C1_NUM,"","")
	cHTML += MontaTab("Comprador:",IIf(Empty(cComprador),"Comprador não alocado",cComprador),"","")
	cHTML += MontaTab("Filial:",cDescFil,"Dt.Emissão",Dtoc(TMPSC1->C1_EMISSAO))
	cHTML += MontaTab("Requisitante:",TMPSC1->C1_SOLICIT,"","")
	
	If Empty(TMPSC1->C1_CCAPRV)
		cHTML += MontaTab("C.Custo Aprovador:",TMPSC1->C1_CC+" - "+Posicione("CTT",1,xFilial("CTT")+TMPSC1->C1_CC,"CTT_DESC01"),"","")
	Else
		cHTML += MontaTab("C.Custo Aprovador:",TMPSC1->C1_CCAPRV+" - "+Posicione("CTT",1,xFilial("CTT")+TMPSC1->C1_CCAPRV,"CTT_DESC01"),"","")
	EndIf
	cHTML += '</table>'
	
	cHTML += '<DIV id=table>
	cHTML += ' <table border="0" width="100%" id="table2">
	cHTML += '<tr>'
	cHTML += ' 			<th width="10%">Cl.MCT</th>
	cHTML += ' 			<th width="20%">Produto</th>
	cHTML += ' 			<th width="5%">TES</th>
	cHTML += ' 			<th width="10%">Conta Ctb</th>
	cHTML += ' 			<th width="35%">Detalhe</th>
	cHTML += ' 			<th width="10%">Quantidade</th>
	cHTML += ' 			<th width="10%" >C.Custo</th>
	cHTML += ' 			<th width="10%">Observação</th>
	cHTML += '</tr>'
	
	While !TMPSC1->(Eof())
		cDetalhe := Posicione("SC1",1,TMPSC1->(C1_FILIAL+C1_NUM+C1_ITEM),"C1_DETALH")
		AAdd( aItens , TMPSC1->({ C1_CLVL, C1_DESCRI, B1_TE, C1_CONTA, cDetalhe, Transform(C1_QUANT,"@E 999,999,999.99"), C1_CC, C1_OBS}) )
		TMPSC1->(DbSkip())
	Enddo
	
	for x:= 1 to Len(aItens)
		cHTML += '<tr>'
		for y := 1 to Len(aItens[x])
			cHTML += '<td align="right">'+aItens[x][y]+'</td>'
		Next
		cHTML += '</tr>'
	Next
	cHTML += '</table>'
	
	If Len(aAnexos) > 0
		cHTML += '<font color="#0000FF" >Lista de Anexos</font>'//Itens Pedido
		cHTML += '<table border="0" width="50%" id="table2">
		cHTML += '<tr>'
		cHTML += ' 			<th>Anexo</th>
		cHTML += '</tr>'
		for x:= 1 to Len(aAnexos)
			cHTML += '<tr>'
			cHTML += '<td>'+aAnexos[x][1]+'</td>'
			cHTML += '</tr>'
		Next
		cHTML += '</table>'
	EndIf
	
	cHTML += '<table border="0" width="50%" id="table2">
	cHTML += '<tr>'
	cHTML += '	<th>Justificativa</th>
	cHTML += '</tr>'
	cHTML += '<tr>'
	cHTML += '<td>'+cJustifica+'</td>'
	cHTML += '</tr>'
	cHTML += '</table>'
	cHTML += '</DIV>
	
	TMPSC1->(DbCloseArea())
	
Return cHTML

Static Function MontaTab(cCab1,cDesc1,cCab2,cDesc2)
	Local cHTML := ""
	cHTML += '<tr>'
	cHTML += ' 			<td width="20%" ><font size="2" ><b>'+cCab1+'</b></font></td>
	cHTML += ' 			<td width="40%" align="Left"><font size="2" >'+cDesc1+'</font></td>
	cHTML += ' 			<td width="15%"><font size="2"><b>'+cCab2+'</b></font></td>
	cHTML += ' 			<td width="25%" align="Left"><font size="2">'+cDesc2+'</font></td>
	cHTML += '</tr>'
Return cHTML
