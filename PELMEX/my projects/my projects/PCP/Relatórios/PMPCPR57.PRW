#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR57    ºAutor  ³Wylliam Silva     				º Data ³  10/02/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Controle de Atividades                                   			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR57()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR57"

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

	oReport := TReport():New(cPerg,"Controle de Atividades",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Controle de Atividades",{"SC2"},aOrdem)  
	
	TRCell():New(oSection,"DT_OP"	        ,"SC2","DATA EMISSAO","@!",8)             
	TRCell():New(oSection,"OP"              ,"SC2","ORDEM PROD.","@!",8)
	TRCell():New(oSection,"PA"	            ,"SC2","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"	    ,"SB1","DESCRICAO","@!",30)
	TRCell():New(oSection,"QTD_OP"	        ,"SC2","QTDE","@E 999,999,999.99",)
	TRCell():New(oSection,"QTD_BASE"	    ,"SB1","QTDE BASE","@E 999,999,999.99",)
	TRCell():New(oSection,"PI"	            ,"SD4","PI","@!",15)
	TRCell():New(oSection,"DESCRICAO_PI"    ,"SB12","DESCRICAO PI","@!",15)
	TRCell():New(oSection,"UM"	            ,"SB12","UM","@!",2)
	TRCell():New(oSection,"ARMAZEM"	        ,"SD4","ARMAZEM","@!",6)
	TRCell():New(oSection,"QTD_ESTRUTURA"	,"SG1","QTDE ESTRUTURA","@E 999,999,999.999999",)
	TRCell():New(oSection,"QTD_EMPENHO"	    ,"SD4","QTDE EMPENHO","@E 999,999,999.999999",)
	TRCell():New(oSection,"C_TRABALHO"	    ,"SG2","C_TRABALHO","@!",18)
	TRCell():New(oSection,"RECURSO"	        ,"SH1","RECURSO","@!",18)  
	TRCell():New(oSection,"ATIVIDADE"	    ,"SG2","ATIVIDADE","@!",18)
	TRCell():New(oSection,"PONTO"	        ,"SG2","PONTO","@E 999,999,999.99",)
	TRCell():New(oSection,"TOTAL_PONTOS"	,"SD4","TOTAL PONTOS","@E 999,999,999.999999",)
	TRCell():New(oSection,"CMO70"	        ,"SD4","CMO70","@E 999,999,999.999999",)
	TRCell():New(oSection,"CMO100"	        ,"SD4","CMO100","@E 999,999,999.999999",)
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

SELECT DT_OP,SUBSTRING(OP,1,6)OP,PA,DESCRICAO,SUM(QTD_OP)QTD_OP,QTD_BASE,DESCRICAO_PI,UM,QTD_ESTRUTURA,SUM(QTD_OP)*QTD_ESTRUTURA QTD_EMPENHO,C_TRABALHO,RECURSO,ATIVIDADE,PONTO,TOTAL_PONTOS,CMO70,CMO100
		FROM(SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_OP,C2_NUM+C2_ITEM OP,C2_PRODUTO PA,SB1.B1_DESC DESCRICAO,C2_QUANT QTD_OP,SB1.B1_QB QTD_BASE,D4_COD PI,
			   SB12.B1_DESC DESCRICAO_PI,SB12.B1_UM UM,D4_LOCAL ARMAZEM,
			   G1_QUANT QTD_ESTRUTURA,D4_QTDEORI QTD_EMPENHO,
		       G2_CTRAB+' - '+HB_NOME C_TRABALHO,
		       H1_CODIGO+' - '+H1_DESCRI RECURSO,
		       G2_CODIGO+G2_OPERAC+' - '+G2_DESCRI ATIVIDADE,
		       G2_TEMPAD PONTO,
		        CASE WHEN SB1.B1_XJUNCAO = 'S' THEN ((D4_QTDEORI*2)*G2_TEMPAD) ELSE (D4_QTDEORI*G2_TEMPAD) END TOTAL_PONTOS,
		      (D4_QTDEORI*G2_TEMPAD)/528 CMO70,
		      (D4_QTDEORI*G2_TEMPAD)/755 CMO100
				FROM SC2100 SC2 (NOLOCK)
				INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
				INNER JOIN SG1100 SG1 (NOLOCK) ON C2_PRODUTO = G1_COD AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
				INNER JOIN SD4100 SD4 (NOLOCK) ON C2_NUM = SUBSTRING(D4_OP,1,6) AND D4_COD = G1_COMP AND G1_TRT = D4_SEQ AND SD4.D_E_L_E_T_ = ''
				LEFT JOIN SG2100 SG2 (NOLOCK) ON D4_COD = G2_PRODUTO AND SG2.D_E_L_E_T_ = ''
				LEFT JOIN SHB100 SHB (NOLOCK) ON G2_CTRAB = HB_COD AND SHB.D_E_L_E_T_ = ''
				LEFT JOIN SH1100 SH1 (NOLOCK) ON G2_RECURSO = H1_CODIGO AND SH1.D_E_L_E_T_ = ''
				LEFT JOIN SB1100 SB12 (NOLOCK) ON D4_COD = SB12.B1_COD  AND SB12.D_E_L_E_T_ = ''
				WHERE SC2.D_E_L_E_T_ = ''
				AND D4_COD NOT LIKE 'MOD%'
				AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND C2_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
				AND G2_CTRAB BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		)TB
	GROUP BY DT_OP,SUBSTRING(OP,1,6),PA,DESCRICAO,QTD_BASE,DESCRICAO_PI,UM,QTD_ESTRUTURA,C_TRABALHO,RECURSO,ATIVIDADE,PONTO,TOTAL_PONTOS,CMO70,CMO100
UNION
SELECT DT_OP,SUBSTRING(OP,1,6)OP,PA,DESCRICAO,SUM(QTD_OP)QTD_OP,QTD_BASE,DESCRICAO_PI,UM,QTD_ESTRUTURA,SUM(QTD_OP)*QTD_ESTRUTURA QTD_EMPENHO,C_TRABALHO,RECURSO,ATIVIDADE,PONTO,TOTAL_PONTOS,CMO70,CMO100
FROM(
		SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_OP,C2_NUM+C2_ITEM OP,C2_PRODUTO PA,SB1.B1_DESC DESCRICAO,C2_QUANT QTD_OP,SB1.B1_QB QTD_BASE,
		       C2_PRODUTO PI,SB1.B1_DESC DESCRICAO_PI,SB1.B1_UM UM,'10' ARMAZEM,
		       CASE WHEN SB1.B1_XJUNCAO = 'S' THEN 2 ELSE 1 END QTD_ESTRUTURA,C2_QUANT QTD_EMPENHO,
		       G2_CTRAB+' - '+HB_NOME C_TRABALHO,
		       H1_CODIGO+' - '+H1_DESCRI RECURSO,
		       G2_CODIGO+G2_OPERAC+' - '+G2_DESCRI ATIVIDADE,
		       G2_TEMPAD PONTO,
		       CASE WHEN SB1.B1_XJUNCAO = 'S' THEN ((C2_QUANT*2)*G2_TEMPAD) ELSE (C2_QUANT*G2_TEMPAD) END TOTAL_PONTOS,
		       (C2_QUANT*G2_TEMPAD)/528 CMO70,
		       (C2_QUANT*G2_TEMPAD)/755 CMO100
		FROM SC2100 SC2 (NOLOCK)
		INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN SG2100 SG2 (NOLOCK) ON C2_PRODUTO = G2_PRODUTO AND SG2.D_E_L_E_T_ = ''
		LEFT JOIN SHB100 SHB (NOLOCK) ON G2_CTRAB = HB_COD AND SHB.D_E_L_E_T_ = ''
		LEFT JOIN SH1100 SH1 (NOLOCK) ON G2_RECURSO = H1_CODIGO AND SH1.D_E_L_E_T_ = ''
		WHERE SC2.D_E_L_E_T_ = ''
		AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C2_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND G2_CTRAB BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		)TB
GROUP BY DT_OP,SUBSTRING(OP,1,6),PA,DESCRICAO,QTD_BASE,DESCRICAO_PI,UM,QTD_ESTRUTURA,C_TRABALHO,RECURSO,ATIVIDADE,PONTO,TOTAL_PONTOS,CMO70,CMO100	
ORDER BY OP,12,13,14
	

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Emissao:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt. Emissao:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Dt Ordem:",20)+"?","","","mv_ch3","C",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Dt. Ordem:",20)+"?","","","mv_ch4","C",8,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Centro Trab.:",20)+"?","","","mv_ch5","C",6,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate Centro Trab.:",20)+"?","","","mv_ch6","C",6,0,0,"G","","","","","mv_par06")
	
Return