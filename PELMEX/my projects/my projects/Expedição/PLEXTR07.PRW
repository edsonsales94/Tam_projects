#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXTR07    บAutor  ณWILSON GUEDES	    				บ Data ณ  08/07/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Pedidos em ordem											 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLEXTR07()
	Local oReport := nil
	Local cPerg:= Padr("PLEXTR07",10)

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

	oReport := TReport():New(cNOME,"Relat๓rio de Pedidos em ordem",cNOME,{|oReport| ReportPrint(oReport)},"Relat๓rio de Pedidos em ordem")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:nFontBody := 9

	//Primeira se็ใo

	oSection1:= TRSection():New(oReport, "Pedido", {"PK2"}, , .F., .T.)
	TRCell():New(oSection1,"PK2_CODIGO"					,"cAlias","Codigo","",15)
	TRCell():New(oSection1,"PED_NUM"					,"cAlias","Numero",/*Mascara*/,9)
	TRCell():New(oSection1,"PK2_PRODUTO"	    		,"cAlias","Produto",,9)
	TRCell():New(oSection1,"PK2_DESCRI"		    		,"cAlias","Descri็ao",,60)
	TRCell():New(oSection1,"PK2_QUANT"					,"cAlias","Qtd.Ordem",/*Mascara*/,8)
	TRCell():New(oSection1,"PED_QUANT"	    			,"cAlias","Qtd.Pedido",,8)
	TRCell():New(oSection1,"INICIO_PRODUCAO"		    ,"cAlias","Inicio",,10)
	TRCell():New(oSection1,"DT_INCLUSAO"				,"cAlias","Planjado",/*Mascara*/,10)


	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas


	

	//Quebra por Se็ใo
	//	oBreak := TRBreak():New(oSection2,oSection1:Cell("CNF_DOCA"),"Total por Perido")

	//TRFunction():New(oSection2:Cell("CNF_CLIENTE"),"Total","COUNT",oBreak,,,,.F.,.F.)
	//Fim Quebra por Se็ใo

	//Totalizador final
	//	TRFunction():New(oSection2:Cell("CNF_CLIENTE"),"TOTAL ENVIADO","COUNT",,,"@E 9,999,999,999",,.F.,.T.)
	//Totalizador
	/*

	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	//	oReport:ThinLine()
	oReport:SetTotalInLine(.F.)
	//quebra  por se็ใo (.T.) uma se็ใo por pagina
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)


	Local cQuery    := ""

	
	cQuery := "	SELECT PK2_CODIGO,PED_NUM,PK2_PRODUTO,PK2_DESCRI,PK2_QUANT,PED_QUANT,PK2_DTPROPEL INICIO_PRODUCAO,PK2_DATINC DT_INCLUSAO "
	cQuery += " FROM PK2 "
	cQuery += " INNER JOIN (SELECT PED_CODIGO,PED_NUM,PED_PRODUTO,SUM(PED_QUANT)PED_QUANT "
	cQuery += "       FROM PED "
	cQuery += "       WHERE PED_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "       AND PED_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "       AND PED_NOTA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += "       GROUP BY PED_CODIGO,PED_NUM,PED_PRODUTO)PED ON PK2_CODIGO = PED_CODIGO AND PK2_PRODUTO = PED_PRODUTO "
	cQuery += " ORDER BY PK2_CODIGO,PK2_PRODUTO "
	

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
		//IncProc("Imprimindo Produt"+alltrim(cAlias->G1_COD))


		//imprimo a primeira se็ใo
		oSection1:Cell("PK2_CODIGO"):SetValue(cAlias->PK2_CODIGO)
		oSection1:Cell("PED_NUM"):SetValue(cAlias->PED_NUM)
		oSection1:Cell("PK2_PRODUTO"):SetValue(cAlias->PK2_PRODUTO)
		oSection1:Cell("PK2_DESCRI"):SetValue(cAlias->PK2_DESCRI)
		oSection1:Cell("PK2_QUANT"):SetValue(cAlias->PK2_QUANT)
		oSection1:Cell("PED_QUANT"):SetValue(cAlias->PED_QUANT)
		oSection1:Cell("INICIO_PRODUCAO"):SetValue(cAlias->INICIO_PRODUCAO)
		oSection1:Cell("DT_INCLUSAO"):SetValue(cAlias->DT_INCLUSAO)

		//Aqui, farei uma quebra  por se็ใo

		//finalizo a segunda se็ใo para que seja reiniciada para o proximo registro
		*/

		//finalizo a primeira se็ใo
		oSection1:Finish()
	Enddo

Return

Static Function AjustaSX1(cPerg)


	u_InPutSX1(cPerg,"01",PADR("Pedido De  ?",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Pedido At้ ?",20)+"","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Produto De ?",20)+"","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Produto At้  ?",20)+"","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Nota De ?",20)+"","","","mv_ch5","C",9,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Nota At้ ?",20)+"","","","mv_ch6","C",9,0,0,"G","","","","","mv_par06")
Return
