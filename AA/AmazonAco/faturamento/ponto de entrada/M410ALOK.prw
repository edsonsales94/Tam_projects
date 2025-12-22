#include 'Protheus.ch'

User Function M410ALOK()
	Local lIntACD	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"
	Local lRet	:= .T. 
	Local xACDChange := SuperGetMV("MV_XPVACDU",.F.,"000000")
	Local aOrdem 	:= {}


	If Upper(Alltrim(FunName()))=="MATA410" .And. Altera
		If lIntACD
			CB7->(DbSetOrder(2))
			If CB7->(DbSeek(xFilial("CB7")+SC5->C5_NUM))

				While !CB7->(Eof()) .And. xFilial("CB7")+CB7->CB7_PEDIDO==SC5->C5_FILIAL+SC5->C5_NUM
					If aScan(aOrdem, CB7->CB7_ORDSEP) = 0 //pega grupo de produto
						aAdd(aOrdem, CB7->CB7_ORDSEP)
					EndIf
					CB7->(DbSkip())
				EndDo
				cMsg := ""
				aEval(aOrdem, {|x| cMsg += x +', ' })
				cMsg := Left(cMsg, Len(cMsg)-2)
				If( __cUserId$xACDChange)
					//AddSZ6(SC5->C5_NUM, "Usuario : " + __cUserId + "-" + cUserName +  ", Liberado Alteração do Pedido com Lista de Separação do ACD")
					FwALertInfo("OK","Acesso a Pedido com Lista de Separação Liberado, as seguintes ordens estão amarradas para este pedido ("+cMsg+") ")
				Else
					Aviso("Integração ACD","Não é possivel alterar pedidos vinculados com uma Ordem de Separação",{"OK"})
					lRet:=.F.
				EndIf
			EndIf 
		EndIf
	EndIf


	If !Empty(SC5->C5_ORCRES) .And. Altera
		SC5->(RecLock('SC5',.F.))
		SC5->C5_ORCRES := ''
		SC5->(MsUnlock())
	EndIf


Return lRet



Static Function AddSZ6(cdPedido,cdMsg)
	_xdId := GetSXEnum("SZ6","Z6_ID")
	SZ6->(RecLock('SZ6',.T.))
	SZ6->Z6_FILIAL := xFilial('SZ6')
	SZ6->Z6_USUARIO:= cdPedido
	SZ6->Z6_ID     := _xdId
	SZ6->Z6_MSGM   := cdMsg
	SZ6->Z6_DATA   := Date()
	SZ6->Z6_HORA   := Time()
	SZ6->(msUnlock())
	ConfirmSX8()
Return lRet

/* powered by DXRCOVRB*/