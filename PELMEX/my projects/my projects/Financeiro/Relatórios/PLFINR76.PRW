#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR76    บAutor  ณKledson Oliveira    				บ Data ณ 27/03/2025บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Tit. Pag. por natureza                      		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR76()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR76"

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
   

	oReport := TReport():New(cPerg,"Tit. Pag. por natureza",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Tit. Pag. por natureza",{"SE2"},aOrdem)
	
    
	TRCell():New(oSection,"Empresa"	        ,"SE2","Empresa","@!",8)
	TRCell():New(oSection,"E2_NUM"	        ,"SE2","Titulo","@!",9)
    TRCell():New(oSection,"E2_PREFIXO"	    	,"SE2","Prefixo","@!",3)
    TRCell():New(oSection,"E2_PARCELA"	    ,"SE2","Parcela","@!",3)
    TRCell():New(oSection,"E2_TIPO"	    ,"SE2","Tipo","@!",3)
    TRCell():New(oSection,"E2_VALOR"	        ,"SE2","Valor","@E 9,999,999,999.99")
    TRCell():New(oSection,"E2_VALLIQ"	        ,"SE2","Val. Liquido","@E 9,999,999,999.99")	   
	TRCell():New(oSection,"E2_SALDO"	    ,"SE2","Saldo","@E 9,999,999,999.99")
    TRCell():New(oSection,"DT_EMISSAO"	    ,"SE2","Dt. Emissao","@!",11) 
	TRCell():New(oSection,"DT_VENCTO"	   	,"SE2","Dt. Vencto","@!",11)
	TRCell():New(oSection,"DT_BAIXA"	   	,"SE2","Dt. Baixa","@!",11)
    TRCell():New(oSection,"E2_FORNECE"	   	,"SE2","Cod. Fornec.","@!",7)
	TRCell():New(oSection,"E2_LOJA"	    ,"SE2","Loja","@!",2)
	TRCell():New(oSection,"E2_NOMFOR"	    ,"SE2","Nome Fornec. ","@!",30)
    TRCell():New(oSection,"E2_NATUREZ"	   	,"SE2","Natureza","@!",10)
	TRCell():New(oSection,"ED_DESCRIC"	    ,"SE2","Desc. Nat.","@!",30)
	TRCell():New(oSection,"E2_HIST"	    ,"SE2","Historico","@!",40)
    

//SELECT 'PELMEX' Empresa,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_VALOR,E2_VALLIQ,E2_SALDO,
    //CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO,
    //CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO,
    //CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA,
    //E2_FORNECE,E2_LOJA,E2_NOMFOR,
	//E2_NATUREZ,ED_DESCRIC,E2_HIST	

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	

    //TRFunction():New(oSection:Cell("E2_VALOR"),"Total valor","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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
FROM(
SELECT 'PELMEX' Empresa,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_VALOR,E2_VALLIQ,E2_SALDO,
       CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO,
     CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO,
     CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA,
     E2_FORNECE,E2_LOJA,E2_NOMFOR,
       E2_NATUREZ,ED_DESCRIC,E2_HIST
FROM SE2100 SE2 (NOLOCK)
INNER JOIN SED100 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_NOMFOR NOT LIKE 'AMAZON MOT%'
AND E2_VENCTO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
UNION
SELECT 'AMAZON' Empresa,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_VALOR,E2_VALLIQ,E2_SALDO,
       CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO,
     CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO,
     CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA,
     E2_FORNECE,E2_LOJA,E2_NOMFOR,
       E2_NATUREZ,ED_DESCRIC,E2_HIST
FROM SE2200 SE2 (NOLOCK)
INNER JOIN SED200 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
WHERE SE2.D_E_L_E_T_ = ''
AND E2_VENCTO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
ORDER BY 1,CONVERT(VARCHAR,CAST(DT_VENCTO AS DATE),112),E2_NUM,E2_PREFIXO

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("Data Vcto "    ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Data Vcto ate "    ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("Status: ",20)+"?","","","mv_ch3","N",1,0,0,"C","","","","","mv_par03","1 - A PAGAR","","","","2 - PAGO")
//u_InPutSX1(cPerg,"04",PADR("De Fornecedor: ",20)+"?","","","mv_ch4","N",1,0,0,"C","","","","","mv_par04","1 - Amazon","","","","2 - Outros Forn.")
//u_InPutSX1(cPerg,"05",PADR("Ate Fornecedor: ",20)+"?","","","mv_ch5","N",1,0,0,"C","","","","","mv_par05","1 - Amazon","","","","2 - Outros Forn.")

//u_InPutSX1(cPerg,"03",PADR("De Baixa"     ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
