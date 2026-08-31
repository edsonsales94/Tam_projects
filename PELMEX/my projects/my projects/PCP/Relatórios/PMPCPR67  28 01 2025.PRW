#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR67    ºAutor  ³Wylliam Silva     				º Data ³  23/03/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Rel. Movimentações Almoxarifado                          			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR67()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR67"

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

	oReport := TReport():New(cPerg,"Rel. Movimentações Almoxarifado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Rel. Movimentações Almoxarifado",{"SD2"},aOrdem)  
	
	
	TRCell():New(oSection,"EMPRESA"		,"SD2","CODIGO PROD","@!",10)
	TRCell():New(oSection,"D2_FILIAL"	,"SD2","FILIAL","@!",3) 
	TRCell():New(oSection,"D2_COD"		,"SD2","CODIGO","@!",15)
	TRCell():New(oSection,"DESCPA"		,"SB1","DESCRICAO PA","@!",30)   
	TRCell():New(oSection,"UMPA"		,"SB1","UM","@!",3)
	TRCell():New(oSection,"D2_QUANT"  	,"SD2","QTD PA","@E 999,999,999.999",)
	TRCell():New(oSection,"G1_COMP"		,"SG1","COMPONENTE","@!",15)         
	TRCell():New(oSection,"DESCPI"  	,"SB1","DESCRICAO PI","@!",30)
	TRCell():New(oSection,"UMPI"		,"SB1","UM","@!",3)
	TRCell():New(oSection,"G1_QUANT"  	,"SG1","QTD PI","@E 999,999,999.999",)
	

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

		SELECT EMPRESA,D2_FILIAL,D2_COD,DESCPA,UMPA,SUM(D2_QUANT)D2_QUANT,G1_COMP,DESCPI,UMPI,G1_QUANT
		FROM(
				SELECT 'PELMEX' EMPRESA,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,SB1.B1_DESC DESCPA,SB1.B1_UM UMPA,D2_QUANT,G1_COMP,SB12.B1_DESC DESCPI,SB12.B1_UM UMPI,G1_QUANT
				FROM SD2100 SD2 (NOLOCK)
				LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
				INNER JOIN SG1100 SG1 (NOLOCK) ON D2_COD = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.G1_COMP NOT LIKE 'MOD%'
				INNER JOIN SB1100 SB1 (NOLOCK) ON D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
				INNER JOIN SB1100 SB12 (NOLOCK) ON G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
				WHERE SD2.D_E_L_E_T_ = ''
				AND D2_FILIAL = '01'
				AND D2_LOCAL IN ('20','30')
				AND D1_DOC IS NULL
				AND D2_COD NOT LIKE 'TRAV%'
				AND SB1.B1_TIPO IN ('PA','PC')
				AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,SB1.B1_DESC,SB1.B1_UM,D2_QUANT,G1_COMP,SB12.B1_DESC,SB12.B1_UM,G1_QUANT
			UNION
				SELECT 'AMAZON' EMPRESA,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,SB1.B1_DESC DESCPA,SB1.B1_UM UMPA,D2_QUANT,G1_COMP,SB12.B1_DESC DESCPI,SB12.B1_UM UMPI,G1_QUANT
				FROM SD2200 SD2 (NOLOCK)
				LEFT JOIN SD1200 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
				INNER JOIN SG1200 SG1 (NOLOCK) ON D2_COD = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.G1_COMP NOT LIKE 'MOD%'
				INNER JOIN SB1200 SB1 (NOLOCK) ON D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
				INNER JOIN SB1200 SB12 (NOLOCK) ON G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
				WHERE SD2.D_E_L_E_T_ = ''
				AND D2_FILIAL = '01'
				AND D2_LOCAL IN ('20','30')
				AND D1_DOC IS NULL
				AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,SB1.B1_DESC,SB1.B1_UM,D2_QUANT,G1_COMP,SB12.B1_DESC,SB12.B1_UM,G1_QUANT
				)TB
		GROUP BY EMPRESA,D2_FILIAL,D2_COD,DESCPA,UMPA,G1_COMP,DESCPI,UMPI,G1_QUANT
		ORDER BY 1,6 DESC,DESCPI
				
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissão Nota:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Até Emissão Nota:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
Return