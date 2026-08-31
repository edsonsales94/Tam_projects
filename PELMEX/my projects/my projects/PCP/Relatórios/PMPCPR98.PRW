#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR98   บAutor  ณJuevan Silva     				บ Data ณ  27/03/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Inspe็ใo Final por Problema                       			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR98()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR98"

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

	oReport := TReport():New(cPerg,"Inspe็ใo Final por Problema",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Inspe็ใo Final por Problema",{"SC2"},aOrdem) 

  CLIENTE
    TRCell():New(oSection,"PERIODO"   	     ,"SGQ","PERIODO","@!",10)
	TRCell():New(oSection,"NC"		      ,"SGQ","NC","@!",20)
	TRCell():New(oSection,"QTD_NC"		     ,"SGQ","QTD_NC","@@E 999,999,999.999",)
    //TRCell():New(oSection,"QTD_INSPECAO"		    ,"SGQ","QTD_INSPECAO","@@E 999,999,999.999",)
	//TRCell():New(oSection,"PENDENTE"		    ,"SGQ","PENDENTE","@@E 999,999,999.999",)
    //TRCell():New(oSection,"QTD_NC"	     ,"SGQ","QTD_NC","@@E 999,999,999.999",)    
	//TRCell():New(oSection,"QUANTIDADE"  	    ,"PED","QUANTIDADE","@@E 999,999,999.999",)
	//TRCell():New(oSection,"G1_XDENSID"			    ,"SG1","G1_XDENSID","@!",4)
	//TRCell():New(oSection,"G1_XDIMENS"        ,"SG1","G1_XDENSID","@!",30)
	//TRCell():New(oSection,"QTD_SOLICITADA" 	,"SG1","QTDE SOLICITAdA","@E 999,999,999.999",)
	//TRCell():New(oSection,"QTD_EMPENHADA"	,"SG1","QtDE EMPENHADA","@E 999,999,999.999",)
	//TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",12)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 
	
    
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

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


SELECT SUBSTRING(SGQ_DATINC,4,7)PERIODO,SGQ_CONFORME NC,CAST(SUM(SGQ_QUANT) AS FLOAT) QTD_NC
FROM SGQ (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON SGQ_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(SGQ_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND SGQ_AVARIA = 'S'
GROUP BY SUBSTRING(SGQ_DATINC,4,7),SGQ_CONFORME
ORDER BY 1,2

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("DT Ini:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("DT Fim:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
