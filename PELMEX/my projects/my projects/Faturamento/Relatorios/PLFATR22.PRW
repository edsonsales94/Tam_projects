#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR08    ºAutor  ³WILSON GUEDES	    				º Data ³  02/07/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de Vendas									        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFATR22()
	Local oReport := nil
	Local cPerg:= Padr("PLFATR22",10)

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
	Local oBreak
	Local oFunction


	oReport := TReport():New(cNOME,"Relatório de Desconto Aplicado ",cNOME,{|oReport| ReportPrint(oReport)},"Desconto Aplicado")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção


	oSection1:= TRSection():New(oReport, "PRODUTO", {"SD2"}, , .F., .T.)
	TRCell():New(oSection1,"D2_COD"		   ,"cAlias","Codigo do Produto","@!",8)
	TRCell():New(oSection1,"B1_DESC"	   ,"cAlias","Descrição do Produto",,50)


	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "filial", {"SD2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"M0_FILIAL"	    		,"cAlias","Nome da Filial",,30)
	TRCell():New(oSection2,"D2_DOC"		    		,"cAlias","Documento",,10)
	TRCell():New(oSection2,"D2_SERIE"				,"cAlias","Série",/*Mascara*/,)    
	TRCell():New(oSection2,"EMISSAO"				,"cAlias","Emissão",/*Mascara*/,12)   

	TRCell():New(oSection2,"D2_PRUNIT"	   			,"cAlias","Preço de venda","@E 9,999,999,999.99",14)       
	TRCell():New(oSection2,"D2_QUANT"	   			,"cAlias","QTD",,4) 
	TRCell():New(oSection2,"TOTALVEND"	   			,"cAlias","Total de Venda","@E 9,999,999,999.99",14)  
	TRCell():New(oSection2,"VALDESC"	   			,"cAlias","Val Desconto","@E 9,999,999,999.99",14)
	TRCell():New(oSection2,"PERDESCONTO"	   		,"cAlias","% Desconto","@E 99.99",)  
	TRCell():New(oSection2,"D2_PRCVEN"	   			,"cAlias","Preço Liquido","@E 9,999,999,999.99",14)  
	TRCell():New(oSection2,"D2_TOTAL"	   			,"cAlias","Total Líquido","@E 9,999,999,999.99",14) 
	TRCell():New(oSection2,"A3_NOME"	   			,"cAlias","Vendedor",,50)                
	//Quebra por Seção

	oBreak := TRBreak():New(oSection2,oSection2:Cell("TOTALVEND"),"TOTAL DE VENDA") 
	oBreak := TRBreak():New(oSection2,oSection2:Cell("D2_TOTAL"),"TOTAL LIQUIDO") 
	TRFunction():New(oSection2:Cell("TOTALVEND"),"Total:   ","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("D2_TOTAL"),"Total : ","SUM",oBreak,,,,.F.,.F.)                                         
	//Fim Quebra por Seção

	//Totalizador final
	TRFunction():New(oSection2:Cell("TOTALVEND"),"TOTAL ","SUM",,,"@E 9,999,999,999",,.F.,.T.) 
	TRFunction():New(oSection2:Cell("D2_TOTAL")	,"TOTAL","SUM",,,"@E 9,999,999,999",,.F.,.T.)




	//Totalizador                                                                                                          MIC

	/* 

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	oReport:SetTotalInLine(.F.)

	//quebra  por seção (.T.) uma seção por pagina
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
	Local cMascara  := "@E 9,999,999,999,999,999,999"
	Local lPrim 	:= .T.

	cQuery := " SELECT M0_FILIAL,D2_SERIE,D2_DOC,CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103) EMISSAO,D2_COD,B1_DESC,D2_PRUNIT,D2_QUANT,(D2_PRUNIT*D2_QUANT) TOTALVEND,(D2_PRUNIT*D2_QUANT-D2_TOTAL) VALDESC,100-(D2_PRCVEN*100/D2_PRUNIT) PERDESCONTO,D2_PRCVEN,D2_QUANT,D2_TOTAL,A3_NOME " 
	cQuery += "	FROM "+RETSQLNAME("SD2")+" SD2 (NOLOCK) "
	cQuery += " INNER JOIN SIGAMAT SM (NOLOCK) ON D2_FILIAL = M0_CODFIL AND M0_CODIGO = '"+mv_par01+"' AND SM.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SF2")+" SF2 (NOLOCK) ON F2_FILIAL = D2_FILIAL AND F2_SERIE = D2_SERIE AND F2_DOC = D2_DOC AND SF2.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK) ON B1_COD = D2_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SA3")+" SA3 (NOLOCK) ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = '' "
	cQuery += " WHERE "
	cQuery += " SD2.D_E_L_E_T_ = '' "
	cQuery += " AND D2_PRUNIT != D2_PRCVEN "
	cQuery += " AND D2_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' " 
	cQuery += " AND D2_EMISSAO BETWEEN '"+DToS(mv_par04)+"' AND '"+DToS(mv_par05)+"' " 
	cQuery += "	AND 100-(D2_PRCVEN*100/D2_PRUNIT) >= "+STR(mv_par06,5,2)+" "
	cQuery += " ORDER BY M0_FILIAL,D2_COD,B1_DESC " 


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


		cCodproduto 	:= cAlias->D2_COD

		IncProc("Imprimindo Produto"+alltrim(cAlias->D2_COD))

		//imprimo a primeira seção				
		oSection1:Cell("D2_COD"):SetValue(cAlias->D2_COD)
		oSection1:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->D2_COD == cCodproduto
			oReport:IncMeter()		                                




			IncProc("Imprimindo Vendas"+alltrim(cAlias->M0_FILIAL))
			oSection2:Cell("M0_FILIAL"):SetValue(cAlias->M0_FILIAL)
			oSection2:Cell("D2_DOC"):SetValue(cAlias->D2_DOC)
			oSection2:Cell("D2_SERIE"):SetValue(cAlias->D2_SERIE)
			oSection2:Cell("EMISSAO"):SetValue(cAlias->EMISSAO)			
			oSection2:Cell("D2_PRUNIT"):SetValue(cAlias->D2_PRUNIT)	
			oSection2:Cell("D2_QUANT"):SetValue(cAlias->D2_QUANT)		
			oSection2:Cell("TOTALVEND"):SetValue(cAlias->TOTALVEND) 
			oSection2:Cell("VALDESC"):SetValue(cAlias->VALDESC)
			oSection2:Cell("PERDESCONTO"):SetValue(cAlias->PERDESCONTO)
			oSection2:Cell("D2_PRCVEN"):SetValue(cAlias->D2_PRCVEN)
			oSection2:Cell("D2_TOTAL"):SetValue(cAlias->D2_TOTAL)
			oSection2:Cell("A3_NOME"):SetValue(cAlias->A3_NOME)
			oSection2:Printline()
			cAlias->(dbSkip())
		EndDo		
		//Aqui, farei uma quebra  por seção

		//finalizo a segunda seção para que seja reiniciada para o proximo registro
		oSection2:Finish()
		//imprimo uma linha para separar os Títulos de outro
		oReport:ThinLine()
		//finalizo a primeira seção
		oSection1:Finish()
	Enddo


Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Empresa?    ",20)+"","","","mv_ch1","C",2,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("De Filial?    ",20)+"","","","mv_ch2","C",2,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Ate Filial?    ",20)+"","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("DT. Emissão de?    ",20)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("DT. Emissão Até?   ",20)+"","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Desconto Minimo?   ",20)+"","","","mv_ch6","N",5,2,0,"G","","","","","mv_par06")

Return
