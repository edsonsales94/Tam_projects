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


User Function PLRHR04()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLRHR04"

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


	TRCell():New(oSection,"RA_FILIAL"	        		,"SRA","Filial",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"RA_MAT"	        			,"SRA","Matricula",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"RA_NOME"	        			,"SRA","Nome do Funcionario",/*Mascara*/,/*Tamanho*/)  	
	TRCell():New(oSection,"RA_SEXO"	        			,"SRA","Sexo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_CODFUNC"	        		,"SRA","Cod.Fun็ใo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RJ_DESC"	        			,"SRJ","Fun็ใo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RJ_MAOBRA"	        		,"SRJ","Mใo de obra",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"X5_DESCRI"	        		,"SX5","Escolaridade",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"CTT_DESC01"	        		,"CTT","Centro de Custo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RD_PD"	        			,"SRD","Cod.Verba",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RV_DESC"	        			,"SRV","Descri็ใo da Verba",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RV_TIPOCOD"	        		,"SRA","Tipo da verba",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RD_HORAS"	       			,"SRD","Horas",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RD_VALOR"	       			,"SRD","Valor","@E 9,999,999,999,999.99",15)
	TRCell():New(oSection,"RA_ADMISSA"	       			,"SRA","Admissใo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_DTFIMCT"	        		,"SRA","Fim do Contrato",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_DEFIFIS"	       			,"SRA","Deficiente",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_BRPDH"	        		,"SRA","Reabilitado?",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_TPDEFFI"        			,"SRA","Tipo de Deficiencia",/*Mascara*/,/*Tamanho*/)
	//Totalizador                                                                                  


	TRFunction():New(oSection:Cell("RD_VALOR"),"Despesas da folha","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
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

	oSection:BeginQuery()



	BeginSQL Alias cAlias
		%noparser%   



		SELECT RA_FILIAL,LTRIM(RA_MAT) RA_MAT,RA_NOME,
		CASE WHEN RA_SEXO = 'M' THEN 'MASCULINO' ELSE 'FEMININO' END RA_SEXO,RA_CODFUNC,RJ_DESC,
		CASE WHEN RJ_MAOBRA = 'I' THEN 'INDIRETA' ELSE 'DIRETA' END RJ_MAOBRA, 
		X5_DESCRI,CTT_DESC01,
		CASE WHEN RV_TIPOCOD = 1 THEN 'PROVENTO' ELSE
		CASE WHEN RV_TIPOCOD = 2 THEN 'DESCONTO' ELSE
		CASE WHEN RV_TIPOCOD = 3 THEN '(BASE) PROVENTO' ELSE
		CASE WHEN RV_TIPOCOD = 4 THEN '(BASE) DESCONTO' ELSE
		'NAO CADASTRADO' END END END END RV_TIPOCOD,
		RD_PD,RV_DESC,RD_HORAS,
		CASE WHEN RV_TIPOCOD = 2 THEN RD_VALOR*-1 ELSE
		CASE WHEN RV_TIPOCOD = 4 THEN RD_VALOR*-1 ELSE
		RD_VALOR END END RD_VALOR,
		RA_ADMISSA,
		CASE WHEN RA_DTFIMCT = '' THEN RA_DEMISSA ELSE RA_DTFIMCT END RA_DTFIMCT,
		CASE WHEN RA_DEFIFIS = '1' THEN 'SIM' ELSE 'NรO' END RA_DEFIFIS,
		CASE WHEN RA_BRPDH = '1' THEN 'BENEFICIARIO REABILITADO' ELSE 
		CASE WHEN RA_BRPDH = '2' THEN 'PORTADOR DEFICIENCIA HABILITADO' ELSE 'NรO APLICAVEL' END END RA_BRPDH,
		CASE WHEN RA_TPDEFFI = '1' THEN 'FISICA' ELSE 
		CASE WHEN RA_TPDEFFI = '2' THEN 'AUDITIVA' ELSE
		CASE WHEN RA_TPDEFFI = '3' THEN 'VISUAL' ELSE
		CASE WHEN RA_TPDEFFI = '4' THEN 'INTELECTUAL (MENTAL)' ELSE
		CASE WHEN RA_TPDEFFI = '5' THEN 'MULTIPLA' ELSE
		CASE WHEN RA_TPDEFFI = '6' THEN 'REABILITADO' ELSE 'NรO E PORTADOR DE DEFICIENCIA'
	END END END END END END RA_TPDEFFI, 
	CASE WHEN RA_SEXO = 'M' THEN 1 ELSE 0 END M,
	CASE WHEN RA_SEXO = 'F' THEN 1 ELSE 0 END F
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
	AND RA_SITFOLH NOT IN ('T')
	GROUP BY RA_FILIAL,RA_MAT,RA_NOME,RA_SEXO,RA_CODFUNC,RA_GRINRAI,RJ_DESC,X5_DESCRI,RA_CC,CTT_DESC01,RV_TIPOCOD,RA_DEFIFIS,RA_BRPDH,RA_TPDEFFI,RA_ADMISSA,RA_DTFIMCT,RJ_MAOBRA,
	RD_PD,RV_DESC,RD_HORAS,RD_VALOR,RA_DEMISSA
	ORDER BY RA_FILIAL, RA_MAT,RD_PD

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