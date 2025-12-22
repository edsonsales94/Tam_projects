#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINR14 º                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de RH                                            º±±
±±º          ³ Por Colaborador                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico INDT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INFINR14(_cProj,_cTitulo,_cProg,_cPerg,_vPerg,_lCallMe,_cMCT)
	Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2 := "de acordo com os parametros informados pelo usuario."
	Local cDesc3 := If( _cTitulo == Nil , "Despesas de RH", _cTitulo)
	Local titulo := cDesc3
	Local nLin   := 80
	Local Cabec1 := ""
	Local Cabec2 := ""
	Local aOrd   := {}
	Local cPerg  := PADR("INFINR14",Len(SX1->X1_GRUPO))
	
	Private lHibrido := .F.
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	_lCallMe := If( _lCallMe == Nil , .F., _lCallMe)
	
	If !_lCallMe
		Private lEnd        := .F.
		Private lAbortPrint := .F.
		Private limite      := 160
		Private tamanho     := "G"
		Private nomeprog    := If( _cProg == Nil , "INFINR14", _cProg)
		Private nTipo       := 15
		Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
		Private nLastKey    := 0
		Private m_pag       := 01
		Private wnrel       := "INFINR14"
		Private cString     := "SE5"
		
		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
		
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
		mv_par01 := _vPerg[1]     // Da Data
		mv_par02 := _vPerg[2]     // Ate a Data
		mv_par03 := Repli(" ",Len(mv_par03)) // Do Colaborador
		mv_par04 := Repli("Z",Len(mv_par04)) // Ate Colaborador
		mv_par05 := _cProj        // Do centro de custo
		mv_par06 := _cProj        // Ate o centro de custo
		mv_par07 := 2             // Quabra por item contabil (1=Sim 2=Nao)
		mv_par08 := _vPerg[5]     // Considera filiais abaixo
		mv_par09 := _vPerg[6]     // Da filial
		mv_par10 := _vPerg[7]     // Ate a filial
		mv_par11 := 1             // Imprime resumo no final
		mv_par12 := PADR(_cMCT,9) // Classe MCT
		mv_par13 := _vPerg[8]     // Considera PA's
		mv_par14 := _vPerg[9]     // Data Referencia :  Caixa  Competencia  Contabil  Hibrido
		mv_par15 := _vPerg[10]    // Considera estorno: Sim  Nao
	Endif
	
	lHibrido := (mv_par14 == 4)  // Se opcao for Hibrido
	
	Titulo := Trim(Titulo)
	
	Cabec1 := Padc("Periodo de "+Dtoc(mv_par01)+" a "+Dtoc(mv_par02),132)
	Cabec2 := "          Dt. Pgto    Descricao da Despesa                      Beneficiario                                     Entrada           Saida           Saldo  Local  Origem"
				//          99/99/9999  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999.99  999,999,999.99  999,999,999.99   xxx   Compet.
				//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
				//0         1         2         3         4         5         6         7         8         9        10         11        12       13        14        15        16
	
	Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin,_lCallMe) }, "Filtrando dados")
	
Return

//////////////////////////////////////////////////////////////
Static function ExecProc(Cabec1,Cabec2,Titulo,nLin,_lCallMe)
	Local aStru, cArq, cInd, cQry, cQPA
	Local cTpImp := MVISS+";"+MVINSS+";"+MVTAXA+";"+MVTXA
	
	If !_lCallMe
		If mv_par14 < 3 .Or. lHibrido  // Se não for a opção Contábil ou Base MCT
			Titulo := AllTrim(Titulo) + " (Base Oficial)"
			If mv_par14 <> 2
				Titulo += If( mv_par14 == 1 , " - Caixa", " - Hibrido")
			Else
				Titulo += " - Competencia"
				cQry   := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
				
				If mv_par08 == 1    // Considera Filial ==  1-Sim  2-Nao
					cQry += "E2_FILIAL >= '"+mv_par09+"' AND E2_FILIAL <= '"+mv_par10+"' AND "
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
				cArq := u_INDADCOMP(cQry,mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par08,mv_par09,mv_par10,mv_par12,mv_par13,"C")
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processando Saidas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aStru := SE5->(dbStruct())
			
			cQry  := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE5")
			cQry  += " WHERE D_E_L_E_T_ <> '*' AND "
			cQry  += "E5_DTDISPO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND "
			
			If mv_par08 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += "E5_FILIAL >= '"+mv_par09+"' AND E5_FILIAL <= '"+mv_par10+"' AND "
			Else
				cQry += "E5_FILIAL = '"+xFilial("SE5")+"' AND "
			Endif
			
			cQry += "E5_RECPAG = 'P' AND "+u_CondPadRel()
			
			If mv_par14 <> 2   // Se for Caixa ou Híbrido
				// - D= Ref. Despesas financeiras                             FIN MAT GPE
				Processa({|| cArq := u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par13,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
				
				// Só for hibrido, processa competência
				If lHibrido
					Processa({|| u_INDADCOMP(Nil,mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par08,mv_par09,mv_par10,"001",mv_par13,"C") },"Filtro de Dados")
				Endif
			Else
				cQry += " AND E5_ITEMD >= '"+mv_par03+"' AND E5_ITEMD <= '"+mv_par04+"'"
				cQry += " AND E5_CCD >= '"+mv_par05+"' AND E5_CCD <= '"+mv_par06+"'"
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
			cQry += " AND ((CT2_ITEMD >= '"+mv_par03+"' AND CT2_ITEMD <= '"+mv_par04+"')"
			cQry += " OR (CT2_ITEMC >= '"+mv_par03+"' AND CT2_ITEMC <= '"+mv_par04+"'))"
			cQry += " AND ((CT2_CCD >= '"+mv_par05+"' AND CT2_CCD <= '"+mv_par06+"')"
			cQry += " OR (CT2_CCC >= '"+mv_par05+"' AND CT2_CCC <= '"+mv_par06+"'))"
			
			// Busca e filtra Classe MCT pelo Plano de Contas
			cQry += " AND ("
			cQry += " (CT2_DC IN ('1','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_DEBITO = CT1_CONTA AND CT1_GRUPO = '"+mv_par12+"'))"
			cQry += " OR"
			cQry += " (CT2_DC IN ('2','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_CREDIT = CT1_CONTA AND CT1_GRUPO = '"+mv_par12+"')))"
			
			If mv_par08 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND CT2_FILIAL >= '"+mv_par09+"' AND CT2_FILIAL <= '"+mv_par10+"'"
			Else
				cQry += " AND CT2_FILIAL = '"+xFilial("CT2")+"'"
			Endif
			
			// Rotina de Busca de Dados --> INFINP04.PRW
			Processa({|| cArq := u_INFINP04("TMP",cQry,"D",.T.,.T.,mv_par15==1) },"Filtro de Dados","Filtrando Saidas...")
		Else  // Se for a opção Base MCT
			Titulo := AllTrim(Titulo) + " (Base MCT)"
			
			cQry := "SELECT COUNT(*) SOMA"
			cQry += " FROM "+RetSQLName("SZ3")+" SZ3"
			cQry += " WHERE SZ3.D_E_L_E_T_ = ' '"
			
			If mv_par08 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND SZ3.Z3_FILIAL >= '"+mv_par09+"' AND SZ3.Z3_FILIAL <= '"+mv_par10+"'"
			Else
				cQry += " AND SZ3.Z3_FILIAL = '"+xFilial("SZ3")+"'"
			Endif
			
			cQry += " AND SZ3.Z3_DTDISPO >= '"+Dtos(mv_par01)+"' AND SZ3.Z3_DTDISPO <= '"+Dtos(mv_par02)+"'"
			cQry += " AND SZ3.Z3_ITEMCTA >= '"+mv_par03+"' AND SZ3.Z3_ITEMCTA <= '"+mv_par04+"'"
			cQry += " AND SZ3.Z3_CC >= '"+mv_par05+"' AND SZ3.Z3_CC <= '"+mv_par06+"'"
			cQry += " AND SZ3.Z3_CLVL = '"+mv_par12+"'"
			
			// Rotina de Busca de Dados --> INFINP08.PRW
			Processa({|| cArq := u_INFINP08("TMP",cQry,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
		Endif
	Endif
	
	cInd := CriaTrab(NIL ,.F.)
	
	IndRegua("TMP",cInd,"E5_ITEMCTA+E5_CC+Dtos(E5_DTDISPO)",,,"Selecionando Registros...")
	
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
	Local cCCusto, cFiltro, vRodape, cItemCTA, cNomeCTA, cColaborador, cCCusto, cDescCCusto, aProjeto, aColaborador
	Local nTotalEnt, nTotalSai, nEntCC, nSaiCC, nEntFunc, nSaiFunc, nPos, nOpc, aCCusto, aContas
	Local aFunc   := {}
	Local aTotCta := {}
	Local nTam    := TamSX3("RA_MAT")[1]
	Local lOk     := .T.
	Local i
	
	aColaborador:= {}
	
	dbSelectArea("TMP")
	DbsetOrder(1)
	
	SetRegua(RecCount())
	dbGoTop()
	
	While !Eof()
		
		Incregua()
		
		If E5_ITEMCTA < mv_par03 .Or. E5_ITEMCTA > mv_par04 .Or. E5_CC < mv_par05 .Or. E5_CC > mv_par06 .Or.;
			E5_STATUS <> "S" .Or. E5_CLVL <> mv_par12 .Or. !IsHibrido()
			dbskip()
			Loop
		Endif
		
		cItemCTA    := E5_ITEMCTA //- Colaborador
		cColaborador:= ""
		cNomeCTA    := ""
		nEntFunc    := 0.00
		nSaiFunc    := 0.00
		nCEnt       := 0   // Posição da coluna de entrada
		nCSai       := 0   // Posição da coluna de saída
		aCCusto     := {}
		aContas     := {}
		
		//- Item contabil
		CTD->(DbsetOrder(1))
		If CTD->(DbSeek(xFilial()+cItemCTA))
			cNomeCTA := CTD->CTD_DESC01
		Else
			cNomeCTA := " COLABORADOR NAO ENCONTRADO"
		Endif
		cColaborador:= cItemCTA + "  -  "  + cNomeCTA
		
		AAdd( aFunc , { PADR(Trim(E5_ITEMCTA),nTam), cNomeCTA, {}, {}} )
		
		While !Eof() .and. E5_ITEMCTA == cItemCTA
			
			Incregua()
			
			If E5_CC < mv_par05 .Or. E5_CC > mv_par06 .Or. E5_STATUS <> "S" .Or. E5_CLVL <> mv_par12 .Or. !IsHibrido()
				dbskip()
				Loop
			Endif
			
			cCCusto    := E5_CC //- Projeto
			cDescCCusto:= ""
			aProjeto   := {}
			
			//- Centro de custo
			CTT->(DbsetOrder(1))
			If CTT->(DbSeek(xFilial("CTT")+cCCusto))
				cDescCCusto:= cCCusto +"  -  " + CTT->CTT_DESC01
			Else
				cDescCCusto:= cCCusto +"  -  " + "DESPESA PARA PROJETO INEXISTENTE"
			Endif
			
			While !Eof() .And. E5_ITEMCTA+E5_CC == cItemCTA+cCCusto
				
				Incregua()
				
				If E5_STATUS <> "S" .Or. E5_CLVL <> mv_par12 .Or. !IsHibrido()
					dbSkip()
					Loop
				Endif
				//                  1           2         3        4                     5                    6         7
				AADD(aProjeto,{ E5_DTDISPO, E5_DESCT1, E5_VALOR, PADR(E5_BENEF,30), U_NomeFilial(E5_FILIAL), E5_RECPAG, E5_MANUAL} )
				
				If !_lCallMe
					// Soma as despesas do funcionário por PERÍODO + C.C.
					nPos := AScan( aCCusto , {|x| x[1]+x[2] == E5_CC+SubStr(Dtos(E5_DTDISPO),1,6) })
					If nPos == 0
						AAdd( aCCusto , { E5_CC, SubStr(Dtos(E5_DTDISPO),1,6), 0, 0, 0, 0, 0} )
						nPos := Len(aCCusto)
					Endif
					Do Case
						Case E5_XTPORH == "1"  ;  aCCusto[nPos,3] += (E5_VALOR * If( E5_RECPAG == "P" , 1, -1))
						Case E5_XTPORH == "2"  ;  aCCusto[nPos,4] += (E5_VALOR * If( E5_RECPAG == "P" , 1, -1))
						Case E5_XTPORH == "3"  ;  aCCusto[nPos,5] += (E5_VALOR * If( E5_RECPAG == "P" , 1, -1))
						Case E5_XTPORH == "4"  ;  aCCusto[nPos,6] += (E5_VALOR * If( E5_RECPAG == "P" , 1, -1))
						OtherWise              ;  aCCusto[nPos,7] += (E5_VALOR * If( E5_RECPAG == "P" , 1, -1))
					EndCase
					
					// Pesquisa e totaliza valores por conta contábil
					nPos := AScan( aContas , {|x| x[1]+x[2] == SubStr(Dtos(E5_DTDISPO),1,6)+ConvDescr(E5_DESCT1) })
					If nPos == 0
						AAdd( aContas , { SubStr(Dtos(E5_DTDISPO),1,6), ConvDescr(E5_DESCT1), 0})
						nPos := Len(aContas)
					Endif
					aContas[nPos,3] += (E5_VALOR * If( E5_RECPAG == "P" , 1, -1))
					
					// Armazena todas as contas contábeis encontradas
					If AScan( aTotCta , {|x| x[3] == ConvDescr(E5_DESCT1) } ) == 0
						AAdd(  aTotCta , { E5_XTPORH, Trim(E5_DESCT1), ConvDescr(E5_DESCT1) } )
					Endif
				Endif
				
				dbSkip()
			Enddo
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicio da impressao     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nEntCC := 0
			nSaiCC := 0
			
			// Ordena por Descricao da Conta
			ASort( aProjeto ,,, {|x,y| x[6]+x[2]+Dtos(x[1]) < y[6]+y[2]+Dtos(y[1]) })
			
			For i:=1 To Len(aProjeto)
				If nLin > 60
					nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				Endif
				
				@ nLin,010      PSAY PADR(Dtoc(aProjeto[i][1]),10) //- Dt. Pagto
				@ nLin,PCol()+2 PSAY PADR(aProjeto[i][2],40) //- Descricao da Despesa
				@ nLin,PCol()+2 PSAY PADR(aProjeto[i][4],40) //- Beneficiario
				
				nCEnt := PCol()+2
				If aProjeto[i][6] == "R"
					@ nLin,nCEnt PSAY aProjeto[i][3] Picture "@E 999,999,999.99"   //- Entrada
					nCSai := PCol()+2
					@ nLin,nCSai PSAY 0              Picture "@EZ 999,999,999.99"
					nEntCC   += aProjeto[i][3]
					nEntFunc += aProjeto[i][3]
				Else
					@ nLin,nCEnt PSAY 0              Picture "@EZ 999,999,999.99"
					nCSai := PCol()+2
					@ nLin,nCSai PSAY aProjeto[i][3] Picture "@E 999,999,999.99"   //- Saida
					nSaiCC   += aProjeto[i][3]
					nSaiFunc += aProjeto[i][3]
				Endif
				@ nLin,PCol()+2 PSAY aProjeto[i][3]*If(aProjeto[i][6]=="R",-1,1) Picture "@E 999,999,999.99"
				@ nLin,PCol()+2 PSAY aProjeto[i][7]                                  //- Lancamento: * = manual
				@ nLin,PCol()   PSAY aProjeto[i][5]                                  //- Filial
				@ nLin,PCol()+3 PSAY If( aProjeto[i][6] $ " B" , "Caixa", "Compet.") //- Origem
				nLin++
			Next
			
			// Criado vetor de impressao do rodape para acertar a quebra de pagina
			vRodape := {} //  Col  Dados a imprimir      Salto
			AAdd( vRodape , { 010  , Repli("-",Limite), 1} )
			AAdd( vRodape , { 010  , "Projeto: " + cDescCCusto, 0} )
			AAdd( vRodape , { nCEnt, Transform(nEntCC,"@E 999,999,999.99"), 0} )
			AAdd( vRodape , { nCSai, Transform(nSaiCC,"@E 999,999,999.99"), 0} )
			AAdd( vRodape , { Nil  , Transform(nSaiCC-nEntCC,"@E 999,999,999.99"), 1} )
			AAdd( vRodape , { 010  , Repli("-",Limite), 2} )
			
			For i:=1 to Len(vRodape)
				If nLin > 60
					nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				Endif
				@ nLin,If(vRodape[i,1]==Nil,PCol()+2,vRodape[i,1]) PSAY vRodape[i,2]
				nLin += vRodape[i,3]
			Next
		Enddo
		
		If !Empty(aCCusto)   // Caso tenha valores
			ASort( aCCusto ,,, {|x,y| x[1]+x[2] < y[1]+y[2] })   // Ordena o vetor por C.C. + Período
			ASort( aContas ,,, {|x,y| x[1]+x[2] < y[1]+y[2] })   // Ordena o vetor por Data + Conta contábil
			
			aFunc[Len(aFunc),3] := aClone(aCCusto)  // Atribui registros encontrados
			aFunc[Len(aFunc),4] := aClone(aContas)  // Atribui registros encontrados
		Else
			// Exclui funcionário sem informação
			ADel( aFunc , Len(aFunc) )
			ASize( aFunc , Len(aFunc)-1 )
		Endif
		
		vRodape := {} //  Col  Dados a imprimir                      Salto
		AAdd( vRodape , { 000  , "Total Colaborador: " + cColaborador, 0} )
		AAdd( vRodape , { nCEnt, Transform(nEntFunc,"@E 999,999,999.99"), 0} )
		AAdd( vRodape , { nCSai, Transform(nSaiFunc,"@E 999,999,999.99"), 0} )
		AAdd( vRodape , { Nil  , Transform(nSaiFunc-nEntFunc,"@E 999,999,999.99"), 1} )
		AAdd( vRodape , { 000  , Repli("_",Limite+10), 2} )
		
		nLin++
		For i:=1 to Len(vRodape)
			If nLin > 60
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			@ nLin,If(vRodape[i,1]==Nil,PCol()+2,vRodape[i,1]) PSAY vRodape[i,2]
			nLin += vRodape[i,3]
		Next
		
		If mv_par07 = 1 //- Salta pagina apos imprimir o colaborador
			nLin:= 80
		Endif
		
		AADD(aColaborador,{cItemCTA, cNomeCTA, nEntFunc, nSaiFunc } )
	Enddo
	If Len(aColaborador) > 0 .and. mv_par11 = 1
		nTotalEnt := 0.00
		nTotalSai := 0.00
		
		nLin  := 80
		
		Titulo:= "Resumo de Despesas com RH " + Dtoc(mv_par01) + " a " + Dtoc(mv_par02)
		
		Cabec1:= "Matricula Nome                                            Entrada          Saida           Saldo"
		//              zzzzzzzzz zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz 999,999,999.99 999,999,999.99   999,999,999.99
		//              0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
		//              0         1         2         3         4         5         6         7         8         9
		Cabec2:= ""
		
		For i:= 1 to Len(aColaborador)
			If nLin > 60
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			Endif
			@ nLin, 000 PSay aColaborador[i][1]
			@ nLin, 010 PSay aColaborador[i][2]
			@ nLin, 051 PSay aColaborador[i][3] Picture "@E 999,999,999.99"
			@ nLin, 066 PSay aColaborador[i][4] Picture "@E 999,999,999.99"
			@ nLin, 083 PSay aColaborador[i][4]-aColaborador[i][3] Picture "@E 999,999,999.99"
			nTotalEnt += aColaborador[i][3]
			nTotalSai += aColaborador[i][4]
			nLin++
		Next
		nLin++
		nSaldo := nTotalSai - nTotalEnt
		@ nLin, 051 PSay nTotalEnt Picture "@E 999,999,999.99"
		@ nLin, 066 PSay nTotalSai Picture "@E 999,999,999.99"
		@ nLin, 083 PSay nSaldo    Picture "@E 999,999,999.99"
	Endif
	
	dbSelectArea("TMP")
	
	If !_lCallMe
		dbCloseArea()
		
		nOpc := SelecOpc()
		
		If nOpc == 1 .Or. nOpc == 3
			MsgRun("Exportando Dados, Aguarde...",,{|| lOk := ExportaExcel(aFunc,1) } )
		Endif
		If lOk .And. (nOpc == 2 .Or. nOpc == 3)
			MsgRun("Exportando Dados, Aguarde...",,{|| ExportaExcel(aFunc,2,aTotCta) } )
		Endif
		
		If aReturn[5]==1
			dbCommitAll()
			SET PRINTER TO
			OurSpool(wnrel)
		Endif
		MS_FLUSH()
	Endif
Return

Static Function IsHibrido()
	Local lFolha := (Trim(E5_ROTINA)=="GPEM670" .And. Trim(E5_CLVL)=="001")  // Definição de título da folha
Return If( lHibrido , !lFolha .Or. E5_BAICOMP=="C" , If( mv_par14 == 1 , E5_BAICOMP <> "C" , E5_BAICOMP == "C" ))

Static Function ExportaExcel(aFunc,nOpc,aTotCta)
	Local nX, nY, cLinha, nL, cPath, cArqTxt, aTotCol, nRecno, aCabec, nPos, aAux
	Local nE      := 0    // Linha do Excel
	Local lAmeric := (__cUserID $ GetMv("MV_XEXCAME",.F.,"000002"))
	Local cSoma   := If( lAmeric , "SUM", "SOMA")
	Local aTotal  := {}
	
	If Empty(aFunc)
		Return .F.
	Endif
	
	If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
		MsgStop( 'MsExcel não instalado !' )
		Return .F.
	EndIf
	
	cPath   := GetTempPath()
	cArqTxt := Trim(wnrel)+StrZero(nOpc,2)+".xls"
	Private nHdl := fCreate(cPath+cArqTxt)
	
	If File(cPath+cArqTxt)   // Se existir o arquivo
		FErase(cPath+cArqTxt) // Apaga
	Endif
	
	CTT->(dbSetOrder(1))
	SRA->(dbSetOrder(13))
	
	ASort( aFunc ,,, {|x,y| x[1] < y[1] })   // Ordena o vetor por Matrícula
	
	If nOpc == 1    // Planilha Funcionário X Centro de Custo
		//               Col  Soma
		AAdd( aTotal , { "I", ""} )
		AAdd( aTotal , { "J", ""} )
		AAdd( aTotal , { "K", ""} )
		AAdd( aTotal , { "L", ""} )
		AAdd( aTotal , { "M", ""} )
		AAdd( aTotal , { "N", ""} )
		
		// Monta o cabeçalho com as colunas a serem exportadas
		aCabec := { "FILIAL","FUNCIONARIO","ADMISSAO","DESCRICAO RH","PROJETO","TIPO","PERIODO","QTDE DE HORAS","SALARIO","BENEFICIOS","PROVISAO","ENCARGOS","OUTROS","TOTAL","ATIVIDADE"}
		WriteLine(nHdl,aCabec,@nE)
		
		For nX:=1 To Len(aFunc)
			PesqFunc(aFunc[nX,1])   // Posiciona no funcionário
			
			nL := nE + 1
			For nY:=1 To Len(aFunc[nX,3])
				
				CTT->(dbSeek(XFILIAL("CTT")+aFunc[nX,3][nY,1]))    // Posiciona no centro de custo
				
				// Atribui nome do funcionário
				WriteLine(nHdl,{ 	SRA->RA_FILIAL,;
										aFunc[nX,2],;
										Dtoc(SRA->RA_ADMISSA),;
										"",;
										Trim(CTT->CTT_DESC01),;
										If(CTT->CTT_TIPOPR=="2","SERVICO",If(CTT->CTT_IDCC=="P","PROJETO","ADMINISTRATIVO")),;
										Upper(SubStr(MesExtenso(Val(SubStr(aFunc[nX,3][nY,2],5,2))),1,3))+"/"+SubStr(aFunc[nX,3][nY,2],1,4),;
										"",;
										Transform(aFunc[nX,3][nY,3],"@"+If(lAmeric,"","E")+" 999999999.99"),;
										Transform(aFunc[nX,3][nY,4],"@"+If(lAmeric,"","E")+" 999999999.99"),;
										Transform(aFunc[nX,3][nY,5],"@"+If(lAmeric,"","E")+" 999999999.99"),;
										Transform(aFunc[nX,3][nY,6],"@"+If(lAmeric,"","E")+" 999999999.99"),;
										Transform(aFunc[nX,3][nY,7],"@"+If(lAmeric,"","E")+" 999999999.99"),;
										"="+cSoma+"("+aTotal[1,1]+LTrim(Str(nE+1,10))+":"+aTotal[Len(aTotal)-1,1]+LTrim(Str(nE+1,10))+")",;
										""},;
										@nE)
			Next
			//If (nE - nL) > 0
				aTotCol := { "", "", "", "", "", "", "", "SUB TOTAL"}
				aEval( aTotal , {|x| AAdd( aTotCol , "=" + cSoma + "(" + x[1] + LTrim(Str(nL,10)) + ":" + x[1] + LTrim(Str(nE,10)) + ")" ) } )
				AAdd( aTotCol , "" )
				
				WriteLine(nHdl,aTotCol,@nE)
				
				aEval( aTotal , {|x| x[2] += If( Empty(x[2]) , "="+cSoma+"(", ";") + x[1] + LTrim(Str(nE,10)) } )
			//Endif
		Next
		
		aTotCol := { "", "", "", "", "", "", "", "TOTAL GERAL"}
		aEval( aTotal , {|x| AAdd( aTotCol , x[2] + ")" ) } )
		AAdd( aTotCol , "" )
		
		WriteLine(nHdl,aTotCol,@nE)
	Else    // Planilha Funcionário X Conta Contábil
		ASort( aTotCta ,,, {|x,y| x[1]+x[2] < y[1]+y[2] })   // Ordena o vetor por Tipo Conta + Descrição contábil
		
		// Monta o cabeçalho com as colunas a serem exportadas
		aCabec := { "FILIAL","FUNCIONARIO","ADMISSAO","DESCRICAO RH","PERIODO"}
		aEval( aTotCta , {|x| AAdd( aCabec , x[2] ) } )
		WriteLine(nHdl,aCabec,@nE)
		
		// Ajusta o array quebrando o funcionário em funcionário + período
		aAux := {}
		For nX:=1 To Len(aFunc)
			nY := 1
			While nY <= Len(aFunc[nX,4])
				cPeriodo := aFunc[nX,4][nY,1]
				AAdd( aAux , { aFunc[nX,1], aFunc[nX,2], cPeriodo, {}} )
				While nY <= Len(aFunc[nX,4]) .And. cPeriodo == aFunc[nX,4][nY,1]
					AAdd( aAux[Len(aAux),4] , { aFunc[nX,4][nY,2], aFunc[nX,4][nY,3]} )
					nY++
				Enddo
			Enddo
		Next
		
		aFunc := aClone(aAux)
		
		For nX:=1 To Len(aFunc)
			PesqFunc(aFunc[nX,1])   // Posiciona no funcionário
			
			aTotCol := { SRA->RA_FILIAL, aFunc[nX,2], Dtoc(SRA->RA_ADMISSA), "", aFunc[nX,3]}
			
			For nY:=1 To Len(aTotCta)
				nPos := AScan( aFunc[nX,4] , {|x| aTotCta[nY,3] == x[1] } )
				AAdd( aTotCol , Transform(If( nPos > 0 , aFunc[nX,4][nPos,2], 0),"@"+If(lAmeric,"","E")+" 999999999.99") )
			Next
			
			WriteLine(nHdl,aTotCol,@nE)
		Next
	Endif
	
	u_INRunExcel(cPath,cArqTxt)
	
Return .T.

Static Function WriteLine(nHdl,aLinha,nE)
	Local x
	Local cLinha := ""
	
	AEval( aLinha , {|x| cLinha += x + Chr(9) })
	cLinha += chr(13)+chr(10)  // Quebra de linha
	
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf
	
	nE++   // Atualiza a linha atual do Excel
Return

Static Function PesqFunc(cMat)
	Local nRecno
	
	If SRA->(dbSeek(cMat,.T.))            // Posiciona no funcionário
		nRecno := SRA->(Recno())
		While !SRA->(Eof()) .And. cMat == SRA->RA_MAT
			If Empty(SRA->RA_DEMISSA)   // Verifica se o vendedor está ativo
				nRecno := SRA->(Recno())
				Exit
			Endif
			SRA->(dbSkip())
		Enddo
		SRA->(dbGoTo(nRecno))   // Posiciona no funcionário encontrado
	Endif
	
Return

Static Function SelecOpc()
	Local oDlg
	Local nOpc := 0
	
	DEFINE MSDIALOG oDlg TITLE "Geração de Planihas" From 12,8 To 17,57 OF oMainWnd
	
	@ 05,050 SAY "Quais planilhas abaixo deseja gerar?" OF oDlg PIXEL COLOR CLR_HBLUE
	
	@ 20,008 BUTTON "Func. X C.C." SIZE 40,12 PIXEL OF oDlg ACTION (nOpc:=1,oDlg:End())
	@ 20,055 BUTTON "Func. X Ctas" SIZE 40,12 PIXEL OF oDlg ACTION (nOpc:=2,oDlg:End())
	@ 20,102 BUTTON "Todas"        SIZE 40,12 PIXEL OF oDlg ACTION (nOpc:=3,oDlg:End())
	@ 20,149 BUTTON "Nenhuma"      SIZE 40,12 PIXEL OF oDlg ACTION (nOpc:=0,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg //CENTERED
	
Return nOpc

Static Function ConvDescr(cString)
	cString := StrTran(cString,".","")
	cString := StrTran(cString," ","")
	cString := StrTran(cString,"/","")
	cString := StrTran(cString,"-","")
	cString := StrTran(cString,"º","")
	
	cString := StrTran(cString,"SOES","SAO")
Return cString

/////////////////////////////////
Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data                  ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data               ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Do Colaborador           ",29)+"?","","","mv_ch3","C", 6,0,0,"G","","SZ8","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate o Colaborador        ",29)+"?","","","mv_ch4","C", 6,0,0,"G","","SZ8","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Do Projeto               ",29)+"?","","","mv_ch5","C", 9,0,0,"G","","CTT","","","mv_par05")
	u_INPutSX1(cPerg,"06",PADR("Ate o Projeto            ",29)+"?","","","mv_ch6","C", 9,0,0,"G","","CTT","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Quebra por item contabil ",29)+"?","","","mv_ch7","N", 1,0,0,"C","","   ","","","mv_par07","Sim","","","","Nao")
	u_INPutSX1(cPerg,"08",PADR("Considera Filiais a baixo",29)+"?","","","mv_ch8","N", 1,0,0,"C","","   ","","","mv_par08","Sim","","","","Nao")
	u_INPutSX1(cPerg,"09",PADR("Da Filial                ",29)+"?","","","mv_ch9","C", 2,0,0,"G","","   ","","","mv_par09")
	u_INPutSX1(cPerg,"10",PADR("Ate a Filial             ",29)+"?","","","mv_cha","C", 2,0,0,"G","","   ","","","mv_par10")
	u_INPutSX1(cPerg,"11",PADR("Imprime resumo no final  ",29)+"?","","","mv_chb","N", 1,0,0,"C","","   ","","","mv_par11","Sim","","","","Nao")
	u_INPutSX1(cPerg,"12",PADR("Classe MCT               ",29)+"?","","","mv_chc","C", 9,0,0,"G","","CTH","","","mv_par12")
	u_INPutSX1(cPerg,"13",PADR("Considera P.A.           ",29)+"?","","","mv_chd","N", 1,0,0,"C","","   ","","","mv_par13","Sim","","","","Nao")
	u_INPutSX1(cPerg,"14",PADR("Imprime relatorio por    ",29)+"?","","","mv_che","N", 1,0,0,"C","","   ","","","mv_par14","Caixa","","","","Competencia",;
									"","","Contabil","","","Hibrido","","","Base MCT")
	u_INPutSX1(cPerg,"15",PADR("Considera estornos       ",29)+"?","","","mv_chf","N", 1,0,0,"C","","   ","","","mv_par15","Sim","","","","Nao")
Return
