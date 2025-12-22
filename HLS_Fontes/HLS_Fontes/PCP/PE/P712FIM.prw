#include "totvs.ch"
/*/{Protheus.doc} P712FIM
	pe para substituir o calculo de geracao de necessidade padrao do MRP Memoria 
	pelo calculo customizado do cliente
	@author  ivan.caproni
	@since	 07/10/2023
	@version 1.0
	@type    function
/*/
user function P712FIM()
    local lConcluiu	:= ParamixB[1]
    local cTicket	:= ParamixB[3]
	local lFieldHWB := HWB->( FieldPos("HWB_XBKNEC") > 0 )
	local lFieldHWC := HWC->( FieldPos("HWC_XBKNEC") > 0 )
	local lEnable	:= GetMV("ES_ENBNMRP",,.T.)
	if lFieldHWB .and. lFieldHWC .and. lConcluiu .and. lEnable
		Processa({|| ProcNewQt(cTicket) }, "Aguarde...", "Carregando novas necessidades personalizadas ...",.F.)
	endif
return
/*/{Protheus.doc} ProcNewQt
	processamento principal
	@author  ivan.caproni
	@since	 07/10/2023
	@version 1.0
	@type    function
/*/
static function ProcNewQt(cTicket)
	local cTmp		:= "__TMPMRP__"
	local nSomaPMP	as numeric
	local nSldInici	:= 0
	local nSldFinal	:= 0
	local nLen		as numeric
	local nNeces	as numeric
	local nAux		as numeri
	local nCnt		:= 0
	local nCPrd		:= 0
	local cProd		:= ""

	if Select(cTmp) > 0 ; (cTmp)->( dbClosearea() ) ; endif
	BeginSql alias cTmp
		column HWB_DATA as date
		SELECT HWB_PRODUT, HWB_DATA, B1_XINDICE, B1_QE, HWB.R_E_C_N_O_ RECHWB
		FROM %table:HWB% HWB
		JOIN %table:SB1% SB1
		ON B1_FILIAL=%xFilial:SB1%
			AND B1_COD=HWB_PRODUT
			AND SB1.%notDel%
			AND B1_TIPO NOT IN ('PA','PI')
			AND B1_XINDICE > 0
		WHERE HWB.HWB_FILIAL=%xFilial:HWB%
			AND HWB.HWB_TICKET=%Exp:cTicket%
			AND HWB.%notDel%
		ORDER BY 1,2
	EndSql
	
	Count to nLen
	
	ProcRegua(nLen)
	
	(cTmp)->( dbGotop() )
	
	while (cTmp)->( ! Eof() )
		nCnt ++ ; nCPrd ++
		IncProc("Processando "+cValtochar(nCnt)+" de "+cValtochar(nLen)+" ...")
		ProcessMessages()
		
		HWB->( dbGoto((cTmp)->RECHWB) )

		if HWB->HWB_PRODUT != cProd
			nCPrd := 1
		endif

		If AllTrim(HWB->HWB_PRODUT) == "69293-10020"
			lOk	:= .T.
		Endif

		nSomaPMP := GetPMP(cTicket,(cTmp)->B1_XINDICE,HWB->HWB_PRODUT,HWB->HWB_DATA)
		
		// obtem o saldo inicial/final do periodo calculado pelo sistema somente 
		// no primeiro mes nos demais meses esse valor sera calculado
		if nCPrd == 1
			nSldInici := HWB->HWB_QTSLES
			nSldFinal := HWB->HWB_QTSALD
		else
			nSldFinal := HWB->(nSldInici+HWB_QTENTR+HWB_QTRENT-HWB_QTSAID-HWB_QTSEST-HWB_QTRSAI)
			if nSomaPMP == 0
				nSldInici := nSldFinal
			endif
		endif

		if nSomaPMP >= 0
			nNeces := nSomaPMP - nSldFinal

			if nNeces < 0
				nNeces := 0
			endif
			
			if (cTmp)->B1_QE > 0
				nAux := nNeces % (cTmp)->B1_QE
				if nAux != 0
					nNeces := (Int(Abs(nNeces)/(cTmp)->B1_QE)+1)*(cTmp)->B1_QE
					if nAux < 0 // tratamento para necessidade negativa
						nNeces := nNeces * -1
					endif
				endif
			endif
					
			// if nNeces > HWB->HWB_QTNECE
			Reclock("HWB",.F.)
			HWB->HWB_XBKNEC := HWB->HWB_QTNECE
			HWB->HWB_QTNECE := nNeces
			HWB->HWB_QTSLES := nSldInici
			HWB->( MsUnlock() )

			AjustarHWC(cTicket,HWB->HWB_PRODUT,HWB->HWB_DATA,nNeces,HWB->HWB_XBKNEC)
			// endif
			
			nSldInici := nNeces + nSldFinal
		endif
		
		cProd := HWB->HWB_PRODUT
		(cTmp)->( dbSkip() )
	end
	
	(cTmp)->( dbClosearea() )
return
/*/{Protheus.doc} GetPMP
	ontem o PMP
	@author  ivan.caproni
	@since	 07/10/2023
	@version 1.0
	@type    function
/*/
static function GetPMP(cTicket,nIndice,cProd,dData)
	local nSaldo	:= nIndice
	local nParcial	:= nIndice - Int(nIndice)
	local nPmp		:= 0
	local cTbl		:= GetNextAlias()
	local dDataAux	:= FirstDay(MonthSum(dData,1))

	BeginSql alias cTbl
		SELECT 
			HWB_PRODUT, YEAR(HWB_DATA) ANO, MONTH(HWB_DATA) MES, SUM(HWB_QTSAID+HWB_QTSEST) SAIDA
		FROM %table:HWB% HWB
		WHERE HWB.HWB_FILIAL=%xFilial:HWB%
			AND HWB.HWB_TICKET=%Exp:cTicket%
			AND HWB.HWB_PRODUT=%Exp:cProd%
			AND HWB.HWB_DATA>=%Exp:dDataAux%
			AND HWB.%notDel%
		GROUP BY HWB_PRODUT, YEAR(HWB_DATA), MONTH(HWB_DATA)
		ORDER BY 1,2,3
	EndSql
	
	while nSaldo > 0 .and. (cTbl)->( ! Eof() )
		if nSaldo >= 1 // faz os inteiros
			nPmp += (cTbl)->SAIDA
		elseif nSaldo > 0 // faz o ultimo mes
			nPmp += (cTbl)->SAIDA * nParcial
		endif
		nSaldo --
		(cTbl)->( dbSkip() )
	end
	(cTbl)->( dbCloseArea() )
return nPmp
/*/{Protheus.doc} AjustarHWC
	ajusta a HWC
	@author  ivan.caproni
	@since	 07/10/2023
	@version 1.0
	@type    function
/*/
static function AjustarHWC(cTicket,cProd,dData,nNovaNecTot,nNecTotAnt)
	local cTemp := GetNextAlias()
	local nCnt as numeric
	
	BeginSql alias cTemp
		SELECT R_E_C_N_O_ REGHWC
		FROM %table:HWC%
		WHERE	HWC_FILIAL=%xFilial:HWC%
			AND HWC_TICKET=%Exp:cTicket%
			AND HWC_PRODUT=%Exp:cProd%
			AND HWC_DATA=%Exp:dData%
			AND %notDel%
	EndSql

	Count to nCnt

	(cTemp)->(dbGotop())
	
	while (cTemp)->( ! Eof() )
		HWC->( dbGoto((cTemp)->REGHWC) )
		
		Reclock("HWC",.F.)
		HWC->HWC_XBKNEC := HWC->HWC_QTNECE
		if nNecTotAnt == 0 .or. (HWC->HWC_QTNECE == 0 .and. nCnt == 1)
			HWC->HWC_QTNECE := nNovaNecTot
		elseif HWC->HWC_QTNECE == 0 .and. nCnt > 1
			HWC->HWC_QTNECE := 0
		else
			HWC->HWC_QTNECE := nNovaNecTot * ( HWC->HWC_QTNECE / nNecTotAnt )
		endif
		HWC->( MsUnlock() )
		
		(cTemp)->( dbSkip() )
	end
	
	(cTemp)->( dbCloseArea() )
return
