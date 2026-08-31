#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR49    บAutor  ณJuevan Silva     				บ Data ณ 23/03/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Duplicatas Simples em Aberto            		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR51()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR51"

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
	Local aOrdem      := {"FILIAL"}
   

	oReport := TReport():New(cPerg,"Comissao Bemol Simplificada",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Comissao Bemol Simplificada",{"SE1"},aOrdem)
	
	TRCell():New(oSection,"PERIODO"	        ,"SE1","Periodo","@!",10)
    TRCell():New(oSection,"TOTAL"	        ,"SE1","Total Venda","@E 9,999,999,999.99",)	   
	TRCell():New(oSection,"COMIS1"	  		,"SE1","Comissao 1%","@E 9,999,999,999.99",) 
    TRCell():New(oSection,"COMIS15"	  	    ,"SE1","Comissao 1.5%","@E 9,999,999,999.99",)
	TRCell():New(oSection,"COMIS2"	   	    ,"SE1","Comissao 2%","@E 9,999,999,999.99",)
	TRCell():New(oSection,"REPRESENTANTE"	,"SE1","Comissao Representante","@E 9,999,999,999.99",10)
	TRCell():New(oSection,"CONSULTORA"	  	,"SE1","Comissao Consultora","@E 9,999,999,999.99",10)
    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	//TRFunction():New(oSection:Cell("VALOR"),"Total VALOR:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    /*TRFunction():New(oSection:Cell("JUROS"),"Total Juros:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_IOF_DIA"),"Total IOF Dia","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_IOF_ADICIONAL"),"Total IOF Adicional:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_IOF"),"Total IOF:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_OPERACAO"),"Total Taxa Inclusใo:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_DESCONTADO"),"Total Lํquido:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_LIQUIDO"),"Total a Receber:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
	
    /*oFunction1 := TRFunction():New(oSection:Cell("TOTAL_DUPLICATA") ,"Total Duplicata :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("TOTAL_IOF") ,"Total IOF :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("VAL_OPERACAO") ,"Total IOF :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("GERAL") ,"A Receber:","ONPRINT",oBreak,"","@E 999,999,999.99",{||oSection:aFunction[1]:GetValue() - oSection:aFunction[2]:GetValue() - oSection:aFunction[3]:GetValue()},.F.,.F.,.F.)
    */
    TRFunction():New(oSection:Cell("TOTAL"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("REPRESENTANTE"),"Total Represent","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	oReport:SetTotalInLine(.F.)

	//Quebra por Se็ใo
	//oSection1:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")

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

SELECT PERIODO,TOTAL,
       COMIS1 * 1/100 COMIS1,
       ISNULL(CASE WHEN COMIS15 < 0 THEN 0 ELSE COMIS15 * 1.5/100 END,0) COMIS15,
	   ISNULL(CASE WHEN COMIS2 < 0 THEN 0 ELSE COMIS2 * 2/100 END,0) COMIS2,
	   ISNULL((COMIS1 * 1/100)+CASE WHEN ISNULL(COMIS15,0) < 0 THEN 0 ELSE (ISNULL(COMIS15,0) * 1.5/100)END +CASE WHEN ISNULL(COMIS2,0) < 0 THEN 0 ELSE (ISNULL(COMIS2,0) * 2/100)END,0) REPRESENTANTE,
	   ISNULL(CASE WHEN TOTAL <  3000000 THEN 3248
            WHEN TOTAL >= 3000000 AND TOTAL <= 3500000 THEN TOTAL * 0.12/100
	        WHEN TOTAL >= 3500001 THEN TOTAL * 0.13/100 END,0) CONSULTORA 
FROM(
SELECT CASE WHEN SUBSTRING(E1_BAIXA,4,7) = '' THEN '' ELSE SUBSTRING(E1_BAIXA,4,7)END PERIODO,SUM(E1_VALOR)TOTAL,
       CASE WHEN SUM(E1_VALOR) <= 1500000 THEN SUM(E1_VALOR) ELSE 1500000 END COMIS1,
       CASE WHEN SUM(E1_VALOR) >= 1500001 AND SUM(E1_VALOR) <= 2000000 THEN SUM(E1_VALOR)-1500000 ELSE (2000000-1500001) END COMIS15,
	   CASE WHEN SUM(E1_VALOR) >= 2000001 THEN (SUM(E1_VALOR)-2000001) END COMIS2
FROM(
SELECT E1_NUM,E1_PREFIXO,E1_TIPO,E1_PARCELA,E1_VALOR,
	   E1_EMISSAO,E1_VENCREA,CASE WHEN E1_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E1_BAIXA AS DATE),103)END E1_BAIXA,
	   E1_CLIENTE,A1_NOME,A1_NREDUZ,A1_MUN
FROM SE1100 SE1 (NOLOCK)
INNER JOIN SA1100 SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT D1_FILIAL,D1_NFORI,D1_SERIORI,D1_DOC,D1_SERIE,D1_EMISSAO
           	   FROM SD1100 SD1 (NOLOCK)
		       WHERE SD1.D_E_L_E_T_ = ''
		       GROUP BY D1_FILIAL,D1_NFORI,D1_SERIORI,D1_DOC,D1_SERIE,D1_EMISSAO)SD1 ON E1_FILORIG = D1_FILIAL AND E1_NUM = D1_NFORI AND E1_PREFIXO = D1_SERIORI
WHERE SE1.D_E_L_E_T_ = ''
AND D1_DOC IS NULL
AND E1_BAIXA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND E1_CLIENTE BETWEEN '000028' AND '000028'
AND E1_NUM NOT LIKE '%FIN%'
AND E1_TIPO NOT IN ('RA','NCC')
AND E1_PREFIXO NOT LIKE 'FIN'
AND E1_PREFIXO NOT LIKE 'REN'
)TB
GROUP BY SUBSTRING(E1_BAIXA,4,7)
)TB2
ORDER BY PERIODO

                                            		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De  Dt.Baixa "    ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Dt.Baixa "    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Baixa"     ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
