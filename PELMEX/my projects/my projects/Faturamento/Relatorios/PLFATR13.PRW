#Include "rwmake.ch"
#Include "Topconn.ch"
/*_____________________________________________________________________________
¦ Função    ¦ PLFATR13   ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 02/09/2009     ¦
+-----------+------------+-------+---------------------+------+----------------+
¦ Descriçäo ¦ Relação de notas fiscais Pelmex                					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PlFatR13()

	Local CbTxt
	Local CbCont,wnrel
	Local nOrdem,cFiltro := ""
	Local tamanho:= "G"
	Local limite := 220
	Local titulo := "Relacao de Produtos para Suframa"
	Local cDesc1 := "Este programa ira emitir a relacao de produtos "
	Local cDesc2 := "vendidos ou produzidos para envio a Suframa."
	Local cDesc3 := ""
	Local cString:= "SF2"

	Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	Private nomeprog:="PLFATR13"
	Private aLinha  := { },nLastKey := 0
	Private oTela, nOpc, nRadio := 1, aRadio := {"Vendas","Producao"}
	Private cPerg

	cbtxt 	:= SPACE(10)
	cbcont 	:= 0
	li 		:= 80
	m_pag 	:= 1

	PlFatR13c()

	If nOpc <> 1
		Return
	EndIf

	If nRadio == 1
		cPerg := PADR("FATR13",Len(SX1->X1_GRUPO))
		wnrel := "FATR13"
		PergVendas()
	Else
		cPerg := PADR("PROD13",Len(SX1->X1_GRUPO))
		wnrel := "PROD13"
		PergProduc()
	EndIf

	pergunte(cPerg,.F.)

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.T.)

	If nLastKey==27
		dbClearFilter()
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey==27
		dbClearFilter()
		Return
	Endif

	If nRadio == 1
		RptStatus({|lEnd| PlFatR13a(@lEnd,wnRel,cString)},Titulo)
	Else
		RptStatus({|lEnd| PlFatR13b(@lEnd,wnRel,cString)},Titulo)
	EndIf

Return

/*__________________________________________________________________________
¦ Função    ¦ PLFATR13A  ¦ Autor ¦ Ulisses Junior   ¦ Data ¦ 02/09/2009     ¦
+-----------+------------+-------+------------------+------+----------------+
¦ Descriçäo ¦ Chamada do relatório                        					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlFatR13a(lEnd,WnRel,cString)

	Local lContinua	:= .T., dEmisAnt
	Local tamanho:= "G"
	Local cQuery := ""
	Local nTqtdEst, nTqtd2UmEst, nTvlrEst
	Local nTqtdAm, nTqtd2UmAm, nTvlrAm
	Local nTqtdGrp, nTqtd2UmGrp, nTvlrGrp
	Local nTotQuant, nTotQuant2Um, nValortot
	Local nGerQuant, nGerQuant2Um, nValorGer
	Local cabec1,cabec2
	Local xEstado	:= GetMv("MV_ESTADO")
	Local cRestEstado	:= GetMv("MV_RESTEST")
	Local aTexto	:= {"DENTRO DO ESTADO","FORA DO ESTADO",""}

	cbtxt    := Space(10)
	cbcont   := 00
	li       := 80
	m_pag    := 01

	titulo := " RELACAO DE PRODUTOS PARA SUFRAMA - "+Alltrim(aTexto[mv_par09])
	//Cabec1 := "PRODUTO          DESCRICAO                            QUANTIDADE  UM           QTD 2UM  2UM    VALOR UNITARIO  VALOR MERCADORIA ARM CFO  TES PEDIDO/IT         VALOR IPI         VALOR ICM  DESP. ACESSORIAS             TOTAL"
	Cabec1 := "GRUPO  DESC.GRUPO           PRODUTO            DESCRICAO                                           TIPO    QUANTIDADE  UM         QTD 2UM  2UM    VALOR MERCADORIA  NOTA FISCAL  CLIENTE  TRIBUTAÇÃO  CFO   EMISSAO  ESTADO"
	//         XXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XX  999.999.999,99  UM  999.999,999999   UM  99	9.999.999.999,99    999999999  9999  99/99/99   XX   XXXXXX
	// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	Cabec2 := " "

	//campos do SF2
	cQuery := " SELECT F2_DOC, F2_SERIE, F2_EMISSAO, F2_EST, SF2.R_E_C_N_O_ SF2RECNO, "
	//campos do SD2
	cQuery += " D2_DOC, D2_SERIE, D2_COD, D2_GRUPO, D2_TIPO, D2_TP, D2_CLIENTE, D2_LOJA, D2_CF, D2_TES, "
	cQuery += " D2_QUANT,D2_TOTAL,D2_UM, B1_SEGUM D2_SEGUM, " 
	cQuery += " CASE WHEN D2_QTSEGUM > 0 THEN D2_QTSEGUM ELSE CASE WHEN B1_TIPCONV = 'M' THEN D2_QUANT * B1_CONV ELSE CASE WHEN B1_TIPCONV = 'D' THEN D2_QUANT / B1_CONV END END END D2_QTSEGUM , "
	cQuery += " A1_TPTRIBU "
	cQuery += " FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA1")+" SA1, " + RetSqlName("SD2")+" SD2 "
	cQuery += " LEFT JOIN "+RetSqlName("SD1")+" SD1  ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1  ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	cQuery += " AND F2_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	cQuery += " AND F2_TIPO = 'N' "
	cQuery += " AND D1_DOC IS NULL "
	cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
	If mv_par09 == 1
		cQuery += " AND F2_EST = '"+xEstado+"' "
	ElseIf mv_par09 == 2
		cQuery += " AND F2_EST <> '"+xEstado+"' "
	Endif
	cQuery += " AND F2_EST NOT IN('"+ALLTRIM(cRestEstado)+"')"
	cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"' "
	cQuery += " AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
	cQuery += " AND D2_TES BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "
	cQuery += " AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "
	//Alterado Jean Vicente 08/09/2010
	If mv_par10 == 1
		cQuery += " AND A1_TPTRIBU  = 1 "
	ElseIf mv_par10 == 2
		cQuery += " AND A1_TPTRIBU  = 2 "
	ElseIf mv_par10 == 3
		cQuery += " AND A1_TPTRIBU  = 3 "
	Endif
	//Fim Jean 
	cQuery += " AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE "
	cQuery += " AND D2_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " AND D2_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " AND SD2.D_E_L_E_T_=''"
	cQuery += " AND SA1.D_E_L_E_T_=''"
	cQuery += " ORDER BY F2_EST, D2_GRUPO, D2_COD, F2_DOC, F2_EMISSAO "



	cQuery:=ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"Wrk",.F.,.T.)
	TCSetField("Wrk","F2_EMISSAO","D",8,0)

	nGerQuant := nGerQuant2Um := nValorGer := 0

	nQtdTRB1	:= 0
	nVlrTRB1	:= 0 
	nQtdTRB2	:= 0
	nVlrTRB2	:= 0
	nQtdTRB3	:= 0
	nVlrTRB3	:=0


	SetRegua(Wrk->(RecCount()))		// Total de Elementos da regua
	While !Wrk->(Eof()) .and. lContinua

		If lEnd
			@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		EndIf

		cEstado	:= Wrk->F2_EST
		//Totalizadores do Estado
		nTqtdEst		:= 0
		nTqtd2UmEst	:= 0
		nTvlrEst		:= 0

		nTqtdAm		:= 0
		nTqtd2UmAm	:= 0
		nTvlrAm		:= 0

		nTqtdEstTRIB1		:= 0
		nTvlrEstTRIB1		:= 0
		nTqtdAmTRIB1	:= 0
		nTvlrAmTRIB1		:= 0 
		nTqtdEstTRIB2		:= 0
		nTvlrEstTRIB2		:= 0
		nTqtdAmTRIB2		:= 0
		nTvlrAmTRIB2		:= 0
		nTqtdEstTRIB3		:= 0
		nTvlrEstTRIB3		:= 0
		nTqtdAmTRIB3		:= 0
		nTvlrAmTRIB3		:= 0


		While !Wrk->(Eof()) .and. If(cEstado == xEstado, Wrk->F2_EST == cEstado, .T.)

			cGrupo	:= Wrk->D2_GRUPO
			//Totalizadores do Grupo
			nTqtdGrp		:= 0
			nTqtd2UmGrp	:= 0
			nTvlrGrp		:= 0

			While !Wrk->(Eof()) .and. If(cEstado == xEstado, Wrk->F2_EST == cEstado, .T.) .and. Wrk->D2_GRUPO == cGrupo

				cProduto := Wrk->D2_COD
				//Totalizadores do Produto
				nTotQuant	:= 0
				nTotQuant2Um:=0
				nValorTot	:=0

				While !Wrk->(Eof()) .and. If(cEstado == xEstado, Wrk->F2_EST == cEstado, .T.) .and. Wrk->D2_GRUPO+Wrk->D2_COD == cGrupo+cProduto

					IncRegua()

					If li > 52
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					EndIf

					SF4->(dbSetOrder(1))
					SF4->(dbSeek(xFilial("SF4")+Wrk->D2_TES))
					//Alterado Jean Vicente 08/09/2010
					cTributo := Posicione("SA1",1,xFilial("SA1")+Wrk->D2_CLIENTE +Wrk->D2_LOJA,"A1_TPTRIBU")
					cTipoTributo := ''

					if cTributo == '1'
						cTipoTributo := 'REAL     '				
					elseif cTributo == '2'
						cTipoTributo := 'PRESUMIDO'				
					elseif cTributo == '3'
						cTipoTributo := 'SIMPLES  '
					else					     
						cTipoTributo := '         '
					endif
					// Fim Jean								
					If SF4->F4_DUPLIC == 'S'
						@Li,000 Psay Wrk->D2_GRUPO
						@Li,007 Psay Posicione("SBM",1,xFilial("SBM")+Wrk->D2_GRUPO,"BM_DESC")   //TAM 30
						@Li,030 Psay Wrk->D2_COD   // TAM 15
						@Li,047 Psay Posicione("SB1",1,xFilial("SB1")+Wrk->D2_COD,"B1_DESC") // TAM 60
						@Li,101 Psay Wrk->D2_TP
						@Li,103 Psay Wrk->D2_QUANT		Picture "@E 999,999,999.99" 
						@Li,119 Psay Wrk->D2_UM
						@Li,123 Psay Wrk->D2_QTSEGUM	Picture "@E 999,999,999.99"
						@Li,140 Psay Wrk->D2_SEGUM
						@Li,144 Psay xMoeda(Wrk->D2_TOTAL ,1,1,Wrk->F2_EMISSAO) Picture "@E 999,999,999,999.99"
						@Li,166 Psay Wrk->F2_DOC 

						//Alterado Jean Vicente 08/09/2010
						@Li,178 Psay Wrk->D2_CLIENTE
						@Li,187 Psay cTipoTributo         
						//fim da alteração

						@Li,199 Psay Wrk->D2_CF
						@Li,205 Psay Wrk->F2_EMISSAO
						@Li,216 Psay Wrk->F2_EST

						li++

						nTotQuant	+= Wrk->D2_QUANT
						nTotQuant2Um+= Wrk->D2_QTSEGUM
						nValorTot	+= xMoeda(Wrk->D2_TOTAL ,1,1,Wrk->F2_EMISSAO)

						if cTributo == '1'
							nQtdTRB1	+= Wrk->D2_QUANT
							nVlrTRB1    += xMoeda(Wrk->D2_TOTAL ,1,1,Wrk->F2_EMISSAO)						
						elseif cTributo == '2'
							nQtdTRB2	+= Wrk->D2_QUANT
							nVlrTRB2    += xMoeda(Wrk->D2_TOTAL ,1,1,Wrk->F2_EMISSAO)						
						elseif cTributo == '3'
							nQtdTRB3	+= Wrk->D2_QUANT
							nVlrTRB3    += xMoeda(Wrk->D2_TOTAL ,1,1,Wrk->F2_EMISSAO)
						endif

					EndIf

					Wrk->(dbSkip())

				End // FIM DO 3 WHILE PRODUTO		
				li++

				If (nTotQuant+nTotQuant2Um+nValorTot) > 0

					@Li,000 Psay "Totais do Produto "+cProduto
					@li,102 Psay nTotQuant		Picture "@E 999,999,999.99" 
					@li,122 Psay nTotQuant2Um	Picture "@E 999,999.999999"
					@li,143 Psay nValorTot		Picture "@E 999,999,999,999.99"
					li++

					@ Li,000 PSay __PrtThinLine()
					li += 2
				EndIf

				nTqtdGrp		+= nTotQuant
				nTqtd2UmGrp		+= nTotQuant2Um
				nTvlrGrp		+= nValorTot			

			End // FIM DO WHILE 2 GRUPO

			If (nTqtdGrp+nTqtd2UmGrp+nTvlrGrp) > 0

				@li,000 Psay "Totais do Grupo "+cGrupo
				@li,103 Psay nTqtdGrp		Picture "@E 999,999,999.99" 
				@li,123 Psay nTqtd2UmGrp	Picture "@E 999,999.999999"
				@li,144 Psay nTvlrGrp		Picture "@E 999,999,999,999.99"
				li++

				@ Li,000 PSay __PrtThinLine()
				li+=2
			EndIf

			If cEstado # xEstado
				nTqtdEst		+= nTqtdGrp
				nTqtd2UmEst	+= nTqtd2UmGrp
				nTvlrEst		+= nTvlrGrp

			Else
				nTqtdAm		+= nTqtdGrp
				nTqtd2UmAm	+= nTqtd2UmGrp
				nTvlrAm		+= nTvlrGrp

			EndIf
		End//FIM DO 1 WHILE DO ESTADO

		If (nTqtdEst+nTqtd2UmEst+nTvlrEst+nTqtdAm+nTqtd2UmAm+nTvlrAm) > 0
			If cEstado # xEstado
				@li,000 Psay "Totais Fora do Estado"
				@li,103 Psay nTqtdEst		Picture "@E 999,999,999.99" 
				@li,123 Psay nTqtd2UmEst	Picture "@E 999,999.999999" 	
				@li,144 Psay nTvlrEst		Picture "@E 999,999,999,999.99"
				li++

				@ Li,000 PSay __PrtThinLine()
				li += 2
			Else
				@li,000 Psay "Totais Dentro do Estado"
				@li,103 Psay nTqtdAm		Picture "@E 999,999,999.99" 
				@li,123 Psay nTqtd2UmAm	Picture "@E 999,999.999999"
				@li,144 Psay nTvlrAm		Picture "@E 999,999,999,999.99"
				li++

				@ Li,000 PSay __PrtThinLine()
				li += 2
			EndIf
		EndIf

		nGerQuant	+= (nTqtdEst+nTqtdAm)
		nGerQuant2Um+= (nTqtd2UmEst+nTqtd2UmAm)
		nValorGer	+= (nTvlrEst+nTvlrAm)

	End

	If (nGerQuant+nGerQuant2Um+nValorGer) > 0
		IF li >= 52
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIf           

		If mv_par10 == 1
			@li ,000 Psay "Total Lucro Real       ---->"
			@li ,103 Psay nQtdTRB1		Picture "@E 999,999,999.99"
			@li ,144 Psay nVlrTRB1			Picture "@E 999,999,999,999.99" 
		ElseIf mv_par10 == 2
			@li ,000 Psay "Total Lucro Presumido  ---->"
			@li ,103 Psay nQtdTRB2			Picture "@E 999,999,999.99" 
			@li ,144 Psay nVlrTRB2			Picture "@E 999,999,999,999.99" 
		ElseIf mv_par10 == 3
			@li ,000 Psay "Total Optante Simples  ---->"
			@li ,103 Psay nQtdTRB3			Picture "@E 999,999,999.99" 
			@li ,144 Psay nVlrTRB3			Picture "@E 999,999,999,999.99" 
		ElseIf mv_par10 == 4	
			@li ,000 Psay "Total Lucro Real       ---->"
			@li ,103 Psay nQtdTRB1			Picture "@E 999,999,999.99" 
			@li ,144 Psay nVlrTRB1			Picture "@E 999,999,999,999.99" 
			li += 1		
			@li ,000 Psay "Total Lucro Presumido  ---->"		
			@li ,103 Psay nQtdTRB2			Picture "@E 999,999,999.99" 
			@li ,144 Psay nVlrTRB2			Picture "@E 999,999,999,999.99" 
			li += 1		
			@li ,000 Psay "Total Optante Simples  ---->"
			@li ,103 Psay nQtdTRB3			Picture "@E 999,999,999.99" 
			@li ,144 Psay nVlrTRB3			Picture "@E 999,999,999,999.99" 	
		Endif
		li += 2		
		@li ,000 Psay "Total Geral            ---->"
		@li ,103 Psay nGerQuant			Picture "@E 999,999,999.99" 
		@li ,123 Psay nGerQuant2Um		Picture "@E 999,999.999999"
		@li ,144 Psay nValorGer			Picture "@E 999,999,999,999.99"
		roda(cbcont,cbtxt,tamanho)
	EndIf	

	Wrk->(DbCloseArea())

	dbSelectArea("SD2")
	dbSetOrder(1)

	If aReturn[5] = 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Return .T.

/*_____________________________________________________________________________
¦ Função    ¦ PlFatR13b  ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 10/09/2009     ¦
+-----------+------------+-------+---------------------+------+----------------+
¦ Descriçäo ¦ Relação de producao Pelmex 		               					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlFatR13b(lEnd,WnRel,cString)

	Local lContinua	:= .T., dEmisAnt
	Local cQuery := ""
	Local tamanho:= "G"
	Local nTqtdEst, nTqtd2UmEst
	Local nTqtdGrp, nTqtd2UmGrp
	Local nTotQuant, nTotQuant2Um
	Local cabec1,cabec2

	cbtxt    := Space(10)
	cbcont   := 00
	li       := 80
	m_pag    := 01

	titulo := " RELACAO DE PRODUTOS PARA SUFRAMA - PRODUCAO"
	Cabec1 := "GRUPO  DESC.GRUPO                      PRODUTO          DESCRICAO                                       TIPO      QUANTIDADE  UM         QTD 2UM  2UM   EMISSAO"
	//         XXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          XX  999.999.999,99  UM  999.999,999999   UM  99/99/99
	// 0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
	// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	Cabec2 := " "

	cQuery := " SELECT D3_GRUPO, D3_COD, D3_TIPO, D3_EMISSAO, D3_QUANT, D3_UM,"
	cQuery += " CASE WHEN D3_QTSEGUM > '0'THEN D3_QTSEGUM ELSE CASE WHEN B1_TIPCONV = 'M' THEN D3_QUANT * B1_CONV ELSE CASE WHEN B1_TIPCONV = 'D' THEN D3_QUANT / B1_CONV END END END D3_QTSEGUM, D3_SEGUM " 
	cQuery += " FROM "+RetSqlName("SD3")+" SD3"
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_COD = D3_COD AND SB1.D_E_L_E_T_='' "
	cQuery += " WHERE SD3.D_E_L_E_T_ = '' "
	cQuery += " AND D3_FILIAL = '"+xFilial("SD3")+"' "
	cQuery += " AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
	cQuery += " AND D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " AND D3_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " AND D3_CC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	cQuery += " AND D3_TIPO = 'PA' " 
	cQuery += " AND D3_ESTORNO = '' " 
	//cQuery += " AND D3_COD NOT LIKE 'SUP%'" //MODIFICADO 11/01/2022
	cQuery += " AND LEFT(D3_CF,2) = 'PR' "
	cQuery += " ORDER BY D3_FILIAL+D3_GRUPO+D3_COD+D3_EMISSAO"

	cQuery:=ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"Wrk",.F.,.T.)
	TCSetField("Wrk","D3_EMISSAO","D",8,0)

	SetRegua(Wrk->(RecCount()))		// Total de Elementos da regua

	nTqtdEst	:= 0
	nTqtd2UmEst	:= 0

	While !Wrk->(Eof()) .and. lContinua

		If lEnd
			@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		EndIf

		IncRegua()

		cGrupo	:= Wrk->D3_GRUPO
		//Totalizadores do Grupo
		nTqtdGrp		:= 0
		nTqtd2UmGrp	:= 0

		While !Wrk->(Eof()) .and. Wrk->D3_GRUPO == cGrupo

			cProduto := Wrk->D3_COD
			//Totalizadores do Produto
			nTotQuant	:= 0
			nTotQuant2Um:=0

			While !Wrk->(Eof()) .and. Wrk->D3_GRUPO+Wrk->D3_COD == cGrupo+cProduto

				If li > 52
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				EndIf

				@Li,000 Psay Wrk->D3_GRUPO
				@Li,007 Psay Posicione("SBM",1,xFilial("SBM")+Wrk->D3_GRUPO,"BM_DESC")
				@Li,039 Psay Wrk->D3_COD
				@Li,056 Psay Posicione("SB1",1,xFilial("SB1")+Wrk->D3_COD,"B1_DESC")
				@Li,106 Psay Wrk->D3_TIPO
				@Li,110 Psay Wrk->D3_QUANT		Picture "@E 999,999,999.99" 
				@Li,126 Psay Wrk->D3_UM
				@Li,130 Psay Wrk->D3_QTSEGUM	Picture "@E 999,999.999999" 
				@Li,147 Psay Wrk->D3_SEGUM
				@Li,151 Psay Wrk->D3_EMISSAO

				li++

				nTotQuant	+= Wrk->D3_QUANT
				nTotQuant2Um+= Wrk->D3_QTSEGUM

				Wrk->(dbSkip())

			End		
			li++

			If (nTotQuant+nTotQuant2Um) > 0

				@Li,000 Psay "Totais do Produto "+cProduto
				@li,110 Psay nTotQuant		Picture "@E 999,999,999.99" 
				@li,130 Psay nTotQuant2Um	Picture "@E 999,999,999.99"
				li++

				@ Li,000 PSay __PrtThinLine()
				li += 2
			EndIf

			nTqtdGrp		+= nTotQuant
			nTqtd2UmGrp	+= nTotQuant2Um
		End

		If (nTqtdGrp+nTqtd2UmGrp) > 0

			@li,000 Psay "Totais do Grupo "+cGrupo
			@li,110 Psay nTqtdGrp		Picture "@E 999,999,999.99" 
			@li,130 Psay nTqtd2UmGrp	Picture "@E 999,999.999999"
			li++

			@ Li,000 PSay __PrtThinLine()
			li+=2
		EndIf

		nTqtdEst		+= nTqtdGrp
		nTqtd2UmEst	+= nTqtd2UmGrp
	End

	If (nTqtdEst+nTqtd2UmEst) > 0
		IF li >= 52
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIf

		@li ,000 Psay "Total Geral            ---->"
		@li ,110 Psay nTqtdEst			Picture "@E 999,999,999.99" 
		@li ,130 Psay nTqtd2UmEst		Picture "@E 999,999.999999"

		roda(cbcont,cbtxt,tamanho)
	EndIf	

	Wrk->(DbCloseArea())

	dbSelectArea("SD3")
	dbSetOrder(1)

	If aReturn[5] = 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Return .T.

/*______________________________________________________________________________
¦ Função    ¦ PlFatR13c  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 10/09/2009¦
+-----------+------------+-------+--------------------------+------+-----------+
¦ Descriçäo ¦ Tela para seleção do tipo de relatorio a ser gerado. De vendas ou¦
¦           ¦ producao.                                                        ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlFatR13c()

	@ 000, 000 To 160,150 Dialog oTela Title OemToAnsi("Relatorio de ....") 

	@ 010, 010 To 050,070 Title "Tipo"
	@ 025, 025 Radio aRadio Var nRadio

	@ 060, 010 BmpButton Type 01 Action (nOpc:= 1,oTela:End())
	@ 060, 040 BmpButton Type 02 Action (nOpc:= 0,oTela:End())

	Activate Dialog oTela Centered                                                       

Return

/*_____________________________________________________________________________
¦ Função    ¦ PergVendas ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 02/09/2009     ¦
+-----------+------------+-------+---------------------+------+----------------+
¦ Descriçäo ¦ Grupo de perguntas para relatorio de vendas    					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PergVendas()

	u_InPutSX1(cPerg,"01","Data Inicial    ?","","","mv_ch1","D",08,0,0,"G","",""   ,"","","mv_par01")
	u_InPutSX1(cPerg,"02","Data Final      ?","","","mv_ch2","D",08,0,0,"G","",""   ,"","","mv_par02")
	u_InPutSX1(cPerg,"03","Do Produto      ?","","","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03")
	u_InPutSX1(cPerg,"04","Ate o Produto   ?","","","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04")
	u_InPutSX1(cPerg,"05","Do Grupo        ?","","","mv_ch5","C",04,0,0,"G","","SBM","","","mv_par05")
	u_InPutSX1(cPerg,"06","Ate o Grupo     ?","","","mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06")
	u_InPutSX1(cPerg,"07","Do Cliente      ?","","","mv_ch7","C",06,0,0,"G","","CLI","","","mv_par07")
	u_InPutSX1(cPerg,"08","Ate o Cliente   ?","","","mv_ch8","C",06,0,0,"G","","CLI","","","mv_par08")
	u_InPutSX1(cPerg,"09","Estado          ?","","","mv_ch9","N",01,0,0,"C","",""   ,"","","mv_par09","Dentro do Estado","","","","Fora do Estado","","","Ambos")
	u_InPutSX1(cPerg,"10","Filtrar Por     ?","","","mv_chA","N",01,0,0,"C","",""   ,"","","mv_par10","Lucro Real ","","","","Lucro Presumido","","","Optante Simples","","","Todos")
	u_InPutSX1(cPerg,"11","Do TES          ?","","","mv_chB","C",03,0,0,"G","","SF4","","","mv_par11")
	u_InPutSX1(cPerg,"12","Ate a TES       ?","","","mv_chC","C",03,0,0,"G","","SF4","","","mv_par12")

Return

/*_____________________________________________________________________________
¦ Função    ¦ PergProduc ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 02/09/2009     ¦
+-----------+------------+-------+---------------------+------+----------------+
¦ Descriçäo ¦ Grupo de perguntas para relatorio de producao  					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PergProduc()

	u_InPutSX1(cPerg,"01","Data Inicial    ?","","","mv_ch1","D",08,0,0,"G","",""   ,"","","mv_par01")
	u_InPutSX1(cPerg,"02","Data Final      ?","","","mv_ch2","D",08,0,0,"G","",""   ,"","","mv_par02")
	u_InPutSX1(cPerg,"03","Do Produto      ?","","","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03")
	u_InPutSX1(cPerg,"04","Ate o Produto   ?","","","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04")
	u_InPutSX1(cPerg,"05","Do Grupo        ?","","","mv_ch5","C",04,0,0,"G","","SBM","","","mv_par05")
	u_InPutSX1(cPerg,"06","Ate o Grupo     ?","","","mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06")
	u_InPutSX1(cPerg,"07","C.Custo de      ?","","","mv_ch7","C",09,0,0,"G","","CTT","","","mv_par07")
	u_InPutSX1(cPerg,"08","C.Custo ate     ?","","","mv_ch8","C",09,0,0,"G","","CTT","","","mv_par08")

Return

