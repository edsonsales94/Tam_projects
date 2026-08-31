#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR54  บAutor  ณStan Lee    				บ Data ณ  29/10/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   INDICADORES DE HORAS TRABALHADAS AMAZON                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR10()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR10"

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

	oReport := TReport():New(cPerg,"INDICADORES DE HORAS TRABALHADAS AMAZON",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"INDICADORES DE HORAS TRABALHADAS AMAZON",{"SPL"},aOrdem) 

    TRCell():New(oSection,"PERIODO"   	    ,"SPL","Periodo","@!",20)
	TRCell():New(oSection,"DIAS_UTEIS"		,"SPL","Dias Trabalhados","@E 999,999,999",)
    TRCell():New(oSection,"TOTAL_HORAS"		,"SPL","Total de Horas Trabalhadas","@E 999,999,999.99",)
    //TRCell():New(oSection,"FUNCIONARIOS"		    ,"SPL","Qtd. Funcionarios","@!",20)
	//TRCell():New(oSection,"CTT_DESC01"		  ,"CTT","Centrousto","@!",20)		
    //TRCell():New(oSection,"R8_TIPOAFA"	      ,"SR8","R8_TIPOAFA","@!",4) 
	//TRCell():New(oSection,"DESCRICAO"  	     ,"SRA","DESCRICAO","@!",40)
	//TRCell():New(oSection,"R8_CID"		 ,"SR8","R8_CID","@!",3)
	//TRCell():New(oSection,"DIAS"  			,"SRA","DIAS","@!",3)
    //TRCell():New(oSection,"R8_OBSAFAS"  	,"SR8","R8_OBSAFAS","@!",100)
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
SELECT PERIODO,DIAS_UTEIS,SUM(HORAS) TOTAL_HORAS
FROM(
SELECT SUBSTRING(PL_DATA,4,7)PERIODO,PL_FILIAL,PL_MAT,220 HORAS_MES,SUM(PL_HORAS)HORAS,1 FUNCIONARIOS
FROM(
SELECT PL_FILIAL,PL_MAT,PL_PD,
       CONVERT(VARCHAR,CAST(PL_DATA AS DATE),103) PL_DATA,
	   PL_HORAS,PL_CC
FROM SPL
WHERE D_E_L_E_T_ = ''
AND PL_PD = '258'
AND PL_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
UNION
SELECT PL_FILIAL,PL_MAT,PL_PD,
       CONVERT(VARCHAR,CAST(PL_DATA AS DATE),103) PL_DATA,
	   PL_HORAS,PL_CC
FROM SPL200 SPL
WHERE SPL.D_E_L_E_T_ = ''
AND PL_PD = '258'
AND PL_DATA BETWEEN '20240101' AND %Exp:MV_PAR02% 
)TB
GROUP BY SUBSTRING(PL_DATA,4,7),PL_FILIAL,PL_MAT
)TB1
INNER JOIN (SELECT DIA_DATA,DIA_DIAS DIAS_UTEIS
            FROM DIA (NOLOCK)
			)DIA ON PERIODO = DIA_DATA
GROUP BY PERIODO,HORAS_MES,DIAS_UTEIS
ORDER BY SUBSTRING(PERIODO,4,4)+SUBSTRING(PERIODO,1,2)

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("Data de:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Data ate:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return
