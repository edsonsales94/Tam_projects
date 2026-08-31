#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR65  บAutor  ณKledson Oliveira    				บ Data ณ  06/06/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Producao e Pontuacao                    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR65()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR65"

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

	oReport := TReport():New(cPerg,"Producao e Pontuacao",cPerg,{|oReport| PrintReport(oReport,cAlias)}, "Este relat๓rio mostra a pontua็ใo dos funcionแrios da produ็ใo de acordo com a data definida pelo usuario nos parโmetros" )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Producao e Pontuacao",{"SRA"},aOrdem) 

	TRCell():New(oSection,"Data",		"SRA","DtProducao","@!",10)
    TRCell():New(oSection,"SETOR",		"SRA","Setor","@!",8)
	TRCell():New(oSection,"B1_XSETOR",		"SRA","Setor Produtivo","@!",15)
	TRCell():New(oSection,"RA_CC",			"SRA","Centro de Custo","@!",6)
    TRCell():New(oSection,"CTT_DESC01",		"SRA","Descri็ใo C.Custo","@!",30)
	TRCell():New(oSection,"Nome",		"SRA","Nome","@!",30)
	TRCell():New(oSection,"QTD",		"SRA","Quantidade Produzida","@E 999,999,999.999")

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


SELECT *
FROM(
SELECT Data,'COLCHรO' SETOR,B1_XSETOR,RA_CC ,CTT_DESC01 ,RA_NOME Nome,SUM(CLA_QUANT)QTD
FROM(
SELECT CLA_DATINC Data,RA_CC,CTT_DESC01,RA_NOME,CLA_CPRODUC,CLA_COD,CAST(CLA_QUANT AS FLOAT)CLA_QUANT,B1_XSETOR
FROM CLA (NOLOCK)
INNER JOIN SRA100 SRA (NOLOCK) ON CLA_FILIAL = RA_FILIAL AND CLA_USERINC = RA_MAT AND SRA.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON CLA_COD = B1_COD AND SB1.D_E_L_E_T_= ''
INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
)TB
GROUP BY Data,RA_CC,CTT_DESC01,RA_NOME,B1_XSETOR
UNION
SELECT Data,'CAMA' SETOR, B1_XSETOR, RA_CC ,CTT_DESC01 ,RA_NOME Nome,SUM(CLB_QUANT)
FROM(
SELECT CLB_DATINC Data,RA_CC,CTT_DESC01,RA_NOME,CLB_CPRODUC,CLB_COD, CASE WHEN B1_XJUNCAO = 'S' THEN 2 ELSE 1 END CLB_QUANT,B1_XSETOR
FROM CLB (NOLOCK)
INNER JOIN SRA100 SRA (NOLOCK) ON CLB_FILIAL = RA_FILIAL AND CLB_USERINC = RA_MAT AND SRA.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_= ''
INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(CLB_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
)TB
GROUP BY Data,RA_CC,CTT_DESC01,RA_NOME,B1_XSETOR
UNION
SELECT Data,'COLAGEM' SETOR,B1_XSETOR,RA_CC ,CTT_DESC01 ,RA_NOME Nome,SUM(CLC_QUANT)
FROM(
SELECT CLC_DATINC Data,RA_CC,CTT_DESC01,RA_NOME,CLC_CPRODUC,CLC_COD,CAST(CLC_QUANT AS FLOAT)CLC_QUANT,B1_XSETOR
FROM CLC (NOLOCK)
INNER JOIN SRA100 SRA (NOLOCK) ON CLC_FILIAL = RA_FILIAL AND CLC_USERINC = RA_MAT AND SRA.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON CLC_COD = B1_COD AND SB1.D_E_L_E_T_= ''
INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(CLC_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
)TB
GROUP BY Data,RA_CC,CTT_DESC01,RA_NOME,B1_XSETOR
UNION
SELECT Data,'FAIXA' SETOR,B1_XSETOR,RA_CC ,CTT_DESC01 ,RA_NOME Nome,SUM(CLE_QUANT)
FROM(
SELECT CLE_DATINC Data,RA_CC,CTT_DESC01,RA_NOME,CLE_CPRODUC,CLE_COD,CAST(CLE_QUANT AS FLOAT)CLE_QUANT,B1_XSETOR
FROM CLE (NOLOCK)
INNER JOIN SRA100 SRA (NOLOCK) ON CLE_FILIAL = RA_FILIAL AND CLE_USERINC = RA_MAT AND SRA.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON CLE_COD = B1_COD AND SB1.D_E_L_E_T_= ''
INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
WHERE CONVERT(VARCHAR,CAST(CLE_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
)TB
GROUP BY Data,RA_CC,CTT_DESC01,RA_NOME,B1_XSETOR
)TB1
ORDER BY CONVERT(VARCHAR,CAST(Data AS DATE),112),2,4,6 DESC


EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De Dt Producao:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Producao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Filial   ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par03")
	//u_InPutSX1(cPerg,"04",PADR("Ate Filial   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return

