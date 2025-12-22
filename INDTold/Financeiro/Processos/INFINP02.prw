#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INFINP02 ³ Autor ³ Ronilton O. Barros    ³ Data ³ 03.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de alteracao de dados lancados na base oficial      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revis„o  ³                                          ³ Data ³          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INFINP02()
	Local cCadastro, aSays, aButtons, nOpca, cQry, vTela
	Local cPerg   := PADR("INFINP02",Len(SX1->X1_GRUPO))
	
	Private aCols1, aHeader1, aCols, aHeader
	
	ValidPerg(cPerg)
	
	While .T.
		
		vTela := { 1, .T., .T.}
		Pergunte(cPerg,.F.)
		
		cCadastro := OemtoAnsi("Alteração Dados Base Oficial")
		aSays     := {}
		aButtons  := {}
		nOpca     := 0
		
		AADD(aSays,OemToAnsi("Esta rotina permitirá alterar os dados  referentes  a:  Projeto,  Classe  MCT,") )
		AADD(aSays,OemToAnsi("Colaborador, Descrição, Pedido, Viagem, Treinamento e  Justificativa de acordo") )
		AADD(aSays,OemToAnsi("com os paramêtros informados  pelo  usuário.  A rotina irá  exibir documento a") )
		AADD(aSays,OemToAnsi("documento os dados atuais, e o usuário irá alterar esses  dados  conforme  sua") )
		AADD(aSays,OemToAnsi("necessidade.") )
		AADD(aSays,OemToAnsi("Obs: Caso o usuário preencha com ZZZZ nos campos destinos,  esses  não  serão" ) )
		AADD(aSays,OemToAnsi("     atualizados na base." ) )
		
		AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) }})
		AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }})
		AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
		
		FormBatch( cCadastro, aSays, aButtons )
		
		If nOpca == 0
			Exit
		Else
			If mv_par13 == mv_par14   // Se Origem e Destino do projeto forem iguais
				Alert("Projeto origem e destino não podem ser iguais !")
				Loop
			Endif
			If mv_par15 == mv_par16   // Se Origem e Destino da Classe MCT forem iguais
				Alert("Classe MCT origem e destino não podem ser iguais !")
				Loop
			Endif
			If mv_par17 == mv_par18   // Se Origem e Destino do Item Contabil forem iguais
				Alert("Colaborador origem e destino não podem ser iguais !")
				Loop
			Endif
			If mv_par19 == mv_par20   // Se Origem e Destino do Pedido forem iguais
				Alert("Pedido origem e destino não podem ser iguais !")
				Loop
			Endif
			If mv_par21 == mv_par22   // Se Origem e Destino da Viagem forem iguais
				Alert("Viagem origem e destino não podem ser iguais !")
				Loop
			Endif
			If mv_par23 == mv_par24   // Se Origem e Destino do Treinamento forem iguais
				Alert("Treinamento origem e destino não podem ser iguais !")
				Loop
			Endif
			
			// Cria estrutura dos itens do documento
			aHeader1 := {}
			AAdd( aHeader1 , { "Item"       , "cItem"     , "@!"               , 5, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "Valor"      , "nValor"    , "@EZ 99,999,999.99",10, 2, ".T."           , "û", "N", "", ""} )
			AAdd( aHeader1 , { "Conta Orig.", "cCtbCO"    , "@!"               ,20, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "Conta Dest.", "D1_CONTA"  , "@!"               ,20, 0, "u_IN070Valid()", "û", "C", "", ""} )
			AAdd( aHeader1 , { "Proj.Orig." , "cProjO"    , "@!"               , 9, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "Proj.Dest." , "D1_CC"     , "@!"               , 9, 0, "u_IN070Valid()", "û", "C", "", ""} )
			AAdd( aHeader1 , { "MCT Orig."  , "cCMCTO"    , "@!"               , 9, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "MCT Dest."  , "D1_CLVL"   , "@!"               , 9, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "Colab.Orig.", "cItemO"    , "@!"               , 9, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "Colab.Dest.", "D1_ITEMCTA", "@!"               , 9, 0, "u_IN070Valid()", "û", "C", "", ""} )
			AAdd( aHeader1 , { "Pedido Orig", "cPediO"    , "@!"               , 6, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "Pedido Dest", "D1_PRCOMP" , "@!"               , 6, 0, "u_IN070Valid()", "û", "C", "", ""} )
			AAdd( aHeader1 , { "Viagem Orig", "cViagO"    , "@!"               , 6, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "Viagem Dest", "D1_VIAGEM" , "@!"               , 6, 0, "u_IN070Valid()", "û", "C", "", ""} )
			AAdd( aHeader1 , { "Trein.Orig.", "cTreiO"    , "@!"               , 6, 0, ".T."           , "û", "C", "", ""} )
			AAdd( aHeader1 , { "Trein.Dest.", "D1_TREINAM", "@!"               , 6, 0, "u_IN070Valid()", "û", "C", "", ""} )
			AAdd( aHeader1 , { "Descricao"  , "cDescr"    , "@!"               ,60, 0, "u_IN070Valid()", "û", "C", "", ""} )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processando Saidas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQry := "SELECT COUNT(*) SOMA"
			cQry += " FROM "+RetSQLName("CT2")+" CT2"
			cQry += " INNER JOIN "+RetSQLName("CT1")+" CT1 ON CT1.D_E_L_E_T_ = ' ' AND CT1.CT1_CONTA = CT2.CT2_DEBITO"
			cQry += " AND CT1.CT1_XMCT = 'S'"         `
			
			// Busca e filtra Classe MCT pelo Plano de Contas
			If !Empty(mv_par15)
				cQry += " AND CT1.CT1_GRUPO = '"+mv_par15+"'"
			Endif
			
			cQry += " WHERE CT2.D_E_L_E_T_ = ' '"
			cQry += " AND CT2.CT2_FILIAL = '"+xFilial("CT2")+"'"
			cQry += " AND CT2.CT2_DATA >= '"+Dtos(mv_par01)+"' AND CT2.CT2_DATA <= '"+Dtos(mv_par02)+"'"
			
			// Caso tenha sido informado o projeto origem
			If !Empty(mv_par13)
				cQry += " AND CT2.CT2_CCD = '"+mv_par13+"'"
			Endif
			
			// Caso tenha sido informado o item contábil origem
			If !Empty(mv_par17)
				cQry += " AND CT2.CT2_ITEMD = '"+mv_par17+"'"
			Endif
			
			// Adiciona filtros básicos a query de origem
			cQry += " AND (CT2.CT2_KEY <> ' ' OR SUBSTRING(CT2.CT2_ROTINA,1,3) = 'GPE')"
			cQry += " AND CT2.CT2_VALOR <> 0 AND CT2.CT2_CCD <> ' '"
			
			// Adicionar lançamentos padrões que não serão processados. Ex: Baixas pois não se referem a COMPETÊNCIA
			cQry += " AND CT2.CT2_LP NOT IN ('530','532','597','801','805','820',"
			
			// Adicionar lançamentos padrões que não serão processados. Ex: Estornos diversos
			cQry += "'509','512','514','515','531','564','565','581','589','591','655','656','806','807','814','815','816')"
			
			cQry += " AND CT2.CT2_TPSALD = '1' AND CT2.CT2_CANC <> 'S'"
			
			vTela[2] := MsgYesNo("Exibir tela dos documentos ?",OemToAnsi("ATENCAO"))  // Flag para exibicao dos documentos
			
			Processa({|| Documentos(cQry,@vTela) },"Filtro de Documentos - Saidas")
		EndIf
		
	Enddo
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ Documentos ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de processamento dos documentos a serem alterados      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Documentos(cQry,vTela)
	Local nRegis, cChave, lAchou, ni, nTam, cBusca, cQry, nValSEV, nValSEZ, nRegAtu, vLanc, l
	Local cAlias    := Alias()
	Local aStru     := CT2->(dbStruct())
	Local cFilCTL   := CTL->(XFILIAL("CTL"))
	//Local cMVESTADO := GetMV("MV_ESTADO")
	
	Private dDtEmiss, dDtDigit, vReg, vJus, nTotTit, nTotLan, lCtb, lPrj, lMCT, lIte, lPed, lVgm, lTrn, lDes, lFin, lMat, lGpe
	
	CTL->(dbSetOrder(1))
	SA6->(dbSetOrder(1))
	SD1->(dbSetOrder(1))
	SE2->(dbSetOrder(6))
	SED->(dbSetOrder(1))
	SF1->(dbSetOrder(1))
	
	lFin := (mv_par25 == 1)  // Define se processa titulos do financeiro
	lMat := (mv_par26 == 1)  // Define se processa titulos do Compras
	lGpe := .F. //(mv_par27 == 1)  // Define se processa titulos da Folha de Pagamento
	
	//- Conta o numero de registros filtrados pela query
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "SOM", .T., .F. )
	nRegis:= SOM->SOMA
	dbCloseArea()
	
	//- Troca a expressao COUNT(*) por * na clausula SELECT
	cQry := StrTran(cQry,"COUNT(*) SOMA","CT2.*, CT2.R_E_C_N_O_ AS CT2_RECNO, SUBSTRING(CT1_GRUPO,1,9) AS CT1_CLVL")
	cQry += " ORDER BY CT2_KEY, CT2_LP"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TBS", .T., .F. )
	
	For ni:=1 To Len(aStru)
		If aStru[ni,2] != "C"
			TCSetField("TBS", aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next
	
	ProcRegua(nRegis)
	While !Eof()
		vLanc  := {}
		cChave := CT2_KEY
		While !Eof() .And. cChave == CT2_KEY
			
			lAchou := .T.
			
			If CTL->(dbSeek(cFilCTL+TBS->CT2_LP))  // Se não achou chave de busca
				// Posiciona no item da tabela
				dbSelectArea(CTL->CTL_ALIAS)
				dbSetOrder(Val(CTL->CTL_ORDER))
				If CTL->CTL_ALIAS == "SD1"
					If Len(AllTrim(TBS->CT2_KEY)) > 20
						nTam := Len(&(CTL->CTL_ALIAS+"->("+Trim(CTL->CTL_KEY)+")"))
					Else
						nTam := 19
					Endif
				Else
					nTam := Len(&(CTL->CTL_ALIAS+"->("+Trim(CTL->CTL_KEY)+")"))
				Endif
				lAchou := dbSeek(PADR(TBS->CT2_KEY,nTam))
				dbSelectArea("TBS")
			Endif
			
			cLP := CT2_LP
			While !Eof() .And. cChave+cLP == CT2_KEY+CT2_LP
				
				IncProc()
				
				//If lAchou .And. Estornado()  // Se a origem não existe mais
				//   dbSkip()
				//   Loop
				//Endif
				
				nRegAtu := 0
				
				Do Case
					Case Left(CT2_ROTINA,3) == "GPE"
						
						cRotina := "GPEM670"
						
						dbSkip()
						Loop
						
					Case CTL->CTL_ALIAS $ "SD2,SF2"
						
						dbSkip()
						Loop
						
					Case CTL->CTL_ALIAS $ "SD1,SF1"
						
						If !lAchou .Or. !lMat  // Se não encontrou referência na origem
							dbSkip()
							Loop
						Endif
						
						If CTL->CTL_ALIAS == "SD1"
							SF1->(dbSeek(SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))  // Posiciona no Cabeçalho da nota
						Else
							SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))          // Posiciona no Item da Nota
						Endif
						
						If SD1->D1_SERIE   < mv_par03 .Or. SD1->D1_SERIE   > mv_par04 .Or.;
							SD1->D1_DOC     < mv_par05 .Or. SD1->D1_DOC     > mv_par06 .Or.;
							SD1->D1_FORNECE < mv_par07 .Or. SD1->D1_FORNECE > mv_par08 .Or.;
							SD1->D1_LOJA    < mv_par09 .Or. SD1->D1_LOJA    > mv_par10 .Or.;
							SD1->D1_ITEM    < mv_par11 .Or. SD1->D1_ITEM    > mv_par12
							dbSkip()
							Loop
						Endif
						
						nRegAtu := SD1->(Recno())
						
					Case CTL->CTL_ALIAS == "SE2"
						
						If !lAchou .Or. !lFin // Se não encontrou referência na origem
							dbSkip()
							Loop
						Endif
						
						If SE2->E2_PREFIXO < mv_par03 .Or. SE2->E2_PREFIXO > mv_par04 .Or.;
							SE2->E2_NUM     < mv_par05 .Or. SE2->E2_NUM     > mv_par06 .Or.;
							SE2->E2_FORNECE < mv_par07 .Or. SE2->E2_FORNECE > mv_par08 .Or.;
							SE2->E2_LOJA    < mv_par09 .Or. SE2->E2_LOJA    > mv_par10
							dbSkip()
							Loop
						Endif
						
						nRegAtu := SE2->(Recno())
						
					Case CTL->CTL_ALIAS == "SE5"
						
						If !lAchou .Or. !lFin  // Se não encontrou referência na origem
							dbSkip()
							Loop
						Endif
						
						//- Lancamentos incluido via movimentacao bancaria
						If !Empty(SE5->E5_MOTBX) .Or. SE5->E5_RATEIO <> "N"
							dbSkip()
							Loop
						Endif
						
						If SubStr(SE5->E5_DOCUMEN,1,6) < mv_par05 .Or. SubStr(SE5->E5_DOCUMEN,1,6) > mv_par06
							dbSkip()
							Loop
						Endif
						
						nRegAtu := SE5->(Recno())
						
				EndCase
				
				// Adiciona os lançamentos efetuados para o documento
				AAdd( vLanc , { CT2_LP, If( Left(CT2_ROTINA,3) == "GPE", "SRD", CTL->CTL_ALIAS), CT2_RECNO, nRegAtu, .F., CT2_VALOR})
				
				dbSkip()
			Enddo
		Enddo
		
		// Se não encontrou nenhum lançamento para a chave
		If Empty(vLanc)
			Loop
		Endif
		
		CT2->(dbGoTo(vLanc[1,3])) // Posiciona no CT2
		
		// Define o conteúdo das variáveis conforme origem do lançamento
		If vLanc[1,2] == "SE5"
			For l:=1 To Len(vLanc)
				If vLanc[l,2] == "SE5"
					
					CT2->(dbGoTo(vLanc[l,3])) // Posiciona no CT2
					SE5->(dbGoTo(vLanc[l,4]))  // Posiciona no SE5
					
					IniciaVar(SE5->E5_DATA)   // Inicializa variaveis de exibicao dos dados e contabilizacao
					
					nTotLan := vLanc[l,6]  // Atribui valor do  lançamento
					
					lPed := .F.  // Não exibir campo do Pedido
					lVgm := .F.  // Não exibir campo da Viagem
					lTrn := .F.  // Não exibir campo do Treinamento
					
					SED->(dbSeek(XFILIAL("SED")+SE5->E5_NATUREZ))
					If AtuaCols(SE5->E5_VALOR,SED->ED_CONTAB,SE5->E5_CCD,SE5->E5_CLVLDB,SE5->E5_ITEMD,,,,SE5->E5_HISTOR,,"SE5")
						AAdd( vReg , { "SE5" , SE5->(Recno()), " ", 0, Trim(SE5->E5_LA), TBS->CT2_RECNO})
						
						vTela := { 1, vTela[2], vTela[3]}
						
						// Monta aHeader e aCols conforme campos a serem alterados
						CargaArray()
						
						If vTela[2]  // Se Exibe tela estiver habilitado
							vTela := MontaTela(SE5->E5_PREFIXO+" - "+SE5->E5_NUMERO,vLanc[l,1])
						Endif
						
						If vTela[1] == 1  // Se confirmou
							Begin Transaction
							IN070Grava(vLanc[l,3])
							End Transaction
						Endif
						dbSelectArea("TBS")
						
						If !vTela[3]   // Verifica se nao processa proximos documentos
							Exit
						Endif
					Endif
				Endif
			Next
			
			Loop
		ElseIf vLanc[1,2] $ "SD1,SF1"
			
			IniciaVar(CT2->CT2_DATA)   // Inicializa variaveis de exibicao dos dados e contabilizacao
			
			// Totaliza os lançamentos encontrados
			nTotLan := 0
			AEval( vLanc , {|x| nTotLan += x[6] })
			
			SD1->(dbGoTo(vLanc[1,4]))  // Posiciona no registro do SD1
			
			cBusca := SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			
			SE2->(dbSetOrder(6))
			SE2->(dbSeek(SD1->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_SERIE+D1_DOC)))  // Posiciona no título a pagar
			
			SD1->(dbSetOrder(1))
			SD1->(dbSeek(cBusca,.T.))
			While !SD1->(Eof()) .And. cBusca == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
				
				AAdd( vJus , { "", 0 })   // Adiciona uma linha por item da justificativa
				If AtuaCols(SD1->D1_TOTAL,SD1->D1_CONTA,SD1->D1_CC,SD1->D1_CLVL,SD1->D1_ITEMCTA,SD1->D1_PRCOMP,SD1->D1_VIAGEM,SD1->D1_TREINAM,SD1->D1_DESCRI,SD1->D1_ITEM,"SD1")
					AAdd( vReg , { "SD1" , SD1->(Recno()), " ", 0, If( Empty(SF1->F1_DTLANC), " ", "S"), TBS->CT2_RECNO})
				Endif
				
				SD1->(dbSkip())
			Enddo
			
		ElseIf vLanc[1,2] == "SE2"
			
			IniciaVar(CT2->CT2_DATA)   // Inicializa variaveis de exibicao dos dados e contabilizacao
			
			// Totaliza os lançamentos encontrados
			nTotLan := 0
			AEval( vLanc , {|x| nTotLan += x[6] })
			
			SE2->(dbGoTo(vLanc[1,4]))  // Posiciona no registro do SE2
			
			dDtEmiss := SE2->E2_EMISSAO
			dDtDigit := SE2->E2_EMIS1
			
			AAdd( vJus , { "", 0 })   // Adiciona uma linha por documento da justificativa
			cBusca := SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
			
			If SE2->E2_MULTNAT == "1"   //- Caso seja multiplas naturezas
				lPed := .F.  // Não exibir campo do Pedido
				//lVgm := .F.  // Não exibir campo da Viagem
				//lTrn := .F.  // Não exibir campo do Treinamento
				//lDes := .F.  // Não exibir campo da Descricao
				
				//- Rateio por multiplas naturezas
				SEV->(dbSetOrder(1))
				SEV->(dbSeek(cBusca,.T.))
				While !SEV->(Eof()) .And. cBusca == SEV->EV_FILIAL+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA
					
					If SEV->EV_RECPAG <> "P"  //- Somente titulos a pagar
						SEV->(dbSkip())
						Loop
					Endif
					
					nValSEV := GetE2VALOR("SE2") * SEV->EV_PERC
					
					SED->(dbSeek(XFILIAL("SED")+SEV->EV_NATUREZ))
					
					If SEV->EV_RATEICC == "1"  // Caso seja multi-centro de custo
						//- Rateio por multiplos centros de custos
						SEZ->(dbSetOrder(1))
						SEZ->(dbSeek(cBusca+SEV->EV_NATUREZ,.T.))
						While !SEZ->(Eof()) .And. cBusca+SEV->EV_NATUREZ == SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ)
							
							If SEZ->EZ_RECPAG <> "P" //- Somente titulos a pagar
								SEZ->(dbSkip())
								Loop
							Endif
							
							cCCusto  := If(Empty(SEZ->EZ_CCUSTO) , SE2->E2_CC     , SEZ->EZ_CCUSTO)
							cClvl    := If(Empty(SEZ->EZ_CLVL)   , SE2->E2_CLVL   , SEZ->EZ_CLVL)
							cItemCta := If(Empty(SEZ->EZ_ITEMCTA), SE2->E2_ITEMCTA, SEZ->EZ_ITEMCTA)
							
							nValSEZ := nValSEV * SEZ->EZ_PERC
							
							If AtuaCols(nValSEZ,SED->ED_CONTAB,cCCusto,cClvl,cItemCta,,SE2->E2_VIAGEM,SE2->E2_TREINAM,SE2->E2_HIST,,"SE2")
								AAdd( vReg , { "SEZ" , SEZ->(Recno()), " ", 0, SEZ->EZ_LA, TBS->CT2_RECNO})
							Endif
							
							SEZ->(dbSkip())
						Enddo
					Else
						If AtuaCols(nValSEV,SED->ED_CONTAB,SE2->E2_CC,SE2->E2_CLVL,SE2->E2_ITEMCTA,SE2->E2_PEDIDO,SE2->E2_VIAGEM,SE2->E2_TREINAM,SE2->E2_HIST,,"SE2")
							AAdd( vReg , { "SE2" , SE2->(Recno()), " ", 0, SE2->E2_LA, TBS->CT2_RECNO})
						Endif
					Endif
					
					SEV->(dbSkip())
				Enddo
			Else
				SED->(dbSeek(XFILIAL("SED")+SE2->E2_NATUREZ))
				If AtuaCols(SE2->E2_VALOR,SED->ED_CONTAB,SE2->E2_CC,SE2->E2_CLVL,SE2->E2_ITEMCTA,SE2->E2_PEDIDO,SE2->E2_VIAGEM,SE2->E2_TREINAM,SE2->E2_HIST,,"SE2")
					AAdd( vReg , { "SE2" , SE2->(Recno()), " ", 0, SE2->E2_LA, TBS->CT2_RECNO})
				Endif
			Endif
		Endif
		
		// Grava somente se achar o documento de origem ou for um lançamento manual
		If (!Empty(vLanc) .Or. Empty(cChave) .Or. Empty(cLP)) .And. !Empty(aCols1)
			
			// Vetor de retorno da tela. 1=Ok grava, .T.=Exibe prox. doc, .T.=Processa prox. doc
			vTela := { 1, vTela[2], vTela[3]}
			
			// Monta aHeader e aCols conforme campos a serem alterados
			CargaArray()
			
			If vTela[2]  // Se Exibe tela estiver habilitado
				vTela := MontaTela(SE2->E2_PREFIXO+" - "+SE2->E2_NUM,vLanc[1,1])
			Endif
			
			If vTela[1] == 1  // Se confirmou
				Begin Transaction
				IN070Grava(vLanc)
				End Transaction
			Endif
		Endif
		dbSelectArea("TBS")
		
		vTela[2] := .T.  // Força exibir a tela para os titulos compensados
		vTela[3] := .T.  // Força processar proximos documentos para os titulos compensados
		
		If !vTela[3]   // Verifica se nao processa proximos documentos
			Exit
		Endif
		
	Enddo
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ IniciaVar  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 11/10/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicializa variaveis para montagem da tela de exibicao        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IniciaVar(dDATA)
	dDtEmiss := dDATA     // Data de Emissao   do documento
	dDtDigit := dDATA     // Data de Digitacao do documento
	nTotTit  := 0         // Valor do Título
	
	vReg   := {}
	vJus   := {}
	aCols1 := {}
	lCtb   := .T.  // Exibir campo da Conta Contábil
	lPrj   := .T.  // Exibir campo do Projeto
	lMCT   := .T.  // Exibir campo do MCT
	lIte   := .T.  // Exibir campo do Item Contabil
	lPed   := .T.  // Exibir campo do Pedido
	lVgm   := .T.  // Exibir campo da Viagem
	lTrn   := .T.  // Exibir campo do Treinamento
	lDes   := .T.  // Exibir campo da Descricao
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaTela  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de monta a tela para digitacao do usuario              ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaTela(cDoc,cLP)
	Local x, y, z, nPos, cFornec, cTp, cParc, oPanelT, oTel1, oTel2
	Local lNoShow     := .F.
	Local lNoProc     := .F.
	Local nOpcX       := 4
	Local nOpcA       := 0
	Local cOrigem     := ""
	Local aButtons    := {{"POSCLI",{|| IN070Justif(Upper(SubStr(cOrigem,1,3))) },"Justificativa", "Justificat"}}
	Private cNomFor   := Posicione("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NOME")
	Private cCadastro := "Documento "+cDoc
	Private aRotina   := {{"","",0,1},{"","",0,2},{"","",0,3},{"","",0,4}}
	
	Do Case
		Case Left(TBS->CT2_ROTINA,3) == "GPE"
			cOrigem := "Gestão Pessoal"
			cFornec := ""
			cTp     := ""
			cParc   := ""
		Case cLP $ "562,563,564,565"
			cOrigem := "Movimento Bancário"
			cFornec := SE5->E5_CLIFOR+"-"+SE5->E5_LOJA
			cTp     := SE5->E5_TIPO
			cParc   := SE5->E5_PARCELA
		Case cLP $ "650,660"
			cOrigem := "Compras"
			cFornec := SE2->E2_FORNECE+"-"+SE2->E2_LOJA
			cTp     := SE2->E2_TIPO
			cParc   := SE2->E2_PARCELA
		Case cLP $ "508,510,513"
			cOrigem := "Financeiro"
			cFornec := SE2->E2_FORNECE+"-"+SE2->E2_LOJA
			cTp     := SE2->E2_TIPO
			cParc   := SE2->E2_PARCELA
	EndCase
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 31,90 OF oMainWnd
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,203 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM
	
	@ 15, 2 TO 52,355 LABEL "" OF oPanelT PIXEL
	
	@ 24, 006 SAY "Documento"    SIZE  40,7 PIXEL OF oPanelT
	@ 24, 090 SAY "Fornecedor"   SIZE  70,7 PIXEL OF oPanelT
	@ 24, 180 SAY "Tipo"         SIZE  40,7 PIXEL OF oPanelT
	@ 24, 260 SAY "Parcela"      SIZE  40,7 PIXEL OF oPanelT
	@ 39, 006 SAY "Origem"       SIZE  40,7 PIXEL OF oPanelT
	@ 39, 110 SAY "Emissão"      SIZE  40,7 PIXEL OF oPanelT
	@ 39, 195 SAY "Digitação"    SIZE  40,7 PIXEL OF oPanelT
	
	@ 23, 040 MSGET cDoc         PICTURE "@!" SIZE 040,7 PIXEL OF oPanelT WHEN .F.
	@ 23, 125 MSGET cFornec      PICTURE "@!" SIZE 040,7 PIXEL OF oPanelT WHEN .F.
	@ 23, 200 MSGET cTp          PICTURE "@!" SIZE 020,5 PIXEL OF oPanelT WHEN .F.
	@ 23, 280 MSGET cParc        PICTURE "@!" SIZE 015,7 PIXEL OF oPanelT WHEN .F.
	@ 38, 040 MSGET cOrigem      PICTURE "@!" SIZE 060,7 PIXEL OF oPanelT WHEN .F.
	@ 38, 140 MSGET dDtEmiss     PICTURE "@!" SIZE 045,7 PIXEL OF oPanelT WHEN .F.
	@ 38, 225 MSGET dDtDigit     PICTURE "@!" SIZE 045,7 PIXEL OF oPanelT WHEN .F.
	
	@ 150, 006 SAY oSay1 VAR cNomFor PICTURE "@!" SIZE 150,7 PIXEL OF oPanelT Color (CLR_BLUE)
	@ 150, 176 SAY AllTrim(Str(Len(aCols),6))+" linha(s)" SIZE 40,7 PIXEL OF oPanelT Color (CLR_BLUE)
	@ 150, 236 SAY "Total Documento " SIZE 60,7 PIXEL OF oPanelT Color (CLR_BLUE)
	@ 150, 300 SAY oSay2 VAR nTotTit PICTURE "@E 9,999,999.99" SIZE 50,7 PIXEL OF oPanelT Color (CLR_BLUE)
	@ 165, 236 SAY "Total Lançamento" SIZE 60,7 PIXEL OF oPanelT Color (CLR_BLUE)
	@ 165, 300 SAY oSay3 VAR nTotLan PICTURE "@E 9,999,999.99" SIZE 50,7 PIXEL OF oPanelT Color (CLR_BLUE)
	
	oDlg:Cargo := {|n1,n2,n3| oSay1:SetText(n1),oSay2:SetText(n2),oSay3:SetText(n3) }
	
	oGet := MSGetDados():New(51,2,140,355,nOpcX,,,,.T.,,,,Len(aCols),,,,"AllwaysFalse",oPanelT)
	
	oGet:oBrowse:bChange := {|| IN070CpoAlt(oGet:oBrowse,cLP) }
	
	IN070CpoAlt(oGet:oBrowse,cLP)
	
	Private oObj:=oGet
	AtuRodape(oObj,cNomFor,nTotTit,nTotLan)
	
	@ 165,006 CHECKBOX oTel1 VAR lNoShow PROMPT "Não exibir próximos documentos"    OF oPanelT SIZE 100,08 PIXEL
	@ 165,106 CHECKBOX oTel2 VAR lNoProc PROMPT "Não processar próximos documentos" OF oPanelT SIZE 100,08 PIXEL
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif( .T. ,oDlg:End(),nOpcA:=0)},{||oDlg:End()},,aButtons) CENTERED
	
	dbSelectArea("TBS")
	
Return {nOpcA,!lNoShow,!lNoProc}

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CargaArray ¦ Autor ¦ Reinaldo Magalhaes   ¦ Data ¦ 02/12/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para carregar o aHeader e o Acols                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CargaArray()
	Local x, y, z, nPos
	
	// Monta aHeader conforme campos a serem alterados
	aHeader := {}
	For x:=1 To Len(aHeader1)
		If Trim(aHeader1[x,2]) $ "cItem,nValor" .Or.;
			((lCtb .And. Trim(aHeader1[x,2]) $ "cCtbCO,D1_CONTA"  ) .Or.;
			(lPrj .And. Trim(aHeader1[x,2]) $ "cProjO,D1_CC"     ) .Or.;
			(lMCT .And. Trim(aHeader1[x,2]) $ "cCMCTO,D1_CLVL"   ) .Or.;
			(lIte .And. Trim(aHeader1[x,2]) $ "cItemO,D1_ITEMCTA") .Or.;
			(lPed .And. Trim(aHeader1[x,2]) $ "cPediO,D1_PRCOMP" ) .Or.;
			(lVgm .And. Trim(aHeader1[x,2]) $ "cViagO,D1_VIAGEM" ) .Or.;
			(lTrn .And. Trim(aHeader1[x,2]) $ "cTreiO,D1_TREINAM") .Or.;
			(lDes .And. Trim(aHeader1[x,2]) $ "cDescr"))
			AAdd( aHeader , Array(Len(aHeader1[x])) )
			For y:=1 To Len(aHeader1[x])
				aHeader[Len(aHeader),y] := aHeader1[x,y]
			Next
		Endif
	Next
	
	// Monta aCols conforme configuracao do aHeader
	aCols := {}
	For x:=1 To Len(aCols1)
		AAdd( aCols , Array(Len(aHeader)+1) )
		For y:=1 To Len(aHeader)
			// Pesquisa no aHeader1 (original), a posicao do campo do aHeader (exibicao)
			nPos := Ascan( aHeader1 , {|z| Trim(z[2]) == Trim(aHeader[y,2]) })
			// Atribui o conteudo pego do aCols1 para o aCols a ser exibido
			aCols[x,y] := aCols1[x,nPos]
		Next
		aCols[x,Len(aHeader)+1] := .F.
	Next
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ IN070Valid ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de validacao dos campos do usuario                     ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function IN070Valid()
	Local nPos, nPCTB, nPCLV, nPCLO, x, cAux
	Local cVar := Upper(ReadVar())
	Local lRet := .T.
	
	Do Case
		Case cVar == "M->D1_CONTA"
			If !(M->D1_CONTA = "ZZZ")
				If lRet := (NaoVazio() .And. ExistCpo("CT1"))
					nPos := aScan(aHeader,{|x| Upper(Trim(x[2])) == "CCTBCO" })
					If lRet := (M->D1_CONTA <> aCols[n,nPos])
						nPCTB := aScan(aHeader,{|x| Upper(Trim(x[2])) == "D1_CONTA" })
						nPCLV := aScan(aHeader,{|x| Upper(Trim(x[2])) == "D1_CLVL"  })
						nPCLO := aScan(aHeader,{|x| Upper(Trim(x[2])) == "CCMCTO"   })
						cAux  := aCols[n,nPos]   // Guarda o conteúdo anterior para comparação
						
						CT1->(dbSetOrder(1))
						CT1->(dbSeek(XFILIAL("CT1")+M->D1_CONTA))
						
						// Altera todas as linhas que tiverem a mesma a conta. Também atualiza a Classe de Valor
						For x:=1 To Len(aCols)
							If aCols[x,nPos] == cAux
								aCols[x,nPCTB] := M->D1_CONTA
								aCols[x,nPCLV] := PADR(CT1->CT1_GRUPO,Len(aCols[x,nPCLV]))
							Endif
						Next
					Else
						Aviso("INVÁLIDO","O Codigo não pode ser o mesmo da Conta origem !",{"OK"},1)
					Endif
				Endif
			Endif
		Case cVar == "M->D1_CC"
			If !(M->D1_CC = "ZZZ")
				If lRet := (NaoVazio() .And. ExistCpo("CTT"))
					nPos := aScan(aHeader,{|x| Upper(Trim(x[2])) == "CPROJO" })
					If M->D1_CC == aCols[n,nPos]
						Aviso("INVÁLIDO","O Codigo não pode ser o mesmo do projeto origem !",{"OK"},1)
						lRet := .F.
					Endif
				Endif
			Endif
		Case cVar == "M->D1_ITEMCTA"
			If !(M->D1_ITEMCTA = "ZZZ")
				If lRet := (NaoVazio() .And. ExistCpo("CTD"))
					nPos := aScan(aHeader,{|x| Upper(Trim(x[2])) == "CITEMO" })
					If M->D1_ITEMCTA == aCols[n,nPos]
						Aviso("INVÁLIDO","O Codigo não pode ser o mesmo do Colaborador origem !",{"OK"},1)
						lRet := .F.
					Endif
				Endif
			Endif
		Case cVar == "M->D1_PRCOMP"
			If !(M->D1_PRCOMP = "ZZZ")
				If lRet := (Vazio() .Or. ExistCpo("SC7"))
					nPos := aScan(aHeader,{|x| Upper(Trim(x[2])) == "CPEDIO" })
					If M->D1_PRCOMP == aCols[n,nPos]
						Aviso("INVÁLIDO","O Pedido não pode ser o mesmo do Pedido origem !",{"OK"},1)
						lRet := .F.
					Endif
				Endif
			Endif
		Case cVar == "M->D1_VIAGEM"
			If !(M->D1_VIAGEM = "ZZZ")
				If lRet := (Vazio() .Or. ExistCpo("SZ7"))
					nPos := aScan(aHeader,{|x| Upper(Trim(x[2])) == "CVIAGO" })
					If M->D1_VIAGEM == aCols[n,nPos]
						Aviso("INVÁLIDO","A Viagem não pode ser a mesma da Viagem origem !",{"OK"},1)
						lRet := .F.
					Endif
				Endif
			Endif
		Case cVar == "M->D1_TREINAM"
			If !(M->D1_TREINAM = "ZZZ")
				If lRet := (Vazio() .Or. ExistCpo("SZ8"))
					nPos := aScan(aHeader,{|x| Upper(Trim(x[2])) == "CTREIO" })
					If M->D1_TREINAM == aCols[n,nPos]
						Aviso("INVÁLIDO","O Treinamento não pode ser o mesmo do Treinamento origem !",{"OK"},1)
						lRet := .F.
					Endif
				Endif
			Endif
		Case cVar == "CDESCR"
			lRet := NaoVazio()
	EndCase
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ IN070CpoAlt¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Habilita a leitura dos campos conforme condicao               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IN070CpoAlt(oGet,cLP)
	Local nPos
	Local vVar  := {}
	
	oGet:aAlter := {}
	oGet:oMother:aAlter := {}
	
	If cLP $ "562,563,564,565"  // Origem do movmento bancario
		vVar := { "D1_CONTA", "D1_CC" , "D1_ITEMCTA", "cDescr"}
	Else
		Do Case
			Case vReg[oGet:nAt,1] == "SD1"
				vVar := { "D1_CONTA", "D1_CC" , "D1_ITEMCTA", "D1_PRCOMP", "D1_VIAGEM", "D1_TREINAM", "cDescr"}
			Case vReg[oGet:nAt,1] == "SE2"
				// Se origem for da folha, nao habilita a digitacao do item contabil (colaborador)
				If SE2->E2_ORIGEM = "GPEM670"  // Se origem for da folha
					vVar := { "D1_CONTA", "D1_CC" , "cDescr"}
				Else
					// Se descricao nao existir ou tiver apenas um caractere em branco, entao nao existe historico
					nPos := aScan(aHeader,{|x| Upper(Trim(x[2])) == "CDESCR" })
					If nPos == 0 .Or. aCols[oGet:nAt,nPos] == " "
						vVar := { "D1_CONTA", "D1_CC" , "D1_ITEMCTA", "D1_PRCOMP", "D1_VIAGEM", "D1_TREINAM"}
					Else
						vVar := { "D1_CONTA", "D1_CC" , "D1_ITEMCTA", "D1_PRCOMP", "D1_VIAGEM", "D1_TREINAM", "cDescr"}
					Endif
				Endif
			Case vReg[oGet:nAt,1] == "SEZ"   ;  vVar := { "D1_CONTA", "D1_CC" , "D1_ITEMCTA", "D1_VIAGEM", "D1_TREINAM", "cDescr"}
			Case vReg[oGet:nAt,1] == "SZ1"   ;  vVar := { "D1_CONTA", "D1_CC"}
		EndCase
	Endif
	oGet:aAlter := vVar
	oGet:oMother:aAlter := vVar
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ IN070Justif¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Tela de exibicao da justifitiva do documento                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IN070Justif(cOrig)
	Local oDlg, oJustific, cJustific, lAchou, oPanelT
	Local cBusca   := "ZZZZZ"
	Local nOpcA    := 0
	Local nPos     := 1   // Posicao da linha da justificativa
	Local oFontCou := TFont():New("Courier New",9,15,.T.,.F.,5,.T.,5,.F.,.F.)
	Local cPrefix  := SE2->E2_PREFIXO
	Local cDocume  := SE2->E2_NUM
	Local cFornec  := SE2->E2_FORNECE
	Local cLjForn  := SE2->E2_LOJA
	Local cNomFor  := SE2->E2_NOMFOR
	Local cCodIte  := Space(Len(SD1->D1_ITEM))
	
	// Se origem for do movimento bancario ou for um titulo e imposto, nao exibe nada
	If cOrig == "MOV" .Or. SE2->E2_TIPO $ "TX ,INS,ISS"
		Return
	ElseIf cOrig == "COM"  // Se origem do compras, pega o codigo do item
		cCodIte := aCols[n,1]   // Codigo do Item
		nPos    := n            // Pega a posicao do item da justificativa
	Endif
	
	cJustific := CriaVar("Z6_JUSTIFI",.T.)
	
	If !Empty(SE2->E2_VIAGEM)
		Justific("3"+SE2->E2_VIAGEM,nPos,@cJustific)
	ElseIf !Empty(SE2->E2_TREINAM)
		Justific("5"+SE2->E2_TREINAM,nPos,@cJustific)
	Endif
	
	If Empty(cJustific) .And. !Empty(aCols[nPos,11]) .And. MsgYesNo("Alterar a justificativa do pedido ?")
		Justific("1"+PADR(aCols[nPos,11],Len(cDocume)),nPos,@cJustific)
	Endif
	
	If Empty(vJus[nPos,1])                  // Se estiver vazia a justificativa
		If !Justific("4"+cDocume+cPrefix+cFornec+cLjForn+cCodIte,nPos,@cJustific)
			Justific("4"+cDocume+cPrefix+cFornec+cLjForn+Space(Len(cCodIte)),nPos,@cJustific)
		Endif
	Else
		cJustific := vJus[nPos,1]
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro+" - Descrição Detalhada" From 0,0 TO 40,81 OF oMainWnd
	oDlg:lEscClose := .F.
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 10,266 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM
	
	@ 15,006 SAY "Prefixo"      PIXEL OF oPanelT
	@ 15,036 GET cPrefix        PIXEL OF oPanelT WHEN .F.
	@ 15,106 SAY "Numero"       PIXEL OF oPanelT
	@ 15,136 GET cDocume        PIXEL OF oPanelT WHEN .F.
	@ 30,006 SAY "Fornecedor"   PIXEL OF oPanelT
	@ 30,036 GET cFornec        PIXEL OF oPanelT WHEN .F.
	@ 30,076 GET cLjForn        PIXEL OF oPanelT WHEN .F.
	@ 30,106 SAY "Nome"         PIXEL OF oPanelT
	@ 30,136 GET cNomFor        PIXEL OF oPanelT WHEN .F.
	
	@ 060,002 To 204,318 PROMPT "Descrição Detalhada" PIXEL OF oPanelT
	@ 070,006 SAY "Justificativa" PIXEL OF oPanelT
	@ 080,006 GET oJustific       VAR cJustific SIZE 308,90 PIXEL OF oPanelT MEMO
	oJustific:oFont := oFontCou
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| nOpcA := 1, oDlg:End()},{|| nOpcA := 0, oDlg:End()})
	
	If nOpcA == 1   // Se foi confirmado a alteracao
		vJus[nPos,1] := cJustific
	Endif
	
Return

Static Function Justific(cBusca,nPos,cJustific)
	Local lRet := .F.
	
	SZ6->(dbSetOrder(1))                           // Pega os dados do SZ6
	If lRet := SZ6->(dbSeek(xFilial("SZ6")+cBusca))
		cJustific := SZ6->Z6_JUSTIFI
		
		vJus[nPos,1] := cJustific
		vJus[nPos,2] := SZ6->(Recno())    // Pega a posicao do SZ6
	Endif
	
Return lRet .And. !Empty(cJustific)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ IN070Grava ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 05/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de gravacao dos dados alterados                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function IN070Grava(vCT2)
	Local x, y, z, lCtbC, lProj, lCMCT, lItem, lPedi, lViag, lTrei, lDesc, nPCtO, nPCtD, nPPrO, nPPrD, nPMCO, nPMCD, nPItO, nPItD, nPPdO
	Local nPPdD, nPVgO, nPVgD, nPTnO, nPTnD, nPDes, nPos, lAglut
	Local nRegSE2  := SE2->(Recno())
	Local lHead    := .T.
	Local nHdlPrv  := 1
	Local nTotal   := 0
	Local cLote    := ""
	Local lDigita  := (mv_par28 == 1)  // Mostra tela de contabilizacao: 1=Sim, 2=Nao
	Local cArquivo := ""
	Local nRegSE5  := SE5->( Recno() )
	Local dDtLanc  := SE5->E5_DATA
	Private aCt5   := {}
	
	nPCtO := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "CCTBCO"     })
	nPCtD := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "D1_CONTA"   })
	nPPrO := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "CPROJO"     })
	nPPrD := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "D1_CC"      })
	nPMCO := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "CCMCTO"     })
	nPMCD := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "D1_CLVL"    })
	nPItO := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "CITEMO"     })
	nPItD := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "D1_ITEMCTA" })
	nPPdO := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "CPEDIO"     })
	nPPdD := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "D1_PRCOMP"  })
	nPVgO := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "CVIAGO"     })
	nPVgD := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "D1_VIAGEM"  })
	nPTnO := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "CTREIO"     })
	nPTnD := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "D1_TREINAM" })
	nPDes := aScan(aHeader1,{|x| Upper(Trim(x[2])) == "CDESCR"     })
	
	// Grava no aCols1 os dados informados no aCols
	For x:=1 To Len(aCols1)
		For y:=1 To Len(aHeader)
			// Pesquisa no aHeader1 (original), a posicao do campo do aHeader (exibicao)
			nPos := Ascan( aHeader1 , {|z| Trim(z[2]) == Trim(aHeader[y,2]) })
			// Atribui o conteudo digitado no aCols para o aCols1 a ser gravado
			aCols1[x,nPos] := aCols[x,y]
		Next
	Next
	
	For x:=1 To Len(aCols1)
		// Cria Condicao para gravacao de cada campo digitado pelo usuario
		lCtbC := lCtb .And. !(aCols1[x,nPCtD] = "ZZZ") .And. aCols1[x,nPCtD] <> aCols1[x,nPCtO]
		lProj := lPrj .And. !(aCols1[x,nPPrD] = "ZZZ") .And. aCols1[x,nPPrD] <> aCols1[x,nPPrO]
		lCMCT := lMCT .And. !(aCols1[x,nPMCD] = "ZZZ") .And. aCols1[x,nPMCD] <> aCols1[x,nPMCO]
		lItem := lIte .And. !(aCols1[x,nPItD] = "ZZZ") .And. aCols1[x,nPItD] <> aCols1[x,nPItO]
		lPedi := lPed .And. !(aCols1[x,nPPdD] = "ZZZ") .And. aCols1[x,nPPdD] <> aCols1[x,nPPdO]
		lViag := lVgm .And. !(aCols1[x,nPVgD] = "ZZZ") .And. aCols1[x,nPVgD] <> aCols1[x,nPVgO]
		lTrei := lTrn .And. !(aCols1[x,nPTnD] = "ZZZ") .And. aCols1[x,nPTnD] <> aCols1[x,nPTnO]
		lDesc := lDes .And. !Empty(aCols1[x,nPDes])
		
		// Se nenhum campo precisar ser atualizado
		If !(lCtbC .Or. lProj .Or. lCMCT .Or. lItem .Or. lPedi .Or. lViag .Or. lTrei .Or. lDesc)
			Loop
		Endif
		
		CT2->(dbGoTo(vReg[x,6]))     // Posiciona no lançamento contábil
		
		dbSelectArea(vReg[x,1])      // Seleciona a area a alterar
		dbGoTo(vReg[x,2])            // Posiciona no registro a alterar
		Do Case
			Case vReg[x,1] == "SE5"   // Se origem do movimento bancario
				lCtbC := lCtbC .And. E5_CONTA  <> aCols1[x,nPCtD]  // Se dado gravado for diferente do digitado
				lProj := lProj .And. E5_CCD    <> aCols1[x,nPPrD]  // Se dado gravado for diferente do digitado
				lCMCT := lCMCT .And. E5_CLVLDB <> aCols1[x,nPMCD]  // Se dado gravado for diferente do digitado
				lItem := lItem .And. E5_ITEMD  <> aCols1[x,nPItD]  // Se dado gravado for diferente do digitado
				lDesc := lDesc .And. E5_HISTOR <> aCols1[x,nPDes]  // Se dado gravado for diferente do digitado
				If lCtbC .Or. lProj .Or. lCMCT .Or. lItem .Or. lDesc
					If vReg[x,5] == "S" .And. (lCtbC .Or. lProj .Or. /*lCMCT .Or.*/ lItem)  // Contabiliza alteracoes
						SED->(dbSetOrder(1))
						SED->(dbSeek(XFILIAL("SED")+SE5->E5_NATUREZ))    // Posiciona no cadastro da natureza
						SA6->(dbSetOrder(1))
						SA6->(dbSeek(XFILIAL("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)) // Posiciona no cadastro de Banco
						
						// Prepara o lancamento padrao de origem do estorno
						If lHead
							cLote   := "009950"
							nHdlPrv := HeadProva(cLote,"INFINP02",SubStr(cUsuario,7,15),@cArquivo)
							lHead   := .F.
						Endif
						If SE5->E5_RECPAG == "P"  // Se for pagamento
							nTotal += DetProva(nHdlPrv,"564","INFINP02",cLote) // Lancamento padrao de estorno  -  A PAGAR
						Else
							nTotal += DetProva(nHdlPrv,"565","INFINP02",cLote) // Lancamento padrao de estorno  -  A RECEBER
						Endif
					Endif
					RecLock("SE5",.F.)
					If lCtbC
						SE5->E5_NATUREZ := aCols1[x,nPCtD]
						SE5->E5_CONTA   := aCols1[x,nPCtD]
					Endif
					If lProj
						SE5->E5_CCD    := aCols1[x,nPPrD]
					Endif
					If lCMCT .Or. lCtbC
						SE5->E5_CLVLDB := aCols1[x,nPMCD]
					Endif
					If lITem
						SE5->E5_ITEMD  := aCols1[x,nPItD]
					Endif
					If lDesc
						SE5->E5_HISTOR := aCols1[x,nPDes]
					Endif
					MsUnLock()
					If vReg[x,5] == "S" .And. (lCtbC .Or. lProj .Or. /*lCMCT .Or.*/ lItem)  // Contabiliza alteracoes
						If SE5->E5_RECPAG == "P"  // Se for pagamento
							nTotal += DetProva(nHdlPrv,"562","INFINP02",cLote) // Lancamento padrao de inclusao -  A PAGAR
						Else
							nTotal += DetProva(nHdlPrv,"563","INFINP02",cLote) // Lancamento padrao de inclusao -  A RECEBER
						Endif
					Endif
				Endif
			Case vReg[x,1] == "SD1"   // Se origem do Compras
				lCtbC := lCtbC .And. D1_CONTA   <> aCols1[x,nPCtD]  // Se dado gravado for diferente do digitado
				lProj := lProj .And. D1_CC      <> aCols1[x,nPPrD]  // Se dado gravado for diferente do digitado
				lCMCT := lCMCT .And. D1_CLVL    <> aCols1[x,nPMCD]  // Se dado gravado for diferente do digitado
				lItem := lItem .And. D1_ITEMCTA <> aCols1[x,nPItD]  // Se dado gravado for diferente do digitado
				lPedi := lPedi .And. D1_PRCOMP  <> aCols1[x,nPPdD]  // Se dado gravado for diferente do digitado
				lViag := lViag .And. D1_VIAGEM  <> aCols1[x,nPVgD]  // Se dado gravado for diferente do digitado
				lTrei := lTrei .And. D1_TREINAM <> aCols1[x,nPTnD]  // Se dado gravado for diferente do digitado
				lDesc := lDesc .And. D1_DESCRI  <> aCols1[x,nPDes]  // Se dado gravado for diferente do digitado
				If lCtbC .Or. lProj .Or. lCMCT .Or. lItem .Or. lPedi .Or. lViag .Or. lTrei .Or. lDesc
					If vReg[x,5] == "S" .And. (lCtbC .Or. lProj .Or. /*lCMCT .Or.*/ lItem)  // Contabiliza alteracoes
						SB1->(dbSetOrder(1))
						SB1->(dbSeek(XFILIAL("SB1")+SD1->D1_COD))      // Posiciona no cadastro de produtos
						SF4->(dbSetOrder(1))
						SF4->(dbSeek(XFILIAL("SF4")+SD1->D1_TES))      // Posiciona no cadastro de TES
						dDtLanc := SF1->F1_DTLANC                      // Pega a mesma data de lancamento
						
						// Prepara o lancamento padrao de origem do estorno
						If lHead
							cLote   := "009910"
							nHdlPrv := HeadProva(cLote,"INFINP02",SubStr(cUsuario,7,15),@cArquivo)
							lHead   := .F.
						Endif
						nTotal += DetProva(nHdlPrv,"655","INFINP02",cLote,,,,,, aCt5) // Lancamento padrao de estorno
						
						MarcaCancelado(@vCT2,SD1->D1_CONTA,SD1->D1_CC,SD1->D1_ITEMCTA)
					Endif
					
					// Grava as alteracoes no compras
					RecLock("SD1",.F.)
					If lCtbC
						SD1->D1_CONTA   := aCols1[x,nPCtD]
						SD1->D1_DESCCTB := Posicione("CT1",1,CT1->(XFILIAL("CT1"))+aCols1[x,nPCtD],"CT1_DESC01")
					Endif
					If lProj
						SD1->D1_CC      := aCols1[x,nPPrD]
						SD1->D1_DESCCC  := Posicione("CTT",1,CTT->(XFILIAL("CTT"))+aCols1[x,nPPrD],"CTT_DESC01")
					Endif
					If lCMCT .Or. lCtbC
						SD1->D1_CLVL    := aCols1[x,nPMCD]
						SD1->D1_DESCCLV := Posicione("CTH",1,CTH->(XFILIAL("CTH"))+aCols1[x,nPMCD],"CTH_DESC01")
					Endif
					If lITem
						SD1->D1_ITEMCTA := aCols1[x,nPItD]
					Endif
					If lPedi
						SD1->D1_PRCOMP  := aCols1[x,nPPdD]
					Endif
					If lViag
						SD1->D1_VIAGEM  := aCols1[x,nPVgD]
					Endif
					If lTrei
						SD1->D1_TREINAM := aCols1[x,nPTnD]
					Endif
					If lDesc
						SD1->D1_DESCRI  := aCols1[x,nPDes]
					Endif
					MsUnLock()
					
					// Grava as alteracoes no financeiro
					RecLock("SE2",.F.)
					If lProj
						SE2->E2_CC      := aCols1[x,nPPrD]
					Endif
					If lCMCT
						SE2->E2_CLVL    := aCols1[x,nPMCD]
					Endif
					If lITem
						SE2->E2_ITEMCTA := aCols1[x,nPItD]
					Endif
					If lPedi
						SE2->E2_PEDIDO  := aCols1[x,nPPdD]
					Endif
					If lViag
						SE2->E2_VIAGEM  := aCols1[x,nPVgD]
					Endif
					If lTrei
						SE2->E2_TREINAM := aCols1[x,nPTnD]
					Endif
					MsUnLock()
					
					If vReg[x,5] == "S" .And. (lCtbC .Or. lProj .Or. /*lCMCT .Or.*/ lItem)  // Contabiliza alteracoes
						nTotal += DetProva(nHdlPrv,"650","INFINP02",cLote,,,,,, aCt5) // Lancamento padrao de inclusao
					Endif
				Endif
			Case vReg[x,1] == "SEZ"   // Se origem do Rateio do Financeiro
				dbSelectArea("SE2")
				dbSetOrder(1)
				dbSeek(XFILIAL("SE2")+SEZ->(EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA))  // Posiciona no Contas a Pagar
				
				lViag := lViag .And. E2_VIAGEM  <> aCols1[x,nPVgD]  // Se dado gravado for diferente do digitado
				lTrei := lTrei .And. E2_TREINAM <> aCols1[x,nPTnD]  // Se dado gravado for diferente do digitado
				lDesc := lDesc .And. E2_HIST    <> aCols1[x,nPDes]  // Se dado gravado for diferente do digitado
				If lViag .Or. lTrei .Or. lDesc
					RecLock("SE2",.F.)
					If lViag
						SE2->E2_VIAGEM  := aCols1[x,nPVgD]
					Endif
					If lTrei
						SE2->E2_TREINAM := aCols1[x,nPTnD]
					Endif
					If lDesc
						SE2->E2_HIST    := aCols1[x,nPDes]
					Endif
					MsUnLock()
				Endif
				dbSelectArea("SEZ")
				
				lCtbC := lCtbC .And. EZ_NATUREZ <> aCols1[x,nPCtD]  // Se dado gravado for diferente do digitado
				lProj := lProj .And. EZ_CCUSTO  <> aCols1[x,nPPrD]  // Se dado gravado for diferente do digitado
				lCMCT := lCMCT .And. EZ_CLVL    <> aCols1[x,nPMCD]  // Se dado gravado for diferente do digitado
				lItem := lItem .And. EZ_ITEMCTA <> aCols1[x,nPItD]  // Se dado gravado for diferente do digitado
				If lCtbC .Or. lProj .Or. lCMCT .Or. lItem
					If vReg[x,5] == "S" .And. (lCtbC .Or. lProj .Or. /*lCMCT .Or.*/ lItem)  // Contabiliza alteracoes
						SED->(dbSetOrder(1))
						SED->(dbSeek(XFILIAL("SED")+SEZ->EZ_NATUREZ))    // Posiciona no cadastro da natureza
						SA2->(dbSetOrder(1))
						SA2->(dbSeek(XFILIAL("SA2")+SEZ->(EZ_CLIFOR+EZ_LOJA))) // Posiciona no Cadastro de Fornecedores
						
						// Inicializa variaveis utilizadas pelo sistema nos lancamentos padroes
						VALOR  := 0   // Valor do Fornecedor
						VALOR2 := 0   // Valor do IRRF
						VALOR3 := 0   // Valor do INSS
						VALOR4 := 0   // Valor do ISS
						VALOR5 := 0   // Valor do PIS
						VALOR6 := 0   // Valor do COFINS
						VALOR7 := 0   // Valor do CSLL
						
						// Prepara o lancamento padrao de origem do estorno
						If lHead
							cLote   := "009950"
							nHdlPrv := HeadProva(cLote,"INFINP02",SubStr(cUsuario,7,15),@cArquivo)
							lHead   := .F.
						Endif
						
						nTotal += DetProva(nHdlPrv,"509","INFINP02",cLote) // Lancamento padrao de estorno
						
						MarcaCancelado(@vCT2,SEZ->EZ_NATUREZ,SEZ->EZ_CCUSTO,SEZ->EZ_ITEMCTA)
					Endif
					
					If lCtbC    // Se houve alteração de conta contábil, então altera também o SEV
						SEV->(dbSetOrder(1))
						While SEV->(dbSeek(SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ)))
							RecLock("SEV",.F.)
							SEV->EV_NATUREZ := aCols1[x,nPCtD]
							MsUnLock()
						Enddo
					Endif
					
					RecLock("SEZ",.F.)
					If lCtbC
						SEZ->EZ_NATUREZ := aCols1[x,nPCtD]
					Endif
					If lProj
						SEZ->EZ_CCUSTO  := aCols1[x,nPPrD]
					Endif
					If lCMCT .Or. lCtbC
						SEZ->EZ_CLVL    := aCols1[x,nPMCD]
					Endif
					If lITem
						SEZ->EZ_ITEMCTA := aCols1[x,nPItD]
					Endif
					MsUnLock()
					
					If vReg[x,5] == "S" .And. (lCtbC .Or. /*lCMCT .Or.*/ lProj .Or. lItem)   // Contabiliza alteracoes
						VALOR  := 0   // Valor do Fornecedor
						VALOR2 := 0   // Valor do IRRF
						VALOR3 := 0   // Valor do INSS
						VALOR4 := 0   // Valor do ISS
						VALOR5 := 0   // Valor do PIS
						VALOR6 := 0   // Valor do COFINS
						VALOR7 := 0   // Valor do CSLL
						
						nTotal += DetProva(nHdlPrv,"508","INFINP02",cLote) // Lancamento padrao de inclusao
					Endif
					dDtLanc := SE2->E2_EMIS1
				Endif
			Case vReg[x,1] == "SE2"   // Se origem do Financeiro
				lCtbC := lCtbC .And. E2_NATUREZ <> aCols1[x,nPCtD]  // Se dado gravado for diferente do digitado
				lProj := lProj .And. E2_CC      <> aCols1[x,nPPrD]  // Se dado gravado for diferente do digitado
				lCMCT := lCMCT .And. E2_CLVL    <> aCols1[x,nPMCD]  // Se dado gravado for diferente do digitado
				lItem := lItem .And. E2_ITEMCTA <> aCols1[x,nPItD]  // Se dado gravado for diferente do digitado
				lPedi := lPedi .And. E2_PEDIDO  <> aCols1[x,nPPdD]  // Se dado gravado for diferente do digitado
				lViag := lViag .And. E2_VIAGEM  <> aCols1[x,nPVgD]  // Se dado gravado for diferente do digitado
				lTrei := lTrei .And. E2_TREINAM <> aCols1[x,nPTnD]  // Se dado gravado for diferente do digitado
				lDesc := lDesc .And. E2_HIST    <> aCols1[x,nPDes]  // Se dado gravado for diferente do digitado
				If lCtbC .Or. lProj .Or. lCMCT .Or. lItem .Or. lPedi .Or. lViag .Or. lTrei .Or. lDesc
					If vReg[x,5] == "S" .And. (lCtbC .Or. lProj .Or. /*lCMCT .Or.*/ lItem)  // Contabiliza alteracoes
						SED->(dbSetOrder(1))
						SED->(dbSeek(XFILIAL("SED")+SE2->E2_NATUREZ))    // Posiciona no cadastro da natureza
						SA2->(dbSetOrder(1))
						SA2->(dbSeek(XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA))) // Posiciona no Cadastro de Fornecedores
						
						// Inicializa variaveis utilizadas pelo sistema nos lancamentos padroes
						VALOR  := 0     // Valor do Titulo
						VALOR2 := 0     // Valor do IRRF
						VALOR3 := 0     // Valor do INSS
						VALOR4 := 0     // Valor do ISS
						VALOR5 := 0     // Valor do PIS
						VALOR6 := 0     // Valor do COFINS
						VALOR7 := 0     // Valor do CSLL
						
						// Prepara o lancamento padrao de origem do estorno
						If lHead
							cLote   := "009950"
							nHdlPrv := HeadProva(cLote,"INFINP02",SubStr(cUsuario,7,15),@cArquivo)
							lHead   := .F.
						Endif
						nTotal += DetProva(nHdlPrv,"515","INFINP02",cLote) // Lancamento padrao de estorno   - Contas a Pagar
						
						MarcaCancelado(@vCT2,SE2->E2_NATUREZ,SE2->E2_CC,SE2->E2_ITEMCTA)
					Endif
					
					RecLock("SE2",.F.)
					If lCtbC
						SE2->E2_NATUREZ := aCols1[x,nPCtD]
					Endif
					If lProj
						SE2->E2_CC      := aCols1[x,nPPrD]
					Endif
					If lCMCT .Or. lCtbC
						SE2->E2_CLVL    := aCols1[x,nPMCD]
					Endif
					If lITem
						SE2->E2_ITEMCTA := aCols1[x,nPItD]
					Endif
					If lPedi
						SE2->E2_PEDIDO  := aCols1[x,nPPdD]
					Endif
					If lViag
						SE2->E2_VIAGEM  := aCols1[x,nPVgD]
					Endif
					If lTrei
						SE2->E2_TREINAM := aCols1[x,nPTnD]
					Endif
					If lDesc
						SE2->E2_HIST    := aCols1[x,nPDes]
					Endif
					MsUnLock()
					
					If vReg[x,5] == "S" .And. (lCtbC .Or. lProj .Or. /*lCMCT .Or.*/ lItem)  // Contabiliza alteracoes
						nTotal += DetProva(nHdlPrv,"510","INFINP02",cLote) // Lancamento padrao de inclusao  - Contas a Pagar
					Endif
					
					dDtLanc := SE2->E2_EMIS1
				Endif
			Case vReg[x,1] == "SZ1"   // Se origem da Folha
				If lProj .And. Z1_CC <> aCols1[x,nPPrD]  // Se dado gravado for diferente do digitado
					If vReg[x,5] == "S"   // Contabiliza alteracoes
						If lHead
							cLote   := "009990"
							//nHdlPrv := HeadProva(cLote,"INFINP02",SubStr(cUsuario,7,15),@cArquivo)
							lHead := .F.
						Endif
					Endif
					RecLock("SZ1",.F.)
					SZ1->Z1_CC := aCols1[x,nPPrD]
					MsUnLock()
				Endif
				dbSelectArea("SE2")
				dbGoTo(vReg[x,4])
				If lCMCT .And. E2_CLVL <> aCols1[x,nPMCD]  // Se dado gravado for diferente do digitado
					If vReg[x,5] == "S"   // Contabiliza alteracoes
					Endif
					RecLock("SE2",.F.)
					SE2->E2_CLVL := aCols1[x,nPMCD]
					MsUnLock()
				Endif
		EndCase
	Next
	
	SE2->(dbGoTo(nRegSE2))  // Re-Posiciona no registro do SE2
	SE5->(dbGoTo(nRegSE5))  // Re-Posiciona no registro do SE5
	
	// Efetua gravacao da justificativa
	SZ6->(dbSetOrder(1))          // Pega os dados do SZ6
	For x:=1 To Len(vJus)
		If vJus[x,2] <> 0  // Se houve alteracao da justificativa
			SZ6->(dbGoTo(vJus[x,2]))
			RecLock("SZ6",.F.)
			SZ6->Z6_JUSTIFI := vJus[x,1]
			MsUnLock()
		Else
			If !Empty(aCols1[x,nPPdD]) .And. !(aCols1[x,nPPdD] = "Z")   // Se foi informado o processo de compra
				If !SZ6->(dbSeek(XFILIAL("SZ6")+"1"+aCols1[x,nPPdD]))
					RecLock("SZ6",.T.)
					SZ6->Z6_FILIAL  := XFILIAL("SZ6")
					SZ6->Z6_TIPO    := "1"
					SZ6->Z6_NUM     := aCols1[x,nPPdD]
					SZ6->Z6_JUSTIFI := vJus[x,1]
					MsUnLock()
				Endif
			ElseIf !SZ6->(dbSeek(xFilial("SZ6")+"4"+SE2->(E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA)))
				RecLock("SZ6",.T.)
				SZ6->Z6_FILIAL  := XFILIAL("SZ6")
				SZ6->Z6_TIPO    := "4"
				SZ6->Z6_NUM     := SE2->E2_NUM
				SZ6->Z6_PREFIXO := SE2->E2_PREFIXO
				SZ6->Z6_FORNECE := SE2->E2_FORNECE
				SZ6->Z6_LOJA    := SE2->E2_LOJA
				SZ6->Z6_JUSTIFI := vJus[x,1]
				MsUnLock()
			Endif
		Endif
	Next
	
	// Envia para Lancamento Contabil
	If !lHead
		lAglut := .T.
		RodaProva(nHdlPrv,nTotal)
		// Essa e a funcao do quadro dos lancamentos.
		lRet := cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut,"S",dDtLanc,)
	Endif
	
	// Marca os lançamentos do CT2 como cancelado
	vCT2 := If( ValType(vCT2) == Nil , {}, If( ValType(vCT2) == "N" , { {,,vCT2,,.T.} }, vCT2))
	For x:=1 To Len(vCT2)
		If vCT2[x,5]   // Se foi alterado
			CT2->(dbGoTo(vCT2[x,3]))
			RecLock("CT2",.F.)
			CT2->CT2_CANC := "S"
			MsUnLock()
		Endif
	Next
	
	dbSelectArea("TBS")
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AtuRodape  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de atualizacao do calculo do Rodape                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AtuRodape(oObj,cDes1,nTot1,nTot2)
	Local oDlg := Nil
	
	If ( oObj == Nil )
		oDlg := GetWndDefault()
		If ( ValType(oDlg:Cargo)<>"B" )
			oDlg := oDlg:oWnd
		EndIf
	Else
		oDlg := oObj:oWnd
	EndIf
	
	If ( ValType(oDlg:Cargo)=="B" )
		Eval(oDlg:Cargo,cDes1,nTot1,nTot2)
	Endif
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AtuaCols   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de atualizacao do aCols com os dados filtrados do mvto.¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function AtuaCols(nValDoc,cConta,cCC,cCLVL,cITCTB,cPedid,cViage,cTrein,cHist,cItCOM,cOrig)
	Local cCtbC, cProj, cMCT, cItem, cPedi, cViag, cTrei
	Local lRet := .F.
	
	cPedid := If( cPedid == Nil , Space(06), cPedid)  // Caso seja nulo, inicializa com espacos
	cViage := If( cViage == Nil , Space(06), cViage)  // Caso seja nulo, inicializa com espacos
	cTrein := If( cTrein == Nil , Space(06), cTrein)  // Caso seja nulo, inicializa com espacos
	
	If (Empty(mv_par13) .Or. cCC    == mv_par13) .And.;  // Se projeto vazio ou igual ao encontrado na movimentacao
		(Empty(mv_par15) .Or. cCLVL  == mv_par15) .And.;  // Se MCT     vazio ou igual ao encontrado na movimentacao
		(Empty(mv_par17) .Or. cITCTB == mv_par17) .And.;  // Se Item    vazio ou igual ao encontrado na movimentacao
		(Empty(mv_par19) .Or. cPedid == mv_par19) .And.;  // Se Pedido  vazio ou igual ao encontrado na movimentacao
		(Empty(mv_par21) .Or. cViage == mv_par21) .And.;  // Se Viagem  vazio ou igual ao encontrado na movimentacao
		(Empty(mv_par23) .Or. cTrein == mv_par23)         // Se Treina  vazio ou igual ao encontrado na movimentacao
		cItCOM := If( cItCOM == Nil , Space(Len(SD1->D1_ITEM)), cItCOM)
		cCtbC  := Repli("Z",Len(cConta))
		cProj  := If( cCC   == mv_par14 , Repli("Z",Len(cCC))  , mv_par14)
		cMCT   := If( cMCT  == mv_par16 , Repli("Z",Len(cMCT)) , mv_par16)
		cItem  := If( cItem == mv_par18 , Repli("Z",Len(cItem)), mv_par18)
		cPedi  := If( cPedi == mv_par20 , Repli("Z",Len(cPedi)), mv_par20)
		cViag  := If( cViag == mv_par22 , Repli("Z",Len(cViag)), mv_par22)
		cTrei  := If( cTrei == mv_par24 , Repli("Z",Len(cTrei)), mv_par24)
		// Se nao for movimento bancario e o usuario preencheu com ZZZ e o titulo tem origem na folha,
		// atribui o mesmo valor do colaborador para o destino
		If cOrig <> "SE5" .And. mv_par16 = "ZZZ" .And. SE2->E2_ORIGEM = "GPEM670"
			cItem := cITCTB
		Endif
		cCLVL := CT2->CT2_CLVLDB  // Atribui no aCols a Classe de valor do Lançamento Contábil
		AAdd( aCols1 , { cItCOM, nValDoc, cConta, cCtbC, cCC, cProj, cCLVL, cMCT, cITCTB, cItem,;
		cPedid, cPedi, cViage, cViag, cTrein, cTrei, cHist, .F.})
		lRet := .T.
		nTotTit += nValDoc
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ Estornado ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 30/01/2009¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Pesquisa se o documento de origem foi estornado               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
/*Static Function Estornado()
	Local cTab, nReg
	Local cAlias := Alias()
	Local lRet := .F.
	
	If Empty(TBS->CT2_DTCV3) .Or. Left(TBS->CT2_ROTINA,3) == "GPE"
		Return lRet
	Endif
	
	cQry := "SELECT CV3_TABORI, MIN(ISNULL(CV3_RECORI,' ')) AS CV3_RECORI, ISNULL(SUM(CV3_VLR01),0) AS CV3_VLR01"
	cQry += " FROM "+RetSQLName("CV3")
	cQry += " WHERE D_E_L_E_T_ = ' '"
	
	// Se o CT2_LP estiver vazio, provavelmente não posicionou no CTL, caso contrário posicionou
	// Então caso não seja de origem de mov. bancária, adiciona filtros referente ao documento origem
	If Empty(TBS->CT2_LP) .Or. CTL->CTL_ALIAS <> "SE5"
		cQry += " AND CV3_FILIAL = '"+TBS->CT2_FILIAL+"'"
		cQry += " AND CV3_DTSEQ = '"+Dtos(TBS->CT2_DATA)+"'"
		cQry += " AND CV3_SEQUEN = '"+TBS->CT2_SEQUEN+"'"
		cQry += " AND CV3_LP = '"+TBS->CT2_LP+"'"
		cQry += " AND CV3_LPSEQ = '"+TBS->CT2_SEQHIS+"'"
		cQry += " AND CV3_MOEDLC = '"+TBS->CT2_MOEDLC+"'"
		cQry += " AND CV3_DC = '"+TBS->CT2_DC+"'"
		cQry += " AND CV3_DEBITO = '"+TBS->CT2_DEBITO+"'"
		cQry += " AND CV3_CREDIT = '"+TBS->CT2_CREDIT+"'"
		cQry += " AND CV3_CCD = '"+TBS->CT2_CCD+"'"
		cQry += " AND CV3_CCC = '"+TBS->CT2_CCC+"'"
		cQry += " AND CV3_ITEMD = '"+TBS->CT2_ITEMD+"'"
		cQry += " AND CV3_ITEMC = '"+TBS->CT2_ITEMC+"'"
		cQry += " AND CV3_CLVLDB = '"+TBS->CT2_CLVLDB+"'"
		cQry += " AND CV3_CLVLCR = '"+TBS->CT2_CLVLCR+"'"
	Endif
	
	cQry += " AND CV3_RECDES = '"+AllTrim(Str(TBS->CT2_RECNO,0))+"'"
	cQry += " GROUP BY CV3_TABORI"
	
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TTT", .T., .F. )
	If !Empty(TTT->CV3_TABORI) .And. !Empty(TTT->CV3_RECORI) .And. Abs(TTT->CV3_VLR01-TBS->CT2_VALOR) < 0.01
		cTab := TTT->CV3_TABORI
		nReg := (cTab)->(Recno())  // Salva a posicão original
		(cTab)->(dbGoTo(Val(TTT->CV3_RECORI)))
		
		If !(lRet := (cTab)->(Eof()))
			lRet := (cTab)->(Deleted())  // Se estiver deletado
			If cTab == "SE5" .And. !lRet
				lRet := SE5->E5_SITUACA $ "CEX"   // Cancelado
			Endif
		Endif
		If lRet   // Se estiver deletado, então volta a posição original do título
			(cTab)->(dbGoTo(nReg))
		Endif
	Endif
	dbCloseArea()
	dbSelectArea(cAlias)
	
Return lRet*/

Static Function GetE2VALOR(cAlias)
	Local x
	Local nRet  := (cAlias)->E2_VALOR
	Local vParc := {}
	
	AAdd( vParc , { {|a| (a)->E2_INSS   }, {|a| (a)->E2_PARCINS }})
	AAdd( vParc , { {|a| (a)->E2_IRRF   }, {|a| (a)->E2_PARCIR  }})
	AAdd( vParc , { {|a| (a)->E2_ISS    }, {|a| (a)->E2_PARCISS }})
	AAdd( vParc , { {|a| (a)->E2_PIS    }, {|a| (a)->E2_PARCPIS }})
	AAdd( vParc , { {|a| (a)->E2_COFINS }, {|a| (a)->E2_PARCCOF }})
	AAdd( vParc , { {|a| (a)->E2_CSLL   }, {|a| (a)->E2_PARCSLL }})
	
	For x:=1 To Len(vParc)
		If !Empty(Eval(vParc[x,2],cAlias))
			nRet += Eval(vParc[x,1],cAlias)
		Endif
	Next
	
Return nRet

Static Function MarcaCancelado(vCT2,cConta,cCC,cItem)
	Local x
	
	For x:=1 To Len(vCT2)
		If !vCT2[x,5]  // Se ainda não foi marcado
			CT2->(dbGoTo(vCT2[x,3]))   // Posiciona no CT2
			// Se tiver os mesmos dados contábeis alterados, então marca como cancelado
			If CT2->CT2_DEBITO == cConta .And. CT2->CT2_CCD == cCC .And. CT2->CT2_ITEMD == cItem
				vCT2[x,5] := .T.
			Endif
		Endif
	Next
	
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ValidPerg  ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/08/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de criacao das perguntas                               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidPerg(cPerg)
	Local i, j, aRegs, _sAlias := Alias()
	
	aRegs := {}
	dbSelectArea("SX1")
	dbSetOrder(1)
	AADD(aRegs,{cPerg,"01","Da Data                      ?","","","mv_ch1","D", 8,0,0,"G","","mv_par01"})
	AADD(aRegs,{cPerg,"02","Ate a Data                   ?","","","mv_ch2","D", 8,0,0,"G","","mv_par02"})
	AADD(aRegs,{cPerg,"03","Do Prefixo                   ?","","","mv_ch3","C", 3,0,0,"G","","mv_par03"})
	AADD(aRegs,{cPerg,"04","Ate o Prefixo                ?","","","mv_ch4","C", 3,0,0,"G","","mv_par04"})
	AADD(aRegs,{cPerg,"05","Do Documento                 ?","","","mv_ch5","C", 9,0,0,"G","","mv_par05"})
	AADD(aRegs,{cPerg,"06","Ate o Documento              ?","","","mv_ch6","C", 9,0,0,"G","","mv_par06"})
	AADD(aRegs,{cPerg,"07","Do Fornecedor                ?","","","mv_ch7","C", 6,0,0,"G","","mv_par07",;
							"","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
	AADD(aRegs,{cPerg,"08","Ate o Fornecedor             ?","","","mv_ch8","C", 6,0,0,"G","","mv_par08",;
							"","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
	AADD(aRegs,{cPerg,"09","Da Loja                      ?","","","mv_ch9","C", 2,0,0,"G","","mv_par09"})
	AADD(aRegs,{cPerg,"10","Ate a Loja                   ?","","","mv_cha","C", 2,0,0,"G","","mv_par10"})
	AADD(aRegs,{cPerg,"11","Do Item da Nota              ?","","","mv_chd","C", 4,0,0,"G","","mv_par11"})
	AADD(aRegs,{cPerg,"12","Ate o Item da Nota           ?","","","mv_che","C", 4,0,0,"G","","mv_par12"})
	AADD(aRegs,{cPerg,"13","Projeto Origem               ?","","","mv_chf","C", 9,0,0,"G",;
							"Vazio().Or.ExistCpo('CTT')","mv_par13","","","","","","","","","",;
							"","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"14","Projeto Destino              ?","","","mv_chg","C", 9,0,0,"G",;
							"mv_par14='ZZZ'.Or.ExistCpo('CTT')","mv_par14","","","","","","","",;
							"","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"15","Classe MCT Origem            ?","","","mv_chh","C", 9,0,0,"G",;
							"Vazio().Or.ExistCpo('CTH')","mv_par15","","","","","","","","","","",;
							"","","","","","","","","","","","","","","CTH"})
	AADD(aRegs,{cPerg,"16","Classe MCT Destino           ?","","","mv_chi","C", 9,0,0,"G",;
							"mv_par16='ZZZ'.Or.ExistCpo('CTH')","mv_par16","","","","","","","","",;
							"","","","","","","","","","","","","","","","","CTH"})
	AADD(aRegs,{cPerg,"17","Colaborador Origem           ?","","","mv_chj","C", 9,0,0,"G",;
							"Vazio().Or.ExistCpo('CTD')","mv_par17","","","","","","","","","","","",;
							"","","","","","","","","","","","","","CTD"})
	AADD(aRegs,{cPerg,"18","Colaborador Destino          ?","","","mv_chk","C", 9,0,0,"G",;
							"mv_par18='ZZZ'.Or.ExistCpo('CTD')","mv_par18","","","","","","","","","",;
							"","","","","","","","","","","","","","","","CTD"})
	AADD(aRegs,{cPerg,"19","Pedido Origem            ?","","","mv_chl","C", 6,0,0,"G",;
							"Vazio().Or.ExistCpo('SC7',mv_par19)","mv_par19","","","","","","","","","","",;
							"","","","","","","","","","","","","","","SC7"})
	AADD(aRegs,{cPerg,"20","Pedido Destino           ?","","","mv_chm","C", 6,0,0,"G",;
							"mv_par20='ZZZ'.Or.ExistCpo('SC7',mv_par20)","mv_par20","","","","","","","","",;
							"","","","","","","","","","","","","","","","","SC7"})
	AADD(aRegs,{cPerg,"21","Viagem Origem            ?","","","mv_chn","C", 6,0,0,"G",;
							"Vazio().Or.ExistCpo('SZ7',mv_par21)","mv_par21","","","","","","","","","","",;
							"","","","","","","","","","","","","","","SZ7"})
	AADD(aRegs,{cPerg,"22","Viagem Destino           ?","","","mv_cho","C", 6,0,0,"G",;
							"mv_par22='ZZZ'.Or.ExistCpo('SZ7',mv_par22)","mv_par22","","","","","","","","",;
							"","","","","","","","","","","","","","","","","SZ7"})
	AADD(aRegs,{cPerg,"23","Treinamento Origem           ?","","","mv_chp","C", 6,0,0,"G",;
							"Vazio().Or.ExistCpo('SZ8',mv_par23)","mv_par23","","","","","","","","","","",;
							"","","","","","","","","","","","","","","SZ8"})
	AADD(aRegs,{cPerg,"24","Treinameto Destino           ?","","","mv_chq","C", 6,0,0,"G",;
							"mv_par24='ZZZ'.Or.ExistCpo('SZ8',mv_par24)","mv_par24","","","","","","","","",;
							"","","","","","","","","","","","","","","","","SZ8"})
	AADD(aRegs,{cPerg,"25","Processar titulos Financeiro ?","","","mv_chr","N",01,0,0,"C","","mv_par25",;
							"Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"26","Processar titulos do Compras ?","","","mv_chs","N",01,0,0,"C","","mv_par26",;
							"Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"27","Processar titulos da Folha   ?","","","mv_cht","N",01,0,0,"C","","mv_par27",;
							"Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"28","Mostra Lancamento contabil   ?","","","mv_chu","N",01,0,0,"C","","mv_par28",;
							"Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif
	Next
	dbSelectArea(_sAlias)
Return
