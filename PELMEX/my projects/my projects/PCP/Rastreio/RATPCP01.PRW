#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR04    บAutor  ณStan Lee Lopes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO ANALISE DE MOVIMENTO VENDAS X ESTOQUE		        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RATPCP01()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "RATPCP01"

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

	oReport := TReport():New(cPerg,"RELATORIO USUARIO DE ALTERAวรO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"RELATORIOUSUARIO DE ALTERAวรO",{"SB2"},aOrdem)     




	TRCell():New(oSection,"G1_COD"				,"SB1","Codigo",/*Mascara*/,16) 
	TRCell():New(oSection,"PRODUTO"				,"SB1","Descri็ใo",/*Mascara*/,60)
	TRCell():New(oSection,"G1_COMP"		        ,"SB1","Componente",,16)
	TRCell():New(oSection,"COMPONENTE"	    	,"SB1","Descri็ใo",,60) 
	TRCell():New(oSection,"ALTERACAO"	   		,"SB1","Responsavel",/*Mascara*/,10) 
	TRCell():New(oSection,"TDATA"	    		,"SC6","Dt.Altera็ใo",/*Mascara*/,15)
	
TRFunction():New(oSection:Cell("COMPONENTE"),"TOTAL","COUNT",,,"@E 9,999,999,999",,.F.,.T.)

	//Totalizador
	/*                                                                                  

	

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		
		SELECT G1_COD,PRODUTO,G1_COMP,COMPONENTE,
CASE WHEN ALTERACAO = '000277' THEN 'MARCUS' 
	 WHEN ALTERACAO = '000388' THEN 'DALTON' 
	 WHEN ALTERACAO = '000390' THEN 'SEGUNDO' ELSE '' END ALTERACAO,
CONVERT(VARCHAR,CAST(TB.TDATA AS DATE),103)  TDATA
FROM (
	SELECT G1_COD,SB11.B1_DESC PRODUTO,G1_COMP,SB12.B1_DESC COMPONENTE
	,SUBSTRING(G1_USERLGA, 11,1)+SUBSTRING(G1_USERLGA, 15,1)+
	SUBSTRING(G1_USERLGA, 2, 1)+SUBSTRING(G1_USERLGA, 6, 1)+
	SUBSTRING(G1_USERLGA, 10,1)+SUBSTRING(G1_USERLGA, 14,1)+
	SUBSTRING(G1_USERLGA, 1, 1)+SUBSTRING(G1_USERLGA, 5, 1)+
	SUBSTRING(G1_USERLGA, 9, 1)+SUBSTRING(G1_USERLGA, 13,1)+
	SUBSTRING(G1_USERLGA, 17,1)+SUBSTRING(G1_USERLGA, 4, 1)+
	SUBSTRING(G1_USERLGA, 8, 1) ALTERACAO,
	CONVERT(VARCHAR,
	DATEADD(DAY,((ASCII(SUBSTRING(G1_USERLGA,12,1)) - 50) * 100 + (ASCII(SUBSTRING(G1_USERLGA,16,1)) - 50)),'19960101'),112) TDATA
	 FROM %Table:SG1% SG1
	 INNER JOIN %Table:SB1% SB11 ON SB11.B1_COD = G1_COD
	 INNER JOIN %Table:SB1% SB12 ON SB12.B1_COD = G1_COMP
	WHERE
	SG1.D_E_L_E_T_ = ''
)TB

WHERE TB.ALTERACAO IN ('000277','000388','000390')
AND TB.TDATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY TB.TDATA,TB.G1_COD,ALTERACAO,G1_COMP
		

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Dt.Altera็ใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Dt.Altera็ใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return