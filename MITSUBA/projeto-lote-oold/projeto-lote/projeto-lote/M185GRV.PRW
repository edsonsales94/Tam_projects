#Include "RwMake.CH"
#Include "PRTOPDEF.CH"
#include "tbiconn.ch"
#include "protheus.ch"

User Function M185GRV()
Local cArm := SuperGetMV("MV_X_PARAM", .F., "10") ///  passa armazem de processo
	Processa({|| U_MIJOBEND(ALLTRIM(cArm))}, 'Processando...')
Return
