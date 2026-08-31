#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR18    บAutor  ณStan Lee Lopes     				บ Data ณ  05/10/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  			COMISSรO DE FมBRICA DETALHADO								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLFATR34()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR34"

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

	oReport := TReport():New(cPerg,"COMISSรO DE FมBRICA DETALHADO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()
	oReport:SetEnvironment(2)

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"COMISSรO DE FมBRICA DETALHADO",{"SD2"},aOrdem)
    TRCell():New(oSection,"EMPRESA"	        ,"SD2","Empresa",/*Mascara*/,25)
	TRCell():New(oSection,"D2_FILIAL"	    ,"SD2","Filial",/*Mascara*/,7)
	TRCell():New(oSection,"D2_DOC"        	,"SD2","Nota",,14)
	TRCell():New(oSection,"D2_SERIE"	    ,"SD2","Serie",/*Mascara*/,5)
	TRCell():New(oSection,"D2_CLIENTE"      ,"SD2","Cliente",,14)
	TRCell():New(oSection,"D2_LOJA"	        ,"SD2","Loja",/*Mascara*/,5)
	TRCell():New(oSection,"A1_NOME"        	,"SA1","Nome",,15)
	TRCell():New(oSection,"B1_COD"	        ,"SB1","Codigo",/*Mascara*/,14)
	TRCell():New(oSection,"B1_DESC"        	,"SB1","Descri็ใo",,30)
	TRCell():New(oSection,"D2_QUANT"        ,"SD2","Quantidade","@E 999,999,999.99",14)
	TRCell():New(oSection,"D2_PRCVEN"	    ,"SD2","Pre็o","@E 999,999,999.99",14)
	TRCell():New(oSection,"D2_TOTAL"        ,"SD2","Total","@E 999,999,999.99",14)
	TRCell():New(oSection,"D2_EST"	        ,"SD2","Estado",/*Mascara*/,/*Tamanho*/)
	TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL FATURADO"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("D2_QUANT"),"Total de produtos"•,"SUM",,,"@E 9,999,999,999",,.F.,.T.)
	//Totalizador

	//
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENวA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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
	//	cOrdem := "A1_COD"                       ท
	//endif

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

		//PELMEX CLIENTE VENDA
		SELECT  'PELMEX' EMPRESA,D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,A1_NOME,
		B1_COD,B1_DESC,B1_UM,
		D2_QUANT,
		D2_PRCVEN,D2_TOTAL,D2_EST
		FROM SD2100 SD2 (NOLOCK)
		INNER JOIN SB1100 SB1 (NOLOCK) ON SB1.B1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = ''
		LEFT JOIN SA1100 SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		WHERE SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SD2.D2_TES IN ('511','515','550','551','553','556','558','563','564','566','570','709','719','720','721','722','724','803','856','888','889','894','895','896')
		AND SD2.D_E_L_E_T_ = ''
		AND SD2.D2_FILIAL = '01'

		UNION

		//PELMEX TRANFERENCIA E BONIFICAวรO
		SELECT  'PELMEX' EMPRESA,D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,A1_NOME,
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
	AND SD2.D2_TES IN ('848','871','877','723','561')
	AND SD2.D_E_L_E_T_ = ''
	AND SD2.D2_FILIAL = '01'

	UNION

	//DEVOLUวรO PELMEX TRANSFERENCIA / BONIFICACAO
	SELECT 'PELMEX' EMPRESA,D1_FILIAL D2_FILIAL,D1_NFORI D2_DOC,D1_SERIORI D2_SERIE,D1_FORNECE D2_CLIENTE,D1_LOJA D2_LOJA,A1_NOME,
	B1_COD,B1_DESC,B1_UM,
	D1_QUANT D2_QUANT,
	DA1_PRCVEN*-1 D2_PRCVEN,
	(D1_QUANT * DA1_PRCVEN)*-1 D2_TOTAL,
	D2_EST
	FROM SD1100 SD1 (NOLOCK)
	INNER JOIN SD2100 SD2 (NOLOCK) ON SD1.D1_FILIAL = SD2.D2_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = '' AND SD1.D1_LOCAL !='30'
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
	AND SD2.D2_TES IN ('848','871','877','723','561')
	AND SD1.D1_TIPO = 'D'

	UNION
	//DEVOLUวรO PELMEX CLIENTE VENDA
	SELECT 'PELMEX' EMPRESA,D1_FILIAL D2_FILIAL,D1_NFORI D2_DOC,D1_SERIORI D2_SERIE,D1_FORNECE D2_CLIENTE,D1_LOJA D2_LOJA,A1_NOME,
	B1_COD,B1_DESC,B1_UM,
	D1_QUANT D2_QUANT,
	D2_PRCVEN*-1,
	D2_TOTAL*-1,
	D2_EST
	FROM SD1100 SD1 (NOLOCK)
	INNER JOIN SD2100 SD2 (NOLOCK) ON SD1.D1_FILIAL = SD2.D2_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = '' AND SD1.D1_LOCAL !='30'
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

	AND SD2.D2_TES IN ('511','515','550','551','553','556','558','563','564','566','570','709','719','720','721','722','724','803','856','888','889','894','895','896')
	AND SD1.D1_TIPO = 'D'

	//AMAZON
	UNION
	//DEVOLUวรO AMAZON
	SELECT 'AMAZON' EMPRESA,D1_FILIAL D2_FILIAL,D1_DOC D2_DOC,D1_SERIE D2_SERIE,D1_FORNECE D2_CLIENTE,D1_LOJA D2_LOJA,A1_NOME,
	B1_COD,B1_DESC,B1_UM,
	D1_QUANT D2_QUANT,
	D1_VUNIT*-1 D2_PRCVEN,
	(D1_QUANT * ISNULL(DA1_PRCVEN,D1_VUNIT))*-1 D2_TOTAL,D2_EST
	FROM SD1200 SD1 (NOLOCK)
	INNER JOIN SD2200 SD2 (NOLOCK) ON SD1.D1_FILIAL = SD2.D2_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD1.D1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = '' AND SD1.D1_LOCAL !='30'
	LEFT JOIN DA1200 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND DA1_CODTAB = '022'
	INNER JOIN SB1200 SB1 (NOLOCK) ON SB1.B1_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
	LEFT JOIN SA1200 SA1 (NOLOCK) ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
	WHERE SD1.D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND (SD2.D2_COD LIKE 'LAM%' OR SD2.D2_COD LIKE 'BLOD%' OR SD2.D2_COD LIKE 'DFLOC%' OR SD2.D2_COD LIKE 'PCD%')
	AND SD1.D_E_L_E_T_ = ''
	AND SD1.D1_TIPO = 'D'

	UNION
	//FATURAMENTO AMAZON
	SELECT 'AMAZON' EMPRESA,D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,A1_NOME,
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

	ORDER BY D2_DOC,D2_EST

	EndSQL

	oSection:EndQuery()
	oSection:SetParentQuery()
	oSection:Print()
Return

Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return