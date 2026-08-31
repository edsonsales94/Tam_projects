#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma   PLFINR11    บAutor  ณStan Lee Lopes     				บ Data ณ  04/12/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de vendas por vendendor       								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR11()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR11"

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

	oReport := TReport():New(cPerg,"RELATORIO DE VENDAS POR VENDEDOR ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"PLFINR11",{"SE1"},aOrdem) 


	TRCell():New(oSection,"E1_EMISSAO"	,"SE1","Dt.Emissใo",/*Mascara*/)
	TRCell():New(oSection,"A1_COD"      ,"SA1","COD",/*Mascara*/,)
	TRCell():New(oSection,"A1_NOME"     ,"SA1","Nome.Cliente",/*Mascara*/,)
	TRCell():New(oSection,"E1_TIPO" 	,"SE1","Tipo",/*Mascara*/,) 
	TRCell():New(oSection,"E1_PREFIXO"  ,"SE1","Prefixo",/*Mascara*/,)
	TRCell():New(oSection,"E1_NUM"   	,"SE1","N๚mero",/*Mascara*/,12)
	TRCell():New(oSection,"E1_PARCELA"	,"SE1","Parcela",/*Mascara*/,) 
	TRCell():New(oSection,"E1_VENCTO"	,"SE1","Dt.Vencimento",/*Mascara*/,)
	TRCell():New(oSection,"E1_VALOR"    ,"SE1","Valor",/*Mascara*/,20)
	TRCell():New(oSection,"E1_NSUTEF"	,"SE1","NSUTEF",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"A3_COD"    	,"SA3","Cod.Vend",/*Mascara*/,)
	TRCell():New(oSection,"A3_NOME"    	,"SA3","Nome.Vend",/*Mascara*/,)


	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 999,999,999.99",,.F.,.T.)
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


		SELECT  E1_EMISSAO,E1_TIPO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VENCTO,E1_VALOR,E1_NSUTEF,
		A3_COD,A3_NOME,
		A1_COD,A1_NOME

		FROM %Table:SE1% (NOLOCK) AS SE1
		INNER JOIN %Table:SA3% (NOLOCK) AS SA3 ON E1_VEND1 = A3_COD
		INNER JOIN %Table:SL1% (NOLOCK) AS SL1 ON SL1.D_E_L_E_T_ = '' AND SL1.L1_DOCPED = SE1.E1_NUM AND SL1.L1_SERPED = SE1.E1_PREFIXO
		INNER JOIN %Table:SA1% (NOLOCK) AS SA1 ON SA1.D_E_L_E_T_ = '' AND SL1.L1_CLIENTE = SA1.A1_COD
		WHERE 
		E1_EMISSAO BETWEEN %Exp:MV_PAR01% AND  %Exp:MV_PAR02%
		AND E1_TIPO IN ('CC','CD')
		AND SE1.D_E_L_E_T_ = ''
		AND SA3.D_E_L_E_T_ = ''

		UNION 

		SELECT  E1_EMISSAO,E1_TIPO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VENCTO,E1_VALOR,E1_NSUTEF,
		A3_COD,A3_NOME,
		A1_COD,A1_NOME

		FROM %Table:SE1% (NOLOCK) AS SE1
		INNER JOIN %Table:SA3% (NOLOCK) AS SA3 ON E1_VEND1 = A3_COD
		INNER JOIN %Table:SL1% (NOLOCK) AS SL1 ON SL1.D_E_L_E_T_ = '' AND SL1.L1_DOC = SE1.E1_NUM AND SL1.L1_SERIE = SE1.E1_PREFIXO
		INNER JOIN %Table:SA1% (NOLOCK) AS SA1 ON SA1.D_E_L_E_T_ = '' AND SL1.L1_CLIENTE = SA1.A1_COD
		WHERE 
		E1_EMISSAO BETWEEN %Exp:MV_PAR01% AND  %Exp:MV_PAR02%
		AND E1_TIPO IN ('CC','CD')
		AND SE1.D_E_L_E_T_ = ''
		AND SA3.D_E_L_E_T_ = ''
		ORDER BY E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_PARCELA

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Emissใo de    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","SM0","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Emissใo ate   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","SM0","","","mv_par02") 

Return
