#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLCOMR08   บAutor  ณStan Lee Lopes	    				บ Data ณ  08/06/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Estrutura X Vendas								        	   			 ฑ
ฑฑบ          ณ  											                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLCOMR08()
	Local oReport := nil
	Local cPerg:= Padr("PLCOMR08",10)

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


	oReport := TReport():New(cNOME,"Estrutura X Vendas",cNOME,{|oReport| ReportPrint(oReport)},"Estrutura X Vendas")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Produto", {"SB1"}, , .F., .T.)
	TRCell():New(oSection1,"G1_COD"		   ,"cAlias","Cod.Produto",,)
	TRCell():New(oSection1,"SB1.B1_DESC"   ,"cAlias","Descri็ใo",,)
	TRCell():New(oSection1,"SB1.B1_UM"	   ,"cAlias","Medida",,)
	TRCell():New(oSection1,"D2_QUANT"	   ,"cAlias","Quantidade",,)                                                                                               
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Componentes", {"SB1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"G1_COMP"	    		,"cAlias","Componente",,)
	TRCell():New(oSection2,"SB11.B1_DESC"		    ,"cAlias","Descri็ใo",,20)    
	TRCell():New(oSection2,"SB11.B1_UM"				,"cAlias","Unindade",/*Mascara*/,) 
	TRCell():New(oSection2,"G1_QUANT"	    		,"cAlias","Quantidade",,10)
	TRCell():New(oSection2,"G1_TOTAL"		    	,"cAlias","Total",,)    
	TRCell():New(oSection2,"B2_QATU"				,"cAlias","Saldo",/*Mascara*/,6)
	TRCell():New(oSection2,"SB11.B1_UM"				,"cAlias","Total",/*Mascara*/,12)   	
	//Quebra por Se็ใo



	oBreak := TRBreak():New(oSection2,oSection1:Cell("G1_COMP"),"TOTAL") 

	TRFunction():New(oSection2:Cell("G1_QUANT"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("G1_TOTAL"),"Total","SUM",oBreak,,,,.F.,.F.)


	//Fim Quebra por Se็ใo                                                       


	//Totalizador final
	TRFunction():New(oSection2:Cell("G1_QUANT"),"Quantidade","SUM", ,,"@E 9,999,999,999.9999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("G1_TOTAL"),"Total Gasto","SUM", ,,"@E 9,999,999,999.9999",,.F.,.T.)



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

	cQuery := "SELECT G1_COD,SB1.B1_DESC,SB1.B1_UM,"
	cQuery += "    SUM(D2_QUANT)D2_QUANT,"
	cQuery += " 	   G1_COMP,SB11.B1_DESC,SB11.B1_UM,"
	cQuery += " 	   G1_QUANT,
	cQuery += " 	   SUM(G1_QUANT*D2_QUANT)G1_TOTAL,"
	cQuery += "        CASE WHEN G1_COMP LIKE 'MOD%' THEN 0 ELSE B2_QATU END B2_QATU,"
	cQuery += " 	   SB11.B1_UM"
	cQuery += " 	FROM "+RetSQLName("SG1")+" SG1"
	cQuery += " INNER JOIN "+RetSQLName("SD2")+" SD2 (NOLOCK) ON G1_COD = D2_COD AND SD2.D_E_L_E_T_ = ''"
	cQuery += " INNER JOIN "+RetSQLName("SB2")+" SB2 (NOLOCK) ON D2_FILIAL = B2_FILIAL AND G1_COMP = B2_COD AND SB2.D_E_L_E_T_ = ''"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" SB1 (NOLOCK) ON D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" SB11 (NOLOCK) ON G1_COMP = SB11.B1_COD AND SB11.D_E_L_E_T_ = ''"
	cQuery += " WHERE SG1.D_E_L_E_T_ = ''"
	cQuery += " AND D2_FILIAL = '01'"
	cQuery += " AND B2_LOCAL = '01'"
	cQuery += " AND D2_EMISSAO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND G1_COMP BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " GROUP BY G1_COD,SB1.B1_DESC,SB1.B1_UM,G1_QUANT,G1_COMP,SB11.B1_DESC,SB11.B1_UM,B2_QATU"
	cQuery += " ORDER BY D2_QUANT DESC,G1_COD,G1_COMP"




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
		oSection1:Cell("SB1.B1_DESC"):SetValue(cAlias->SB1.B1_DESC)
		oSection1:Cell("SB1.B1_UM"):SetValue(cAlias->SB1.B1_UM)
		oSection1:Cell("D2_QUANT"):SetValue(cAlias->D2_QUANT)

		oSection1:Printline()


		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->G1_COD == cCodproduto
			oReport:IncMeter()		                                


			IncProc("Imprimindo Componentes"+alltrim(cAlias->G1_COMP))
			oSection2:Cell("G1_COMP"):SetValue(cAlias->G1_COMP)
			oSection2:Cell("SB11.B1_DESC"):SetValue(cAlias->SB11.B1_DESC)
			oSection2:Cell("SB11.B1_UM"):SetValue(cAlias->SB11.B1_UM)
			oSection2:Cell("G1_QUANT"):SetValue(cAlias->G1_QUANT)
			oSection2:Cell("G1_TOTAL"):SetValue(cAlias->G1_TOTAL)
			oSection2:Cell("B2_QATU"):SetValue(cAlias->B2_QATU)


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

	u_InPutSX1(cPerg,"05",PADR("Emissใo de  ?    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"06",PADR("Emissใo At้ ?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"01","Componente De?		 ","", "", "mv_ch1","C",11,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02","Componente Ate?		 ","", "", "mv_ch2","C",11,0,0,"G","","","","","mv_par02")



Return