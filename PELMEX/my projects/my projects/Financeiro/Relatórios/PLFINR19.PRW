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



User Function PLFINR19()
	Local oReport := nil
	Local cPerg:= Padr("PLFINR19",10)

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


	oReport := TReport():New(cNOME,"Relat๓rio de titulos em aberto por cliente",cNOME,{|oReport| ReportPrint(oReport)},"Custo de produto")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Cliente", {"SE1"}, , .F., .T.)
	TRCell():New(oSection1,"E1_CLIENTE"		   	,"cAlias","Codigo do Cliente","@!",17)
	TRCell():New(oSection1,"E1_NOMCLI"	   	    ,"cAlias","Nome do Cliente",,50)
	TRCell():New(oSection1,"E1_LOJA"	   		,"cAlias","Loja",,4)
	TRCell():New(oSection1,"A1_MSBLQL"	   		,"cAlias","Status Cliente",,30)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Titulos em Aberto", {"SE1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"E1_NUM"	    				,"cAlias","Numero do Titulo",,)
	TRCell():New(oSection2,"E1_PREFIXO"			    	,"cAlias","Prefixo",,4)
	TRCell():New(oSection2,"E1_PARCELA"					,"cAlias","Parcela","@E ",)    
	TRCell():New(oSection2,"E1_EMISSAO"					,"cAlias","Emissใo",/*Mascara*/,)
	TRCell():New(oSection2,"E1_VENCTO"					,"cAlias","Vencimento",/*Mascara*/,)
	//TRCell():New(oSection2,"E1_NUMBOR"					,"cAlias","Bordero",/*Mascara*/,)
	//TRCell():New(oSection2,"E1_DTBOR"					,"cAlias","DtBord",/*Mascara*/,)	
	TRCell():New(oSection2,"E1_VALOR"					,"cAlias","Valor","@E 9,999,999,999.99",13)
	TRCell():New(oSection2,"E1_SALDO"					,"cAlias","Saldo","@E 9,999,999,999.99",13)
	TRCell():New(oSection2,"E1_HIST"					,"cAlias","Historico",/*Mascara*/,20)
	TRCell():New(oSection2,"STATUS"						,"cAlias","Status",/*Mascara*/,20)


	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("E1_CLIENTE"),"Total por Cliente ") 
	TRFunction():New(oSection2:Cell("E1_VALOR"),"Total","SUM",oBreak,,,,.F.,.F.) 
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("E1_VALOR"),"Total Geral","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)




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


	cQuery := " SELECT E1_CLIENTE,E1_NOMCLI,E1_LOJA,E1_NUM,E1_PREFIXO,E1_PARCELA,CONVERT(VARCHAR,CAST(E1_EMISSAO AS DATE),103) E1_EMISSAO,CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103) E1_VENCTO,E1_VALOR,E1_SALDO,E1_HIST, "
	cQuery += "			E1_NUMBOR,CONVERT(VARCHAR,CAST(E1_DTBOR AS DATE),103) E1_DTBOR"
	cQuery += " 	CASE WHEN E1_SALDO = 0 THEN 'RECEBIDO' "
	cQuery += " 	     WHEN CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),103)< GETDATE() THEN 'PARCELA VENCIDA'"
	cQuery += "		ELSE 'PARCELA NO PRAZO' END [STATUS],"
	cQuery += " 	CASE WHEN A1_MSBLQL = '1' THEN 'CLIENTE COM PENDENCIA' ELSE 'CLIENTE OK' END A1_MSBLQL,A3_NOME "
	cQuery += " FROM "+RETSQLNAME("SE1")+" (NOLOCK)SE1 "
	cQuery += " LEFT JOIN "+RETSQLNAME("SA1")+"(NOLOCK) SA1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SA3")+"(NOLOCK) SA3 ON E1_VEND1 = A3_COD AND SA3.D_E_L_E_T_ ='' "
	cQuery += " WHERE SE1.D_E_L_E_T_= ''  "
	cQuery += " AND E1_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND CONVERT(VARCHAR,CAST(E1_VENCTO AS DATE),112) BETWEEN '"+DToS(mv_par04)+"' AND '"+DToS(mv_par05)+"' "
	cQuery += " AND E1_VEND1 = '"+mv_par03+"' "
	cQuery += " AND E1_SALDO > 0 "
	cQuery += " GROUP BY E1_NUM,E1_PARCELA,E1_PREFIXO,E1_CLIENTE,E1_VENCTO,E1_NOMCLI,E1_LOJA,E1_EMISSAO,E1_VALOR,E1_SALDO,E1_HIST,A1_MSBLQL,A3_NOME" 
	cQuery += " ORDER BY E1_CLIENTE,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VENCTO "


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

		cCodproduto 	:= cAlias->E1_CLIENTE

		IncProc("Imprimindo Clientes"+alltrim(cAlias->E1_CLIENTE))

		//imprimo a primeira se็ใo				
		oSection1:Cell("E1_CLIENTE"):SetValue(cAlias->E1_CLIENTE)
		oSection1:Cell("E1_NOMCLI"):SetValue(cAlias->E1_NOMCLI) 
		oSection1:Cell("E1_LOJA"):SetValue(cAlias->E1_LOJA) 
		oSection1:Cell("A1_MSBLQL"):SetValue(cAlias->A1_MSBLQL)       			
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->E1_CLIENTE == cCodproduto
			oReport:IncMeter()		                                


			IncProc("Imprimindo Titulos"+alltrim(cAlias->E1_NUM))
			oSection2:Cell("E1_NUM"):SetValue(cAlias->E1_NUM)
			oSection2:Cell("E1_PREFIXO"):SetValue(cAlias->E1_PREFIXO)
			oSection2:Cell("E1_PARCELA"):SetValue(cAlias->E1_PARCELA)
			oSection2:Cell("E1_EMISSAO"):SetValue(cAlias->E1_EMISSAO)			
			oSection2:Cell("E1_VALOR"):SetValue(cAlias->E1_VALOR)
			oSection2:Cell("E1_SALDO"):SetValue(cAlias->E1_SALDO)
			oSection2:Cell("E1_HIST"):SetValue(cAlias->E1_HIST)
			oSection2:Cell("STATUS"):SetValue(cAlias->STATUS)		

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

	u_InPutSX1(cPerg,"01",PADR("Cliente De  ?    ",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Cliente At้ ?    ",20)+"","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Vendedor?     	 ",20)+"","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("De Dt Emissao? 	 ",20)+"","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("At้ Dt Emissao?	 ",20)+"","","","mv_ch5","D",10,0,0,"G","","","","","mv_par05")


Return
