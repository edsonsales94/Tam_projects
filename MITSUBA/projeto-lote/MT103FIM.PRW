#Include "RwMake.CH"
#Include "PRTOPDEF.CH"
#include "tbiconn.ch"
#include "protheus.ch"


User Function MT103FIM()
	Processa({|| U_MIJOBEND(SD1->D1_LOCAL)}, 'Processando...')
Return
