#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR20    บAutor  ณStan Lee Lopes     				บ Data ณ  11/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Produtos polishop  sintetico 						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR20()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR20"

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

	oReport := TReport():New(cPerg,"Produtos polishop Sintetico",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Produtos polishop Sintetico",{"SD2"},aOrdem)  


	TRCell():New(oSection,"PRODUTO"		    ,"SC6","Produto",,60)             
	TRCell():New(oSection,"PRODUZIDO" 		,"SC6","Produzido","@E 999,999,999",/*Tamanho*/) 
	TRCell():New(oSection,"SAIDA"    		,"SC6","Saida","@E 999,999,999",)
	TRCell():New(oSection,"DIFERENCA"    	,"SC6","Diferen็a","@E 999,999,999",)

	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("PRODUZIDO"),"Total Produzido","SUM",,,"@E 999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("SAIDA"),"Total Saida","SUM",,,"@E 999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("DIFERENCA"),"Diferen็a Total","SUM",,,"@E 999,999,999",,.F.,.T.)
	//TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)


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






		SELECT PRODUTO,SUM(PRODUZIDO)PRODUZIDO,SUM(SAIDA)SAIDA,SUM(PRODUZIDO)-SUM(SAIDA)DIFERENCA
		FROM(

		SELECT SAI_PRODUTO PRODUTO,0 PEDIDO,0 PRODUZIDO,SUM(SAI_QUANT)SAIDA
		FROM SAI (NOLOCK)
		WHERE SAI_PRODUTO IN (SELECT C6_PRODUTO
		FROM %Table:SC6% (NOLOCK)
		WHERE D_E_L_E_T_ = ''
		AND C6_CLI = 'Q21559'
		AND C6_NUM = %Exp:MV_PAR01% 
		GROUP BY C6_PRODUTO)
		GROUP BY SAI_PRODUTO
		UNION
		SELECT C2_PRODUTO,0 PEDIDO,SUM(C2_QUANT)PRODUZIDO,0 SAIDA
		FROM(
		SELECT C2_NUM,C2_PRODUTO,C2_QUANT
		FROM %Table:SC2% SC2 (NOLOCK)
		WHERE D_E_L_E_T_ = ''
		AND C2_PRODUTO IN (SELECT C6_PRODUTO
		FROM %Table:SC6% (NOLOCK)
		WHERE D_E_L_E_T_ = ''
		AND C6_CLI = 'Q21559'
		AND C6_NUM = %Exp:MV_PAR01% 
		GROUP BY C6_PRODUTO)
		GROUP BY C2_NUM,C2_PRODUTO,C2_QUANT)TB
		GROUP BY C2_PRODUTO
		)TB
		GROUP BY PRODUTO
		ORDER BY PRODUZIDO DESC

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Pedido",20)+"?","","","mv_ch1","c",6,0,0,"G","","","","","mv_par01") 

Return
