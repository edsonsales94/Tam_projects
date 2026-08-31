
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMRHR05  ºAutor  ³Juevan Silva     				º Data ³  18/04/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Producao Diaria X Horas Extras                      			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMRHR05()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR05"

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

	oReport := TReport():New(cPerg,"Producao Diaria X Horas Extras",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Producao Diaria X Horas Extras",{"SC2"},aOrdem) 

    TRCell():New(oSection,"SETOR"   	    ,"SB1","SETOR","@!",15)
	TRCell():New(oSection,"TOTAL"		    ,"B1","TOTAL","@E 999,999,999,999",10)
	TRCell():New(oSection,"PERIODO"		    ,"SB1","PERIODO","@!",20)
    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)
	//TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    //TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	//TRCell():New(oSection,"C6_DESCRI"  	     ,"SC6","C6_DESCRI","@!",40)
	//TRCell():New(oSection,"C6_QTDVEN"		 ,"SC6","C6_QTDVEN","@E 999,999,999,999",10)
	//TRCell():New(oSection,"C6_LOCAL"         ,"SC6","C6_LOCAL","@!",3)
	//TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	//TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
	//TRCell():New(oSection,"A1_MUN"  			,"SA1","A1_MUN","@!",15)
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


SELECT B1_XSETOR SETOR,TOTAL,PERIODO
FROM(
SELECT B1_XSETOR,CAST(SUM(CLA_QUANT) AS FLOAT)TOTAL,'DEPOIS AS 16:48' PERIODO
FROM CLA (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON CLA_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112) BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND B1_XSETOR LIKE 'COLCHAO%'
AND CLA_HORINC >= '16:48'
GROUP BY B1_XSETOR

UNION

SELECT B1_XSETOR,SUM(CLB_QUANT)TOTAL,'DEPOIS AS 16:48' PERIODO
FROM CLB (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(CLB_DATINC AS DATE),112) BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND B1_XSETOR LIKE 'CAMA%'
AND CLB_HORINC >= '16:48'
GROUP BY B1_XSETOR

UNION
SELECT B1_XSETOR,SUM(CLA_QUANT)TOTAL,'ATÉ AS 16:48' PERIODO
FROM CLA (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON CLA_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112) BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND B1_XSETOR LIKE 'COLCHAO%'
AND CLA_HORINC < '16:48'
GROUP BY B1_XSETOR

UNION

SELECT B1_XSETOR,SUM(CLB_QUANT)TOTAL,'ATÉ AS 16:48' PERIODO
FROM CLB (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(CLB_DATINC AS DATE),112) BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND B1_XSETOR LIKE 'CAMA%'
AND CLB_HORINC < '16:48'
GROUP BY B1_XSETOR
)TB

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
