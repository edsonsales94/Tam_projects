#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR36    บAutor  ณWILSON GUEDES	    				บ Data ณ  26/02/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Custo de produto							        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLFATR36()
	Local oReport := nil
	Local cPerg:= Padr("PLFATR36",10)

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

	oReport := TReport():New(cNOME,"Relat๓rio Custo de produto",cNOME,{|oReport| ReportPrint(oReport)},"Custo de produto")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo

	oSection1:= TRSection():New(oReport, "Produto", {"SD2"}, , .F., .T.)
	TRCell():New(oSection1,"D2_EMISSAO"		   ,"cAlias","Emissใo","@!",17)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Componentes", {"SD2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"B1_XEMP"	    		,"cAlias","Empresa",,)
	TRCell():New(oSection2,"D2_DOC"		    		,"cAlias","Nota",,)
	TRCell():New(oSection2,"D2_COD"					,"cAlias","Codigo",/*Mascara*/,)
	TRCell():New(oSection2,"B1_DESC"				,"cAlias","Descri็ใo",/*Mascara*/,)
	TRCell():New(oSection2,"D2_TES"					,"cAlias","TES","",3)
	TRCell():New(oSection2,"B1_GRUPO"	    		,"cAlias","Grupo",,)
	TRCell():New(oSection2,"BM_DESC"		    	,"cAlias","Descri็ใo do grupo",,50)
	TRCell():New(oSection2,"D2_QUANT"				,"cAlias","Quantidade",/*Mascara*/,)
	TRCell():New(oSection2,"D2_TOTAL"				,"cAlias","Total",/*Mascara*/,)
	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("D2_EMISSAO"),"Total por Perido")

	TRFunction():New(oSection2:Cell("D2_TOTAL"),"Total","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

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
	Local cCodCli   := ""
	Local cCliente  := ""
	Local lPrim 	:= .T.

	cQuery := " SELECT CASE "
	cQuery += " WHEN B1_XEMP = '1' THEN 'PROBEL' "
	cQuery += " WHEN B1_XEMP = '2' THEN 'PELMEX' "
	cQuery += " WHEN B1_XEMP = '3' THEN 'SONOFLEX' "
	cQuery += " WHEN B1_XEMP = '4' THEN 'POLISHOP' "
	cQuery += " WHEN B1_XEMP = '5' THEN 'KING STAR' "
	cQuery += " WHEN B1_XEMP = '6' THEN 'INOVAR' "
	cQuery += " ELSE '' "
	cQuery += " END B1_XEMP, "
	cQuery += " D2_DOC,D2_COD,B1_DESC,D2_TES,B1_GRUPO,BM_DESC,D2_QUANT,D2_TOTAL,SUBSTRING(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),4,7) D2_EMISSAO "
	cQuery += " FROM "+RETSQLNAME("SD2")+" SD2 "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SF5")+" SF4 ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SBM")+" SBM ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN "+RETSQLNAME("SD1")+" SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' "
	cQuery += " WHERE SD2.D_E_L_E_T_ = '' "
	cQuery += " AND D1_DOC IS NULL "
	cQuery += " AND D2_CLIENTE BETWENN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND D2_EMISSAO BETWEEN '"+STOD(mv_par03)+"' AND '"+STOD(mv_par04)+"' "
	cQuery += " ORDER BY D2_EMISSAO "

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

		cCodproduto 	:= cAlias->D2_EMISSAO

		//IncProc("Imprimindo Produt"+alltrim(cAlias->G1_COD))

		//imprimo a primeira se็ใo

		oSection1:Cell("D2_EMISSAO"):SetValue(cAlias->D2_EMISSAO)
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->D2_EMISSAO == cCodproduto
			oReport:IncMeter()

			IncProc("Imprimindo produtos"+alltrim(cAlias->D2_DOC))
			oSection2:Cell("D2_DOC"):SetValue(cAlias->D2_DOC)
			oSection2:Cell("D2_COD"):SetValue(cAlias->D2_COD)
			oSection2:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)
			oSection2:Cell("D2_TES"):SetValue(cAlias->D2_TES)
			oSection2:Cell("B1_GRUPO"):SetValue(cAlias->B1_GRUPO)
			oSection2:Cell("BM_DESC"):SetValue(cAlias->BM_DESC)
			oSection2:Cell("D2_QUANT"):SetValue(cAlias->D2_QUANT)
			oSection2:Cell("D2_TOTAL"):SetValue(cAlias->D2_TOTAL)

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

	u_InPutSX1(cPerg,"01",PADR("Produto De  ?    ",20)+"","","","mv_ch1","C",16,0,0,"G","","SB1","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Produto At้ ?    ",20)+"","","","mv_ch2","C",16,0,0,"G","","SB1","","","mv_par02")

Return