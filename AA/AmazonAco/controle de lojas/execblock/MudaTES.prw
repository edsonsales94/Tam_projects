#Include "rwmake.ch"

/*/
---------------------------------------------------------------------------------------------------------------------------------------------------
ExecBlock executado LR_ENTBRAS para definir a Loja que a mercadoria irá sair fisicamente - TRANSFERÊNCIA ENTRE LOJAS NA VENDA ASSISTIDA
OBJETIVO 1: Modificar o TES de acordo com a Loja definida pelo usuário
----------------------------------------------------------------------------------------------------------------------------------------------------
/*/

User Function MudaTES()

nProduto 	:= Ascan(aHeader	,{|x|Alltrim(x[2]) == "LR_PRODUTO"	})
nQuant	 	:= Ascan(aHeader	,{|x|Alltrim(x[2]) == "LR_QUANT"	})
nEntBRAS 	:= Ascan(aHeader	,{|x|Alltrim(x[2]) == "LR_ENTBRAS"	})
nTES 		:= Ascan(aPosCpoDet	,{|x|Alltrim(x[1]) == "LR_TES"		})
nCF 		:= Ascan(aPosCpoDet	,{|x|Alltrim(x[1]) == "LR_CF"		})

cTES   			:= IIf(Empty(SB1->B1_TS),GETMV("MV_TESSAI"),SB1->B1_TS)  	 			// TES PADRÃO DO SISTEMA
lFilialCorrente := .T.

nRecSB2 := SB2->(RecNo())

If SB1->(DbSeek(xFilial("SB1")+Acols[N][nProduto]))
	
	If SB1->B1_LJVENDA $ "  #ZZ" .Or. Acols[N][nEntBRAS] == SB1->B1_LJVENDA 		// Verifica se o produto pode ser vendido de outra Loja que não a Atual do sistema
		
		If Acols[N][nEntBRAS] <> SubStr(cNumEmp,3,2)								// Caso seja uma Venda de outra Loja
			
			If !Empty(SB1->B1_LJVENDA) 												// Verifica se o campo que define a LJ que pode vender está preenchido
				
				If SB2->(DbSeek(Acols[N][nEntBRAS]+Acols[N][nProduto]+Acols[N][nEntBRAS]))
					
					// Verifica se há Saldo em Estoque suficiente para realizar a Venda no almoxarifado informado
					If ( SB2->B2_QATU - (SB2->B2_QEMP+SB2->B2_RESERVA) ) < Acols[N][nQuant]
						MsgAlert("Não há saldo suficiente na Filial "+Acols[N][nEntBRAS]+" para realizar a venda !!!","ATENÇÃO")
						Acols[N][nQuant]	:= 0
					Else
						If Acols[N][nEntBRAS] <> SubStr(cNumEmp,3,2)   		   		// Verifica se a Venda é na Filial corrente ou em outra Filial
							
							cTES   		:= GETMV("MV_LJOUTLJ")   					// TES utilizado na Venda de outra Loja C/ FIN e S/ ESTOQUE
							lFilialCorrente := .F.
							
							If SF4->(DbSeek(xFilial("SF4")+cTES))
								AcolsDet[N][nTES] := cTes							// Modifica o TES quando a Mercadoria for entregue por outra Loja
								AcolsDet[N][nCF]  := SF4->F4_CF						// Modifica o CF quando a Mercadoria for entregue por outra Loja
							Else
								If ! lFilialCorrente
									MsgAlert("Favor criar o TES informado no parametro MV_LJOUTLJ, Estoque = 'N', Duplicata = 'S'  ","ATENÇÃO")
								Endif
								cTES := AcolsDet[N][nTES]
							EndIf
							
						Else
							
							If SF4->(DbSeek(xFilial("SF4")+cTES))
								AcolsDet[N][nTES] := cTes              				// TES padrão de Venda, informado no Produto ou MV_TESSAI
								AcolsDet[N][nCF]  := SF4->F4_CF 					// CF pertencente ao TES padrão
							EndIf
							
						EndIf
						
					Endif
					
				Else
					MsgAlert("Não há saldo suficiente na Filial "+Acols[N][nEntBRAS]+" para realizar a venda !!!","ATENÇÃO")
					Acols[N][nQuant] 	:= 0
					AcolsDet[N][nTES] 	:= cTes
				EndIf
				
			Else
				// Caso esteja vazio, somente pode vender da loja atual do sistema
				Aviso("Parâmetro", "Informar no cadastro de Produto qual a Loja que poderá realizar a venda, no campo LJ VENDA? !!!", {"Ok"}, 2)
				Acols[N][nEntBRAS]  := SubStr(cNumEmp,3,2)
				Acols[N][nQuant] 	:= 0
				
				If SF4->(DbSeek(xFilial("SF4")+cTES))
					AcolsDet[N][nTES] := cTes              				// TES padrão de Venda, informado no Produto ou MV_TESSAI
					AcolsDet[N][nCF]  := SF4->F4_CF 					// CF pertencente ao TES padrão
				EndIf
				
			EndIf
			
		Else
			
			If SF4->(DbSeek(xFilial("SF4")+cTES))
				AcolsDet[N][nTES] := cTes              				// TES padrão de Venda, informado no Produto ou MV_TESSAI
				AcolsDet[N][nCF]  := SF4->F4_CF 					// CF pertencente ao TES padrão
			EndIf
			
		EndIf
		
	Else
		MsgAlert("Este Produto somente poderá ser vendido da Filial "+SB1->B1_LJVENDA+" !!!","ATENÇÃO")
		Acols[N][nEntBRAS]  := SB1->B1_LJVENDA
		Acols[N][nQuant] 	:= 0
		AcolsDet[N][nTES] 	:= cTes
		
	EndIf
	
EndIf

SB2->(DbGoto(nRecSB2))

Return(cTes)