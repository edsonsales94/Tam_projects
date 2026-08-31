#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR19    บAutor  ณStan Lee Lopes     				บ Data ณ  02/04/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Comiss๕es Representantes simplificado      				 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR30()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR30"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE COMISSีES REPRESENTANTES SIMPLIFICADO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Comissใo Representantes",{"SA1"},aOrdem) 
	TRCell():New(oSection,"A1_COD"    		,"SA1","Cliente",/*Mascara*/,)
	TRCell():New(oSection,"A1_NOME"    		,"SA1","Nome",/*Mascara*/,)
	TRCell():New(oSection,"C5_VEND1"        ,"SC5","Cod.Vendedor 1",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"A3_NOME"		    ,"SA3","Vendedor 1",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C5_VEND2"        ,"SC5","Cod.Vendedor 2",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"VEND2"		    ,"SA3","Vendedor 2",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"L2_VLRITEM" 		,"SD2","Base Comissใo","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"C5_COMIS1"   	,"SC5","%Comissใo","@E 999,999.99",/*Tamanho*/)
	TRCell():New(oSection,"L1_VLRTOT"       ,"SC5","Valor Comissใo","@E 999,999,999.99",/*Tamanho*/) 


	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"Base da Comissใo:","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"Valor da Comissใo:","SUM",,,"@E 999,999,999.99",,.F.,.T.)


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



		SELECT A1_COD,A1_NOME,C5_VEND1,A3_NOME,C5_VEND2,ISNULL(VEND2,'') VEND2,SUM(L2_VLRITEM) L2_VLRITEM,C5_COMIS1,SUM(L1_VLRTOT) L1_VLRTOT
		FROM (SELECT A1_COD,A1_NOME,
		CASE WHEN D1_EMISSAO IS NULL THEN CASE WHEN (C5_COMIS1 = 0 AND C5_VEND1 != '008') THEN 0 ELSE D2_TOTAL END ELSE D2_TOTAL*0 END L2_VLRITEM,
		CASE WHEN C5_COMIS1 = 0 THEN 0 ELSE C5_COMIS1 END C5_COMIS1,
		CASE WHEN D1_EMISSAO IS NULL THEN (D2_TOTAL * (CASE WHEN C5_COMIS1 = 0 THEN 0 ELSE C5_COMIS1 END) /100) ELSE (D2_TOTAL*0) END L1_VLRTOT,
		C5_VEND1,SA3.A3_NOME,C5_VEND2,SA32.A3_NOME VEND2
		FROM %Table:SD2% SD2 (NOLOCK)
		INNER JOIN %Table:SC6% SC6 (NOLOCK) ON SD2.D2_FILIAL = SC6.C6_FILIAL AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_COD = SC6.C6_PRODUTO AND SC6.D_E_L_E_T_ = ''
		INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SD2.D2_FILIAL = SC5.C5_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SD2.D2_CLIENTE = A1_COD AND SD2.D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SD2.D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SA3% SA3 (NOLOCK) ON SC5.C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
		LEFT JOIN SA3100 SA32 (NOLOCK) ON SC5.C5_VEND2 = SA32.A3_COD AND SA3.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SD2.D2_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
		WHERE SD2.D2_FILIAL BETWEEN '01' AND '01'
		AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C5_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
		AND C5_VEND2 BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SD2.D_E_L_E_T_ = ''
		AND SD2.D2_SERIE IN ('2','UNR')
		AND SA3.A3_TIPO = 'E'
		AND SD2.D2_TES != '561' 
		AND SD2.D2_CLIENTE BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		AND SD2.D2_LOJA BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
		)TB
		GROUP BY A1_COD,A1_NOME,C5_COMIS1,C5_VEND1,A3_NOME,C5_VEND2,TB.VEND2
		ORDER BY A1_COD






		/*
		SELECT A1_COD,A1_NOME,C5_VEND1,A3_NOME,SUM(L2_VLRITEM) L2_VLRITEM,C5_COMIS1,SUM(L1_VLRTOT) L1_VLRTOT
		FROM (SELECT A1_COD,A1_NOME,
		CASE WHEN D1_EMISSAO IS NULL THEN CASE WHEN (C5_COMIS1 = 0 AND C5_VEND1 != '008') THEN 0 ELSE D2_TOTAL END ELSE D2_TOTAL*0 END L2_VLRITEM,
		CASE WHEN C5_COMIS1 = 0 THEN 0 ELSE C5_COMIS1 END C5_COMIS1,
		CASE WHEN D1_EMISSAO IS NULL THEN (D2_TOTAL * (CASE WHEN C5_COMIS1 = 0 THEN 0 ELSE C5_COMIS1 END) /100) ELSE (D2_TOTAL*0) END L1_VLRTOT,
		C5_VEND1,A3_NOME
		FROM %Table:SD2% SD2 (NOLOCK)
		INNER JOIN %Table:SC6% SC6 (NOLOCK) ON SD2.D2_FILIAL = SC6.C6_FILIAL AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_COD = SC6.C6_PRODUTO AND SC6.D_E_L_E_T_ = ''
		INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SD2.D2_FILIAL = SC5.C5_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SD2.D2_CLIENTE = A1_COD AND SD2.D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SD2.D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SA3% SA3 (NOLOCK) ON SC5.C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SD2.D2_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
		WHERE SD2.D2_FILIAL BETWEEN '01' AND '01'
		AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND (C5_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% OR C5_VEND2 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% )
		AND SD2.D_E_L_E_T_ = ''
		AND SD2.D2_SERIE IN ('2','UNR')
		AND SA3.A3_TIPO = 'E'
		AND SD2.D2_TES != '561' 
		AND SD2.D2_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SD2.D2_LOJA BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%)TB
		GROUP BY A1_COD,A1_NOME,C5_COMIS1,C5_VEND1,A3_NOME
		ORDER BY A1_COD
		*/
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissao De     ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissao At้    ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Vendedor De    ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Vendedor At้   ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Vendedor De    ",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA3","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Vendedor At้   ",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA3","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Cliente De     ",20)+"?","","","mv_ch7","C",6,0,0,"G","","SA1","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Cliente At้    ",20)+"?","","","mv_ch8","C",6,0,0,"G","","SA1","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("Loja De        ",20)+"?","","","mv_ch9","C",6,0,0,"G","","","","","mv_par09") 
	u_InPutSX1(cPerg,"10",PADR("Loja At้       ",20)+"?","","","mv_cha","C",6,0,0,"G","","","","","mv_par10")

Return
