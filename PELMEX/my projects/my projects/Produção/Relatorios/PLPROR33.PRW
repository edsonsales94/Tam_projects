#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR33    บAutor  ณJUEVAN SILVA   				บ Data ณ  07/12/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Acompanhamento Produ็ใo por Setor				   						     			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLPROR33()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR33",10)

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
	//Local oSection2:= Nil
	Local oBreak
	Local oFunction

	oReport := TReport():New(cNOME,"Acompanhamento Produ็ใo por Setor",cNOME,{|oReport| ReportPrint(oReport)},"producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira se็ใo
	


	oSection1:= TRSection():New(oReport, "PERIODO", {"cAlias"}, , .F., .T.)
	
	TRCell():New(oSection1,"PERIODO"	,"cAlias","perido",,10)
	TRCell():New(oSection,"ALVEOLADO"		      ,"cAlias","ALVEOLADO","@E 9,999,999,999.99",)
	TRCell():New(oSection,"CAMA_ACOPLADA"   	     ,"cAlias","CAMA_ACOPLADA","@@E 999,999,999.999",)
    TRCell():New(oSection,"CAMA_AMERICANA"   	     ,"cAlias","CAMA_AMERICANA","@@E 999,999,999.999",)
    TRCell():New(oSection,"CAMA_BAU"   	     ,"cAlias","CAMA_BAU","@@E 999,999,999.999",)
	TRCell():New(oSection,"CAMA_CLICK"   	     ,"cAlias","CAMA_CLICK","@@E 999,999,999.999",)
    TRCell():New(oSection,"CAMA_DOBRAVEL"   	     ,"cAlias","CAMA_DOBRAVEL","@@E 999,999,999.999",)
	TRCell():New(oSection,"COLCHAO_ESPUMA"   	     ,"cAlias","COLCHAO_ESPUMA","@@E 999,999,999.999",)
	TRCell():New(oSection,"COLCHAO_MOLA"   	     ,"cAlias","COLCHAO_MOLA","@@E 999,999,999.999",)
	TRCell():New(oSection,"COLCHONETE"   	     ,"cAlias","COLCHONETE","@@E 999,999,999.999",) 
    TRCell():New(oSection,"NAMASPET"   	     ,"cAlias","NAMASPET","@@E 999,999,999.999",) 
    TRCell():New(oSection,"ROLETE"   	     ,"cAlias","ROLETE","@@E 999,999,999.999",) 
    TRCell():New(oSection,"SUAVE_ENCOSTO"   	     ,"cAlias","SUAVE_ENCOSTO","@@E 999,999,999.999",) 
    TRCell():New(oSection,"TRAVESSEIRO"   	     ,"cAlias","TRAVESSEIRO","@@E 999,999,999.999",) 
    TRCell():New(oSection,"OUTROS"   	     ,"cAlias","OUTROS","@@E 999,999,999.999",) 
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
	//oReport:SetTotalInLine(.F.)

	//quebra  por se็ใo (.T.) uma se็ใo por pagina
	//oSection1:SetPageBreak(.F.)
	//oSection1:SetTotalText(" ")
Return(oReport)

/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	//Local oSection2 := oReport:Section(2)
	//Local cQuery    := ""
	//Local lPrim 	:= .T.
	
cQuery := "SELECT SUBSTRING(PED_DTPROPEL,4,7)PERIODO,"
cQuery := "SUM(ISNULL([ALVEOLADO],0))ALVEOLADO,"
cQuery := "SUM(ISNULL([CAMA ACOPLADA],0))CAMA_ACOPLADA,"
cQuery := "SUM(ISNULL([CAMA AMERICANA],0))CAMA_AMERICANA,"
cQuery := "SUM(ISNULL([CAMA BAU],0))CAMA_BAU,"
cQuery := "SUM(ISNULL([CAMA CLICK],0))CAMA_CLICK,"
cQuery := "SUM(ISNULL([CAMA DOBRAVEL],0))CAMA_DOBRAVEL,"
cQuery := "SUM(ISNULL([COLCHAO ESPUMA],0))COLCHAO_ESPUMA,"
cQuery := "SUM(ISNULL([COLCHAO MOLA],0))COLCHAO_MOLA,"
cQuery := "SUM(ISNULL([COLCHONETE],0))COLCHONETE,"
cQuery := "SUM(ISNULL([NAMASPET],0))NAMASPET,"
cQuery := "SUM(ISNULL([ROLETE],0))ROLETE,"
cQuery := "SUM(ISNULL([SUAVE ENCOSTO],0))SUAVE_ENCOSTO,"
cQuery := "SUM(ISNULL([TRAVESSEIRO],0))TRAVESSEIRO,"
cQuery := "SUM(ISNULL([''],0))OUTROS"
cQuery := "FROM("
cQuery := "SELECT PED_DTPROPEL,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,RTRIM(PED_SETOR)PED_SETOR,CAST(PED_QUANT AS FLOAT)PED_QUANT"
cQuery := "FROM PED (NOLOCK)"
cQuery := "WHERE PED_STATUS != 'C'"
cQuery := "AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'  "
cQuery := ")TB"
cQuery := "PIVOT("
cQuery := "SUM(PED_QUANT)"
cQuery := "FOR PED_SETOR IN ([ALVEOLADO],[CAMA ACOPLADA],[CAMA AMERICANA],[CAMA BAU],[CAMA CLICK],[CAMA DOBRAVEL],[COLCHAO ESPUMA],[COLCHAO MOLA],[COLCHONETE],[NAMASPET],[ROLETE],[SUAVE ENCOSTO],[TRAVESSEIRO],[''])"
cQuery := ")PV"
cQuery := "GROUP BY SUBSTRING(PED_DTPROPEL,4,7)"
cQuery := "ORDER BY 1,2"

	
	
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



		cSetor 	:= cAlias->DENSIDADE

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se็ใo

		oSection1:Cell("PERIODO"):SetValue(cAlias->PERIODO)
		oSection1:Cell("AVEOLADO"):SetValue(cAlias->AVEOLADO)
		oSection1:Cell("CAMA_ACOPLADA"):SetValue(cAlias->CAMA_ACOPLADA)
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		//While cAlias->DENSIDADE == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo Plano de Lamina็ใo "+alltrim(cAlias->G1_XDIMENS))
			oSection2:Cell("G1_XDIMENS"):SetValue(cAlias->G1_XDIMENS)
			oSection2:Cell("TOTAL"):SetValue(cAlias->TOTAL)
			//oSection2:Cell("QTD_PLANEJADA"):SetValue(cAlias->QTD_PLANEJADA)
			//oSection2:Cell("QTD_PRODUZIDA"):SetValue(cAlias->QTD_PRODUZIDA)
			//oSection2:Cell("STATUS"):SetValue(cAlias->STATUS)
			oSection2:Printline()

			cAlias->(dbSkip())
		//EndDo
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
    u_InPutSX1(cPerg,"01",PADR("De Produ็ใo?    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Produ็ใo?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
Return

