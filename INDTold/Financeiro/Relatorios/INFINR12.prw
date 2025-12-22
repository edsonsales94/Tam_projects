#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de despesas de Viagem                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico INDT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INFINR12(_cProj,_cTitulo,_cProg,_cPerg,_vPerg,_lCallMe,_cMCT)
	Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2 := "de acordo com os parametros informados pelo usuario."
	Local cDesc3 := If( _cTitulo == Nil , "Despesas com Viagem", _cTitulo)
	Local titulo := cDesc3
	Local nLin   := 80
	Local Cabec2 := ""
	Local aOrd   := {}
	Local cPerg  := PADR("INFINR12",Len(SX1->X1_GRUPO))
	Local Cabec1 := "Dat Pgto   Favorecido                      No. NF         C.Contabil   Despesa                                    Historico                                         Entrada            Saida            Saldo   Local"
	//               99/99/9999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXX/999999999  9999999999   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999,999,999.99   999,999,999.99   999,999,999.99   XXX
	//               01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789023456789023456789012345678901234567890123456789012345678901234567890
	//               0         1         2         3         4         5         6         7         8         9        10        11        12        13        14       15       16        17        18        19        20        21
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	_lCallMe := If( _lCallMe == Nil , .F., _lCallMe)
	
	If !_lCallMe
		Private Limite   := 220
		Private Tamanho  := "G"
		Private Nomeprog := If( _cProg == Nil , "INFINR12", _cProg)
		Private nTipo    := 15
		Private aReturn  := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
		Private nLastKey := 0
		Private m_pag    := 01
		Private wnrel    := "INFINR12"
		Private cString  := "SE5"
		
		Private cCsvPath := ""
		Private cCsvArq  := ""
		Private nHdl     := 0
		
		wnrel := SetPrint(cString,Nomeprog,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
		
		If nLastKey == 27
			Return
		Endif
		
		SetDefault(aReturn,cString)
		
		If nLastKey == 27
			Return
		Endif
		nTipo:= If(aReturn[4]==1,15,18)
	Else
		// Atualiza os parametros digitados pelo usuario para o relatorio aglutinado
		mv_par01 := _vPerg[1]     // Da Data
		mv_par02 := _vPerg[2]     // Ate a Data
		mv_par03 := Repli(" ",Len(mv_par03)) // Da Viagem
		mv_par04 := Repli("Z",Len(mv_par04)) // Ate Viagem
		mv_par05 := _vPerg[5]     // Considera filiais abaixo
		mv_par06 := _vPerg[6]     // Da filial
		mv_par07 := _vPerg[7]     // Ate a filial
		mv_par08 := 2             // Quebra por pagina (1=Sim 2=Nao)
		mv_par09 := 1             // Imprime resumo
		mv_par10 := _cProj        // Do centro de custo
		mv_par11 := _cProj        // Ate o centro de custo
		mv_par12 := PADR(_cMCT,9) // Classe MCT
		mv_par13 := _vPerg[8]     // Considera PA's
		mv_par14 := _vPerg[9]     // Imprime Relatorio por: Caixa  Competencia
		mv_par15 := _vPerg[10]    // Considera estorno: Sim  Nao
		
		If mv_par14 == 4          // Caso tenha sido escolhida a opção Hibrido
			mv_par14 := 1          // O relatório será impresso por Caixa
		Endif
	Endif
	
	Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin,_lCallMe) }, "Filtrando dados")
Return

////////////////////////////////////////////////////////////
Static function ExecProc(Cabec1,Cabec2,Titulo,nLin,_lCallMe)
	Local aStru, cArq, cInd, cQry, cQPA
	Local cTpImp := MVISS+";"+MVINSS+";"+MVTAXA+";"+MVTXA
	
	If !_lCallMe
		If mv_par14 < 3  // Se não for a opção Contábil ou Base MCT
			Titulo := AllTrim(Titulo) + " (Base Oficial)"
			If mv_par14 == 1
				Titulo += " - Caixa"
			Else
				Titulo += " - Competencia"
				cQry   := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
				
				If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
					cQry += "E2_FILIAL >= '"+mv_par06+"' AND E2_FILIAL <= '"+mv_par07+"' AND "
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
				cArq := u_INDADCOMP(cQry,mv_par01,mv_par02,,,mv_par10,mv_par11,mv_par05,mv_par06,mv_par07,mv_par12,mv_par13,"C")
			Endif
			
			aStru := SE5->(dbStruct())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processando Saidas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQry := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE5")+" WHERE D_E_L_E_T_ <> '*' AND "
			cQry += "E5_DTDISPO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND "
			
			If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += "E5_FILIAL >= '"+mv_par06+"' AND E5_FILIAL <= '"+mv_par07+"' AND "
			Else
				cQry += "E5_FILIAL = '"+xFilial("SE5")+"' AND "
			Endif
			cQry += "E5_RECPAG = 'P' AND "+u_CondPadRel()
			
			If mv_par14 == 1   // Se for Caixa
				// - D= Ref. Despesas financeiras                             FIN MAT GPE
				Processa({|| cArq := u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par13,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
			Else
				cQry += " AND E5_CCD >= '"+mv_par10+"' AND E5_CCD <= '"+mv_par11+"'"
				cQry += " AND E5_CLVLDB = '"+mv_par12+"' AND E5_MOTBX = ' '"
				
				// - D= Ref. Despesas financeiras                   FIN MAT GPE
				Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par13,"D",.F.,,,.T.) },"Filtro de Dados","Filtrando Saidas...")
				
				If mv_par13 == 1  // Se considera PA
					// Processa os estornos de PA's
					cQPA := "(E5_MOTBX = ' ' OR (E5_MOTBX = 'DEB' AND E5_TIPO IN "+FormatIn(MVPAGANT,"|")+"))"
					cQry := StrTran(cQry,"E5_MOTBX = ' '", cQPA)
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processando as entrada ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQry := StrTran(cQry,"E5_RECPAG = 'P'","E5_RECPAG = 'R'")
			
			// - D= Ref. Despesas financeiras                     FIN MAT GPE
			Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par13,"D",.F.,,,mv_par14==2) },"Filtro de Dados","Filtrando Entradas...")
		ElseIf mv_par14 == 3  // Se for a opção Contábil
			Titulo := AllTrim(Titulo) + " (Base Oficial) - Contabil"
			
			cQry := "SELECT COUNT(*) SOMA FROM "+RetSQLName("CT2")+" CT2 WHERE D_E_L_E_T_ <> '*'"
			cQry += " AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
			cQry += " AND ((CT2_CCD >= '"+mv_par10+"' AND CT2_CCD <= '"+mv_par11+"')"
			cQry += " OR (CT2_CCC >= '"+mv_par10+"' AND CT2_CCC <= '"+mv_par11+"'))"
			
			// Busca e filtra Classe MCT pelo Plano de Contas
			cQry += " AND ("
			cQry += " (CT2_DC IN ('1','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_DEBITO = CT1_CONTA AND CT1_GRUPO = '"+mv_par12+"'))"
			cQry += " OR"
			cQry += " (CT2_DC IN ('2','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_CREDIT = CT1_CONTA AND CT1_GRUPO = '"+mv_par12+"')))"
			
			If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND CT2_FILIAL >= '"+mv_par06+"' AND CT2_FILIAL <= '"+mv_par07+"'"
			Else
				cQry += " AND CT2_FILIAL = '"+xFilial("CT2")+"'"
			Endif
			
			// Rotina de Busca de Dados --> INFINP04.PRW
			Processa({|| cArq := u_INFINP04("TMP",cQry,"D",.T.,.T.,mv_par15==1) },"Filtro de Dados","Filtrando Saidas...")
		Else // Se não for a opção Base MCT
			Titulo := AllTrim(Titulo) + " (Base MCT)"
			
			cQry := "SELECT COUNT(*) SOMA"
			cQry += " FROM "+RetSQLName("SZ3")+" SZ3"
			cQry += " WHERE SZ3.D_E_L_E_T_ = ' '"
			
			If mv_par05 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND SZ3.Z3_FILIAL >= '"+mv_par06+"' AND SZ3.Z3_FILIAL <= '"+mv_par07+"'"
			Else
				cQry += " AND SZ3.Z3_FILIAL = '"+xFilial("SZ3")+"'"
			Endif
			
			cQry += " AND SZ3.Z3_DTDISPO >= '"+Dtos(mv_par01)+"' AND SZ3.Z3_DTDISPO <= '"+Dtos(mv_par02)+"'"
			cQry += " AND SZ3.Z3_VIAGEM >= '"+mv_par03+"' AND SZ3.Z3_VIAGEM <= '"+mv_par04+"'"
			cQry += " AND SZ3.Z3_CC >= '"+mv_par10+"' AND SZ3.Z3_CC <= '"+mv_par11+"'"
			cQry += " AND SZ3.Z3_CLVL = '"+mv_par12+"'"
			
			// Rotina de Busca de Dados --> INFINP08.PRW
			Processa({|| cArq := u_INFINP08("TMP",cQry,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
		Endif
	Endif
	
	cInd := CriaTrab(NIL ,.F.)
	cKey := "E5_VIAGEM+E5_CC+Dtos(E5_DTDISPO)"
	
	IndRegua("TMP",cInd,cKey,,,"Selecionando Registros...")
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,_lCallMe) },Titulo)
	
	If !_lCallMe
		FErase(cArq+".DBF")
	Else
		dbClearIndex()
	Endif
	FErase(cInd+".IDX")
	
Return

/////////////////////////////////////////////////////////////
Static function RunReport(Cabec1,Cabec2,Titulo,nLin,_lCallMe)
	Local x, i, vLinha, cCodViagem, cJustifi, cViagem, cDestino, cViajante, dIda, dVolta
	Local cOrigem, nTotalSai, nTotalEnt, nEntVia, nSaiVia, nEntCC, nSaiCC, nCEnt, nCSai, cE5_FILIAL
	Local nTamDoc := TamSX3("E2_NUM")[1]
	Local aViagem := {}
	Local lFirst  := .T.
	
	Titulo   += "  " + Dtoc(mv_par01) + " a " + Dtoc(mv_par02)
	
	dbSelectArea("TMP")
	SetRegua(RecCount())
	
	If !(Eof() .And. Bof())
		If Empty(cCsvArq)            // Se ainda não foi informado
			cCsvPath := GetTempPath() //path do arquivo texto
			cCsvArq  := Trim(wnrel)+".xls"  //nome do arquivo csv
			nHdl     := fCreate(cCsvPath+cCsvArq)   //arquivo para trabalho
		Endif
	Endif
	
	dbGoTop()
	
	While !Eof()
		
		IncRegua()
		
		If E5_CC < mv_par10 .Or. E5_CC > mv_par11 .Or. E5_VIAGEM < mv_par03 .Or. E5_VIAGEM > mv_par04 .Or.;
			E5_STATUS <> "S" .Or. E5_CLVL <> mv_par12 .Or. If( mv_par14 == 1 , E5_BAICOMP == "C", E5_BAICOMP <> "C")
			dbSkip()
			Loop
		Endif
		
		cE5_FILIAL := If( Empty(E5_FILIAL) .Or. Empty(E5_FILORIG) , E5_FILIAL, E5_FILORIG)
		cCodViagem := E5_VIAGEM
		cJustifi   := " "
		cViagem    := PADR("VIAGEM NAO ENCONTRADA !!!",Len(SZ7->Z7_DESCRI))
		cDestino   := Space(Len(SZ7->Z7_DESTINO))
		cViajante  := Space(Len(SZ7->Z7_NOME))
		cDestino   := Space(Len(SZ7->Z7_DESTINO))
		dIda       := Ctod("")
		dVolta     := Ctod("")
		
		//- Cadastro de Viagens
		SZ7->(dbSetOrder(1)) //Filial + Codigo
		If SZ7->(dbSeek(cE5_FILIAL+cCodViagem))
			cViagem   := SZ7->Z7_DESCRI
			cDestino  := SZ7->Z7_DESTINO
			cViajante := SZ7->Z7_NOME
			cDestino  := SZ7->Z7_DESTINO
			dIda      := SZ7->Z7_IDA
			dVolta    := SZ7->Z7_VOLTA
			
			//- Justificativas de Viagens
			cJustifi := u_INObjJust(cE5_FILIAL,"3",PADR(cCodViagem,nTamDoc),mv_par14 <> 4)
		Endif
		
		If mv_par08 = 1 //- Quebra pagina por viagem
			nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		ElseIf nLin > 60
			nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		Endif
		nLin:= CabViagem(nLin,cCodViagem,cViagem,cDestino,cViajante,dIda,dVolta) + 1
		
		nEntVia := 0
		nSaiVia := 0
		nCEnt   := 0   // Posição da coluna de entrada
		nCSai   := 0   // Posição da coluna de saída
		
		While !Eof() .And. E5_VIAGEM == cCodViagem
			
			Incregua()
			
			If E5_CC < mv_par10 .Or. E5_CC > mv_par11 .Or. E5_STATUS <> "S" .Or. E5_CLVL <> mv_par12 .Or. If( mv_par14 == 1 , E5_BAICOMP == "C", E5_BAICOMP <> "C")
				dbSkip()
				Loop
			Endif
			
			If nLin > 60
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				nLin:= CabViagem(nLin,cCodViagem,cViagem,cDestino,cViajante,dIda,dVolta) + 1
			Endif
			
			cCCusto := E5_CC
			nEntCC  := 0
			nSaiCC  := 0
			
			//- Centro de custo
			CTT->(dbSetOrder(1))
			CTT->(dbSeek(XFILIAL("CTT")+cCCusto))
			
			While !Eof() .And. E5_CC+E5_VIAGEM = cCCusto+cCodViagem
				
				IncRegua()
				
				If E5_STATUS <> "S" .Or. E5_CLVL <> mv_par12 .Or. If( mv_par14 == 1 , E5_BAICOMP == "C", E5_BAICOMP <> "C")
					dbSkip()
					Loop
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verificando a origem do documento, se for o financeiro, o historico ³
				//³ sera o historico do documento, se for o compras sera a descricao    ³
				//³ do produto                                                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SE2->(dbSetOrder(1))
				If SE2->(dbSeek(cE5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA))
					If Trim(SE2->E2_ORIGEM) == "MATA100"
						cOrigem := BscHistCmp(cE5_FILIAL+TMP->(E5_NUMERO+E5_PREFIXO+E5_CLIFOR+E5_LOJA))
					Else
						cOrigem := SE2->E2_HIST
					Endif
				Else
					cOrigem := ""
				Endif
				
				If nLin > 60
					nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
					nLin:= CabViagem(nLin,cCodViagem,cViagem,cDestino,cViajante,dIda,dVolta) + 1
				Endif
				@ nLin,000      PSAY PADR(Dtoc(E5_DTDISPO),10)
				@ nLin,PCol()+1 PSAY PADR(TMP->E5_BENEF,30)
				@ nLin,PCol()+2 PSAY E5_PREFIXO+"/"+E5_NUMERO
				@ nLin,PCol()+2 PSAY PADR(TMP->E5_CONTAB,10)  //- C.Contabil
				@ nLin,PCol()+3 PSAY TMP->E5_DESCT1
				@ nLin,PCol()+3 PSAY Padr(cOrigem,40)
				
				nCEnt := PCol()+3
				If E5_RECPAG == "R" //- Entrada
					@ nLin,nCEnt PSAY E5_VALOR Picture "@E 999,999,999.99"
					nCSai := PCol()+3
					@ nLin,nCSai PSAY 0        Picture "@EZ 999,999,999.99"
					nEntVia += E5_VALOR
					nEntCC  += E5_VALOR
				Else
					@ nLin,nCEnt PSAY 0        Picture "@EZ 999,999,999.99"
					nCSai := PCol()+3
					@ nLin,nCSai PSAY E5_VALOR Picture "@E 999,999,999.99"
					nSaiVia += E5_VALOR
					nSaiCC  += E5_VALOR
				Endif
				@ nLin,PCol()+3 PSAY E5_VALOR*If(E5_RECPAG=="R",-1,1) Picture "@E 999,999,999.99"
				@ nLin,PCol()+2 PSAY TMP->E5_MANUAL
				@ nLin,PCol()   PSAY u_NomeFilial(E5_FILIAL)
				nLin++
				
				If lFirst
					lFirst := .F.
					u_AddCSV({Titulo})
					u_AddCSV({ "FILIAL", "VIAGEM", "DESTINO", "IDA", "VOLTA", "VIAJANTE", "DATA", "MCT", "PROJETO", "HISTORICO", "ENTRADA", "SAIDA", "JUSTIFICATIVA", "PREIXO/TITULO", "VENCTO.REAL"})
				Endif
				
				// Atualiza o arquivo Excel com os dados do MCT
				u_AddCSV({	E5_FILIAL,E5_VIAGEM,Trim(cDestino),dIda,dVolta,Trim(cViajante),E5_DTDISPO,Trim(Posicione("CTH",1,XFILIAL("CTH")+E5_CLVL,"CTH_DESC01")),;
							AllTrim(CTT->CTT_DESC01),AllTrim(cOrigem), If( E5_RECPAG == "R" , E5_VALOR, 0), If( E5_RECPAG <> "R" , E5_VALOR, 0),AllTrim(cJustifi),;
							E5_PREFIXO+"/"+E5_NUMERO, Dtoc(SE2->E2_VENCREA)})
				
				DbSkip()
			Enddo
			@ nLin,000 PSAY Replicate("-",Limite)
			nLin++
			
			nSaldo := nSaiCC - nEntCC
			
			@ nLin,000   PSAY cCCusto + " - " + PADR(CTT->CTT_DESC01,40)
			@ nLin,nCEnt PSAY nEntCC Picture "@E 999,999,999.99"
			@ nLin,nCSai PSAY nSaiCC Picture "@E 999,999,999.99"
			@ nLin,PCol()+3 PSAY nSaiCC-nEntCC Picture "@E 999,999,999.99"
			nLin++
			
			@ nLin,000 PSAY Replicate("-",Limite)
			nLin++
		Enddo
		
		AADD(aViagem,{cCodViagem, cViagem, nEntVia, nSaiVia } )
		
		If !Empty(vLinha := u_QuebraLinha("",cJustifi,158))
			If nLin > 60
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				nLin:= CabViagem(nLin,cCodViagem,cViagem,cDestino,cViajante,dIda,dVolta) + 1
			Endif
			nLin++
			@ nLin,000 PSAY "Justificativa:"
			nLin++
			
			For x:=1 To Len(vLinha)
				If nLin > 60
					nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
					nLin:= CabViagem(nLin,cCodViagem,cViagem,cDestino,cViajante,dIda,dVolta) + 1
				Endif
				@ nLin,000 PSAY vLinha[x,2]
				nLin++
			Next
		Endif
		nSaldo := nSaiVia - nEntVia
		
		@ nLin,009   PSAY "TOTAL DA VIAGEM " + cCodViagem + "("+Trim(cViagem)+")"
		@ nLin,nCEnt PSAY nEntVia Picture "@E 999,999,999.99"
		@ nLin,nCSai PSAY nSaiVia Picture "@E 999,999,999.99"
		@ nLin,PCol()+3 PSAY nSaiVia-nEntVia Picture "@E 999,999,999.99"
		nLin++
		
		@ nLin,000 PSAY Repli("_",Limite)
		nLin+=2
	Enddo
	
	If Len(aViagem) > 0 .and. mv_par09 = 1
		
		nTotalEnt:= 0.00
		nTotalSai:= 0.00
		
		nLin  := 80
		
		Titulo:= "Resumo de Despesas com Viagem - " + Dtoc(mv_par01) + " a " + Dtoc(mv_par02)
		Cabec1:= "Viagem Descricao                              Entrada           Saida"
		//        zzzzzz zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz  999,999,999.99  999,999,999.99
		//        012345678901234567890123456789012345656789012345678901234567890123456
		//        0         1         2         3           4         5         6
		Cabec2:= ""
		
		nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		
		For i:= 1 to Len(aViagem)
			If nLin > 60
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			@ nLin, 000 PSay aViagem[i][1]
			@ nLin, 007 PSay aViagem[i][2]
			@ nLin, 036 PSay aViagem[i][3] Picture "@E 999,999,999.99"
			@ nLin, 053 PSay aViagem[i][4] Picture "@E 999,999,999.99"
			nTotalEnt += aViagem[i][3]
			nTotalSai += aViagem[i][4]
			nLin++
		Next
		nLin++
		nSaldo:= nTotalSai - nTotalEnt
		
		@ nLin, 036 PSay nTotalEnt Picture "@E 999,999,999.99"
		@ nLin, 053 PSay nTotalSai Picture "@E 999,999,999.99"
		@ nLin, 070 PSay nSaldo    Picture "@E 999,999,999.99"
		
	Endif
	
	dbSelectArea("TMP")
	
	If !lFirst .And. !Empty(cCsvArq)
		u_AddCSV(AFill(Array(14),""))
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

/////////////////////////////////////////////////////////////////////////////////
Static function CabViagem(nLin,cCodViagem,cViagem,cDestino,cViajante,dIda,dVolta)
	
	@ nLin,000 PSAY "Codigo: "+cCodViagem + " - " + Trim(cViagem)
	nLin++
	
	@ nLin,000 PSAY "Percurso: " + cDestino
	@ nLin,065 PSAY "Viajante: " + cViajante
	nLin++
	
	@ nLin,000 PSAY "Ida: " + Dtoc(dIda)
	@ nLin,065 PSAY "Volta: " + Dtoc(dVolta)
	nLin++
	
	@ nLin,000 PSAY Replicate("-",Limite)
	nLin++
	
return nLin

///////////////////////////////////
Static function BscHistCmp(cBusca)
	Local cHist:= ""
	
	//- NF de compras
	SD1->(DbSetOrder(1))
	SD1->(dbSeek(cBusca,.T.))
	While !SD1->(Eof()) .And. cBusca == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		If TMP->E5_VIAGEM == SD1->D1_VIAGEM
			cHist:= SD1->D1_DESCRI
			Exit
		Endif
		SD1->(dbSkip())
	Enddo
	
Return cHist

//////////////////////////////////
Static function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data                  ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data               ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Da Viagem                ",29)+"?","","","mv_ch3","C", 6,0,0,"G","","SZ7","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate a Viagem             ",29)+"?","","","mv_ch4","C", 6,0,0,"G","","SZ7","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Considera Filiais a baixo",29)+"?","","","mv_ch5","N", 1,0,0,"C","","   ","","","mv_par05","Sim","","","","Nao")
	u_INPutSX1(cPerg,"06",PADR("Da Filial                ",29)+"?","","","mv_ch6","C", 2,0,0,"G","","   ","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Ate a Filial             ",29)+"?","","","mv_ch7","C", 2,0,0,"G","","   ","","","mv_par07")
	u_INPutSX1(cPerg,"08",PADR("Quebra por pagina        ",29)+"?","","","mv_ch8","N", 1,0,0,"C","","   ","","","mv_par08","Sim","","","","Nao")
	u_INPutSX1(cPerg,"09",PADR("Imprime resumo           ",29)+"?","","","mv_ch9","N", 1,0,0,"C","","   ","","","mv_par09","Sim","","","","Nao")
	u_INPutSX1(cPerg,"10",PADR("Do Projeto               ",29)+"?","","","mv_cha","C", 9,0,0,"G","","CTT","","","mv_par10")
	u_INPutSX1(cPerg,"11",PADR("Ate o Projeto            ",29)+"?","","","mv_chb","C", 9,0,0,"G","","CTT","","","mv_par11")
	u_INPutSX1(cPerg,"12",PADR("Classe MCT               ",29)+"?","","","mv_chc","C", 9,0,0,"G","","CTH","","","mv_par12")
	u_INPutSX1(cPerg,"13",PADR("Considera P.A.           ",29)+"?","","","mv_chd","N", 1,0,0,"C","","   ","","","mv_par13","Sim","","","","Nao")
	u_INPutSX1(cPerg,"14",PADR("Imprime relatorio por    ",29)+"?","","","mv_che","N", 1,0,0,"C","","   ","","","mv_par14","Caixa","","","","Competencia",;
							"","","Contabil","","","Base MCT")
	u_INPutSX1(cPerg,"15",PADR("Considera estornos       ",29)+"?","","","mv_chf","N", 1,0,0,"C","","   ","","","mv_par15","Sim","","","","Nao")
Return
