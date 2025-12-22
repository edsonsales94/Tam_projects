#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ M460MARK   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 28/08/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada de validação da geração da nota de saida     ¦¦¦
¦¦¦ Descriçäo ¦                                                               ¦¦¦
¦¦¦ Alteraçäo ¦                                                               ¦¦¦
¦¦¦-----------¦---------------------------------------------------------------¦¦¦
¦¦¦ Diego     ¦ Modificação para efetuar a impedir o faturamento quando há no ¦¦¦
¦¦¦ 28/05/20  ¦ pedido de Venda TES cujo o Campo F4_NROLIVRO sejam diferentes ¦¦¦
¦¦¦           ¦ entre Si!                                                     ¦¦¦
¦¦¦-----------¦---------------------------------------------------------------¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦¦           ¦                                                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function M460MARK()
	Local cQry, x
	Local cAlias    := Alias()
	Local cFiltro   := SC9->(dbFilter())    // Pega o filtro atual da tabela
	Local aStruct   := SC9->(dbStruct())    // Carrega os campos da tabela SC9
	Local lRet      := .T.
	Local cNroLivro :=""
	LocaL xAlias := ""	

	cQry := "SELECT SF4.F4_NRLIVRO,SC9.*"
	cQry += " FROM "+RetSQLName("SC9")+" SC9"
	cQry += " INNER JOIN "+RetSQLName("SC5")+" SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC9.C9_FILIAL = SC5.C5_FILIAL AND SC9.C9_PEDIDO = SC5.C5_NUM"
	cQry += " AND SC5.C5_TIPO = 'N'"
	cQry += " INNER JOIN "+RetSQLName("SC6")+" SC6 ON SC6.D_E_L_E_T_ = ' ' AND SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_PEDIDO = SC6.C6_NUM"
	cQry += " AND SC9.C9_ITEM = SC6.C6_ITEM AND SC9.C9_PRODUTO = SC6.C6_PRODUTO"
	cQry += " INNER JOIN "+RetSQLName("SF4")+" SF4 ON SF4.D_E_L_E_T_ = ' ' AND SF4.F4_CODIGO = SC6.C6_TES"
	cQry += " AND SF4.F4_ESTOQUE = 'S'"
	cQry += " WHERE SC9.D_E_L_E_T_ = ' '"
	cQry += " AND SC9.C9_FILIAL = '"+XFILIAL("SC9")+"'"
	cQry += " AND SC9.C9_PEDIDO <> '"+Space(TamSX3("C9_PEDIDO")[1])+"'"
	cQry += " AND SC9.C9_NFISCAL = '"+Space(TamSX3("C9_NFISCAL")[1])+"'"
	cQry += " AND SC9.C9_OK "+If( ParamIXB[2] , "<>" , "=" )+" '"+ParamIXB[1]+"'"
	cQry += " ORDER BY SC9.C9_PEDIDO, SC9.C9_ITEM, SC9.C9_PRODUTO"
	
	xAlias := MpSysOpenQuery(cQry)
	
	/*
	xAlias := GetNextALias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),xAlias,.T.,.T.)
	*/
	
	// Converte os campos não caracteres
	For x:=1 To Len(aStruct)
		If aStruct[x,2] <> "C"
			TCSetField(xAlias,aStruct[x,1],aStruct[x,2],aStruct[x,3],aStruct[x,4])
		Endif
	Next
	
	cNroLivro := (xAlias)->F4_NRLIVRO
	While !Eof() .And. lRet
		//If Empty(cFiltro) .Or. &(cFiltro)  // Considera o filtro da rotina
		// Posiciona no cadastro de almoxarifado x usuários
		If (xAlias)->C9_LOCAL=="14"
			MsgStop("Usuário ("+Trim(cUserName)+") não está liberado para faturar o almoxarifado "+(xAlias)->C9_LOCAL+" !",;
			"Pedido: "+C9_PEDIDO+" Item: "+C9_ITEM)
			lRet := .F.
		ElseIf (xAlias)->C9_LOCAL=="75"
			If Empty((xAlias)->C9_ORDSEP)
				MsgStop("Só é possível faturar neste armazém pedidos com ordem de separacao !",;
				"Pedido: "+C9_PEDIDO+" Item: "+C9_ITEM)
				lRet := .F.
			EndIf
		EndIf
		
		//Verifica se existem itens no Pedido de Venda configuração de Percentuais de Restituição diferentes.
		//Caso haja, isso impedirá o faturamento, pois foi determinado que a Nota só poderá sair com um unico Percentual.
		//Alteração - Williams Messa -  10/09/19 - Aplicado somente para Empresa 00
		
		If SuperGetMv("MV_XVLIVRO",.F.,.F.)
			If cNroLivro != (xAlias)->F4_NRLIVRO
				MsgStop("Existem TES de Percentuais de Retituição Diferentes, Faturamento Não Permitido, Corrija as TES !","Pedido: "+C9_PEDIDO+" Item: "+C9_ITEM)
				lRet := .F.
			EndIf			
		EndIf
		
		(xAlias)->(dbSkip())
	Enddo
	dbCloseArea()
	dbSelectArea(cAlias)

Return lRet
