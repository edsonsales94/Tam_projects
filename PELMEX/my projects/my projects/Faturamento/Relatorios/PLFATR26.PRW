#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR20    บAutor  ณStan Lee Lopes     				บ Data ณ  11/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Produto X Notas Emitidas      								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR26()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR26"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE PRODUTO X NOTAS EMITIDAS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Produto X Notas Emitidas",{"SD2"},aOrdem)  



	TRCell():New(oSection,"D2_COD"  		,"SD2","C๓digo",/*Mascara*/,25)  
	TRCell():New(oSection,"B1_DESC"		    ,"SB1","Descri็ใo",/*Mascara*/,/*Tamanho*/)             
	TRCell():New(oSection,"D2_QUANT" 		,"SD2","Quantidade","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"A1_COD"    		,"SA1","Cod.Cliente",/*Mascara*/,)
	TRCell():New(oSection,"A1_NOME"    		,"SA1","Cliente",/*Mascara*/,)
	TRCell():New(oSection,"A1_END"    		,"SA1","Endere็o",/*Mascara*/,)
	TRCell():New(oSection,"A1_TEL"    		,"SA1","Telefone 1",/*Mascara*/,)
	TRCell():New(oSection,"A1_TELEX"  		,"SA1","Telefone 2",/*Mascara*/,)  
	TRCell():New(oSection,"A1_EST"		    ,"SA1","Estado",/*Mascara*/,/*Tamanho*/)             
	TRCell():New(oSection,"A1_EMAIL" 		,"SA1","Email",/*Tamanho*/) 

	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("D2_QUANT"),"QUANTIDADE TOTAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)
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

		SELECT D2_FILIAL,A1_COD,A1_NOME,
		D2_COD,B1_DESC,SUM(D2_QUANT)D2_QUANT,A1_END,A1_DDD+A1_TEL A1_TEL,A1_TELEX,A1_EST,A1_EMAIL
		FROM %Table:SD2% SD2 (NOLOCK)
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SD2.D2_CLIENTE = A1_COD AND SD2.D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SD2.D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON SD2.D2_DOC = SD1.D1_NFORI AND SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SD2.D2_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
		WHERE SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SD2.D2_COD BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SD2.D_E_L_E_T_ = ''
		AND SD2.D2_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SD2.D2_LOJA BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%                               
		AND SD2.D2_TES NOT IN ('848','871','705','877','893','886')      
		AND D2_FILIAL BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
		GROUP BY D2_FILIAL,A1_COD,A1_NOME,D2_COD,B1_DESC,A1_END,A1_TEL,A1_TELEX,A1_EST,A1_EMAIL,A1_DDD
		ORDER BY D2_FILIAL,D2_COD,A1_COD

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Emissao De     ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Emissao At้    ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	PutSX1(cPerg,"03",PADR("Produto De     ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SB1","","","mv_par03") 
	PutSX1(cPerg,"04",PADR("Produto At้    ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SB1","","","mv_par04")
	PutSX1(cPerg,"05",PADR("Cliente De     ",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA1","","","mv_par05") 
	PutSX1(cPerg,"06",PADR("Cliente At้    ",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA1","","","mv_par06")
	PutSX1(cPerg,"07",PADR("Loja De        ",20)+"?","","","mv_ch7","C",6,0,0,"G","","","","","mv_par07") 
	PutSX1(cPerg,"08",PADR("Loja At้       ",20)+"?","","","mv_ch8","C",6,0,0,"G","","","","","mv_par08") 
	PutSX1(cPerg,"09",PADR("Filial De      ",20)+"?","","","mv_ch9","C",6,0,0,"G","","","","","mv_par09")
	PutSX1(cPerg,"10",PADR("Filial At้     ",20)+"?","","","mv_cha","C",6,0,0,"G","","","","","mv_par10")

Return
