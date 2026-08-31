#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLOJR02    บAutor  ณStan Lee Lopes     				บ Data ณ  31/10/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Comiss๕es Variaveis           								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMLOJR08()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMLOJR08"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE COMISSีES VARIAVEIS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Comissใo",{"SL1"},aOrdem) 

	TRCell():New(oSection,"L1_FILIAL"		,"SL1","Filial",/*Mascara*/)
	TRCell():New(oSection,"L1_EMISNF"		,"SL1","Dt.Emissใo",/*Mascara*/,) 
	TRCell():New(oSection,"L1_NUM"   		,"SL1","Orc/Pedido",/*Mascara*/,) 
	TRCell():New(oSection,"L1_DOC"		    ,"SL1","NFe/NFCe/Pedido",/*Mascara*/,13)
	TRCell():New(oSection,"L1_SERIE"		,"SL1","S้rie"		  ,/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"NOTA"	        ,"SL1","Nota Fiscal",/*Mascara*/,13)
	TRCell():New(oSection,"SERIE"		    ,"SL1","S้rie"		  ,/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"D1_EMISSAO"		,"SD1","Dt.Devolu็ใo",/*Mascara*/,) 
	TRCell():New(oSection,"A1_COD"    		,"SA1","Cliente",/*Mascara*/,)
	TRCell():New(oSection,"A1_NOME"    		,"SA1","Cliente",/*Mascara*/,)
	TRCell():New(oSection,"L2_PRODUTO"		,"SL2","C๓digo",/*Mascara*/,25)  
	TRCell():New(oSection,"B1_DESC"		    ,"SL2","Descri็ใo",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"L2_VLRITEM" 		,"SL2","Base Comissใo","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"NSUTEF"   	    ,"SL1","NSU TEF",/*Mascara*/,20) 
	TRCell():New(oSection,"B1_COMIS"   		,"SB1","%Comissใo","@E 999,999.99",/*Tamanho*/)
	TRCell():New(oSection,"L1_VLRTOT"       ,"SL1","Valor Comissใo","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"L2_VEND"		    ,"SL2","Cod.Vendedor",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"A3_NOME"		    ,"SA3","Vendedor",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"L1_XRES"		    ,"SL1","Origem",/*Mascara*/,/*Tamanho*/)


	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)


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

		SELECT L1_FILIAL,L1_EMISNF,L1_NUM,
		L1_DOC,
		L1_SERIE,
		NOTA,
		SERIE,
		D1_EMISSAO,
		A1_COD,A1_NOME,
		L2_PRODUTO,B1_DESC,
		CASE WHEN D1_EMISSAO = '' THEN L2_VLRITEM ELSE L2_VLRITEM * -1 END L2_VLRITEM,
		NSUTEF,
		B1_COMIS,
		CASE WHEN D1_EMISSAO = '' THEN L1_VLRTOT ELSE L1_VLRTOT * -1 END L1_VLRTOT,
		L2_VEND,A3_NOME,
		CASE WHEN L1_XRES = '1' THEN 'PRODUวรO'
		ELSE 'ESTOQUE' END L1_XRES
		FROM(
		SELECT SL1.L1_FILIAL,SL1.L1_EMISNF,SL1.L1_NUM,
		CASE WHEN SL1.L1_DOCPED = '' THEN SL1.L1_DOC ELSE SL1.L1_DOCPED END L1_DOC,
		CASE WHEN SL1.L1_SERPED = '' THEN SL1.L1_SERIE ELSE SL1.L1_SERPED END L1_SERIE,
		CASE WHEN SC5.C5_NOTA IS NULL THEN SL1.L1_DOC ELSE SC5.C5_NOTA END NOTA,
		CASE WHEN SC5.C5_SERIE IS NULL THEN SL1.L1_SERIE ELSE SC5.C5_SERIE END SERIE,
		'' D1_EMISSAO,
		CASE WHEN SL1.L1_FILIAL IN ('14','15','16','17','18') AND A1_COD IS NULL THEN '003067'
		WHEN SL1.L1_FILIAL NOT IN ('14','15','16','17','18') AND A1_COD IS NULL THEN '001041'
		ELSE A1_COD END A1_COD,
		CASE WHEN SL1.L1_FILIAL IN ('14','15','16','17','18') AND A1_NOME IS NULL THEN 'CLIENTE PADRAO PARA'
		WHEN SL1.L1_FILIAL NOT IN ('14','15','16','17','18') AND A1_NOME IS NULL THEN 'CLIENTE PADRAO MANAUS'
		ELSE A1_NOME END A1_NOME,
		L2_PRODUTO,B1_DESC,
		L2_VLRITEM,
		SL1.L1_NSUTEF NSUTEF,
		CASE WHEN SL1.L1_FILIAL IN ('14','15','16','17','18') THEN 5
		ELSE CASE WHEN L1_XRES = '1' THEN 3 ELSE 6 END END B1_COMIS,
		CASE WHEN SL1.L1_FILIAL IN ('14','15','16','17','18') THEN ((((L2_VRUNIT*L2_QUANT)*5)/100))
		ELSE ((((L2_VLRITEM)*CASE WHEN L1_XRES = '1' THEN 3 ELSE 6 END)/100)) END AS L1_VLRTOT,
		L2_VEND,A3_NOME,L1_XRES
		FROM %Table:SL1% SL1 (NOLOCK)
		LEFT JOIN %Table:SC5% SC5 (NOLOCK) ON SL1.L1_FILIAL = CASE WHEN SC5.C5_XFILRES = '' THEN SC5.C5_FILIAL ELSE SC5.C5_XFILRES END 
		AND SL1.L1_NUM = CASE WHEN SC5.C5_XORCRES = '' THEN SC5.C5_ORCRES ELSE SC5.C5_XORCRES END AND SC5.D_E_L_E_T_ = ''								  
		LEFT JOIN %Table:SA1% SA1 (NOLOCK) ON SL1.L1_CLIENTE = A1_COD AND SL1.L1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL !='1'
		INNER JOIN %Table:SL2% SL2 (NOLOCK) ON SL1.L1_FILIAL = L2_FILIAL AND SL1.L1_NUM = L2_NUM AND SL2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON L2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA3% SA3 (NOLOCK) ON L2_VEND = A3_COD AND SA3.D_E_L_E_T_ = ''
		WHERE SL1.L1_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SL1.L1_EMISNF BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND L2_VEND BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SL1.D_E_L_E_T_ = ''
		AND SL1.L1_SERIE NOT IN ('20','19','18','17','16','15','14','13','12','11','10','9','8','7','6','5','4','3') 
		AND SL1.L1_SITUA IN ('OK','FR','')
		AND (SL1.L1_DOC != '' OR SL1.L1_DOCPED != '')     

		UNION ALL 
		SELECT SL1.L1_FILIAL,SL1.L1_EMISNF,SL1.L1_NUM,
		CASE WHEN SL1.L1_DOCPED = '' THEN SL1.L1_DOC ELSE SL1.L1_DOCPED END L1_DOC,
		CASE WHEN SL1.L1_SERPED = '' THEN SL1.L1_SERIE ELSE SL1.L1_SERPED END L1_SERIE,
		CASE WHEN C5_NOTA IS NULL THEN CASE WHEN SD1.D1_EMISSAO IS NULL THEN SL1.L1_DOC ELSE SD1.D1_DOC END ELSE C5_NOTA END NOTA,
		CASE WHEN C5_SERIE IS NULL THEN CASE WHEN SD1.D1_EMISSAO IS NULL THEN SL1.L1_SERIE ELSE SD1.D1_SERIE END ELSE C5_SERIE END SERIE,
		D1_EMISSAO,
		A1_COD,A1_NOME,
		L2_PRODUTO,B1_DESC,
		L2_VLRITEM,
		SL1.L1_NSUTEF NSUTEF,
		CASE WHEN SL1.L1_FILIAL IN ('14','15','16','17','18') THEN 5
		ELSE B1_COMIS END B1_COMIS,
		CASE WHEN SL1.L1_FILIAL IN ('14','15','16','17','18') THEN (((L2_VRUNIT*L2_QUANT)*5)/100) ELSE (((L2_VLRITEM)*B1_COMIS)/100) END AS L1_VLRTOT,
		L2_VEND,A3_NOME,L1_XRES
		FROM %Table:SL1% SL1 (NOLOCK)
		LEFT JOIN %Table:SC5% SC5 (NOLOCK) ON SL1.L1_FILIAL = CASE WHEN SC5.C5_XFILRES = '' THEN SC5.C5_FILIAL ELSE SC5.C5_XFILRES END 
		AND SL1.L1_NUM = CASE WHEN SC5.C5_XORCRES = '' THEN SC5.C5_ORCRES ELSE SC5.C5_XORCRES END AND SC5.D_E_L_E_T_ = ''								  
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SL1.L1_CLIENTE = A1_COD AND SL1.L1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL !='1'
		INNER JOIN %Table:SL2% SL2 (NOLOCK) ON SL1.L1_FILIAL = L2_FILIAL AND SL1.L1_NUM = L2_NUM AND SL2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON L2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA3% SA3 (NOLOCK) ON L2_VEND = A3_COD AND SA3.D_E_L_E_T_ = ''
		INNER JOIN %Table:SD1% SD1 (NOLOCK) ON SL2.L2_DOC = SD1.D1_NFORI AND SL2.L2_SERIE = SD1.D1_SERIORI AND SL2.L2_ITEM = SD1.D1_ITEMORI AND SL2.L2_PRODUTO = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
		WHERE SL1.L1_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SD1.D1_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND L2_VEND BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SL1.D_E_L_E_T_ = ''
		AND SL1.L1_SITUA IN ('OK','FR','') 
		)TB
		ORDER BY 1,3,4,5

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Filial De    ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Filial At้   ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02") 
	PutSX1(cPerg,"03",PADR("Emissao De    ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	PutSX1(cPerg,"04",PADR("Emissao At้   ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04") 
	PutSX1(cPerg,"05",PADR("Vendedor De    ",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA3","","","mv_par05") 
	PutSX1(cPerg,"06",PADR("Vendedor At้   ",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA3","","","mv_par06")

Return
