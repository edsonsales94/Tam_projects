#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR15    ºAutor  ³Stan Lee Lopes     				º Data ³  14/03/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO POSIÇÃO DE TÍTULOS A RECEBER	        						±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR15()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR15"

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

	oReport := TReport():New(cPerg,"RELATÓRIO POSIÇÃO DE TÍTULOS A RECEBER",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"RELATÓRIO POSIÇÃO DE TÍTULOS A RECEBER",{"SE1"},aOrdem) 

	TRCell():New(oSection,"E1_PREFIXO"			,"SE1","Prefixo",/*Mascara*/,4)
	TRCell():New(oSection,"E1_NUM"		        ,"SE1","Título",,15)
	TRCell():New(oSection,"E1_PARCELA"	    	,"SE1","Parcela",,/*Tamanho*/) 
	TRCell():New(oSection,"E1_TIPO"	    	    ,"SE1","Tipo",/*Mascara*/,) 
	TRCell():New(oSection,"E1_PORTADO"	    	,"SE1","Banco",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"SITUACAO"            ,"SE1","Situação",/*Mascara*/,20)
	TRCell():New(oSection,"E1_CLIENTE"         	,"SE1","Cod.Cli",/*Mascara*/,)
	TRCell():New(oSection,"A1_NOME"         	,"SA1","Cliente",/*Mascara*/,25)
	TRCell():New(oSection,"E1_EMISSAO"         	,"SE1","Dt.Emissão",/*Mascara*/,15)
	TRCell():New(oSection,"E1_VENCTO"         	,"SE1","Dt.Vencimento",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"E1_VALOR"         	,"SE1","Valor","@E 999,999,999.99",/*Tamanho*/)
	TRCell():New(oSection,"E1_SALDO"         	,"SE1","Saldo","@E 999,999,999.99",/*Tamanho*/)
	TRCell():New(oSection,"E1_BAIXA"         	,"SE1","Dt.Baixa",/*Mascara*/,15)
	TRCell():New(oSection,"E1_STATUS"         	,"SE1","Status",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"E1_HIST"         	,"SE1","Histórico",/*Mascara*/,/*Tamanho*/)          

	//Totalizador
	/*                                                                                  

	TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

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

		SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_PORTADO,
		CASE WHEN E1_SITUACA = 0 THEN 'CARTEIRA'
		WHEN E1_SITUACA = 1 THEN 'COB SIMPLES'
		WHEN E1_SITUACA = 2 THEN 'DESCONTADA'
	END SITUACAO,
	E1_CLIENTE,A1_NOME,E1_EMISSAO,E1_VENCTO,E1_VALOR,E1_SALDO,E1_BAIXA,E1_STATUS,E1_HIST
	FROM %Table:SE1% SE1 (NOLOCK) 
	INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SE1.E1_CLIENTE = SA1.A1_COD AND SE1.E1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
	WHERE SE1.D_E_L_E_T_ = ''
	AND E1_VENCTO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND E1_TIPO = 'NF' 
	AND E1_SALDO > 0
	ORDER BY 1,3,2 	          

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Vencimento De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Vencimento Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return