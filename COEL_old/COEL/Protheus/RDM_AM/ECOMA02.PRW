#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function ECOMA02()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

_nPos	   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) = "C7_PRODUTO"})
_cProduto  := aCols[n,_nPos]

return( _cProduto )
