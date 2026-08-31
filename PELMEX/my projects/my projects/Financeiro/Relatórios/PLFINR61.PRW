#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR61    บAutor  ณWylliam Silva     				บ Data ณ 19/06/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Cartoes em aberto                             		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR61()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR61"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oFunction1
    Local oBreak
	Local aOrdem  := {"FILIAL"}
   

	oReport := TReport():New(cPerg,"Cartoes em aberto",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Cartoes em aberto",{"SE1"},aOrdem)
	

	TRCell():New(oSection,"NUM_TITULO"      ,"SE1","NUM_TITULO","@!",10)
    TRCell():New(oSection,"PREF"	        ,"SE1","PREFIXO","@!",6)
    TRCell():New(oSection,"TIPO"	        ,"SE1","TIPO","@!",8)
    TRCell():New(oSection,"CLINTE"	        ,"SE1","COD_CLINTE","@!",10)
    TRCell():New(oSection,"PARCELA"	        ,"SE1","PARCELA","@!",10)	   
	TRCell():New(oSection,"DTEMISSAO"	    ,"SE1","DTEMISSAO","@!",10) 
    TRCell():New(oSection,"DTVENCTO"	    ,"SE1","DTVENCTO","@!",4) 
	TRCell():New(oSection,"VALOR"	        ,"SE1","VALOR","@E 9,999,999,999.99")
    TRCell():New(oSection,"NSU"	         	,"SE1","NSU","@!",12)
    TRCell():New(oSection,"AUTORIZ"	     	,"SE1","DAUTORIZ","@!",12)
	/*TRCell():New(oSection,"E2_NUMBOR"	    ,"SE2","AUTORIZ","@!",12)
    TRCell():New(oSection,"A2_COD"	        ,"SA2","COD.CLI","@!",8)
    TRCell():New(oSection,"A2_NOME"	    	,"SA2","NOME CLI","@!",35)*/
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    TRFunction():New(oSection:Cell("VALOR"),"VALOR","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	oReport:SetTotalInLine(.F.)

	//Quebra por Se็ใo
	oSection:SetPageBreak(.T.)
	oSection:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   

SELECT E1_NUM NUM_TITULO,E1_PREFIXO PREF,E1_TIPO TIPO,E1_CLIENTE CLINTE,E1_PARCELA PARCELA,CONVERT(VARCHAR,CAST(E1_EMISSAO AS DATE),103) DTEMISSAO,
        CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103) DTVENCTO,E1_VALOR VALOR,E1_NSUTEF NSU,E1_CARTAUT AUTORIZ
FROM SE1100 SE1
WHERE SE1.D_E_L_E_T_ =''
AND E1_TIPO IN ('CC','CD')
AND E1_BAIXA = ''
AND E1_VENCTO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY E1_NUM,E1_PARCELA  

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("Data Ini "    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Data Fim "    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Baixa"     ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
