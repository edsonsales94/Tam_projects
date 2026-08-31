#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR64    ºAutor  ³STAN LEE LOPES    				º Data ³  03/06/25 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Acompanhamento da Previa PELMEX				        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLPROR64()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR64",10)

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

	oReport := TReport():New(cNOME,"Acompanhamento da Previa",cNOME,{|oReport| ReportPrint(oReport)}," producao")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira seção
	


	oSection1:= TRSection():New(oReport, "Setor", {"cAlias"}, , .F., .T.)
	
	TRCell():New(oSection1,"DTAMAZON"		,"cAlias","Data PELMEX",,20)
	TRCell():New(oSection1,"DT"	    		,"cAlias","Data Previa",,20)
	TRCell():New(oSection1,"SETOR"		   ,"cAlias","Setor","@!",50)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produto", {"cAlias"}, NIL, .F., .T.)

	TRCell():New(oSection2,"CODIGO"		    ,"cAlias","Codigo",,20)
	TRCell():New(oSection2,"DESCRICAO"		,"cAlias","Descrição",/*Mascara*/,50)
	TRCell():New(oSection2,"QTD_PLANEJADA"	,"cAlias","Qtd.Planejada","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"QTD_PRODUZIDA"	,"cAlias","Qtd.Produzida","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"STATUS"			,"cAlias","Status",,20)
	//Quebra por Seção
	oBreak := TRBreak():New(oSection2,oSection1:Cell("Setor"),"Codigo")
	TRFunction():New(oSection2:Cell("QTD_PLANEJADA"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"Total","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Seção

	//Totalizador final
	//TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//Totalizador

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
	Local lPrim 	:= .T.
	
	
    cQuery := " SELECT DT_PREVIA DT,'' DTAMAZON,SETOR,PRODUTO CODIGO,DESCRICAO,SUM(QTD_PEDIDO)QTD_PLANEJADA,0 QTD_PRODUZIDA,'' STATUS "
    cQuery += "FROM( "
    cQuery += "SELECT DT_PRODUCAO,DT_PREVIA,DT_PEDIDO,DT_NOTA,NOTA,DT_SAIDA,DT_DEV,PEDIDO,CARGA,OP,ITEM,PRODUTO,DESCRICAO,ARMAZEM, "
    cQuery += "    QTD_PEDIDO*(B1_XCOMPRI*B1_XLARGUR*B1_XALTURA) TOTAL_M3,QTD_PEDIDO,PED_TOTAL TOTAL,QTD_APONTADA, "
    cQuery += "    QTD_PRODUZIDA,QTD_ENTRADA,QTD_BIPADA,DIFERENCA,PENDENTE_BIPE,QTD_VALIDADA,QTD_PEDIDO-QTD_VALIDADA DIFERENCA_VALIDADA,CLIENTE,CIDADE,OBSERVACAO,SETOR "
    cQuery += "FROM( "
    cQuery += "SELECT PED_DTPROPEL DT_PRODUCAO,PED_DTPREVIA DT_PREVIA,ISNULL(D1_DOC,'') NF_DEV,ISNULL(CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103),'') DT_DEV, "
    cQuery += "    CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_PEDIDO, "
    cQuery += "    ISNULL(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),'')DT_NOTA,ISNULL(D2_DOC,'') NOTA, "
    cQuery += "    ISNULL(CNF_EXPEDICAO,'') DT_SAIDA,PED_NUM PEDIDO,ISNULL(C2_XCARGA,'') CARGA,PED_OP OP,PED_ITEM ITEM, "
    cQuery += "    PED_PRODUTO PRODUTO,PED_DESCRI DESCRICAO,PED_LOCAL ARMAZEM,SB1.B1_XSETOR SETOR, "
    cQuery += "    CAST(PED_QUANT AS FLOAT)QTD_PEDIDO,CAST(PED_TOTAL AS FLOAT)PED_TOTAL, "
    cQuery += "    C2_QUJE QTD_APONTADA, "
    cQuery += "    CAST(CASE WHEN (PED_SETOR LIKE 'CAMA%') THEN ISNULL(QTD_CAMA,0) "
    cQuery += "                WHEN (PED_SETOR LIKE 'COLC%') THEN ISNULL(QTD_COLCHAO,0) "
    cQuery += "            ELSE ISNULL(QTD_ENTRADA,0) END AS FLOAT) QTD_PRODUZIDA, "
    cQuery += "    CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)QTD_ENTRADA, "
    cQuery += "    CAST(CASE WHEN (PED_SETOR LIKE 'CAMA%') AND (ISNULL(QTD_CAMA,0) > ISNULL(QTD_ENTRADA,0)) THEN ISNULL(QTD_CAMA,0) "
    cQuery += "            WHEN (PED_SETOR LIKE 'COLC%') AND (ISNULL(QTD_COLCHAO,0) > ISNULL(QTD_ENTRADA,0)) THEN ISNULL(QTD_COLCHAO,0) "
    cQuery += "    ELSE ISNULL(QTD_ENTRADA,0) END AS FLOAT) QTD_VALIDADA, "
    cQuery += "    CAST(ISNULL(QTD_SAIDA,0) AS FLOAT)QTD_BIPADA, "
    cQuery += "    CAST(PED_QUANT AS FLOAT)-CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)DIFERENCA, "
    cQuery += "    CAST(PED_QUANT AS FLOAT)-CAST(ISNULL(QTD_SAIDA,0) AS FLOAT)PENDENTE_BIPE, "
    cQuery += "    PED_NOME CLIENTE,PED_MUN CIDADE, "
    cQuery += "    RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT)OBSERVACAO "
    cQuery += "FROM PED (NOLOCK) "
    cQuery += "INNER JOIN SB1100 SB1 (NOLOCK) ON PED_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
    cQuery += "INNER JOIN SC5100 SC5 (NOLOCK) ON PED_FILIAL = C5_FILIAL AND PED_NUM = C5_NUM AND SC5.D_E_L_E_T_ = '' "
    cQuery += "LEFT JOIN SD2100 SD2 (NOLOCK) ON PED_FILIAL = D2_FILIAL AND PED_NUM = D2_PEDIDO AND PED_ITEM = D2_ITEMPV AND PED_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = '' "
    cQuery += "LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' "
    cQuery += "LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA  "
    cQuery += "LEFT JOIN SEN (NOLOCK) ON D2_FILIAL = SEN_FILIAL AND D2_DOC = SEN_DOC AND D2_SERIE = SEN_SERIE AND D2_CLIENTE = SEN_CLIENTE AND D2_LOJA = SEN_LOJA "
    cQuery += "LEFT JOIN (SELECT C2_XCARGA,C2_EMISSAO,C2_NUM,C2_PRODUTO,SUM(C2_QUANT)C2_QUANT,SUM(C2_QUJE)C2_QUJE "
    cQuery += "            FROM( "
    cQuery += "            SELECT C2_XCARGA,C2_EMISSAO,C2_NUM,C2_PRODUTO,SUM(C2_QUANT)C2_QUANT,SUM(C2_QUJE)C2_QUJE "
    cQuery += "            FROM( "
    cQuery += "            SELECT * "
    cQuery += "            FROM SC2100 SC2 (NOLOCK)  "
    cQuery += "            WHERE SC2.D_E_L_E_T_ = '' "
    cQuery += "            )TB "
    cQuery += "            GROUP BY C2_XCARGA,C2_EMISSAO,C2_DATRF,C2_NUM,C2_PRODUTO "
    cQuery += "            )TB1 "
    cQuery += "            GROUP BY C2_XCARGA,C2_EMISSAO,C2_NUM,C2_PRODUTO)SC2 ON PED_OP = SC2.C2_NUM AND PED_PRODUTO = SC2.C2_PRODUTO "
    cQuery += "LEFT JOIN (SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,Z1_PRODUTO,SUM(Z1_QUANT)QTD_ENTRADA "
    cQuery += "        FROM( "
    cQuery += "        SELECT Z1_OP+Z1_CHASSIS Z1_OP,C2_PRODUTO Z1_PRODUTO,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT "
    cQuery += "        FROM SZ1100 SZ1 (NOLOCK) "
    cQuery += "        INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = '' "
    cQuery += "        INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
    cQuery += "        WHERE SZ1.D_E_L_E_T_ = '' "
    cQuery += "        GROUP BY Z1_OP+Z1_CHASSIS,C2_PRODUTO,B1_XJUNCAO "
    cQuery += "        )TB "
    cQuery += "        GROUP BY SUBSTRING(Z1_OP,1,6),Z1_PRODUTO)SZ1 ON PED_OP = Z1_OP AND PED_PRODUTO = Z1_PRODUTO "
    cQuery += "LEFT JOIN (SELECT SUBSTRING(SAI_CPRODUC,1,6)SAI_OP,SAI_PRODUTO,SUM(SAI_QUANT)QTD_SAIDA "
    cQuery += "         FROM( "
    cQuery += "                SELECT SAI_FILIAL,SAI_PEDIDO,SAI_DOC,SAI_SERIE,SAI_ITEM, "
    cQuery += "                    SAI_PRODUTO,SAI_QUANT,SAI_CPRODUC "
    cQuery += "                FROM SAI "
    cQuery += "                GROUP BY SAI_FILIAL,SAI_PEDIDO,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO,SAI_QUANT,SAI_CPRODUC "
    cQuery += "            )TB "
    cQuery += "            GROUP BY SUBSTRING(SAI_CPRODUC,1,6),SAI_PRODUTO)SAI ON PED_OP = SAI_OP AND PED_PRODUTO = SAI_PRODUTO "
    cQuery += "LEFT JOIN (SELECT SUBSTRING(CLA_CPRODUC,1,6)CLA_OP,CLA_COD,SUM(CLA_QUANT)QTD_COLCHAO "
    cQuery += "        FROM( "
    cQuery += "                SELECT CLA_FILIAL,CLA_COD,CLA_QUANT,CLA_CPRODUC "
    cQuery += "                FROM CLA "
    cQuery += "                GROUP BY CLA_FILIAL,CLA_COD,CLA_QUANT,CLA_CPRODUC "
    cQuery += "            )TB "
    cQuery += "            GROUP BY SUBSTRING(CLA_CPRODUC,1,6),CLA_COD)CLA ON PED_OP = CLA_OP AND PED_PRODUTO = CLA_COD "
    cQuery += "LEFT JOIN (SELECT SUBSTRING(CLB_CPRODUC,1,6)CLB_OP,CLB_COD,SUM(CLB_QUANT)QTD_CAMA "
    cQuery += "        FROM( "
    cQuery += "                SELECT CLB_FILIAL,CLB_COD,CLB_CPRODUC, "
    cQuery += "                    CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END CLB_QUANT "
    cQuery += "                FROM CLB "
    cQuery += "                INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
    cQuery += "                GROUP BY CLB_FILIAL,CLB_COD,CLB_QUANT,CLB_CPRODUC,B1_XJUNCAO "
    cQuery += "            )TB "
    cQuery += "            GROUP BY SUBSTRING(CLB_CPRODUC,1,6),CLB_COD)CLB ON PED_OP = CLB_OP AND PED_PRODUTO = CLA_COD "
    cQuery += "WHERE PED_STATUS != 'C' "
    cQuery += "AND D1_DOC IS NULL "
    cQuery += "AND PED_LOCAL IN ('15','20','50','80') "
    cQuery += "AND CONVERT(VARCHAR,CAST (PED_DTPREVIA AS DATE),112) = '"+DTOS(mv_par01)+"' "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%' " 
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NÃO PRODUZIR%' ""
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%' " 
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%'  "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%'  "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%'  "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%'  "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%' "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%' "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '% STAN%' "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TESTE%'  "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%MARKET%PLACE' "
    cQuery += "AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%MKT'  "
    cQuery += ")TB2 "
    cQuery += "INNER JOIN SB1100 SB1 (NOLOCK) ON PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
    cQuery += "GROUP BY DT_PRODUCAO,DT_PREVIA,DT_PEDIDO,DT_NOTA,NOTA,DT_SAIDA,PEDIDO,CARGA,OP,ITEM,PRODUTO,DESCRICAO,ARMAZEM,SETOR, "
    cQuery += "        QTD_PEDIDO,B1_XCOMPRI,B1_XLARGUR,B1_XALTURA,QTD_PEDIDO,PED_TOTAL,QTD_APONTADA,NF_DEV,DT_DEV, "
    cQuery += "        QTD_PRODUZIDA,QTD_ENTRADA,QTD_VALIDADA,QTD_BIPADA,DIFERENCA,PENDENTE_BIPE,CLIENTE,CIDADE,OBSERVACAO "
    cQuery += ")TB3 "
    cQuery += "GROUP BY DT_PREVIA,SETOR,PRODUTO,DESCRICAO "
    cQuery += "ORDER BY SETOR,DESCRICAO "

	
	
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



		cSetor 	:= cAlias->SETOR

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira seção

		oSection1:Cell("Setor"):SetValue(cAlias->SETOR)
		oSection1:Cell("DT"):SetValue(cAlias->DT)
		oSection1:Cell("DTAMAZON"):SetValue(cAlias->DTAMAZON)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor é mesmo, se sim, imprimo Estrutura
		While cAlias->SETOR == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))
			oSection2:Cell("CODIGO"):SetValue(cAlias->CODIGO)
			oSection2:Cell("DESCRICAO"):SetValue(cAlias->DESCRICAO)
			oSection2:Cell("QTD_PLANEJADA"):SetValue(cAlias->QTD_PLANEJADA)
			oSection2:Cell("QTD_PRODUZIDA"):SetValue(cAlias->QTD_PRODUZIDA)
			oSection2:Cell("STATUS"):SetValue(cAlias->STATUS)
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
    u_InPutSX1(cPerg,"01",PADR("Dt.Previa ?    ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 

Return
