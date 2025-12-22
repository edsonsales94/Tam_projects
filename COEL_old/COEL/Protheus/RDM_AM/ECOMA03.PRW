#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

User Function ECOMA03()        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

_nPos	   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) = "D1_COD"})
_cProduto  := aCols[n,_nPos]

return( _cProduto )
