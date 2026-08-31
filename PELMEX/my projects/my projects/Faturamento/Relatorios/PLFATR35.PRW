#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR35    บAutor  ณWilson Guedes      				บ Data ณ  28/10/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  			NOTAS NAO EXPEDIDAS 										 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR35()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR35"

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

	oReport := TReport():New(cPerg,"NOTAS NAO EXPEDIDAS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"NOTAS NAO EXPEDIDAS",{"SD2"},aOrdem) 

	TRCell():New(oSection,"D2_CLIENTE"	    ,"SD2","Cod.Cliente",/*Mascara*/,/*Tamanho*/)     
	TRCell():New(oSection,"A1_NOME"        	,"SA1","Nome",,14) 
	TRCell():New(oSection,"A1_EST"	        ,"SA1","Estado",/*Mascara*/,/*Tamanho*/)     
	TRCell():New(oSection,"EMPRESA"        	,"SD2","Empresa",,14) 
	TRCell():New(oSection,"D2_DOC"	        ,"SD2","Nota",/*Mascara*/,10)     
	TRCell():New(oSection,"D2_ITEM"        	,"SD2","Item",,5) 
	TRCell():New(oSection,"D2_COD"	        ,"SD2","Codigo",/*Mascara*/,15)     
	TRCell():New(oSection,"B1_DESC"        	,"SB1","Descri็ใo",,30) 
	TRCell():New(oSection,"D2_QUANT"	    ,"SD2","Quantidade",/*Mascara*/,13)     
	TRCell():New(oSection,"D2_EMISSAO"      ,"SD2","Emissใo",,14)      
	TRCell():New(oSection,"D2_TOTAL"        ,"SD2","Total Venda","R$@E 999,999,999.99",14) 

	TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL PENDENTE"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("D2_QUANT"),"TOTAL DE PRODUTOS"•,"SUM",,,"@E 9,999,999,999",,.F.,.T.) 
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


		SELECT D2_CLIENTE,A1_NOME,A1_EST,
		CASE WHEN B1_XEMP = 1 THEN 'PROBEL'
		WHEN B1_XEMP = 2 THEN 'PELMEX'
		WHEN B1_XEMP = 3 THEN 'SONOFLEX'
		WHEN B1_XEMP = 4 THEN 'POLISHOP'
		WHEN B1_XEMP = 5 THEN 'KING STAR'
		WHEN B1_XEMP = 6 THEN 'INOVAR'
	END EMPRESA,
	D2_DOC,SAI_DOC,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,SUM(SAI_QUANT)SAI_QUANT,D2_EMISSAO,ISNULL((D2_QUANT * DA1_PRCVEN),D2_TOTAL) D2_TOTAL
	FROM %Table:SD2% SD2 (NOLOCK)
	INNER JOIN %Table:SB1% SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
	INNER JOIN %Table:SA1% SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' AND SD1.D1_LOCAL != '30'
	LEFT JOIN SAI (NOLOCK) ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_COD = SAI_PRODUTO AND D2_ITEM = SAI_ITEM
	LEFT JOIN %Table:DA1% DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND 
	DA1_CODTAB = CASE WHEN B1_XEMP = '1' THEN '003'
	WHEN B1_XEMP = '2' THEN '022'
	WHEN B1_XEMP = '3' THEN '004' END
	WHERE SD2.D_E_L_E_T_ = ''
	AND SAI_DOC IS NULL
	AND D1_NFORI IS NULL
	AND B1_TIPO = 'PA'
	AND D2_FILIAL = '01'
	AND D2_EMISSAO BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SD2.D2_TES IN ('877','723','574')
	GROUP BY D2_CLIENTE,A1_NOME,A1_EST,B1_XEMP,D2_DOC,SAI_DOC,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,D2_EMISSAO,DA1_PRCVEN,D2_TOTAL

	UNION

	SELECT D2_CLIENTE,A1_NOME,A1_EST,
	CASE WHEN B1_XEMP = 1 THEN 'PROBEL'
	WHEN B1_XEMP = 2 THEN 'PELMEX'
	WHEN B1_XEMP = 3 THEN 'SONOFLEX'
	WHEN B1_XEMP = 4 THEN 'POLISHOP'
	WHEN B1_XEMP = 5 THEN 'KING STAR'
	WHEN B1_XEMP = 6 THEN 'INOVAR'
	END EMPRESA,
	D2_DOC,SAI_DOC,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,SUM(SAI_QUANT)SAI_QUANT,D2_EMISSAO,D2_TOTAL
	FROM %Table:SD2% SD2 (NOLOCK)
	INNER JOIN %Table:SB1% SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
	INNER JOIN %Table:SA1% SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' AND SD1.D1_LOCAL != '30'
	LEFT JOIN SAI (NOLOCK) ON  D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_COD = SAI_PRODUTO AND D2_ITEM = SAI_ITEM
	WHERE SD2.D_E_L_E_T_ = ''
	AND SAI_DOC IS NULL
	AND D1_NFORI IS NULL
	AND B1_TIPO = 'PA'
	AND D2_FILIAL = '01'
	AND D2_EMISSAO BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SD2.D2_TES IN ('511','515','550','551','553','556','558','560','563','564','566','803','856','888','889','894','895','896','719','720','721','722','724')
	GROUP BY D2_CLIENTE,A1_NOME,A1_EST,B1_XEMP,D2_DOC,SAI_DOC,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,D2_EMISSAO,D2_TOTAL

	ORDER BY D2_EMISSAO,D2_DOC,D2_ITEM   



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return