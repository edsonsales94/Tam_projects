#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR16    ºAutor  ³Stan Lee Lopes     				º Data ³  14/03/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO DE TÍTULOS A PAGAR		   	        					   	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR16()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR16"

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

	oReport := TReport():New(cPerg,"RELATÓRIO DE TÍTULOS A PAGAR",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"RELATÓRIO DE TÍTULOS A PAGAR",{"SE2"},aOrdem) 

	TRCell():New(oSection,"E2_NOMFOR"           ,"SE2","Fornecedor",/*Mascara*/,)
	TRCell():New(oSection,"E2_NUM"		        ,"SE2","Título",,15)
	TRCell():New(oSection,"E2_PREFIXO"			,"SE2","Prefixo",/*Mascara*/,4)
	TRCell():New(oSection,"E2_PARCELA"	    	,"SE2","Parcela",,/*Tamanho*/) 
	TRCell():New(oSection,"E2_FORNECE"	    	,"SE2","Cod.For",/*Mascara*/,) 
	TRCell():New(oSection,"E2_HIST"         	,"SE2","Historico",/*Mascara*/,)
	TRCell():New(oSection,"E2_EMISSAO"         	,"SE2","Dt.Emissão",/*Mascara*/,15)
	TRCell():New(oSection,"E2_VENCREA"         	,"SE2","Dt.Vencimento",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"E2_DATAAGE"         	,"SE2","Dt.AgendaVenc.",/*Mascara*/,15)
	TRCell():New(oSection,"E2_VALOR"         	,"SE2","Valor","@E 999,999,999.99",/*Tamanho*/)

	TRFunction():New(oSection:Cell("E2_VALOR"),"TOTAL A PAGAR","SUM",,,"@E 999,999,999,999.99",,.F.,.T.)
	//Totalizador
	/*                                                                                  


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

		SELECT SE2.E2_NOMFOR,SE2.E2_NUM,SE2.E2_PREFIXO,SE2.E2_PARCELA,SE2.E2_FORNECE,SE2.E2_HIST,SE2.E2_EMISSAO,SE2.E2_VENCREA,SE2.E2_DATAAGE,SE2.E2_VALOR
		FROM %Table:SE2% AS SE2 (NOLOCK)
		WHERE SE2.D_E_L_E_T_ = ''
		AND SE2.E2_DATAAGE BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SE2.E2_SALDO>0
		ORDER BY E2_NOMFOR,E2_EMISSAO 


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Vencimento De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Vencimento Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return
