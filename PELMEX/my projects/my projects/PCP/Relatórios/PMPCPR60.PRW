#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR60    บAutor  ณWylliam Silva     				บ Data ณ  22/02/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Notas Expedidas                                          			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR60()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR60"

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

	oReport := TReport():New(cPerg,"Notas Expedidas",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Notas Expedidas",{"SC2"},aOrdem)  
	
	
	TRCell():New(oSection,"DT_OP"		 			     ,"SC2","DT PROD.","@!",10)             
	TRCell():New(oSection,"OP"         					 ,"SC2","ORDEM PROD.","@!",10)
	TRCell():New(oSection,"CLIENTE_OP"	    			 ,"SC2","CLIENTE","@!",30)
	TRCell():New(oSection,"CLIENTE_EXPEDIDO"	    	 ,"SAI","CLIENTE EXPEDIDO","@!",30)
	TRCell():New(oSection,"NOTA"	    				 ,"SAI","NOTA","@!",8)
	TRCell():New(oSection,"SERIE"	    				 ,"SAI","SERIE","@!",3)
	TRCell():New(oSection,"ITEM"	    				 ,"SAI","ITEM","@!",3)
	TRCell():New(oSection,"PRODUTO"	    				 ,"SAI","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"	    			 ,"SAI","DESCRICAO","@!",40)
	TRCell():New(oSection,"QTD_EXPEDIDA"	   			 ,"SAI","QTD EXPEDIDA","@E 9,999,999,999.99",)
	TRCell():New(oSection,"DT_EXPEDICAO"	   			 ,"SAI","DT EXPEDIDA","@!",10)
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

	SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_OP,C2_NUM OP,C2_OBS CLIENTE_OP,SAI_NOME CLIENTE_EXPEDIDO,SAI_DOC NOTA,SAI_SERIE SERIE,
       SAI_ITEM ITEM,SAI_PRODUTO PRODUTO,SAI_DESCPROD DESCRICAO,SUM(SAI_QUANT)QTD_EXPEDIDA,SAI_DTEXP DT_EXPEDICAO
	FROM SC2100 SC2
	INNER JOIN SAI ON C2_NUM = SUBSTRING(SAI_CPRODUC,1,6)
	WHERE SC2.D_E_L_E_T_ = ''
	AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SAI_NOME NOT LIKE C2_OBS+'%'
	GROUP BY C2_EMISSAO,C2_NUM,C2_OBS,SAI_NOME,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO,SAI_DESCPROD,SAI_DTEXP
	ORDER BY SAI_DOC,SAI_ITEM	


EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissใo:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Emissใo:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
Return