#INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATE10   ¦ Autor ¦ Ronilto .Gadelha     ¦ Data ¦ 22/03/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Execblock de validação da condição de pagamento da venda      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AAFATE10()
	Local aPgto
	Local cVar := ReadVar()
	Local dMin := dDataBase + 1
	Local lRet := .T.

	cCond := ""
	If cVar == "M->C5_CONDPAG"
		cCond := M->C5_CONDPAG
		
		SE4->(dbSetOrder(1))
		If SE4->(dbSeek(XFILIAL("SE4")+M->C5_CONDPAG))
			If Trim(SE4->E4_FORMA) $ GetMV("MV_XFORAVI",.F.,"R$,CH")   // Se forma de pagamento for Dinheiro ou Cheque
				aPgto := Condicao(100,cCond)
				aEval( aPgto , {|x| dMin := If( x[1] < dMin , x[1], dMin) } )
				
				If dMin <= dDataBase
					Alert("Não é permitido informar condição de pagamento A VISTA !")
					Return .F.
				Endif
			Endif
		Endif
		
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
	ElseIf cVar == "M->LQ_CONDPG"
		cCond := M->LQ_CONDPG
		
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(XFILIAL("SA1")+M->LQ_CLIENTE+M->LQ_LOJA))
	Endif
	SE4->(dbSetOrder(1))
	SE4->(dbSeek(XFILIAL("SE4")+cCond))
	If !(AllTrim(SE4->E4_FORMA) $ "CC#CD#R$") //Alteração realizada por Williams Messa, para desconsiderar as formas Cartão e a Vista.
		If !Empty(cCond) .And. !Empty(SA1->A1_COND)
		// Caso a maior data da venda seja maior que a data do cliente
			If DataMaxima(cCond) > DataMaxima(SA1->A1_COND)
			// Posiciona na condição de pagamento do cliente
				SE4->(dbSeek(XFILIAL("SE4")+SA1->A1_COND))
				lRet := .F.
				Alert("Prazo de pagamento é maior que o permitido para esse cliente."+Chr(13)+Chr(10)+;
				"(Condição cliente: "+SA1->A1_COND+" - "+Trim(SE4->E4_DESCRI)+" - "+Trim(SE4->E4_COND)+") !")
			EndIf
		Endif
	Endif
	
Return lRet

Static Function DataMaxima(cCond)
	Local aCond := Condicao(100,cCond)
	Local dRet  := Ctod("")
	aEval( aCond , {|x| dRet := If( x[1] > dRet , x[1], dRet) } )
Return dRet
