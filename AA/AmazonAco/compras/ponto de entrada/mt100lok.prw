#Include "Rwmake.ch"

/*___________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Função    ¦ MT100LOK   ¦ Wermeson Gadelha do Canto    ¦ Data ¦ 30/07/2009             ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para validar dados antes da gravacao da NF de entrada    ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦ Retorno   ¦ .T. ou .F.                                                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT100LOK()
   Local nPosDI  := AScan(aHeader, {|x| Trim(x[2]) == "D1_XDI"    })
   Local nPosInv := AScan(aHeader, {|x| Trim(x[2]) == "D1_XINVOIC"})   
   Local nPosHAWB:= AScan(aHeader, {|x| Trim(x[2]) == "D1_XHAWB"  })    
   Local lRet:= ParamIXB[1]                    
   
   If nPosDI > 0
	   If lRet .And. aCols[n,nPosDI] <> aCols[1,nPosDI] .And. SA2->A2_EST == 'EX' 
	       Alert("Favor informar uma única D.I. para a Nota!")
	       lRet := .F.
	   Endif
   EndIf
   
   If nPosHAWB > 0
	   If lRet .And. aCols[n,nPosHAWB] <> aCols[1,nPosHAWB] .And. SA2->A2_EST == 'EX'
	       Alert("Favor informar um único conhecimento para a Nota!")
	       lRet := .F.
	   Endif
   EndIf
   
Return(lRet)