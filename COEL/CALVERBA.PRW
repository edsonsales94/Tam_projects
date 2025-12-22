#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

User Function CALVERBA()
	local NRET := 0
	NRET := 10
	ncont := 0
	nProvento := 0
	nDesconto := 0
	SRR->(DBSETORDER(4))
	IF SRR->(DBSEEK(XFILIAL('SRH')+SRH->RH_MAT+SRH->RH_PERIODO))
		while !SRR->(EOF()) .and. ncont <= 10
			// SRV->(DBSETORDER(4))
			// if SRV->(DBSEEK(XFILIAL('SRV')+SRR->(RR_PD)))
			// 	if SRV->RV_TIPOCOD =='1'
			// 		nProvento += SRR->RR_VALOR
			// 	elseif SRV->RV_TIPOCOD =='2'
			// 		nDesconto += SRR->RR_VALOR
			// 	endif
			// endif
			ncont++
			SRR->(DBSKIP())
		EndDo
	ENDIF
    nBaseCalc := nProvento - nDesconto
Return







