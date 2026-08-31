#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR66    บAutor  ณWylliam Silva     				บ Data ณ  09/03/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Acompanhamento Carga	    		                			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PMASSR06()
	Local oReport := nil
	Local cPerg:= Padr("PMASSR06",10)

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

	oReport := TReport():New(cNOME,"Comprovante de assist๊ncia",cNOME,{|oReport| ReportPrint(oReport)},"producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira se็ใo
	

	oSection1:= TRSection():New(oReport, "Cabe็alho", {"cAlias"}, , .F., .T.)
	TRCell():New(oSection1,"DT_AGENDAMENTO"	,"cAlias","DT AGENDAMENTO","@!",10)
	TRCell():New(oSection1,"OS"				,"cAlias","OS","@!",15)
	TRCell():New(oSection1,"CLIENTE"		,"cAlias","CLIENTE","@!",15)
	TRCell():New(oSection1,"NOME"			,"cAlias","NOME","@!",30)
	TRCell():New(oSection1,"ENDERECO"		,"cAlias","ENDERECO","@!",30)
	TRCell():New(oSection1,"BAIRRO"			,"cAlias","BAIRRO","@!",20)
	TRCell():New(oSection1,"FONE"			,"cAlias","FONE","@!",12)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas


	oSection2:= TRSection():New(oReport, "Produto", {"cAlias"}, NIL, .F., .T.)

	TRCell():New(oSection2,"PRODUTO"	    	,"cAlias","PRODUTO","@!",15)
	TRCell():New(oSection2,"DESCRICAO"			,"cAlias","DESCRICAO","@!",35)
	TRCell():New(oSection2,"CHIP"				,"cAlias","CHIP","@!",30)
	TRCell():New(oSection2,"CODMOTEXT"			,"cAlias","CODMOTEXT","@!",4)
	TRCell():New(oSection2,"ANALISEEXTERNA"		,"cAlias","ANALISE_EXTERNA","@!",30)

	
	//Quebra por Se็ใo
	//oBreak := TRBreak():New(oSection2,oSection1:Cell("DT_AGENDAMENTO"),("PEDIDO"))
	//TRFunction():New(oSection2:Cell("PED_QUANT"),"Total","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("CUBAGEM"),"Total","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("QTD_TOTALJUNCAO"),"Total","SUM",oBreak,,,,.F.,.F.)
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
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")
Return(oReport)

/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local lPrim 	:= .T.
	
	cQuery := "SELECT MDA_DTAGENDA DT_AGENDAMENTO,MDA_NUM OS,MDA_CLIENTE CLIENTE,MDA_NOME NOME,A1_END ENDERECO,A1_BAIRRO BAIRRO,A1_TEL FONE, "
	cQuery += " 		MDA_PRODUTO PRODUTO,MDA_DESCRI DESCRICAO,MDA_CPRODUC CHIP,MDA_CODMOT CODMOTEXT,MDA_MOTIVO ANALISEEXTERNA "
	cQuery += "FROM MDA "
	cQuery += "INNER JOIN SA1100 SA1 (NOLOCK) ON MDA_CLIENTE = A1_COD AND A1_LOJA = '01'"
	cQuery += "WHERE MDA_STATUS NOT LIKE 'DELETADO'"
	cQuery += "AND CONVERT(VARCHAR,CAST(MDA_DTAGENDA AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += "AND MDA_CLIENTE BETWEEN '"+(mv_par03)+"' AND '"+(mv_par04)+"'"
	cQuery += "ORDER BY CONVERT(VARCHAR,CAST(MDA_DTAGENDA AS DATE),112)"
	cQuery += ""
	cQuery += ""
	

	
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



		cSetor 	:= cAlias->DT_AGENDAMENTO

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se็ใo

		oSection1:Cell("DT_AGENDAMENTO"):SetValue(cAlias->DT_AGENDAMENTO)
		oSection1:Cell("OS"):SetValue(cAlias->OS)
		oSection1:Cell("CLIENTE"):SetValue(cAlias->CLIENTE)
		oSection1:Cell("NOME"):SetValue(cAlias->NOME)
		oSection1:Cell("ENDERECO"):SetValue(cAlias->ENDERECO)
		oSection1:Cell("BAIRRO"):SetValue(cAlias->BAIRRO)
		oSection1:Cell("FONE"):SetValue(cAlias->FONE)
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		While cAlias->DT_AGENDAMENTO == cSetor
			oReport:IncMeter()


		IncProc("Imprimindo Estrutura "+alltrim(cAlias->PRODUTO))
			oSection2:Cell("PRODUTO"):SetValue(cAlias->PRODUTO)
			oSection2:Cell("DESCRICAO"):SetValue(cAlias->DESCRICAO)
			oSection2:Cell("CHIP"):SetValue(cAlias->CHIP)
			oSection2:Cell("CODMOTEXT"):SetValue(cAlias->CODMOTEXT)
			oSection2:Cell("ANALISE_EXTERNA"):SetValue(cAlias->ANALISEEXTERNA)
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
		oReport:endpage()
	Enddo

Return

Static Function AjustaSX1(cPerg)
    u_InPutSX1(cPerg,"01",PADR("Dt Agenda:    ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
    u_InPutSX1(cPerg,"02",PADR("At้ Agenda:   ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02") 
    u_InPutSX1(cPerg,"03",PADR("De Cliente:   ",20)+"","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03")
    u_InPutSX1(cPerg,"04",PADR("At้ Cliente:  ",20)+"","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
   
Return