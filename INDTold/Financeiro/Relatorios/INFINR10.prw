#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INFINR10 º Autor ³ Alidio Ribeiro     º Data ³  27/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de despesas de projetos                          º±±
±±º          ³ Por Centro de Custo                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico INDT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºData      ³ Descricao da alteracao                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º21/01/05  ³ Incluido calculo de rateio pelo valor realmente utilizado  º±±
±±º          ³ referente a um P.A                                         º±±
±±º06/05/05  ³ Incluida a opcao de ordem por centro de custo              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INFINR10

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Despesas de Projetos INDT"
Local titulo        := "Despesas de Projetos"
Local nLin          := 80
Local Cabec1        := ""
Local Cabec2        := ""
Local cPerg         := PADR("INFINR10",Len(SX1->X1_GRUPO))

//                               1                    2                3              4               5               6
Local aOrd          := { "Por Centro Custo", "Por Classe MCT", "Por Documento", "Por Data", "Por Cta Contabil","Por Alfab. CC"}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "INFINR10"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "INFINR10"
Private cString     := "SE5"

ValidPerg(cPerg)
pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo  := If(aReturn[4]==1,15,18)
Titulo := Trim(Titulo)+" - "+aOrd[aReturn[8]]
Cabec1 := "  Data      Documento  Prefixo  C. Custo   C.Contabil  Desc.C.Contabil                 Desc.Cat. MCT                   Colaborador                  Banco  Agencia  Beneficiario                    Filial            Valor"
//    "99/99/9999  xxxxxxxxx  xxx      xxxxxxxxx  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxx 123    12345    123456789012345678901234567890  123      999,999,999.99
//              1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

Processa({|| ExecProc(Cabec1,Cabec2,Titulo,nLin) }, "Filtrando dados")
Return

Static Function ExecProc(Cabec1,Cabec2,Titulo,nLin)
	Local aStru, cArq, cInd, cQry, cKey, cDtFinal, cQPA
	Local cTpImp := MVISS+";"+MVINSS+";"+MVTAXA+";"+MVTXA
	
	If mv_par16 < 3  // Se não for a opção Contábil ou Base MCT
		Titulo += " (Base Oficial)"
		If mv_par16 == 1   // Por Regime de Caixa
			Titulo += " - Caixa"
		Else
			Titulo += " - Competencia"
			cQry   := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
			cQry   += "E2_NUM >= '"+mv_par07+"' AND E2_NUM <= '"+mv_par08+"' AND "
			cQry   += "E2_PREFIXO >= '"+mv_par09+"' AND E2_PREFIXO <= '"+mv_par10+"' AND "
			
			If mv_par11 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += "E2_FILIAL >= '"+mv_par12+"' AND E2_FILIAL <= '"+mv_par13+"' AND "
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
			cArq := u_INDADCOMP(cQry,mv_par01,mv_par02,,,mv_par03,mv_par04,mv_par11,mv_par12,mv_par13,,mv_par14)
		Endif
		
		aStru := SE5->( dbStruct() )
		cQry  := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE5")+" WHERE D_E_L_E_T_ <> '*' AND "
		cQry  += "E5_DTDISPO >= '"+dtos(mv_par01)+"' AND E5_DTDISPO <= '"+dtos(mv_par02)+"' AND  "
		cQry  += "E5_NUMERO >= '"+mv_par07+"' AND E5_NUMERO <= '"+mv_par08+"' AND "
		cQry  += "E5_PREFIXO >= '"+mv_par09+"' AND E5_PREFIXO <= '"+mv_par10+"' AND "
		
		//NAO CONSIDERA CP (COMPENSACAO) BA (BAIXA) E QUANDO NAO REGISTRAR O BANCO - ADELSON
		cQry  += "E5_RECPAG = 'P' AND "+u_CondPadRel()
		
		If mv_par11 == 1    // Considera Filial ==  1-Sim  2-Nao
			cQry += " AND E5_FILIAL >= '"+mv_par12+"' AND E5_FILIAL <= '"+mv_par13+"'"
		Else
			cQry += " AND E5_FILIAL = '"+xFilial("SE5")+"'"
		Endif
		
		If mv_par16 == 1   // Se for Caixa
			// Rotina de Busca de Dados --> INDACFG.PRW      FIN MAT GPE             Junta REC e PGT
			cArq := u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par14,,,,.T.)
		Else
			cQry += " AND E5_CCD >= '"+mv_par03+"' AND E5_CCD <= '"+mv_par04+"'"
			cQry += " AND E5_CLVLDB >= '"+mv_par05+"' AND E5_CLVLDB <= '"+mv_par06+"' AND E5_MOTBX = ' '"
			
			// - D= Ref. Despesas financeiras                   FIN MAT GPE
			Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,mv_par14,"D",.F.,,,.T.) },"Filtro de Dados","Filtrando Saidas...")
		Endif
	ElseIf mv_par16 == 3  // Se não for a opção Contábil
		Titulo += " (Base Oficial) - Contabil"
		
		cQry := "SELECT COUNT(*) SOMA FROM "+RetSQLName("CT2")+" CT2 WHERE D_E_L_E_T_ <> '*'"
		cQry += " AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
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
		
		If mv_par11 == 1    // Considera Filial ==  1-Sim  2-Nao
			cQry += " AND CT2_FILIAL >= '"+mv_par12+"' AND CT2_FILIAL <= '"+mv_par13+"'"
		Else
			cQry += " AND CT2_FILIAL = '"+xFilial("CT2")+"'"
		Endif
		
		// Rotina de Busca de Dados --> INFINP04.PRW
		Processa({|| cArq := u_INFINP04("TMP",cQry,"D",.T.,.T.) },"Filtro de Dados","Filtrando Saidas...")
	Else  // Se não for a opção Base MCT
		Titulo += " (Base MCT)"
		
		cQry := "SELECT COUNT(*) SOMA"
		cQry += " FROM "+RetSQLName("SZ3")+" SZ3"
		cQry += " WHERE SZ3.D_E_L_E_T_ = ' '"
		
		If mv_par11 == 1    // Considera Filial ==  1-Sim  2-Nao
			cQry += " AND SZ3.Z3_FILIAL >= '"+mv_par12+"' AND SZ3.Z3_FILIAL <= '"+mv_par13+"'"
		Else
			cQry += " AND SZ3.Z3_FILIAL = '"+xFilial("SZ3")+"'"
		Endif
		
		cQry += " AND SZ3.Z3_DTDISPO >= '"+Dtos(mv_par01)+"' AND SZ3.Z3_DTDISPO <= '"+Dtos(mv_par02)+"'"
		cQry += " AND SZ3.Z3_CC >= '"+mv_par03+"' AND SZ3.Z3_CC <= '"+mv_par04+"'"
		cQry += " AND SZ3.Z3_CLVL >= '"+mv_par05+"' AND SZ3.Z3_CLVL <= '"+mv_par06+"'"
		cQry += " AND SZ3.Z3_NUMERO >= '"+mv_par07+"' AND SZ3.Z3_NUMERO <= "+mv_par08+"'"
		cQry += " AND SZ3.Z3_PREFIXO >= '"+mv_par09+"' AND SZ3.Z3_PREFIXO <= "+mv_par10+"'"
		
		// Rotina de Busca de Dados --> INFINP08.PRW
		Processa({|| cArq := u_INFINP08("TMP",cQry,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
	Endif
	
	cInd := CriaTrab(NIL ,.F.)
	cKey := If( aReturn[8] == 1 , "E5_CC+E5_CLVL+Dtos(E5_DTDISPO)", "")
	cKey := If( aReturn[8] == 2 , "E5_CLVL+Dtos(E5_DTDISPO)+E5_CC", cKey)
	cKey := If( aReturn[8] == 3 , "Dtos(E5_DTDISPO)+E5_NUMERO+E5_PREFIXO", cKey)
	cKey := If( aReturn[8] == 4 , "Dtos(E5_DTDISPO)+E5_CC+E5_CLVL", cKey)
	cKey := If( aReturn[8] == 5 , "E5_CC+E5_CLVL+E5_CONTAB+Dtos(E5_DTDISPO)", cKey)
	cKey := If( aReturn[8] == 6 , "E5_DESCCC+E5_CLVL+Dtos(E5_DTDISPO)", cKey)
	
	IndRegua("TMP",cInd,cKey,,,"Selecionando Registros...")
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
	FErase(cArq+GetDBExtension())
	FErase(cInd+OrdBagExt())
Return

Static function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local lCentury, cCCusto, cClsVal, dData, nTotal, nSoma, nSubTot, cDoc, cNumero, cPrefixo, cTipo, cFiltro
	Local nSubClVl, cContab, dData
	
	lCentury := (Len(Dtoc(dDataBase)) > 8)
	nTotal   := 0.00
	
	dbSelectArea("TMP")
	SetRegua(RecCount())
	dbgotop()
	
	While !Eof()
		nSoma:= 0.00
		If aReturn[8] = 1 .or. aReturn[8] = 6 //- Por Centro Custo (E5_CC+E5_CLVL+E5_DTDISPO)
			cCCusto := E5_CC
			Do while !Eof() .and. E5_CC == cCCusto
				nSubTot := 0.00
				cClsVal := E5_CLVL //- Classe MCT
				Do while !Eof() .and. E5_CC == cCCusto .and. E5_CLVL == cClsVal
					ProcItem(Cabec1,Cabec2,Titulo,lCentury,@nLin,@nSubTot)
					dbSkip() // Avanca o ponteiro do registro no arquivo
				Enddo
				If nSubTot <> 0
					@ nLin,000 PSAY "  "
					nLin++
					@ nLin,012 PSAY "Total da Classe MCT "+cClsVal+" ("+Trim(Posicione("CTH",1,XFILIAL("CTH")+cClsVal,"CTH_DESC01"))+") >>>"
					@ nLin,207 PSAY nSubTot Picture "@E 999,999,999.99"
					nLin++
					@ nLin,000 PSAY "  "   //Repli("_",Limite)
					nLin++
					nSoma += nSubTot
				Endif
			Enddo
		ElseIf aReturn[8] == 2   // Por Classe MCT (E5_CLVL+E5_DTDISPO+E5_CC)
			cClsVal:= E5_CLVL
			Do while !Eof() .and. E5_CLVL == cClsVal
				ProcItem(Cabec1,Cabec2,Titulo,lCentury,@nLin,@nSoma)
				dbSkip() // Avanca o ponteiro do registro no arquivo
			Enddo
		ElseIf aReturn[8] == 3   // Por Documento (E5_DTDISPO+E5_NUMERO+E5_PREFIXO)
			cDoc    := E5_NUMERO+E5_PREFIXO+E5_BENEF
			cNumero := E5_NUMERO
			cPrefixo:= E5_PREFIXO
			cTipo   := E5_TIPO
			nSubTot := 0.00
			Do while !Eof() .and. E5_NUMERO+E5_PREFIXO+E5_BENEF == cDoc
				ProcItem(Cabec1,Cabec2,Titulo,lCentury,@nLin,@nSubTot)
				dbSkip() // Avanca o ponteiro do registro no arquivo
			Enddo
			If nSubTot <> 0
				@ nLin,000 PSAY "  "
				nLin++
				@ nLin,012 PSAY "Total do Documento "+cNumero+" "+cPrefixo+"     >>> "
				@ nLin,207 PSAY nSubTot Picture "@E 999,999,999.99"
				nLin++
				@ nLin,000 PSAY Repli("_",Limite)
				nLin++
				nSoma += nSubTot
			Endif
		ElseIf aReturn[8] == 4  // Por E5_DTDISPO+E5_CC+E5_CLVL
			dData := E5_DTDISPO
			Do while !Eof() .And. E5_DTDISPO == dData
				ProcItem(Cabec1,Cabec2,Titulo,lCentury,@nLin,@nSoma)
				dbSkip() // Avanca o ponteiro do registro no arquivo
			Enddo
		Else  // Por E5_CC+E5_CLVL+E5_CONTAB+Dtos(E5_DTDISPO)
			cCCusto:= E5_CC
			Do while !Eof() .and. E5_CC == cCCusto
				cClsVal := E5_CLVL //- Classe MCT
				nSubClvl:= 0.00
				Do while !Eof() .and. E5_CC+E5_CLVL == cCCusto+cClsVal
					nSubTot:= 0.00
					cContab:= E5_CONTAB
					Do while !Eof() .and. E5_CC+E5_CLVL+E5_CONTAB == cCCusto+cClsVal+cContab
						ProcItem(Cabec1,Cabec2,Titulo,lCentury,@nLin,@nSubTot)
						dbSkip() // Avanca o ponteiro do registro no arquivo
					Enddo
					If nSubTot <> 0
						@ nLin,000 PSAY "  "
						nLin++
						@ nLin,012 PSAY "Total da Conta Contabil " + cContab + ") >>>"
						@ nLin,207 PSAY nSubTot Picture "@E 999,999,999.99"
						nLin++
						@ nLin,000 PSAY "  "   //Repli("_",Limite)
						nLin++
						nSoma += nSubTot
						nSubClvl += nSubTot
					Endif
				Enddo
				If nSubClvl <> 0
					@ nLin,000 PSAY "  "
					nLin++
					@ nLin,012 PSAY "Total da Classe MCT "+cClsVal+" ("+Trim(Posicione("CTH",1,XFILIAL("CTH")+cClsVal,"CTH_DESC01"))+") >>>"
					@ nLin,207 PSAY nSubClvl Picture "@E 999,999,999.99"
					nLin++
					@ nLin,000 PSAY "  "   //Repli("_",Limite)
					nLin++
				Endif
			Enddo
		Endif
		If aReturn[8] <> 3 .and. nSoma <> 0 //- por documento
			If aReturn[8] = 1 .or. aReturn[8] = 5 .or. aReturn[8] = 6
				@ nLin,012 PSAY "Total do Centro de Custo "+cCCusto+" ("+Trim(Posicione("CTT",1,XFILIAL("CTT")+cCCusto,"CTT_DESC01"))+") >>>"
			ElseIf aReturn[8] = 2
				@ nLin,000 PSAY "  "
				nLin++
				@ nLin,012 PSAY "Total da Classe MCT "+cClsVal+" ("+Trim(Posicione("CTH",1,XFILIAL("CTH")+cClsVal,"CTH_DESC01"))+") >>>"
			Else
				@ nLin,000 PSAY "  "
				nLin++
				@ nLin,012 PSAY "Total da Data ("      +Dtoc(dData)+") >>>"
			Endif
			@ nLin,207 PSAY nSoma    Picture "@E 999,999,999.99"
			nLin++
			@ nLin,000 PSAY Repli("_",Limite)
			nLin++
		Endif
		nTotal += nSoma
	Enddo
	dbCloseArea()
	If nTotal <> 0 //- Total geral
		If aReturn[8] == 3
			@ nLin,000 PSAY "  "
			nLin++
		Endif
		@ nLin,012 PSAY "Total Geral  >>>"
		@ nLin,207 PSAY nTotal    Picture "@E 999,999,999.99"
		nLin++
		@ nLin,000 PSAY Repli("_",Limite)
	Endif
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return

Static Function ProcItem(Cabec1,Cabec2,Titulo,lCentury,nLin,nTotItem)
	Local cNomeCTA := "COLABORADOR NAO ENCONTRADO"
	
	IncRegua()
	
	If E5_NUMERO  < mv_par07 .Or. E5_NUMERO  > mv_par08 .Or.;
		E5_PREFIXO < mv_par09 .Or. E5_PREFIXO > mv_par10
		Return
	Endif
	
	If E5_CC >= mv_par03 .And. E5_CC <= mv_par04 .And. E5_CLVL >= mv_par05 .And. E5_CLVL <= mv_par06 .And.;
		E5_STATUS == "S" .And. E5_ORIGEM <> "4" //<-- Não imprimir APORTE NOKIA
		//- Item contabil
		CTD->(DbsetOrder(1))
		If CTD->(DbSeek(xFilial("CTD")+TMP->E5_ITEMCTA))
			cNomeCTA := CTD->CTD_DESC01
		Endif
		
		If nLin > 60
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
		Endif
		@ nLin,000      PSAY E5_DTDISPO
		If !lCentury
			@ nLin,Pcol()+2 PSAY ""
		Endif
		@ nLin,Pcol()+2 PSAY E5_NUMERO
		@ nLin,Pcol()+2 PSAY E5_PREFIXO
		@ nLin,Pcol()+6 PSAY E5_CC               //- C. Custo
		@ nLin,Pcol()+2 PSAY PADR(E5_CONTAB,10)  //- C.Contabil
		@ nLin,Pcol()+2 PSAY PADR(E5_DESCT1,30)  //- Desc.C.Contabil
		@ nLin,Pcol()+2 PSAY PADR(E5_DESCTH,30)  //- Desc.Cat. MCT
		@ nLin,Pcol()+2 PSAY PADR(cNomeCTA,28)   //- Colaborador
		@ nLin,Pcol()+1 PSAY E5_BANCO
		@ nLin,Pcol()+4 PSAY E5_AGENCIA
		@ nLin,Pcol()+4 PSAY PADR(E5_BENEF,30)
		@ nLin,Pcol()+2 PSAY u_NomeFilial(E5_FILIAL)
		@ nLin,Pcol()+7 PSAY E5_VALOR * If( E5_RECPAG == "P" , 1, -1) Picture "@E 999,999,999.99"
		nLin++
		
		nTotItem += E5_VALOR * If( E5_RECPAG == "P" , 1, -1)
	Endif
	
Return

Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data                  ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data               ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Do Projeto               ",29)+"?","","","mv_ch3","C", 9,0,0,"G","","CTT","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate o Projeto            ",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Da Classe MCT            ",29)+"?","","","mv_ch5","C", 9,0,0,"G","","CTH","","","mv_par05")
	u_INPutSX1(cPerg,"06",PADR("Ate a Classe MCT         ",29)+"?","","","mv_ch6","C", 9,0,0,"G","","CTH","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Do Documento             ",29)+"?","","","mv_ch7","C", 9,0,0,"G","","   ","","","mv_par07")
	u_INPutSX1(cPerg,"08",PADR("Ate o Documento          ",29)+"?","","","mv_ch8","C", 9,0,0,"G","","   ","","","mv_par08")
	u_INPutSX1(cPerg,"09",PADR("Do Prefixo               ",29)+"?","","","mv_ch9","C", 3,0,0,"G","","   ","","","mv_par09")
	u_INPutSX1(cPerg,"10",PADR("Ate o Prefixo            ",29)+"?","","","mv_cha","C", 3,0,0,"G","","   ","","","mv_par10")
	u_INPutSX1(cPerg,"11",PADR("Considera Filiais a baixo",29)+"?","","","mv_chb","N", 1,0,0,"C","","   ","","","mv_par11","Sim","","","","Nao")
	u_INPutSX1(cPerg,"12",PADR("Da Filial                ",29)+"?","","","mv_chc","C", 2,0,0,"G","","   ","","","mv_par12")
	u_INPutSX1(cPerg,"13",PADR("Ate a Filial             ",29)+"?","","","mv_chd","C", 2,0,0,"G","","   ","","","mv_par13")
	u_INPutSX1(cPerg,"14",PADR("Considera P.A.           ",29)+"?","","","mv_che","N", 1,0,0,"C","","   ","","","mv_par14","Sim","","","","Nao")
	u_INPutSX1(cPerg,"15",PADR("Considera Entradas       ",29)+"?","","","mv_chf","N", 1,0,0,"C","","   ","","","mv_par15","Sim","","","","Nao")
	u_INPutSX1(cPerg,"16",PADR("Imprime relatorio por    ",29)+"?","","","mv_chg","N", 1,0,0,"C","","   ","","","mv_par16","Caixa","","","","Competencia",;
							"","","Contabil","","","Base MCT")
Return
