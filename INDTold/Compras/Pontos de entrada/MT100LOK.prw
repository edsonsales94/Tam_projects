#Include "Rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³Ener Fredes         º Data ³  07.12.10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado para valaidar os dados do documento de        º±±
±±º          ³ enetrada. Será usado para validar se os dados do follow-up º±±
±±º          ³ estão preenchidos antes da entrada da nota fiscal ou da DI.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COMPRA - Documento de Entrada                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100LOK()
	Local nPNDI := AScan(aHeader,{|x| Trim(x[2]) == "D1_NODI"   })
	Local nPPed := AScan(aHeader,{|x| Trim(x[2]) == "D1_PRCOMP" })
	Local cPedido := AScan(aHeader,{|x| Trim(x[2]) == "D1_PEDIDO"   })
	   
	Local nPosCLVL   := aScan(aHeader, {|x| Trim(x[2]) == "D1_CLVL"}) 
	Local nPosTreina := aScan(aHeader, {|x| Trim(x[2]) == "D1_TREINAM"}) 
	Local nPosViagem := aScan(aHeader, {|x| Trim(x[2]) == "D1_VIAGEM"}) 
	Local nPosItemCta:= aScan(aHeader, {|x| Trim(x[2]) == "D1_ITEMCTA"}) 
	   
	Local nPosCc    := aScan(aHeader, {|x| Trim(x[2]) == "D1_CC"}) 
	Local nPosConta := aScan(aHeader, {|x| Trim(x[2]) == "D1_CONTA"}) 
	Local nPosRateio:= aScan(aHeader, {|x| Trim(x[2]) == "D1_RATEIO"}) 
	Local lRet:= ParamIXB[1]
	   
	If !Empty(aCols[n,cPedido])
	SC7->(dbSetorder(1))
	If !SC7->(dbSeek(xFilial("SC7")+aCols[n,cPedido]))
		lValida := .T.
	else
		lValida := (Len(Alltrim(SC7->C7_CONTRA)) == 0)
	EndIf
	SZD->(DbSetOrder(1))
	If SZD->(DbSeek(xFilial("SZD")+aCols[n,cPedido])) 
		If Empty(SZD->ZD_DATENV) .And. lValida
			Alert("Não está informada a Data de Envio do Pedido do Fornecedor no Follow-Up !!!")
			lRet := .F.
		EndIf
		If Empty(SZD->ZD_DATAEF) .And. lValida
			Alert("Não está informada a Data de Entrega do Fornecedor no Follow-Up !!!")
			lRet := .F.
		EndIf
		If Empty(SZD->ZD_DATAEC) .And. lValida
			Alert("Não está informada a Data de Entrega ao Cliente Interno no Follow-Up !!!")
			lRet := .F.
		EndIf
		Elseif lValida
			Alert("Não existe Follow-Up informado para este PO !!!")
			lRet := .F.
		EndIf
	EndIf
	
	If lRet .And. !aCols[n,Len(aCols[1])]
		If Posicione("SA2",1,XFILIAL("SA2")+cA100For+cLoja,"A2_EST") == "EX"  // Se for Fornecedor Estrangeiro
			If Empty(aCols[n,nPNDI])
				Alert("O numero da DI nao pode ficar vazio !")
				lRet := .F.
			Endif
		Endif
		If lRet .And. cTipo == "C"  // Se for Conhecimento de Frete
			If Empty(aCols[n,nPPed])
				Alert("O numero do Processo de Compra nao pode ficar vazio !")
				lRet := .F.
			Endif
		Endif
		If lRet .and. cTipo == "N" // Nota de compras
			If Trim(aCols[n,nPosCLVL]) == "006" .and. Empty(aCols[n,nPosViagem])
				Alert("O Codigo da viagem deve ser informada para esta classe MCT !")
				lRet := .F.
			Endif  
			If Trim(aCols[n,nPosCLVL]) == "007" .and. Empty(aCols[n,nPosTreina])
				Alert("O Codigo do treinamento deve ser informado para esta classe MCT !")
				lRet := .F.
			Endif  
			If Trim(aCols[n,nPosCLVL]) $ "001,006,007" .and. Empty(aCols[n,nPosItemCta])
				Alert("O Codigo do colaborador deve ser informado para esta classe MCT !")
				lRet := .F.
			Endif  
		Endif   
		      
		If aCols[n,nPosRateio] = '2' .And. ( Len(Alltrim(aCols[n,nPosCc])) = 0 .OR. Len(Alltrim(aCols[n,nPosConta])) = 0 )
			Aviso('Atencao','Os Campos Centro de Custo ou Conta Contabil estão em Branco',{'2'},2)
			lRet := .F.
		EndIf

      // Se foi preenchida a conta contábil
		If lRet .And. !Empty(aCols[n,nPosConta])
         // Posiciona na conta contábil
         CT1->(dbSetOrder(1))
         CT1->(dbSeek(XFILIAL("CT1")+aCols[n,nPosConta]))

         // Se a conta pertencer ao grupo de despesas do MCT
         If CT1->CT1_XMCT == "S"
            If !(lRet := (Trim(aCols[n,nPosCLVL]) == Trim(CT1->CT1_GRUPO)))
               Aviso('Atenção',"Classe MCT diferente do Grupo Contábil ("+Trim(CT1->CT1_GRUPO)+") !",{'2'},2)
            Endif
         Endif
		Endif
	Endif
Return(lRet)
