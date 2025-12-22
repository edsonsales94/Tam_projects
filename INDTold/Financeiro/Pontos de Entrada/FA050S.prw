#include "RWMAKE.CH"

/*_____________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+--------------------------------------------+------+------------+¦¦
¦¦¦ Função    ¦ FA050S     ¦ Wermeson Gadelha do Canto                  ¦ Data ¦ 04/02/2009 ¦¦¦
¦¦+-----------+------------+--------------------------------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada para manipular os dados do titulo substituido              ¦¦¦
¦¦+-----------+-----------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FA050S()
   M->E2_MULTNAT := SE2->E2_MULTNAT
   M->E2_NATUREZ := SE2->E2_NATUREZ                
   M->E2_NROPRV  := SE2->E2_NROPRV
   M->E2_VENCTO  := SE2->E2_VENCTO
   M->E2_VENCREA := SE2->E2_VENCREA
   M->E2_ITEMCTA := SE2->E2_ITEMCTA  
   M->E2_TREINAM := SE2->E2_TREINAM 
   M->E2_CLVL    := SE2->E2_CLVL                   	
   M->E2_CONFIRM := SE2->E2_CONFIRM  
   M->E2_CC      := SE2->E2_CC      
   M->E2_EMIS1   := SE2->E2_EMIS1   
   M->E2_VENCORI := SE2->E2_VENCORI 
   M->E2_SALDO   := SE2->E2_SALDO   
   M->E2_MOEDA   := SE2->E2_MOEDA
   M->E2_FLUXO   := SE2->E2_FLUXO
   M->E2_RATEIO  := SE2->E2_RATEIO
   M->E2_OCORREN := SE2->E2_OCORREN
   M->E2_ORIGEM  := SE2->E2_ORIGEM
   M->E2_DESDOBR := SE2->E2_DESDOBR
   M->E2_PROJPMS := SE2->E2_PROJPMS
   M->E2_DIRF    := SE2->E2_DIRF
   M->E2_MODSPB  := SE2->E2_MODSPB
   M->E2_NROREQ  := SE2->E2_NROREQ
   M->E2_TIPOREQ := SE2->E2_TIPOREQ
Return 

