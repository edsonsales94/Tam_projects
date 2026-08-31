#INCLUDE "MATR780.CH"
#INCLUDE "FIVEWIN.CH"

/*___________________________________________________________________________________
¦ Função    ¦ PLFATR12   ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 04/06/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Ranking de Vendas por Cliente                  					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PlFatR12()

	LOCAL wnrel
	LOCAL tamanho:="M"
	LOCAL titulo := OemToAnsi(STR0001)	//"Estatisticas de Vendas (Cliente x Produto)"
	LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
	LOCAL cDesc2 := OemToAnsi(STR0003)	//"totalizando por produto e escolhendo a moeda forte para os Valores."
	LOCAL cDesc3 := ""
	LOCAL cString:= "SD2"

	PRIVATE aReturn := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
	PRIVATE nomeprog:=PadR("PLFATR12",Len(SX1->X1_GRUPO))
	PRIVATE nLastKey := 0
	PRIVATE cPerg   :="FATR12"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ValidPerg(cPerg)
	pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // De Cliente                           ³
	//³ mv_par02             // Ate Cliente                          ³
	//³ mv_par03             // De Data                              ³
	//³ mv_par04             // Ate a Data                           ³
	//³ mv_par05             // De Produto                           ³
	//³ mv_par06             // Ate o Produto                        ³
	//³ mv_par07             // Do Grupo                              ³
	//³ mv_par08             // Ate Grupo                            ³
	//³ mv_par09             // Inclui Devolu‡„o                     ³
	//³ mv_par10	// Quanto a Estoque Movimenta/Nao Movta/Ambos    ³
	//³ mv_par11	// Quanto a Duplicata Gera/Nao Gera/Ambos        ³
	//³ mv_par12   // Quanto a Devolucao NF Original/NF Devolucao    ³
	//³ mv_par13   // Quanto a Descricao  Produto  Prod x Cli.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	titulo := "RANKING DE VENDAS POR CLIENTES - PERIODO DE "+dtoc(mv_par03)+" A "+dtoc(mv_par04)
	Cabec1 := "CLIENTE   RAZAO SOCIAL"
	Cabec2 := "PRODUTO         DESCRICAO                                            UN      QUANTIDADE    PRECO UNITARIO               TOTAL"
	// 123456789012345 123456789012345678901234567890 123456/123 12/12/1234 12  12345678901234  1234567890123456    1234567890123456
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	// 00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222
	// 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111
	wnrel:="PLFATR12"

	wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.T.)

	If nLastKey==27
		dbClearFilter()
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey==27
		dbClearFilter()
		Return
	Endif

	RptStatus({|lEnd| PlFatR12a(@lEnd,wnRel,cString)},Titulo)

Return

/*___________________________________________________________________________________
¦ Função    ¦ PLFATR12a  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 04/06/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Chamada do Relatório                           					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlFatR12a(lEnd,WnRel,cString)

	LOCAL CbTxt
	LOCAL CbCont,cabec1,cabec2,cabec3
	LOCAL nTotCli1:= 0,nTotCli2:=0,nTotGer1 := 0,nTotGer2 := 0
	LOCAL nOrdem
	LOCAL tamanho:= "M"
	LOCAL limite := 132
	LOCAL titulo := OemToAnsi(STR0006)	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
	LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
	LOCAL cDesc2 := OemToAnsi(STR0003)	//"totalizando por produto e escolhendo a moeda forte para os Valores."
	LOCAL cDesc3 := ""
	LOCAL cMoeda
	LOCAL nAcN1  := 0, nAcN2 := 0, nV := 0
	LOCAL cClieAnt := "", cProdAnt := "", cLojaAnt := ""
	LOCAL lContinua := .T. , lProcessou := .F. , lNewProd := .T.
	LOCAL cMascara :=GetMv("MV_MASCGRD")
	LOCAL cProdRef :=""
	Local cUM      :=""
	LOCAL nTotQuant:=0
	LOCAL nReg     :=0
	LOCAL cFiltro  := ""
	Local cEstoq := If( (mv_par10 == 1),"S",If( (mv_par10 == 2),"N","SN" ))
	Local cDupli := If( (mv_par11 == 1),"S",If( (mv_par11 == 2),"N","SN" ))
	Local cArqTrab1, cArqTrab2, cCondicao1
	Local aDevImpr := {}
	Local cVends   := ""
	Local nDevQtd 	:=0
	Local nDevVal 	:=0
	Local aDev		:={}
	Local nIndD2    :=0
	Local cQuery, aStru
	Local lNfD2Ori   := .F.
	// variaveis criadas para realinhamento das colunas para o Mexico (factura com 20 digitos)
	Local aColuna   := {46,61,69,73,89,109,125}
	Local nj := 0
	Local cAliasSA1 := "SA1"

	Private cSD1, cSD2
	Private nIndD1  :=0

	SF1->(dbsetorder(1))
	SF2->(dbsetorder(1))
	SB1->(dbSetOrder(1))
	SA7->(dbSetOrder(2))

	titulo := "RANKING DE VENDAS POR CLIENTES - PERIODO DE "+dtoc(mv_par03)+" A "+dtoc(mv_par04)
	Cabec1 := "CLIENTE   RAZAO SOCIAL"
	Cabec2 := "PRODUTO         DESCRICAO                                            UN      QUANTIDADE    PRECO UNITARIO               TOTAL"
	// 123456789012345 123456789012345678901234567890 123456/123 12/12/1234 12  12345678901234  1234567890123456    1234567890123456
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
	// 00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222
	// 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt    := SPACE(10)
	cbcont   := 0
	li       := 80
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria filtro para impressao das devolucoes                    ³
	//³ *** este filtro possui 208 posicoes  ***                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	cArqTrab1  := CriaTrab( "" , .F. )

	cSD1   := "SD1TMP"
	aStru  := dbStruct()
	cQuery := "SELECT * FROM " + RetSqlName("SD1") + " SD1 "
	cQuery += "WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
	cQuery += "SD1.D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQuery += "SD1.D1_DTDIGIT BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+ "' AND "
	cQuery += "SD1.D1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	cQuery += "SD1.D1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
	cQuery += "SD1.D1_TIPO = 'D' AND "
	cQuery += " NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ") AND "
	cQuery += "SD1.D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_GRUPO,SD1.D1_COD"
	cQuery := ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD1TRB', .F., .T.)},OemToAnsi(STR0011)) //"Seleccionado registros"
	For nj := 1 to Len(aStru)
		If aStru[nj,2] != 'C'
			TCSetField('SD1TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
		EndIf
	Next nj
	PlFatR12c(cArqTrab1, aStru, cSD1, "SD1TRB")
	IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_GRUPO+D1_COD",,".T.",STR0011)		//"Selecionando Registros..."

	dbSeek(xFilial("SD1"))

	DbSelectArea("SD2")

	cArqTrab2  := CriaTrab( "" , .F. )

	cSD2   := "SD2TMP"
	aStru  := dbStruct()

	cQuery := "SELECT D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_GRUPO, D2_COD, D2_UM, Sum(D2_QUANT) As D2_QUANT, Sum(D2_TOTAL) As D2_TOTAL, Avg(D2_PRCVEN) As D2_PRCVEN"
	cQuery += " FROM " + RetSqlName("SD2") + " SD2"
	cQuery += ", " + RetSqlName("SF4") + " SF4"
	cQuery += ", " + RetSqlName("SA1") + " SA1"
	cQuery += " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND SD2.D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
	cQuery += " AND SD2.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"'"
	cQuery += " AND SD2.D2_GRUPO   BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQuery += " AND SD2.D2_TIPO = 'N'"
	cQuery += " AND  NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ")"
	cQuery += " AND SD2.D_E_L_E_T_ <> '*'"

	cQuery += " AND SF4.D_E_L_E_T_ <> '*'"
	cQuery += " AND D2_TES = F4_CODIGO"

	cQuery += " AND A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " AND D2_CLIENTE >= '"        +MV_PAR01+"'"
	cQuery += " AND D2_CLIENTE <= '"        +MV_PAR02+"'"
	cQuery += " AND SA1.D_E_L_E_T_ = ' '"
	cQuery += " AND D2_CLIENTE = A1_COD"
	cQuery += " AND D2_LOJA = A1_LOJA"

	If Mv_Par10 == 1
		cQuery += " AND F4_ESTOQUE = 'S'"
	ElseIf Mv_Par10 == 2
		cQuery += " AND F4_ESTOQUE = 'N'"
	End If

	If Mv_Par11 == 1
		cQuery += " AND F4_DUPLIC = 'S'"
	ElseIf Mv_Par11 == 2
		cQuery += " AND F4_DUPLIC = 'N'"
	End If

	cQuery += " GROUP BY D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_GRUPO, D2_COD, D2_UM"

	If Mv_Par14 == 1
		cQuery += " ORDER BY D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_GRUPO, D2_QUANT Desc"
	ELse
		cQuery += " ORDER BY D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_GRUPO, D2_TOTAL Desc"
	End If

	cQuery := ChangeQuery(cQuery)

	MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD2TRB', .F., .T.)},OemToAnsi(STR0011)) //"Seleccionado registros"
	For nj := 1 to Len(aStru)
		If aStru[nj,2] != 'C'
			TCSetField('SD2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
		EndIf
	Next nj

	//PlFatR12c(cArqTrab2, aStru, cSD2, "SD2TRB")

	SetRegua(200)		// Total de Elementos da regua

	While !SD2TRB->(EOF())

		If lEnd
			@Prow()+1,001 Psay STR0012	//"CANCELADO PELO OPERADOR"
			Exit
		EndIf

		lNewCli := .T.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem da quebra do relatorio por  Cliente             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cClieAnt := SD2TRB->D2_CLIENTE
		cLojaAnt := SD2TRB->D2_LOJA
		lNewProd := .T.
		lNewCli  := .T.
		nTotCli1 := 0
		nTotCli2 := 0

		While !Eof() .and. (SD2TRB->(D2_FILIAL+D2_CLIENTE+D2_LOJA)) == (xFilial("SD2")+cClieAnt+cLojaAnt)

			If Li > 70
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				lProcessou := .T.
			EndIf

			If lNewCli
				SA1->(dBseek(xFilial()+SD2TRB->D2_CLIENTE+SD2TRB->D2_LOJA))
				@ Li,000 Psay Repli('-',limite)
				Li++
				@ Li,000 Psay SD2TRB->D2_CLIENTE+"   "+SA1->A1_NOME
				If !Empty(SA1->A1_OBSERV)
					Li++
					@ Li,000 Psay STR0013+SA1->A1_OBSERV		//"Obs.: "
				EndIf
				Li++
				@ Li,000 Psay Repli('-',limite)
				Li+=2
				lNewCli := .F.
			EndIf

			@Li, 000 Psay "GRUPO : "+SD2TRB->D2_GRUPO
			Li+=2

			cGrupAnt := SD2TRB->D2_GRUPO
			nAcN1 := 0 // Qtd Total Grupo
			nAcN2 := 0 // Vlr Total Grupo

			//Grupo
			While !Eof() .and. SD2TRB->(D2_FILIAL + D2_CLIENTE + D2_LOJA  + D2_GRUPO) = ;
			(xFilial("SD2")+cClieAnt+cLojaAnt+cGrupAnt)

				If Li > 70
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					@ Li, 000 Psay "Continuacao......"
					Li++
				Endif

				cProdAnt := SD2TRB->D2_COD
				nPrcUnit := 0
				nQtde    := 0
				nPrcTot  := 0

				IncRegua()

				nPrcUnit := SD2TRB->D2_PRCVEN
				nQtde    := SD2TRB->D2_QUANT
				nPrcTot  := SD2TRB->D2_TOTAL
				cUM		 := SD2TRB->D2_UM

				SB1->(dbSeek(xFilial("SB1")+SD2TRB->D2_COD))

				If mv_par13 = 1
					@li , 16 Psay Substr(SB1->B1_DESC,1,50) //28
				Else
					If SA7->(dbSeek(xFilial("SA7")+SD2TRB->(D2_COD+D2_CLIENTE+D2_LOJA)))
						@li , 16 Psay Substr(SA7->A7_DESCCLI,1,30)
					Else
						@li , 16 Psay Substr(SB1->B1_DESC,1,50) //28
					Endif
				EndIf

				nDevQtd :=0
				nDevVal :=0

				If mv_par09 == 1 //inclui Devolucoes
					PlFatR12b(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli)
				EndIf

				@Li , aColuna[3] Psay cUM
				@Li , aColuna[4] Psay nQtde PICTURE PesqPictqt("D2_QUANT",14)
				nAcN1 += nQtde

				@Li , aColuna[5] Psay nPrcUnit    PICTURE PesqPict("SD2","D2_PRCVEN",14)
				@Li , aColuna[6] Psay nPrcTot     PICTURE PesqPict("SD2","D2_TOTAL",16)
				nAcN2 += nPrcTot


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime as devolucoes do produto selecionado             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nDevQtd!=0
					Li++
					@Li,053 Psay STR0017 // "DEV"
					@Li,aColuna[3] Psay cUM
					@Li,aColuna[4] Psay nDevQtd          PICTURE "@)"+PesqPictqt("D2_QUANT",14)
					@Li,aColuna[6] Psay nDevVal          PICTURE "@)"+PesqPict("SD2","D2_TOTAL",16)
					nAcN1+= nDevQtd
					nAcN2+= nDevVal
				EndIf
				Li++

				SD2TRB->(dbSkip())

			End	//Grupo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acumula o total geral do relatorio                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotGer1 += nAcN1
			nTotGer2 += nAcN2

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acumula o total por cliente                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotCli1 += nAcN1
			nTotCli2 += nAcN2

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime o total do produto selecionado                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Li++
			@Li ,  07 Psay "TOTAL DO GRUPO "+cGrupAnt	//"TOTAL DO PRODUTO - "
			@Li ,  52 Psay "---->"
			@Li , aColuna[3] Psay cUM
			@Li , aColuna[4] Psay nAcN1 PICTURE PesqPictqt("D2_QUANT",14)
			@Li , aColuna[6] Psay nAcN2 PICTURE PesqPict("SD2","D2_TOTAL",16)
			Li+=2
			nAcN1 := 0
			nAcN2 := 0

		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ocorreu quebra por cliente                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		LI+=2
		@Li , 07 Psay STR0015+cClieAnt+'/'+cLojaAnt	//"TOTAL DO CLIENTE - "
		@Li , 52 Psay "---->"
		@Li ,aColuna[4] Psay nTotCli1 PICTURE PesqPictqt("D2_QUANT",16)
		@Li ,aColuna[6] Psay nTotCli2 PICTURE PesqPict("SD2","D2_TOTAL",18)
		LI++

		cClieAnt := ""
		cLojaAnt := ""
		nTotCli1 := 0
		nTotCli2 := 0

	End

	If lProcessou
		If li > 70
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIf
		Li+=2
		@Li , 07 Psay STR0016		//"T O T A L   G E R A L                        ---->"
		@Li ,aColuna[4] Psay nTotGer1 PICTURE "@)"+PesqPictqt("D2_QUANT",16)
		@Li ,aColuna[6] Psay nTotGer2 PICTURE "@)"+PesqPict("SD2","D2_TOTAL",18)
		roda(cbcont,cbtxt,tamanho)
	Endif

	dbSelectArea("SD1")
	dbClearFilter()
	RetIndex("SD1")

	dbSelectArea("SD2")
	dbClearFilter()
	RetIndex("SD2")

	(cSD1)->(DbCloseArea())
	SD2TRB->(DbCloseArea())
	fErase(cArqTrab1+OrdBagExt())
	fErase(cArqTrab2+OrdBagExt())

	fErase(cArqTrab1+GetDbExtension())
	fErase(cArqTrab2+GetDbExtension())

	If aReturn[5] = 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	EndIf

	MS_FLUSH()

Return .T.



/*___________________________________________________________________________________
¦ Função    ¦ PLFATR12b  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 04/06/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Soma devoluções de venda                       					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlFatR12b(nDevQtd, nDevVal, aDev, cEstoq, cDupli )

	If (cSD1)->(dbSeek(xFilial("SD1")+SD2TRB->(D2_CLIENTE+D2_LOJA+D2_GRUPO+D2_COD )))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Soma Devolucoes          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While (cSD1)->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_GRUPO+D1_COD) == SD2TRB->( xFilial("SD2")+D2_CLIENTE+D2_LOJA+D2_GRUPO+D2_COD).AND.!(cSD1)->(Eof())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Avalia TES                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
				(cSD1)->(dbSkip())
				Loop
			Endif

			SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))

			If (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) == SD2TRB->(D2_DOC   + D2_SERIE   + D2_ITEM )

				Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
				nDevQtd -= (cSD1)->D1_QUANT
				nDevVal -=(cSD1)->(D1_TOTAL-D1_VALDESC)

			ElseIf mv_par12 == 2 .And. (cSD1)->D1_DTDIGIT < SD2TRB->D2_EMISSAO .And.;
			(cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) < ;
			SD2TRB->(D2_DOC   + D2_SERIE   + D2_ITEM ) .And.;
			Ascan(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI))) == 0

				Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
				nDevQtd -= (cSD1)->D1_QUANT
				nDevVal -=(cSD1)->(D1_TOTAL-D1_VALDESC)

			EndIf

			(cSD1)->(dbSkip())

		End

	EndIf
Return .t.

/*___________________________________________________________________________________
¦ Função    ¦ PLFATR12c  ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 04/06/2008     ¦
+-----------+------------+-------+--------------------------+------+----------------+
¦ Descriçäo ¦ Cria temporário a partir da consulta corrente  					    ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PlFatR12c(cArqTmp, aStruTmp, cAliasTmp, cAlias)
	Local nI, nF, nPos
	Local cFieldName := ""
	nF := (cAlias)->(Fcount())
	dbCreate(cArqTmp,aStruTmp)
	DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
	(cAlias)->(DbGoTop())
	While ! (cAlias)->(Eof())
		(cAliasTmp)->(DbAppend())
		For nI := 1 To nF
			cFieldName := (cAlias)->( FieldName( ni ))
			If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
				(cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
			EndIf
		Next
		(cAlias)->(DbSkip())
	End
	(cAlias)->(dbCloseArea())
	DbSelectArea(cAliasTmp)
Return Nil

Static Function ValidPerg()
	u_InPutSX1(cPerg,"01","De Cliente			?","","","mv_ch1","C",06,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","Ate Cliente			?","","","mv_ch2","C",06,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03","De Data				?","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04","Ate a Data			?","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05","De Produto			?","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06","Ate o Produto		?","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07","Do Grupo				?","","","mv_ch7","C",04,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08","Ate Grupo			?","","","mv_ch8","C",04,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09","Inclui Devolucao		?","","","mv_ch9","N",01,0,0,"C","","","","","mv_par09","Sim","","","","Nao")
	u_InPutSX1(cPerg,"10","Quanto a Estoque		?","","","mv_chA","N",01,0,0,"C","","","","","mv_par10","Movimenta","","","","Nao Movimenta","","","Ambos")
	u_InPutSX1(cPerg,"11","Quanto a Duplicata	?","","","mv_chB","N",01,0,0,"C","","","","","mv_par11","Gera","","","","Nao Gera","","","Ambos")
	u_InPutSX1(cPerg,"12","Quanto a Devolucao	?","","","mv_chC","N",01,0,0,"C","","","","","mv_par12","NF Original","","","","NF Devolucao")
	u_InPutSX1(cPerg,"13","Quanto a Descricao	?","","","mv_chD","N",01,0,0,"C","","","","","mv_par13","Produto","","","","Prod x Cliente")
	u_InPutSX1(cPerg,"14","Ordenar por			?","","","mv_chE","N",01,0,0,"C","","","","","mv_par14","Quantidade","","","","Valor")

Return
