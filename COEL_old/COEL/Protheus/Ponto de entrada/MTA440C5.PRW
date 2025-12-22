#include "rwmake.ch"

User Function MTA440C5()                 ///P.E. para adicionar campos no cabeçalho da rotina de Liberacao de Pedidos - MATA440C5 - Carlos 13/05/15

Local a_Cpos := {}

//IF ( M->cNumEmp=="0301" )
	a_Cpos := {"C5_X_TRANS"}
//ENDIF

Return(a_Cpos)	

