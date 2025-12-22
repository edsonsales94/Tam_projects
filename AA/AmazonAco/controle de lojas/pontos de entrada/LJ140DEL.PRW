#Include "rwmake.ch"

User Function LJ140DEL()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto de entrada executdo na confirmação da Exclusão do Cupom Fiscal/Comprovante de Venda
OBJETIVO 1: Deletar os títulos no CR quando o cancelamento for de um comprovante de venda
OBJETIVO 2: Excluir a venda no Controle de Entrega
OBJETIVO 3: Estornar a Movimentação Interna, no caso de TRANSFERÊNCIA entre Lojas
OBJETIVO 4: Excluir o PV gerado pela Venda Assistida
OBJETIVO 5: Retornar o TES de Entrega quando for venda com Transferência para não atualizar o estoque na exclusão
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

DbSelectArea("SL1")

DbSelectArea("SE1")
DbSetOrder(1)

DbSelectArea("SE5")
DbSetOrder(7)

nRecSE1 	:= SE1->(RecNO())
nRecSE5 	:= SE5->(RecNO())
lJaEstorno 	:= .T.

If !Empty(SL1->L1_DOCPED)
	
	cDoc 	:= SL1->L1_DOCPED
	cSerie  := SL1->L1_SERPED
	
	If SE1->(DbSeek(xFilial("SE1")+cSerie+cDoc))
		
		Do While !SE1->(Eof()) .And. xFilial("SE1")+cSerie+cDoc == SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)
			
			Begin Transaction
			
			If SE5->(DbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA))
				
				Do While !SE5->(Eof()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == ;
					SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA)
					
					RecLock("SE5")
					SE5->(DbDelete())
					MsUnLock()
					
					SE5->(DbSkip())
					
				EndDo
				
			Endif
			
			RecLock("SE1")
			SE1->(DbDelete())
			MsUnLock()
			
			End Transaction
			
			SE1->(DbSkip())
			
		EndDo
		
	EndIf
	
Endif

SE1->(DbGoto(nRecSE1))
SE5->(DbGoto(nRecSE5))


//OBJETIVO 2: Excluir a venda no Controle de Entrega

//OBJETIVO 3: Estorna a Movimentação Interna, no caso de TRANSFERÊNCIA entre Lojas      

//Estorna Movimentação Interna de Entrada da Filial que vendeu a Mercadoria 

If !Empty(SL1->L1_DOCDE0)
	
	SD3->(DbSetOrder(2))
	
	If SD3->(DbSeek(xFilial("SD3")+SL1->L1_DOCDE0))
		
		lJaEstorno := .T.
		
		If SD3->D3_ESTORNO <> "S"   // Verifica se a mov. interna já foi estornada pelo SF2460I.prw, caso positivo, desconsiderar
			
			// Estornar todos os documentos de Entrada na Filial Destino, devido a EXCLUSÃO NF de Venda
			Do While !SD3->(Eof()) .And. xFilial("SD3") == SD3->D3_FILIAL .And. SD3->D3_DOC == SL1->L1_DOCDE0
				
				Begin Transaction
				RecLock("SD3")
				SD3->D3_ESTORNO := "S"
				MsUnLock()
				
				End Transaction
				
				SD3->(DbSkip())
				
			EndDo

			lJaEstorno := .F.
			
		EndIf
		
		RecLock("SL1")
		SL1->L1_DOCDE0  := Space(09)
		MsUnLock()
		
	Endif
	
EndIf

//Estorna Movimentação Interna de Saída da Filial que a Mercadoria saiu fisicamente
If !Empty(SL1->L1_DOCRE0)
	
	SD3->(DbSetOrder(2))
	
	If SD3->(DbSeek(SL1->L1_ENTBRAS+SL1->L1_DOCRE0))
		
		lJaEstorno := .T.
		
		If SD3->D3_ESTORNO <> "S"   // Verifica se a mov. interna já foi estornada pelo SF2460I.prw, caso positivo, desconsiderar
			
			// Estornar todos os documentos de Entrada na Filial Destino, devido a EXCLUSÃO NF de Venda
			Do While !SD3->(Eof()) .And. SL1->L1_ENTBRAS == SD3->D3_FILIAL .And. SD3->D3_DOC == SL1->L1_DOCRE0
				
				Begin Transaction
				RecLock("SD3")
				SD3->D3_ESTORNO := "S"
				MsUnLock()
				
				If SB2->(dbSeek(SL1->L1_ENTBRAS+SD3->D3_COD+SD3->D3_LOCAL))
		
					RecLock("SB2",.F.)  
		
					If Left(SD3->D3_CF,2) == "RE"   		// Somente na Filial de Saída da Mercadoria ajusta o Saldo em Estoque e o Custos
						SB2->B2_QATU    += SD3->D3_QUANT
					Endif
		
					SB2->B2_VATU1   := SB2->B2_QATU * SB2->B2_CM1
					MsUnLock()
				Endif
				
				End Transaction
				
				SD3->(DbSkip())
				
			EndDo

			lJaEstorno := .F.
			
		EndIf
		
		RecLock("SL1")
		SL1->L1_DOCRE0  := Space(09)
		MsUnLock()
		
	Endif
	
EndIf

//OBJETIVO 4: Excluir o PV gerado pela Venda Assistida

SC6->(dbSetOrder(1))
SC5->(dbSetOrder(1))
SC9->(dbSetOrder(1))
SB2->(dbSetOrder(1))

Begin Transaction

If SC5->(DbSeek(SL1->L1_ENTBRAS+SL1->L1_PEDRES))
	
	RecLock("SC5")
	SC5->(DbDelete())
	MsunLock()
	
	// Caso o Orçamento esteja relacionado a um PV, deleta o Pedido de venda e seus itens
	If SC6->(DbSeek(SL1->L1_ENTBRAS+SL1->L1_PEDRES))
		
		Do While !SC6->(Eof()) .And. SC6->(C6_FILIAL+C6_NUM) = SL1->(L1_ENTBRAS+L1_PEDRES)
			
			RecLock("SC6")
			SC6->(DbDelete())
			MsunLock()
			
			SC6->(DbSkip())
			
		EndDo
		
		If SC9->(DbSeek(SL1->L1_ENTBRAS+SL1->L1_PEDRES))  // verifica se o PV está Liberado para Faturar, caso afirmativo deletar a Liberação
			
			Do While !SC9->(Eof()) .And. SC9->(C9_FILIAL+C9_PEDIDO) = SL1->(L1_ENTBRAS+L1_PEDRES)
				
				RecLock("SC9")
				SC9->(DbDelete())
				MsunLock()
				
				SC9->(DbSkip())
				
			EndDo
			
		EndIf
		
	Endif
	
	RecLock("SL1")
	SL1->L1_PEDRES  := Space(06)
	MsUnLock()
	
EndIf

//OBJETIVO 5: Retornar o TES de Entrega quando for venda com Transferência para não atualizar o estoque na exclusão

nRecSL2	:= SL2->(RecNo())

If SL2->(DbSeek(xFilial("SL2")+SL1->L1_NUM))
	
	nIndSD2 := SD2->(IndexOrd())
	nRecSD2	:= SD2->(RecNo())
	
	Do While !SL2->(Eof()) .And. SL2->(L2_FILIAL+L2_NUM) == SL1->(L1_FILIAL+L1_NUM)
		
	/*	If SL2->L2_ENTBRAS <> SubStr(cNumEmp,3,2)							// Neste item foi realizado venda com Transferência, neste caso
			// deverá retornar o TES de Venda com Transferência devido o Saldo em Estoque
			cTES   		:= GETMV("MV_LJOUTLJ")   						// TES utilizado na Venda de outra Loja
			SF4->(DbSeek(xFilial("SF4")+cTES))
			
			RecLock("SL2")
			SL2->L2_TES 	:= cTES
			SL2->L2_CF  	:= SF4->F4_CF
			MsUnLock()
			
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(xFilial("SD2")+SL2->L2_DOC+SL2->L2_SERIE+SL1->L1_CLIENTE+SL1->L1_LOJA+SL2->L2_PRODUTO+SL2->L2_ITEM))
				
				RecLock("SD2")
				SD2->D2_TES := SL2->L2_TES							// TES de Venda com Transferência, devido o Saldo em Estoque
				SD2->D2_CF  := SL2->L2_CF							// 	CFOP
				MsUnLock()
				
				If lJaEstorno           							// Somente se foi estornado pelo SF2460i, senão irá ajustar em duplicida na filial solicitante	
					
					If SB2->(dbSeek(XFILIAL("SB2")+SD2->D2_COD+SD2->D2_LOCAL))	
						RecLock("SB2",.F.)
						SB2->B2_QATU    += SD2->D2_QUANT
						SB2->B2_VATU1   := SB2->B2_QATU * SB2->B2_CM1
						MsUnLock()
					EndIf
					
				Endif
				
			Endif
			
		EndIf */
		
		SL2->(DbSkip())
		
	EndDo
	
	SD2->(DbSetOrder(nIndSD2))
	SD2->(DbGoto(nRecSD2))
	
EndIf

DbGoto(nRecSL2)

End Transaction


Return()
