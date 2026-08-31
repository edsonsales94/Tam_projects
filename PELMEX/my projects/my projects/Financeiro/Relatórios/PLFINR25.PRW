#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR25    บAutor  ณWylliam Silva     				บ Data ณ 01/12/2021บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Comissใo com baixa Representantes      								 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR25()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR25"

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

	oReport := TReport():New(cPerg,"Comissใo com baixa",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Comissใo com baixa",{"SD2"},aOrdem)
	
		   
	TRCell():New(oSection,"E1_PARCELA"		,"SE1","PARCELA",/*Mascara*/,5) 
	TRCell():New(oSection,"E1_NUM"		    ,"SE1","NOTA FISCAL",/*Mascara*/,10)
	//TRCell():New(oSection,"E1_PREFIXO"		,"SE1","PREFIXO",/*Mascara*/,20)
	//TRCell():New(oSection,"D2_PEDIDO"		,"SD2","PEDIDO",/*Mascara*/,20)
	TRCell():New(oSection,"E1_TIPO"		    ,"SE1","TIPO",/*Mascara*/,6)
	TRCell():New(oSection,"A1_NOME" 		,"SA1","NOME CLIENTE",/*Mascara*/,35)
	TRCell():New(oSection,"E1_VALOR"		,"SE1","VALOR","@E 9,999,999,999.99",)
	TRCell():New(oSection,"E1_SALDO"		,"SE1","SALDO","@E 9,999,999,999.99",)
	TRCell():New(oSection,"C5_COMIS1"		,"SC5","COMISSAO",/*Mascara*/,5)
	TRCell():New(oSection,"VAL_COMISSAO"	,"VAL","VLR COMISSAO","@E 9,999,999,999.99",)
	TRCell():New(oSection,"E1_EMISSAO"		,"SE1","EMISSAO",/*Mascara*/,10)
	TRCell():New(oSection,"E1_VENCTO"		,"SE1","VENCIMENTO",/*Mascara*/,10)
	TRCell():New(oSection,"E1_BAIXA"		,"SE1","BAIXA",/*Mascara*/,10)
	TRCell():New(oSection,"D1_DOC"		    ,"SD1","NOTA DEV",/*Mascara*/,9)
	TRCell():New(oSection,"D1_EMISSAO"		,"SD1","DT DEV",/*Mascara*/,10)
	TRCell():New(oSection,"C5_VEND1"		,"SC5","VEND1",/*Mascara*/,5)
	TRCell():New(oSection,"A3_NOME"		    ,"SA3","NOME",/*Mascara*/,35)
	            

	

	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("E1_VALOR"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VAL_COMISSAO"),"TOTAL COMISSAO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	oReport:SetTotalInLine(.F.)
	
	//Segunda se็ใo
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  


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

		SELECT  E1_PARCELA,E1_NUM,E1_PREFIXO,D2_PEDIDO,E1_TIPO,A1_NOME,E1_VALOR,E1_SALDO,C5_COMIS1,
				ISNULL(D1_TOTAL,0)D1_TOTAL,
				SD21.D2_TOTAL,
				(ISNULL(D1_TOTAL,0)*100/SD21.D2_TOTAL) PER_DEV,
				CASE WHEN E1_SALDO = 0 THEN CASE WHEN D1_DOC IS NULL THEN (E1_VALOR)*(C5_COMIS1/100) ELSE ((E1_VALOR-(E1_VALOR*(D1_TOTAL*100/SD21.D2_TOTAL)/100))*(C5_COMIS1/100)) END
				ELSE 0 END VAL_COMISSAO, 
				E1_EMISSAO,
				E1_VENCTO,
				E1_BAIXA,
				D1_DOC,D1_EMISSAO,D1_SERIE,
				C5_VEND1,A3_NOME
	    FROM %Table:SD2% SD2 (NOLOCK)
	    INNER JOIN %Table:SF4% SF4 (NOLOCK) ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ''
	    INNER JOIN %Table:SC5% SC5 (NOLOCK) ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
	    INNER JOIN %Table:SE1% SE1 (NOLOCK) ON D2_SERIE = E1_PREFIXO AND D2_DOC = E1_NUM AND SE1.D_E_L_E_T_ = ''
	    INNER JOIN %Table:SA1% SA1 (NOLOCK) ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	    INNER JOIN %Table:SA3% SA3 (NOLOCK) ON C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
	    LEFT JOIN (SELECT D1_FILIAL,D1_DOC,D1_EMISSAO,D1_SERIE,D1_NFORI,D1_SERIORI,D1_FORNECE,D1_LOJA,SUM(D1_TOTAL)D1_TOTAL
		           FROM %Table:SD1% SD1 (NOLOCK)
				   WHERE SD1.D_E_L_E_T_ = ''
				   AND D1_LOCAL NOT IN ('30')
				   GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_NFORI,D1_SERIORI,D1_EMISSAO,D1_FORNECE,D1_LOJA)SD1 ON E1_FILORIG = D1_FILIAL AND E1_NUM = D1_NFORI AND E1_PREFIXO = D1_SERIORI AND E1_CLIENTE = D1_FORNECE AND E1_LOJA = D1_LOJA
		LEFT JOIN (SELECT D2_FILIAL,D2_DOC,D2_EMISSAO,D2_SERIE,D2_CLIENTE,D2_LOJA,SUM(D2_PRUNIT*D2_QUANT)D2_TOTAL
				   FROM %Table:SD2% SD2 (NOLOCK)
				   WHERE SD2.D_E_L_E_T_ = ''
				   GROUP BY D2_FILIAL,D2_DOC,D2_EMISSAO,D2_SERIE,D2_CLIENTE,D2_LOJA)SD21 ON E1_FILORIG = SD21.D2_FILIAL AND E1_NUM = SD21.D2_DOC AND E1_PREFIXO = SD21.D2_SERIE AND E1_CLIENTE = SD21.D2_CLIENTE AND E1_LOJA = SD21.D2_LOJA	   
	    WHERE SD2.D_E_L_E_T_ = ''
	    AND F4_DUPLIC = 'S'
	    AND SD2.D2_FILIAL = '01'
	    AND E1_BAIXA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	    AND E1_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	    AND C5_VEND1 BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	    GROUP BY E1_PARCELA,E1_NUM,E1_PREFIXO,D2_PEDIDO,E1_TIPO,A1_NOME,E1_VALOR,E1_SALDO,D1_TOTAL,SD21.D2_TOTAL,C5_COMIS1,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_NSUTEF,C5_VEND1,A3_NOME,D1_DOC,D1_EMISSAO,D1_SERIE,D1_TOTAL
	    ORDER BY A3_NOME,E1_PARCELA,E1_NUM,E1_PREFIXO
	    
					

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("Dt Baixa De "      ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Dt Baixa At้"      ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("Emissใo de   "     ,20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03")
u_InPutSX1(cPerg,"04",PADR("Emissใo at้ "      ,20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
u_InPutSX1(cPerg,"05",PADR("De Vendedor "      ,20)+"?","","","mv_ch5","C",4,0,0,"G","","","","","mv_par05")
u_InPutSX1(cPerg,"06",PADR("At้ Vendedor "     ,20)+"?","","","mv_ch6","C",4,0,0,"G","","","","","mv_par06")   

Return
