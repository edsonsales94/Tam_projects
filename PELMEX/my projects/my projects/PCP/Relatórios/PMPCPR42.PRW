#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR42    ºAutor  ³WYLLIAM SILVA     				º Data ³  19/11/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Acompanhamento de quantidade de Produção          						 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR42()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR42"

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

	oReport := TReport():New(cPerg,"Acompanhamento de quantidade de Produção",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()
	oReport:SetEnvironment(2)

	//Primeira seção
	oSection := TRSection():New(oReport,"ACOMPANHAMENTO DE QUANTIDADE DE PRODUÇÃO",{"PK2"},aOrdem)


	TRCell():New(oSection,"PK2_FILIAL"       ,"PK2","FILIAL",/*Mascara*/,5)     
	TRCell():New(oSection,"PK2_PRODUTO"      ,"PK2","PRODUTO",/*Mascara*/,20)  
	TRCell():New(oSection,"B1_DESC"          ,"SB1","DESCRICAO",/*Mascara*/,50)  
	TRCell():New(oSection,"B1_UM"	         ,"SB1","UM",/*Mascara*/,5)
	TRCell():New(oSection,"QTD_01"		     ,"SB2","QTDE AMZ01","@E 9,999,999,999.999",5)
	TRCell():New(oSection,"QTD_PRODUCAO"	 ,"PK2","QTDE PRODUC","@E 9,999,999,999.999",5)
	TRCell():New(oSection,"QTD_20"           ,"SB2","QTDE AMZ20","@E 9,999,999,999.999",5)
	TRCell():New(oSection,"QTD_EMPENHO20"    ,"SB2","QTDE EMP20","@E 9,999,999,999.999",5)
	TRCell():New(oSection,"QTD_30"           ,"SB2","QTDE AMZ30","@E 9,999,999,999.999",5)
	TRCell():New(oSection,"QTD_60"           ,"SB2","QTDE AMZ60","@E 9,999,999,999.999",5)
		

    
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("C6_VALOR"),"TOTAL FATURADO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("CUBAGEM"),"TOTAL CUBAGEM","SUM",,,"@E 999,999,999.999999",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)


Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

SELECT PK2_FILIAL,PK2_PRODUTO,B1_DESC,B1_UM,ISNULL(QTD_01,0)QTD_01,CAST(SUM(PK2_QUANT) AS INT) QTD_PRODUCAO,ISNULL(QTD_20,0)QTD_20,ISNULL(QTD_EMPENHO20,0)QTD_EMPENHO20,ISNULL(QTD_30,0)QTD_30,ISNULL(QTD_60,0)QTD_60
FROM PK2
INNER JOIN SB1100 SB1 ON PK2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_01
            FROM SB2100 SB2
      INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
      WHERE SB2.D_E_L_E_T_ = ''
      AND B2_FILIAL = '01'
      AND B2_LOCAL = '01'
      AND B2_QATU > 0)SB210 ON PK2_PRODUTO = SB210.B2_COD
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_20,B2_RESERVA QTD_EMPENHO20
            FROM SB2100 SB2
      INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
      WHERE SB2.D_E_L_E_T_ = ''
      AND B2_FILIAL = '01'
      AND B2_LOCAL = '20'
      AND B2_QATU > 0)SB220 ON PK2_PRODUTO = SB220.B2_COD
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_30
            FROM SB2100 SB2
      INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
      WHERE SB2.D_E_L_E_T_ = ''
      AND B2_FILIAL = '01'
      AND B2_LOCAL = '30'
      AND B2_QATU > 0)SB230 ON PK2_PRODUTO = SB230.B2_COD
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_60
            FROM SB2100 SB2
      INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
      WHERE SB2.D_E_L_E_T_ = ''
      AND B2_FILIAL = '01'
      AND B2_LOCAL = '60'
      AND B2_QATU > 0)SB260 ON PK2_PRODUTO = SB260.B2_COD
WHERE PK2_FILIAL = '01'
AND CONVERT(VARCHAR,CAST(PK2_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
GROUP BY PK2_FILIAL,PK2_PRODUTO,B1_DESC,B1_UM,QTD_01,QTD_20,QTD_EMPENHO20,QTD_30,QTD_60
ORDER BY B1_DESC
		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Produção"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Até Produção"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return
