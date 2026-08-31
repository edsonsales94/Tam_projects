#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR20    บAutor  ณStan Lee Lopes     				บ Data ณ  11/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Produtos polishop analitico							   					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR19()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR19"

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

	oReport := TReport():New(cPerg,"Produtos polishop analitico",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Produtos polishop analitico",{"SC2"},aOrdem)  


	TRCell():New(oSection,"C2_NUM"		    ,"SC2","OP",/*Mascara*/,/*Tamanho*/)             
	TRCell():New(oSection,"C2_PRODUTO" 		,"SC2","Produto",,/*Tamanho*/) 
	TRCell():New(oSection,"B1_DESC"    		,"SB1","B1_DESC",/*Mascara*/,)
	TRCell():New(oSection,"QTDOP"    		,"SC2","Quantidade","@E 999,999,999",)
	TRCell():New(oSection,"APONTADA"    	,"SC2","Apontada","@E 999,999,999",)
	TRCell():New(oSection,"AAPONTAR"    	,"SC2","Pendente de Apontamento","@E 999,999,999",)


	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("QTDOP"),"Apontamento Total","SUM",,,"@E 999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("APONTADA"),"Entrada Total","SUM",,,"@E 999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("AAPONTAR"),"Salto Total","SUM",,,"@E 999,999,999",,.F.,.T.)
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




		SELECT C2_NUM,C2_PRODUTO,B1_DESC,SUM(C2_QUANT)QTDOP,SUM(C2_QUJE)APONTADA,SUM(C2_QUANT)-SUM(C2_QUJE) AAPONTAR
		FROM %Table:SC2% SC2 (NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE SC2.D_E_L_E_T_ = ''
		AND C2_PRODUTO IN(	SELECT C2_PRODUTO
		FROM %Table:SZ1% SZ1 (NOLOCK)
		INNER JOIN %Table:SC2% SC2 (NOLOCK) ON SUBSTRING(Z1_OP,1,6) = C2_NUM AND SC2.D_E_L_E_T_ = ''
		WHERE SC2.D_E_L_E_T_ = '' 
		AND C2_PRODUTO IN (SELECT C6_PRODUTO
		FROM %Table:SC6% SC6 (NOLOCK)
		WHERE D_E_L_E_T_ = ''
		AND C6_CLI = 'Q21559'
		AND C6_NUM = %Exp:MV_PAR01% 
		GROUP BY C6_PRODUTO)
		)
		AND C2_NUM NOT IN(	SELECT SUBSTRING(Z1_OP,1,6)
		FROM %Table:SZ1% SZ1 (NOLOCK)
		INNER JOIN %Table:SC2% SC2 (NOLOCK) ON SUBSTRING(Z1_OP,1,6) = C2_NUM AND SC2.D_E_L_E_T_ = ''
		WHERE SC2.D_E_L_E_T_ = '' 
		AND C2_PRODUTO IN (SELECT C6_PRODUTO 
		FROM %Table:SC6% SC6 (NOLOCK)
		WHERE D_E_L_E_T_ = ''
		AND C6_CLI = 'Q21559'
		AND C6_NUM = %Exp:MV_PAR01% 
		GROUP BY C6_PRODUTO)
		GROUP BY SUBSTRING(Z1_OP,1,6),C2_PRODUTO
		)
		GROUP BY C2_NUM,C2_PRODUTO,B1_DESC
		ORDER BY C2_PRODUTO


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Cliente",20)+"?","","","mv_ch1","c",6,0,0,"G","","","","","mv_par01") 

Return
