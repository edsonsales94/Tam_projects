#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR70    ºAutor  ³Wylliam Silva     				º Data ³  31/03/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Rel. Revisão de Qtd Bloco                               			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR70()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR70"

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

	oReport := TReport():New(cPerg,"Rel. Revisão de Estrutura X Plano de Produção",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Rel. Revisão de Estrutura X Plano Produção",{"PED"},aOrdem)  
	
	
	TRCell():New(oSection,"EMPRESA"			,"PED","EMPRESA","@!",8)
	TRCell():New(oSection,"PED_PRODUTO"		,"PED","PRODUTO","@!",15) 
	TRCell():New(oSection,"PED_DESCRI"		,"PED","DESCRI","@!",30)
	TRCell():New(oSection,"PED_QUANT"		,"PED","QTD","@E 999,999,999,999",)
	TRCell():New(oSection,"PI"				,"SG1","PI","@!",15)
	TRCell():New(oSection,"UMPI"  			,"SB1","UM PI","@!",5)
	TRCell():New(oSection,"QTDPI"			,"SG1","QTD PI","@E 999,999,999.9999",)      
	TRCell():New(oSection,"QTD_CORRECAO"  	,"PED","CORRECAO","@!",30)
	TRCell():New(oSection,"QB"				,"SB1","QB","@E 999,999,999.9999",)
	TRCell():New(oSection,"TOTAL_M3"  		,"SG1","TOTAL M3","@E 999,999,999.9999",)
	TRCell():New(oSection,"QTD_BLOCO"  		,"SG1","QTD_BLOCO","@E 999,999,999.9999",)

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

		SELECT 'PELMEX' EMPRESA,PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS FLOAT)PED_QUANT,SG1.G1_COMP PI,
		       SB1.B1_UM UMPI,SG1.G1_QUANT QTDPI,'' QTD_CORRECAO,
		       SB1.B1_QB QB,SUM(PED_QUANT)*SG1.G1_QUANT TOTAL_M3,(SUM(PED_QUANT)*SG1.G1_QUANT)/CASE WHEN SB1.B1_QB > 0 THEN SB1.B1_QB ELSE 1 END QTD_BLOCO
				FROM(
					SELECT PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT
					FROM PED (NOLOCK)
					WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					)TB
			INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = SG1.G1_COD AND SG1.D_E_L_E_T_ = '' AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
			INNER JOIN SB1100 SB1 (NOLOCK) ON SG1.G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
			WHERE SG1.G1_COMP BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			GROUP BY PED_PRODUTO,PED_DESCRI,SG1.G1_COMP,SB1.B1_DESC,SB1.B1_UM,SG1.G1_QUANT,SB1.B1_QB
			UNION
		SELECT 'AMAZON' EMPRESA,PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS FLOAT)PED_QUANT,SG1.G1_COMP PI,
				SB1.B1_UM,SG1.G1_QUANT,'' QTD_CORRECAO,
				SB1.B1_QB,SUM(PED_QUANT)*SG1.G1_QUANT TOTAL_M3,(SUM(PED_QUANT)*SG1.G1_QUANT)/CASE WHEN SB1.B1_QB > 0 THEN SB1.B1_QB ELSE 1 END QTD_BLOCO
					FROM(
					SELECT PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT
					FROM PED (NOLOCK)
					WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					)TB
			INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = SG1.G1_COD AND SG1.D_E_L_E_T_ = '' AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
			INNER JOIN SG1200 SG12 (NOLOCK) ON SG1.G1_COMP = SG12.G1_COD AND SG12.D_E_L_E_T_ = '' AND SG12.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
			INNER JOIN SB1200 SB1 (NOLOCK) ON SG1.G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
			WHERE SG1.G1_COMP BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			GROUP BY PED_PRODUTO,PED_DESCRI,SG1.G1_COMP,SB1.B1_DESC,SB1.B1_UM,SG1.G1_QUANT,SB1.B1_QB
				
			ORDER BY 2,5,11 DESC
				
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Prod. Pelmex:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Até Dt Prod. Pelmex:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Componente: ",20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Até Componente: ",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
Return