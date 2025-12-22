#include 'protheus.ch'
#include 'parmtype.ch'

user function FC010BTN()
	 If Paramixb[1] == 1// Deve retornar o nome a ser exibido no botão
	     Return "Serasa"
	 ElseIf Paramixb[1] == 2// Deve retornar a mensagem do botão
	     Return "Consulta Cliente na Base do Serasa"
	 ElseIf Paramixb[1] == 3// Deve retornar a mensagem do botão
	     Return u_odSerasa()
	     //Return u__DOPRSEA()
	 Endif 
return