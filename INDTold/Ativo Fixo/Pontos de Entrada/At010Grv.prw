#include "rwmake.ch" 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para gravar dados da nota fiscal do cadastro do bem  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/* MATA119 - despesa de importação
   MATA116 - conhecimento de Frete
   
*/
User Function AT010GRV
	
   If Trim(FunName()) == 'MATA103' .OR. trim(FunName()) == 'MATA119' .OR. Trim(FunName()) == 'MATA116'// Nota fiscal de entrada     
      //- Atualizando SN1                                    
      Reclock("SN1",.F.)             
      SN1->N1_DESCRIC := SD1->D1_DESCRI
      SN1->N1_XPRCOMP := IIF(EMPTY(SD1->D1_PEDIDO),SD1->D1_PRCOMP,SD1->D1_PEDIDO)
      MSUNLOCK()  
   Endif  
return
