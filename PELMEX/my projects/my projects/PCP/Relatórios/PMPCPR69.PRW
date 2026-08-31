#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR69    ºAutor  ³Wylliam Silva     				º Data ³  30/03/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Relatório de Produção Por Pontos                           			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR69()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR69"

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

	oReport := TReport():New(cPerg,"Relatório de Produção Por Pontos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Relatório de Produção Por Pontos",{"CLA"},aOrdem)  

	TRCell():New(oSection,"PA"				,"CLA","PA","@!",15)
	TRCell():New(oSection,"PADESCRI"		,"CLA","PA DESCRI","@!",30) 
	TRCell():New(oSection,"PAQTD"			,"CLA","PA QTD","@E 999,999,999,999",)   
	TRCell():New(oSection,"PONTOS"			,"SG2","PONTOS","@E 999,999,999.999",)
	TRCell():New(oSection,"TOTAL"  			,"SG2","TOTAL","@E 999,999,999.999",)
	TRCell():New(oSection,"COD_RECURSO"		,"SH1","COD RECURSO","@!",15)         
	TRCell():New(oSection,"RECURSO"  		,"SH1","DESC. RECURSO","@!",30)
	TRCell():New(oSection,"COD_ATIVIDADE"	,"SH1","COD ATIVIDADE","@!",15)
	TRCell():New(oSection,"ATIVIDADE"  		,"SH1","DESC. ATIVIDADE","@!",30)
	TRCell():New(oSection,"MATRICULA"  		,"CLA","MATRICULA","@!",8)
	TRCell():New(oSection,"FUNCIONARIO"  	,"SRA","NOME FUNCIONARIO","@!",30)
	TRCell():New(oSection,"DT_INCLUSAO"		,"CLA","DT INCLUSAO","@!",8) 
	/*TRCell():New(oSection,"PIDESCAMA"		,"SB1","DESC. PI AMAZ","@!",30)
	TRCell():New(oSection,"PIUMAM"			,"SB1","UM PI AMA","@!",8)
	TRCell():New(oSection,"PIQTDAMA"  		,"SG1","QTD PI AMA","@E 999,999,999.999",)
	TRCell():New(oSection,"PITOTALAMA"  	,"SG1","QTD PI TTL AMA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_ESTAMA01"  	,"SB2","QTD ESTAMA01","@E 999,999,999.999",)*/
	
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

	SELECT CLA_COD PA,CLA_DESCRI PADESCRI,CLA_QUANT PAQTD,G2_TEMPAD PONTOS,TOTAL,H1_CODIGO COD_RECURSO,H1_DESCRI RECURSO,COD_ATIVIDADE,ATIVIDADE,CLA_USERINC MATRICULA,RA_NOME FUNCIONARIO,CLA_DATINC DT_INCLUSAO
			FROM(
					SELECT CLA_COD,CLA_DESCRI,SUM(CLA_QUANT)CLA_QUANT,G2_TEMPAD,SUM(CLA_QUANT)*G2_TEMPAD TOTAL,H1_CODIGO,H1_DESCRI,G2_CODIGO+G2_OPERAC COD_ATIVIDADE,G2_DESCRI ATIVIDADE,CLA_USERINC,RA_NOME,CLA_DATINC
					FROM CLA (NOLOCK)
					INNER JOIN SRA100 SRA (NOLOCK) ON CLA_USERINC = RA_MAT AND RA_FILIAL = '01' AND SRA.D_E_L_E_T_ = ''
					INNER JOIN SB1100 SB1 (NOLOCK) ON CLA_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
					LEFT JOIN SG2100 SG2 (NOLOCK) ON CLA_COD = G2_PRODUTO AND SG2.D_E_L_E_T_ = '' AND G2_RECURSO LIKE '040%'
					LEFT JOIN SH1100 SH1 (NOLOCK) ON G2_RECURSO = H1_CODIGO AND G2_CTRAB = H1_CTRAB AND SH1.D_E_L_E_T_ = ''
					WHERE CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					GROUP BY CLA_COD,CLA_DESCRI,G2_TEMPAD,H1_CODIGO,H1_DESCRI,G2_CODIGO,G2_OPERAC,G2_DESCRI,
					         CLA_USERINC,RA_NOME,CLA_DATINC
					UNION
					SELECT CLB_COD,CLB_DESCRI,SUM(CLB_QUANT)CLB_QUANT,G2_TEMPAD,SUM(CLB_QUANT)*G2_TEMPAD TOTAL,H1_CODIGO,H1_DESCRI,G2_CODIGO+G2_OPERAC COD_ATIVIDADE,G2_DESCRI ATIVIDADE,CLB_USERINC,RA_NOME,CLB_DATINC
					FROM CLB (NOLOCK)
					INNER JOIN SRA100 SRA (NOLOCK) ON CLB_USERINC = RA_MAT AND RA_FILIAL = '01' AND SRA.D_E_L_E_T_ = ''
					INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
					LEFT JOIN SG2100 SG2 (NOLOCK) ON CLB_COD = G2_PRODUTO AND SG2.D_E_L_E_T_ = '' AND G2_RECURSO LIKE '020%'
					LEFT JOIN SH1100 SH1 (NOLOCK) ON G2_RECURSO = H1_CODIGO AND G2_CTRAB = H1_CTRAB AND SH1.D_E_L_E_T_ = ''
					WHERE CONVERT(VARCHAR,CAST(CLB_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					GROUP BY CLB_COD,CLB_DESCRI,G2_TEMPAD,H1_CODIGO,H1_DESCRI,G2_CODIGO,G2_OPERAC,G2_DESCRI,
					         CLB_USERINC,RA_NOME,CLB_DATINC
					UNION
					SELECT CLD_COD,CLD_DESCRI,SUM(CLD_QUANT)CLD_QUANT,G2_TEMPAD,SUM(CLD_QUANT)*G2_TEMPAD TOTAL,H1_CODIGO,H1_DESCRI,G2_CODIGO+G2_OPERAC COD_ATIVIDADE,G2_DESCRI ATIVIDADE,CLD_USERINC,RA_NOME,CLD_DATINC
					FROM CLD (NOLOCK)
					INNER JOIN SRA100 SRA (NOLOCK) ON CLD_USERINC = RA_MAT AND RA_FILIAL = '01' AND SRA.D_E_L_E_T_ = ''
					INNER JOIN SB1100 SB1 (NOLOCK) ON CLD_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
					LEFT JOIN SG2100 SG2 (NOLOCK) ON CLD_COD = G2_PRODUTO AND SG2.D_E_L_E_T_ = '' AND G2_RECURSO LIKE '020%'
					LEFT JOIN SH1100 SH1 (NOLOCK) ON G2_RECURSO = H1_CODIGO AND G2_CTRAB = H1_CTRAB AND SH1.D_E_L_E_T_ = ''
					WHERE CONVERT(VARCHAR,CAST(CLD_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					GROUP BY CLD_COD,CLD_DESCRI,G2_TEMPAD,H1_CODIGO,H1_DESCRI,G2_CODIGO,G2_OPERAC,G2_DESCRI,
					         CLD_USERINC,RA_NOME,CLD_DATINC
					UNION
					SELECT C2_PRODUTO,B1_DESC,
					       CASE WHEN SUM(C2_QUANT) > SUM(C2_QUJE) THEN SUM(C2_QUJE) ELSE SUM(C2_QUANT) END C2_QUANT,
					       G2_TEMPAD,CASE WHEN SUM(C2_QUANT) > SUM(C2_QUJE) THEN SUM(C2_QUJE)*G2_TEMPAD ELSE SUM(C2_QUANT)*G2_TEMPAD END TOTAL,
					       H1_CODIGO,H1_DESCRI,G2_CODIGO+G2_OPERAC COD_ATIVIDADE,G2_DESCRI ATIVIDADE,
					       '' RA_MAT,'' RA_NOME,CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)C2_EMISSAO
					FROM SC2200 SC2 (NOLOCK)
					INNER JOIN SB1200 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
					LEFT JOIN SG2100 SG2 (NOLOCK) ON C2_PRODUTO = G2_PRODUTO AND SG2.D_E_L_E_T_ = ''
					LEFT JOIN SH1100 SH1 (NOLOCK) ON G2_RECURSO = H1_CODIGO AND G2_CTRAB = H1_CTRAB AND SH1.D_E_L_E_T_ = ''
					WHERE C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					AND B1_DESC LIKE 'SUP%'
					GROUP BY C2_PRODUTO,B1_DESC,G2_TEMPAD,H1_CODIGO,H1_DESCRI,G2_CODIGO,G2_OPERAC,G2_DESCRI,
					         C2_EMISSAO
					)TB
			ORDER BY CLA_USERINC,CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112),CLA_DESCRI,H1_CODIGO
		
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De DT Prod PEL:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Até DT Prod PEL:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	

	
Return