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


User Function PLESTR22()
	Local oReport
	Local cQuery
	Local cAlias    := getNextAlias()

	Private cPerg   := "PLESTR22"

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

	oReport := TReport():New(cPerg,"COMPARATIVO DE CUSTO SALDO INICIAL",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"COMPARATIVO DE CUSTO SALDO INICIAL",{"SB9"},aOrdem)     


	TRCell():New(oSection,"B9_COD"			,"SB9","CODIGO","!@",15)
	TRCell():New(oSection,"B1_DESC"	    	,"SB9","DESCRICAO","!@",30)
	TRCell():New(oSection,"B9_LOCAL"	   	,"SB9","LOCAL","!@",4)
	TRCell():New(oSection,"B1_TIPO"	 	  	,"SB1","TIPO","!@",4)
	TRCell():New(oSection,"DTINI"			,"SB9","DATA INI","!@",8)
	TRCell():New(oSection,"B9_QINI"			,"SB9","QUANT INI","@E 9,999,999.999",)
	TRCell():New(oSection,"B9_CM1"		    ,"SB9","VLRUNIT","@E 9,999,999.999",)   
	TRCell():New(oSection,"B9_VINI1"	    ,"SB9","VLRTTL","@E 9,999,999.999",)       
	
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

    SELECT B9_COD,B1_DESC,B9_LOCAL,B1_TIPO,CONVERT(VARCHAR,CAST(B9_DATA AS DATE),103) DTINI,B9_QINI,B9_CM1,B9_VINI1
        FROM %Table:SB9% SB9 (NOLOCK)
        INNER JOIN %Table:SB1% SB1 (NOLOCK) ON B9_COD = B1_COD AND SB1.D_E_L_E_T_ =''
        WHERE SB9.D_E_L_E_T_ = ''
        AND B9_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        AND B9_FILIAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
        AND B9_LOCAL BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
        AND CONVERT(VARCHAR,CAST(B9_DATA AS DATE),112) BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
        ORDER BY CONVERT(VARCHAR,CAST(B9_DATA AS DATE),112),B9_COD 
	
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Codigo ?    ",20)+"?","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Codigo?    ",20)+"?","","","mv_ch2","C",15,0,0,"G","","","","","mv_par02")  
	u_InPutSX1(cPerg,"03",PADR("De Filial?     ",20)+"?","","","mv_ch3","C",4,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("At้ Filial?    ",20)+"?","","","mv_ch4","C",4,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Local De ?     ",20)+"?","","","mv_ch5","C",2,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Local At้ ?    ",20)+"?","","","mv_ch6","C",2,0,0,"G","","","","","mv_par06") 
	u_InPutSX1(cPerg,"07",PADR("De Data ?      ",20)+"?","","","mv_ch7","D",10,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("At้ Data?      ",20)+"?","","","mv_ch8","D",10,0,0,"G","","","","","mv_par08") 
Return

