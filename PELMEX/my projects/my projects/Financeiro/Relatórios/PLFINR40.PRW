#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR40    บAutor  ณjuevan Silva     				บ Data ณ 13/01/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Confere Saida de Notas Baruf            		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR40()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR40"

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
   

	oReport := TReport():New(cPerg,"Confere Saida de Notas Baruf",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Confere Saida de Notas Baruf",{"SE1"},aOrdem)
	
	TRCell():New(oSection,"CONTRATO"	        ,"SC6","CONTRATO","@!",7)	   
	TRCell():New(oSection,"TITULO"	  		    ,"SE1","TITULO","@!",10) 
    TRCell():New(oSection,"PREFIXO"	  	    ,"SE1","PREFIXO","@!",4)
	TRCell():New(oSection,"PARCELA"	  	    ,"SE1","PARCELA","@!",3)
	TRCell():New(oSection,"TIPO"	   	   ,"SE1","TIPO","@!",3)
	TRCell():New(oSection,"VALOR"	  	 ,"SE1","VALOR","@E 9,999,999,999.99",)      
    TRCell():New(oSection,"E1_EMISSAO"	   	   ,"SE1","DT_EMISSAO","@!",10)
    TRCell():New(oSection,"E1_VENCREA"	   	   ,"SE1","DT_VENCTO","@!",10)
    TRCell():New(oSection,"E1_BAIXA"	   	   ,"SE1","DT_BAIXA","@!",10)
    TRCell():New(oSection,"DT_TRANSPORTE"	   	   ,"CNF","DT_TRANSPORTE","@!",10)
    TRCell():New(oSection,"NOTA_BIPE"	   	   ,"SAI","NOTA_BIPE","@!",10)
    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	/*TRFunction():New(oSection:Cell("TOTAL_DUPLICATA"),"Total Duplicata:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("JUROS"),"Total Juros:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
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
    //TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	oReport:SetTotalInLine(.T.)

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

SELECT ISNULL(C6_CONTRAT,'')CONTRATO,E1_NUM TITULO,E1_PREFIXO PREFIXO,E1_PARCELA PARCELA,E1_TIPO TIPO,E1_VALOR VALOR,
       E1_EMISSAO DT_EMISSAO,
       E1_VENCREA DT_VENCTO,
       CASE WHEN E1_BAIXA = '' THEN '' ELSE E1_BAIXA END DT_BAIXA,
       ISNULL(CNF_EXPEDICAO,'') DT_TRANSPORTE,ISNULL(SAI_DOC,'') NOTA_BIPE
FROM SE1100 SE1 (NOLOCK)
INNER JOIN SA1100 SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT *
           FROM CNF (NOLOCK) )CNF ON E1_NUM = CNF_DOC AND E1_PREFIXO = CNF_SERIE
LEFT JOIN (SELECT SAI_DOC,SAI_SERIE,SUM(SAI_QUANT)SAI_QUANT
           FROM SAI (NOLOCK) 
           GROUP BY SAI_DOC,SAI_SERIE)SAI ON E1_NUM = SAI_DOC AND E1_PREFIXO = SAI_SERIE
LEFT JOIN ( SELECT D2_DOC,D2_SERIE,C6_CONTRAT
			FROM SD2100 SD2 (NOLOCK)
			INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
			LEFT JOIN (SELECT C6_FILIAL,C6_NUM,C6_NOTA,C6_ITEM,C6_PRODUTO,C6_CONTRAT
            		   FROM SC6100 SC6 (NOLOCK)
                       INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
                       WHERE SC6.D_E_L_E_T_ = ''
                       AND A1_NREDUZ LIKE 'ORTOCONFORT%')SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND D2_COD = C6_PRODUTO
            WHERE SD2.D_E_L_E_T_ = ''
            AND D2_FILIAL = '01'
            AND D2_LOCAL = '20'
            AND A1_NREDUZ LIKE 'ORTOCONFORT%'
            GROUP BY D2_DOC,D2_SERIE,C6_CONTRAT)SD2 ON E1_NUM = D2_DOC AND E1_PREFIXO = D2_SERIE
WHERE SE1.D_E_L_E_T_ = ''
AND E1_VENCREA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND A1_NREDUZ LIKE 'ORTOCONFORT%'
ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA
    		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Vencto"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate DtVencto"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
//u_InPutSX1(cPerg,"03",PADR("De Num Broder๔"     ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
//u_InPutSX1(cPerg,"04",PADR("Ate Num Broder๔"    ,20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
