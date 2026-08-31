#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR36    ºAutor  ³Stan Lee Lopes     				º Data ³  21/05/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  			PICKLIST COMPACTADO PELMEX									 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PMPCPR36()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR36"

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

	oReport := TReport():New(cPerg,"PICKLIST COMPAQUITADO PELMEX",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()
	oReport:SetEnvironment(2)

	//Primeira seção
	oSection := TRSection():New(oReport,"PICKLIST COMPACTADO PELMEX",{"PRO"},aOrdem)
	
    TRCell():New(oSection,"DTPROPEL"         ,"PRO","Dt.Produção",/*Mascara*/,20)
	TRCell():New(oSection,"CODIGO"	         ,"PRO","Produto",/*Mascara*/,20)
	TRCell():New(oSection,"DESCRICAO"        ,"PRO","Descrição",,80)
	TRCell():New(oSection,"UNIDADE"	         ,"PRO","Unidade",/*Mascara*/,10)
	TRCell():New(oSection,"QTD_NECESSARIA"   ,"PRO","Qtd.Necessária","@E 9,999,999,999.99",)
	
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
	Local cProd := AllTrim(MV_PAR05)

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

		SELECT TB1.DTPROPEL,TB1.CODIGO,TB1.DESCRICAO,TB1.UNIDADE,SUM(TB1.QTD_NECESSARIA)QTD_NECESSARIA
		FROM(
		SELECT TB.PK2_DTPROPEL DTPROPEL,TB.PK2_SETOR SETOR,TB.G1_COMP CODIGO,TB.B1_DESC DESCRICAO,TB.B1_UM UNIDADE,SUM(QTD_NECESSARIA)QTD_NECESSARIA
		FROM(
		SELECT PK2_DTPROPEL,PK2_SETOR,PK2_PRODUTO,PK2_DESCRI,G1_COMP,SB1.B1_DESC,SB1.B1_UM,PK2_QUANT,G1_QUANT,
		       PK2_QUANT*G1_QUANT QTD_NECESSARIA
		FROM PK2
		INNER JOIN SG1100 SG1 ON PK2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
		INNER JOIN SB1100 SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE G1_COMP NOT LIKE 'MOD%'
		AND CONVERT(VARCHAR,CAST(PK2_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND CONVERT(VARCHAR,CAST(PK2_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND B1_DESC LIKE '%'+%Exp:cProd%+'%'
		)TB 
		GROUP BY TB.PK2_DTPROPEL,TB.PK2_SETOR,TB.G1_COMP,TB.B1_DESC,TB.B1_UM
		)TB1
		GROUP BY TB1.DTPROPEL,TB1.CODIGO,TB1.DESCRICAO,TB1.UNIDADE 
		ORDER BY TB1.DESCRICAO
		
	EndSQL

	oSection:EndQuery()
	oSection:SetParentQuery()
	oSection:Print()
Return
Static Function AjustaSX1(cPerg)
    u_InPutSX1(cPerg,"01",PADR("Emissão de  ?     ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissão Até ?     ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("DT.Producao de  ? ",20)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("DT.Producao Até ? ",20)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Produto ?    	  ",20)+"","","","mv_ch5","C",50,0,0,"G","","SB1","","","mv_par05")
Return