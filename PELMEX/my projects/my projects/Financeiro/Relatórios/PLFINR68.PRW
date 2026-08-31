#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR68    ºAutor  ³Kledson Oliveira    				º Data ³ 19/04/2024º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contas a Receber Simples                		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR68()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR68"

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
   

	oReport := TReport():New(cPerg,"Contas a Receber Simples",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Contas a Receber Simples",{"SE1"},aOrdem)
	


    TRCell():New(oSection,"E1_NUM"	    ,"SE1","NUM","@!",10)
    TRCell():New(oSection,"E1_PREFIXO"	     ,"SE1","PREFIXO","@!",3)
    TRCell():New(oSection,"E1_PARCELA"	    ,"SE1","PARCELA","@!",3)
	TRCell():New(oSection,"E1_TIPO"	        ,"SE1","TIPO","@!",3) 	   
	TRCell():New(oSection,"E1_VALOR"	     ,"SE1","VALOR","@E 9,999,999,999.99",)	 
    TRCell():New(oSection,"E1_SALDO"	     ,"SE1","SALDO","@E 9,999,999,999.99",)	
	TRCell():New(oSection,"E1_EMISSAO"	     ,"SE1","EMISSAO","@!",10) 
	TRCell():New(oSection,"E1_VENCTO"	   	    ,"SE1","VENCIMENTO","@!",10)
    TRCell():New(oSection,"E1_BAIXA"	   	  ,"SE1","BAIXA","@!",10)
	TRCell():New(oSection,"E1_HIST"	   	  ,"SE1","HISTORICO","@!",40)
	TRCell():New(oSection,"A1_COD"	   	  ,"SA1","CODCLIEN","@!",6)
	TRCell():New(oSection,"A1_NOME"	   	  ,"SA1","NOME","@!",30)
	TRCell():New(oSection,"A1_MUN"	   	  ,"SA1","MUNICIPIO","@!",20)
	TRCell():New(oSection,"A3_COD"	   	  ,"SA3","CODVEND","@!",6)
	TRCell():New(oSection,"A3_NOME"	    	,"SA3","VENDEDOR","@!",30)

    //TRCell():New(oSection,"D1_DOC"	   	      ,"SD1","NOTA","@!",10)
	//TRCell():New(oSection,"D1_SERIE"       ,"SD1","SERIE","@!",3)
	//TRCell():New(oSection,"D1_EMISSAO"	    	,"SD1","EMISDEV","@!",10)
    //TRCell():New(oSection,"E1_CLIENTE"	    	,"SE1","CLIENTE","@!",6)
    //TRCell():New(oSection,"E1_NOMCLI"	    	,"SE1","NOME","@!",30)
    //TRCell():New(oSection,"E1_VEND1"	    	,"SE1","CODVEND","@!",6)
    //TRCell():New(oSection,"A3_NOME"	    	,"SA3","NOMVEND","@!",30)
   
    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    //TRFunction():New(oSection:Cell("TOTAL"),"Total Geral","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	oReport:SetTotalInLine(.F.)

	//Quebra por Seção
	oSection:SetPageBreak(.T.)
	oSection:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   

SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_VALOR,E1_SALDO,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_HIST,A1_COD,A1_NOME,A1_MUN,A3_COD,A3_NOME
    FROM SE1100 SE1 (NOLOCK)
        INNER JOIN SA1100 SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
            LEFT JOIN SA3100 SA3 (NOLOCK) ON E1_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
    WHERE SE1.D_E_L_E_T_ = ''
        AND E1_VENCTO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND E1_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                AND E1_SALDO > 0
ORDER BY E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_PARCELA

                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Vencimento  ",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Vencimento  ",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Vendedor De  ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Vendedor Até ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04")
	//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
	//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
