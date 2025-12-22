User Function M460FIL()
LOCAL _cFil := ""
SC5->(DbSetOrder(1))
SC6->(DbSetOrder(1))
SF4->(DbSetOrder(1))
SC5->(DbSeek(xfilial("SC5")+MV_PAR05))                    
SC6->(DbSeek(xfilial("SC6")+MV_PAR05))                    
SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
//--Filtra apenas quando o pedido possui liberação do Faturamento, quando não é porque o pedido é de amostra, simples remessa
IF SA1->A1_MSBLQL = '1'
	_cFil := " SA1->A1_MSBLQL <> '1'"
Else	
	_cFil := " SA1->A1_MSBLQL $ '2/ '"
Endif
RETURN(_cFil)