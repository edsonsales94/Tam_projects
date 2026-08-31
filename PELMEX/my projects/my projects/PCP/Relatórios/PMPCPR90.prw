#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR90   ºAutor  ³Stan Lee     				º Data ³  12/12/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Plano de Producao Bordadeira                        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PMPCPR90()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR90",10)

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

	oReport := TReport():New(cNOME,"PLANO DE PRODUCAO BORDADEIRA",cNOME,{|oReport| ReportPrint(oReport)},"PLANO BORDADEIRA")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira seção

	oSection1:= TRSection():New(oReport, "Dt. Pelmex", {"cAlias"}, , .F., .T.)
	TRCell():New(oSection1,"DT_PELMEX"      ,"cAlias","Dt. Pelmex","@!",20)

	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Dt. Pelmex", {"cAlias"}, NIL, .F., .T.)
	TRCell():New(oSection2,"TIPO"		   ,"cAlias","Tipo","@!",50)
	TRCell():New(oSection2,"DENSIDADE"      ,"cAlias","Densidade","@!",10)
	TRCell():New(oSection2,"ESPESSURA"      ,"cAlias","Espessura","@!",10)
	TRCell():New(oSection2,"CODIGO"			,"cAlias","Codigo","@!",15) 
	TRCell():New(oSection2,"DESCRICAO"		,"cAlias","Descricao","@!",100)   
	TRCell():New(oSection2,"QUANTIDADE"		,"cAlias","Quantidade","@E 999,999,999,999.99",)
    TRCell():New(oSection2,"DIMENSAO"		,"cAlias","Dimensao","@!",20)
    TRCell():New(oSection2,"MAQUINA"	    ,"cAlias","Maquina","@!",10)
    TRCell():New(oSection2,"BORDADO"	    ,"cAlias","Bordado","@!",10)
	TRCell():New(oSection2,"METRAGEM"		,"cAlias","Metragem","@E 999,999,999,999.99",20)
	TRCell():New(oSection2,"TEC_INVERT"     ,"cAlias","Tecido Invertido","@!",10)	

	//Quebra por Seção
	oBreak := TRBreak():New(oSection2,oSection1:Cell("DT_PELMEX"),"Por Data")

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

cQuery += " SELECT DT_PELMEX,TIPO,CODIGO,DESCRICAO,QUANTIDADE,DIMENSAO,MAQUINA,BORDADO,"
cQuery += "        METRAGEM,ESPESSURA,G1_XDENSID DENSIDADE,G1_XTECINV TEC_INVERT"
cQuery += " 	FROM("
cQuery += " 	SELECT DT_PELMEX,TIPO,CODIGO,DESCRICAO,QUANTIDADE,DIMENSAO,MAQUINA,BORDADO,LARGURA,COMPRIMENTO,G1_XDENSID,G1_XTECINV,"
cQuery += " 		CASE WHEN TIPO IN ('CAPA','ANTIDERRAPANTE') AND DESCRICAO NOT LIKE '%TNT%'  THEN QUANTIDADE * LARGURA ELSE CASE WHEN DESCRICAO LIKE '%TNT%' THEN QUANTIDADE * LARGURA * 2.18 ELSE METRAGEM END END METRAGEM,ESPESSURA"
cQuery += " 	FROM("
cQuery += " 	SELECT DT_PELMEX,TIPO,CODIGO,DESCRICAO,QUANTIDADE,DIMENSAO,MAQUINA,BORDADO,"
cQuery += " 		QUANTIDADE * CASE WHEN TIPO IN ('FAIXA','PILLOW') THEN ((LARGURA + COMPRIMENTO)*2)/FLOOR(CASE WHEN B1_XLARGUR > 0 THEN B1_XLARGUR/ALTURA ELSE 2.1/ALTURA END)END METRAGEM,"
cQuery += " 		ESPESSURA,LARGURA,COMPRIMENTO,ALTURA,B1_XLARGUR,G1_XDENSID,G1_XTECINV"
cQuery += " 	FROM("
cQuery += " 	SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_PELMEX,"
cQuery += " 		CASE WHEN SUBSTRING(D4_TRT,1,2) = 'CP' THEN 'CAPA' "
cQuery += " 				WHEN SUBSTRING(D4_TRT,1,2) = 'FX' THEN 'FAIXA' "
cQuery += " 				WHEN SUBSTRING(D4_TRT,1,2) = 'AN' THEN 'ANTIDERRAPANTE' " 
cQuery += " 				WHEN SUBSTRING(D4_TRT,1,2) = 'PI' THEN 'PILLOW' END TIPO,"
cQuery += " 				CAST(SUBSTRING(RTRIM(LTRIM(G1_XDIMENS)),1,3) AS FLOAT)/100 LARGURA,"
cQuery += " 				CAST(SUBSTRING(RTRIM(LTRIM(G1_XDIMENS)),5,3) AS FLOAT)/100 COMPRIMENTO,"
cQuery += " 				CAST(SUBSTRING(RTRIM(LTRIM(G1_XDIMENS)),9,3) AS FLOAT)/100 ALTURA,"
cQuery += " 			D4_COD CODIGO,B1_DESC DESCRICAO,SUM(C2_QUANT)QUANTIDADE,G1_XDIMENS DIMENSAO,G1_XMAQBOR MAQUINA,G1_XNBORD BORDADO,B1_XLARGUR,G1_XDENSID,"
cQuery += " 			CASE WHEN G1_XTECINV = 'S' THEN 'SIM' ELSE '' END G1_XTECINV,"
cQuery += " 			G1_XESPESS ESPESSURA"
cQuery += " 	FROM("
cQuery += " 	SELECT C2_EMISSAO,D4_COD,B1_DESC,B1_UM,D4_TRT,C2_QUANT,G1_QUANT,D4_QTDEORI,G1_XDIMENS,G1_XMAQBOR,G1_XNBORD,B1_XLARGUR,G1_XDENSID,G1_XTECINV,G1_XESPESS"
cQuery += " 	FROM SC2100 SC2 (NOLOCK)"
cQuery += " 	INNER JOIN SG1100 SG1 (NOLOCK) ON G1_COD = C2_PRODUTO AND G1_COMP NOT LIKE 'MOD%' AND SG1.D_E_L_E_T_ = '' "
cQuery += " 	LEFT JOIN SD4100 SD4 (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND G1_COMP = D4_COD AND G1_TRT = D4_TRT AND SD4.D_E_L_E_T_ = '' "
cQuery += " 	INNER JOIN SB1100 SB1 (NOLOCK) ON D4_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQuery += " 	WHERE SC2.D_E_L_E_T_ = ''"
cQuery += " 	AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)"
cQuery += " 	AND C2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " 	AND SUBSTRING(D4_TRT,1,2) IN ('CP','FX','AN','PI')"
cQuery += " 	AND (B1_DESC LIKE 'ART%TEC%' "
cQuery += " 	OR B1_DESC LIKE 'ART%ANT%')"
cQuery += " 	)TB"
cQuery += " 	GROUP BY C2_EMISSAO,D4_TRT,D4_COD,B1_DESC,B1_UM,G1_XDIMENS,G1_XMAQBOR,G1_XNBORD,B1_XLARGUR,G1_XDENSID,G1_XTECINV,G1_XESPESS"
cQuery += " 	)TB1"
cQuery += " 	)TB2"
cQuery += " )TB3"
cQuery += " ORDER BY 2,11,3,6"

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

		cDtPelmex 	:= cAlias->DT_PELMEX

		//IncProc("Imprimindo Plano de Produçao Bordadeira "+alltrim(cAlias->CODIGO))

		//imprimo a primeira seção

		oSection1:Cell("DT_PELMEX"):SetValue(cAlias->DT_PELMEX)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Tipo é mesmo, se sim, imprimo Plano
		While cAlias->DT_PELMEX == cDtPelmex
			oReport:IncMeter()


			IncProc("Imprimindo Plano Bordadeira "+alltrim(cAlias->DESCRICAO))
            oSection2:Cell("TIPO"):SetValue("----------")
			oSection2:Cell("CODIGO"):SetValue("----------")
			oSection2:Cell("DESCRICAO"):SetValue("----------")
			oSection2:Cell("QUANTIDADE"):SetValue("----------")
			oSection2:Cell("DIMENSAO"):SetValue("----------")
			oSection2:Cell("MAQUINA"):SetValue("----------")
			oSection2:Cell("BORDADO"):SetValue("----------")
			oSection2:Cell("METRAGEM"):SetValue("----------")
			oSection2:Cell("ESPESSURA"):SetValue("----------")
			oSection2:Cell("DENSIDADE"):SetValue("----------")
            oSection2:Cell("TEC_INVERT"):SetValue("----------")
			oSection2:Cell("TIPO"):SetValue(cAlias->TIPO)
			oSection2:Cell("CODIGO"):SetValue(cAlias->CODIGO)
			oSection2:Cell("DESCRICAO"):SetValue(cAlias->DESCRICAO)
			oSection2:Cell("QUANTIDADE"):SetValue(cAlias->QUANTIDADE)
			oSection2:Cell("DIMENSAO"):SetValue(cAlias->DIMENSAO)
			oSection2:Cell("MAQUINA"):SetValue(cAlias->MAQUINA)
			oSection2:Cell("BORDADO"):SetValue(cAlias->BORDADO)
			oSection2:Cell("METRAGEM"):SetValue(cAlias->METRAGEM)
			oSection2:Cell("ESPESSURA"):SetValue(cAlias->ESPESSURA)
			oSection2:Cell("DENSIDADE"):SetValue(cAlias->DENSIDADE)
            oSection2:Cell("TEC_INVERT"):SetValue(cAlias->TEC_INVERT)


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
    u_InPutSX1(cPerg,"01",PADR("De DT PROD PEL:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate DT PROD PEL:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De PA:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate PA:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
Return
