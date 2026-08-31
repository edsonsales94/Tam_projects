#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLCOMR04    บAutor  ณWilson Guedes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  CUSTO ENTRADA X CUSTO STAND	  						        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLCOMR04()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLCOMR04"

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

	oReport := TReport():New(cPerg,"CUSTO ENTRADA X CUSTO STAND",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"CUSTO ENTRADA X CUSTO STAND",{"SD1"},aOrdem)     


	TRCell():New(oSection,"D1_COD"		        	,"SD1","COD",,)
	TRCell():New(oSection,"B1_DESC"	    			,"SB1","Descri็ใo",,)
	TRCell():New(oSection,"D1_VUNIT"				,"SD1","Custo Entrada",/*Mascara*/,) 
	TRCell():New(oSection,"B1_CUSTD"	        	,"SB1","Custo Stand",/*Mascara*/,)
	TRCell():New(oSection,"B1_TIPO"		        	,"SB1","Tipo",/*Mascara*/,)
	TRCell():New(oSection,"B2_LOCAL"		        ,"SB2","Armaz้m",/*Mascara*/,) 
	TRCell():New(oSection,"B2_QATU"		        	,"SB2","Qtd. Atual",/*Mascara*/,)         
	TRCell():New(oSection,"B1_QB"	        		,"SB1","Base Estrutura",/*Mascara*/,)
	TRCell():New(oSection,"D1_DOC"      			,"SD1","Documento",/*Mascara*/,)
	TRCell():New(oSection,"D1_SERIE"      			,"SD1","S้rie",/*Mascara*/,4)
	TRCell():New(oSection,"D1_EMISSAO"       		,"SD1","Dt. Emissใo",/*Mascara*/,12)
	TRCell():New(oSection,"D1_DTDIGIT"	       		,"SD1","Dt. Digita็ใo",/*Mascara*/,12)


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
	//	cOrdem := "A1_COD"           
	ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

		SELECT SD1.D1_COD,B1_DESC,B1_TIPO,B1_QB,D1_VUNIT,B1_CUSTD,SB2.B2_LOCAL,SB2.B2_QATU,D1_DOC,D1_SERIE,D1_EMISSAO,D1_DTDIGIT 
		FROM %Table:SD1% SD1 (NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ =''  AND SB1.B1_MSBLQL != '1'
		INNER JOIN %Table:SB2% SB2 (NOLOCK) ON B1_COD = B2_COD AND SB1.D_E_L_E_T_ =''
		WHERE SD1.D_E_L_E_T_ = ''
		AND SD1.R_E_C_N_O_ IN (SELECT MAX (SD1.R_E_C_N_O_)
		FROM %Table:SD1% SD1 (NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ =''  AND SB1.B1_MSBLQL != '1' AND SB1.B1_TIPO IN ('PA','PI','PC','MA','MI','MN')
		WHERE SD1.D_E_L_E_T_ = '' 
		AND SD1.D1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SD1.D1_TIPO NOT IN  ('D','C')
		AND SD1.D1_TES NOT IN ('848')
		AND SD1.D1_SERIE NOT IN ('UNI')
		AND SB1.B1_TIPO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%

		GROUP BY SD1.D1_COD
		) 
		AND SB2.B2_QATU != 0                                       
		AND SB2.B2_LOCAL BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		ORDER BY  B1_COD,B1_DESC,B1_TIPO

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)
	u_InPutSx1(cPerg, "01", "Produto de?",			"","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01")
	u_InPutSx1(cPerg, "02", "Produto Ate?",			"","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02")
	u_InPutSx1(cPerg, "03", "Tipo de?", 			"","","mv_ch3","C",2,0,0,"G","","SB1","","","mv_par03")
	u_InPutSx1(cPerg, "04", "Tipo Ate?",			"","","mv_ch4","C",2,0,0,"G","","SB1","","","mv_par04") 
	u_InPutSx1(cPerg, "05", "Armaz้n de?", 			"","","mv_ch5","C",2,0,0,"G","","SB2","","","mv_par05")
	u_InPutSx1(cPerg, "06", "Armaz้n Ate?",			"","","mv_ch6","C",2,0,0,"G","","SB2","","","mv_par06") 
Return