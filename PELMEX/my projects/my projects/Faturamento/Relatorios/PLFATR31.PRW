#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR31   บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Faturamento X Estado							        	   			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR31()
	Local oReport := nil
	Local cPerg:= Padr("PLFATR31",10)

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
	Local oBreak1
	Local oFunction


	oReport := TReport():New(cNOME,"Relatorio para Suframa",cNOME,{|oReport| ReportPrint(oReport)},"Faturamento X Estado")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Grupo", {"SBM"}, , .F., .T.)
	TRCell():New(oSection1,"D3_GRUPO"		   ,"cAlias","Grupo",,)
	TRCell():New(oSection1,"BM_DESC"	   	,"cAlias","Descri็ใo",,) 
	//	TRCell():New(oSection1,"C2_XNOME"	   ,"cAlias","Nome do Cliente",,50)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produtos", {"SD3"}, NIL, .F., .T.)
	TRCell():New(oSection2,"D3_GRUPO"		   		,"cAlias","Grupo",,)
	TRCell():New(oSection2,"BM_DESC"	   			,"cAlias","Descri็ใo",,) 	
	TRCell():New(oSection2,"D3_COD"	    			,"cAlias","Codigo",,)
	TRCell():New(oSection2,"B1_DESC"		    	,"cAlias","Descri็ใo",,)    
	TRCell():New(oSection2,"D3_TIPO"				,"cAlias","Tipo",,)
	TRCell():New(oSection2,"D3_EMISSAO"	    		,"cAlias","Emissao",,)
	TRCell():New(oSection2,"D3_QUANT"		    	,"cAlias","Qtd","@E 9,999,999,999",)    
	TRCell():New(oSection2,"D3_UM"					,"cAlias","UM",,)
	TRCell():New(oSection2,"D3_QTSEGUM"				,"cAlias","QTD 2UM","@E 9,999,999,999.9999",) 
	TRCell():New(oSection2,"D3_SEGUM"				,"cAlias","2UM",,)
	TRCell():New(oSection2,"B1_XENROLL"				,"cAlias","Enrolado",,) 
	//Quebra por Se็ใo



	oBreak := TRBreak():New(oSection1,oSection2:Cell("D3_QUANT"),"Totais") 

	TRFunction():New(oSection2:Cell("D3_QUANT"),"Total","SUM",oBreak,,,,.F.,.F.)


	//Fim Quebra por Se็ใo                                                       


	//Totalizador final
	TRFunction():New(oSection2:Cell("D3_QUANT"),"QUANTIDADE TOTAL","SUM",,,"@E 9,999,999,999.9999",,.F.,.T.)



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



	cQuery := "SELECT D3_GRUPO,BM_DESC,D3_COD,B1_DESC, D3_TIPO, D3_EMISSAO, D3_QUANT, D3_UM, D3_QTSEGUM, D3_SEGUM, CASE WHEN B1_XENROLL = '1' THEN 'SIM' ELSE 'NรO'END B1_XENROLL "  
	cQuery += "FROM "+RetSQLName("SD3")+" SD3(NOLOCK) "
	cQuery += "LEFT JOIN "+RetSQLName("SBM")+" SBM (NOLOCK) ON BM_GRUPO = D3_GRUPO AND SBM.D_E_L_E_T_ = '' "
	cQuery += "LEFT JOIN "+RetSQLName("SB1")+" SB1 (NOLOCK) ON B1_COD = D3_COD AND SB1.D_E_L_E_T_ = '' AND SB1.B1_MSBLQL != '1' "
	cQuery += "WHERE SD3.D_E_L_E_T_ <> '*' " 
	cQuery += "AND D3_FILIAL = '01' " 
	cQuery += "AND D3_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
	cQuery += "AND D3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "AND D3_GRUPO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += "AND D3_CC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
	cQuery += "AND D3_TIPO = 'PA'   "
	cQuery += "AND D3_ESTORNO = ''   "
	cQuery += " AND D3_COD NOT LIKE 'SUP%'" //MODIFICADO 11/01/2022
	cQuery += "AND LEFT(D3_CF,2) = 'PR'  "
	cQuery += "GROUP BY D3_FILIAL,D3_GRUPO,BM_DESC,D3_COD,B1_DESC, D3_TIPO, D3_EMISSAO, D3_QUANT, D3_UM, D3_QTSEGUM, D3_SEGUM, B1_XENROLL "
	cQuery += "ORDER BY D3_EMISSAO,D3_COD "


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


		cCodproduto 	:= cAlias->D3_GRUPO

		IncProc("Imprimindo Estados"+alltrim(cAlias->BM_DESC)) 
		//imprimo a primeira se็ใo				
		oSection1:Cell("D3_GRUPO"):SetValue(cAlias->D3_GRUPO)
		oSection1:Cell("BM_DESC"):SetValue(cAlias->BM_DESC)
		//	oSection1:Cell("C2_XNOME"):SetValue(cAlias->C2_XNOME)       			
		oSection1:Printline()


		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 		
		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->D3_GRUPO == cCodproduto
			oReport:IncMeter()		                                

			IncProc("Imprimindo Produtos "+alltrim(cAlias->D3_COD))
			oSection2:Cell("D3_GRUPO"):SetValue(cAlias->D3_GRUPO)
			oSection2:Cell("BM_DESC"):SetValue(cAlias->BM_DESC)
			oSection2:Cell("D3_COD"):SetValue(cAlias->D3_COD)
			oSection2:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)
			oSection2:Cell("D3_TIPO"):SetValue(cAlias->D3_TIPO)
			oSection2:Cell("D3_EMISSAO"):SetValue(stod(cAlias->D3_EMISSAO))
			oSection2:Cell("D3_QUANT"):SetValue(cAlias->D3_QUANT)
			oSection2:Cell("D3_UM"):SetValue(cAlias->D3_UM)
			oSection2:Cell("D3_QTSEGUM"):SetValue(cAlias->D3_QTSEGUM)  
			oSection2:Cell("D3_SEGUM"):SetValue(cAlias->D3_SEGUM) 
			oSection2:Cell("B1_XENROLL"):SetValue(cAlias->B1_XENROLL) 
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


	u_InPutSX1(cPerg,"01",PADR("Emissใo De  ?    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้ ?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Codigo De  ?     ",20)+"","","","mv_ch3","C",14,0,0,"G","","SB1","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Codigo At้ ?     ",20)+"","","","mv_ch4","C",14,0,0,"G","","SB1","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("Grupo De  ?    ",20)+"","","","mv_ch5","C",4,0,0,"G","","","SBM","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Grupo At้ ?    ",20)+"","","","mv_ch6","C",4,0,0,"G","","","SBM","","mv_par06") 
	u_InPutSX1(cPerg,"07",PADR("C.Custo De  ?     ",20)+"","","","mv_ch7","C",2,0,0,"G","","CC2","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("C.Custo At้ ?     ",20)+"","","","mv_ch8","C",2,0,0,"G","","CC2","","","mv_par08") 

Return