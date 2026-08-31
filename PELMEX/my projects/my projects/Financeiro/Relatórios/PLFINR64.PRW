#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR64    บAutor  ณWYLLIAM SILVA     				บ Data ณ  28/07/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  FATURAMENTO GERAL DETALHADO			    			        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLFINR64()
	Local oReport := nil
	Local cPerg:= Padr("PLFINR64",10)

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

	oReport := TReport():New(cNOME,"FATURAMENTO GERAL DETALHADO",cNOME,{|oReport| ReportPrint(oReport)},"FATURAMENTO GERAL DETALHADO")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Setor", {"cAlias"}, NIL , .F., .T.)
	TRCell():New(oSection1,"PERIODO"		   ,"cAlias","PERIODO","@!",10)
    TRCell():New(oSection1,"L1_FILIAL"	    	,"cAlias","FILIAL","!@",3)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Estrutura", {"cAlias"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"L1_FILIAL"	    	,"cAlias","Filial","!@",3)
	TRCell():New(oSection2,"M0_FILIAL"		    ,"cAlias","Loja","!@",40)
    TRCell():New(oSection2,"FORMPG"		        ,"cAlias","FormaPG","!@",5)
	TRCell():New(oSection2,"TOTAL"			    ,"cAlias","TOTAL","@E 9,999,999,999.99",16)

	//Quebra por Se็ใo

   
	oBreak := TRBreak():New(oSection2,oSection1:Cell("L1_FILIAL"),"FILIAL")

    
	TRFunction():New(oSection2:Cell("TOTAL"),"TOTAL","SUM",oBreak,,,,.F.,.T.)
	//TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                           
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("TOTAL"),"Valor Total","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

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
	//Local teste := mv_par03

	cQuery := " SELECT PERIODO,L1_FILIAL,M0_FILIAL,SUM(TOTAL)TOTAL,FORMPG"
	cQuery += " FROM("
	cQuery += "     SELECT PERIODO,L1_FILIAL,M0_FILIAL,SUM(TOTAL)TOTAL,L4_FORMA FORMPG"
	cQuery += "     FROM("
	cQuery += "         SELECT SUBSTRING(DT_EMISSAO,4,7)PERIODO,L1_FILIAL,M0_FILIAL,TIPO,L2_TES,F4_FINALID,SUM(L2_VLRITEM)TOTAL,L4_FORMA" 
	cQuery += "         FROM("
	cQuery += "         SELECT 'RESERVA' TIPO,L1_FILIAL,L1_NUM,L1_DOC,L1_SERIE,L1_DOCPED,L1_SERPED,L1_ORCRES,L1_FILRES,CONVERT(VARCHAR,CAST(L1_EMISSAO AS DATE),103)DT_EMISSAO,L2_ITEM,L2_PRODUTO,L2_DESCRI,L2_QUANT,"
	cQuery += "         L2_VLRITEM,L2_TES,F4_DUPLIC,F4_FINALID,L1_CLIENTE,L1_LOJA,L4_FORMA"
	cQuery += "         FROM SL1100 SL1 (NOLOCK)"
	cQuery += "         INNER JOIN SL2100 SL2 (NOLOCK) ON L1_FILIAL = L2_FILIAL AND L1_NUM = L2_NUM AND SL2.D_E_L_E_T_ = ''"
	cQuery += "         INNER JOIN SF4100 SF4 (NOLOCK) ON L2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ''"
	cQuery += "         INNER JOIN (SELECT E1_FILORIG,E1_NUM,E1_PREFIXO"
	cQuery += " 		    	    FROM SE1100 SE1 (NOLOCK)"
	cQuery += " 	                WHERE SE1.D_E_L_E_T_ = ''"
	cQuery += " 	                GROUP BY E1_FILORIG,E1_NUM,E1_PREFIXO)SE1 ON L1_FILIAL = E1_FILORIG AND L1_DOCPED = E1_NUM AND L1_SERPED = E1_PREFIXO"
	cQuery += "         LEFT JOIN ( SELECT L4_NUM,L4_FILIAL,L4_FORMA,SUM(L4_VALOR) L4_VALOR"
    cQuery += "                     FROM SL4100 (NOLOCK) SL4"
    cQuery += "                     WHERE SL4.D_E_L_E_T_ =''"
    cQuery += "                     GROUP BY L4_NUM,L4_FILIAL,L4_FORMA )SL4 ON L4_FILIAL = L1_FILIAL AND L4_NUM = L1_NUM"
    cQuery += "         WHERE SL1.D_E_L_E_T_ = ''"
	cQuery += "         AND F4_FINALID LIKE 'VENDA%'"
	cQuery += "         AND L1_EMISNF BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += "         AND L1_DOCPED != ''"
    cQuery += "     UNION"
    cQuery += "         SELECT 'NFe' TIPO,L1_FILIAL,L1_NUM,L1_DOC,L1_SERIE,L1_DOCPED,L1_SERPED,L1_ORCRES,L1_FILRES,CONVERT(VARCHAR,CAST(L1_EMISSAO AS DATE),103)DT_EMISSAO,L2_ITEM,L2_PRODUTO,L2_DESCRI,L2_QUANT,"
    cQuery += "         L2_VLRITEM,L2_TES,F4_DUPLIC,F4_FINALID,L1_CLIENTE,L1_LOJA,L4_FORMA"
    cQuery += "         FROM SL1100 SL1 (NOLOCK)"
    cQuery += "         INNER JOIN SL2100 SL2 (NOLOCK) ON L1_FILIAL = L2_FILIAL AND L1_NUM = L2_NUM AND SL2.D_E_L_E_T_ = ''"
    cQuery += "         INNER JOIN SF4100 SF4 (NOLOCK) ON L2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ''"
    cQuery += "         LEFT JOIN SD1100 SD1 (NOLOCK) ON L1_FILIAL = D1_FILIAL AND L1_DOC = D1_NFORI AND L1_SERIE = D1_SERIORI AND L2_ITEM = D1_ITEMORI AND L2_PRODUTO = D1_COD AND SD1.D_E_L_E_T_ = ''"
    cQuery += "         INNER JOIN (SELECT E1_FILORIG,E1_NUM,E1_PREFIXO"
    cQuery += "                      FROM SE1100 SE1 (NOLOCK)"
    cQuery += "                      WHERE SE1.D_E_L_E_T_ = ''"
    cQuery += "         GROUP BY E1_FILORIG,E1_NUM,E1_PREFIXO)SE1 ON L1_FILIAL = E1_FILORIG AND L1_DOC = E1_NUM AND L1_SERIE = E1_PREFIXO"
    cQuery += "         LEFT JOIN ( SELECT L4_NUM,L4_FILIAL,L4_FORMA,SUM(L4_VALOR) L4_VALOR"
    cQuery += "         FROM SL4100 (NOLOCK) SL4"
    cQuery += "         WHERE SL4.D_E_L_E_T_ =''"
    cQuery += "         GROUP BY L4_NUM,L4_FILIAL,L4_FORMA)SL4 ON L4_FILIAL = L1_FILIAL AND L4_NUM = L1_NUM "
    cQuery += "         WHERE SL1.D_E_L_E_T_ = ''"
    cQuery += "         AND D1_DOC IS NULL"
    cQuery += "         AND F4_FINALID LIKE 'VENDA%'"
    cQuery += "         AND L1_FILIAL NOT IN ('01')"
    cQuery += "         AND L1_EMISNF BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
    cQuery += "         AND L1_DOCPED != ''"
    cQuery += "     UNION"
    cQuery += "         SELECT 'NFCe' TIPO,L1_FILIAL,L1_NUM,L1_DOC,L1_SERIE,L1_DOCPED,L1_SERPED,L1_ORCRES,L1_FILRES,CONVERT(VARCHAR,CAST(L1_EMISSAO AS DATE),103)DT_EMISSAO,L2_ITEM,L2_PRODUTO,L2_DESCRI,L2_QUANT,"
    cQuery += "         L2_VLRITEM,L2_TES,F4_DUPLIC,F4_FINALID,L1_CLIENTE,L1_LOJA,L4_FORMA"
    cQuery += "         FROM SL1100 SL1 (NOLOCK)"
    cQuery += "         INNER JOIN SL2100 SL2 (NOLOCK) ON L1_FILIAL = L2_FILIAL AND L1_NUM = L2_NUM AND SL2.D_E_L_E_T_ = ''"
    cQuery += "         INNER JOIN SF4100 SF4 (NOLOCK) ON L2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ''"
    cQuery += "         LEFT JOIN SD1100 SD1 (NOLOCK) ON L1_FILIAL = D1_FILIAL AND L1_DOC = D1_NFORI AND L1_SERIE = D1_SERIORI AND L2_ITEM = D1_ITEMORI AND L2_PRODUTO = D1_COD AND SD1.D_E_L_E_T_ = ''"
    cQuery += "         INNER JOIN (SELECT E1_FILORIG,E1_NUM,E1_PREFIXO"
    cQuery += "                      FROM SE1100 SE1 (NOLOCK)"
    cQuery += "                      WHERE SE1.D_E_L_E_T_ = ''"
    cQuery += "                      GROUP BY E1_FILORIG,E1_NUM,E1_PREFIXO)SE1 ON L1_FILIAL = E1_FILORIG AND L1_DOC = E1_NUM AND L1_SERIE = E1_PREFIXO"
    cQuery += "         LEFT JOIN ( SELECT L4_NUM,L4_FILIAL,L4_FORMA,SUM(L4_VALOR) L4_VALOR"
    cQuery += "                     FROM SL4100 (NOLOCK) SL4"
    cQuery += "                     WHERE SL4.D_E_L_E_T_ =''"
    cQuery += "                     GROUP BY L4_NUM,L4_FILIAL,L4_FORMA)SL4 ON L4_FILIAL = L1_FILIAL AND L4_NUM = L1_NUM "
    cQuery += "         WHERE SL1.D_E_L_E_T_ = ''"
    cQuery += "         AND D1_DOC IS NULL"
    cQuery += "         AND L1_FILIAL NOT IN ('01')"
    cQuery += "         AND F4_FINALID LIKE 'VENDA%'"
    cQuery += "         AND L1_EMISNF BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
    cQuery += "         AND L1_DOCPED = ''"
    cQuery += "         AND L1_ORCRES = ''"
    cQuery += "         AND L1_DOC != ''"
	cQuery += "         )TB"
	cQuery += "     INNER JOIN SIGAMAT SM (NOLOCK) ON L1_FILIAL = M0_CODFIL AND M0_CODIGO = '10' AND SM.D_E_L_E_T_ = ''"
	cQuery += "     GROUP BY L1_FILIAL,M0_FILIAL,SUBSTRING(DT_EMISSAO,4,7),TIPO,L2_TES,F4_FINALID,L4_FORMA"
	cQuery += "     )TB1"
	cQuery += "     GROUP BY PERIODO,L1_FILIAL,M0_FILIAL,L4_FORMA"
	cQuery += "     )TB2"
    cQuery += " GROUP BY PERIODO,L1_FILIAL,M0_FILIAL,FORMPG"
    cQuery += " ORDER BY 1,2,3"



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

		cSetor 	:= cAlias->L1_FILIAL

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se็ใo

        oSection1:Cell("L1_FILIAL"):SetValue(cAlias->L1_FILIAL)
		oSection1:Cell("PERIODO"):SetValue(cAlias->PERIODO)
        
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		While cAlias->L1_FILIAL == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo produtos "+alltrim(cAlias->M0_FILIAL)) 
			//oSection2:Cell("L1_FILIAL"):SetValue(cAlias->L1_FILIAL)
			oSection2:Cell("M0_FILIAL"):SetValue(cAlias->M0_FILIAL)
            oSection2:Cell("FORMPG"):SetValue(cAlias->FORMPG)
			oSection2:Cell("TOTAL"):SetValue(cAlias->TOTAL)

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
    u_InPutSX1(cPerg,"01",PADR("Emissใo de  ?    ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้ ?    ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	/*u_InPutSX1(cPerg,"03",PADR("Mesa de  ?    ",20)+"","","","mv_ch3","N",3,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Mesa Ate  ?    ",20)+"","","","mv_ch4","N",3,0,0,"G","","","","","mv_par04") */
Return
