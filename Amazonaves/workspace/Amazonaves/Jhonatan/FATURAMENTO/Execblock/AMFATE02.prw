#include 'protheus.ch'

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ AMFATE02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/06/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execcblock de validação dos campos do Orçamento               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AMFATE02()
	Local cSeek
	Local cVar := ReadVar()
	
	If cVar == "M->CJ_XNUMOS"
		cSeek := XFILIAL("SCP")+M->CJ_XNUMOS
		SCP->(dbOrderNickName("NUMOS"))
		If SCP->(dbSeek(cSeek,.T.))
			If FWAlertYesNo("Deseja importar os itens da Solicitação ao Armazém ?")
				ValidPerg("AMFATE02")
				If Pergunte("AMFATE02",.T.)
					SF4->(dbSetOrder(1))
					If SF4->(dbSeek(XFILIAL("SF4")+mv_par01))
						FWMsgRun(Nil, {|oSay| AdicionaItens(cSeek) }, "Solicitação ao Armazém", "Adicionando itens...")
					Else
						FWAlertError("TES informado não existe !")
					Endif
				Endif
			Endif
		Endif
	Endif

Return .T.

Static Function AdicionaItens(cSeek)
	Local cTES := mv_par01
	
	While !SCP->(Eof()) .And. SCP->CP_FILIAL+SCP->CP_XNUMOS == cSeek
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(XFILIAL("SB1")+SCP->CP_PRODUTO))
		
		u_AMSCKAddItem(SCP->CP_QUANT,cTES)
		
		SCP->(dbSkip())
	Enddo

Return

User Function AMSCKAddItem(nQtde,cTES /*,lAtuBmp*/)
	Local nX
	Local nPreco := MaTabPrVen(M->CJ_TABELA,SB1->B1_COD,nQtde,M->CJ_CLIENTE,M->CJ_LOJA,M->CJ_MOEDA,M->CJ_EMISSAO)
	Local nLinha := CriaLinha()
	
	// Inicializa as variáveis em memória
	For nX:=1 To TMP1->(FCount())
		M->&( FieldName(nX) ) := TMP1->( FieldGet(nX))
	Next
	
	n := nLinha
	
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA))
	
	M->CK_PRODUTO := SB1->B1_COD
	M->CK_QTDVEN  := nQtde
	
	If ValType(nPreco) == "N"
		M->CK_PRCVEN := nPreco
	Endif
	
	RecLock("TMP1",.F.)
	TMP1->CK_PRODUTO := M->CK_PRODUTO
	u_AMDispara("CK_PRODUTO",M->CK_PRODUTO,nLinha)
	
	TMP1->CK_QTDVEN := M->CK_QTDVEN
	u_AMDispara("CK_QTDVEN",M->CK_QTDVEN,nLinha)
	
	If ValType(nPreco) == "N"
		TMP1->CK_PRCVEN := M->CK_PRCVEN
		u_AMDispara("CK_PRCVEN",M->CK_PRCVEN,nLinha)
		
		M->CK_VALOR    := A410Arred(M->CK_QTDVEN * M->CK_PRCVEN,"CK_VALOR")
		TMP1->CK_VALOR := M->CK_VALOR
		u_AMDispara("CK_VALOR",M->CK_VALOR,nLinha)
	Endif
	
	TMP1->CK_TES := M->CK_TES := cTES
	u_AMDispara("CK_TES",M->CK_TES,nLinha)
	
	MsUnLock()
	
	//lAtuBmp := If( lAtuBmp == Nil , .T., lAtuBmp)
	//VerAcols(lAtuBmp)
	
	oGetDad:nCount := TMP1->(RecCount())
	
	TMP1->(dbGoTop())
	oGetDad:oBrowse:GoTop()
	oGetDad:oBrowse:Refresh()
	
Return 

Static Function CriaLinha()
	Local cItem, c, lNovo
	Local nReg := TMP1->(Recno())
	
	// Pesquisa uma posição que esteja deletada ou vazia
	While !TMP1->(Eof()) .And. !TMP1->CK_FLAG .And. !Empty(TMP1->CK_PRODUTO)
		TMP1->(dbSkip())
	Enddo
	
	If lNovo := TMP1->(Eof())
		TMP1->(dbGoBottom())
		cItem := Soma1(TMP1->CK_ITEM)
	Else
		cItem := TMP1->CK_ITEM
	Endif
	
	RecLock("TMP1",lNovo)
	For c:=1 To Len(aHeader)
		If !(SubStr(aHeader[c,2],3,7) $ "_ALI_WT,_REC_WT")
			FieldPut(c,CriaVar(aHeader[c,2],.T.))
		Endif
	Next
	TMP1->CK_ITEM := cItem
	TMP1->CK_FLAG := .F.
	MsUnLock()
	
Return nReg

Static Function ValidPerg(cPerg)
	u_AMPutSX1(cPerg,"01",PADR("TES",29)+"?","","","mv_ch1","C",TamSX3("CK_TES")[1],0,0,"G","","SF4","","","mv_par01")
Return

