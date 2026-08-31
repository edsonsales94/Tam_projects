#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
?????????????????????????????????????????????
?????????????????????????????????????????????
?????????????????????????????????????????????
??rograma  PMLOJR09    ?utor  ?ILSON GUEDES	    				?Data ? 02/07/19 ??
?????????????????????????????????????????????
??esc.     ? Relat?io de Vendas									        			 ?
??         ?                                                           			   ??
?????????????????????????????????????????????
??so       ?AP                                                        			   ??
?????????????????????????????????????????????
?????????????????????????????????????????????
?????????????????????????????????????????????
*/


User Function PMLOJR09()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMLOJR09"

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


	oReport := TReport():New(cPerg,"RELATORIO DE COMISSOES ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se?o
	oSection := TRSection():New(oReport,"Comissao",{"SL1"},aOrdem) 


	TRCell():New(oSection,"L1_FILRES"			,"SL1","Fil.Origem","@!",)
	TRCell():New(oSection,"L1_FILIAL"			,"SL1","Fil.Destino","@!",)
	TRCell():New(oSection,"L1_EMISNF"			,"SL1","Dt.Emiss?","@!",) 
	TRCell():New(oSection,"L1_DOCPED"			,"SL1","Titulo","@!",15)
	TRCell():New(oSection,"L1_SERPED"	    	,"SL1","Prefixo","@!",8) 
	TRCell():New(oSection,"L1_NSUTEF"			,"SL1","NSUTEF","@E 99999999999",15) 
	TRCell():New(oSection,"L1_AUTORIZ"	    	,"SL1","Autoriza?o","@!",) 
	TRCell():New(oSection,"C5_NUM"	       		,"SC5","Pedido","@!",) 
	TRCell():New(oSection,"D2_DOC"		 	    ,"SD2","Nota","@!",15)
	TRCell():New(oSection,"D2_SERIE"			,"SD2","Serie","@!",) 
	TRCell():New(oSection,"D1_DOC"    			,"SD1","NF.Devolu?o","@!",)
	TRCell():New(oSection,"D1_SERIE"     	    ,"SD1","Serie","@!",)
	TRCell():New(oSection,"D1_EMISSAO"			,"SD1","Dt.Devolu?o","@!",)  
	TRCell():New(oSection,"L1_CLIENTE"			,"SL1","Cliente","@!",8) 
	TRCell():New(oSection,"A1_NOME" 			,"SA1","Nome do Cliente","@!",35) 
	TRCell():New(oSection,"L2_ITEM" 			,"SL2","Item","@!",) 
	TRCell():New(oSection,"L2_PRODUTO"   		,"SL2","Produto","@!",20) 
	TRCell():New(oSection,"L2_DESCRI"     		,"SL2","Descri?o do produto","@!",45)
	TRCell():New(oSection,"L2_QUANT"    	    ,"SL2","Quantidade","@E 999,999,999,999",)
	TRCell():New(oSection,"L2_LOCAL"  		  	,"SL2","Local","@!",3)
	TRCell():New(oSection,"L2_VRUNIT"    		,"SL2","Valor Unit","@E 999,999,999.99",)
	TRCell():New(oSection,"L2_VLRITEM"    		,"SL2","Valor Item","@E 999,999,999.99",)
	TRCell():New(oSection,"L2_TES"    			,"SL2","TES","@!",20) 
	TRCell():New(oSection,"B1_COMIS"			,"SB1","% Comissao","!@",8)
	TRCell():New(oSection,"L2_BASECOM"			,"SB1","Valor Comiss?","@E 999,999,999.99",)
	TRCell():New(oSection,"L1_VEND"			    ,"SL1","Cod.Vendedor","@!",6)
	TRCell():New(oSection,"A3_NOME"		  		,"SA3","Nome Vendedor","@!",25)

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL ","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("B1_TOTAL"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)

	//Fim Quebra por Se?o

	//Totalizador final





	//Totalizador                                                                                                          MIC

	/* 

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	//quebra  por se?o (.T.) uma se?o por pagina		
	
Return(oReport)



/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ?
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%    
	
	SELECT L1_FILRES,L1_FILIAL,L1_EMISNF,L1_DOCPED,L1_SERPED,L1_NSUTEF,L1_AUTORIZ,C5_NUM,D2_DOC,D2_SERIE,
		   D1_DOC,D1_SERIE,D1_EMISSAO,
		   L1_CLIENTE,A1_NOME,
		   C6_ITEM L2_ITEM,C6_PRODUTO L2_PRODUTO,C6_DESCRI L2_DESCRI,D2_QUANT L2_QUANT, D2_PRCVEN L2_VRUNIT,D2_TOTAL L2_VLRITEM,C6_TES L2_TES,B1_COMIS,
		   (D2_TOTAL * B1_COMIS)/100 L2_BASECOM,
		   A3_COD L1_VEND,A3_NOME
	FROM(
	SELECT SL12.L1_FILRES,SL12.L1_ORCRES,SL12.L1_FILIAL,SL12.L1_NUM,C5_NUM,SL1.L1_DOCPED,SL1.L1_SERPED,SL1.L1_NSUTEF,SL1.L1_AUTORIZ,SL1.L1_EMISNF,
		   ISNULL(D2_DOC,'')D2_DOC,ISNULL(D2_SERIE,'')D2_SERIE,ISNULL(D2_EMISSAO,'')D2_EMISSAO,
		   ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,ISNULL(D1_EMISSAO,'')D1_EMISSAO,
		   C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_LOCAL,C6_TES,CASE WHEN D2_EMISSAO IS NULL THEN C6_QTDVEN ELSE D2_QUANT END D2_QUANT,
		   CASE WHEN D2_TOTAL IS NULL THEN C6_PRCVEN ELSE D2_PRCVEN END D2_PRCVEN,
		   CASE WHEN D2_TOTAL IS NULL THEN C6_VALOR ELSE CASE WHEN ISNULL(D1_DOC,'') = '' THEN D2_TOTAL ELSE 0 END END D2_TOTAL,B1_COMIS,
		   SL1.L1_VLRLIQ,SL1.L1_CLIENTE,SL1.L1_LOJA,A1_NOME,A3_COD,A3_NOME
	FROM SL1100 SL1 (NOLOCK)
	INNER JOIN SL1100 SL12 (NOLOCK) ON SL1.L1_FILIAL = SL12.L1_FILRES AND SL1.L1_NUM = SL12.L1_ORCRES AND SL12.D_E_L_E_T_ = ''
	INNER JOIN SC5100 SC5 (NOLOCK) ON CASE WHEN (ISNULL(SL12.L1_PEDRES,'') != '') THEN SL12.L1_FILIAL ELSE SL12.L1_FILRES END = CASE WHEN (ISNULL(SL12.L1_PEDRES,'') != '') THEN C5_FILIAL ELSE C5_XFILRES END AND
									  CASE WHEN (ISNULL(SL12.L1_PEDRES,'') != '') THEN SL12.L1_NUM ELSE SL12.L1_ORCRES END = CASE WHEN (ISNULL(SL12.L1_PEDRES,'') != '') THEN C5_ORCRES ELSE C5_XORCRES END 
									  AND SC5.D_E_L_E_T_ = '' 
	INNER JOIN SC6100 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ''
	INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
	LEFT JOIN (SELECT D2_FILIAL,D2_EMISSAO,D2_PEDIDO,D2_DOC,D2_SERIE,D2_ITEM,D2_ITEMPV,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_CLIENTE,D2_LOJA
			   FROM SD2100 SD2 (NOLOCK)
			   WHERE SD2.D_E_L_E_T_ = ''
			   )SD2 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD
	INNER JOIN SA1100 SA1 (NOLOCK) ON SL1.L1_CLIENTE = A1_COD AND SL1.L1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	LEFT JOIN SA3100 SA3 (NOLOCK) ON SL1.L1_VEND = A3_COD AND SA3.D_E_L_E_T_ = ''
	LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
	WHERE SL1.D_E_L_E_T_ = ''
	AND C6_TES NOT IN ('723')
	AND SL1.L1_EMISNF BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND SL1.L1_CLIENTE BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND ISNULL(A3_COD,'') BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	AND SL1.L1_DOCPED != ''

	UNION

	SELECT C5_FILIAL,C5_NUM,C5_FILIAL,C5_NUM,C5_NUM,
		   ISNULL(D2_DOC,'')D2_DOC,ISNULL(D2_SERIE,'')D2_SERIE,'' L1_NSUTEF, '' L1_AUTORIZ,C5_EMISSAO,
		   ISNULL(D2_DOC,'')D2_DOC,ISNULL(D2_SERIE,'')D2_SERIE,ISNULL(D2_EMISSAO,'')D2_EMISSAO,
		   ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,ISNULL(D1_EMISSAO,'')D1_EMISSA,
		   C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_LOCAL,C6_TES,CASE WHEN D2_EMISSAO IS NULL THEN C6_QTDVEN ELSE D2_QUANT END D2_QUANT,
		   CASE WHEN D2_TOTAL IS NULL THEN C6_PRCVEN ELSE D2_PRCVEN END D2_PRCVEN,
		   CASE WHEN D2_TOTAL IS NULL THEN C6_VALOR ELSE CASE WHEN ISNULL(D1_DOC,'') = '' THEN D2_TOTAL ELSE 0 END END D2_TOTAL,B1_COMIS,
		   C6_VALOR,C5_CLIENTE,C5_LOJACLI,A1_NOME,A3_COD,A3_NOME
	FROM SC5100 SC5 (NOLOCK)
	INNER JOIN SC6100 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ''
	INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
	INNER JOIN SF4100 SF4 (NOLOCK) ON C6_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = ''
	INNER JOIN (SELECT D2_FILIAL,D2_EMISSAO,D2_PEDIDO,D2_DOC,D2_SERIE,D2_ITEM,D2_ITEMPV,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_CLIENTE,D2_LOJA
			   FROM SD2100 SD2 (NOLOCK)
			   WHERE SD2.D_E_L_E_T_ = ''
			   )SD2 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD
	INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	LEFT JOIN SA3100 SA3 (NOLOCK) ON C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
	LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
	WHERE SC5.D_E_L_E_T_ = ''
	AND C6_TES NOT IN ('723')
	AND C5_ORCRES = ''
	AND C5_XORCRES = ''
	AND C5_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND C5_CLIENTE BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND ISNULL(A3_COD,'') BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	GROUP BY C5_FILIAL,C5_NUM,C5_FILIAL,C5_NUM,C5_NUM,D2_DOC,D2_SERIE,C5_EMISSAO,D2_DOC,D2_SERIE,D2_EMISSAO,D1_DOC,D1_SERIE,D1_EMISSAO,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_PRCVEN,D2_PRCVEN,C6_LOCAL,C6_TES,C6_QTDVEN,C6_VALOR,D2_QUANT,D2_TOTAL,SC6.C6_VALOR,C5_CLIENTE,C5_LOJACLI
			 ,B1_COMIS,A1_NOME,A3_COD,A3_NOME
	UNION
	SELECT SL1.L1_FILIAL,SL1.L1_NUM,SL1.L1_FILIAL,SL1.L1_ORCRES,'' C5_NUM,SL1.L1_DOC,SL1.L1_SERIE,SL1.L1_NSUTEF,SL1.L1_AUTORIZ,SL1.L1_EMISNF,
		   L1_DOC,L1_SERIE,L1_EMISNF,
		   ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,ISNULL(D1_EMISSAO,'')D1_EMISSA,
		   L2_ITEM,L2_PRODUTO,L2_DESCRI,L2_LOCAL,L2_TES,L2_QUANT,L2_VRUNIT,
		   CASE WHEN ISNULL(D1_DOC,'') = '' THEN L2_VLRITEM ELSE 0 END L2_VLRITEM,B1_COMIS,
		   SL1.L1_VLRLIQ,SL1.L1_CLIENTE,SL1.L1_LOJA,A1_NOME,A3_COD,A3_NOME
	FROM SL1100 SL1 (NOLOCK)
	INNER JOIN SL2100 SL2 (NOLOCK) ON SL1.L1_FILIAL = SL2.L2_FILIAL AND SL1.L1_NUM = SL2.L2_NUM AND SL2.D_E_L_E_T_ = ''
	INNER JOIN SB1100 SB1 (NOLOCK) ON L2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
	INNER JOIN SA1100 SA1 (NOLOCK) ON SL1.L1_CLIENTE = A1_COD AND SL1.L1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	LEFT JOIN SA3100 SA3 (NOLOCK) ON SL1.L1_VEND = A3_COD AND SA3.D_E_L_E_T_ = ''
	LEFT JOIN SD1100 SD1 (NOLOCK) ON L1_FILIAL = D1_FILIAL AND L1_DOC = D1_NFORI AND L1_SERIE = D1_SERIORI AND L2_ITEM = D1_ITEMORI AND L2_PRODUTO = D1_COD AND SD1.D_E_L_E_T_ = ''
	WHERE SL1.D_E_L_E_T_ = ''
	AND SL1.L1_EMISNF BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND SL1.L1_CLIENTE BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND ISNULL(A3_COD,'') BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	AND SL1.L1_DOC != ''
	AND SL1.L1_ORCRES = ''
	)TB
	WHERE L1_FILRES BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	ORDER BY 1,8,9,10,CAST(C6_ITEM AS INT)
	
	
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)


	u_InPutSX1(cPerg,"01",PADR("Filial De      ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Filial Ate?    ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Emissao De     ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Emissao Ate?   ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("Vendedor De    ",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA3","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Vendedor Ate?  ",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA3","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Cliente De?     ",20)+"?","","","mv_ch7","C",6,0,0,"G","","SA1","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Cliente Ate?   ",20)+"?","","","mv_ch8","C",6,0,0,"G","","SA1","","","mv_par08")
	
Return
