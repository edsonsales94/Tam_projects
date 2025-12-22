#include 'protheus.ch'


User Function ACD100BUT()
Local aButtons := {}

//AAdd( aButtons , {"AAFATR03",{|| U_AAFATR03()  },"Imp. Separacao","Imp. Separacao"} )
aadd(aButtons, {'RELOAD',{||U_AAFATR03(CB7->CB7_ORDSEP,CB7->CB7_PEDIDO)},"Imp. Separacao","Imp. Separacao"})
	
Return aButtons    