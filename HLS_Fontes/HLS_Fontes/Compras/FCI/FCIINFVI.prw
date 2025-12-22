#include "RWMAKE.CH"
#include "PROTHEUS.CH"

/*/{Protheus.doc} FCIINFVI

Este Ponto de Entrada permite ao usuário informar o valor da parcela importada do produto quando o processo de pré-apuração não conseguir localizar nenhum documento de entrada para o produto no período calculado e em períodos anteriores.

@type function
@author Honda Lock
@since 01/10/2017

@return Numerico, Valor da parcela.

@history 01/10/2017, Retorna o valor do cadastro de produto.
/*/

User Function FCIINFVI()
cProduto := ParamIXB[1]
aArea    := SB1->( GetArea() )

SB1->(dbSetOrder(1))
SB1->(dbSeek( xFilial("SB1")+cProduto) )

MsgInfo( SB1->B1_COD + "-" + SB1->B1_DESC + "- R$ " + AllTrim(Transform(SB1->B1_PRV1,"@E 9,999,999.99") )  )
nRet := SB1->B1_PRV1

RestArea( aArea )

Return( nRet )


//User Function FCIPROC001()  
//MsgINFO( "FCIPROC001" )
//Return( 1.00 )
