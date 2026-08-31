#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ PMLOJP02   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 21/07/2010 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descrição ¦Processamento especifico para geracao do pedido de tranferencia¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function PMLOJP02()
	Local x, y, cLoja, cNumPed, cItem
	Local cAlias := Alias()
	Local aRegs  := {}
	Local cCNPJ  := "" //Alltrim(SM0->M0_CGC)  
	Private nDiaEnt := GetMv("MV_XDIAENT")

	QOUT("PASSOU PELA DECLARACAO")
	cCNPJ  := Alltrim(SM0->M0_CGC)   
	QOUT("PASSOU PELO CNPJ " + cCNPJ )
	DbSelectArea("SA1")
	SA1->(dbSetOrder(3))
	SA1->(dbSeek(XFILIAL("SA1")+cCNPJ))  
	qout("cliente "+SA1->A1_COD + " - CNPJ " + cCNPJ)

	// Pesquisa os itens marcados para reserva
	SL2->(dbSetOrder(1))
	SL2->(dbSeek(SL1->(L1_FILIAL+L1_NUM),.T.))  
	qout("ORCAMENTO "+SL1->L1_NUM)
	While !SL2->(Eof()) .And. SL1->(L1_FILIAL+L1_NUM) == SL2->(L2_FILIAL+L2_NUM)

		SF4->(dbSetOrder(1))
		SF4->(dbSeek(XFILIAL("SF4")+SL2->L2_TES))  
		qout("ENCONTORU A TES")
		If !Empty(SL2->L2_LOJARES) .And. SF4->F4_ESTOQUE == "S"
			SL2->(AAdd( aRegs , { L2_LOJARES, Recno() }))
		Endif
		qout("GRAVOU O ITEM "+SL2->L2_PRODUTO)
		SL2->(dbSkip())
	Enddo

	// Ordena o vetor de reservas por Loja + Produto
	ASort( aRegs ,,, {|x,y| x[1]+Str(x[2]*-1,10) < y[1]+Str(y[2]*-1,10) })
	QOUT("ORDENOU")

	// Efetua gravação da transferência
	x := 1
	While x <= Len(aRegs)

		Begin Transaction
			//	ALERT(GetSX8Num("SC5","C5_NUM","01SC5X"))                                                                                     
			// Se estiver atualizando o deposito, grava o cabeçalho do pedido
			cNumPed := GetSX8Num("SZ3","Z3_NUM") 
			GravaSZ3(cNumPed)
			QOUT("ACHOU A NUMERO DO PEDIDO LIVRE "+ cNumPed)
			cLoja   := aRegs[x,1]
			cItem   := StrZero(0,Len(SC6->C6_ITEM))

			GeraPedido(cNumPed,"C") // Grava o cabeçalho
			QOUT("GRAVOU O CABECALHO DO PEDIDO "+cNumPed)	
			While x <= Len(aRegs) .And. cLoja == aRegs[x,1]
				SL2->(dbGoTo(aRegs[x,2]))   // Posiciona no item encontrado

				SB1->(dbSetOrder(1))
				SB1->(dbSeek(XFILIAL("SB1")+SL2->L2_PRODUTO))

				GeraPedido(cNumPed,"I",@cItem) // Grava os itens
				QOUT("GRAVOU O ITEM "+SL2->L2_PRODUTO)

				//Grava o numero do pedido no orçamento
				RecLock("SL2",.F.)
				SL2->L2_XPDTRAN := cNumPed
				MsUnLock()

				x++
			Enddo  

			ConfirmSX8()

		End Transaction

	Enddo
	dbSelectArea(cAlias)

Return       

Static Function GravaSZ3(cNumPed)
	RecLock("SZ3",.T.) 
	SZ3->Z3_FILIAL := xFilial("SZ3")
	SZ3->Z3_NUM    := cNumPed   
	SZ3->Z3_FILORI := SL1->L1_FILIAL
	SZ3->Z3_NUMORC := SL1->L1_NUM
	MsUnlock()
Return 


Static Function GeraPedido(cNumPed,cOpc,cItem)
	Local lLibera, nQtdLib, nQtdLib2, lCredito, lEstoque, cTES
	Local aDadosCfo := {}

	If cOpc == "I"
		// Se TES de saída de transferência tiver preenchido e for isento

		cTES := GetMv("MV_XTESTRA")   // TES de Saida p/ a Filial

		AAdd( aDadosCfo , { "OPERNF"  , "S"           })
		AAdd( aDadosCfo , { "TPCLIFOR", SA1->A1_TIPO  })
		AAdd( aDadosCfo , { "UFDEST"  , SA1->A1_EST   })
		AAdd( aDadosCfo , { "INSCR"   , SA1->A1_INSCR })

		SF4->(dbSetOrder(1))
		SF4->(dbSeek(XFILIAL("SF4")+cTES))

		RecLock("SC6",.T.)
		SC6->C6_FILIAL  := XFILIAL("SC6")
		SC6->C6_ITEM    := (cItem:=Soma1(cItem,Len(SC6->C6_ITEM)))
		SC6->C6_NUM     := cNumPed
		SC6->C6_PRODUTO := SL2->L2_PRODUTO
		SC6->C6_UM      := SB1->B1_UM
		SC6->C6_QTDVEN  := SL2->L2_QUANT
		SC6->C6_PRCVEN  := SL2->L2_VRUNIT
		SC6->C6_VALOR   := SC6->C6_QTDVEN * SC6->C6_PRCVEN
		SC6->C6_TES     := cTES
		SC6->C6_LOCAL   := "01"
		SC6->C6_CF      := MaFisCfo(,SF4->F4_CF,aDadosCfo)
		SC6->C6_CLI     := SA1->A1_COD
		SC6->C6_LOJA    := SA1->A1_LOJA
		SC6->C6_DESCRI  := SB1->B1_DESC
		SC6->C6_PRUNIT  := SC6->C6_PRCVEN
		SC6->C6_OP      := "02"
		SC6->C6_TPOP    := "F"
		SC6->C6_QTDLIB  := SC6->C6_QTDVEN        // Quantidade a liberar
		SC6->C6_ENTREGA := DDATABASE+nDiaEnt

		MsUnLock()

	ElseIf cOpc == "C"
		RecLock("SC5",.T.)
		SC5->C5_FILIAL  := XFILIAL("SC5")
		SC5->C5_NUM     := cNumPed
		SC5->C5_TIPO    := "N"
		SC5->C5_CLIENTE := SA1->A1_COD
		SC5->C5_LOJACLI := SA1->A1_LOJA
		SC5->C5_LOJAENT := SA1->A1_LOJA
		SC5->C5_TRANSP  := " "
		SC5->C5_TIPOCLI := SA1->A1_TIPO
		SC5->C5_CONDPAG := "001"         // Transferência
		SC5->C5_TABELA  := ""
		SC5->C5_VEND1   := SL1->L1_VEND
		SC5->C5_EMISSAO := dDataBase
		SC5->C5_MOEDA   := 1
		SC5->C5_TIPLIB  := "1"
		SC5->C5_TXMOEDA := 1  
		SC5->C5_OBS1	 := SL1->L1_XOBS
		SC5->C5_GERAWMS := "1"
		SC5->C5_TPCARGA := "2"
		SC5->C5_DCR     := "N"
		SC5->C5_XFILRES := SL1->L1_FILIAL        // Filial que efetuou a reserva
		SC5->C5_XORCRES := SL1->L1_NUM           // Orçamento com reserva

		MsUnLock()
	EndIf
Return
