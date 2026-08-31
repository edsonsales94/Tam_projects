#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR16    บAutor  ณStan Lee Lopes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATำRIO NOTAS FATURADAS 		        								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR16()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR16"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE NOTAS FATURADAS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"RELATำRIO DE NOTAS FATURADAS",{"SF2"},aOrdem) 

	TRCell():New(oSection,"F2_EMISSAO"			,"SF2","Dt.Emissใo",/*Mascara*/,15) 
	TRCell():New(oSection,"F2_DOC"				,"SF2","Nota",/*Mascara*/,11)
	TRCell():New(oSection,"F2_SERIE"		    ,"SF2","Serie",,/*Tamanho*/)
	TRCell():New(oSection,"D2_TOTAL"	    	,"SD2","Total","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"F2_CLIENTE"	    	,"SF2","Cod. Cliente",/*Mascara*/,) 
	TRCell():New(oSection,"F2_LOJA"	    		,"SF2","Loja",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"A1_NOME"         	,"SA1","Nome",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"F4_FINALID"         	,"SF4","Finalidade",/*Mascara*/,35)
	TRCell():New(oSection,"TIPO"         		,"SF2","Tipo NFe",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"SITUACAO"         	,"SF2","Situa็ใo",/*Mascara*/,/*Tamanho*/)


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
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		SELECT F2_EMISSAO,F2_DOC,F2_SERIE,SUM(D2_TOTAL)D2_TOTAL,F2_CLIENTE,F2_LOJA,A1_NOME,RTRIM(F4_FINALID)F4_FINALID,'SAอDA' TIPO,
		CASE WHEN SF2.D_E_L_E_T_ = '' THEN 'NFe OK'
		ELSE 'NFe CANCELADA' END SITUACAO
		FROM %Table:SF2% SF2 (NOLOCK)
		INNER JOIN %Table:SD2% SD2 (NOLOCK) ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.D_E_L_E_T_ = '' AND SD2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ''
		WHERE F2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND F2_FILIAL = '01'
		AND F2_SERIE = '2'
		GROUP BY F2_EMISSAO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,A1_NOME,F4_FINALID,SF2.D_E_L_E_T_
		UNION
		SELECT F1_EMISSAO F2_EMISSAO,F1_DOC F2_DOC,F1_SERIE F2_SERIE,SUM(D1_TOTAL)D1_TOTAL,F1_FORNECE,F1_LOJA,A1_NOME,RTRIM(F4_FINALID)F4_FINALID,'ENTRADA' TIPO,
		CASE WHEN SF1.D_E_L_E_T_ = '' THEN 'NFe OK'
		ELSE 'NFe CANCELADA' END SITUACAO
		FROM %Table:SF1% (NOLOCK) SF1
		INNER JOIN %Table:SD1% SD1 (NOLOCK) ON SF1.F1_FILIAL = SD1.D1_FILIAL AND SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE AND SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SF1.F1_FORNECE = SA1.A1_COD AND SF1.F1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SD1.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ''
		WHERE F1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND F1_FILIAL = '01'
		AND F1_SERIE = '2'
		GROUP BY F1_EMISSAO,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A1_NOME,F4_FINALID,SF1.D_E_L_E_T_   

		UNION

		SELECT F1_EMISSAO F2_EMISSAO,F1_DOC F2_DOC,F1_SERIE F2_SERIE,SUM(D1_TOTAL)D1_TOTAL,F1_FORNECE,F1_LOJA,A2_NOME,RTRIM(F4_FINALID)F4_FINALID,'ENTRADA' TIPO,
		CASE WHEN SF1.D_E_L_E_T_ = '' THEN 'NFe OK'
		ELSE 'NFe CANCELADA' END SITUACAO
		FROM %Table:SF1% (NOLOCK) SF1
		INNER JOIN %Table:SD1% SD1 (NOLOCK) ON SF1.F1_FILIAL = SD1.D1_FILIAL AND SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE AND SF1.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA2% SA2 (NOLOCK) ON SF1.F1_FORNECE = SA2.A2_COD AND SF1.F1_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SD1.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ''
		WHERE F1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND F1_FILIAL = '01'
		AND F1_SERIE = '2'
		GROUP BY F1_EMISSAO,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,A2_NOME,F4_FINALID,SF1.D_E_L_E_T_
		ORDER BY 1,2,3          


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Emissใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return