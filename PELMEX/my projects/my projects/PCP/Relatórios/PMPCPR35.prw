#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR35    ºAutor  ³STAN LEE LOPES    				º Data ³  16/05/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  PICKLIST DETALHADO ATIPICO AMAZON				        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PMPCPR35()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR35",10)

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

	oReport := TReport():New(cNOME,"PICKLIST DETALHADO ATIPICO AMAZON",cNOME,{|oReport| ReportPrint(oReport)},"PICKLIST")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira seção

	oSection1:= TRSection():New(oReport, "Setor", {"cAlias"}, , .F., .T.)
	TRCell():New(oSection1,"SETOR"		   ,"cAlias","Setor","@!",30)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Estrutura", {"cAlias"}, NIL, .F., .T.)
	TRCell():New(oSection2,"CODIGO"	    		,"cAlias","Código",,20)
	TRCell():New(oSection2,"DESCRICAO"		    ,"cAlias","Descrição",,80)
	TRCell():New(oSection2,"COMPONENTE"	   		,"cAlias","Componente",,20)
	TRCell():New(oSection2,"PK2_QUANT"			,"cAlias","Qtd","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"DESCOMP"		    ,"cAlias","Descrição",,80)
	TRCell():New(oSection2,"UMCOMP"				,"cAlias","Unidade",/*Mascara*/,10)
	TRCell():New(oSection2,"QTD_NECESSARIA"		,"cAlias","Qtd.Necessária","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"QTD_10"				,"cAlias","Armz Produção","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"SALDO_10"			,"cAlias","Saldo","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"QTD_01"				,"cAlias","Armz Almaxarifado","@E 9,999,999,999.99",)
	
	//Quebra por Seção
	oBreak := TRBreak():New(oSection2,oSection1:Cell("SETOR"),"Por Setor")

	//TRFunction():New(oSection2:Cell("D2_TOTAL"),"Total","SUM",oBreak,,,,.F.,.F.)
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


cQuery += " SELECT TB1.SETOR SETOR,TB1.CODIGO CODIGO,TB1.DESCRICAO DESCRICAO,SG1.G1_COMP COMPONENTE,PK2_QUANT,SB12.B1_DESC DESCOMP,SB12.B1_UM UMCOMP,(TB1.QTD_NECESSARIA*SG1.G1_QUANT) QTD_NECESSARIA,"
cQuery += "       ISNULL(QTD_10,0)QTD_10,"
cQuery += "	   ISNULL(QTD_10,0)-(TB1.QTD_NECESSARIA*SG1.G1_QUANT) SALDO_10,"
cQuery += "	   ISNULL(QTD_01,0)QTD_01 "
cQuery += "  FROM( "
cQuery += "  SELECT TB.PK2_SETOR SETOR,TB.G1_COMP CODIGO,TB.B1_DESC DESCRICAO,SUM(PK2_QUANT) PK2_QUANT,TB.B1_UM UM,SUM(QTD_NECESSARIA)QTD_NECESSARIA "
cQuery += " 	 FROM( "
cQuery += "			SELECT PK2_SETOR,PK2_PRODUTO,PK2_DESCRI,G1_COMP,SB1.B1_DESC,SB1.B1_UM,PK2_QUANT, "
cQuery += " 		G1_QUANT,PK2_QUANT*G1_QUANT QTD_NECESSARIA "
cQuery += " 		FROM PK2 "
cQuery += " 		INNER JOIN SG1100 SG1 ON PK2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) "
cQuery += " 		INNER JOIN SB1100 SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''" 
cQuery += " 		WHERE G1_COMP NOT LIKE 'MOD%' "
cQuery += " 		AND CONVERT(VARCHAR,CAST(PK2_DTPROAMA AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " 		)TB "
cQuery += " GROUP BY TB.PK2_SETOR,TB.G1_COMP,TB.B1_DESC,TB.B1_UM "
cQuery += " )TB1 "
cQuery += " INNER JOIN SG1200 SG1 ON TB1.CODIGO = SG1.G1_COD AND SG1.D_E_L_E_T_ = ''" 
cQuery += " INNER JOIN SB1200 SB12 ON SG1.G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''"
cQuery += " LEFT JOIN (SELECT B2_FILIAL,B2_COD,B2_QATU QTD_10,B2_LOCAL"
cQuery += "            FROM SB2200 SB2 (NOLOCK)"
cQuery += "		       WHERE SB2.D_E_L_E_T_ = ''"
cQuery += "		       AND B2_FILIAL = '01'"
cQuery += "		       AND B2_LOCAL = '10')SB210 ON G1_COMP = SB210.B2_COD"
cQuery += " LEFT JOIN (SELECT B2_FILIAL,B2_COD,B2_QATU QTD_01,B2_LOCAL"
cQuery += "            FROM SB2200 SB2 (NOLOCK)"
cQuery += "		       WHERE SB2.D_E_L_E_T_ = ''"
cQuery += "		       AND B2_FILIAL = '01'"
cQuery += "		       AND B2_LOCAL = '01')SB201 ON G1_COMP = SB201.B2_COD  "
cQuery += " WHERE G1_COMP NOT LIKE 'MOD%' "
cQuery += " ORDER BY TB1.SETOR,TB1.CODIGO "























// Desabilitado dia 12/08/2022 
	/*cQuery += " SELECT TB1.SETOR,TB1.CODIGO,TB1.DESCRICAO,SG1.G1_COMP COMPONENTE,PK2_QUANT,SB12.B1_DESC DESCOMP,SB12.B1_UM UMCOMP,(TB1.QTD_NECESSARIA*SG1.G1_QUANT) QTD_NECESSARIA "
	cQuery += " FROM( "
	cQuery += " SELECT TB.PK2_SETOR SETOR,TB.G1_COMP CODIGO,TB.B1_DESC DESCRICAO,SUM(PK2_QUANT) PK2_QUANT,TB.B1_UM UM,SUM(QTD_NECESSARIA)QTD_NECESSARIA "
	cQuery += " FROM( "
	cQuery += " SELECT PK2_SETOR,PK2_PRODUTO,PK2_DESCRI,G1_COMP,SB1.B1_DESC,SB1.B1_UM,PK2_QUANT, "
	cQuery += " G1_QUANT,PK2_QUANT*G1_QUANT QTD_NECESSARIA "
	cQuery += " FROM PK2 "
	cQuery += " INNER JOIN SG1100 SG1 ON PK2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) "
	cQuery += " INNER JOIN SB1100 SB1 ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " WHERE G1_COMP NOT LIKE 'MOD%' "
	cQuery += " AND CONVERT(VARCHAR,CAST(PK2_DATINC AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	cQuery += " AND CONVERT(VARCHAR,CAST(PK2_DTPROAMA AS DATE),112) BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' "
	cQuery += " AND (PK2_DESCRI LIKE '%"+ALLTRIM(mv_par05)+"%' OR PK2_PRODUTO LIKE '%"+ALLTRIM(mv_par05)+"%' )"
	cQuery += " )TB "
	cQuery += " GROUP BY TB.PK2_SETOR,TB.G1_COMP,TB.B1_DESC,TB.B1_UM "
	cQuery += " )TB1 "
	cQuery += " INNER JOIN SG1200 SG1 ON TB1.CODIGO = SG1.G1_COD AND SG1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN SB1200 SB12 ON SG1.G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = '' "
	cQuery += " WHERE G1_COMP NOT LIKE 'MOD%' "
	cQuery += " ORDER BY TB1.SETOR,TB1.CODIGO "*/
	
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
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor é mesmo, se sim, imprimo Estrutura
		While cAlias->SETOR == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))
			oSection2:Cell("CODIGO"):SetValue(cAlias->CODIGO)
			oSection2:Cell("DESCRICAO"):SetValue(cAlias->DESCRICAO)
			oSection2:Cell("COMPONENTE"):SetValue(cAlias->COMPONENTE)
			oSection2:Cell("DESCOMP"):SetValue(cAlias->DESCOMP)
			oSection2:Cell("UMCOMP"):SetValue(cAlias->UMCOMP)
			oSection2:Cell("QTD_NECESSARIA"):SetValue(cAlias->QTD_NECESSARIA)
			oSection2:Cell("QTD_10"):SetValue(cAlias->QTD_10)
			oSection2:Cell("SALDO_10"):SetValue(cAlias->SALDO_10)
			oSection2:Cell("QTD_01"):SetValue(cAlias->QTD_01)


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
    u_InPutSX1(cPerg,"01",PADR("De Prod Ama  ?    ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Até Prod. Ama ?    ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("DT.Producao de  ?    ",20)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("DT.Producao Até ?    ",20)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
	//u_InPutSX1(cPerg,"05",PADR("Produto de  ?    ",20)+"","","","mv_ch5","C",50,0,0,"G","","SB1","","","mv_par05")
	
Return