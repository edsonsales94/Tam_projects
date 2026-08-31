#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR16    ºAutor  ³Stan Lee Lopes     				º Data ³  13/03/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RELATÓRIO COMISSÃO DE FÁBRICA	        								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFATR17()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR17"

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

	oReport := TReport():New(cPerg,"RELATÓRIO DE COMISSÃO DE FÁBRICA",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"RELATÓRIO DE COMISSÃO DE FÁBRICA",{"SD2"},aOrdem) 

	TRCell():New(oSection,"D2_FILIAL"	    ,"SD2","Filial",/*Mascara*/,/*Tamanho*/)     
	TRCell():New(oSection,"D2_DOC"          ,"SD2","Nota Fiscal",/*"@E 999,999.99"*/,)  
	TRCell():New(oSection,"D2_SERIE"        ,"SD2","Série",/*"@E 999,999.99"*/,)  
	TRCell():New(oSection,"D2_CLIENTE"	    ,"SD2","Cod.Cli",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"D2_LOJA"			,"SD2","Loja Cli",/*"@E 999,999.99"*/,/*Tamanho*/)
	TRCell():New(oSection,"A1_NOME"		    ,"SA1","Cliente",/*"@E 999,999.99"*/,/*Tamanho*/) 
	TRCell():New(oSection,"B1_COD"          ,"SB1","Cod.Produto",/*"@E 999,999.99"*/,)   
	TRCell():New(oSection,"B1_DESC"		    ,"SB1","Produto",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"B1_UM"           ,"SB1","Unidade",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"D2_QUANT"        ,"SD2","Qtd.Vendida","@E 999,999.99",) 
	TRCell():New(oSection,"D2_TOTAL"        ,"SD2","Total Venda---->","@E 999,999,999.99",) 
	TRCell():New(oSection,"DA1_TOTAL"       ,"DA1","Total Fabrica---->","@E 999,999,999.99",)  
	TRCell():New(oSection,"DA1_DESC"        ,"DA1","Diferença-------->","@E 999,999,999.99",) 


	//Totalizador                                                                                  

	TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL VENDA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENÇA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("DA1_TOTAL"),"TOTAL FABRICA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	/*
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)  




	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		SELECT (D2_TOTAL-DA1_TOTAL)DA1_DESC
		FROM(

		SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,A1_NOME,
		B1_COD,B1_DESC,B1_UM,
		D2_QUANT,D2_PRCVEN,D2_TOTAL,
		ISNULL(DA1_PRCVEN,0)DA1_PRCVEN,
		ISNULL(CASE WHEN A1_TIPO = 'R' THEN D2_PRCVEN
		ELSE DA1_PRCVEN END,0) PRCVEN,
		ISNULL(CASE WHEN A1_TIPO = 'R' THEN D2_TOTAL
		ELSE (D2_QUANT * DA1_PRCVEN) END,0) DA1_TOTAL,D2_EST 
		FROM SD2100 SD2 (NOLOCK)
		FULL JOIN DA1100 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND DA1_CODTAB = '022'
		INNER JOIN SB1100 SB1 (NOLOCK) ON SB1.B1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = ''
		LEFT JOIN SA1100 SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		WHERE SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SD2.D2_TES IN ('511','515','550','551','553','556','558','560','563','564','566','803','856','888','889','894','895','896','719','720','721','722','723','724','877')
		//AND SD2.D2_TES IN ('511','515','550','551','553','556','558','560','563','564','566','803','827','828','838','856','865','880','888','889','894','895','896','719','720','721','722','723','877')
		AND SD2.D_E_L_E_T_ = ''

		UNION

		SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,A1_NOME,
		B1_COD,B1_DESC,B1_UM,
		D2_QUANT,D2_PRCVEN,D2_TOTAL,
		ISNULL(DA1_PRCVEN,0)DA1_PRCVEN,
		ISNULL(CASE WHEN A1_TIPO = 'R' THEN D2_PRCVEN
		ELSE DA1_PRCVEN END,0) PRCVEN,
		ISNULL(CASE WHEN A1_TIPO = 'R' THEN D2_TOTAL
		ELSE (D2_QUANT * DA1_PRCVEN) END,0) DA1_TOTAL,D2_EST 
		FROM SD2200 SD2 (NOLOCK)
		FULL JOIN DA1200 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND DA1_CODTAB = '022'
		INNER JOIN SB1200 SB1 (NOLOCK) ON SB1.B1_COD = SD2.D2_COD AND SD2.D_E_L_E_T_ = ''
		LEFT JOIN SA1200 SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		WHERE SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND (SD2.D2_COD LIKE 'LAM%' OR SD2.D2_COD LIKE 'BLOD%' OR SD2.D2_COD LIKE 'DFLOC%' OR SD2.D2_COD LIKE 'PCD%')
		AND SD2.D_E_L_E_T_ = ''

		UNION 
		//DEVOLUÇÃO PELMEX
		SELECT D1_FILIAL,D1_NFORI,D1_SERIORI,D1_FORNECE,D1_LOJA,A1_NOME,
		B1_COD,B1_DESC,B1_UM,
		D1_QUANT,D1_VUNIT,(D1_TOTAL-D1_VALDESC)*-1 D2_TOTAL,
		ISNULL(DA1_PRCVEN,0)DA1_PRCVEN,
		ISNULL(CASE WHEN A1_TIPO = 'R' THEN D1_VUNIT
		ELSE DA1_PRCVEN END,0) PRCVEN,
		ISNULL(CASE WHEN A1_TIPO = 'R' THEN ((D1_TOTAL-D1_VALDESC) * -1)
		ELSE ((D2_QUANT * DA1_PRCVEN) *-1) END,0) DA1_TOTAL,D2_EST 
		FROM SD1100 SD1 (NOLOCK)
		INNER JOIN SD2100 SD2 (NOLOCK) ON SD1.D1_FILORI = SD2.D2_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD2.D_E_L_E_T_ = ''
		FULL JOIN DA1100 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND DA1_CODTAB = '022'
		INNER JOIN SB1100 SB1 (NOLOCK) ON SB1.B1_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
		LEFT JOIN SA1100 SA1 (NOLOCK) ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		WHERE SD1.D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SD1.D_E_L_E_T_ = ''
		AND SD1.D1_FILIAL = '01'
		AND SD1.D1_TIPO = 'D'

		UNION  
		//DEVOLUÇÃO AMAZON
		SELECT D1_FILIAL,D1_NFORI,D1_SERIORI,D1_FORNECE,D1_LOJA,A1_NOME,
		B1_COD,B1_DESC,B1_UM,
		D1_QUANT,D1_VUNIT,(D1_TOTAL-D1_VALDESC)*-1 D2_TOTAL,
		ISNULL(DA1_PRCVEN,0)DA1_PRCVEN,
		ISNULL(CASE WHEN A1_TIPO = 'R' THEN D1_VUNIT
		ELSE DA1_PRCVEN END,0) PRCVEN,
		ISNULL(CASE WHEN A1_TIPO = 'R' THEN ((D1_TOTAL-D1_VALDESC) * -1)
		ELSE ((D2_QUANT * DA1_PRCVEN) *-1) END,0) DA1_TOTAL,D2_EST 
		FROM SD1200 SD1 (NOLOCK)
		INNER JOIN SD2200 SD2 (NOLOCK) ON SD1.D1_FILORI = SD2.D2_FILIAL AND SD1.D1_NFORI = SD2.D2_DOC AND SD1.D1_SERIORI = SD2.D2_SERIE AND SD1.D1_ITEMORI = SD2.D2_ITEM AND SD2.D_E_L_E_T_ = ''
		FULL JOIN DA1200 DA1 (NOLOCK) ON SD2.D2_COD = DA1.DA1_CODPRO AND DA1.D_E_L_E_T_ = '' AND DA1.DA1_ATIVO = '1' AND DA1_CODTAB = '022'
		INNER JOIN SB1200 SB1 (NOLOCK) ON SB1.B1_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = ''
		LEFT JOIN SA1200 SA1 (NOLOCK) ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
		WHERE SD1.D1_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SD1.D_E_L_E_T_ = ''
		AND SD1.D1_TIPO = 'D'
		)SD2
		ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,B1_DESC


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(CPerg,"01",PADR("Emissão De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissão Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 

Return