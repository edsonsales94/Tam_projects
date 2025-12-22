#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} M460FIM

Este P.E. e' chamado apos a Gravacao da NF de Saida, e fora da transação.

@type function
@author Honda Lock
@since 01/10/2017

@history 01/10/2017, Altera o campo C6_LOTECTL¨ com o D2_LOTECTL.
/*/

User Function M460FIM()
Local _aArea := GetArea()
Local _aAreaSD2 := SD2->(GetArea())
Local _aAreaSC6 := SC6->(GetArea())
Local _cAlias := Alias()

dbSelectArea("SD2")
dbSetOrder(8)                                       
dbSeek(xFilial("SD2")+SC6->C6_NUM+SC6->C6_PRODUTO) 

While ! Eof() .and. D2_FILIAL=xFilial("SD2") .and. SC6->C6_NUM == SD2->D2_PEDIDO //.and. SC6->C6_PRODUTO == SD2->D2_COD

Reclock("SC6",.F.)

Replace C6_LOTECTL With SD2->D2_LOTECTL
MsUnlock()
dbSkip()

SD2->(RestArea(_aAreaSD2))
SC6->(RestArea(_aAreaSC6))

RestArea(_aArea)
dbSelectArea(_cAlias)
//Endif
End
Return()
