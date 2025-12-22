#include "Protheus.ch"
                                          
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AAFATR05   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 15/02/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Add botao no EnchoiceBar do orçamento, para consulta d produto¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MA415BUT()
Local aRet := {}
 
SetKey( 9 ,  {|| U_TelaPesq("F")} ) 
SetKey(11 ,  {|| U_TelaEnt ("P")} )
SetKey(13 ,  {|| U_TelaEst(TMP1->CK_PRODUTO) } )
SetKey(16 ,  {|| Aviso("PESO",'Peso Total' + Transform(u_Calcpes2(aCols),"@E 999,999,999.9999"),{'OK'},2) } )

aAdd( aRet, {'Tela Estoque / PC', {||U_TelaEst(TMP1->CK_PRODUTO) }  ,'Tela Estoque / PC','Tela Estoque / PC' })
aAdd( aRet, {'Tela Entrega'     , {||U_TelaEnt("P")}   ,'Tela Entrega'     ,'Tela Entrega'})   // lol
aAdd( aRet, {'OBJETIVO'         , {||U_TelaPesq("F")}  ,'Pesquisa Prod.'        ,'&Pesquisa Prod.'        })  
aAdd( aRet, {'Peso Orcamento',    {||Aviso("PESO",'Peso Total: ' + Transform(u_Calcpes2(),"@E 999,999,999.9999"),{'OK'},2) },'Peso Orcamento', '&Peso Orcamento'})

Return aRet                                                         
