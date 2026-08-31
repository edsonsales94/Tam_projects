#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR21    บAutor  ณWilson Guedes     				บ Data ณ 19/03/2020บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Saida da Expedi็ใo									  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR21()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR21"

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

	oReport := TReport():New(cPerg,"Saida da Expedi็ใo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Saida da Expedi็ใo",{"SD2"},aOrdem)  


	TRCell():New(oSection,"SAI_DOC"		    ,"SC6","Nota",,)             
	TRCell():New(oSection,"SAI_SERIE" 		,"SC6","Serie",,/*Tamanho*/) 
	TRCell():New(oSection,"SAI_PRODUTO"    	,"SC6","Produto",,)
	TRCell():New(oSection,"SAI_DESCPROD"    ,"SC6","Descri็ใo",,)
	TRCell():New(oSection,"DTEXPEDICAO"    	,"SC6","Dt.Expedido",,)
	TRCell():New(oSection,"SAI_CPRODUC"    	,"SC6","Etiqueta",,)
	//Totalizador                                          

	/*                                        
	TRFunction():New(oSection:Cell("PRODUZIDO"),"Total Produzido","SUM",,,"@E 999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("SAIDA"),"Total Saida","SUM",,,"@E 999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("DIFERENCA"),"Diferen็a Total","SUM",,,"@E 999,999,999",,.F.,.T.)
	*/
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



		SELECT SAI_DOC,SAI_SERIE,SAI_PRODUTO,SAI_DESCPROD,SAI_CPRODUC,SAI_DTEXP+' '+SAI_DTHORA DTEXPEDICAO,SAI_CPRODUC 
		FROM SAI
		WHERE SAI_DOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SAI_SERIE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		ORDER BY SAI_DOC,SAI_SERIE


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Nota de",20)+"?","","","mv_ch1","c",9,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Nota Ate",20)+"?","","","mv_ch2","c",9,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Serie de",20)+"?","","","mv_ch3","c",9,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Serie Ate",20)+"?","","","mv_ch4","c",9,0,0,"G","","","","","mv_par04") 

Return
