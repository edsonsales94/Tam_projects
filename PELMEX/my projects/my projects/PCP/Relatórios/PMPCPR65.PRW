#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR65    ºAutor  ³Wylliam Silva     				º Data ³  04/03/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Rel. Produtos PI e MP Saldos Negativos                     			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR65()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR65"

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

	oReport := TReport():New(cPerg,"Rel. Produtos PI e MP saldos Negativos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Rel. Produtos PI e MP saldos Negativos",{"SB2"},aOrdem)  
	
	
	TRCell():New(oSection,"B2_COD"		,"SB2","CODIGO PROD","@!",15)
	TRCell():New(oSection,"B1_DESC"			,"SB1","DESCRICAO","@!",30)             
	TRCell():New(oSection,"B2_QATU"  	,"SB2","QTD ATUAL","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_01"  		,"SB2","QTD ARM01","@E 999,999,999.999",)
	TRCell():New(oSection,"D2_QUANT"  		,"SD2","QTD TRÂMITE","@E 999,999,999.999",)

	

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

		SELECT SB2.B2_COD,B1_DESC,SB2.B2_QATU,ISNULL(QTD_01,0) QTD_01,ISNULL(D2_QUANT,0) D2_QUANT
		FROM SB2100 SB2
		INNER JOIN SB1100 SB1 ON B1_COD = B2_COD AND SB2.D_E_L_E_T_ =''
		LEFT JOIN (SELECT B2_COD,B2_QATU QTD_01
		      FROM SB2100 SB2
		      WHERE SB2.D_E_L_E_T_ = ''
		      AND B2_FILIAL = '01'
		      AND B2_LOCAL = '01'
		      AND B2_QATU > '0')SB201 ON SB2.B2_COD = SB201.B2_COD
		LEFT JOIN (SELECT D2_FILIAL,D2_COD,SUM(D2_QUANT)D2_QUANT
		           FROM SD2200 SD2
		       LEFT JOIN SD1100 SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_DOC AND D2_SERIE = CAST(D1_SERIE AS INT) AND D2_ITEM = CAST(D1_ITEM AS INT) AND D2_COD = D1_COD
		       WHERE SD2.D_E_L_E_T_ = ''
		       AND D2_FILIAL = '01'
		       AND D1_DOC IS NULL
		       AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		       GROUP BY D2_FILIAL,D2_COD)SD2 ON SB2.B2_COD = SD2.D2_COD AND SB2.B2_FILIAL = SD2.D2_FILIAL
		WHERE SB2.D_E_L_E_T_ = ''
		AND B2_FILIAL = '01'
		AND B2_LOCAL = '10'
		AND B2_QATU < '0'
		ORDER BY B2_COD
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissão Nota:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Até Emissão Nota:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
Return