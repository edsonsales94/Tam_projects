#include "Protheus.ch"
User Function M410GET()
  SC5->(RecLock('SC5',.F.))
     SC5->C5_ORCRES := GetVenda(SC5->C5_FILIAL,SC5->C5_NUM)
     M->C5_ORCRES := GetVenda(SC5->C5_FILIAL,SC5->C5_NUM)
  SC5->(MsUnlock())  

Return Nil


Static Function GetVenda(cdFilial,cdPedido)
  Local cTable  := GetNextAlias()
  
  BeginSql Alias cTable
  Select  * FRom %Table:SL1% SL1
   Where SL1.%NotDel%
     And L1_PEDRES = %Exp:cdPedido%
     and L1_FILIAL = %Exp:cdFilial%
  EndSql
  
  //SL1->(dbGoTo((cTable)->R_E_C_N_O_))
    
  _cdNumero := (cTable)->L1_NUM
  (cTable)->(dbCloseArea(cTable))
  
Return _cdNumero




/*Powered by DXRCOVRB*/