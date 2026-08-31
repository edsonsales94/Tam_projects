#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR12   บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Entrada X Saida Do Estoque						        	   			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR12()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR12",10)

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


	oReport := TReport():New(cNOME,"Entrada X Saida Do Estoque",cNOME,{|oReport| ReportPrint(oReport)},"Entrada X Saida Do Estoque")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Ordem de produ็ใo", {"SC2"}, , .F., .T.)
	TRCell():New(oSection1,"C2_NUM"		   ,"cAlias","Num.Op",,8)
	TRCell():New(oSection1,"C2_PRODUTO"	   ,"cAlias","Cod.Produto",,14) 
	TRCell():New(oSection1,"B1_DESC"	   ,"cAlias","Descri็ใo do produto",,50)
	TRCell():New(oSection1,"C2_EMISSAO"	   ,"cAlias","DT.Emissใo",,13)
	TRCell():New(oSection1,"C2_QUANT"	   ,"cAlias","Quantidade","@E 9,999,999,999",13) 
	TRCell():New(oSection1,"C2_QUJE"	   ,"cAlias","QTD.Apontada","@E 9,999,999,999",20)  
	TRCell():New(oSection1,"FALTA"		   ,"cAlias","QTD.Pendente","@E 9,999,999,999",20)
	TRCell():New(oSection1,"C2_DATRF"	   ,"cAlias","DT.Fechamento",,13)
	//	TRCell():New(oSection1,"C2_XNOME"	   ,"cAlias","Nome do Cliente",,50)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Etiquetas", {"SZ4"}, NIL, .F., .T.)
	TRCell():New(oSection2,"Z4_FILIAL"	    		,"cAlias","Filial",,)
	TRCell():New(oSection2,"Z4_CPRODUC"		    	,"cAlias","Etiqueta",,20)    
	TRCell():New(oSection2,"Z4_NUMERO"				,"cAlias","Quantidade",/*Mascara*/,) 
	TRCell():New(oSection2,"IMPRESSAO"	    		,"cAlias","Impressใo",,10)
	TRCell():New(oSection2,"ESTOQUE"		    	,"cAlias","Entrada",,)    
	TRCell():New(oSection2,"SAIDA"					,"cAlias","Saida",/*Mascara*/,6)
	TRCell():New(oSection2,"Z1_DTAPONT"				,"cAlias","DT.Entrada",/*Mascara*/,12) 
	TRCell():New(oSection2,"Z1_HRAPONT"				,"cAlias","Hora da Entrada",/*Mascara*/,12) 
	TRCell():New(oSection2,"SAI_NOME"				,"cAlias","Saida para o Cliente",/*Mascara*/,50) 
	TRCell():New(oSection2,"SAI_DOC"				,"cAlias","DOCUMENTO",/*Mascara*/,)
	TRCell():New(oSection2,"SAI_SERIE"				,"cAlias","SERIE",/*Mascara*/,)                  
	TRCell():New(oSection2,"SAI_DTEXP"				,"cAlias","DT.Saida",/*Mascara*/,12)
	TRCell():New(oSection2,"SAI_DTHORA"				,"cAlias","Hora da Saida",/*Mascara*/,15)

	//Quebra por Se็ใo


	oBreak := TRBreak():New(oSection2,oSection2:Cell("Z4_NUMERO"),"TOTAL") 

	TRFunction():New(oSection2:Cell("Z4_NUMERO"),"Total","SUM",oBreak,,,,.F.,.F.)

	//Fim Quebra por Se็ใo                                                       


	//Totalizador final
	TRFunction():New(oSection2:Cell("Z4_NUMERO"),"QUANTIDADE TOTAL","SUM", ,,"@E 9,999,999,999",,.F.,.T.)



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


	cQuery := "SELECT C2_NUM,C2_PRODUTO,B1_DESC,C2_QUANT,C2_QUJE,(C2_QUANT - C2_QUJE) FALTA,SAI_NOME,C2_XCARGA,C2_DATRF,Z4_FILIAL,Z4_CPRODUC,Z1_OP,C2_EMISSAO,Z4_NUMERO,ISNULL(Z1_DTAPONT,'') Z1_DTAPONT,ISNULL(SAI_DTHORA,'')SAI_DTHORA,ISNULL(Z1_HRAPONT,'')Z1_HRAPONT, "



	cQuery += " CASE WHEN Z4_CPRODUC= ISNULL(Z4_CPRODUC,'') THEN 'SIM'"
	cQuery += " ELSE 'NAO' END IMPRESSAO,"
	cQuery += " CASE WHEN Z1_OP=ISNULL(Z1_OP,'') THEN 'SIM'"
	cQuery += " ELSE 'NAO' END ESTOQUE,"
	cQuery += " CASE WHEN SAI_CPRODUC=ISNULL(SAI_CPRODUC,'') THEN 'SIM'"
	cQuery += " ELSE 'NAO' END SAIDA,"
	cQuery += " ISNULL(SAI_NOME,'') SAI_NOME, ISNULL(SAI_DTEXP,''), ISNULL(SAI_DOC,'') SAI_DOC,ISNULL(SAI_SERIE,'')SAI_SERIE, ISNULL(SAI_DTEXP,'') SAI_DTEXP " 

	cQuery += " FROM "+RETSQLNAME("SZ4")+" SZ4 (NOLOCK)"
	cQuery += " INNER JOIN "+RETSQLNAME("SC2")+" SC2(NOLOCK) ON C2_NUM = SUBSTRING(Z4_CPRODUC,1,6) AND SUBSTRING(Z4_CEXPEDI,1,15) = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''"
	cQuery += " LEFT JOIN  "+RETSQLNAME("SZ1")+" SZ1(NOLOCK)  ON Z4_CPRODUC = Z1_OP+Z1_CHASSIS AND SZ1.D_E_L_E_T_ = ''"
	cQuery += " LEFT JOIN SAI (NOLOCK)		  ON Z4_CPRODUC = SAI_CPRODUC"
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK)ON B1_COD = C2_PRODUTO"
	cQuery += " WHERE "
	cQuery += " C2_LOCAL = '20'"
	cQuery += " AND C2_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "  
	cQuery += " AND Z1_DTAPONT BETWEEN '"+DToS(mv_par03)+"' AND '"+DToS(mv_par04)+"' "  
	cQuery += " AND C2_PRODUTO BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " AND SZ4.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY C2_NUM,C2_PRODUTO,B1_DESC,C2_QUANT,C2_QUJE,C2_XCARGA,C2_DATRF,Z4_FILIAL,Z4_CPRODUC,Z1_OP,SAI_CPRODUC,SAI_NOME,C2_EMISSAO,Z4_NUMERO,SAI_DTEXP,SAI_DOC,SAI_SERIE,Z1_DTAPONT,SAI_DTHORA,Z1_HRAPONT"
	cQuery += " ORDER BY C2_PRODUTO,Z4_CPRODUC"



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


		cCodproduto 	:= cAlias->C2_NUM

		IncProc("Imprimindo Ordem de produ็ใo"+alltrim(cAlias->C2_NUM)) 

		//imprimo a primeira se็ใo				
		oSection1:Cell("C2_NUM"):SetValue(cAlias->C2_NUM)
		oSection1:Cell("C2_PRODUTO"):SetValue(cAlias->C2_PRODUTO)
		oSection1:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)
		oSection1:Cell("C2_EMISSAO"):SetValue(STOD(cAlias->C2_EMISSAO))
		oSection1:Cell("C2_QUANT"):SetValue(cAlias->C2_QUANT)
		oSection1:Cell("C2_QUJE"):SetValue(cAlias->C2_QUJE)
		oSection1:Cell("FALTA"):SetValue(cAlias->FALTA) 
		oSection1:Cell("C2_DATRF"):SetValue(StoD(cAlias->C2_DATRF))
		//	oSection1:Cell("C2_XNOME"):SetValue(cAlias->C2_XNOME)       			
		oSection1:Printline()


		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->C2_NUM == cCodproduto
			oReport:IncMeter()		                                

			IncProc("Imprimindo ETIQUETAS"+alltrim(cAlias->Z4_CPRODUC))
			oSection2:Cell("Z4_FILIAL"):SetValue(cAlias->Z4_FILIAL)
			oSection2:Cell("Z4_CPRODUC"):SetValue(cAlias->Z4_CPRODUC)
			oSection2:Cell("Z4_NUMERO"):SetValue(cAlias->Z4_NUMERO)
			oSection2:Cell("IMPRESSAO"):SetValue(cAlias->IMPRESSAO)
			oSection2:Cell("ESTOQUE"):SetValue(cAlias->ESTOQUE)
			oSection2:Cell("SAIDA"):SetValue(cAlias->SAIDA)
			oSection2:Cell("SAI_NOME"):SetValue(cAlias->SAI_NOME)  
			oSection2:Cell("SAI_DOC"):SetValue(cAlias->SAI_DOC)  
			oSection2:Cell("SAI_SERIE"):SetValue(cAlias->SAI_SERIE)  
			oSection2:Cell("SAI_DTEXP"):SetValue(cAlias->SAI_DTEXP)
			oSection2:Cell("Z1_DTAPONT"):SetValue(SToD(cAlias->Z1_DTAPONT))
			oSection2:Cell("SAI_DTHORA"):SetValue(cAlias->SAI_DTHORA)
			oSection2:Cell("Z1_HRAPONT"):SetValue(cAlias->Z1_HRAPONT)
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

	u_InPutSX1(cPerg,"01",PADR("OP De  ?    	 ",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("OP At้ ?    	 ",20)+"","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Emissใo Apt De  ?    ",20)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Emissใo Apt At้ ?    ",20)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("Produto De  ?    ",20)+"","","","mv_ch5","C",14,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Produto At้ ?    ",20)+"","","","mv_ch6","C",14,0,0,"G","","","","","mv_par06")


Return