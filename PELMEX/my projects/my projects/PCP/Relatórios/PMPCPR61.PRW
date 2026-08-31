#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR61    ºAutor  ³STAN LEE LOPES    				º Data ³  23/02/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Acompanhamento Produção Junção				                			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PMPCPR61()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR61",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
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

	oReport := TReport():New(cNOME,"Acompanhamento Produção Junção",cNOME,{|oReport| ReportPrint(oReport)},"producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira seção
	


	oSection1:= TRSection():New(oReport, "Setor", {"cAlias"}, , .F., .T.)
	//TRCell():New(oSection1,"DT"	    		,"cAlias","Data",,20)
	TRCell():New(oSection1,"SETOR"		   ,"cAlias","Setor","@!",50)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produto", {"cAlias"}, NIL, .F., .T.)

	TRCell():New(oSection2,"TB1.CODIGO"	    	,"cAlias","Codigo",,20)
	TRCell():New(oSection2,"TB1.DESCRICAO"		,"cAlias","Descrição",/*Mascara*/,50)
	TRCell():New(oSection2,"QTD_PLANEJADA"		,"cAlias","Qtd.Planejada","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"QTD_PRODUZIDA"		,"cAlias","Qtd.Produzida","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"QTD_TOTALJUNCAO"	,"cAlias","Qtd.Prod.Junção","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"STATUS"			,"cAlias","Status",,20)
	//Quebra por Seção
	oBreak := TRBreak():New(oSection2,oSection1:Cell("Setor"),"Codigo")
	TRFunction():New(oSection2:Cell("QTD_PLANEJADA"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("QTD_TOTALJUNCAO"),"Total","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Seção

	//Totalizador final
	//TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//Totalizador

	/*

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	oReport:SetTotalInLine(.F.)

	//quebra  por seção (.T.) uma seção por pagina
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local lPrim 	:= .T.
	
	
	

	cQuery := " SELECT  TB1.CODIGO,TB1.DESCRICAO, "
	cQuery += "         SUM(QTD_PLANEJADA)QTD_PLANEJADA,"
	cQuery += " 	    SUM(QTD_PRODUZIDA)QTD_PRODUZIDA, "
	cQuery += " 	    CASE WHEN SB1.B1_XJUNCAO = 'S' THEN SUM(QTD_PRODUZIDA*2) ELSE SUM(QTD_PRODUZIDA) END QTD_TOTALJUNCAO,"
	cQuery += " 		CASE WHEN SUM(QTD_PLANEJADA) = 0 THEN 'NÃO PLANEJADO' ELSE 'PLANEJADO' END STATUS, "
	cQuery += " 		B1_XSETOR SETOR "
	cQuery += " FROM( SELECT * "
	cQuery += " 	  FROM(  "
	cQuery += " 	  SELECT PK2_PRODUTO CODIGO,B1_DESC DESCRICAO,SUM(PK2_QUANT)QTD_PLANEJADA,0 QTD_PRODUZIDA "
	cQuery += " 	  FROM PK2 "
	cQuery += "	      INNER JOIN SB1100 SB1 ON PK2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += "		  WHERE CONVERT(VARCHAR,CAST (PK2_DTPROPEL AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " 	  AND PK2_QUANT > 0  "
	cQuery += " 	  AND PK2_STATUS != 'C' "
	cQuery += " 	  AND PK2_DESCRI LIKE 'CAM%' "
    cQuery += " 	  GROUP BY PK2_PRODUTO,B1_DESC  "
	cQuery += " 		UNION "
	cQuery += " 	  SELECT B1_COD CODIGO,B1_DESC DESCRICAO,  "
	cQuery += " 	  0 QTD_PLANEJADA, "
	cQuery += " 	  SUM(ISNULL(CLB_QUANT,0)) QTD_PRODUZIDA "
	cQuery += " 	  FROM CLB  "
	cQuery += "		  INNER JOIN SB1100 SB1 ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " 		WHERE CONVERT(VARCHAR,CAST (CLB_DATINC AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	cQuery += " 		AND CLB_DESCRI NOT LIKE 'COLC%' "
    cQuery += "	        GROUP BY B1_COD,B1_DESC,B1_XJUNCAO  "
	cQuery += " 		 )TB "
	cQuery += " 	GROUP BY CODIGO,DESCRICAO,QTD_PLANEJADA,QTD_PRODUZIDA"
	cQuery += " 	)TB1  "
	cQuery += " INNER JOIN SB1100 SB1 ON TB1.CODIGO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''  "
	cQuery += " GROUP BY TB1.CODIGO,TB1.DESCRICAO,B1_XSETOR,SB1.B1_XJUNCAO"
	cQuery += " ORDER BY B1_XSETOR,TB1.CODIGO "
	
	 	
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

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()



		cSetor 	:= cAlias->SETOR

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira seção

		oSection1:Cell("Setor"):SetValue(cAlias->SETOR)
		//oSection1:Cell("DT"):SetValue(cAlias->DT)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor é mesmo, se sim, imprimo Estrutura
		While cAlias->SETOR == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))
			oSection2:Cell("TB1.CODIGO"):SetValue(cAlias->CODIGO)
			oSection2:Cell("TB1.DESCRICAO"):SetValue(cAlias->DESCRICAO)
			oSection2:Cell("QTD_PLANEJADA"):SetValue(cAlias->QTD_PLANEJADA)
			oSection2:Cell("QTD_PRODUZIDA"):SetValue(cAlias->QTD_PRODUZIDA)
			oSection2:Cell("QTD_TOTALJUNCAO"):SetValue(cAlias->QTD_TOTALJUNCAO)
			oSection2:Cell("STATUS"):SetValue(cAlias->STATUS)
			oSection2:Printline()

			cAlias->(dbSkip())
		EndDo
		//Aqui, farei uma quebra  por seção

		//finalizo a segunda seção para que seja reiniciada para o proximo registro
		oSection2:Finish()
		//imprimo uma linha para separar os Títulos de outro
		oReport:ThinLine()
		//finalizo a primeira seção
		oSection1:Finish()
	Enddo

Return

Static Function AjustaSX1(cPerg)
    u_InPutSX1(cPerg,"01",PADR("Dt Prod:    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
    u_InPutSX1(cPerg,"02",PADR("Até dt Prod:    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
Return