#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLOJR15    บAutor  ณWylliam Silva     				บ Data ณ  20/06/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Resumo Faturamento por Cliente											 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR45()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR45"

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

	oReport := TReport():New(cPerg,"Resumo Faturamento por Cliente",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Resumo Faturamento por Cliente",{"SD2"},aOrdem) 

	TRCell():New(oSection,"DT_EMISSAO"			,"SD2","Periodo","!@",10) 
	TRCell():New(oSection,"TOTAL"				,"SD2","Total","@E 999,999,999.99",)
	TRCell():New(oSection,"A1_NOME"			    ,"SA1","Cliente","!@",100)
	
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
		
        SELECT SUBSTRING(SUBSTRING(D2_EMISSAO,1,6),5,2)+'/'+SUBSTRING(SUBSTRING(D2_EMISSAO,1,6),1,4)DT_EMISSAO,SUM(D2_TOTAL)TOTAL,A1_NOME
		FROM SD2100 SD2 (NOLOCK)
		INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN SF4100 SF4 (NOLOCK) ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ''
		LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
		WHERE SD2.D_E_L_E_T_ = ''
		AND D1_DOC IS NULL
		AND F4_DUPLIC = 'S'
		AND D2_FILIAL = '01'
		AND D2_LOCAL = '20'
		AND D2_CLIENTE BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		GROUP BY SUBSTRING(D2_EMISSAO,1,6),A1_NOME
		ORDER BY SUBSTRING(D2_EMISSAO,1,6)
				

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)
	u_InPutSX1(cPerg,"01",PADR("De Cliente    ",20)+"?","","","mv_ch1","C",6,0,0,"G","","","SA1","","mv_par01")  
	u_InPutSX1(cPerg,"02",PADR("Ate Cliente   ",20)+"?","","","mv_ch2","C",6,0,0,"G","","","SA1","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Emissao NF    ",20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Ate Emissao NF   ",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
Return
