#include "Protheus.ch"
User Function INCOMP03()
   Local cFilter := SCR->(dbFilter())
   Local _adArea := GetArea()
   //Aviso('',cFilter,{''},3) 
   //CR_FILIAL=="01".And.
   //AVISO('', 'CR_FILIAL=="' + SCR->(xFilial("SCR"))+ '".And.',{'ER'},3 )
   cFilter := StrTran(cFilter,'CR_FILIAL=="' + SCR->(xFilial("SCR"))+ '".And.',"" )   
   //Aviso('',cFilter,{''},3) 
   dbSelectArea("SCR")
   Set Filter To &(cFilter)
   RestArea(_adArea)
Return Nil
