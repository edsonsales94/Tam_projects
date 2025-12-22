#include 'protheus.ch'
#include 'parmtype.ch'

User Function A105BUT()

 Local aButtons := {}
   
   	SetKEY(VK_F9,{|| u_AACOME05()    })
   aadd(aButtons,{'PRODUTO',{|| u_AACOME05()},'Consulta Itens','Consulta Itens'}) 
     
Return aButtons