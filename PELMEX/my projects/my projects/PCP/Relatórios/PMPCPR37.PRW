#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR32    บAutor  ณSTAN LEE LOPES    				บ Data ณ  16/05/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  PICKLIST SIMPLIFICADO ATIPICO PELMEX				        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PMPCPR37()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR37",10)

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

	oReport := TReport():New(cNOME,"Produ็ใo por Mesa",cNOME,{|oReport| ReportPrint(oReport)},"Produ็ใo por Mesa")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Setor", {"cAlias"}, , .F., .T.)
	TRCell():New(oSection1,"MESA"		   ,"cAlias","Mesa","@!",)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Estrutura", {"cAlias"}, NIL, .F., .T.)
	TRCell():New(oSection2,"CODIGO"	    		,"cAlias","C๓digo",,20)
	TRCell():New(oSection2,"DESCRICAO"		    ,"cAlias","Descri็ใo",,80)
	TRCell():New(oSection2,"JUNCAO"			,"cAlias","Jun็ใo",/*Mascara*/,10)
	TRCell():New(oSection2,"QTD_PRODUZIDA"		,"cAlias","Qtd.Produzida","@E 9,999,999,999.99",)
	//Quebra por Se็ใo
	
	oBreak := TRBreak():New(oSection2,oSection1:Cell("MESA"),"Por MESA	")

	TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                           
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
	Local teste := mv_par03
	
	
	cQuery := " 	SELECT CLB_ANTENA MESA,CLB_COD CODIGO,CLB_DESCRI DESCRICAO,"
	cQuery += "        CASE WHEN B1_XJUNCAO = '' THEN 'N'" 
	cQuery += " 	   ELSE B1_XJUNCAO END JUNCAO,"
	cQuery += "        CASE WHEN B1_XJUNCAO = 'S' THEN SUM(CLB_QUANT)*2"
	cQuery += " 	   ELSE SUM(CLB_QUANT) END QTD_PRODUZIDA"
	cQuery += " FROM CLB"
	cQuery += " INNER JOIN SB1100 SB1 ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = ''"
	cQuery += " WHERE CONVERT(VARCHAR,CAST(CLB_DATINC AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	cQuery += " AND CLB_ANTENA BETWEEN '"+STR(mv_par03)+"' AND '"+STR(mv_par04)+"' "
	cQuery += " GROUP BY CLB_ANTENA,CLB_COD,CLB_DESCRI,B1_XJUNCAO"
	cQuery += " ORDER BY CLB_ANTENA,4 DESC,5 DESC"

	
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

		cSetor 	:= cAlias->MESA

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se็ใo


		oSection1:Cell("MESA"):SetValue(cAlias->MESA)
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		While cAlias->MESA == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo produtos "+alltrim(cAlias->CODIGO))
			oSection2:Cell("CODIGO"):SetValue(cAlias->CODIGO)
			oSection2:Cell("DESCRICAO"):SetValue(cAlias->DESCRICAO)
			oSection2:Cell("JUNCAO"):SetValue(cAlias->JUNCAO)
			oSection2:Cell("QTD_PRODUZIDA"):SetValue(cAlias->QTD_PRODUZIDA)

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
    u_InPutSX1(cPerg,"01",PADR("Emissใo de  ?    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้ ?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Mesa de  ?    ",20)+"","","","mv_ch3","N",3,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Mesa Ate  ?    ",20)+"","","","mv_ch4","N",3,0,0,"G","","","","","mv_par04") 
Return