#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR49    บAutor  ณJUEVAN CARVALHO DA SILVA   				บ Data ณ  04/07/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Verifica Pontuacao por Previa				   						     	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR49()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR49",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponํvel no botใo a็๕es relacionadas
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

	oReport := TReport():New(cNOME,"Verifica Pontuacao por Previa",cNOME,{|oReport| ReportPrint(oReport)},"producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira se็ใo
	


	oSection1:= TRSection():New(oReport, "DT_PRODUCAO", {"cAlias"}, , .F., .T.)
	
	TRCell():New(oSection1,"DT_PRODUCAO"	,"cAlias","PREVIA",,10)
	TRCell():New(oSection1,"PED_SETOR"	    ,"cAlias","SETOR",,15)
    TRCell():New(oSection1,"PED_PRODUTO"	    ,"cAlias","PRODUTO",,15)
    TRCell():New(oSection1,"PED_DESCRI"	    ,"cAlias","DESCRI",,20)
    TRCell():New(oSection1,"PED_QUANT"	        ,"cAlias","QUANT","@E 9,999,999,999.99",)
    TRCell():New(oSection1,"TEMPO"	        ,"cAlias","TEMPO","@E 9,999,999,999.99",)
    TRCell():New(oSection1,"TEMPO_ESTIMADO"	        ,"cAlias","TEMPO_ESTIMADO","@E 9,999,999,999.99",)
    TRCell():New(oSection1,"G2_TEMPAD"	    ,"cAlias","G2_TEMPAD",,10)
    TRCell():New(oSection1,"TEMPO_NECESSARIO"	    ,"cAlias","TEMPO_NECESSARIO",,10)
	//TRCell():New(oSection1,"SETOR"		   ,"cAlias","Setor","@!",50)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	//oSection2:= TRSection():New(oReport, "Produto", {"cAlias"}, NIL, .F., .T.)

	//TRCell():New(oSection2,"DENSIDADE"      ,"cAlias","Densidade",,20)
	//TRCell():New(oSection2,"G1_XDIMENS"		,"cAlias","Dimensใo",/*Mascara*/,50)
	//TRCell():New(oSection2,"TOTAL"	        ,"cAlias","Qtd.Solicitada","@E 9,999,999,999.99",)
	//TRCell():New(oSection2,"QTD_PRODUZIDA"	,"cAlias","Qtd.Produzida","@E 9,999,999,999.99",)
	//TRCell():New(oSection2,"STATUS"			,"cAlias","Status",,20)
	//Quebra por Se็ใo
	//oBreak := TRBreak():New(oSection2,oSection1:Cell("DENSIDADE"),"Densidade")
	//TRFunction():New(oSection2:Cell("TOTAL"),"Total","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"Total","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Se็ใo

	//Totalizador final
	//TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//Totalizador

	/*

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	oReport:SetTotalInLine(.F.)

	//quebra  por se็ใo (.T.) uma se็ใo por pagina
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local lPrim 	:= .T.
	
cQuery := "DECLARE @DEDATA VARCHAR(8) "
cQuery += ""
cQuery += "DECLARE @ATEDATA VARCHAR(8) "
cQuery += ""
cQuery += "DECLARE @SETOR VARCHAR(50) "
cQuery += ""
cQuery += "SET @DEDATA = '"+DTOS(mv_par01)+"'  "
cQuery += ""
cQuery += "SET @ATEDATA = '"+DTOS(mv_par02)+"'  "
cQuery += ""
cQuery += "SET @SETOR = '"+AllTrim(mv_par03)+"'  "
cQuery += "     "
cQuery += ""    
cQuery += "SELECT PED_DTPREVIA DT_PRODUCAO,PED_SETOR,PED_PRODUTO,PED_DESCRI,SUM(PED_QUANT)PED_QUANT,ISNULL(G2_TEMPAD,0)TEMPO, "
cQuery += "        SUM(PED_QUANT)*ISNULL(G2_TEMPAD,0)TEMPO_ESTIMADO,  "
cQuery += "        REPLICATE('0', 2 - LEN(CAST((CAST(ISNULL(G2_TEMPAD,0) AS INT) / 60) AS VARCHAR(2)))) + CAST((CAST(ISNULL(G2_TEMPAD,0) AS INT) / 60) AS VARCHAR(2))  "
cQuery += "        + ':' +  "
cQuery += "        REPLICATE('0', 2 - LEN(CAST((CAST(ISNULL(G2_TEMPAD,0) AS INT) % 60) AS VARCHAR(2)))) + CAST((CAST(ISNULL(G2_TEMPAD,0) AS INT) % 60) AS VARCHAR(2))  "
cQuery += "        + ':' +  "
cQuery += "        REPLICATE('0', 2 - LEN(CAST((CAST(ISNULL(G2_TEMPAD,0) * 60 AS INT) % 60) AS VARCHAR(2)))) + CAST((CAST(ISNULL(G2_TEMPAD,0) * 60 AS INT) % 60) AS VARCHAR(2))  "
cQuery += "        AS G2_TEMPAD,  "
cQuery += "        REPLICATE('0', 2 - LEN(CAST((CAST(SUM(PED_QUANT)*ISNULL(G2_TEMPAD,0) AS INT) / 60) AS VARCHAR(2)))) + CAST((CAST(ROUND(SUM(PED_QUANT)*ISNULL(G2_TEMPAD,0),2) AS INT) / 60) AS VARCHAR(2))  "
cQuery += "        + ':' +  "
cQuery += "        REPLICATE('0', 2 - LEN(CAST((CAST(SUM(PED_QUANT)*ISNULL(G2_TEMPAD,0) AS INT) % 60) AS VARCHAR(2)))) + CAST((CAST(ROUND(SUM(PED_QUANT)*ISNULL(G2_TEMPAD,0),2) AS INT) % 60) AS VARCHAR(2))  "
cQuery += "        + ':' +  "
cQuery += "        REPLICATE('0', 2 - LEN(CAST((CAST(SUM(PED_QUANT)*ISNULL(G2_TEMPAD,0) * 60 AS INT) % 60) AS VARCHAR(2)))) + CAST((CAST(SUM(PED_QUANT)*ISNULL(G2_TEMPAD,0) * 60 AS INT) % 60) AS VARCHAR(2))  "
cQuery += "        AS TEMPO_NECESSARIO  "
cQuery += "FROM( "
cQuery += "SELECT PED_DTPREVIA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,G2_TEMPAD, "
cQuery += "        PED_QUANT*ISNULL(G2_TEMPAD,0) TEMPO, "
cQuery += "        PED_NOME,PED_MUN, "
cQuery += "        PED_TOTAL, "
cQuery += "        CASE WHEN B1_XSETOR LIKE 'COLCHAO%' THEN 'COLCHAO' END PED_SETOR  "
cQuery += "FROM PED (NOLOCK)  "
cQuery += "INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''  "
cQuery += "LEFT JOIN SG2100 SG2 (NOLOCK) ON PED_FILIAL = G2_FILIAL AND PED_PRODUTO = G2_PRODUTO AND G2_CODIGO IN ('F0') AND SG2.D_E_L_E_T_ = ''  "
cQuery += "WHERE PED_STATUS != 'C'  "
cQuery += "AND B1_XSETOR LIKE 'COLCHAO%'  "
cQuery += "AND B1_XSETOR LIKE '%'+@SETOR+'%'  "
cQuery += "AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN @DEDATA AND @ATEDATA  "
cQuery += "UNION  "
cQuery += "SELECT PED_DTPREVIA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,  "
cQuery += "        CAST(CASE WHEN B1_XJUNCAO = 'S' THEN PED_QUANT * 2 ELSE PED_QUANT END AS FLOAT) PED_QUANT,G2_TEMPAD,  "
cQuery += "        CASE WHEN B1_XJUNCAO = 'S' THEN (PED_QUANT*2)*ISNULL(G2_TEMPAD,0) ELSE PED_QUANT * ISNULL(G2_TEMPAD,0) END TEMPO, "
cQuery += "        PED_NOME,PED_MUN,  "
cQuery += "        CASE WHEN B1_XSETOR LIKE 'CAM%' THEN PED_TOTAL ELSE 0 END PED_TOTAL,  "
cQuery += "        CASE WHEN B1_XSETOR LIKE 'CAM%' THEN 'CAMA' END PED_SETOR  "
cQuery += "FROM PED (NOLOCK)  "
cQuery += "INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''  "
cQuery += "LEFT JOIN SG2100 SG2 (NOLOCK) ON PED_FILIAL = G2_FILIAL AND PED_PRODUTO = G2_PRODUTO AND G2_CODIGO IN ('T0') AND SG2.D_E_L_E_T_ = ''  "
cQuery += "WHERE PED_STATUS != 'C'  "
cQuery += "AND B1_XSETOR LIKE 'CAMA%'  "
cQuery += "AND B1_XSETOR NOT LIKE '%BAU%'  "
cQuery += "AND B1_XSETOR LIKE '%'+@SETOR+'%'  "
cQuery += "AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN @DEDATA AND @ATEDATA  "
cQuery += "UNION  "
cQuery += "SELECT PED_DTPREVIA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,  "
cQuery += "        CAST(CASE WHEN B1_XJUNCAO = 'S' THEN PED_QUANT * 2 ELSE PED_QUANT END AS FLOAT) PED_QUANT,G2_TEMPAD,  "
cQuery += "        CASE WHEN B1_XJUNCAO = 'S' THEN (PED_QUANT*2)*ISNULL(G2_TEMPAD,0) ELSE PED_QUANT * ISNULL(G2_TEMPAD,0) END TEMPO, "
cQuery += "        PED_NOME,PED_MUN,  "
cQuery += "        CASE WHEN B1_XSETOR LIKE 'CAM%' THEN PED_TOTAL ELSE 0 END PED_TOTAL,  "
cQuery += "        CASE WHEN B1_XSETOR LIKE '%BAU%' THEN 'BAU' END PED_SETOR  "
cQuery += "FROM PED (NOLOCK)  "
cQuery += "INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''  "
cQuery += "LEFT JOIN SG2100 SG2 (NOLOCK) ON PED_FILIAL = G2_FILIAL AND PED_PRODUTO = G2_PRODUTO AND G2_CODIGO IN ('U0') AND SG2.D_E_L_E_T_ = ''  "
cQuery += "WHERE PED_STATUS != 'C'  "
cQuery += "AND B1_XSETOR = 'CAMA '+@SETOR  "
cQuery += "AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN @DEDATA AND @ATEDATA  "
cQuery += "UNION "
cQuery += "SELECT PED_DTPREVIA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,G2_TEMPAD, "
cQuery += "        PED_QUANT*ISNULL(G2_TEMPAD,0) TEMPO, "
cQuery += "        PED_NOME,PED_MUN, "
cQuery += "        PED_TOTAL, "
cQuery += "        B1_XSETOR PED_SETOR " 
cQuery += "FROM PED (NOLOCK)  "
cQuery += "INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''  "
cQuery += "LEFT JOIN SG2100 SG2 (NOLOCK) ON PED_FILIAL = G2_FILIAL AND PED_PRODUTO = G2_PRODUTO AND G2_CODIGO IN ('F0') AND SG2.D_E_L_E_T_ = ''  "
cQuery += "WHERE PED_STATUS != 'C'  "
cQuery += "AND B1_XSETOR LIKE 'TRAVESSEIRO%'  "
cQuery += "AND B1_XSETOR LIKE '%'+@SETOR+'%'  "
cQuery += "AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN @DEDATA AND @ATEDATA  "
cQuery += "UNION  "
cQuery += "SELECT PED_DTPREVIA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,G2_TEMPAD, "
cQuery += "        PED_QUANT*ISNULL(G2_TEMPAD,0) TEMPO, "
cQuery += "        PED_NOME,PED_MUN, "
cQuery += "        PED_TOTAL, "
cQuery += "        B1_XSETOR PED_SETOR  "
cQuery += "FROM PED (NOLOCK)  "
cQuery += "INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''  "
cQuery += "LEFT JOIN SG2100 SG2 (NOLOCK) ON PED_FILIAL = G2_FILIAL AND PED_PRODUTO = G2_PRODUTO AND G2_CODIGO IN ('F0') AND SG2.D_E_L_E_T_ = ''  "
cQuery += "WHERE PED_STATUS != 'C'  "
cQuery += "AND B1_XSETOR LIKE '%ENCOSTO%'  "
cQuery += "AND B1_XSETOR LIKE '%'+@SETOR+'%'  "
cQuery += "AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN @DEDATA AND @ATEDATA  "
cQuery += "UNION  "
cQuery += "SELECT PED_DTPREVIA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,G2_TEMPAD, "
cQuery += "        PED_QUANT*ISNULL(G2_TEMPAD,0) TEMPO, "
cQuery += "        PED_NOME,PED_MUN, "
cQuery += "        PED_TOTAL, "
cQuery += "        CASE WHEN B1_XSETOR LIKE 'COLCHAO%' THEN 'COLCHAO' END PED_SETOR  "
cQuery += "FROM PED (NOLOCK)  "
cQuery += "INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''  "
cQuery += "LEFT JOIN SG2100 SG2 (NOLOCK) ON PED_FILIAL = G2_FILIAL AND PED_PRODUTO = G2_PRODUTO AND G2_CODIGO IN ('F0') AND SG2.D_E_L_E_T_ = ''  "
cQuery += "WHERE PED_STATUS != 'C'  "
cQuery += "AND B1_XSETOR LIKE 'ALVEOLADO%'  "
cQuery += "AND B1_XSETOR LIKE '%'+@SETOR+'%'  "
cQuery += "AND CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN @DEDATA AND @ATEDATA  "
cQuery += ")TB  "
cQuery += "GROUP BY PED_DTPREVIA,PED_SETOR,PED_PRODUTO,PED_DESCRI,G2_TEMPAD  "
cQuery += "ORDER BY PED_SETOR,PED_DESCRI "
	
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

		//inicializo a primeira se็ใo
		oSection1:Init()

		oReport:IncMeter()



		cSetor 	:= cAlias->DT_PRODUCAO

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se็ใo

		oSection1:Cell("DT_PRODUCAO"):SetValue(cAlias->DT_PRODUCAO)
		oSection1:Cell("PED_SETOR"):SetValue(cAlias->PED_SETOR)
        oSection1:Cell("PED_PRODUTO"):SetValue(cAlias->PED_PRODUTO)
        oSection1:Cell("PED_DESCRI"):SetValue(cAlias->PED_DESCRI)
        oSection1:Cell("PED_QUANT"):SetValue(cAlias->PED_QUANT)
        oSection1:Cell("PED_TEMPO"):SetValue(cAlias->TEMPO)
        oSection1:Cell("TEMPO_ESTIMADO"):SetValue(cAlias->TEMPO_ESTIMADO)
        oSection1:Cell("G2_TEMPAD"):SetValue(cAlias->G2_TEMPAD)
        oSection1:Cell("TEMPO_NECESSARIO"):SetValue(cAlias->TEMPO_NECESSARIO)
		//oSection1:Cell("DTAMAZON"):SetValue(cAlias->DTAMAZON)
		oSection1:Printline()

		//inicializo a segunda se็ใo
		//oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		//While cAlias->DENSIDADE == cSetor
			//oReport:IncMeter()

			//IncProc("Imprimindo Plano de Lamina็ใo "+alltrim(cAlias->G1_XDIMENS))
			//oSection2:Cell("G1_XDIMENS"):SetValue(cAlias->G1_XDIMENS)
			//oSection2:Cell("TOTAL"):SetValue(cAlias->TOTAL)
			//oSection2:Cell("QTD_PLANEJADA"):SetValue(cAlias->QTD_PLANEJADA)
			//oSection2:Cell("QTD_PRODUZIDA"):SetValue(cAlias->QTD_PRODUZIDA)
			//oSection2:Cell("STATUS"):SetValue(cAlias->STATUS)
			//oSection2:Printline()

			//cAlias->(dbSkip())
		//EndDo
		//Aqui, farei uma quebra  por se็ใo

		//finalizo a segunda se็ใo para que seja reiniciada para o proximo registro
		//oSection2:Finish()
		//imprimo uma linha para separar os Tํtulos de outro
		oReport:ThinLine()
		//finalizo a primeira se็ใo
		oSection1:Finish()
	Enddo

Return

Static Function AjustaSX1(cPerg)
    u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
    u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
    u_InPutSX1(cPerg,"03",PADR("Setor:" ,20)+"?","","","mv_ch3","C",20,0,0,"G","","","","","mv_par03") 
Return
