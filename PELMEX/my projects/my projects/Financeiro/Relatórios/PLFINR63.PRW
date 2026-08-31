#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR49    ºAutor  ³Wylliam Silva     				º Data ³ 19/06/2023º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contas a Pagar Detalhado                      		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR63()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR63"

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
   

	oReport := TReport():New(cPerg,"Titulos a receber Vendedor Pel",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Titulos a receber Vendedor Pel",{"SE2"},aOrdem)

	TRCell():New(oSection,"E1_VEND1"	    ,"SE1","COD_VEND","@!",5)
	TRCell():New(oSection,"A3_NOME"	        ,"SA3","NOME_VED","@!",25)
	TRCell():New(oSection,"PRF"	            ,"SE1","PRF","@!",3)
    TRCell():New(oSection,"NOTA"	        ,"SE1","NOTA","@!",9)
    TRCell():New(oSection,"PARCELA"	       ,"SE1","PARCELA","@!",3)
    TRCell():New(oSection,"TIPO"	        ,"SE1","TIPO","@!",8)
    TRCell():New(oSection,"COD_CLIENTE"	    ,"SE1","COD_CLIENTE","@!",6)	   
	TRCell():New(oSection,"RAZAOSOCIAL"	    ,"SA1","RAZAOSOCIAL","@!",35) 
    TRCell():New(oSection,"NOME_CLIENTE"	,"SE1","NOME_CLIENTE","@!",35) 
	TRCell():New(oSection,"CIDADE"	        ,"SA1","CIDADE","@!",10)
    TRCell():New(oSection,"EMISSAO"	     	,"SE1","DATA EMISSAO","@!",10)
    TRCell():New(oSection,"VENCIMENTO"	   	,"SE1","DATA VENCTO","@!",10)
	TRCell():New(oSection,"VALOR"	     	,"SE1","VALOR","@E 9,999,999,999.99")
    TRCell():New(oSection,"PAGLIQ"	     	,"SE1","PAGLIQ","@E 9,999,999,999.99")
    TRCell():New(oSection,"SALDO"	     	,"SE1","SALDO","@E 9,999,999,999.99")
    TRCell():New(oSection,"JUROS"	     	,"SE1","JUROS","@E 9,999,999,999.99")
    TRCell():New(oSection,"SALDO_CORR"	    ,"SE1","SALDO_CORR","@E 9,999,999,999.99")
	TRCell():New(oSection,"NATUREZA"	    ,"SE1","NATUREZA","@!",12)
    TRCell():New(oSection,"HISTORICO"	    ,"SE1","HISTORICO","@!",35)
    TRCell():New(oSection,"ATRASO"	    	,"SE1","ATRASO","@!",5)
    

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

    SELECT E1_VEND1,A3_NOME,E1_PREFIXO PRF,E1_NUM NOTA,E1_PARCELA PARCELA,E1_TIPO TIPO, E1_CLIENTE COD_CLIENTE,A1_NOME RAZAOSOCIAL, E1_NOMCLI NOME_CLIENTE,A1_MUN CIDADE,
        CONVERT(VARCHAR,CAST (E1_EMISSAO AS DATE),103) EMISSAO,CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103) VENCIMENTO,E1_VALOR VALOR,E1_VALLIQ PAGLIQ,
        E1_SALDO SALDO,E1_JUROS JUROS,E1_BASCOM1 SALDO_CORR, E1_NATUREZ NATUREZA,E1_HIST HISTORICO,DATEDIFF(DAY, E1_VENCTO, GETDATE()) ATRASO
        FROM %Table:SE1% (NOLOCK)SE1
        INNER JOIN %Table:SA1% (NOLOCK) SA1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ =''
		LEFT JOIN SA3100 (NOLOCK) SA3 ON A3_COD = E1_VEND1 AND SA3.D_E_L_E_T_ =''
        WHERE SE1.D_E_L_E_T_ =''
        AND  E1_SALDO > 0
        AND E1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        AND E1_VENCTO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
        AND E1_VEND1 BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
        ORDER BY E1_NUM,E1_VENCTO

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Dt Emissao Ini"    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissao Fim"    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Dt Venc. Ini"     ,20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Ate Dt Venc. Fim"    ,20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
u_InPutSX1(cPerg,"05",PADR("De Vendedor"         ,20)+"?","","","mv_ch5","C",3,5,0,"G","","SA3","","","mv_par05") 
u_InPutSX1(cPerg,"06",PADR("Ate Vendedor"        ,20)+"?","","","mv_ch6","C",3,5,0,"G","","SA3","","","mv_par06")

Return
