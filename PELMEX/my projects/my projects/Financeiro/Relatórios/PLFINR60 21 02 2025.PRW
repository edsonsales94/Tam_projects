#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR49    บAutor  ณWylliam Silva     				บ Data ณ 19/06/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Contas a Pagar Detalhado                      		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR60()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR60"

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
   

	oReport := TReport():New(cPerg,"Contas a Pagar Detalhado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Contas a Pagar Detalhado",{"SE2"},aOrdem)
	

	TRCell():New(oSection,"STATUS"	        ,"SE2","STATUS","@!",20)
    TRCell():New(oSection,"NATUREZA"	    ,"SE2","NATUREZA","@!",20)
    TRCell():New(oSection,"DESCRICAO"	    ,"SE2","DESCRICAO","@!",35)
    TRCell():New(oSection,"E2_TIPO"	        ,"SE2","TIPO","@!",8)
    TRCell():New(oSection,"E2_NUM"	        ,"SE2","NUM","@!",10)	   
	TRCell():New(oSection,"E2_PREFIXO"	    ,"SE2","PREFIXO","@!",4) 
    TRCell():New(oSection,"E2_PARCELA"	    ,"SE2","PARCELA","@!",4) 
	TRCell():New(oSection,"E2_VALOR"	   	,"SE2","VALOR","@E 9,999,999,999.99")
	TRCell():New(oSection,"E2_SALDO"	   	,"SE2","SALDO","@E 9,999,999,999.99")
    TRCell():New(oSection,"E2_EMISSAO"	   	,"SE2","DATA EMISSAO","@!",10)
    TRCell():New(oSection,"E2_VENCTO"	   	,"SE2","DATA VENCTO","@!",10)
	TRCell():New(oSection,"E2_NUMBOR"	    ,"SE2","NUM.BORDER","@!",8)
	TRCell():New(oSection,"E2_BCOPAG"	    ,"SE2","BANCO","@!",10)
    TRCell():New(oSection,"A2_COD"	        ,"SA2","COD.CLI","@!",8)
    TRCell():New(oSection,"A2_NOME"	    	,"SA2","NOME CLI","@!",35)
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    TRFunction():New(oSection:Cell("E2_VALOR"),"Total valor","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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

SELECT *
FROM (  
SELECT '1 - A PAGAR' STATUS,E2_NATUREZ NATUREZA,ED_DESCRIC DESCRICAO,E2_TIPO,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_VALOR,E2_SALDO,E2_EMISSAO,E2_VENCTO,E2_NUMBOR,E2_BCOPAG,A2_COD,A2_NOME
FROM %Table:SE2% SE2 (NOLOCK)
INNER JOIN %Table:SED% SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
INNER JOIN %Table:SA2% SA1 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA1.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_BAIXA = ''
AND E2_VENCTO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%

UNION

SELECT '2 - PAGO' STATUS,E2_NATUREZ NATUREZA,ED_DESCRIC DESCRICAO,E2_TIPO,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_VALOR,E2_SALDO,E2_EMISSAO,E2_VENCTO,E2_NUMBOR,E2_BCOPAG,A2_COD,A2_NOME
FROM %Table:SE2% SE2 (NOLOCK)
INNER JOIN %Table:SED% SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
INNER JOIN %Table:SA2% SA1 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA1.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_BAIXA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%

UNION

SELECT '2- PAGO' STATUS,E2_NATUREZ NATUREZA,ED_DESCRIC DESCRICAO,E2_TIPO,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_VALOR,E2_SALDO,E2_EMISSAO,E2_VENCTO,E2_NUMBOR,E2_BCOPAG,A2_COD,A2_NOME
FROM %Table:SE2% SE2 (NOLOCK)
INNER JOIN %Table:SED% SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
INNER JOIN %Table:SA2% SA1 (NOLOCK) ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA1.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_TIPO IN ('PA')
AND E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB 
WHERE CAST(SUBSTRING(STATUS,1,1) AS INT) = %Exp:MV_PAR03%

ORDER BY 1,3

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("Data Vencto "    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Data Vencto "    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("Status: ",20)+"?","","","mv_ch3","N",1,0,0,"C","","","","","mv_par03","1 - A PAGAR","","","","2 - PAGO")
//u_InPutSX1(cPerg,"03",PADR("De Baixa"     ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
