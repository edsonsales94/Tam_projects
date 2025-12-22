#include "protheus.ch"

User Function LJ7016()
//Executado no Botão “OUTROS” na Venda Assistida
// OBJETIVO 1: Chamada de funções desenvolvidas para o cliente


/*
Array bidimensional contendo:

[1] - Titulo para o menu
[2] - Titulo para botao (tip)
[3] - Resource
[4] - Funcao a ser executada
[5] - Aparece na toolbar lateral ? (TRUE / FALSE)
[6] - Habilitada ? (TRUE / FALSE)
[7] - Grupo (1- Gravacao, 2- Detalhes, 3- Estoque, 4- Outros)
[8] - Tecla de atalho
*/

Local aRet := {}

aAdd( aRet, {'Tela Estoque / PC', 'Tela Estoque / PC', 'Tela Estoque / PC', {||U_TelaEst(Acols[N][2]) }, .F., .T., 4, {13,'Ctrl+M'}  } )
aAdd( aRet, {'Tela Entrega'     , 'Tela Entrega'     , 'Tela Entrega'     , {||U_TelaEnt()}            , .F., .T., 4, {11,'Ctrl+K'}  } )
aAdd( aRet, {'Pesquisar Produto', 'Pesquisar Produto', 'Pesquisar Produto', {||U_TelaPesq(Acols[N][2])}, .F., .T., 4, {9 ,'Ctrl+I'}  } )
aAdd( aRet, {'Calculadora'      , 'Calculadora'      , 'Calculadora'      , {||WinExec( 'G:\Geral\Calculadora\AuCalc.exe' )}, .F., .T., 4, {12,'Ctrl+L'}  } )
aAdd( aRet, {'Peso Orcamento', 'Peso Orcamento', 'Peso Orcamento', {||Aviso("PESO",'Peso Total ' + Transform(u_Calcpeso(aCols),"@E 999,999,999.9999"),{'OK'},2) }, .F., .T., 4, {16 ,'Ctrl+P'}  } )
/*
SetKey( 9 ,  {|| U_TelaPesq("F")} ) 
SetKey(11 ,  {|| U_TelaEnt ("P")} )
SetKey(13 ,  {|| U_TelaEst(Acols[N][2])} )
SetKey(16 ,  {|| Aviso("PESO",'Peso Total' + Transform(u_Calcpeso(aCols),"@E 999,999,999.9999"),{'OK'},2) } )
*/

Return aRet 
