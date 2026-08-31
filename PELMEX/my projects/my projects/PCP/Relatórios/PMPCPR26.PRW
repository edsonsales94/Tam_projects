#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR26   บAutor  ณStan Lee Lopes	    				บ Data ณ  09/12/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Etiquetas sem Saida									        	   		 ฑ
ฑฑบ          ณ  											                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR26()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR26",10)

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
	//	Local oBreak
	Local oFunction


	oReport := TReport():New(cNOME,"Etiquetas sem Saida",cNOME,{|oReport| ReportPrint(oReport)},"Etiquetas sem Saida")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo

	oSection1:= TRSection():New(oReport, "Produto", {"SB1"}, , .F., .T.)
	TRCell():New(oSection1,"C2_PRODUTO"		   ,"cAlias","Cod.Produto",,)
	TRCell():New(oSection1,"B1_DESC"   		   ,"cAlias","Descri็ใo",,)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Etiqueta", {"SZ1"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"C2_PRODUTO"		   		,"cAlias","Cod.Produto",,0)
	TRCell():New(oSection2,"Z4_CPRODUC"	    		,"cAlias","Componente",,)
	TRCell():New(oSection2,"Z1_CPRODUC"		    	,"cAlias","Descri็ใo",,20)    
	TRCell():New(oSection2,"SAI_CPRODUC"			,"cAlias","Saida",/*Mascara*/,) 
	TRCell():New(oSection2,"ENTRADA"		    	,"cAlias","Dt.Entrada",,)    
	TRCell():New(oSection2,"C2_DATRF"				,"cAlias","Dt.Apontamento",/*Mascara*/,6)

	//Quebra por Se็ใo



	//oBreak := TRBreak():New(oSection2,oSection1:Cell("C2_PRODUTO"),"TOTAL") 
	//TRFunction():New(oSection2:Cell("Z4_CPRODUC"),"Total","SUM",oBreak,,,,.F.,.F.)
	// 	TRFunction():New(oSection2:Cell("G1_TOTAL"),"Total","SUM",oBreak,,,,.F.,.F.)


	//Fim Quebra por Se็ใo                                                       


	//Totalizador final
	//TRFunction():New(oSection2:Cell("Z4_CPRODUC"),"Quantidade","SUM", ,,"@E 9,999,999,999.9999",,.F.,.T.)
	//  	TRFunction():New(oSection2:Cell("G1_TOTAL"),"Total Gasto","SUM", ,,"@E 9,999,999,999.9999",,.F.,.T.)



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




	cQuery := "SELECT SUBSTRING(Z4_CEXPEDI,1,15)C2_PRODUTO, "
	cQuery += "           B1_DESC, "
	cQuery += "    	   Z4_CPRODUC, "
	cQuery += "           CASE WHEN Z1_OP+Z1_CHASSIS IS NULL THEN 'EM PRODUวรO' ELSE Z1_OP+Z1_CHASSIS END Z1_CPRODUC, "
	cQuery += "    	   CASE WHEN SAI_CPRODUC IS NULL THEN 'SEM SAอDA NA EXPEDIวรO' ELSE SAI_CPRODUC END SAI_CPRODUC,SAI_PROCESS,SAI_DOC,SAI_DTEXP,CONVERT(VARCHAR,CAST(Z1_DTAPONT AS DATE),103) ENTRADA, "
	cQuery += "    	   CASE WHEN C2_DATRF = '' THEN 'ORDEM NรO FINALIZADA' ELSE CONVERT(VARCHAR,CAST(C2_DATRF AS DATE),103) END " 
	cQuery += "    	   C2_DATRF "
	cQuery += "    FROM "+RetSQLName("SZ4")+" SZ4 (NOLOCK) "
	cQuery += "    LEFT JOIN "+RetSQLName("SZ1")+" SZ1 (NOLOCK) ON Z4_CPRODUC = Z1_OP+Z1_CHASSIS AND SZ1.D_E_L_E_T_ = '' "
	cQuery += "    LEFT JOIN SAI (NOLOCK) ON Z4_CPRODUC = SAI_CPRODUC "
	cQuery += "    LEFT JOIN "+RetSQLName("SC2")+" SC2 (NOLOCK) ON SUBSTRING(Z4_CPRODUC,1,6) = C2_NUM AND SC2.D_E_L_E_T_ = '' "
	cQuery += "    INNER JOIN "+RetSQLName("SB1")+" SB1 (NOLOCK) ON SUBSTRING(Z4_CEXPEDI,1,15) = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += "    WHERE SUBSTRING(Z4_CPRODUC,1,11) IN( "
	cQuery += "    SELECT C2_NUM+C2_ITEM+C2_SEQUEN "
	cQuery += "    FROM "+RetSQLName("SC2")+" SC2 (NOLOCK) "
	cQuery += "    WHERE SC2.D_E_L_E_T_ = '' "
	cQuery += "    AND C2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	cQuery += "    AND C2_PRODUTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "    ) "
	cQuery += "    AND SAI_CPRODUC IS NULL "
	cQuery += "    AND B1_TIPO = 'PA' "

	cQuery += "    AND Z1_CHASSIS IS NOT NULL " 

	cQuery += "    ORDER BY 1,3 " 





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


		cCodproduto 	:= cAlias->C2_PRODUTO

		IncProc("Imprimindo Produto"+alltrim(cAlias->C2_PRODUTO)) 
		//imprimo a primeira se็ใo				
		oSection1:Cell("C2_PRODUTO"):SetValue(cAlias->C2_PRODUTO)
		oSection1:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)

		oSection1:Printline()


		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->C2_PRODUTO == cCodproduto
			oReport:IncMeter()		                                


			IncProc("Imprimindo Etiquetas"+alltrim(cAlias->Z4_CPRODUC))
			oSection2:Cell("Z4_CPRODUC"):SetValue(cAlias->Z4_CPRODUC)
			oSection2:Cell("Z1_CPRODUC"):SetValue(cAlias->Z1_CPRODUC)
			oSection2:Cell("SAI_CPRODUC"):SetValue(cAlias->SAI_CPRODUC)
			oSection2:Cell("ENTRADA"):SetValue(cAlias->ENTRADA)
			oSection2:Cell("C2_DATRF"):SetValue(STOD(cAlias->C2_DATRF))





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

	u_InPutSX1(cPerg,"01",PADR("Emissใo de  ?    ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้ ?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03","Produto De?		 ","", "", "mv_ch3","C",15,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04","Produto Ate?		 ","", "", "mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	//u_InPutSX1(cPerg,"05",PADR("SITUAวีES?    ",20)+"","","","mv_ch5","c",1,0,0,"G","","","","","mv_par05")


Return