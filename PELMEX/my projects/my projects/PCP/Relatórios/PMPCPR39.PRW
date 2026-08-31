#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATR39    ºAutor  ³Stan Lee Lopes     				º Data ³  15/06/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  			Pedidos em produção											 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PMPCPR39()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR39"

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

	oReport := TReport():New(cPerg,"Pedidos em produção",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()
	oReport:SetEnvironment(2)

	//Primeira seção
	oSection := TRSection():New(oReport,"Pedidos em produção",{"PRO"},aOrdem)
	
	
    TRCell():New(oSection,"CODIGO"         ,"SD2","Codigo",/*Mascara*/,20)
	TRCell():New(oSection,"DESCRICAO"	    ,"SD2","Descrição",/*Mascara*/,50)
	TRCell():New(oSection,"QTD_PELMEX"        ,"SD2","Pelmex",,8)
	TRCell():New(oSection,"QTD_AMAZON"	        ,"SD2","Amazon",/*Mascara*/,8)
	TRCell():New(oSection,"DIFERENCA"   	,"SD2","Diferenca",,15)
	
	/*TRFunction():New(oSection:Cell("OPNAOPRODUZIDA"),"Total nao produzido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("EMESTOQUE"),"Total em estoque","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("PRODUZIDO"),"Total produzido"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("SALDOPREVISTO"),"Total previsto"•,"SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("FATURADO"),"Total faturado"•,"SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("SALDOATUAL"),"Saldo em disponivel"•,"SUM",,,"@E 9,999,999,999",,.F.,.T.)
	//Totalizador
*/
	//
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENÇA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DA1_TOTAL"),"TOTAL FABRICA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	/*
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport

/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ·
	//endif


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

SELECT G1_COMP CODIGO,B1_DESC DESCRICAO,SUM(QTD_PELMEX)QTD_PELMEX,ISNULL(QTD_AMAZON,0)QTD_AMAZON,SUM(QTD_PELMEX)-ISNULL(QTD_AMAZON,0)DIFERENCA
FROM(
SELECT D2_COD,G1_COMP,SB12.B1_DESC,
       D2_QUANT,G1_QUANT,
	   G1_QUANT * D2_QUANT QTD_PELMEX
FROM SD2100 SD2 (NOLOCK)
INNER JOIN SG1100 SG1 (NOLOCK) ON D2_COD = G1_COD AND SG1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB12 (NOLOCK) ON G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_COD = D2_COD AND D2_ITEM = D1_ITEMORI 
WHERE SD2.D_E_L_E_T_ = ''
AND D2_FILIAL = '01'
AND D2_LOCAL = '20'
AND D1_DOC IS NULL
AND ((SB12.B1_DESC LIKE 'ART%'
AND SG1.G1_COMP LIKE '050%')
OR (SG1.G1_COMP LIKE 'SUP%'
AND SB12.B1_DESC LIKE 'SUP%'))
AND SB1.B1_TIPO IN ('PA','PC')
AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
GROUP BY D2_FILIAL,D2_COD,SB1.B1_DESC,D2_QUANT,G1_COMP,G1_QUANT,SB12.B1_DESC,D1_DOC
)TB
LEFT JOIN (SELECT D2_COD,SUM(D2_QUANT)QTD_AMAZON
           FROM SD2200 SD2
		   LEFT JOIN SD1200 SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
		   INNER JOIN SB1200 SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		   WHERE SD2.D_E_L_E_T_ = ''
		   AND D1_DOC IS NULL
		   AND D2_FILIAL = '01'
		   AND D2_LOCAL = '20'
		   AND B1_TIPO IN ('PA','PC')
		   AND ((D2_COD LIKE '050%'
		   AND B1_DESC LIKE 'ART%')
		   OR (D2_COD LIKE 'SUP%'
		   AND B1_DESC LIKE 'SUP%'))
		   AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		   GROUP BY D2_COD)SD22 ON G1_COMP = SD22.D2_COD
GROUP BY TB.G1_COMP,TB.B1_DESC,QTD_AMAZON
HAVING (SUM(QTD_PELMEX)-ISNULL(QTD_AMAZON,0)) > 0
ORDER BY TB.G1_COMP

EndSQL

	oSection:EndQuery()
	oSection:SetParentQuery()
	oSection:Print()
Return

Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("Emissao de  ?     ",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissao Até ?     ",20)+"","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02")

Return