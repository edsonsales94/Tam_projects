
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR40  บAutor  ณJuevan Silva     				บ Data ณ 03/01/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Indicador Assistencia Agendado x Atendido                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR40()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR40"

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

	oReport := TReport():New(cPerg,"Indicador Assistencia Agendado x Atendido",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Indicador Assistencia Agendado x Atendido",{"SD2"},aOrdem) 

    TRCell():New(oSection,"PERIODO"   	        ,"MDA","PERIODO","@!",10)
    TRCell():New(oSection,"TOTAL_AGENDADO"	            ,"MDA","TOTAL_AGENDADO","@E 999,999,999,999",)
    TRCell():New(oSection,"TOTAL_ATENDIDO"	            ,"MDA","TOTAL_ATENDIDO","@E 999,999,999,999",)
     TRCell():New(oSection,"PENDENCIA"	            ,"MDA","PENDENCIA","@E 999,999,999,999",)
    //TRCell():New(oSection,"A1_COD"  			,"SA1","CODIGO","@!",15)
     //TRCell():New(oSection,"A1_NOME"		    ,"SA1","NOME","@!",20)
	//TRCell():New(oSection,"A1_MUN"		    ,"SA1","CIDADE",,10)
   //TRCell():New(oSection,"C6_VALOR"		    ,"SC6","VALOR","@E 999,999,999,999",)
    //TRCell():New(oSection,"A1_NOME"		    ,"SA1","NOME","@!",20)
    //TRCell():New(oSection,"D2_TES"		    ,"SD2","TES","@!",20)
   //TRCell():New(oSection,"F4_TEXTO"		    ,"SF4","Descricao TES","@!",20)
    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)
	//TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    //TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	//TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	//TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
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

SELECT SUBSTRING(PERIODO,4,7)PERIODO,SUM(MDA_DATINC)TOTAL_AGENDADO,SUM(MDA_DATALT)TOTAL_ATENDIDO,SUM(MDA_DATINC)-SUM(MDA_DATALT)PENDENCIA
FROM(
SELECT MDA_DATINC PERIODO,CASE WHEN MDA_DATINC != '' THEN 1 ELSE 0 END MDA_DATINC,CASE WHEN MDA_DATALT = '' THEN 0 ELSE 1 END MDA_DATALT
FROM MDA
WHERE CONVERT(VARCHAR,CAST(MDA_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
GROUP BY SUBSTRING(PERIODO,4,7)
ORDER BY 1



		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
