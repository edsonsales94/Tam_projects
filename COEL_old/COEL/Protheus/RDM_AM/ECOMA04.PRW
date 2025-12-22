#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function ECOMA04()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

_nPos	   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) = "D1_COD"})
_cProduto  := aCols[n,_nPos]

dbselectarea("SZJ")
dbseek(xFilial() + _cProduto + M->D1_X_FABRI)
if eof() .and. !empty(M->D1_X_FABRI)
   msgbox("Fabricante nao cadastrado para este produto")
   return(.f.)
else
   return(.t.)
endif
