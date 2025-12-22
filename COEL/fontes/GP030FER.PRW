#Include 'Protheus.ch'
#INCLUDE "TOTVS.CH"

User Function GP030FER()

	Local NX := 1
	Local nProvento := 0
	Local nDesconto := 0
    Local cAlias := 'TRB'
    // verba de A1 à A4 verbas calculo de ferias
	Local aVerba :=  iif(SRR->RR_ROTEIR=='FER',{'A01','A02','A03','A04'},;
                        iif(SRR->RR_ROTEIR=='RES',{'A05','A06','A07','A08'},{}))

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
					nProvento += SRR->RR_VALOR
				elseif SRV->RV_TIPOCOD =='2' .and. SRV->RV_INSS=='S'
					nDesconto += SRR->RR_VALOR
				endif
			endif
			SRR->(DBSKIP())
		EndDo
	ENDIF
    // BASE DE CALCULO
	nBaseCalc := nProvento - nDesconto

    // gravar a verba de acordo com o calculo
	IF nBaseCalc > 0
		for NX := 1 to Len(aVerba)
                // calculo inss empresa
            if aVerba[nX]=='A01' .Or. aVerba[nX]=='A05'
                nValorVerba := nBaseCalc * 0.2
                //calculo terceiros.
            elseif aVerba[nX]=='A02' .Or. aVerba[nX]=='A06'
                // nPercTer := posicione('SRV',2,xFilial('SRV')+'0149','RV_XTERCEI')
                nValorVerba := nBaseCalc * 0.058
                //calculo acident trabalho.
            elseif aVerba[nX]=='A03' .Or. aVerba[nX]=='A07'
                if SRR->RR_FILIAL == '01' // Manaus
                    nValorVerba := nBaseCalc * 0.020312
                elseif SRR->RR_FILIAL == '02' // Sao paulo
                    nValorVerba := nBaseCalc * 0.01
                endif
                //calculo FGTS.
            elseif aVerba[nX]=='A04' .Or. aVerba[nX]=='A08'
                nValorVerba := nBaseCalc * 0.08
            endif

            cAlias := GetNextAlias()
            BEGINSQL ALIAS cAlias
                SELECT MAX(RR_CODB1T) SEQ FROM %Table:SRR%  RR
                WHERE RR.%notdel% AND RR_MAT=%EXP:SRH->RH_MAT%
                AND RR_DATA =%EXP:DTOS(SRR->RR_DATA)%
            ENDsQL

            // SRR->(DBSEEK(XFILIAL('SRH')+M->RH_MAT+M->RH_PERIODO))
			Reclock('SRR',.T.)
                SRR->RR_FILIAL  := SRH->RH_FILIAL
                SRR->RR_MAT     := SRH->RH_MAT
                SRR->RR_PD      := aVerba[nX]
                SRR->RR_NOME    := SRA->RA_NOME
                SRR->RR_VALOR   := nValorVerba
                SRR->RR_VALORBA := nValorVerba
                SRR->RR_TIPO1   := 'V'
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

			SRR->(MSUNLOCK())
		next
	endif
Return
