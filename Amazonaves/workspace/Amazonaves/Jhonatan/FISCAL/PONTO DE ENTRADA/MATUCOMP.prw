#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MATUCOMP   ¦ Autor ¦ Jhonatan S. Lobato   ¦ Data ¦ 02/05/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para Complementar os Documentos Fiscais      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MATUCOMP()
	Local lInclui   := .F.
	//Local Inclui    := .T.
	Local lGravou   := .F.
	Local cEntSai   := ParamIXB[1] // E=Entrada ou S=Saida
	Local cSerie    := ParamIXB[2] // Serie do documento fiscal
	Local cDoc      := ParamIXB[3] // Numero do documento
	Local cCliefor  := ParamIXB[4] // Cliente/Fornecedor
	Local cLoja     := ParamIXB[5] // Loja do Cliente/Fornecedor
	Local cEstFor	:= ""
	Local lDeleta   := !Inclui .AND. !Altera
	
	If cEntSai == "S"   // Não processar os documentos de saída
		Return
	Endif

	SA2->(dbSetOrder(1))
	SA2->(dbSeek(XFILIAL("SA2")+cClieFor+cLoja,.T.))
	cEstFor += SA2->A2_EST

	If !cEstFor == "EX"   // Não processar se o Fornecedor nao for do Exterior
		Return
	Endif
	
	CDT->(dbSetOrder(1))
	CD5->(dbSetOrder(1))    // CD5_FILIAL+CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA+CD5_DOCIMP+CD5_NADIC                                                                                           
	
	// customizações do cliente, deve ser adequadas as regras do cliente
	If !lDeleta
		// Pesquisa os itens do documento de entrada

		SD1->(dbSetOrder(1))
			SD1->(dbSeek(XFILIAL("SD1")+cDoc+cSerie,.T.))
			While !SD1->(Eof()) .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE == XFILIAL("SD1")+cDoc+cSerie

				If SD1->D1_TOTAL == 0
					SD1->(dbSkip())
					Loop
				Endif

				SF1->(dbSetOrder(1))
				SF1->(dbSeek(XFILIAL("SF1")+cDoc+cSerie,.T.))
				While !SF1->(Eof()) .And. SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE == XFILIAL("SF1")+cDoc+cSerie
			
					If Empty(SF1->F1_XNDI)
						SF1->(dbSkip())
						Loop
					Endif

					If !Empty(SF1->F1_XNDI)
						nDi := SF1->F1_XNDI   // Numero da DI
					Endif
												
					If !Empty(nDi)
						lGravou := .T.
						lInclui := !CD5->(dbSeek(xFilial("CD5")+cDoc+cSerie+cClieFor+cLoja+SF1->F1_XNDI+SF1->F1_XNADIC))
					
						RecLock("CD5",lInclui)
						CD5->CD5_FILIAL := xFilial("CD5")
						CD5->CD5_DOC    := cDoc
						CD5->CD5_SERIE  := cSerie
						CD5->CD5_ESPEC  := SF1->F1_ESPECIE
						CD5->CD5_FORNEC := cClieFor
						CD5->CD5_LOJA   := cLoja
						CD5->CD5_TPIMP	:= "0"
						CD5->CD5_DOCIMP := nDi
						CD5->CD5_LOCAL  := "0"
						CD5->CD5_NDI	:= nDi
						CD5->CD5_DTDI   := SF1->F1_XDTDI
						CD5->CD5_LOCDES := SF1->F1_XLOCDE
						CD5->CD5_UFDES  := SF1->F1_XUFDES
						CD5->CD5_DTDES  := SF1->F1_XDTDES
						CD5->CD5_CODEXP	:= cClieFor
						CD5->CD5_LOJEXP	:= cLoja
						CD5->CD5_NADIC	:= SF1->F1_XNADIC
						CD5->CD5_SQADIC := SF1->F1_XSQADI
						CD5->CD5_CODFAB := cClieFor
						CD5->CD5_LOJFAB	:= cLoja
						CD5->CD5_ITEM 	:= SD1->D1_ITEM
						CD5->CD5_VTRANS := SF1->F1_XVTRAN
						CD5->CD5_INTERM := SF1->F1_XINTER
						CD5->CD5_SDOC   := cSerie
						MsUnLock()
					Endif

					SF1->(dbSkip())
				Enddo

				SD1->(dbSkip())
			Enddo
		
		If lGravou
			lInclui := !CDT->(dbSeek(xFilial("CDT")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
			
			RecLock("CDT",lInclui)
			CDT->CDT_FILIAL := xFilial("CDT")
			CDT->CDT_TPMOV  := cEntSai
			CDT->CDT_DOC    := cDoc
			CDT->CDT_SERIE  := cSerie
			CDT->CDT_CLIFOR := cClieFor
			CDT->CDT_LOJA   := cLoja
			CDT->CDT_SDOC	:= cSerie
			CDT->CDT_DTAREC := dDataBase
			//CDT->CDT_IFCOMP := "000001"
			MsUnLock()
			
			/*lInclui := !CDF->(dbSeek(xFilial("CDF")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
			
			RecLock("CDF",lInclui)
			CDF->CDF_FILIAL := xFilial("CDF")
			CDF->CDF_TPMOV  := cEntSai
			CDF->CDF_DOC    := cDoc
			CDF->CDF_SERIE  := cSerie
			CDF->CDF_CLIFOR := cClieFor
			CDF->CDF_LOJA   := cLoja
			CDF->CDF_IFCOMP := "000001"
			MsUnLock()*/
		Endif
	Else
		While CDT->(dbSeek(xFilial("CDT")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
			RecLock("CDT",.F.)
			DbDelete()
			MsUnLock()
		Enddo
		
		While CD5->(dbSeek(xFilial("CD5")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
			RecLock("CD5",.F.)
			DbDelete()
			MsUnLock()
		Enddo
		
		/*While CDF->(dbSeek(xFilial("CDF")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
			RecLock("CDF",.F.)
			DbDelete()
			MsUnLock()
		Enddo*/
	EndIf

 Return
