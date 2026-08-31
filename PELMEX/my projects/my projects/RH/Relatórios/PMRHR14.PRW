#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMRHR14  ºAutor  ³Kledson Oliveira    				º Data ³  14/05/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   SUFRAMA DP                    			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PMRHR14()
	Local oReport := nil
	Local cPerg:= Padr("PMRHR14",10)

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


	oReport := TReport():New(cNOME,"SUFRAMA DP",cNOME,{|oReport| ReportPrint(oReport)},"SUFRAMA DP")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção



	oSection1:= TRSection():New(oReport, "Descricao",{"cAlias"} , , .F., .T.)

	TRCell():New(oSection1,"Descricao"		,"cAlias","Descricao",,20)
	TRCell():New(oSection1,"EMPRESA"				,"cAlias","Empresa",,15)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas


	oSection2:= TRSection():New(oReport, "Total", {"cAlias"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"TIPO"	   ,"cAlias","Tipo",,8)	
	TRCell():New(oSection2,"Total"				,"cAlias","Total","@E 9,999,999,999.99",)   
	TRCell():New(oSection2,"Salario_Valor"	   	   ,"cAlias","Salario ou valor","@E 9,999,999,999.99",15)
	//TRCell():New(oSection2,"CFOP"				,"cAlias","CFOP",/*Mascara*/,5)
	TRCell():New(oSection2,"Faixa_Descri"	   	,"cAlias","Faixa ou Desc. Verba",,20)     
	//TRCell():New(oSection2,"ICMS"	   			,"cAlias","ICMS","@E 9,999,999,999.99",)       

	//oBreak := TRBreak():New(oSection2,oSection1:Cell("Natureza"),"Total Quantidade/Total Geral") 
	//TRFunction():New(oSection2:Cell("Quantidade"),"Total Quantidade","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("Total"),"Total Geral","SUM",oBreak,,,,.F.,.F.)
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

cQuery := "    SELECT Descricao, EMPRESA, Total, Salario [Salario_Valor], Faixa [Faixa_Descri] "
cQuery += "    FROM ( "
cQuery += "    SELECT Descricao, EMPRESA, Total, Salario, '' Faixa  "
cQuery += "    FROM( "
cQuery += "    SELECT 'Total de Funcionários' Descricao,'2 - AMAZON' EMPRESA, COUNT(RA_MAT)[Total], round(sum(RA_SALARIO),2)[Salario], RA_FILIAL Filial "
cQuery += "    FROM SRA200 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "         AND RA_SITFOLH != 'D' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                   AND RA_FILIAL = '01' "
cQuery += "    GROUP BY RA_FILIAL "
cQuery += "    UNION  "
cQuery += "    SELECT 'Total de Funcionários' Descricao,'1 - PELMEX' EMPRESA, COUNT(RA_MAT)[Total], round(sum(RA_SALARIO),2)[Salario], COUNT(RA_FILIAL) Filial "
cQuery += "    FROM SRA100 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "         AND RA_SITFOLH != 'D' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "    )FUNC "
cQuery += "    UNION  "
cQuery += "    SELECT Descricao, EMPRESA, QTD, SALARIO, CATEG "
cQuery += "    FROM ( "
cQuery += "    SELECT 'Faixa Salarial' Descricao,'2 - AMAZON' EMPRESA, COUNT(RA_MAT)QTD, CATEG, SUM(RA_SALARIO) SALARIO  "
cQuery += "    FROM ( "
cQuery += "    SELECT RA_MAT, RA_NOME, RA_SALARIO,  "
cQuery += "         CASE WHEN RA_SALARIO BETWEEN 499 AND 1497.00 THEN 'Até 1,5'  "
cQuery += "              WHEN RA_SALARIO BETWEEN 1497.01 AND 1966.00 THEN 'De 1,5 a 2'  "
cQuery += "              WHEN RA_SALARIO BETWEEN 1996.01 AND 3992.00 THEN 'De 2 a 4' "
cQuery += "              WHEN RA_SALARIO BETWEEN 3992.01 AND 5988.00 THEN 'De 4 a 6' "
cQuery += "              WHEN RA_SALARIO BETWEEN 5988.01 AND 9980.00 THEN 'De 6 a 10' "
cQuery += "              WHEN RA_SALARIO BETWEEN 9980.01 AND 14970.00 THEN 'De 10 a 15' "
cQuery += "              WHEN RA_SALARIO > 14970.01 THEN 'Acima de 15' END CATEG, "
cQuery += "              RA_CC        "
cQuery += "    FROM SRA200 SRA "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "    AND RA_SALARIO > 498.99 "
cQuery += "    AND RA_FILIAL = '01' "
cQuery += "    AND RA_SITFOLH NOT IN ('D') "
cQuery += "    AND RA_CC NOT IN ('20000','1000') "
cQuery += "    )TB  "
cQuery += "    GROUP BY CATEG  "
cQuery += "    UNION  "
cQuery += "    SELECT 'Faixa Salarial' Descricao, '1 - PELMEX' EMPRESA, COUNT(RA_MAT)QTD, CATEG, SUM(RA_SALARIO) SALARIO  "
cQuery += "    FROM ( "
cQuery += "    SELECT RA_MAT, RA_NOME, RA_SALARIO,  "
cQuery += "         CASE WHEN RA_SALARIO BETWEEN 499 AND 1497.00 THEN 'Até 1,5'  "
cQuery += "              WHEN RA_SALARIO BETWEEN 1497.01 AND 1966.00 THEN 'De 1,5 a 2'  "
cQuery += "              WHEN RA_SALARIO BETWEEN 1996.01 AND 3992.00 THEN 'De 2 a 4' "
cQuery += "              WHEN RA_SALARIO BETWEEN 3992.01 AND 5988.00 THEN 'De 4 a 6' "
cQuery += "              WHEN RA_SALARIO BETWEEN 5988.01 AND 9980.00 THEN 'De 6 a 10' "
cQuery += "              WHEN RA_SALARIO BETWEEN 9980.01 AND 14970.00 THEN 'De 10 a 15' "
cQuery += "              WHEN RA_SALARIO > 14970.01 THEN 'Acima de 15' END CATEG, "
cQuery += "              RA_CC        "
cQuery += "    FROM SRA100 SRA "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "    AND RA_SALARIO > 498.99 "
cQuery += "    AND RA_SITFOLH NOT IN ('D') "
cQuery += "    AND RA_CC NOT IN ('20000','1000') "
cQuery += "    )TB  "
cQuery += "    GROUP BY CATEG  "
cQuery += "    )FAIXA "
cQuery += "    UNION  "
cQuery += "    SELECT 'Funcionarios no 1º dia' Descricao, EMPRESA, cast(COUNT(MATRICULA) as int)TOTAL_POR_FILIAL , SUM(RA_SALARIO)Salario, '' Nada "
cQuery += "    FROM(   "
cQuery += "        SELECT EMPRESA, COD, NOME, MATRICULA, RA_DEMISSA, RA_SALARIO "
cQuery += "        FROM( "
cQuery += "            SELECT '1 - PELMEX' EMPRESA, RJ_FILIAL COD, M0_FILIAL FILIAL, RA_NOME NOME, RA_MAT MATRICULA, RA_CC COD_CC,  "
cQuery += "                   CTT_DESC01 CENTRO_CUSTO, RA_CODFUNC COD_FUNCAO, RJ_DESC FUNCAO, RA_SALARIO,  "
cQuery += "                   RA_DEMISSA  "
cQuery += "                   FROM SRA100 SRA "
cQuery += "                   INNER JOIN SRJ100 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL "
cQuery += "                   INNER JOIN CTT100 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
cQuery += "                   INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '10' "
cQuery += "                   WHERE SRA.D_E_L_E_T_ = ''  "
cQuery += "                   AND RA_MAT BETWEEN '' AND 'ZZZZ' "
cQuery += "                AND RA_DEMISSA >= '"+mv_par01+"'  + '01' "
cQuery += "                AND RA_ADMISSA <= '"+mv_par01+"'  + '01' "
cQuery += "            UNION  "
cQuery += "            SELECT '2 - AMAZON' EMPRESA, RJ_FILIAL COD, M0_FILIAL FILIAL, RA_NOME NOME, RA_MAT MATRICULA, RA_CC COD_CC,  "
cQuery += "                   CTT_DESC01 CENTRO_CUSTO, RA_CODFUNC COD_FUNCAO, RJ_DESC FUNCAO, RA_SALARIO, "
cQuery += "                   RA_DEMISSA "
cQuery += "                   FROM SRA200 SRA2 "
cQuery += "                   INNER JOIN SRJ200 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL "
cQuery += "                   INNER JOIN CTT200 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
cQuery += "                   INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '20' "
cQuery += "                   WHERE SRA2.D_E_L_E_T_ = ''  "
cQuery += "                   AND RA_MAT BETWEEN '' AND 'ZZZZ' "
cQuery += "                   AND RA_CC NOT IN ('20000','1000') "
cQuery += "                AND RA_DEMISSA >= '"+mv_par01+"'  + '01' "
cQuery += "                AND RA_ADMISSA <= '"+mv_par01+"'  + '01' "
cQuery += "                   AND RA_FILIAL = '01'                 "
cQuery += "            )TB1  "
cQuery += "        UNION  "
cQuery += "        SELECT EMPRESA, COD, NOME, MATRICULA, RA_DEMISSA, RA_SALARIO "
cQuery += "        FROM( "
cQuery += "            SELECT '1 - PELMEX' EMPRESA, RJ_FILIAL COD, M0_FILIAL FILIAL, RA_NOME NOME, RA_MAT MATRICULA, RA_CC COD_CC,  "
cQuery += "                   CTT_DESC01 CENTRO_CUSTO, RA_CODFUNC COD_FUNCAO, RJ_DESC FUNCAO, RA_SALARIO,  "
cQuery += "                   RA_DEMISSA "
cQuery += "                   FROM SRA100 SRA "
cQuery += "                   INNER JOIN SRJ100 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL "
cQuery += "                   INNER JOIN CTT100 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
cQuery += "                   INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '10' "
cQuery += "                   WHERE SRA.D_E_L_E_T_ = ''  "
cQuery += "                   AND RA_MAT BETWEEN '' AND 'ZZZZ' "
cQuery += "                   AND RA_DEMISSA = '' "
cQuery += "                AND RA_ADMISSA <= '"+mv_par01+"'  + '01' "
cQuery += "            UNION  "
cQuery += "            SELECT '2 - AMAZON' EMPRESA, RJ_FILIAL COD, M0_FILIAL FILIAL, RA_NOME NOME, RA_MAT MATRICULA, RA_CC COD_CC,  "
cQuery += "                   CTT_DESC01 CENTRO_CUSTO, RA_CODFUNC COD_FUNCAO, RJ_DESC FUNCAO, RA_SALARIO, "
cQuery += "                   RA_DEMISSA "
cQuery += "                   FROM SRA200 SRA2 "
cQuery += "                   INNER JOIN SRJ200 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL "
cQuery += "                   INNER JOIN CTT200 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
cQuery += "                   INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '20' "
cQuery += "                   WHERE SRA2.D_E_L_E_T_ = ''  "
cQuery += "                   AND RA_MAT BETWEEN '' AND 'ZZZZ' "
cQuery += "                   AND RA_CC NOT IN ('20000','1000') "
cQuery += "                   AND RA_DEMISSA = '' "
cQuery += "                AND RA_ADMISSA <= '"+mv_par01+"'  + '01' "
cQuery += "                   AND RA_FILIAL = '01' "
cQuery += "            )TB2 "
cQuery += "    )FUNCPER "
cQuery += "    GROUP BY EMPRESA "
cQuery += "    UNION  "
cQuery += "    SELECT 'Funcionarios admitidos no mês' Descricao, EMPRESA, Total, Salario, ''Vazio2 "
cQuery += "    from ( "
cQuery += "    SELECT '2 - AMAZON' EMPRESA, COUNT(RA_MAT)[Total], SUM(RA_SALARIO) Salario "
cQuery += "    FROM SRA200 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                AND RA_ADMISSA BETWEEN ('"+mv_par01+"'  + '01') AND ('"+mv_par01+"'  + '30') "
cQuery += "                        AND RA_FILIAL = '01' "
cQuery += "    GROUP BY RA_FILIAL "
cQuery += "    UNION  "
cQuery += "    SELECT '1 - PELMEX' EMPRESA, COUNT(RA_MAT)[Total], SUM(RA_SALARIO) Salario "
cQuery += "    FROM SRA100 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                AND RA_ADMISSA BETWEEN ('"+mv_par01+"'  + '01') AND ('"+mv_par01+"'  + '30') "
cQuery += "    )ADMI "
cQuery += "    UNION  "
cQuery += "    SELECT 'Funcionarios demitidos no mês' Descricao, EMPRESA, Total, Salario, '' Vazio "
cQuery += "    from ( "
cQuery += "    SELECT '2 - AMAZON' EMPRESA, COUNT(RA_MAT)[Total], sum(RA_SALARIO)Salario "
cQuery += "    FROM SRA200 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "         AND RA_SITFOLH = 'D' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                AND RA_DEMISSA BETWEEN ('"+mv_par01+"' + '01') AND ('"+mv_par01+"'  + '30') "
cQuery += "                        AND RA_FILIAL = '01' "
cQuery += "    GROUP BY RA_FILIAL "
cQuery += "    UNION  "
cQuery += "    SELECT '1 - PELMEX' EMPRESA, COUNT(RA_MAT)[Total], sum(RA_SALARIO)Salario "
cQuery += "    FROM SRA100 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "         AND RA_SITFOLH = 'D' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                AND RA_DEMISSA BETWEEN ('"+mv_par01+"' + '01') AND ('"+mv_par01+"'  + '30') "
cQuery += "    )DEMI "
cQuery += "    UNION  "
cQuery += "    SELECT 'Funcionarios no ULTIMO dia' Descricao, EMPRESA, cast(COUNT(MATRICULA) as int)TOTAL_POR_FILIAL , SUM(RA_SALARIO)Salario, '' Nada "
cQuery += "    FROM(   "
cQuery += "        SELECT EMPRESA, COD, NOME, MATRICULA, RA_DEMISSA, RA_SALARIO "
cQuery += "        FROM( "
cQuery += "            SELECT '1 - PELMEX' EMPRESA, RJ_FILIAL COD, M0_FILIAL FILIAL, RA_NOME NOME, RA_MAT MATRICULA, RA_CC COD_CC,  "
cQuery += "                   CTT_DESC01 CENTRO_CUSTO, RA_CODFUNC COD_FUNCAO, RJ_DESC FUNCAO, RA_SALARIO,  "
cQuery += "                   RA_DEMISSA  "
cQuery += "                   FROM SRA100 SRA "
cQuery += "                   INNER JOIN SRJ100 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL "
cQuery += "                   INNER JOIN CTT100 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
cQuery += "                   INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '10' "
cQuery += "                   WHERE SRA.D_E_L_E_T_ = ''  "
cQuery += "                   AND RA_MAT BETWEEN '' AND 'ZZZZ' "
cQuery += "                AND RA_DEMISSA >= '"+mv_par01+"'  + '31' "
cQuery += "                AND RA_ADMISSA <= '"+mv_par01+"'  + '31' "
cQuery += "            UNION  "
cQuery += "            SELECT '2 - AMAZON' EMPRESA, RJ_FILIAL COD, M0_FILIAL FILIAL, RA_NOME NOME, RA_MAT MATRICULA, RA_CC COD_CC,  "
cQuery += "                   CTT_DESC01 CENTRO_CUSTO, RA_CODFUNC COD_FUNCAO, RJ_DESC FUNCAO, RA_SALARIO, "
cQuery += "                   RA_DEMISSA "
cQuery += "                   FROM SRA200 SRA2 "
cQuery += "                   INNER JOIN SRJ200 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL "
cQuery += "                   INNER JOIN CTT200 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
cQuery += "                   INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '20' "
cQuery += "                   WHERE SRA2.D_E_L_E_T_ = ''  "
cQuery += "                   AND RA_MAT BETWEEN '' AND 'ZZZZ' "
cQuery += "                   AND RA_CC NOT IN ('20000','1000') "
cQuery += "                AND RA_DEMISSA >= '"+mv_par01+"'  + '31' "
cQuery += "                AND RA_ADMISSA <= '"+mv_par01+"'  + '31' "
cQuery += "                   AND RA_FILIAL = '01'                 "
cQuery += "            )TB1  "
cQuery += "        UNION  "
cQuery += "        SELECT EMPRESA, COD, NOME, MATRICULA, RA_DEMISSA, RA_SALARIO "
cQuery += "        FROM( "
cQuery += "            SELECT '1 - PELMEX' EMPRESA, RJ_FILIAL COD, M0_FILIAL FILIAL, RA_NOME NOME, RA_MAT MATRICULA, RA_CC COD_CC,  "
cQuery += "                   CTT_DESC01 CENTRO_CUSTO, RA_CODFUNC COD_FUNCAO, RJ_DESC FUNCAO, RA_SALARIO,  "
cQuery += "                   RA_DEMISSA "
cQuery += "                   FROM SRA100 SRA "
cQuery += "                   INNER JOIN SRJ100 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL "
cQuery += "                   INNER JOIN CTT100 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
cQuery += "                   INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '10' "
cQuery += "                   WHERE SRA.D_E_L_E_T_ = ''  "
cQuery += "                   AND RA_MAT BETWEEN '' AND 'ZZZZ' "
cQuery += "                AND RA_ADMISSA <= '"+mv_par01+"'  + '31' "
cQuery += "                   AND RA_DEMISSA = '' "
cQuery += "                   AND RA_FILIAL = '01' "
cQuery += "            UNION  "
cQuery += "            SELECT '2 - AMAZON' EMPRESA, RJ_FILIAL COD, M0_FILIAL FILIAL, RA_NOME NOME, RA_MAT MATRICULA, RA_CC COD_CC,  "
cQuery += "                   CTT_DESC01 CENTRO_CUSTO, RA_CODFUNC COD_FUNCAO, RJ_DESC FUNCAO, RA_SALARIO, "
cQuery += "                   RA_DEMISSA "
cQuery += "                   FROM SRA200 SRA2 "
cQuery += "                   INNER JOIN SRJ200 SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = '' AND RJ_FILIAL = RA_FILIAL "
cQuery += "                   INNER JOIN CTT200 CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = '' "
cQuery += "                   INNER JOIN SYS_COMPANY SYS ON RA_FILIAL = M0_CODFIL AND SYS.D_E_L_E_T_ = '' AND M0_CODIGO = '20' "
cQuery += "                   WHERE SRA2.D_E_L_E_T_ = ''  "
cQuery += "                   AND RA_MAT BETWEEN '' AND 'ZZZZ' "
cQuery += "                   AND RA_CC NOT IN ('20000','1000') "
cQuery += "                AND RA_ADMISSA <= '"+mv_par01+"'  + '31' "
cQuery += "                   AND RA_DEMISSA = '' "
cQuery += "                   AND RA_FILIAL = '01' "
cQuery += "            )TB2 "
cQuery += "    )FUNCULT "
cQuery += "    GROUP BY EMPRESA "
cQuery += "    UNION  "
cQuery += "    SELECT 'Mão de Obra PNEs' Descricao, EMPRESA, Total, Salario , '' Vazio "
cQuery += "    FROM ( "
cQuery += "    SELECT '2 - AMAZON' EMPRESA,COUNT(RA_MAT)[Total], RA_FILIAL, SUM(RA_SALARIO) Salario  "
cQuery += "    FROM SRA200 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "         AND RA_SITFOLH != 'D' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                   AND RA_DEFIFIS = '1' "
cQuery += "                        AND RA_FILIAL = '01' "
cQuery += "    GROUP BY RA_FILIAL "
cQuery += "    UNION  "
cQuery += "    SELECT '1 - PELMEX' EMPRESA,COUNT(RA_MAT)[Total], COUNT(RA_FILIAL)Filial, SUM(RA_SALARIO) Salario  "
cQuery += "    FROM SRA100 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "         AND RA_SITFOLH != 'D' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                   AND RA_DEFIFIS = '1' "
cQuery += "    )PNE "
cQuery += "    UNION  "
cQuery += "    SELECT 'Mão de Obra FEMININA' Descricao, EMPRESA, Total, Salario, ''Vazio "
cQuery += "    FROM ( "
cQuery += "    SELECT '2 - AMAZON' EMPRESA, COUNT(RA_MAT)[Total], RA_FILIAL, SUM(RA_SALARIO) Salario, RA_SEXO "
cQuery += "    FROM SRA200 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "         AND RA_SITFOLH != 'D' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                   AND RA_SEXO = 'F' "
cQuery += "                        AND RA_FILIAL = '01'                 "
cQuery += "    GROUP BY RA_FILIAL, RA_SEXO "
cQuery += "    UNION "
cQuery += "    SELECT '1 - PELMEX' EMPRESA, COUNT(RA_MAT)[Total], count(RA_FILIAL) filial, SUM(RA_SALARIO) Salario, RA_SEXO "
cQuery += "    FROM SRA100 SRA  "
cQuery += "    WHERE SRA.D_E_L_E_T_ = '' "
cQuery += "         AND RA_SITFOLH != 'D' "
cQuery += "              AND RA_CC NOT IN ('20000','1000') "
cQuery += "                   AND RA_SEXO = 'F'       "
cQuery += "    GROUP BY RA_SEXO "
cQuery += "    )FEMI "
cQuery += "    UNION  "
cQuery += "    SELECT  'Encargos Sociais Obrigatorios' Descricao, EMPRESA, 0 Vazio, VALOR, RV_DESC "
cQuery += "    FROM( "
cQuery += "    SELECT '2 - AMAZON' EMPRESA, RD_PD, RV_DESC, RV_DESCDET, SUM(RD_VALOR) VALOR "
cQuery += "    FROM SRD200 SRD  "
cQuery += "    LEFT JOIN SRV200 SRV ON RV_COD = RD_PD  "
cQuery += "         AND SRV.D_E_L_E_T_ = '' "
cQuery += "    WHERE SRD.D_E_L_E_T_ = '' "
cQuery += "        AND RD_PERIODO = '"+mv_par01+"'  "
cQuery += "              AND RD_PD = '755' "
cQuery += "                   AND RD_FILIAL = '01' "
cQuery += "    GROUP BY RD_PD, RV_DESC, RV_DESCDET  "
cQuery += "    UNION  "
cQuery += "    SELECT '1 - PELMEX' EMPRESA, RD_PD, RV_DESC, RV_DESCDET, SUM(RD_VALOR) VALOR "
cQuery += "    FROM SRD100 SRD  "
cQuery += "    LEFT JOIN SRV100 SRV ON RV_COD = RD_PD  "
cQuery += "         AND SRV.D_E_L_E_T_ = '' "
cQuery += "    WHERE SRD.D_E_L_E_T_ = '' "
cQuery += "        AND RD_PERIODO = '"+mv_par01+"'  "
cQuery += "              AND RD_PD = '755' "
cQuery += "    GROUP BY RD_PD, RV_DESC, RV_DESCDET  "
cQuery += "    )ENC "
cQuery += "    UNION  "
cQuery += "    SELECT 'Beneficios Sociais' Descricao, EMPRESA, 0 Vazio, VALOR, RV_DESC "
cQuery += "    FROM ( "
cQuery += "    SELECT '2 - AMAZON' EMPRESA, SUM(VALOR) VALOR, RV_DESC "
cQuery += "    FROM( "
cQuery += "    SELECT RD_PD, RV_DESC, RV_DESCDET, round(SUM(RD_VALOR),2) VALOR "
cQuery += "    FROM SRD200 SRD  "
cQuery += "    LEFT JOIN SRV200 SRV ON RV_COD = RD_PD  "
cQuery += "         AND SRV.D_E_L_E_T_ = '' "
cQuery += "    WHERE SRD.D_E_L_E_T_ = '' "
cQuery += "        AND RD_PERIODO = '"+mv_par01+"'  "
cQuery += "              AND RD_PD IN ('341','423','438') "
cQuery += "    GROUP BY RD_PD, RV_DESC, RV_DESCDET  "
cQuery += "    )TB  "
cQuery += "    GROUP BY RV_DESC  "
cQuery += "    UNION  "
cQuery += "    SELECT '1 - PELMEX' EMPRESA, SUM(VALOR) VALOR, RV_DESC "
cQuery += "    FROM( "
cQuery += "    SELECT RD_PD, RV_DESC, RV_DESCDET, round(SUM(RD_VALOR),2) VALOR "
cQuery += "    FROM SRD100 SRD  "
cQuery += "    LEFT JOIN SRV100 SRV ON RV_COD = RD_PD  "
cQuery += "         AND SRV.D_E_L_E_T_ = '' "
cQuery += "    WHERE SRD.D_E_L_E_T_ = '' "
cQuery += "        AND RD_PERIODO = '"+mv_par01+"'  "
cQuery += "              AND RD_PD IN ('341','423','438') "
cQuery += "    GROUP BY RD_PD, RV_DESC, RV_DESCDET  "
cQuery += "    )TB  "
cQuery += "    GROUP BY RV_DESC  "
cQuery += "    )BENE "
cQuery += "    )TB_GERAL "
cQuery += "    WHERE CAST(substring(EMPRESA,1,1) AS INT) = 1 "





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
			cDescricao 	:= cAlias->Descricao
			cEMPRESA := cAlias->EMPRESA
			IncProc("Imprimindo Resumo"+alltrim(cAlias->Descricao))
			IncProc("Imprimindo Resumo"+alltrim(cAlias->EMPRESA))
		//imprimo a primeira seção				
			oSection1:Cell("Descricao"):SetValue(cAlias->Descricao)
			oSection1:Cell("EMPRESA"):SetValue(cAlias->EMPRESA)
		oSection1:Printline()

		//inicializo a segunda seção

		oSection2:init()
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->Descricao == cDescricao .and. cAlias->EMPRESA = cEMPRESA
			oReport:IncMeter()		                                
			IncProc("Imprimindo Valores"+alltrim(cAlias->Total))
			oSection2:Cell("Total"):SetValue(cAlias->Total)
			oSection2:Cell("Salario_Valor"):SetValue(cAlias->Salario_Valor)
			oSection2:Cell("Faixa_Descri"):SetValue(cAlias->Faixa_descri)			
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


	u_InPutSX1(cPerg,"01",PADR("Per. Folha(AnoMes)? ",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01", )
	//u_InPutSX1(cPerg,"02",PADR("Empresa",20)+"","","","mv_ch2","N",1,0,0,"C","","","","","mv_par02", "1 - PELMEX","","","","2 - AMAZON")

Return


