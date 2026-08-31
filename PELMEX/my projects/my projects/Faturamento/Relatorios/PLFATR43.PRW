#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATR43    ºAutor  ³Stan Lee Lopes     				º Data ³  05/10/20 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  			RELATORIO GERENCIAL DE FATURAMENTO							 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLFATR43()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR43"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return

Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oBreak
	Local aOrdem      := {"FILIAL"}

	oReport := TReport():New(cPerg,"RELATORIO GERENCIAL DE FATURAMENTO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()
	oReport:SetEnvironment(2)

	//Primeira seção
	oSection := TRSection():New(oReport,"RELATORIO GERENCIAL DE FATURAMENTO",{"SD2"},aOrdem)

	TRCell():New(oSection,"D2_EST"	        ,"SD2","Estado",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"D2_TOTAL"        ,"SD2","Total Venda---->","@E 999,999,999.99",14)

	TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//Totalizador

	//
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENÇA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DA1_TOTAL"),"TOTAL FABRICA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	/*
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport

/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

		SELECT D2_EST,SUM(D2_TOTAL)D2_TOTAL
		FROM(
		//PELMEX VENDA
		SELECT  D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,A1_NOME,
		B1_COD,B1_DESC,B1_UM,
		D2_QUANT,
		D2_PRCVEN,D2_TOTAL,D2_EST
		FROM SD2100 SD2 (NOLOCK)
		INNER JOIN SB1100 SB1 (NOLOCK) ON SB1.B1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = ''
		LEFT JOIN SA1100 SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		WHERE SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SD2.D2_TES IN ('511','551','553','558','560','563','564','570','709','719','720','721','722','724','803','856','871','877','888','895')
		AND SD2.D_E_L_E_T_ = ''
		AND SD2.D2_FILIAL = '01'

		UNION

		//PELMEX TRANFERENCIA E BONIFICAÇÃO
		SELECT  D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,A1_NOME,
		B1_COD,B1_DESC,B1_UM,
		D2_QUANT,
		ISNULL(DA1_PRCVEN,D2_PRCVEN) D2_PRCVEN,
		(D2_QUANT * ISNULL(DA1_PRCVEN,D2_PRCVEN))D2_TOTAL,
		D2_EST
		FROM SD2100 SD2 (NOLOCK)
		INNER JOIN SB1100 SB1 (NOLOCK) ON SB1.B1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = ''
		LEFT JOIN DA1100 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND
		DA1_CODTAB = CASE WHEN B1_XEMP = '1' THEN '003'
		WHEN B1_XEMP = '2' THEN '022'
		WHEN B1_XEMP = '3' THEN '004'
	END
	LEFT JOIN SA1100 SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
	WHERE SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SD2.D2_TES IN ('871','877')
	AND SD2.D_E_L_E_T_ = ''
	AND SD2.D2_FILIAL = '01'

	UNION

	//DEVOLUÇÃO PELMEX TRANSFERENCIA / BONIFICACAO
	SELECT D1_FILIAL D2_FILIAL,D1_NFORI D2_DOC,D1_SERIORI D2_SERIE,D1_FORNECE D2_CLIENTE,D1_LOJA D2_LOJA,A1_NOME,
	B1_COD,B1_DESC,B1_UM,
	D1_QUANT D2_QUANT,
	DA1_PRCVEN*-1 D2_PRCVEN,
	(D1_QUANT * DA1_PRCVEN)*-1 D2_TOTAL,
	D2_EST
	FROM SD1100 SD1 (NOLOCK)
	INNER JOIN SD2100 SD2 (NOLOCK) ON SD1.D1_FILORI = SD2.D2_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD2.D_E_L_E_T_ = ''
	INNER JOIN SB1100 SB1 (NOLOCK) ON SB1.B1_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
	LEFT JOIN DA1100 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND
	DA1_CODTAB = CASE WHEN B1_XEMP = '1' THEN '003'
	WHEN B1_XEMP = '2' THEN '022'
	WHEN B1_XEMP = '3' THEN '004'
	END
	LEFT JOIN SA1100 SA1 (NOLOCK) ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
	WHERE SD1.D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SD1.D1_FILIAL = '01'
	AND SD1.D_E_L_E_T_ = ''
	AND SD2.D2_TES IN ('871','877')
	AND SD1.D1_TIPO = 'D'

	UNION
	//DEVOLUÇÃO PELMEX CLIENTE VENDA
	SELECT D1_FILIAL D2_FILIAL,D1_NFORI D2_DOC,D1_SERIORI D2_SERIE,D1_FORNECE D2_CLIENTE,D1_LOJA D2_LOJA,A1_NOME,
	B1_COD,B1_DESC,B1_UM,
	D1_QUANT D2_QUANT,
	D2_PRCVEN*-1,
	D2_TOTAL*-1,
	D2_EST
	FROM SD1100 SD1 (NOLOCK)
	INNER JOIN SD2100 SD2 (NOLOCK) ON SD1.D1_FILORI = SD2.D2_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD2.D_E_L_E_T_ = ''
	INNER JOIN SB1100 SB1 (NOLOCK) ON SB1.B1_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
	LEFT JOIN DA1100 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND
	DA1_CODTAB = CASE WHEN B1_XEMP = '1' THEN '003'
	WHEN B1_XEMP = '2' THEN '022'
	WHEN B1_XEMP = '3' THEN '004'
	END
	LEFT JOIN SA1100 SA1 (NOLOCK) ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
	WHERE SD1.D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SD1.D1_FILIAL = '01'
	AND SD1.D_E_L_E_T_ = ''
	AND SD2.D2_TES IN ('511','551','553','558','560','563','564','570','719','720','721','722','724','803','856','871','877','888','895')
	AND SD1.D1_TIPO = 'D'

	//AMAZON
	UNION
	//DEVOLUÇÃO AMAZON
	SELECT D1_FILIAL D2_FILIAL,D1_DOC D2_DOC,D1_SERIE D2_SERIE,D1_FORNECE D2_CLIENTE,D1_LOJA D2_LOJA,A1_NOME,
	B1_COD,B1_DESC,B1_UM,
	D1_QUANT D2_QUANT,
	D1_VUNIT*-1 D2_PRCVEN,
	(D1_QUANT * ISNULL(DA1_PRCVEN,D1_VUNIT))*-1 D2_TOTAL,D2_EST
	FROM SD1200 SD1 (NOLOCK)
	INNER JOIN SD2200 SD2 (NOLOCK) ON SD1.D1_FILORI = SD2.D2_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD2.D_E_L_E_T_ = ''
	LEFT JOIN DA1200 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND DA1_CODTAB = '022'
	INNER JOIN SB1200 SB1 (NOLOCK) ON SB1.B1_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
	LEFT JOIN SA1200 SA1 (NOLOCK) ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
	WHERE SD1.D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND (SD2.D2_COD LIKE 'LAM%' OR SD2.D2_COD LIKE 'BLOD%' OR SD2.D2_COD LIKE 'DFLOC%' OR SD2.D2_COD LIKE 'PCD%')
	AND SD1.D_E_L_E_T_ = ''
	AND SD1.D1_TIPO = 'D'

	UNION
	//FATURAMENTO AMAZON
	SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,A1_NOME,
	B1_COD,B1_DESC,B1_UM,
	D2_QUANT,
	isNULL(DA1_PRCVEN,D2_PRCVEN) D2_PRCVEN,
	(D2_QUANT * isNULL(DA1_PRCVEN,D2_PRCVEN)) D2_TOTAL,
	D2_EST
	FROM SD2200 SD2 (NOLOCK)
	LEFT JOIN DA1200 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND DA1_CODTAB = '022'
	INNER JOIN SB1200 SB1 (NOLOCK) ON SB1.B1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = ''
	LEFT JOIN SA1200 SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
	WHERE SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND (SD2.D2_COD LIKE 'LAM%' OR SD2.D2_COD LIKE 'BLOD%' OR SD2.D2_COD LIKE 'DFLOC%' OR SD2.D2_COD LIKE 'PCD%')
	AND SD2.D_E_L_E_T_ = ''

	)SD2
	GROUP BY D2_EST
	ORDER BY D2_EST

	EndSQL

	oSection:EndQuery()
	oSection:SetParentQuery()
	oSection:Print()
Return

Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissão De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Emissão Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return