#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR03    ºAutor  ³Stan Lee Lopes     				º Data ³ 08/06/2020º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE MATERIAL VS PEDIDO       								 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR22()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR22"

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

	oReport := TReport():New(cPerg,"RELATÓRIO DE MATERIAL X PEDIDO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"MATERIAL X PEDIDO",{"SG1"},aOrdem) 


	TRCell():New(oSection,"G1_COMP"			,"SG1","Codigo",/*Mascara*/,20) 
	TRCell():New(oSection,"G1_DESC"			,"SG1","Descrição",/*Mascara*/,60)
	TRCell():New(oSection,"L01"	    		,"SB2","Armazém 01",/*Mascara*/,) 
	TRCell():New(oSection,"B2_QATU"		    ,"SB2","Armazém 10","@E 999,999,999.99999",20)
	TRCell():New(oSection,"APAGAR"          ,"SA1","A Pagar","@E 999,999,999.99999",20)
	TRCell():New(oSection,"USUARIO"         ,"SA1","Usuário",,20)        

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
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		SELECT G1_COMP,G1_DESC,L10 L01,B2_QATU,SUM(APAGAR) APAGAR,'[____________]' USUARIO
		FROM (
		SELECT C6_PRODUTO,B1_DESC,QTD_PED,QTD_OP,L20,SALDO,G1_COMP,G1_DESC,ISNULL(L10,0)L10,(SALDO * G1_QUANT)APAGAR
		FROM(
		SELECT C6_PRODUTO,TAB.B1_DESC,QTD_PED,QTD_OP,L20,(L20-(QTD_PED-QTD_OP))SALDO,SB21.B2_QATU L10,G1_COMP,SB11.B1_DESC G1_DESC,G1_QUANT
		FROM(
		SELECT C6_PRODUTO,B1_DESC,SUM(QTD_PED)QTD_PED,SUM(QTD_OP)QTD_OP,B2_QATU L20
		FROM(
		SELECT C6_FILIAL,C6_PRODUTO,B1_DESC,C6_LOCAL,SUM(QTD_PED)QTD_PED,SUM(QTD_OP)QTD_OP
		FROM(
		SELECT C6_FILIAL,C6_NUM,C6_PRODUTO,B1_DESC,C6_LOCAL,(C6_QTDVEN-C6_QTDENT)QTD_PED,0 QTD_OP
			FROM %Table:SC6% (NOLOCK) SC6
			INNER JOIN %Table:SB1% (NOLOCK) SB1 ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
			INNER JOIN %Table:SB2% (NOLOCK) SB220 ON C6_FILIAL = SB220.B2_FILIAL AND C6_PRODUTO = SB220.B2_COD AND C6_LOCAL = SB220.B2_LOCAL AND SB220.D_E_L_E_T_ = ''
		WHERE SC6.D_E_L_E_T_ = '' 
		AND C6_ENTREG BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C6_LOCAL = '20'
		AND C6_FILIAL = '01'
		AND C6_BLQ NOT IN  ('R','S')
		AND C6_QTDVEN > C6_QTDENT
		UNION
		SELECT C2_FILIAL,'' C6_NUM,C2_PRODUTO,B1_DESC,C2_LOCAL,0 QTD_PED,(C2_QUANT-C2_QUJE) QTD_OP
		FROM %Table:SC2% (NOLOCK) SC2
		INNER JOIN %Table:SB1% (NOLOCK) SB1 ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB2% (NOLOCK) SB220 ON C2_FILIAL = SB220.B2_FILIAL AND C2_PRODUTO = SB220.B2_COD AND C2_LOCAL = SB220.B2_LOCAL AND SB220.D_E_L_E_T_ = ''
		WHERE SC2.D_E_L_E_T_ = '' 
		AND C2_LOCAL = '20'
		AND C2_FILIAL = '01'
		AND C2_DATRF = ''
		)TB
		GROUP BY C6_FILIAL,C6_PRODUTO,B1_DESC,QTD_OP,C6_LOCAL
		)TB1
		INNER JOIN %Table:SB2% (NOLOCK) SB2 ON TB1.C6_FILIAL = B2_FILIAL AND TB1.C6_PRODUTO = B2_COD AND TB1.C6_LOCAL = B2_LOCAL AND SB2.D_E_L_E_T_ = ''
		GROUP BY TB1.C6_FILIAL,TB1.C6_PRODUTO,TB1.B1_DESC,TB1.C6_LOCAL,B2_QATU
		)TAB
		INNER JOIN %Table:SG1% (NOLOCK) SG1 ON TAB.C6_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
		LEFT JOIN %Table:SB2% (NOLOCK) SB21 ON G1_FILIAL = SB21.B2_FILIAL AND G1_COMP = SB21.B2_COD AND SB21.B2_LOCAL = '01' AND SB21.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% (NOLOCK) SB11 ON G1_COMP = SB11.B1_COD AND SB11.D_E_L_E_T_ = ''
		)TAB2
		WHERE G1_COMP NOT LIKE 'MOD%'
		GROUP BY C6_PRODUTO,B1_DESC,QTD_PED,QTD_OP,L20,SALDO,G1_COMP,G1_DESC,L10,SALDO,G1_QUANT
		HAVING SALDO < 0
		)TB3
		INNER JOIN SB2100 SB2 (NOLOCK) ON B2_COD = G1_COMP AND B2_FILIAL = '01' AND B2_LOCAL = '10' AND SB2.D_E_L_E_T_ =''
		GROUP BY G1_COMP,G1_DESC,L10,B2_QATU
		ORDER BY G1_COMP



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Entrega De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Entrega Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
Return