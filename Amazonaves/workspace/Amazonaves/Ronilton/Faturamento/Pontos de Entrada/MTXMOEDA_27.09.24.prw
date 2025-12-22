#Include "Protheus.ch"

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Programa  ¦ MTXMOEDA   ¦ Autor ¦ Ronilton O. Barros     ¦ Data ¦ 27/09/2024 ¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada p/ alterar o valor da conversao da xMoeda      ¦¦¦
¦¦+-----------+-----------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MTXMOEDA()
	Local lArred   := .T.
	
	Local nValor   := ParamIXB[1]
	Local nMoedp   := ParamIXB[2]
	Local nMoedd   := ParamIXB[3]
	Local dData    := ParamIXB[4]
	Local nDecimal := ParamIXB[5]
	Local nTaxap   := ParamIXB[6]
	Local nTaxad   := ParamIXB[7]
	Local nValRet  := ParamIXB[8]
	
	If IsInCallStack("MATA415") .And. M->CJ_MOEDA > 1 .And. M->CJ_TXMOEDA > 0
		If nMoedd == nMoedp
			nValRet := nValor
		Else
			nTaxad  := M->CJ_TXMOEDA
			nValRet := (nValor * Iif (nMoedp!=1,Iif(nTaxap==0,RecMoeda(dData,nMoedp),nTaxap) ,1 ))
			If !( !lArred .And. Iif (nMoedd!=1, Iif(nTaxad==0,RecMoeda(dData,nMoedd),nTaxad) ,1 ) == 1 )
				If cPaisLoc	== "RUS"
					nValRet := Round (nValRet / Iif (nMoedd!=1, Iif(nTaxad==0,RecMoeda(dData,nMoedd),nTaxad) ,1 ) ,nDecimal)
				Else
					nValRet := NoRound (nValRet / Iif (nMoedd!=1, Iif(nTaxad==0,RecMoeda(dData,nMoedd),nTaxad) ,1 ) ,nDecimal)
				Endif
			EndIf
		EndIf
	Endif

Return nValRet
