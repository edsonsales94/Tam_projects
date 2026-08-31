#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMRHR13  ºAutor  ³Kledson Oliveira    				º Data ³  10/12/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Programacao de Ferias(Customizado)                     			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMRHR13()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR13"

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

	oReport := TReport():New(cPerg,"Programacao de Ferias(Customizado)",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Programacao de Ferias(Customizado)",{"SRA"},aOrdem) 

    TRCell():New(oSection,"RA_FILIAL",		"SRA","Nº Filial","@!",2)
	TRCell():New(oSection,"M0_FILIAL",		"SYS","Filial","@!",25)
	TRCell():New(oSection,"CTT_DESC01",		"CTT","CentroCusto","@!",20)
	TRCell():New(oSection,"RA_MAT",		    "SRA","Matricula","@!",10)
    TRCell():New(oSection,"RA_NOME",		"SRA","Nome","@!",30)
	TRCell():New(oSection,"RJ_DESC",		"SRJ","DescFuncao","@!",20)
	TRCell():New(oSection,"DT_ADMISSA",		"SRA","DtAdmissao","@!",10)
	TRCell():New(oSection,"DT_BASE",		"SRA","DtBase","@!",10)
	TRCell():New(oSection,"DT_IDEAL",		"SRA","DtLimiteIdeal","@!",10)
	TRCell():New(oSection,"DT_MAXIMA",		"SRA","DtLimiteMaxima","@!",10)
	//TRCell():New(oSection,"RA_MAT",			"SRA","Matricula","@!",4)
	//TRCell():New(oSection,"M0_NOME",		"SYS","Empresa","@!",16)
    //TRCell():New(oSection,"RA_FILIAL",		"SRA","Nº Filial","@!",2)
	//TRCell():New(oSection,"RG_TIPORES",		"SRG","CodDes","@!",2)
	//TRCell():New(oSection,"C8O_DESCRI",		"C8O","MotivoDes","@!",220)
	//TRCell():New(oSection,"RA_DEMISSA",		"SRA","DtDemissao","@!",10)
	//TRCell():New(oSection,"RA_CIC",			"SRA","CPF","@!",11)
	//TRCell():New(oSection,"RA_RG",			"SRA","RG","@!",15)
	//TRCell():New(oSection,"RA_NASC",		"SRA","DtNasc","@!",10)
	//TRCell():New(oSection,"RA_CODFUNC",		"SRA","CodFuncao","@!",5)
	//TRCell():New(oSection,"RA_CC",			"SRA","CodCC","@!",9)
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


SELECT *
FROM(
SELECT RA_FILIAL,M0_FILIAL,CTT_DESC01,RA_MAT,RA_NOME,RJ_DESC,CONVERT(VARCHAR,CAST(RA_ADMISSA AS DATE),103)DT_ADMISSA,CONVERT(VARCHAR,CAST(RF_DATABAS AS DATE),103)DT_BASE,
       CONVERT(VARCHAR,CAST(DATEADD(MONTH,13,RF_DATABAS) AS DATE),103)DT_IDEAL,
	   CONVERT(VARCHAR,CAST(DATEADD(DAY,685,RF_DATABAS) AS DATE),103)DT_MAXIMA
FROM SRF200 SRF (NOLOCK)
INNER JOIN SRA200 SRA (NOLOCK) ON RF_FILIAL = RA_FILIAL AND RF_MAT = RA_MAT AND RA_CC NOT IN ('3050','20000','1000') AND SRA.D_E_L_E_T_ = '' AND RA_DEMISSA = ''
INNER JOIN SRJ200 SRJ (NOLOCK) ON RA_FILIAL = RJ_FILIAL AND RA_CODFUNC = RJ_FUNCAO
INNER JOIN CTT200 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND M0_CODIGO = '20' AND SYS.D_E_L_E_T_ = ''
WHERE SRF.D_E_L_E_T_ = ''
AND RF_STATUS = '1'
AND RF_DFERVAT > 0
UNION
SELECT RA_FILIAL,M0_FILIAL,CTT_DESC01,RA_MAT,RA_NOME,RJ_DESC,CONVERT(VARCHAR,CAST(RA_ADMISSA AS DATE),103)DT_ADMISSA,CONVERT(VARCHAR,CAST(RF_DATABAS AS DATE),103)DT_BASE,
       CONVERT(VARCHAR,CAST(DATEADD(MONTH,13,RF_DATABAS) AS DATE),103)DT_IDEAL,
	   CONVERT(VARCHAR,CAST(DATEADD(DAY,685,RF_DATABAS) AS DATE),103)DT_MAXIMA
FROM SRF100 SRF (NOLOCK)
INNER JOIN SRA100 SRA (NOLOCK) ON RF_FILIAL = RA_FILIAL AND RF_MAT = RA_MAT AND RA_CC NOT IN ('21000','20000') AND SRA.D_E_L_E_T_ = '' AND RA_DEMISSA = ''
INNER JOIN SRJ100 SRJ (NOLOCK) ON RA_FILIAL = RJ_FILIAL AND RA_CODFUNC = RJ_FUNCAO
INNER JOIN CTT100 CTT (NOLOCK) ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND M0_CODIGO = '10' AND SYS.D_E_L_E_T_ = ''
WHERE SRF.D_E_L_E_T_ = ''
AND RF_STATUS = '1'
AND RF_DFERVAT > 0

)TB
ORDER BY M0_FILIAL,RA_FILIAL,CTT_DESC01, RJ_DESC, DT_ADMISSA ASC 

EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    //u_InPutSX1(cPerg,"01",PADR("De Dt Desligamento:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	//u_InPutSX1(cPerg,"02",PADR("Ate Dt Desligamento:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Filial   ",20)+"?","","","mv_ch3","C",2,0,0,"G","","SM0","","","mv_par03")
	//u_InPutSX1(cPerg,"04",PADR("Ate Filial   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","SM0","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return

