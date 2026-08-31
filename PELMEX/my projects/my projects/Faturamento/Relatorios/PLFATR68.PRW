#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR68  บAutor  ณKledson Oliveira   				บ Data ณ 26/02/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   FATURADO X TABELA DE PRECO                   			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR68()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR68"

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

	oReport := TReport():New(cPerg,"FATURADO X TABELA DE PRECO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"FATURADO X TABELA DE PRECO",{"SD2"},aOrdem) 

    TRCell():New(oSection,"TABELA"   	      ,"DA1","TABELA","@!",3)
    TRCell():New(oSection,"DESCRICAO_TABELA"		    ,"SC5","DESCRICAO_TABELA","@!",30)
    TRCell():New(oSection,"FILIAL"		    ,"SC5","FILIAL","@!",2)
    TRCell():New(oSection,"NOTA"		    ,"SC5","NOTA","@!",9)
    TRCell():New(oSection,"SERIE"  			,"SC5","SERIE","@!",3)
    TRCell():New(oSection,"PEDIDO"		    ,"SC5","PEDIDO","@!",6)
	TRCell():New(oSection,"ITEM"		    ,"SC5","ITEM","@!",3)
    TRCell():New(oSection,"CODIGO"		    ,"SC5","CODIGO","@!",15)
    TRCell():New(oSection,"DESCRICAO"		    ,"SC5","DESCRICAO","@!",30)
    TRCell():New(oSection,"QTD_NOTA"		    ,"SC5","QTD_NOTA","@E 999,999,999.999",)
    TRCell():New(oSection,"PRECO_NOTA"  			,"SC5","PRECO_NOTA","@E 999,999,999.999",30)
    TRCell():New(oSection,"PRECO_TABELA"		    ,"SC5","PRECO_TABELA","@E 999,999,999.999",30)
	TRCell():New(oSection,"DIFERENCA"		    ,"SC5","DIFERENCA","@E 999,999,999.999",)
    TRCell():New(oSection,"TOTAL_NOTA"		    ,"SC5","TOTAL_NOTA","@E 999,999,999.999",)
    TRCell():New(oSection,"TOTAL_TABELA"		    ,"SC5","TOTAL_TABELA","@E 999,999,999.999",)
    TRCell():New(oSection,"DIFER_TOTAL"		    ,"SC5","DIFER_TOTAL","@E 999,999,999.999",)
    TRCell():New(oSection,"CLIENTE"		    ,"SC5","CLIENTE","@!",6)
    TRCell():New(oSection,"LOJA"		    ,"SC5","LOJA","@!",3)
    TRCell():New(oSection,"NOME"		    ,"SC5","NOME","@!",30)
    TRCell():New(oSection,"CIDADE"		    ,"SC5","CIDADE","@!",18)

    //TRCell():New(oSection,"QTD_PERDA"		    ,"PED","QTD_PERDA","@E 999,999,999,999",)
    //TRCell():New(oSection,"DIFERENCA"		    ,"PED","DIFERENCA","@E 999,999,999,999",)
    //TRCell():New(oSection,"NOME"		    ,"PED","NOME","@!",30)
    //TRCell():New(oSection,"CIDADE"		    ,"PED","CIDADE","@!",10)
    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)
	//TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    //TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	//TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	//TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 

	
    
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%


SELECT TABELA,ISNULL(DA0_DESCRI,'') DESCRICAO_TABELA,FILIAL,NOTA,SERIE,PEDIDO,ITEM,CODIGO,DESCRICAO,QTD_NOTA,PRECO_NOTA,PRECO_TABELA,
       DIFERENCA,TOTAL_NOTA,TOTAL_TABELA, (ROUND(TOTAL_NOTA,2) - TOTAL_TABELA) DIFER_TOTAL,CLIENTE,LOJA,NOME,CIDADE
FROM(
SELECT ISNULL(CASE WHEN C5_XFILRES != '' THEN X6_CONTEUD ELSE DA0_CODTAB END,'') TABELA, 
       ISNULL(CASE WHEN C5_XFILRES != '' THEN '' ELSE DA0_DESCRI END,'')  DESCRICAO_TABELA,
     D2_FILIAL FILIAL,D2_DOC NOTA,D2_SERIE SERIE,D2_PEDIDO PEDIDO,D2_ITEM ITEM,D2_COD CODIGO,B1_DESC DESCRICAO,D2_QUANT QTD_NOTA,D2_PRCVEN PRECO_NOTA,
     ROUND(ISNULL(DA1_PRCVEN,0),2)PRECO_TABELA,
     CASE WHEN DA1_CODTAB IS NULL THEN 0 ELSE ROUND(ISNULL(D2_PRCVEN,0),2)-DA1_PRCVEN END DIFERENCA, 
     D2_TOTAL TOTAL_NOTA,D2_QUANT * ROUND(ISNULL(DA1_PRCVEN,0),2) TOTAL_TABELA,D2_CLIENTE CLIENTE,D2_LOJA LOJA,A1_NOME NOME,A1_MUN CIDADE
FROM SD2100 SD2
INNER JOIN SB1100 SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SC5100 SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
LEFT JOIN DA1100 DA1 ON C5_TABELA = DA1_CODTAB AND D2_COD = DA1_CODPRO AND  DA1.D_E_L_E_T_ = ''
LEFT JOIN DA0100 DA0 ON DA1_CODTAB = DA0_CODTAB AND DA0.D_E_L_E_T_ = ''
LEFT JOIN SA1100 SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
LEFT JOIN SX6100 SX6 ON CASE WHEN C5_XFILRES != '' THEN C5_XFILRES ELSE C5_FILIAL END = X6_FIL AND X6_VAR = 'MV_TABPAD' AND SX6.D_E_L_E_T_ = ''
WHERE SD2.D_E_L_E_T_ = ''
AND D1_DOC IS NULL
AND B1_TIPO IN ('PA','PC')
AND D2_FILIAL BETWEEN '01' AND '01'
AND ISNULL(DA1_CODTAB,'') BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02%
AND D2_CLIENTE BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%
AND D2_DOC BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
AND D2_SERIE BETWEEN %EXP:MV_PAR07% AND %EXP:MV_PAR08%
AND D2_EMISSAO BETWEEN %EXP:MV_PAR09% AND %EXP:MV_PAR10%
)TB
LEFT JOIN DA0100 DA0 ON TABELA = DA0_CODTAB
ORDER BY FILIAL,CODIGO

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Tabela:" ,20)+"?","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Tabela:",20)+"?","","","mv_ch2","C",15,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Cliente:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Cliente:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Nota:" ,20)+"?","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate Nota:",20)+"?","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De Serie:" ,20)+"?","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Ate Serie:",20)+"?","","","mv_ch8","C",15,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("De Emissao:",20)+"?","","","mv_ch9","D",10,0,0,"G","","","","","mv_par09") 
	u_InPutSX1(cPerg,"10",PADR("Ate Emissao:",20)+"?","","","mv_cha","D",10,0,0,"G","","","","","mv_par10")

	
	
	
Return
