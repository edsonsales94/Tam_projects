#Include "rwmake.ch"

User Function TabPreco()

/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função de Recalculo de Preços de acordo com a Tabela definida LQ_PRCTAB - Acionada no Gatilho LQ_PRCTAB - 001
OBJETIVO 1: Para recalcular a preço de venda na Venda Assistida
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

Local nPosQuant		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_QUANT"})][2]				// Posicao da Quantidade
Local nPosProd		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_PRODUTO"})][2]			// Posicao da codigo do produto
Local nPosVlDesc	:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_VALDESC"})][2]			// Posicao do percentual de descontoLocal nPosPrcTab	:= Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_PRCTAB"})						// Posicao do Preco de Tabela
Local nPosDesc		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_DESC"})][2]				// Posicao do percentual de descontoLocal nPosPrcTab	:= Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_PRCTAB"})						// Posicao do Preco de Tabela
Local nPosUnit		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_VRUNIT"})][2]				// Posicao do Valor Unitário
Local nPosVlItem	:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_VLRITEM"})][2]			// Posicao do Valor Total
Local nPosPrcTab	:= Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_PRCTAB"})						// Posicao do Preco de Tabela
Local nPosTabela	:= Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_TABELA"})						// Posicao da Tabela
Local nPosBaseICM   := Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_BASEICM"})						// Posicao da Base de ICMS
Local nTotal 		:= 0

DbSelectArea("SB0")
nIndSB0 := IndexOrd()
DbSetOrder(1)

DbSelectArea("SA1")
nIndSA1 := IndexOrd()
DbSetOrder(1)
SA1->(DbSeek(xFilial("SA1")+M->LQ_CLIENTE+M->LQ_LOJA))
cTipo := Alltrim(SA1->A1_TIPO)

nDecimais 	:= 2
nDesc 		:= 0

If Len(Acols) > 0 
	
	For I:=1 to Len(Acols)
		
		If !Empty(Acols[I][nPosProd])   														// Verifica se há produto definido
			
			If ! Acols[I,Len(Acols[I])] 														// Se a linha não estiver deletado
				
				SB0->(DbSeek(xFilial("SB0")+Acols[I][nPosProd],.T.)) 							// Pesquisa o Produto na Tabela de Preços
				
				nPreco := &("SB0->B0_PRV"+M->LQ_PRCTAB)     									// Recebe o preco da tabela escolhida
				Acols[I][nPosQuant]     := Iif(Acols[I][nPosQuant] > 0,Acols[I][nPosQuant],0)   // Recebe a quantidade já definida para multplicar pelo valor da tabela escolhida.
				Acols[I][nPosUnit] 		:= nPreco												// Preco Unitario 
				MaFisAlt("IT_PRCUNI"	,aCols[I][nPosUnit],I)									// Altera o Valor Unitário
				Acols[I][nPosVlItem]	:= Acols[I][nPosQuant]*Acols[I][nPosUnit]               // Calcula o valor do Total do Item
				MaFisAlt("IT_VALMERC"	,aCols[I][nPosVlItem],I)								// Altera o Valor Total do Item
				
				AcolsDet[I][nPosTabela]	:= M->LQ_PRCTAB											// Atualiza a nova tabela de preço nos Detalhes
				AcolsDet[I][nPosPrcTab]	:= Acols[I][nPosUnit]                                   // Atualiza o novo preço de venda nos Detalhes	
				M->LR_PRCTAB 			:= aColsDet[I][nPosPrcTab]								// Atualiza a variável de memóra 
				
				If cTipo == "L"	 // F O R A    DE   U S O 																// PRODUTOR RURAL
//					nDesc := u_VDesc(I,nPosProd) 												// Verifica o %Desconto, caso seja PRODUTOR RURAL - FUNCOES GENERICAS.PRW
				EndIf
				
				aCols[I][nPosUnit] := NoRound(aColsDet[I][nPosPrcTab]-((aColsDet[I][nPosPrcTab] * nDesc)/100),nDecimais) 	// Recalcula o valor unitario - o desconto
				M->LR_VRUNIT := aCols[I][nPosUnit]                                              							// Atualiza a variável de memória
				aCols[I][nPosVlDesc] := Round((aColsDet[I][nPosPrcTab]*aCols[I][nPosQuant])* nDesc/100,nDecimais)  			// Recalcula o valor do desconto
				M->LR_VALDESC := aCols[I][nPosVlDesc]                                                                       // Atualiza a varável de memória
				aCols[I][nPosVlItem] := Round(aColsDet[I][nPosPrcTab]*aCols[I][nPosQuant],nDecimais)-aCols[I][nPosVlDesc]   // Recalcula o valor do item
				M->LR_VLRITEM := aCols[I][nPosVlItem]																		// Atualiza a varável de memória
				
				If MaFisFound("IT",I)    // Fazendo recalculo de impostos
					MaFisAlt( "IT_PRCUNI" , aCols[I][nPosUnit] , I )     	// Altera o novo valor unitário
					MaFisAlt( "IT_DESCONTO" , aCols[I][nPosVlDesc] , I )    // Aletra o valor do desconto
				EndIf
				
				nTotal 					+= Acols[I][nPosVlItem]             // Soma o valor total do Orçamento
				Acols[I][nPosDesc]		:=	nDesc                           // Recebe o % do Desconto
				
			EndIf
			
		EndIf
		
	Next
	
	u_RecRodape(nTotal)   	// Recalcula o Rodape da Tela da Venda Assistida - FUNCOES GENERICAS.PRW
	
EndIf

Lj7SetPicture() 			// Atualiza a Picture considerando a nova moeda da venda

Eval(bRefresh) 				// Refresh no Browse dos Itens na Venda Assistida

Return(M->LQ_PRCTAB)



