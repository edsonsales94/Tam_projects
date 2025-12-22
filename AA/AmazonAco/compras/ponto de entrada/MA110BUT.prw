#include 'protheus.ch'
#include 'parmtype.ch'

User Function MA110BUT()

   Local nOpc:= PARAMIXB[1]
   Local aBut:= PARAMIXB[2]//Customização Desejada
   //Local aButtons := {}
   	SetKEY(VK_F9,{|| u_AACOME05()    })
   aadd(aBut,{'BUDGETY',{|| u_AACOME05()},'Consulta Itens','Consulta Itens'})
   
Return aBut
