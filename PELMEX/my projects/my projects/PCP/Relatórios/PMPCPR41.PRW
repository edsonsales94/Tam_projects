#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR41    บAutor  ณWYLLIAM SILVA     				บ Data ณ  28/10/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Produto por Estrutura     								     ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PMPCPR41()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR41"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE PRODUTO POR ESTRUTURA",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"PRODUTO POR ESTRUTURA",{"SC2"},aOrdem) 

	TRCell():New(oSection,"C2_PRODUTO"		,"SC2","COD. PRODUTO",/*Mascara*/,20)     
	TRCell():New(oSection,"B1_DESC"         ,"SB1","DESC. PRODUTO",/*Mascara*/,50)  
	TRCell():New(oSection,"C2_QUANT"        ,"SC2","QUANTIDADE","@E 9,999,999,999.99",20)  
	TRCell():New(oSection,"G1_COMP"		    ,"SG1","COD. COMPONENTE",/*Mascara*/,20)
	TRCell():New(oSection,"B1_DESC"	        ,"SB1","DESC. COMPONENTE",/*Mascara*/,50)
	TRCell():New(oSection,"B1_UM"	        ,"SB1","UNIDADE",/*Mascara*/,20) 
	TRCell():New(oSection,"G1_QUANT"        ,"SG1","QUANT.ESTRUTURA","@E 9,999,999,999.9999",20)   
	TRCell():New(oSection,"TOTAL"		    ,"TOTAL","TOTAL ENPENHO","@E 9,999,999,999.9999",20) 
		

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("C6_VALOR"),"TOTAL FATURADO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("CUBAGEM"),"TOTAL CUBAGEM","SUM",,,"@E 999,999,999.999999",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)


Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

SELECT C2_PRODUTO,SB1.B1_DESC,G1_COMP,SB12.B1_DESC,SB12.B1_UM,G1_QUANT,SUM(C2_QUANT)C2_QUANT,SUM(C2_QUANT)*G1_QUANT TOTAL
FROM %Table:SC2% SC2
INNER JOIN %Table:SG1% SG1 ON C2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = ''
INNER JOIN %Table:SB1% SB1 ON C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN %Table:SB1% SB12 ON G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
WHERE SC2.D_E_L_E_T_ = ''
AND G1_COMP NOT LIKE 'MOD%'
AND G1_COMP BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C2_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
GROUP BY C2_PRODUTO,SB1.B1_DESC,G1_COMP,SB12.B1_DESC,SB12.B1_UM,G1_QUANT
ORDER BY SB1.B1_DESC,G1_COMP
		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	//u_InPutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"01",PADR("De Produto"     ,15)+"?","","","mv_ch1","C",50,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Produto"    ,15)+"?","","","mv_ch2","C",50,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("De Emissใo"     ,20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("At้ Emissใo"    ,20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")  
	
Return
