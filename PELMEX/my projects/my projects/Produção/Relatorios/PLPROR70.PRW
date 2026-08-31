#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR68    บAutor  ณKLEDSON OLIVEIRA    				บ Data ณ  27/06/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Indicador de Plano de Producao				        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLPROR68()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR68",10)

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

	oReport := TReport():New(cNOME,"Indicador de Plano de Producao",cNOME,{|oReport| ReportPrint(oReport)},"Indicador de Plano de Producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira se็ใo
	


	oSection1:= TRSection():New(oReport, "Data_Producao", {"cAlias"}, , .F., .T.)
	
	TRCell():New(oSection1,"Data_Producao"		,"cAlias","Data_Producao ",,12)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Setor", {"cAlias"}, NIL, .F., .T.)

	TRCell():New(oSection2,"Setor"		    ,"cAlias","Setor",/*Mascara*/,20)
	TRCell():New(oSection2,"Qtd_Conjunto"		,"cAlias","Qtd. Conjunto","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"Qtd_Pecas"	,"cAlias","Qtd Pe็as","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"Total_Programado"	,"cAlias","Total Programado","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"Total_Financeiro_Geral"			,"cAlias","Total Financeiro Geral","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"Total_Financeiro_a_Faturar"			,"cAlias","Total Financeiro a Faturar","@E 9,999,999,999.99",)
	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("Data_Producao"),"Total")
	TRFunction():New(oSection2:Cell("Qtd_Conjunto"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("Qtd_Pecas"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("Total_Programado"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("Total_Financeiro_Geral"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("Total_Financeiro_a_Faturar"),"Total","SUM",oBreak,,,,.F.,.F.)

	//Fim Quebra por Se็ใo

	//Totalizador final
	//TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//Totalizador

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
		

cQuery := " SELECT 'PELMEX' Empresa,C5_EMISSAO [Data_Pedido],MAX(PED_DTPROPEL) [Data_Producao], "
cQuery += "        C6_NUM Pedido,ISNULL(D2_DOC,'')Nota, "
cQuery += "        A1_NOME Cliente, "
cQuery += "      SUM(C6_VALOR)[Total_Pedido], "
cQuery += "        SUM([Valor Financeiro])[Gera_Financeiro], "
cQuery += "      SUM([Valor Programado])[Total_Programado], "
cQuery += "      SUM([Valor Previa])[Total_Previa], "
cQuery += "      SUM([Valor Previa Financeiro])[Total_Previa_Financeiro], "
cQuery += "      SUM([Valor a Programar])[Total_a_Programar], "
cQuery += "      SUM([Valor a Faturar])[Total_a_Faturar], "
cQuery += "      SUM([Valor Faturado Financeiro])[Total_Faturado_Financeiro], "
cQuery += "      SUM([Valor a Faturar Financeiro])[Total_a_Faturar_Financeiro], "
cQuery += "      SUM([Valor Faturado])[Total_Faturado], "
cQuery += "      SUM([Valor a Expedir])[Total_a_Expedir], "
cQuery += "      SUM([Valor Expedido])[Total_Expedido] "
cQuery += " FROM( "
cQuery += " SELECT C6_FILIAL,C6_NUM,CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)C5_EMISSAO,C6_ENTREG,ISNULL(PED_DTPROPEL,'')PED_DTPROPEL,ISNULL(PED_DTPREVIA,'')PED_DTPREVIA,ISNULL(D2_DOC,'')D2_DOC,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_VALOR,C6_LOCAL,A1_NOME,A1_MUN, "
cQuery += "        F4_TEXTO, "
cQuery += "      CASE WHEN (A1_NOME LIKE 'ACP COMERCIO E REPRESENTACOES LTDA%' OR A1_NOME LIKE 'ARRUDA COMERCIO VAREJISTA DE ARTIGOS DE%' OR  "
cQuery += "                 A1_NOME LIKE 'ITALO DE OLIVEIRA VALERUZ%' OR A1_NOME LIKE '%PELMEX%' OR A1_NOME LIKE 'PRO FLORES COMERCIO DE ART. DE COLC.LTDA' "
cQuery += "           OR A1_NOME LIKE 'PI VIVIAN COM VAREJ DE ART DE COLCH LTDA' "
cQuery += "                 OR F4_TEXTO NOT LIKE '%VENDA%' OR SUBSTRING(C6_NUM,1,1) IN ('R','L')) THEN 0 ELSE C6_VALOR END [Valor Financeiro], "
cQuery += "      CASE WHEN ISNULL(PED_OP,'') = '' THEN 0 ELSE C6_VALOR END [Valor Programado], "
cQuery += "      CASE WHEN (ISNULL(PED_OP,'') = '' AND ISNULL(PED_DTPREVIA,'') != '') THEN C6_VALOR ELSE 0 END [Valor Previa], "
cQuery += "      CASE WHEN (ISNULL(PED_OP,'') = '' AND ISNULL(PED_DTPREVIA,'') != '') AND  "
cQuery += "                 (A1_NOME LIKE 'ACP COMERCIO E REPRESENTACOES LTDA%' OR A1_NOME LIKE 'ARRUDA COMERCIO VAREJISTA DE ARTIGOS DE%' OR  "
cQuery += "                 A1_NOME LIKE 'ITALO DE OLIVEIRA VALERUZ%' OR A1_NOME LIKE '%PELMEX%' OR A1_NOME LIKE 'PRO FLORES COMERCIO DE ART. DE COLC.LTDA' "
cQuery += "           OR A1_NOME LIKE 'PI VIVIAN COM VAREJ DE ART DE COLCH LTDA' "
cQuery += "                 OR F4_TEXTO NOT LIKE '%VENDA%' OR SUBSTRING(C6_NUM,1,1) IN ('R','L')) THEN 0 ELSE C6_VALOR END [Valor Previa Financeiro], "
cQuery += "      CASE WHEN (ISNULL(PED_OP,'') = '' AND ISNULL(PED_DTPREVIA,'') = '') THEN C6_VALOR ELSE 0 END [Valor a Programar], "
cQuery += "      CASE WHEN D2_DOC IS NOT NULL THEN 0 ELSE C6_VALOR END [Valor a Faturar], "
cQuery += "      CASE WHEN (D2_DOC IS NOT NULL AND F4_TEXTO LIKE '%VENDA%' AND SUBSTRING(C6_NUM,1,1) NOT IN ('L','R')) THEN C6_VALOR ELSE 0 END [Valor Faturado Financeiro], "
cQuery += "      CASE WHEN (D2_DOC IS NOT NULL) AND  "
cQuery += "                 (A1_NOME LIKE 'ACP COMERCIO E REPRESENTACOES LTDA%' OR A1_NOME LIKE 'ARRUDA COMERCIO VAREJISTA DE ARTIGOS DE%' OR  "
cQuery += "                 A1_NOME LIKE 'ITALO DE OLIVEIRA VALERUZ%' OR A1_NOME LIKE '%PELMEX%' OR A1_NOME LIKE 'PRO FLORES COMERCIO DE ART. DE COLC.LTDA' "
cQuery += "           OR A1_NOME LIKE 'PI VIVIAN COM VAREJ DE ART DE COLCH LTDA' "
cQuery += "                 OR F4_TEXTO LIKE '%VENDA%' OR SUBSTRING(C6_NUM,1,1) IN ('R','L')) THEN 0 ELSE C6_VALOR END [Valor a Faturar Financeiro], "
cQuery += "      CASE WHEN D2_DOC IS NOT NULL THEN C6_VALOR ELSE 0 END [Valor Faturado], "
cQuery += "      CASE WHEN CNF_EXPEDICAO IS NOT NULL THEN 0 ELSE C6_VALOR END [Valor a Expedir], "
cQuery += "      CASE WHEN CNF_EXPEDICAO IS NOT NULL THEN C6_VALOR ELSE 0 END [Valor Expedido] "
cQuery += " FROM SC5100 SC5 (NOLOCK) "
cQuery += " INNER JOIN SC6100 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN PED (NOLOCK) ON C6_FILIAL = PED_FILIAL AND C6_NUM = PED_NUM AND C6_ITEM = PED_ITEM AND C6_PRODUTO = PED_PRODUTO AND PED_STATUS != 'C'  "
cQuery += " LEFT JOIN SD2100 SD2 (NOLOCK) ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN SF4100 SF4 (NOLOCK) ON C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA "
cQuery += " WHERE C5_EMISSAO BETWEEN '20250801' AND '20250818' "
cQuery += " AND C5_FILIAL = '01' "
cQuery += " AND C6_LOCAL NOT IN ('01','10') "
cQuery += " AND C6_LOCAL NOT IN ('01') "
cQuery += " AND C6_TES NOT IN ('709','915','916','917') "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NรO PRODUZIR%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%' "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '% STAN%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TESTE%'  "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%MARKET%PLACE' "
cQuery += " AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%MKT'  "
cQuery += " )TB "
cQuery += " GROUP BY C5_EMISSAO,--PED_DTPROPEL,--PED_DTPREVIA, "
cQuery += "          A1_NOME,C6_NUM,D2_DOC,C6_LOCAL "
cQuery += " ORDER BY 1,CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),112),C6_NUM,A1_NOME "


	
	
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



		cDataProducao 	:= cAlias->Data_Producao

		//imprimo a primeira se็ใo
/*
	oSection1:= TRSection():New(oReport, "Data_Producao", {"cAlias"}, , .F., .T.)
	
	TRCell():New(oSection1,"Data_Producao"		,"cAlias","Data_Producao ",,12)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas
*/

		oSection1:Cell("Data_Producao"):SetValue(cAlias->Data_Producao)
		oSection1:Printline()

		//inicializo a segunda se็ใo

/*
	TRCell():New(oSection2,"Setor"		    ,"cAlias","Setor",/*Mascara,20)
	TRCell():New(oSection2,"Qtd_Conjunto"		,"cAlias","Qtd. Conjunto","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"Qtd_Pecas"	,"cAlias","Qtd Pe็as","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"Total_Programado"	,"cAlias","Total Programado","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"Total_Financeiro_Geral"			,"cAlias","Total Financeiro Geral","@E 9,999,999,999.99")
	TRCell():New(oSection2,"Total_Financeiro_a_Faturar"			,"cAlias","Total Financeiro a Faturar","@E 9,999,999,999.99")
*/
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		While cAlias->Data_Producao == cDataProducao
			oReport:IncMeter()

			IncProc("Imprimindo Estrutura "+alltrim(cAlias->Setor))
			oSection2:Cell("Setor"):SetValue(cAlias->Setor)
			oSection2:Cell("Qtd_Conjunto"):SetValue(cAlias->Qtd_Conjunto)
			oSection2:Cell("Qtd_Pecas"):SetValue(cAlias->Qtd_Pecas)
			oSection2:Cell("Total_Programado"):SetValue(cAlias->Total_Programado)
			oSection2:Cell("Total_Financeiro_Geral"):SetValue(cAlias->Total_Financeiro_Geral)
			oSection2:Cell("Total_Financeiro_a_Faturar"):SetValue(cAlias->Total_Financeiro_a_Faturar)
			oSection2:Printline()

			cAlias->(dbSkip())
		EndDo
		//Aqui, farei uma quebra  por se็ใo

		//finalizo a segunda se็ใo para que seja reiniciada para o proximo registro
		oSection2:Finish()
		//imprimo uma linha para separar os Tํtulos de outro
		oReport:ThinLine()
		//finalizo a primeira se็ใo
		oSection1:Finish()
	Enddo

Return

Static Function AjustaSX1(cPerg)
    u_InPutSX1(cPerg,"01",PADR("De dt. Produ็ใo?    ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
    u_InPutSX1(cPerg,"02",PADR("Ate dt. Produ็ใo?    ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02") 

Return
