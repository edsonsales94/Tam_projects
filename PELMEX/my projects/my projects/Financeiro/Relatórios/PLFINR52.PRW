#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR52    บAutor  ณWylliam Silva     				บ Data ณ 06/06/2023บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Comissao Representantes Simplificado  	                 			 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR52()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR52"

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
   

	oReport := TReport():New(cPerg,"Comissao Representantes Simplificado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Comissao Representantes Simplificado",{"SE1"},aOrdem)
	

	TRCell():New(oSection,"PERIODO"	        ,"SE1","Periodo","@!",10)
    TRCell():New(oSection,"TOTAL"	        ,"SE1","Total Venda","@E 9,999,999,999.99",)	   
	TRCell():New(oSection,"COMISSAO"		,"SC5","Comissao","@E 9,999,999,999.99",) 
    TRCell():New(oSection,"VAL_COMISSAO"    ,"SE1","Valor Comissao","@E 9,999,999,999.99",)
	TRCell():New(oSection,"E1_VEND1"	    ,"SE1","Venda","@!",10)
	TRCell():New(oSection,"A3_NOME"	        ,"SA3","Representante","@!",30)
	
    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	//TRFunction():New(oSection:Cell("TOTAL"),"Total Venda:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    //TRFunction():New(oSection:Cell("Valor Comissao"),"Valor Comissao:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    /*TRFunction():New(oSection:Cell("VAL_IOF_DIA"),"Total IOF Dia","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
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
    TRFunction():New(oSection:Cell("TOTAL"),"Total Venda","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VAL_COMISSAO"),"Total Comissao","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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

    SELECT PERIODO,SUM(E5_VALOR)TOTAL,
	       CASE WHEN E5_TIPODOC = 'MT' THEN 0 ELSE C5_COMIS1 END COMISSAO,
	       CASE WHEN E5_TIPODOC = 'MT' THEN 0 ELSE SUM(E5_VALOR) * C5_COMIS1/100 END VAL_COMISSAO,E1_VEND1,A3_NOME
    FROM(
           SELECT SUBSTRING(CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103),4,7)PERIODO,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,C5_COMIS1,CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)DT_VENCTO,
                  CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103)DT_BAIXA,E1_VALOR,E5_VALOR,E1_SALDO,E1_CLIENTE,A1_NOME,E1_VEND1,A3_NOME,E1_HIST,E5_HISTOR
            FROM %Table:SD2% SD2 (NOLOCK)
            INNER JOIN %Table:SA1% SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ = ''
			INNER JOIN %Table:SC5% SC5 (NOLOCK) ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
            LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
            INNER JOIN %Table:SE1% SE1 (NOLOCK) ON D2_FILIAL = E1_FILORIG AND D2_DOC = E1_NUM AND D2_SERIE = E1_PREFIXO AND SE1.D_E_L_E_T_ = ''
            INNER JOIN %Table:SE5% SE5 (NOLOCK) ON E1_NUM = E5_NUMERO AND E1_PREFIXO = E5_PREFIXO AND E1_PARCELA = E5_PARCELA AND E1_CLIENTE = E5_CLIFOR AND SE5.D_E_L_E_T_ = ''
			LEFT JOIN %Table:SA3% SA3 (NOLOCK) ON E1_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
            WHERE SD2.D_E_L_E_T_ = ''
            AND E5_RECPAG = 'R'
			AND D1_DOC IS NULL
            AND E1_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
            AND E5_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            GROUP BY SUBSTRING(CONVERT(VARCHAR,CAST(E5_DATA AS DATE),103),4,7),E5_DATA,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_VALOR,E5_VALOR,E1_SALDO,C5_COMIS1,E1_VENCTO,E1_CLIENTE,A1_NOME,E1_VEND1,A3_NOME,E1_HIST,E5_HISTOR
            )TB
    GROUP BY PERIODO,C5_COMIS1,E1_VEND1,A3_NOME
    ORDER BY PERIODO

                                            		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De  Dt.Baixa "    ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Dt.Baixa "    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Vendedor"     ,20)+"?","","","mv_ch3","C",6,0,0,"G","","","SA3","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Ate Vendedor"    ,20)+"?","","","mv_ch4","C",6,0,0,"G","","","SA3","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
