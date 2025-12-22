#include 'protheus.ch'
#include 'parmtype.ch'

user function MT103LDV()
	 Local aLinha   := PARAMIXB[01]
	 Local cSD2     := PARAMIXB[02]
	 Local nPosLot  := aScan(aLinha, {|x| x[01] == "D1_LOTECTL"})
	 Local nPosNfO  := aScan(aLinha, {|x| x[01] == "D1_NFORI"})
	 Local nPosSrO  := aScan(aLinha, {|x| x[01] == "D1_SERIORI"})
	 Local nPosItO  := aScan(aLinha, {|x| x[01] == "D1_ITEMORI"})
	 Local nPosCod  := aScan(aLinha, {|x| x[01] == "D1_COD"})
   
	 Local nNumSeq  := Posicione("SD2",3,XFILIAL("SD2") + aLinha[nPosNfO][02] + aLinha[nPosSrO][02] + (CSD2)->D2_CLIENTE   + (CSD2)->D2_LOJA + aLinha[nPosCod][02] + aLinha[nPosItO][02]   ,"D2_NUMSEQ" )
	 Local cxLots   := Posicione("SD5",3,XFILIAL("SD5") + nNumSeq   ,"D5_LOTECTL" )
		
	 If nPosLot > 0 .AND. !EMPTY(cxLots)
	 	aLinha[nPosLot][02] := cxLots
	 EndIf
	   
return aLinha
