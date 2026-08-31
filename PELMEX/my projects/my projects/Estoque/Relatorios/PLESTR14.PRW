#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR18    บAutor  ณWilson Junior     				บ Data ณ  03/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATำRIO DE Indicadores por Salแrio									 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR14()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLESTR14"

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

	oReport := TReport():New(cPerg,"Relatorio de Mใo de Obra",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relatorio de Mใo de Obra",{"SG1"},aOrdem) 


	TRCell():New(oSection,"G1_FILIAL"	        		,"SG1","Filial",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"C2_OP"	        			,"SC2","Op",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"G1_COMP"	        			,"SG1","Componente",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"G1_COD"	       				,"SG1","Produto",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"B1_DESC"	       				,"SB1","Descri็ใo",/*Mascara*/,/*Tamanho*/)	
	TRCell():New(oSection,"B1_TIPO"	        			,"SB1","Tipo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"B1_GRUPO"	        		,"SB1","Grupo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"G1_QUANT"	        		,"SG1","Qtd.Estrutura",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C2_QUANT"		        	,"SC2","Qtd.Op",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"TOTAL"		       			,"TOTAL","Total",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C2_EMISSAO"	        		,"SC7","Emissใo",/*Mascara*/,/*Tamanho*/)

	//TRCell():New(oSection,"RA_DTFIMCT"	        		,"SRA","Fim do Contrato",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_DEFIFIS"	       			,"SRA","Deficiente",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_BRPDH"	        		,"SRA","Reabilitado?",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_TPDEFFI"        			,"SRA","Tipo de Deficiencia",/*Mascara*/,/*Tamanho*/)
	//Totalizador                                                                                  


	/*
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

	/*
	local par01 :=0
	local par02 :=0
	if %Exp:MV_PAR05% == 1 
	par01 := "M"
	else
	par01 := "F"
	endif 
	if %Exp:MV_PAR06% == 1 
	par02 := "M"
	else
	par02 := "F"
	endif
	*/

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		SELECT G1_FILIAL,LTRIM(RTRIM(C2_NUM+C2_ITEM+C2_SEQUEN)) C2_OP,G1_COMP,G1_COD,B1_DESC,B1_TIPO,B1_GRUPO,G1_QUANT,C2_QUANT,(G1_QUANT*C2_QUANT)TOTAL,C2_EMISSAO
		FROM %Table:SG1% SG1 (NOLOCK)
		INNER JOIN %Table:SC2% SC2 (NOLOCK) ON C2_FILIAL = G1_FILIAL AND G1_COD = C2_PRODUTO  AND SC2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON G1_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE SG1.D_E_L_E_T_  = ''
		AND G1_COMP LIKE '%MOD%'
		AND G1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND B1_TIPO IN ('PA','PI')
		AND C2_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		ORDER BY C2_OP,G1_COD


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            

	u_InPutSX1(cPerg,"01",PADR("Produto De    ",20)+"?","","","mv_ch1","C",6,0,0,"G","","SB1","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Produto At้   ",20)+"?","","","mv_ch2","C",6,0,0,"G","","SB1","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Emissใo De    ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Emissใo At้   ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
Return