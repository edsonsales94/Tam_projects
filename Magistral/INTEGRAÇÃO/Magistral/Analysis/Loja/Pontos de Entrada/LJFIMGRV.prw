#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ LJFIMGRV   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 18/11/2024 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada depois após gravar SD2/SF2 e antes do SF3    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function LJFIMGRV()
	Local nX, nY
	Local aArea := GetArea()
	Local cSeek := SL1->L1_FILIAL+SL1->L1_NUM
	Local aSE1  := {}
	Local aSL4  := {}
	
	// Pesquisa as parcelas do orçamento
	SL4->(dbSetOrder(1))
	SL4->(dbSeek(cSeek,.T.))
	While !SL4->(Eof()) .And. SL4->L4_FILIAL+SL4->L4_NUM == cSeek
		AAdd( aSL4 , { SL4->L4_FORMA, SL4->L4_DATA, SL4->L4_XIDINT} )
		SL4->(dbSkip())
	Enddo
	
	// Pesquisa as parcelas do Contas a Receber
	SE1->(dbSetOrder(1))
	SE1->(dbSeek(XFILIAL("SE1")+SL1->L1_SERIE+SL1->L1_DOC,.T.))
	While !SE1->(Eof()) .And. SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == XFILIAL("SE1")+SL1->L1_SERIE+SL1->L1_DOC
		AAdd( aSE1 , { SE1->E1_TIPO, SE1->E1_VENCTO, SE1->(Recno()), .T.} )
		SE1->(dbSkip())
	Enddo
	
	// Processa a atualizaão do XIDINT no Contas a Receber
	For nX:=1 To Len(aSL4)
		If !Empty(aSL4[nX,3])
			For nY:=1 To Len(aSE1)
				// Tenta localizar a mesma forma de pagamento e mesmo vencimento
				If aSE1[nY,4] .And. Trim(aSE1[nY,1]) == Trim(aSL4[nX,1]) .And. aSE1[nY,2] == aSL4[nX,2]
					SE1->(dbGoTo(aSE1[nX,3]))   // Posiciona no registro
					RecLock("SE1",.F.)
					SE1->E1_XIDINT := aSL4[nX,3]
					MsUnLock()
					aSE1[nY,4] := .F.    // Marca como já processado
					Exit
				Endif
			Next
		Endif
	Next
	
	RestArea(aArea)
	
Return
