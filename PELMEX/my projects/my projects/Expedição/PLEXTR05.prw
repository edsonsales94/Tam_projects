#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLEXTR05    ºAutor  ³WILSON GUEDES	    				º Data ³  02/03/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório Saida das Docas							 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLEXTR05()
	Local oReport := nil
	Local cPerg:= Padr("PLEXTR05",10)

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
	Local oSection3:= Nil
	Local oSection4:= Nil
	Local oBreak
	Local oFunction

	oReport := TReport():New(cNOME,"Relatório saida das docas",cNOME,{|oReport| ReportPrint(oReport)},"Saida das Docas")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:nFontBody := 12

	//Primeira seção

	oSection1:= TRSection():New(oReport, "DOCA", {"CNF"}, , .F., .T.)
	TRCell():New(oSection1,"CNF_LACRE"					,"cAlias","Lacre","",50)
	TRCell():New(oSection1,"CNF_MAT"					,"cAlias","Matricula","!@",8)
	TRCell():New(oSection1,"CNF_FUNC"					,"cAlias","Responsavel","!@",20)
	TRCell():New(oSection1,"CNF_PLACA"					,"cAlias","Placa","",20)
	TRCell():New(oSection1,"CNF_MOTORISTA"				,"cAlias","Motorista","!@",20)
	TRCell():New(oSection1,"CNF_DOCA"		   			,"cAlias","Doca ","!@",10)

	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Nota", {"SD2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"CNF_CLIENTE"	    		,"cAlias","Cod. Cli","!@",8)
	TRCell():New(oSection2,"CNF_LOJA"		    		,"cAlias","Loja","!@",5)
	TRCell():New(oSection2,"CNF_NOME"					,"cAlias","Nome Cliente","!@",25)
	TRCell():New(oSection2,"A1_EST"						,"cAlias","Estado","!@",5)
	TRCell():New(oSection2,"A1_MUN"						,"cAlias","Cidade","!@",15)
	TRCell():New(oSection2,"CNF_DOC"	    			,"cAlias","Nota","!@",12)
	TRCell():New(oSection2,"CNF_SERIE"		    		,"cAlias","Serie","!@",4)
	//TRCell():New(oSection2,"CNF_EMISSAO"				,"cAlias","Emissão",/*Mascara*/,10)
	TRCell():New(oSection2,"CNF_EXPEDICAO"				,"cAlias","Expedição","!@",10)
	TRCell():New(oSection2,"F2_VALMERC"					,"cAlias","Valor da NF","@E 9,999,999.99",)

	oSection3:= TRSection():New(oReport, "ASSINATURA", {"SD2"}, NIL, .F., .T.)
	TRCell():New(oSection3,"ASS"	    		,"","Assinaturas","@!",99)

	//Quebra por Seção
	//	oBreak := TRBreak():New(oSection2,oSection1:Cell("CNF_DOCA"),"Total por Perido")

	//TRFunction():New(oSection2:Cell("CNF_CLIENTE"),"Total","COUNT",oBreak,,,,.F.,.F.)
	//Fim Quebra por Seção

	//Totalizador final
	//	TRFunction():New(oSection2:Cell("CNF_CLIENTE"),"TOTAL ENVIADO","COUNT",,,"@E 9,999,999,999",,.F.,.T.)
	//Totalizador
	/*

	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	//	oReport:ThinLine()
	oReport:SetTotalInLine(.F.)
	//quebra  por seção (.T.) uma seção por pagina
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local oSection4 := oReport:Section(4)
	Local cQuery    := ""
	Local aAss := {}
	Local lPrim 	:= .T.

	cQuery := " SELECT CNF_DOCA,CNF_CLIENTE,CNF_LOJA,CNF_NOME,A1_EST,A1_MUN,CNF_MAT,CNF_FUNC,CNF_DOC,CNF_SERIE,CNF_EMISSAO,CNF_EXPEDICAO,CNF_LACRE,CNF_MOTORISTA,CNF_PLACA,F2_VALMERC "
	cQuery += " FROM CNF "
	cQuery += " INNER JOIN SA1100 SA1 (NOLOCK) ON A1_COD = CNF_CLIENTE AND A1_LOJA = CNF_LOJA "
	cQuery += " LEFT JOIN  SC5100 SC5 (NOLOCK) ON C5_NOTA = CNF_DOC AND C5_SERIE = CNF_SERIE AND SC5.D_E_L_E_T_ = ''"
    cQuery += " LEFT JOIN  SF2100 SF2 (NOLOCK) ON F2_DOC = CNF_DOC AND F2_SERIE = CNF_SERIE AND F2_CLIENTE = CNF_CLIENTE AND F2_LOJA = CNF_LOJA  AND SF2.D_E_L_E_T_ = '' "
	cQuery += " WHERE CNF_DOCA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND CNF_DOC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
	cQuery += " AND CNF_SERIE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
    cQuery += " AND CONVERT(VARCHAR,CAST(CNF_DATINC AS DATE),112) BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' "
	cQuery += " AND CNF_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += " AND CNF_LACRE BETWEEN  '"+mv_par11+"' AND '"+mv_par12+"' "
	cQuery += " AND F2_VALMERC  > 0"
	cQuery += " GROUP BY CNF_DOCA,CNF_CLIENTE,CNF_LOJA,CNF_NOME,A1_EST,A1_MUN,CNF_MAT,CNF_FUNC,CNF_DOC,CNF_SERIE,CNF_EMISSAO,CNF_EXPEDICAO,CNF_LACRE,CNF_MOTORISTA,CNF_PLACA,F2_VALMERC "
	cQuery += " UNION "
	cQuery += " SELECT CNF_DOCA,CNF_CLIENTE,CNF_LOJA,CNF_NOME,A1_EST,A1_MUN,CNF_MAT,CNF_FUNC,CNF_DOC,CNF_SERIE,CNF_EMISSAO,CNF_EXPEDICAO,CNF_LACRE,CNF_MOTORISTA,CNF_PLACA,F2_VALMERC "
	cQuery += " FROM CNF "
	cQuery += " INNER JOIN SA1200 SA1 (NOLOCK) ON A1_COD = CNF_CLIENTE AND A1_LOJA = CNF_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN SC5200 SC5 (NOLOCK) ON C5_NOTA = CNF_DOC AND C5_SERIE = CNF_SERIE AND SC5.D_E_L_E_T_ = ''"
    cQuery += " LEFT JOIN SF2200 SF2 (NOLOCK) ON F2_DOC = CNF_DOC AND F2_SERIE = CNF_SERIE AND F2_CLIENTE = CNF_CLIENTE AND F2_LOJA = CNF_LOJA  AND SF2.D_E_L_E_T_ = '' "
	cQuery += " WHERE CNF_DOCA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND CNF_DOC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
	cQuery += " AND CNF_SERIE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
    cQuery += " AND CONVERT(VARCHAR,CAST(CNF_DATINC AS DATE),112) BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' "
	cQuery += " AND CNF_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += " AND CNF_LACRE BETWEEN  '"+mv_par11+"' AND '"+mv_par12+"' "
	cQuery += " AND F2_VALMERC  > 0"
	cQuery += " GROUP BY CNF_DOCA,CNF_CLIENTE,CNF_LOJA,CNF_NOME,A1_EST,A1_MUN,CNF_MAT,CNF_FUNC,CNF_DOC,CNF_SERIE,CNF_EMISSAO,CNF_EXPEDICAO,CNF_LACRE,CNF_MOTORISTA,CNF_PLACA,F2_VALMERC "
	cQuery += " ORDER BY CNF_LACRE,CNF_DOCA,CNF_DOC "
	
	//28/08 - INCLUSAO DO VALOR DA NOTA E FILTROS DE DADOS
	/*cQuery := "	SELECT CNF_DOCA,CNF_CLIENTE,CNF_LOJA,CNF_NOME,A1_EST,A1_MUN,CNF_MAT,CNF_FUNC,CNF_DOC,CNF_SERIE,CNF_EMISSAO,CNF_EXPEDICAO,CNF_LACRE,CNF_MOTORISTA,CNF_PLACA,CNF_HORALT"
	cQuery += " FROM CNF "
	//cQuery += " INNER JOIN SD2100 SD2(NOLOCK) ON CNF_CLIENTE = D2_CLIENTE AND CNF_LOJA = D2_LOJA AND CNF_DOC = D2_DOC AND CNF_SERIE = D2_SERIE AND SD2.D_E_L_E_T_ = ''"
	cQuery += " INNER JOIN SA1100 SA1 (NOLOCK) ON A1_COD = CNF_CLIENTE AND A1_LOJA = CNF_LOJA"
	cQuery += " LEFT JOIN SC5100 SC5 (NOLOCK) ON C5_DOC = CNF_DOC"
	cQuery += " WHERE CNF_DOCA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND CNF_DOC BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " AND CNF_SERIE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " AND CONVERT(VARCHAR,CAST(CNF_DATINC AS DATE),112) BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' "
	cQuery += " AND CNF_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += " AND CNF_LACRE BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "
	//cQuery += " GROUP BY CNF_DOCA,CNF_CLIENTE,CNF_LOJA,CNF_NOME,D2_EST,A1_MUN,CNF_MAT,CNF_FUNC,CNF_DOC,CNF_SERIE,CNF_EMISSAO,CNF_EXPEDICAO,CNF_LACRE,CNF_MOTORISTA,CNF_PLACA,CNF_HORALT "
	cQuery += " ORDER BY CNF_LACRE,CNF_DOCA,CNF_DOC "*/

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

		cCodproduto 	:= cAlias->CNF_LACRE

		//IncProc("Imprimindo Produt"+alltrim(cAlias->G1_COD))

		//imprimo a primeira seção
		oSection1:Cell("CNF_MAT"):SetValue(cAlias->CNF_MAT)
		oSection1:Cell("CNF_FUNC"):SetValue(cAlias->CNF_FUNC)
		oSection1:Cell("CNF_LACRE"):SetValue(cAlias->CNF_LACRE)
		oSection1:Cell("CNF_MOTORISTA"):SetValue(cAlias->CNF_MOTORISTA)
		oSection1:Cell("CNF_PLACA"):SetValue(cAlias->CNF_PLACA)
		oSection1:Cell("CNF_DOCA"):SetValue(cAlias->CNF_DOCA)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->CNF_LACRE == cCodproduto
			oReport:IncMeter()

			IncProc("Imprimindo produtos"+alltrim(cAlias->CNF_CLIENTE))
			oSection2:Cell("CNF_CLIENTE"):SetValue(cAlias->CNF_CLIENTE)
			oSection2:Cell("CNF_LOJA"):SetValue(cAlias->CNF_LOJA)
			oSection2:Cell("CNF_NOME"):SetValue(cAlias->CNF_NOME)
			oSection2:Cell("A1_EST"):SetValue(cAlias->A1_EST)
			oSection2:Cell("A1_MUN"):SetValue(cAlias->A1_MUN)
			oSection2:Cell("CNF_DOC"):SetValue(cAlias->CNF_DOC)
			oSection2:Cell("CNF_SERIE"):SetValue(cAlias->CNF_SERIE)
			//oSection2:Cell("CNF_EMISSAO"):SetValue(cAlias->CNF_EMISSAO)
			oSection2:Cell("CNF_EXPEDICAO"):SetValue(cAlias->CNF_EXPEDICAO)
			oSection2:Cell("F2_VALMERC"):SetValue(cAlias->F2_VALMERC)

			oSection2:Printline()
			cAlias->(dbSkip())
		EndDo
		oSection2:Finish()

		oSection3:init()

		aadd(aAss,{" "})
		aadd(aAss,{"Assinatura do Motorista:"+REPLICATE("_", 80)})
		aadd(aAss,{" "})
		aadd(aAss,{"Assinatura do Responsavel:"+REPLICATE("_", 80)})
		oReport:SetMeter(Len(aAss))
		oReport:IncMeter()

		for i=1 to 1

			oReport:IncMeter()
			oSection3:Cell("ASS"):SetValue(" "+ Chr(13) + Chr(10))
			oSection3:Printline()
			oSection3:Cell("ASS"):SetValue(" "+ Chr(13) + Chr(10))
			oSection3:Printline()
			oSection3:Cell("ASS"):SetValue(" "+ Chr(13) + Chr(10))
			oSection3:Printline()
			oSection3:Cell("ASS"):SetValue("Assinatura do Motorista:"+REPLICATE("_", 80))
			oSection3:Printline()

			oSection3:Cell("ASS"):SetValue(" "+ Chr(13) + Chr(10))
			oSection3:Printline()
			oSection3:Cell("ASS"):SetValue(" "+ Chr(13) + Chr(10))
			oSection3:Printline()
			oSection3:Cell("ASS"):SetValue(" "+ Chr(13) + Chr(10))
			oSection3:Printline()
			oSection3:Cell("ASS"):SetValue("Assinatura do Responsavel:"+REPLICATE("_", 80))
			oSection3:Printline()

		next

		oSection3:Finish()
		//Aqui, farei uma quebra  por seção

		//finalizo a segunda seção para que seja reiniciada para o proximo registro
		*/

		//finalizo a primeira seção
		oSection1:Finish()
	Enddo

Return

Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Doca De  ?   	 ",20)+"","","","mv_ch1","C",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Doca Até ?  	 ",20)+"","","","mv_ch2","C",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Nota De  ?  	 ",20)+"","","","mv_ch3","C",9,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Nota Até ?   	 ",20)+"","","","mv_ch4","C",9,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Serie De  ? 	 ",20)+"","","","mv_ch5","C",3,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Serie Até ?  	 ",20)+"","","","mv_ch6","C",3,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Emissão De  ?    ",20)+"","","","mv_ch7","D",8,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Emissão Até ?    ",20)+"","","","mv_ch8","D",8,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("Cliente De  ?    ",20)+"","","","mv_ch9","C",6,0,0,"G","","SA1","","","mv_par09")
	u_InPutSX1(cPerg,"10",PADR("Cliente Até ?    ",20)+"","","","mv_cha","C",6,0,0,"G","","SA1","","","mv_par10")
	u_InPutSX1(cPerg,"11",PADR("Lacre De  ?   	 ",20)+"","","","mv_chb","C",30,0,0,"G","","","","","mv_par11")
	u_InPutSX1(cPerg,"12",PADR("Lacre Até ?   	 ",20)+"","","","mv_chc","C",30,0,0,"G","","","","","mv_par12")

Return
