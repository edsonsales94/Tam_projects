#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLOJR15    บAutor  ณWylliam Silva     				บ Data ณ  20/06/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Gerencial	      												 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMLOJR16()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMLOJR16"

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

	oReport := TReport():New(cPerg,"Relat๓rio Gerencial",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relat๓rio Gerencial",{"SD2"},aOrdem) 

	TRCell():New(oSection,"DTEMISSAO"			,"SD2","DTEMISSAO","!@",10) 
	TRCell():New(oSection,"D2_DOC"				,"SD2","NF","!@",9)
	TRCell():New(oSection,"D2_SERIE"			,"SD2","SERIE","!@",4)
	TRCell():New(oSection,"D2_ITEM"				,"SD2","ITEM","!@",3)
	TRCell():New(oSection,"D2_COD"			  	,"SD2","CODIGO","!@",16) 
	TRCell():New(oSection,"D2_QUANT"		   	,"SD2","QTD","@E 999,999,999,99",)
	TRCell():New(oSection,"D2_PRUNIT"		    ,"SD2","PRวUNIT","@E 999,999,999.99",)
	TRCell():New(oSection,"D2_TOTAL"		 	,"SD1","TOTAL","@E 999,999,999.99",)
	TRCell():New(oSection,"D2_TES"				,"SD1","TES","!@",4) 
	TRCell():New(oSection,"D1_DOC"				,"SD1","NF_DEVOLU","!@",10) 
	TRCell():New(oSection,"D1_SERIE"			,"SD1","SERIE_DEVOLU","!@",4) 
	TRCell():New(oSection,"D1_QUANT"			,"SD1","QTD_DEVOLU","@E 999,999,999,99",) 
	TRCell():New(oSection,"SAI_DTEXP"			,"SAI","DTSAIEXP","!@",10) 
	TRCell():New(oSection,"SAI_USER"			,"SAI","DOCA","!@",10) 
	
	
	//Totalizador
	/*                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
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

		SELECT CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103) DTEMISSAO,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_PRUNIT,D2_TOTAL,D2_TES,D1_DOC,D1_SERIE ,D1_QUANT,
        SAI_DTEXP,SAI_USER
		FROM SD2100 SD2 (NOLOCK)
		LEFT JOIN SA1100 SA1 (NOLOCK) ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA 
		LEFT JOIN SD1100 (NOLOCK)SD1 ON D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_COD = D1_COD AND D2_FILIAL = D1_FILIAL
		//LEFT JOIN CNF (NOLOCK) ON CNF_DOC = D2_DOC AND CNF_SERIE = D2_SERIE AND CNF_SERIE = D2_FILIAL AND CNF_CLIENTE = D2_CLIENTE AND CNF_LOJA = D2_LOJA
		LEFT JOIN SAI (NOLOCK) ON SAI_DOC = D2_DOC AND SAI_SERIE = D2_SERIE AND SAI_FILIAL = D2_FILIAL AND SAI_CLIENTE = D2_CLIENTE
		WHERE SD2.D_E_L_E_T_ = ''
		AND D2_CLIENTE BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		GROUP BY  D2_EMISSAO,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_PRUNIT,D2_TES,D1_DOC,D1_SERIE,D1_QUANT,SAI_DTEXP,SAI_USER,D2_QUANT,D2_TOTAL
		ORDER BY CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),112), D2_DOC,D2_ITEM
				

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)
	u_InPutSX1(cPerg,"01",PADR("De Cliente    ",20)+"?","","","mv_ch1","C",6,0,0,"G","","","SA1","","mv_par01")  
	u_InPutSX1(cPerg,"02",PADR("Ate Cliente   ",20)+"?","","","mv_ch2","C",6,0,0,"G","","","SA1","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Data NF    ",20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Ate Data NF   ",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
Return
