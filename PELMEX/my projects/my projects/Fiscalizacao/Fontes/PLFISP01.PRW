#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

User Function PLFISP01(_aTbl,_cPrm,_cQry,_cFiltro,_cOrder)

	cTable := GetNextAlias()
	_cCons := " Select * from " + RetSqlName("SD1")
	_cCOns += " WHere D_E_L_E_T_ = ''
	_cCOns += " ANd " + _cQry
	_cCOns += " Order by " + StrTran(_cOrder,"+",",")
	memowrite("PMQUERY.SQL",_cCOns)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cCons),cTable, .F., .T.)

	(cTable)->(dbGOTop())
	dbSelectArea(cTable)

REturn Nil