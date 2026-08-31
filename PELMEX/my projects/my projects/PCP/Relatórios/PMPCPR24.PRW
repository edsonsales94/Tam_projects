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


User Function PMPCPR24()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR24",10)

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


	oReport := TReport():New(cNOME," ",cNOME,{|oReport| ReportPrint(oReport)}," ")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção





	oSection1:= TRSection():New(oReport, "Produto", {"SC2"}, , .F., .T.)
	TRCell():New(oSection1,"C6_PRODUTO"	   	   ,"cAlias","Produto",,16)
	TRCell():New(oSection1,"B1_DESC"	   	   ,"cAlias","Descrição",,60)  
	TRCell():New(oSection1,"SALDO"	   	   	   ,"cAlias","Saldo",,)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas




	oSection2:= TRSection():New(oReport, "Componente", {"SG1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"G1_COMP"	   	   ,"cAlias","Componente",,16)
	TRCell():New(oSection2,"G1_DESC"	   	   ,"cAlias","Descrição",,60)  
	TRCell():New(oSection2,"ESTRUTURA"	   	   ,"cAlias","Estrutura",,)  
	TRCell():New(oSection2,"L10"	   	   	   ,"cAlias","Qtd.Armazen",,10)
	TRCell():New(oSection2,"POSSIVEL"	   	   ,"cAlias","Qtd.Possivel",,10)
	TRCell():New(oSection2,"ABERTURA"	   	   ,"cAlias","Abertura Op.","@E 9,999,999,99",10)  
	TRCell():New(oSection2,"FALTA"	   	   	   ,"cAlias","Falta","@E 9,999,999,99",10)  





	oBreak := TRBreak():New(oSection2,oSection1:Cell("C6_PRODUTO"),"Total") 
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





	cQuery += "	SELECT C6_PRODUTO,B1_DESC,G1_COMP,G1_DESC,SUM(SALDO) SALDO, SUM(ESTRUTURA) ESTRUTURA , SUM(L10) L10, SUM(POSSIVEL)  POSSIVEL,SUM(ABERTURA) ABERTURA,SUM(FALTA) FALTA FROM ( "	
	cQuery += "			SELECT C6_PRODUTO,B1_DESC,G1_COMP,G1_DESC,SALDO,SUM(G1_QUANT) ESTRUTURA,L10, (L10/SUM(G1_QUANT)) POSSIVEL, "	 
	cQuery += "			CASE WHEN  (L10/SUM(G1_QUANT))>SALDO THEN SALDO ELSE L10/SUM(G1_QUANT) END  ABERTURA, "	
	cQuery += "			CASE WHEN  (L10/SUM(G1_QUANT))-SALDO<0 THEN  (L10/SUM(G1_QUANT))-SALDO ELSE 0 END FALTA "	
	cQuery += "			FROM ( "	
	cQuery += "			SELECT C6_PRODUTO,B1_DESC,QTD_PED,QTD_OP,L20,SALDO,G1_QUANT,G1_COMP,G1_DESC,ISNULL(L10,0)L10,(SALDO * G1_QUANT)APAGAR "	
	cQuery += "			FROM( "	
	cQuery += "			SELECT C6_PRODUTO,TAB.B1_DESC,QTD_PED,QTD_OP,L20,(QTD_PED-(QTD_OP-L20))SALDO,SB21.B2_QATU L10,G1_COMP,SB11.B1_DESC G1_DESC,G1_QUANT "	
	cQuery += "			FROM( "	
	cQuery += "			SELECT C6_PRODUTO,B1_DESC,SUM(QTD_PED)QTD_PED,SUM(QTD_OP)QTD_OP,B2_QATU L20 "	
	cQuery += "			FROM( "	
	cQuery += "			SELECT C6_FILIAL,C6_PRODUTO,B1_DESC,C6_LOCAL,SUM(QTD_PED)QTD_PED,SUM(QTD_OP)QTD_OP "	
	cQuery += "			FROM( "	
	cQuery += "			SELECT C6_FILIAL,C6_NUM,C6_PRODUTO,B1_DESC,C6_LOCAL,(C6_QTDVEN-C6_QTDENT)QTD_PED,0 QTD_OP "	
	cQuery += "			FROM "+RETSQLNAME("SC6")+" (NOLOCK) SC6 "	
	cQuery += "			INNER JOIN "+RETSQLNAME("SB1")+" (NOLOCK) SB1 ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "	
	cQuery += "			WHERE SC6.D_E_L_E_T_ = '' "	 
	cQuery += "			AND C6_ENTREG BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "	
	cQuery += "			AND C6_LOCAL = '20' "	
	cQuery += "			AND C6_FILIAL = '01' "	
	cQuery += "			AND C6_BLQ NOT IN  ('R','S') "	
	cQuery += "			AND C6_QTDVEN > C6_QTDENT "	
	cQuery += "			UNION "	
	cQuery += "			SELECT C2_FILIAL,'' C6_NUM,C2_PRODUTO,B1_DESC,C2_LOCAL,0 QTD_PED,(C2_QUANT-C2_QUJE) QTD_OP "	
	cQuery += "			FROM "+RETSQLNAME("SC2")+" (NOLOCK) SC2 "	
	cQuery += "			INNER JOIN "+RETSQLNAME("SB1")+" (NOLOCK) SB1 ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "	
	cQuery += "			WHERE SC2.D_E_L_E_T_ = '' "	 
	cQuery += "			AND C2_LOCAL = '20' "	
	cQuery += "			AND C2_FILIAL = '01' "	
	cQuery += "			AND C2_DATRF = '' "	
	cQuery += "			)TB "	
	cQuery += "			GROUP BY C6_FILIAL,C6_PRODUTO,B1_DESC,QTD_OP,C6_LOCAL "	
	cQuery += "			)TB1 "	
	cQuery += "			INNER JOIN "+RETSQLNAME("SB2")+" (NOLOCK) SB2 ON TB1.C6_FILIAL = B2_FILIAL AND TB1.C6_PRODUTO = B2_COD AND TB1.C6_LOCAL = B2_LOCAL AND SB2.D_E_L_E_T_ = '' "	
	cQuery += "			GROUP BY TB1.C6_FILIAL,TB1.C6_PRODUTO,TB1.B1_DESC,TB1.C6_LOCAL, ESTRUTURA , L10,B2_QATU "	
	cQuery += "			)TAB "	
	cQuery += "			INNER JOIN "+RETSQLNAME("SG1")+" (NOLOCK) SG1 ON TAB.C6_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) "	
	cQuery += "			LEFT JOIN "+RETSQLNAME("SB2")+" (NOLOCK) SB21 ON G1_FILIAL = SB21.B2_FILIAL AND G1_COMP = SB21.B2_COD AND SB21.B2_LOCAL IN( '01','10') AND SB21.D_E_L_E_T_ = '' "	
	cQuery += "			INNER JOIN "+RETSQLNAME("SB1")+" (NOLOCK) SB11 ON G1_COMP = SB11.B1_COD AND SB11.D_E_L_E_T_ = '' "	
	cQuery += "			)TAB2 "	
	cQuery += "			WHERE G1_COMP NOT LIKE 'MOD%' "	
	cQuery += "			GROUP BY C6_PRODUTO,B1_DESC,QTD_PED,QTD_OP,L20,SALDO,G1_COMP,G1_DESC,L10,SALDO,G1_QUANT "	
	cQuery += "			HAVING SALDO > 0 "	
	cQuery += "			)TB3 "	
	cQuery += "			INNER JOIN "+RETSQLNAME("SB2")+" SB2 (NOLOCK) ON B2_COD = G1_COMP AND B2_FILIAL = '01' AND B2_LOCAL = '10' AND SB2.D_E_L_E_T_ ='' "	
	cQuery += "			GROUP BY C6_PRODUTO,B1_DESC,SALDO,G1_COMP,L10,G1_COMP,G1_DESC "	
	cQuery += "			)TB4 "	
	cQuery += "			GROUP BY C6_PRODUTO,B1_DESC,G1_COMP,G1_DESC,FALTA "	
	cQuery += "			HAVING FALTA != 0 "	
	cQuery += "			ORDER BY C6_PRODUTO "	

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

		cCodproduto 	:= cAlias->C6_PRODUTO


		IncProc("Imprimindo PRODUTO"+alltrim(cAlias->C6_PRODUTO))

		//TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,A1_COD,A1_NOME,A3_NOME

		//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,		
		//imprimo a primeira seção				
		oSection1:Cell("C6_PRODUTO"):SetValue(cAlias->C6_PRODUTO) 
		oSection1:Cell("B1_DESC"):SetValue(cAlias->B1_DESC) 					
		oSection1:Cell("SALDO"):SetValue(cAlias->SALDO)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->C6_PRODUTO == cCodproduto
			oReport:IncMeter()		                                



			IncProc("Imprimindo Componente"+alltrim(cAlias->G1_COMP))

			oSection2:Cell("G1_COMP"):SetValue(cAlias->G1_COMP)			
			oSection2:Cell("G1_DESC"):SetValue(cAlias->G1_DESC)
			oSection2:Cell("ESTRUTURA"):SetValue(cAlias->ESTRUTURA)
			oSection2:Cell("L10"):SetValue(cAlias->L10)
			oSection2:Cell("POSSIVEL"):SetValue(cAlias->POSSIVEL)
			oSection2:Cell("ABERTURA"):SetValue(cAlias->ABERTURA)
			oSection2:Cell("FALTA"):SetValue(cAlias->FALTA)

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

	u_InPutSX1(cPerg,"01",PADR("Emissao De? ",30)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Emissão Ate? ",30)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return