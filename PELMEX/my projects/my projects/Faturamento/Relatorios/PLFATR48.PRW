#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR48    บAutor  ณJuevan Silva     				บ Data ณ  26/10/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Nota x Entrega Simplificado											 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR48()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR48"

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

	oReport := TReport():New(cPerg,"Nota x Entrega Simplificado	",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Nota x Entrega Simplificado",{"SC6"},aOrdem) 

    TRCell():New(oSection,"DT_NOTA"    	,"SD2","DATA NOTA","@!",8)
    TRCell():New(oSection,"NOTA"  	,"SD2","NOTA","@!",10)
    TRCell():New(oSection,"SERIE"   	,"SD2","SERIE","@!",4)
    TRCell():New(oSection,"CLIENTE"   	,"SD2","EMPRESA","@!",40)
    TRCell():New(oSection,"NOME"    	,"SA1","NOME","@!",30)
    TRCell():New(oSection,"DT_BIPE"    	,"SA1","DATA BIPAGEM","@!",10)
    TRCell():New(oSection,"DT_SAIDA"    	,"SAI","DATA SAIDA","@!",10)
    TRCell():New(oSection,"CIDADE"    	,"SA1","CIDADE","@!",40)
    

	//Totalizador
	/*                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

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
SELECT CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103)DT_NOTA,D2_DOC NOTA,D2_SERIE SERIE,D2_CLIENTE CLIENTE,A1_NOME NOME,MAX(SAI_DTEXP) DT_BIPE,CNF_EXPEDICAO DT_SAIDA,A1_MUN CIDADE
FROM SD2100 SD2 (NOLOCK)
INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SAI (NOLOCK) ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND D2_ITEM = SAI_ITEM AND D2_COD = SAI_PRODUTO
LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE
WHERE SD2.D_E_L_E_T_ = ''
AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND D2_CLIENTE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
GROUP BY D2_EMISSAO,D2_DOC,D2_SERIE,CNF_EXPEDICAO,D2_CLIENTE,A1_NOME,A1_MUN
ORDER BY A1_MUN,D2_DOC,D2_SERIE

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)
	u_InPutSX1(cPerg,"01",PADR("De Emissao NF   ",20)+"?","","","mv_ch1","D",6,0,0,"G","","","","","mv_par01")  
	u_InPutSX1(cPerg,"02",PADR("Ate Emisao NF  ",20)+"?","","","mv_ch2","D",6,0,0,"G","","","","","mv_par02")
   u_InPutSX1(cPerg,"03",PADR("De Cliente    ",20)+"?","","","mv_ch3","C",10,0,0,"G","","","SA1","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Ate Cliente   ",20)+"?","","","mv_ch4","C",10,0,0,"G","","","SA1","","mv_par04")

Return
