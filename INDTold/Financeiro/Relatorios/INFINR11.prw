#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINR11 º Autor ³ Ronilton O. Barros º Data ³  03/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de despesas de projetos                          º±±
±±º          ³ Por Centro de Custo                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico INDT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INFINR11(_cProj,_cTitulo,_cProg,_cPerg,_vPerg,_lCallMe,_cMCT,_lHib)
	Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2 := "de acordo com os parametros informados pelo usuario."
	Local cDesc3 := If( _cTitulo == Nil , "Despesas de Projetos", _cTitulo)
	Local titulo := cDesc3
	Local nLin   := 80
	Local Cabec1 := ""
	Local Cabec2 := ""
	Local aOrd   := {}
	Local cPerg  := PADR("INFINR11",Len(SX1->X1_GRUPO))
	
	Private lHibrido := If( _lHib == Nil , .F., _lHib)
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	_lCallMe := If( _lCallMe == Nil , .F., _lCallMe)
	
	If !_lCallMe
		Private lEnd        := .F.
		Private lAbortPrint := .F.
		Private limite      := 220
		Private tamanho     := "G"
		Private nomeprog    := If( _cProg == Nil , "INFINR11", _cProg)
		Private nTipo       := 15
		Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
		Private nLastKey    := 0
		Private m_pag       := 01
		Private wnrel       := nomeprog
		Private cString     := "SE5"
		
		wnrel:= SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
		
		If nLastKey == 27
			Return
		Endif
		
		SetDefault(aReturn,cString)
		
		If nLastKey == 27
			Return
		Endif
		nTipo  := If(aReturn[4]==1,15,18)
	Else
		// Atualiza os parametros digitados pelo usuario para o relatorio aglutinado
		mv_par01 := _vPerg[1]                // Da Data
		mv_par02 := _vPerg[2]                // Ate a Data
		mv_par03 := _cProj                   // Do Centro Custo
		mv_par04 := _cProj                   // Ate o Centro Custo
		mv_par05 := Repli(" ",Len(mv_par05)) // Da Classe MCT
		mv_par06 := Repli("Z",Len(mv_par06)) // Ate a Classe MCT
		mv_par07 := Repli(" ",Len(mv_par07)) // Da Conta Contabil
		mv_par08 := Repli("Z",Len(mv_par08)) // Ate a Conta Contabil
		mv_par09 := 2                // Imprimir Relatorio
		mv_par10 := _vPerg[5]        // Considera Filiais
		mv_par11 := _vPerg[6]        // Da Filial
		mv_par12 := _vPerg[7]        // Ate a Filial
		mv_par13 := 1                // Quebra pagina por Projeto
		mv_par14 := _vPerg[8]        // Considera PA
		mv_par15 := _vPerg[9]        // Imprime Relatorio por: Caixa  Competencia
		mv_par16 := _vPerg[10]       // Considera estorno: Sim  Nao
		
		If mv_par15 == 4             // Caso tenha sido escolhida a opção Hibrido
			mv_par15 := 1             // O relatório será impresso por Caixa
		Endif
	Endif
	
	Titulo := Trim(Titulo)+" - "+If( lHibrido , "Resumo", If( mv_par09 == 1 , "Anali", "Sinte")+"tico")
	
	Cabec1 := Padc("Periodo de "+Dtoc(mv_par01)+" a "+Dtoc(mv_par02),132)
	
	If mv_par09 == 1
		Cabec2 := "Classe MCT  Descricao                                 Conta Contabil        Descricao                                          Valor                                  "
	Else
		Cabec2 := "Classe MCT  Descricao                                                                                                        Entrada           Saida             Saldo"
	EndIf
	//    xxxxxxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99   999,999,999.99   999,999,999.99
	//    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
	//    0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
	Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin,_lCallMe) }, "Filtrando dados")
Return

Static Function ExecProc(Cabec1,Cabec2,Titulo,nLin,_lCallMe)
	Local aStru, cArq, cInd, cQry, cQPA
	Local cTpImp := MVISS+";"+MVINSS+";"+MVTAXA+";"+MVTXA
	
	If !_lCallMe
		If mv_par15 < 3  // Se não for a opção Contábil ou Base MCT
			Titulo := AllTrim(Titulo) + " (Base Oficial)"
			If mv_par15 == 1
				Titulo += " - Caixa"
			Else
				Titulo += " - Competencia"
				cQry   := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
				
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
				cArq := u_INDADCOMP(cQry,mv_par01,mv_par02,,,mv_par03,mv_par04,mv_par10,mv_par11,mv_par12,,mv_par14,"C")
			Endif
			
			aStru := SE5->( dbStruct() )
			cQry  := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE5")
			cQry  += " WHERE D_E_L_E_T_ <> '*' AND E5_DTDISPO >= '"+dtos(mv_par01)+"' AND E5_DTDISPO <= '"+dtos(mv_par02)+"'" //idem aldelson
			
			//NAO CONSIDERA CP (COMPENSACAO) E QUANDO NAO REGISTRAR O BANCO - ADELSON
			cQry  += " AND E5_RECPAG = 'P' AND "+u_CondPadRel()
			
			If mv_par10 == 1    // Considera Filial == 2-Nao  1-Sim
				cQry += " AND E5_FILIAL >= '"+mv_par11+"' AND E5_FILIAL <= '"+mv_par12+"'"
			Else
				cQry += " AND E5_FILIAL = '"+xFilial("SE5")+"'"
			Endif
			
			If mv_par15 == 1   // Se for Caixa
				// - D= Ref. Despesas financeiras                           FIN MAT GPE
				Processa({|| cArq := u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par14,"D",.T.) },"Filtro de Dados","Filtrando Entradas...")
			Else  // Se for competência, processa somente as movimentações bancárias
				cQry += " AND E5_CCD >= '"+mv_par03+"' AND E5_CCD <= '"+mv_par04+"'"
				cQry += " AND E5_CLVLDB >= '"+mv_par05+"' AND E5_CLVLDB <= '"+mv_par06+"' AND E5_MOTBX = ' '"
				
				If mv_par14 == 1  // Se considera PA
					// Processa os estornos de PA's
					cQPA := "(E5_MOTBX = ' ' OR (E5_MOTBX = 'DEB' AND E5_TIPO IN "+FormatIn(MVPAGANT,"|")+"))"
					cQry := StrTran(cQry,"E5_MOTBX = ' '", cQPA)
				Endif
				
				Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par14,"D",.F.,,,.T.) },"Filtro de Dados","Filtrando Saidas...")
			Endif
		ElseIf mv_par15 == 3  // Se for a opção Contábil
			Titulo := AllTrim(Titulo) + " (Base Oficial) - Contabil"
			
			cQry := "SELECT COUNT(*) SOMA FROM "+RetSQLName("CT2")+" CT2 WHERE D_E_L_E_T_ <> '*'"
			cQry += " AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
			cQry += " AND ((CT2_DEBITO >= '"+mv_par07+"' AND CT2_DEBITO <= '"+mv_par08+"')"
			cQry += " OR (CT2_CREDIT >= '"+mv_par07+"' AND CT2_CREDIT <= '"+mv_par08+"'))"
			cQry += " AND ((CT2_CCD >= '"+mv_par03+"' AND CT2_CCD <= '"+mv_par04+"')"
			cQry += " OR (CT2_CCC >= '"+mv_par03+"' AND CT2_CCC <= '"+mv_par04+"'))"
			
			// Busca e filtra Classe MCT pelo Plano de Contas
			cQry += " AND ("
			cQry += " (CT2_DC IN ('1','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_DEBITO = CT1_CONTA"
			cQry += " AND CT1_GRUPO >= '"+mv_par05+"' AND CT1_GRUPO <= '"+mv_par06+"'))"
			cQry += " OR"
			cQry += " (CT2_DC IN ('2','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_CREDIT = CT1_CONTA"
			cQry += " AND CT1_GRUPO >= '"+mv_par05+"' AND CT1_GRUPO <= '"+mv_par06+"')))"
			
			If mv_par10 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND CT2_FILIAL >= '"+mv_par11+"' AND CT2_FILIAL <= '"+mv_par12+"'"
			Else
				cQry += " AND CT2_FILIAL = '"+xFilial("CT2")+"'"
			Endif
			
			// Rotina de Busca de Dados --> INFINP04.PRW
			Processa({|| cArq := u_INFINP04("TMP",cQry,"D",.T.,.T.,mv_par16==1) },"Filtro de Dados","Filtrando Saidas...")
		Else  // Se for a opção Base MCT
			Titulo := AllTrim(Titulo) + " (Base MCT)"
			
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
			cQry += " AND SZ3.Z3_CLVL >= '"+mv_par05+"' AND SZ3.Z3_CLVL <= '"+mv_par06+"'"
			cQry += " AND SZ3.Z3_CONTA >= '"+mv_par07+"' AND SZ3.Z3_CONTA <= "+mv_par08+"'"
			
			// Rotina de Busca de Dados --> INFINP08.PRW
			Processa({|| cArq := u_INFINP08("TMP",cQry,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
		Endif
	Endif
	
	cInd := CriaTrab(NIL ,.F.)
	cKey := "E5_CC+E5_CLVL+E5_CONTAB+Dtos(E5_DTDISPO)"
	
	IndRegua("TMP",cInd,cKey,,,"Selecionando Registros...")
	
	GravClZero()
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,_lCallMe) },Titulo)
	
	If !_lCallMe
		FErase(cArq+".DBF")
	Else
		dbClearIndex()
	Endif
	FErase(cInd+".IDX")
	
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,_lCallMe)
	Local cContab, cClsVal, cCCusto, nTotCtb, cDesCTH, cDesCT1, vClasse, x, cFiltro
	Local nEntCCu, nSaiCCu, nEntCls, nSaiCls, nEntCtb, nSaiCtb
	Local nEntGer := 0
	Local nSaiGer := 0
	
	dbSelectArea("TMP")
	DbsetOrder(1)
	dbGoTop()
	SetRegua(RecCount())
	
	While !Eof()
		
		IncRegua()
		
		//- Filtrando centro de custos
		If E5_CC < mv_par03 .Or. E5_CC > mv_par04 .Or. E5_STATUS <> "S" .Or. Trim(E5_CLVL) == "010" .Or. !IsHibrido()
			dbSkip()
			Loop
		Endif
		
		If nLin > 60 .Or. mv_par13 == 1
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		Endif
		
		@ nLin,000 PSAY "Projeto: "+E5_CC
		@ nLin,Pcol()+3 PSAY E5_DESCCC
		nLin++
		
		If mv_par09 == 1   // Caso seja Analitico avanca uma linha
			@ nLin,000 PSAY "  "
			nLin++
		Endif
		
		nEntCCu := 0
		nSaiCCu := 0
		cCCusto := E5_CC
		
		While !Eof() .and. E5_CC == cCCusto
			
			//- Filtrando classe de valor
			If Trim(E5_CLVL) == "010" .or. Empty(E5_CLVL) //- Aporte Nokia ou em branco
				IncRegua()
				dbSkip()
				Loop
			Endif
			
			cClsVal := E5_CLVL
			
			vClasse := {}
			//- Mofificado pelo Reinaldo em 18/05/06 pois a descricao estava vindo em branco em alguns casos.
			cDesCTH := If(Empty(E5_DESCTH),Trim(Posicione("CTH",1,XFILIAL("CTH")+cClsVal,"CTH_DESC01")),E5_DESCTH)
			nEntCls := 0
			nSaiCls := 0
			
			While !Eof() .and. E5_CLVL == cClsVal .and. E5_CC == cCCusto
				cDesCT1 := E5_DESCT1
				nTotCtb := 0
				nEntCtb := 0
				nSaiCtb := 0
				
				cContab := E5_CONTAB
				
				While !Eof() .And. cContab == E5_CONTAB .and. E5_CLVL == cClsVal .and. E5_CC == cCCusto
					
					IncRegua()
					
					If E5_CLVL   >= mv_par05 .And. E5_CLVL   <= mv_par06 .And.;
						E5_CONTAB >= mv_par07 .And. E5_CONTAB <= mv_par08 .And. IsHibrido() .And.;
						E5_CC     >= mv_par03 .And. E5_CC     <= mv_par04 .And. E5_STATUS == "S"
						If E5_RECPAG == "R"
							nEntCtb += E5_VALOR
						Else
							nSaiCtb += E5_VALOR
						Endif
						nTotCtb += E5_VALOR
					Endif
					dbSkip()
				Enddo
				If nTotCtb <> 0
					If mv_par09 == 1   // Caso seja Analitico
						AAdd( vClasse , { cContab, cDesCT1, nTotCtb} )
					Endif
					nEntCls += nEntCtb
					nSaiCls += nSaiCtb
				Endif
			Enddo
			If nLin > 60
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			@ nLin,010 PSAY Repli("-",Limite-10)
			nLin++
			nSaldo:= nSaiCls - nEntCls
			
			@ nLin,010      PSAY cClsVal
			@ nLin,Pcol()+3 PSAY Trim(cDesCTH)+If( lHibrido .And. Trim(cClsVal)=="001", " (HIBRIDO)", "")
			@ nLin,118      PSAY nEntCls Picture "@E 999,999,999.99"
			@ nLin,135      PSAY nSaiCls Picture "@E 999,999,999.99"
			@ nLin,152      PSAY nSaldo  Picture "@E 999,999,999.99"
			nLin++
			If mv_par09 == 1   // Caso seja Analitico imprime a linha
				@ nLin,010 PSAY Repli("-",Limite-10)
				nLin++
			Endif
			For x:=1 To Len(vClasse)
				If nLin > 60
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				Endif
				@ nLin,054      PSAY vClasse[x,1]
				@ nLin,Pcol()+2 PSAY vClasse[x,2]
				@ nLin,Pcol()+2 PSAY vClasse[x,3] Picture "@E 999,999,999.99"
				nLin++
			Next
			If mv_par09 == 1   // Caso seja Analitico avanca uma linha
				@ nLin,000 PSAY "  "
				nLin++
			Endif
			nEntGer += nEntCls
			nSaiGer += nSaiCls
			nEntCCu += nEntCls
			nSaiCCu += nSaiCls
		Enddo
		If nLin > 60
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		Endif
		@ nLin,000 PSAY Repli("_",Limite)
		nLin++
		@ nLin,000 PSAY "Total do Projeto: " +cCCusto
		@ nLin,118 PSAY nEntCCu Picture "@E 999,999,999.99"
		@ nLin,135 PSAY nSaiCCu Picture "@E 999,999,999.99"
		nLin++
		@ nLin,000 PSAY Repli("_",Limite)
		nLin := nLin + 2
	Enddo
	If nEntGer <> 0 .Or. nSaiGer <> 0
		If mv_par09 <> 1   // Caso nao seja Analitico avanca uma linha
			@ nLin,000 PSAY "  "
			nLin++
		Endif
		nSaldo:= nSaiGer - nEntGer
		@ nLin,000 PSAY "Total Geral"
		@ nLin,118 PSAY nEntGer Picture "@E 999,999,999.99"
		@ nLin,135 PSAY nSaiGer Picture "@E 999,999,999.99"
		@ nLin,152 PSAY nSaldo  Picture "@E 999,999,999.99"
		nLin++
		
		@ nLin,000 PSAY Repli("_",Limite)
	Endif
	
	dbSelectArea("TMP")
	
	If !_lCallMe
		dbCloseArea()
		If aReturn[5]==1
			dbCommitAll()
			SET PRINTER TO
			OurSpool(wnrel)
		Endif
		MS_FLUSH()
	Endif
	
Return

Static function GravClZero()
	Local cCC,aCC := {}
	dbSelectArea("TMP")
	DbsetOrder(1)
	DbGotop()
	cCC := "999999999999"
	While !Eof()
		If cCC <> E5_CC
			If E5_CC >= mv_par03 .And. E5_CC <= mv_par04
				AAdd(aCC,E5_CC)
			Endif
			cCC := E5_CC
		EndIf
		DbSkip()
	Enddo
	For x:=1 To Len(aCC)
		DbSelectArea("CTH")
		DbSetOrder(1)
		DbGotop()
		While !CTH->(Eof())
			DbSelectArea("TMP")
			If !(DbSeek(aCC[x]+CTH->CTH_CLVL))
				If CTH->CTH_CLVL >= mv_par05 .And. CTH->CTH_CLVL <= mv_par06 .And.;
					Space(Len(CT1->CT1_CONTA)) >= mv_par07 .And. Space(Len(CT1->CT1_CONTA)) <= mv_par08
					RecLock("TMP",.T.)
					TMP->E5_CC     := aCC[x]
					TMP->E5_DESCCC := Posicione("CTT",1,XFILIAL("CTT")+aCC[x],"CTT_DESC01")
					TMP->E5_CLVL   := CTH->CTH_CLVL
					TMP->E5_DESCTH := CTH->CTH_DESC01
					TMP->E5_CONTAB := ""
					TMP->E5_DESCT1 := ""
					TMP->E5_VALOR  := 0
					TMP->E5_STATUS := "S"
					MsUnLock()
				Endif
			EndIf
			DbSelectArea("CTH")
			CTH->(DbSkip())
		Enddo
	Next
Return()

Static Function IsHibrido()
	Local lFolha := (Trim(E5_ROTINA)=="GPEM670" .And. Trim(E5_CLVL)=="001")  // Definição de título da folha
Return If( lHibrido , !lFolha .Or. E5_BAICOMP=="C" , If( mv_par15 == 1 , E5_BAICOMP <> "C" , E5_BAICOMP == "C" ))

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data                  ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data               ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Do Projeto               ",29)+"?","","","mv_ch3","C", 9,0,0,"G","","CTT","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate o Projeto            ",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Da Classe MCT            ",29)+"?","","","mv_ch5","C", 9,0,0,"G","","CTH","","","mv_par05")
	u_INPutSX1(cPerg,"06",PADR("Ate a Classe MCT         ",29)+"?","","","mv_ch6","C", 9,0,0,"G","","CTH","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Da Conta Contabil        ",29)+"?","","","mv_ch7","C",20,0,0,"G","","CT1","","","mv_par07")
	u_INPutSX1(cPerg,"08",PADR("Ate a Conta Contabil     ",29)+"?","","","mv_ch8","C",20,0,0,"G","","CT1","","","mv_par08")
	u_INPutSX1(cPerg,"09",PADR("Imprime Relatorio        ",29)+"?","","","mv_ch9","N", 1,0,0,"C","","   ","","","mv_par09","Analitico","","","","Sintetico")
	u_INPutSX1(cPerg,"10",PADR("Considera Filiais a baixo",29)+"?","","","mv_cha","N", 1,0,0,"C","","   ","","","mv_par10","Sim","","","","Nao")
	u_INPutSX1(cPerg,"11",PADR("Da Filial                ",29)+"?","","","mv_chb","C", 2,0,0,"G","","   ","","","mv_par11")
	u_INPutSX1(cPerg,"12",PADR("Ate a Filial             ",29)+"?","","","mv_chc","C", 2,0,0,"G","","   ","","","mv_par12")
	u_INPutSX1(cPerg,"13",PADR("Quebra pagina por Projeto",29)+"?","","","mv_chd","N", 1,0,0,"C","","   ","","","mv_par13","Sim","","","","Nao")
	u_INPutSX1(cPerg,"14",PADR("Considera P.A.           ",29)+"?","","","mv_che","N", 1,0,0,"C","","   ","","","mv_par14","Sim","","","","Nao")
	u_INPutSX1(cPerg,"15",PADR("Imprime relatorio por    ",29)+"?","","","mv_chf","N", 1,0,0,"C","","   ","","","mv_par15","Caixa","","","","Competencia",;
							"","","Contabil","","","Base MCT")
	u_INPutSX1(cPerg,"16",PADR("Considera estornos       ",29)+"?","","","mv_chg","N", 1,0,0,"C","","   ","","","mv_par16","Sim","","","","Nao")
Return
