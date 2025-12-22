#include "rwmake.ch"       

User Function ECOMA01()   

Local _lRsp := .T.

_nPos	   := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) = "C7_PRODUTO"})
_cProduto  := aCols[n,_nPos]

_nPos    := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) = "C7_X_PARTN"})
//_cFabri    := aCols[n,_nPos]

IF ( !EMPTY(M->C7_X_FABRI) )
	dbselectarea("SZJ")
	dbseek(xFilial("SZJ") + _cProduto + M->C7_X_FABRI)
	if eof() .and. !empty(M->C7_X_FABRI)
		msgbox("Fabricante nao cadastrado para este produto")
		_lRsp := .F.
	endif
ELSE
	//IF ( nPos > 0 )
	//	aCols[n,nPos2] := ' '
	//ENDIF	
ENDIF
Return(_lRsp)	
