#Include "Rwmake.ch"

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ MT100TOK   ¦ WERMESON GADELHA DO CANTO    ¦ Data ¦ 30/07/2009             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para validar dados antes da gravacao da NF de entrada    ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ .T. ou .F.                                                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT100TOK()
	Local nPosDI   := AScan(aHeader, {|x| Trim(x[2]) == "D1_XDI"    })
	//Local nPosInv  := AScan(aHeader, {|x| Trim(x[2]) == "D1_XINVOIC"})
	Local nPosInv  := AScan(aHeader, {|x| Trim(x[2]) == "D1_XINV"})
	Local nPosHAWB := AScan(aHeader, {|x| Trim(x[2]) == "D1_XHAWB"  })
	Local lRet     := ParamIXB[1]
	
	If lRet .And. SA2->A2_EST == "EX"
		
		For i:=1 To Len(acols)
			
			If nPosDI > 0
				If Empty(aCols[i,nPosDI])
					Alert("Favor informar D.I. para a Nota!")
					lRet := .F.
					Exit
				Endif
			EndIf
			
			If nPosHAWB > 0
				If Empty(aCols[i,nPosHAWB])
					Alert("Favor informar o Conhecimento para a Nota!")
					lRet := .F.
					Exit
				Endif
			EndIf
			
			if nPosInv > 0
				If Empty(aCols[i,nPosInv])
					Alert("Favor informar a Invoice  para a Nota!")
					lRet := .F.
					Exit
				Endif
			EndIf
			
			If nPosDI > 0			
				If aCols[i,nPosDI] <> aCols[1,nPosDI]
					Alert("Favor informar uma única D.I. para a Nota!")
					lRet := .F.
					Exit
				Endif
			EndIf
			
			If nPosHAWB > 0
				If aCols[i,nPosHAWB] <> aCols[1,nPosHAWB]
					Alert("Favor informar um único conhecimento para a D.I.!")
					lRet := .F.
					Exit
				Endif
			EndIf
		Next
		
	Endif
	
	If lRet
		If Alltrim(FunName())=="MATA103"
			lRet := ValidaPuxada()
		EndIf
	Endif
	
Return lRet

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ValidaPuxada¦ Autor ¦ ADRIANO LIMA         ¦ Data ¦ 23/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Valida os dados que integram com as puxadas                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ValidaPuxada()
	Local nX
	Local nPosPac := AScan( aHeader , {|x| Trim(x[2]) == "D1_XPACLIS"})
	Local nPosAlm := AScan( aHeader , {|x| Trim(x[2]) == "D1_LOCAL"  })
	Local nPosPed := AScan( aHeader , {|x| Trim(x[2]) == "D1_PEDIDO" })
	Local nPosIPc := AScan( aHeader , {|x| Trim(x[2]) == "D1_ITEMPC" })
	Local nPosIte := AScan( aHeader , {|x| Trim(x[2]) == "D1_ITEM"   })
	Local nPosDel := Len(aHeader) + 1
	Local nLinPac := 0
	Local cArmTra := GetMv("MV_XARMTRA",.F.,"TR")
	
	SC7->(DbSetOrder(1))
	
	For nX:=1 To Len(aCols)
		
		If aCols[nX,nPosDel]   // Desconsidera itens deletados
			Loop
		Endif
		
		// Se foi informado pedido de compra para o item
		If !Empty(aCols[nX,nPosPed]) .And. !Empty(aCols[nX,nPosIPc])
			// Posiciona no item do pedido de compra informado
			If SC7->(DbSeek(xFilial("SC7")+aCols[nX,nPosPed]+aCols[nX,nPosIPc]))
				If !Empty(aCols[nX,nPosPac]) .And. SC7->C7_XPACLIS <> aCols[nX,nPosPac]
					Alert("Pack-List informado não é o mesmo do pedido de compra!")
					Return .F.
				EndIf
			EndIf
		EndIf
		
		If aCols[nX,nPosAlm] == cArmTra  // Se armazém for de trânsito
			// Valida o campo Pack-List
			If nPosPac > 0
				If Empty(aCols[nX,nPosPac])
					Alert("Favor informar o Pack-List para o item "+aCols[nX,nPosIte]+" !")
					Return .F.
				ElseIf nLinPac > 0 .And. aCols[nLinPac,nPosPac] <> aCols[nX,nPosPac]
					Alert("Existem pack-list diferentes nos itens !")
					Return .F.
				Endif
			EndIf
			nLinPac := nX   // Salva o item com pack-list informado
		ElseIf nPosPac > 0
		    If !Empty(aCols[nX,nPosPac])  // Se foi informado o Pack-List
		    	Alert("Não pode ser informado um Pack-List (item "+aCols[nX,nPosIte]+") sem que o almoxarifado seja de trânsito !")
		    	Return .F.
			EndIf
		Endif
	Next
	
Return .T.