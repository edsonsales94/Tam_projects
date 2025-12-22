User Function MT100C7L()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Ponto de Entrada executado na Tela de Itens do Pedido de Compras
OBJETIVO 1: Atualizar o campos PRODUTO com a referência ou o código do produto
----------------------------------------------------------------------------------------------------------------------------------------------------/*/

Local aArea := GetArea()
Local nFreeQt
Local nX

dbSelectArea('SC7')
dbSetOrder(3)

If dbSeek(xFilial() + cA100For)
	
	aArrSldo := {}
	aArrayF4 := {}
	
	While !Eof() .And. SC7->C7_FORNECE == cA100For
		
		nFreeQt := SC7->C7_QUANT - SC7->C7_QUJE - SC7->C7_QTDACLA
		
		If nFreeQt > 0
			
			aAdd(aArrSldo, {nFreeQt, RecNo()})
			Aadd(aArrayF4, Array(Len(aCampos)))
			
			For nX := 1 To Len(aCampos)
				
				If aCampos[nX][3] != 'V'
					aArrayF4[Len(aArrayF4)][nX] := FieldGet(FieldPos(aCampos[nX][1]))
				Else
					aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
				Endif
				
				If Alltrim(aCampos[nX][1]) == "C7_PRODUTO"  // Caso seja o campo PRODUTO substitui pela referência do produto
					
					cReferencia 				:= Posicione("SB1",1,xFilial("SB1")+FieldGet(FieldPos(aCampos[nX][1])),"B1_REFEREN")
					aArrayF4[Len(aArrayF4)][nX] := IIf(!Empty(cReferencia),cReferencia,aArrayF4[Len(aArrayF4)][nX])
					
				EndIf
				
			Next
			
		Endif
		
		dbSkip()
		
	End
	
Endif

RestArea(aArea)

Return NIL
