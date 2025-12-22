#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ M410LIOK บAutor  ณ Reinaldo Magalhaes บ Data ณ  14/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E para validar as linhas do pedido de venda              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ .T. ou .F.                                                 บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M410LIOK

Local nPosMct     := Ascan( aHeader, {|y| "C6_CLVL" == Trim(y[2])})
Local nPosItemCta := Ascan( aHeader, {|y| "C6_ITEMCTA" == Trim(y[2])})
Local nPosTreina  := Ascan( aHeader, {|y| "C6_TREINAM" == Trim(y[2])})
Local nPosViagem  := Ascan( aHeader, {|y| "C6_VIAGEM" == Trim(y[2])})
Local lRet:= .T.

If !aCols[n,Len(aCols[1])]
	If Trim(aCols[n,nPosMct]) $ "001|006|007" .and. Empty(aCols[n,nPosItemCta])
		lRet := .F.
		MsgBox("ษ obrigado informar o colaborador para essa classe MCT","Classe MCT","STOP")
	ElseIf Trim(aCols[n,nPosMct]) = "006" .and. Empty(aCols[n,nPosViagem])
		lRet := .F.
		MsgBox("ษ obrigado informar o codigo da viagem para essa classe MCT","Classe MCT","STOP")
	ElseIf Trim(aCols[n,nPosMct]) = "007" .and. Empty(aCols[n,nPosTreina])
		lRet := .F.
		MsgBox("ษ obrigado informar o codigo do treinamento para essa classe MCT","Classe MCT","STOP")
	EndIf
Endif

Return(lRet)
