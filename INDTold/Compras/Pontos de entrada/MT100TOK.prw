#Include "RwMake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MT100TOK   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 19/01/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada de validação da gravação da nota de entrada  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT100TOK
	Local nX
	Local nPDel := Len(aCols[1])
	Local nPIte := AScan( aHeader , {|x| Trim(x[2]) == "D1_ITEM"   } )
	Local nPPed := AScan( aHeader , {|x| Trim(x[2]) == "D1_PEDIDO" } )
	Local nPIPC := AScan( aHeader , {|x| Trim(x[2]) == "D1_ITEMPC" } )
	Local lRet  := .T.
	
	If ParamIXB[1]   // Se validou
		For nX:=1 To Len(aCols)
			// Se não estiver deletado e tiver sido informado o pedido de compras mas o item do pedido não foi informado
			If !aCols[nX,nPDel] .And. !Empty(aCols[nX,nPPed]) .And. Empty(aCols[nX,nPIPC])
				Alert("Favor informar o campo Item do Pedido de Compras para o item: "+aCols[nX,nPIte]+" !")
				lRet := .F.
				Exit
			Endif
		Next
	Endif
	
Return lRet
