
USER FUNCTION BUSCA_QRY(CCODIGO,CFLAG)

	LOCAL CQUERY := ""

	IF ExistBlock("MAX_QRY01")
		CQUERY := ExecBlock("MAX_QRY01",.F.,.F.,{CCODIGO,CFLAG})
		RETURN(CQUERY)
	ENDIF

	//FILIAIS
	IF ALLTRIM(CCODIGO) == "Filiais"

		// ---- Campos do arquivo temporário ---- // 
		aCmpArqTmp := { {"M0_CODFIL"   ,"C",06,0 } ,; 
						{"M0_NOME"     ,"C",40,0 } ,; 
						{"M0_ESTCOB"   ,"C",02,0 } ,; 
						{"M0_CGC"      ,"C",14,0 } ,;
						{"VERBO"       ,"C",04,0 }}
			
		// ----- Alimentando arq. temporário ----- // 
		cNomeArq := CriaTrab(aCmpArqTmp,.T.) 
		dbUseArea(.T.,, cNomeArq,"TMP",.T.) 
		Index On M0_CODFIL To &cNomeArq 

		DBSELECTAREA("SM0")
		SM0->(DBGOTOP())
		WHILE !SM0->(EOF())
			RECLOCK("TMP",.T.)
				TMP->M0_CODFIL := SM0->M0_CODFIL
				TMP->M0_NOME   := SM0->M0_NOME
				TMP->M0_ESTCOB := SM0->M0_ESTCOB
				TMP->M0_CGC    := SM0->M0_CGC
				TMP->VERBO     := "POST"
			TMP->(MSUNLOCK())
			SM0->(DBSKIP())
		ENDDO
		
		TMP->(DBGOTOP())
			
		CQUERY += "*"	
	ENDIF

	//CIDADES
	IF ALLTRIM(CCODIGO) == "Cidades"
		CQUERY += " SELECT * FROM " + RETSQLNAME("CC2")+ " CC2"
		CQUERY += " WHERE D_E_L_E_T_ = ' '"
		CQUERY += " AND CC2_CODMUN <> ' '"
		CQUERY += " ORDER BY CC2_EST, CC2_CODMUN"
	ENDIF

	//ATIVIDADES
	IF ALLTRIM(CCODIGO) == "Atividades"
		CQUERY += " SELECT X5_CHAVE, X5_DESCRI FROM " + RETSQLNAME("SX5")	
		CQUERY += " WHERE D_E_L_E_T_ = ' '"
		CQUERY += " AND X5_TABELA = 'T3'"
		CQUERY += " ORDER BY X5_CHAVE"
	ENDIF

	//GRUPOS - CATEGORIAS
	IF ALLTRIM(CCODIGO) $ "Departamentos/Subcategorias/Categorias/Secoes"
		CQUERY += " SELECT X5_CHAVE, X5_DESCRI FROM " + RETSQLNAME("SX5")	
		CQUERY += " WHERE D_E_L_E_T_ = ' '"
		CQUERY += " AND X5_TABELA = 'ZZ'"
		CQUERY += " ORDER BY X5_CHAVE"
	ENDIF

	//CLIENTES
	IF ALLTRIM(CCODIGO) == "Clientes"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SA1") + " SA1"	
		CQUERY += " WHERE SA1.D_E_L_E_T_ = ' '"
		CQUERY += " AND A1_VEND <> ' '"
		CQUERY += " AND A1_XXMAXIM = ' '"
		
		CQUERY += " ORDER BY A1_COD, A1_LOJA"     
	ENDIF

	IF ALLTRIM(CCODIGO) == "Pracas" .OR. ALLTRIM(CCODIGO) == "Regioes"
		CQUERY += " SELECT * FROM " + RETSQLNAME("DA0") + " DA0"	
		//CQUERY += " INNER JOIN SYS_COMPANY EMP ON EMP.D_E_L_E_T_ = ' ' AND M0_CODIGO <> '99'"
		CQUERY += " WHERE DA0.D_E_L_E_T_ = ' '"
		CQUERY += " ORDER BY DA0_CODTAB"     
	EndIf

	/*
	IF ALLTRIM(CCODIGO) == "Regioes"
		CQUERY += "SELECT * FROM SYS_COMPANY EMP WHERE EMP.D_E_L_E_T_ = ' ' AND M0_CODIGO <> '99'"    
	ENDIF
	*/

	//PRODUTOS
	IF ALLTRIM(CCODIGO) == "Produtos"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SB1") + " SB1"	
		CQUERY += " WHERE D_E_L_E_T_ = ' '"
		CQUERY += " AND B1_XXMAXIM = ' '"
		CQUERY += " ORDER BY B1_COD"
	ENDIF

	//ESTOQUES
	IF ALLTRIM(CCODIGO) == "Estoques" 
		CQUERY += " SELECT * FROM " + RETSQLNAME("SB2") + " SB2"	
		CQUERY += " INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON B1_COD = B2_COD AND B1_LOCPAD = B2_LOCAL AND SB1.D_E_L_E_T_ = ' '"
		CQUERY += " WHERE SB2.D_E_L_E_T_ = ' '"
		CQUERY += " ORDER BY B2_COD"
	ENDIF

	IF ALLTRIM(CCODIGO) == "ProdutosFiliais"
		CQUERY += " SELECT M0_CODFIL, B1_COD "
		CQUERY += " FROM " + RETSQLNAME("SB1") + " SB1"
		CQUERY += " INNER JOIN SYS_COMPANY EMP"
		CQUERY += " ON EMP.D_E_L_E_T_ = ' '"
		CQUERY += " AND M0_CODIGO <> '99'"
		CQUERY += " WHERE SB1.D_E_L_E_T_ = ' '"
		CQUERY += " AND B1_TIPO = 'PA'"
		CQUERY += " ORDER BY B1_COD"
	EndIf

	//FORNECEDORES
	IF ALLTRIM(CCODIGO) == "Fornecedores"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SA2") + " SA2"	
		CQUERY += " WHERE D_E_L_E_T_ = ' '"
		CQUERY += " AND A2_FILIAL = '"+XFILIAL("SA2")+"'"
		CQUERY += " AND A2_XXMAXIM = ' '"
		CQUERY += " ORDER BY A2_COD"
	ENDIF
					
	//PlanosPagamentos              
	IF ALLTRIM(CCODIGO) == "PlanosPagamentos"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SE4") + " SE4"	
		CQUERY += " WHERE D_E_L_E_T_ = ' '"
		CQUERY += " ORDER BY E4_CODIGO"
	ENDIF

	//PLANOSPAGAMENTOSCLIENTES
	IF ALLTRIM(CCODIGO) == "PlanosPagamentosClientes"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SA1") + " SA1"	
		CQUERY += " WHERE D_E_L_E_T_ = ' '"
		CQUERY += " AND A1_COND <> ' '"
		CQUERY += " ORDER BY A1_COD, A1_LOJA"
	ENDIF                                   

	//ClientesCreditosDisponiveis   
	IF ALLTRIM(CCODIGO) == "ClientesCreditosDisponiveis"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SA1") + " SA1"	
		CQUERY += " WHERE D_E_L_E_T_ = ' '"
		CQUERY += " ORDER BY A1_COD, A1_LOJA"
	ENDIF                                   
			
	//HISTORICOSPEDIDOSCAPAS
	IF ALLTRIM(CCODIGO) == "HistoricosPedidosCapas"
		CQUERY += " SELECT C5_XXPEDMA, C5_NOTA, C5_LIBEROK, C5_BLQ, C5_XORC, SC5.D_E_L_E_T_ REG_DEL,C5_VEND1, C5_FILIAL, C5_CLIENTE, C5_LOJACLI, C5_NUM, SUM(C6_VALOR) TOTAL, C5_EMISSAO, C5_CONDPAG FROM " + RETSQLNAME("SC5") + " SC5"	
		CQUERY += " INNER JOIN " + RETSQLNAME("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM "//AND SC6.D_E_L_E_T_ = ' '"
	//	CQUERY += " WHERE SC5.D_E_L_E_T_ = ' '"
		CQUERY += " WHERE C5_EMISSAO >= '"+DTOS(DATE()-20)+"'"
		CQUERY += " GROUP BY C5_XXPEDMA, C5_NOTA, C5_LIBEROK, C5_BLQ, C5_XORC, SC5.D_E_L_E_T_ ,C5_VEND1, C5_FILIAL, C5_CLIENTE, C5_LOJACLI, C5_NUM, C5_EMISSAO, C5_CONDPAG"
		CQUERY += " ORDER BY C5_FILIAL, C5_NUM"
	ENDIF                         

	//HistoricosPedidosItens
	IF ALLTRIM(CCODIGO) == "HistoricosPedidosItens"
		CQUERY += " SELECT C6_FILIAL, C6_NUM, C6_QTDVEN, C6_QTDENT, C6_ITEM, C6_PRCVEN, C6_PRODUTO FROM " + RETSQLNAME("SC6") + " SC6"	
		CQUERY += " INNER JOIN  " + RETSQLNAME("SC5") + " SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_EMISSAO >= '"+DTOS(DATE()-20)+"'"	
		CQUERY += " WHERE SC6.D_E_L_E_T_ = ' '"
		CQUERY += " ORDER BY C6_FILIAL, C6_NUM, C6_ITEM"
	ENDIF                         

	//HistoricoPedidosCortes
	IF ALLTRIM(CCODIGO) == "HistoricosPedidosCortes"
		CQUERY += " SELECT C5_XXPEDMA,C6_FILIAL, C6_NUM, C6_QTDVEN - C6_QTDENT QUANT, C6_ITEM, C6_PRCVEN, C6_PRODUTO FROM " + RETSQLNAME("SC6") + " SC6"	
		CQUERY += " INNER JOIN  " + RETSQLNAME("SC5") + " SC5 ON C5_FILIAL = C6_FILIAL AND C5_NOTA <> ' ' AND C5_NUM = C6_NUM AND C5_EMISSAO >= '"+DTOS(DATE()-20)+"'"	
		CQUERY += " WHERE SC6.D_E_L_E_T_ = ' '"
		CQUERY += " AND C6_QTDVEN-C6_QTDENT > 0" 
		CQUERY += " ORDER BY C6_FILIAL, C6_NUM, C6_ITEM"
	ENDIF                         

	//Supervisores
	IF ALLTRIM(CCODIGO) == "Supervisores"
		CQUERY += " SELECT A3_SUPER, A3_GEREN FROM " + RETSQLNAME("SA3") + " SA3"
		CQUERY += " WHERE SA3.D_E_L_E_T_ = ' '"
		CQUERY += " AND (A3_SUPER <> ' ' OR A3_GEREN <> ' ')" 
		CQUERY += " GROUP BY A3_SUPER, A3_GEREN"
		CQUERY += " ORDER BY A3_SUPER"	
	ENDIF      

	//Usuaris
	IF ALLTRIM(CCODIGO) == "Usuaris"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SA3") + " SA3"	
		CQUERY += " WHERE SA3.D_E_L_E_T_ = ' '"
		CQUERY += " ORDER BY A3_COD"
	ENDIF                         

	//TitulosAbertos                          
	IF ALLTRIM(CCODIGO) == "PrestacoesTitulos"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SE1") + " SE1"	
		CQUERY += " WHERE SE1.D_E_L_E_T_ = ' '"                                                                                   
		CQUERY += " AND E1_SALDO > 0"
		CQUERY += " AND E1_VEND1 <> ' '"
		CQUERY += " ORDER BY E1_NUM"
	ENDIF                         

	//TABELASPRECOS
	IF ALLTRIM(CCODIGO) == "TabelasPrecos"
		CQUERY += " SELECT * FROM " + RETSQLNAME("DA1") + " DA1 "	
		CQUERY += " INNER JOIN " + RETSQLNAME("DA0") + " DA0 "
		CQUERY += " ON DA0_FILIAL = DA1_FILIAL "
		CQUERY += " AND DA0_CODTAB = DA1_CODTAB "
		CQUERY += " AND DA0_ATIVO = '1' "
		CQUERY += " AND DA0.D_E_L_E_T_ = ' ' "//AND (DA0_DATATE >= '"+DTOS(DATE())+"' OR DA0_DATATE = ' ')
		CQUERY += " WHERE DA1.D_E_L_E_T_ = ' ' " 
		CQUERY += " ORDER BY DA1_CODTAB, DA1_CODPRO"
	ENDIF                         

	//TRANSPORTADORA
	IF ALLTRIM(CCODIGO) == "Transportadoras"
		CQUERY += " SELECT * FROM " + RETSQLNAME("SA4") + " SA4"	
		CQUERY += " WHERE SA4.D_E_L_E_T_ = ' '"                                                                                   
		CQUERY += " ORDER BY A4_COD"
	ENDIF                         

	//CobrancasClientes
	IF ALLTRIM(CCODIGO) == "CobrancasClientes"
		CQUERY += " SELECT A1_COD, A1_LOJA, 'BOL' FORMA FROM " + RETSQLNAME("SA1") + " SA1"	
		CQUERY += " WHERE SA1.D_E_L_E_T_ = ' '"
		CQUERY += " AND A1_VEND <> ' '"
	//	CQUERY += " AND A1_XXMAXIM = ' '"
		CQUERY += " UNION ALL"
		CQUERY += " SELECT A1_COD, A1_LOJA, 'DUP' FORMA FROM " + RETSQLNAME("SA1") + " SA1"	
		CQUERY += " WHERE SA1.D_E_L_E_T_ = ' '"
		CQUERY += " AND A1_VEND <> ' '"
	//	CQUERY += " AND A1_XXMAXIM = ' '"	
	//	CQUERY += " ORDER BY A1_COD, A1_LOJA"     
	ENDIF
		
	IF ALLTRIM(CCODIGO) == "ClientesRegioes"
		CQUERY += " SELECT DA0_FILIAL, DA0_CODTAB, A1_COD, A1_LOJA, A1_DESC "
		CQUERY += " FROM " + RETSQLNAME("SA1") + " SA1 "
		CQUERY += " INNER JOIN " + RETSQLNAME("DA0") + " DA0 "
		CQUERY += " ON DA0.D_E_L_E_T_ = ' ' "
		CQUERY += " WHERE SA1.D_E_L_E_T_ = ' ' "
		CQUERY += " GROUP BY DA0_FILIAL, DA0_CODTAB, A1_COD, A1_DESC, A1_LOJA "
	EndIf

	IF ALLTRIM(CCODIGO) == "FilialRegiao"
		CQUERY += " SELECT * "
		CQUERY += " FROM " + RETSQLNAME("DA0") + " DA0	"
		CQUERY += " INNER JOIN SYS_COMPANY EMP ON EMP.D_E_L_E_T_ = ' ' AND M0_CODIGO <> '99' " 
		CQUERY += " AND SUBSTRING(M0_CODFIL ,1,4)+'  ' = DA0_FILIAL "
		CQUERY += " WHERE DA0.D_E_L_E_T_ = ' ' "
		CQUERY += " AND DA0_ATIVO = '1' "
		CQUERY += " AND DA0.D_E_L_E_T_ = ' ' "
		CQUERY += " ORDER BY DA0_FILIAL, DA0_CODTAB "
	EndIf
RETURN(CQUERY)
