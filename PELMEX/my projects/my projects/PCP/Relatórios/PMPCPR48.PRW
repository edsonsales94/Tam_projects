#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR48    ºAutor  ³Wylliam Silva     				º Data ³  28/12/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rel. Pedidos em Carteira Baruf         						  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR48()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR48"

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

	oReport := TReport():New(cPerg,"Rel. Pedidos em Carteira Baruf",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Rel. Pedidos em Carteira Baruf",{"SC6"},aOrdem)  
	


	TRCell():New(oSection,"C6_NUM"	        ,"SC6","PEDIDO","@!",8)             
	TRCell():New(oSection,"NOTA"            ,"SD2","NOTA","@!",9) 
	TRCell():New(oSection,"C6_ITEM"    	    ,"SC6","ITEM","@!",3)
	TRCell():New(oSection,"C6_PRODUTO"      ,"SC6","PRODUTO","@!",15)
	TRCell():New(oSection,"C6_DESCRI"   	,"SC6","PRODUTO","@!",30)
	TRCell():New(oSection,"C6_QTDVEN"       ,"SC6","QTDE VENDA","@E 999,999,999,999",6)
	TRCell():New(oSection,"C6_PRCVEN"       ,"SC6","PREÇO VENDA","@E 999,999,999,999",9)
	TRCell():New(oSection,"C6_VALOR"        ,"SC6","VALOR","@E 999,999,999,999",9)
	TRCell():New(oSection,"QTD_NOTA"        ,"SC6","QTDE NOTA","@E 999,999,999,999",6)		
	TRCell():New(oSection,"DIFERENCA"       ,"SC6","DIFERENCA","@E 999,999,999,999",9)
	TRCell():New(oSection,"TOTAL"           ,"SC6","TOTAL","@E 999,999,999,999",9)
	TRCell():New(oSection,"CIDADE"          ,"SA1","CIDADE","@!",15)
	TRCell():New(oSection,"CLIENTE"      ,"SA1","NOME CLIENTE","@!",30)
	
		
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

  SELECT C6_NUM,ISNULL(D2_DOC,'')NOTA,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_VALOR,ISNULL(QTD_NOTA,0)QTD_NOTA,C6_QTDVEN-ISNULL(QTD_NOTA,0) DIFERENCA,(C6_QTDVEN-ISNULL(QTD_NOTA,0))*C6_PRCVEN TOTAL,A1_MUN CIDADE,A1_NOME CLIENTE
FROM SC6100 SC6
INNER JOIN SA1100 SA1 ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN PED ON PED_FILIAL = C6_FILIAL AND PED_NUM = C6_NUM AND PED_PRODUTO = C6_PRODUTO AND SC6.D_E_L_E_T_ = ''
LEFT JOIN (SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_PEDIDO,D2_ITEMPV,D2_COD,D2_QUANT QTD_NOTA
FROM SD2100 SD2
LEFT JOIN SD1100 SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
WHERE SD2.D_E_L_E_T_ = ''
AND D2_FILIAL = '01'
AND D1_DOC IS NULL
AND D2_EMISSAO >= '20210901')SD2 ON PED_FILIAL = D2_FILIAL AND PED_NUM = D2_PEDIDO AND PED_ITEM = D2_ITEMPV AND PED_PRODUTO = D2_COD
WHERE SC6.D_E_L_E_T_ = ''

AND (PED_NOME LIKE '%BARUF%'
OR PED_NOME LIKE '%W FALCAO%'
OR PED_NOME LIKE '%BESSA%'
OR A1_COD = 'Q61244')
AND C6_QTDVEN > C6_QTDENT
AND C6_TES NOT IN ('723')

GROUP BY C6_NUM,D2_DOC,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_VALOR,QTD_NOTA,A1_NOME,A1_MUN
ORDER BY C6_NUM,C6_ITEM

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Emissão:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissão:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Vendedor:",20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Vendedor:",20)+"?","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	

Return
