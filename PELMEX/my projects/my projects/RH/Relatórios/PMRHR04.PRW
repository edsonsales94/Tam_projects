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

User Function PMRHR04()
	Local oReport := nil
	Local cPerg:= Padr("PMRHR04",10)

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

	oReport := TReport():New(cNOME,"REL. ADVERTENCIA RH",cNOME,{|oReport| ReportPrint(oReport)},"PICKLIST")
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
	TRCell():New(oSection2,"ADV_NOME"		    ,"cAlias","NOME","!@",30)
	TRCell():New(oSection2,"ADV_MOTIVO"			,"cAlias","MOTIVO","!@",55)
	TRCell():New(oSection2,"QTDMOT"	   	    	,"cAlias","QTD","@E 9,999,999,999",)
	/*TRCell():New(oSection2,"PARCELA"		    ,"cAlias","PARC.","!@",3)
	TRCell():New(oSection2,"TIPO "		        ,"cAlias","TIPO","!@",3)
	TRCell():New(oSection2,"DT_EMISSAO"			,"cAlias","DT EMISSAO","!@",10)
	TRCell():New(oSection2,"DT_VENCTO"			,"cAlias","DT VENCTO","!@",10)
	TRCell():New(oSection2,"DT_BAIXA"			,"cAlias","DT BAIXA","!@",10)
	TRCell():New(oSection2,"HISTORICO"			,"cAlias","HISTORICO","!@",30)	
	TRCell():New(oSection2,"E2_VALOR"		    ,"cAlias","VALOR","@E 9,999,999,999.99",)*/

	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("EMPRESA"),"TOTAL EMPRESA")

	TRFunction():New(oSection2:Cell("QTD"),"TOTAL","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("QTD"),"TOTAL MAO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

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

cQuery += " SELECT CASE WHEN ADV_EMPRESA = '10' THEN 'PELMEX' ELSE 'AMAZON' END EMPRESA,"
cQuery += " ADV_NOME, ADV_MOTIVO,COUNT(ADV_MOTIVO) QTDMOT"
cQuery += " FROM ADV"
cQuery += " WHERE CONVERT(VARCHAR,CAST(ADV_EMISSAO AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " AND ADV_MAT BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
cQuery += " GROUP BY ADV_EMPRESA, ADV_NOME, ADV_MOTIVO"
cQuery += " "



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

			IncProc("Imprimindo Estrutura "+alltrim(cAlias->ADV_NOME))
			oSection2:Cell("ADV_NOME"):SetValue(cAlias->ADV_NOME)
			oSection2:Cell("ADV_MOTIVO"):SetValue(cAlias->ADV_MOTIVO)
			oSection2:Cell("QTDMOT"):SetValue(cAlias->QTDMOT)
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
	u_InPutSX1(cPerg,"03",PADR("De Matricula  ?   	",20)+"","","","mv_ch3","C",4,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Matricula ? 	",20)+"","","","mv_ch4","C",4,0,0,"G","","","","","mv_par04")
	/*u_InPutSX1(cPerg,"05",PADR("De Cliente ?	    ",20)+"","","","mv_ch5","C",10,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("At้ Cliente ? 		",20)+"","","","mv_ch6","C",10,0,0,"G","","","","","mv_par06")*/
	
Return
