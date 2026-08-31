#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR04    บAutor  ณStan Lee Lopes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO ANALISE DE MOVIMENTO VENDAS X ESTOQUE		        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR04()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR04"

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

	oReport := TReport():New(cPerg,"RELATORIO ANALISE DE MOVIMENTO VENDAS X ESTOQUE",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"RELATORIO ANALISE DE MOVIMENTO VENDAS X ESTOQUE",{"SB2"},aOrdem)     




	TRCell():New(oSection,"B1_COD"				,"SB1","Codigo",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"B1_DESC"				,"SB1","Descri็ใo",/*Mascara*/,)
	TRCell():New(oSection,"B1_UM"		        ,"SB1","UM",,)
	TRCell():New(oSection,"B1_COR"	    		,"SB1","Cor",,/*Tamanho*/) 
	TRCell():New(oSection,"SALDO_ESTOQUE"	   	,"SB2","Saldo Estoque",/*Mascara*/,) 
	TRCell():New(oSection,"VENDIDO"	    		,"SC6","Vendido",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"SALDO_RESTANTE"      ,"SB2","Saldo Restante",/*Mascara*/,)
	TRCell():New(oSection,"OPS_ABERTAS"        	,"SC2","OPS Abertas",/*Mascara*/,)
	TRCell():New(oSection,"OPS_ABERTURA"        ,"SC2","OPS Abertura",/*Mascara*/,)
	//TRCell():New(oSection,"B2_DTINV"       		,"SB2","Dt.Inventแrio",/*Mascara*/,)

	//Totalizador
	/*                                                                                  

	TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
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

		SELECT TB.B1_COD,TB.B1_DESC,TB.B1_UM,TB.B1_COR,SUM(SALDO)SALDO_ESTOQUE,SUM(VENDIDO)VENDIDO,SUM(SALDO-VENDIDO)SALDO_RESTANTE,SUM(OPS)OPS_ABERTAS,
		CASE WHEN SUM(SALDO-VENDIDO+OPS) < 0 THEN SUM(VENDIDO-SALDO-OPS) ELSE 0 END OPS_ABERTURA,B2_DTINV
		FROM(
		SELECT B1_COD,B1_DESC,B1_UM,B1_COR,SUM(B2_QATU)SALDO,0 VENDIDO, 0 OPS,B2_DTINV
		FROM %Table:SB2% SB2 (NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SB2.B2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE SB2.D_E_L_E_T_ = ''
		AND SB2.B2_FILIAL = '01'
		AND SB2.B2_LOCAL = '20'
		AND SB1.B1_TIPO = 'PA'
		GROUP BY B1_COD,B1_DESC,B1_UM,B1_COR,B2_DTINV
		UNION
		SELECT B1_COD,B1_DESC,B1_UM,B1_COR,0 SALDO,SUM(C6_QTDVEN-C6_QTDENT)VENDIDO,0 OPS,'' B2_DTINV
		FROM %Table:SC6% SC6 (NOLOCK)
		INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE SC6.D_E_L_E_T_ = '' 
		AND SC6.C6_FILIAL = '01'
		AND SC6.C6_LOCAL = '20' 
		AND SC6.C6_QTDVEN != SC6.C6_QTDENT
		AND SC6.C6_ENTREG BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SB1.B1_TIPO = 'PA'
		GROUP BY B1_COD,B1_DESC,B1_UM,B1_COR
		UNION
		SELECT B1_COD,B1_DESC,B1_UM,B1_COR,0 SALDO,0 VENDIDO,SUM(C2_QUANT)OPS, '' B2_DTINV
		FROM %Table:SC2% SC2 (NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC2.C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE SC2.D_E_L_E_T_ = ''
		AND SC2.C2_FILIAL = '01'
		AND SC2.C2_LOCAL = '20'
		AND SC2.C2_DATRF = ''
		AND SB1.B1_TIPO = 'PA'
		GROUP BY B1_COD,B1_DESC,B1_UM,B1_COR
		)TB
		GROUP BY TB.B1_COD,TB.B1_DESC,TB.B1_UM,TB.B1_COR,B2_DTINV
		HAVING SUM(TB.SALDO+TB.OPS-TB.VENDIDO) < 0
		ORDER BY TB.B1_DESC

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Dt.Entrega De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Dt.Entrega At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return