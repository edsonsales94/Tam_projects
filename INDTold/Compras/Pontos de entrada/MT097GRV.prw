#include "RWMAKE.CH"

User Function MT097GRV
   Local cFuncao := AllTrim(FunName())

   If cFuncao == "MATA097"
      If Alltrim(ProcName(3)) == "A097LIBERA"
//       u_INEnviaEmail(SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_NUMSC,1,"")   // Envia e-mail para os aprovadores
      Endif
   Endif       

Return .T.

