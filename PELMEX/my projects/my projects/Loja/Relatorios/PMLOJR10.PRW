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


User Function PMLOJR10()
	Local oReport := nil
	Local cPerg:= Padr("PMLOJR10",10)

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
	Local oSection3:= Nil
	Local oBreak
	Local oFunction


	oReport := TReport():New(cNOME,"Conferencia de Vendas",cNOME,{|oReport| ReportPrint(oReport)},"Conferencia de Vendas")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)


	//Primeira se็ใo

	oSection1:= TRSection():New(oReport, "Cliente", {"SA1"}, , .F., .T.)
	TRCell():New(oSection1,"L1_CLIENTE"		   	,"cAlias","Cod.Cliente",,)
	TRCell():New(oSection1,"A1_NOME"	   		,"cAlias","Nome",,) 
	TRCell():New(oSection1,"A1_TEL"	   			,"cAlias","Telefone",,)
	TRCell():New(oSection1,"A1_CGC"	   			,"cAlias","CPF",,)
	TRCell():New(oSection1,"A1_CEP"	  			,"cAlias","CEP",,) 
	TRCell():New(oSection1,"A1_END"	   	 	    ,"cAlias","Endere็o",,)  
	TRCell():New(oSection1,"A1_BAIRRO"		    ,"cAlias","Bairro",,)
	TRCell():New(oSection1,"A1_PESSOA"	   		,"cAlias","Pessoa",,)
	TRCell():New(oSection1,"A1_TRTRIBU"	   		,"cAlias","Tributa็ใo",,)
	TRCell():New(oSection1,"A1_INSCR"	   		,"cAlias","Inscri็ใo",,)
	TRCell():New(oSection1,"A1_SUFRAMA"	   		,"cAlias","Suframa",,)
	TRCell():New(oSection1,"A3_NOME"	   		,"cAlias","Vendedor",,)                     
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas




	oSection2:= TRSection():New(oReport, "Produto", {"SA1"}, NIL, .F., .T.,,,,.T.)
	TRCell():New(oSection2,"L1_NUM"	    			,"cAlias","Or็amento",,)
	TRCell():New(oSection2,"B1_DESC"		    	,"cAlias","Descri็ใo",,)    
	TRCell():New(oSection2,"L1_EMISSAO"				,"cAlias","Emissใo",/*Mascara*/,)
	TRCell():New(oSection2,"L2_QUANT"		    	,"cAlias","Qtd","@E 999",)    
	TRCell():New(oSection2,"L2_VLRITEM"				,"cAlias","Vlr Venda",/*Mascara*/,) 
	TRCell():New(oSection2,"L2_PRODUTO"	    		,"cAlias","Produto",,)




	oSection3:= TRSection():New(oReport, "Titulos", {"SA1"}, NIL, .F., .T.)
	TRCell():New(oSection3,"E1_NUM"	    			,"cAlias","Titulo",,)
	TRCell():New(oSection3,"E1_PREFIXO"		    	,"cAlias","Prefixo",,)    
	TRCell():New(oSection3,"E1_PARCELA"				,"cAlias","Parcela",/*Mascara*/,) 
	TRCell():New(oSection3,"E1_TIPO"	    		,"cAlias","Forma de Pagamento",,)
	TRCell():New(oSection3,"E1_BASCOM1"		    	,"cAlias","Valor","@E 999,999,999.99",)       
	//Quebra por Se็ใo



	oBreak := TRBreak():New(oSection2,oSection1:Cell("L1_CLIENTE"),"TOTAL") 

	/*
	TRFunction():New(oSection2:Cell("Z4_NUMERO"),"Total","SUM",oBreak,,,,.F.,.F.)

	//Fim Quebra por Se็ใo                                                       


	//Totalizador final
	TRFunction():New(oSection2:Cell("Z4_NUMERO"),"QUANTIDADE TOTAL","SUM", ,,"@E 9,999,999,999",,.F.,.T.)
	*/                                           


	//Totalizador                                                                                                          MIC

	/* 

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	oReport:SetTotalInLine(.F.)

	//quebra  por se็ใo (.T.) uma se็ใo por pagina

	oSection2:SetPageBreak(.F.)
	oSection2:SetTotalText(" ")

	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText(" ")				
Return(oReport)



/*Inicia Logica Print Report */

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)	 
	Local cQuery    := ""		
	Local cCodCli   := ""   
	Local cCliente  := "" 
	Local lPrim 	:= .T.
	Local nCount 	:= 0







	cQuery := "SELECT L1_NUM,L1_CLIENTE,A1_NOME,A3_NOME,RTRIM(LTRIM(A1_DDD+A1_TEL)) A1_TEL,A1_CGC,A1_CEP,A1_END,A1_BAIRRO,L1_EMISSAO, "
	cQuery += " CASE WHEN A1_PESSOA = 'F' THEN 'FISICA' ELSE 'JURIDICA' END A1_PESSOA, "
	cQuery += " CASE WHEN A1_TPTRIBU = '1' THEN 'LUCRO REAL' ELSE "
	cQuery += " CASE WHEN A1_TPTRIBU = '2' THEN 'LUCRO PRESUMIDO' ELSE "
	cQuery += " CASE WHEN A1_TPTRIBU = '3' THEN 'OPTANTE DO SIMPLES' ELSE '' "
	cQuery += " END END END A1_TPTRIBU,A1_INSCR,A1_SUFRAMA,L2_QUANT,L2_VLRITEM,TB.*,L1_DOCTEF,L1_DOCPED,L1_SERPED,L2_PRODUTO,B1_DESC  FROM "
	cQuery += " (SELECT E1_NUM,E1_PREFIXO,E1_VEND1, COUNT(E1_PARCELA) E1_PARCELA,SUM(E1_BASCOM1) E1_BASCOM1, "
	cQuery += " CASE WHEN E1_TIPO = 'CD' THEN 'DEBITO' ELSE " 
	cQuery += " CASE WHEN E1_TIPO = 'CC' THEN 'CREDITO' ELSE "
	cQuery += " CASE WHEN E1_TIPO = 'R$' THEN 'DINHEIRO' ELSE 'OUTRAS FORMAS' "
	cQuery += " END END END E1_TIPO " 
	cQuery += " FROM "+RETSQLNAME("SE1")+" SE1 "
	cQuery += " WHERE E1_EMISSAO BETWEEN '"+DToS(mv_par05)+"' AND '"+DToS(mv_par06)+"' "
	cQuery += " AND SE1.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY E1_NUM,E1_PREFIXO,E1_VEND1,E1_TIPO "
	cQuery += " ) TB "
	cQuery += "	INNER JOIN "+RETSQLNAME("SL1")+" SL1 (NOLOCK)  ON L1_DOCPED = TB.E1_NUM AND L1_SERPED = TB.E1_PREFIXO "
	cQuery += "	INNER JOIN "+RETSQLNAME("SA1")+" SA1 (NOLOCK)  ON L1_CLIENTE = A1_COD AND L1_LOJA = A1_LOJA "
	cQuery += "	INNER JOIN "+RETSQLNAME("SA3")+" SA3 (NOLOCK)  ON A3_COD = L1_VEND "
	cQuery += "	INNER JOIN "+RETSQLNAME("SL2")+" SL2 (NOLOCK)  ON L2_NUM = L1_NUM AND L1_FILIAL = L2_FILIAL AND SL2.D_E_L_E_T_ = '' "
	cQuery += "	INNER JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK)  ON B1_COD = L2_PRODUTO "  

	cQuery += "	WHERE L1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "	AND L1_VEND BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "	AND L1_EMISSAO BETWEEN '"+DToS(mv_par05)+"' AND '"+DToS(mv_par06)+"' "
	cQuery += " AND SL1.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY L1_NUM,L1_CLIENTE,A1_NOME,A3_NOME,A1_DDD,A1_TEL,A1_CGC,A1_CEP,A1_END,A1_BAIRRO,A1_PESSOA,A1_TPTRIBU,A1_INSCR,A1_SUFRAMA,L2_QUANT,L2_VLRITEM,L1_DOCTEF,L1_DOCPED,L1_SERPED,L2_PRODUTO,B1_DESC,TB.E1_BASCOM1, "
	cQuery += " TB.E1_NUM,TB.E1_PREFIXO,TB.E1_VEND1,TB.E1_PARCELA,TB.E1_TIPO,L2_TIPO,L1_EMISSAO "

	cQuery += " UNION ALL "

	cQuery += " SELECT L1_NUM,L1_CLIENTE,A1_NOME,A3_NOME,RTRIM(LTRIM(A1_DDD+A1_TEL)) A1_TEL,A1_CGC,A1_CEP,A1_END,A1_BAIRRO,L1_EMISSAO, "
	cQuery += " CASE WHEN A1_PESSOA = 'F' THEN 'FISICA' ELSE 'JURIDICA' END A1_PESSOA, "
	cQuery += " CASE WHEN A1_TPTRIBU = '1' THEN 'LUCRO REAL' ELSE "
	cQuery += " CASE WHEN A1_TPTRIBU = '2' THEN 'LUCRO PRESUMIDO' ELSE "
	cQuery += " CASE WHEN A1_TPTRIBU = '3' THEN 'OPTANTE DO SIMPLES' ELSE '' "
	cQuery += " END END END A1_TPTRIBU,A1_INSCR,A1_SUFRAMA,L2_QUANT,L2_VLRITEM,TB.*,L1_DOCTEF,L1_DOC L1_DOCPED,L1_SERIE L1_SERPED,L2_PRODUTO,B1_DESC  FROM "
	cQuery += " (SELECT E1_NUM,E1_PREFIXO,E1_VEND1, COUNT(E1_PARCELA) E1_PARCELA,SUM(E1_BASCOM1) E1_BASCOM1, "
	cQuery += " CASE WHEN E1_TIPO = 'CD' THEN 'DEBITO' ELSE " 
	cQuery += " CASE WHEN E1_TIPO = 'CC' THEN 'CREDITO' ELSE "
	cQuery += " CASE WHEN E1_TIPO = 'R$' THEN 'DINHEIRO' ELSE 'OUTRAS FORMAS' "
	cQuery += " END END END E1_TIPO " 
	cQuery += " FROM "+RETSQLNAME("SE1")+" SE1 "
	cQuery += " WHERE E1_EMISSAO BETWEEN '"+DToS(mv_par05)+"' AND '"+DToS(mv_par06)+"' "
	cQuery += " AND SE1.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY E1_NUM,E1_PREFIXO,E1_VEND1,E1_TIPO "
	cQuery += " )TB "
	cQuery += " INNER JOIN "+RETSQLNAME("SL1")+" SL1 ON SL1.L1_DOC= TB.E1_NUM AND SL1.L1_SERIE = TB.E1_PREFIXO "
	cQuery += " INNER JOIN "+RETSQLNAME("SA1")+" SA1 ON SL1.L1_CLIENTE = A1_COD AND SL1.L1_LOJA = A1_LOJA "
	cQuery += " INNER JOIN "+RETSQLNAME("SA3")+" SA3 ON A3_COD = SL1.L1_VEND "
	cQuery += " INNER JOIN "+RETSQLNAME("SL2")+" SL2 ON L2_NUM = SL1.L1_NUM AND SL1.L1_FILIAL = L2_FILIAL AND SL2.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON B1_COD = L2_PRODUTO "  
	cQuery += " WHERE L1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "	AND L1_VEND BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "	AND L1_EMISSAO BETWEEN '"+DToS(mv_par05)+"' AND '"+DToS(mv_par06)+"' "
	cQuery += " AND SL1.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY L1_NUM,L1_CLIENTE,A1_NOME,A3_NOME,A1_DDD,A1_TEL,A1_CGC,A1_CEP,A1_END,A1_BAIRRO,A1_PESSOA,A1_TPTRIBU,A1_INSCR,A1_SUFRAMA,L2_QUANT,L2_VLRITEM,L1_DOCTEF,L1_DOC,L1_SERIE,L2_PRODUTO,B1_DESC,TB.E1_BASCOM1, "
	cQuery += " TB.E1_NUM,TB.E1_PREFIXO,TB.E1_VEND1,TB.E1_PARCELA,TB.E1_TIPO,L2_TIPO,L1_EMISSAO "
	cQuery += " ORDER BY L1_NUM "














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


		cCodproduto 	:= cAlias->L1_CLIENTE
		cDocped 	:= cAlias->E1_NUM
		cSerped 	:= cAlias->E1_PREFIXO
		IncProc("Imprimindo Cliente: "+alltrim(cAlias->A1_NOME)) 


		//imprimo a primeira se็ใo				
		oSection1:Cell("L1_CLIENTE"):SetValue(cAlias->L1_CLIENTE)
		oSection1:Cell("A1_NOME"):SetValue(cAlias->A1_NOME)
		oSection1:Cell("A1_TEL"):SetValue(cAlias->A1_TEL)
		oSection1:Cell("A1_CGC"):SetValue(cAlias->A1_CGC)
		oSection1:Cell("A1_CEP"):SetValue(cAlias->A1_CEP)
		oSection1:Cell("A1_END"):SetValue(cAlias->A1_END) 
		oSection1:Cell("A1_BAIRRO"):SetValue(cAlias->A1_BAIRRO)
		oSection1:Cell("A1_PESSOA"):SetValue(cAlias->A1_PESSOA)



		//oSection1:Cell("A1_TPTRIBU"):SetValue(cAlias->A1_TPTRIBU)

		oSection1:Cell("A1_INSCR"):SetValue(cAlias->A1_INSCR)
		oSection1:Cell("A1_SUFRAMA"):SetValue(cAlias->A1_SUFRAMA)      			
		oSection1:Cell("A3_NOME"):SetValue(cAlias->A3_NOME)
		oSection1:Printline()


		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While (cAlias->L1_CLIENTE == cCodproduto) .OR.(cAlias->E1_NUM == cDocped .and. cAlias->E1_PREFIXO == cSerped) 
			oReport:IncMeter()		                                

			IncProc("Imprimindo Produtos: "+alltrim(cAlias->B1_DESC))

			oSection2:Cell("L1_NUM"):SetValue(cAlias->L1_NUM)
			oSection2:Cell("L2_QUANT"):SetValue(cAlias->L2_QUANT)
			oSection2:Cell("L2_VLRITEM"):SetValue(cAlias->L2_VLRITEM)
			oSection2:Cell("L2_PRODUTO"):SetValue(cAlias->L2_PRODUTO)
			oSection2:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)
			oSection2:Cell("L1_EMISSAO"):SetValue(StoD(cAlias->L1_EMISSAO))
			oSection2:Printline()

			oSection3:init()

			oSection3:Cell("E1_NUM"):SetValue(cAlias->E1_NUM)
			oSection3:Cell("E1_PREFIXO"):SetValue(cAlias->E1_PREFIXO)
			oSection3:Cell("E1_PARCELA"):SetValue(cAlias->E1_PARCELA)
			oSection3:Cell("E1_TIPO"):SetValue(cAlias->E1_TIPO)
			oSection3:Cell("E1_BASCOM1"):SetValue(cAlias->E1_BASCOM1)			
			oSection3:Printline()

			cAlias->(dbSkip())
			oSection3:Finish()	
			oReport:ThinLine()	
		ENDDO






		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto


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

	u_InPutSX1(cPerg,"01",PADR("Filial De  ?    	 ",20)+"","","","mv_ch1","C",6,0,0,"G","","SM0",,"","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Filial At้ ?    	 ",20)+"","","","mv_ch2","C",6,0,0,"G","","SM0",,"","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Vendedor De  ?    ",20)+"","","","mv_ch3","C",14,0,0,"G","","SA3","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Vendedor At้ ?    ",20)+"","","","mv_ch4","C",14,0,0,"G","","SA3",,"","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Emissใo De  ?    ",20)+"","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Emissใo At้ ?    ",20)+"","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06") 
