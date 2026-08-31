#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR20    บAutor  ณWylliam Silva     				บ Data ณ  15/02/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Rela็ใo Picklist X Transfer๊ncia				  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR20()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR20"

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

	oReport := TReport():New(cPerg,"Rel. Rela็ใo Picklist X Transfer๊ncia",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Rela็ใo Picklist X Transfer๊ncia",{"PED"},aOrdem)  


	TRCell():New(oSection,"EMPRESA"				,"SB2","EMPRESA","@!",4)             
	TRCell():New(oSection,"PRODUTO" 			,"SG1","PRODUTO","@!",15) 
	TRCell():New(oSection,"DESCRICAO"  			,"SB2","DESCRICAO","@!",50)
	TRCell():New(oSection,"UM"    	   			,"SB1","UM","@!",5)
	TRCell():New(oSection,"QTD_PICKLIST"    	,"PED","QTD PICKLIST","@E 999,999,999.99",)
	TRCell():New(oSection,"QTD_TRANSFERIDA"   	,"SD3","QTD TRANSFERIDA","@E 999,999,999.99",)
	TRCell():New(oSection,"DIFERENCA"    		,"PED","DIFERENCA","@E 999,999,999.99",)

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

		SELECT EMPRESA,G1_COMP PRODUTO,B1_DESC DESCRICAO,B1_UM UM,ISNULL(SUM(QTD_PICKLIST),'')QTD_PICKLIST,ISNULL(SUM(QTD_TRANSFERIDA),'')QTD_TRANSFERIDA,
		CASE WHEN SUM(QTD_TRANSFERIDA)< 0 THEN (SUM(QTD_TRANSFERIDA)*-1) - SUM(QTD_PICKLIST) ELSE SUM(QTD_TRANSFERIDA)-SUM(QTD_PICKLIST) END DIFERENCA
		FROM(
		  SELECT 'PELMEX' EMPRESA,G1_COMP,B1_DESC,B1_UM,SUM(TOTAL)QTD_PICKLIST,0 QTD_TRANSFERIDA
		  FROM(
		      SELECT PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS INT)PED_QUANT,G1_COMP,SB1.B1_DESC,SB1.B1_UM,G1_QUANT,SUM(PED_QUANT)*G1_QUANT TOTAL
		      FROM(
		      SELECT *
		      FROM PED
		      WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		  )TB
		  INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = ''
		  INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		  GROUP BY PED_PRODUTO,PED_DESCRI,G1_COMP,SB1.B1_DESC,SB1.B1_UM,G1_QUANT
		)TB1
		WHERE B1_DESC NOT LIKE 'ART%'
		AND B1_DESC NOT LIKE 'SUP%'
		AND G1_COMP NOT LIKE 'MOD%'
		GROUP BY G1_COMP,B1_DESC,B1_UM
		
		UNION
		
		SELECT 'PELMEX' EMPRESA,D3_COD,B1_DESC,B1_UM,0 QTD_PICKILIST,
		       CASE WHEN D3_TM = '501' THEN SUM(D3_QUANT)
		          WHEN D3_TM = '101' THEN SUM(D3_QUANT)*-1 END QTD_TRANSFERIDA
		FROM SD3100 SD3
		INNER JOIN SB1100 SB1 (NOLOCK) ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE SD3.D_E_L_E_T_ = ''
		AND D3_FILIAL = '01'
		AND D3_TM IN ('101','501')
		AND B1_DESC NOT LIKE 'ART%'
		AND B1_DESC NOT LIKE 'SUP%'
		AND D3_COD NOT LIKE 'MOD%'
		AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY D3_COD,B1_DESC,B1_UM,D3_TM
		)TB2
		//WHERE G1_COMP = '10010024'
		GROUP BY EMPRESA,G1_COMP,B1_DESC,B1_UM
		
		UNION
		
		SELECT EMPRESA,G1_COMP,B1_DESC,B1_UM,ISNULL(SUM(QTD_PICKLIST),'')QTD_PICKLIST,ISNULL(SUM(QTD_TRANSFERIDA),'')QTD_TRANSFERIDA,
				CASE WHEN SUM(QTD_TRANSFERIDA)< 0 THEN (SUM(QTD_TRANSFERIDA)*-1) - SUM(QTD_PICKLIST) ELSE SUM(QTD_TRANSFERIDA)-SUM(QTD_PICKLIST) END DIFERENCA
		FROM(
		  SELECT 'AMAZON' EMPRESA,G1_COMP,B1_DESC,B1_UM,SUM(TOTAL)QTD_PICKLIST,0 QTD_TRANSFERIDA
		  FROM(
		    SELECT PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS INT)PED_QUANT,SG12.G1_COMP,SB12.B1_DESC,SB12.B1_UM,SG12.G1_QUANT,SUM(PED_QUANT)*SG12.G1_QUANT TOTAL
		    FROM(
		      SELECT *
		      FROM PED
		      WHERE CONVERT(VARCHAR,CAST(PED_DTPROAMA AS DATE),112) BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		    )TB
		    INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = SG1.G1_COD AND SG1.D_E_L_E_T_ = ''
		    INNER JOIN SB1200 SB1 (NOLOCK) ON SG1.G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		    INNER JOIN SG1200 SG12 (NOLOCK) ON SG1.G1_COMP = SG12.G1_COD AND SG12.D_E_L_E_T_ = ''
		    INNER JOIN SB1200 SB12 (NOLOCK) ON SG12.G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
		    GROUP BY PED_PRODUTO,PED_DESCRI,SG12.G1_COMP,SB12.B1_DESC,SB12.B1_UM,SG12.G1_QUANT
		  )TB1
		  WHERE G1_COMP NOT LIKE 'MOD%'
		  GROUP BY G1_COMP,B1_DESC,B1_UM,G1_QUANT
		
		UNION
		
		  SELECT 'AMAZON' EMPRESA,D3_COD,B1_DESC,B1_UM,0 QTD_PICKILIST,
		       CASE WHEN D3_TM = '501' THEN SUM(D3_QUANT)
		        WHEN D3_TM = '101' THEN SUM(D3_QUANT)*-1 END QTD_TRANSFERIDA
		  FROM SD3200 SD3
		  INNER JOIN SB1200 SB1 (NOLOCK) ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		  WHERE SD3.D_E_L_E_T_ = ''
		  AND D3_FILIAL = '01'
		  AND D3_TM IN ('101','501')
		  AND D3_COD NOT LIKE 'MOD%'
		  AND D3_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		  GROUP BY D3_COD,B1_DESC,B1_UM,D3_TM
		)TB2
		//WHERE G1_COMP = '01020065'
		GROUP BY EMPRESA,G1_COMP,B1_DESC,B1_UM
	ORDER BY EMPRESA,B1_DESC


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Prod. Pelmex:" ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Prod. Pelmex:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Prod. Amazon:" ,20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Prod. Amazon:",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
Return