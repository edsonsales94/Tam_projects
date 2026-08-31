#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR18    บAutor  ณWilson Junior     				บ Data ณ  03/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATำRIO Indicadores 													 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLRHR06()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLRHR06"

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

	oReport := TReport():New(cPerg,"Relatorio gerencial ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relatorio gerencial",{"SRA"},aOrdem) 


	TRCell():New(oSection,"RD_PD"	        			,"SRD","Cod.Verba",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RV_DESC"	        			,"SRV","Descri็ใo da Verba",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RV_TIPOCOD"	        		,"SRA","Tipo da verba",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RD_HORAS"	       			,"SRD","Horas",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RD_VALOR"	       			,"SRD","Valor","@E 9,999,999,999,999.99",20)
	//Totalizador                                                                                  

	/*
	TRFunction():New(oSection:Cell("RD_VALOR"),"Despesas da folha","SUM",,,"@E 9,999,999.999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("RD_HORAS"),"Horas Totais","SUM",,,"@E 9,999,999,999.99",,.F.,.T.) 

	TRFunction():New(oSection:Cell("M"),"Masculino","SUM",,,,,.F.,.T.)  
	TRFunction():New(oSection:Cell("F"),"Feminino","SUM",,,,,.F.,.T.)  
	*/
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENวA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("DA1_TOTAL"),"TOTAL FABRICA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	/*
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                      MIMIM ท
	//endif      
	Local nTotReg :=0

	oSection:BeginQuery()



	BeginSQL Alias cAlias
		%noparser%   


		SELECT RD_PD,RV_DESC,RV_TIPOCOD,SUM(RD_HORAS) RD_HORAS,SUM(RD_VALOR) RD_VALOR
		FROM (	SELECT
		CASE WHEN RV_TIPOCOD = 1 THEN 'PROVENTO' ELSE
		CASE WHEN RV_TIPOCOD = 2 THEN 'DESCONTO' ELSE
		CASE WHEN RV_TIPOCOD = 3 THEN '(BASE) PROVENTO' ELSE
		CASE WHEN RV_TIPOCOD = 4 THEN '(BASE) DESCONTO' ELSE
		'NAO CADASTRADO' END END END END RV_TIPOCOD,
		RD_PD,RV_DESC,RD_HORAS,
		CASE WHEN RV_TIPOCOD = 2 THEN RD_VALOR*-1 ELSE
		CASE WHEN RV_TIPOCOD = 4 THEN RD_VALOR*-1 ELSE
		RD_VALOR END END RD_VALOR
		FROM %Table:SRA% AS SRA
		INNER JOIN %Table:SRJ% AS SRJ (NOLOCK) ON RJ_FUNCAO = RA_CODFUNC AND RA_FILIAL = RJ_FILIAL  AND SRJ.D_E_L_E_T_ = ''
		INNER JOIN %Table:SX5% AS SX5 (NOLOCK) ON X5_CHAVE = RA_GRINRAI AND X5_TABELA = '26' AND X5_FILIAL = '' AND SX5.D_E_L_E_T_ = ''
		INNER JOIN %Table:CTT% AS CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
		INNER JOIN %Table:SRD% AS SRD (NOLOCK) ON RD_MAT = RA_MAT AND RD_FILIAL = RA_FILIAL AND SRD.D_E_L_E_T_ = ''
		INNER JOIN %Table:SRV% AS SRV (NOLOCK) ON RV_COD = RD_PD AND SRV.D_E_L_E_T_ = ''
		WHERE 
		RD_PERIODO = %Exp:MV_PAR01%
		AND RD_ROTEIR = %Exp:MV_PAR02%
		AND RA_FILIAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND RA_CC BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND RA_MAT BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		AND SRA.D_E_L_E_T_ = ''
		AND RA_SITFOLH NOT IN ('T') )TB	
		GROUP BY RD_PD,RV_DESC,RV_TIPOCOD	
		ORDER BY RD_PD


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            

	u_InPutSX1(cPerg,"01",PADR("Periodo   ",20)+"?","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Roteiro   ",20)+"?","","","mv_ch2","C",3,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Filial De ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Filial At้",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par04")  
	u_InPutSX1(cPerg,"05",PADR("Centro de custo de   ",20)+"?","","","mv_ch5","C",9,0,0,"G","","CTT","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Centro de custo At้  ",20)+"?","","","mv_ch6","C",9,0,0,"G","","CTT","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Matricula De",20)+"?","","","mv_ch7","C",6,0,0,"G","","SRA","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Matricula At้",20)+"?","","","mv_ch8","C",6,0,0,"G","","SRA","","","mv_par08") 
Return