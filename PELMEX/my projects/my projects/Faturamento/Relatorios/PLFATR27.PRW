#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR21    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de comissใo representante por titutlos baixados    			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



User Function PLFATR27()
	Local oReport := nil
	Local cPerg:= Padr("PLFATR27",10)

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


	oReport := TReport():New(cNOME,"Relat๓rio de comissใo representante por titutlos baixados  ",cNOME,{|oReport| ReportPrint(oReport)},"Comissใo")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Vendedor", {"SE1"}, , .F., .T.)
	TRCell():New(oSection1,"E1_VEND1"		   	,"cAlias","Cod.Vend","@!",17)
	TRCell():New(oSection1,"A3_NOME"	   	    ,"cAlias","Vendedor",,50)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Titulos Baixados", {"SE1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"E1_NUM"	    				,"cAlias","Numero do Titulo",,)
	TRCell():New(oSection2,"E1_PREFIXO"			    	,"cAlias","Prefixo",,4)
	TRCell():New(oSection2,"E1_PARCELA"					,"cAlias","Parcela","@E ",) 
	TRCell():New(oSection2,"E1_TIPO"					,"cAlias","Tipo","@E ",) 

	TRCell():New(oSection2,"E1_CLIENTE"					,"cAlias","Cod.Cli",/*Mascara*/,)
	TRCell():New(oSection2,"E1_NOMCLI"					,"cAlias","Nome Reduzido",/*Mascara*/,)
	TRCell():New(oSection2,"E1_EMISSAO"					,"cAlias","Emissใo",/*Mascara*/,)
	TRCell():New(oSection2,"E1_VENCTO"					,"cAlias","Vencimento",/*Mascara*/,)
	TRCell():New(oSection2,"E1_VALOR"					,"cAlias","Valor","@E 9,999,999,999.99",13)
	TRCell():New(oSection2,"VLRCOMIS"					,"cAlias","Comissใo","@E 9,999,999,999.99",13)
	TRCell():New(oSection2,"E1_SALDO"					,"cAlias","Saldo","@E 9,999,999,999.99",13)
	TRCell():New(oSection2,"E1_BAIXA"					,"cAlias","Dt.Baixa",,13)


	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("E1_VEND1"),"Total por Vendedor") 
	TRFunction():New(oSection2:Cell("E1_VALOR"),"Valor","SUM",oBreak,,,,.F.,.F.)      
	TRFunction():New(oSection2:Cell("VLRCOMIS"),"Comissใo","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Se็ใo

	//Totalizador final
	TRFunction():New(oSection2:Cell("E1_VALOR"),"Total Geral","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection2:Cell("VLRCOMIS"),"Comissใo Geral","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)




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

	cQuery := "	SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_NOMCLI, E1_EMISSAO,E1_VENCTO,E1_VALOR,(E1_VALOR*5/100) VLRCOMIS,E1_SALDO,E1_BAIXA,E1_VEND1,A3_NOME"
	cQuery += "	FROM "+RETSQLNAME("SE1")+" SE1 (NOLOCK)  "
	cQuery += "	INNER JOIN "+RETSQLNAME("SA3")+" (NOLOCK)  SA3 ON A3_COD = E1_VEND1 "
	cQuery += " 	WHERE E1_VEND1 BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += "	AND E1_VENCTO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' "
	cQuery += "	AND E1_BAIXA BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' "
	cQuery += "	AND E1_SALDO  = 0 "
	cQuery += "	AND SE1.D_E_L_E_T_ = ''"
	cQuery += "	AND A3_TIPO = 'E'"
	cQuery += "	ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"






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

		cCodproduto 	:= cAlias->E1_VEND1

		IncProc("Imprimindo Vendedores"+alltrim(cAlias->E1_VEND1))

		//imprimo a primeira se็ใo				
		oSection1:Cell("E1_VEND1"):SetValue(cAlias->E1_VEND1)
		oSection1:Cell("A3_NOME"):SetValue(cAlias->A3_NOME)      			
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->E1_VEND1 == cCodproduto
			oReport:IncMeter()		                                

			IncProc("Imprimindo Titulos"+alltrim(cAlias->E1_NUM))
			oSection2:Cell("E1_NUM"):SetValue(cAlias->E1_NUM)
			oSection2:Cell("E1_PREFIXO"):SetValue(cAlias->E1_PREFIXO)
			oSection2:Cell("E1_PARCELA"):SetValue(cAlias->E1_PARCELA)
			oSection2:Cell("E1_TIPO"):SetValue(cAlias->E1_TIPO)			
			oSection2:Cell("E1_CLIENTE"):SetValue(cAlias->E1_CLIENTE)
			oSection2:Cell("E1_NOMCLI"):SetValue(cAlias->E1_NOMCLI)			
			oSection2:Cell("E1_EMISSAO"):SetValue(STOD(cAlias->E1_EMISSAO))
			oSection2:Cell("E1_VENCTO"):SetValue(STOD(cAlias->E1_VENCTO))
			oSection2:Cell("E1_VALOR"):SetValue(cAlias->E1_VALOR)
			oSection2:Cell("VLRCOMIS"):SetValue(cAlias->VLRCOMIS)
			oSection2:Cell("E1_SALDO"):SetValue(cAlias->E1_SALDO)
			oSection2:Cell("E1_BAIXA"):SetValue(STOD(cAlias->E1_BAIXA))


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
	u_InPutSX1(cPerg,"01",PADR("Dt de Entrega De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Dt de Entrega At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
Return