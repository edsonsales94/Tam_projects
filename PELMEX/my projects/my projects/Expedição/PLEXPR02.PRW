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


User Function PLEXPR02()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLEXPR02"

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

	oReport := TReport():New(cPerg,"Saida da expedi็ใo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()                                                                                                                      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Saida da expedi็ใo",{"SAI"},aOrdem) 


	TRCell():New(oSection,"SAI_PRODUTO"				,"SAI","Cod.Produto",/*Mascara*/,20) 
	TRCell():New(oSection,"SAI_DESCPROD"	 		,"SAI","Descri็ใo",/*Mascara*/,70)
	TRCell():New(oSection,"SAI_QUANT"				,"SAI","Qtd.Expedida","@E 9,999,999,999",20) 
	TRCell():New(oSection,"B2_QATU"					,"SB2","Saldo Atual","@E 9,999,999,999",20) 


	TRFunction():New(oSection:Cell("SAI_QUANT"),"TOTAL DE SAIDA","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("B2_QATU"),"TOTAL DE PRODUTOS","SUM",,,"@E 9,999,999,999",,.F.,.T.)
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


		SELECT SAI_PRODUTO,SAI_DESCPROD,SUM(SAI_QUANT) SAI_QUANT,B2_QATU FROM SAI
		INNER JOIN SB2100 SB2 ON B2_COD = SAI_PRODUTO AND SAI_FILIAL = B2_FILIAL  AND B2_LOCAL = '20' AND SB2.D_E_L_E_T_ =''
		WHERE 
		CONVERT(VARCHAR(13),CAST(SAI_DTEXP AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY SAI_PRODUTO,SAI_DESCPROD,B2_QATU
		ORDER BY SAI_PRODUTO



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Expedi็ใo De?     ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Expedi็ใo Ate?    ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")  



Return