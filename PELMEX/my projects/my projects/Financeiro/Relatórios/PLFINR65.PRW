#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR49    บAutor  ณJuevan Silva     				บ Data ณ 02/08/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Titulos Com NF Devolucao                		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR65()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR65"

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
   

	oReport := TReport():New(cPerg,"Titulos Com NF Devolucao",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Titulos Com NF Devolucao",{"SE1"},aOrdem)
	

	TRCell():New(oSection,"E1_FILORIG"	        ,"SE1","FILORIG","@!",3)
    TRCell():New(oSection,"E1_NUM"	    ,"SE1","NUM","@!",10)
    TRCell():New(oSection,"E1_PREFIXO"	     ,"SE1","PREFIXO","@!",3)
    TRCell():New(oSection,"E1_TIPO"	        ,"SE1","TIPO","@!",3)
    TRCell():New(oSection,"E1_PARCELA"	    ,"SE1","PARCELA","@!",3) 	   
	 TRCell():New(oSection,"E1_VALOR"	     ,"SE1","VALOR","@E 9,999,999,999.99",)	 
    TRCell():New(oSection,"E1_EMISSAO"	     ,"SE1","EMISSAO","@!",10) 
	TRCell():New(oSection,"E1_VENCTO"	   	    ,"SE1","VENCIMENTO","@!",10)
    TRCell():New(oSection,"E1_BAIXA"	   	  ,"SE1","BAIXA","@!",10)
    TRCell():New(oSection,"D1_DOC"	   	      ,"SD1","NOTA","@!",10)
	TRCell():New(oSection,"D1_SERIE"       ,"SD1","SERIE","@!",3)
	TRCell():New(oSection,"D1_EMISSAO"	    	,"SD1","EMISDEV","@!",10)
    TRCell():New(oSection,"E1_CLIENTE"	    	,"SE1","CLIENTE","@!",6)
    TRCell():New(oSection,"E1_NOMCLI"	    	,"SE1","NOME","@!",30)
    TRCell():New(oSection,"E1_VEND1"	    	,"SE1","CODVEND","@!",6)
    TRCell():New(oSection,"A3_NOME"	    	,"SA3","NOMVEND","@!",30)
   
    
    

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

   SELECT E1_FILORIG,E1_NUM,E1_PREFIXO,E1_TIPO,E1_PARCELA,E1_VALOR,E1_EMISSAO,E1_VENCTO,E1_BAIXA,D1_DOC,D1_SERIE,D1_EMISSAO,E1_CLIENTE,E1_NOMCLI,E1_VEND1,A3_NOME
FROM SE1100 SE1 (NOLOCK)
INNER JOIN SA3100 SA3 (NOLOCK) ON E1_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
INNER JOIN (SELECT D1_FILIAL,D1_NFORI,D1_SERIORI,D1_DOC,D1_SERIE,D1_EMISSAO
           FROM SD1100 SD1 (NOLOCK)
       WHERE SD1.D_E_L_E_T_ = ''
       GROUP BY D1_FILIAL,D1_NFORI,D1_SERIORI,D1_DOC,D1_SERIE,D1_EMISSAO)SD1 ON E1_FILORIG = D1_FILIAL AND E1_NUM = D1_NFORI AND E1_PREFIXO = D1_SERIORI
WHERE SE1.D_E_L_E_T_ = ''
AND E1_BAIXA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY E1_FILORIG,E1_NUM,E1_PREFIXO,E1_PARCELA

                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Baixa "    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Dt Baixa "    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Baixa"     ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
