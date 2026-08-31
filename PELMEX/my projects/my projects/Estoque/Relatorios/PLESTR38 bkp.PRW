#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR38    ºAutor  ³Kledson Oliveira Andrade   		º Data ³  17/12/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  CEIPIM FATURAMENTO FORA ESTADO TRIBUTADO 						  					 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR38()
	Local oReport := nil
	Local cPerg:= Padr("PLESTR38",10)

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


	oReport := TReport():New(cNOME,"CEIPIM FATURAMENTO FORA ESTADO TRIBUTADO",cNOME,{|oReport| ReportPrint(oReport)},"CEIPIM FATURAMENTO FORA ESTADO TRIBUTADO")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção



	oSection1:= TRSection():New(oReport, "Tributacao",{"cAlias"} , , .F., .T.)

	TRCell():New(oSection1,"Tributacao"		,"cAlias","Tributação",,20)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas


	oSection2:= TRSection():New(oReport, "Resumo", {"cAlias"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"TIPO"	   ,"cAlias","Tipo",,8)	
	TRCell():New(oSection2,"Resumo"	   	   ,"cAlias","Resumo",,30)
	//TRCell():New(oSection2,"CFOP"				,"cAlias","CFOP",/*Mascara*/,5)
	TRCell():New(oSection2,"Quantidade"	   	,"cAlias","Quantidade","@E 9,999,999,999.99",9)     
	TRCell():New(oSection2,"Total"				,"cAlias","Total","@E 9,999,999,999.99",9)   
	//TRCell():New(oSection2,"ICMS"	   			,"cAlias","ICMS","@E 9,999,999,999.99",)       

	oBreak := TRBreak():New(oSection2,oSection1:Cell("Tributacao"),"Total Quantidade/Total Geral") 
	TRFunction():New(oSection2:Cell("Quantidade"),"Total Quantidade","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("Total"),"Total Geral","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("ICMS"),"Total ICMS","SUM",oBreak,,,,.F.,.F.)

	//Fim Quebra por Seção

	//Totalizador final
	//TRFunction():New(oSection1:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

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


cQuery := " SELECT GRUPO Resumo,SUM(D2_QUANT)Quantidade,SUM(D2_TOTAL)Total,A1_TPRIBU Tributacao "
cQuery += " FROM( "
cQuery += " SELECT A1_TPRIBU, "
cQuery += " D2_CF, "
cQuery += " CASE WHEN (BM_DESC LIKE 'CAMA%') THEN 'CAMA'"
cQuery += " 	        WHEN (BM_DESC LIKE 'COLCHAO%ESPUMA%') AND (BM_DESC NOT LIKE '%VACUO%') THEN 'COLCHAO ESPUMA' "
cQuery += " 			WHEN (BM_DESC LIKE 'COLCHAO%ESPUMA%') AND (BM_DESC LIKE '%VACUO%') THEN 'COLCHAO ESPUMA ENROLADO' "
cQuery += " 			WHEN (BM_DESC LIKE 'COLCHAO%MOLA%') AND (BM_DESC NOT LIKE '%VACUO%') THEN 'COLCHAO MOLA' "
cQuery += " 			WHEN (BM_DESC LIKE 'COLCHAO%MOLA%') AND (BM_DESC LIKE '%VACUO%') THEN 'COLCHAO MOLA ENROLADO' "
cQuery += " 		ELSE BM_DESC END GRUPO, "
cQuery += " 	   D2_QUANT,D2_TOTAL "
cQuery += " FROM( "
cQuery += " SELECT D2_FILIAL,D2_DOC,D2_SERIE, "
cQuery += "        CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103)D2_EMISSAO, "
cQuery += "        CASE WHEN D1_DOC IS NULL THEN '' ELSE CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103) END D1_EMISSAO, "
cQuery += " 	   D2_ITEM,D2_COD,D2_QUANT,D2_TOTAL,D2_LOCAL,D2_CF, "
cQuery += " 	   B1_GRUPO,BM_DESC,F4_TEXTO,D2_CLIENTE,D2_LOJA,A1_EST, "
cQuery += " 	   CASE WHEN A1_TPTRIBU = '1' THEN 'Lucro Real' "
cQuery += "             WHEN A1_TPTRIBU = '2' THEN 'Lucro Presumido' "
cQuery += " 			WHEN A1_TPTRIBU = '3' THEN 'Optante Simples' "
cQuery += " 	   ELSE 'Não Informado' END A1_TPRIBU "
cQuery += " FROM %Table:SD2% SD2 "
cQuery += " INNER JOIN %Table:SF4% SF4 ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN %Table:SB1% SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN %Table:SBM% SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN %Table:SA1% SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN %Table:SD1% SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' "
cQuery += " WHERE SD2.D_E_L_E_T_ = '' AND D2_FILIAL = '01' AND SUBSTRING(D2_CF,1,1) > '5' AND F4_TEXTO LIKE 'VENDA%' AND F4_TEXTO NOT LIKE '%ROMANEIO%' "
cQuery += " 	AND D2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'  "
cQuery += " )TB "
cQuery += " )TB1 "
cQuery += " GROUP BY GRUPO,A1_TPRIBU "
cQuery += " ORDER BY A1_TPRIBU,GRUPO "




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
			cTributacao 	:= cAlias->Tributacao
			IncProc("Imprimindo Resumo"+alltrim(cAlias->Tributacao))
		//imprimo a primeira seção				
			oSection1:Cell("Tributacao"):SetValue(cAlias->Tributacao)   
		oSection1:Printline()

		//inicializo a segunda seção

		oSection2:init()
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->Tributacao == cTributacao
			oReport:IncMeter()		                                
			IncProc("Imprimindo Valores"+alltrim(cAlias->Resumo))
			oSection2:Cell("Resumo"):SetValue(cAlias->Resumo)
			oSection2:Cell("Quantidade"):SetValue(cAlias->Quantidade)
			oSection2:Cell("Total"):SetValue(cAlias->Total)			
			//oSection2:Cell("BASE"):SetValue(cAlias->BASE)
			//oSection2:Cell("ICMS"):SetValue(cAlias->ICMS)
			
			//oSection2:Cell("F4_TEXTO"):SetValue(cAlias->F4_TEXTO)	
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


	u_InPutSX1(cPerg,"01",PADR("Dt. Emissao de    ? ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Dt. Emissao ate  ? ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")

Return
