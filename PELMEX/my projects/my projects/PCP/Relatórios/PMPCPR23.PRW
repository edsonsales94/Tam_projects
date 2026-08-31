#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR23    ºAutor  ³WILSON GUEDES	    				º Data ³  23/06/20 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Produto X Componente								        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR23()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR23",10)

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


	oReport := TReport():New(cNOME,"Analise de empenho X Estrutura",cNOME,{|oReport| ReportPrint(oReport)},"Analise de empenho X Estrutura")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção



	oSection1:= TRSection():New(oReport, "Produto", {"SC2"}, , .F., .T.)
	TRCell():New(oSection1,"C2_NUM"	   	   	   ,"cAlias","OP",,)
	TRCell():New(oSection1,"C2_PRODUTO"	   	   ,"cAlias","Produto",,16)
	TRCell():New(oSection1,"B1_DESC"	   	   ,"cAlias","Descrição",,60)  

	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas



	oSection2:= TRSection():New(oReport, "Componente", {"SG1"}, NIL, .F., .T.)


	TRCell():New(oSection2,"G1_COMP"	   	   ,"cAlias","Componente",,16)
	TRCell():New(oSection2,"DESCRI"	   	   	   ,"cAlias","Descrição",,60)  
	TRCell():New(oSection2,"B1_UM"	   	   	   ,"cAlias","Medida 1",,)  
	TRCell():New(oSection2,"B1_SEGUM"	   	   ,"cAlias","Medida 2",,)  
	TRCell():New(oSection2,"G1_XDIMENS"	   	   ,"cAlias","Dimensao",,10)
	TRCell():New(oSection2,"G1_QUANT"	   	   ,"cAlias","Estrutura",,10)
	TRCell():New(oSection2,"OPS"	   	   	   ,"cAlias","Ops Aberta",,10)  
	TRCell():New(oSection2,"RESULT"	   	   	   ,"cAlias","Consumo",,10)
	TRCell():New(oSection2,"D4_QTDORI"	   	   ,"cAlias","Empenho",,10)  





	oBreak := TRBreak():New(oSection2,oSection1:Cell("C2_NUM"),"Total") 
	TRFunction():New(oSection2:Cell("OPS"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.) 
	TRFunction():New(oSection2:Cell("RESULT"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)   
	TRFunction():New(oSection2:Cell("D4_QTDORI"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)

	//Fim Quebra por Seção

	//Totalizador final
	//TRFunction():New(oSection2:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 
	//TRFunction():New(oSection2:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

	//TRFunction():New(oSection2:Cell("SAI_DOC")	,"Total de Notas","COUNT",,,"@E 9,999,999,999",,.F.,.T.)


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



	cQuery += "	SELECT C2_NUM,C2_PRODUTO,B1_DESC,G1_COMP,DESCRI,B1_UM,B1_SEGUM,G1_XDIMENS,G1_QUANT,OPS, CAST(G1_QUANT*OPS AS NUMERIC(15,8))RESULT,CAST(D4_QTDEORI AS NUMERIC(15,8))D4_QTDORI "
	cQuery += "	FROM ( "
	cQuery += "	SELECT C2_NUM+C2_ITEM+C2_SEQUEN C2_NUM,C2_PRODUTO,SB11.B1_DESC,G1_COMP,SB12.B1_DESC DESCRI,SB12.B1_UM,SB12.B1_SEGUM,G1_XDIMENS,SUM(G1_QUANT) G1_QUANT,SUM(C2_QUANT) OPS "
	cQuery += "	FROM "+RETSQLNAME("SC2")+" SC2 (NOLOCK) " 
	cQuery += "	INNER JOIN "+RETSQLNAME("SG1")+" SG1 (NOLOCK) ON C2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SB1")+" SB11 (NOLOCK) ON SB11.B1_COD = C2_PRODUTO AND SB11.D_E_L_E_T_  = '' "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SB1")+" SB12 (NOLOCK) ON SB12.B1_COD = G1_COMP AND SB12.D_E_L_E_T_ ='' "
	cQuery += "	WHERE " 
	cQuery += "	SC2.D_E_L_E_T_ = '' "
	cQuery += "	AND G1_COMP NOT LIKE 'MOD%' "
	cQuery += "	AND C2_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "	AND C2_NUM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "	AND C2_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' "
	cQuery += "	AND C2_PRODUTO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	cQuery += "	AND G1_COMP BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
	cQuery += "	AND C2_CC BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "
	cQuery += "	GROUP BY C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,SB11.B1_DESC,G1_COMP,SB12.B1_DESC,G1_XDIMENS,SB12.B1_UM,SB12.B1_SEGUM "
	cQuery += "	)TB "
	cQuery += "	INNER JOIN "+RETSQLNAME("SD4")+" SD4 (NOLOCK) ON TB.C2_NUM = D4_OP  AND C2_PRODUTO = D4_PRODUTO AND G1_COMP = D4_COD AND D4_LOCAL = '10' AND  SD4.D_E_L_E_T_ ='' "
	cQuery += "	GROUP BY C2_NUM,C2_PRODUTO,B1_DESC,G1_COMP,DESCRI,G1_QUANT,OPS,D4_QTDEORI,G1_XDIMENS,B1_UM,B1_SEGUM "

	If mv_par13 == 2

		cQuery += "	HAVING CAST(G1_QUANT * OPS AS NUMERIC(15,8)) != CAST (D4_QTDEORI AS NUMERIC(15,8)) "
	EndIf

	cQuery += "	ORDER BY C2_NUM,C2_PRODUTO ,G1_COMP "












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

		cCodproduto 	:= cAlias->C2_NUM

		IncProc("Imprimindo PRODUTO"+alltrim(cAlias->C2_PRODUTO))

		//TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,A1_COD,A1_NOME,A3_NOME

		//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,		
		//imprimo a primeira seção				
		oSection1:Cell("C2_NUM"):SetValue(cAlias->C2_NUM)
		oSection1:Cell("C2_PRODUTO"):SetValue(cAlias->C2_PRODUTO) 
		oSection1:Cell("B1_DESC"):SetValue(cAlias->B1_DESC) 
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->C2_NUM == cCodproduto
			oReport:IncMeter()		                                

			//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,    

			IncProc("Imprimindo Componente"+alltrim(cAlias->G1_COMP))
			oSection2:Cell("G1_COMP"):SetValue(cAlias->G1_COMP)			
			oSection2:Cell("DESCRI"):SetValue(cAlias->DESCRI)
			oSection2:Cell("B1_UM"):SetValue(cAlias->B1_UM)
			oSection2:Cell("B1_SEGUM"):SetValue(cAlias->B1_SEGUM)
			oSection2:Cell("G1_XDIMENS"):SetValue(cAlias->G1_XDIMENS)
			oSection2:Cell("G1_QUANT"):SetValue(cAlias->G1_QUANT)
			oSection2:Cell("OPS"):SetValue(cAlias->OPS)
			oSection2:Cell("RESULT"):SetValue(cAlias->RESULT)
			oSection2:Cell("D4_QTDORI"):SetValue(cAlias->D4_QTDORI)
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

	u_InPutSX1(cPerg,"01",PADR("Armazen De ? ",20)+"","","","mv_ch1","C",2,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Armazen Ate? ",30)+"","","","mv_ch2","C",2,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Op de? ",30)+"","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Op ate? ",30)+"","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Emissao De? ",30)+"","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Emissão Ate? ",30)+"","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Produto de? ",30)+"","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Produto Ate? ",20)+"","","","mv_ch8","C",15,0,0,"G","","","","","mv_par08") 
	u_InPutSX1(cPerg,"09",PADR("Componente De? ",20)+"","","","mv_ch9","C",15,0,0,"G","","","","","mv_par09")
	u_InPutSX1(cPerg,"10",PADR("Componente Até ? ",20)+"","","","mv_ch8","C",15,0,0,"G","","","","","mv_par10") 
	u_InPutSX1(cPerg,"11",PADR("Cento de Custo de   ? ",20)+"","","","mv_ch9","C",4,0,0,"G","","","","","mv_par11")
	u_InPutSX1(cPerg,"12",PADR("Centro de Custo ate? ",20)+"","","","mv_cha","C",4,0,0,"G","","","","","mv_par12")
	u_InPutSX1(cPerg,"13",PADR("Listar a estrutura ? ",20)+"","","","mv_chb","C",1,2,0,"C","","","","","mv_par13")
Return