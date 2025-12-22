#INCLUDE "rwmake.ch"

User Function RES_DET()
	Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2     := "de acordo com os parametros informados pelo usuario."
	Local cDesc3     := "Resumo de Caixa Detalhado     "
	Local titulo     := "Resumo de Caixa Detalhado     "
	Local nLin       := 80
	Local Cabec1     := ""
	Local Cabec2     := ""
	Local aOrd       := {}
	Local cPerg      := PADR("RDET"+SM0->M0_CODFIL,Len(SX1->X1_GRUPO))
	
	Private Limite   := 220
	Private tamanho  := "G"
	Private nomeprog := "RDET"+SM0->M0_CODFIL // Coloque aqui o nome do programa para impressao no cabecalho
	Private nLin     := 70
	Private nTipo    := 15
	Private aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey := 0
	Private m_pag    := 01
	Private wnrel    := "RDET"+SM0->M0_CODFIL // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString  := "SE1"
	
	ValidPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	Endif
	
	SE1->(dbSetOrder(1))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Titulo := AllTrim(Titulo)+" - Data: "+Dtoc(mv_par01)
        Cabec2 := ""
        Cabec1 := "Orcam   Res  Tp  Prf Num.       Vencimento         Valor  Pc  Cliente                      Caixa                Vendedor"
	      //   xxxxxx  xxx  xxx xxx xxxxxxxxx  99/99/9999  9,999,999.99  xx  xxxxxx / xx xxxxxxxxxxxxxxx  xxx xxxxxxxxxxxxxxx  xxxxxx xxxxxxxxxxxxxxx
	      //   000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111
	      //   000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233
	      //   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/01/07   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local cQry, cTipo, cOrcam, lSkip, cTrb, nItens, nPos
	Local nValTOT := 0
	Local nValCR  := 0	
	Local cTipos  := "CC#CD#FI"
	Local nTotGer := 0
	Local aTipos  := {}
	Local aFecham := {}
	
	Private cCX1    := If( Empty(MV_PAR02) , "ZZZ", MV_PAR02)
	Private cCX2    := If( Empty(MV_PAR03) , "ZZZ", MV_PAR03)
	Private cCX3    := If( Empty(MV_PAR04) , "ZZZ", MV_PAR04)
	Private cCX4    := If( Empty(MV_PAR05) , "ZZZ", MV_PAR05)
	Private cCX5    := If( Empty(MV_PAR06) , "ZZZ", MV_PAR06)
	
	SE1->(DbSetOrder(1))
	SA1->(DbSetOrder(1))
	SA3->(DbSetOrder(1))
	SA6->(DbSetOrder(1))
	SL1->(DbSetOrder(2))
	
	// Retirado da Consulta a Condicao E1.D_E_L_E_T_ <> '*' para pegar os registros deletados da venda com reserva pois quando
	// se gera venda para as COndicoes do parametro MV_XFORMC o P.E. LJ7002 deleta esses registros pois os mesmos sao faturado no destino
	// Nunca, Jamais em Hipótese nenhuma colocar esta condicao na consulta
	// Desde ja agradeco pela compreensao Ass.: Marcel Contato:8423-4908
	
	cQry := FiltraTit(.T.)  // Filtra as vendas normais
	cQry += " UNION "
	cQry += FiltraTit(.F.)  // Filtra as vendas reserva
	cQry += " ORDER BY L1_ESTACAO,  L1_NUM, E1_TIPO, E1_PREFIXO,  E1_NUM, E1_PARCELA"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRE", .T., .F. )
	
	TCSetField("TRE","E1_VENCREA","D",8,0)
	
	dbGoTop()
	
	// Caso tenha encontrado registros
	If !TRE->(Eof())
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		@ nLin, 00 PSAY "Data de Fechamento : "+ DTOC(MV_PAR01)
		nLin := nLin + 2
	Endif
	
	While !TRE->(EOF())
		
		cEstacao:= TRE->L1_ESTACAO
		nValEst := 0
		
		
		While !TRE->(EOF()) .And. TRE->L1_ESTACAO == cEstacao

		cOrcam  := TRE->L1_NUM
		nValTot := 0
		nItens  := 0

		While !TRE->(EOF()) .And. TRE->L1_NUM == cOrcam
			
			SA1->(DbSeek(xFilial("SA1")+TRE->(E1_CLIENTE+E1_LOJA)))
			SA3->(DbSeek(xFilial("SA3")+TRE->E1_VEND1))
			SA6->(DbSeek(xFilial("SA6")+TRE->E1_PORTADO))
			SE1->(DbSeek(xFilial("SE1")+TRE->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)))
			
			If nLin > 60  // Salto de Página. Neste caso o formulario tem 60 linhas...
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif

			@nLin,000 PSAY L1_NUM

			If Trim(E1_TIPO) $ cTipos
				cTipo   := E1_TIPO
				cTrb    := "SE1"
				lSkip   := .F.
				nValor  := 0
				nNumPar := 0
				cNum    := E1_PREFIXO+E1_NUM
				
				While !EOF() .And. L1_NUM+E1_TIPO+E1_PREFIXO+E1_NUM == cOrcam+cTipo+cNum
					nValor   += E1_VLRREAL
					nValEst  += E1_VLRREAL
					nNumPar++
					TRE->(DbSkip())
				EndDo
				
				nNumPar := Str(nNumPar,Len(SE1->E1_PARCELA))
			Else
				cTipo   := TRE->E1_TIPO
				cTrb    := "TRE"
				lSkip   := .T.
				nValor  := E1_VALOR
				nValEst += E1_VALOR
				nNumPar := TRE->E1_PARCELA
			Endif
			//BLA
			@nLin,PCol()+1 PSAY TRE->L1_XRESERV
			@nLin,PCol()+1 PSAY cTipo
			@nLin,PCol()+1 PSAY (cTrb)->E1_PREFIXO'
			@nLin,PCol()+1 PSAY (cTrb)->E1_NUM
			@nLin,PCol()+2 PSAY (cTrb)->E1_VENCREA
			@nLin,PCol()+2 PSAY Transform(nValor,"@E 9,999,999.99")
			@nLin,PCol()+2 PSAY nNumPar
			@nLin,PCol()+2 PSAY SA1->(A1_COD+" / "+A1_LOJA)
			@nLin,PCol()+1 PSAY PADR(SA1->A1_NOME,15)
			@nLin,PCol()+2 PSAY SA6->A6_COD
			@nLin,PCol()+1 PSAY PADR(SA6->A6_NOME,15)
			@nLin,PCol()+2 PSAY SA3->A3_COD
			@nLin,PCol()+1 PSAY PADR(SA3->A3_NOME,15)
			nLin++
			
			If Alltrim(cTipo) <> "CR"
				nValTot += nValor
				
				// Totaliza por Tipo
				nPos := AScan( aTipos , {|x| x[1] == cTipo .AND. x[4] == TRE->L1_XRESERV .and.  x[5] == TRE->L1_ESTACAO })
				If nPos == 0
					AAdd( aTipos , { cTipo, "S", 0, TRE->L1_XRESERV, TRE->L1_ESTACAO})
					nPos := Len(aTipos)
				Endif
				aTipos[nPos,3] += nValor

				nPos := AScan( aFecham , {|x| x[1] == TRE->L1_XRESERV .AND. X[3] == TRE->L1_ESTACAO })
				If nPos == 0
					AAdd( aFecham , { TRE->L1_XRESERV, 0,  TRE->L1_ESTACAO})
					nPos := Len (aFecham )
				Endif
				aFecham [nPos,2] += nValor
			
			Else
				nValCR  += nValor
			Endif
			nItens++
			
			If lSkip
				TRE->(dbSkip())
			Endif
		EndDo
		
		If nVALTOT > 0
			If nItens > 1  // Caso tenha impresso mais de uma linha por orçamento
				@nLin,010 PSAY "Sub-Valor : "
				@nLin,037 PSAY Transform(nVALTOT,"@E 999,999,999.99")
				nLin++
			Endif
			nLin++
			nTotGer += nValTot
		Endif

		Enddo

		iF nValEst > 0
				@nLin,010 PSAY "Sub-Valor Caixa: " + cEstacao
				@nLin,050 PSAY Transform(nValEst,"@E 999,999,999.99")
				nLin++
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		ENDIF
		
	Enddo
	dbCloseArea()
	
	If nTotGer > 0 
		nLin++
		@nLin,010 PSAY "Valor do Fechamento: "
		ASORT( aFecham, , , { | x,y | x[3]+x[1] > y[3]+y[1] } )
		
		FOR NX:=1 TO LEN(aFecham )
			IF aFecham[NX][1]='02'
				_cxEmps := "IND SUCATA  "
			ELSEIF aFecham[NX][1]='03'
				_cxEmps := "IND SILVES  "
			ELSEIF aFecham[NX][1]='04'
				_cxEmps := "IND ALVORADA"
			ELSEIF aFecham[NX][1]='05'
				_cxEmps := "DEP SILVES  "
			ELSEIF aFecham[NX][1]='03'
				_cxEmps := "DEP ALVORADA"
			ELSE
				 If FWCodEmp() == "06"
					_cxEmps := "COMERCIO DE A�O  "
				 ElseIf FWCodEmp() == "05"
				 	_cxEmps := "COMERCIO DE FERRO"
				 Else
				 	_cxEmps := "EMPRESA NAO CLASS. "
				 End
			ENDIF

			@nLin,037 PSAY aFecham[NX][3] + "# " +aFecham[NX][1] + "-" + _cxEmps + "->" + Transform(aFecham[NX][2],"@E 999,999,999.99")
			nLin += 1
		NEXT  NX
		nLin += 1
		@nLin,000 PSAY "Valor de Creditos/Trocas no Dia: "
		@nLin,037 PSAY Transform(nVALCR,"@E 999,999,999.99")
		nLin += 2

		nValCancel := 0
		If(nVALCancel > 0)
			@nLin,000 PSAY "Valor de Cancelamentos no Dia: "
			@nLin,037 PSAY Transform(nValCancel,"@E 999,999,999.99")
			nLin += 2
		Endif

		// Totaliza por TIPO o valor das Devoluções
		cQry := "SELECT E5_PREFIXO LG_NOMCOMP, SE5.E5_TIPO, SL12.L1_XRESERV, SUM(SE5.E5_VALOR) AS E5_VALOR"
		cQry += " FROM "+RetSQLName("SE5")+" SE5"
		//reserva?
		cQry += " INNER JOIN "+RetSQLName("SL1")+" SL1 ON L1_DOCPED = E5_NUMERO AND L1_SERPED = E5_PREFIXO 
		cQry += " INNER JOIN "+RetSQLName("SL1")+" SL12 ON SL12.L1_ORCRES = SL1.L1_NUM AND SL12.L1_FILRES = SL1.L1_FILIAL 
		cQry += " INNER JOIN "+RetSQLName("SLG")+" SLG (NOLOCK) ON SLG.D_E_L_E_T_ = '' "
		cQry += " AND SL1.L1_FILIAL = SLG.LG_FILIAL AND SLG.LG_SERIE = SL1.L1_SERPED "

		cQry += " WHERE SE5.E5_DATA = '"+Dtos(mv_par01)+"'"
		cQry += " AND SE5.E5_RECPAG = 'P'"
		cQry += " AND SE5.E5_TIPODOC IN ('TR','  ','VL','ES','LJ')"
		cQry += " AND SE5.E5_HISTOR <> 'Estorno de transferencia.'"
		cQry += " AND SE5.E5_NATUREZ = 'DEV./TROCA'"
		cQry += " AND SE5.E5_SITUACA <> 'C'"
		cQry += " AND SE5.E5_BANCO IN "+FormatIn(cCX1+","+cCX2+","+cCX3+","+cCX4+","+cCX5,",")
		cQry += " AND SE5.D_E_L_E_T_ = ' '"
		cQry += " GROUP BY SE5.E5_TIPO, SL12.L1_XRESERV, E5_PREFIXO "
		cQry += " ORDER BY SE5.E5_TIPO"
		dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRE", .T., .F. )
		While !Eof()
			AAdd( aTipos , { E5_TIPO, "D", -E5_VALOR, L1_XRESERV, LG_NOMCOMP })
			dbSkip()
		Enddo
		dbCloseArea()
		
		ASort( aTipos ,,, {|x,y| x[5]+x[4]+x[1]+x[2] < Y[5]+y[4]+y[1]+y[2] } )  // Ordena por Tipo
		lImp := .T.
		For x:=1 To Len(aTipos)
			If nLin > 60  // Salto de Página. Neste caso o formulario tem 60 linhas...
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				lImp := .T.
			Endif
			If lImp
				@ nLin,000 PSAY "Tipo S/D          Valor      Estacao" ; nLin++
				@ nLin,000 PSAY "------------------------------------" ; nLin++
				lImp := .F.
			Endif
			@ nLin,000      PSAY aTipos[x,1]
			@ nLin,PCol()+2 PSAY aTipos[x,4]
			@ nLin,PCol()+3 PSAY aTipos[x,2]
			@ nLin,PCol()+4 PSAY aTipos[x,3]  Picture "@E 999,999,999.99"
			@ nLin,PCol()+6 PSAY aTipos[x,5]
			nLin++
		Next
	Endif
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return()

Static Function FiltraTit(lFiscal)
	Local cQry
	
	cQry := "SELECT E1_PREFIXO L1_ESTACAO,E1_TIPO, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_VENCREA, E1_CLIENTE, E1_LOJA, E1_VALOR, E1_VLRREAL, E1_PORTADO, E1_VEND1, L1_NUM, L1_XRESERV"
	cQry += " FROM "+RetSQLName("SE1")+" SE1"
	cQry += " INNER JOIN "+RetSQLName("SL1")+" SL1 ON SL1.D_E_L_E_T_ = ' '"
	
	If lFiscal  // Filtra as vendas normais
		cQry += " AND SL1.L1_DOC = SE1.E1_NUM AND SL1.L1_SERIE = SE1.E1_PREFIXO"
		cQry += " INNER JOIN "+RetSQLName("SLG")+" SLG (NOLOCK) ON SLG.D_E_L_E_T_ = '' "
		cQry += " AND SL1.L1_FILIAL = SLG.LG_FILIAL AND SLG.LG_SERIE = SL1.L1_SERIE "
	Else        // Filtra as vendas com reserva
		cQry += " AND SL1.L1_DOCPED = SE1.E1_NUM AND SL1.L1_SERPED = SE1.E1_PREFIXO"
		cQry += " INNER JOIN "+RetSQLName("SLG")+" SLG (NOLOCK) ON SLG.D_E_L_E_T_ = '' "
		cQry += " AND SL1.L1_FILIAL = SLG.LG_FILIAL AND SLG.LG_SERIE = SL1.L1_SERPED "
	Endif

	cQry += " WHERE SE1.D_E_L_E_T_ <> '*'"
	cQry += " AND E1_EMISSAO = '"+Dtos(MV_par01)+"'"
	//cQry += " AND E1_TIPO NOT IN ('NCC')"
	cQry += " And E1_PORTADO IN('" + cCX1 + "','" + cCX2 + "','" + cCX3 + "','" + cCX4 + "','" + cCX5 + "') 
	//cQry += " And E1_FILORIG = '" + xFilial('SE1') + "' "
	
Return cQry

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ValidPerg  ¦ Autor ¦ Alidio   S. Ribeiro  ¦ Data ¦ 17/11/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Generico function                                             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	PutSX1(cPerg,"01","Data "    ,"Data "    ,"Data "   ,"mv_ch1","D",8,0,0,"G","","   ","","","mv_par01")
	PutSX1(cPerg,"02","1o Caixa ","1o Caixa ","1o Caixa","mv_ch2","C",3,0,0,"G","","SA6","","","mv_par02")
	PutSX1(cPerg,"03","2o Caixa" ,"2o Caixa ","2o Caixa","mv_ch3","C",3,0,0,"G","","SA6","","","mv_par03")
	PutSX1(cPerg,"04","3o Caixa" ,"3o Caixa ","3o Caixa","mv_ch4","C",3,0,0,"G","","SA6","","","mv_par04")
	PutSX1(cPerg,"05","4o Caixa" ,"4o Caixa ","4o Caixa","mv_ch5","C",3,0,0,"G","","SA6","","","mv_par05")
	PutSX1(cPerg,"06","5o Caixa" ,"5o Caixa ","5o Caixa","mv_ch6","C",3,0,0,"G","","SA6","","","mv_par06")
Return
