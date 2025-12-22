#include "Protheus.ch"
#include "FWMVCDEF.CH"

User Function GPEM040()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local cIdPonto   := ''
	Local cIdModel   := ''

	// Local nLinha     := 0
	// Local nQtdLinhas := 0
	Local oObj         := ''
	Local NX 		   := 1
	Local nVerba       := 0
	Local nProINSS    := 0
	Local nDesINSS    := 0
	Local nProvSal := 0
	Local nDescSal := 0
	Local nProvDecimo := 0
	Local nDescDecimo := 0
	Local cAlias := 'TRB'
	// verba de A1 à A4 verbas calculo de ferias
	// verba de A5 à A8 verbas calculo de recisão
	Local aVerba :=  iif(M->RG_ROTEIR=='RES',{'A05','A06','A07','A08','B08'},{})

	// verificar as verbas do calculo de ferias
	// a soma de todos os proventos menos a soma de todos os desConto.
	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

		If cIdPonto == 'MODELCOMMITTTS' .and. Inclui // s� na inclusao.
			SRR->(dbGoTop())
			SRR->(DBSETORDER(11))
			// RR_FILIAL+RR_MAT+RR_PERIODO+RR_ROTEIR
			cseek := SRG->(RG_FILIAL+RG_MAT+RG_PERIODO+RG_ROTEIR+RG_SEMANA+DTOS(RG_DTGERAR))
			IF SRR->(DBSEEK(cseek))
				while !SRR->(EOF()) .AND. cseek ==  SRR->(RR_FILIAL+RR_MAT+RR_PERIODO+RR_ROTEIR+RR_SEMANA+DTOS(RR_DATA))
					_cFilialSRR  := SRR->RR_FILIAL
					_cMat  := SRR->RR_MAT
					cRoteiro  := SRR->RR_ROTEIR
					dData     := SRR->RR_DATA
					cTipo3    := SRR->RR_TIPO3
					cCc       := SRR->RR_CC
					dDataPag  := SRR->RR_DATAPAG
					dDTREF    := SRR->RR_DTREF
					cPeriodo  := SRR->RR_PERIODO
					cProcess  := SRR->RR_PROCES

					SRV->(DBSETORDER(1))
					if SRV->(DBSEEK(XFILIAL('SRV')+SRR->(RR_PD)))
						// TIPO 1 = PROVENTO | 2 = DESCONTO
						if SRV->RV_TIPOCOD =='1'
							IF (SRV->RV_INSS=='S' )  // INSS
								nProINSS += SRR->RR_VALOR
							EndIf
							IF (SRV->RV_FGTS=='S'  .AND. SRV->RV_REF13 == 'N')  // FGTS SALARIO
								nProvSal += SRR->RR_VALOR
							EndIf
							IF (SRV->RV_FGTS=='S'  .AND. SRV->RV_REF13 == 'S')  // FGTS DECIMO
								nProvDecimo += SRR->RR_VALOR
							EndIf

						elseif SRV->RV_TIPOCOD =='2'
							IF (SRV->RV_INSS=='S' )  // DECIMO
								nDesINSS += SRR->RR_VALOR
							EndIf
							IF (SRV->RV_FGTS=='S' .AND. SRV->RV_REF13 == 'N')  //DESCONTO FGTS SALARIO
								nDescSal += SRR->RR_VALOR
							EndIf
							IF (SRV->RV_FGTS=='S'  .AND. SRV->RV_REF13 == 'S')  //DESCONTO FGTS DECIMO
								nDescDecimo += SRR->RR_VALOR
							EndIf

						endif
					endif
					SRR->(DBSKIP())
				EndDo
			ENDIF
			//BASE DE CALCULO
			nBaseINSS 	 := nProINSS    - nDesINSS
			nBaseSal 	 := nProvSal 	- nDescSal
			nBaseDecimo	 := nProvDecimo - nDescDecimo

			// gravar a verba de acordo com o calculo
			for NX := 1 to Len(aVerba)
				IF nBaseINSS > 0
					// calculo inss empresa
					if aVerba[nX]=='A05'
						nVerbaINSS := nBaseINSS * 0.2
						//calculo terceiros.
					elseif aVerba[nX]=='A06'
						// nPercTer := posicione('SRV',2,xFilial('SRV')+'0149','RV_XTERCEI')
						nVerbaINSS := nBaseINSS * 0.058
						//calculo acident trabalho.
					elseif aVerba[nX]=='A07'
						if SRR->RR_FILIAL == '01' // Manaus
							nVerbaINSS := nBaseINSS * 0.020312
						elseif SRR->RR_FILIAL == '02' // Sao paulo
							nVerbaINSS := nBaseINSS * 0.01
						endif
					endif
				endif

				if nBaseSal > 0
					//calculo FGTS.
					if aVerba[nX]=='A08'
						nFGTSSAL := nBaseSal * 0.08
					endif
				endif
				if nBaseDecimo> 0
					//calculo FGTS.
					if aVerba[nX]=='B08'
						nFGTSDec := nBaseDecimo* 0.08
					endif
				endif

				// RETORNA O VALOR DA VERBA A SER GRAVADA
				nVerba := iif((aVerba[nX]=='A05' .OR. aVerba[nX]=='A06' .OR. aVerba[nX]=='A07'),nVerbaINSS,;
					IIF(aVerba[nX]=='A08',nFGTSSAL ,IIF(aVerba[nX]=='B08',nFGTSDec ,0)))

				cAlias := GetNextAlias()
				BEGINSQL ALIAS cAlias
                        SELECT MAX(RR_CODB1T) SEQ FROM %Table:SRR%  RR
                        WHERE RR.%notdel% AND RR_MAT=%EXP:SRH->RH_MAT%
                        AND RR_DATA =%EXP:DTOS(SRR->RR_DATA)%


				ENDsQL

				if nVerba > 0  // SE HOVER VALOR GRAVA A VERBA
					// SRR->(DBSEEK(XFILIAL('SRH')+M->RH_MAT+M->RH_PERIODO))
					Reclock('SRR',.T.)
					SRR->RR_FILIAL  := _cFilialSRR
					SRR->RR_MAT     := _cMat
					SRR->RR_PD      := aVerba[nX]
					SRR->RR_NOME    := SRA->RA_NOME
					SRR->RR_VALOR   := nVerba
					SRR->RR_VALORBA := nVerba
					SRR->RR_TIPO1   := 'V'
					SRR->RR_TIPO2   := 'R'
					SRR->RR_DATA    := dData
					SRR->RR_TIPO3   := cTipo3
					SRR->RR_PERIODO := cPeriodo
					SRR->RR_ROTEIR  := cRoteiro
					SRR->RR_SEMANA  := '01'
					SRR->RR_DATAPAG := dDataPag
					SRR->RR_CC      := cCc
					// SRR->RR_SEQ     := SOMA1((cAlias)->(SEQ))
					// SRR->RR_CODB1T  := SOMA1((cAlias)->(SEQ))
					SRR->RR_DTREF  := dDTREF
					SRR->RR_PROCES := cProcess
					SRR->(MSUNLOCK())

					nVerba := 0
				endif
			next nX
		EndIf
	EndIf
Return xRet


// IF SRR->(DBSEEK(cseek))
// 				while !SRR->(EOF()) .AND. cseek ==  SRR->(RR_FILIAL+RR_MAT+RR_PERIODO+RR_ROTEIR+RR_SEMANA+DTOS(RR_DATA))
// 					_cFilialSRR  := SRR->RR_FILIAL
// 					_cMat  := SRR->RR_MAT
// 					cRoteiro  := SRR->RR_ROTEIR
// 					dData     := SRR->RR_DATA
// 					cTipo3    := SRR->RR_TIPO3
// 					cCc       := SRR->RR_CC
// 					dDataPag  := SRR->RR_DATAPAG
// 					cPeriodo  := SRR->RR_PERIODO
// 					cProcess  := SRR->RR_PROCES

// 					SRV->(DBSETORDER(1))
// 					if SRV->(DBSEEK(XFILIAL('SRV')+SRR->(RR_PD)))
// 						// TIPO 1 = PROVENTO | 2 = DESCONTO
// 						if SRV->RV_TIPOCOD =='1'
// 							IF (SRV->RV_INSS=='S' )  // DECIMO
// 								nProINSS += SRR->RR_VALOR
// 							EndIf
// 							IF (SRV->RV_FGTS=='S' )  // DECIMO
// 								nProvSal += SRR->RR_VALOR
// 							EndIf
// 							// IF (SRV->RV_INSS=='S' .and. SRV->RV_REFFER=="S")  // FERIAS
// 							// 	nProFer += SRR->RR_VALOR
// 							// elseIF (SSRV->RV_INSS=='S' .and. SRV->RV_REF13)  // DECIMO
// 							// 	nProDec += SRR->RR_VALOR
// 							// EndIf
// 						elseif SRV->RV_TIPOCOD =='2'
// 							IF (SRV->RV_INSS=='S' )  // DECIMO
// 								nDesINSS += SRR->RR_VALOR
// 							EndIf
// 							IF (SRV->RV_FGTS=='S' )  // DECIMO
// 								nDesFGTS += SRR->RR_VALOR
// 							EndIf
// 							// IF (SRV->RV_INSS=='S' .and. SRV->RV_REFFER=="S") // FERIAS
// 							// 	nDesFer += SRR->RR_VALOR
// 							// elseIF (SSRV->RV_INSS=='S' .and. SRV->RV_REF13)  // DECIMO
// 							// 	nDesDec += SRR->RR_VALOR
// 							// EndIf
// 						endif
// 					endif
// 					SRR->(DBSKIP())
// 				EndDo
// 			ENDIF
