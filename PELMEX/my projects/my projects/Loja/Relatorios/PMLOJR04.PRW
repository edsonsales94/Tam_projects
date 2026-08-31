#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLOJR04    บAutor  ณStan Lee Lopes     				บ Data ณ  14/12/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Pedido de Fแbrica             								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMLOJR04()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMLOJR04"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE PEDIDO DE FมBRICA ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Pedido",{"SC5"},aOrdem) 

	//TRCell():New(oSection,"C6_FILIAL"	,"SC6","Filial",/*Mascara*/)
	TRCell():New(oSection,"C6_NUM"		,"SC6","No Pedido",/*Mascara*/,) 
	TRCell():New(oSection,"C6_CLI"   	,"SC6","Cod.Cli",/*Mascara*/,10) 
	//TRCell():New(oSection,"C6_LOJA"		,"SC6","Loja Cli",/*Mascara*/,8)
	TRCell():New(oSection,"A1_NOME"		,"SA1","Cliente",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"C6_ITEM"    	,"SC6","Item",/*Mascara*/,)
	TRCell():New(oSection,"C6_PRODUTO"  ,"SC6","Cod.Prod",/*Mascara*/,)
	TRCell():New(oSection,"B1_DESC"		,"SB1","Produto",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"C6_QTDVEN"	,"SC6","QTD","@E999",5) 
	TRCell():New(oSection,"C6_VALOR"	,"SC6","Valor","@E 999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"C5_EMISSAO"	,"SC5","Dt.Emissใo",,/*Tamanho*/)
	TRCell():New(oSection,"C6_ENTREG"	,"SC6","Dt.Entrega",,/*Tamanho*/)
	TRCell():New(oSection,"C6_NOTA"	    ,"SC6","Nota Fiscal",,11) 
	TRCell():New(oSection,"C6_SERIE"	,"SC6","S้rie",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"C6_DATFAT"	,"SC6","Dt.Faturamento",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"A3_COD"		,"SA3","Vendedor",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"A3_NOME"		,"SA3","Vendedor",/*Mascara*/,20)
	TRCell():New(oSection,"SAI_DTEXP"	,"SAI","DT. Expedi็ใo",/*Mascara*/,12)
	TRCell():New(oSection,"SAI_QUANT"	,"SAI","Qtd.Expedi็ใo",/*Mascara*/,5)


	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)


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

		SELECT C6_FILIAL,C6_NUM,C6_CLI,C6_LOJA,A1_NOME,C6_ITEM,C6_PRODUTO,B1_DESC,C6_QTDVEN,C6_VALOR,C5_EMISSAO,C6_ENTREG,C6_NOTA,C6_SERIE,ISNULL(C6_DATFAT,'') C6_DATFAT,ISNULL(SAI_DTEXP,'') AS SAI_DTEXP,A3_COD,A3_NOME,SUM(SAI_QUANT) SAI_QUANT
		FROM %Table:SC5% SC5 (NOLOCK)
		INNER JOIN %Table:SC6% SC6 (NOLOCK) ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC6.C6_PRODUTO = SB1.B1_COD AND SC6.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA3% SA3 (NOLOCK) ON SC5.C5_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ = ''
		LEFT JOIN SAI (NOLOCK) ON SAI_DOC = SC5.C5_NOTA AND SAI_SERIE = SC5.C5_SERIE AND SAI_PRODUTO = C6_PRODUTO
		WHERE C5_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND C5_EMISSAO  BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND C5_XFILRES  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C5_XORCRES != ''
		GROUP BY C6_FILIAL,C6_NUM,C6_CLI,C6_LOJA,A1_NOME,C6_ITEM,C6_PRODUTO,B1_DESC,C6_QTDVEN,C6_VALOR,C5_EMISSAO,C6_ENTREG,C6_NOTA,C6_SERIE,C6_DATFAT,SAI_DTEXP,A3_COD,A3_NOME
		ORDER BY C6_ENTREG,C6_NUM,C6_ITEM

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Filial De  ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Filial At้ ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Vendedor De  ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Vendedor At้ ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Emissใo De   ",20)+"?","","","mv_ch5","C",8,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Emissใo At้  ",20)+"?","","","mv_ch6","C",8,0,0,"G","","","","","mv_par06") 

Return
