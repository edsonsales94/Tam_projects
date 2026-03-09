#Include "RwMake.CH"
#Include "PRTOPDEF.CH"
#include "tbiconn.ch"
#include "protheus.ch"

User Function MIJOBEND(_cLocal)

	// Local lAmb := RpcSetEnv("01", "01", "admin", "MITECH1", "EST", GetEnvServer())
	Local aArea        := GETAREA()
	Local aCabSDA       := {}
	Local aItSDB        := {}
	Local _aItensSDB    := {}
	Local cSDA          := GetNextAlias()
	Local cEnder        := "PADRAO"
	Local cItem         := "0000"
	Local nSaldo        := 0

	Private lMsErroAuto := .F.

	FWLogMsg("Iniciando job TMATA265 - Endereçamento automático")

	// Fecha áreas se já estiverem abertas
	If Select(cSDA) > 0
		(cSDA)->(DbCloseArea())
	EndIf

	BEGINSQL ALIAS cSDA
        SELECT DA_DOC,
               DA_NUMSEQ REC,
               DA_PRODUTO,
               DA_SALDO,
               DA_CLIFOR,
               DA_LOCAL
        FROM %table:SDA% SDA
        WHERE SDA.%NOTDEL%
          AND DA_LOCAL = %exp:_cLocal%
          AND DA_SALDO > %exp:nSaldo%
        ORDER BY DA_LOCAL
	ENDSQL

	DbSelectArea(cSDA)
	(cSDA)->(DbGoTop())

	While !(cSDA)->(EoF())

		FWLogMsg("Processando produto: " + (cSDA)->DA_PRODUTO)

		_aItensSDB := {}
		aCabSDA    := {}
		aItSDB     := {}
		cEnder     := "PADRAO"
		cItem         := "0000"

		// Gera item incremental
		cItem := Soma1(cItem)
		FWLogMsg("Item gerado: " + cItem)

		// Regra de endereço
		// If (cSDA)->DA_LOCAL == "20"
		// 	If !Empty((cSDA)->DA_CLIFOR) .And. (cSDA)->DA_CLIFOR <> "11663"
		// 		cEnder := "PRONTOCARGO"
		// 	EndIf
		// EndIf

		// Cabeçalho
		aCabSDA := {;
			{"DA_PRODUTO", (cSDA)->DA_PRODUTO, Nil},;
			{"DA_NUMSEQ" , cValToChar((cSDA)->REC), Nil};
			}

		// Item
		aItSDB := {;
			{"DB_ITEM"    , cItem               , Nil},;
			{"DB_ESTORNO" , " "                 , Nil},;
			{"DB_LOCALIZ" , cEnder              , Nil},;
			{"DB_DATA"    , dDataBase           , Nil},;
			{"DB_QUANT"   , (cSDA)->DA_SALDO    , Nil};
			}

		AAdd(_aItensSDB, aItSDB)

		// Execução automática
		FWLogMsg("Chamando MSExecAuto para produto: " + (cSDA)->DA_PRODUTO)

		MSExecAuto({ |x,y,z| MATA265(x,y,z) }, aCabSDA, _aItensSDB, 3)

		If lMsErroAuto
			FWLogMsg("Erro no endereçamento automático para produto: " + (cSDA)->DA_PRODUTO)
		Else
			FWLogMsg("Endereçamento concluído com sucesso para produto: " + (cSDA)->DA_PRODUTO)
		EndIf
		(cSDA)->(DbSkip())

	EndDo


	// Fecha áreas
	If Select(cSDA) > 0
		(cSDA)->(DbCloseArea())
	EndIf


	FWLogMsg("Finalizando job TMATA265")
	// RpcClearEnv()
	RestArea(aArea)
Return
