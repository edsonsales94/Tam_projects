#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR29    บAutor  ณStan Lee Lopes     				บ Data ณ  09/03/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Pedidos X Estoque        								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR29()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR29"

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

	oReport := TReport():New(cPerg,"Relat๓rio de Pedidos X Estoque",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Pedido",{"SC6"},aOrdem) 

	TRCell():New(oSection,"A1_EST"		    ,"SA1","Estado",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"CC2_MUN"		    ,"CC2","Municipio",/*Mascara*/,20)
	TRCell():New(oSection,"C6_NUM"		    ,"SC6","Pedido",,/*Tamanho*/)
	TRCell():New(oSection,"C6_ENTREG"	    ,"SC6","Data da Entrega",,/*Tamanho*/) 
	TRCell():New(oSection,"C6_PRODUTO"	    ,"SC6","Produto",,30) 
	TRCell():New(oSection,"QTDPEDI"	        ,"SB2","Qtd.Pedido","@E 9,999,999,999",6) 
	TRCell():New(oSection,"B2_QATU"         ,"SB2","SALDO","@E 9,999,999,999",6) 
	TRCell():New(oSection,"C6_CLI"          ,"SC6","Cod.Cliente",,6)
	TRCell():New(oSection,"A1_NOME"         ,"SA1","Nome",,30)

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
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

		SELECT A1_EST,CC2_MUN,C6_ENTREG,C6_NUM,C6_PRODUTO,(C6_QTDVEN-C6_QTDENT) QTDPEDI,B2_QATU,C6_CLI,A1_NOME
		FROM %Table:SC6% SC6 (NOLOCK)
		INNER JOIN %Table:SA1% SA1 ON SC6.C6_CLI = SA1.A1_COD AND SC6.C6_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:CC2% CC2 ON SA1.A1_COD_MUN = CC2.CC2_CODMUN AND A1_EST = CC2_EST AND CC2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB2% SB2 ON SC6.C6_FILIAL = SB2.B2_FILIAL AND SC6.C6_PRODUTO = SB2.B2_COD AND SC6.C6_LOCAL = SB2.B2_LOCAL AND SB2.D_E_L_E_T_ = ''
		WHERE SC6.D_E_L_E_T_  = ''
		AND C6_FILIAL = '01'
		AND B2_LOCAL = '20'
		AND C6_QTDENT < C6_QTDVEN
		AND C6_ENTREG BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C6_BLQ NOT IN  ('R','S')
		GROUP BY A1_EST,CC2_MUN,C6_ENTREG,C6_NUM,C6_PRODUTO,C6_QTDVEN,C6_QTDENT,B2_QATU,C6_CLI,A1_NOME
		ORDER BY A1_EST,C6_ENTREG,C6_NUM,C6_PRODUTO

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Periodo De",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Periodo At้",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return
