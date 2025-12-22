#include "rwmake.ch"

User Function R050IMP()

if SM0->M0_CODIGO == "03"    // Manaus
   // altera local padrao na importacao de registro SB1
   if paramixb[1] == "SB1"
      reclock("SB1",.F.)
      SB1->B1_LOCPAD:= "03"
      msunlock()
   endif
endif
