#Include "rwmake.ch"

User Function VSalProd()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função executada através do ExecBlock LR_QUANT - 002
OBJETIVO 1: Bloquear realização de orçamentos com Produtos que a quantidade informada seja maior que a soma das quantidade em outros orçamentos
OBJETIVO 2: Criar uma reserva para imprimir o COMPROVANTE FISCAL quando for SERVIÇO
OBJETIVO 3: Verifica se o Produto usa Metros x Quantidades, caso positivo somente pela tela de Pesquisa CTRL+I
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

Local cUsaReserva   := GETMV("MV_USARESE")   		// Controle de Reserva da PILOTO
Local nQtdOrc 		:= u_SaldoOrc(M->LR_PRODUTO) 	// Função que soma a quantidade de produtos com Orcamentos em abertos e NÃO vencidos
Local nQuant  		:= M->LR_QUANT
Local nReserva      := Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_RESERVA"})
Local nLojaRes      := Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_LOJARES"})
Local nColUm        := AScan( aHeader , {|x| Trim(x[2]) == "LR_UM" })

Public  nLastKe2    := 0

DbSelectArea("SB2")
DbSetOrder(1)

If cUsaReserva == "S"  // Caso seja SIM controla a reserva dos itens
	
	If SB2->(DbSeek(xFilial("SB2")+M->LR_PRODUTO))
		
		If SB2->B2_QATU < (nQtdOrc+M->LR_QUANT) // Quantidade em Estoque é menor que a soma de orçamento em aberto e a quant. informada pelo usuário
			
			nQtdDisp := SB2->B2_QATU - nQtdOrc // Quantidade disponível para venda
			
			// Verifica se o usuário SUPERIOR pode liberar a quantidade digitada para venda
			If ! MsgNoYes("Qtd disponivel devido orcamentos em abertos: "+Transform(nQtdDisp,"@E 999,999,999.99")+", Deseja senha superior? ")
				nQuant := 0
			Else
				Do While nLastKe2 == 0
					lRet := u_SenhaSup("VSALPROD",Space(06)) // Senha para liberar a quantidade digitada mesmo havendo saldo em orçamentos em abertos - LJ7018.PRW
				EndDo
				
				If lRet
					nQuant := M->LR_QUANT
				Else
					nQuant := 0
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
Endif                      

// OBJETIVO 2: Cria uma Reserva para imprimir um COMPROVANTE FISCAL DE SERVIÇO
If AllTrim(Acols[n][nColUM]) == "SV"
	AcolsDet[n][nReserva]    := M->LQ_NUM
	AcolsDet[n][nLojaRes]    := "000002" 
EndIf

//OBJETIVO 3: Verifica se o Produto usa Metros x Quantidades, caso positivo somente pela tela de Pesquisa CTRL+I
SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+M->LR_PRODUTO))
   If SB1->B1_USAMTS == "S" 
      Aviso("ATENÇÃO","Para informar a quantidade utilize a Tela de Pesquisa 'CTRL+I'. B1_USAMTS='S'",{"OK"},2)
      nQuant := 0
   EndIf
EndIf

Return(nQuant)



