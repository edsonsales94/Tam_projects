#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR03    ºAutor  ³Stan Lee Lopes     				º Data ³  22/02/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE EMPENHO VS SALDO ATUAL        								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR03()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR03"

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

	oReport := TReport():New(cPerg,"RELATÓRIO DE EMPENHO VS SALDO ATUAL",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"EMPENHO VS SALDO ATUAL",{"SD4"},aOrdem) 



	TRCell():New(oSection,"D4_COD"			,"SD4","Codigo",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"B1_DESC"			,"SB1","Descrição",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"B1_TIPO"		,"SB1","Tipo",,/*Tamanho*/)
	//TRCell():New(oSection,"B1_GRUPO"	    ,"SB1","Grupo",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"D4_QUANT"	    ,"SD4","Empenho",/*Mascara*/,) 
	TRCell():New(oSection,"B2_QATU"		    ,"SB2","Armazém 10","@E 999,999,999.999999",20)
	TRCell():New(oSection,"A_PAGAR"         ,"SA1","A Pagar","@E 999,999,999.999999",20)
	TRCell():New(oSection,"ARMAZEM01"    	,"SB2","Armazém 01","@E 999,999,999.999999",20)

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

		SELECT TB.*,ROUND(TB.B2_QATU,2)- ROUND(D4_QUANT,2) A_PAGAR,SB22.B2_QATU  ARMAZEM01,SB22.B2_LOCAL,'[____________]' USUARIO
		FROM(
		SELECT B2_FILIAL,D4_COD,B1_DESC,SUM(D4_QUANT)D4_QUANT,B2_QATU
		FROM %Table:SD4% SD4 (NOLOCK)  
		INNER JOIN %Table:SC2% SC2 ON SD4.D4_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AND SD4.D4_PRODUTO = SC2.C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB2% SB2 (NOLOCK) ON SD4.D4_FILIAL = SB2.B2_FILIAL AND SD4.D4_COD = SB2.B2_COD AND SD4.D4_LOCAL = SB2.B2_LOCAL AND SD4.D4_COD = SB2.B2_COD AND SB2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SD4.D4_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' //AND SB1.B1_XFANTAS != 'S'
		WHERE SD4.D_E_L_E_T_ = ''    
		AND B1_TIPO != 'MO'   
		AND C2_DATRF = ''
		AND D4_QUANT > 0
		AND D4_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY B2_FILIAL,D4_COD,B1_DESC,B2_QATU
		)TB
		LEFT JOIN %Table:SB2% SB22 ON TB.B2_FILIAL = SB22.B2_FILIAL AND TB.D4_COD = SB22.B2_COD AND SB22.B2_LOCAL = '01' AND SB22.D_E_L_E_T_ =''
		WHERE ROUND(TB.B2_QATU,2)- ROUND(D4_QUANT,2) < 0
		ORDER BY 2	


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissão De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissão Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
Return