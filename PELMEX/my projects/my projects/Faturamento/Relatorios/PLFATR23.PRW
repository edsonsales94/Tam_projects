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


User Function PLFATR23()
	Local oReport := nil
	Local cPerg:= Padr("PLFATR23",10)

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


	oReport := TReport():New(cNOME,"Vendas X Financeiro",cNOME,{|oReport| ReportPrint(oReport)},"Vendas X Financeiro")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo

	//TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,A1_COD,A1_NOME,A3_NOME

	//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,



	oSection1:= TRSection():New(oReport, "Vendas", {"SL1"}, , .F., .T.)
	TRCell():New(oSection1,"M0_CODFIL"	   	   ,"cAlias","Cod.Filial",,10)
	TRCell():New(oSection1,"M0_FILIAL"	   	   ,"cAlias","Loja",,50)  
	TRCell():New(oSection1,"L1_NUM"	   	   	   ,"cAlias","Num.Or็amento",,)
	TRCell():New(oSection1,"C6_NUM"	   	   	   ,"cAlias","Num.Pedido",,)
	TRCell():New(oSection1,"C6_NOTA"	  	   ,"cAlias","Nota",,13)
	TRCell():New(oSection1,"C6_SERIE"	   	   ,"cAlias","Serie",,50)  
	TRCell():New(oSection1,"C6_DATFAT"	   	   ,"cAlias","Dt.Faturamento",,50)
	TRCell():New(oSection1,"A1_COD"	   		   ,"cAlias","Cod.Cliente",,50)  
	TRCell():New(oSection1,"A1_NOME"		   ,"cAlias","Nome Cliente",,10)
	TRCell():New(oSection1,"A3_NOME"	   	   ,"cAlias","Nome Vendedor",,50)    
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas



	oSection2:= TRSection():New(oReport, "Financeiro", {"SE1"}, NIL, .F., .T.)

	TRCell():New(oSection2,"E1_NUM"	   	   	   ,"cAlias","Titulo",,10)
	TRCell():New(oSection2,"E1_PREFIXO"	   	   ,"cAlias","Prefixo",,8)  
	TRCell():New(oSection2,"E1_NSUTEF"	   	   ,"cAlias","NSUTEF",,15)
	TRCell():New(oSection2,"E1_TIPO"	   	   ,"cAlias","Tipo",,5)
	TRCell():New(oSection2,"E1_PARCELA"	  	   ,"cAlias","Parcela",,10)
	TRCell():New(oSection2,"E1_BASCOM1"	   	   ,"cAlias","Valor Bruto","@E 9,999,999,999.99",15)  
	TRCell():New(oSection2,"E1_VALOR"	   	   ,"cAlias","Valor Liquido","@E 9,999,999,999.99",15)
	TRCell():New(oSection2,"E1_EMISSAO"	   	   ,"cAlias","Dt.Emissใo",,15)  
	TRCell():New(oSection2,"E1_VENCTO"		   ,"cAlias","Dt.Vencimento",,15)
	TRCell():New(oSection2,"E1_BAIXA"	   	   ,"cAlias","Dt.Baixa",,15)
	TRCell():New(oSection2,"E1_SALDO"	   	   ,"cAlias","Saldo","@E 9,999,999,999.99",15)

	oBreak := TRBreak():New(oSection2,oSection1:Cell("C6_NOTA"),"Total") 
	TRFunction():New(oSection2:Cell("E1_BASCOM1"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.) 
	TRFunction():New(oSection2:Cell("E1_VALOR"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)   
	TRFunction():New(oSection2:Cell("E1_SALDO"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)

	//Fim Quebra por Se็ใo

	//Totalizador final
	//TRFunction():New(oSection2:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 
	//TRFunction():New(oSection2:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

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


	cQuery += "	SELECT TB1.M0_CODFIL,"
	cQuery += "	       M0_FILIAL,"
	cQuery += "		   TB1.L1_NUM,"
	cQuery += "	       TB1.C6_NUM,"
	cQuery += "		   TB1.C6_NOTA,"
	cQuery += "	       TB1.C6_SERIE,"
	cQuery += "		   TB1.C6_DATFAT,"
	cQuery += "	       TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,"
	cQuery += "		   A1_COD,"
	cQuery += "		   A1_NOME,"
	cQuery += "		   ISNULL(A3_NOME,'SEM VENDEDOR') A3_NOME"
	cQuery += "	FROM("
	cQuery += "	SELECT CASE WHEN ISNULL(TB.M0_CODFIL,'') = '' THEN SD2.D2_FILIAL ELSE TB.M0_CODFIL END M0_CODFIL,"
	cQuery += "	       CASE WHEN ISNULL(TB.M0_CODFIL,'') = '' THEN SM1.M0_FILIAL ELSE TB.M0_FILIAL END M0_FILIAL,"
	cQuery += "		   CASE WHEN ISNULL(TB.L1_NUM,'') = '' THEN '' ELSE TB.L1_NUM END L1_NUM,"
	cQuery += "	       CASE WHEN ISNULL(TB.C6_NUM,'') = '' THEN D2_PEDIDO ELSE TB.C6_NUM END C6_NUM,"
	cQuery += "		   CASE WHEN ISNULL(TB.C6_NOTA,'') = '' THEN D2_DOC ELSE TB.C6_NOTA END C6_NOTA,"
	cQuery += "	       CASE WHEN ISNULL(TB.C6_SERIE,'') = '' THEN D2_SERIE ELSE TB.C6_SERIE END C6_SERIE,"
	cQuery += "		   CASE WHEN ISNULL(TB.C6_DATFAT,'') = '' THEN  D2_EMISSAO ELSE TB.C6_DATFAT END C6_DATFAT,"
	cQuery += "	       CASE WHEN ISNULL(TB.E1_NUM,'') = '' THEN '' ELSE TB.E1_NUM END E1_NUM,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_PREFIXO,'') = '' THEN '' ELSE TB.E1_PREFIXO END E1_PREFIXO,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_NSUTEF,'') = '' THEN '' ELSE TB.E1_NSUTEF END E1_NSUTEF,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_TIPO,'') = '' THEN '' ELSE TB.E1_TIPO END E1_TIPO,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_PARCELA,'') = '' THEN '' ELSE TB.E1_PARCELA END E1_PARCELA,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_BASCOM1,'') = '' THEN '' ELSE TB.E1_BASCOM1 END E1_BASCOM1,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_VALOR,'') = '' THEN '' ELSE TB.E1_VALOR END E1_VALOR,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_EMISSAO,'') = '' THEN '' ELSE TB.E1_EMISSAO END E1_EMISSAO,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_VENCTO,'') = '' THEN '' ELSE TB.E1_VENCTO END E1_VENCTO,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_BAIXA,'') = '' THEN '' ELSE TB.E1_BAIXA END E1_BAIXA,"
	cQuery += "		   CASE WHEN ISNULL(TB.E1_SALDO,'') = '' THEN '' ELSE TB.E1_SALDO END E1_SALDO,"
	cQuery += "		   CASE WHEN ISNULL(TB.A1_COD,'') = '' THEN SD2.D2_CLIENTE ELSE TB.A1_COD END A1_COD,"
	cQuery += "		   CASE WHEN ISNULL(TB.A1_LOJA,'') = '' THEN SD2.D2_LOJA ELSE TB.A1_LOJA END A1_LOJA,"
	cQuery += "		   CASE WHEN ISNULL(TB.A1_NOME,'') = '' THEN SA11.A1_NOME ELSE TB.A1_NOME END A1_NOME,"
	cQuery += "		   CASE WHEN ISNULL(TB.A3_NOME,'') = '' THEN SA31.A3_NOME ELSE TB.A3_NOME END A3_NOME "
	cQuery += "	FROM"
	cQuery += "	(SELECT SM.M0_CODFIL,SM.M0_FILIAL,SLE.L1_NUM,"
	cQuery += "	       CASE WHEN ISNULL(C6_NUM,'') = '' THEN CASE WHEN ISNULL(SL11.L1_PEDRES,'') != '' THEN SL11.L1_PEDRES ELSE SLE.L1_NUM END ELSE C6_NUM END C6_NUM,"
	cQuery += "		   CASE WHEN ISNULL(SLE.L1_DOC,'') = '' THEN CASE WHEN ISNULL(C6_NOTA,'') = '' THEN SL11.L1_DOC ELSE C6_NOTA END ELSE SLE.L1_DOC END C6_NOTA,"
	cQuery += "	       CASE WHEN ISNULL(SLE.L1_SERIE,'') = '' THEN CASE WHEN ISNULL(C6_SERIE,'') = '' THEN SL11.L1_SERIE ELSE C6_SERIE END ELSE SLE.L1_SERIE END C6_SERIE,"
	cQuery += "		   CASE WHEN ISNULL(C6_NOTA,'') = '' THEN CASE WHEN ISNULL(SL11.L1_PEDRES,'') = '' THEN SL11.L1_EMISNF ELSE '' END ELSE C6_DATFAT END C6_DATFAT,		  "
	cQuery += "	       E1_NUM,E1_PREFIXO,E1_NSUTEF,E1_TIPO,E1_PARCELA,E1_BASCOM1,E1_VALOR,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_SALDO,SA1.A1_COD,SA1.A1_LOJA,SA1.A1_NOME,SA3.A3_NOME"
	cQuery += "	FROM("
	cQuery += "	SELECT L1_FILIAL,L1_NUM,L1_FILRES,L1_ORCRES,L1_DOC,L1_DOCPED,E1_NUM,E1_PREFIXO,E1_NSUTEF,L1_SERIE,L1_SERPED,L1_CLIENTE,L1_LOJA,E1_TIPO,E1_PARCELA,E1_BASCOM1,E1_VALOR,E1_EMISSAO,E1_BAIXA,E1_SALDO,E1_VENCTO,L1_VEND,L1_PEDRES"
	cQuery += "	FROM "+RETSQLNAME("SL1")+" SL1 (NOLOCK)"
	cQuery += "	INNER JOIN "+RETSQLNAME("SE1")+" SE1 (NOLOCK) ON SL1.L1_DOCPED = SE1.E1_NUM AND SL1.L1_SERPED = SE1.E1_PREFIXO AND SL1.L1_DOCPED != '' AND SL1.D_E_L_E_T_ = '' AND SE1.D_E_L_E_T_ = ''"
	cQuery += "	WHERE L1_CLIENTE BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "
	cQuery += "	AND E1_EMISSAO BETWEEN '"+DToS(mv_par02)+"' AND '"+DToS(mv_par03)+"'   "
	cQuery += "	AND E1_VENCTO BETWEEN  '"+DToS(mv_par04)+"' AND '"+DToS(mv_par05)+"' "
	cQuery += "	AND E1_NUM BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"
	cQuery += "	AND E1_PREFIXO BETWEEN '"+mv_par14+"' AND '"+mv_par15+"'"
	cQuery += "	UNION ALL"
	cQuery += "	SELECT L1_FILIAL,L1_NUM,L1_FILRES,L1_ORCRES,L1_DOC,L1_DOCPED,E1_NUM,E1_PREFIXO,E1_NSUTEF,L1_SERIE,L1_SERPED,L1_CLIENTE,L1_LOJA,E1_TIPO,E1_PARCELA,E1_BASCOM1,E1_VALOR,E1_EMISSAO,E1_BAIXA,E1_SALDO,E1_VENCTO,L1_VEND,L1_PEDRES"
	cQuery += "	FROM "+RETSQLNAME("SL1")+" SL1 (NOLOCK)"
	cQuery += "	INNER JOIN "+RETSQLNAME("SE1")+" SE1 (NOLOCK) ON SL1.L1_DOC = SE1.E1_NUM AND SL1.L1_SERIE = SE1.E1_PREFIXO AND SL1.L1_DOC != '' AND SL1.D_E_L_E_T_ = '' AND SE1.D_E_L_E_T_ = ''"
	cQuery += "	WHERE L1_CLIENTE BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "
	cQuery += "	AND E1_EMISSAO BETWEEN '"+DToS(mv_par02)+"' AND '"+DToS(mv_par03)+"' "
	cQuery += "	AND E1_VENCTO BETWEEN  '"+DToS(mv_par04)+"' AND '"+DToS(mv_par05)+"' "
	cQuery += "	AND E1_NUM BETWEEN '"+mv_par12+"' AND '"+mv_par13+"'"
	cQuery += "	AND E1_PREFIXO BETWEEN '"+mv_par14+"' AND '"+mv_par15+"'"

	cQuery += "	)SLE"
	cQuery += "	LEFT JOIN "+RETSQLNAME("SC5")+" SC5 (NOLOCK) ON CASE WHEN ISNULL(SC5.C5_XFILRES,'') = '' THEN SC5.C5_FILIAL ELSE SC5.C5_XFILRES END = CASE WHEN ISNULL(SLE.L1_FILRES,'') = '' THEN SLE.L1_FILIAL ELSE SLE.L1_FILRES END AND"
	cQuery += "	                        CASE WHEN ISNULL(SC5.C5_XORCRES,'') = '' THEN CASE WHEN ISNULL(SC5.C5_ORCRES,'') != '' THEN SC5.C5_NUM ELSE SC5.C5_ORCRES END ELSE SC5.C5_XORCRES END = CASE WHEN ISNULL(SLE.L1_ORCRES,'') = '' THEN SLE.L1_NUM ELSE SLE.L1_ORCRES END AND SC5.D_E_L_E_T_ = ''"
	cQuery += "	LEFT JOIN "+RETSQLNAME("SC6")+" SC6 (NOLOCK) ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC6.D_E_L_E_T_ = ''"
	cQuery += "	INNER JOIN "+RETSQLNAME("SA3")+" SA3 (NOLOCK) ON SLE.L1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ''"
	cQuery += "	INNER JOIN "+RETSQLNAME("SA1")+" SA1 (NOLOCK) ON SLE.L1_CLIENTE = SA1.A1_COD AND SLE.L1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''"
	cQuery += "	LEFT JOIN "+RETSQLNAME("SL1")+" SL11 (NOLOCK) ON SLE.L1_FILIAL = SL11.L1_FILRES AND SLE.L1_NUM = SL11.L1_ORCRES AND SL11.L1_DOC != '' AND SL11.D_E_L_E_T_ = '' "
	cQuery += "	LEFT JOIN SIGAMAT SM (NOLOCK) ON CASE WHEN ISNULL(SC5.C5_FILIAL,'') = '' THEN CASE WHEN ISNULL(SLE.L1_FILRES,'') = '' THEN SLE.L1_FILIAL ELSE SLE.L1_FILRES END ELSE SC5.C5_FILIAL END = SM.M0_CODFIL AND SM.M0_CODIGO = '10' AND SM.D_E_L_E_T_ = ''"
	cQuery += "	GROUP BY SM.M0_CODFIL,SM.M0_FILIAL,SLE.L1_NUM,C6_NUM,SL11.L1_PEDRES,SLE.L1_DOC,SL11.L1_DOC,SLE.L1_SERIE,SLE.L1_DOCPED,SL11.L1_SERIE,SLE.L1_SERPED,C6_NOTA,C6_SERIE,SL11.L1_EMISNF,C6_DATFAT,E1_NUM,E1_PREFIXO,SLE.E1_NSUTEF,E1_TIPO,E1_PARCELA,E1_BASCOM1,E1_VALOR,E1_EMISSAO,E1_VENCTO,E1_BAIXA,E1_SALDO,A1_COD,A1_LOJA,A1_NOME,A3_NOME"
	cQuery += "	)TB"
	cQuery += "	FULL JOIN "+RETSQLNAME("SD2")+" SD2 (NOLOCK) ON TB.M0_CODFIL = SD2.D2_FILIAL AND TB.C6_NOTA = SD2.D2_DOC AND TB.C6_SERIE = SD2.D2_SERIE AND SD2.D_E_L_E_T_ = '' "
	cQuery += "	INNER JOIN "+RETSQLNAME("SF2")+" SF2 (NOLOCK) ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SF2.D_E_L_E_T_ = '' "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SA1")+" SA11 (NOLOCK) ON SD2.D2_CLIENTE = SA11.A1_COD AND SD2.D2_LOJA = SA11.A1_LOJA AND SA11.D_E_L_E_T_ = ''"
	cQuery += "	LEFT JOIN "+RETSQLNAME("SA3")+" SA31 (NOLOCK) ON SF2.F2_VEND1 = SA31.A3_COD AND SA31.D_E_L_E_T_ = ''"
	cQuery += "	LEFT JOIN SIGAMAT SM1 (NOLOCK) ON SD2.D2_FILIAL = SM1.M0_CODFIL AND SM1.M0_CODIGO = '10' AND SM1.D_E_L_E_T_ = '' "
	cQuery += "	WHERE"
	cQuery += "	SD2.D2_EMISSAO BETWEEN '"+DToS(mv_par06)+"' AND '"+DToS(mv_par07)+"' "
	cQuery += "	AND SD2.D2_FILIAL = '"+mv_par01+"' "
	cQuery += "	)TB1"
	cQuery += "	WHERE TB1.C6_SERIE != 'UNR'"
	cQuery += "	AND TB1.C6_NOTA BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
	cQuery += "	GROUP BY TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,A1_COD,A1_NOME,A3_NOME "
	cQuery += "	ORDER BY TB1.M0_CODFIL,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,TB1.A1_COD,TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_PARCELA"	




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



		cCodproduto 	:= cAlias->C6_NOTA

		IncProc("Imprimindo Venda"+alltrim(cAlias->L1_NUM))

		//TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,A1_COD,A1_NOME,A3_NOME

		//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,		
		//imprimo a primeira se็ใo				
		oSection1:Cell("M0_CODFIL"):SetValue(cAlias->M0_CODFIL)
		oSection1:Cell("M0_FILIAL"):SetValue(cAlias->M0_FILIAL) 
		oSection1:Cell("L1_NUM"):SetValue(cAlias->L1_NUM) 
		oSection1:Cell("C6_NUM"):SetValue(cAlias->C6_NUM)
		oSection1:Cell("C6_NOTA"):SetValue(cAlias->C6_NOTA) 
		oSection1:Cell("C6_SERIE"):SetValue(cAlias->C6_SERIE)
		oSection1:Cell("C6_DATFAT"):SetValue(STOD(cAlias->C6_DATFAT))
		oSection1:Cell("A1_COD"):SetValue(cAlias->A1_COD) 
		oSection1:Cell("A1_NOME"):SetValue(cAlias->A1_NOME)
		oSection1:Cell("A3_NOME"):SetValue(cAlias->A3_NOME)   
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->C6_NOTA == cCodproduto
			oReport:IncMeter()		                                

			//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,    

			IncProc("Imprimindo Financeiro"+alltrim(cAlias->E1_NUM))
			oSection2:Cell("E1_NUM"):SetValue(cAlias->E1_NUM)			
			oSection2:Cell("E1_PREFIXO"):SetValue(cAlias->E1_PREFIXO)
			oSection2:Cell("E1_NSUTEF"):SetValue(cAlias->E1_NSUTEF)
			oSection2:Cell("E1_TIPO"):SetValue(cAlias->E1_TIPO)
			oSection2:Cell("E1_PARCELA"):SetValue(cAlias->E1_PARCELA)
			oSection2:Cell("E1_BASCOM1"):SetValue(cAlias->E1_BASCOM1)
			oSection2:Cell("E1_VALOR"):SetValue(cAlias->E1_VALOR)
			oSection2:Cell("E1_EMISSAO"):SetValue(STOD(cAlias->E1_EMISSAO))
			oSection2:Cell("E1_VENCTO"):SetValue(STOD(cAlias->E1_VENCTO))
			oSection2:Cell("E1_BAIXA"):SetValue(STOD(cAlias->E1_BAIXA))
			oSection2:Cell("E1_SALDO"):SetValue(cAlias->E1_SALDO)
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

	u_InPutSX1(cPerg,"01",PADR("Filial    	  ? ",20)+"","","","mv_ch1","C",2,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo do Titulo De? ",30)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Emissใo do Titulo At้? ",30)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Vencimento de ? ",30)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Vencimento At้? ",30)+"","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Emissใo da Nota de? ",30)+"","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Emissใo da Nota At้? ",30)+"","","","mv_ch7","D",8,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Nota de    	  ? ",20)+"","","","mv_ch8","C",9,0,0,"G","","","","","mv_par08") 
	u_InPutSX1(cPerg,"09",PADR("Nota At้   	  ? ",20)+"","","","mv_ch9","C",9,0,0,"G","","","","","mv_par09")
	u_InPutSX1(cPerg,"10",PADR("Cliente de    ? ",20)+"","","","mv_ch8","C",6,0,0,"G","","","","","mv_par10") 
	u_InPutSX1(cPerg,"11",PADR("Cliente At้   ? ",20)+"","","","mv_ch9","C",6,0,0,"G","","","","","mv_par11")
	u_InPutSX1(cPerg,"12",PADR("Titulo de     ? ",20)+"","","","mv_cha","C",9,0,0,"G","","","","","mv_par12")
	u_InPutSX1(cPerg,"13",PADR("Titulo At้    ? ",20)+"","","","mv_chb","C",9,2,0,"G","","","","","mv_par13")
	u_InPutSX1(cPerg,"14",PADR("Prefixo de    ? ",20)+"","","","mv_chc","C",3,0,0,"G","","","","","mv_par14") 
	u_InPutSX1(cPerg,"15",PADR("Prefixo At้   ? ",20)+"","","","mv_chd","C",3,0,0,"G","","","","","mv_par15")
Return