#include 'Protheus.ch'

User Function MA410VRES()
	Local lRet := .T.
	Local lIntACD	:= SuperGetMV("MV_INTACD",.F.,"0") == "1"
	Local aOrdem := {}
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
		EndIf
		If Len(aOrdem)>0
			FwALertInfo("OK","Nao e possivel eliminar residuos deste pedido, pois as seguintes ordens estão amarradas para este pedido ("+cMsg+") ")
			lRet := .F.
		EndIf
	EndIf
Return lRet