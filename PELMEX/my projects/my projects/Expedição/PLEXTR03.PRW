#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXPR02    บAutor  ณWilson Guedes     				บ Data ณ  01/06/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO DE SAIDA DA EXPEDIวรO		    								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEXPR03()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLEXPR03"

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

	oReport := TReport():New(cPerg,"Relatorio de Entrega",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()                                                                                                                      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo


	oSection := TRSection():New(oReport,"Relatorio de Entrega",{"SAI"},aOrdem) 
	TRCell():New(oSection,"C5_EMISSAO"		   			,"cAlias","Emissใo Pedido",,13)
	TRCell():New(oSection,"C6_ENTREG"		   			,"cAlias","Dt.Entrega",,13)
	TRCell():New(oSection,"DATRASO"		   				,"cAlias","Dias em Atraso",,9)
	TRCell():New(oSection,"D2_EMISSAO"					,"cAlias","Dt.Faturamento",,13)
	TRCell():New(oSection,"SAI_DTEXP"		   			,"cAlias","Dt.Expedi็ใo",,9)
	TRCell():New(oSection,"D2_DOC"		   				,"cAlias","Nota",,9)
	TRCell():New(oSection,"D2_SERIE"		   			,"cAlias","Serie",,)
	TRCell():New(oSection,"D2_CLIENTE"					,"cAlias","Cod.Cliente",,)
	TRCell():New(oSection,"A1_NOME"			   			,"cAlias","Nome",,30)
	TRCell():New(oSection,"ENT_STATUS"				   	,"cAlias","Status",,12)
	TRCell():New(oSection,"D2_ITEM"	    				,"cAlias","Item",,)
	TRCell():New(oSection,"D2_COD"		    			,"cAlias","Produto",,15)
	TRCell():New(oSection,"B1_DESC"						,"cAlias","Descri็ใo",/*Mascara*/,50)    
	TRCell():New(oSection,"ENT_QUANT"					,"cAlias","Quantidade",/*Mascara*/,)
	TRCell():New(oSection,"ENT_MOTORISTA"				,"cAlias","Motorista",,20)
	TRCell():New(oSection,"ENT_PLACA"		   			,"cAlias","Placa",,15)
	TRCell():New(oSection,"ENT_RECEBPOR"			 	,"cAlias","Recebido Por",,20)
	TRCell():New(oSection,"ENT_DTRECEB"					,"cAlias","Dt.Recebimento",,)
	TRCell():New(oSection,"ENT_HORARIO"					,"cAlias","Horario",,)


	TRCell():New(oSection,"ENT_OBS"						,"cAlias","Observa็ใo",,50)
	TRFunction():New(oSection:Cell("ENT_QUANT"),"TOTAL DE SAIDA","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	//Totalizador
	/*                                                                                  

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)



	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   




		SELECT D2_PEDIDO,C5_EMISSAO,C6_ENTREG,ENT_DTEXP,SAI_DTEXP,DATEDIFF (DAY,CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),103),CASE WHEN ENT_DTRECEB IS NULL THEN GETDATE() ELSE ENT_DTRECEB END) DATRASO,D2_DOC,D2_SERIE, D2_CLIENTE,A1_NOME,D2_EMISSAO,
		ISNULL(CASE WHEN ENT_DTEXP IS NULL THEN SAI_DTEXP ELSE ENT_DTEXP END,'') ENT_DTEXP,
		CASE WHEN ENT_STATUS = 0 THEN 'DEVOLVIDO' 
		WHEN ENT_STATUS = 1 THEN CASE WHEN (ENT_DTEXP IS NOT NULL) AND (SAI_DTEXP IS NOT NULL) THEN 'ENTREGUE' END ELSE 'NรO ENTREGUE' END ENT_STATUS, 
		ISNULL(D2_ITEM,'') D2_ITEM,ISNULL(D2_COD,'')D2_COD,ISNULL(B1_DESC,'')B1_DESC,ISNULL(ENT_QUANT,'') ENT_QUANT,
		ISNULL(ENT_MOTORISTA,'') ENT_MOTORISTA,ISNULL(ENT_PLACA,'')ENT_PLACA,ISNULL(ENT_RECEBPOR,'') ENT_RECEBPOR,ISNULL(ENT_DTRECEB,'')ENT_DTRECEB,ISNULL(ENT_HORARIO,'') ENT_HORARIO ,ISNULL(ENT_OBS,'') ENT_OBS
		FROM SD2100 SD2  (NOLOCK) 
		INNER JOIN SB1100 SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN SC6100 SC6 (NOLOCK) ON D2_FILIAL = C6_FILIAL AND D2_ITEMPV = C6_ITEM AND D2_COD = C6_PRODUTO AND D2_PEDIDO = C6_NUM AND D2_SERIE = C6_SERIE AND SC6.D_E_L_E_T_ = ''
		LEFT JOIN SAI (NOLOCK) ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND D2_ITEM = SAI_ITEM AND D2_COD = SAI_PRODUTO
		LEFT JOIN ENTREGA (NOLOCK) ON ENT_DOC = D2_DOC AND D2_SERIE = ENT_SERIE AND D2_FILIAL = ENT_FILIAL AND ENT_ITEM = D2_ITEM AND ENT_PRODUTO = D2_COD
		LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
		LEFT JOIN SC5100 SC5 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_ = ''
		INNER JOIN SF2100 SF2 (NOLOCK) ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND SF2.D_E_L_E_T_ = ''
		INNER JOIN SA1100 (NOLOCK) SA1 ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA1.D_E_L_E_T_ = ''
		WHERE  D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%  
		AND D2_LOCAL = '20'
		AND D1_EMISSAO IS NULL
		AND D2_FILIAL = '01'
		AND F2_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SD2.D_E_L_E_T_ = ''

		GROUP BY D2_PEDIDO,D2_DOC,D2_SERIE, D2_CLIENTE,A1_NOME,D2_EMISSAO,C5_EMISSAO,ENT_DTEXP,SAI_DTEXP,ENT_MOTORISTA,ENT_PLACA,ENT_RECEBPOR,C6_ENTREG,ENT_DTRECEB,ENT_HORARIO,ENT_STATUS,D2_ITEM,D2_COD,B1_DESC,ENT_QUANT,ENT_OBS
		ORDER BY C6_ENTREG,D2_DOC,D2_SERIE,D2_ITEM,D2_COD



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo De?     ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo Ate?    ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")  
	u_InPutSX1(cPerg,"03",PADR("Vendedor De?     ",20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Vendedor Ate?    ",20)+"?","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")  



Return