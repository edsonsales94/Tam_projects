#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR69    บAutor  ณKledson Oliveira    				บ Data ณ 05/12/2024บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Titulos a Pagar com Natureza                		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR69()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR69"

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
   

	oReport := TReport():New(cPerg,"Titulos a Pagar com Natureza",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Titulos a Pagar com Natureza",{"SE2"},aOrdem)
	


    TRCell():New(oSection,"EMPRESA"	    ,"SE2","Empresa","@!",6)
    TRCell():New(oSection,"DT_EMISSAO"	     ,"SE2","Dt.Emissao","@!",11)
    TRCell():New(oSection,"DT_VENCTO"	    ,"SE2","Vencimento","@!",11)
	TRCell():New(oSection,"TITULO"	        ,"SE2","Titulo","@!",9) 	   
	TRCell():New(oSection,"PREFIXO"	     ,"SE2","Prefixo","@!",3) 
	TRCell():New(oSection,"TIPO"	     ,"SE2","Tipo","@!",3) 	 
	TRCell():New(oSection,"PARCELA"	   	    ,"SE2","Parcela","@!",3) 
    TRCell():New(oSection,"VALOR"	     ,"SE2","Valor","@E 9,999,999,999.99",)	
    TRCell():New(oSection,"SALDO"	     ,"SE2","Saldo","@E 9,999,999,999.99",)
    TRCell():New(oSection,"BANCO"	     ,"SE2","Banco","@!",5)
    TRCell():New(oSection,"BAIXA"	   	  ,"SE2","Baixa","@!",11)
    TRCell():New(oSection,"VLR_BAIXA"	     ,"SE2","Vlr Baixa","@E 9,999,999,999.99",)
	TRCell():New(oSection,"FORNECEDOR"	   	  ,"SE2","CodFornec","@!",7)
	TRCell():New(oSection,"NOME"	   	  ,"SE2","NomeFornec","@!",20)
	TRCell():New(oSection,"RSOCIAL"	   	  ,"SA2","Razao Social","@!",30)
	TRCell():New(oSection,"HISTORICO"	   	  ,"SE2","Historico","@!",40)
	TRCell():New(oSection,"E2_NATUREZ"	   	  ,"SE2","Natureza","@!",10)
	TRCell():New(oSection,"ED_DESCRIC"	    	,"SED","Desc.Natureza","@!",30)
	//TRCell():New(oSection,"E1_EMISSAO"	     ,"SE1","EMISSAO","@!",10) 

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

SELECT EMPRESA, CONVERT(VARCHAR,CAST(DT_EMISSAO AS DATE),103)DT_EMISSAO, 
CONVERT(VARCHAR,CAST(DT_VENCTO AS DATE),103)DT_VENCTO,
TITULO, PREFIXO, TIPO, PARCELA, VALOR, SALDO, BANCO,
BAIXA,
VLR_BAIXA,
FORNECEDOR, NOME, RSOCIAL, HISTORICO, E2_NATUREZ, ED_DESCRIC
FROM(
SELECT 'PELMEX' EMPRESA,
    	E2_EMISSAO DT_EMISSAO,
     	E2_VENCTO DT_VENCTO,
     	E2_NUM TITULO,E2_PREFIXO PREFIXO,E2_TIPO TIPO,E2_PARCELA PARCELA,
       	E2_VALOR VALOR,
     	E2_SALDO SALDO,
		E2_BCOPAG BANCO,
     CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR, CAST(E2_BAIXA AS DATE),103) END BAIXA,
	 E2_VALLIQ VLR_BAIXA,
     E2_FORNECE FORNECEDOR,E2_NOMFOR NOME,A2_NOME RSOCIAL,E2_HIST HISTORICO,E2_NATUREZ,ED_DESCRIC
FROM SE2100 SE2 (NOLOCK)
LEFT JOIN SA2100 SA2 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
LEFT JOIN SED100 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_FORNECE != '001343'
AND E2_LOJA != '02'
AND E2_VENCTO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	AND E2_BAIXA BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
UNION
SELECT 'AMAZON' EMPRESA,
       E2_EMISSAO DT_EMISSAO,
     E2_VENCTO DT_VENCTO,
     E2_NUM TITULO,E2_PREFIXO PREFIXO,E2_TIPO TIPO,E2_PARCELA PARCELA,
       E2_VALOR VALOR,
     E2_SALDO SALDO,
	 E2_BCOPAG BANCO,
     CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR, CAST(E2_BAIXA AS DATE),103) END BAIXA,
	 E2_VALLIQ VLR_BAIXA,
     E2_FORNECE FORNECEDOR,E2_NOMFOR NOME,A2_NOME RSOCIAL,E2_HIST HISTORICO,E2_NATUREZ,ED_DESCRIC
FROM SE2200 SE2 (NOLOCK)
LEFT JOIN SA2200 SA2 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
LEFT JOIN SED200 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_VENCTO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	AND E2_BAIXA BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
)TB
ORDER BY EMPRESA, DT_VENCTO ,TITULO,PREFIXO,PARCELA

                                           		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Vencimento  ",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Vencimento  ",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Dt. Baixa  ",20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Dt. Baixa  ",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	//u_InPutSX1(cPerg,"03",PADR("Vendedor De  ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Vendedor At้ ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04")
	//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
	//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
