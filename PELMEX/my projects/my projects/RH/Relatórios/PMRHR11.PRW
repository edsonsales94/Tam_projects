#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMRHR11  บAutor  ณKledson Oliveira    				บ Data ณ  10/11/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   LISTA DE FUNCIONARIOS ATIVOS                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR11()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR11"

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

	oReport := TReport():New(cPerg,"FUNCIONARIOS ATIVOS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"FUNCIONARIOS ATIVOS",{"SRA"},aOrdem) 

    TRCell():New(oSection,"M0_CODIGO",		"SYS","Nบ Emp","@!",2)
	TRCell():New(oSection,"M0_NOME",		"SYS","Empresa","@!",16)
    TRCell():New(oSection,"RA_FILIAL",		"SRA","Nบ Filial","@!",2)
	TRCell():New(oSection,"M0_FILIAL",		"SYS","Filial","@!",30)
	TRCell():New(oSection,"RA_MAT",			"SRA","Matricula","@!",4)
    TRCell():New(oSection,"RA_NOME",		"SRA","Nome","@!",30)
	TRCell():New(oSection,"RA_CIC",			"SRA","CPF","@!",11)
	TRCell():New(oSection,"RA_RG",			"SRA","RG","@!",15)
	TRCell():New(oSection,"RA_NASC",		"SRA","DtNasc","@!",10)
	TRCell():New(oSection,"RA_CODFUNC",		"SRA","CodFuncao","@!",5)
	TRCell():New(oSection,"RJ_DESC",		"SRJ","DescFuncao","@!",20)
	TRCell():New(oSection,"RA_CC",			"SRA","CodCC","@!",9)
	TRCell():New(oSection,"CTT_DESC01",		"CTT","CentroCusto","@!",20)
	TRCell():New(oSection,"RA_ADMISSA",		"SRA","DtAdmissao","@!",10)
	TRCell():New(oSection,"RA_SALARIO",		"SRA","Salario","@E 999,999,999",)

	
	
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


SELECT M0_CODIGO, M0_NOME, RA_FILIAL, M0_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_RG, RA_NASC, RA_ADMISSA, RA_CODFUNC, RJ_DESC, RA_CC, CTT_DESC01, RA_SALARIO
FROM (

SELECT CASE WHEN M0_CODIGO = '10' THEN 1
            ELSE 2 END EMPRESA, M0_CODIGO,
M0_NOME, RA_FILIAL, M0_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_RG, RA_NASC, RA_ADMISSA, RA_CODFUNC, RJ_DESC, RA_CC, CTT_DESC01, RA_SALARIO
FROM SRA100 SRA 
LEFT JOIN SRJ100 SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ = '' 
    AND RJ_FILIAL = RA_FILIAL
LEFT JOIN CTT100 CTT ON CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SYS ON M0_CODFIL = RA_FILIAL AND M0_CODIGO = '10'
WHERE SRA.D_E_L_E_T_ = ''
AND RA_FILIAL BETWEEN '' AND 'ZZ'
AND RA_DEMISSA = '' 

UNION

SELECT CASE WHEN M0_CODIGO = '10' THEN 1
            ELSE 2 END EMPRESA, M0_CODIGO,
M0_NOME, RA_FILIAL, M0_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_RG, RA_NASC, RA_ADMISSA, RA_CODFUNC, RJ_DESC, RA_CC, CTT_DESC01, RA_SALARIO
FROM SRA200 SRA2 
LEFT JOIN SRJ200 SRJ2 ON RJ_FUNCAO = RA_CODFUNC AND SRJ2.D_E_L_E_T_ = '' 
    AND RJ_FILIAL = RA_FILIAL
LEFT JOIN CTT200 CTT2 ON CTT_CUSTO = RA_CC AND CTT2.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SYS ON M0_CODFIL = RA_FILIAL AND M0_CODIGO = '20'
WHERE SRA2.D_E_L_E_T_ = ''
AND RA_FILIAL BETWEEN '' AND 'ZZ'
AND RA_DEMISSA = ''  
)TB
WHERE EMPRESA IN (%Exp:MV_PAR01%, %Exp:MV_PAR02%)
ORDER BY CTT_DESC01 ASC

EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De Empresa:" ,20)+"?","","","mv_ch1","N",1,0,0,"C","","","","","mv_par01","10 - Pelmex","","","","20 - Amazon")//,"","","","","3 - Fabr/Franq ")
	u_InPutSX1(cPerg,"02",PADR("Ate Empresa:",20)+"?","","","mv_ch2","N",1,0,0,"C","","","","","mv_par02","10 - Pelmex","","","","20 - Amazon")
	//u_InPutSX1(cPerg,"03",PADR("De Filial   ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par03")
	//u_InPutSX1(cPerg,"04",PADR("Ate Filial   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return

