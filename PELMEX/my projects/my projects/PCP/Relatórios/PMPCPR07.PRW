#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR06    บAutor  ณStan Lee Lopes     				บ Data ณ  29/04/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Posi็ใo das OP's Geradas	  						        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR07()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR07"

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

	oReport := TReport():New(cPerg,"Posi็ใo das OP's Geradas",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Posi็ใo das OP's Geradas",{"SC2"},aOrdem)     

	TRCell():New(oSection,"C2_CC"		        	,"SC2","Cod. Custo",,)
	TRCell():New(oSection,"CTT_DESC01"	    		,"CTT","Descri็ใo",,)
	TRCell():New(oSection,"TOTAL"					,"SC2","Total",/*Mascara*/,) 
	TRCell():New(oSection,"PENDENTES"				,"SC2","Pendentes",/*Mascara*/,) 

	TRFunction():New(oSection:Cell("TOTAL"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("PENDENTES"),"PENDENTES","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	//TRCell():New(oSection,"C2_XCARGA"      			,"SC2","Carga",/*Mascara*/,12)
	//TRCell():New(oSection,('000169')	,"SC2","Usuแrio",/*Mascara*/,35)
	//TRCell():New(oSection,FWLeUserlg("C2_USERLGA",2)	,"SC2","Usuแrio",/*Mascara*/,35)

	//Totalizador
	/*                                                                                  


	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
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

		SELECT C2_CC,CTT_DESC01,SUM(C2_QUANT) TOTAL,
		CASE WHEN SUM(C2_QUANT) = SUM(C2_QUJE) THEN 0
		ELSE SUM(C2_QUANT)-SUM(C2_QUJE) END PENDENTES

		FROM %Table:SC2% SC2(NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC2.C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:CTT% CTT (NOLOCK) ON CTT.CTT_CUSTO = SB1.B1_CC AND CTT.D_E_L_E_T_ = ''
		WHERE SC2.D_E_L_E_T_ = '' 
		AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C2_LOCAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%    
		AND C2_PRODUTO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND C2_CC BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%

		GROUP BY C2_CC,CTT_DESC01
		ORDER BY 1

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Emissใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	PutSX1(cPerg,"03",PADR("Armaz้m De    ",20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
	PutSX1(cPerg,"04",PADR("Armaz้m At้   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04") 
	PutSX1(cPerg,"05",PADR("Produto De    ",20)+"?","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05") 
	PutSX1(cPerg,"06",PADR("Produto At้   ",20)+"?","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")
	PutSX1(cPerg,"07",PADR("Custo De   	  ",20)+"?","","","mv_ch7","C",4,0,0,"G","","","","","mv_par07") 
	PutSX1(cPerg,"08",PADR("Custo At้     ",20)+"?","","","mv_ch8","C",4,0,0,"G","","","","","mv_par08") 

Return