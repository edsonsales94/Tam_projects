#Include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INFINP05 ³ Autor ³ Reinaldo Magalhaes    ³ Data ³ 20.11.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Geracao do arquivo texto com despesas de P&D p/ FPF        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01         Da Data                      ?
//³ mv_par02         Ate a Data                   ?
//³ mv_par03         Do Projeto                   ?
//³ mv_par04         Ate o Projeto                ?
//³ mv_par05         Da Classe MCT                ?
//³ mv_par06         Ate a Classe MCT             ?
//³ mv_par07         Arquivo de Saida             ?
//³ mv_par08         Cons. Filiais abaix          ?
//³ mv_par09         Da Filial                    ?
//³ mv_par10         Ate a Filial                 ?
//³ mv_par11         Arquivo Justificativa        ?
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
User Function INFINP05()
	Local cPerg     := PADR("INFINP05",Len(SX1->X1_GRUPO))
	Local cCadastro := OemtoAnsi("Geracao de Arquivo TXT - FPF")
	Local aSays     := {}
	Local aButtons  := {}
	Local nOpca     := 0
	Local vOpcao    := { "Caixa", "Competência", "Contábil"}
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays,OemToAnsi("Esta rotina irá gerar um arquivo em formato TXT com todas as despesas de ") )
	AADD(aSays,OemToAnsi("P&D de acordo com os parâmetros informados pelo usuário.                 ") )
	
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
		Processa({|| GeraTXT() },"Geração de Arquivo TXT - "+vOpcao[mv_par12])
	EndIf
	
Return

////////////////////////
Static Function GeraTXT
	Local cArq, cQry, cViagem, cJustifi, cDescri, cDocUni, cIniProj, cFimProj, lRefaz, nEntra, nSaida, cArqDW, cParDw
	Local cDtFinal, nMesDepr, cInd, cBusca, cHist, cHora, cHistDoc, nPos, x, f, cItemCTA, nValItem, vUnico, cProd
	Local cTpImp    := MVISS+";"+MVINSS+";"+MVTAXA+";"+MVTXA
	Local cTmpFileA := Trim(mv_par07) //- Despesas do projeto
	Local cTmpFileB := Trim(mv_par11) //- Justificativa
	Local vFilial   := { "01", "02", "03"}   // Filiais cadastradas no sistema
	Local l
	
	Private nNumID, cData, cCGC, cCGCPrin, cFornec, cUF, cPais, cIE, cIM, cQuant, cEntra, cSaida, cTreina, cInicio, cFim, cValor
	Private cGrpAtf, cMesDepr, cLocal, cChapa, cDtAquis, cDtBaixa, cDtDepr, _cJus, cFilSE5, cPercUso, cKey
	Private vAuxSd1, cPrfTit, cNumTit, cParcTit, cTipoTit, cCodFor, cLojaFor, vLinha, l, nTotReg, nReg, cAtivida, cFuncao, cDemissa
	Private aReturn := { "", 1, "", 2, 2, 1, "", 1}
	Private cCRLF   := chr(13)+chr(10)
	Private nTamDoc := TamSX3("F2_DOC")[1]
	
	mv_par11 := StrTran(Upper(mv_par07),".TXT",".UDF")
	
	//- Criando arquivo para despesas de projeto (A)
	If !File(cTmpFileA)
		fHandleA:= FCREATE(cTmpFileA)
	Else
		FErase(cTmpFileA)
		fHandleA:= FCREATE(cTmpFileA)
	Endif
	
	//- Criando arquivo para a justificativa (B)
	If !File(cTmpFileB)
		fHandleB:= FCREATE(cTmpFileB)
	Else
		FErase(cTmpFileA)
		fHandleB:= FCREATE(cTmpFileB)
	Endif
	
	cArqDW := "\DWMCT\MCTFILE.DBF"
	lRefaz := !(File(cArqDW) .And. MsgYesNo("Existe um arquivo gerado, deseja utilizá-lo ?"))
	
	aStru  := SE5->(dbStruct())
	
	If lRefaz
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processando Saidas  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par12 < 3      // Se não for Contábi ou Base MCT
			If mv_par12 == 2   // Se for Competência
				cQry := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE2")+" WHERE D_E_L_E_T_ <> '*' AND "
				
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
				cArq := u_INDADCOMP(cQry,mv_par01,mv_par02,,,mv_par03,mv_par04,mv_par08,mv_par09,mv_par10,,1,"C")
			Endif
			
			cQry := "SELECT COUNT(*) SOMA FROM "+RetSqlName("SE5")+" WHERE D_E_L_E_T_ <> '*' AND "
			cQry += "E5_DTDISPO >= '"+DTOS(mv_par01)+"' AND E5_DTDISPO <= '"+DTOS(mv_par02)+"' AND "
			
			If mv_par08 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += "E5_FILIAL >= '"+mv_par09+"' AND E5_FILIAL <= '"+mv_par10+"' AND "
			Else
				cQry += "E5_FILIAL = '"+xFilial("SE5")+"' AND "
			Endif
			cQry += "E5_RECPAG = 'P' AND "+u_CondPadRel()
			
			If mv_par12 == 1   // Se for Caixa
				// - D= Ref. Despesas financeiras                   FIN MAT GPE PA(1=Sim/2=Nao)
				Processa({|| cArq := u_INDADSE5("TMP",cQry,aStru,"",.T.,.T.,.T.,1,"D",.T.) },"Filtro de Dados","Filtrando Saidas...")
			Else
				cQry += " AND E5_CCD >= '"+mv_par03+"' AND E5_CCD <= '"+mv_par04+"'"
				cQry += " AND E5_CLVLDB >= '"+mv_par05+"' AND E5_CLVLDB <= '"+mv_par06+"' AND E5_MOTBX = ' '"
				
				// - D= Ref. Despesas financeiras                   FIN MAT GPE
				Processa({|| u_INDADSE5("TMP",cQry,aStru,aReturn[7],.T.,.T.,.T.,1,"D",.F.,,,.T.) },"Filtro de Dados","Filtrando Saidas...")
			Endif
		ElseIf mv_par12 == 3      // Se for Contábi
			cQry := "SELECT COUNT(*) SOMA FROM "+RetSQLName("CT2")+" CT2 WHERE D_E_L_E_T_ <> '*'"
			cQry += " AND CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2_DATA <= '"+Dtos(mv_par02)+"'"
			cQry += " AND ((CT2_CCD >= '"+mv_par03+"' AND CT2_CCD <= '"+mv_par04+"')"
			cQry += " OR (CT2_CCC >= '"+mv_par03+"' AND CT2_CCC <= '"+mv_par04+"'))"
			
			// Busca e filtra Classe MCT pelo Plano de Contas
			cQry += " AND ("
			cQry += " (CT2_DC IN ('1','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_DEBITO = CT1_CONTA AND CT1_GRUPO >= '"+mv_par05+"' AND CT1_GRUPO <= '"+mv_par06+"'))"
			cQry += " OR"
			cQry += " (CT2_DC IN ('2','3') AND "
			cQry += " EXISTS(SELECT * FROM "+RetSQLName("CT1")+" WHERE D_E_L_E_T_ = ' '"
			cQry += " AND CT2_CREDIT = CT1_CONTA AND CT1_GRUPO >= '"+mv_par05+"' AND CT1_GRUPO <= '"+mv_par06+"')))"
			
			If mv_par08 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND CT2_FILIAL >= '"+mv_par09+"' AND CT2_FILIAL <= '"+mv_par10+"'"
			Else
				cQry += " AND CT2_FILIAL = '"+xFilial("CT2")+"'"
			Endif
			
			// Rotina de Busca de Dados --> INFINP04.PRW
			Processa({|| cArq := u_INFINP04("TMP",cQry,"D",.T.,.T.) },"Filtro de Dados","Filtrando Saidas...")
		Else      // Se for Base MCT
			cQry := "SELECT COUNT(*) SOMA"
			cQry += " FROM "+RetSQLName("SZ3")+" SZ3"
			cQry += " WHERE SZ3.D_E_L_E_T_ = ' '"
			
			If mv_par08 == 1    // Considera Filial ==  1-Sim  2-Nao
				cQry += " AND SZ3.Z3_FILIAL >= '"+mv_par09+"' AND SZ3.Z3_FILIAL <= '"+mv_par10+"'"
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
		
		dbSelectArea("TMP")
		Copy To &(cArqDW)
	Else
		Use &(cArqDW) Alias TMP New Exclusive
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordenando o arquivo gerado por classe de valor  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cInd := CriaTrab(NIL ,.F.)
	cKey := "E5_CLVL+E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_CC+E5_ITEMCTA+E5_ITEM+Dtos(E5_DTDISPO)"
	
	IndRegua("TMP",cInd,cKey,,,"Selecionando Registros...")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Geracao do arquivo TXT  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TMP")
	nTotReg := RecCount()
	ProcRegua(nTotReg)
	
	dbGoTop()
	
	nNumID := 0
	nReg   := 0
	
	While !TMP->(Eof())
		vUnico := {}
		cClVl  := E5_CLVL
		While !TMP->(Eof()) .And. cClVl == E5_CLVL
			cJustifi := " "
			vLinha   := {}
			cFilSE5  := E5_FILIAL
			cData    := FormatDate(E5_DTDISPO)
			cPrfTit  := E5_PREFIXO
			cNumTit  := E5_NUMERO
			cParcTit := E5_PARCELA
			cTipoTit := E5_TIPO
			cCodFor  := E5_CLIFOR
			cLojaFor := E5_LOJA
			cFornec  := Padr(cFilSE5 + "/" +cCodFor + " - FORNECEDOR NAO ENCONTRADO",38)
			cCGC     := Space(18)
			cCGCPrin := Space(18)
			cUF      := "  "
			cPais    := Space(20)
			cIE      := Space(10)
			cIM      := Space(10)
			cHistDoc := " "
			cAtivida := Space(120)
			cFuncao  := Space(40)
			cDemissa := Space(08)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verificando a origem do documento, se for o financeiro, o historico ³
			//³ sera o historico do documento, se for o compras sera a descricao    ³
			//³ do produto                                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SE2->(dbSetOrder(1))
			If SE2->(dbSeek(cFilSE5+cPrfTit+cNumTit+cParcTit+cTipoTit+cCodFor+cLojaFor))
				cHistDoc := SE2->(If(Empty(E2_HIST),cHistDoc,E2_HIST))
			Endif
			
			//- Fornecedores
			SA2->(dbSetOrder(1))
			If SA2->(dbSeek(cFilSE5+cCodFor+cLojaFor))
				cFornec := Padr(Trim(SA2->A2_NOME),38)
				cCGC    := SA2->A2_CGC
				cUF     := SA2->A2_EST
				cIE     := StrTran(StrTran(SA2->A2_INSCR,".",""),"-","")
				cIM     := StrTran(StrTran(SA2->A2_INSCRM,".",""),"-","")
				cPais   := SA2->A2_PAISORI
			Endif
			
			While !TMP->(Eof()) .And. cClVl+cFilSE5+cPrfTit+cNumTit+cParcTit+cTipoTit+cCodFor+cLojaFor == E5_CLVL+E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA
				
				If mv_par13 == 2 .And. Empty(E5_ROTINA)  // Ignora registros sem referência
					dbSkip()
					Loop
				Endif
				
				If !CheckUnique()
					Loop
				Endif
				
				cItemCTA := E5_ITEMCTA
				
				If Trim(E5_CLVL) == "001"  // Se for RH
					// Busca a matrícula mais recente do colaborador
					cItemCTA := Colaborador(cItemCTA)
				Endif
				
				//- Item contabil
				CTD->(dbsetOrder(1))
				If CTD->(dbSeek(xFilial("CTD")+cItemCTA))
					cNomeCTA:= CTD->CTD_DESC01
				Else
					cNomeCTA:= "COLABORADOR NAO ENCONTRADO"
				Endif
				
				cDescCT1 := E5_DESCT1
				cProd    := If(!Empty(E5_PRODUTO), E5_PRODUTO, cFornec)
				cTreina  := Space(Len(SZ8->Z8_DESCRI))
				cIniProj := FormatDate(Posicione("CTT",1,xFilial("CTT")+E5_CC,"CTT_DTEXIS"))
				cFimProj := FormatDate(Posicione("CTT",1,xFilial("CTT")+E5_CC,"CTT_DTEXSF"))
				cInicio  := Space(8)
				cFim     := Space(8)
				cLocal   := Space(Len(SZ8->Z8_LOCAL))
				cHist    := If( Empty(E5_BENEF) , cHistDoc, E5_BENEF)
				cHora    := Space(6)
				
				If E5_RECPAG == "R" //- Entrada
					nEntra := E5_VALOR
					nSaida := 0
				Else
					nEntra := 0
					nSaida := E5_VALOR  //Padr(StrTran(Transform(E5_VALOR,"999999999999.99"),".",""),14)
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³       O B J E T I V O  E  J U S T I F I C A T  I V A                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//³ 1- Pedido de Compras                                                ³
				//³ 2- Solicitacao de compras                                           ³
				//³ 3- Viagem                                                           ³
				//³ 4- Documento de Entrada                                             ³
				//³ 5- Treinamento                                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If Trim(E5_CLVL) $ "001,002,005,006,007"  // Se for RH, Equipamento, Material de Consumo, Viagem ou Treinamento
					cJustifi := " "
					cDescri  := Space(40)
					vInfo    := {}
					If Trim(E5_CLVL) == "001"
						cDocUni  := cNumTit
						cData    := FormatDate(E5_DTDISPO)
						cDescCT1 := "CUSTO DO COLABORADOR"
						nPos     := AScan( vUnico , {|x| x[2]+x[4]+SubStr(x[30],3,6)+x[31] == E5_CLVL+PADR(cItemCTA,6)+SubStr(cData,3,6)+cFilSE5 })
					ElseIf Trim(E5_CLVL) == "002"
						// Para Equipamento, pega os dados do fornecedor do pedido (Que é o Principal)
						SC7->(dbSetOrder(1))
						SC7->(dbSeek(cFilSE5+TMP->E5_PRCOMP))
						SA2->(dbSetOrder(1))
						SA2->(dbSeek(cFilSE5+SC7->(C7_FORNECE+C7_LOJA)))
						
						vInfo := { Space(03), SC7->C7_FORNECE, SA2->A2_CGC, SA2->A2_EST, SA2->A2_INSCR, SA2->A2_INSCRM, SA2->A2_PAISORI}
						cDocUni := PADR(E5_PRCOMP,nTamDoc)
						cDescri := E5_PRODUTO
						nPos    := AScan( vUnico , {|x| x[2]+x[31]+x[29] == E5_CLVL+cFilSE5+cDocUni })
						
						// Atualiza a variavel de gravacao da justificativa
						BuscaJustif(TMP->E5_PRCOMP,TMP->E5_ITEM,@cJustifi)
					ElseIf Trim(E5_CLVL) == "005"
						vInfo   := { cPrfTit, cFornec, cCGC, cUF, cIE, cIM, cPais}
						cDocUni := cNumTit
						cDescri := E5_PRODUTO
						nPos    := AScan( vUnico , {|x| x[2]+x[29]+x[30]+x[7]+x[31] == E5_CLVL+cDocUni+cData+cDescri+cFilSE5 })
						
						// Atualiza a variavel de gravacao da justificativa
						BuscaJustif(TMP->E5_PRCOMP,TMP->E5_ITEM,@cJustifi)
					ElseIf Trim(E5_CLVL) == "006"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Informacoes da viagem      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cDocUni := PADR(TMP->E5_VIAGEM,nTamDoc)
						nPos    := AScan( vUnico , {|x| x[2]+x[31]+x[29] == E5_CLVL+cFilSE5+cDocUni })
						
						If Empty(E5_VIAGEM)
							cItemCTA := " "
							cNomeCTA := "COLABORADOR NAO ENCONTRADO"
						Endif
						
						If nPos == 0
							SZ7->(dbSetOrder(1))
							If SZ7->(dbSeek(cFilSE5+TMP->E5_VIAGEM))
								cViagem  := SZ7->Z7_DESCRI
								cLocal   := SZ7->Z7_DESTINO
								cInicio  := FormatDate(SZ7->Z7_IDA)
								cFim     := FormatDate(SZ7->Z7_VOLTA)
								cAtivida := SZ7->Z7_ATIVIDA
								
								// Pesquisa o pais cadastrado na viagem
								PC1->(dbSetOrder(1))
								If PC1->(dbSeek(XFILIAL("PC1")+SZ7->Z7_PAIS))
									cPais := PADR(PC1->PC1_NOME,20)
								Endif
								
								// Pesquisa o estado cadastrado na viagem
								PC2->(dbSetOrder(1))
								If PC2->(dbSeek(XFILIAL("PC2")+SZ7->(Z7_ESTADO+Z7_PAIS)))
									cUF := PC2->PC2_SIGLA
								Endif
								
								// Pesquisa a cidade destino cadastrada na viagem
								PC3->(dbSetOrder(1))
								If PC3->(dbSeek(XFILIAL("PC3")+SZ7->(Z7_CIDADE+Z7_ESTADO+Z7_PAIS)))
									cLocal := PADR(PC3->PC3_NOME,30)
								Endif
							Endif
							
							//- Justificativas de Viagens
							SZ6->(dbSetOrder(1)) //- Filial + Codigo
							If SZ6->(dbSeek(cFilSE5+"3"+cDocUni))
								cJustifi := SZ6->Z6_JUSTIFI
							Endif
						Endif
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Informacoes do treinamento   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cDocUni := PADR(TMP->E5_TREINAM,nTamDoc)
						nPos    := AScan( vUnico , {|x| x[2]+x[31]+x[29]+x[4] == E5_CLVL+cFilSE5+cDocUni+PADR(E5_ITEMCTA,6) })
						
						If nPos == 0
							SZ8->(dbSetOrder(1)) //- Filial + Codigo
							If SZ8->(dbSeek(cFilSE5+TMP->E5_TREINAM))
								cTreina := SZ8->Z8_DESCRI
								cLocal  := SZ8->Z8_LOCAL
								cInicio := FormatDate(SZ8->Z8_INICIO)
								cFim    := FormatDate(SZ8->Z8_FIM)
								cHora   := PADR(SZ8->Z8_HORA,6)
							Endif
							//- Justificativas
							SZ6->(dbSetOrder(1))
							If SZ6->(dbSeek(cFilSE5+"5"+cDocUni))
								cJustifi := AllTrim(SZ6->Z6_JUSTIFI)
								cJustifi += If(SubStr(cJustifi,Len(cJustifi),1) == "." ," ", ". ")
							Endif
						Else
							cHora   := vUnico[nPos,13]
							cInicio := vUnico[nPos,17]
						Endif
						If !Empty(cHora)  // Se existe valor válido para a hora
							cHora := RateioTreino(cHora,PADR(E5_ITEMCTA,9),E5_CC,cInicio)
						Endif
					Endif
					
					// Tira cópia da linha para o 1o item ou para classe Equipamento (será utilizado quando processar a nota principal)
					vCopia := {}
					If nPos == 0 .Or. (Trim(E5_CLVL) == "002" .And. SC7->(C7_FORNECE+C7_LOJA) == E5_CLIFOR+E5_LOJA)
						vCopia := {	E5_CC,;                                               //  1
										E5_CLVL,;                                             //  2
										E5_NODI,;                                             //  3
										PADR(cItemCTA,6),;                                    //  4
										PADR(cNomeCTA,29),;                                   //  5
										If( Empty(E5_ITEM), "0000", E5_ITEM),;                //  6
										cDescri,;                                             //  7
										E5_QUANT,;                                            //  8
										0,;                                                   //  9
										0,;                                                   // 10
										Padr(E5_CONTAB,10),;                                  // 11
										Padr(cHist,60),;                                      // 12
										cHora,;                                               // 13
										0,;                                                   // 14
										Padr(cDescCT1,40),;                                   // 15
										cTreina,;                                             // 16
										cIniProj,;                                            // 17
										cFimProj,;                                            // 18
										cInicio,;                                             // 19
										cFim,;                                                // 20
										PADR(E5_DESCCC,40),;                                  // 21
										cLocal,;                                              // 22
										E5_RECPAG,;                                           // 23
										E5_SEQ,;                                              // 24
										E5_TIPODOC,;                                          // 25
										E5_PRCOMP,;                                           // 26
										E5_BASEATF,;                                          // 27
										0,;                                                   // 28
										cDocUni,;                                             // 29
										cData,;                                               // 30
										cFilSE5,;                                             // 31
										"",;                                                  // 32
										cJustifi,;                                            // 33
										cAtivida,;                                            // 34
										E5_MOVBCO,;                                           // 35
										cFuncao,;                                             // 36
										cDemissa,;                                            // 37
										aClone(vInfo),;                                       // 38
										cUF,;                                                 // 39
										cPais}                                                // 40
					Endif
					
					If nPos == 0
						AAdd( vUnico , aClone(vCopia) )
						nPos := Len(vUnico)
					ElseIf !Empty(vCopia)
						// Se for Equipamentos acerta colunas conforme a nota principal
						For x:=1 To Len(vCopia)
							// Atribui todos os campos menos os de valores pois são acumuladores
							If x <> 9 .And. x <> 10 .And. x <> 28
								vUnico[nPos,x] := If( ValType(vCopia[x]) <> "A" , vCopia[x], aClone(vCopia[x]))
							Endif
						Next
					Endif
					
					vUnico[nPos, 9] += nEntra
					vUnico[nPos,10] += nSaida
					vUnico[nPos,14] := vUnico[nPos,10] - vUnico[nPos, 9]
					vUnico[nPos,28] += E5_VALOR
					vUnico[nPos,29] := If( Trim(vUnico[nPos,2]) == "001" .And. Empty(vUnico[nPos,29]) , E5_NUMERO, vUnico[nPos,29])
					vUnico[nPos,30] := If( cData > vUnico[nPos,30] , cData, vUnico[nPos,30])
					
					// Se for Material de Consumo e colaborado não foi encontrado ainda
					If Trim(E5_CLVL) == "005" .And. "COLABORADOR" $ vUnico[nPos,5]
						BuscaColaborador(@vUnico[nPos,4],@vUnico[nPos,5])
					Endif
				Else
					
					// Se for Serviços de Terceiros ou Intercâmbio
					If Trim(E5_CLVL) $ "008,012"
						// Pesquisa o centro de custo no vetor a Linha
						If (nPos := AScan( vLinha , {|x| x[1]+x[35] == E5_CC+E5_MOVBCO })) == 0
							cItemCTA := " "
							cNomeCTA := "COLABORADOR NAO ENCONTRADO"
						Else
							// Caso tenha encontrado, acumula valores
							vLinha[nPos, 9] += nEntra
							vLinha[nPos,10] += nSaida
							vLinha[nPos,14] := vLinha[nPos,10] - vLinha[nPos, 9]
							vLinha[nPos,28] += E5_VALOR
							
							dbSkip()
							Loop
						Endif
					Endif
					
					AAdd( vLinha , {	E5_CC,;                                               //  1
											E5_CLVL,;                                             //  2
											E5_NODI,;                                             //  3
											PADR(cItemCTA,6),;                                    //  4
											PADR(cNomeCTA,29),;                                   //  5
											If( Empty(E5_ITEM), "0000", E5_ITEM),;                //  6
											PADR(cProd,40),;                                      //  7
											E5_QUANT,;                                            //  8
											nEntra,;                                              //  9
											nSaida,;                                              // 10
											Padr(E5_CONTAB,10),;                                  // 11
											Padr(cHist,60),;                                      // 12
											E5_HORA,;                                             // 13
											nSaida - nEntra,;                                     // 14
											Padr(cDescCT1,40),;                                   // 15
											cTreina,;                                             // 16
											cIniProj,;                                            // 17
											cFimProj,;                                            // 18
											cInicio,;                                             // 19
											cFim,;                                                // 20
											PADR(E5_DESCCC,40),;                                  // 21
											cLocal,;                                              // 22
											E5_RECPAG,;                                           // 23
											E5_SEQ,;                                              // 24
											E5_TIPODOC,;                                          // 25
											E5_PRCOMP,;                                           // 26
											E5_BASEATF,;                                          // 27
											E5_VALOR,;                                            // 28
											"",;                                                  // 29
											"",;                                                  // 30
											"",;                                                  // 31
											"",;                                                  // 32
											"",;                                                  // 33
											cAtivida,;                                            // 34
											E5_MOVBCO,;                                           // 35
											cFuncao,;                                             // 36
											cDemissa,;                                            // 37
											{},;                                                  // 38
											cUF,;                                                 // 39
											cPais} )                                              // 40
				Endif
				
				dbSkip()
			Enddo
			
			// Processa as linhas pegas do documento
			For l:=1 To Len(vLinha)
				
				cQuant   := Transform(vLinha[l,8],"9999999999")
				cEntra   := Padr(StrTran(Transform(vLinha[l, 9],"999999999999.99"),".",""),14)
				cSaida   := Padr(StrTran(Transform(vLinha[l,10],"999999999999.99"),".",""),14)
				cGrpAtf  := Space(30)
				cMesDepr := Space(08)
				cChapa   := Space(06)
				cDtAquis := Space(08)
				cDtDepr  := Space(08)
				cDtBaixa := Space(08)
				cPercUso := Space(5)
				cValor   := Padr(StrTran(Transform(vLinha[l,14],"999999999999.99"),".",""),14)
				cAtivida := vLinha[l,34]
				cFuncao  := vLinha[l,36]
				cDemissa := vLinha[l,37]
				vAuxSd1  := {}
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento para itens do imobilizado  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Trim(SE2->E2_ORIGEM) == "MATA100"
					cDescri  := ""
					nValItem := 0
					cJustifi := ""
					
					If FindSE5()
						cBusca := cFilSE5+SE2->(E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA)
						SF1->(dbSetOrder(1))
						SF1->(dbSeek(cBusca))
						SD1->(dbSetOrder(1))
						SD1->(dbSeek(cBusca,.T.))
						cDescri  := vLinha[l,07]
						nValItem := vLinha[l,28]
						While !SD1->(Eof()) .And. cBusca == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
							
							If SD1->D1_ITEM == vLinha[l,06] .Or.;
								(vLinha[l,02] == SD1->D1_CLVL .And. PADR(vLinha[l,04], 9) == SD1->D1_ITEMCTA .And.;
								vLinha[l,01] == SD1->D1_CC   .And. PADR(vLinha[l,11],20) == SD1->D1_CONTA)
								
								cDescri  := SD1->D1_DESCRI
								nValItem := SD1->D1_TOTAL
								
								BuscaJustif(SD1->D1_PRCOMP,SD1->D1_ITEM,@cJustifi)
								
								Exit
							Endif
							
							SD1->(dbSkip())
						Enddo
					Endif
					
					If Empty(cJustifi)
						BuscaJustif(vLinha[l,26],vLinha[l,06],@cJustifi)
					Endif
					
					AAdd( vAuxSd1, { SubStr(cDescri,1,40),; //1
					vLinha[l,08],;         //2
					vLinha[l,28],;         //3
					vLinha[l,27],;         //4
					vLinha[l,26],;         //5
					vLinha[l,06],;         //6
					(nValItem / SF1->F1_VALBRUT) * 100,; //7
					cNumTit,;      //8
					cPrfTit,;      //9
					"",;           //10
					cJustifi } )   //11
					
				ElseIf Trim(SE2->E2_ORIGEM) $ "FINA050,GPEM670"
					SZ6->(dbSetOrder(1))
					If SZ6->(dbSeek(cFilSE5+"4"+SE2->(E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA)))
						If !(AllTrim(SZ6->Z6_JUSTIFI) $ AllTrim(cJustifi))
							cJustifi := AllTrim(cJustifi) + If( Empty(cJustifi) , "", " ") + AllTrim(SZ6->Z6_JUSTIFI)
							cJustifi += If(SubStr(cJustifi,Len(cJustifi),1) == "." ,"", ".")
						Endif
					Endif
				Endif
				
				// Caso não tenha encontrado o item contábil
				If Empty(vLinha[l,04])
					BuscaColaborador(@vLinha[l,04],@vLinha[l,05])
				Endif
				
				// Atualiza a variavel de gravacao da justificativa
				_cJus := cJustifi
				
				PrepGrv()
			Next l
		Enddo
		
		SRA->(dbSetOrder(1))
		SA2->(dbSetOrder(1))
		
		// Processa as Classes MCT que devem gerar registro único: RH, Viagem e Treinamento
		vLinha := AClone(vUnico)
		
		If Trim(cClVl) == "001"
			ASort(vLinha,,,{|x,y| x[2]+x[4]+x[30]+x[1] < y[2]+y[4]+y[30]+y[1] })  // Ordena por CLVL + Matricula + Data + CC
		ElseIf Trim(cClVl) <> "005"
			ASort(vLinha,,,{|x,y| x[2]+x[29]+x[4]+x[1] < y[2]+y[29]+y[4]+y[1] })  // Ordena por CLVL + Viagem + Matricula + CC
		Endif
		
		For l:=1 To Len(vLinha)
			
			cPrfTit  := Space(3)
			cNumTit  := vLinha[l,29]
			cData    := vLinha[l,30]
			cFilSE5  := vLinha[l,31]
			cCGC     := Space(18)
			cCGCPrin := Space(18)
			cDtAquis := Space(08)
			cUF      := vLinha[l,39]
			cIE      := Space(10)
			cIM      := Space(10)
			cPais    := vLinha[l,40]
			cFuncao  := vLinha[l,36]
			cDemissa := vLinha[l,37]
			cCodFor  := Space(6)
			cFornec  := Padr(cFilSE5 + "/" +cCodFor + " - FORNECEDOR NAO ENCONTRADO",38)
			cLojaFor := Space(2)
			
			If !Empty(vLinha[l,38])  // Caso tenha sido informado (Classe 002 e 005)
				cPrfTit := vLinha[l,38][1]
				cFornec := vLinha[l,38][2]
				cCGC    := vLinha[l,38][3]
				cUF     := vLinha[l,38][4]
				cIE     := vLinha[l,38][5]
				cIM     := vLinha[l,38][6]
			Else
				For f:=1 To Len(vFilial)
					// Pesquisa a matricula nas três filiais
					If SRA->(dbSeek(vFilial[f]+vLinha[l,4]))
						cCGC     := SRA->RA_CIC
						cCGCPrin := SRA->RA_CIC
						
						If Trim(vLinha[l,2]) == "001"   // Se for RH
							//vLinha[l,1] := SRA->RA_CC
							cDtAquis := FormatDate(SRA->RA_ADMISSA)
							cUF      := If( SRA->RA_NATURAL == "EX" , "  ", SRA->RA_NATURAL)
							cPais    := If( SRA->RA_NATURAL == "EX" , PADR("EX",20), PADR("BRASIL",20))
							cDemissa := If( SRA->RA_DEMISSA <= mv_par02 , FormatDate(SRA->RA_DEMISSA), Space(08))
							
							// Pesquisa a descrição da Função
							SRJ->(dbSetOrder(1))
							If SRJ->(dbSeek(XFILIAL("SRJ")+SRA->RA_CODFUNC))
								cFuncao := PADR(SRJ->RJ_DESC,40)
							Endif
						Endif
						
						Exit
					Endif
				Next
			Endif
			
			cTipoTit := Space(3)
			cParcTit := Space(Len(SE2->E2_PARCELA))
			cQuant   := Transform(vLinha[l,8],"9999999999")
			cEntra   := Padr(StrTran(Transform(vLinha[l, 9],"999999999999.99"),".",""),14)
			cSaida   := Padr(StrTran(Transform(vLinha[l,10],"999999999999.99"),".",""),14)
			cGrpAtf  := Space(30)
			cMesDepr := Space(08)
			cChapa   := Space(06)
			cDtDepr  := Space(08)
			cDtBaixa := Space(08)
			cPercUso := Space(5)
			cValor   := Padr(StrTran(Transform(vLinha[l,14],"999999999999.99"),".",""),14)
			cHistDoc := " "
			cAtivida := vLinha[l,34]
			vAuxSd1  := {}
			
			// Atualiza a variavel de gravacao da justificativa
			_cJus := vLinha[l,33]
			
			PrepGrv()
		Next
	Enddo
	dbSelectArea("TMP")
	dbCloseArea()
	
	FErase(cInd+".IDX")
	
	FCLOSE(fHandleA)
	FCLOSE(fHandleB)
Return

Static Function BuscaColaborador(cMat,cNome)
	
	SRA->(dbSetOrder(5))  // Ordem: Filial + CPF
	SRA->(dbSeek(cFilSE5+PADR(cCGC,11),.T.))
	While !SRA->(Eof()) .And. SRA->(RA_FILIAL+RA_CIC) == cFilSE5+PADR(cCGC,11)
		cMat  := SRA->RA_MAT
		cNome := PADR(SRA->RA_NOME,29)
		// Se encontrou um registro não demitido
		If SRA->RA_SITFOLH <> "D"
			Exit
		Endif
		SRA->(dbSkip())
	Enddo
	
Return

Static Function CheckUnique()
	Local nPos := 0
	Local nRet := 0
	Local cCC  := E5_CC
	Local cItC := E5_ITEMCTA
	Local cIte := E5_ITEM
	Local bKey := {|| cClVl+cFilSE5+cPrfTit+cNumTit+cParcTit+cTipoTit+cCodFor+cLojaFor+cCC+cItC+cIte == E5_CLVL+E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_CC+E5_ITEMCTA+E5_ITEM }
	
	While !TMP->(Eof()) .And. Eval(bKey)
		
		nReg++
		
		IncProc("Gerando TXT..."+Alltrim(Str(nReg))+"/"+Alltrim(Str(nTotReg)))
		
		If E5_CC < mv_par03 .Or. E5_CC > mv_par04 .Or. E5_CLVL < mv_par05 .Or. E5_CLVL > mv_par06 .Or. E5_VALOR = 0 .Or.;
			E5_STATUS <> "S" .Or. If( mv_par12 == 1 , E5_BAICOMP == "C", E5_BAICOMP <> "C") .Or. Empty(E5_CC) .Or. Empty(E5_CLVL) .Or.;
			"ESTORNO" $ E5_BENEF .Or. (E5_RECPAG == "R" .And. Trim(E5_CLVL) <> "001")
			dbSkip()
			Loop
		Endif
		
		nPos := Recno()
		
		// Sai para essas Classes pois ocorre de ter vários lançamentos para o mesmo documento ou origem do Mov. Bancário ou Folha
		If Trim(E5_CLVL) $ "001,002,005,006,007,008,012" .Or. Trim(E5_ROTINA) $ "FINA100,GPEM670"
			Exit
		Endif
		
		dbSkip()
	Enddo
	
	If nPos > 0
		dbGoTo(nPos)
	Endif
	
Return nPos > 0

Static Function PrepGrv()
	Local cLinha, nMesDepr, cBaseAtf, i
	
	If Len(vAuxSd1) == 0
		GrvTXT(vLinha)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para itens do imobilizado   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For i:=1 to Len(vAuxSD1)
			
			cQuant   := Transform(vAuxSD1[i,2],"9999999999")
			cEntra   := Space(14)
			cSaida   := Padr(StrTran(Transform(vAuxSD1[i,3],"999999999999.99"),".",""),14)
			cGrpAtf  := Space(30)
			cMesDepr := Space(08)
			cChapa   := Space(06)
			cDtAquis := Space(08)
			cDtDepr  := Space(08)
			cDtBaixa := Space(08)
			cPercUso := Space(05)
			
			If !Empty(vAuxSD1[i,4])
				cPercUso := Padr(StrTran(Transform(vAuxSD1[i,7],"999.99"),".",""),5)
				cBaseAtf := Padr(vAuxSD1[i,4],10)
				//- Cadastro do bem
				SN1->(DbSetOrder(1))
				If SN1->(DbSeek(cFilSE5+cBaseAtf))
					cChapa   := SN1->N1_CHAPA
					cDtAquis := Substr(Dtos(SN1->N1_AQUISIC),7,2)+Substr(Dtos(SN1->N1_AQUISIC),5,2)+Substr(Dtos(SN1->N1_AQUISIC),1,4)
					cDtBaixa := Substr(Dtos(SN1->N1_BAIXA),7,2)+Substr(Dtos(SN1->N1_BAIXA),5,2)+Substr(Dtos(SN1->N1_BAIXA),1,4)
					cGrpAtf  := Padr(Posicione("SNG",1,xFilial("SNG")+SN1->N1_GRUPO,"NG_DESCRIC"),30)
					nMesDepr := Posicione("SNG",1,xFilial("SNG")+SN1->N1_GRUPO,"NG_TXDEPR1") * 12
					cMesDepr := Str(Int(nMesDepr),8)
				Endif
				
				//- Saldos do bem
				SN3->(dbSetOrder(1))
				If SN3->(dbSeek(cFilSE5+cBaseAtf))
					cDtDepr:= FormatDate(SN3->N3_DINDEPR)
				Endif
			Endif
			
			// Atualiza a variavel de gravacao da justificativa
			_cJus := vAuxSD1[i,11]
			
			GrvTXT(vLinha)
			
		Next i
	Endif
	
Return .T.

Static Function GrvTXT(vLinha)
	Local cLinha
	
	nNumID++
	
	cLinha := vLinha[l,01]                          //- Centro de Custo                                -> 01 -  09 posicoes -   1
	cLinha += vLinha[l,02]                          //- Classe de Valor                                -> 02 -  09 posicoes -  10
	cLinha += cData                                 //- Data (ddmmaaaa)                                -> 03 -  08 posicoes -  19
	cLinha += cNumTit                               //- Doc                                            -> 04 -  09 posicoes -  27
	cLinha += cPrfTit                               //- Serie                                          -> 05 -  03 posicoes -  36
	cLinha += vLinha[l,03]                          //- Declaracao de Importacao                       -> 06 -  12 posicoes -  39
	cLinha += PADR(cCGC,18)                         //- CPF/CNPJ                                       -> 07 -  18 posicoes -  51
	cLinha += PADR(cCGCPrin,18)                     //- CPF/CNPJ do Fator Gerador                      -> 08 -  18 posicoes -  69
	cLinha += FormataTXT(cFornec,38)                //- Razao Social                                   -> 09 -  38 posicoes -  87
	cLinha += vLinha[l,04]                          //- Matricula                                      -> 10 -  06 posicoes - 125
	cLinha += vLinha[l,05]                          //- Nome colaborador                               -> 11 -  29 posicoes - 131
	cLinha += If(Empty(cUF),"AM",cUF)               //- Estado da Federacao                            -> 12 -  02 posicoes - 160
	cLinha += Padr(cIE,10)                          //- Insc.Estadual                                  -> 13 -  10 posicoes - 162
	cLinha += Padr(cIM,10)                          //- Insc.Municipal                                 -> 14 -  10 posicoes - 172
	cLinha += SubStr(vLinha[l,06],2,3)              //- Item da nota fiscal                            -> 15 -  03 posicoes - 182
	cLinha += vLinha[l,07]                          //- Descricao                                      -> 16 -  40 posicoes - 185
	cLinha += cQuant                                //- Quantidade                                     -> 17 -  10 posicoes - 225
	cLinha += cEntra                                //- Entradas                                       -> 18 -  14 posicoes - 235
	cLinha += cSaida                                //- Saidas                                         -> 19 -  14 posicoes - 249
	cLinha += cFilSE5                               //- Site                                           -> 20 -  02 posicoes - 263
	cLinha += vLinha[l,11]                          //- Conta Contabil                                 -> 21 -  10 posicoes - 265
	cLinha += FormataTXT(vLinha[l,12],60)           //- Historico                                      -> 22 -  60 posicoes - 275
	cLinha += vLinha[l,13]                          //- Horas Treinamento                              -> 23 -  06 posicoes - 335
	cLinha += cValor                                //- Valor                                          -> 24 -  14 posicoes - 341
	cLinha += vLinha[l,15]                          //- Nome da conta contabil                         -> 25 -  40 posicoes - 355
	cLinha += vLinha[l,16]                          //- Nome do treinamento                            -> 26 -  30 posicoes - 395
	cLinha += vLinha[l,17]                          //- Dt inicio do projeto                           -> 27 -  08 posicoes - 425
	cLinha += vLinha[l,18]                          //- Dt final do projeto                            -> 28 -  08 posicoes - 433
	cLinha += vLinha[l,19]                          //- Dt inicio (Viagem/treinamento)                 -> 29 -  08 posicoes - 441
	cLinha += vLinha[l,20]                          //- Dt final  (Viagem/treinamento)                 -> 30 -  08 posicoes - 449
	cLinha += cPercUso                              //- Percentual de uso                              -> 31 -  05 posicoes - 457
	cLinha += vLinha[l,21]                          //- Nome do projeto                                -> 32 -  40 posicoes - 462
	cLinha += vLinha[l,22]                          //- Cidade (Colaborador/Fornecedor/Viagem/Destino) -> 33 -  30 posicoes - 502
	cLinha += cUF                                   //- Estado (Colaborador/Fornecedor/Viagem/Destino) -> 34 -  02 posicoes - 532
	cLinha += cPais                                 //- País (Colaborador/Fornecedor/Viagem/Destino)   -> 35 -  20 posicoes - 534
	cLinha += cChapa                                //- No. ativo                                      -> 36 -  06 posicoes - 554
	cLinha += cGrpAtf                               //- Grupo imobilizado                              -> 37 -  30 posicoes - 560
	cLinha += cMesDepr                              //- Tempo de depreciacao do grupo                  -> 38 -  08 posicoes - 590
	cLinha += cDtAquis                              //- Data de aquisicao                              -> 39 -  08 posicoes - 598
	cLinha += cDtDepr                               //- Data de inicio da depreciacao                  -> 40 -  08 posicoes - 606
	cLinha += cDtBaixa                              //- Data baixa do bem                              -> 41 -  08 posicoes - 614
	cLinha += cTipoTit                              //- Tipo do documento                              -> 42 -  03 posicoes - 622
	cLinha += cParcTit                              //- Parcela do documento                           -> 43 -  01 posicao  - 625
	cLinha += vLinha[l,23]                          //- Pagamento/Recebimento                          -> 44 -  02 posicoes - 626
	cLinha += cCodFor                               //- Fornecedor/Cliente                             -> 45 -  06 posicoes - 628
	cLinha += FormataTXT(cLojaFor,2)                //- Loja do Fornecedor/Cliente                     -> 46 -  02 posicoes - 634
	cLinha += vLinha[l,24]                          //- Sequencia do documento                         -> 47 -  02 posicoes - 636
	cLinha += vLinha[l,25]                          //- Tipo do documento                              -> 48 -  02 posicoes - 638
	cLinha += cAtivida                              //- Atividade                                      -> 49 - 120 posicoes - 640
	cLinha += cFuncao                               //- Funcao do Colaborador                          -> 50 -  40 posicoes - 760
	cLinha += cDemissa                              //- Data de Demissao                               -> 51 -  08 posicoes - 800
	cLinha += StrZero(nNumID,6)                     //- ID do registro                                 -> 52 -  06 posicoes - 808
	cLinha += cCRLF
	
	fWrite(fHandleA,cLinha,Len(cLinha))
	lRet:= .T.
	
	GrvMemo(nNumID)
	
Return NIL

///////////////////////////////////////////////////////////
Static Function GrvMemo(nNumID)
	Local x, cLinha
	Local vLin:= u_QuebraLinha("",_cJus)
	
	For x:=1 To Len(vLin)
		cLinha := StrZero(nNumID,6)           //- Id da justificativa              -> 06 posicoes
		cLinha += StrZero(x,3)                //- Item da justificativa            -> 03 posicoes
		cLinha += Padr(Alltrim(vLin[x,1]),64) //-                                  -> 64 posicoes
		cLinha += Padr(Alltrim(vLin[x,2]),64) //- Descrição da justificativa       -> 64 posicoes
		cLinha += cCRLF
		fWrite(fHandleB,cLinha,Len(cLinha))
	Next
	
Return

/////////////////////////////////////////
Static Function FormataTXT(cString,nTam)
	Local cRet := ""
	Local j
	cString := Upper(AllTrim(cString))
	For j:=1 To Len(cString)
		cChar := SubStr(cString,j,1)
		If !(cChar $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789. ")
			cChar := "" //SPACE(1) // cChar:= "" -> Modificao wermeson 25/04/08
		Endif
		cRet += cChar
	Next
	cRet := Padr(cRet,nTam)
	
Return cRet

Static Function FormatDate(dData)
Return Substr(Dtos(dData),7,2)+Substr(Dtos(dData),5,2)+Substr(Dtos(dData),1,4)

Static function FindSE5()
	Local lRet := .T.
	
	If cTipoTit $ "TX ,INS,ISS"
		lRet := .F.
		
		If !(Trim(SE2->E2_ORIGEM) $ "GPEM670") //- Origem diferente do GPE ou do FIN
			SE2->(dbSetOrder(1))
			SE2->(dbSeek(cFilSE5+cNumTit+cPrfTit,.T.))
			While !SE2->(Eof()) .And. cFilSE5+cNumTit+cPrfTit == SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM)
				If !(SE2->E2_TIPO $ "TX ,INS,ISS")
					If (cTipoTit == "ISS" .And. SE2->E2_PARCISS == cParcTit) .Or.;
						(cTipoTit == "INS" .And. SE2->E2_PARCINS == cParcTit) .Or.;
						(cTipoTit == "TX " .And. SE2->E2_PARCIR  == cParcTit) .Or.;
						(cTipoTit == "TX " .And. SE2->E2_PARCSLL == cParcTit) .Or.;
						(cTipoTit == "TX " .And. SE2->E2_PARCCOF == cParcTit) .Or.;
						(cTipoTit == "TX " .And. SE2->E2_PARCPIS == cParcTit)
						lRet := .T.
						Exit
					Endif
				Endif
				SE2->(dbSkip())
			Enddo
		Endif
	Endif
	
Return lRet

Static Function BuscaJustif(cPrComp,cItem,cJustifi)
	Local lAchou := .F.
	
	SZ6->(dbSetOrder(1))
	If !Empty(cPrComp)
		lAchou:= SZ6->(dbSeek(cFilSE5+"1"+PADR(cPrComp,nTamDoc)))
	Else
		lAchou:= SZ6->(dbSeek(cFilSE5+"4"+SE2->(E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA+cItem)))
		If !lAchou
			lAchou:= SZ6->(dbSeek(cFilSE5+"4"+SE2->(E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA+Space(Len(cItem)))))
		Endif
	Endif
	
	If lAchou
		If !(AllTrim(SZ6->Z6_JUSTIFI) $ AllTrim(cJustifi))
			cJustifi += AllTrim(SZ6->Z6_JUSTIFI)
			cJustifi += If(SubStr(cJustifi,Len(cJustifi),1) == "." ,"", ".") + cCRLF
		Endif
	Endif
	
Return

Static Function Colaborador(cItem)
	Local cCPF, dAdmissao
	Local cFilSRA := SRA->(XFILIAL("SRA"))
	
	// Pesquisa a matrícula no cadastro de funcionários
	SRA->(dbSetOrder(1))
	If SRA->(dbSeek(cFilSRA+cItem))
		cCPF      := SRA->RA_CIC
		dAdmissao := SRA->RA_ADMISSA
		
		// Pesquisa as matrículas cadastradas para o CPF
		SRA->(dbSetOrder(5))
		SRA->(dbSeek(cFilSRA+cCPF,.T.))
		While !SRA->(Eof()) .And. cFilSRA+cCPF == SRA->(RA_FILIAL+RA_CIC)
			
			// Identifica a data de admissão mais recente
			If SRA->RA_ADMISSA > dAdmissao
				dAdmissao := SRA->RA_ADMISSA
				cItem     := SRA->RA_MAT
			Endif
			
			SRA->(dbSkip())
		Enddo
	Endif
	
Return cItem

Static Function RateioTreino(cHora,cMat,cCC,cData)
	Local cFil := SZ1->(XFILIAL("SZ1"))
	Local nTot := 0
	Local nSom := 0
	Local nPos := 0
	Local vPrj := {}
	Local cRet := cHora
	
	cData := SubStr(cData,5,4)+SubStr(cData,3,2)
	
	SZ1->(dbSetOrder(2))
	SZ1->(dbSeek(cFil+cMat+cData,.T.))
	While !SZ1->(Eof()) .And. cFil+cMat == SZ1->(Z1_FILIAL+Z1_MAT)
		If SubStr(Dtos(SZ1->Z1_DATA),1,6) == cData                           // Pesquisa percentuais do mesmo período
			AAdd( vPrj , Round(Val(cHora) * SZ1->Z1_PERC,0))                  // Guarda os percentuais dos projetos do período
			nTot += SZ1->Z1_PERC                                              // Totaliza os percentuais
			nSom += vPrj[Len(vPrj)]                                           // Soma o percentual calculado para o projeto
			nPos := If( nPos == 0 .And. SZ1->Z1_CC == cCC , Len(vPrj), nPos)  // Verifica se o projeto é o procurado
		Endif
		SZ1->(dbSkip())
	Enddo
	
	// Se totalizou 100% e encontrou o projeto
	If nTot == 1 .And. nPos > 0
		vPrj[Len(vPrj)] += (Val(cHora) - nSom)    // Acerta a diferença no último projeto
		cRet := PADR(LTrim(Str(vPrj[nPos],10)),6) // Retorna o total de horas para o projeto
	Endif
	
Return cRet

/////////////////////////////////
Static Function ValidPerg(cPerg)
	u_INPutSX1(cPerg,"01",PADR("Da Data                   ",29)+"?","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01")
	u_INPutSX1(cPerg,"02",PADR("Ate a Data                ",29)+"?","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02")
	u_INPutSX1(cPerg,"03",PADR("Do Projeto                ",29)+"?","","","mv_ch3","C", 9,0,0,"G","","CTT","","","mv_par03")
	u_INPutSX1(cPerg,"04",PADR("Ate o Projeto             ",29)+"?","","","mv_ch4","C", 9,0,0,"G","","CTT","","","mv_par04")
	u_INPutSX1(cPerg,"05",PADR("Da Classe MCT             ",29)+"?","","","mv_ch5","C", 9,0,0,"G","","CTH","","","mv_par05")
	u_INPutSX1(cPerg,"06",PADR("Ate a Classe MCT          ",29)+"?","","","mv_ch6","C", 9,0,0,"G","","CTH","","","mv_par06")
	u_INPutSX1(cPerg,"07",PADR("Arquivo de Saida          ",29)+"?","","","mv_ch7","C",40,0,0,"G","","   ","","","mv_par07")
	u_INPutSX1(cPerg,"08",PADR("Considera Filiais a baixo ",29)+"?","","","mv_ch8","N", 1,0,0,"C","","   ","","","mv_par08","Sim","","","","Nao")
	u_INPutSX1(cPerg,"09",PADR("Da Filial                 ",29)+"?","","","mv_ch9","C", 2,0,0,"G","","   ","","","mv_par09")
	u_INPutSX1(cPerg,"10",PADR("Ate a Filial              ",29)+"?","","","mv_cha","C", 2,0,0,"G","","   ","","","mv_par10")
	u_INPutSX1(cPerg,"11",PADR("Arquivo da Justificativa  ",29)+"?","","","mv_chb","C",40,0,0,"G","","   ","","","mv_par11")
	u_INPutSX1(cPerg,"12",PADR("Gera arquivo por          ",29)+"?","","","mv_chc","N", 1,0,0,"C","","   ","","","mv_par12","Caixa","","","",;
	"Competencia","","","Contabil","","","Base MCT")
	u_INPutSX1(cPerg,"13",PADR("Imprime doc sem referencia",29)+"?","","","mv_chd","N", 1,0,0,"C","","   ","","","mv_par13","Sim","","","","Nao")
Return
