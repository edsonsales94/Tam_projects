#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#Include "TOTVS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR50    บAutor  ณWYLLIAM SILVA     				บ Data ณ  04/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  GERAL CONTAS A PAGAR		                		        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLFINR50()
	Local oReport := nil
	Local cPerg:= Padr("PLFINR50",10)

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

	oReport := TReport():New(cNOME,"GERAL CONTAS A PAGAR",cNOME,{|oReport| ReportPrint(oReport)},"PICKLIST")
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

	TRCell():New(oSection2,"FORNECEDOR"		    ,"cAlias","NUM. TITULO","!@",35)
	TRCell():New(oSection2,"TITULO"		  		,"cAlias","TITULO","!@",15)
	TRCell():New(oSection2,"PREF"	   	    	,"cAlias","PREFIXO","!@",4)
	TRCell():New(oSection2,"PARCELA"		    ,"cAlias","PARC.","!@",3)
	TRCell():New(oSection2,"TIPO "		        ,"cAlias","TIPO","!@",3)
	TRCell():New(oSection2,"DT_EMISSAO"			,"cAlias","DT EMISSAO","!@",10)
	TRCell():New(oSection2,"DT_VENCTO"			,"cAlias","DT VENCTO","!@",10)
	TRCell():New(oSection2,"DT_BAIXA"			,"cAlias","DT BAIXA","!@",10)
	TRCell():New(oSection2,"HISTORICO"			,"cAlias","HISTORICO","!@",30)	
	TRCell():New(oSection2,"E2_VALOR"		    ,"cAlias","VALOR","@E 9,999,999,999.99",)
	TRCell():New(oSection2,"E2_NATUREZ"			,"cAlias","COD.NATUREZ","!@",15)
	TRCell():New(oSection2,"ED_DESCRIC"			,"cAlias","NOME NATUREZ","!@",25)

	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("EMPRESA"),"TOTAL EMPRESA")

	TRFunction():New(oSection2:Cell("E2_VALOR"),"TOTAL","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("E2_VALOR"),"TOTAL PELMEX/AMAZON MAO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

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



cQuery += "SELECT * "
cQuery += "FROM ( SELECT 'PELMEX' EMPRESA, E2_NOMFOR FORNECEDOR,E2_NUM TITULO,E2_PREFIXO PREF,E2_PARCELA PARCELA,E2_TIPO TIPO, "
cQuery += "         CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103) DT_EMISSAO,CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103) DT_VENCTO,"
cQuery += "         CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) DT_BAIXA,E2_HIST HISTORICO,E2_VALOR VALOR,E2_NATUREZ,ED_DESCRIC"
cQuery += "     FROM  SE2100 SE2"
cQuery += "     INNER JOIN SA1100 SA1 (NOLOCK) ON E2_FORNECE = A1_COD AND E2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ = '' "
cQuery += "  	INNER JOIN SED100 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = '' "
cQuery += "     WHERE SE2.D_E_L_E_T_ = '' "
cQuery += "     AND A1_NOME NOT LIKE 'PELMEX%'"
cQuery += "     AND E2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += "     AND E2_BAIXA BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
cQuery += "     UNION"
cQuery += "     SELECT 'AMAZON' EMPRESA,E2_NOMFOR FORNECEDOR,E2_NUM TITULO,E2_PREFIXO PREF,E2_PARCELA PARCELA,E2_TIPO TIPO,"
cQuery += "         CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103) DT_EMISSAO,CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103) DT_VENCTO,"
cQuery += "         CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) DT_BAIXA,E2_HIST HISTORICO,E2_VALOR VALOR,E2_NATUREZ,ED_DESCRIC"
cQuery += "     FROM  SE2200 SE2"
cQuery += "     INNER JOIN SA1200 SA1 (NOLOCK) ON E2_FORNECE = A1_COD AND E2_LOJA = A1_LOJA  AND SA1.D_E_L_E_T_ = '' "
cQuery += "  	INNER JOIN SED200 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = '' "
cQuery += "     WHERE SE2.D_E_L_E_T_ = ''"
cQuery += "     AND A1_NOME NOT LIKE 'AMAZON%'"
cQuery += "     AND E2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += "     AND E2_BAIXA BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' ) TB"
cQuery += " ORDER BY 1,TB.DT_EMISSAO,DT_BAIXA"


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

			IncProc("Imprimindo Estrutura "+alltrim(cAlias->FORNECEDOR))
			oSection2:Cell("FORNECEDOR"):SetValue(cAlias->FORNECEDOR)
			oSection2:Cell("TITULO"):SetValue(cAlias->TITULO)
			oSection2:Cell("PREF"):SetValue(cAlias->PREF)
			oSection2:Cell("PARCELA"):SetValue(cAlias->PARCELA)
			oSection2:Cell("TIPO"):SetValue(cAlias->TIPO)
			oSection2:Cell("DT_EMISSAO"):SetValue(cAlias->DT_EMISSAO)
			oSection2:Cell("DT_VENCTO"):SetValue(cAlias->DT_VENCTO)
			oSection2:Cell("DT_BAIXA"):SetValue(cAlias->DT_BAIXA)
            oSection2:Cell("HISTORICO"):SetValue(cAlias->HISTORICO)
            oSection2:Cell("VALOR"):SetValue(cAlias->VALOR)
			oSection2:Cell("E2_NATUREZ"):SetValue(cAlias->E2_NATUREZ)
			oSection2:Cell("ED_DESCRIC"):SetValue(cAlias->ED_DESCRIC)

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
    u_InPutSX1(cPerg,"01",PADR("De Emissao  ?    	",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Emissao ?   	",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Vencto  ?     	",20)+"","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Vencto ? 		",20)+"","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	/*u_InPutSX1(cPerg,"05",PADR("De Cliente ?	    ",20)+"","","","mv_ch5","C",10,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("At้ Cliente ? 		",20)+"","","","mv_ch6","C",10,0,0,"G","","","","","mv_par06")*/
	
Return
