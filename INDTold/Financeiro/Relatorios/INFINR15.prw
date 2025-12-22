#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINR15 º Autor ³ Ronilton O. Barros º Data ³  28/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de Material de Consumo                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico INDT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INFINR15(_cProj,_cTitulo,_cProg,_cPerg,_vPerg,_lCallMe,_cMCT)
	Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2 := "de acordo com os parametros informados pelo usuario."
	Local cDesc3 := If( _cTitulo == Nil , "Despesas Material de Consumo", _cTitulo)
	Local Titulo := cDesc3
	Local nLin   := 80
	Local aOrd   := {}
	
	Local Cabec1 := "Data        Fornecedor                                CPF / CNPJ          Documento      No. DI        Descricao Produto                                        Quant         Entrada           Saida           Saldo  Local"
			//         99/99/9999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99.999.999/9999-99  xxxxxxxxx-xxx  99/9999999-9  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99999  999,999,999.99  999,999,999.99  999,999,999.99   XXX
			//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
	
	Local Cabec2 := ""
	Local cPerg  := PADR(If( _cPerg == Nil , "INFINR15", _cPerg),Len(SX1->X1_GRUPO))
	
	_cTitulo := Titulo
	_lCallMe := If( _lCallMe == Nil , .F., _lCallMe)
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	If !_lCallMe
		Private Limite   := 220
		Private Tamanho  := "G"
		Private NomeProg := If( _cProg == Nil , "INFINR15", _cProg)
		Private nTipo    := 15
		Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
		Private nLastKey := 0
		Private m_pag    := 01
		Private wnrel    := NomeProg
		Private cString  := "SE5"
		
		Private cCsvPath := ""
		Private cCsvArq  := ""
		Private nHdl     := 0
		
		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
		
		If nLastKey == 27
			Return
		Endif
		
		SetDefault(aReturn,cString)
		
		If nLastKey == 27
			Return
		Endif
		
		nTipo := If(aReturn[4]==1,15,18)
	Else
		// Atualiza os parametros digitados pelo usuario para o relatorio aglutinado
		mv_par01 := _vPerg[1]       // Da Data
		mv_par02 := _vPerg[2]       // Ate a Data
		mv_par03 := _cProj          // Do Centro Custo
		mv_par04 := _cProj          // Ate o Centro Custo
		mv_par05 := PADR(_cMCT,9)   // Da Classe MCT
		mv_par06 := Repli(" ",Len(mv_par06)) // Do Documento
		mv_par07 := Repli("Z",Len(mv_par07)) // Ate o Documento
		mv_par08 := Repli(" ",Len(mv_par08)) // Do Prefixo
		mv_par09 := Repli("Z",Len(mv_par09)) // Ate o Prefixo
		mv_par10 := _vPerg[5]       // Consulta Filiais abaixo
		mv_par11 := _vPerg[6]       // Da filial
		mv_par12 := _vPerg[7]       // Ate a filial
		mv_par13 := 1               // Imprime resumo
		mv_par14 := _vPerg[8]       // Considera PA (1=Sim 2=Nao)
		mv_par15 := _vPerg[9]       // Imprime Relatorio por: Caixa  Competencia
		mv_par16 := Repli(" ",Len(mv_par16)) // Do Pedido
		mv_par17 := Repli("Z",Len(mv_par17)) // Ate o Pedido
		mv_par18 := _vPerg[10]      // Considera estorno: Sim  Nao
		
		If mv_par15 == 4            // Caso tenha sido escolhida a opção Hibrido
			mv_par15 := 1            // O relatório será impresso por Caixa
		Endif
	Endif
	Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin,_lCallMe,_cTitulo) }, "Filtrando dados")
Return

/////////////////////////////////////////////////////////////////////
Static function ExecProc(Cabec1,Cabec2,Titulo,nLin,_lCallMe,_cTitulo)
	Local aStru, cArq, cInd, cKey, cQry, cQPA, lFind
	Local cTpImp := MVISS+";"+MVINSS+";"+MVTAXA+";"+MVTXA
	
	If !_lCallMe
		If mv_par15 < 3  // Se não for a opção Contábil ou Base MCT
			Titulo := AllTrim(Titulo)+ " (Base Oficial)"
			If mv_par15 == 1
				Titulo += " - Caixa"
			Else
				Titulo += " - Competencia"
				cQry   := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
				cQry   += "E2_NUM >= '"+mv_par06+"' AND E2_NUM <= '"+mv_par07+"' AND "
				cQry   += "E2_PREFIXO >= '"+mv_par08+"' AND E2_PREFIXO <= '"+mv_par09+"' AND "
				
				If mv_par10 == 1    // Considera Filial ==  1-Sim  2-Nao
					cQry += "E2_FILIAL >= '"+mv_par11+"' AND E2_FILIAL <= '"+mv_par12+"' AND "
				Else
					cQry += "E2_FILIAL = '"+xFilial("SE2")+"' AND "
				Endif
				
				/*___________________________________________________________________________________________
				¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
				¦¦+---------------------------------------------------------------------------------------+¦¦
				¦¦¦                 Filtro para titulos com origem do Compras / Financeiro                ¦¦¦
				¦¦+---------------------------------------------------------------------------------------+¦¦
				¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
				¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
				cQry += "((E2_ORIGEM <> 'GPEM670' AND E2_TIPO NOT IN "+FormatIn(cTpImp,";")+" AND "
				cQry += "(E2_PARCELA IN (' ','1','A') OR E2_ORIGEM = 'FINA050') AND "
				cQry += "E2_EMIS1 >= '"+Dtos(mv_par01)+"' AND E2_EMIS1 <= '"+Dtos(mv_par02)+"') OR "
				
				/*___________________________________________________________________________________________
				¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
				¦¦+---------------------------------------------------------------------------------------+¦¦
				¦¦¦                       Filtro para titulos com origem da Folha                         ¦¦¦
				¦¦+---------------------------------------------------------------------------------------+¦¦
				¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
				¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
				// Ignora títulos de férias. Os mesmos serão pegos em uma rotina específica
				cQry += "(E2_ORIGEM = 'GPEM670' AND E2_VERBAS NOT LIKE '%452%' AND E2_VERBAS NOT LIKE '%444%' AND "
				
				// Acerta filtro da data final para os titulos de 13o e 14o salario
				cDtFinal := Dtos(mv_par02)
				If SubStr(cDtFinal,5,2) == "12"
					cDtFinal := Stuff(cDtFinal,5,2,"14")
				Endif
				
				// Busca a data de competencia do titulo de RH
				cQry += "E2_DATARQ BETWEEN '"+SubStr(Dtos(mv_par01),1,6)+"' AND '"+SubStr(cDtFinal,1,6)+"'))"
				
				// Rotina de Busca de Dados --> INDACFG.PRW
				cArq := u_INDADCOMP(cQry,mv_par01,mv_par02,,,mv_par03,mv_par04,mv_par10,mv_par11,mv_par12,mv_par05,mv_par14,"C")
			Endif
			
			aStru := SE5->(dbStruct())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processando Saidas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQry := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE5")+" WHERE D_E_L_E_T_ <> '*' AND "
			cQry += "E5_DTDISPO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND "
			cQry += "E5_NUMERO >= '"+mv_par06+"' AND E5_NUMERO <= '"+mv_par07+"' AND "
			cQry += "E5_PREFIXO >= '"+mv_par08+"' AND E5_PREFIXO <= '"+mv_par09+"' AND "
			
			cQry += "E5_RECPAG = 'P' AND "+u_CondPadRel()
			
			If mv_par10 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND E5_FILIAL >= '"+mv_par11+"' AND E5_FILIAL <= '"+mv_par12+"'"
			Else
				cQry += " AND E5_FILIAL = '"+xFilial("SE5")+"'"
			Endif
			
			If mv_par15 == 1   // Se for Caixa
				// - D= Ref. Despesas financeiras                           FIN MAT GPE
				Processa({|| cArq := u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par14,"D",.T.,mv_par05,,.F.) },"Filtro de Dados","Filtrando Saidas...")
			Else  // Se for competência, processa somente as movimentações bancárias
				cQry += " AND E5_CCD >= '"+mv_par03+"' AND E5_CCD <= '"+mv_par04+"'"
				cQry += " AND E5_CLVLDB = '"+mv_par05+"' AND E5_MOTBX = ' '"
				
				Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par14,"D",.F.,mv_par05,,.T.) },"Filtro de Dados","Filtrando Saidas...")
				
				If mv_par14 == 1  // Se considera PA
					// Processa os estornos de PA's
					cQPA := "(E5_MOTBX = ' ' OR (E5_MOTBX = 'DEB' AND E5_TIPO IN "+FormatIn(MVPAGANT,"|")+"))"
					cQry := StrTran(cQry,"E5_MOTBX = ' '", cQPA)
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processando as entrada ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQry := StrTran(cQry,"E5_RECPAG = 'P'","E5_RECPAG = 'R'")
			
			// - D= Ref. Despesas financeiras                   FIN MAT GPE
			Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par14,"D",.F.,mv_par05,,mv_par15==2) },"Filtro de Dados","Filtrando Entradas...")
		ElseIf mv_par15 == 3  // Se for a opção Contábil
			Titulo := AllTrim(Titulo)+ " (Base Oficial) - Contabil"
			
			cQry := "SELECT COUNT(*) SOMA FROM "+RetSQLName("CT2")+" CT2 WHERE CT2.D_E_L_E_T_ = ' '"
			cQry += " AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
			cQry += " AND ((CT2_CCD >= '"+mv_par03+"' AND CT2_CCD <= '"+mv_par04+"')"
			cQry += " OR (CT2_CCC >= '"+mv_par03+"' AND CT2_CCC <= '"+mv_par04+"'))"
			
			// Busca e filtra Classe MCT pelo Plano de Contas
			cQry += " AND ("
			cQry += " (CT2_DC IN ('1','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_DEBITO = CT1_CONTA AND CT1_GRUPO = '"+mv_par05+"'))"
			cQry += " OR"
			cQry += " (CT2_DC IN ('2','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_CREDIT = CT1_CONTA AND CT1_GRUPO = '"+mv_par05+"')))"
			
			If mv_par10 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND CT2_FILIAL >= '"+mv_par11+"' AND CT2_FILIAL <= '"+mv_par12+"'"
			Else
				cQry += " AND CT2_FILIAL = '"+xFilial("CT2")+"'"
			Endif
			
			// Rotina de Busca de Dados --> INFINP04.PRW
			Processa({|| cArq := u_INFINP04("TMP",cQry,"D",.T.,.T.,mv_par18==1) },"Filtro de Dados","Filtrando Saidas...")
		Else  // Se for a opção Base MCT
			Titulo := AllTrim(Titulo)+ " (Base MCT)"
			
			cQry := "SELECT COUNT(*) SOMA"
			cQry += " FROM "+RetSQLName("SZ3")+" SZ3"
			cQry += " WHERE SZ3.D_E_L_E_T_ = ' '"
			
			If mv_par10 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND SZ3.Z3_FILIAL >= '"+mv_par11+"' AND SZ3.Z3_FILIAL <= '"+mv_par12+"'"
			Else
				cQry += " AND SZ3.Z3_FILIAL = '"+xFilial("SZ3")+"'"
			Endif
			
			cQry += " AND SZ3.Z3_DTDISPO >= '"+Dtos(mv_par01)+"' AND SZ3.Z3_DTDISPO <= '"+Dtos(mv_par02)+"'"
			cQry += " AND SZ3.Z3_CC >= '"+mv_par03+"' AND SZ3.Z3_CC <= '"+mv_par04+"'"
			cQry += " AND SZ3.Z3_CLVL = '"+mv_par05+"'"
			cQry += " AND SZ3.Z3_NUMERO >= '"+mv_par06+"' AND SZ3.Z3_NUMERO <= '"+mv_par07+"'"
			cQry += " AND SZ3.Z3_PREFIXO >= '"+mv_par08+"' AND SZ3.Z3_PREFIXO <= '"+mv_par09+"'"
			cQry += " AND SZ3.Z3_PRCOMP >= '"+mv_par16+"' AND SZ3.Z3_PRCOMP <= '"+mv_par17+"'"
			
			// Rotina de Busca de Dados --> INFINP08.PRW
			Processa({|| cArq := u_INFINP08("TMP",cQry,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
		Endif
	Endif
	Titulo := AllTrim(Titulo)+" - "+Dtoc(mv_par01)+" A "+Dtoc(mv_par02)
	
	cInd := CriaTrab(NIL ,.F.)
	cKey := "E5_CC+E5_PRCOMP+E5_MOVBCO+E5_FILIAL+E5_NUMERO+E5_PREFIXO+E5_PARCELA+E5_TIPO+Dtos(E5_DTDISPO)"
	
	IndRegua("TMP",cInd,cKey,,,"Selecionando Registros...")
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,_lCallMe,_cTitulo) },Titulo)
	
	If !_lCallMe
		FErase(cArq+GetDBExtension())
	Else
		dbClearIndex()
	Endif
	FErase(cInd+OrdBagExt())
Return

//////////////////////////////////////////////////////////////////////
Static function RunReport(Cabec1,Cabec2,Titulo,nLin,_lCallMe,_cTitulo)
	Local cMovFil, cNumero, cPrefixo, vFornec, nPos, x, y, cBusca, vItens, vOk, vTotDoc, lImpDoc, nCEnt, nCSai, cRet
	Local vPed, cObj, cJus, lImpCCC, cPedido, nPos, lImpPed, lPulou, cCLVL, i
	Local nSomaEnt, nSomaSai, nEntCC, nSaiCC, nTotEnt, nTotSai, cFilSE5, lAtendido
	Local cFornec, cLoja, cDocPrin, cHist, vFrete, vAuxFrete, vChave, lPrinc
	Local aResumo := {}
	Local cCRLF   := chr(13)+chr(10)
	Local nTamDoc := TamSX3("E2_NUM")[1]
	Local cSPData := Space(10)
	Local cSPForn := Space(40)
	Local cSPCNPJ := Space(18)
	Local cSPDocm := Space(Len(SE2->(E2_PREFIXO+"-"+E2_NUM)))
	Local cSPNoDI := Space(Len(SD1->D1_NODI))
	Local lFirst  := .T.
	
	Private cE2_FILIAL, cE2_FORNECE, cE2_LOJA, cE2_AGRUPA, cE2_ITEMCTA, cE2_PREFIXO, cE2_NUM, cE2_HIST, cE2_PARCELA
	Private cE2_TIPO, cE2_ORIGEM, cA2_NOME, cA2_CGC, cA2_TIPO
	
	nTotEnt := 0
	nTotSai := 0
	
	CTT->(dbSetOrder(1))
	
	dbSelectArea("TMP")
	dbGoTop()
	SetRegua(RecCount())
	
	If !(Eof() .And. Bof())
		If Empty(cCsvArq)            // Se ainda não foi informado
			cCsvPath := GetTempPath() //path do arquivo texto
			cCsvArq  := Trim(wnrel)+".xls"  //nome do arquivo csv
			nHdl     := fCreate(cCsvPath+cCsvArq)   //arquivo para trabalho
		Endif
	Endif
	
	While !Eof()
		
		CTT->(dbSeek(XFILIAL("CTT")+TMP->E5_CC))
		
		lImpCCC := .T.
		nEntCC  := 0
		nSaiCC  := 0
		cCCusto := E5_CC
		nCEnt   := 0   // Coluna da entrada
		nCSai   := 0   // Coluna da saída
		
		//- Quebra por centro de custo
		While !Eof() .And. E5_CC == cCCusto
			nSomaEnt := 0
			nSomaSai := 0
			cObj     := ""
			cJus     := ""
			vPed     := {}
			lImpPed  := .T.
			cPedido  := E5_PRCOMP
			
			//- Quebra por pedido
			While !Eof() .And. E5_CC+E5_PRCOMP == cCCusto+cPedido
				cMovFil  := E5_MOVBCO+E5_FILIAL
				cNumero  := E5_NUMERO
				cPrefixo := E5_PREFIXO
				cFilSE5  := E5_FILIAL
				cFornec  := E5_CLIFOR
				cLoja    := E5_LOJA
				cHist    := E5_BENEF
				cFornPrin:= ""
				cLojPrin := ""
				cDocPrin := ""
				vFornec  := {}
				vTotDoc  := { 0, 0}
				lImpDoc  := .T.
				
				//- Quebra por documento
				While !Eof() .and. E5_CC+E5_PRCOMP+E5_MOVBCO+E5_FILIAL+E5_NUMERO+E5_PREFIXO == cCCusto+cPedido+cMovFil+cNumero+cPrefixo
					
					IncRegua()
					
					If E5_CC < mv_par03 .Or. E5_CC > mv_par04 .Or. E5_CLVL <> mv_par05 .Or. TMP->E5_STATUS <> "S" .Or. If( mv_par15 == 1 , E5_BAICOMP == "C", E5_BAICOMP <> "C")
						dbSkip()
						Loop
					Endif
					
					If E5_NUMERO  < mv_par06 .Or. E5_NUMERO  > mv_par07 .Or.;
						E5_PREFIXO < mv_par08 .Or. E5_PREFIXO > mv_par09 .Or.;
						E5_PRCOMP  < mv_par16 .Or. E5_PRCOMP  > mv_par17
						dbSkip()
						Loop
					EndIf
					
					nPos:= Ascan(vFornec, {|x| x[1]+x[2]+x[3]+x[9]+x[13]+x[15] == E5_FILIAL+E5_CLIFOR+E5_LOJA+E5_RECPAG+E5_PARCELA+E5_ITEM .And. x[19] <> "S" })
					If nPos == 0 .Or. E5_TPCTB == "S"  // Se for Lançamento avulso
						//                  1           2         3          4        5       6              7       8              9        10    11   12            13          14        15       16              17              18              19        20
						AAdd( vFornec , { E5_FILIAL, E5_CLIFOR, E5_LOJA, E5_DTDISPO, 0.00, TMP->E5_TPIMP, E5_CLVL, TMP->E5_NODI, E5_RECPAG, 0.00, 0.00, TMP->E5_TIPO, E5_PARCELA, E5_BENEF, E5_ITEM, TMP->E5_GERFIN, TMP->E5_ROTINA, TMP->E5_MANUAL, E5_TPCTB, TMP->E5_FILORIG} )
						nPos := Len(vFornec)
					Endif
					If E5_RECPAG == "R"
						vFornec[nPos,10] += E5_VALOR
					Else
						vFornec[nPos,11] += E5_VALOR
					Endif
					
					dbSkip() // Avanca o ponteiro do registro no arquivo
				Enddo
				
				For x:=1 To Len(vFornec)
					cDocPrin := ""
					vItens   := {}
					lFind    := .F.
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprimindo dados do titulo principal caso o tipo seja imposto ou taxa e nao ³
					//³ venham com o pedido preenchido.         								    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cE2_FILIAL := If( Empty(vFornec[x,1]) .Or. Empty(vFornec[x,20]) , vFornec[x,1], vFornec[x,20])
					dPagamento := Ctod("")
					
					//- Busca o titulo principal
					If vFornec[x,16] == "S"   // Se gerou Financeiro
						lPrinc := BuscaPrinc(cE2_FILIAL,cPrefixo,cNumero,vFornec[x,2],vFornec[x,3],vFornec[x,12],vFornec[x,13],@lFind)
						
						cE2_PREFIXO := SE2->E2_PREFIXO
						cE2_NUM     := SE2->E2_NUM
						cE2_PARCELA := SE2->E2_PARCELA
						cE2_TIPO    := SE2->E2_TIPO
						cE2_FORNECE := SE2->E2_FORNECE
						cE2_LOJA    := SE2->E2_LOJA
						cE2_AGRUPA  := SE2->E2_AGRUPA
						cE2_ITEMCTA := SE2->E2_ITEMCTA
						cE2_HIST    := SE2->E2_HIST
						cE2_ORIGEM  := SE2->E2_ORIGEM
						dPagamento  := If( Empty(SE2->E2_BAIXA) , SE2->E2_VENCREA, SE2->E2_BAIXA)
					Else
						lPrinc      := .T.
						cE2_PREFIXO := cPrefixo
						cE2_NUM     := cNumero
						cE2_PARCELA := vFornec[x,13]
						cE2_TIPO    := vFornec[x,12]
						cE2_FORNECE := vFornec[x,2]
						cE2_LOJA    := vFornec[x,3]
						cE2_AGRUPA  := "1"
						cE2_ITEMCTA := Space(Len(SE2->E2_ITEMCTA))
						cE2_HIST    := vFornec[x,14]
						cE2_ORIGEM  := vFornec[x,17]
					Endif
					
					cA2_NOME := ""
					cA2_CGC  := ""
					cA2_TIPO := ""
					
					PesqCliFor(cE2_FILIAL,cE2_FORNECE+cE2_LOJA)   // Posiciona no cliente / fornecedor do documento
					
					If lImpDoc .And. Empty(cPedido) .and. vFornec[x,12] $ "TX ,INS,ISS" .and. Trim(cE2_ORIGEM) != "MATA100"
						
						If nLin > 60
							nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
						Endif
						
						@ nLin,000      PSAY cSPData
						@ nLin,PCol()+2 PSAY PADR(cA2_NOME,39)+If( cE2_AGRUPA=="4" , " - "+Trim(Posicione("SRA",1,cE2_FILIAL+cE2_ITEMCTA,"RA_NOME")), " ")
						@ nLin,PCol()+2 PSAY Transform(cA2_CGC,"@R "+If(cA2_TIPO=="J".And.!Empty(cA2_CGC),"99.999.999/9999-99",Repli("9",18)))
						@ nLin,PCol()+2 PSAY cE2_PREFIXO+"-"+cE2_NUM
						@ nLin,PCol()+2 PSAY cSPNoDI
						@ nLin,PCol()+2 PSAY PADR(cE2_HIST,55)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Imprimindo a data de pagamrnto do titulo principal  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nRecSE5:= SE5->(Recno())
						
						SE5->(dbSetOrder(7))
						SE5->(dbSeek(cE2_FILIAL+cE2_PREFIXO+cE2_NUM+cE2_PARCELA+cE2_TIPO+cE2_FORNECE+cE2_LOJA))
						
						d_Baixa:= SE5->E5_DTDISPO
						
						If SE5->E5_RECPAG == "P" .And. SE5->E5_TIPODOC == "CP"
							c_Documen:= SE5->E5_DOCUMEN
							SE5->(dbSeek(cE2_FILIAL+c_Documen,.T.))
							d_Baixa:= SE5->E5_DTDISPO
						Endif
						If d_Baixa < mv_par01
							@ nLin,171 PSAY "PAGO EM: "+ Dtoc(d_Baixa)
						Endif
						nLin++
						
						dPagamento := d_Baixa
						
						SE5->(Dbgoto(nRecSE5))
						cDocPrin := cE2_PREFIXO+cE2_NUM
						lImpDoc  := .F.
					Endif
					
					nRecSE2   := SE2->(Recno())
					vAuxFrete := {}
					vFrete    := {}
					
					If Trim(cE2_ORIGEM) == "MATA100"
						
						cFornPrin := cE2_FORNECE
						cLojPrin  := cE2_LOJA
						cBusca    := cE2_FILIAL+cE2_NUM+cE2_PREFIXO+cE2_FORNECE+cE2_LOJA //- Posicionado no principal
						
						CT1->(dbSetOrder(1))
						
						//- Itens NF de entrada
						dbSelectArea("SD1")
						dbSetOrder(1)
						dbSeek(cBusca,.T.)
						
						While !Eof() .And. cBusca == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
							
							// Se for Contábil, pesquisa a classe de valor vinculada a conta contábil lançada na nota
							cCLVL := SD1->D1_CLVL
							If mv_par15 == 3 .And. CT1->(dbSeek(XFILIAL("CT1")+SD1->D1_CONTA))
								cCLVL := PADR(CT1->CT1_GRUPO,9)
							Endif
							
							//- Incluido em 06-07-05 - Por Reinaldo Magalhaes
							If SD1->D1_ITEM <> vFornec[x,15]   // Se não for o mesmo item
								If cCLVL != mv_par05 .or. SD1->D1_PRCOMP != cPedido // .or. D1_TIPO $ "CI"
									dbSkip()
									Loop
								Endif
							Endif
							
							If SD1->D1_CC == cCCusto .Or. SD1->D1_ITEM == vFornec[x,15]
								AAdd( vItens, { SubStr(SD1->D1_DESCRI,1,55), SD1->D1_QUANT, SD1->D1_TOTAL, SD1->D1_NODI} )
								vChave := {}
								If SD1->D1_TIPO $ "C"  // Se for conhecimento de frete
									SF8->(dbSetOrder(3)) // Pesquisa a nota de frete e pega a nota original
									If SF8->(dbSeek(SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA))
										vChave := { SF8->F8_FILIAL, SF8->F8_NFORIG, SF8->F8_SERORIG, SF8->F8_FORNECE, SF8->F8_LOJA, SD1->D1_PRCOMP}
									Endif
								Endif
								If Empty(vChave)  // Se nao encontrou nota de frete, preenche com dados da nota original
									vChave := { SD1->D1_FILIAL, SD1->D1_NFORI, SD1->D1_SERIORI, SD1->D1_FORNECE, SD1->D1_LOJA, SD1->D1_PRCOMP}
								Endif
								If Ascan( vAuxFrete, {|x| x[1]+x[2]+x[3]+x[6] == vChave[1]+vChave[2]+vChave[3]+vChave[6] }) == 0
									AAdd( vAuxFrete, vChave )
								Endif
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Modificado para atender a situacao de quando o pedido for prenchido ³
								//³ pega a justificativa do pedido, caso contrario, pega do item da nota³
								//³ fiscal de entrada. Em 04-08-05 by Reinaldo Magalhaes                ³
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								cRet := ""
								If !Empty(SD1->D1_PRCOMP)
									If SD1->D1_PRCOMP == cPedido .And. Ascan(vPed,SD1->D1_PRCOMP) == 0
										//- Verifica se o pedido nao esta vazio e se ainda nao foi lido
										AAdd(vPed,SD1->D1_PRCOMP)
										cRet := u_INObjJust(cE2_FILIAL,"1",PADR(SD1->D1_PRCOMP,nTamDoc),mv_par15 <> 4)
									Endif
								Else
									cRet := u_INObjJust(cE2_FILIAL,"4",SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM,mv_par15 <> 4)
									If Empty(cRet)
										cRet := u_INObjJust(cE2_FILIAL,"4",SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+Space(Len(SD1->D1_ITEM)),mv_par15 <> 4)
									Endif
								Endif
								If !Empty(cRet) .And. !(AllTrim(cRet) $ AllTrim(cJus))
									cJus := AllTrim(cJus) + AllTrim(cRet)
									cJus += If(SubStr(cJus,Len(cJus),1) == "." ,"", ".") + cCRLF
								Endif
							Endif
							
							dbSkip()
						Enddo
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verificando se a nota fiscal e de frete (tipo="C", se for, localiza a nota  ³
						//³ de compra corresponde e seus itens.										  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For i:= 1 to Len(vAuxFrete)
							cBusca:= vAuxFrete[i,1]+vAuxFrete[i,2]+vAuxFrete[i,3]
							//- Itens NF de entrada
							dbSelectArea("SD1")
							dbSetOrder(1)
							dbSeek(cBusca,.t.)
							While !Eof() .And. cBusca == D1_FILIAL+D1_DOC+D1_SERIE
								If D1_PRCOMP == vAuxFrete[i,6] .and. !(D1_TIPO $ "C,I")
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Analisando a data da baixa do documento, caso seja a compensacao de um P.A ³
									//³ exibe a data de inclusao do P.A            							      ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									SE2->(dbSetOrder(6))
									SE2->(dbSeek(SD1->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_SERIE+D1_DOC)))
									
									SE5->(dbSetOrder(7))
									SE5->(dbSeek(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
									
									d_Baixa  := SE5->E5_DTDISPO
									c_DataPag:= ""
									
									If SE5->E5_RECPAG == "P" .And. SE5->E5_TIPODOC == "CP"
										c_Documen:= SE5->E5_DOCUMEN
										SE5->(dbSeek(SE2->E2_FILIAL+c_Documen,.T.))
										d_Baixa:= SE5->E5_DTDISPO
									Endif
									If d_Baixa < mv_par01
										c_DataPag:= Dtoc(d_Baixa) //"  PAGO EM: " + Dtoc(d_Baixa)
									Endif
									
									//               1         2         3          4     5               6          7         8         9    10
									AAdd( vFrete, {D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_DESCRI, D1_QUANT, D1_PRCOMP, c_DataPag, D1_NODI, 0 } )
									cFornPrin:= D1_FORNECE
									cLojPrin := D1_LOJA
									
								Endif
								dbSkip()
							Enddo
						Next
						SE2->(Dbgoto(nRecSE2))
						
					ElseIf Trim(cE2_ORIGEM) $ "FINA050,GPEM670"
						If cPrefixo+cNumero != cDocPrin
							AAdd( vItens, { Substr(cE2_HIST,1,55), 0, If(vFornec[x,9]=="R",vFornec[x,10],vFornec[x,11]), Space(Len(SD1->D1_NODI)), } )
						Endif 
						
						cRet := u_INObjJust(cE2_FILIAL,"4",cE2_NUM+cE2_PREFIXO+cE2_FORNECE+cE2_LOJA,mv_par15 <> 4)
						If !(cRet $ AllTrim(cJus))
							cJus := AllTrim(cJus) + If( Empty(cJus) , "", " ") + cRet
							cJus += If(SubStr(cJus,Len(cJus),1) == "." ,"", ".")
						Endif
					Else
						AAdd( vItens, { PADR(If(lFind,cHist,vFornec[x,14]),55), 0, If(vFornec[x,9]=="R",vFornec[x,10],vFornec[x,11]), Space(Len(SD1->D1_NODI)) } )
					Endif
					
					// Caso nao tenha sido adicionado algum item, adiciona linha em branco
					If Empty(vItens)
						AAdd( vItens, { Space(55), 0, If(vFornec[x,9]=="R",vFornec[x,10],vFornec[x,11]), Space(Len(SD1->D1_NODI)) } )
					Endif
					
					dbSelectArea("TMP")
					
					If nLin > 60 //.Or. lImpCCC
						nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
					Endif
					
					If lImpPed .or. Empty(cPedido)
						
						//- Fornecedor principal
						PesqCliFor(cE2_FILIAL,cFornPrin+cLojPrin)   // Posiciona no cliente / fornecedor do documento
						
						lPulou := .F.
						If !Empty(cPedido)
							//- Caso o pedido nãao tenha sido atendido ainda, pega o fornecedor do pedido
							SC7->(dbSetOrder(1))
							SC7->(dbSeek(cE2_FILIAL+cPedido))
							
							PesqCliFor(SC7->C7_FILIAL,SC7->C7_FORNECE+SC7->C7_LOJA)   // Posiciona no cliente / fornecedor do documento
							
							lAtendido:= .f.
							
							While SC7->(!Eof()) .And. cE2_FILIAL+cPedido == SC7->(C7_FILIAL+C7_NUM)
								If SC7->C7_QUJE != 0
									lAtendido:= .t.
									Exit
								Endif
								SC7->(dbSkip())
							Enddo
							
							// Se for um PA ou nao tiver nota pra imprimir pega os dados do pedido de compra
							If cE2_TIPO == "PA " .Or. Empty(vFrete) .and. !lAtendido
								SC7->(dbSeek(cE2_FILIAL+cPedido))
								While SC7->(!Eof()) .And. cE2_FILIAL+cPedido == SC7->(C7_FILIAL+C7_NUM)
									If cE2_TIPO == "PA " .Or. SC7->C7_QUJE = 0
										//                      1         2        3        4            5           6       7     8                                      9                  10
										AAdd( vFrete, {Space(06), "   ", SC7->C7_FORNECE, SC7->C7_LOJA, SC7->C7_DESCRI, SC7->C7_QUANT, SC7->C7_NUM, Space(11+Len(Dtoc(dDataBase))), Space(Len(SD1->D1_NODI)), SC7->C7_PRECO } )
										SC7->(dbSkip())
									Endif
								Enddo
							Endif
							@ nLin, 000      PSAY "Pedido: "+cPedido
							@ nLin, Pcol()+2 PSAY SubStr(cA2_NOME,1,38)
							@ nLin, Pcol()+2 PSAY Transform(cA2_CGC,"@R "+If(cA2_TIPO=="J".And.!Empty(cA2_CGC),"99.999.999/9999-99",Repli("9",18)))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verificando se o documento é um principal de um titulo de imposto e o pedido ³
							//³ esta prenchido, se estiver mostra a data do pagamento   				      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lPrinc
								nRecSE5:= SE5->(Recno())
								SE5->(dbSetOrder(7))
								SE5->(dbSeek(cE2_FILIAL+cE2_PREFIXO+cE2_NUM+cE2_PARCELA+cE2_TIPO+cE2_FORNECE+cE2_LOJA))
								d_Baixa:= SE5->E5_DTDISPO
								If SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC == "CP"
									c_Documen:= SE5->E5_DOCUMEN
									SE5->(dbSeek(cE2_FILIAL+c_Documen,.T.))
									d_Baixa:= SE5->E5_DTDISPO
								Endif
								If d_Baixa < mv_par01
									@ nLin, Pcol()+2 PSAY "PAGO EM: "+ Dtoc(d_Baixa)
								Endif
								SE5->(Dbgoto(nRecSE5))
								
								dPagamento := d_Baixa
							Endif
							nLin++
							lPulou := .T.
						ElseIf vFornec[x,2]+vFornec[x,3] != cFornPrin+cLojPrin .and. Trim(cE2_ORIGEM) == "MATA100"
							If lImpDoc
								@ nLin,000      PSAY cSPData
								@ nLin,PCol()+2 PSAY SubStr(cA2_NOME,1,40)
								@ nLin,PCol()+2 PSAY Transform(cA2_CGC,"@R "+If(cA2_TIPO=="J".And.!Empty(cA2_CGC),"99.999.999/9999-99",Repli("9",18)))
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verificando se o documento é um principal de um titulo de imposto, se for ³
								//³ mostra a data do pagamento do principal            				          ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If lPrinc
									nRecSE5:= SE5->(Recno())
									SE5->(dbSetOrder(7))
									SE5->(dbSeek(cE2_FILIAL+cE2_PREFIXO+cE2_NUM+cE2_PARCELA+cE2_TIPO+cE2_FORNECE+cE2_LOJA))
									d_Baixa:= SE5->E5_DTDISPO
									If SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC == "CP"
										c_Documen:= SE5->E5_DOCUMEN
										SE5->(dbSeek(cE2_FILIAL+c_Documen,.T.))
										d_Baixa:= SE5->E5_DTDISPO
									Endif
									If d_Baixa < mv_par01
										@ nLin,171 PSAY "PAGO EM: "+ Dtoc(d_Baixa)
									Endif
									SE5->(Dbgoto(nRecSE5))
									
									dPagamento := d_Baixa
								Endif
								nLin++
								lPulou  := .T.
								lImpDoc := .F.
							Endif
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Imprimindo dados da nota fiscal de compras caso seja despesa com frete. ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Len(vFrete) > 0
							If lPulou
								nLin--
							Endif
							For i:= 1 to Len(vFrete)
								If nLin > 60
									nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
								Endif
								@ nLin,000      PSAY cSPData
								@ nLin,PCol()+2 PSAY cSPForn
								@ nLin,PCol()+2 PSAY cSPCNPJ
								@ nLin,PCol()+2 PSAY vFrete[i, 2]+"-"+vFrete[i,1]          //- Documento
								@ nLin,PCol()+2 PSAY vFrete[i, 9]                          //- No. da DI
								@ nLin,PCol()+2 PSAY PADR(vFrete[i, 5],55)                 //- Produto
								@ nLin,PCol()+2 PSAY vFrete[i, 6] Picture "@EZ 99999"      //- Quantidade
								@ nLin,PCol()+2 PSAY PADR(vFrete[i, 8],10)                 //- Data de pagamento
								@ nLin,PCol()+1 PSAY vFrete[i,10] Picture "@EZ 999,999.99" //- Valor do Item
								nLin++
							Next
						Endif
						If !Empty(cPedido)
							@ nLin,000 PSAY Repli("-",Limite)
							nLin++
						Endif
						lImpPed := .F.
					Endif
					
					PesqCliFor(cE2_FILIAL,vFornec[x,2]+vFornec[x,3])   // Posiciona no cliente / fornecedor do documento
					
					// Acerta arredondamento dos itens
					vOk := u_Arredonda(If(vFornec[x,9]=="R",vFornec[x,10],vFornec[x,11]),vItens,3)
					
					For y:=1 to Len(vItens)
						If nLin > 60
							nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
						Endif
						
						If y == 1
							@ nLin,000      PSAY PADR(Dtoc(vFornec[x,4]),10)
							@ nLin,PCol()+2 PSAY PADR(Trim(If(Empty(vFornec[x,6]), cA2_NOME, vFornec[x,6])),40)
							@ nLin,PCol()+2 PSAY Transform(cA2_CGC,"@R "+If(cA2_TIPO=="J".And.!Empty(cA2_CGC),"99.999.999/9999-99",Repli("9",18)))
							@ nLin,PCol()+2 PSAY cPrefixo+"-"+cNumero
						Else
							@ nLin,000      PSAY cSPData
							@ nLin,PCol()+2 PSAY cSPForn
							@ nLin,PCol()+2 PSAY cSPCNPJ
							@ nLin,PCol()+2 PSAY cSPDocm
						EndIf
						@ nLin,PCol()+2 PSAY vItens[y,4]                      //- No. da DI
						@ nLin,PCol()+2 PSAY PADR(vItens[y,1],55)             //- Descricao
						@ nLin,PCol()+2 PSAY vItens[y,2]  Picture "@EZ 99999" //- Quantidade
						
						nCEnt := PCol()+2
						If vFornec[x,9] == "R" //- Entrada
							@ nLin,nCEnt PSAY vOk[y,1] Picture "@EZ 999,999,999.99"
							nCSai := PCol()+2
							@ nLin,nCSai PSAY 0        Picture "@EZ 999,999,999.99"
						Else                   //- Saida
							@ nLin,nCEnt PSAY 0        Picture "@EZ 999,999,999.99"
							nCSai := PCol()+2
							@ nLin,nCSai PSAY vOk[y,1] Picture "@EZ 999,999,999.99"
						Endif
						@ nLin,PCol()+2 PSAY vOk[y,1]*If(vFornec[x,9] == "R",-1,1) Picture "@EZ 999,999,999.99"
						
						If Len(vItens) == 1
							@ nLin,PCol()+2 PSAY vFornec[x,18]
							@ nLin,PCol()   PSAY u_NomeFilial(vFornec[x,1])
						Endif
						nLin++
						
						If lFirst
							lFirst := .F.
							u_AddCSV({Titulo})
							u_AddCSV({ "FILIAL", "PEDIDO", "DATA", "PAGAMENTO", "FORNEDOR", "CNPJ", "DOCUMENTO", "PRODUTO", "MCT", "PROJETO", "HISTORICO", "ENTRADA", "SAIDA", "JUSTIFICATIVA"})
						Endif
						
						// Atualiza o arquivo Excel com os dados do MCT
						u_AddCSV({	vFornec[x,1],;                      // Filial
										cPedido,;                           // Pedido
										vFornec[x,4],;                      // Data
										dPagamento,;                        // Pagamento
										cA2_NOME,;                          // Fornecedor
										Transform(cA2_CGC,"@R "+If(cA2_TIPO=="J".And.!Empty(cA2_CGC),"99.999.999/9999-99",Repli("9",18))),;
										cPrefixo+"-"+cNumero,;              // Documento
										vItens[y,1],;                       // Descrição do produto
										Trim(Posicione("CTH",1,XFILIAL("CTH")+vFornec[x,7],"CTH_DESC01")),;                      // Classe de valor
										Trim(CTT->CTT_DESC01),;             // Descrição da projeto
										AllTrim(vItens[y,1]),;              // Histórico
										If(vFornec[x,9]=="R",vOk[y,1],0),;  // Entrada
										If(vFornec[x,9]<>"R",vOk[y,1],0),;  // Saída
										AllTrim(cJus)})                     // Justificativa
					Next
					If Len(vItens) > 1
						If vFornec[x,9] == "R" //- Entrada
							@ nLin,nCEnt-1 PSAY "----------------"
							@ nLin,nCSai-1 PSAY "                "
							@ nLin,PCol()  PSAY "----------------"
							nLin++
							@ nLin,nCEnt   PSAY vFornec[x,10] Picture "@E 999,999,999.99"
							@ nLin,nCSai   PSAY 0             Picture "@EZ 999,999,999.99"
						Else                   //- Saida
							@ nLin,nCSai-1 PSAY "----------------"
							@ nLin,PCol()  PSAY "----------------"
							nLin++
							@ nLin,nCSai   PSAY vFornec[x,11] Picture "@E 999,999,999.99"
						Endif
						@ nLin,PCol()+2 PSAY vFornec[x,11]-vFornec[x,10] Picture "@E 999,999,999.99"
						@ nLin,PCol()+2 PSAY vFornec[x,18]
						@ nLin,PCol()   PSAY u_NomeFilial(vFornec[x,1])
						nLin++
					Endif
					nSomaEnt   += vFornec[x,10]
					nSomaSai   += vFornec[x,11]
					vTotDoc[1] += vFornec[x,10]
					vTotDoc[2] += vFornec[x,11]
					
					// Caso tenha sido impresso o titulo principal nao permite o cabecalho do fornecedor para os titulos
					// de impostos
					If !(vFornec[x,12] $ "TX ,INS,ISS")
						lImpDoc := .F.
					Endif
				Next
				
				//- Fim do for next pelo numero do documento
				If Empty(cPedido)  // Se vazio, imprime logo e a justificativa para a nota
					If Len(vFornec) > 1 .And. (vTotDoc[1] <> 0 .Or. vTotDoc[2] <> 0)
						If nLin > 59
							nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
						Endif
						If vTotDoc[1] <> 0
							@ nLin,nCEnt-1 PSAY "----------------"
						Endif
						If vTotDoc[2] <> 0
							@ nLin,nCSai-1 PSAY "----------------"
						Endif
						@ nLin,nCSai+15  PSAY "----------------"
						nLin++
						@ nLin,000   PSAY "Total do Documento: "+cPrefixo+"-"+cNumero
						@ nLin,nCEnt PSAY vTotDoc[1] Picture "@EZ 999,999,999.99"
						@ nLin,nCSai PSAY vTotDoc[2] Picture "@EZ 999,999,999.99"
						@ nLin,PCol()+2 PSAY vTotDoc[2]-vTotDoc[1] Picture "@E 999,999,999.99"
						nLin++
					Endif
					ImpObjJus(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,@nLin,cObj,cJus)
					
					If Empty(cObj) .and. Empty(cJus) .and. (!TMP->(Eof()) .And. TMP->E5_MOVBCO == "2") .And. (Len(vFornec) = 1 .or. vTotDoc[1] <> 0 .or. vTotDoc[2] <> 0)
						@ nLin,000 PSAY Repli("-",Limite)
						nLin++
					Endif
					cObj := ""      // Limpa variavel para nao imprimir novamente
					cJus := ""      // Limpa variavel para nao imprimir novamente
				Endif
			Enddo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime a justificativa do pedido de compra          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ImpObjJus(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,@nLin,cObj,cJus)
			
			If nSomaEnt <> 0 .Or. nSomaSai <> 0
				If !Empty(cPedido)
					If nLin > 60
						nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
					Endif
					nLin++
					@ nLin,000   PSAY "Total do Pedido: "+cPedido
					@ nLin,nCEnt PSAY nSomaEnt Picture "@EZ 999,999,999.99"
					@ nLin,nCSai PSAY nSomaSai Picture "@EZ 999,999,999.99"
					@ nLin,PCol()+2 PSAY nSomaSai-nSomaEnt Picture "@EZ 999,999,999.99"
					nLin++
				Endif
				@ nLin,000 PSAY __PrtThinLine()  //Repli("-",Limite)
				nLin++
				nEntCC += nSomaEnt
				nSaiCC += nSomaSai
			Endif
		Enddo
		If nEntCC <> 0 .Or. nSaiCC <> 0
			If nLin > 60
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			@ nLin,000   PSAY "Total do Projeto: "+cCCusto+" - "+Trim(CTT->CTT_DESC01)
			@ nLin,nCEnt PSAY nEntCC Picture "@EZ 999,999,999.99"
			@ nLin,nCSai PSAY nSaiCC Picture "@EZ 999,999,999.99"
			@ nLin,PCol()+2 PSAY nSaiCC-nEntCC Picture "@EZ 999,999,999.99"
			nLin++
			@ nLin,000 PSAY Repli("=",Limite)
			nLin++
			nTotEnt += nEntCC
			nTotSai += nSaiCC
			AADD(aResumo,{cCCusto, CTT->CTT_DESC01, nEntCC, nSaiCC })
		Endif
	Enddo
	If Len(aResumo) > 0 .and. mv_par13 = 1
		nTotEnt:= 0.00
		nTotSai:= 0.00
		
		nLin  := 80
		
		Titulo:= "Resumo de " + _cTitulo + " - " + Dtoc(mv_par01) + " a " + Dtoc(mv_par02)
		Cabec1:= "Codigo     Descricao                                        Entrada           Saida            Saldo"
		//        zzzzzzzzz  zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz  999,999,999.99  999,999,999.99   999,999,999.99
		//        0123456789012345678901234567890123456567890123456789012345678901345678901234567890123456789012345678
		//        0         1         2         3           4         5         7        9        10
		Cabec2:= ""
		
		nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		
		For i:= 1 to Len(aResumo)
			If nLin > 60
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			@ nLin, 000      PSay aResumo[i][1]
			@ nLin, Pcol()+2 PSay aResumo[i][2]
			@ nLin, Pcol()+2 PSay aResumo[i][3] Picture "@E 999,999,999.99"
			@ nLin, Pcol()+2 PSay aResumo[i][4] Picture "@E 999,999,999.99"
			nTotEnt += aResumo[i][3]
			nTotSai += aResumo[i][4]
			nLin++
		Next
		nSaldo:= nTotSai - nTotEnt
		nLin++
		@ nLin, 000      PSay Space(Len(aResumo[1][1]+aResumo[1][2])+2)
		@ nLin, Pcol()+2 PSay nTotEnt Picture "@E 999,999,999.99"
		@ nLin, Pcol()+2 PSay nTotSai Picture "@E 999,999,999.99"
		@ nLin, Pcol()+3 PSay nSaldo  Picture "@E 999,999,999.99"
	Endif
	dbSelectArea("TMP")
	
	If !lFirst .And. !Empty(cCsvArq)
		u_AddCSV(AFill(Array(12),""))
	Endif
	
	If !_lCallMe
		dbCloseArea()
		
		u_INRunExcel(cCsvPath,cCsvArq)   //abrir arquivo csv
		
		If aReturn[5]==1
			dbCommitAll()
			SET PRINTER TO
			OurSpool(wnrel)
		Endif
		MS_FLUSH()
	Endif
Return

Static Function ImpObjJus(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,nLin,cObj,cJus)
	Local vLinha, x
	vLinha := u_QuebraLinha(cObj,cJus,170)
	If !Empty(vLinha)
		For x:=1 To Len(vLinha)
			If nLin > 60
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			If x == 1
				nLin++
				@ nLin,000 PSAY "Justificativa:"
				nLin++
			Endif
			@ nLin,000 PSAY vLinha[x,2]
			nLin++
		Next
		@ nLin,000 PSAY Repli("-",Limite)
		nLin++
	Endif
Return

Static Function BuscaPrinc(cFilTit,cPrfTit,cNumTit,cForTit,cLjTit,cTpTit,cParcTit,lFind)
	Local lAchou := .F.
	
	If cTpTit $ "TX ,INS,ISS" .And. !Empty(cParcTit)
		SE2->(dbSetOrder(1))
		SE2->(dbSeek(cFilTit+cPrfTit+cNumTit,.T.))
		While !SE2->(Eof()) .And. cFilTit+cPrfTit+cNumTit == SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM)
			If !(SE2->E2_TIPO $ "TX ,INS,ISS")
				If (cTpTit == "ISS" .And. SE2->E2_PARCISS == cParcTit) .Or.;
					(cTpTit == "INS" .And. SE2->E2_PARCINS == cParcTit) .Or.;
					(cTpTit == "TX " .And. SE2->E2_PARCIR  == cParcTit) .Or.;
					(cTpTit == "TX " .And. SE2->E2_PARCSLL == cParcTit) .Or.;
					(cTpTit == "TX " .And. SE2->E2_PARCCOF == cParcTit) .Or.;
					(cTpTit == "TX " .And. SE2->E2_PARCPIS == cParcTit)
					lAchou := .T.
					Exit
				Endif
			Endif
			SE2->(dbSkip())
		Enddo
	Endif
	
	lFind := lAchou
	If !lAchou
		SE2->(dbSetOrder(6))
		lFind := SE2->(dbSeek(cFilTit+cForTit+cLjTit+cPrfTit+cNumTit+cParcTit+cTpTit))
	Endif
	
Return lAchou

Static Function PesqCliFor(cFilSE2,cSeek)
	
	If Trim(cE2_ORIGEM) == "MATA460"
		//- Cliente
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(XFILIAL("SA1")+cSeek))
		
		cA2_NOME := PADR(SA1->A1_NOME,Len(SA2->A2_NOME))
		cA2_CGC  := SA1->A1_CGC
		cA2_TIPO := SA1->A1_TIPO
	Else
		//- Fornecedor
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(cFilSE2+cSeek))
		
		cA2_NOME := SA2->A2_NOME
		cA2_CGC  := SA2->A2_CGC
		cA2_TIPO := SA2->A2_TIPO
	Endif
	
Return

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data                  ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data               ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Do Projeto               ",29)+"?","","","mv_ch3","C", 9,0,0,"G","","CTT","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate o Projeto            ",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Classe MCT               ",29)+"?","","","mv_ch5","C", 9,0,0,"G","","CTH","","","mv_par05")
	u_INPutSX1(cPerg,"06",PADR("Do Documento             ",29)+"?","","","mv_ch6","C", 9,0,0,"G","","   ","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Ate o Documento          ",29)+"?","","","mv_ch7","C", 9,0,0,"G","","   ","","","mv_par07")
	u_INPutSX1(cPerg,"08",PADR("Do Prefixo               ",29)+"?","","","mv_ch8","C", 3,0,0,"G","","   ","","","mv_par08")
	u_INPutSX1(cPerg,"09",PADR("Ate o Prefixo            ",29)+"?","","","mv_ch9","C", 3,0,0,"G","","   ","","","mv_par09")
	u_INPutSX1(cPerg,"10",PADR("Considera Filiais a baixo",29)+"?","","","mv_cha","N", 1,0,0,"C","","   ","","","mv_par10","Sim","","","","Nao")
	u_INPutSX1(cPerg,"11",PADR("Da Filial                ",29)+"?","","","mv_chb","C", 2,0,0,"G","","   ","","","mv_par11")
	u_INPutSX1(cPerg,"12",PADR("Ate a Filial             ",29)+"?","","","mv_chc","C", 2,0,0,"G","","   ","","","mv_par12")
	u_INPutSX1(cPerg,"13",PADR("Imprime resumo           ",29)+"?","","","mv_chd","N", 1,0,0,"C","","   ","","","mv_par13","Sim","","","","Nao")
	u_INPutSX1(cPerg,"14",PADR("Considera P.A.           ",29)+"?","","","mv_che","N", 1,0,0,"C","","   ","","","mv_par14","Sim","","","","Nao")
	u_INPutSX1(cPerg,"15",PADR("Imprime relatorio por    ",29)+"?","","","mv_chf","N", 1,0,0,"C","","   ","","","mv_par15","Caixa","","","","Competencia",;
							"","","Contabil","","","Base MCT")
	u_INPutSX1(cPerg,"16",PADR("Do Pedido                ",29)+"?","","","mv_chg","C", 6,0,0,"G","","   ","","","mv_par16")
	u_INPutSX1(cPerg,"17",PADR("Ate o Pedido             ",29)+"?","","","mv_chh","C", 6,0,0,"G","","   ","","","mv_par17")
	u_INPutSX1(cPerg,"18",PADR("Considera estornos       ",29)+"?","","","mv_chi","N", 1,0,0,"C","","   ","","","mv_par18","Sim","","","","Nao")
Return
