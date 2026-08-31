
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR53   บAutor  ณJuevan Silva     				บ Data ณ  08/02/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Faturamento Maiores Clientes									 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR53()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR53"

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

	oReport := TReport():New(cPerg," Faturamento Maiores Clientes ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"  Faturamento Maiores Clientes ",{"SD2"},aOrdem) 

    TRCell():New(oSection,"A1_NREDUZ"    		,"SA1","CLIENTE","@!",20)
    TRCell():New(oSection,"TOTAL"  		,"SD2","TOTAL","@E 999,999,999,999",)
    TRCell():New(oSection,"MEDIA" 		,"SD2","MEDIA","@E 999,999,999,999",)
    TRCell():New(oSection,"PROJECAO"   		,"SD2","PROJECAO","@E 999,999,999,999",)
    //TRCell():New(oSection,"D2_PRCVEN"   	,"SD2","VL. UNIT","@E 999,999,999.99",)
    //TRCell():New(oSection,"D2_TOTAL"    	,"SD2","VAL. MERCAD.","@E 999,999,999.99",)
    //TRCell():New(oSection,"D2_TES"    		,"SD2","TES","@!",5)
 	//TRCell():New(oSection,"F4_TEXTO"   		,"SF4","TES DESCRI","@!",30)
    //TRCell():New(oSection,"SAI_QUANT"    	,"SAI","QUANTIDADE","@E 999,999,999,999",10)
    //TRCell():New(oSection,"SAI_DTEXP"    	,"SAI","DT EXPEDICAO","@!",40)
    //TRCell():New(oSection,"SAI_CLIENTE"   ,"SAI","CLIENTE","@!",40)
    //TRCell():New(oSection,"SAI_NOME"    	,"SAI","NOME","@!",40)
    

	//Totalizador
	                                                                                
	//TRFunction():New(oSection:Cell("TOTAL"),"TOTAL TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.F.)
	//TRFunction():New(oSection:Cell("D2_PRCVEN"),"TOTAL PREวOVEND","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("TOTAL"),"TOTAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	
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

SELECT A1_NREDUZ,SUM(D2_TOTAL)TOTAL,SUM(D2_TOTAL)/12 MEDIA,SUM(D2_TOTAL)+SUM(D2_TOTAL)*30/100 PROJECAO
FROM(
SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_TOTAL,D2_LOCAL,D2_TES,A1_COD,A1_NOME,A1_NREDUZ,A1_MUN
FROM SD2100 SD2 (NOLOCK)
INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL != '1'
INNER JOIN SF4100 SF4 (NOLOCK) ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
WHERE SD2.D_E_L_E_T_ = ''
AND D2_FILIAL = '01'
AND D1_DOC IS NULL
AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND F4_DUPLIC = 'S'
AND (A1_NREDUZ LIKE 'ORTOCONFORT%'
OR A1_NOME LIKE 'BENCHI%'
OR A1_NREDUZ LIKE '%TV%LAR%'
OR A1_NOME LIKE '%V P %'
OR A1_NOME LIKE 'LIDER%')
)TB
GROUP BY A1_NREDUZ
ORDER BY 2 DESC
EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Emissao  ",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Emissao ",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02") 

Return
