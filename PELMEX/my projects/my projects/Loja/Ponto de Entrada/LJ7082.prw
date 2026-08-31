#INCLUDE "TOTVS.CH"

User Function LJ7082()

Local lRet := .T.

//o ponteiro já está posicionado sobre o cabeçalho da venda
If SL1->L1_VLRTOT <= 0
   lRet := .F.
EndIf

Return lRet