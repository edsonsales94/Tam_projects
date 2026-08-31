#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de titulos em aberto por cliente							        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



User Function PMASSR02()
	Local oReport := nil
	Local cPerg:= Padr("PMASSR02",10)

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


	oReport := TReport():New(cNOME,"Relat๓rio de Assistencia Tecnica",cNOME,{|oReport| ReportPrint(oReport)},"Assistencia Tecnica")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Cliente", {"SD1"}, , .F., .T.)
	TRCell():New(oSection1,"D1_FORNECE"		   	,"cAlias","Codigo do Cliente",,17)
	TRCell():New(oSection1,"A1_NOME"	   	    ,"cAlias","Nome do Cliente",,50)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas
	oSection2:= TRSection():New(oReport, "Assistencia Tecnica", {"SD1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"D1_NFORI"	    			,"cAlias","1บNF.Saida",,12)
	TRCell():New(oSection2,"D1_SERIORI"			    	,"cAlias","Serie",,5)
	TRCell():New(oSection2,"D1_DOC"						,"cAlias","1บNF.Entrada",,12)    
	TRCell():New(oSection2,"D1_SERIE"					,"cAlias","Serie",/*Mascara*/,5)
	TRCell():New(oSection2,"D2_DOC"				   		,"cAlias","2บNF.Saida",/*Mascara*/,12)
	TRCell():New(oSection2,"D2_SERIE"					,"cAlias","Serie","",5)
	TRCell():New(oSection2,"D1_COD"				   		,"cAlias","Cod.Produto",,15)
	TRCell():New(oSection2,"B1_DESC"					,"cAlias","Descri็ใo do Produto",/*Mascara*/,)
	TRCell():New(oSection2,"F1_XMENS"					,"cAlias","Motivo da Assistencia",/*Mascara*/,60)
	TRCell():New(oSection2,"D1_QUANT"					,"cAlias","Qtd de Entrada","@E 999,999,999",)	
	TRCell():New(oSection2,"D2_QUANT"					,"cAlias","Qtd de Saida","@E 999,999,999",)

	//Quebra por Se็ใo 
	oBreak := TRBreak():New(oSection2,oSection1:Cell("D1_FORNECE"),"Total") 
	TRFunction():New(oSection2:Cell("D1_QUANT"),"","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("D2_QUANT"),"","SUM",oBreak,,,,.F.,.F.) 
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("D1_QUANT"),"Total Entrada","SUM",,,"@E 9,999,999,999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("D2_QUANT"),"Total Saida","SUM",,,"@E 9,999,999,999",,.F.,.T.)


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


	cQuery := "	SELECT D1_NFORI,D1_SERIORI,D1_DOC,D1_SERIE,D2_DOC,D2_SERIE,D1_FORNECE,A1_NOME,D1_COD,B1_DESC,F1_XMENS,D1_QUANT,D2_QUANT"
	cQuery += "	FROM "+RETSQLNAME("SD1")+" SD1 (NOLOCK)"
	cQuery += "	LEFT JOIN "+RETSQLNAME("SD2")+" SD2 (NOLOCK) ON SD2.D2_FILIAL = SD1.D1_FILIAL AND SD2.D2_NFORI = SD1.D1_DOC AND SD2.D2_CLIENTE = SD1.D1_FORNECE AND SD2.D2_COD = SD1.D1_COD AND SD1.D_E_L_E_T_ = '' AND SD2.D_E_L_E_T_ = '' "
	cQuery += "	INNER JOIN "+RETSQLNAME("SF1")+" SF1 (NOLOCK) ON F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE"
	cQuery += "	INNER JOIN "+RETSQLNAME("SA1")+" SA1 (NOLOCK) ON A1_COD = D1_FORNECE AND A1_LOJA = D1_LOJA AND SA1.D_E_L_E_T_ = ''"
	cQuery += "	INNER JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK) ON B1_COD = D1_COD "
	cQuery += "	WHERE D1_NFORI BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "	AND D1_SERIORI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "	AND D1_FORNECE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += "	AND D1_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "   
	cQuery += "	AND D1_DTDIGIT BETWEEN '"+DTOS(mv_par09)+"' AND '"+DTOS(mv_par10)+"' "  
	cQuery += "	AND D1_TES IN ('014','705') "
	cQuery += "	ORDER BY 1,3,5 "

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

		cCodproduto 	:= cAlias->D1_FORNECE

		IncProc("Imprimindo Clientes"+alltrim(cAlias->D1_FORNECE))     
		//imprimo a primeira se็ใo				
		oSection1:Cell("D1_FORNECE"):SetValue(cAlias->D1_FORNECE)
		oSection1:Cell("A1_NOME"):SetValue(cAlias->A1_NOME)         			
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->D1_FORNECE == cCodproduto
			oReport:IncMeter()		                                


			IncProc("Imprimindo Notas"+alltrim(cAlias->D1_NFORI))
			oSection2:Cell("D1_NFORI"):SetValue(cAlias->D1_NFORI)
			oSection2:Cell("D1_SERIORI"):SetValue(cAlias->D1_SERIORI)
			oSection2:Cell("D1_DOC"):SetValue(cAlias->D1_DOC)
			oSection2:Cell("D1_SERIE"):SetValue(cAlias->D1_SERIE)			
			oSection2:Cell("D2_DOC"):SetValue(cAlias->D2_DOC)
			oSection2:Cell("D2_SERIE"):SetValue(cAlias->D2_SERIE)
			oSection2:Cell("D1_COD"):SetValue(cAlias->D1_COD)
			oSection2:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)
			oSection2:Cell("F1_XMENS"):SetValue(cAlias->F1_XMENS)
			oSection2:Cell("D1_QUANT"):SetValue(cAlias->D1_QUANT)			
			oSection2:Cell("D2_QUANT"):SetValue(cAlias->D2_QUANT)					

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


	u_InPutSX1(cPerg,"01",PADR("Nf.Origem De  ?    ",20)+"","","","mv_ch1","C",9,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Nf.Origem At้ ?    ",20)+"","","","mv_ch2","C",9,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Serie De  ?    ",20)+"","","","mv_ch3","C",3,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Serie At้ ?    ",20)+"","","","mv_ch4","C",3,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Cliente De  ?    ",20)+"","","","mv_ch5","C",6,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Cliente At้ ?    ",20)+"","","","mv_ch6","C",6,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Cod.Produto De  ?    ",20)+"","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Cod.Produto At้ ?    ",20)+"","","","mv_ch8","C",15,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"07",PADR("Etiqueta De  ?    ",20)+"","","","mv_ch9","C",15,0,0,"G","","","","","mv_par09") 
	u_InPutSX1(cPerg,"08",PADR("Etiqueta At้ ?    ",20)+"","","","mv_cha","C",15,0,0,"G","","","","","mv_par10")
	U_InPutSX1(cPerg,"09", "Emissao De  ?","","","mv_chb","D",8,0,0,"G","","","","","mv_par11")
	U_InPutSX1(cPerg,"10", "Emissao Ate ?","","","mv_chc","D",8,0,0,"G","","","","","mv_par12")

Return