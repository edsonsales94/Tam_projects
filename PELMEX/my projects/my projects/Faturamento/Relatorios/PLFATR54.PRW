#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#Include "TOTVS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR54    บAutor  ณJUEVAN SILVA	     				บ Data ณ  04/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  	FATURAMENTO POR CIDADE	                		        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLFATR54()
	Local oReport := nil
	Local cPerg:= Padr("PLFATR54",10)

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

	oReport := TReport():New(cNOME,"FATURAMENTO POR CIDADE",cNOME,{|oReport| ReportPrint(oReport)},"PICKLIST")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo

	oSection1:= TRSection():New(oReport, "EMPRESA", {"cAlias"}, , .F., .T.)
	TRCell():New(oSection1,"EMPRESA"		   ,"cAlias","EMPRESA","!@",10)
	/*TRCell():New(oSection1,"NFANT"			   ,"cAlias","CLIENTE","@!",20)
	TRCell():New(oSection1,"VENDEDOR"		   ,"cAlias","COD VENDEDOR","@!",10)
	TRCell():New(oSection1,"NOME"			   ,"cAlias","VENDEDOR","@!",20)*/
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Estrutura", {"cAlias"}, NIL, .F., .T.)
	TRCell():New(oSection2,"PERIODO"		    ,"cAlias","PERIODO","!@",8)
	TRCell():New(oSection2,"A1_MUN"		  		,"cAlias","CIDADE","!@",30)
	TRCell():New(oSection2,"TOTAL"	   	    	,"cAlias","TOTAL","@E 9,999,999,999.99",)
	/*TRCell():New(oSection2,"PARCELA"		    ,"cAlias","PARC.","!@",3)
	TRCell():New(oSection2,"TIPO "		        ,"cAlias","TIPO","!@",3)
	TRCell():New(oSection2,"DT_EMISSAO"			,"cAlias","DT EMISSAO","!@",10)
	TRCell():New(oSection2,"DT_VENCTO"			,"cAlias","DT VENCTO","!@",10)
	TRCell():New(oSection2,"DT_BAIXA"			,"cAlias","DT BAIXA","!@",10)
	TRCell():New(oSection2,"HISTORICO"			,"cAlias","HISTORICO","!@",30)	
	TRCell():New(oSection2,"E2_VALOR"		    ,"cAlias","VALOR","@E 9,999,999,999.99",)*/

	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("EMPRESA"),"TOTAL EMPRESA")

	TRFunction():New(oSection2:Cell("TOTAL"),"TOTAL","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("TOTAL"),"TOTAL MAO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	//Totalizador
	//TRFunction():New(oSection:Cell("E2_VALOR"),"TOTAL VALOR","SUM",,,"@E 999,999,999.99",,.F.,.T.)                       
	//TRFunction():New(oSection:Cell("VLRTOTAL"),"VLRTOTAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	
	oReport:SetTotalInLine(.F.)

	//quebra  por se็ใo (.T.) uma se็ใo por pagina
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText("VALOR TOTAL")
Return(oReport)

/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local lPrim 	:= .T.

cQuery += "SELECT SUBSTRING(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),4,7)PERIODO,'PELMEX' EMPRESA,A1_MUN,SUM(D2_TOTAL)TOTAL "
cQuery += "FROM("
cQuery += " 	SELECT D2_EMISSAO,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_TOTAL,D2_CLIENTE,A1_NOME,A1_MUN"
cQuery += " 	FROM SD2100 SD2 (NOLOCK)"
cQuery += " 	INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND A1_MSBLQL != '1' AND SA1.D_E_L_E_T_ = ''"
cQuery += " 	LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''"
cQuery += " 	INNER JOIN SF4100 SF4 (NOLOCK) ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ''"
cQuery += " 	WHERE SD2.D_E_L_E_T_ = ''"
cQuery += "		AND F4_TEXTO NOT LIKE '%FUT%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%BONI%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%BRI%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%CONS%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%CONC%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%EMPR%'"
cQuery += " 	AND D1_DOC IS NULL"
cQuery += " 	AND D2_FILIAL = '01'"
cQuery += " 	AND D2_LOCAL = '20'"
cQuery += " 	AND D2_EMISSAO BETWEEN '20230101' AND '20230131' )TB "
cQuery += " GROUP BY D2_EMISSAO,A1_MUN,EMPRESA"

cQuery += "UNION "

cQuery += "SELECT SUBSTRING(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),4,7)PERIODO,'AMAZON' EMPRESA,A1_MUN,SUM(D2_TOTAL)TOTAL"
cQuery += "FROM("
cQuery += "		SELECT D2_EMISSAO,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_TOTAL,D2_CLIENTE,A1_NOME,A1_MUN "
cQuery += " 	FROM SD2200 SD2 (NOLOCK)"
cQuery += " 	INNER JOIN SA1200 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND A1_MSBLQL != '1' AND SA1.D_E_L_E_T_ = ''"
cQuery += " 	LEFT JOIN SD1200 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''"
cQuery += " 	INNER JOIN SF4200 SF4 (NOLOCK) ON D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ''"
cQuery += " 	WHERE SD2.D_E_L_E_T_ = ''"
cQuery += " 	AND F4_TEXTO NOT LIKE '%FUT%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%BONI%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%BRI%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%CONS%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%CONC%'"
cQuery += " 	AND F4_TEXTO NOT LIKE '%EMPR%'"
cQuery += " 	AND A1_NOME NOT LIKE 'PELMEX%'"
cQuery += "		AND D1_DOC IS NULL "
cQuery += " 	AND D2_FILIAL = '01'"
cQuery += " 	AND D2_LOCAL = '20'"
cQuery += " 	AND D2_EMISSAO BETWEEN '20230101' AND '20230131' )TB "
cQuery += "GROUP BY D2_EMISSAO,A1_MUN,EMPRESA"
cQuery += "ORDER BY 1,2,3 "



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

		cSetor 	:= cAlias->EMPRESA

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira se็ใo

		oSection1:Cell("EMPRESA"):SetValue(cAlias->EMPRESA)
		/*oSection1:Cell("NFANT"):SetValue(cAlias->NFANT)
		oSection1:Cell("VENDEDOR"):SetValue(cAlias->VENDEDOR)
		oSection1:Cell("NOME"):SetValue(cAlias->NOME)*/
				
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor ้ mesmo, se sim, imprimo Estrutura
		While cAlias->EMPRESA == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo Estrutura "+alltrim(cAlias->PERIODO))
			oSection2:Cell("PERIODO"):SetValue(cAlias->PERIODO)
			oSection2:Cell("A1_MUN"):SetValue(cAlias->A1_MUN)
			oSection2:Cell("TOTAL"):SetValue(cAlias->TOTAL)
			/*oSection2:Cell("PARCELA"):SetValue(cAlias->PARCELA)
			oSection2:Cell("TIPO"):SetValue(cAlias->TIPO)
			oSection2:Cell("DT_EMISSAO"):SetValue(cAlias->DT_EMISSAO)
			oSection2:Cell("DT_VENCTO"):SetValue(cAlias->DT_VENCTO)
			oSection2:Cell("DT_BAIXA"):SetValue(cAlias->DT_BAIXA)
            oSection2:Cell("HISTORICO"):SetValue(cAlias->HISTORICO)
            oSection2:Cell("VALOR"):SetValue(cAlias->VALOR)*/

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
    u_InPutSX1(cPerg,"01",PADR("De Periodo  ?    	",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Periodo ?   	",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	/*u_InPutSX1(cPerg,"03",PADR("De Vencto  ?     	",20)+"","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Vencto ? 		",20)+"","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Cliente ?	    ",20)+"","","","mv_ch5","C",10,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("At้ Cliente ? 		",20)+"","","","mv_ch6","C",10,0,0,"G","","","","","mv_par06")*/
	
Return
