#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR29    บAutor  ณWylliam Silva     				บ Data ณ 08/04/2022บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rel. Analise de Cliente Detalhado               		     			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR37()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR37"

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
   

	oReport := TReport():New(cPerg,"Rel. Rela็ใo de titulos pagos em Real",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Rela็ใo de titulos pagos em Real",{"SE5"},aOrdem)

   	TRCell():New(oSection,"E5_PREFIXO"	        ,"SE5","PREFIXO","@!",5)	   
	TRCell():New(oSection,"E5_TIPO"	  		    ,"SE5","TIPO","@!",5) 
    TRCell():New(oSection,"E5_NUMERO"	  	    ,"SE5","NUMERO","@!",12)
    TRCell():New(oSection,"E5_PARCELA"          ,"SE5","PARCELA","@!",5)
	TRCell():New(oSection,"D1_CF"	            ,"SD1","CFOP","@!",5)
	TRCell():New(oSection,"E5_CLIFOR"	   	    ,"SE5","COD. CLIENTE","@!",8)
    TRCell():New(oSection,"E2_NOMFOR"	   	    ,"SE2","CLIENTE","@!",30)
    TRCell():New(oSection,"ED_DESCRIC"	   	    ,"SED","NATUREZA","@!",25)
    TRCell():New(oSection,"E2_VENCREA"	   	    ,"SE2","DTVENCIM","@!",10)
    TRCell():New(oSection,"E5_HISTOR"	        ,"SE5","HISTORICO","@!",30)
    TRCell():New(oSection,"E2_BAIXA"	        ,"SE2","DTBAIXA","@!",10)
	TRCell():New(oSection,"E5_VALOR"	  	    ,"SE2","VLR ORIGINAL","@E 9,999,999,999.99",)
    TRCell():New(oSection,"JURMULTA"	  	    ,"SE5","JUR/MULTA","@E 9,999,999,999.99",)
    TRCell():New(oSection,"E5_VLCORRE"	  	    ,"SE5","CORRECAO","@E 9,999,999,999.99",)
    TRCell():New(oSection,"E5_VLDESCO"	  	    ,"SE5","DESCONTO","@E 9,999,999,999.99",)
    TRCell():New(oSection,"E2_IRRF"	  	        ,"SE2","IMPOSTO","@E 9,999,999,999.99",)
    TRCell():New(oSection,"E2_VALLIQ"	  	    ,"SE2","TOTAL BAIXADO","@E 9,999,999,999.99",)
    TRCell():New(oSection,"E5_BANCO"	  	    ,"SE2","BANCO","@!",5)
    TRCell():New(oSection,"E5_DTDIGIT"	  	    ,"SE5","DTDIGIT","@!",10)
    TRCell():New(oSection,"E5_MOTBX"	  	    ,"SE5","MOT","@!",4)
    TRCell():New(oSection,"E2_FILORIG"	  	    ,"SE2","FILIAL","@!",4)

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	TRFunction():New(oSection:Cell("E5_VALOR"),"VLR ORIGINAL:","SUM",,,"@E 9,999,999,999.99",,.T.,.T.)
    TRFunction():New(oSection:Cell("JURMULTA"),"Total Juros:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("E5_VLCORRE"),"Total Correcao","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("E5_VLDESCO"),"Total Desconto","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("E2_IRRF"),"Total Imposto:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("E2_VALLIQ"),"TOTAL BAIXADO:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    
    
    //TRFunction():New(oSection:Cell("TOTAL_DESCONTADO"),"Total Lํquido:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    //TRFunction():New(oSection:Cell("TOTAL_LIQUIDO"),"Total a Receber:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
	
    TRFunction():New(oSection:Cell("E5_VALOR"),"Total Original","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	oReport:SetTotalInLine(.T.)

	//Quebra por Se็ใo
	//oSection:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")*/

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

SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,D1_CF,E5_CLIFOR,E5_NATUREZ,ED_DESCRIC,
        E2_VENCREA,E5_HISTOR,
        E2_BAIXA,E5_VALOR,
        E5_VLJUROS+E5_VLMULTA JURMULTA,E5_VLCORRE,E5_VLDESCO,E2_IRRF,E2_VALLIQ,E5_BANCO,
        E5_DTDIGIT,E5_MOTBX,E2_FILORIG
FROM SE5100 SE5 (NOLOCK)
LEFT JOIN (SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_CF,D1_COD,D1_FORNECE
           FROM SD1100 SD1 (NOLOCK) 
       WHERE SD1.D_E_L_E_T_ = ''
       GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_CF,D1_COD,D1_FORNECE)SD1 ON E5_NUMERO = D1_DOC AND E5_PREFIXO = D1_SERIE AND E5_FILORIG = D1_FILIAL
LEFT JOIN SED100 SED (NOLOCK) ON ED_CODIGO = E5_NATUREZ AND SED.D_E_L_E_T_ = ''
LEFT JOIN SE2100 SE2 (NOLOCK) ON E5_NUMERO = E2_NUM AND E5_PREFIXO = E2_PREFIXO AND E5_NATUREZ = E2_NATUREZ AND SE2.D_E_L_E_T_ = ''
WHERE SE5.D_E_L_E_T_ =''
AND E5_NUMERO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND E2_VENCREA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND E2_BAIXA BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
AND E5_DTDIGIT BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
AND D1_FILIAL BETWEEN  %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND E2_PREFIXO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
//AND E5_BANCO BETWEEN '' AND 'ZZZZZZZZZZ'
//AND ED_DESCRIC LIKE '%RANS%'
//AND E5_NUMERO = '000022870'
GROUP BY E5_PREFIXO,E5_TIPO,E5_NUMERO,E5_PARCELA,D1_CF,E5_CLIFOR,E5_NATUREZ,ED_DESCRIC,ED_DESCRIC,E2_VENCREA,E5_HISTOR,E2_BAIXA,E5_VALOR,
        E5_VLJUROS,E5_VLMULTA,E5_VLCORRE,E5_VLDESCO,E2_IRRF,E2_VALLIQ,E5_BANCO,E5_DTDIGIT,E5_MOTBX,E2_FILORIG
ORDER BY E5_NUMERO,E5_PARCELA

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De Numero "       ,20)+"?","","","mv_ch1","C",12,0,0,"G","","","","","mv_par01") 
    u_InPutSX1(cPerg,"02",PADR("Ate Numero "      ,20)+"?","","","mv_ch2","C",12,0,0,"G","","","","","mv_par02")
    u_InPutSX1(cPerg,"03",PADR("De DtVenc"        ,20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
    u_InPutSX1(cPerg,"04",PADR("Ate DtVenc"       ,20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
    u_InPutSX1(cPerg,"05",PADR("De Filial"        ,20)+"?","","","mv_ch5","C",4,0,0,"G","","","","","mv_par05") 
    u_InPutSX1(cPerg,"06",PADR("Ate Filial"       ,20)+"?","","","mv_ch6","C",4,0,0,"G","","","","","mv_par06")
    u_InPutSX1(cPerg,"07",PADR("De Prefixo"       ,20)+"?","","","mv_ch7","C",4,0,0,"G","","","","","mv_par07")
    u_InPutSX1(cPerg,"08",PADR("Ate Prefixo"      ,20)+"?","","","mv_ch8","C",4,0,0,"G","","","","","mv_par08")
    u_InPutSX1(cPerg,"09",PADR("De DtBaixa"       ,20)+"?","","","mv_ch9","D",10,0,0,"G","","","","","mv_par09")
    u_InPutSX1(cPerg,"10",PADR("At้ DtBaixa"      ,20)+"?","","","mv_cha","D",10,0,0,"G","","","","","mv_par10")
    u_InPutSX1(cPerg,"11",PADR("De DtDigit"       ,20)+"?","","","mv_chb","D",10,0,0,"G","","","","","mv_par11")
    u_InPutSX1(cPerg,"12",PADR("At้ DtDigit"      ,20)+"?","","","mv_chc","D",10,0,0,"G","","","","","mv_par12")

Return
