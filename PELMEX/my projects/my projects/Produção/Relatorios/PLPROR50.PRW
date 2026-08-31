

#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR50   บAutor  ณJuevan Silva     				บ Data ณ 27/08/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Producao de PA Novo                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR50()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR50"

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

	oReport := TReport():New(cPerg,"Rel. Producao de PA Novo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Producao de PA Novo",{"PED"},aOrdem) 

    TRCell():New(oSection,"TURNO"   	        ,"SC2","TURNO","@!",15)
    TRCell():New(oSection,"DT_EMISSAO"	        ,"SC2","DT_EMISSAO","@!",10)
    TRCell():New(oSection,"GRUPO"	        ,"SB1","GRUPO","@!",04)
	TRCell():New(oSection,"DESC_GRUPO"	        ,"SBM","DescGrupo","@!",30)
    TRCell():New(oSection,"PRODUTO"	        ,"SC2","PRODUTO","@!",15)
    TRCell():New(oSection,"DESCRICAO"	        ,"SC2","DESCRICAO","@!",04)
    TRCell():New(oSection,"UNIDADE"	        ,"SC2","UNIDADE","@!",02)
    TRCell():New(oSection,"TIPO"	        ,"SC2","TIPO","@!",02)
    TRCell():New(oSection,"QTD_PRODUZIDA"	        ,"SC2","TD_PRODUZIDA","@E 999,999,999.999",)
   
	

    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)

	
    
	
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


SELECT 'COMERCIAL' TURNO,CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_EMISSAO,B1_GRUPO GRUPO, BM_DESC DESC_GRUPO,C2_PRODUTO PRODUTO,B1_DESC DESCRICAO,
B1_UM UNIDADE,B1_TIPO TIPO,SUM(C2_QUJE)QTD_PRODUZIDA
FROM(
SELECT C2_EMISSAO,C2_NUM+C2_ITEM C2_NUM,B1_GRUPO, BM_DESC, C2_PRODUTO,B1_DESC,B1_UM,B1_TIPO,C2_QUANT,C2_QUJE,C2_OBS
FROM SC2100 SC2 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SC2.D_E_L_E_T_ = ''
INNER JOIN SBM100 SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ''
WHERE SC2.D_E_L_E_T_ = ''
AND B1_TIPO IN ('PA','PC')
AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
GROUP BY C2_EMISSAO,B1_GRUPO, BM_DESC,C2_PRODUTO,B1_DESC,B1_UM,B1_TIPO
ORDER BY 1,2,B1_DESC


 EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Emissao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Cod:" ,20)+"?","","","mv_ch3","C",20,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Cod:",20)+"?","","","mv_ch4","C",20,0,0,"G","","","","","mv_par04")
