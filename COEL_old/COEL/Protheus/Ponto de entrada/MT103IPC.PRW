#include "rwmake.ch"

User Function mt103ipc()
Local nLin    

//if SM0->M0_CODIGO == "03"

   nLin:= LEN(ACOLS)
   nposcampo:= ascan( aheader , { |x| alltrim(x[2]) == "D1_X_FABRI" } )
   acols[nLin,nposcampo]:= SC7->C7_X_FABRI

//endif
