#INCLUDE "rwmake.ch"

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto Entrada executado no Final da Nota Fiscal de Entrada.
OBJETIVO 1: Chamada da Função que forma o Preço de Venda;
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

User Function GQREENTR()
	
	If SF1->F1_FORMUL = 'S'
		u_AAFATE03("E")
		
		SF1->(RecLock("SF1",.F.))
		SF1->F1_ESPECIE := "SPED"
		SF1->(MsUnLock())
		
		SF3->(dbSetOrder(4))
		If SF3->(DbSeek(xFilial("SF3") + SF1->F1_SERIE + SF1->F1_DOC + SF1->F1_FORNECE + SF1->F1_LOJA ))
			RecLock("SF3",.F.)
			SF3->F3_ESPECIE := "SPED"
			MsUnLock()
		EndIF
		
		SFT->(dbSetOrder(1))
		If SFT->(DbSeek(xFilial("SFT") + "E" + SF1->F1_SERIE + SF1->F1_DOC + SF1->F1_FORNECE + SF1->F1_LOJA ))
			_cChave := SFT->(FT_FILIAL + FT_TIPOMOV + FT_SERIE + FT_NFISCAL + FT_CLIEFOR + FT_LOJA)
			WHile !SFT->(EOF()) .And. SFT->(FT_FILIAL + FT_TIPOMOV + FT_SERIE + FT_NFISCAL + FT_CLIEFOR + FT_LOJA) == _cChave
				RecLock("SFT",.F.)
				SFT->FT_ESPECIE := "SPED"
				MsUnLock()
				SFT->(dbSkip())
			Enddo
		Endif
	EndIf
	
	If SF1->F1_TIPO == "D"
		RecComiss(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE)
		u_AAFINE03()
	ElseIf SF1->F1_TIPO == "N"
		//Grava Saldo em Transito (Utilizado no controle de Puxadas)
		fGrvSalTran()
	EndIf
	
Return

//Grava Saldo em Transito (Utilizado no controle de Puxadas)
Static Function fGrvSalTran()
	Local cBusca := SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
	
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(cBusca,.T.))
	While !SD1->(Eof()) .And. cBusca == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
	
		If SD1->(FieldPos("D1_XPACLIS")) > 0
			If !Empty(SD1->D1_XPACLIS)  // Caso o campo tenha conteúdo válido
				RecLock("SZW",.T.)
				SZW->ZW_FILIAL  := XFILIAL("SZW")
				SZW->ZW_PACLIS  := SD1->D1_XPACLIS
				SZW->ZW_DOC     := SD1->D1_DOC
				SZW->ZW_SERIE   := SD1->D1_SERIE
				SZW->ZW_FORNECE := SD1->D1_FORNECE
				SZW->ZW_LOJA    := SD1->D1_LOJA
				SZW->ZW_ITEM    := SD1->D1_ITEM
				SZW->ZW_CODPRO  := SD1->D1_COD
				SZW->ZW_NUMDI   := SD1->D1_XDI
				SZW->ZW_QTDORI  := SD1->D1_QUANT
				SZW->ZW_SALDO   := SD1->D1_QUANT
				MsUnLock()
			Endif
		EndIf
		SD1->(dbSkip())
	Enddo
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ RecComiss  ¦ Autor ¦ Arlindo Neto         ¦ Data ¦ 25/09/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Função para ajuste de comissão                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

Static function RecComiss(cNota,cSerie,cCliente)
	Local cQry, dDataEmi
	Local cAlias    := Alias()
	Local cFilSF2   := xFilial("SF2")
	Local nQtdVend  := 0
	Local cVendedor := ""
	Local nComiss   := 0
	Local cFilSA3   := xFilial("SA3")
	
	cQry := "SELECT SD1.D1_NFORI, SD1.D1_SERIORI, SD1.D1_SERIE, SD1.D1_DOC, SD1.D1_EMISSAO, SF1.F1_FORNECE, SF1.F1_LOJA,"
	cQry += " SUM(SD1.D1_TOTAL - SD1.D1_VALDESC) AS TOTALVEND"
	cQry += " FROM "+RetSQLName("SD1")+" SD1"
	cQry += " INNER JOIN "+RetSQLName("SF1")+" SF1 ON SF1.D_E_L_E_T_ = ' '"
	cQry += " AND SF1.F1_FILIAL = SD1.D1_FILIAL"
	cQry += " AND SF1.F1_DOC = SD1.D1_DOC"
	cQry += " AND SF1.F1_SERIE = SD1.D1_SERIE"
	cQry += " AND SF1.F1_FORNECE = SD1.D1_FORNECE"
	cQry += " AND SF1.F1_LOJA = SD1.D1_LOJA"
	cQry += " WHERE SD1.D_E_L_E_T_ = ' '"
	cQry += " AND SD1.D1_NFORI <> ' '"
	cQry += " AND SD1.D1_DOC = '"+cNota+"'"
	cQry += " AND SD1.D1_SERIE = '"+cSerie+"'"
	cQry += " GROUP BY SD1.D1_NFORI, SD1.D1_SERIORI, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_EMISSAO, SF1.F1_FORNECE, SF1.F1_LOJA"
	cQry += " ORDER BY SD1.D1_NFORI, SD1.D1_SERIORI, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_EMISSAO, SF1.F1_FORNECE, SF1.F1_LOJA"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TKT", .T., .F. )
	tcSetField("TKT","D1_EMISSAO","D",8,0)
	While !TKT->(Eof())
		
		cVendedor := Posicione("SF2",1,cFilSF2 + TKT->D1_NFORI + TKT->D1_SERIORI,"F2_VEND1" )
		nQtdVend  := -(TKT->TOTALVEND)
		dDataEmi  := TKT->D1_EMISSAO
		nComiss   := Posicione("SD2",1,cFilSF2 + TKT->D1_NFORI + TKT->D1_SERIORI,"D2_COMIS1" )
		
		If Empty(nComiss)
			nComiss := Posicione("SA3",1,cFilSA3 + cVendedor ,"A3_COMIS" )
		EndIf
		
		RecLock("SE3",.T.)
		SE3->E3_VEND    := cVendedor
		SE3->E3_NUM     := TKT->D1_DOC
		SE3->E3_EMISSAO := TKT->D1_EMISSAO
		SE3->E3_SERIE   := TKT->D1_SERIE
		SE3->E3_CODCLI  := TKT->F1_FORNECE
		SE3->E3_LOJA    := TKT->F1_LOJA
		SE3->E3_BASE    := nQtdVend
		SE3->E3_PORC    := nComiss
		SE3->E3_COMIS   := ROUND((nQtdVend * nComiss)/100,2)
		SE3->E3_PREFIXO := TKT->D1_SERIE
		SE3->E3_TIPO    := "NCC"
		SE3->E3_BAIEMI  := "E"
		SE3->E3_ORIGEM  := "D"
		SE3->E3_VENCTO  := TKT->D1_EMISSAO
		SE3->E3_MOEDA   := "01"
		MsUnLock()
		
		TKT->(DbSkip())
	Enddo
	TKT->(dbCloseArea())
	dbSelectArea(cAlias)
	
Return

