////
////P.E. = Cria botao na rotina MATA650 (Ordem de Producao) para facilitar a geracao de OP's
////       via Planilha. (Carlos - 20/08/14) - Sugestao do Brandao e aceita pela DORA.
////     = Cria, tambem, botao para imprimir a OP Grafica (Carlos - 24/04/15)
////     = Nova opção via pedido individual (Carlos - 20/05/15)
////
#Include "rwmake.ch"

User Function MA650BUT() 

//aAdd(aRotina,{'® Venda Planilha','U_CESTG650',0,5 })              //Carlos: 31/08/15                                                          
//IF ( M->cNumEmp == "0301" )
	aAdd(aRotina,{'® Venda Pedido','U_CESTG65B',0,5 })                //Carlos: 31/08/15 - EM TESTE A PARTIR DE 22/01/2016 (SOMENTE P/COELMATIC-MAO)
	aAdd(aRotina,{'® Impr.O.P Gráfica','U_OP_GRAFICA',0,6 })
//ENDIF	

Return aRotina
