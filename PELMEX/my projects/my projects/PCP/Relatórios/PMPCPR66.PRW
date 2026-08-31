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

User Function PMPCPR66()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR66",10)

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

	oReport := TReport():New(cNOME,"Relat๓rio Acompanhamento Carga",cNOME,{|oReport| ReportPrint(oReport)},"producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira se็ใo
	


	oSection1:= TRSection():New(oReport, "Setor", {"cAlias"}, , .F., .T.)
	TRCell():New(oSection1,"DT_PRODUCAO"	,"cAlias","DT_PRODUCAO","@!",8)
	TRCell():New(oSection1,"CARGA"		,"cAlias","CARGA","@!",10)
	TRCell():New(oSection1,"PED_MUN"		,"cAlias","LOCALUF","@!",20)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produto", {"cAlias"}, NIL, .F., .T.)

	TRCell():New(oSection2,"PED_NUM"	    	,"cAlias","PEDIDO","@!",10)
	TRCell():New(oSection2,"PED_OP"				,"cAlias","ORDEM","@!",10)
	//TRCell():New(oSection2,"C6_NOTA"			,"cAlias","NOTA_OP","@!",10)
	TRCell():New(oSection2,"PED_ITEM"			,"cAlias","ITEM","@!",3)
	TRCell():New(oSection2,"PED_PRODUTO"		,"cAlias","PRODUTO","@!",15)
	TRCell():New(oSection2,"PED_DESCRI"			,"cAlias","DESCRICAO","@!",55)
	TRCell():New(oSection2,"PED_QUANT"			,"cAlias","QTD","@E 9,999,999,999",)
	TRCell():New(oSection2,"CUBAGEM"			,"cAlias","CUBAGEM","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"PED_NOME"			,"cAlias","CLIENTE_OP","@!",16)
	
	
	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("CARGA"),("PEDIDO"))
	TRFunction():New(oSection2:Cell("PED_QUANT"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("CUBAGEM"),"Total","SUM",oBreak,,,,.F.,.F.)
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
	
	cQuery := " SELECT PED_NUM PEDIDO,C6_NOTA NOTA_OP,PED_DTPROPEL DT_PRODUCAO,PED_OP ORDEM,PED_ITEM ITEM,PED_MUN LOCALUF,"
	cQuery += "         PED_PRODUTO PRODUTO,PED_DESCRI DESCRICAO,PED_QUANT QTD,"
	cQuery += " 	   ((B1_XALTURA*B1_XCOMPRI*B1_XLARGUR)*PED_QUANT)CUBAGEM,C2_XCARGA CARGA,PED_NOME CLIENTE_OP"
	cQuery += " 	    FROM PED"
	cQuery += " 		LEFT JOIN SC2100 SC2 ON PED_OP = C2_NUM AND PED_PRODUTO = C2_PRODUTO AND SC2.D_E_L_E_T_= ''"
	cQuery += " 		INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''"
	cQuery += "			LEFT JOIN (SELECT C6_NUM,C6_NOTA,C6_FILIAL,C6_PRODUTO"
    cQuery += "     		  		FROM SC6100 SC6 (NOLOCK)"
    cQuery += " 	    	  		WHERE SC6.D_E_L_E_T_ =''"
    cQuery += "						)SC6 ON C2_FILIAL = C6_FILIAL AND C6_NUM = PED_NUM AND C6_PRODUTO = C2_PRODUTO "
	cQuery += " 		WHERE PED_STATUS != 'C'"
	cQuery += " 		AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " 	 	AND C2_XCARGA BETWEEN '"+(mv_par03)+"' AND '"+(mv_par04)+"'"
	cQuery += " 	  	ORDER BY C2_XCARGA,C6_NOTA,PED_ITEM"
	cQuery += "	      "
	

	
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



		cSetor 	:= cAlias->CARGA

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se็ใo

		oSection1:Cell("DT_PRODUCAO"):SetValue(cAlias->DT_PRODUCAO)
		oSection1:Cell("CARGA"):SetValue(cAlias->CARGA)
		oSection1:Cell("PED_MUN"):SetValue(cAlias->LOCALUF)

		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		While cAlias->CARGA == cSetor
			oReport:IncMeter()

		IncProc("Imprimindo Estrutura "+alltrim(cAlias->PEDIDO))
			oSection2:Cell("PED_NUM"):SetValue(cAlias->PEDIDO)
			oSection2:Cell("PED_OP"):SetValue(cAlias->ORDEM)
			//oSection2:Cell("C6_NOTA"):SetValue(cAlias->NOTA_OP)
			oSection2:Cell("PED_ITEM"):SetValue(cAlias->ITEM)
			oSection2:Cell("PED_PRODUTO"):SetValue(cAlias->PRODUTO)
			oSection2:Cell("PED_DESCRI"):SetValue(cAlias->DESCRICAO)
			oSection2:Cell("PED_QUANT"):SetValue(cAlias->QTD)
			oSection2:Cell("CUBAGEM"):SetValue(cAlias->CUBAGEM)
			oSection2:Cell("PED_NOME"):SetValue(cAlias->CLIENTE_OP)
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
    u_InPutSX1(cPerg,"01",PADR("Dt Prod:    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
    u_InPutSX1(cPerg,"02",PADR("At้ dt Prod:    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
    u_InPutSX1(cPerg,"03",PADR("De Carga:    ",20)+"","","","mv_ch3","C",9,0,0,"G","","","","","mv_par03")
    u_InPutSX1(cPerg,"04",PADR("At้ Carga:    ",20)+"","","","mv_ch4","C",9,0,0,"G","","","","","mv_par04")
   
Return
