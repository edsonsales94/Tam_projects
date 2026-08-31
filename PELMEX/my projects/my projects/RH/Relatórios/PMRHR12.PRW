#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMRHR12  บAutor  ณKledson Oliveira    				บ Data ณ  21/11/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   FUNCIONARIOS DESLIGADOS                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR12()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR12"

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

	oReport := TReport():New(cPerg,"FUNCIONARIOS DESLIGADOS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"FUNCIONARIOS DESLIGADOS",{"SRA"},aOrdem) 

    TRCell():New(oSection,"EMPRESA",		"SYS","Empresa","@!",8)
	TRCell():New(oSection,"M0_FILIAL",		"SYS","Filial","@!",15)
	TRCell():New(oSection,"RA_MAT",			"SRA","Matricula","@!",4)
    TRCell():New(oSection,"RA_NOME",		"SRA","Nome","@!",30)
	TRCell():New(oSection,"RG_TIPORES",		"SRG","CodDes","@!",2)
	TRCell():New(oSection,"C8O_DESCRI",		"C8O","MotivoDes","@!",220)
	TRCell():New(oSection,"RA_ADMISSA",		"SRA","Dt. Admissao","@!",10)
	TRCell():New(oSection,"RA_DEMISSA",		"SRA","DtDemissao","@!",10)
	TRCell():New(oSection,"RJ_DESC",		"SRJ","DescFuncao","@!",20)
	TRCell():New(oSection,"CTT_DESC01",		"CTT","CentroCusto","@!",20)
	TRCell():New(oSection,"RA_CIC",			"SRA","CPF","@!",11)
	TRCell():New(oSection,"RA_RG",			"SRA","RG","@!",15)
	TRCell():New(oSection,"RA_NASC",		"SRA","DtNasc","@!",10)
	TRCell():New(oSection,"E2_HIST",		"SRA","Historico Titulo","@!",40)
	TRCell():New(oSection,"E2_VALOR",			"SRA","Valor","@E 999,999,999.999")
	//TRCell():New(oSection,"RA_SALARIO",		"SRA","Salario","@E 999,999,999",)

	
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%


SELECT EMPRESA, M0_FILIAL, RA_MAT, RA_NOME, RG_TIPORES, C8O_DESCRI, RA_ADMISSA, RA_DEMISSA, RJ_DESC, CTT_DESC01, RA_CIC, RA_RG, RA_NASC, E2_HIST, E2_VALOR  
FROM (
SELECT '10 - PELMEX' EMPRESA, M0_CODIGO,
M0_NOME, RA_FILIAL, M0_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_RG, RA_NASC, RA_ADMISSA, RA_DEMISSA, RA_CODFUNC, RJ_DESC, RA_CC, CTT_DESC01, RA_SALARIO, RG_TIPORES, C8O_DESCRI, E2_HIST, E2_VALOR
FROM SRA100 SRA 
INNER JOIN SRJ100 SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ = '' 
    AND RJ_FILIAL = RA_FILIAL
INNER JOIN CTT100 CTT ON CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SYS ON M0_CODFIL = RA_FILIAL AND M0_CODIGO = '10'
INNER JOIN 
(
    SELECT RG_FILIAL, RG_MAT, RG_TIPORES, RG_DATADEM, C8O_DESCRI
    FROM SRG100 SRG
    INNER JOIN C8O100 C8O ON C8O_CODIGO = RG_TIPORES AND C8O.D_E_L_E_T_ = ''
    WHERE SRG.D_E_L_E_T_ = '' 
)SRG ON RG_MAT = RA_MAT AND RG_DATADEM = RA_DEMISSA AND RG_FILIAL = RA_FILIAL
LEFT JOIN SA2100 SA2 ON RTRIM(RA_CIC) = RTRIM(A2_CGC) AND SA2.D_E_L_E_T_ = ''
LEFT JOIN SE2100 SE2 ON E2_FORNECE = A2_COD AND SE2.D_E_L_E_T_ = ''
WHERE SRA.D_E_L_E_T_ = ''
AND RA_FILIAL BETWEEN '' AND 'ZZ'
AND RA_DEMISSA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
GROUP BY  M0_CODIGO,
M0_NOME, RA_FILIAL, M0_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_RG, RA_NASC, RA_ADMISSA, RA_DEMISSA, RA_CODFUNC, RJ_DESC, RA_CC, CTT_DESC01, RA_SALARIO, RG_TIPORES, C8O_DESCRI, E2_HIST, E2_VALOR

UNION

SELECT '20 - AMAZON' EMPRESA, M0_CODIGO,
M0_NOME, RA_FILIAL, M0_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_RG, RA_NASC, RA_ADMISSA, RA_DEMISSA, RA_CODFUNC, RJ_DESC, RA_CC, CTT_DESC01, RA_SALARIO, RG_TIPORES, C8O_DESCRI,  E2_HIST, E2_VALOR
FROM SRA200 SRA2 
INNER JOIN SRJ200 SRJ2 ON RJ_FUNCAO = RA_CODFUNC AND SRJ2.D_E_L_E_T_ = '' 
    AND RJ_FILIAL = RA_FILIAL
INNER JOIN CTT200 CTT2 ON CTT_CUSTO = RA_CC AND CTT2.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SYS ON M0_CODFIL = RA_FILIAL AND M0_CODIGO = '20'
INNER JOIN 
(
    SELECT RG_FILIAL, RG_MAT, RG_TIPORES, RG_DATADEM
    FROM SRG200 SRG1
    WHERE SRG1.D_E_L_E_T_ = '' 
)SRG ON RG_MAT = RA_MAT AND RG_DATADEM = RA_DEMISSA
INNER JOIN 
(
    SELECT C8O_CODIGO, C8O_DESCRI
    FROM C8O200 C8O2
    WHERE C8O2.D_E_L_E_T_ = ''
)C8O ON C8O_CODIGO = RG_TIPORES
LEFT JOIN SA2200 SA2 ON RTRIM(RA_CIC) = RTRIM(A2_CGC) AND SA2.D_E_L_E_T_ = ''
LEFT JOIN SE2200 SE2 ON E2_FORNECE = A2_COD AND SE2.D_E_L_E_T_ = ''
WHERE SRA2.D_E_L_E_T_ = ''
AND RA_FILIAL BETWEEN '' AND 'ZZ'
AND RA_DEMISSA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
GROUP BY  M0_CODIGO,
M0_NOME, RA_FILIAL, M0_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_RG, RA_NASC, RA_ADMISSA, RA_DEMISSA, RA_CODFUNC, RJ_DESC, RA_CC, CTT_DESC01, RA_SALARIO, RG_TIPORES, C8O_DESCRI, E2_HIST, E2_VALOR

)TB


GROUP BY EMPRESA, M0_FILIAL, RA_MAT, RA_NOME, RG_TIPORES, C8O_DESCRI, RA_CIC, RA_RG, RA_NASC, RA_ADMISSA, RA_DEMISSA, RJ_DESC, CTT_DESC01, E2_HIST, E2_VALOR 
ORDER BY CTT_DESC01 ASC


EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De Dt Desligamento:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Desligamento:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Filial   ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par03")
	//u_InPutSX1(cPerg,"04",PADR("Ate Filial   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return

