#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR02    บAutor  ณWilson Junior     บ Data ณ  22/04/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RANK DA PRODUวรO SIMPLIFICADO	                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        	   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR04()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR04",10)

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


	oReport := TReport():New(cNOME,"Produ็ใo simplificado",cNOME,{|oReport| ReportPrint(oReport)},"Produ็ใo simplificado")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Produto", {"CTT"}, , .F., .T.)
	TRCell():New(oSection1,"CTT_DESC01"	   	   	    ,"cAlias","Descri็ใo",,20)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas



	oSection2:= TRSection():New(oReport, "Componente", {"SG1"}, NIL, .F., .T.)

	TRCell():New(oSection2,"CLA_USERINC"	   	   ,"cAlias","Matricula",,10)
	TRCell():New(oSection2,"RA_NOME"	   	   	   ,"cAlias","Nome",,30)
	TRCell():New(oSection2,"CLA_QUANT"	   	   	   ,"cAlias","Quantidade",,10)  
	TRCell():New(oSection2,"CLA_PONTOS"	   	   	   ,"cAlias","Qtd de Pontos","@E 9,999,999,999.99",20)  
	TRCell():New(oSection2,"VALORDOPONTO"	   	   ,"cAlias","Valor do ponto","@E 9.99",10) 
	TRCell():New(oSection2,"VALOR"	   	   	   	   ,"cAlias","Resultado R$","@E 999,999.99",20)  
	TRCell():New(oSection2,"RA_SALARIO"	   	   	   ,"cAlias","-Salario","@E 9,999,999,999.99",20)
	TRCell():New(oSection2,"COMISSAO"	   	   	   ,"cAlias","= Comissao","@E 9,999,999,999.99",20)






	oBreak := TRBreak():New(oSection1,oSection2:Cell("CLA_PONTOS"),"Total")
	TRFunction():New(oSection2:Cell("CLA_QUANT"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.) 
	TRFunction():New(oSection2:Cell("VALOR"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)   
	TRFunction():New(oSection2:Cell("CLA_PONTOS"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.) 
	TRFunction():New(oSection2:Cell("RA_SALARIO"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)   
	TRFunction():New(oSection2:Cell("COMISSAO"),"","SUM",oBreak,,"@E 9,999,999,999.99",,.F.,.F.)

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


	cQuery := "	SELECT CLA_USERINC,RA_NOME,SUM(CLA_QUANT) CLA_QUANT,SUM(CLA_PONTOS) CLA_PONTOS,SUM((CLA_QUANT*CLA_PONTOS))*CAST('"+STR(mv_par03)+"' AS FLOAT) VALOR,RA_SALARIO, "
	cQuery += "	(SUM((CLA_QUANT*CLA_PONTOS))*CAST('"+STR(mv_par03)+"' AS FLOAT)-RA_SALARIO) COMISSAO, "
	cQuery += "	CAST('"+STR(mv_par03)+"' AS FLOAT) VALORDOPONTO,CTT_DESC01 "
	cQuery += "	FROM CLA "
	cQuery += "	INNER JOIN SRA100 ON RA_MAT = CLA_USERINC "
	cQuery += "	INNER JOIN SB1100 ON B1_COD = CLA_COD "
	cQuery += "	INNER JOIN CTT100 ON CTT_CUSTO = RA_CC "
	cQuery += "	WHERE "
	cQuery += "	CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112) BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' "
	cQuery += "	AND CLA_RETRAB != 'S' "
	cQuery += "	GROUP BY CLA_USERINC,RA_NOME,RA_SALARIO,CTT_DESC01 "
	
	cQuery += " UNION ALL "
	
	cQuery += "	SELECT CLB_USERINC,RA_NOME,SUM(CLB_QUANT) CLB_QUANT,SUM(CLB_PONTOS) CLB_PONTOS,SUM((CLB_QUANT*CLB_PONTOS))*CAST('"+STR(mv_par03)+"' AS FLOAT) VALOR,RA_SALARIO, "
	cQuery += "	(SUM((CLB_QUANT*CLB_PONTOS))*CAST('"+STR(mv_par03)+"' AS FLOAT)-RA_SALARIO) COMISSAO, "
	cQuery += "	CAST('"+STR(mv_par03)+"' AS FLOAT) VALORDOPONTO,CTT_DESC01 "
	cQuery += "	FROM CLB "
	cQuery += "	INNER JOIN SRA100 ON RA_MAT = CLB_USERINC "
	cQuery += "	INNER JOIN SB1100 ON B1_COD = CLB_COD "
	cQuery += "	INNER JOIN CTT100 ON CTT_CUSTO = RA_CC "
	cQuery += "	WHERE "
	cQuery += "	CONVERT(VARCHAR,CAST(CLB_DATINC AS DATE),112) BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' "
	cQuery += "	AND CLB_RETRAB != 'S' "
	cQuery += "	GROUP BY CLB_USERINC,RA_NOME,RA_SALARIO,CTT_DESC01 "
	
	cQuery += " UNION ALL "
	
	cQuery += "	SELECT CLC_USERINC,RA_NOME,SUM(CLC_QUANT) CLC_QUANT,SUM(CLC_PONTOS) CLC_PONTOS,SUM((CLC_QUANT*CLC_PONTOS))*CAST('"+STR(mv_par03)+"' AS FLOAT) VALOR,RA_SALARIO, "
	cQuery += "	(SUM((CLC_QUANT*CLC_PONTOS))*CAST('"+STR(mv_par03)+"' AS FLOAT)-RA_SALARIO) COMISSAO, "
	cQuery += "	CAST('"+STR(mv_par03)+"' AS FLOAT) VALORDOPONTO,CTT_DESC01 "
	cQuery += "	FROM CLC "
	cQuery += "	INNER JOIN SRA100 ON RA_MAT = CLC_USERINC "
	cQuery += "	INNER JOIN SB1100 ON B1_COD = CLC_COD "
	cQuery += "	INNER JOIN CTT100 ON CTT_CUSTO = RA_CC "
	cQuery += "	WHERE "
	cQuery += "	CONVERT(VARCHAR,CAST(CLC_DATINC AS DATE),112) BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' "
	cQuery += "	AND CLC_RETRAB != 'S' "
	cQuery += "	GROUP BY CLC_USERINC,RA_NOME,RA_SALARIO,CTT_DESC01 "
	
	cQuery += " UNION ALL "
		
	cQuery += "	SELECT CLD_USERINC,RA_NOME,SUM(CLD_QUANT) CLD_QUANT,SUM(CLD_PONTOS) CLD_PONTOS,SUM((CLD_QUANT*CLD_PONTOS))*CAST('"+STR(mv_par03)+"' AS FLOAT) VALOR,RA_SALARIO, "
	cQuery += "	(SUM((CLD_QUANT*CLD_PONTOS))*CAST('"+STR(mv_par03)+"' AS FLOAT)-RA_SALARIO) COMISSAO, "
	cQuery += "	CAST('"+STR(mv_par03)+"' AS FLOAT) VALORDOPONTO,CTT_DESC01 "
	cQuery += "	FROM CLD "
	cQuery += "	INNER JOIN SRA100 ON RA_MAT = CLD_USERINC "
	cQuery += "	INNER JOIN SB1100 ON B1_COD = CLD_COD "
	cQuery += "	INNER JOIN CTT100 ON CTT_CUSTO = RA_CC "
	cQuery += "	WHERE "
	cQuery += "	CONVERT(VARCHAR,CAST(CLD_DATINC AS DATE),112) BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' "
	cQuery += "	AND CLD_RETRAB != 'S' "
	
	
	
	
	cQuery += "	GROUP BY CLD_USERINC,RA_NOME,RA_SALARIO,CTT_DESC01 "
	cQuery += "	ORDER BY CTT_DESC01,3 DESC "



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

		cCodproduto 	:= cAlias->CTT_DESC01

		IncProc("Imprimindo tipo"+alltrim(cAlias->CTT_DESC01))
		//TB1.M0_CODFIL,M0_FILIAL,TB1.L1_NUM,TB1.C6_NUM,TB1.C6_NOTA,TB1.C6_SERIE,TB1.C6_DATFAT,A1_COD,A1_NOME,A3_NOME

		//TB1.E1_NUM,TB1.E1_PREFIXO,TB1.E1_NSUTEF,TB1.E1_TIPO,TB1.E1_PARCELA,TB1.E1_BASCOM1,TB1.E1_VALOR,TB1.E1_EMISSAO,TB1.E1_VENCTO,TB1.E1_BAIXA,TB1.E1_SALDO,
		//imprimo a primeira se็ใo
		oSection1:Cell("CTT_DESC01"):SetValue(cAlias->CTT_DESC01)
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->CTT_DESC01 == cCodproduto
			oReport:IncMeter()                                


			IncProc("Imprimindo funcionario"+alltrim(cAlias->CLA_USERINC))
			oSection2:Cell("CLA_USERINC"):SetValue(cAlias->CLA_USERINC)	
			oSection2:Cell("RA_NOME"):SetValue(cAlias->RA_NOME)
			oSection2:Cell("CLA_QUANT"):SetValue(cAlias->CLA_QUANT)
			oSection2:Cell("CLA_PONTOS"):SetValue(cAlias->CLA_PONTOS)
			oSection2:Cell("VALOR"):SetValue(cAlias->VALOR)
			oSection2:Cell("RA_SALARIO"):SetValue(cAlias->RA_SALARIO)
			oSection2:Cell("COMISSAO"):SetValue(cAlias->COMISSAO)
			oSection2:Cell("VALORDOPONTO"):SetValue(cAlias->VALORDOPONTO)
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

	u_InPutSX1(cPerg,"01",PADR("Emissใo De 	 ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้  ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Valor Ponto  ",20)+"?","","","mv_ch3","N",8,2,0,"G","","","","","mv_par03")  

Return
