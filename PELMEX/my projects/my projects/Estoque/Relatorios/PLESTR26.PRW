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


User Function PLESTR26()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR26"

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

	oReport := TReport():New(cPerg,"REL. CONSUMO DE MATERIA PRIMA",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"REL. CONSUMO DE MATERIA PRIMA",{"SD3"},aOrdem)  

	TRCell():New(oSection,"EMPRESA"				,"SD3","EMISSAO","@!",6)           
	TRCell():New(oSection,"B1_GRUPO" 	   		,"SB1","GRUPO","@!",8) 
	TRCell():New(oSection,"MES" 	   		    ,"SD3","MES","@!",8)
	TRCell():New(oSection,"DTEMISSAO"  			,"SD3","DATA","@!",10)
    TRCell():New(oSection,"PRODUTO"    	        ,"SD3","PRODUTO","@!",15) 
    TRCell():New(oSection,"B1_DESC"    	        ,"SB1","DESCRI PRODU","@!",30) 
    TRCell():New(oSection,"D3_UM"    	        ,"SD3","UM","@!",3) 
	TRCell():New(oSection,"QTD"    	         	,"SD3","QTD","@E 999,999,999.99",)  

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

	 SELECT TB.EMPRESA EMPRESA,TB.B1_GRUPO,TB.MES,CONVERT(VARCHAR,CAST(TB.D3_EMISSAO AS DATE),103)DTEMISSAO,TB.D3_COD PRODUTO,TB.B1_DESC,TB.D3_UM,TB.QTD QTD
        FROM(
            SELECT 'PELMEX'EMPRESA,SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,3,2) MES,D3_EMISSAO,B1_GRUPO,D3_COD,B1_DESC,D3_UM,SUM(D3_QUANT) QTD
            FROM SD3100 SD3
            INNER JOIN SB1100 SB1 ON B1_COD = D3_COD AND SB1.D_E_L_E_T_ =''
            WHERE SD3.D_E_L_E_T_ = ''
            AND D3_COD NOT LIKE 'MOD%'
            AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND D3_CF = 'RE2'
            GROUP BY D3_COD,B1_DESC,D3_UM,D3_EMISSAO,B1_GRUPO
            UNION
            SELECT 'AMAZON'EMPRESA,SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,3,2) MES,D3_EMISSAO,B1_GRUPO,D3_COD,B1_DESC,D3_UM,SUM(D3_QUANT) QTD
            FROM SD3200 SD3
            INNER JOIN SB1200 SB1 ON B1_COD = D3_COD AND SB1.D_E_L_E_T_ =''
            WHERE SD3.D_E_L_E_T_ = ''
            AND D3_COD NOT LIKE 'MOD%'
            AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND D3_CF = 'RE2'
            GROUP BY D3_COD,B1_DESC,D3_UM,D3_EMISSAO,B1_GRUPO)TB

   //WHERE TB.D3_COD ='0700000'

ORDER BY 1,3

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	
Return
