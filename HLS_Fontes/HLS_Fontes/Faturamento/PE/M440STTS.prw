#Include "Protheus.ch"

/*/{protheus.doc}M440STTS
Ponto de Entrada que é disparado na liberação do Pedido e após a gravação dos registros. 
Usado aqui para complementar os registros do SC9.
@author Waldir Baldin
@since 29/07/2010
/*/

*******************************************************************************************************************************************************
// M440STTS - Waldir Baldin - 29/07/2010 - Ponto de Entrada que é disparado na liberação do Pedido e após a gravação dos registros. 
//                                         Usado aqui para complementar os registros do SC9.
*******************************************************************************************************************************************************
User Function M440STTS()
	Local aAreaATU	:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())
	Local aAreaSC9	:= SC9->(GetArea())

	SC6->(DbSetOrder(1))			// C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	SC9->(DbSetOrder(1))			// C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO

	SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))
	Do While SC6->(!Eof()) .and. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6") + SC5->C5_NUM

		SC9->(DbSeek(xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM))
		Do While SC9->(!Eof()) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM == xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM
			RecLock("SC9", .F.)
				SC9->C9_ZZIDEXP := SC6->C6_ZZIDEXP
			SC9->(MsUnLock())

			SC9->(DbSkip())
	    EndDo

		SC6->(DbSkip())
    EndDo

	RestArea(aAreaSC6)
	RestArea(aAreaSC9)
	RestArea(aAreaATU)
Return
