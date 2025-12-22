#INCLUDE "rwmake.ch"

User Function RES_DETC()
	Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2     := "de acordo com os parametros informados pelo usuario."
	Local cDesc3     := "Resumo de Caixa Detalhado     "
	Local cPict      := ""
	Local titulo     := "Resumo de Caixa Detalhado     "
	Local nLin       := 80
	Local Cabec1     := "Tp Orcam    Pref. Num. Vencimento       Valor  Parc.    Cliente                     Caixa              Vendedor"
	Local Cabec2     := ""
	Local aOrd       := {}
	Local cPerg      := "RDET"+SM0->M0_CODFIL
	
	Private limite   := 132
	Private tamanho  := "M"
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
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	
	//????????????????????????????????????
	//?Monta a interface padrao com o usuario...                           ?
	//????????????????????????????????????
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//????????????????????????????????????
	//?Processamento. RPTSTATUS monta janela com a regua de processamento. ?
	//????????????????????????????????????
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
???????????????????????????????????????
???????????????????????????????????????
? ?????????????????????????????????????
??un??o    ?UNREPORT ?Autor ?AP6 IDE            ?Data ? 10/01/07   ??
???????????????????????????????????????
??escri??o ?Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ??
??         ?monta a janela com a regua de processamento.               ??
???????????????????????????????????????
??so       ?Programa principal                                         ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local aDbf, cArq, cInd, cQry, cTipo, bImp, nPDESC, nPRCTAB, nPICM, cSIMBCOM, cNumSer, cCondPG
	Local cData    := DTOS(MV_PAR01)
	Local vTitulo  := {}
	Local nValTOT  := 0
	Local nValCR   := 0
	Local cCX1     := If( Empty(MV_PAR02) , "ZZZ", MV_PAR02)
	Local cCX2     := If( Empty(MV_PAR03) , "ZZZ", MV_PAR03)
	Local cCX3     := If( Empty(MV_PAR04) , "ZZZ", MV_PAR04)
	Local cCX4     := If( Empty(MV_PAR05) , "ZZZ", MV_PAR05)
	Local cCX5     := If( Empty(MV_PAR06) , "ZZZ", MV_PAR06)
	Local nValTotGer := 0
	
	Local cCaixas  := "   ("+If( Empty(mv_par02) , "", mv_par02)+;
		If( Empty(mv_par03) , "", If( Empty(mv_par03) , "", ", ")+mv_par03)+;
		If( Empty(mv_par04) , "", If( Empty(mv_par02+mv_par03) , "", ", ")+mv_par04)+")"
	
	Private aDriver := ReadDriver()
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	
	DbSelectArea("SA3")
	DbSetOrder(1)
	
	DbSelectArea("SA6")
	DbSetOrder(1)
	
	DbSelectArea("SL1")
	DbSetOrder(2)
	
	/*********************************************************************************************************/
	nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
	@ nLin, 00 PSAY "Data de Fechamento : "+ DTOC(MV_PAR01)
	nLin := nLin + 2
	
	AAdd( vTitulo , " LISTA DE VENDAS DETALHADAS" )
	
	SetRegua(3)
	
	cQry := " SELECT E1_TIPO, E1_NUM, E1_PREFIXO, E1_PARCELA,E1_EMISSAO, E1_VENCREA, E1_CLIENTE, E1_LOJA, E1_VALOR, E1_VLRREAL, E1_PORTADO, E1_VEND1, L1_NUM, L1_DOC, L1_SERIE"
	cQry += "  FROM "+RetSQLName("SE1")+" E1, "+RetSQLName("SL1")+" L1 "
	cQry += "  WHERE E1_EMISSAO BetWeen '" + dtos(mv_par01) + "' And '" + dtos(mv_par01) + "' "
	cQry += "  And E1.D_E_L_E_T_ <> '*' AND L1.D_E_L_E_T_ <> '*' AND "
	cQry += "  L1_STORC != 'A' And
	cQry += "  ((E1_NUM = L1_DOC AND E1_PREFIXO = L1_SERIE) OR "
	cQry += "  (E1_NUM = L1_DOCPED AND E1_PREFIXO = L1_SERPED)) AND "
	cQry += "  E1_ORIGEM  IN ('LOJA010','LOJA701','FATA701') AND "
	cQry += "  E1_TIPO NOT IN ('NCC') AND "
	cQry += "  (E1_PORTADO IN ("
	cQry += "  '"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"')"+"  OR E1_BCORIG IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"') OR L1_OPERADO IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"','"+cCX5+"') )"
	cQry += "  ORDER BY E1_TIPO, L1_NUM, E1_PREFIXO, E1_NUM, E1_PARCELA "
	MemoWrite('RESUMO_DETALHADO.SQL',cQry)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRE", .T., .F. )
	dbSelectArea("TRE")
	dbGoTop()
	
	While !EOF()
		
		cTipo := E1_TIPO
		nValTot:= 0
		nValor := 0
		
		If nLin > 60  // Salto de P?ina. Neste caso o formulario tem 60 linhas...
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		Endif
		
		While !EOF() .And. E1_TIPO == cTipo
			
			SA1->(DbSeek(xFilial("SA1")+TRE->(E1_CLIENTE+E1_LOJA)))
			SA3->(DbSeek(xFilial("SA3")+TRE->E1_VEND1))
			SA6->(DbSeek(xFilial("SA6")+TRE->E1_PORTADO))
			SE1->(DbSeek(xFilial("SE1")+TRE->E1_PREFIXO+TRE->E1_NUM))
			
			If Alltrim(cTIPO) $ "CC#CD"
				
				cNum 	:= L1_NUM
				nValCC 	:= 0
				nNumPar	:= 0
				
				While !EOF() .And. E1_TIPO == cTipo .And. L1_NUM == cNum
					
					nValCC  += E1_VLRREAL
					nNumPar += 1
					TRE->(DbSkip())
					
				EndDo
				lSkip := .F.
				nValor := nValCC
				
			Else
				nValor :=  E1_VALOR
				lSkip := .T.
			Endif
			
			If Alltrim(cTipo) $ "CC"
				nyy := 0
			EndIf
			
			@nLin,000 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", cTipo			,TRE->E1_TIPO)
			@nLin,004 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", cNum				,TRE->L1_NUM)
			@nLin,012 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", SE1->E1_PREFIXO	,TRE->E1_PREFIXO)
			@nLin,016 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", SE1->E1_NUM		,TRE->E1_NUM)
			@nLin,026 PSAY IIf( Alltrim(cTIPO)$ "R$#", DTOC(STOD(TRE->E1_EMISSAO)) ,  IIf(Alltrim(cTIPO) $ "CC#CD", SE1->E1_VENCREA	,DTOC(STOD(TRE->E1_VENCREA))) )
			@nLin,035 PSAY Transform(nValor,"@E 9,999,999.99")
			@nLin,048 PSAY IIf(Alltrim(cTIPO) $ "CC#CD",nNumPar			,TRE->E1_PARCELA)
			@nLin,053 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", SE1->E1_CLIENTE+" / "+SE1->E1_LOJA,TRE->E1_CLIENTE+" / "+TRE->E1_LOJA)
			@nLin,065 PSAY Left(SA1->A1_NOME,15)
			@nLin,082 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", SE1->E1_PORTADO	,TRE->E1_PORTADO)
			@nLin,087 PSAY Left(SA6->A6_NOME,15)
			@nLin,104 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", SE1->E1_VEND1	,TRE->E1_VEND1)
			@nLin,PCol()+1 PSAY Left(SA3->A3_NOME,15)
			
			nLin := nLin + 1 // Avanca a linha de impressao
			
			If nLin > 60  // Salto de P?ina. Neste caso o formulario tem 60 linhas...
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			
			nValTot += Iif(Alltrim(cTipo) <> "CR",nValor,0)
			nValCR  += Iif(Alltrim(cTipo) == "CR",nValor,0)
			
			If lSkip
				dbSkip()
			Endif
		EndDo
		
		@nLin,010 PSAY "Sub-Valor : "
		If Alltrim(cTipo) <> "CR"
			@nLin,033 PSAY Transform(nVALTOT,"@E 999,999,999.99")
		Else
			@nLin,033 PSAY Transform(nVALCR,"@E 999,999,999.99")
		Endif
		
		nLin    	:= nLin + 2 // Avanca a linha de impressao
		nValTotGer 	+= nValTot
		
	Enddo
	TRE->(dbCloseArea('TRE'))
	IncRegua()
	nLin:= nLin + 1
	@nLin,020 PSAY "Valor do Fechamento           : "
	@nLin,078 PSAY Transform(nVALTOTGER,"@E 999,999,999.99")
	
	nLin:= nLin + 2
	@nLin,020 PSAY "Valor de Creditos/Trocas no Dia: "
	@nLin,078 PSAY Transform(nVALCR,"@E 999,999,999.99")
	
	cQry := ""
	cTbl := GetNextAlias()
	
	cQry +=                     " select  TBL.*,A1_NOME,A2_NOME From (
	cQry += Chr(13) + Chr(10) + " 	Select distinct D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,D1_FORNECE,D1_LOJA,D1E1E5.E1_PARCELA,D1E1E5.E1_VENCREA,
	cQry += Chr(13) + Chr(10) + " 		   TIPO,D1E1E5.E1_SALDO VALOR,D1E1E5.D1_CAIXA,IsNull(L1_VEND,F2_VEND1) VEND,IsNull(L1_CLIENTE,F2_CLIENTE)CLIENTE,Isnull(L1_LOJA,F2_LOJA) LOJA
	cQry += Chr(13) + Chr(10) + " 	From (
	cQry += Chr(13) + Chr(10) + " 		Select D1_DOC,D1_SERIE,D1_NFORI,D1_FORNECE,D1_LOJA,D1_SERIORI,E1_TIPO,D1_CAIXA,IsNull(E1_PARCELA,'')E1_PARCELA,isNull(E1_VENCREA,E5_VENCTO) E1_VENCREA,IsNull(DEVOLUCAO,0) E1_SALDO ,E1_VALOR,IsNull(E5_TIPO,E1_TIPO) TIPO,isNull(Sum(E5_VALOR ),0) E5_VALOR From (
	cQry += Chr(13) + Chr(10) + " 			SELECT Sum(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_ICMSRET - SD1.D1_VALDESC) DEVOLUCAO,
	cQry += Chr(13) + Chr(10) + " 				   D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,D1_FILIAL,D1_FORNECE,D1_LOJA,SUBSTRING(SD1.D1_NUMCQ,1,3) D1_CAIXA
	cQry += Chr(13) + Chr(10) + " 			FROM " + retSqlName('SD1') + " SD1
	cQry += Chr(13) + Chr(10) + " 			WHERE SD1.D1_FILIAL BETWEEN '  ' And 'zz'
	cQry += Chr(13) + Chr(10) + " 			  AND SD1.D1_EMISSAO BetWeen '" + dtos(mv_par01) + "' And '" + dtos(mv_par01) + "' "
	cQry += Chr(13) + Chr(10) + " 			  AND SUBSTRING(SD1.D1_NUMCQ,1,3) in( '" + cCX1 + "','" + cCX2 + "','" + cCX3 + "','" + cCX4 + "','" + cCX5 + "' )"
	cQry += Chr(13) + Chr(10) + " 			  And SD1.D_E_L_E_T_ = ''
	cQry += Chr(13) + Chr(10) + " 			group by D1_DOC,D1_SERIE,D1_DOC,D1_FORNECE,D1_LOJA,D1_NFORI,D1_SERIORI,D1_FILIAL,SUBSTRING(SD1.D1_NUMCQ,1,3)
	cQry += Chr(13) + Chr(10) + " 		)SD1
	cQry += Chr(13) + Chr(10) + " 		Left outer join (Select * From " + retSqlName('SE1') + " Where D_E_L_E_T_ = '') SE1 on E1_NUM    = D1_DOC And E1_PREFIXO = D1_SERIE
	cQry += Chr(13) + Chr(10) + " 		Left Outer Join (Select * From " + retSqlName('SE5') + " Where D_E_L_E_T_ = '') SE5 on E5_NUMERO = D1_DOC and E5_PREFIXO = D1_SERIE
	cQry += Chr(13) + Chr(10) + " 		group by D1_DOC,D1_SERIE,D1_NFORI,D1_FORNECE,D1_LOJA,D1_SERIORI,E1_TIPO,DEVOLUCAO,E1_VALOR,E5_TIPO,D1_CAIXA,E1_PARCELA,E1_VENCREA,E5_VENCTO
	cQry += Chr(13) + Chr(10) + " 	) D1E1E5
	cQry += Chr(13) + Chr(10) + " 	Left Outer Join (Select * From " + retSqlName('SL1') + " Where D_E_L_E_T_ = '')SL1 on L1_NUM = D1_NFORI And L1_SERIE = D1_SERIORI
	cQry += Chr(13) + Chr(10) + "     Left Outer Join (Select * From " + retSqlName('SE1') + " Where D_E_L_E_T_ = '')SE1 on E1_NUM = D1_NFORI And E1_SERIE = D1_SERIORI
	cQry += Chr(13) + Chr(10) + "     Left Outer Join (Select * From " + retSqlName('SF2') + " Where D_E_L_E_T_ = '')SF2 on F2_DOC = D1_NFORI And F2_SERIE = D1_SERIORI
	cQry += Chr(13) + Chr(10) + " )TBL
	cQry += Chr(13) + Chr(10) + " left outer join (Select * FRom " + retSqlName('SA1') + " Where D_E_L_E_T_ = '')SA1 on A1_COD = CLIENTE AND A1_LOJA = LOJA
	cQry += Chr(13) + Chr(10) + " left outer join (Select * FRom " + retSqlName('SA2') + " Where D_E_L_E_T_ = '')SA2 on A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA
	cQry += Chr(13) + Chr(10) + " Left Outer Join (Select * From SX5010 Where D_E_L_E_T_ = '' And X5_TABELA = '05')SX5 on X5_CHAVE = TIPO
	cQry += Chr(13) + Chr(10) + " order by TIPO,D1_DOC
	
	MemoWrite('RES_DET_DEVOLUCAO.SQL',cQry)
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), ctbl, .T., .F. )
	
	If !(cTbl)->(EOF())
		nLin += 6
		Cabec1     := "Tp Doc.Ori  Pref. Num.    Vencimento    Valor  Parc.    Cliente                     Caixa              Vendedor"
		If nLin > 55  // Salto de P?ina. Neste caso o formulario tem 60 linhas...
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		else
			@nLin,001	PSAY __PrtThinLine()
			nLin++
			@nLin,001	PSAY Cabec1
			nLin++
			@nLin,001	PSAY __PrtThinLine()
			nLin += 2
		Endif
		@nLin,000 PSAY PADC("**  DEVOLUÇÕES **",limite)
		nLin++
	EndIf
	
	nTotalDev := 0
	While !(cTbl)->(EOF())
		cTipo := (cTbl)->TIPO
		nTotTipo := 0
		While cTipo == (cTbl)->TIPO .And. !(cTbl)->(EOF())
			SA6->(DbSeek(xFilial("SA6")+(cTbl)->D1_CAIXA))
			SA3->(DbSeek(xFilial("SA3")+(cTbl)->VEND))
			
			@nLin,000 PSAY (cTbl)->TIPO
			@nLin,004 PSAY (cTbl)->D1_NFORI
			@nLin,014 PSAY (cTbl)->D1_SERIE
			@nLin,018 PSAY (cTbl)->D1_DOC
			@nLin,028 PSAY DTOC(STOD((cTbl)->E1_VENCREA))
			@nLin,037 PSAY Transform((cTbl)->VALOR,"@E 9,999,999.99")
			@nLin,050 PSAY (cTbl)->E1_PARCELA
			@nLin,055 PSAY (cTbl)->CLIENTE+" / "+(cTbl)->LOJA
			@nLin,067 PSAY Left((cTbl)->A1_NOME,15)
			@nLin,084 PSAY (cTbl)->D1_CAIXA
			@nLin,089 PSAY Left(SA6->A6_NOME,15)
			@nLin,106 PSAY (cTbl)->VEND
			@nLin,PCol()+1 PSAY Left(SA3->A3_NOME,15)
			nLin++
			nTotTipo += (cTbl)->VALOR
			(cTbl)->(dbSkip())
			If nLin > 60  // Salto de P?ina. Neste caso o formulario tem 60 linhas...
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
		Enddo
		@nLin,010 PSAY "Sub-Valor : "
		@nLin,033 PSAY Transform(nTotTipo,"@E 999,999,999.99")
		nLin += 2
		nTotalDev += nTotTipo
	EndDo
	nLin:= nLin + 2
	@nLin,020 PSAY "Valor de Devoluções: "
	@nLin,078 PSAY Transform(nTotalDEv,"@E 999,999,999.99")
	
	(ctbl)->(dbCloseArea())
	IncRegua()
	
	_cQry :=  " SELECT L2_NUM L1_NUM,E1_VEND1,E1_VALOR ,E1_VLRREAL,E1_PARCELA,E1_EMISSAO,E1_VENCREA,E1_TIPO ,
	If SF3->(FieldPos("F3_XOPERA")) > 0
		_cQry +=  "		   F3_XOPERA,F3_XFORPG,F3_XMOTIV,
	Else
		_cQry +=  "		   E1_PORTADO F3_XOPERA,
	EndIf
	_cQry +=  "        F3_DTCANC,F3_ESPECIE,F3_TIPO,F3_SERIE,F3_NFISCAL,
	_cQry +=  " 	   F3_CLIEFOR,F3_LOJA,A1_NOME
	_cQry +=  " 	FROM " + RetSqlName('SF3') + " SF3 "
	_cQry +=  " 	 INNER JOIN " + RetSqlName('SA1') + " SA1  ON SA1.D_E_L_E_T_= '' AND SF3.F3_CLIEFOR=A1_COD AND SF3.F3_LOJA=A1_LOJA
	_cQry +=  " 	 Left Outer JOIN " + RetSqlName('SF2') + " F2 ON F2_DOC = F3_NFISCAL AND F2_SERIE = F3_SERIE AND F2.D_E_L_E_T_ = '*'
	_cQry +=  " 	 Left Outer JOIN " + RetSqlName('SE1') + " E1 ON E1_NUM = F2_DOC AND E1_PREFIXO = F2_SERIE AND E1.D_E_L_E_T_ = '*'
	_cQry +=  " 	 Left Outer Join " + RetSqlName('SL2') + " L2 ON L2_DOC = F2_DOC And L2_SERIE = F2_SERIE  "
	_cQry +=  " 	 WHERE SF3.D_E_L_E_T_=''
	_cQry +=  " 	   AND F3_EMISSAO BetWeen '" + dtos(mv_par01) + "' And '" + dtos(mv_par01) + "' "
	_cQry +=  " 	   AND F3_DTCANC != ''
	_cQry +=  " 	   AND LEFT(F3_CFO,1)>='5' AND F3_TIPO<>'D'
	_cQry +=  " 	   AND E1_PORTADO in( '" + cCX1 + "','" + cCX2 + "','" + cCX3 + "','" + cCX4 + "','" + cCX5 + "' )"
	_cQry +=  " GROUP BY L2_NUM,E1_VEND1,E1_VALOR,E1_VLRREAL,E1_PARCELA,E1_EMISSAO,E1_VENCREA,E1_TIPO,
	If SF3->(FieldPos("F3_XOPERA")) > 0
	    _cQry +=  " F3_XOPERA,F3_XFORPG,F3_XMOTIV,
	Else 
		_cQry +=  " E1_PORTADO,
	EndIf
	_cQry +=  " F3_DTCANC,F3_ESPECIE,F3_TIPO,F3_SERIE,F3_NFISCAL,F3_CLIEFOR,F3_LOJA,A1_NOME
	
	cTbl := getNextAlias()
	MemoWrite('RES_DET_CANCELADAS.SQL',_cQry)	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(_cQry)), ctbl, .T., .F. )
	
	//
	If !(cTbl)->(EOF())
		nLin += 6
		Cabec1     := "Tp Orcam    Pref. Num.    Vencimento    Valor  Parc.    Cliente                     Caixa              Vendedor"
		If nLin > 55  // Salto de P?ina. Neste caso o formulario tem 60 linhas...
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		else
			@nLin,001	PSAY __PrtThinLine()
			nLin++
			@nLin,001	PSAY Cabec1
			nLin++
			@nLin,001	PSAY __PrtThinLine()
			nLin += 2
		Endif
		@nLin,000 PSAY PADC("**  CANCELADAS **",limite)
		nLin++
	EndIf
	
	
	nTotalCanc := 0
	While !(cTbl)->(EOF())
		cTipo := (cTbl)->E1_TIPO
		nTotTipo := 0
		
		While cTipo == (cTbl)->E1_TIPO .And. !(cTbl)->(EOF())
			
			SA1->(DbSeek(xFilial("SA1")+(cTbl)->F3_CLIEFOR+(cTbl)->F3_LOJA))
			SA3->(DbSeek(xFilial("SA3")+(cTbl)->E1_VEND1))
			
			SA6->(DbSeek(xFilial("SA6")+(cTbl)->F3_XOPERA))
			//SE1->(DbSeek(xFilial("SE1")+(cTbl)->E1_PREFIXO+TRE->E1_NUM))
			
			If Alltrim(cTIPO) $ "CC#CD"
				
				cNum 	:= (cTbl)->L1_NUM
				nValCC 	:= 0
				nNumPar	:= 0
				
				While !EOF() .And. (cTbl)->E1_TIPO == cTipo .And. (cTbl)->L1_NUM == cNum
					
					nValCC  += (cTbl)->E1_VLRREAL
					nNumPar += 1
					(cTbl)->(DbSkip())
					
				EndDo
				lSkip := .F.
				nValor := nValCC
				
			Else
				nValor :=  (cTbl)->E1_VALOR
				lSkip := .T.
			Endif
			
			If Alltrim(cTipo) $ "CC"
				nyy := 0
			EndIf
			
			
			@nLin,000 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", cTipo			    ,(cTbl)->E1_TIPO)
			@nLin,004 PSAY IIf(Alltrim(cTIPO) $ "CC#CD", cNum				,(cTbl)->L1_NUM)
			@nLin,012 PSAY (cTbl)->F3_SERIE
			@nLin,016 PSAY (cTbl)->F3_NFISCAL
			@nLin,026 PSAY IIf( Alltrim(cTIPO)$ "R$#", DTOC(STOD( (cTbl)->E1_EMISSAO)) ,  DTOC(STOD( (cTbl)->E1_VENCREA) ) )
			@nLin,035 PSAY Transform(nValor,"@E 9,999,999.99")
			@nLin,048 PSAY IIf(Alltrim(cTipo) $ "CC#CD",nNumPar			   ,(cTbl)->E1_PARCELA)
			@nLin,053 PSAY SA1->A1_COD+" / "+SA1->A1_LOJA
			@nLin,065 PSAY Left(SA1->A1_NOME,15)
			@nLin,082 PSAY (cTbl)->F3_XOPERA
			@nLin,087 PSAY Left(SA6->A6_NOME,15)
			@nLin,104 PSAY (cTbl)->E1_VEND1
			@nLin,PCol()+1 PSAY Left(SA3->A3_NOME,15)
			
			nLin := nLin + 1 // Avanca a linha de impressao
			
			If nLin > 60  // Salto de P?ina. Neste caso o formulario tem 60 linhas...
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			
//			nValTot += Iif(Alltrim(cTipo) <> "CR",nValor,0)
//			nValCR  += Iif(Alltrim(cTipo) == "CR",nValor,0)
			nTotalCanc += nValor
			If lSkip
				(cTbl)->(dbSkip())
			Endif
		EndDo
	EndDo
	nLin:= nLin + 2
	@nLin,020 PSAY "Valor de Cancelamentos: "
	@nLin,078 PSAY Transform(nTotalCanc,"@E 999,999,999.99")
	
	
	IncRegua()
	dbCloseArea()
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

/*_______________________________________________________________________________
?????????????????????????????????????????
?+-----------+------------+-------+----------------------+------+------------+?
??Fun?o    ?ValidPerg  ?Autor ?Alidio   S. Ribeiro  ?Data ?17/11/2006 ??
?+-----------+------------+-------+----------------------+------+------------+?
??Descri?o ?Generico function                                             ??
?+-----------+---------------------------------------------------------------+?
?????????????????????????????????????????
???????????????????????????????????????????????????????????????????????????????*/
Static Function ValidPerg(cPerg)
	PutSX1(cPerg,"01","Data "    ,"Data "    ,"Data "   ,"mv_ch1","D",8,0,0,"G","","   ","","","mv_par01")
	PutSX1(cPerg,"02","1o Caixa ","1o Caixa ","1o Caixa","mv_ch2","C",3,0,0,"G","","SA6","","","mv_par02")
	PutSX1(cPerg,"03","2o Caixa" ,"2o Caixa ","2o Caixa","mv_ch3","C",3,0,0,"G","","SA6","","","mv_par03")
	PutSX1(cPerg,"04","3o Caixa" ,"3o Caixa ","3o Caixa","mv_ch4","C",3,0,0,"G","","SA6","","","mv_par04")
	PutSX1(cPerg,"05","4o Caixa" ,"4o Caixa ","4o Caixa","mv_ch5","C",3,0,0,"G","","SA6","","","mv_par05")
	PutSX1(cPerg,"06","5o Caixa" ,"5o Caixa ","5o Caixa","mv_ch6","C",3,0,0,"G","","SA6","","","mv_par06")
	PutSX1(cPerg,"07","Data 2"    ,"Data 2"    ,"Data 2","mv_ch1","D",8,0,0,"G","","   ","","","mv_par07")
Return
