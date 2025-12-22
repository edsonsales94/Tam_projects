#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02

// Ponto Entrada

User Function MT120LOK()

_nPos	   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) = "C7_PRODUTO"})
_cProduto  := aCols[n,_nPos]

_nPos	   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) = "C7_X_FABRI"})
_cFabrica  := aCols[n,_nPos]


IF ( !EMPTY(_cFabrica) )
	dbselectarea("SZJ")
	dbsetorder(1)
	dbseek(xFilial() + _cProduto)
	if !eof()     // produto com fabricante
		dbseek(xFilial() + _cProduto + _cFabrica)
		if eof()
			msgbox("Fabricante nao cadastrado para este produto")
			return(.f.)
		endif
	endif
ENDIF
         
   
return( .T. )
