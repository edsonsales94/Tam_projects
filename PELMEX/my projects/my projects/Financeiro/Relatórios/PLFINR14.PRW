#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR14    บAutor  ณStan Lee Lopes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATำRIO DE NOTAS PARA ASSISTสNCIA    								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR14()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR14"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE NOTAS PARA ASSISTสNCIA",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"RELATำRIO DE NOTAS PARA ASSISTสNCIA",{"SD2"},aOrdem) 

	TRCell():New(oSection,"D2_FILIAL"		,"SD2","Filial",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"D2_DOC"			,"SD2","Nota",/*Mascara*/,15)
	TRCell():New(oSection,"D2_SERIE"		,"SD2","S้rie",,4)
	TRCell():New(oSection,"D2_EMISSAO"      ,"SD2","Dt.Emissใo",/*Mascara*/,15)
	TRCell():New(oSection,"D2_TOTAL"	    ,"SD2","Total","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"D2_CLIENTE"	    ,"SD2","Cod.Cli",/*Mascara*/,) 
	TRCell():New(oSection,"D2_LOJA"	    	,"SD2","Loja Cli",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"A1_NOME"         ,"SA1","Cliente",/*Mascara*/,20)
	TRCell():New(oSection,"F4_FINALID"      ,"SF4","Cod.Cli",/*Mascara*/,25)
	TRCell():New(oSection,"TIPO"         	,"SD2","Tipo",/*Mascara*/,)
	TRCell():New(oSection,"B1_DESC"         ,"SB1","Produto",/*Mascara*/,50)


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

		SELECT D2_FILIAL,D2_DOC,D2_SERIE,SUM(D2_TOTAL)D2_TOTAL,D2_EMISSAO,D2_CLIENTE,D2_LOJA,A1_NOME,F4_FINALID,'NFe SAอDA' TIPO,
		B1_DESC
		FROM %Table:SD2% SD2(NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ''
		WHERE D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_FILIAL = '01'
		AND D2_SERIE != 'UNR'
		AND D2_TES = '705'
		GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_EMISSAO,D2_CLIENTE,D2_LOJA,A1_NOME,F4_FINALID,SD2.D_E_L_E_T_,B1_DESC
		UNION
		SELECT D1_FILIAL,D1_DOC,D1_SERIE,SUM(D1_TOTAL)D1_TOTAL,D1_EMISSAO D2_EMISSAO,D1_FORNECE,D1_LOJA,A1_NOME,F4_FINALID,'NFe ENTRADA' TIPO,
		B1_DESC
		FROM %Table:SD1% SD1
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SD1.D1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SD1.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ''
		WHERE D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D1_FILIAL = '01'
		AND D1_SERIE = '2'
		AND D1_TES = '014'
		GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_EMISSAO,D1_FORNECE,D1_LOJA,A1_NOME,F4_FINALID,SD1.D_E_L_E_T_,B1_DESC
		ORDER BY 1,2,3

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return