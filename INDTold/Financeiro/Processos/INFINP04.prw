#include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ INFINP04   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/10/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de geração dos dados da contabilidade para o MCT       ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function INFINP04(cTab,cQry,cOrig,lNewFile,lJunRP,lEstorno)
	Local aDbf, cArq, nRegis, cChave, lAchou, ni, nTam, cBusca, lFound, nReg, lAvulso
	Local cAlias    := Alias()
	Local aStru     := CT2->(dbStruct())
	Local cFilCTL   := CTL->(XFILIAL("CTL"))
	Local cMVESTADO := GetMV("MV_ESTADO")

	Private lRuby   := (Trim(FunName()) == "INFINP05")   // Se tiver processando dados para o sistema do Ruby
	Private vLP     := {}
	Private cNumDoc, cPrfTit, cTpTit, cParcTit, cCodFor, cLjFor, cBcoPag, cAgePag, cCtaPag, cProd, cViagem, cTreina
	Private cHora, cPrComp, nQuant, cNoDI, cItem, cBaseAtf, cSeq, cTipoDoc, cMovBco, cOrigFlx, cRotina, cGerFin, cFilOrig
	
	CTL->(dbSetOrder(1))
	SA6->(dbSetOrder(1))
	
	lNewFile := If( lNewFile == nil , .T., lNewFile ) // Define se ira gerar novo arquivo temporario
	cOrig    := If( cOrig    == nil , " ", cOrig)     // Define origem de busca
	lEstorno := If( lEstorno == nil , .F., lEstorno)  // Define se não considera os estornos
	
	If lNewFile
		aDbf := u_CpoPadSE5()
		cArq := CriaTrab(aDbf,.t.)
		Use &cArq Alias &(cTab) New Exclusive
	Endif
	
	//aTMP := CT2->(dbStruct())
	//cTMP := CriaTrab( aTMP , .T. )
	//Use &cTMP Alias TMPAUD New Exclusive
	
	// Cria vetor de lançamentos padrões, inclusão e estorno
	AAdd( vLP , { "508", "509"})
	AAdd( vLP , { "510", "515"})
	AAdd( vLP , { "513", "514"})
	AAdd( vLP , { "650", "655"})
	AAdd( vLP , { "651", "656"})
	AAdd( vLP , { "660", "665"})
	
	// Ignora Lotes de transferência
	cQry += " AND CT2_LOTE NOT IN ('009960')"
	
	// Adiciona filtros básicos a query de origem
	cQry += " AND (CT2_KEY <> 'XX' OR SUBSTRING(CT2_ROTINA,1,3) = 'GPE')"
	cQry += " AND CT2_VALOR <> 0 AND (CT2_CCD <> ' ' OR CT2_CCC <> ' ')"
	
	// Adicionar lançamentos padrões que não serão processados. Ex: Baixas pois não se referem a COMPETÊNCIA
	cQry += " AND CT2_LP NOT IN ('530','532','597','801','805','820',"
	
	// Adicionar lançamentos padrões que não serão processados. Ex: Estornos diversos
	If !lEstorno   // Se não considera estorno
		cQry += "'509','512','514','515','531','564','565','581','589','591','655','656',"
	Endif
	cQry += "'806','807','814','815','816')"
	
	cQry += " AND (EXISTS(SELECT DEB.CT1_CONTA FROM "+RetSQLName("CT1")+" DEB WHERE DEB.D_E_L_E_T_ = ' ' AND DEB.CT1_CONTA = CT2.CT2_DEBITO AND DEB.CT1_XMCT = 'S')
	cQry += " OR EXISTS(SELECT CRD.CT1_CONTA FROM "+RetSQLName("CT1")+" CRD WHERE CRD.D_E_L_E_T_ = ' ' AND CRD.CT1_CONTA = CT2.CT2_CREDIT AND CRD.CT1_XMCT = 'S'))"
	cQry += " AND CT2_TPSALD = '1' AND CT2_CANC <> 'S'"
	cQry += " AND CT2_ROTINA <> 'CTBA211'"  // Desconsidera lançamentos de fechamento
	
	//- Conta o numero de registros filtrados pela query
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "SOM", .T., .F. )
	nRegis:= SOM->SOMA
	dbCloseArea()
	
	//- Troca a expressao COUNT(*) por * na clausula SELECT
	cQry := StrTran(cQry,"COUNT(*) SOMA","CT2.*, R_E_C_N_O_ AS CT2_RECNO")
	cQry += " ORDER BY CT2_KEY, CT2_LP"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TBS", .T., .F. )
	
	For ni:=1 To Len(aStru)
		If aStru[ni,2] != "C"
			TCSetField("TBS", aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next
	
	ProcRegua(RecCount())
	While !Eof()
		cChave := CT2_KEY
		While !Eof() .And. cChave == CT2_KEY
			
			lAchou := .T.
			
			If (lEstorno .Or. !Empty(CT2_KEY)) .And. CTL->(dbSeek(cFilCTL+TBS->CT2_LP))  // Se não achou chave de busca
				// Posiciona no item da tabela
				dbSelectArea(CTL->CTL_ALIAS)
				dbSetOrder(Val(CTL->CTL_ORDER))
				If CTL->CTL_ALIAS == "SD1"
					If Len(AllTrim(cChave)) > 20
						nTam := Len(&(CTL->CTL_ALIAS+"->("+Trim(CTL->CTL_KEY)+")"))
					Else
						nTam := 19
					Endif
				Else
					nTam := Len(&(CTL->CTL_ALIAS+"->("+Trim(CTL->CTL_KEY)+")"))
				Endif
				lAchou := dbSeek(PADR(cChave,nTam))
				dbSelectArea("TBS")
			ElseIf Empty(CT2_KEY)
				lAchou := .F.
			Endif
			
			cLP := CT2_LP
			While !Eof() .And. cChave+cLP == CT2_KEY+CT2_LP
				
				IncProc()
				
				If Estornado(lEstorno)  // Se a origem não existe mais
					//GravaTemp()
					dbSkip()
					Loop
				Endif
				
				// Ignora lançamentos onde o usuário não tem acesso liberado
				If !u_UserCCusto(CT2_CCD) .Or. !u_UserCCusto(CT2_CCC)
					dbSkip()
					Loop
				Endif
				
				// Inicializa variáveis genéricas
				cNumDoc  := ""
				cPrfTit  := ""
				cTpTit   := ""
				cParcTit := ""
				cCodFor  := ""
				cLjFor   := ""
				cBcoPag  := ""
				cAgePag  := ""
				cCtaPag  := ""
				cProd    := ""
				cViagem  := ""
				cTreina  := ""
				cHora    := ""
				cPrComp  := ""
				nQuant   := 1
				cNoDI    := ""
				cItem    := ""
				cBaseAtf := ""
				cSeq     := ""
				cTipoDoc := ""
				cMovBco  := "2"
				cOrigFlx := cOrig
				cGerFin  := ""
				cRotina  := ""
				cFilOrig := ""
				lAvulso  := Empty(cChave)
				
				// Define o conteúdo das variáveis conforme origem do lançamento
				Do Case
					Case Left(CT2_ROTINA,3) == "GPE"
						
						cRotina  := "GPEM670"
						cFilOrig := TBS->CT2_FILIAL
						
						CT1->(dbSetOrder(1))
						CT1->(dbSeek(XFILIAL("CT1")+TBS->CT2_DEBITO))
						
						If Trim(PADR(CT1->CT1_GRUPO,Len(CTH->CTH_CLVL))) == "008"
							// Pesquisa o título gerado para o lançamento de Serviço de Terceiros
							cQry := "SELECT TOP 1 E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA"
							cQry += " FROM "+RetSQLName("SE2")
							cQry += " WHERE D_E_L_E_T_=' ' AND '"+CT2_FILIAL+"' >= SUBSTRING(E2_PARFOL,1,2)"
							cQry += " AND '"+CT2_FILIAL+"' <= SUBSTRING(E2_PARFOL,3,2) AND '"+CT2_CCD+"' >= SUBSTRING(E2_PARFOL,5,9)"
							cQry += " AND '"+CT2_CCD+"' <= SUBSTRING(E2_PARFOL,14,9) AND '"+CT2_ITEMD+"' >= SUBSTRING(E2_PARFOL,23,6)"
							cQry += " AND '"+CT2_ITEMD+"' <= SUBSTRING(E2_PARFOL,29,6) AND E2_DATARQ = '"+SubStr(Dtos(CT2_DATA),1,6)+"'"
							cQry += " AND (E2_AGRUPA NOT IN ('2','4') OR (E2_AGRUPA = '4' AND E2_ITEMCTA = '"+CT2_ITEMD+"')"
							cQry += " OR (E2_AGRUPA = '2' AND E2_CC = '"+CT2_CCD+"')) AND E2_CLVL = '008'"
							cQry += " AND "+TiposTit(CT2_LP)
							cQry += " ORDER BY E2_ITEMCTA DESC, E2_CC DESC, E2_PREFIXO, E2_NUM"
							dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "QRYSE2", .T., .F. )
							If !Empty(E2_FILIAL)
								SE2->(dbSetOrder(1))
								If SE2->(dbSeek(QRYSE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
									cNumDoc  := SE2->E2_NUM
									cPrfTit  := SE2->E2_PREFIXO
									cTpTit   := SE2->E2_TIPO
									cParcTit := SE2->E2_PARCELA
									cCodFor  := SE2->E2_FORNECE
									cLjFor   := SE2->E2_LOJA
									cBcoPag  := SE2->E2_BCOPAG
									cAgePag  := SE2->E2_AGENCIA
									cCtaPag  := SE2->E2_CONTA
									cPrComp  := SE2->E2_PEDIDO
									cProd    := SE2->E2_HIST
									cViagem  := SE2->E2_VIAGEM
									cTreina  := SE2->E2_TREINAM
									cGerFin  := "S"
									cRotina  := SE2->E2_ORIGEM
									cFilOrig := SE2->E2_FILORIG
								Endif
							Endif
							dbCloseArea()
							dbSelectArea("TBS")
						Endif
						
					Case CTL->CTL_ALIAS == "SD1"
						
						If lAchou  // Se encontrou referência na origem
							SE2->(dbSetOrder(6))
							SE2->(dbSeek(SD1->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_SERIE+D1_DOC)))  // Posiciona no título a pagar
							cBusca := SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
							lFound := (TBS->CT2_MANUAL == "1")   // Se for lançamento manual (.T.)
							nReg   := SD1->(Recno())
							While !SD1->(Eof()) .And. cBusca == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) .And. !lFound
								
								If SD1->(&(AllTrim(CTL->CTL_KEY))) == AllTrim(cChave) .Or.;
									(TBS->CT2_CLVLDB == SD1->D1_CLVL .And. TBS->CT2_ITEMD == SD1->D1_ITEMCTA .And.;
									TBS->CT2_CCD == SD1->D1_CC .And. TBS->CT2_DEBITO == SD1->D1_CONTA)
									lFound := .T.
									Exit
								Endif
								
								SD1->(dbSkip())
							Enddo
							
							// Se não encontrou referência
							If !lFound
								dbSkip()
								Loop
							Endif
							
							cNumDoc  := SD1->D1_DOC
							cPrfTit  := SD1->D1_SERIE
							cTpTit   := SE2->E2_TIPO
							cParcTit := SE2->E2_PARCELA
							cCodFor  := SD1->D1_FORNECE
							cLjFor   := SD1->D1_LOJA
							cBcoPag  := SE2->E2_BCOPAG
							cAgePag  := SE2->E2_AGENCIA
							cCtaPag  := SE2->E2_CONTA
							
							cViagem  := SD1->D1_VIAGEM
							cProd    := SD1->D1_DESCRI
							cTreina  := SD1->D1_TREINAM
							cHora    := SD1->D1_HORA
							cPrComp  := SD1->D1_PRCOMP
							nQuant   := SD1->D1_QUANT
							cNoDI    := SD1->D1_NODI
							cItem    := SD1->D1_ITEM
							cBaseAtf := SD1->D1_CBASEAF
							cGerFin  := Posicione("SF4",1,XFILIAL("SF4")+SD1->D1_TES,"F4_DUPLIC")
							cRotina  := If( cGerFin == "S" , SE2->E2_ORIGEM, "MATA100")
							cFilOrig := SD1->D1_FILIAL
						Endif
						
					Case CTL->CTL_ALIAS == "SD2"
						
						dbSkip()
						Loop
						
					Case CTL->CTL_ALIAS == "SE2"
						
						If lAchou  // Se não encontrou referência na origem
							cNumDoc  := SE2->E2_NUM
							cPrfTit  := SE2->E2_PREFIXO
							cTpTit   := SE2->E2_TIPO
							cParcTit := SE2->E2_PARCELA
							cCodFor  := SE2->E2_FORNECE
							cLjFor   := SE2->E2_LOJA
							cBcoPag  := SE2->E2_BCOPAG
							cAgePag  := SE2->E2_AGENCIA
							cCtaPag  := SE2->E2_CONTA
							cPrComp  := SE2->E2_PEDIDO
							cProd    := SE2->E2_HIST
							cViagem  := SE2->E2_VIAGEM
							cTreina  := SE2->E2_TREINAM
							cGerFin  := "S"
							cRotina  := SE2->E2_ORIGEM
							cFilOrig := SE2->E2_FILORIG
						Endif
						
					Case CTL->CTL_ALIAS == "SE5"
						
						If lAchou  // Se não encontrou referência na origem
							cNumDoc  := SE5->E5_NUMERO
							cPrfTit  := SE5->E5_PREFIXO
							cTpTit   := SE5->E5_TIPO
							cParcTit := SE5->E5_PARCELA
							cCodFor  := SE5->E5_CLIFOR
							cLjFor   := SE5->E5_LOJA
							cBcoPag  := SE5->E5_BANCO
							cAgePag  := SE5->E5_AGENCIA
							cCtaPag  := SE5->E5_CONTA
							cViagem  := BscViagem(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
							cSeq     := SE5->E5_SEQ
							cTipoDoc := SE5->E5_TIPODOC
							cMovBco  := "1"
							cGerFin  := "S"
							cRotina  := "FINA100"
							cFilOrig := SE5->E5_FILORIG
							
							If Empty(SE5->E5_RATEIO) .And. SE5->E5_TIPODOC == "TR"
								
								SA6->(dbSeek(XFILIAL("SA6")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA)))  // Posiciona no banco
								
								If SA6->A6_EST <> cMVESTADO
									cOrigFlx := "3"
								Else
									cOrigFlx := "9"
								Endif
								
							ElseIf Trim(CT2_CLVLDB) == "010"
								cOrigFlx := "4"
							Endif
						Endif
						
					Case CTL->CTL_ALIAS == "SF1"
						
						If lAchou  // Se encontrou referência na origem
							SE2->(dbSetOrder(6))
							SE2->(dbSeek(SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)))  // Posiciona no título a pagar
							SD1->(dbSetOrder(1))
							SD1->(dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))  // Posiciona no Item da Nota
							
							cNumDoc  := SD1->D1_DOC
							cPrfTit  := SD1->D1_SERIE
							cTpTit   := SE2->E2_TIPO
							cParcTit := SE2->E2_PARCELA
							cCodFor  := SD1->D1_FORNECE
							cLjFor   := SD1->D1_LOJA
							cBcoPag  := SE2->E2_BCOPAG
							cAgePag  := SE2->E2_AGENCIA
							cCtaPag  := SE2->E2_CONTA
							cViagem  := SD1->D1_VIAGEM
							cProd    := SD1->D1_COD
							cTreina  := SD1->D1_TREINAM
							cHora    := SD1->D1_HORA
							cPrComp  := SD1->D1_PRCOMP
							nQuant   := SD1->D1_QUANT
							cNoDI    := SD1->D1_NODI
							cItem    := SD1->D1_ITEM
							cBaseAtf := SD1->D1_CBASEAF
							cGerFin  := Posicione("SF4",1,XFILIAL("SF4")+SD1->D1_TES,"F4_DUPLIC")
							cRotina  := If( cGerFin == "S" , SE2->E2_ORIGEM, "MATA100")
							cFilOrig := SD1->D1_FILIAL
						Endif
						
					Case CTL->CTL_ALIAS == "SF2"
						
						If lAchou  // Se encontrou referência na origem
							lAchou := .F.
							SE2->(dbSetOrder(1))
							SE2->(dbSeek(SF2->(F2_FILIAL+F2_SERIE+F2_DOC),.T.))  // Posiciona no título a pagar
							While !SE2->(Eof()) .And. SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM) == SF2->(F2_FILIAL+F2_SERIE+F2_DOC)
								If Trim(SE2->E2_ORIGEM) == "MATA460" .And. SE2->E2_TIPO $ MVTAXA+","+MVTXA
									lAchou := .T.
									Exit
								Endif
								SE2->(dbSkip())
							Enddo
						Endif
						
						SD2->(dbSetOrder(1))
						SD2->(dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))  // Posiciona no Item da Nota
						
						cNumDoc  := SF2->F2_DOC
						cPrfTit  := SF2->F2_SERIE
						cTpTit   := "ISS"
						cParcTit := If( lAchou , SE2->E2_PARCELA, "")
						cCodFor  := SF2->F2_CLIENTE
						cLjFor   := SF2->F2_LOJA
						cBcoPag  := If( lAchou , SE2->E2_BCOPAG , "")
						cAgePag  := If( lAchou , SE2->E2_AGENCIA, "")
						cCtaPag  := If( lAchou , SE2->E2_CONTA  , "")
						cProd    := SD2->D2_COD
						nQuant   := SD2->D2_QUANT
						cGerFin  := If( lAchou , "S", "N")
						cRotina  := If( cGerFin == "S" .And. lAchou , SE2->E2_ORIGEM, "MATA460")
						cFilOrig := SF2->F2_FILIAL
						
				EndCase
				
				// Grava somente se achar o documento de origem, ou considera os estornos ou for um lançamento manual
				If lAchou .Or. lEstorno .Or. Empty(cChave) .Or. Empty(cLP)
					// Grava o movimento a Débito
					If !Empty(CT2_CCD) .And. Posicione("CT1",1,XFILIAL("CT1")+CT2_DEBITO,"CT1_XMCT") == "S"
						GrvTmpE5(cTab,CT2_CCD,CT2_DEBITO,CT2_CLVLDB,CT2_ITEMD,"P",lAvulso)
					Endif
					
					// Grava o movimento a Crédito
					If !Empty(CT2_CCC) .And. Posicione("CT1",1,XFILIAL("CT1")+CT2_CREDIT,"CT1_XMCT") == "S"
						GrvTmpE5(cTab,CT2_CCC,CT2_CREDIT,CT2_CLVLCR,CT2_ITEMC,"R",lAvulso)
					Endif
				Endif
				
				dbSkip()
			Enddo
		Enddo
	Enddo
	dbCloseArea()
	//dbSelectArea("TMPAUD")
	//dbCloseArea()
	dbSelectArea(cAlias)
	
	//If File("\AUDITO"+GetDBExtension())
	//	FErase("\AUDITO"+GetDBExtension())
	//Endif
	//FRename(cTMP+GetDBExtension(),"\AUDITO"+GetDBExtension())
	
Return cArq

Static Function GrvTmpE5(cTab,cCC,ccCtaPagb,cClasVal,cItemCta,cRP,lAvulso)
	Local cAlias := Alias()
	
	// Incluso referência da tabela de grupo de contas em substituição a Classe de Valor
	CT1->(dbSetOrder(1))
	CT1->(dbSeek(XFILIAL("CT1")+ccCtaPagb))
	
	cClasVal := CT1->CT1_GRUPO
	
	If lRuby   // Se estiver processando dados para o sistema Ruby
		If Trim(CT1->CT1_GRUPO) $ "013,017"  // Se MATERIAL DE CONSUMO: INFRAESTRUTURA ou ICM FEE
			cClasVal := "005"   // MATERIAL DE CONSUMO
		ElseIf Trim(CT1->CT1_GRUPO) == "016"  // Se VIAGEM PARA TREINAMENTO
			cClasVal := "006"   // VIAGEM
		Endif
	Endif
	
	cClasVal := PADR(cClasVal,Len(CTH->CTH_CLVL))   // Ajusta tamanho da variável
	
	dbSelectArea(cTab)
	RecLock(cTab,.T.)
	(cTab)->E5_FILIAL  := TBS->CT2_FILIAL
	(cTab)->E5_DTDISPO := TBS->CT2_DATA
	(cTab)->E5_NUMERO  := cNumDoc
	(cTab)->E5_PREFIXO := cPrfTit
	(cTab)->E5_TIPO    := cTpTit
	(cTab)->E5_PARCELA := cParcTit
	(cTab)->E5_RECPAG  := cRP
	(cTab)->E5_VALOR   := TBS->CT2_VALOR
	(cTab)->E5_CONTAB  := ccCtaPagb
	(cTab)->E5_DESCT1  := CT1->CT1_DESC01
	(cTab)->E5_CLVL    := cClasVal
	(cTab)->E5_DESCTH  := Posicione("CTH",1,XFILIAL("CTH")+cClasVal,"CTH_DESC01")
	(cTab)->E5_CC      := cCC
	(cTab)->E5_DESCCC  := Posicione("CTT",1,XFILIAL("CTT")+cCC     ,"CTT_DESC01")
	(cTab)->E5_ITEMCTA := cItemCta
	(cTab)->E5_BANCO   := cBcoPag
	(cTab)->E5_AGENCIA := cAgePag
	(cTab)->E5_CONTA   := cCtaPag
	(cTab)->E5_BENEF   := TBS->CT2_HIST
	(cTab)->E5_CLIFOR  := cCodFor
	(cTab)->E5_LOJA    := cLjFor
	(cTab)->E5_STATUS  := "S"
	(cTab)->E5_VIAGEM  := cViagem
	(cTab)->E5_TREINAM := cTreina
	(cTab)->E5_HORA    := cHora
	(cTab)->E5_PRODUTO := cProd
	(cTab)->E5_QUANT   := nQuant
	(cTab)->E5_PRCOMP  := cPrComp
	(cTab)->E5_NODI    := cNoDI
	(cTab)->E5_ITEM    := cItem
	(cTab)->E5_ORIGEM  := cOrigFlx
	(cTab)->E5_ROTINA  := cRotina
	(cTab)->E5_BAICOMP := "C"   // Grava como regime de competência
	(cTab)->E5_BASEATF := cBaseAtf
	(cTab)->E5_SEQ     := cSeq
	(cTab)->E5_TIPODOC := cTipoDoc
	(cTab)->E5_TPCTB   := If( lAvulso .Or. Empty(TBS->CT2_ROTINA) .Or. Trim(TBS->CT2_ROTINA)=="FINA100" , "S", " ")
	(cTab)->E5_GERFIN  := cGerFin
	(cTab)->E5_MANUAL  := If( TBS->CT2_MANUAL == "1" , "*", " ")
	(cTab)->E5_FILORIG := cFilOrig
	(cTab)->E5_XTPORH  := If( Empty(CT1->CT1_XTPORH) , "5", CT1->CT1_XTPORH)
	
	// Define se o registro tem origem no movimento bancario. Onde 1=Sim e 2=Nao.
	// Em qualquer alteracao de alias, favor nao mudar o alias do comando abaixo TBS->CT2_MOTBX.
	(cTab)->E5_MOVBCO  := cMovBco
	
	If cTpTit == "ISS"
		(cTab)->E5_TPIMP := "ISS"
	ElseIf cTpTit == "INS"
		(cTab)->E5_TPIMP := "INSS"
	ElseIf cTpTit == "TX "
		If SE2->E2_PARCIR  == cParcTit
			(cTab)->E5_TPIMP := "IRRF"
		ElseIf SE2->E2_PARCSLL == cParcTit
			(cTab)->E5_TPIMP := "CSLL"
		ElseIf SE2->E2_PARCCOF == cParcTit
			(cTab)->E5_TPIMP := "COFINS"
		ElseIf SE2->E2_PARCPIS == cParcTit
			(cTab)->E5_TPIMP := "PIS"
		Endif
	Endif
	
	MsUnLock()
	dbSelectArea(cAlias)
	
Return((cTab)->E5_VALOR)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ BscViagem ¦ Autor ¦ Reinaldo Magalhaes     ¦ Data ¦ 04/02/2005¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Retorna o codigo da viagem de um documento                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Parâmetro ¦ cDoc -> PREFIXO+NUMERO+PARCELA+TIPO+CLIFOR+LOJA               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static function BscViagem(cDoc)
	Local n_RegSE2 := SE2->(Recno())
	Local n_IndSE2 := SE2->(IndexOrd())
	Local cViagem  := SE5->E5_VIAGEM
	
	//- Contas a pagar
	SE2->(dbSetOrder(1))
	If SE2->(dbSeek(cDoc))
		cViagem:= SE2->E2_VIAGEM
	Endif
	
	SE2->(DbSetOrder(n_IndSE2))
	SE2->(Dbgoto(n_RegSE2))
	
Return cViagem

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ Estornado ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 30/01/2009¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Pesquisa se o documento de origem foi estornado               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function Estornado(lEstorno)
	Local cTab, cTab, cQry, nPos, lAchou, cChave
	Local vReg   := {0,0,.F.}
	Local cAlias := Alias()
	Local lPesq  := !lEstorno   // Se não considera estorno, então pesquisa os estornos para desconsiderá-los
	Local vTam   := {}
	Local nTamA  := 0
	Local lRet   := .F.
	
	If lEstorno .Or. Empty(TBS->CT2_DTCV3) .Or. Left(TBS->CT2_ROTINA,3) == "GPE"
		Return lRet
	Endif
	
	CV3->(dbSetOrder(2))
	If lAchou := CV3->(dbSeek(TBS->CT2_FILIAL+AllTrim(Str(TBS->CT2_RECNO,10))))
		If lAchou := (CV3->CV3_DTSEQ == TBS->CT2_DATA .And. CV3->CV3_SEQUEN == TBS->CT2_SEQUEN)
			cTab    := Trim(CV3->CV3_TABORI)
			vReg[1] := (cTab)->(Recno())   // Salva o registro atual
			
			// Posiciona no registro da tabela de origem do lançamento
			(cTab)->(dbGoTo(Val(CV3->CV3_RECORI)))
			vReg[2] := (cTab)->(Recno())   // Salva o registro de origem
			vReg[3] := (cTab)->(Deleted()) // Identifica deleção
			
			// Re-posiciona no registro atual
			(cTab)->(dbGoTo(vReg[1]))
			
			// Se o registro for igual então a origem está correta
			If vReg[2] == Val(CV3->CV3_RECORI)
				If vReg[3] .Or. cTab == "SE5" .And. SE5->E5_SITUACA $ "CEX"   // Se estiver deletado ou Cancelado
					Return .T.
				Endif
			Endif
		Endif
	Endif
	
	If !lAchou
		CV3->(dbSetOrder(1))
		CV3->(dbSeek(TBS->(CT2_FILIAL+Dtos(CT2_DATA)+CT2_SEQUEN)))
	Endif
	
	If !Empty(CV3->CV3_KEY) .And. CV3->CV3_TABORI $ "SE2,SEV,SEZ,SD1,SF1"
		If CV3->CV3_TABORI $ "SE2,SEV,SEZ"
			// Cria vetor com campos e tamanhos antigos
			AAdd( vTam , { "E2_FILIAL" , 2})
			AAdd( vTam , { "E2_PREFIXO", 3})
			AAdd( vTam , { "E2_NUM"    , 6})
			AAdd( vTam , { "E2_PARCELA", 1})
			AAdd( vTam , { "E2_TIPO"   , 3})
			AAdd( vTam , { "E2_FORNECE", 6})
			AAdd( vTam , { "E2_LOJA"   , 2})
			
			cTab := "SE2"
		Else
			// Cria vetor com campos e tamanhos antigos
			AAdd( vTam , { "D1_FILIAL" , 2})
			AAdd( vTam , { "D1_DOC"    , 6})
			AAdd( vTam , { "D1_SERIE"  , 3})
			AAdd( vTam , { "D1_FORNECE", 6})
			AAdd( vTam , { "D1_LOJA"   , 2})
			AAdd( vTam , { "D1_COD"    ,15})
			AAdd( vTam , { "D1_ITEM"   , 4})
			
			cTab := "SD1"
		Endif
		
		// Calcula os o total de tamanhos antigos e novos
		aEval( vTam , {|x| nTamA += x[2] })
		
		cChave := AllTrim(CV3->CV3_KEY)
		
		If Len(cChave) == nTamA   // Se o tamanho for igual ao antigo
			nPos   := 0
			cChave := ""
			aEval( vTam , {|x| cChave += PADR(SubStr(CV3->CV3_KEY,nPos+1,x[2]),TamSX3(x[1])[1]), nPos += x[2] })
		Endif
		
		lRet  := !(cTab)->(dbSeek(cChave))
		lPesq := !lRet .And. lPesq   // Define se pesquisa se o lançamento foi estornado
	Endif
	
	If lPesq .And. (nPos:=AScan(vLP,{|x|x[1]==CT2_LP})) > 0   // Pesquisa um estorno para o lançamento
		cQry := "SELECT COUNT(*) AS TOTAL FROM "+RetSQLName("CT2")+" CT2 "
		cQry += " WHERE D_E_L_E_T_ = ' ' AND CT2_FILIAL = '"+CT2_FILIAL+"'"
		cQry += " AND CT2_DATA = '"+Dtos(CT2_DATA)+"' AND CT2_LOTE = '"+CT2_LOTE+"'"
		cQry += " AND CT2_CREDIT = '"+CT2_DEBITO+"'"
		cQry += " AND CT2_VALOR = "+AllTrim(Str(CT2_VALOR,14,2))
		cQry += " AND CT2_CCC = '"+CT2_CCD+"'"
		cQry += " AND CT2_ITEMC = '"+CT2_ITEMD+"'"
		cQry += " AND CT2_CLVLCR = '"+CT2_CLVLDB+"'"
		cQry += " AND CT2_KEY = '"+CT2_KEY+"'"
		cQry += " AND CT2_SEQUEN > '"+CT2_SEQUEN+"'"
		cQry += " AND CT2_LP = '"+vLP[nPos,2]+"'"
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery(cQry)), "TMPEST", .T., .F. )
		lRet := (TMPEST->TOTAL == 1)
		dbCloseArea()
		dbSelectArea(cAlias)
	Endif
	
Return !lEstorno .And. lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Função    ¦ TiposTit  ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 03/06/2009¦¦¦
¦¦+-----------+-----------+-------+------------------------+------+-----------+¦¦
¦¦¦ Descriçäo ¦ Pesquisa o tipo do titulo referente ao lançamento             ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function TiposTit(cLP)
	Local cRet := "E2_TIPO NOT IN ('INS','IRF','TX ','PIS')"
	
	If cLP $ "E01,E02,E03,E11,E13,E20,E22,H31,H37,H48,H49,H50,H55,H73"  // INSS
		cRet := "E2_TIPO = 'INS'"
	ElseIf cLP $ "E04,E51,H90"  // IRRF
		cRet := "E2_TIPO IN ('IRF','TX ')"
	ElseIf cLP $ "H09,H25,H32,H37,H83"  // FGTS
		cRet := "E2_TIPO = 'FGT'"
	Endif
	
Return cRet

/*Static Function GravaTemp()
	Local nX
	Local cAlias := Alias()
	
	RecLock("TMPAUD",.T.)
	For nX:=1 To FCount()
		FieldPut( nX , TBS->(FieldGet(nX)) )
	Next
	MsUnLock()
	dbSelectArea(cAlias)
	
Return*/
