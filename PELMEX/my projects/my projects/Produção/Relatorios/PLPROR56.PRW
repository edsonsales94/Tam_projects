#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR56    ºAutor  ³STAN LEE LOPES    				º Data ³  10/10/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Plano de Laminação Vertical		   						     			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLPROR56()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR56",10)

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

	oReport := TReport():New(cNOME,"Plano de Laminação Vertical",cNOME,{|oReport| ReportPrint(oReport)},"producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira seção
	


	oSection1:= TRSection():New(oReport, "Densidade", {"cAlias"}, , .F., .T.)
	
	TRCell():New(oSection1,"PED_DTPROPEL"	,"cAlias","Dt.Produçao",,20)
	TRCell():New(oSection1,"B1_XSETOR"	    ,"cAlias","Densidade",,20)
	//TRCell():New(oSection1,"SETOR"		   ,"cAlias","Setor","@!",50)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Medidas", {"cAlias"}, NIL, .F., .T.)

	//TRCell():New(oSection2,"DENSIDADE"      ,"cAlias","Densidade",,20)
	TRCell():New(oSection2,"LARGURA"		,"cAlias","Medida",/*Mascara*/,50)
	TRCell():New(oSection2,"PONTAS"	        ,"cAlias","Pontas","@E 9,999,999,999.99",)
	//TRCell():New(oSection2,"QTD_PRODUZIDA"	,"cAlias","Qtd.Produzida","@E 9,999,999,999.99",)
	//TRCell():New(oSection2,"STATUS"			,"cAlias","Status",,20)
	//Quebra por Seção
	oBreak := TRBreak():New(oSection2,oSection1:Cell("B1_XSETOR"),"Total Pontas")
	TRFunction():New(oSection2:Cell("PONTAS"),"Total Pontas","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"Total","SUM",oBreak,,,,.F.,.F.)
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
	
    cQuery := " SELECT PED_DTPROPEL,B1_XSETOR,LARGURA,PONTAS "
    cQuery += "FROM( "
    cQuery += "SELECT PED_DTPROPEL,B1_XSETOR,LARGURA,SUM(QTD_NECESSARIA)QTD_NECESSARIA,G1_XM3PAD M3_BLOCO, "
    cQuery += "    CASE WHEN G1_XM3PAD > 0 THEN CEILING(SUM(QTD_NECESSARIA)/G1_XM3PAD) ELSE ROUND(SUM(QTD_NECESSARIA),2) END PONTAS  "
    cQuery += "FROM( "
    cQuery += "SELECT PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,PED_QUANT,G1_TRT,G1_COMP,B1_DESC,B1_UM,G1_QUANT,PED_QUANT * G1_QUANT QTD_NECESSARIA,B1_XSETOR,"
	cQuery += "SUBSTRING(G1_XDIMENS,1,3)LARGURA,G1_XDIMENS,G1_XM3PAD  "
    cQuery += "FROM( "
    cQuery += "SELECT PED_NUM,PED_NOTA,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_DTPROPEL,PED_NOME,PED_SETOR  "
    cQuery += "FROM PED (NOLOCK)  "
    cQuery += "WHERE PED_STATUS != 'C'  "
    cQuery += "AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'  "
    cQuery += ")TB "
    cQuery += "INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = '' "
    cQuery += "INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''  "
    cQuery += "WHERE (B1_DESC LIKE 'ART%BLO%' OR B1_DESC LIKE 'ART%AGLO%')   "
    cQuery += "AND B1_DESC NOT LIKE '%CIL%' "
    cQuery += ")TB2 "
    cQuery += "GROUP BY PED_DTPROPEL,B1_XSETOR,LARGURA,G1_XM3PAD "
    cQuery += ")TB3 "
    //cQuery += "WHERE PONTAS > 0 "
    cQuery += "ORDER BY CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112),B1_XSETOR,LARGURA "


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



		cSetor 	:= cAlias->B1_XSETOR

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira seção

		oSection1:Cell("PED_DTPROPEL"):SetValue(cAlias->PED_DTPROPEL)
		oSection1:Cell("B1_XSETOR"):SetValue(cAlias->B1_XSETOR)
		//oSection1:Cell("DTAMAZON"):SetValue(cAlias->DTAMAZON)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor é mesmo, se sim, imprimo Estrutura
		While cAlias->B1_XSETOR == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo Plano de Laminação "+alltrim(cAlias->B1_XSETOR))
			oSection2:Cell("LARGURA"):SetValue(cAlias->LARGURA)
			oSection2:Cell("PONTAS"):SetValue(cAlias->PONTAS)
			//oSection2:Cell("QTD_PLANEJADA"):SetValue(cAlias->QTD_PLANEJADA)
			//oSection2:Cell("QTD_PRODUZIDA"):SetValue(cAlias->QTD_PRODUZIDA)
			//oSection2:Cell("STATUS"):SetValue(cAlias->STATUS)
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
    u_InPutSX1(cPerg,"01",PADR("De Produção?    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Produção?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
Return
