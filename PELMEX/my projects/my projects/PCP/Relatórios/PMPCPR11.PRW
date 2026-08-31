#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Custo de produto							        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR11()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR11",10)

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


	oReport := TReport():New(cNOME,"Relat๓rio Entrada no Estoque",cNOME,{|oReport| ReportPrint(oReport)},"Entrada no Estoque")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo


	oSection1:= TRSection():New(oReport, "Ordem de produ็ใo", {"SC2"}, , .F., .T.)
	TRCell():New(oSection1,"C2_NUM"		   ,"cAlias","Numero da Op","@!",8)
	TRCell():New(oSection1,"C2_PRODUTO"	   ,"cAlias","Codigo do produto",,14) 
	TRCell():New(oSection1,"B1_DESC"	   ,"cAlias","Descri็ใo do produto",,50)
	TRCell():New(oSection1,"C2_EMISSAO"	   ,"cAlias","DT.Emissใo",,)
	TRCell():New(oSection1,"PENDENTE"	   ,"cAlias","QTD Pendente",,)
	TRCell():New(oSection1,"SITUACAO"	   ,"cAlias","Status",,50)
	TRCell():New(oSection1,"C2_XNOME"	   ,"cAlias","Nome do Cliente",,50)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Etiquetas", {"SZ1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"Z1_FILIAL"	    		,"cAlias","Filial",,)
	TRCell():New(oSection2,"ETIQUETA"		    	,"cAlias","Etiqueta",,50)
	TRCell():New(oSection2,"Z1_DTAPONT"				,"cAlias","DT. Entrada",/*Mascara*/,)    
	TRCell():New(oSection2,"Z1_HRAPONT"				,"cAlias","Hora da Entrada",/*Mascara*/,)
	TRCell():New(oSection2,"Z1_USER"				,"cAlias","Usuแrio",,)  
	//Quebra por Se็ใo

	oBreak := TRBreak():New(oSection1,oSection1:Cell("C2_NUM"),"QUANTITADE PENDENTE DE ENTRADA") 
	TRFunction():New(oSection1:Cell("PENDENTE"),"Total ","SUM",oBreak,,,,.F.,.F.) 
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection1:Cell("PENDENTE"),"QUANTIDADE TOTAL PENDENTE DE ENTRADA","SUM",,,"@E 9,999,999,999",,.F.,.T.)




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


	cQuery := " SELECT Z1_FILIAL,Z1_OP,C2_NUM,C2_PRODUTO,B1_DESC,Z1_OP+Z1_CHASSIS ETIQUETA,C2_EMISSAO,Z1_DTAPONT,(C2_QUANT - C2_QUJE) PENDENTE,   "
	cQuery += " CASE WHEN (C2_QUJE<C2_QUANT) THEN 'PENDENTE DE APONTAMENTO'  "
	cQuery += " ELSE 'APONTAMENTO FINALIZADO' END SITUACAO,  "
	cQuery += " C2_XNOME, Z1_HRAPONT, Z1_USER "

	cQuery += " FROM "+RETSQLNAME("SZ1")+" SZ1 (NOLOCK) "
	cQuery += " INNER JOIN "+RETSQLNAME("SC2")+" SC2 (NOLOCK)  ON C2_NUM = SUBSTRING(Z1_OP,1,6) AND SC2.D_E_L_E_T_ =''   "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK) ON  B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ =''  "
	cQuery += " WHERE "
	cQuery += " SZ1.D_E_L_E_T_ = '' "
	cQuery += " AND C2_NUM BETWEEN  '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND C2_PRODUTO BETWEEN  '"+mv_par05+"' AND '"+mv_par06+"' "    
	cQuery += " AND Z1_DTAPONT BETWEEN '"+DToS(mv_par03)+"' AND '"+DToS(mv_par04)+"' "  

	cQuery += " ORDER BY 3 "

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

		IncProc("Imprimindo Ordem de produ็ใo"+alltrim(cAlias->C2_NUM))

		//imprimo a primeira se็ใo				
		oSection1:Cell("C2_NUM"):SetValue(cAlias->C2_NUM)
		oSection1:Cell("C2_PRODUTO"):SetValue(cAlias->C2_PRODUTO)
		oSection1:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)
		oSection1:Cell("C2_EMISSAO"):SetValue(STOD(cAlias->C2_EMISSAO))
		oSection1:Cell("PENDENTE"):SetValue(cAlias->PENDENTE)
		oSection1:Cell("SITUACAO"):SetValue(cAlias->SITUACAO)
		oSection1:Cell("C2_XNOME"):SetValue(cAlias->C2_XNOME)       			
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->C2_PRODUTO == cCodproduto
			oReport:IncMeter()		                                


			IncProc("Imprimindo ETIQUETAS"+alltrim(cAlias->ETIQUETA))
			oSection2:Cell("Z1_FILIAL"):SetValue(cAlias->Z1_FILIAL)
			oSection2:Cell("ETIQUETA"):SetValue(cAlias->ETIQUETA)
			oSection2:Cell("Z1_DTAPONT"):SetValue(STOD(cAlias->Z1_DTAPONT))
			oSection2:Cell("Z1_HRAPONT"):SetValue(cAlias->Z1_HRAPONT)			
			oSection2:Cell("Z1_USER"):SetValue(cAlias->Z1_USER)		

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

	u_InPutSX1(cPerg,"01",PADR("OP De  ?    ",20)+"","","","mv_ch1","C",6,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("OP At้ ?    ",20)+"","","","mv_ch2","C",6,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("DT Apontamento De    ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("DT Apontamento At้   ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Produto De  ?    ",20)+"","","","mv_ch5","C",16,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Produto At้ ?    ",20)+"","","","mv_ch6","C",16,0,0,"G","","","","","mv_par06") 

Return