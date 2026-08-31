#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR40    บAutor  ณKledson Oliveira    				บ Data ณ  13/05/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ CEIPIM FATURAMENTO E TRANSFERENCIA				  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR40()
	Local oReport := nil
	Local cPerg:= Padr("PLESTR40",10)

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


	oReport := TReport():New(cNOME,"CEIPIM FATURAMENTO E TRANSFERENCIA",cNOME,{|oReport| ReportPrint(oReport)},"CEIPIM FATURAMENTO E TRANSFERENCIA")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Natureza",{"cAlias"} , , .F., .T.)

	TRCell():New(oSection1,"Natureza"		,"cAlias","Natureza",,20)
	TRCell():New(oSection1,"UF"				,"cAlias","UF",,15)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas


	oSection2:= TRSection():New(oReport, "Resumo", {"cAlias"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"TIPO"	   ,"cAlias","Tipo",,8)	
	TRCell():New(oSection2,"Resumo"	   	   ,"cAlias","Resumo",,30)
	//TRCell():New(oSection2,"CFOP"				,"cAlias","CFOP",/*Mascara*/,5)
	TRCell():New(oSection2,"Quantidade"	   	,"cAlias","Quantidade","@E 9,999,999,999.99",15)     
	TRCell():New(oSection2,"Total"				,"cAlias","Total","@E 9,999,999,999.99",15)   
	//TRCell():New(oSection2,"ICMS"	   			,"cAlias","ICMS","@E 9,999,999,999.99",)       

	oBreak := TRBreak():New(oSection2,oSection1:Cell("Natureza"),"Total Quantidade/Total Geral") 
	TRFunction():New(oSection2:Cell("Quantidade"),"Total Quantidade","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("Total"),"Total Geral","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("ICMS"),"Total ICMS","SUM",oBreak,,,,.F.,.F.)

	//Fim Quebra por Se็ใo

	//Totalizador final
	//TRFunction():New(oSection1:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

	//TRFunction():New(oSection2:Cell("SAI_DOC")	,"Total de Notas","COUNT",,,"@E 9,999,999,999",,.F.,.T.)


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
	Local cMascara  := "@E 9,999,999,999,999,999,999"
	Local lPrim 	:= .T.


cQuery := " SELECT F4_TEXTO Natureza,A1_EST UF,GRUPO Resumo,SUM(D2_QUANT)Quantidade,SUM(D2_TOTAL)Total "
cQuery += " FROM( "
cQuery += " SELECT A1_TPRIBU, "
cQuery += "        CASE WHEN SUBSTRING(D2_CF,1,1) = '5' THEN 'DENTRO' ELSE 'FORA' END A1_EST,D2_CF, "
cQuery += " 	   CASE WHEN F4_TEXTO LIKE 'VENDA%' THEN 'VENDA' ELSE 'TRANSFERENCIA' END F4_TEXTO,B1_GRUPO, "
cQuery += "        CASE WHEN (BM_DESC LIKE 'CAMA%') THEN 'CAMA' "
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
cQuery += " 	   ELSE '' END A1_TPRIBU "
cQuery += " FROM  "+RETSQLNAME("SD2")+" SD2 "
cQuery += " INNER JOIN  "+RETSQLNAME("SF4")+" SF4 ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN  "+RETSQLNAME("SB1")+" SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN  "+RETSQLNAME("SBM")+" SBM (NOLOCK) ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN  "+RETSQLNAME("SA1")+" SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN  "+RETSQLNAME("SD1")+" SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' "
cQuery += " WHERE SD2.D_E_L_E_T_ = '' "
cQuery += " AND D2_FILIAL = '01' "
cQuery += " AND B1_TIPO IN ('PA','PC') "//Incluir essa parte nos outros do faturamento
cQuery += " AND (F4_TEXTO LIKE 'VENDA%' "
cQuery += " OR F4_TEXTO LIKE 'TRANSF%') "
cQuery += " AND F4_TEXTO NOT LIKE '%ROMANEIO%' "
cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " )TB "        
cQuery += " )TB1 "
cQuery += " GROUP BY F4_TEXTO,A1_EST,GRUPO "
cQuery += " ORDER BY F4_TEXTO DESC,UF,GRUPO "




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
			cNatureza 	:= cAlias->Natureza
			cUF := cAlias->UF
			IncProc("Imprimindo Resumo"+alltrim(cAlias->Natureza))
			IncProc("Imprimindo Resumo"+alltrim(cAlias->Natureza))
		//imprimo a primeira se็ใo				
			oSection1:Cell("Natureza"):SetValue(cAlias->Natureza)
			oSection1:Cell("UF"):SetValue(cAlias->UF)
		oSection1:Printline()

		//inicializo a segunda se็ใo

		oSection2:init()
		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->Natureza == cNatureza .and. cAlias->UF = cUF
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


	u_InPutSX1(cPerg,"01",PADR("Dt. Emissao de    ? ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Dt. Emissao ate  ? ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")

Return
