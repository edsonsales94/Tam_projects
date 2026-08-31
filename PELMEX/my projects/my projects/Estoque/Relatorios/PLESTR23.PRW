#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR04    บAutor  ณWilson Junior 	  				บ Data ณ  12/05/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO DE ESTOQUE 								        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR23()
	Local oReport
	Local cQuery
	Local cAlias    := getNextAlias()

	Private cPerg   := "PLESTR23"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oBreak
	Local aOrdem    := {"FILIAL"}

	oReport := TReport():New(cPerg,"REL. CUSTO VS FATURAMENTO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"REL. CUSTO VS FATURAMENTO",{"SD2"},aOrdem)     


	TRCell():New(oSection,"D2_EMISSAO"		,"SD2","EMISSAO","!@",10)
	TRCell():New(oSection,"TABELA"	    	,"SA1","TABELA","!@",5)
	TRCell():New(oSection,"PRC_TABELA"	   	,"DA1","PRC TABELA","!@",4)
	TRCell():New(oSection,"B9_DATA"	 	  	,"SB9","DATA INI","!@",10)
	TRCell():New(oSection,"B9_CM1"			,"SB9","CUSTO","@E 9,999,999.99",)
	TRCell():New(oSection,"PRC_BRUTO"		,"SD2","PRC BRUTO","@E 9,999,999.99",)
	TRCell():New(oSection,"PER_DESCONTO"	,"SD2","PER DESCONTO","@E 9,999,999.99",)   
	TRCell():New(oSection,"PRC_LIQ"	  		,"SD2","PRC LIQ","@E 9,999,999.99",)       
	TRCell():New(oSection,"D2_CLIENTE"	    ,"SD2","CLIENTE","!@",15)    
	TRCell():New(oSection,"A1_NOME"	  		,"SA1","NOME","!@",30)     
	TRCell():New(oSection,"A1_NREDUZ"	  	,"SA1","NOMEREDUZ","!@",15)
	TRCell():New(oSection,"A1_MUN"	  		,"SA1","MUNICIPIO","!@",20)       

	//TRFunction():New(oSection:Cell("B2_QATU"),"Produtos em Estoque","SUM",,,"@E 9,999,999,999",,.F.,.T.)

	//Totalizador
	/*                                                                                  

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

	SELECT CONVERT (VARCHAR,CAST(D2_EMISSAO AS DATE),103) D2_EMISSAO,A1_TABELA TABELA,DA1_PRCVEN PRC_TABELA,ISNULL(CONVERT (VARCHAR,CAST(B9_DATA AS DATE),103),'')B9_DATA,
			ISNULL(B9_CM1,0)B9_CM1,D2_COD,D2_DOC NOTA,D2_SERIE SERIE,D2_QUANT ,D2_PRUNIT PRC_BRUTO,D2_DESC PER_DESCONTO,D2_PRCVEN PRC_LIQ,
       		D2_CLIENTE,A1_NOME,A1_NREDUZ,A1_MUN
		FROM SD2100 SD2 (NOLOCK)
		INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN DA1100 DA1 (NOLOCK) ON A1_TABELA = DA1_CODTAB AND D2_COD = DA1_CODPRO AND DA1.D_E_L_E_T_ = ''
		LEFT JOIN SB9100 SB9 (NOLOCK) ON D2_FILIAL = B9_FILIAL AND D2_COD = B9_COD AND D2_LOCAL = B9_LOCAL AND SB9.D_E_L_E_T_ = '' AND SUBSTRING(D2_EMISSAO,1,6) = SUBSTRING(B9_DATA,1,6) 
		WHERE SD2.D_E_L_E_T_ = ''
		AND D2_PEDIDO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_COD BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND D2_EMISSAO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		GROUP BY D2_EMISSAO,A1_TABELA,DA1_PRCVEN,D2_PRCVEN,B9_DATA,B9_CM1,D2_CUSTO1,D2_PRUNIT,D2_DESC,D2_VALBRUT,D2_QUANT,D2_CLIENTE,A1_NOME,A1_NREDUZ,A1_MUN,D2_DOC,D2_SERIE,D2_COD,D2_QUANT
		ORDER BY D2_EMISSAO,A1_TABELA


        /*SELECT CONVERT (VARCHAR,CAST(D2_EMISSAO AS DATE),103) D2_EMISSAO,A1_TABELA TABELA,DA1_PRCVEN PRC_TABELA,ISNULL(CONVERT (VARCHAR,CAST(B9_DATA AS DATE),103),'')B9_DATA,
			ISNULL(B9_CM1,0)B9_CM1,D2_PRUNIT PRC_BRUTO,D2_DESC PER_DESCONTO,D2_PRCVEN PRC_LIQ,
       		D2_CLIENTE,A1_NOME,A1_NREDUZ,A1_MUN
		FROM %Table:SD2% SD2 (NOLOCK)
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:DA1% DA1 (NOLOCK) ON A1_TABELA = DA1_CODTAB AND D2_COD = DA1_CODPRO AND DA1.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SB9% SB9 (NOLOCK) ON D2_FILIAL = B9_FILIAL AND D2_COD = B9_COD AND D2_LOCAL = B9_LOCAL AND SUBSTRING(D2_EMISSAO,1,6) = SUBSTRING(B9_DATA,1,6) AND SB9.D_E_L_E_T_ = ''
		WHERE SD2.D_E_L_E_T_ = ''
		AND D2_PEDIDO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_COD BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND D2_EMISSAO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		GROUP BY D2_EMISSAO,A1_TABELA,DA1_PRCVEN,D2_PRCVEN,B9_DATA,B9_CM1,D2_CUSTO1,D2_PRUNIT,D2_DESC,D2_VALBRUT,D2_QUANT,D2_CLIENTE,A1_NOME,A1_NREDUZ,A1_MUN
		ORDER BY D2_EMISSAO,A1_TABELA*/
	
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Pedido ?      ",20)+"?","","","mv_ch1","C",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Pedido?      ",20)+"?","","","mv_ch2","C",10,0,0,"G","","","","","mv_par02")  
	u_InPutSX1(cPerg,"03",PADR("De Codigo?       ",20)+"?","","","mv_ch3","C",15,0,0,"G","","","SB1","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("At้ Codigo?      ",20)+"?","","","mv_ch4","C",15,0,0,"G","","","SB1","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Emissao ?     ",20)+"?","","","mv_ch5","D",10,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("At้ Emissao?     ",20)+"?","","","mv_ch6","D",10,0,0,"G","","","","","mv_par06") 
	//u_InPutSX1(cPerg,"07",PADR("De Data ?      ",20)+"?","","","mv_ch7","D",10,0,0,"G","","","","","mv_par07") 
	//u_InPutSX1(cPerg,"08",PADR("At้ Data?      ",20)+"?","","","mv_ch8","D",10,0,0,"G","","","","","mv_par08") 
	
Return

