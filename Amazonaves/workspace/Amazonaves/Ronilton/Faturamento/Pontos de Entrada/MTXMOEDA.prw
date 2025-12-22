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
//	Local lArred   := .T.

	Local nValor   := ParamIXB[1]
	Local nMoedp   := ParamIXB[2]
	Local nMoedd   := ParamIXB[3]
//	Local dData    := ParamIXB[4]
//	Local nDecimal := ParamIXB[5]
//	Local nTaxap   := ParamIXB[6]
	Local nTaxad   := ParamIXB[7]
	Local nValRet  := ParamIXB[8]
	
	If IsInCallStack("MATA415") .And. M->CJ_MOEDA = 1 .And. M->CJ_TXMOEDA > 1
		If nMoedd == nMoedp
			nValRet := nValor
		Else
			nTaxad  := M->CJ_TXMOEDA
			nValRet := nValor * nTaxad
		EndIf
	EndIf	

Return nValRet
