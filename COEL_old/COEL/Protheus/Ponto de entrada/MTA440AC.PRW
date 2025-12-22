#include "rwmake.ch"

User Function MTA440AC()                 ///P.E. para habilitar campos de detalhes do pedido de venda na rotina de Liberacao de Pedidos - MATA440AC - Carlos 23/06/15

Local a_Cpos := {}

IF ( M->cNumEmp=="0301".AND.SC5->C5_TIPOCLI=="X" )             ///EM TESTE NO AMBIENTE CARLOS
	a_Cpos := {"C6_PRUNIT"}
ENDIF

Return(a_Cpos)	

