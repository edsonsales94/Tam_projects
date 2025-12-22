/*
Solicitacao do Sr. Rafael Bocchi em 16/05/13
*/
#Include "PROTHEUS.CH"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 02/09/02
#include "TOTVS.CH"
#include "ap5mail.ch"
#INCLUDE "TBICONN.CH"
#include "TbiCode.ch"

User Function FT210OPC()

Local  c_Alias := ALIAS()

IF ( !M->__cUserId $ "000279|000312|000316|000000|000088" )
	MsgStop("Usuário s/permissão pra executar essa rotina.","Solicitar permissão")
	Return(0)
ENDIF
	
dbSelectArea(c_Alias)

Return(1)