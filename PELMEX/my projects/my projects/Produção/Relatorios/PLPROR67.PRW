#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR67  บAutor  ณKledson Oliveira    				บ Data ณ  24/06/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Consumo de Estrutura por Previa                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR67()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR67"

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

	oReport := TReport():New(cPerg,"Consumo de Estrutura por Previa",cPerg,{|oReport| PrintReport(oReport,cAlias)}, "Este relat๓rio mostra o consumo da estrutura por pr้via." )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Consumo de Estrutura por Previa",{"SRA"},aOrdem) 

	TRCell():New(oSection,"PED_DTPREVIA",		"PED","Dt. Previa","@!",10)
    TRCell():New(oSection,"TOTAL",				"PED","Total","@E 999,999,999.999",20)
	//TRCell():New(oSection,"B1_XSETOR",		"SRA","Setor Produtivo","@!",15)
	//TRCell():New(oSection,"RA_CC",			"SRA","Centro de Custo","@!",6)
    //TRCell():New(oSection,"CTT_DESC01",		"SRA","Descri็ใo C.Custo","@!",30)
	//TRCell():New(oSection,"Nome",		"SRA","Nome","@!",30)
	//TRCell():New(oSection,"QTD",		"SRA","Quantidade Produzida","@E 999,999,999.999")

	//TRCell():New(oSection,"RA_SALARIO",		"SRA","Salario","@E 999,999,999",)

//Data,'COLCHรO' SETOR,B1_XSETOR,RA_CC ,CTT_DESC01 ,RA_NOME Nome,SUM(CLA_QUANT)
	
	
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


SELECT PED_DTPREVIA,SUM(TOTAL)TOTAL
FROM(
SELECT PED_DTPROPEL,PED_DTPREVIA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO, CAST(PED_QUANT AS FLOAT)PED_QUANT,
       G1_COMP,B1_DESC,B1_UM,G1_QUANT,
     G1_PERDA,CAST(PED_QUANT AS FLOAT)*(G1_QUANT+(G1_QUANT*G1_PERDA/100)) TOTAL
FROM PED
INNER JOIN SG1100 SG1 ON PED_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 ON G1_COMP = B1_COD
WHERE PED_STATUS != 'C'
AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND B1_DESC LIKE '%01060100%'
)TB
GROUP BY PED_DTPREVIA
ORDER BY CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112)


EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De Dt Previa:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Previa:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Filial   ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par03")
	//u_InPutSX1(cPerg,"04",PADR("Ate Filial   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return

