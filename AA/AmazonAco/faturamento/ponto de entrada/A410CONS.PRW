#include "Protheus.ch"
//#include 'inkey.ch'

//  .---------------------------------------------------------------------------------------------------------------------.
// |     Programa     |     A410CONS     |     Autor     |     Wagner da Gama Correa              |     Data: 20/10/10     |
// |-----------------------------------------------------------------------------------------------------------------------|
// |     Descricao    |     Adiciona um botao no EnchoiceBar na Inclusao do Pedido de Vendas, para consulta de produto     |
//  '---------------------------------------------------------------------------------------------------------------------'
User Function A410CONS()
Local aRet := {}
 
SetKey( 9 ,  {|| U_TelaPesq("F")} ) 
SetKey(11 ,  {|| U_TelaEnt ("P")} )
SetKey(13 ,  {|| U_TelaEst(Acols[N][2])} )                     

If !( Alltrim(FunName()) $ 'MATA410|') 
  SetKey(16 ,  {|| Aviso("PESO",'Peso Total' + Transform(u_Calcpeso(aCols),"@E 999,999,999.9999"),{'OK'},2) } )
EndIf 

aAdd( aRet, {'Tela Estoque / PC', {||U_TelaEst(Acols[N][2]) }  ,'Tela Estoque / PC','Tela Estoque / PC' })
aAdd( aRet, {'Tela Entrega'     , {||U_TelaEnt("P")}   ,'Tela Entrega'     ,'Tela Entrega'})   // lol
aAdd( aRet, {'OBJETIVO'         , {||U_TelaPesq("F")}  ,'Pesquisa Prod.'        ,'&Pesquisa Prod.'        })  
If !( Alltrim(FunName()) $ 'MATA410|') 
  aAdd( aRet, {'Peso Orcamento',    {||Aviso("PESO",'Peso Total: ' + Transform(u_Calcpeso(aCols),"@E 999,999,999.9999"),{'OK'},2) },'Peso Orcamento', '&Peso Orcamento'})
EndIf 

/*
aAdd( aRet, {'Tela Estoque / PC', 'Tela Estoque / PC', 'Tela Estoque / PC', {||U_TelaEst("F") }        , .F., .T., 4, {13,'Ctrl+M'}  } )
aAdd( aRet, {'Tela Entrega'     , 'Tela Entrega'     , 'Tela Entrega'     , {||U_TelaEnt()}            , .F., .T., 4, {11,'Ctrl+K'}  } )
aAdd( aRet, {'OBJETIVO',          'Pesquisar Produto', 'Pesquisar Pr	oduto', {||U_TelaPesq("F")}        , .F., .T., 4, {9 ,'Ctrl+I'}  } )
*/
Return aRet                                                         
