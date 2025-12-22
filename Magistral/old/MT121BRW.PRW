#Include 'Protheus.ch'


User Function MT121BRW() 

Local aButtons := {} // Botoes a adicionar

aAdd(aButtons, {"Imprimir Pedido OLD", "U_MGTPECOM('SC7', R_E_C_N_O_,1)", 0, 7, 0, Nil})
// aadd(aButtons,{'IMPRIME',{|| U_MGTPECOM()},'Imprimir Pedido','Imprimir.'}) 
// aadd(aButtons,{ 'NOTE'      ,{||  U_Desconto() },'Desconto','Desc' } )

Return (aButtons )
