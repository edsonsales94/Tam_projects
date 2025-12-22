#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  01/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AJUSTES()
	Processa( {||Ajuste3()},'Processando')
	Alert("Finalizado")
Return
/*
Static Function Ajuste1
	Local cQuery := ""

	cQuery += " SELECT C1_FILIAL,C1_NUM,C1_ITEM,C1_NROREQ,PA2_CCFIN,C1_CCAPRV,PA2_NUM,PA2_TIPO FROM SC1010 SC1
	cQuery += " INNER JOIN	(
	cQuery += " 			SELECT PA2_FILIAL,PA2_NUM,PA2_CCFIN,PA2_TIPO FROM PA2010
	cQuery += " 			WHERE D_E_L_E_T_ = ''
	cQuery += " 			AND PA2_TIPO = '4'
	cQuery += " 			) AS PA2 ON C1_FILIAL = PA2_FILIAL AND C1_NROREQ = PA2_NUM
	cQuery += " WHERE D_E_L_E_T_ = ''
	cQuery += " AND C1_PEDIDO = ''
	cQuery += " AND C1_RESIDUO = ''
	cQuery += " ORDER BY C1_FILIAL,C1_NUM

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)), "AJUST"  ,.T.,.T.)  
	
	While !AJUST->(Eof())
		PA1->(DbSetOrder(1))
		If PA1->(DbSeek(AJUST->C1_FILIAL+AJUST->PA2_NUM+AJUST->PA2_TIPO))
			SZ6->(DbSetOrder(1))
			If !SZ6->(DbSeek(AJUST->C1_FILIAL+"2"+AJUST->C1_NUM))
				RecLock("SZ6",.T.)
				SZ6->Z6_FILIAL  := AJUST->C1_FILIAL
				SZ6->Z6_TIPO    := "2"
				SZ6->Z6_NUM     := AJUST->C1_NUM
				SZ6->Z6_JUSTIFI := PA1->PA1_JUSTIF
				MsUnLock()
			EndIf
		EndIf
		AJUST->(DbSkip())
	End                          
	DbSelectArea("AJUST")
	DbCloseArea("AJUST")
	Alert("Finalizado com sucesso 2")
Return

Static Function Ajuste2
	Local cQuery := ""

	cQuery += " SELECT * FROM PA5010 PA5"
	cQuery += " INNER JOIN	(
	cQuery += " 			SELECT C7_FILIAL,C7_NUM,C7_NROREQ FROM SC7010
	cQuery += " 			WHERE D_E_L_E_T_ = '' AND C7_NROREQ <> ''
	cQuery += " 			GROUP BY C7_FILIAL,C7_NUM,C7_NROREQ
	cQuery += " 			) AS SC7 ON PA5_NUM = C7_NROREQ
	cQuery += " WHERE PA5.D_E_L_E_T_ = ''
	cQuery += " AND PA5_TIPO = '2'
	cQuery += " ORDER BY C7_FILIAL,C7_NUM,PA5_ITEM
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)), "AJUST"  ,.T.,.T.)  
	
	While !AJUST->(Eof())
		DbSelectArea("SZF")
		RecLock("SZF",.T.)
		SZF->ZF_FILIAL := AJUST->C7_FILIAL  
		SZF->ZF_NUM		:= AJUST->C7_NUM
		SZF->ZF_TIPO	:= "2"
		SZF->ZF_ITEM	:= AJUST->PA5_ITEM
		SZF->ZF_ARQSRV	:= AJUST->PA5_ARQSRV
		MsUnLock()
		AJUST->(DbSkip())
	End                          
	DbSelectArea("AJUST")
	DbCloseArea("AJUST")
	Alert("Finalizado com sucesso")
Return
*/
/*** gravacao DO TRECHO, CC FINANCIADOR E HOTEL E VEICULO DAS VIAGENS **/

Static Function Ajuste3()
	Local cQuery := ""
	cQuery += " SELECT Z7_FILIAL,Z7_CODIGO,Z7_REQUIS,Z7_EMISSAO,Z7_DESCRI
	cQuery += "   ,PA2_CCFIN,PA2_DCCFIN,PA2_RATCC
	cQuery += "   ,PA2_TRECHO,PA2_DT_IDA,PA2_DT_RET,PA2_PASSAG,PA2_TOBS
	cQuery += "   ,PA2_HPER,PA2_HTIPO,PA2_HQTD,PA2_HTARIF,PA2_HOBS,PA2_VPER,PA2_VTIPO,PA2_VQTD,PA2_VTARIF,PA2_VOBS
	cQuery += " FROM SZ7010 SZ7
	cQuery += " INNER JOIN PA2010 PA2 ON Z7_FILIAL = PA2_FILIAL AND Z7_REQUIS = PA2_NUM AND PA2.D_E_L_E_T_ = '' AND PA2_TIPO = '1'
	cQuery += " WHERE SZ7.D_E_L_E_T_ = ''
	cQuery += " AND Z7_REQUIS <> ''
	cQuery += " AND Z7_EMISSAO >= '20100101'
	cQuery += " AND Z7_EMISSAO < '20100601'
	cQuery += " ORDER BY Z7_FILIAL,Z7_CODIGO
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)), "AJVIAGEM"  ,.T.,.T.)  
	TcSetField("AJVIAGEM","PA2_DT_IDA","D")  
	TcSetField("AJVIAGEM","PA2_DT_RET","D")  
	ProcRegua(2000)
	
   Begin Transaction
	While !AJVIAGEM->(Eof())
		If !Empty(AJVIAGEM->PA2_CCFIN)
			DbSelectArea("SZH")
			DbSetOrder(1)
			If !DbSeek(AJVIAGEM->Z7_FILIAL+AJVIAGEM->Z7_CODIGO+AJVIAGEM->PA2_CCFIN)
				RecLock("SZH",.T.)
				SZH->ZH_FILIAL	:= AJVIAGEM->Z7_FILIAL
				SZH->ZH_NUM		:= AJVIAGEM->Z7_CODIGO
				SZH->ZH_CCFIN	:= AJVIAGEM->PA2_CCFIN
				SZH->ZH_DESCFIN:= AJVIAGEM->PA2_DCCFIN
				SZH->ZH_PERCFIN:= AJVIAGEM->PA2_RATCC
				MsUnLock()
			EndIf
		EndIf

		If !Empty(AJVIAGEM->PA2_TRECHO)
			DbSelectArea("SZI")
			RecLock("SZI",.T.)
			SZI->ZI_FILIAL	:= AJVIAGEM->Z7_FILIAL
			SZI->ZI_NUM		:= AJVIAGEM->Z7_CODIGO
			SZI->ZI_PERC	:= AJVIAGEM->PA2_TRECHO
			SZI->ZI_DTIDA	:= AJVIAGEM->PA2_DT_IDA
			SZI->ZI_DTVOLTA:= AJVIAGEM->PA2_DT_RET
			SZI->ZI_VALOR	:= AJVIAGEM->PA2_PASSAG
			SZI->ZI_OBS		:= AJVIAGEM->PA2_TOBS
			MsUnLock()
		EndIf
		If !Empty(AJVIAGEM->PA2_HPER)
			DbSelectArea("SZJ")
			DbSetOrder(1)
			If !DbSeek(AJVIAGEM->Z7_FILIAL+AJVIAGEM->Z7_CODIGO+AJVIAGEM->PA2_HPER)
				RecLock("SZJ",.T.)
				SZJ->ZJ_FILIAL	:= AJVIAGEM->Z7_FILIAL
				SZJ->ZJ_NUM		:= AJVIAGEM->Z7_CODIGO
				SZJ->ZJ_PERIODO:= AJVIAGEM->PA2_HPER
				SZJ->ZJ_TIPOAP	:= AJVIAGEM->PA2_HTIPO
				SZJ->ZJ_QUANT	:= AJVIAGEM->PA2_HQTD
				SZJ->ZJ_TARIFA	:= AJVIAGEM->PA2_HTARIF
				SZJ->ZJ_OBSERV	:= AJVIAGEM->PA2_HOBS
				MsUnLock()
			EndIf                    
		EndIf	

		If !Empty(AJVIAGEM->PA2_VPER)
			DbSelectArea("SZK")
			DbSetOrder(2)      
			If !DbSeek(AJVIAGEM->Z7_FILIAL+AJVIAGEM->Z7_CODIGO+AJVIAGEM->PA2_VPER)
				RecLock("SZK",.T.)
				SZK->ZK_FILIAL	:= AJVIAGEM->Z7_FILIAL
				SZK->ZK_NUM		:= AJVIAGEM->Z7_CODIGO
				SZK->ZK_PERIODO:= AJVIAGEM->PA2_VPER
				SZK->ZK_TIPO	:= AJVIAGEM->PA2_VTIPO
				SZK->ZK_QUANT	:= AJVIAGEM->PA2_VQTD
				SZK->ZK_TARIFA	:= AJVIAGEM->PA2_VTARIF
				SZK->ZK_OBS		:= AJVIAGEM->PA2_VOBS
				MsUnLock()
			EndIf                    
		EndIf	

		AJVIAGEM->(DbSkip())
		IncProc()
	End                          
   End Transaction

	DbSelectArea("AJVIAGEM")
	DbCloseArea("AJVIAGEM")
	Alert("Finalizado com sucesso")
Return Nil
