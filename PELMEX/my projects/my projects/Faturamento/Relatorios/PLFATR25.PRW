#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR08    ºAutor  ³WILSON GUEDES	    				º Data ³  02/07/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de Vendas									        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFATR25()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR25"

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



	oReport := TReport():New(cPerg,"Relatorio de Desconto Aplicado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()    
	oReport:SetEnvironment(2)      


	//Primeira seção


	oSection:= TRSection():New(oReport, "Vendas com Desconto", {"SD2"},aOrdem)   
	TRCell():New(oSection,"D2_COD"		   ,"cAlias","Codigo do Produto","",8)
	TRCell():New(oSection,"B1_DESC"	   ,"cAlias","Descrição do Produto",,50)


	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	TRCell():New(oSection,"M0_FILIAL"	    		,"cAlias","Nome da Filial",,30)
	TRCell():New(oSection,"D2_DOC"		    		,"cAlias","Documento",,10)
	TRCell():New(oSection,"D2_SERIE"				,"cAlias","Série",/*Mascara*/,)    
	TRCell():New(oSection,"EMISSAO"			   		,"cAlias","Emissão",/*Mascara*/,12)   
	TRCell():New(oSection,"D2_PRUNIT"	   			,"cAlias","Preço de venda","@E 9,999,999,999.99",14)       
	TRCell():New(oSection,"D2_QUANT"	   			,"cAlias","QTD",,4) 
	TRCell():New(oSection,"TOTALVEND"	   			,"cAlias","Total de Venda","@E 9,999,999,999.99",14)  
	TRCell():New(oSection,"VALDESC"	   				,"cAlias","Val Desconto","@E 9,999,999,999.99",14)
	TRCell():New(oSection,"PERDESCONTO"	   			,"cAlias","% Desconto","@E 99.99",)  
	TRCell():New(oSection,"D2_PRCVEN"	   			,"cAlias","Preço Liquido","@E 9,999,999,999.99",14)  
	TRCell():New(oSection,"D2_TOTAL"	   		  	,"cAlias","Total Líquido","@E 9,999,999,999.99",14) 
	TRCell():New(oSection,"A3_NOME"	   		 		,"cAlias","Vendedor",,50)                
	//Quebra por Seção                         N4


	//	TRFunction():New(oSection2:Cell("TOTALVEND"),"Total:   ","SUM",oBreak,,,,.F.,.F.)
	//	TRFunction():New(oSection2:Cell("D2_TOTAL"),"Total : ","SUM",oBreak,,,,.F.,.F.)  

	TRFunction():New(oSection:Cell("TOTALVEND"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("D2_TOTAL"),"PENDENTES","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)                                      
	//Fim Quebra por Seção

	//Totalizador final





	//Totalizador                                                                                                          MIC

	/* 

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	//quebra  por seção (.T.) uma seção por pagina		
Return(oReport)



/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   
		 
		SELECT M0_FILIAL,D2_SERIE,D2_DOC,CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103) EMISSAO,D2_COD,B1_DESC,D2_PRUNIT,D2_QUANT,(D2_PRUNIT*D2_QUANT) TOTALVEND,(D2_PRUNIT*D2_QUANT-D2_TOTAL) VALDESC,100-(D2_PRCVEN*100/D2_PRUNIT) PERDESCONTO,D2_PRCVEN,D2_QUANT,D2_TOTAL,A3_NOME 
		FROM %Table:SD2% SD2 (NOLOCK) 
		INNER JOIN SIGAMAT SM (NOLOCK) ON D2_FILIAL = M0_CODFIL AND M0_CODIGO = %Exp:MV_PAR01% AND SM.D_E_L_E_T_ = '' 
		INNER JOIN %Table:SF2% SF2 (NOLOCK) ON F2_FILIAL = D2_FILIAL AND F2_SERIE = D2_SERIE AND F2_DOC = D2_DOC AND SF2.D_E_L_E_T_ = '' 
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = '' 
		INNER JOIN %Table:SA3% SA3 (NOLOCK) ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = '' 
		WHERE SD2.D_E_L_E_T_ = '' 
		AND D2_PRUNIT != D2_PRCVEN 
		AND D2_EMISSAO BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% 
		AND 100-(D2_PRCVEN*100/D2_PRUNIT) >= %Exp:MV_PAR04% 
		ORDER BY M0_CODFIL,M0_FILIAL,D2_COD



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Empresa  ?    ",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("DT. Emissão de?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("DT. Emissão Até?   ",20)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Desconto Minimo?   ",20)+"","","","mv_ch4","N",5,2,0,"G","","","","","mv_par04")

Return