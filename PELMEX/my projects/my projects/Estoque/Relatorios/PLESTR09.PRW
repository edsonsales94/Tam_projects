#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Vendas									        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEST09()
	Local oReport := nil
	Local cPerg:= Padr("PLEST09",10)

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


	oReport := TReport():New(cNOME,"Notas Expedidas",cNOME,{|oReport| ReportPrint(oReport)},"Notas Expedidas")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Cliente", {"SL1"}, , .F., .T.)
	TRCell():New(oSection1,"SAI_CLIENTE"	   ,"cAlias","Cliente",,10)
	TRCell():New(oSection1,"SAI_NOME"	   	   ,"cAlias","Nome",,50)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas



	oSection2:= TRSection():New(oReport, "Documento", {"SE1"}, NIL, .F., .T.)

	TRCell():New(oSection2,"SAI_DOC"		    	,"cAlias","Nota",,10)
	TRCell():New(oSection2,"SAI_SERIE"				,"cAlias","Serie",/*Mascara*/,7)    
	TRCell():New(oSection2,"SAI_DTEXP"				,"cAlias","Dt.Saida",/*Mascara*/,12)   
	TRCell():New(oSection2,"F4_CODIGO"	   			,"cAlias","TES",,15)       
	TRCell():New(oSection2,"F4_TEXTO"	   			,"cAlias","Natureza",,50) 

	oBreak := TRBreak():New(oSection2,oSection1:Cell("SAI_CLIENTE"),"Total de Notas") 
	TRFunction():New(oSection2:Cell("SAI_DOC"),"","COUNT",oBreak,,"@E 9,999,999,999",,.F.,.F.)

	//Fim Quebra por Se็ใo

	//Totalizador final
	//TRFunction():New(oSection1:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

	TRFunction():New(oSection2:Cell("SAI_DOC")	,"Total de Notas","COUNT",,,"@E 9,999,999,999",,.F.,.T.)


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


	cQuery := " SELECT SAI_DOC,SAI_SERIE,SAI_CLIENTE,SAI_NOME,SAI_DTEXP,F4_CODIGO,F4_TEXTO "
	cQuery += "	FROM SAI (NOLOCK) "
	cQuery += "	INNER JOIN "+RETSQLNAME("SD2")+" SD2 (NOLOCK) ON SAI_FILIAL = SD2.D2_FILIAL AND SAI_DOC = SD2.D2_DOC AND SAI_SERIE = SD2.D2_SERIE AND SAI_ITEM = SD2.D2_ITEM AND SAI_PRODUTO = SD2.D2_COD AND SD2.D_E_L_E_T_ = '' "
	cQuery += "	INNER JOIN "+RETSQLNAME("SF4")+" SF4 (NOLOCK) ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
	cQuery += "	WHERE CAST(SAI_DTEXP AS DATE) BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "	GROUP BY SAI_DOC,SAI_SERIE,SAI_CLIENTE,SAI_NOME,SAI_DTEXP,F4_CODIGO,F4_TEXTO "
	cQuery += "	ORDER BY SAI_CLIENTE,SAI_DOC,SAI_SERIE,SAI_DTEXP "



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



		cCodproduto 	:= cAlias->SAI_CLIENTE

		IncProc("Imprimindo Cliente"+alltrim(cAlias->L1_NUM))


		//imprimo a primeira se็ใo				
		oSection1:Cell("SAI_CLIENTE"):SetValue(cAlias->SAI_CLIENTE)
		oSection1:Cell("SAI_NOME"):SetValue(cAlias->SAI_NOME)   
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->E1_NUM == cCodproduto
			oReport:IncMeter()		                                


			IncProc("Imprimindo Nota Fiscal"+alltrim(cAlias->SAI_DOC))
			oSection2:Cell("SAI_DOC"):SetValue(cAlias->SAI_DOC)
			oSection2:Cell("SAI_SERIE"):SetValue(cAlias->SAI_SERIE)
			oSection2:Cell("SAI_DTEXP"):SetValue(cAlias->SAI_DTEXP)
			oSection2:Cell("F4_CODIGO"):SetValue(cAlias->F4_CODIGO)			
			oSection2:Cell("F4_TEXTO"):SetValue(cAlias->F4_TEXTO)	

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

	u_InPutSX1(cPerg,"01",PADR("Expedida De    ? ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Expedida At้   ? ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return