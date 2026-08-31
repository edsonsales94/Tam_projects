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


User Function PLFINR33()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR33"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oBreak
	Local aOrdem      := {"FILIAL"}

	oReport := TReport():New(cPerg,"Rel. Analise de Cliente Detalhado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Analise de Cliente Detalhado",{"SE1"},aOrdem)
	
		   
	TRCell():New(oSection,"EMPRESA"	  		,"SE1","EMPRESA","@!",8) 
	TRCell():New(oSection,"DT_EMISSAO"	    ,"SE1","DT_EMISSAO","@!",10)
	TRCell():New(oSection,"TITULO"	   		,"SE1","TITULO","@!",9)
	TRCell():New(oSection,"PREFIXO"	    	,"SE1","PREFIXO","@!",5)
	TRCell():New(oSection,"PARCELA"	  		,"SE1","PARCELA","@!",4)
	TRCell():New(oSection,"VALOR"	  		,"SE1","VALOR","@E 9,999,999,999.99",)
	TRCell():New(oSection,"SALDO"			,"SE1","SALDO","@E 9,999,999,999.99",)
	TRCell():New(oSection,"DT_VENCIMENTO"	,"SE1","DT_VENCIMENTO","@!",10)
	TRCell():New(oSection,"DT_BAIXA"		,"SE1","DT_BAIXA","@!",10)
    TRCell():New(oSection,"NOTA_DEV"		,"SD1","NOTA_DEV","@!",9)
    TRCell():New(oSection,"SERIE_DEV"		,"SD1","SERIE_DEV","@!",3)      
	TRCell():New(oSection,"DT_DEVOLUCAO"	,"SD1","DT_DEVOLUCAO","@!",10)
	TRCell():New(oSection,"PER_COMISSAO"	,"SC5","PER_COMISSAO","@!",15) 
	TRCell():New(oSection,"VAL_COMISSAO"	,"SE1","VAL_COMISSAO","@E 9,999,999,999.99",)
	TRCell():New(oSection,"STATUS"			,"SE1","STATUS","@!",30) 
	TRCell():New(oSection,"CODCLI"			,"SE1","CODCLI","@!",15) 
	TRCell():New(oSection,"RSOCIAL"			,"SE1","RSOCIAL","@!",30) 
	TRCell():New(oSection,"NFANT"			,"SE1","NFANT","@!",30) 
	TRCell():New(oSection,"VENDEDOR"		,"SE1","VENDEDOR","@!",6)
	TRCell():New(oSection,"NOME"			,"SE1","NOME","@!",30)
	
	//Segunda se็ใo
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("VAL_RECEBER"),"TOTAL Recebido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//oReport:SetTotalInLine(.F.)

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

			SELECT *
				FROM(
				SELECT 'PELMEX' EMPRESA,CONVERT(VARCHAR,CAST(E1_EMISSAO AS DATE),103)DT_EMISSAO,
				       E1_NUM TITULO,E1_PREFIXO PREFIXO,E1_PARCELA PARCELA,E1_VALOR VALOR,E1_SALDO SALDO,
				       CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)DT_VENCIMENTO,
				       CASE WHEN E1_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E1_BAIXA AS DATE),103) END DT_BAIXA,
				       ISNULL(D1_DOC,'') NOTA_DEV,ISNULL(D1_SERIE,'') SERIE_DEV,ISNULL(CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103),'')DT_DEVOLUCAO,
				       ISNULL(C5_COMIS1,0) PER_COMISSAO,ISNULL(CASE WHEN ISNULL(D1_EMISSAO,'') != '' THEN ((E1_VALOR*C5_COMIS1)/100)*-1 ELSE ((E1_VALOR*C5_COMIS1)/100) END,0) VAL_COMISSAO,
				       E1_CLIENTE CODCLI,E1_NOMCLI RSOCIAL,A1_NREDUZ NFANT,E1_VEND1 VENDEDOR,A3_NOME NOME,
				       CASE WHEN E1_SALDO = 0 THEN 'RECEBIDO' WHEN CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)< GETDATE() THEN 'PARCELA VENCIDA' ELSE 'PARCELA NO PRAZO' END STATUS
				FROM SE1100 SE1 (NOLOCK)
				LEFT JOIN SD2100 SD2 (NOLOCK) ON E1_NUM = D2_DOC AND E1_PREFIXO = D2_SERIE AND SD2.D_E_L_E_T_ = ''
				LEFT JOIN SC5100 SC5 (NOLOCK) ON D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
				INNER JOIN SA1100 SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
				INNER JOIN SA3100 SA3 (NOLOCK) ON E1_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
				LEFT JOIN (SELECT D1_DOC,D1_SERIE,D1_EMISSAO,D1_NFORI,D1_SERIORI,SUM(D1_TOTAL)TOTAL_DEV,D1_FORNECE,D1_LOJA
				           FROM SD1100 SD1 (NOLOCK)
				       WHERE SD1.D_E_L_E_T_ = ''
				       AND D1_LOCAL NOT IN ('30')
				       GROUP BY D1_DOC,D1_SERIE,D1_EMISSAO,D1_NFORI,D1_SERIORI,D1_FORNECE,D1_LOJA)SD1 ON E1_NUM = D1_NFORI AND E1_PREFIXO = D1_SERIORI AND E1_CLIENTE = D1_FORNECE AND E1_LOJA = D1_LOJA
				WHERE SE1.D_E_L_E_T_ = ''
				AND E1_VENCTO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND E1_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
				AND E1_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
				AND E1_SALDO > 0 
				AND A3_TIPO = 'E'
				
				UNION
				
				SELECT 'AMAZON' EMPRESA,CONVERT(VARCHAR,CAST(E1_EMISSAO AS DATE),103)DT_EMISSAO,
				       E1_NUM TITULO,E1_PREFIXO PREFIXO,E1_PARCELA PARCELA,E1_VALOR VALOR,E1_SALDO SALDO,
				     CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)DT_VENCIMENTO,
				       CASE WHEN E1_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E1_BAIXA AS DATE),103) END DT_BAIXA,
				     ISNULL(D1_DOC,'') NOTA_DEV,ISNULL(D1_SERIE,'') SERIE_DEV,ISNULL(CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103),'')DT_DEVOLUCAO,
				     ISNULL(C5_COMIS1,0) PER_COMISSAO,ISNULL(CASE WHEN ISNULL(D1_EMISSAO,'') != '' THEN ((E1_VALOR*C5_COMIS1)/100)*-1 ELSE ((E1_VALOR*C5_COMIS1)/100) END,0) VAL_COMISSAO,
				     E1_CLIENTE CODCLI,E1_NOMCLI RSOCIAL,A1_NREDUZ NFANT,E1_VEND1 VENDEDOR,A3_NOME NOME,
				     CASE WHEN E1_SALDO = 0 THEN 'RECEBIDO' WHEN CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)< GETDATE() THEN 'PARCELA VENCIDA' ELSE 'PARCELA NO PRAZO' END STATUS
				FROM SE1200 SE1 (NOLOCK)
				LEFT JOIN SD2200 SD2 (NOLOCK) ON E1_NUM = D2_DOC AND E1_PREFIXO = D2_SERIE AND SD2.D_E_L_E_T_ = ''
				LEFT JOIN SC5200 SC5 (NOLOCK) ON D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
				INNER JOIN SA1200 SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
				INNER JOIN SA3200 SA3 (NOLOCK) ON E1_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
				LEFT JOIN (SELECT D1_DOC,D1_SERIE,D1_EMISSAO,D1_NFORI,D1_SERIORI,SUM(D1_TOTAL)TOTAL_DEV,D1_FORNECE,D1_LOJA
				           FROM SD1200 SD1 (NOLOCK)
				       WHERE SD1.D_E_L_E_T_ = ''
				       AND D1_LOCAL NOT IN ('30')
				       GROUP BY D1_DOC,D1_SERIE,D1_EMISSAO,D1_NFORI,D1_SERIORI,D1_FORNECE,D1_LOJA)SD1 ON E1_NUM = D1_NFORI AND E1_PREFIXO = D1_SERIORI AND E1_CLIENTE = D1_FORNECE AND E1_LOJA = D1_LOJA
				WHERE SE1.D_E_L_E_T_ = ''
				AND E1_VENCTO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND E1_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
				AND E1_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
				AND E1_SALDO > 0 
				AND A3_TIPO = 'E'
				
				)TB
				
ORDER BY 1,CONVERT(VARCHAR,CAST(DT_EMISSAO AS DATE),112),TITULO,PREFIXO,PARCELA
			
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De DT Baixa "       ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("At้ DT Baixa "      ,20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Cod.Vend"        ,20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("At้ Cod.Vend"       ,20)+"?","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
u_InPutSX1(cPerg,"05",PADR("De Cod.Cliente"     ,20)+"?","","","mv_ch5","C",6,0,0,"G","","","","","mv_par05") 
u_InPutSX1(cPerg,"06",PADR("At้ Cod.Cliente"    ,20)+"?","","","mv_ch6","C",6,0,0,"G","","","","","mv_par06")

Return