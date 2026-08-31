#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMRHR09  บAutor  ณKledson Oliveira    				บ Data ณ  09/09/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Periodo de Experiencia                     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMRHR09()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMRHR09"

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

	oReport := TReport():New(cPerg,"Periodo de Experiencia",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Periodo de Experiencia",{"SRA"},aOrdem) 

    TRCell():New(oSection,"EMPRESA"   	    ,"SRA","EMPRESA","@!",7)
	TRCell():New(oSection,"RJ_FILIAL"		      ,"SRJ","Cod","@!",3)
	TRCell():New(oSection,"M0_FILIAL"		    ,"SYS","Filial","@!",30)
    TRCell():New(oSection,"RA_NOME"		     ,"SRA","Nome","@!",30)
	TRCell():New(oSection,"RA_MAT"		     ,"SRA","Matricula","@!",4)
	TRCell():New(oSection,"RA_CC"		     ,"SRA","CodCC","@!",9)
	TRCell():New(oSection,"CTT_DESC01"		  ,"CTT","CentroCusto","@!",20)
	TRCell():New(oSection,"RA_CODFUNC"		     ,"SRA","CodFuncao","@!",5)
	TRCell():New(oSection,"RJ_DESC"		      ,"SRJ","DescFuncao","@!",20)
	TRCell():New(oSection,"RA_ADMISSA"         ,"SRA","DtAdmissao","@!",10)
	TRCell():New(oSection,"RA_VCTOEXP" 	         ,"SRA","VencExp","@!",10)
	TRCell():New(oSection,"RA_VCTEXP2"	    ,"SRA","VencExp2","@!",10)
	//TRCell():New(oSection,"CTT_DESC01"		  ,"CTT","Centrousto","@!",20)		
    //TRCell():New(oSection,"R8_TIPOAFA"	      ,"SR8","R8_TIPOAFA","@!",4) 
	//TRCell():New(oSection,"DESCRICAO"  	     ,"SRA","DESCRICAO","@!",40)
	//TRCell():New(oSection,"R8_CID"		 ,"SR8","R8_CID","@!",3)
	//TRCell():New(oSection,"DIAS"  			,"SRA","DIAS","@!",3)
    //TRCell():New(oSection,"R8_OBSAFAS"  	,"SR8","R8_OBSAFAS","@!",100)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 

	
    
	
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


SELECT 'PELMEX' EMPRESA, RJ_FILIAL, M0_FILIAL, RA_NOME, RA_MAT, RA_CC, CTT_DESC01, 
RA_CODFUNC, RJ_DESC, RA_ADMISSA, RA_VCTOEXP, RA_VCTEXP2
FROM SRA100 SRA
INNER JOIN SRJ100 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL
INNER JOIN CTT100 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '10'
WHERE SRA.D_E_L_E_T_ = '' 
AND RA_MAT BETWEEN '' AND 'ZZZZ'
AND RA_ADMISSA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND RA_DEMISSA = '' 
UNION 
SELECT 'AMAZON' EMPRESA, RJ_FILIAL, M0_FILIAL, RA_NOME, RA_MAT, RA_CC, CTT_DESC01, 
RA_CODFUNC, RJ_DESC, RA_ADMISSA, RA_VCTOEXP, RA_VCTEXP2
FROM SRA200 SRA
INNER JOIN SRJ200 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL
INNER JOIN CTT200 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ''
INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '20'
WHERE SRA.D_E_L_E_T_ = '' 
AND RA_MAT BETWEEN '' AND 'ZZZZ'
AND RA_ADMISSA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND RA_DEMISSA = ''

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("Admissao de:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Admissao ate:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return
