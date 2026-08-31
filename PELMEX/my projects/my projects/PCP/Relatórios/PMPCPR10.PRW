#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR10    บAutor  ณStan Lee Lopes     				บ Data ณ  17/06/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO DE SAIDA DA EXPEDIวรO		    								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR10()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR10"

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

	oReport := TReport():New(cPerg,"SAIDA DA EXPEDIวรO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()                                                                                                                      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"SAIDA DA EXPEDIวรO",{"SAI"},aOrdem) 


	TRCell():New(oSection,"SAI_DOC"				,"SAI","Nota Fiscal",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"SAI_SERIE"	 		,"SAI","S้rie",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"SAI_EMISSAO"			,"SAI","Dt.Fat",/*Mascara*/,12)
	TRCell():New(oSection,"SAI_CLIENTE"			,"SAI","Cod. Cliente",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"SAI_NOME"			,"SAI","Cliente Saida",/*Mascara*/,50) 
	TRCell():New(oSection,"SAI_PRODUTO"			,"SAI","Produto",/*Mascara*/,18) 
	TRCell():New(oSection,"SAI_DESCPROD"		,"SAI","Descri็ใo",/*Mascara*/,70) 
	TRCell():New(oSection,"SAI_CPRODUC"			,"SAI","Etiqueta",/*Mascara*/,20)
	TRCell():New(oSection,"SAI_DTEXP"			,"SAI","DT.Saida",/*Mascara*/,12)
	TRCell():New(oSection,"C2_XNOME"			,"SC2","Cliente Original",/*Mascara*/,50)  

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

		/*
		SELECT *
		FROM SAI (NOLOCK)
		WHERE SUBSTRING(SAI_CPRODUC,1,6) = %Exp:MV_PAR01%
		ORDER BY SAI_CPRODUC
		*/
		SELECT SAI_DOC,SAI_SERIE,SAI_CLIENTE,SAI_NOME,SAI_PRODUTO,SAI_CPRODUC,SAI_DESCPROD,CONVERT(VARCHAR(10), CAST(SAI_EMISSAO AS DATE), 103) SAI_EMISSAO ,SAI_DTEXP,C2_XNOME,C2_XNOME
		FROM SAI SAI (NOLOCK)
		INNER JOIN %Table:SC2% (NOLOCK) SC2 ON C2_NUM+C2_ITEM+C2_SEQUEN = SUBSTRING(SAI_CPRODUC,1,11) AND SAI_FILIAL = C2_FILIAL
		WHERE SUBSTRING(SAI_CPRODUC,1,6) BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SAI_DOC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SAI_SERIE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SAI_EMISSAO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%

		GROUP BY SAI_DOC,SAI_SERIE,SAI_CLIENTE,SAI_NOME,SAI_PRODUTO,SAI_CPRODUC,SAI_EMISSAO,SAI_DESCPROD,SAI_DTEXP,C2_XNOME
		ORDER BY SAI_DOC,SAI_SERIE,SAI_CPRODUC,SAI_DTEXP


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Etiqueta De?     ",20)+"?","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Etiqueta Ate?    ",20)+"?","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Nota De?     	 ",20)+"?","","","mv_ch3","C",9,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Nota Ate?     	 ",20)+"?","","","mv_ch4","C",9,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Serie De?     	 ",20)+"?","","","mv_ch5","C",3,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Serie Ate?    	 ",20)+"?","","","mv_ch6","C",3,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Emissใo de?      ",20)+"?","","","mv_ch7","D",8,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Emissใo Ate?     ",20)+"?","","","mv_ch8","D",8,0,0,"G","","","","","mv_par08")


Return