#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Custo de produto por pedido						        	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PLESTR16()
	Local oReport := nil
	Local cPerg:= Padr("PLESTR16",10)

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

	oReport := TReport():New(cNOME,"Relat๓rio Custo de produto",cNOME,{|oReport| ReportPrint(oReport)},"Custo de produto")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo

	oSection1:= TRSection():New(oReport, "Produto", {"SG1"}, , .F., .T.)
	TRCell():New(oSection1,"G1_COD"		   ,"cAlias","Codigo do produto","@!",17)
	TRCell():New(oSection1,"PRODUTO"	   ,"cAlias","Descri็ใo do produto",,60)
	TRCell():New(oSection1,"B1_PESO"	   ,"cAlias","Peso do produto","@E 9,999,999,999.99999999",)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Componentes", {"SG1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"G1_COMP"	    		,"cAlias","Componente",,)
	TRCell():New(oSection2,"COMPONENTE"		    	,"cAlias","Descri็ใo do componente",,60)
	TRCell():New(oSection2,"G1_QUANT"				,"cAlias","Quantidade","@E 9,999,999,999.99999999",20)
	TRCell():New(oSection2,"B2_CM1"					,"cAlias","Custo","@E 9,999,999,999.99999999",20)
	TRCell():New(oSection2,"pesocomp"				,"cAlias","Peso do componente","@E 9,999,999,999.99999999",20)
	TRCell():New(oSection2,"TOTAL"					,"cAlias","TOTAL","@E 9,999,999,999.99999999",20)
	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("G1_COD"),"Total por Produto")
	TRFunction():New(oSection2:Cell("TOTAL"),"Total por Custos","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

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

	cQuery := " SELECT	G1_COD,SB1.B1_DESC PRODUTO,G1_COMP,SB12.B1_DESC COMPONENTE,G1_QUANT,B2_CM1, G1_QUANT*B2_CM1 TOTAL,SB1.B1_PESO B1_PESO,SB12.B1_PESO pesocomp  "
	cQuery += " FROM "+RETSQLNAME("SG1")+" SG1 (NOLOCK) "
	cQuery += " INNER JOIN "+RETSQLNAME("SB2")+" SB2 (NOLOCK)  ON SB2.B2_FILIAL = SG1.G1_FILIAL AND G1_COMP = B2_COD AND SB2.D_E_L_E_T_='' "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK) ON SB1.B1_COD = SG1.G1_COD AND SB1.D_E_L_E_T_ = ''  "
	cQuery += " INNER JOIN "+RETSQLNAME("SC6")+" SC6 (NOLOCK) ON SC6.C6_PRODUTO = SG1.G1_COD AND SC6.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB12 (NOLOCK) ON SB12.B1_COD = SG1.G1_COMP AND SB12.D_E_L_E_T_ = ''  "
	cQuery += " INNER JOIN "+RETSQLNAME("SC5")+" SC5 (NOLOCK) ON C6_NUM = C5_NUM AND C6_FILIAL = C5_FILIAL  AND SC5.D_E_L_E_T_ = ''
	cQuery += " WHERE "
	cQuery += " SG1.D_E_L_E_T_ = '' "
	cQuery += " AND SG1.G1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND SC6.C6_NUM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " AND SC6.C6_CLI BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"' "
	cQuery += " AND SB2.B2_FILIAL = '01' "
	cQuery += " AND SB2.B2_LOCAL = '10' "
	cQuery += " AND SB1.B1_DCR = '' "
	cQuery += " AND SB12.B1_ORIGEM NOT IN ('0','2','3','4','5','8') "
	cQuery += " AND SB1.B1_TIPO IN ('MN','MI','MA','PI','MO','PA') "
	cQuery += " GROUP BY G1_COD,SB1.B1_DESC,G1_COMP,SB12.B1_DESC,G1_QUANT,B2_CM1,SB1.B1_PESO,SB12.B1_PESO"
	cQuery += " ORDER BY SG1.G1_COD,SG1.G1_COMP "

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

		cCodproduto 	:= cAlias->G1_COD

		IncProc("Imprimindo Produto"+alltrim(cAlias->G1_COD))

		//imprimo a primeira se็ใo
		oSection1:Cell("G1_COD"):SetValue(cAlias->G1_COD)
		oSection1:Cell("PRODUTO"):SetValue(cAlias->PRODUTO)
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->G1_COD == cCodproduto
			oReport:IncMeter()

			IncProc("ImprimindMICROSIGAo Componentes"+alltrim(cAlias->G1_COMP))
			oSection2:Cell("G1_COMP"):SetValue(cAlias->G1_COMP)
			oSection2:Cell("COMPONENTE"):SetValue(cAlias->COMPONENTE)
			oSection2:Cell("G1_QUANT"):SetValue(cAlias->G1_QUANT)
			oSection2:Cell("B2_CM1"):SetValue(cAlias->B2_CM1)
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

	u_InPutSX1(cPerg,"01",PADR("Produto De  ?    ",20)+"","","","mv_ch1","C",16,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Produto At้ ?    ",20)+"","","","mv_ch2","C",16,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Pedido De?     	 ",20)+"","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Pedido At้?      ",20)+"","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Cliente De?     	 ",20)+"","","","mv_ch5","C",6,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Cliente At้?      ",20)+"","","","mv_ch6","C",6,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Emissใo De?     	 ",20)+"","","","mv_ch7","D",8,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Emissใo At้?      ",20)+"","","","mv_ch8","D",8,0,0,"G","","","","","mv_par08")

Return