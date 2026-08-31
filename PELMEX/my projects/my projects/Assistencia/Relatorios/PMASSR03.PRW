#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Assitencia Cama e Colchใo									        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMASSR03()
	Local oReport := nil
	Local cPerg:= Padr("PMASSR03",10)

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

	cQuery := "		SELECT D2_FILIAL,D2_DOC,D2_SERIE,SUM(D2_TOTAL)D2_TOTAL,D2_EMISSAO,D2_CLIENTE,D2_LOJA,A1_NOME,F4_FINALID,'NFe SAอDA' TIPO,"
	cQuery += "	    B1_DESC,D2_CCUSTO ,CTT_DESC01 "
	cQuery += "	    FROM %Table:SD2% SD2(NOLOCK) "
	cQuery += "	    INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += "	    INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += "	    INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
	cQuery += "     INNER JOIN %Table:CTT% CTT (NOLOCK) ON CTT.CTT_CUSTO = D2_CCUSTO AND CTT.D_E_L_E_T_ = '' "
	cQuery += "	    WHERE D2_EMISSAO BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' "
	cQuery += "	    AND D2_FILIAL = '01' "
	cQuery += "	    AND D2_SERIE != 'UNR' "
	cQuery += "	    AND D2_TES = '705' "
	cQuery += "	    GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_EMISSAO,D2_CLIENTE,D2_LOJA,A1_NOME,F4_FINALID,SD2.D_E_L_E_T_,B1_DESC,D2_CCUSTO,CTT_DESC01 "
	cQuery += "	    UNION "
	cQuery += "	    SELECT D1_FILIAL,D1_DOC,D1_SERIE,SUM(D1_TOTAL)D1_TOTAL,D1_EMISSAO D2_EMISSAO,D1_FORNECE,D1_LOJA,A1_NOME,F4_FINALID,'NFe ENTRADA' TIPO, "
	cQuery += "	    B1_DESC,D1_CC,CTT_DESC01 "
	cQuery += "	    FROM %Table:SD1% SD1 "
	cQuery += "	    INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SD1.D1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += "	    INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += "	    INNER JOIN %Table:SF4% SF4 (NOLOCK) ON SD1.D1_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
	cQuery += "     INNER JOIN %Table:CTT% CTT (NOLOCK) ON CTT.CTT_CUSTO = D1_CC AND CTT.D_E_L_E_T_ = '' "
	cQuery += "	    WHERE D1_EMISSAO BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' "
	cQuery += "	    AND D1_FILIAL = '01' "
	cQuery += "	    AND D1_SERIE = '2' "
	cQuery += "	    AND D1_TES = '014' "
	cQuery += "	    GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_EMISSAO,D1_FORNECE,D1_LOJA,A1_NOME,F4_FINALID,SD1.D_E_L_E_T_,B1_DESC,D1_CC,CTT_DESC01 "
	cQuery += "	    ORDER BY 1,2,3 "











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

	u_InPutSX1(cPerg,"01",PADR("Emissใo De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
Return