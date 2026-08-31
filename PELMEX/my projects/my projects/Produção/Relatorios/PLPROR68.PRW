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

	/*
cQuery := "SELECT PED_DTPROPEL [Data_Producao],B1_XSETOR Setor, "
cQuery += "       SUM(PED_QUANT)[Qtd_Conjunto], "
cQuery += "     SUM(QTD_CALCULADA)[Qtd_Pecas], "
cQuery += "     SUM(PED_TOTAL)[Total_Programado], "
cQuery += "     SUM(ISNULL(TOTAL_FIN,0))[Total_Financeiro_Geral], "
cQuery += "     SUM(ISNULL(TOTAL_SF,0))[Total_Financeiro_a_Faturar] "
	*/

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
		

cQuery := " SELECT PED_DTPROPEL [Data_Producao],B1_XSETOR Setor, "
cQuery += "       SUM(PED_QUANT)[Qtd_Conjunto], "
cQuery += "     SUM(QTD_CALCULADA)[Qtd_Pecas], "
cQuery += "     SUM(PED_TOTAL)[Total_Programado], "
cQuery += "     SUM(ISNULL(TOTAL_FIN,0))[Total_Financeiro_Geral], "
cQuery += "     SUM(ISNULL(TOTAL_SF,0))[Total_Financeiro_a_Faturar] "
cQuery += " FROM( "
cQuery += " SELECT PED_DTPROPEL,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT, "
cQuery += "       CASE WHEN B1_XJUNCAO = 'S' THEN 2*CAST(PED_QUANT AS FLOAT) ELSE CAST(PED_QUANT AS FLOAT) END QTD_CALCULADA, "
cQuery += "      CASE WHEN (PED_NOME NOT LIKE 'PELMEX%' AND PED_NUM NOT LIKE 'L%' AND PED_NUM NOT LIKE 'R%' AND PED_LOCAL != '15') THEN CAST(PED_TOTAL AS FLOAT) END TOTAL_FIN, "
cQuery += "      CASE WHEN (D2_DOC IS NULL AND PED_NOME NOT LIKE 'PELMEX%' AND PED_NUM NOT LIKE 'L%' AND PED_NUM NOT LIKE 'R%' AND PED_LOCAL != '15') THEN CAST(PED_TOTAL AS FLOAT) END TOTAL_SF, "
cQuery += "      CAST(PED_TOTAL AS FLOAT)PED_TOTAL,PED_NOME,PED_MUN,B1_XSETOR "
cQuery += " FROM PED (NOLOCK) "
cQuery += " INNER JOIN SB1100 SB1 (NOLOCK) ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN SD2100 SD2 (NOLOCK) ON PED_FILIAL = D2_FILIAL AND PED_NUM = D2_PEDIDO AND PED_ITEM = D2_ITEMPV AND PED_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = '' "
cQuery += " WHERE PED_STATUS != 'C' "
cQuery += " AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " )TB "
cQuery += " GROUP BY PED_DTPROPEL,B1_XSETOR "
cQuery += " ORDER BY CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112),B1_XSETOR "

	
	
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
