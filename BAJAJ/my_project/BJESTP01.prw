#Include "Protheus.ch"
#Include "Prtopdef.ch"


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ BJESTP01   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/05/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Importação dos Kits para o Estoque                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function BJESTP01()
Local aSays    := {}
	Local aButtons := {}
	Local nOpcA    := 0
	Local cPerg    := "BJESTP01"
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
	
	AADD(aSays, "Processa a importação para o estoque os itens de um kit" )
	AADD(aSays, "de produto a partir de um documento de entrada." )
	
	cCadastro := "Importar Kit para o Estoque"
	
	AADD(aButtons, { 5, .T., {|x| Pergunte(cPerg,.T.)  } } )
	AADD(aButtons, { 1,.T.,{|o| nOpcA:=1, o:oWnd:End() } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	if nOpcA==1
		Processa({|| BJProcess() }, "Em Processamento...") 
	endif
Return


static Function BJProcess()
	Local nX
	Local lNumDI   := .F.
	Local aNotas   := {}
	Local aEstruct := {}
	Local cAlerta  := ""
	Local cErros   := ""
	Local nTotal    := 0
	
	/* ALTERADO POR: EDSON SALES 26/12/2024*/
	/* MUDANÇA NO PERGUNTE DI PARA LOTE */
	/* CONSULTA CRIADA PARA ATRAVES DO LOTE ENCONTRAR A DI CAMPO F1_XDI*/
    BeginSql Alias "QRY_SD1"
        SELECT
            SF1.F1_XDI 
        FROM
            %table:SD1% SD1
			inner join %table:SF1%  SF1 ON SD1.D1_FILIAL=SF1.F1_FILIAL 
						AND SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE=SF1.F1_SERIE
						AND SD1.D1_FORNECE=SF1.F1_FORNECE AND SD1.D1_LOJA=SF1.F1_LOJA
        WHERE SD1.%notDel%
            And SD1.D1_FILIAL = %xFilial:SD1%
            AND SD1.D1_LOTECTL = %exp:MV_PAR08%
		group by F1_XDI
    EndSql

	Count to nTotal

	("QRY_SD1")->(DBGOTOP())
	cDI := ("QRY_SD1")->(F1_XDI)

	If lNumDI := !Empty(cDI)
		SF1->(dbOrderNickName("NUMDI"))
	Else
		SF1->(dbSetOrder(1))
	Endif
	
	If SF1->(dbSeek(XFILIAL("SF1")+If(lNumDI,cDI,mv_par01+mv_par02+mv_par03+mv_par04)))
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(XFILIAL("SB1")+mv_par05))
			
			GetBN(mv_par05,mv_par06*mv_par07,aEstruct)
			
			If Empty(aEstruct)
				FWAlertError("Não existe estrutura cadastrada ou ativa para esse produto !")
				Return .F.
			Endif
			
			If mv_par06 > 0 .And. mv_par07 > 0
				aNotas := {}
				
				If lNumDI
					While !SF1->(Eof()) .And. SF1->F1_FILIAL+SF1->F1_XDI == XFILIAL("SF1")+cDI
						AAdd( aNotas , SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )
						SF1->(dbSkip())
					Enddo
				Else
					//CB0->(dbSetOrder(6))    // CB0_FILIAL+CB0_NFENT+CB0_SERIEE+CB0_FORNEC+CB0_LOJAFO+CB0_CODPRO
					//If !CB0->(dbSeek(XFILIAL("CB0")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
						AAdd( aNotas , SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )
					//Else
					//	FWAlertError("Documento de entrada já teve geração de kit realizado !")
					//Endif
				Endif
				ProcRegua(Len(aNotas))
				For nX:=1 To Len(aNotas)
					IncProc("Analisando os itens da nota e da estrutura: " + cValToChar(nX) + " de " + cValToChar(Len(aEstruct)) + "...")
					/* validSD1 : Criado 30/12/2024 -- Edson sales  verificar se item da D1 está na estrutura*/
					if validSD1(aNotas[nX],aEstruct,@cErros)
						Importar(aEstruct,aNotas[nX],@cAlerta,@cErros,nX==Len(aNotas))
					endif
				Next
				
				If Empty(cErros)
					If !Empty(cAlerta)
						FWAlertWarning("Existe itens na estrutura que não foram localizados na nota: <br />" + cAlerta)
					Endif
					GravaEtiqueta(aEstruct,lNumDI)
				Else
					FWAlertError("Ocorreram erros ao tentar importar o Kit: <br />" + cErros)
				Endif
			Else
				FWAlertError("Quantidades informadas não são válidas para geração de Kits !")
			Endif
		Else
			FWAlertError("O produto informado não existe !")
		Endif
	ElseIf lNumDI
		FWAlertError("Número da DI informado não existe na entrada de notas !")
	Else
		FWAlertError("Documento de entrada informado não existe na entrada de notas !")
	Endif
Return

Static Function Importar(aEstruct,cSeek,cAlerta,cErros,lUltimo)
	Local nX
	Local lCalcKit := .F.
	Local nQtdKit  := 0

	SD1->(dbSetOrder(1))   // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	For nX:=1 To Len(aEstruct)
		//Incrementa a mensagem na régua
		If aEstruct[nX,6] > 0    // Caso já tenha encontrado o item na nota
			Loop
		Endif
		
		If SD1->(dbSeek(XFILIAL("SD1")+cSeek+aEstruct[nX,1]))
			aEstruct[nX,3] := SD1->D1_QUANT - If( SD1->(FieldPos("D1_XQTDKIT")) > 0 , SD1->D1_XQTDKIT, 0)
			aEstruct[nX,4] := SD1->D1_LOCAL
			aEstruct[nX,5] := SD1->D1_ITEM
			aEstruct[nX,6] := SD1->(Recno())
		Endif
		
		If aEstruct[nX,6] == 0    // Caso não tenha encontrado o item
			If lUltimo
				cAlerta += "<br /><strong>Produto: </strong>" + Trim(aEstruct[nX,1]) + " - <strong>Situação: </strong>" + "Não localizado."
			Endif
		ElseIf aEstruct[nX,2] > aEstruct[nX,3]    // Caso não tenha saldo suficiente
			cAlerta  += "<br /><strong>Produto: </strong>" + Trim(aEstruct[nX,1]) + " - <strong>Situação: </strong>" + "Retirado do kit - Sem saldo."
			
			/* Alterado 30/12/2024 -- Edson sales  aEstruct[nX,7] SEM SALDO RECEBE -> .T.*/
			aEstruct[nX,7] := .T.

		Endif
	Next
	
	If Empty(cErros)
		If lCalcKit
			// Define a quantidade máxima do 1o item da estrutura
			While (aEstruct[1,2]*(nQtdKit+1)) <= aEstruct[1,3]
				nQtdKit++
			Enddo
			
			nX := 2
			While nQtdKit > 0 .And. nX <= Len(aEstruct)
				// Calcula a quantidade máxima de kits a serem gerados
				While nQtdKit > 0 .And. (aEstruct[nX,2]*nQtdKit) > aEstruct[nX,3]
					nQtdKit--
				Enddo
				nX++
			Enddo
			nX--
			
			If nQtdKit < 1    // Caso tenha zerado
				cErros += "<br /><strong>Produto: </strong>" + Trim(aEstruct[nX,1]) + " - <strong>Situação: </strong>" + "Sem saldo."
			Else
				aEval( aEstruct , {|x| x[2] *= nQtdKit } )    // Atualiza a quantidade a consumir do kit
			Endif
		Endif
	Endif
	
Return Empty(cErros)


/*/validSD1(aNotas,aEstruct)/*/
Static Function validSD1(cSeek,aEstruct,cErros)
	Local nY := 0 
	Local nPos
	Local nAtual := 0

	SD1->(dbSetOrder(1))   // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SD1->(DBGOTOP())

	If SD1->(dbSeek(XFILIAL("SD1")+cSeek))
		while !SD1->(eof()) .and. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==  XFILIAL('SD1')+ALLTRIM(cSeek)

			//Incrementa a mensagem na régua
			nAtual++
				For nY:=1 To Len(aEstruct)
					nPos := aScan(aEstruct[nY], {|x| AllTrim(x) == ALLTRIM(SD1->D1_COD)})

					if nPos > 0
						Exit
					EndIf

				Next nY

				if nPos > 0
					Return .T.
				else
					cErros += "<br /><strong>Produto: </strong>" + Trim(SD1->D1_COD) + " - <strong>Situação: </strong>" + "Não encontrado na Estrutura."
					Return .F.
				endif

			SD1->(dbSkip())
		endDo
	Endif	
Return 

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GetBN      ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 03/05/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de busca dos itens de beneficiamento da estrutura      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function GetBN(cProduto,nQuant,aBN)
	Local nReg := SG1->(Recno())
	Local cFil := XFILIAL("SG1")
	Local lRet := .F.
	
	Default aBN := {}
	
	SG1->(dbSetOrder(1))
	
	cProduto := AvKey(cProduto, 'G1_COD')

	If lRet := SG1->(dbSeek(cFil+cProduto,.T.))
			/* ALTERADO POR: EDSON SALES */
			/* G1_XKIT =='1' CONSIDERAR SOMENTES OS ITENS MARCADOS COM 1 = SIM NO CADASTRO DA ESTRUTURA */
		While !SG1->(Eof()) .And. SG1->G1_FILIAL+SG1->G1_COD == cFil+cProduto .and. SG1->G1_XKIT =='1'
			
			If dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM
				AddItemRet(SG1->G1_COMP,nQuant,@aBN)
				GetBN(SG1->G1_COMP,(SG1->G1_QUANT * nQuant) * ((100 + SG1->G1_PERDA) /100), @aBN)
			Endif
			
			SG1->(dbSkip())
		Enddo
	Endif
	SG1->(dbGoTo(nReg))
	
Return lRet

Static Function AddItemRet(cProduto,nQuant,aBN)
	Local nPos, lRet
	
	// Posiciona no produto
	SB1->(dbSetOrder(1))
	If lRet := SB1->(dbSeek(XFILIAL("SB1")+cProduto))
		// Se for Material de Beneficiamento e não for FANTASMA
		If lRet := (SB1->B1_FANTASM <> "S")
			//nPos := AScan( aBN , {|x| x[1] == cProduto })
			//If nPos == 0								//controlar o saldo
				AAdd( aBN , { cProduto, 0, 0, "", "", 0,.F.})
				nPos := Len(aBN)						
			//Endif
			aBN[nPos,2] += (SG1->G1_QUANT * nQuant / Max(1,SB1->B1_QB)) * ((100 + SG1->G1_PERDA) /100)
		EndIf
	Endif
	
Return lRet

Static Function GravaEtiqueta(aEstruct,lNumDI)
	Local nE, nK, lRet, oEtiqueta, oPallet, aItens, aPallet, aResp
	Local cErros := ""
	Local cEtiq  := GetMv("MV_CODCB0")
	
	For nK:=1 To mv_par06   // Quantidade de Kits a gerar
		//Incrementa a mensagem na régua
	
		aItens  := {}
		aPallet := {}
		For nE:=1 To Len(aEstruct)
			// Atualiza o saldo usados em kit							// aEstruct[nE,7] SE ESTIVER .T. ESTA SEM SALDO NÃO GRAVA ESTE ITEM
			If aEstruct[nE,6] == 0 .Or. SD1->(FieldPos("D1_XQTDKIT")) == 0 .Or. aEstruct[nE,7] 
				Loop
			Endif
			
			SD1->(dbGoTo(aEstruct[nE,6]))    // Posiciona no registro
			RecLock("SD1",.F.)
			SD1->D1_XQTDKIT += aEstruct[nE,2] / mv_par06
			MsUnLock()
			
			// Define numero da etiqueta
			CB0->(DbSetOrder(1))
			While CB0->(DbSeek(xFilial("CB0")+cEtiq))
				cEtiq := Soma1(cEtiq)
			Enddo
			
			// Posiciona no Cadastro do Produto
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFILIAL("SB1")+aEstruct[nE,1]))
			
			oEtiqueta := WMCEtiqueta():New()
			oEtiqueta:c2UM                 := ""
			oEtiqueta:cArmazem             := aEstruct[nE,4]
			oEtiqueta:cCodigoEtiqueta      := cEtiq
			oEtiqueta:cCodigoProduto       := SB1->B1_COD
			oEtiqueta:cDocEntrada          := SD1->D1_DOC
			oEtiqueta:cEtiquetaAlterada    := ""
			oEtiqueta:cFornecedor          := SD1->D1_FORNECE
			oEtiqueta:cItemDocEntrada      := aEstruct[nE,5]
			oEtiqueta:cLojaFornec          := SD1->D1_LOJA
			oEtiqueta:cLoteDestino         := ""
			oEtiqueta:cLoteFabricante      := ""
			oEtiqueta:cLoteFornecedor      := ""
			oEtiqueta:cLoteProduto         := ""  //if( SC2->(FieldPos("C2_XLOTE")) > 0, SC2->C2_XLOTE, "")
			oEtiqueta:cObservacao          := ""
			oEtiqueta:cOrdemProducao       := ""  //SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
			oEtiqueta:cSerieEntrada        := SD1->D1_SERIE
			oEtiqueta:cTipoEtiqueta        := "01"
			oEtiqueta:cTurnoEtiqueta       := ""
			oEtiqueta:dDataFabricacao      := date()
			oEtiqueta:dDataValidade        := DaySum(ddatabase,SB1->B1_PRVALID)
			oEtiqueta:lLoteTransferido     := .F.
			oEtiqueta:nPesoBrutoEtiqueta   := 0
			oEtiqueta:nPesoLiquidoEtiqueta := 0
			oEtiqueta:nQtd2UM              := 0
			oEtiqueta:nQtdDeEtiqueta       := 1
			oEtiqueta:nQtdPorEtiqueta      := aEstruct[nE,2] / mv_par06
			oEtiqueta:nTara1               := 0
			oEtiqueta:nTara2               := 0
			
			Private st_lMt103  := .T.
			Private st_lMt225  := .F.
			Private st_lMt226  := .F.
			Private st_lMt650  := .F.
			Private st_lMt250  := .F.
			Private st_lMtCB0A := .F.
			Private st_lWmsD14 := .F.
			
			lRet := u_XETQA01Y(oEtiqueta)
			If ValType(lRet) <> "L"
				lRet := .T.
			Endif
			
			If lRet    // Adiciona as etiquetas geradas
				AAdd( aPallet , cEtiq )
				AAdd( aItens  , SB1->B1_COD )
			Else
				cErros += If(Empty(cErros),"","<br />") + "<strong>Produto: </strong>"+Trim(SB1->B1_COD) + " - <strong>Erro: Erro na geração da etiqueta"
			Endif
		Next
		
		If !Empty(aPallet)
			//instancia o opallet
			oPallet := WMCPallet():New("")
			If oPallet:valido
				//vincula etiquetas ao pallet
				u_XWMCPLTA(@oPallet,aPallet,@aResp)
				
				If AScan( aResp , {|x| Trim(x[1]) <> "200" } ) > 0
					For nE:=1 To Len(aResp)
						If Trim(aResp[nE,1]) <> "200"
							cErros += If(Empty(cErros),"","<br />") + "<strong>Produto: </strong>"+Trim(aItens[nX,1]) + " - <strong>Erro: </strong>" + Trim(aResp[nE,2])
						Endif
					Next
				Else
					CB0->(DbSetOrder(1))
					If CB0->(DbSeek(xFilial("CB0")+oPallet:Etiqueta))
						RecLock("CB0",.F.)
						CB0->CB0_QTDE    := 1
						CB0->CB0_NFENT   := SD1->D1_DOC
						CB0->CB0_SERIEE  := SD1->D1_SERIE
						CB0->CB0_ORIGEM  := "SD1"
						CB0->CB0_SDOCE   := SD1->D1_SERIE
						CB0->CB0_FORNECE := SD1->D1_FORNECE
						CB0->CB0_LOJAFO  := SD1->D1_LOJA
						CB0->CB0_CODPRO  := mv_par05
						CB0->CB0_LOTE    := SD1->D1_LOTECTL
						MsUnLock()
					Endif
				Endif
			Else
				cErros += If(Empty(cErros),"","<br />") + "Erro na geração da etiqueta do kit " + LTrim(cValToChar(nK))
			Endif
		Endif
	Next
	
	If Empty(cErros)
		FWAlertSuccess("Gravação do kit concluída com sucesso !")
	Else
		FWAlertError("Erro(s) decorrente(s) da geração do Kit:<br /><br />"+cErros)
	Endif

Return

Static Function ValidPerg(cPerg)
	
	u_BJPutSX1(cPerg,"01",PADR("Numero da Nota             ",29)+"?","","","mv_ch1","C",TamSX3("F1_DOC"    )[1],0,0,"G","","SF1","","","mv_par01")
	u_BJPutSX1(cPerg,"02",PADR("Serie da Nota              ",29)+"?","","","mv_ch2","C",TamSX3("F1_SERIE"  )[1],0,0,"G","","   ","","","mv_par02")
	u_BJPutSX1(cPerg,"03",PADR("Fornecedor                 ",29)+"?","","","mv_ch3","C",TamSX3("F1_FORNECE")[1],0,0,"G","","SA2","","","mv_par03")
	u_BJPutSX1(cPerg,"04",PADR("Loja                       ",29)+"?","","","mv_ch4","C",TamSX3("F1_LOJA"   )[1],0,0,"G","","   ","","","mv_par04")
	u_BJPutSX1(cPerg,"05",PADR("Produto                    ",29)+"?","","","mv_ch5","C",TamSX3("B1_COD"    )[1],0,0,"G","","SB1","","","mv_par05")
	u_BJPutSX1(cPerg,"06",PADR("Quantidade de Kits a gerar ",29)+"?","","","mv_ch6","N",12                     ,0,0,"G","","   ","","","mv_par06")
	u_BJPutSX1(cPerg,"07",PADR("Quantidade de itens por Kit",29)+"?","","","mv_ch7","N",12                     ,0,0,"G","","   ","","","mv_par07")
	// u_BJPutSX1(cPerg,"08",PADR("Numero da DI               ",29)+"?","","","mv_ch8","C",TamSX3("F1_XDI"   )[1],0,0,"G","","    ","","","mv_par08")
	u_BJPutSX1(cPerg,"08",PADR("Numero do Lote               ",29)+"?","","","mv_ch8","C",TamSX3("D1_LOTECTL"   )[1],0,0,"G","","SD1","","","mv_par08")
	
Return
