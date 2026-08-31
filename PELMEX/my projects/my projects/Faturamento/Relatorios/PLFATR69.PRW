#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR68  บAutor  ณKledson Oliveira   				บ Data ณ 06/03/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Relacao Materia Prima Assistencia              			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR69()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR69"

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

	oReport := TReport():New(cPerg,"Relacao Materia Prima Assistencia",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relacao Materia Prima Assistencia",{"SD2"},aOrdem) 

    TRCell():New(oSection,"PERIODO"   	      ,"CDE","PERIODO","@!",11)
    TRCell():New(oSection,"CDE_COMP"		    ,"CDE","COMPONENTE","@!",15)
    TRCell():New(oSection,"CDE_DESC"		    ,"CDE","DESCRICAO","@!",40)
    TRCell():New(oSection,"CDE_UM"		    ,"CDE","UNI MEDIDA","@!",03)
    TRCell():New(oSection,"QUANTIDADE"  			,"CDE","QUANTI","@E 999,999,999,999",10)
    TRCell():New(oSection,"B2_CM1"		    ,"SB2","CUSTO MEDIO","@E 999,999,999,999",10)
	TRCell():New(oSection,"TOTAL"		    ,"CDE","TOTAL","@E 999,999,999,999",10)
    //TRCell():New(oSection,"CODIGO"		    ,"SF8","NOTA","@!",10)
    //TRCell():New(oSection,"DESCRICAO"		    ,"SF8","SERIE_ORI","@!",03)
    //TRCell():New(oSection,"DT_CONHECIMENTO"		    ,"SF8","T_CONHECIMENTO","@!",10)
    //TRCell():New(oSection,"QTD_PERDA"		    ,"PED","QTD_PERDA","@E 999,999,999,999",)
    //TRCell():New(oSection,"DIFERENCA"		    ,"PED","DIFERENCA","@E 999,999,999,999",)
    //TRCell():New(oSection,"NOME"		    ,"PED","NOME","@!",30)
    //TRCell():New(oSection,"CIDADE"		    ,"PED","CIDADE","@!",10)
    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)
	//TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    //TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	//TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	//TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 

	
    
	
	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("TOTAL"),"Total:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

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


SELECT SUBSTRING(CDE_DATINC,4,7)PERIODO,CDE_COMP,CDE_DESC,CDE_UM ,SUM(CDE_QUANT)QUANTIDADE,B2_CM1, SUM(CDE_QUANT)*B2_CM1 TOTAL
FROM(
SELECT *
FROM CDE
WHERE CONVERT(VARCHAR,CAST(CDE_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %EXP:MV_PAR02%
)TB
INNER JOIN SB2100 SB2 ON CDE_COMP = B2_COD AND B2_FILIAL = '01' AND B2_LOCAL = '01'
GROUP BY SUBSTRING(CDE_DATINC,4,7),CDE_COMP,CDE_DESC,CDE_UM,B2_CM1
ORDER BY CDE_DESC

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("Dt. Inclusao de:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Dt Inclusao ate:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
