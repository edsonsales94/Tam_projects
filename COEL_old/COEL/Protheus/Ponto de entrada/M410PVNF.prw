#Include 'Protheus.ch'
#Include 'RwMake.ch'

/*------------------------------------------------------------------------------------------------------*
| P.E.:  M410PVNF                                                                                      |
| Desc:  Validação na chamada do Prep Doc Saída no Ações Relacionadas do Pedido de Venda               |
| Links: http://tdn.totvs.com/pages/releaseview.actionçpageId=6784152                                  |
*------------------------------------------------------------------------------------------------------*/

User Function M410PVNF()
Local lRet := .T.
Local aArea := GetArea()
Local aAreaC5 := SC5->(GetArea())
Local aAreaC6 := SC6->(GetArea())
Local aAreaA1 := SA1->(GetArea())


DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI))
If SA1->A1_MSBLQL == "1"
	Alert("Cadastro do cliente bloqueado, favor entrar em contato com o Depto. Financeiro"+" - "+SC5->(C5_CLIENTE+C5_LOJACLI) )
	lRet := .f.
Else
	lRet := .t.
EndIf


RestArea(aAreaC6)
RestArea(aAreaC5)
RestArea(aAreaA1)
RestArea(aArea)
Return lRet
