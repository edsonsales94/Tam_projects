#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR48    บAutor  ณJuevan Silva     					บ Data ณ 16/03/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rel. de Titulos Pagos             		     						 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR48()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR48"

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
	Local aOrdem     := {"FILIAL"}
   

	oReport := TReport():New(cPerg,"Rel. de Titulos Pagos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. de Titulos Pagos",{"SE2"},aOrdem)

	TRCell():New(oSection,"E2_NATUREZ"	     ,"SE2","NATUREZA","@!",15)
	TRCell():New(oSection,"DESCRICAO"	     ,"SED","DESCRI_NATU","@!",15)
	TRCell():New(oSection,"PREF"	         ,"SE2","PREF","@!",3)
    TRCell():New(oSection,"PARCELA"	        ,"SE2","PARCELA","@!",3)   
	TRCell():New(oSection,"TITULO"	  		    ,"SE2","TITULO","@!",15)
    TRCell():New(oSection,"FORNECEDOR"	  	    ,"SE2","FORNECEDOR","@!",30)
	TRCell():New(oSection,"HISTORICO"	        ,"SE2","HISTORICO","@!",15)
	TRCell():New(oSection,"DT_EMISSAO"	   	   ,"SE2","DT_EMISSAO","@!",10)
	TRCell():New(oSection,"DT_VENCTO"	   	   ,"SE2","DT.VENCTO","@!",10)
	TRCell():New(oSection,"DT_BAIXA"	  	      ,"SE2","DT_BAIXA","@!",10)
    TRCell():New(oSection,"E2_VALOR"	   	   ,"SE2","VALOR","@E 9,999,999,999.99",)
	TRCell():New(oSection,"E2_SALDO"	   	   ,"SE2","SALDO","@E 9,999,999,999.99",)
	TRCell():New(oSection,"E2_MULTA"	   	   ,"SE2","MULTA","@E 9,999,999,999.99",)
	TRCell():New(oSection,"TOTAL"	   	      ,"SE2","TOTAL","@E 9,999,999,999.99",15)
    TRCell():New(oSection,"E2_VALLIQ"	   	   ,"SE2","VALOR_PG","@E 9,999,999,999.99",)
	TRCell():New(oSection,"BANCO"	  	       ,"SE2","BANCO","@!",4)
	TRCell():New(oSection,"E5_MOTBX"	  	       ,"SE2","MOTIVO BAIXA","@!",4)
	
    
	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	TRFunction():New(oSection:Cell("VALOR"),"Total VALOR:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
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

SELECT E2_NATUREZ,ED_DESCRIC DESCRICAO,E2_PREFIXO PREF,E2_PARCELA PARCELA, E2_NUM TITULO, E2_NOMFOR FORNECEDOR, E2_HIST HISTORICO, 
       CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103) DT_EMISSAO ,CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103) DT_VENCTO,
       CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA, 
	   E2_VALOR,E2_VALLIQ,E2_SALDO,E2_MULTA,E2_VALOR+E2_MULTA TOTAL , E2_BCOPAG BANCO,E5_MOTBX
FROM %Table:SE2% SE2
INNER JOIN %Table:SED% SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT JOIN ( SELECT E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_PARCELA,E5_VALOR,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_MOTBX
			FROM %Table:SE5% SE5
			WHERE SE5.D_E_L_E_T_ = ''
			AND E5_BANCO != ''
			)SE5 ON E2_NUM = E5_NUMERO AND E2_PREFIXO = E5_PREFIXO AND E2_TIPO = E5_TIPO
WHERE SE2.D_E_L_E_T_ = ''
AND E2_TIPO NOT IN ('PA')
AND E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND E2_BAIXA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND E2_BCOPAG BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
UNION
SELECT E2_NATUREZ,ED_DESCRIC DESCRICAO,E2_PREFIXO PREF,E2_PARCELA PARCELA, E2_NUM TITULO, E2_NOMFOR FORNECEDOR, E2_HIST HISTORICO, 
       CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103) DT_EMISSAO ,CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103) DT_VENCTO,
       CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA,
	   E2_VALOR,E2_VALLIQ,E2_SALDO,E2_MULTA,E2_VALOR+E2_MULTA TOTAL , E5_BANCO BANCO,E5_MOTBX 
FROM %Table:SE2% SE2
INNER JOIN %Table:SED% SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = ''
LEFT JOIN ( SELECT E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_PARCELA,E5_VALOR,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_MOTBX
			FROM %Table:SE5% SE5
			WHERE SE5.D_E_L_E_T_ = ''
			AND E5_BANCO != ''
			)SE5 ON E2_NUM = E5_NUMERO AND E2_PREFIXO = E5_PREFIXO AND E2_TIPO = E5_TIPO
WHERE SE2.D_E_L_E_T_ = ''
AND E2_TIPO = 'PA'
AND E2_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND E2_BCOPAG BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
ORDER BY DT_EMISSAO,TITULO, PREF                                          



    		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Emissao "     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissao  "    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Baixa"     ,20)+"?","","","mv_ch3","D",15,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Ate Dt Baixa"    ,20)+"?","","","mv_ch4","D",15,0,0,"G","","","","","mv_par04")
u_InPutSX1(cPerg,"05",PADR("De Banco"         ,20)+"?","","","mv_ch5","C",3,0,0,"G","","SA6","","","mv_par05") 
u_InPutSX1(cPerg,"06",PADR("Ate Banco"        ,20)+"?","","","mv_ch6","C",3,0,0,"G","","SA6","","","mv_par06")

Return
