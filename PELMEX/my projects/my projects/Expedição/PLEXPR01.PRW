#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  29/05/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Saida da Expedi็ใo						        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEXPR01()
	Local oReport := nil
	Local cPerg:= Padr("PLEXPR01",10)

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


	oReport := TReport():New(cNOME,"Relat๓rio Entrega de Clientes",cNOME,{|oReport| ReportPrint(oReport)},"Entrega de Clientes")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Nota", {"Nota"}, , .F., .T.)
	TRCell():New(oSection1,"ENT_DOC"		   	,"cAlias","Nota",,9)
	TRCell():New(oSection1,"ENT_SERIE"		   	,"cAlias","Serie",,)
	TRCell():New(oSection1,"ENT_CLIENTE"		,"cAlias","Cod.Cliente",,)
	TRCell():New(oSection1,"ENT_NOME"		   	,"cAlias","Nome",,30)
	TRCell():New(oSection1,"ENT_EMISSAO"		,"cAlias","Emissใo",,13)
	TRCell():New(oSection1,"ENT_DTEXP"		   	,"cAlias","Expedido em",,)
	TRCell():New(oSection1,"ENT_MOTORISTA"		,"cAlias","Motorista",,20)
	TRCell():New(oSection1,"ENT_PLACA"		   	,"cAlias","Placa",,15)
	TRCell():New(oSection1,"ENT_RECEBPOR"	 	,"cAlias","Recebido Por",,20)
	TRCell():New(oSection1,"ENT_DTRECEB"		,"cAlias","Dt.Recebimento",,)
	TRCell():New(oSection1,"ENT_HORARIO"		,"cAlias","Horario",,)
	TRCell():New(oSection1,"ENT_STATUS"		   	,"cAlias","Status",,12)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produto", {"ENTREGA"}, NIL, .F., .T.)
	TRCell():New(oSection2,"ENT_ITEM"	    			,"cAlias","Item",,)
	TRCell():New(oSection2,"ENT_PRODUTO"		    	,"cAlias","Produto",,15)
	TRCell():New(oSection2,"ENT_DESCPROD"				,"cAlias","Descri็ใo",/*Mascara*/,50)    
	TRCell():New(oSection2,"ENT_QUANT"					,"cAlias","Quantidade",/*Mascara*/,)
	TRCell():New(oSection2,"ENT_OBS"					,"cAlias","Observa็ใo",,50)  
	//Quebra por Se็ใo
	//
	oBreak := TRBreak():New(oSection2,oSection1:Cell("ENT_DOC"),"") 
	//TRFunction():New(oSection2:Cell("ENT_QUANT"),"Total por Custos","SUM",oBreak,,,,.F.,.F.) 
	//Fim Quebra por Se็ใo

	//Totalizador final
	//TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)




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


	cQuery := " SELECT ENT_DOC,ENT_SERIE,ENT_CLIENTE,ENT_NOME,CONVERT(VARCHAR(13),CAST(ENT_EMISSAO AS DATE),112) ENT_EMISSAO,CONVERT(VARCHAR(13),CAST(ENT_DTEXP AS DATE),112) ENT_DTEXP,ENT_MOTORISTA,ENT_PLACA,ENT_RECEBPOR,CONVERT(VARCHAR(13),CAST(ENT_DTRECEB AS DATE),112)ENT_DTRECEB,ENT_HORARIO, "
	cQuery += " CASE WHEN ENT_STATUS= 0 THEN 'DEVOLVIDO' ELSE 'ENTREGUE' end ENT_STATUS, "
	cQuery += " ENT_ITEM,ENT_PRODUTO,ENT_DESCPROD,ENT_QUANT,ENT_OBS "
	cQuery += " FROM ENTREGA (NOLOCK) "
	cQuery += " WHERE CONVERT(VARCHAR(13),CAST(ENT_DTRECEB AS DATE),112) BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'  "


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

		cCodproduto 	:= cAlias->ENT_DOC

		IncProc("Imprimindo NOTA"+alltrim(cAlias->ENT_DOC))


		//imprimo a primeira se็ใo				
		oSection1:Cell("ENT_DOC"):SetValue(cAlias->ENT_DOC)
		oSection1:Cell("ENT_SERIE"):SetValue(cAlias->ENT_SERIE)       
		oSection1:Cell("ENT_CLIENTE"):SetValue(cAlias->ENT_CLIENTE)
		oSection1:Cell("ENT_NOME"):SetValue(cAlias->ENT_NOME)  
		oSection1:Cell("ENT_EMISSAO"):SetValue(STOD(cAlias->ENT_EMISSAO))
		oSection1:Cell("ENT_DTEXP"):SetValue(STOD(cAlias->ENT_DTEXP))  
		oSection1:Cell("ENT_MOTORISTA"):SetValue(cAlias->ENT_MOTORISTA)
		oSection1:Cell("ENT_PLACA"):SetValue(cAlias->ENT_PLACA)  
		oSection1:Cell("ENT_RECEBPOR"):SetValue(cAlias->ENT_RECEBPOR)
		oSection1:Cell("ENT_DTRECEB"):SetValue(STOD(cAlias->ENT_DTRECEB))  	
		oSection1:Cell("ENT_HORARIO"):SetValue(cAlias->ENT_HORARIO)	
		oSection1:Cell("ENT_STATUS"):SetValue(cAlias->ENT_STATUS)	
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->ENT_DOC == cCodproduto
			oReport:IncMeter()		                                



			IncProc("Produto"+alltrim(cAlias->ENT_PRODUTO))
			oSection2:Cell("ENT_ITEM"):SetValue(cAlias->ENT_ITEM)
			oSection2:Cell("ENT_PRODUTO"):SetValue(cAlias->ENT_PRODUTO)
			oSection2:Cell("ENT_DESCPROD"):SetValue(cAlias->ENT_DESCPROD)
			oSection2:Cell("ENT_QUANT"):SetValue(cAlias->ENT_QUANT)			
			oSection2:Cell("ENT_OBS"):SetValue(cAlias->ENT_OBS)		

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

	u_InPutSX1(cPerg,"01",PADR("Recebimento De?     	 ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Recebimento At้?	     ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")


Return