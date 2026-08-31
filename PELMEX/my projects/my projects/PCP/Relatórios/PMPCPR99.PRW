#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR99   บAutor  ณJuevan Silva     				บ Data ณ  27/03/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Produziado X Realizado Assistencia                       			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR99()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR99"

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

	oReport := TReport():New(cPerg,"Produziado X Realizado Assistencia",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Produziado X Realizado Assistencia",{"SC2"},aOrdem) 


    TRCell():New(oSection,"PERIODO"   	     ,"SGQ","PERIODO","@!",10)
	TRCell():New(oSection,"QTD_AGENDADA"		      ,"SGQ","QTD_AGENDADA","@@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_ATENDIDA"		     ,"SGQ","QTD_ATENDIDA","@@E 999,999,999.999",)
    TRCell():New(oSection,"PENDENTE"		    ,"SGQ","PENDENTE","@@E 999,999,999.999",)
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


SELECT SUBSTRING(DT_AGENDAMENTO,4,7)PERIODO,SUM(QTD_AGENDADA)QTD_AGENDADA,SUM(QTD_ATENDIDA)QTD_ATENDIDA,SUM(QTD_AGENDADA)-SUM(QTD_ATENDIDA)PENDENTE
FROM(
SELECT MDA_DTAGENDA DT_AGENDAMENTO,COUNT(*)QTD_AGENDADA,0 QTD_ATENDIDA
FROM MDA
WHERE CONVERT(VARCHAR,CAST(MDA_DTAGENDA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND MDA_STATUS NOT LIKE '%DELETADO%'
GROUP BY MDA_DTAGENDA
UNION
SELECT MDA_DTAGENDA DT_GENDAMENTO,0 QTD_AGENDADA,COUNT(*)QTD_ATENDIDA
FROM MDA
WHERE CONVERT(VARCHAR,CAST(MDA_DTAGENDA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND (MDA_STATUS LIKE '%FINALIZADO%'
OR MDA_STATUS LIKE '%DESISTENCIA DA ASSISTENCIA%')
GROUP BY MDA_DTAGENDA
)TB
GROUP BY SUBSTRING(DT_AGENDAMENTO,4,7)
ORDER BY 1

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
