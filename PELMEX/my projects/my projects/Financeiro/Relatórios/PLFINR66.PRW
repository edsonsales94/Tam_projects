#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR66    บAutor  ณJuevan Silva     				บ Data ณ 30/10/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio CTT                 		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR66()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR66"

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
   

	oReport := TReport():New(cPerg,"Relatorio CTT",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relatorio CTT",{"CTT"},aOrdem)
	
    TRCell():New(oSection,"CCT_DTPAG"	        ,"CTT","DATA","@!",10)
	TRCell():New(oSection,"CCT_BANCO"	        ,"CTT","BANCO","@!",5)
    TRCell():New(oSection,"CCT_AGENCIA"	    ,"CTT","AGENCIA","@!",20)
    TRCell():New(oSection,"CCT_CONTA"	     ,"CTT","CONTA","@!",10)
    TRCell():New(oSection,"CCT_STATUS"	     ,"CTT","STATUS","@!",3)
    TRCell():New(oSection,"TOTAL"	         ,"CTT","TOTAL","@E 9,999,999,999.99",)
    
    /*TRCell():New(oSection,"E1_VALOR"	     ,"SE1","Valor","@E 9,999,999,999.99",)	   
	TRCell():New(oSection,"E1_EMISSAO"	   ,"SE1","Emissao","@!",10) 
    TRCell():New(oSection,"E1_VENCREA"	     ,"SE1","DtVenc.","@!",10) 
	TRCell():New(oSection,"E1_BAIXA"	   	    ,"SE1","DtBaixa","@!",10)
    TRCell():New(oSection,"E1_CLIENTE"	   	  ,"SE1","Cliente","@!",6)
    TRCell():New(oSection,"A1_NOME"	   	      ,"SA1","Nome.Cliente","@!",30)
	TRCell():New(oSection,"A1_NREDUZ"       ,"SA1","Nome Reduz","@!",15)
	TRCell():New(oSection,"A1_MUN"	    	,"SA1","Munic","@!",15)*/
    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    //TRFunction():New(oSection:Cell("TOTAL"),"Total Geral","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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

SELECT CONVERT(VARCHAR,CAST(CCT_DTPAG AS DATE),103)CCT_DTPAG,CCT_BANCO,CCT_AGENCIA,CCT_CONTA,CCT_STATUS,SUM(CCT_VALOR)TOTAL
FROM CCT
GROUP BY CCT_DTPAG,CCT_BANCO,CCT_AGENCIA,CCT_CONTA,CCT_STATUS
ORDER BY CCT_DTPAG,CCT_BANCO,CCT_AGENCIA,CCT_CONTA,CCT_STATUS

                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

//u_InPutSX1(cPerg,"01",PADR("Data Ini "    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
//u_InPutSX1(cPerg,"02",PADR("Data Fim "    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Baixa"     ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
