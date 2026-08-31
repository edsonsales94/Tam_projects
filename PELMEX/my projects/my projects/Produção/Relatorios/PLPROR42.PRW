#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR42    บAutor  ณJUEVAN SILVA   				บ Data ณ 18/01/24 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Acompanhamento de Perdas Produ็ใo				   						     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLPROR42()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR42",10)

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

	oReport := TReport():New(cNOME,"Acompanhamento de Perdas Produ็ใo",cNOME,{|oReport| ReportPrint(oReport)},"producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira se็ใo
	


	oSection1:= TRSection():New(oReport, "CCUSTO", {"cAlias"}, , .F., .T.)
	
	TRCell():New(oSection1,"PERIODO"	,"cAlias","PERIODO",,20)
	TRCell():New(oSection1,"CCUSTO"	    ,"cAlias","CCUSTO",,20)
	TRCell():New(oSection1,"DESCRI_CUSTO"		   ,"cAlias","DESCRI_CUSTO","@!",50)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "COMPONENTE", {"cAlias"}, NIL, .F., .T.)

	TRCell():New(oSection2,"COMPONENTE","cAlias","COMPONENTE",,20)
	TRCell():New(oSection2,"DESCRI_COMPONENTE","cAlias","DESCRI_COMPONENTE",/*Mascara*/,50)
	TRCell():New(oSection2,"UM","cAlias","UM",,3)
	TRCell():New(oSection2,"TOTAL_INSUMOS","cAlias","TOTAL_INSUMOS","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"CUSTO_MEDIO"	,"cAlias","CUSTO_MEDIO","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"CUSTO_TOTAL"	,"cAlias","CUSTO_TOTAL","@E 9,999,999,999.99",)
	
	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("CCUSTO"),"CCUSTO")
	TRFunction():New(oSection2:Cell("CUSTO_TOTAL"),"Total","SUM",oBreak,,,,.F.,.F.)
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
	
	cQuery := " SELECT PERIODO,CCUSTO,DESCRI_CUSTO,COMPONENTE,DESCRI_COMPONENTE,UM,SUM(TOTAL_INSUMOS)TOTAL_INSUMOS,CUSTO_MEDIO,SUM(CUSTO_TOTAL)CUSTO_TOTAL "
    cQuery += " FROM( "
	cQuery += " SELECT SUBSTRING(SG1_DATINC,4,7)PERIODO,SG1_CC CCUSTO,CTT_DESC01 DESCRI_CUSTO,SG1_COMP COMPONENTE,SG1_DESCINSU DESCRI_COMPONENTE,SG1_UM UM, "
	cQuery += "  SG1_TOTALINSU TOTAL_INSUMOS,B9_CM1 CUSTO_MEDIO,SG1_TOTALINSU*B9_CM1 CUSTO_TOTAL "
	cQuery += "   FROM SG1"
	cQuery += "  INNER JOIN SB1100 SB1 (NOLOCK) ON SG1_COMP = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += "  INNER JOIN CTT100 CTT (NOLOCK) ON SG1_CC = CTT_CUSTO "
	cQuery += "  LEFT JOIN (SELECT B9_FILIAL,B9_COD,B9_CM1 "
	cQuery += "  FROM SB9100 SB9 (NOLOCK) "
	cQuery += "  WHERE SB9.D_E_L_E_T_ = ''  "
	cQuery += " AND B9_LOCAL = '01' "
	cQuery += " AND B9_FILIAL = '01' "
	cQuery += " AND B9_DATA IN (SELECT MAX(B9_DATA)DATA "
	cQuery += "                 FROM SB9100 SB9 (NOLOCK) "
	cQuery += "                 WHERE SB9.D_E_L_E_T_ = '' "
	cQuery += "                 AND B9_LOCAL = '01' "
	cQuery += "                 AND B9_FILIAL = '01' "
	cQuery += "                ))SB9 ON SG1_FILIAL = B9_FILIAL AND SG1_COMP = B9_COD "
	cQuery += " WHERE SG1_DELETE = '' "
	cQuery += " AND CONVERT(VARCHAR,CAST(SG1_DATINC AS DATE),112) BETWEEN  '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'  "
	cQuery += " AND SG1_COD BETWEEN '"+(mv_par03)+"' AND '"+(mv_par04)+"'  "
    cQuery += " )TB "
	cQuery += " WHERE COMPONENTE BETWEEN '"+(mv_par05)+"' AND '"+(mv_par06)+"'  "
    cQuery += " GROUP BY PERIODO,CCUSTO,DESCRI_CUSTO,COMPONENTE,DESCRI_COMPONENTE,UM,CUSTO_MEDIO "
	
	
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



		cSetor 	:= cAlias->CCUSTO

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se็ใo
		

		oSection1:Cell("PERIODO"):SetValue(cAlias->PERIODO)
		oSection1:Cell("CCUSTO"):SetValue(cAlias->CCUSTO)
		oSection1:Cell("DESCRI_CUSTO"):SetValue(cAlias->DESCRI_CUSTO)
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		While cAlias->COMPONENTE == cSetor
			oReport:IncMeter()

			IncProc("Acompanhamento de Perdas Produ็ใo "+alltrim(cAlias->COMPONENTE))
			oSection2:Cell("COMPONETE"):SetValue(cAlias->COMPONENTE)
			oSection2:Cell("DESCRI_COMPONENTE"):SetValue(cAlias->DESCRI_COMPONENTE)
			oSection2:Cell("UM"):SetValue(cAlias->UM)
			oSection2:Cell("TOTAL_INSUMOS"):SetValue(cAlias->TOTAL_INSUMOS)
			oSection2:Cell("CUSTO_MEDIO"):SetValue(cAlias->CUSTO_MEDIO)
			oSection2:Cell("CUSTO_TOTAL"):SetValue(cAlias->CUSTO_TOTAL)
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
    u_InPutSX1(cPerg,"01",PADR("De Data?    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("De Cod?    ",20)+"","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Cod?    ",20)+"","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("De Componente?    ",20)+"","","","mv_ch5","C",8,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate Componente?    ",20)+"","","","mv_ch6","C",8,0,0,"G","","","","","mv_par06") 
Return
