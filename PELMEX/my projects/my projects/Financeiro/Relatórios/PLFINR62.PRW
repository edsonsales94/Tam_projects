#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
?????????????????????????????????????????????
?????????????????????????????????????????????
?????????????????????????????????????????????
??rograma  PMPCPR32    ?utor  ?TAN LEE LOPES    				?Data ? 16/07/22 ??
?????????????????????????????????????????????
??esc.     ? VENDAS GERAL POR LOJA								        			 ?
??         ?                                                           			   ??
?????????????????????????????????????????????
??so       ?AP                                                        			   ??
?????????????????????????????????????????????
?????????????????????????????????????????????
?????????????????????????????????????????????
*/

User Function PLFINR62()
	Local oReport := nil
	Local cPerg:= Padr("PLFINR62",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando dispon?el no bot? a?es relacionadas
	Pergunte(cPerg,.F.)	          

	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNOME)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction

	oReport := TReport():New(cNOME,"FATURAMENTO GERAL SIMPLIFICADO",cNOME,{|oReport| ReportPrint(oReport)},"FATURAMENTO GERAL SIMPLIFICADO")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira se?o



	oSection1:= TRSection():New(oReport, "Setor", {"cAlias"}, , .F., .T.)

	TRCell():New(oSection1,"PERIODO"		   ,"cAlias","PERIODO","@!",10)
	//A segunda se?o, ser?apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb? a tabela de NCM, com isso, voc?poderia incluir os campos da tabela
	//SYD.Semelhante a se?o 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Estrutura", {"cAlias"}, NIL, .F., .T.)
	TRCell():New(oSection2,"L1_FILRES"	    		,"cAlias","Filial","!@",3)
	TRCell():New(oSection2,"M0_FILIAL"		    ,"cAlias","Loja","!@",20)
	TRCell():New(oSection2,"TOTAL"			,"cAlias","TOTAL","@E 9,999,999,999.99",16)

	//Quebra por Se?o

	oBreak := TRBreak():New(oSection2,oSection1:Cell("PERIODO"),"PERIODO")

	TRFunction():New(oSection2:Cell("TOTAL"),"Total","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                           
	//Fim Quebra por Se?o

	//Totalizador final
	TRFunction():New(oSection2:Cell("TOTAL"),"Valor Total","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	//Totalizador

	/*

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	oReport:SetTotalInLine(.F.)

	//quebra  por se?o (.T.) uma se?o por pagina
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local lPrim 	:= .T.
	//Local teste := mv_par03
	
	cQuery := " SELECT SUBSTRING(L1_EMISNF,5,2)+'/'+SUBSTRING(L1_EMISNF,1,4)PERIODO, "
	cQuery += " 		L1_FILRES,M0_FILIAL,SUM(D2_TOTAL)TOTAL "
	cQuery += " FROM( "
	cQuery += " SELECT SL12.L1_FILRES,SL12.L1_ORCRES,SL12.L1_FILIAL,SL12.L1_NUM,C5_NUM,SL1.L1_DOCPED,SL1.L1_SERPED,SL1.L1_NSUTEF,SL1.L1_AUTORIZ,SL1.L1_EMISNF, "
	cQuery += " 	   ISNULL(D2_DOC,'')D2_DOC,ISNULL(D2_SERIE,'')D2_SERIE,ISNULL(D2_EMISSAO,'')D2_EMISSAO, "
	cQuery += " 	   ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,ISNULL(D1_EMISSAO,'')D1_EMISSAO, "
	cQuery += " 	   C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_LOCAL,C6_TES,CASE WHEN D2_EMISSAO IS NULL THEN C6_QTDVEN ELSE D2_QUANT END D2_QUANT, "
	cQuery += " 	   CASE WHEN D2_TOTAL IS NULL THEN C6_PRCVEN ELSE D2_PRCVEN END D2_PRCVEN, "
	cQuery += " 	   CASE WHEN D2_TOTAL IS NULL THEN C6_VALOR ELSE CASE WHEN ISNULL(D1_DOC,'') = '' THEN D2_TOTAL ELSE 0 END END D2_TOTAL,B1_COMIS, "
	cQuery += " 	   SL1.L1_VLRLIQ,SL1.L1_CLIENTE,SL1.L1_LOJA,A1_NOME,A3_COD,A3_NOME "
	cQuery += " FROM SL1100 SL1 (NOLOCK) "
	cQuery += " INNER JOIN SL1100 SL12 (NOLOCK) ON SL1.L1_FILIAL = SL12.L1_FILRES AND SL1.L1_NUM = SL12.L1_ORCRES AND SL12.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN SC5100 SC5 (NOLOCK) ON CASE WHEN (ISNULL(SL12.L1_PEDRES,'') != '') THEN SL12.L1_FILIAL ELSE SL12.L1_FILRES END = CASE WHEN (ISNULL(SL12.L1_PEDRES,'') !=  '') THEN C5_FILIAL ELSE C5_XFILRES END AND "
	cQuery += " 								  CASE WHEN (ISNULL(SL12.L1_PEDRES,'') != '') THEN SL12.L1_NUM ELSE SL12.L1_ORCRES END = CASE WHEN (ISNULL(SL12.L1_PEDRES,'') != '') THEN C5_ORCRES ELSE C5_XORCRES END  "
	cQuery += " 								  AND SC5.D_E_L_E_T_ = ''  "
	cQuery += " INNER JOIN SC6100 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN (SELECT D2_FILIAL,D2_EMISSAO,D2_PEDIDO,D2_DOC,D2_SERIE,D2_ITEM,D2_ITEMPV,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_CLIENTE,D2_LOJA "
	cQuery += " 		   FROM SD2100 SD2 (NOLOCK) "
	cQuery += " 		   WHERE SD2.D_E_L_E_T_ = '' "
	cQuery += " 		   )SD2 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD "
	cQuery += " INNER JOIN SA1100 SA1 (NOLOCK) ON SL1.L1_CLIENTE = A1_COD AND SL1.L1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SA3100 SA3 (NOLOCK) ON SL1.L1_VEND = A3_COD AND SA3.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' "
	cQuery += " WHERE SL1.D_E_L_E_T_ = '' "
	cQuery += " AND SL1.L1_EMISNF BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " AND SL1.L1_CLIENTE BETWEEN '' AND 'ZZZZZZ' "
	//cQuery += " AND ISNULL(A3_COD,'') BETWEEN '' AND 'ZZZZZZ' "
	//cQuery += " AND SL1.L1_DOCPED != '' "
	cQuery += " UNION "
	cQuery += " SELECT C5_FILIAL,C5_NUM,C5_FILIAL,C5_NUM,C5_NUM, "
	cQuery += " 	   ISNULL(D2_DOC,'')D2_DOC,ISNULL(D2_SERIE,'')D2_SERIE,'' L1_NSUTEF, '' L1_AUTORIZ,C5_EMISSAO, "
	cQuery += " 	   ISNULL(D2_DOC,'')D2_DOC,ISNULL(D2_SERIE,'')D2_SERIE,ISNULL(D2_EMISSAO,'')D2_EMISSAO, "
	cQuery += " 	   ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,ISNULL(D1_EMISSAO,'')D1_EMISSA, "
	cQuery += " 	   C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_LOCAL,C6_TES,CASE WHEN D2_EMISSAO IS NULL THEN C6_QTDVEN ELSE D2_QUANT END D2_QUANT, "
	cQuery += " 	   CASE WHEN D2_TOTAL IS NULL THEN C6_PRCVEN ELSE D2_PRCVEN END D2_PRCVEN, "
	cQuery += " 	   CASE WHEN D2_TOTAL IS NULL THEN C6_VALOR ELSE CASE WHEN ISNULL(D1_DOC,'') = '' THEN D2_TOTAL ELSE 0 END END D2_TOTAL,B1_COMIS, "
	cQuery += " 	   C6_VALOR,C5_CLIENTE,C5_LOJACLI,A1_NOME,A3_COD,A3_NOME "
	cQuery += " FROM SC5100 SC5 (NOLOCK) "
	cQuery += " INNER JOIN SC6100 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN SF4100 SF4 (NOLOCK) ON C6_TES = F4_CODIGO AND F4_DUPLIC = 'S' AND SF4.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN (SELECT D2_FILIAL,D2_EMISSAO,D2_PEDIDO,D2_DOC,D2_SERIE,D2_ITEM,D2_ITEMPV,D2_COD,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_CLIENTE,D2_LOJA "
	cQuery += " 		   FROM SD2100 SD2 (NOLOCK) "
	cQuery += " 		   WHERE SD2.D_E_L_E_T_ = '' "
	cQuery += " 		   )SD2 ON C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD "
	cQuery += " INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SA3100 SA3 (NOLOCK) ON C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' "
	cQuery += " WHERE SC5.D_E_L_E_T_ = '' "
	cQuery += " AND C5_ORCRES = '' "
	cQuery += " AND C5_XORCRES = '' "
	cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	//cQuery += " AND C5_CLIENTE BETWEEN '' AND 'ZZZZZZ' "
	//cQuery += " AND ISNULL(A3_COD,'') BETWEEN '' AND 'ZZZZZZ' "
	cQuery += " GROUP BY C5_FILIAL,C5_NUM,C5_FILIAL,C5_NUM,C5_NUM,D2_DOC,D2_SERIE,C5_EMISSAO,D2_DOC,D2_SERIE,D2_EMISSAO,D1_DOC,D1_SERIE,D1_EMISSAO,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_PRCVEN,D2_PRCVEN,C6_LOCAL,C6_TES,C6_QTDVEN,C6_VALOR,D2_QUANT,D2_TOTAL,SC6.C6_VALOR,C5_CLIENTE,C5_LOJACLI "
	cQuery += " 		 ,B1_COMIS,A1_NOME,A3_COD,A3_NOME "
	cQuery += " UNION "
	cQuery += " SELECT SL1.L1_FILIAL,SL1.L1_NUM,SL1.L1_FILIAL,SL1.L1_ORCRES,'' C5_NUM,SL1.L1_DOC,SL1.L1_SERIE,SL1.L1_NSUTEF,SL1.L1_AUTORIZ,SL1.L1_EMISNF, "
	cQuery += " 	   L1_DOC,L1_SERIE,L1_EMISNF, "
	cQuery += " 	   ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,ISNULL(D1_EMISSAO,'')D1_EMISSA, "
	cQuery += " 	   L2_ITEM,L2_PRODUTO,L2_DESCRI,L2_LOCAL,L2_TES,L2_QUANT,L2_VRUNIT, "
	cQuery += " 	   CASE WHEN ISNULL(D1_DOC,'') = '' THEN L2_VLRITEM ELSE 0 END L2_VLRITEM,B1_COMIS, "
	cQuery += " 	   SL1.L1_VLRLIQ,SL1.L1_CLIENTE,SL1.L1_LOJA,A1_NOME,A3_COD,A3_NOME "
	cQuery += " FROM SL1100 SL1 (NOLOCK) "
	cQuery += " INNER JOIN SL2100 SL2 (NOLOCK) ON SL1.L1_FILIAL = SL2.L2_FILIAL AND SL1.L1_NUM = SL2.L2_NUM AND SL2.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN SB1100 SB1 (NOLOCK) ON L2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN SA1100 SA1 (NOLOCK) ON SL1.L1_CLIENTE = A1_COD AND SL1.L1_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SA3100 SA3 (NOLOCK) ON SL1.L1_VEND = A3_COD AND SA3.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SD1100 SD1 (NOLOCK) ON L1_FILIAL = D1_FILIAL AND L1_DOC = D1_NFORI AND L1_SERIE = D1_SERIORI AND L2_ITEM = D1_ITEMORI AND L2_PRODUTO = D1_COD AND SD1.D_E_L_E_T_ = '' "
	cQuery += " WHERE SL1.D_E_L_E_T_ = '' "
	cQuery += " AND SL1.L1_EMISNF BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	//cQuery += " AND SL1.L1_CLIENTE BETWEEN '' AND 'ZZZZZZ' "
	//cQuery += " AND ISNULL(A3_COD,'') BETWEEN '' AND 'ZZZZZZ' "
	cQuery += " AND SL1.L1_DOC != '' "
	cQuery += " AND SL1.L1_ORCRES = '' "
	cQuery += " )TB "
	cQuery += " INNER JOIN SIGAMAT SM (NOLOCK) ON L1_FILRES = M0_CODFIL AND M0_CODIGO = '10' "
	cQuery += " GROUP BY SUBSTRING(L1_EMISNF,5,2)+'/'+SUBSTRING(L1_EMISNF,1,4), "
	cQuery += " 		 L1_FILRES,M0_FILIAL "
	cQuery += " ORDER BY 1,2 "
	
	
	
	IF Select("cAlias") <> 0
		DbSelectArea("cAlias")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "cAlias"

	dbSelectArea("cAlias")
	cAlias->(dbGoTop())

	oReport:SetMeter(cAlias->(LastRec()))

	//Irei percorrer todos os meus registros
	While !Eof()

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira se?o
		oSection1:Init()

		oReport:IncMeter()

		cSetor 	:= cAlias->PERIODO

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se?o


		oSection1:Cell("PERIODO"):SetValue(cAlias->PERIODO)
		oSection1:Printline()

		//inicializo a segunda se?o
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ?mesmo, se sim, imprimo Estrutura
		While cAlias->PERIODO == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo produtos "+alltrim(cAlias->L1_FILRES)) 
			oSection2:Cell("L1_FILRES"):SetValue(cAlias->L1_FILRES)
			oSection2:Cell("M0_FILIAL"):SetValue(cAlias->M0_FILIAL)
			oSection2:Cell("TOTAL"):SetValue(cAlias->TOTAL)

			oSection2:Printline()

			cAlias->(dbSkip())
		EndDo
		//Aqui, farei uma quebra  por se?o

		//finalizo a segunda se?o para que seja reiniciada para o proximo registro
		oSection2:Finish()
		//imprimo uma linha para separar os T?ulos de outro
		oReport:ThinLine()
		//finalizo a primeira se?o
		oSection1:Finish()
	Enddo

Return

Static Function AjustaSX1(cPerg)
    u_InPutSX1(cPerg,"01",PADR("Emiss? de  ?    ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emiss? At??    ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	/*u_InPutSX1(cPerg,"03",PADR("Mesa de  ?    ",20)+"","","","mv_ch3","N",3,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Mesa Ate  ?    ",20)+"","","","mv_ch4","N",3,0,0,"G","","","","","mv_par04") */
Return
