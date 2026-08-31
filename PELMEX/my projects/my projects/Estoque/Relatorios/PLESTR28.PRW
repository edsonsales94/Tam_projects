#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR26    บAutor  ณJuevan Silva    				บ Data ณ  25/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ REL. de Valor Expedido						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR28()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR28"

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

	oReport := TReport():New(cPerg,"REL. de Valor Expedido",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"REL. de Valor Expedido",{"SD1"},aOrdem)  

	TRCell():New(oSection,"EMPRESA"				,"SD2","EMPRESA","@!",9)           
	TRCell():New(oSection,"PERIODO" 	   		,"SD2","PERIODO","@!",10) 
	TRCell():New(oSection,"TOTAL"    	     ,"SD2","TOTAL","@E 999,999,999.99",)
	//TRCell():New(oSection,"D1_DOC"  			,"SD1","DATA","@!",10)
    //TRCell():New(oSection,"D1_TES"    	        ,"SD","TES","@!",4) 
    //TRCell():New(oSection,"D1_FORNECE"    	    ,"SD1","CODIG. FORNEC","@!",8) 
    //TRCell():New(oSection,"A2_NOME"    	        ,"SA1","UM","@!",30) 
	//TRCell():New(oSection,"D1_COD"    	        ,"SD1","PRODUTO","@!",15) 	  
    //TRCell():New(oSection,"D1_X_DESCR"    	    ,"SD1","DESCRI PRODU","@!",30) 
    //TRCell():New(oSection,"D1_TP"    	        ,"SD1","TIPO","@!",3) 
    //TRCell():New(oSection,"D1_QUANT"    	    ,"SD1","QTD","@E 999,999,999,999",)
    //TRCell():New(oSection,"D1_VUNIT"    	    ,"SD1","VLR UNIT","@E 999,999,999.99",)
    //TRCell():New(oSection,"D1_TOTAL"    	    ,"SD1","VLR TOTAL","@E 999,999,999.99",)
    

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

SELECT 'PELMEX' EMPRESA,SUBSTRING(CNF_EXPEDICAO,4,7)PERIODO,SUM(D2_TOTAL)TOTAL
FROM(
SELECT CNF_EXPEDICAO,D2_FILIAL,D2_EMISSAO,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_TOTAL,D2_CLIENTE
FROM CNF (NOLOCK)
INNER JOIN SD2100 SD2 (NOLOCK) ON CNF_FILIAL = D2_FILIAL AND CNF_DOC = D2_DOC AND CNF_SERIE = D2_SERIE AND CNF_CLIENTE = D2_CLIENTE AND CNF_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ''
WHERE SUBSTRING(CNF_EXPEDICAO,7,4)+SUBSTRING(CNF_EXPEDICAO,4,2)+SUBSTRING(CNF_EXPEDICAO,1,2) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
GROUP BY SUBSTRING(CNF_EXPEDICAO,4,7)
UNION
SELECT 'AMAZON' EMPRESA,SUBSTRING(CNF_EXPEDICAO,4,7)PERIODO,SUM(D2_TOTAL)TOTAL
FROM(
SELECT CNF_EXPEDICAO,D2_FILIAL,D2_EMISSAO,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_TOTAL,D2_CLIENTE
FROM CNF (NOLOCK)
INNER JOIN SD2200 SD2 (NOLOCK) ON CNF_FILIAL = D2_FILIAL AND CNF_DOC = D2_DOC AND CNF_SERIE = D2_SERIE AND CNF_CLIENTE = D2_CLIENTE AND CNF_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ''
WHERE SUBSTRING(CNF_EXPEDICAO,7,4)+SUBSTRING(CNF_EXPEDICAO,4,2)+SUBSTRING(CNF_EXPEDICAO,1,2) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
GROUP BY SUBSTRING(CNF_EXPEDICAO,4,7)
ORDER BY 1


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//_InPutSX1(cPerg,"03",PADR("De Dt Digit:" ,20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Dt Digit:",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")

Return
