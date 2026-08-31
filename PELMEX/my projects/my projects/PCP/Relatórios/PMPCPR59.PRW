#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR59    ºAutor  ³Wylliam Silva      				º Data ³  17/02/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Acompanhamento de Produção Simplificado				        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PMPCPR59()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR59",10)

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

	oReport := TReport():New(cNOME,"Acompanhamento de Produção Simplificado",cNOME,{|oReport| ReportPrint(oReport)},"producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira seção
	


	oSection1:= TRSection():New(oReport, "Setor", {"cAlias"}, , .F., .T.)
	TRCell():New(oSection1,"DT"	    		,"cAlias","Data",,20)
	TRCell():New(oSection1,"SETOR"		   ,"cAlias","Setor","@!",50)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produto", {"cAlias"}, NIL, .F., .T.)

	TRCell():New(oSection2,"CODIGO"		    ,"cAlias","Codigo",20)
	TRCell():New(oSection2,"DESCRICAO"		,"cAlias","Descrição",/*Mascara*/,50)
	TRCell():New(oSection2,"QTD_PLANEJADA"	,"cAlias","Qtd.Planejada","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"QTD_PRODUZIDA"	,"cAlias","Qtd.Produzida","@E 9,999,999,999.99",)
	//TRCell():New(oSection2,"QTD_JUNCAO"	    ,"cAlias","Qtd.Juncao","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"STATUS"			,"cAlias","Status",,20)
	TRCell():New(oSection2,"ORDEM_PROD"		,"cAlias","Ordem Producao",,8)
	TRCell():New(oSection2,"CLIENTE"	,"cAlias","Cliente",20)
	//Quebra por Seção
	oBreak := TRBreak():New(oSection2,oSection1:Cell("Setor"),"Codigo")
	TRFunction():New(oSection2:Cell("QTD_PLANEJADA"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"Total","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("QTD_JUNCAO"),"Total","SUM",oBreak,,,,.F.,.F.)
	
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
	
	
	

	cQuery := " SELECT CONVERT(VARCHAR,CAST ('"+DTOS(mv_par01)+"' AS DATE),103) DT,TB1.CODIGO CODIGO,TB1.DESCRICAO DESCRICAO,SUM(QTD_PLANEJADA)QTD_PLANEJADA,SUM(QTD_PRODUZIDA)QTD_PRODUZIDA, "
	cQuery += " CASE WHEN TB1.B1_XJUNCAO = 'S' THEN  CASE WHEN SUM(QTD_PLANEJADA) > 0 THEN (SUM(QTD_PLANEJADA)*2) ELSE(SUM(QTD_PRODUZIDA)*2)END ELSE CASE WHEN SUM(QTD_PLANEJADA) > 0 THEN SUM(QTD_PLANEJADA) ELSE SUM(QTD_PRODUZIDA) END END QTD_JUNCAO, "
	cQuery += " CASE WHEN SUM(QTD_PLANEJADA) = 0 THEN 'NÃO PLANEJADO' ELSE 'PLANEJADO' END [STATUS], "
	cQuery += " B1_XSETOR SETOR,PK2_OP ORDEM_PROD,PK2_NOME CLIENTE "
	cQuery += " FROM("
	cQuery += " SELECT *"
	cQuery += " FROM( "
	cQuery += " SELECT PK2_PRODUTO CODIGO,B1_DESC DESCRICAO,SUM(PK2_QUANT)QTD_PLANEJADA,0 QTD_PRODUZIDA,PK2_OP,PK2_NOME,B1_XJUNCAO"
	cQuery += " FROM PK2 "
	cQuery += " INNER JOIN SB1100 SB1 ON PK2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''"
	cQuery += " WHERE CONVERT(VARCHAR,CAST (PK2_DTPROPEL AS DATE),112) = '"+DTOS(mv_par01)+"'"
	cQuery += " AND PK2_QUANT > 0 "
	cQuery += " AND PK2_STATUS != 'C'"
	cQuery += " GROUP BY PK2_PRODUTO,B1_DESC,PK2_OP,PK2_NOME,B1_XJUNCAO"
	cQuery += " UNION "
	cQuery += " SELECT B1_COD CODIGO,B1_DESC DESCRICAO,"
	cQuery += " 0 QTD_PLANEJADA,"
	cQuery += " SUM(ISNULL(CLB_QUANT,0)) QTD_PRODUZIDA,"
	cQuery += " SUBSTRING (CLB_CPRODUC,1,6) PK2_OP,"
	cQuery += " CLB_DATINC PK2_DTPROPEL,B1_XJUNCAO"
	cQuery += " FROM CLB "
	cQuery += " INNER JOIN SB1100 SB1 ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = ''"
	cQuery += " WHERE CONVERT(VARCHAR,CAST (CLB_DATINC AS DATE),112) = '"+DTOS(mv_par01)+"' "
	cQuery += " AND CLB_DESCRI NOT LIKE 'COL%'"
	cQuery += " GROUP BY B1_COD,B1_DESC,B1_XJUNCAO,SUBSTRING (CLB_CPRODUC,1,6),CLB_DATINC,B1_XJUNCAO"
	cQuery += " UNION"
	cQuery += " SELECT B1_COD CODIGO,B1_DESC DESCRICAO,"
	cQuery += " 0 QTD_PLANEJADA,"
	cQuery += " SUM(ISNULL(CLA_QUANT,0))  QTD_PRODUZIDA,"
	cQuery += " SUBSTRING (CLA_CPRODUC,1,6) PK2_OP,"
	cQuery += " CLA_DATINC PK2_DTPROPEL,B1_XJUNCAO"
	cQuery += " FROM CLA"
	cQuery += " INNER JOIN SB1100 SB1 ON CLA_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " WHERE CONVERT(VARCHAR,CAST (CLA_DATINC AS DATE),112) = '"+DTOS(mv_par01)+"' "
	cQuery += " AND B1_XSETOR NOT LIKE 'CAMA%'"
	cQuery += " GROUP BY B1_COD,B1_DESC,SUBSTRING (CLA_CPRODUC,1,6),CLA_DATINC,B1_XJUNCAO"
	cQuery += " UNION "
	cQuery += " SELECT B1_COD CODIGO,B1_DESC DESCRICAO,"
	cQuery += " 0 QTD_PLANEJADA,"
	cQuery += " SUM(ISNULL(CLD_QUANT,0))  QTD_PRODUZIDA,"
	cQuery += " SUBSTRING (CLD_CPRODUC,1,6) PK2_OP,"
	cQuery += " CLD_DATINC PK2_DTPROPEL,B1_XJUNCAO"
	cQuery += " FROM CLD"
	cQuery += " INNER JOIN SB1100 SB1 ON CLD_COD = B1_COD AND SB1.D_E_L_E_T_ = ''"
	cQuery += " WHERE CONVERT(VARCHAR,CAST (CLD_DATINC AS DATE),112) = '"+DTOS(mv_par01)+"'"
	cQuery += " AND B1_DESC LIKE 'TRAV%' "
	cQuery += " GROUP BY B1_COD,B1_DESC,SUBSTRING (CLD_CPRODUC,1,6),CLD_DATINC,B1_XJUNCAO "
	cQuery += " UNION"
	cQuery += " SELECT B1_COD CODIGO,B1_DESC DESCRICAO,"
	cQuery += " 0 QTD_PLANEJADA,"
	cQuery += " SUM(ISNULL(CLD_QUANT,0))  QTD_PRODUZIDA,"
	cQuery += " SUBSTRING (CLD_CPRODUC,1,6) PK2_OP,"
	cQuery += " CLD_DATINC PK2_DTPROPEL,B1_XJUNCAO"
	cQuery += " FROM CLD"
	cQuery += " INNER JOIN SB1100 SB1 ON CLD_COD = B1_COD AND SB1.D_E_L_E_T_ = ''"
	cQuery += " WHERE CONVERT(VARCHAR,CAST (CLD_DATINC AS DATE),112) = '"+DTOS(mv_par01)+"' "
	cQuery += " AND B1_DESC LIKE 'ROLETE%'"
	cQuery += " GROUP BY B1_COD,B1_DESC,SUBSTRING (CLD_CPRODUC,1,6),CLD_DATINC,B1_XJUNCAO"
	cQuery += " UNION "
	cQuery += " SELECT B1_COD CODIGO,B1_DESC DESCRICAO,"
	cQuery += " 0 QTD_PLANEJADA, "
	cQuery += " SUM(ISNULL(CLD_QUANT,0))  QTD_PRODUZIDA,"
	cQuery += " SUBSTRING (CLD_CPRODUC,1,6) PK2_OP,"
	cQuery += " CLD_DATINC PK2_DTPROPEL,B1_XJUNCAO"
	cQuery += " FROM CLD"
	cQuery += " INNER JOIN SB1100 SB1 ON CLD_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " WHERE CONVERT(VARCHAR,CAST (CLD_DATINC AS DATE),112) = '"+DTOS(mv_par01)+"' "
	cQuery += " AND B1_DESC LIKE '%ALVEOLADO%'"
	cQuery += " GROUP BY B1_COD,B1_DESC,SUBSTRING (CLD_CPRODUC,1,6),CLD_DATINC,B1_XJUNCAO"
	cQuery += " UNION"
	cQuery += " SELECT B1_COD CODIGO,B1_DESC DESCRICAO,"
	cQuery += " 0 QTD_PLANEJADA,"
	cQuery += " SUM(ISNULL(CLD_QUANT,0))  QTD_PRODUZIDA,"
	cQuery += " SUBSTRING (CLD_CPRODUC,1,6) PK2_OP,"
	cQuery += " CLD_DATINC PK2_DTPROPEL,B1_XJUNCAO "
	cQuery += " FROM CLD"
	cQuery += " INNER JOIN SB1100 SB1 ON CLD_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " WHERE CONVERT(VARCHAR,CAST (CLD_DATINC AS DATE),112) = '"+DTOS(mv_par01)+"' "
	cQuery += " AND B1_DESC LIKE 'SUAVE%' "
	cQuery += " GROUP BY B1_COD,B1_DESC,SUBSTRING (CLD_CPRODUC,1,6),CLD_DATINC,B1_XJUNCAO"
	cQuery += " )TB"
	cQuery += " GROUP BY CODIGO,DESCRICAO,QTD_PLANEJADA,QTD_PRODUZIDA,PK2_OP,PK2_DTPROPEL,B1_XJUNCAO"
	cQuery += " )TB1 "
	cQuery += " INNER JOIN SB1100 SB1 ON TB1.CODIGO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''"
	cQuery += " GROUP BY TB1.CODIGO,TB1.DESCRICAO,B1_XSETOR,PK2_OP,PK2_DTPROPEL,TB1.B1_XJUNCAO"
	cQuery += " ORDER BY B1_XSETOR,TB1.CODIGO"
		
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
		oSection1:Cell("DT"):SetValue(cAlias->DT)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor é mesmo, se sim, imprimo Estrutura
		While cAlias->SETOR == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo Producao "+alltrim(cAlias->CODIGO))
			oSection2:Cell("CODIGO"):SetValue(cAlias->CODIGO)
			oSection2:Cell("DESCRICAO"):SetValue(cAlias->DESCRICAO)
			oSection2:Cell("QTD_PLANEJADA"):SetValue(cAlias->QTD_PLANEJADA)
			oSection2:Cell("QTD_PRODUZIDA"):SetValue(cAlias->QTD_PRODUZIDA)
			oSection2:Cell("QTD_JUNCAO"):SetValue(cAlias->QTD_JUNCAO)
			oSection2:Cell("STATUS"):SetValue(cAlias->STATUS)
			oSection2:Cell("ORDEM_PROD"):SetValue(cAlias->ORDEM_PROD)
			oSection2:Cell("DATA_PRODUCAO"):SetValue(cAlias->DATA_PRODUCAO)
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
    u_InPutSX1(cPerg,"01",PADR("Emissão ?    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 

Return
