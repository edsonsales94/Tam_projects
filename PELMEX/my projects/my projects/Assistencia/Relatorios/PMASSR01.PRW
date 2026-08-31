#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de etiquetas antigas						        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMASSR01()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMASSR01"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return                                        

Static Function ReportDef(cAlias,cPerg)
	Local oReport := Nil
	Local oSection:= Nil
	Local oBreak
	Local aOrdem      := {"FILIAL"}



	oReport := TReport():New(cPerg,"Relatorio de Saida das Etiquetas antigas",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()    
	oReport:SetEnvironment(2)      


	//Primeira se็ใo


	oSection:= TRSection():New(oReport, "Saida das Etiquetas", {"SAI"},aOrdem)   


	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas


	TRCell():New(oSection,"nota_fiscal"	    		,"cAlias","Nota Fiscal",,9)
	TRCell():New(oSection,"cod_cliente"		    	,"cAlias","Codigo do Cliente",,)
	TRCell():New(oSection,"cliente"					,"cAlias","Nome do Cliente",/*Mascara*/,60)    
	TRCell():New(oSection,"codigo_produto_siga"	    ,"cAlias","Codigo do Produto",/*Mascara*/,30)
	TRCell():New(oSection,"B1_DESC"		   			,"cAlias","Descri็ใo do Produto",,30)        
	TRCell():New(oSection,"Z4_CPRODUC"	   			,"cAlias","Etiqueta",,30)
	TRCell():New(oSection,"pn_chassis"	   			,"cAlias","Chassis",,30)     
	TRCell():New(oSection,"data_leitura"	   		,"cAlias","Data da Leitura",,30)     



	//Quebra por Se็ใo                         N4


	//	TRFunction():New(oSection2:Cell("TOTALVEND"),"Total:   ","SUM",oBreak,,,,.F.,.F.)
	//	TRFunction():New(oSection2:Cell("D2_TOTAL"),"Total : ","SUM",oBreak,,,,.F.,.F.)  


	//Fim Quebra por Se็ใo

	//Totalizador final





	//Totalizador                                                                                                          MIC

	/* 

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	//quebra  por se็ใo (.T.) uma se็ใo por pagina		
Return(oReport)



/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%    




		SELECT   nota_fiscal,cod_cliente,cliente,codigo_produto_siga,B1_DESC
		,isnull(Z4_CPRODUC,'SEM ETIQUETA') Z4_CPRODUC,pn_chassi,CONVERT(VARCHAR(8), CAST(data_leitura AS DATE), 112) data_leitura
		FROM SZ4100 
		LEFT JOIN dbPelmex.dbo.set_embarque_item sei on  sei.pn_chassi COLLATE Latin1_General_BIN = Z4_CEXPEDI
		LEFT JOIN dbPelmex.dbo.set_embarque se on se.id_embarque = sei.id_embarque
		INNER JOIN SB1100 (NOLOCK) ON B1_COD = codigo_produto_siga COLLATE Latin1_General_BIN
		where codigo_produto_siga between %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SUBSTRING(Z4_CPRODUC,1,6) between %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
		AND nota_fiscal between %Exp:MV_PAR05% AND %Exp:MV_PAR06% 
		AND cod_cliente between %Exp:MV_PAR07% AND %Exp:MV_PAR08% 
		AND CONVERT(VARCHAR(8), CAST(data_leitura AS DATE), 112) BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10% 


		UNION 

		SELECT   SAI_DOC COLLATE Latin1_General_CI_AI  nota_fiscal, SAI_CLIENTE COLLATE Latin1_General_CI_AI cod_cliente,SAI_NOME COLLATE Latin1_General_CI_AI  cliente
		, SAI_PRODUTO COLLATE Latin1_General_CI_AI  codigo_produto_siga,SAI_DESCPROD COLLATE Latin1_General_CI_AI  B1_DESC
		,SAI_CPRODUC COLLATE Latin1_General_CI_AI  Z4_CPRODUC,SAI_CEXPEDI COLLATE Latin1_General_CI_AI  pn_chassi,CONVERT(VARCHAR(8), CAST(SAI_DTEXP AS DATE), 112) COLLATE Latin1_General_CI_AI  data_leitura
		FROM SAI 
		where SAI_PRODUTO between %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SUBSTRING(SAI_CPRODUC,1,6) between %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
		AND SAI_DOC between %Exp:MV_PAR05% AND %Exp:MV_PAR06% 
		AND SAI_CLIENTE between %Exp:MV_PAR07% AND %Exp:MV_PAR08% 
		AND CONVERT(VARCHAR(8), CAST(SAI_DTEXP AS DATE), 112) BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10% 



		ORDER BY 1,6





	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Produto de?     ",20)+"","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Produto ate?    ",20)+"","","","mv_ch2","C",15,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("OP de?    	 	",20)+"","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("OP At้?   	 	",20)+"","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Nota de?		",20)+"","","","mv_ch5","C",9,2,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Nota Ate?   	",20)+"","","","mv_ch6","C",9,2,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Cliente De?   	",20)+"","","","mv_ch7","C",6,2,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Cliente Ate?   	",20)+"","","","mv_ch8","C",6,2,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("DT.Expedi็ใo De?   	",20)+"","","","mv_ch9","D",8,2,0,"G","","","","","mv_par09")
	u_InPutSX1(cPerg,"10",PADR("DT.Expedi็ใo Ate?   	",20)+"","","","mv_cha","D",8,2,0,"G","","","","","mv_par10")

Return