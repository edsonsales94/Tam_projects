#Include "PROTHEUS.CH"
#Include "TopConn.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMRHR07  บAutor  ณStan Lee Lopes     				    บ Data ณ  26/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Conferencia DIRF Mensal                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR07()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR07"

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

	oReport := TReport():New(cPerg,"Conferencia DIRF Mensal",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Conferencia DIRF Mensal",{"SRC"},aOrdem) 
    
    TRCell():New(oSection,"RC_FILIAL"   	    ,"SRC","Filial","@!",10)
	TRCell():New(oSection,"RC_MAT"		        ,"SRC","Matricula","@!",10)
	TRCell():New(oSection,"RA_NOME"		        ,"SRA","Nome","@!",70)
    TRCell():New(oSection,"RC_PD"		        ,"SRC","Verba","@!",10)
	TRCell():New(oSection,"RV_DESC"		        ,"SRV","Descricao","@!",40)
    TRCell():New(oSection,"RC_VALOR"	        ,"SRC","Valor","@E 999,999,999.99",) 
	TRCell():New(oSection,"RC_PERIODO"  	    ,"SRC","Periodo","@!",10)
	TRCell():New(oSection,"RC_DATA"		        ,"SRC","Data","@!",10)
	
	
    
	
	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("RC_VALOR"),"Total:","SUM",,,"@E 999,999,999.99",,.F.,.T.)

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


SELECT RC_FILIAL,RC_MAT,RA_NOME,RC_PD,RV_DESC,RC_VALOR,RC_PERIODO,RC_DATA
FROM SRC100 SRC (NOLOCK)
INNER JOIN SRA100 SRA (NOLOCK) ON RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
LEFT JOIN SRV100 SRV (NOLOCK) ON RC_PD = RV_COD AND SRV.D_E_L_E_T_ = ''
WHERE SRC.D_E_L_E_T_ = ''
AND RC_PD IN ('403','405','427','470','495')
AND RC_DATA  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
UNION
SELECT RD_FILIAL,RD_MAT,RA_NOME,RD_PD,RV_DESC,RD_VALOR,RD_PERIODO,RD_DATPGT
FROM SRD100 SRC (NOLOCK)
INNER JOIN SRA100 SRA (NOLOCK) ON RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
LEFT JOIN SRR100 SRR (NOLOCK) ON RD_FILIAL = RR_FILIAL AND RD_MAT = RR_MAT AND RD_PD = RR_PD AND RD_PERIODO = RR_PERIODO AND SRR.D_E_L_E_T_ = ''
LEFT JOIN SRV100 SRV (NOLOCK) ON RD_PD = RV_COD AND SRV.D_E_L_E_T_ = ''
WHERE SRC.D_E_L_E_T_ = ''
AND RD_PD IN ('403','405','427','470','495')
AND RD_DATPGT  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
UNION
SELECT RR_FILIAL,RA_MAT,RA_NOME,RR_PD,RV_DESC,RR_VALOR,RR_PERIODO,RR_DATAPAG
FROM SRR100 SRR
INNER JOIN SRA100 SRA ON RR_FILIAL = RA_FILIAL AND RR_MAT = RA_MAT AND SRA.D_E_L_E_T_ = ''
LEFT JOIN SRC100 SRC (NOLOCK) ON RC_FILIAL = RR_FILIAL AND RC_MAT = RR_MAT AND RC_PD = RR_PD AND CAST(RC_PERIODO AS INT) = CAST(RR_PERIODO AS INT) AND SRR.D_E_L_E_T_ = ''
LEFT JOIN SRV100 SRV (NOLOCK) ON RR_PD = RV_COD AND SRV.D_E_L_E_T_ = ''
WHERE SRR.D_E_L_E_T_ = ''
AND RR_PD IN ('403','405','427','470','495')
AND RR_DATAPAG BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND RC_PERIODO IS NULL
ORDER BY 1,2,4

EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
Return
