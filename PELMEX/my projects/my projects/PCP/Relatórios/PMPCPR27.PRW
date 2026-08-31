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

User Function PMPCPR27()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR27"

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

	TRCell():New(oSection,"C2_PRODUTO"	    ,"SB1","Produto",/*Mascara*/,7)
	TRCell():New(oSection,"B1_DESC"        	,"SB1","Descri็ใo",,60)
	TRCell():New(oSection,"OPNAOPRODUZIDA"	,"SB1","Op nใo produzida",/*Mascara*/,5)
	TRCell():New(oSection,"EMESTOQUE"       ,"SB1","Em estoque",,14)
	TRCell():New(oSection,"PRODUZIDO"	    ,"SB1","Produzido",/*Mascara*/,5)
	TRCell():New(oSection,"SALDOPREVISTO"   ,"SB1","Saldo Previsto",,15)
	TRCell():New(oSection,"FATURADO"	    ,"SB1","Faturado",/*Mascara*/,14)
	TRCell():New(oSection,"SALDOATUAL"      ,"SB1","Saldo disponivel",,30)

	TRFunction():New(oSection:Cell("OPNAOPRODUZIDA"),"Total nao produzido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("EMESTOQUE"),"Total em estoque","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("PRODUZIDO"),"Total produzido"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("SALDOPREVISTO"),"Total previsto"•,"SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("FATURADO"),"Total faturado"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("SALDOATUAL"),"Saldo em disponivel"•,"SUM",,,"@E 9,999,999,999",,.F.,.T.)
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

		SELECT * FROM (
		SELECT TB1.C2_PRODUTO,TB1.B1_DESC,SUM(TB1.SEMPRODUCAO)OPNAOPRODUZIDA,SUM(TB1.EMESTOQUE) EMESTOQUE,SUM(TB1.EMPRODUCAO)PRODUZIDO,
		SUM(TB1.EMESTOQUE)+SUM(TB1.EMPRODUCAO)+SUM(TB1.SEMPRODUCAO) SALDOPREVISTO ,SUM(TB1.FATURADO) FATURADO,SUM(TB1.EMESTOQUE)+SUM(TB1.EMPRODUCAO)-SUM(TB1.FATURADO)SALDOATUAL
		FROM(
		SELECT C2_PRODUTO,B1_DESC,COUNT(Z4_CPRODUC) EMESTOQUE, 0 EMPRODUCAO,0 SEMPRODUCAO,0 FATURADO FROM (
		SELECT SUBSTRING(Z4_CEXPEDI,1,15)C2_PRODUTO,
		B1_DESC,
		Z4_CPRODUC,
		CASE WHEN Z1_OP+Z1_CHASSIS IS NULL THEN 'EM PRODUวรO' ELSE Z1_OP+Z1_CHASSIS END Z1_CPRODUC,
		CASE WHEN SAI_CPRODUC IS NULL THEN 'SEM SAอDA NA EXPEDIวรO' ELSE SAI_CPRODUC END SAI_CPRODUC,SAI_PROCESS,SAI_DOC,SAI_DTEXP,CONVERT(VARCHAR,CAST(Z1_DTAPONT AS DATE),103) 'DATA DA ENTRADA',
		C2_DATRF
		FROM %Table:SZ4% SZ4 (NOLOCK)
		LEFT JOIN %Table:SZ1% SZ1 (NOLOCK) ON Z4_CPRODUC = Z1_OP+Z1_CHASSIS AND SZ1.D_E_L_E_T_ = ''
		LEFT JOIN SAI (NOLOCK) ON Z4_CPRODUC = SAI_CPRODUC
		LEFT JOIN %Table:SC2% SC2 (NOLOCK) ON SUBSTRING(Z4_CPRODUC,1,6) = C2_NUM AND SC2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SUBSTRING(Z4_CEXPEDI,1,15) = B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE SUBSTRING(Z4_CPRODUC,1,11) IN(
		SELECT C2_NUM+C2_ITEM+C2_SEQUEN
		FROM %Table:SC2% SC2 (NOLOCK)
		WHERE SC2.D_E_L_E_T_ = ''
		AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND B1_TIPO = 'PA'
		)

		AND SAI_CPRODUC IS NULL
		AND Z1_CHASSIS IS NOT NULL
		) TB
		GROUP BY C2_PRODUTO,B1_DESC

		UNION

		SELECT CLA_COD ,CLA_DESCRI,0 EMESTOQUE ,COUNT(CLA_CPRODUC) EMPRODUCAO,0 SEMPRODUCAO , 0 FATURADO
		FROM CLA
		LEFT JOIN %Table:SZ1% SZ1 (NOLOCK) ON Z1_OP+Z1_CHASSIS = CLA_CPRODUC AND SZ1.D_E_L_E_T_ = ''
		WHERE Z1_OP+Z1_CHASSIS IS NULL
		GROUP BY CLA_COD,CLA_DESCRI

		UNION

		SELECT B1_COD ,B1_DESC,0 EMESTOQUE ,0 EMPRODUCAO,COUNT(Z4_CPRODUC) SEMPRODUCAO , 0 FATURADO
		FROM %Table:SZ4% SZ4 (NOLOCK)
		LEFT JOIN CLA (NOLOCK) ON Z4_CPRODUC = CLA_CPRODUC
		LEFT JOIN %Table:SZ1% SZ1(NOLOCK) ON Z4_CPRODUC = Z1_OP+Z1_CHASSIS AND SZ1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SC2% SC2 (NOLOCK) ON SUBSTRING(Z4_CPRODUC,1,6) = C2_NUM  AND SC2.D_E_L_E_T_= ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON B1_COD = C2_PRODUTO
		WHERE CLA_CPRODUC IS NULL
		AND SZ4.D_E_L_E_T_ = ''
		AND Z1_OP+Z1_CHASSIS IS NULL
		AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY B1_COD,B1_DESC

		UNION
		SELECT D2_COD,B1_DESC,0 EMESTOQUE,0 EMPRODUCAO,0 SEMPRODUCAO,SUM(D2_QUANT) FATURADO
		FROM %Table:SD2%  SD2 (NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON D2_COD = B1_COD
		LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
		LEFT JOIN SAI (NOLOCK) ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND D2_COD = SAI_PRODUTO
		WHERE D1_NFORI IS NULL
		AND SAI_DOC IS NULL
		AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_FILIAL = '01'
		AND B1_TIPO = 'PA'
		AND D2_TES NOT IN ('705','702')
		AND SD2.D_E_L_E_T_ = ''
		GROUP BY D2_COD,B1_DESC

		)TB1
		GROUP BY TB1.C2_PRODUTO,TB1.B1_DESC
		)TB2
		WHERE C2_PRODUTO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		ORDER BY 8 DESC

	EndSQL

	oSection:EndQuery()
	oSection:SetParentQuery()
	oSection:Print()
Return

Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Produto De    ",20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Produto At้   ",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")

Return