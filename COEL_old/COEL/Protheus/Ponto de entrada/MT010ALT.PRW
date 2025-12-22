#include "rwmake.ch"

User Function mt010alt
Local _cAlias

_cAlias:= alias()

// atualiza informacoes em complemento de produto
dbselectarea("SB5")
dbsetorder(1)
dbseek(xFilial() + SB1->B1_COD)
if !eof()
   reclock("SB5",.F.)
   SB5->B5_CEME:= SB1->B1_DESCOMP
   msunlock()
endif

// atualiza informacoes em fabricante x produto
dbselectarea("SZJ")
dbsetorder(1)
dbseek(xFilial() + SB1->B1_COD)
while !eof() .and. ZJ_COD == SB1->B1_COD
   reclock("SZJ",.F.)
    SZJ->ZJ_DESC := SB1->B1_DESC
    SZJ->ZJ_NARRA:= SB1->B1_NARRA
   msunlock()
   dbskip()
enddo

dbselectarea(_cAlias)

Return( .T. )
