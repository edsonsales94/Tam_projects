#INCLUDE "Rwmake.ch"

/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ MT103IPC   ¦ Autor ¦ ADRIANO LIMA         ¦ Data ¦ 23/03/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada de preenchimento dos itens da nota de entrada¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT103IPC()
//---------------------------------------------------------------------------------------------------------------------------------------------------
//Ponto de Entrada executado na Pré-Nota e Documento de Entrada (<F5> e <F6>)
//OBJETIVO 1: Atualizar os campos D1_DESCRI e D1_REFEREN (Virtual)
//---------------------------------------------------------------------------------------------------------------------------------------------------

Local nX, nY, nORD := SX3->( IndexOrd() )
Local nPosCod := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_COD"})
Local aArea    := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local nPacLis   := AScan( aHeader , {|x| Trim(x[2]) == "D1_XPACLIS"}) //INCLUIDO POR: ADRIANO -  23/03/12
 
SX3->( DbSetOrder( 2 ) )
//For nX := 1 to Len( aCols )
nX := ParamIXB[1]
	For nY := 1 to Len( aCols[ nX ] ) - 1
		//If aHeader[ nY ][ 10 ] == "V"
			SX3->( MsSeek( aHeader[ nY ][ 2 ] ) )
			If Alltrim(aHeader[ nY ][ 2 ]) == "D1_DESCRI"
				aCols[ nX ][ nY ] := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")  //aCols[ nX ][ nPosCod ]
			ElseIf Alltrim(aHeader[ nY ][ 2 ]) == "D1_REFEREN"
				aCols[ nX ][ nY ] := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_REFEREN")	  // aCols[ nX ][ nPosCod ]
			ElseIf aHeader[ nY ][ 10 ] == "V"
				If Alltrim(aHeader[ nY ][ 2 ]) # "D1_ITEMMED"
				   if Type("M->D1_COD") = "U"
					   aCols[ nX ][ nY ] := &( STRTRAN(SX3->X3_INIBRW,"M->D1_COD","'" + SC7->C7_PRODUTO + "'") )  //aCols[ nX ][ nPosCod ]
				   else
				      aCols[ nX ][ nY ] := &( SX3->X3_INIBRW )
					EndIf
				Endif
			Endif
		//EndIf
	Next
//Next

 //----------------------------------------------------------------------------------------
 //INCLUIDO POR: ADRIANO -  23/03/12
 //VERIFICA A EXISTENCIA DO PACKLIST NO PEDIDO DE COMPRA, VISANDO O PREENCHIMENTO DO MESMO.
 If !Empty(SC7->C7_XPACLIS)
	   aCols[ParamIXB[1],nPacLis] := SC7->C7_XPACLIS
 EndIf
 //----------------------------------------------------------------------------------------

Eval( bREFRESH )
SX3->(RestArea(aAreaSX3))
RestArea(aArea)

Return NIL