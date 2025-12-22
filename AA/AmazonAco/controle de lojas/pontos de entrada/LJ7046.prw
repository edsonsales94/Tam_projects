#include "Protheus.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ LJ7046     ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 30/10/2012 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada para incluir campos na gravacao do Pedido    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function LJ7046()
	Local nX, nPPrd, nPAlm, cAlm, nTam
	Local cAlmTra := GetMV("MV_XALMCTR")
	Local aSL2    := ParamIXB[3]
	Local aRet    := {}
	
	SB1->(dbSetOrder(1))
	
	For nX:=1 To Len(aSL2)
		nPPrd := AScan(aSL2[nX], {|x| AllTrim(x[1]) == "L2_PRODUTO"	})
		nPAlm := AScan(aSL2[nX], {|x| AllTrim(x[1]) == "L2_LOCAL"	})
		cAlm  := aSL2[nX][nPAlm,2]
		
		SB1->(dbSeek(XFILIAL("SB1")+aSL2[nX][nPPrd,2]))
		
		If !(Trim(SB1->B1_GRUPO) $ "26,28,23,24,25") .And.;  // Se não forem esses PRODUTOS DO GRUPO 63
			!(Trim(SB1->B1_COD) $ "63000001,63000002,63000003,63000004,63000024,63000025,63000026,63000027,63000028")
			cAlm := cAlmTra
		Endif
		
		// Adiciona o item no vetor
		AAdd( aRet , {} )
		nTam := Len(aRet)
		
		// Adiciona os campos no item do vetor
		AAdd( aRet[nTam] , { "C6_LOCAL", cAlm, Nil} )
	Next
	
Return { Nil , aRet }