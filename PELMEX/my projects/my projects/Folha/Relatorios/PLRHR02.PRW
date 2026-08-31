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


User Function PLRHR02()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLRHR02"

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

	oReport := TReport():New(cPerg,"Indicadores por Salแrio",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira se็ใo
	oSection := TRSection():New(oReport,"Indicadores por Salแrio",{"SRA"},aOrdem) 



	TRCell():New(oSection,"RA_FILIAL"	        		,"SRA","Filial",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"RA_MAT"	        			,"SRA","Matricula",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"RA_NOME"	        			,"SRA","Nome do Funcionario",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_ADMISSA"	       			,"SRA","DT.Admissใo",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"RA_DEMISSA"	       			,"SRA","DT.Demissใo",/*Mascara*/,/*Tamanho*/)	
	TRCell():New(oSection,"RA_SALARIO"	        		,"SRA","Salแrio",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_CODFUNC"	        		,"SRA","Cod.Func",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RJ_DESC"	        			,"SRJ","Fun็ใo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_CC"		        		,"SRA","C.Custo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"CTT_DESC01"		       		,"CTT","Descri็ใo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_GRINRAI"	        		,"SRA","COD.RAIZ",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"X5_DESCRI"	        		,"SX5","Escolaridade",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RJ_MAOBRA"	        		,"SRJ","Mใo de obra",/*Mascara*/,/*Tamanho*/)

	//TRCell():New(oSection,"RA_DTFIMCT"	        		,"SRA","Fim do Contrato",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_DEFIFIS"	       			,"SRA","Deficiente",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_BRPDH"	        		,"SRA","Reabilitado?",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_TPDEFFI"        			,"SRA","Tipo de Deficiencia",/*Mascara*/,/*Tamanho*/)
	//Totalizador                                                                                  


	TRFunction():New(oSection:Cell("RA_MAT"),"TOTAL","COUNT",,,"@E 9,999,999,999",,.F.,.T.)  
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

		SELECT RA_FILIAL,LTRIM(RA_MAT) RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_SALARIO,RA_CODFUNC,RJ_DESC,RA_CC,CTT_DESC01,X5_DESCRI,RA_GRINRAI,CTT_DESC01,
		CASE WHEN RJ_MAOBRA = 'I' THEN 'INDIRETA' ELSE 'DIRETA' END RJ_MAOBRA
		FROM %Table:SRA% AS SRA
		INNER JOIN %Table:SRJ% AS SRJ ON RJ_FUNCAO = RA_CODFUNC AND RA_FILIAL = RJ_FILIAL  AND SRJ.D_E_L_E_T_ = ''
		INNER JOIN %Table:SX5% AS SX5 ON X5_CHAVE = RA_GRINRAI AND X5_TABELA = '26' AND X5_FILIAL = '' AND SX5.D_E_L_E_T_ = ''
		INNER JOIN %Table:CTT% AS CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
		WHERE 
		RA_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND((RA_SEXO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% ) OR (RA_SEXO BETWEEN %Exp:MV_PAR04% AND %Exp:MV_PAR03% )) 
		AND SRA.D_E_L_E_T_ = ''
		AND RA_ADMISSA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		GROUP BY RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_SALARIO,RA_CODFUNC,RJ_DESC,RA_CC,CTT_DESC01,X5_DESCRI,RA_GRINRAI,CTT_DESC01,RJ_MAOBRA
		ORDER BY RA_FILIAL,RA_ADMISSA,RA_MAT


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            

	u_InPutSX1(cPerg,"01",PADR("Filial De    ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Filial At้   ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Sexo De    ",20)+"?","","","mv_ch3","C",1,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Sexo At้   ",20)+"?","","","mv_ch4","C",1,0,0,"G","","","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("DT.Admissใo De    ",20)+"?","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("DT.Admissใo At้   ",20)+"?","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06")
Return