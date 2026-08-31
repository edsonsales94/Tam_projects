#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR12   บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Faturamento X Estado							        	   			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR18()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR18",10)

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


	oReport := TReport():New(cNOME,"Faturamento X Estado",cNOME,{|oReport| ReportPrint(oReport)},"Faturamento X Estado")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Estado", {"SA1"}, , .F., .T.)
	TRCell():New(oSection1,"A1_EST"		   ,"cAlias","Estado",,)
	TRCell():New(oSection1,"CC2_MUN"	   ,"cAlias","Municipio",,) 
	//	TRCell():New(oSection1,"C2_XNOME"	   ,"cAlias","Nome do Cliente",,50)

	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produtos", {"SB1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"B1_COD"	    			,"cAlias","Cod",,)
	TRCell():New(oSection2,"B1_DESC"		    	,"cAlias","Descri็ใo",,)    
	TRCell():New(oSection2,"C6_QTDVEN"				,"cAlias","ม Faturar","@E 9,999,999,999",) 
	TRCell():New(oSection2,"B2_QATU"	    		,"cAlias","Saldo em estoque","@E 9,999,999,999",)
	TRCell():New(oSection2,"B1_XALTURA"		    	,"cAlias","Altura","@E 9,999,999,999.9999",)    
	TRCell():New(oSection2,"B1_XCOMPRI"				,"cAlias","Comprimento","@E 9,999,999,999.9999",)
	TRCell():New(oSection2,"B1_XLARGUR"				,"cAlias","Largura","@E 9,999,999,999.9999",) 
	TRCell():New(oSection2,"CUBAGEM"				,"cAlias","Cubagem","@E 9,999,999,999.99999",) 
	//Quebra por Se็ใo



	oBreak := TRBreak():New(oSection1,oSection2:Cell("CUBAGEM"),"Totais") 

	TRFunction():New(oSection2:Cell("CUBAGEM"),"CUBAGEM","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("C6_QTDVEN"),"Total de vendas","SUM",oBreak,,,,.F.,.F.)

	//Fim Quebra por Se็ใo                                                       


	//Totalizador final
	TRFunction():New(oSection2:Cell("CUBAGEM"),"QUANTIDADE TOTAL","SUM",,,"@E 9,999,999,999.9999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("C6_QTDVEN"),"QUANTIDADE TOTAL","SUM",,,"@E 9,999,999,999.9999",,.F.,.T.)



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


	cQuery := " SELECT B1_COD,B1_DESC,B1_UM,SUM(C6_QTDVEN)C6_QTDVEN,B2_QATU,A1_EST,CC2_MUN,B1_XALTURA,B1_XCOMPRI,B1_XLARGUR, (SUM(C6_QTDVEN)*ISNULL(B1_XALTURA,0)*ISNULL(B1_XCOMPRI,0)*ISNULL(B1_XLARGUR,0)) CUBAGEM "
	cQuery += " FROM "+ RetSQLName("SC6")+" SC6 "
	cQuery += " INNER JOIN "+ RetSQLName("SC5")+" SC5 (NOLOCK) ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = '' AND SC5.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+ RetSQLName("SB1")+" SB1 (NOLOCK) ON SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " INNER JOIN "+ RetSQLName("SB2")+" SB2 (NOLOCK) ON SB2.B2_COD = SC6.C6_PRODUTO AND B2_LOCAL = C6_LOCAL AND B2_FILIAL = '01' "
	cQuery += " FULL JOIN "+ RetSQLName("SA1")+" SA1 (NOLOCK) ON SA1.A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "
	cQuery += " FULL JOIN "+ RetSQLName("CC2")+" CC2 (NOLOCK) ON CC2.CC2_CODMUN = A1_COD_MUN AND CC2_EST = A1_EST "
	cQuery += " WHERE SC6.D_E_L_E_T_ = '' " 
	cQuery += " AND SC6.C6_FILIAL = '01' "
	cQuery += " AND SC6.C6_LOCAL = '20' "
	cQuery += " AND SC6.C6_QTDVEN != SC6.C6_QTDENT "
	cQuery += " AND SC6.C6_ENTREG BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	cQuery += " AND SA1.A1_EST BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " AND SB1.B1_TIPO = 'PA' "
	cQuery += " GROUP BY B1_COD,B1_DESC,B1_UM,B2_QATU,A1_EST,CC2_MUN,B1_XALTURA,B1_XCOMPRI,B1_XLARGUR "
	cQuery += " ORDER BY A1_EST,CC2_MUN,4 DESC "


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


		cCodproduto 	:= cAlias->A1_EST+cAlias->CC2_MUN

		IncProc("Imprimindo Estados"+alltrim(cAlias->A1_EST)) 

		//imprimo a primeira se็ใo				
		oSection1:Cell("A1_EST"):SetValue(cAlias->A1_EST)
		oSection1:Cell("CC2_MUN"):SetValue(cAlias->CC2_MUN)
		//	oSection1:Cell("C2_XNOME"):SetValue(cAlias->C2_XNOME)       			
		oSection1:Printline()


		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 		
		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->A1_EST+cAlias->CC2_MUN == cCodproduto
			oReport:IncMeter()		                                

			IncProc("Imprimindo Produtos "+alltrim(cAlias->B1_DESC))
			oSection2:Cell("B1_COD"):SetValue(cAlias->B1_COD)
			oSection2:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)
			oSection2:Cell("C6_QTDVEN"):SetValue(cAlias->C6_QTDVEN)
			oSection2:Cell("B2_QATU"):SetValue(cAlias->B2_QATU)
			oSection2:Cell("B1_XALTURA"):SetValue(cAlias->B1_XALTURA)
			oSection2:Cell("B1_XCOMPRI"):SetValue(cAlias->B1_XCOMPRI)
			oSection2:Cell("B1_XLARGUR"):SetValue(cAlias->B1_XLARGURA)  
			oSection2:Cell("CUBAGEM"):SetValue(cAlias->CUBAGEM)  
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
	u_InPutSX1(cPerg,"03",PADR("Estado De  ?     ",20)+"","","","mv_ch3","C",2,0,0,"G","","CC2","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Estado At้ ?     ",20)+"","","","mv_ch4","C",2,0,0,"G","","CC2","","","mv_par04") 


Return