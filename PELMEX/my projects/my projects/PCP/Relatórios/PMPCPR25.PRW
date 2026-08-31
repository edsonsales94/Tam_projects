#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR20    บAutor  ณStan Lee Lopes     				บ Data ณ  11/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Produtos polishop  sintetico 						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR25()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR25"

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

	oReport := TReport():New(cPerg,"Entrada x Saida",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Entrada x Saida",{"SD2"},aOrdem)  


	TRCell():New(oSection,"DT"		    ,"SZ1","Data",,60)             
	TRCell():New(oSection,"ETIQUETA" 	,"SZ1","Etiqueta","@E 999,999,999,999",14) 
	TRCell():New(oSection,"ENTRADA"    	,"SZ1","Entrada","@E 999,999,999,999",14)
	TRCell():New(oSection,"SAIDA"    	,"SZ1","Saida","@E 999,999,999,999",14)
	TRCell():New(oSection,"DIFER"    	,"SZ1","Entrada - Saida","@E 999,999,999,999",14)
	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("ENTRADA"),"Entrada:","SUM",,,"@E 999,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("SAIDA"),"Saida:","SUM",,,"@E 999,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("DIFER"),"Entrada - Saida:","SUM",,,"@E 999,999,999,999",,.F.,.T.)
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


		SELECT CONVERT(VARCHAR,CAST(DT AS DATE),103) DT,SUM(C2_QUANT) ETIQUETA,SUM(ENTRADA)ENTRADA,SUM(SAIDA)SAIDA,SUM(SAIDA-ENTRADA)DIFER
		FROM(
		SELECT COUNT(*)ENTRADA,0 SAIDA,Z1_DTAPONT DT,0 C2_QUANT
		FROM SZ1100 SZ1
		WHERE Z1_DTAPONT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SZ1.D_E_L_E_T_ = ''
		AND Z1_USER NOT LIKE 'AJUST%'
		GROUP BY Z1_DTAPONT

		UNION

		SELECT 0 ENTRADA,COUNT(*) SAIDA,CONVERT(VARCHAR,CAST(SAI_DTEXP AS DATE),112) SAI_DTEXP,0 C2_QUANT
		FROM SAI
		WHERE CONVERT(VARCHAR,CAST(SAI_DTEXP AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY SAI_DTEXP

		UNION

		SELECT 0 ENTRADA,0 SAIDA,C2_EMISSAO DT ,SUM(C2_QUANT) C2_QUANT
		FROM SC2100
		WHERE C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C2_LOCAL = '20'
		AND D_E_L_E_T_ = ''
		GROUP BY C2_EMISSAO,C2_NUM
		)TB
		GROUP BY TB.DT
		ORDER BY 1



	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo de:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo ate:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return