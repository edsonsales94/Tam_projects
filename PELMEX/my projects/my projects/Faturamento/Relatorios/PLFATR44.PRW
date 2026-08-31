#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR44    บAutor  ณWylliam Silva     				บ Data ณ  28/02/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Rel. Recebimento de Material                             			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR44()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR44"

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

	oReport := TReport():New(cPerg,"Rel. Recebimento de Material ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Recebimento de Material",{"SD2"},aOrdem)  
	
	
	TRCell():New(oSection,"FILORI"	  			,"SD2","FILIAL RI","@!",4)             
	TRCell():New(oSection,"FILDEST"  		   	,"SD2","FILIAL DEST","@!",4)
	TRCell():New(oSection,"D2_DOC"  		  	,"SD2","NOTA","@!",10)
	TRCell():New(oSection,"D2_SERIE"  			,"SDI","SERIE","@!",3)
	TRCell():New(oSection,"D2_ITEM"  	  		 ,"SD2","ITEM","@!",3)
	TRCell():New(oSection,"D2_COD"  	  		 ,"SD2","PRODUTO","@!",15)
	TRCell():New(oSection,"B1_DESC"  	  	 	,"SB1","DESCRICAO","@!",30)
	TRCell():New(oSection,"D2_QUANT"  		   ,"SD2","QTD","@E 999,999,999.999",)
	TRCell():New(oSection,"REC_QUANT"  		   ,"REC","QTD_RECEB","@E 999,999,999.999",)
	TRCell():New(oSection,"D2_CLIENTE"     	 	,"SD2","COD.CLIENTE","@!",10)
	TRCell():New(oSection,"A1_NOME"    			 ,"SA1","NOME","@!",30)
	

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

		SELECT D2_FILIAL FILORI,ISNULL(REC_FILDEST,'')FILDEST,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,ISNULL(REC_QUANT,0)REC_QUANT,D2_CLIENTE,A1_NOME
			FROM SD2100 SD2 (NOLOCK)
			INNER JOIN SB1100 SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
			INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
			LEFT JOIN  SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
			LEFT JOIN ( SELECT REC_EMPRESA,REC_FILORI,REC_FILDEST,REC_DOC,REC_SERIE,REC_ITEM,REC_PRODUTO,REC_DESCRI,SUM(REC_QUANT)REC_QUANT,REC_DTEXP,REC_CLIENTE,REC_NOME
				            FROM REC (NOLOCK)
				            LEFT JOIN DEV (NOLOCK) ON REC_CPRODUC = DEV_CPRODUC AND REC_DOC = DEV_DOC AND REC_SERIE = DEV_SERIE
					      WHERE CONVERT(VARCHAR,CAST(REC_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					      AND DEV_CPRODUC IS NULL
					      GROUP BY REC_EMPRESA,REC_FILORI,REC_FILDEST,REC_DOC,REC_SERIE,REC_ITEM,REC_PRODUTO,
					               REC_DESCRI,REC_DTEXP,REC_CLIENTE,REC_NOME)REC ON D2_FILIAL = REC_FILORI AND D2_DOC = REC_DOC 
					                                                                AND D2_SERIE = REC_SERIE AND D2_ITEM = REC_ITEM 
					                                    AND D2_COD = REC_PRODUTO
		WHERE SD2.D_E_L_E_T_ = ''
		AND D1_DOC IS NULL
		AND D2_SERIE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND D2_DOC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND D2_DOC+D2_SERIE IN (SELECT REC_DOC+REC_SERIE
		                        FROM REC (NOLOCK)
		                        LEFT JOIN DEV (NOLOCK) ON REC_CPRODUC = DEV_CPRODUC AND REC_DOC = DEV_DOC AND REC_SERIE = DEV_SERIE
					            WHERE CONVERT(VARCHAR,CAST(REC_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
					            AND DEV_CPRODUC IS NULL
					            GROUP BY REC_DOC+REC_SERIE)

		UNION

		SELECT '' D2_FILIAL,REC_FILDEST,'' D2_DOC,'' D2_SERIE, '' D2_ITEM,C2_PRODUTO D2_COD,B1_DESC,0 D2_QUANT,SUM(REC_QUANT)REC_QUANT,'' D2_CLIENTE,'' A1_NOME
		FROM SC2100 SC2 (NOLOCK)
		INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN REC (NOLOCK) ON C2_NUM = SUBSTRING(REC_CPRODUC,1,6) AND C2_PRODUTO = REC_PRODUTO
		LEFT JOIN DEV (NOLOCK) ON REC_CPRODUC = DEV_CPRODUC AND REC_DOC = DEV_DOC AND REC_SERIE = DEV_SERIE
		WHERE REC_DOC = ''
		AND CONVERT(VARCHAR,CAST(REC_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY REC_FILDEST,C2_PRODUTO,B1_DESC
		
		ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM


EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissใo:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Emissใo:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Nota:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("At้ Nota:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Serie:",20)+"?","","","mv_ch5","C",2,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("At้ Serie:",20)+"?","","","mv_ch6","C",2,0,0,"G","","","","","mv_par06")
	
Return