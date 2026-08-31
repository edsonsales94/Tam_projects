#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR29    บAutor  ณWYLLIAM Silva     				บ Data ณ  18/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Rel. Faturamento Estoque                                      			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR29()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR29"

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

	oReport := TReport():New(cPerg,"Rel. Faturamento Estoque",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Faturamento Estoque",{"SD2"},aOrdem) 

	TRCell():New(oSection,"D2_FILIAL"        ,"SD2","FILIAL","@!",3)
    TRCell():New(oSection,"D2_COD"          ,"SD2","CODIGO PROD","@!",20)
	TRCell():New(oSection,"B1_DESC"		    ,"SB1","DESC. PROD.","@!",35)
	TRCell():New(oSection,"D2_QUANT"		,"SD2","QUANT","@E 999,999,999.99",)
	TRCell():New(oSection,"D2_PRCVEN"	    ,"SD2","PRCVEND","@E 999,999,999.99",)
    TRCell():New(oSection,"D2_TOTAL"	    ,"SD2","TOTAL","@E 999,999,999.99",)
    TRCell():New(oSection,"D2_TES"	        ,"SD2","TES","@!",5)
    TRCell():New(oSection,"D2_CF"	        ,"SD2","CFOP","@!",8)
    TRCell():New(oSection,"BM_GRUPO"	    ,"SD2","COD.GRUPO","@!",8)
    TRCell():New(oSection,"BM_DESC"	        ,"SD2","DESC. GRUPO","@!",35)
    TRCell():New(oSection,"D2_DOC"	        ,"SD2","NOTA FISCAL","@!",10)
    TRCell():New(oSection,"D2_SERIE"	    ,"SD2","NF SERIE","@!",3)
    TRCell():New(oSection,"D2_TP"	        ,"SD2","TIPO","@!",3)
    TRCell():New(oSection,"DTEMISSAO"	    ,"SD2","DTEMISSAO","@!",10)
    TRCell():New(oSection,"D2_CUSTO1"	    ,"SD2","CUSTO1","@E 999,999,999.99",)
    TRCell():New(oSection,"D2_QTSEGUM"	    ,"SD2","SEGUM_NOTA","@E 999,999,999.99",)
    TRCell():New(oSection,"QTSEGUM_CONV"	,"SD2","QTSEGUM_CONVERT","@E 999,999,999.99",)
    TRCell():New(oSection,"D2_EST"	         ,"SD2","ESTADO","@!",3)
	TRCell():New(oSection,"D2_CLIENTE"	      ,"SD2","COD_CLIENTE","@!",3)
	TRCell():New(oSection,"A1_NOME"	         ,"SA1","NOME_CLIENT","@!",35)
	TRCell():New(oSection,"TPTRIB"	         ,"SA1","TP_TRIBUTARIO_CLIENTE","@!",10)
	TRCell():New(oSection,"CUSTOUNIT"	         ,"SA1","CUSTO_UNIT","@E 999,999,999.99",)
	TRCell():New(oSection,"DIFCUSTO"	         ,"SA1","DIF_CUSTO","@E 999,999,999.99",)
	
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

	SELECT D2_FILIAL,D2_COD,B1_DESC,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_TES,D2_CF,BM_GRUPO,BM_DESC,D2_DOC,D2_SERIE,D2_TP,
		CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103)DTEMISSAO,D2_CUSTO1,D2_QTSEGUM,(B1_CONV*D2_QUANT) QTSEGUM_CONV, D2_EST,
		D2_CLIENTE,A1_NOME,CASE WHEN A1_TPTRIBU = '1' THEN 'LUCRO'
								WHEN A1_TPTRIBU = '2' THEN 'LUCRO PRESUMIDO' 
								WHEN A1_TPTRIBU = '3' THEN 'OPTANTE'
								ELSE 'NรO INFORMADO' END TPTRIB,
		(D2_CUSTO1/D2_QUANT) CUSTOUNIT, (D2_PRCVEN-(D2_CUSTO1/D2_QUANT)) DIFCUSTO
    FROM %Table:SD2% SD2
    LEFT JOIN %Table:SB1% SB1 ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ''
    LEFT JOIN %Table:SBM% SBM ON BM_GRUPO = D2_GRUPO AND SBM.D_E_L_E_T_ =''
	INNER JOIN %Table:SA1% SA1 ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA1.D_E_L_E_T_ =''
    WHERE SD2.D_E_L_E_T_ =''
    AND D2_TP IN ('PA','PI')
    AND CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND D2_FILIAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
    ORDER BY CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),112)

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("Ini Emissao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Fim DT Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Filial:" ,20)+"?","","","mv_ch3","C",3,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Filial:",20)+"?","","","mv_ch4","C",3,0,0,"G","","","","","mv_par04")
	
	
	
Return
