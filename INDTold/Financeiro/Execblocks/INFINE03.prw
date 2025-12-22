#Include "Rwmake.ch"

User Function INFINE03()

	If M->E2_CONFIRM == "1"
		MsgStop("Valor Líquido a Pagar: "+Transform(M->((M->E2_VLCRUZ+M->E2_ACRESC)-M->E2_DECRESC),"@E 999,999,999.99"))
	Endif

Return M->E2_CONFIRM
