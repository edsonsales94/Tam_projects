#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR75  บAutor  ณKledson Oliveira   				บ Data ณ 02/06/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Tit. Pag. simp. por natureza             			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR75()
	Local oReport := nil
	Local cPerg:= Padr("PLFINR75",10)

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


	oReport := TReport():New(cNOME,"Tit. Pag. simp. por natureza",cNOME,{|oReport| ReportPrint(oReport)},"Tit. Pag. simp. por natureza")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Empresa",{"cAlias"} , , .F., .T.)

	TRCell():New(oSection1,"Empresa"		,"cAlias","Empresa",,20)
	TRCell():New(oSection1,"Periodo"				,"cAlias","Periodo",,15)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas


	oSection2:= TRSection():New(oReport, "Natureza", {"cAlias"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"TIPO"	   ,"cAlias","Tipo",,8)	
	TRCell():New(oSection2,"Natureza"	   	   ,"cAlias","Natureza",,15)
	//TRCell():New(oSection2,"CFOP"				,"cAlias","CFOP",/*Mascara*/,5)
	TRCell():New(oSection2,"Descricao"	   	,"cAlias","Descri็ใo",,30)     
	TRCell():New(oSection2,"TotalVencto"				,"cAlias","Total Vencto","@E 9,999,999,999.99",15)   
	TRCell():New(oSection2,"TotalPago"	   	,"cAlias","Total Pg.","@E 9,999,999,999.99",15)     
	TRCell():New(oSection2,"TotalPagar"				,"cAlias","Total a pagar","@E 9,999,999,999.99",15)   
	//TRCell():New(oSection2,"ICMS"	   			,"cAlias","ICMS","@E 9,999,999,999.99",)       

	oBreak := TRBreak():New(oSection2,oSection1:Cell("Empresa"),"Soma Geral") 
	TRFunction():New(oSection2:Cell("TotalVencto"),"Soma vcto","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("TotalPago"),"Soma pago","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("TotalPagar"),"Soma a Pagar","SUM",oBreak,,,,.F.,.F.)

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



cQuery := " SELECT Empresa,SUBSTRING(DT_VENCTO,4,7)[Periodo],E2_NATUREZ Natureza,ED_DESCRIC [Descricao], "
cQuery += "      SUM(E2_VALOR)[TotalVencto], "
cQuery += "      SUM(E2_VALLIQ)[TotalPago], "
cQuery += "      SUM(E2_SALDO)[TotalPagar] "
cQuery += " FROM( "
cQuery += " SELECT * "
cQuery += " FROM( "
cQuery += " SELECT 'PELMEX' Empresa,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_VALOR,E2_VALLIQ,E2_SALDO, "
cQuery += "      CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO, "
cQuery += "      CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO, "
cQuery += "      CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA, "
cQuery += "      E2_FORNECE,E2_LOJA,E2_NOMFOR, "
cQuery += "      E2_NATUREZ,ED_DESCRIC,E2_HIST "
cQuery += " FROM SE2100 SE2 (NOLOCK) "
cQuery += " INNER JOIN SED100 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = '' "
cQuery += " WHERE SE2.D_E_L_E_T_ = '' "
cQuery += " AND E2_NOMFOR NOT LIKE 'AMAZON MOT%' "
cQuery += " AND E2_VENCTO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " UNION "
cQuery += " SELECT 'AMAZON' Empresa,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_VALOR,E2_VALLIQ,E2_SALDO, "
cQuery += "      CONVERT(VARCHAR,CAST(E2_EMISSAO AS DATE),103)DT_EMISSAO, "
cQuery += "      CONVERT(VARCHAR,CAST(E2_VENCTO AS DATE),103)DT_VENCTO, "
cQuery += "      CASE WHEN E2_BAIXA = '' THEN '' ELSE CONVERT(VARCHAR,CAST(E2_BAIXA AS DATE),103) END DT_BAIXA, "
cQuery += "      E2_FORNECE,E2_LOJA,E2_NOMFOR, "
cQuery += "      E2_NATUREZ,ED_DESCRIC,E2_HIST "
cQuery += " FROM SE2200 SE2 (NOLOCK) "
cQuery += " INNER JOIN SED200 SED (NOLOCK) ON E2_NATUREZ = ED_CODIGO AND SED.D_E_L_E_T_ = '' "
cQuery += " WHERE SE2.D_E_L_E_T_ = '' "
cQuery += " AND E2_VENCTO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " )TB "
cQuery += " )TB1 "
cQuery += " GROUP BY Empresa,SUBSTRING(DT_VENCTO,4,7),E2_NATUREZ,ED_DESCRIC "
cQuery += " ORDER BY Empresa,[Periodo],[Descricao] "
		

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
			cEmpresa 	:= cAlias->Empresa
			cPeriodo := cAlias->Periodo
			IncProc("Imprimindo Resumo"+alltrim(cAlias->Empresa))
			IncProc("Imprimindo Resumo"+alltrim(cAlias->Empresa))
		//imprimo a primeira se็ใo				
			oSection1:Cell("Empresa"):SetValue(cAlias->Empresa)
			oSection1:Cell("Periodo"):SetValue(cAlias->Periodo)
		oSection1:Printline()

		//inicializo a segunda se็ใo

		//TotalVencto

		oSection2:init()
		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->Empresa == cEmpresa .and. cAlias->Periodo = cPeriodo
			oReport:IncMeter()		                                
			IncProc("Imprimindo Valores"+alltrim(cAlias->Natureza))
			oSection2:Cell("Natureza"):SetValue(cAlias->Natureza)
			oSection2:Cell("Descricao"):SetValue(cAlias->Descricao)
			oSection2:Cell("TotalVencto"):SetValue(cAlias->TotalVencto)			
			oSection2:Cell("TotalPago"):SetValue(cAlias->TotalPago)			
			oSection2:Cell("TotalPagar"):SetValue(cAlias->TotalPagar)			

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


	u_InPutSX1(cPerg,"01",PADR("Dt. Vencto de   ? ",20)+"","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Dt. Vencto ate ? ",20)+"","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")

Return
