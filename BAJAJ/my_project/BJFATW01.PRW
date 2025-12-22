#Include "Protheus.ch"
#Include "AP5Mail.ch"
#Include "Tbiconn.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ BJFATW01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 09/09/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Envia e-mail com os títulos a vencer e vencidos aos clientes  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function BJFATW01()
	//                                              Emp  Fil     Emp  Fil
	StartJob("u_FATW01Start",GetEnvServer(),.T.) //,"06","0601",{"06","0601"})
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATW01Start¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 09/09/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicia o serviço de atualização do JOB                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATW01Start(cCodEmp,cCodFil)
	
	Default cCodEmp := "01"
	Default cCodFil := "01"
	
	PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil MODULO "FIN" TABLES "SB1", "SB2", "SA1", "DA1"
	
	ConfiguraUsuario("000000")
	u_FATW01Proc()
	
	RESET ENVIRONMENT
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FATW01Proc ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 09/09/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa o envio de e-mail com as liberações efetuadas        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FATW01Proc(aMark)
	Local cUltimo
	Local aArea   := GetArea()
	Local cTempo  := PADR(Transform(DtoS(dDataBase),"@R 9999-99-99") +" "+ Time(),20)
	Local cFilAtu := Space(Len(SX6->X6_FIL))
	Local cMV_PAR := "MV_XULTPRC"
	Local aProc   := {}
	
	Default aMark := {.T.,.T.,.T.,.T.,.T.}
	
	Private cFilProc := GetMV("MV_XTECFIL",.F.,"03")   // Filiais a serem processadas
	
	If Len(cFilAnt) == Len(cFilProc)
		ConfigEmpresa(cFilProc)
	Endif
	
	// Preenche até a quantidade mínima de rotinas a processar
	While Len(aMark) < 5
		AAdd( aMark , .T. )
	Enddo
	
	AAdd( aProc , { aMark[1], {|a| ExpClientes(a)  }} )
	AAdd( aProc , { aMark[2], {|a| ExpProdutos(a)  }} )
	AAdd( aProc , { aMark[3], {|a| ExpEstoque(a)   }} )
	AAdd( aProc , { aMark[4], {|a| ExpPrecos(a)    }} )
	AAdd( aProc , { aMark[5], {|a| ExpStatusPed(a) }} )
	
	Set(_SET_DATEFORMAT, 'dd/mm/yyyy') // Data com QUATRO digitos para Ano
	
	// Cria o parâmetro caso não exista
	SX6->(dbSetOrder(1))
	If !SX6->(dbSeek(cFilAtu+cMV_PAR))
		RecLock("SX6",.T.)
		SX6->X6_FIL     := cFilAtu
		SX6->X6_VAR     := cMV_PAR
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Ultima geracao de arquivos XML p/ TECSINAPSE"
		SX6->X6_CONTEUD := DtoS(dDataBase) + " 00:00:00"
		SX6->X6_PROPRI  := "U"
		MsUnLock()
	Endif
	
	If Len(aMark) >= 6 .And. ValType(aMark[6]) == "C"
		cUltimo := PADR(aMark[6],20)
	Else
		cUltimo := PADR(GetMV(cMV_PAR),20)
	Endif
	
	// Processa a geração dos XML
	aEval( aProc , {|x| If( x[1] , Eval(x[2],cUltimo), ) } )
	
	PutMV(cMV_PAR,cTempo)
	
	RestArea(aArea)

Return

Static Function ExpClientes(cUltimo)
	Local aXML := {}
	Local cTmp := GetNextAlias()
	Local cFil := "%"+FormatIn( If( Empty(XFILIAL("SA1")) , XFILIAL("SA1"), cFilProc) , "," )+"%"
	
	BeginSql Alias cTmp
		
		SELECT SA1.R_E_C_N_O_ AS A1_RECNO
		FROM %Table:SA1% SA1
		WHERE SA1.%NotDel%
		AND SA1.A1_FILIAL IN %Exp:cFil%
		AND SA1.A1_MSBLQL <> '1'
		AND SA1.A1_XDEALER <> ' '
		AND CONVERT(VARCHAR(20),SA1.S_T_A_M_P_,120) > %Exp:cUltimo%
		ORDER BY 1
		
	EndSql
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		(cTmp)->(dbCloseArea())
		Return
	Endif
	
	AAdd( aXML , "<?xml version='1.0' encoding='ISO-8859-1' ?>" + CRLF )
	AAdd( aXML , "<Clientes>" + CRLF )
	
	While !(cTmp)->(Eof())
		
		SA1->(dbGoTo((cTmp)->A1_RECNO))   // Posiciona no registro
		
		AAdd( aXML , "	<Cliente>" + CRLF )
		AAdd( aXML , "		<DealerNumber>"+Trim(SA1->A1_XDEALER)+"</DealerNumber>" + CRLF )
		AAdd( aXML , "		<Codigo>"+Trim(SA1->A1_COD)+"</Codigo>" + CRLF )
		AAdd( aXML , "		<Loja>"+Trim(SA1->A1_LOJA)+"</Loja>" + CRLF )
		AAdd( aXML , "		<Nome>"+Trim(SA1->A1_NOME)+"</Nome>" + CRLF )
		AAdd( aXML , "		<NomeFantasia>"+Trim(SA1->A1_NREDUZ)+"</NomeFantasia>" + CRLF )
		AAdd( aXML , "		<TabelaDePreco>"+u_BJCodTab()+"</TabelaDePreco>" + CRLF )
		AAdd( aXML , "		<Endereco>"+Trim(SA1->A1_END)+"</Endereco>" + CRLF )
		AAdd( aXML , "		<Bairro>"+Trim(SA1->A1_BAIRRO)+"</Bairro>" + CRLF )
		AAdd( aXML , "		<Estado>"+Trim(SA1->A1_EST)+"</Estado>" + CRLF )
		AAdd( aXML , "		<Municipio>"+Trim(SA1->A1_MUN)+"</Municipio>" + CRLF )
		AAdd( aXML , "		<CNPJ>"+Trim(SA1->A1_CGC)+"</CNPJ>" + CRLF )
		AAdd( aXML , "	</Cliente>" + CRLF )
		
		(cTmp)->(dbSkip())
	Enddo
	(cTmp)->(dbCloseArea())
	
	AAdd( aXML , "</Clientes>" + CRLF )
	
	GravaXML(aXML,"clientes","clientes","MATA010",.T.)

Return

Static Function ExpProdutos(cUltimo)
	Local aXML := {}
	Local cTmp := GetNextAlias()
	Local cFil := "%"+FormatIn( If( Empty(XFILIAL("SB1")) , XFILIAL("SB1"), cFilProc) , "," )+"%"
	
	BeginSql Alias cTmp
		
		SELECT SB1.R_E_C_N_O_ AS B1_RECNO
		FROM %Table:SB1% SB1
		WHERE SB1.%NotDel%
		AND SB1.B1_FILIAL IN %Exp:cFil%
		AND SB1.B1_MSBLQL <> '1'
		AND CONVERT(VARCHAR(20),SB1.S_T_A_M_P_,120) > %Exp:SubStr(cUltimo,1,8)%
		ORDER BY 1
		
	EndSql
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		(cTmp)->(dbCloseArea())
		Return
	Endif
	
	AAdd( aXML , "<?xml version='1.0' encoding='ISO-8859-1' ?>" + CRLF)
	AAdd( aXML , "<Produtos>" + CRLF )
	
	While !(cTmp)->(Eof())
		
		SB1->(dbGoTo((cTmp)->B1_RECNO))   // Posiciona no registro
		
		AAdd( aXML , "	<Produto>" + CRLF )
		AAdd( aXML , "		<Codigo>"+Trim(SB1->B1_COD)+"</Codigo>" + CRLF )
		AAdd( aXML , "		<DescricaoPortugues>"+AllTrim(SB1->B1_DESC)+"</DescricaoPortugues>" + CRLF )
		AAdd( aXML , "		<QuantidadeEmbalagem>"+LTrim(cValToChar(SB1->B1_QE))+"</QuantidadeEmbalagem>" + CRLF )
		AAdd( aXML , "		<PesoLiquido>"+LTrim(cValToChar(SB1->B1_PESO))+"</PesoLiquido>" + CRLF )
		AAdd( aXML , "		<PesoBruto>"+LTrim(cValToChar(SB1->B1_PESBRU))+"</PesoBruto>" + CRLF )
		AAdd( aXML , "		<LinhaProduto>"+"P"+"</LinhaProduto>" + CRLF )
		AAdd( aXML , "		<ProdutoBloqueado>"+"N"+"</ProdutoBloqueado>" + CRLF )
		AAdd( aXML , "		<Pe>"+"90"+"</Pe>" + CRLF )
		AAdd( aXML , "	</Produto>" + CRLF )
		
		(cTmp)->(dbSkip())
	Enddo
	(cTmp)->(dbCloseArea())
	
	AAdd( aXML , "</Produtos>" + CRLF )
	
	GravaXML(aXML,"produtos","produtos","MATA030",.T.)

Return

Static Function ExpEstoque(cUltimo)
	Local aXML := {}
	Local cTmp := GetNextAlias()
	Local cFil := "%"+FormatIn( If( Empty(XFILIAL("ZB2")) , XFILIAL("ZB2"), cFilProc) , "," )+"%"
	
	BeginSql Alias cTmp
		
		SELECT ZB2.ZB2_COD AS B2_COD, AVG(ZB2.ZB2_DISPON) AS B2_QATU
		FROM %Table:ZB2% ZB2
		WHERE ZB2.%NotDel%
		AND ZB2.ZB2_FILIAL IN %Exp:cFil%
		AND (ZB2.S_T_A_M_P_ = ' ' OR CONVERT(VARCHAR(20),ZB2.S_T_A_M_P_,120) > %Exp:cUltimo%)
		GROUP BY ZB2.ZB2_COD
		ORDER BY 1
		
	EndSql
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		(cTmp)->(dbCloseArea())
		
		cFil := "%"+FormatIn( If( Empty(XFILIAL("SB2")) , XFILIAL("SB2"), cFilProc) , "," )+"%"
		
		BeginSql Alias cTmp
			
			SELECT SB2.B2_COD, SB2.B2_QATU
			FROM %Table:SB2% SB2
			WHERE SB2.%NotDel%
			AND SB2.B2_FILIAL IN %Exp:cFil%
			AND SB2.B2_LOCAL = '01'
			AND CONVERT(VARCHAR(20),SB2.S_T_A_M_P_,120) > %Exp:cUltimo%
			ORDER BY 1
			
		EndSql
	Endif
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		(cTmp)->(dbCloseArea())
		Return
	Endif
	
	AAdd( aXML , "<?xml version='1.0' encoding='ISO-8859-1' ?>" + CRLF)
	AAdd( aXML , "<Estoque>" + CRLF )
	
	While !(cTmp)->(Eof())
		
		AAdd( aXML , "	<itm_estoque>" + CRLF )
		AAdd( aXML , "		<Produto>"+Trim((cTmp)->B2_COD)+"</Produto>" + CRLF )
		AAdd( aXML , "		<Quantidade>"+LTrim(Transform((cTmp)->B2_QATU,X3Picture("B2_QATU")))+"</Quantidade>" + CRLF )
		AAdd( aXML , "	</itm_estoque>" + CRLF )
		
		(cTmp)->(dbSkip())
	Enddo
	(cTmp)->(dbCloseArea())
	
	AAdd( aXML , "</Estoque>" + CRLF )
	
	GravaXML(aXML,"estoque","estoque","MATA300",.T.)

Return

Static Function ExpPrecos(cUltimo)
	Local aXML := {}
	Local cTmp := GetNextAlias()
	Local cFil := "%"+FormatIn( If( Empty(XFILIAL("DA1")) , XFILIAL("DA1"), cFilProc) , "," )+"%"
	
	BeginSql Alias cTmp
		
		SELECT DA0.DA0_CODTAB, DA1.R_E_C_N_O_ AS DA1_RECNO
		FROM %Table:DA1% DA1
		INNER JOIN %Table:DA0% DA0 ON DA0.%NotDel% AND DA0.DA0_FILIAL = DA1.DA1_FILIAL AND DA0.DA0_CODTAB = DA1.DA1_CODTAB
		INNER JOIN %Table:SB1% SB1 ON SB1.%NotDel% AND SB1.B1_FILIAL = DA1.DA1_FILIAL AND SB1.B1_COD = DA1.DA1_CODPRO AND SB1.B1_GRUPO = 'VPEC'
		WHERE DA1.%NotDel%
		AND DA1.DA1_FILIAL IN %Exp:cFil%
		AND CONVERT(VARCHAR(20),DA1.S_T_A_M_P_,120) > %Exp:cUltimo%
		ORDER BY 1, 2
		
	EndSql
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		(cTmp)->(dbCloseArea())
		Return
	Endif
	
	While !(cTmp)->(Eof())
		cTabela := (cTmp)->DA0_CODTAB
		
		aXML := {}
		AAdd( aXML , "<?xml version='1.0' encoding='ISO-8859-1' ?>" + CRLF)   // UTF-8
		AAdd( aXML , "<Precos>" + CRLF )
		AAdd( aXML , "	<cab_precos>" + CRLF )
		AAdd( aXML , "		<Codigo>" +cTabela+ "</Codigo>" + CRLF )
		AAdd( aXML , "		<Ativa>S</Ativa>" + CRLF )
		AAdd( aXML , "	</cab_precos>" + CRLF )

		While !(cTmp)->(Eof()) .And. (cTmp)->DA0_CODTAB == cTabela
			
			DA1->(dbGoTo((cTmp)->DA1_RECNO))   // Posiciona no registro
			
			AAdd( aXML , "	<itm_precos>" + CRLF )
			AAdd( aXML , "		<Produto>"+Trim(DA1->DA1_CODPRO)+"</Produto>" + CRLF )
			AAdd( aXML , "		<PrecoImposto>"+LTrim(Transform(DA1->DA1_PRCVEN,X3Picture("DA1_PRCVEN")))+"</PrecoImposto>" + CRLF )
			AAdd( aXML , "		<PrecoSugerido></PrecoSugerido>" + CRLF )
			AAdd( aXML , "		<Ativo>S</Ativo>" + CRLF )
			AAdd( aXML , "		<PrecoFull>"+LTrim(Transform(DA1->DA1_PRCVEN,X3Picture("DA1_PRCVEN")))+"</PrecoFull>" + CRLF )
			AAdd( aXML , "	</itm_precos>" + CRLF )
			
			(cTmp)->(dbSkip())
		Enddo
		
		AAdd( aXML , "</Precos>" + CRLF )
		
		GravaXML(aXML,"precos","precos","OMSA010",.T.)
	Enddo
	(cTmp)->(dbCloseArea())

Return

Static Function ExpStatusPed(cUltimo)
	Local nQtdBlq, nQtdLib, nQtdFat, cPedido, cItem, aNotas, nPos, cLinha
	Local aXML := {}
	Local cTmp := GetNextAlias()
	Local cFil := "%"+FormatIn( If( Empty(XFILIAL("SC5")) , XFILIAL("SC5"), cFilProc) , "," )+"%"
	
	BeginSql Alias cTmp
		
		SELECT SC5.C5_FILIAL, SC5.C5_NUM, SC6.C6_ITEM, ISNULL(SC9.C9_SEQUEN,'') AS C9_SEQUEN, ISNULL(SC9.C9_NFISCAL,'') AS C9_NFISCAL, 
		ISNULL(SC9.C9_SERIENF,'') AS C9_SERIENF, ISNULL(SC9.C9_QTDLIB,0) AS C9_QTDLIB, ISNULL(SC9.C9_BLCRED,'') AS C9_BLCRED, 
		ISNULL(SC9.C9_BLEST,'') AS C9_BLEST, CONVERT(VARCHAR(20),SC6.S_T_A_M_P_,120) AS C6_STAMP, CONVERT(VARCHAR(20),SC9.S_T_A_M_P_,120) AS C9_STAMP
		FROM %Table:SC5% SC5
		INNER JOIN %Table:SC6% SC6 ON SC6.%NotDel% AND SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND CONVERT(VARCHAR(20),SC6.S_T_A_M_P_,120) > %Exp:cUltimo%
		LEFT OUTER JOIN %Table:SC9% SC9 ON SC9.%NotDel% AND SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_PEDIDO = SC6.C6_NUM AND SC9.C9_ITEM = SC6.C6_ITEM 
		WHERE SC5.%NotDel%
		AND SC5.C5_FILIAL IN %Exp:cFil%
		AND SC5.C5_XPEDORI <> ' '
		ORDER BY 1, 2, 3, 4
		
	EndSql
	
	If (cTmp)->(Bof()) .And. (cTmp)->(Eof())
		(cTmp)->(dbCloseArea())
		Return
	Endif
	
	While !(cTmp)->(Eof())
		
		cFilAnt := (cTmp)->C5_FILIAL
		cPedido := (cTmp)->C5_FILIAL+(cTmp)->C5_NUM
		
		// Posiciona no Pedido de Venda
		SC5->(dbsetOrder(1))
		SC5->(dbSeek(cPedido))
		
		aXML := {}
		AAdd( aXML , "<?xml version='1.0' encoding='ISO-8859-1' ?>" + CRLF)
		AAdd( aXML , "<Pedido>" + CRLF )
		
		AAdd( aXML , "	<cab_pedido>" + CRLF )
		AAdd( aXML , "		<PedidoPortal>" +Trim(SC5->C5_XPEDORI)+ "</PedidoPortal>" + CRLF )
		AAdd( aXML , "		<PedidoProtheus>" +SC5->C5_NUM+ "</PedidoProtheus>" + CRLF )
		AAdd( aXML , "		<CodigoCliente>" +Trim(SC5->C5_CLIENTE)+ "</CodigoCliente>" + CRLF )
		AAdd( aXML , "		<LojaCliente>" +Trim(SC5->C5_LOJACLI)+ "</LojaCliente>" + CRLF )
		AAdd( aXML , "		<TipoPed>N</TipoPed>" + CRLF )
		AAdd( aXML , "		<LinhaProd>P</LinhaProd>" + CRLF )
		AAdd( aXML , "	</cab_pedido>" + CRLF )
		
		// Posiciona no Pedido de Vendas
		While !(cTmp)->(Eof()) .And. (cTmp)->C5_FILIAL+(cTmp)->C5_NUM == cPedido
			nQtdLib := 0
			nQtdBlq := 0
			nQtdFat := 0
			cItem   := (cTmp)->C5_FILIAL+(cTmp)->C5_NUM+(cTmp)->C6_ITEM
			aNotas  := {}
			
			// Posiciona no Item do Pedido de Venda
			SC6->(dbsetOrder(1))
			SC6->(dbSeek(cItem))
			
			cLinha  := Trim(SC6->C6_XITEORI)
			
			// Pesquisa as liberações / bloqueios / faturamentos do item do pedido
			While !(cTmp)->(Eof()) .And. (cTmp)->C5_FILIAL+(cTmp)->C5_NUM+(cTmp)->C6_ITEM == cItem
				
				If Empty((cTmp)->C9_STAMP) .Or. (cTmp)->C9_STAMP > cUltimo
					If Empty((cTmp)->C9_NFISCAL)
						If !Empty((cTmp)->C9_BLEST)
							nQtdBlq += (cTmp)->C9_QTDLIB
						ElseIf Empty((cTmp)->C9_BLCRED)
							nQtdLib += (cTmp)->C9_QTDLIB
						Endif
					Else
						nPos := AScan( aNotas , {|x| x[1]+x[2] == (cTmp)->C9_NFISCAL+(cTmp)->C9_SERIENF } )
						If nPos == 0
							AAdd( aNotas , { (cTmp)->C9_NFISCAL, (cTmp)->C9_SERIENF, 0, 0, 0} )
							nPos := Len(aNotas)
						Endif
						aNotas[nPos,4] += (cTmp)->C9_QTDLIB
						aNotas[nPos,3] := aNotas[nPos,4]
						
						nQtdFat += (cTmp)->C9_QTDLIB
					Endif
				Endif
				
				(cTmp)->(dbSkip())
			Enddo
			
			// Cria linha somente com a quantidade liberada
			If nQtdLib > 0
				AAdd( aNotas , { "", "", nQtdLib, 0, 0} )
			Endif
			
			// Cria linha somente com a quantidade bloqueada (ou não-liberada)
			If (nQtdBlq := Max(0,SC6->C6_QTDVEN - nQtdLib - nQtdFat)) > 0
				AAdd( aNotas , { "", "", nQtdBlq, 0, nQtdBlq} )
			Endif
			
			aEval( aNotas , {|x| AddItemXML(aXML,x[1],x[2],cLinha,x[3],x[4],x[5]), cLinha := Proximo(cLinha) } )
			
		Enddo
		
		AAdd( aXML , "</Pedido>" + CRLF )
		
		GravaXML(aXML,"entregas","pedido_" + Trim(SC5->C5_XPEDORI) + "_","MATA410",.T.)
	Enddo
	(cTmp)->(dbCloseArea())

Return

Static Function AddItemXML(aXML,cNota,cSerie,cItem,nQtdLib,nQtdFat,nQtdBlq)
	
	Default cNota   := ""
	Default cSerie  := ""
	Default nQtdLib := 0
	Default nQtdFat := 0
	Default nQtdBlq := 0
	
	AAdd( aXML , "	<itm_pedido>" + CRLF )
	AAdd( aXML , "		<CodigoLinha>" +cItem+ "</CodigoLinha>" + CRLF )
	AAdd( aXML , "		<ItemProtheus>" +SC6->C6_ITEM+ "</ItemProtheus>" + CRLF )
	AAdd( aXML , "		<CodigoProduto>"+Trim(SC6->C6_PRODUTO)+"</CodigoProduto>" + CRLF )
	AAdd( aXML , "		<QtdePortal>" +LTrim(Transform(SC6->C6_QTDVEN,X3Picture("C6_QTDVEN")))+ "</QtdePortal>" + CRLF )
	AAdd( aXML , "		<PrecoPortal>" +LTrim(Transform(SC6->C6_PRCVEN,X3Picture("C6_PRCVEN")))+ "</PrecoPortal>" + CRLF )
	AAdd( aXML , "		<PrevEntrega>" +DtoC(SC6->C6_ENTREG)+ "</PrevEntrega>" + CRLF )
	AAdd( aXML , "		<BloqueioEstoque>"+If(nQtdBlq>0,"01","")+"</BloqueioEstoque>" + CRLF )
	AAdd( aXML , "		<Separacao>"+If(nQtdFat>0,"E",If(nQtdBlq>0,"","E"))+"</Separacao>" + CRLF )
	AAdd( aXML , "		<SeqLiber>01</SeqLiber>" + CRLF )
	AAdd( aXML , "		<QtdLiber>" +LTrim(Transform(If(nQtdFat>0,nQtdFat,nQtdLib),X3Picture("C6_QTDVEN")))+ "</QtdLiber>" + CRLF )
	AAdd( aXML , "		<QtdFatur>" +LTrim(Transform(nQtdFat,X3Picture("C6_QTDENT")))+ "</QtdFatur>" + CRLF )
	AAdd( aXML , "		<DataEmbarque> / / </DataEmbarque>" + CRLF )
	AAdd( aXML , "		<NotaFiscal>" +Trim(cNota)+ "</NotaFiscal>" + CRLF )
	AAdd( aXML , "		<EmissaoNF>" +If(nQtdFat>0,DtoC(Posicione("SF2",1,SC5->C5_FILIAL+cNota+cSerie,"F2_EMISSAO"))," / / ")+ "</EmissaoNF>" + CRLF )
	AAdd( aXML , "		<ConfEntrega> / / </ConfEntrega>" + CRLF )
	AAdd( aXML , "	</itm_pedido>" + CRLF )

Return

Static Function Proximo(cSeq)
	Local nX
	Local aTroca := {}
	
	AAdd( aTroca , { "-", "XYZ"})
	AAdd( aTroca , { "/", "XZY"})
	AAdd( aTroca , { ".", "YZX"})
	AAdd( aTroca , { "_", "YXZ"})
	AAdd( aTroca , { "\", "ZYX"})
	AAdd( aTroca , { "=", "ZXY"})
	
	For nX:=1 To Len(aTroca)
		cSeq := StrTran(cSeq,aTroca[nX,1],aTroca[nX,2])
	Next
	cSeq := Soma1(cSeq)
	For nX:=1 To Len(aTroca)
		cSeq := StrTran(cSeq,aTroca[nX,2],aTroca[nX,1])
	Next

Return cSeq

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ BJCodTab   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 11/10/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Retorna a tabela padrão para o estado                         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function BJCodTab(cTabela,cEstado)
	Local aArea := GetArea()
	Local cTmp  := GetNextAlias()
	
	Default cTabela := SA1->A1_TABELA
	Default cEstado := SA1->A1_EST
	
	If Empty(cTabela)
		BeginSql Alias cTmp
			
			SELECT DISTINCT DA1.DA1_CODTAB
			FROM %Table:DA1% DA1
			INNER JOIN %Table:SB1% SB1 ON SB1.%NotDel% AND SB1.B1_FILIAL = DA1.DA1_FILIAL AND SB1.B1_COD = DA1.DA1_CODPRO AND SB1.B1_GRUPO = 'VPEC'
			WHERE DA1.%NotDel%
			AND DA1.DA1_FILIAL = %Exp:XFILIAL("DA1")%
			AND DA1.DA1_DATVIG <= %Exp:DtoS(dDataBase)%
			AND DA1.DA1_ESTADO = %Exp:cEstado%
			ORDER BY 1
			
		EndSql
		
		If !((cTmp)->(Bof()) .And. (cTmp)->(Eof()))
			cTabela := (cTmp)->DA1_CODTAB
		Endif
		(cTmp)->(dbCloseArea())
		
		RestArea(aArea)
	Endif

Return cTabela

User Function BJMontaXML(lFTP)
	GravaXML(,,,,,lFTP)
Return

Static Function GravaXML(aXML,cPasta,cPrefixo,cRotina,lSalvar,lFTP)
	Local nHdl, cMsg, cFile, cPath
	Local cXML := ""
	
	Default aXML     := { AllTrim(SZ0->Z0_XML) }
	Default cPasta   := AllTrim(SZ0->Z0_PASTA)
	Default cPrefixo := AllTrim( SZ0->Z0_PREFIXO )
	Default cRotina  := AllTrim(SZ0->Z0_ROTINA)
	Default lSalvar  := .F.
	Default lFTP     := .F.
	
	cFile := cPrefixo + DtoS(dDataBase) + StrTran(Time(),":","") + ".xml"
	cPath := CriaPastas(cPasta)
	
	Begin Sequence
	
	//Cria o arquivo
	nHdl := fCreate(cPath+cFile)
	
	aEval( aXML , {|x| cXML += x, fWrite( nHdl , x ) } )
	
	//Finalizando o Handle
	fClose(nHdl)
	
	If lSalvar
		RecLock("SZ0",.T.)
		SZ0->Z0_FILIAL  := XFILIAL("SZ0")
		SZ0->Z0_ID      := CriaVar("Z0_ID"  ,.T.)
		SZ0->Z0_ROTINA  := cRotina
		SZ0->Z0_DATA    := CriaVar("Z0_DATA",.T.)
		SZ0->Z0_HORA    := CriaVar("Z0_HORA",.T.)
		SZ0->Z0_USER    := __cUserID
		SZ0->Z0_PATH    := cPath
		SZ0->Z0_FILE    := cFile
		SZ0->Z0_XML     := cXML
		SZ0->Z0_PASTA   := cPasta
		SZ0->Z0_PREFIXO := cPrefixo
		SZ0->Z0_OPER    := "1"    // 1=Arq.Enviado, 2=Arq.Recebido
		MsUnLock()
		
		ConfirmSX8()
		
		SaveXML()
	Endif
	
	End Sequence
	
	SaveXML()
	
	If lFTP
		cPath := GetTempPath()
		If u_FTPConnection(cPasta,{{cPath+cFile,cFile}},@cMsg)
			FWAlertSuccess("Arquivo enviado com sucesso para o FTP !","Transmissão para FTP")
		Else
			FWAlertError("Ocorreu um erro na transmissão para o FTP: <br /><br /><strong>"+cMsg+"</strong>","Transmissão para FTP")
		Endif
	Endif
	
Return

Static Function SaveXML()
	Local nHdl
	Local cPath := GetTempPath()
	Local cFile := AllTrim(SZ0->Z0_FILE)
	
	If cPath == Nil
		cPath := AllTrim(SZ0->Z0_PATH)
	Endif
	
	If File(cPath+cFile)
		FErase(cPath+cFile)
	Endif
	
	nHdl := FCREATE(cPath+cFile,0)
	FWrite(nHdl,AllTrim(SZ0->Z0_XML)+CRLF)
	FCLOSE(nHdl)
	
Return

Static Function CriaPastas(cDir)
	Local cPath := "\prod"
	
	Default cDir := ""
	
	If !Empty(cDir)
		If !ExistDir(cPath)
			MakeDir(cPath)
		Endif
		cPath += "\pam"
		If !ExistDir(cPath)
			MakeDir(cPath)
		Endif
		cPath += "\entrada"
		If !ExistDir(cPath)
			MakeDir(cPath)
		Endif
		
		cDir := StrTran(cPath+"\"+cDir,"\\","\")
		
		If !ExistDir(cDir)
			MakeDir(cDir)
		Endif
		
		cDir += "\"
	Endif

Return cDir

User Function FTPConnection(cPasta,aFiles,cMsg)
	Local nF, nP, cFile
	//Local cPath := GetTempPath()
	Local cHost := GetMV("MV_XENDFTP",.F.,"ftpcentral.tecsinapse.com.br")
	Local nPort := 0
	Local cUser := GetMV("MV_XUSRFTP",.F.,"protheus-homolog")
	Local cPsw  := GetMV("MV_XPSWFTP",.F.,"I3yEz9TfsIGGE@X4")
	Local cRoot := "entrada"
	Local cFTP  := "/"
	
	Local aRet   := {}
	Local aPergs := {}
	
	If !IsBlind()
		aAdd( aPergs ,{9,"Exportar XML TECSINAPSE para o FTP",200, 40,.T.})
		
		aAdd( aPergs ,{1,"Host:"        , cHost    ,""       ,"","","", 90,.T.})
		aAdd( aPergs ,{1,"Porta:"       , nPort    ,"@E 9999","","","", 10,.T.})
		aAdd( aPergs ,{1,"Usuário:"     , cUser    ,""       ,"","","", 30,.T.})
		aAdd( aPergs ,{1,"Senha:"       , cPsw     ,""       ,"","","", 20,.T.})
		aAdd( aPergs ,{1,"Root:"        , cRoot    ,""       ,"","","", 50,.T.})
		
		If ParamBox(aPergs ,"Exportar XML TECSINAPSE",aRet,/*{|| bOKaRet(aRet)}*/,/*aButtons*/,,,,,,,)
			cHost := aRet[2]
			nPort := aRet[3]
			cUser := aRet[4]
			cPsw  := aRet[5]
			cRoot := aRet[6]
		Endif
	Endif
	
	cRoot := StrTran(cRoot,"/","\")
	aDir  := Separa( cRoot , "\", .F.)
	cRoot := aDir[1]
	
	CpyT2S(aFiles[1,1],"\")
	
	nStatus := SFTPUpld1("\"+aFiles[1,2], "/dev/tecsinapse/"+aFiles[1,2], "sftp://bajajdo167416.protheus.cloudtotvs.com.br:1401", "ftp_CILRZS_development", "Dw1VdvKo",@cMsg)
	
	Private oFTPHandle
	
	oFTPHandle := tFtpClient():New()
	nRet := oFTPHandle:FTPConnect(cHost,nPort,cUser,cPsw)
	cMsg := oFTPHandle:GetLastResponse()
	
	If nRet == 0
		If (nRet := MudaPasta(cRoot)) == 0
			cFTP += cRoot + "/"
			For nP:=2 To Len(aDir)
				If (nRet := MudaPasta(aDir[nP])) == 0
					cFTP += aDir[nP] + "/"
				Else
					Exit
				Endif
			Next
			If (nRet := MudaPasta(cPasta)) == 0
				cFTP += cPasta + "/"
				For nF:=1 To Len(aFiles)
					
					cFile := "\"+aFiles[nF,2]
					
					// Copia o Arquivo para o RootPath
					If File(cFile)
						FErase(cFile)
					Endif
					
					nRet := oFTPHandle:SendFile(aFiles[nF,1], cFTP + aFiles[nF,2])
					cMsg := oFTPHandle:GetLastResponse()
					
					FErase(cFile)
					
					If nRet <> 0
						Exit
					Endif
				Next
			Endif
		Endif
	Else
		If !IsBlind()
			FWAlertError("Falha na conexão do ftp, erro " + LTrim(cValToChar(nRet))+;
						If(Empty(cMsg),"","<br /><br />"+cMsg))
		Endif
	Endif
	
	oFTPHandle:Close()
	
Return nRet == 0

Static Function MudaPasta(cPasta,cMens)
	Local nRet
	
	If cPasta <> ".."
		nRet := oFTPHandle:ChDir(cPasta)
	Else
		nRet := oFTPHandle:CdUp()
	Endif
	
	cMens := oFTPHandle:GetLastResponse()
	u_fConout(cMens)
	
	If nRet == 0
		oFTPHandle:GetCurDir(cMens)
		cMens := oFTPHandle:GetLastResponse()
		u_fConout(cMens)
	Endif

Return nRet

Static Function ConfiguraUsuario(cID)
	
	__cUserID := cID      // Define usuário padrão
	
	PswOrder(1)           // (1) Codigo , (2) Nome
	If PswSeek(__cUSerID) // Pesquisa usuário
		cUserName := PswRet(1)[1][2]    // Retorna codigo do usuário [1] ou o Nome [2]
	Endif
	
Return

Static Function ConfigEmpresa(cFil)
	cFilAnt := PADR(AllTrim(cFil),Len(SA1->A1_FILIAL))
	
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))
	
Return
