#INCLUDE "TOPCONN.CH"

User Function ACD100ET()

	PA1->(DbSetOrder(1))
	PA1->(DbSeek(xFilial("PA1")+CB7->CB7_ORDSEP))
	RecLock("PA1",.F.)
	PA1->PA1_STATUS := "1"
	MsUnlock()
Return