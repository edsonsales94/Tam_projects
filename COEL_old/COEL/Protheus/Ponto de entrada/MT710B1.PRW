#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function MT710B1()

if SM0->M0_CODIGO == "03"    // Manaus
   IF SB1->B1_X_MRPAM == "S"
      RETURN(.T.)
   ELSE
      RETURN(.F.)
   ENDIF
endif
