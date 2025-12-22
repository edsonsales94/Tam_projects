#Include 'Protheus.ch'
#INCLUDE "TOTVS.CH"

User Function GP030FER()

	Local NX 			:= 1
	Local nProvINSS 	:= 0
	Local nDescINSS 	:= 0
	Local nBaseInss 	:= 0
	Local nBaseDecimo 	:= 0
	Local nProvDecimo	:= 0
	Local nBaseSal		:= 0
	Local nProvFGTS 	:= 0
	Local nFGTSSAL 		:= 0
	Local nFGTSDec 		:= 0
	Local cAlias	 	:= 'TRB'
	// verba de A1 à A4 verbas calculo de ferias
	Local aVerba :=  {'A01','A02','A03','A04','B04'}

	// verificar as verbas do calculo de ferias
	// a soma de todos os proventos menos a soma de todos os descontos
	SRR->(DBSETORDER(4))
	IF SRR->(DBSEEK(XFILIAL('SRH')+M->RH_MAT+M->RH_PERIODO))
		while !SRR->(EOF()) .AND. M->RH_MAT+M->RH_PERIODO ==  SRR->RR_MAT+SRR->RR_PERIODO
			cRoteiro  := SRR->RR_ROTEIR
			dData     := SRR->RR_DATA
			cTipo3    := SRR->RR_TIPO3
			cCc       := SRR->RR_CC
			dDataPag  := SRR->RR_DATAPAG
			cPeriodo  := SRR->RR_PERIODO
			cProcess  := SRR->RR_PROCES

			SRV->(DBSETORDER(1))
			if SRV->(DBSEEK(XFILIAL('SRV')+SRR->(RR_PD)))
				// TIPO 1 = PROVENTO | 2 = DESCONTO
				if SRV->RV_TIPOCOD =='1' .and. SRV->RV_INSS=='S'
					nProvINSS += SRR->RR_VALOR
				elseif SRV->RV_TIPOCOD =='2' .and. SRV->RV_INSS=='S'
					nDescINSS += SRR->RR_VALOR
				endif

				if SRV->RV_TIPOCOD =='1' .and. SRV->RV_FGTS=='S' .AND. SRV->RV_REF13 ='S'
					nProvDecimo += SRR->RR_VALOR
				elseif SRV->RV_TIPOCOD =='1' .and. SRV->RV_FGTS=='S' .AND. SRV->RV_REF13 ='N'
					nProvFGTS += SRR->RR_VALOR
					// elseif SRV->RV_TIPOCOD =='2' .and. SRV->RV_INSS=='S'
					// 	nDescINSS += SRR->RR_VALOR
				endif
			endif
			SRR->(DBSKIP())
		EndDo
	ENDIF

	// BASE DE CALCULO
	nBaseInss 	:= nProvINSS - nDescINSS   // BASE DE CALCULO DAS VERBAS QUE RESCIDE INSS.
	nBaseDecimo := nProvDecimo			   // BASE DE CALCULO DAS VERBAS QUE RESCIDE DECIMO EM CASO DE ADIANTAMENTO NAS FERIAS.
	nBaseSal 	:= nProvFGTS       		   // BASE DE CALCULO DAS VERBAS QUE RESCIDE FGTS.

	for NX := 1 to Len(aVerba)
		// gravar a verba de acordo com o calculo
		IF nBaseInss > 0
			// calculo inss empresa
			if aVerba[nX]=='A01'
				nVerbaINSS := nBaseInss * 0.2
				//calculo terceiros.
			elseif aVerba[nX]=='A02'
				// nPercTer := posicione('SRV',2,xFilial('SRV')+'0149','RV_XTERCEI')
				nVerbaINSS := nBaseInss * 0.058
				//calculo acident trabalho.
			elseif aVerba[nX]=='A03'
				if SRR->RR_FILIAL == '01' // Manaus
					nVerbaINSS := nBaseInss * 0.020312
				elseif SRR->RR_FILIAL == '02' // Sao paulo
					nVerbaINSS := nBaseInss * 0.01
				endif
			endif
		endif

		if nBaseSal > 0
			//calculo FGTS referente salario
			if aVerba[nX]=='A04'
				nFGTSSAL := nBaseSal * 0.08
			endif
		endif

		if nBaseDecimo > 0
			//calculo FGTS Referente decimo
			if aVerba[nX]=='B04'
				nFGTSDec := nBaseDecimo * 0.08
			endif
		endif

		// RETORNA O VALOR DA VERBA A SER GRAVADA
		nVerba := iif((aVerba[nX]=='A01' .OR. aVerba[nX]=='A02' .OR. aVerba[nX]=='A03'),nVerbaINSS,;
			IIF(aVerba[nX]=='A04',nFGTSSAL ,IIF(aVerba[nX]=='B04',nFGTSDec ,0)))

		cAlias := GetNextAlias()
		BEGINSQL ALIAS cAlias
                SELECT MAX(RR_CODB1T) SEQ FROM %Table:SRR%  RR
                WHERE RR.%notdel% AND RR_MAT=%EXP:SRH->RH_MAT%
                AND RR_DATA =%EXP:DTOS(SRR->RR_DATA)%
		ENDsQL

		if nVerba > 0  // SE HOVER VALOR GRAVA A VERBA
			Reclock('SRR',.T.)
			SRR->RR_FILIAL  := SRH->RH_FILIAL
			SRR->RR_MAT     := SRH->RH_MAT
			SRR->RR_PD      := aVerba[nX]
			SRR->RR_NOME    := SRA->RA_NOME
			SRR->RR_VALOR   := nVerba
			SRR->RR_VALORBA := nVerba
			SRR->RR_TIPO1   := 'V'
			SRR->RR_TIPO2   := 'F'
			SRR->RR_DATA    := dData
			SRR->RR_TIPO3   := cTipo3
			SRR->RR_PERIODO := cPeriodo
			SRR->RR_ROTEIR  := cRoteiro
			SRR->RR_SEMANA  := '01'
			SRR->RR_DATAPAG := dDataPag
			SRR->RR_CC      := cCc
			// SRR->RR_SEQ     := SOMA1((cAlias)->(SEQ))
			// SRR->RR_CODB1T  := SOMA1((cAlias)->(SEQ))
			SRR->RR_PROCES := cProcess
			nVerba := 0
			SRR->(MSUNLOCK())
		endif
	next nX
Return
