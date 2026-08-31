#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR63    บAutor  ณWylliam Silva     				บ Data ณ  24/02/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Rel. Comparativo de OrdemXSaida Cliente                  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR63()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR63"

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

	oReport := TReport():New(cPerg,"Rel. Comparativo de OrdemXSaida Cliente",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Comparativo de OrdemXSaida Cliente",{"SC2"},aOrdem)  
	
	
	TRCell():New(oSection,"DT_OP"	  			,"SC2","DT_OP","@!",8)             
	TRCell():New(oSection,"OP"  		   		,"SC2","O.P.","@!",10)
	TRCell():New(oSection,"C2_XCARGA"  		  	,"SC2","CARGA","@!",12)
	TRCell():New(oSection,"C6_NOTA"  			 ,"SC6","NOTA","@!",10)
	TRCell():New(oSection,"C6_SERIE"  			,"SC6","SERIE","@!",3)
	TRCell():New(oSection,"PRODUTO"  	  		,"SC2","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"  	  	 	,"SC2","DESCRICAO","@!",30)
	TRCell():New(oSection,"QTD_OP"  		    ,"SC2","QTD_OP","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_SAIDA"  		    ,"SAI","QTD_SAIDA","@E 999,999,999.999",)
	TRCell():New(oSection,"PED_CLIENTE"    		,"PED","COD CLIENTE","@!",8)
	TRCell():New(oSection,"CLIENTE_OP"     		,"SC2","CLIENTE OP","@!",30)
	TRCell():New(oSection,"NOTASAIDA"  			,"SAI","NOTA_SAIDA","@!",10)
	TRCell():New(oSection,"SERIESAI"  			,"SAI","SERIE_SAIDA","@!",3)
	TRCell():New(oSection,"DT_EXPEDICAO"	  	,"SAI","DT EXPEDICAO","@!",8) 
	TRCell():New(oSection,"SAI_CLIENTE"    		,"SAI","COD CLI EXPEDDO","@!",8) 
	TRCell():New(oSection,"CLIENTE_EXPEDIDO"    ,"SC2","CLIENTE_EXPEDIDO","@!",30)
	TRCell():New(oSection,"CNF_MOTORISTA"    	,"CNF","MOTORISTA","@!",25)
	TRCell():New(oSection,"CNF_PLACA"    		,"CNF","PLACA","@!",8)

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

	SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_OP,C2_NUM OP,C2_XCARGA,C6_NOTA,C6_SERIE,
	C2_PRODUTO PRODUTO,B1_DESC DESCRICAO,PED_CLIENTE,C2_QUANT QTD_OP,ISNULL(SUM(SAI_QUANT),0)QTD_SAIDA,
	C2_OBS CLIENTE_OP,ISNULL(SAI_DOC,'')NOTASAIDA,ISNULL(SAI_SERIE,'')SERIESAI,SAI_CLIENTE,ISNULL(SAI_NOME,'')CLIENTE_EXPEDIDO,MAX(ISNULL(SAI_DTEXP,''))DT_EXPEDICAO,
	CNF_MOTORISTA,CNF_PLACA
		FROM SC2100 SC2
					INNER JOIN SB1100 (NOLOCK) SB1 ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
					LEFT JOIN SAI (NOLOCK) ON C2_NUM = SUBSTRING(SAI_CPRODUC,1,6) AND C2_PRODUTO = SAI_PRODUTO AND SAI_NOME NOT LIKE C2_OBS+'$%'
					LEFT JOIN (SELECT PED_OP,PED_PRODUTO,PED_QUANT,PED_NUM,PED_NOME,PED_DTPROPEL,PED_DESCRI,PED_CLIENTE
								FROM PED (NOLOCK)
								INNER JOIN SC2100 (NOLOCK) SC2 ON C2_NUM = PED_OP AND SC2.D_E_L_E_T_ = ''
								WHERE PED_STATUS != 'C'
								GROUP BY PED_OP,PED_PRODUTO,PED_QUANT,PED_NUM,PED_NOME,PED_DTPROPEL,PED_DESCRI,PED_CLIENTE
								) PED ON C2_NUM = PED_OP AND C2_PRODUTO = PED_PRODUTO
					LEFT JOIN SC6100 (NOLOCK) SC6 ON C6_NUM = PED_NUM AND C6_PRODUTO = PED_PRODUTO AND SC6.D_E_L_E_T_ =''
					LEFT JOIN CNF (NOLOCK) ON C6_NOTA = CNF_DOC AND C6_SERIE = CNF_SERIE 	
		WHERE SC2.D_E_L_E_T_ = ''
		AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C2_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
        AND SAI_DOC BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
        AND SAI_SERIE BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		AND B1_DESC NOT LIKE 'BLO%'
		GROUP BY C2_EMISSAO,C2_NUM,SAI_DOC,SAI_SERIE,C2_PRODUTO,B1_DESC,C2_QUANT,C2_OBS,SAI_NOME,C6_NOTA,C6_SERIE,C2_XCARGA,PED_CLIENTE,SAI_CLIENTE,CNF_MOTORISTA,CNF_PLACA
		ORDER BY 1

EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissใo:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Emissใo:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De OP:",20)+"?","","","mv_ch3","C",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("At้ OP:",20)+"?","","","mv_ch4","C",8,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Nota:",20)+"?","","","mv_ch5","C",9,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("At้ Nota:",20)+"?","","","mv_ch6","C",9,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De Serie:",20)+"?","","","mv_ch7","C",3,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("At้ Serie:",20)+"?","","","mv_ch8","C",3,0,0,"G","","","","","mv_par08")
	
	
Return