#include "Protheus.ch"

User Function MT103IPC()
	Local nPDesc := AScan(aHeader,{|x|AllTrim(x[2])=="D1_X_DESCR"})
	Local _cDescr   := ""

	_cDescr := SC7->C7_DESCRI
	aCols[PARAMIXB[1]][nPDesc] :=_cDescr
Return

