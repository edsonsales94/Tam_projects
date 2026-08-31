#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR26    บAutor  ณWYLLIAM Silva    				บ Data ณ  04/02/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ REL. CONSUMO DE MATERIA PRIMA						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR27()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR27"

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

	oReport := TReport():New(cPerg,"REL. ENTRADA DE MATERIAL",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"REL. ENTRADA DE MATERIAL",{"SD1"},aOrdem)  

	TRCell():New(oSection,"EMPRESA"				,"SD1","EMPRESA","@!",6)           
	TRCell():New(oSection,"EMISSAO" 	   		,"SD1","DTEMISSAO","@!",8) 
	TRCell():New(oSection,"DTDIGITA" 	   	    ,"SD1","DTDIGITA","@!",8)
	TRCell():New(oSection,"D1_DOC"  			,"SD1","DATA","@!",10)
    TRCell():New(oSection,"D1_TES"    	        ,"SD","TES","@!",4) 
    TRCell():New(oSection,"D1_FORNECE"    	    ,"SD1","CODIG. FORNEC","@!",8) 
    TRCell():New(oSection,"A2_NOME"    	        ,"SA1","UM","@!",30) 
	TRCell():New(oSection,"D1_COD"    	        ,"SD1","PRODUTO","@!",15) 	  
    TRCell():New(oSection,"D1_X_DESCR"    	    ,"SD1","DESCRI PRODU","@!",30) 
    TRCell():New(oSection,"D1_TP"    	        ,"SD1","TIPO","@!",3) 
    TRCell():New(oSection,"D1_QUANT"    	    ,"SD1","QTD","@E 999,999,999,999",)
    TRCell():New(oSection,"D1_VUNIT"    	    ,"SD1","VLR UNIT","@E 999,999,999.99",)
    TRCell():New(oSection,"D1_TOTAL"    	    ,"SD1","VLR TOTAL","@E 999,999,999.99",)
    TRCell():New(oSection,"D1_CUSTO"    	        ,"SD1","VLR CUSTO","@E 999,999,999.99",)

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.) 

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

	SELECT 'PELMEX' EMPRESA,CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103) EMISSAO,CONVERT(VARCHAR,CAST(D1_DTDIGIT AS DATE),103) DTDIGITA,D1_DOC,D1_TES,D1_FORNECE,A2_NOME,D1_COD,D1_X_DESCR,
        D1_TP,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_CUSTO
    FROM SD1100 SD1
    LEFT JOIN SA2100 SA1 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND SA1.D_E_L_E_T_ =''
    WHERE SD1.D_E_L_E_T_ =''
    AND D1_CF IN ('1101','2352','2101','3101')
    AND D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    AND D1_DTDIGIT BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
    UNION
    SELECT 'AMAZON' EMPRESA,CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103) EMISSAO,CONVERT(VARCHAR,CAST(D1_DTDIGIT AS DATE),103) DTDIGITA,D1_DOC,D1_TES,D1_FORNECE,A2_NOME,D1_COD,D1_X_DESCR,
        D1_TP,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_CUSTO
    FROM SD1200 SD1
    LEFT JOIN SA2200 SA1 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND SA1.D_E_L_E_T_ =''
    WHERE SD1.D_E_L_E_T_ =''
    AND D1_CF IN ('1101','2352','2101','3101')
    AND D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    AND D1_DTDIGIT BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
    ORDER BY EMISSAO


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Dt Digit:" ,20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Dt Digit:",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")

Return
