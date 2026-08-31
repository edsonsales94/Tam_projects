#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLRHR03    ºAutor  ³Stan Lee Lopes     				º Data ³  28/02/20 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de Funcionários por Período									 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLRHR03()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLRHR03"

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

	oReport := TReport():New(cPerg,"Funcionarios por Periodo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira seção
	oSection := TRSection():New(oReport,"Funcionários por Periodo",{"SRA"},aOrdem) 


	TRCell():New(oSection,"RA_FILIAL"	        		,"SRA","Filial",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"RA_MAT"	        			,"SRA","Matricula",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"RA_CC"	        			,"SRA","Centro de Custo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_NOME"	        			,"SRA","Nome do Funcionario",/*Mascara*/,/*Tamanho*/)  	
	TRCell():New(oSection,"RA_SEXO"	        			,"SRA","Sexo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_CIC"	        			,"SRA","CPF",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_PIS"	        			,"SRA","PIS",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_SALARIO"	        		,"SRA","Salário","@E 99,999,999,999.99",/*Tamanho*/)
	TRCell():New(oSection,"RA_ADMISSA"	        		,"SRA","Dt.Admissão",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RA_DEMISSA"	        		,"SRA","Dt.Demissão",/*Mascara*/,/*Tamanho*/)
	//Totalizador                                                                                  


	TRFunction():New(oSection:Cell("RA_MAT"),"TOTAL","COUNT",,,"@E 9,999,999,999",,.F.,.T.)  
	TRFunction():New(oSection:Cell("RA_SALARIO"),"TOTAL","SUM",,,"@E 999,999,999,999",,.F.,.T.)
	/*
	TRFunction():New(oSection:Cell("M"),"Masculino","SUM",,,,,.F.,.T.)  
	TRFunction():New(oSection:Cell("F"),"Feminino","SUM",,,,,.F.,.T.)  
	*/
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENÇA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
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
	//	cOrdem := "A1_COD"                      MIMIM ·
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

		SELECT RA_FILIAL,RA_MAT,RA_CC,RA_SEXO,RA_NOME,RA_CIC,RA_PIS,RA_SALARIO,RA_ADMISSA,RA_DEMISSA
		FROM %Table:SRA% SRA
		WHERE SRA.D_E_L_E_T_ = ''
		AND RA_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND RA_CC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND RA_ADMISSA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% 
		AND ((RA_DEMISSA BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08% OR RA_DEMISSA = '') OR RA_DEMISSA >= %Exp:MV_PAR08%)
		ORDER BY RA_FILIAL,RA_SEXO,RA_NOME,RA_ADMISSA,RA_DEMISSA

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            

	u_InPutSX1(cPerg,"01",PADR("Filial De    ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Filial Até   ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("C.Custo De    ",20)+"?","","","mv_ch3","C",4,0,0,"G","","CTT","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("C.Custo Até   ",20)+"?","","","mv_ch4","C",4,0,0,"G","","CTT","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Dt.Admissão De   ",20)+"?","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Dt.Admissão Até   ",20)+"?","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Dt.Demissao De   ",20)+"?","","","mv_ch7","D",8,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Dt.Demissao Até   ",20)+"?","","","mv_ch8","D",8,0,0,"G","","","","","mv_par08") 
Return