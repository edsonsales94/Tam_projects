#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR30   บAutor  ณStan Lee Lopes	    				บ Data ณ  14/04/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Analise do PCP									        	   			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR30()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR30",10)

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


	oReport := TReport():New(cNOME,"Analise do PCP",cNOME,{|oReport| ReportPrint(oReport)},"Analise do PCP")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Modelo", {"PRO"}, , .F., .T.)
	TRCell():New(oSection1,"PRO_MODELO"		   ,"cAlias","Modelo",,50)
	//	TRCell():New(oSection1,"C2_XNOME"	   ,"cAlias","Nome do Cliente",,50)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produto", {"PRO"}, NIL, .F., .T.)
	TRCell():New(oSection2,"PRO_PRODUTO"	    	,"cAlias","Produto",,20)
	TRCell():New(oSection2,"PRO_DESCRI"		    	,"cAlias","Descri็ใo",,50)    
	TRCell():New(oSection2,"PRO_TIPO"				,"cAlias","Tipo",/*Mascara*/,12) 
	TRCell():New(oSection2,"PRO_QUANT"	    		,"cAlias","Quantidade",,10)
	TRCell():New(oSection2,"PRO_DATINC"		    	,"cAlias","Data de Inclusใo",,12)    

	//Quebra por Se็ใo


	oBreak := TRBreak():New(oSection1,oSection2:Cell("PRO_QUANT"),"TOTAL") 

	TRFunction():New(oSection2:Cell("PRO_QUANT"),"Total","SUM",oBreak,,,,.F.,.F.)

	//Fim Quebra por Se็ใo                                                       


	//Totalizador final
	TRFunction():New(oSection2:Cell("PRO_QUANT"),"A produzir ","SUM", ,,"@E 9,999,999,999",,.F.,.T.)



	//Totalizador                                                                                                          MIC

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
	Local nCount 	:= 0
	mv_par02 = ALLTRIM(mv_par02)
	mv_par01 = ALLTRIM(mv_par01)
	
	cQuery += " SELECT PRO_PRODUTO,PRO_DESCRI,PRO_TIPO,PRO_MODELO,PRO_QUANT,PRO_DATINC "
	cQuery += " FROM PRO "
	cQuery += " WHERE  CONVERT (VARCHAR,CAST(PRO_DATINC AS DATE),112) BETWEEN '"+DToS(mv_par03)+"' AND '"+DToS(mv_par04)+"' "
	cQuery += " AND (PRO_DESCRI LIKE '%"+mv_par02+"%' OR PRO_PRODUTO LIKE '%"+mv_par02+"%' ) "
	cQuery += " AND PRO_MODELO LIKE '%"+mv_par01+"%' "


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


		cCodproduto 	:= cAlias->PRO_MODELO

		IncProc("Imprimindo modelos"+alltrim(cAlias->PRO_MODELO)) 

		//imprimo a primeira se็ใo				
		oSection1:Cell("PRO_MODELO"):SetValue(cAlias->PRO_MODELO)
		//	oSection1:Cell("C2_XNOME"):SetValue(cAlias->C2_XNOME)       			
		oSection1:Printline()


		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->PRO_MODELO == cCodproduto
			oReport:IncMeter()		                                

			IncProc("Imprimindo produtos"+alltrim(cAlias->PRO_PRODUTO))
			oSection2:Cell("PRO_PRODUTO"):SetValue(cAlias->PRO_PRODUTO)
			oSection2:Cell("PRO_TIPO"):SetValue(cAlias->PRO_TIPO)
			oSection2:Cell("PRO_QUANT"):SetValue(cAlias->PRO_QUANT)
			oSection2:Cell("PRO_DATINC"):SetValue(cAlias->PRO_DATINC)
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

	u_InPutSX1(cPerg,"01",PADR("Modelo De?    	 ",20)+"","","","mv_ch1","C",14,0,0,"G","","SB1","","","mv_par01")   
	u_InPutSX1(cPerg,"02",PADR("Produto ou descricao?",20)+"","","","mv_ch2","C",14,0,0,"G","","SB1","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Emissao de?    	",20)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Emissao Ate?    ",20)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")

Return