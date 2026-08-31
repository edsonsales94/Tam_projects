#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMRHR01    บAutor  ณWylliam Silva     					บ Data ณ  06/07/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Catraca Refeitorio Detalhado		               		  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR01()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR01"

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

	oReport := TReport():New(cPerg,"Rel. Catraca Refeitorio Detalhado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Catraca Refeitorio Detalhado",{"POA"},aOrdem)  
	
	TRCell():New(oSection,"EMPRESA"			,"POA","EMPRESA","@!",10)
	TRCell():New(oSection,"MATRICULA"		,"POA","MATRICULA","@!",8)
	TRCell():New(oSection,"NOME"			,"POA","NOME","@!",30)
	TRCell():New(oSection,"DATA"			,"POA","DATA","@!",10)
	TRCell():New(oSection,"HORA"			,"POA","HORA","@!",10)
	TRCell():New(oSection,"TIPO"			,"POA","TIPO","@!",15)
	
	/*TRCell():New(oSection,"C6_FILIAL"	  	,"SC2","FILIAL","@!",2)
	TRCell():New(oSection,"C6_NUM"			,"SC6","PEDIDO","@!",8)   
	TRCell():New(oSection,"C5_EMISSAO"	 	,"SC5","DT EMISSAO","@!",10)         
	TRCell():New(oSection,"C6_ENTREG"  	    ,"SC6","DT ENTREGA","@!",10)
	TRCell():New(oSection,"C6_ITEM"  	 	,"SC6","ITEM","@!",3)
	TRCell():New(oSection,"C6_PRODUTO"    	,"SC6","PRODUTO","@!",15)
	TRCell():New(oSection,"C6_DESCRI"   	,"SC6","DESCRIวAO","@!",30)
	TRCell():New(oSection,"C6_QUANT"    	,"SC6","QUANTIDADE","@E 999,999,999,999",) 
	TRCell():New(oSection,"C6_PRCVEN"    	,"SC6","PREวO VEND","@E 999,999,999.999",)
	TRCell():New(oSection,"TOTAL"    		,"SC6","TOTAL","@E 999,999,999.999",)
	TRCell():New(oSection,"A1_NOME"  	  	,"SA1","CLIENTE","@!",30)
	TRCell():New(oSection,"A1_NREDUZ"    	,"SA1","CLIENTE","@!",10)
	
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)*/

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

		SELECT CASE WHEN POA_EMPRESA = '10' THEN 'PELMEX' ELSE 'AMAZON' END EMPRESA,POA_MAT MATRICULA,POA_NOME NOME,POA_DATA DATA,POA_HORA HORA,POA_TIPO TIPO
		FROM POA
		WHERE CONVERT(VARCHAR,CAST(POA_DATA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		ORDER BY POA_EMPRESA DESC,CONVERT(VARCHAR,CAST(POA_DATA AS DATE),112),POA_MAT,POA_HORA
		

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De DATA:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate DATA:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return