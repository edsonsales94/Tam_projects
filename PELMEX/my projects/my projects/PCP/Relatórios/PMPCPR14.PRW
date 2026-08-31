#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR04    บAutor  ณStan Lee Lopes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO ANALISE DE MOVIMENTO VENDAS X ESTOQUE		        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR14()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR14"

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

	oReport := TReport():New(cPerg,"ENTRADA DO ESTOQUE",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Entrada do estoque",{"SB2"},aOrdem)     


	TRCell():New(oSection,"B1_GRUPO"				,"SB1","Grupo",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"BM_DESC"					,"SBM","Descri็ใo",/*Mascara*/,)
	TRCell():New(oSection,"QTDESTOQUE"		        ,"SC2","Total","@E 9,999,999,999",15)           

	TRFunction():New(oSection:Cell("QTDESTOQUE"),"QUANTIDADE TOTAL PRODUZIDA","SUM",,,"@E 9,999,999,999",,.F.,.T.)

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


		SELECT B1_GRUPO,BM_DESC,SUM(1) QTDESTOQUE 
		FROM %Table:SZ1% SZ1
		LEFT JOIN %Table:SC2% SC2 ON C2_NUM+C2_ITEM+C2_SEQUEN = Z1_OP
		INNER JOIN %Table:SB1% SB1 ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SBM% SBM ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = '' 
		WHERE 
		B1_GRUPO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND B1_COD BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND B1_LOCPAD = '20'
		AND Z1_DTAPONT BETWEEN  %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SZ1.D_E_L_E_T_ = ''
		GROUP BY B1_GRUPO,BM_DESC
		ORDER BY BM_DESC



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)


	u_InPutSX1(cPerg,"01",PADR("Grupo De ?   ",20)+"?","","","mv_ch1","C",4,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Grupo At้ ?  ",20)+"?","","","mv_ch2","C",4,0,0,"G","","","","","mv_par02")  
	u_InPutSX1(cPerg,"03",PADR("Produto De ?   ",20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Produto At้ ?  ",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Emissใo De ?   ",20)+"?","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Emissใo At้ ?  ",20)+"?","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06") 


Return