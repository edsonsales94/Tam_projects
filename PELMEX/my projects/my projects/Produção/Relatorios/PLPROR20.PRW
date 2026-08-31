#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR02    ºAutor  ³Wilson Junior     º Data ³  22/04/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RANK DA PRODUÇÃO SIMPLIFICADO	                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        	   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR20()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR20",10)

	//Incluo/Altero as perguntas na tabela SX1
	AjustaSX1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
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


	oReport := TReport():New(cNOME,"Relatório Rastreio de Pedido Simplificado",cNOME,{|oReport| ReportPrint(oReport)},"Relatório Rastreio de Pedido Simplificado")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção

	oSection1:= TRSection():New(oReport, "Produto", {"SC6"}, , .F., .T.)
	TRCell():New(oSection1,"C6_NUM"	   	   	  	,"cAlias","Num_Pedido","!@",6)
	TRCell():New(oSection1,"A1_NOME"	   	    ,"cAlias","Cliente","!@",35)
	TRCell():New(oSection1,"A1_EST"	   	   	    ,"cAlias","Estado","!@",4)
	TRCell():New(oSection1,"A1_MUN"	   	   	    ,"cAlias","Munucipio","!@",20)
	TRCell():New(oSection1,"DT_PEDIDO"	   	    ,"cAlias","Dt_Pedido","!@",8)
	TRCell():New(oSection1,"DT_ENTREGA"	   	    ,"cAlias","Dt_Entrega","!@",8)
	TRCell():New(oSection1,"DIF_DIA"	   	    ,"cAlias","Dia","!@",5)
	TRCell():New(oSection1,"OBSERVACAO"	   	   ,"cAlias","Observacao","!@",35)

	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas



	oSection2:= TRSection():New(oReport, "Componente", {"SG1"}, NIL, .F., .T.)

	TRCell():New(oSection2,"F4_TEXTO"	   	 	  ,"cAlias","Natureza","!@",25)
	TRCell():New(oSection2,"C6_PRODUTO"	   	 	  ,"cAlias","Produção","!@",15)
	TRCell():New(oSection2,"C6_DESCRI"	   	   	   ,"cAlias","Descricao","!@",35)
	TRCell():New(oSection2,"C6_QTDVEN"	   	   	   ,"cAlias","Qtd_Venda","@E 9,999,999,999",) 
	TRCell():New(oSection2,"SLDO"	   	   		   ,"cAlias","Pendente","@E 9,999,999,999",)  
	TRCell():New(oSection2,"C6_VALOR"	   	   	   ,"cAlias","Valor","@E 9,999,999,999.99",) 
	TRCell():New(oSection2,"M3"	   	   	  			,"cAlias","M3","@E 9,999,999,999.99",) 
	TRCell():New(oSection2,"C2_XCARGA"	   	  	,"cAlias","Carga","!@",9) 
	
	/*TRCell():New(oSection2,"VALOR"	   	  	   ,"cAlias","Qtd de Pontos","@E 9,999,999,999.99",10)  
	TRCell():New(oSection2,"VALORDOPONTO"	   	   ,"cAlias","Valor do ponto","@E 9.99",10) 
	TRCell():New(oSection2,"CLA_PONTOS"	   	   	   ,"cAlias","Resultado","@E 999,999.99",10)  
	TRCell():New(oSection2,"RA_SALARIO"	   	   	   ,"cAlias","Salario","@E 9,999,999,999.99",10)
	TRCell():New(oSection2,"COMISSAO"	   	   	   ,"cAlias","Comissao","@E 9,999,999,999.99",10)*/





/*
	oBreak := TRBreak():New(oSection1,oSection2:Cell("CLA_PONTOS"),"Total")
	TRFunction():New(oSection2:Cell("CLA_QUANT"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.) 
	TRFunction():New(oSection2:Cell("VALOR"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)   
	TRFunction():New(oSection2:Cell("CLA_PONTOS"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.) 
	TRFunction():New(oSection2:Cell("RA_SALARIO"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)   
	TRFunction():New(oSection2:Cell("COMISSAO"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)*/

	//Fim Quebra por Seção

	//Totalizador final
	//TRFunction():New(oSection2:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 
	//TRFunction():New(oSection2:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

	//TRFunction():New(oSection2:Cell("SAI_DOC")	,"Total de Notas","COUNT",,,"@E 9,999,999,999",,.F.,.T.)


	oReport:SetTotalInLine(.F.)

	//quebra  por seção (.T.) uma seção por pagina
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
	//Local cMascara  := "@E 9,999,999,999,999,999,999"
	Local lPrim 	:= .T.


	cQuery := "	SELECT C6_NUM, "
	cQuery += "	CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_PEDIDO, "
    cQuery += "	CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),103)DT_ENTREGA, "
    cQuery += "	CASE WHEN (C6_QTDENT - C6_QTDVEN) = 0 THEN '0' ELSE DATEDIFF(DAY, C6_ENTREG, GETDATE()) END DIF_DIA, "
    cQuery += "	A1_NOME, "
	cQuery += " F4_TEXTO,"
    cQuery += "	C6_PRODUTO,"
    cQuery += "	C6_DESCRI,"
    cQuery += "	(C6_QTDENT - C6_QTDVEN) SLDO,"
	cQuery += "	C6_QTDVEN,"
    cQuery += "	C6_VALOR,"
    cQuery += "	CASE WHEN (C6_QTDVEN-C6_QTDENT)> 0 THEN ((B1_XALTURA*B1_XCOMPRI*B1_XLARGUR)* (C6_QTDVEN-C6_QTDENT)) ELSE ((B1_XALTURA*B1_XCOMPRI*B1_XLARGUR)* C6_QTDVEN) END M3,"
    cQuery += "	A1_MUN,"
    cQuery += "	A1_EST,"
	cQuery += " C2_XCARGA,"
    cQuery += "	RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) OBSERVACAO"
	cQuery += "	FROM SC6100 SC6 (NOLOCK) "
	cQuery += "	INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += "	INNER JOIN SC5100 SC5 (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = '' "
	cQuery += "	INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "
	cQuery += "	INNER JOIN SF4100 SF4 (NOLOCK) ON C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = '' "
	cQuery += "	LEFT JOIN (SELECT * "
	cQuery += "	FROM PED "
	cQuery += "	)PED ON C6_FILIAL = PED_FILIAL AND C6_NUM = PED_NUM AND C6_ITEM = PED_ITEM AND C6_PRODUTO = PED_PRODUTO "
	cQuery += "  LEFT JOIN (SELECT *"
    cQuery += "  FROM SD2100 SD2 (NOLOCK)"
	cQuery += "  WHERE SD2.D_E_L_E_T_ = '')SD2 ON (CASE WHEN ISNULL(PED_FILIAL,'') = '' THEN C6_FILIAL ELSE PED_FILIAL END) = D2_FILIAL AND (CASE WHEN ISNULL (PED_NOTA,'') = '' THEN (CASE WHEN ISNULL (PED_NUM,'') = '' THEN C6_NUM ELSE PED_NUM END) ELSE PED_NOTA END) = (CASE WHEN ISNULL (PED_NOTA,'') = '' THEN D2_PEDIDO ELSE D2_DOC END)"
    cQuery += "  AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD"
	cQuery += "	 LEFT JOIN (SELECT *"
    cQuery += "  FROM SC2100 SC2"
    cQuery += "  ) SC2 ON C2_NUM = PED_OP AND C2_PRODUTO = PED_PRODUTO AND  SC2.D_E_L_E_T_ = ''"
	cQuery += "	 LEFT JOIN (SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO,SUM(SAI_QUANT)SAI_QUANT,MIN(SAI_DTEXP)SAI_DTEXP"
    cQuery += "  FROM SAI"
    cQuery += "  GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO)SAI ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND D2_ITEM = SAI_ITEM AND D2_COD = SAI_PRODUTO "
	cQuery += "	 LEFT JOIN (SELECT *"
    cQuery += "  FROM CNF)CNF ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE"
    cQuery += "  LEFT JOIN (SELECT *"
	cQuery += "	 FROM PTC"
	cQuery += "	 WHERE PTC_STATUS != 'D' AND PTC_EMPRESA = '10') PTC ON D2_FILIAL = PTC_FILIAL AND D2_DOC = PTC_DOC AND D2_SERIE = PTC_SERIE"
	cQuery += "	 AND PTC_SETOR = '4040      | EXPEDICAO'"
	cQuery += "	 LEFT JOIN (SELECT *"
	cQuery += "	 FROM MAN"
	cQuery += "	 WHERE MAN_EMPRESA = '10') MAN ON D2_FILIAL = MAN_FILIAL AND D2_DOC = MAN_DOC AND D2_SERIE = MAN_SERIE"
    cQuery += "  LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''  "
	cQuery += "	 WHERE SC6.D_E_L_E_T_ = ''"
	cQuery += "	 AND C6_FILIAL = '01' "
	cQuery += "	 AND C6_TES NOT IN ('709','915','916','917')"
	cQuery += "	 AND C6_LOCAL IN ('20','30','50')"
	cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%INVENT%'"
	cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%NAO PRODUZIR%'"
	cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%NÃO PRODUZIR%' "
	cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%REFATURAMENTO%'"
    cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%TRANSFERENCIA%'"
    cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%TRANSF %'"
    cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%DEVOLUCAO%'"
    cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'DEV %'"
    cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'REF.%'"
    cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'REF %'"
    cQuery += "	 AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'ESTORNO%'"
    cQuery += "	 AND C5_EMISSAO BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' "
    cQuery += "	 AND C6_NUM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
    cQuery += "	 AND A1_EST BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
    cQuery += "	 AND A1_MUN BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
    cQuery += "	 AND A1_COD BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
    cQuery += "	 GROUP BY C6_NUM,C5_EMISSAO,C6_ENTREG,PED_OP,PED_DTPROPEL,C2_XCARGA,D2_DOC,D2_EMISSAO,PTC_DATINC,PTC_DATALT,D1_DOC,D1_EMISSAO,SAI_DTEXP,CNF_EXPEDICAO,MAN_CODMAN,"
    cQuery += "	 MAN_DATEXP,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_LOCAL,D2_QUANT,C6_QTDVEN,C6_QTDENT,PED_QUANT,B1_DCR,B1_XALTURA,B1_XCOMPRI,B1_XLARGUR,A1_EST,A1_MUN,A1_COD,A1_NOME,"
    cQuery += "	 A1_MSBLQL,RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3),B1_XSETOR,C6_VALOR,F4_TEXTO"
    cQuery += "	 ORDER BY A1_MUN,C6_NUM,C6_ITEM"



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

		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter() 

		cCodproduto 	:= cAlias->C6_NUM

		IncProc("Imprimindo tipo"+alltrim(cAlias->C6_NUM))
		//TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,A1_COD,A1_NOME,A3_NOME

		//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,
		//imprimo a primeira seção
		oSection1:Cell("C6_NUM"):SetValue(cAlias->C6_NUM)
		oSection1:Cell("A1_NOME"):SetValue(cAlias->A1_NOME)
		oSection1:Cell("A1_EST"):SetValue(cAlias->A1_EST)
		oSection1:Cell("A1_MUN"):SetValue(cAlias->A1_MUN)
		oSection1:Cell("DT_PEDIDO"):SetValue(cAlias->DT_PEDIDO)
		oSection1:Cell("DT_ENTREGA"):SetValue(cAlias->DT_ENTREGA)
		oSection1:Cell("DIF_DIA"):SetValue(cAlias->DIF_DIA)
		oSection1:Cell("OBSERVACAO"):SetValue(cAlias->OBSERVACAO)


		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->C6_NUM == cCodproduto
			oReport:IncMeter()                                


			IncProc("Imprimindo funcionario"+alltrim(cAlias->C6_PRODUTO))
			oSection2:Cell("F4_TEXTO"):SetValue(cAlias->F4_TEXTO)
			oSection2:Cell("C6_PRODUTO"):SetValue(cAlias->C6_PRODUTO)	
			oSection2:Cell("C6_DESCRI"):SetValue(cAlias->C6_DESCRI)
			oSection2:Cell("C6_QTDVEN"):SetValue(cAlias->C6_QTDVEN)
			oSection2:Cell("SLDO"):SetValue(cAlias->SLDO)
			oSection2:Cell("C6_VALOR"):SetValue(cAlias->C6_VALOR)
			oSection2:Cell("M3"):SetValue(cAlias->M3)
			oSection2:Cell("C2_XCARGA"):SetValue(cAlias->C2_XCARGA)

			oSection2:Printline()
			cAlias->(dbSkip())
			
		EndDo
		//Aqui, farei uma quebra  por seção

		//finalizo a segunda seção para que seja reiniciada para o proximo registro
		oSection2:Finish()
		//imprimo uma linha para separar os Títulos de outro
		oReport:ThinLine()

		//finalizo a primeira seção
		oSection1:Finish()
	Enddo


Return

Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao.:"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao.:"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Pedido:"       ,20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Pedido:"      ,20)+"?","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De UF:"           ,20)+"?","","","mv_ch5","C",2,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate UF:"          ,20)+"?","","","mv_ch6","C",2,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De Municipio:"    ,20)+"?","","","mv_ch7","C",30,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Ate Municipio:"   ,20)+"?","","","mv_ch8","C",30,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("De Cod.Cliente:"  ,20)+"?","","","mv_ch9","C",8,0,0,"G","","SA1","","","mv_par09") 
	u_InPutSX1(cPerg,"10",PADR("Ate Cod.Cliente:" ,20)+"?","","","mv_cha","C",8,0,0,"G","","SA1","","","mv_par10")

Return
