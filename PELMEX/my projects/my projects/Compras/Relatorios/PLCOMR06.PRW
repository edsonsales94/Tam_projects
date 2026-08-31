#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLCOMR06   ºAutor  ³WILSON GUEDES	    				º Data ³  08/06/20 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  FORMAÇÃO DE COMPRAS								        	   			 ±
±±º          ³  foi feito um relatorio baseado no IMPSZ2                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLCOMR06()
	Local oReport := nil
	Local cPerg:= Padr("PLCOMR06",10)

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


	oReport := TReport():New(cNOME,"Formação de Preço",cNOME,{|oReport| ReportPrint(oReport)},"Formação de preço")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção



	oSection1:= TRSection():New(oReport, "Produto", {"SZ2"}, , .F., .T.)
	TRCell():New(oSection1,"Z2_COD"		   ,"cAlias","Cod.Produto",,)
	TRCell():New(oSection1,"B1_DESC"	   ,"cAlias","Descrição",,)                                                                                             
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Componentes", {"SZ2"}, NIL, .F., .T.)
	TRCell():New(oSection2,"Ordem"	    			,"cAlias","Ordem",,)
	TRCell():New(oSection2,"Z2_COMP"		    	,"cAlias","Cod.Componente",,20)    
	TRCell():New(oSection2,"Z2_DESCMP"				,"cAlias","Descrição",/*Mascara*/,) 
	TRCell():New(oSection2,"Z2_UNICMP"	    		,"cAlias","Unidade",,10)
	TRCell():New(oSection2,"Z2_QUANT"		    	,"cAlias","Quantidade",,)    
	TRCell():New(oSection2,"Z2_CUSTO"				,"cAlias","Custo",/*Mascara*/,6)
	TRCell():New(oSection2,"Z2_TOTAL"				,"cAlias","Total",/*Mascara*/,12) 
	TRCell():New(oSection2,"Z2_PERPAR"				,"cAlias","% do Material","@E999.99",12)  	
	//Quebra por Seção



	oBreak := TRBreak():New(oSection2,oSection1:Cell("Z2_COD"),"TOTAL") 

	TRFunction():New(oSection2:Cell("Z2_QUANT"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("Z2_CUSTO"),"Total","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("Z2_TOTAL"),"Total","SUM",oBreak,,,,.F.,.F.)


	//Fim Quebra por Seção                                                       


	//Totalizador final
	TRFunction():New(oSection2:Cell("Z2_QUANT"),"Quantidade","SUM", ,,"@E 9,999,999,999.9999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("Z2_CUSTO"),"Custo por unidade Total","SUM", ,,"@E 9,999,999,999.9999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("Z2_TOTAL"),"Total Gasto","SUM", ,,"@E 9,999,999,999.9999",,.F.,.T.)



	//Totalizador                                                                                                          MIC

	/* 

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
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
	Local lPrim 	:= .T.
	Local nCount 	:= 0


	cQuery := "Select Case When Z2_COMP Like 'FATOR%'	Then '2' Else				 '1'End  Ordem,Z2_COD,B1_DESC,Z2_COMP,Z2_DESCMP,Z2_UNICMP,Z2_QUANT,Z2_CUSTO,Z2_TOTAL,Z2_PERPAR  "
	cQuery += " From SZ2100 As Z2 "
	cQuery += " INNER JOIN SB1100 As SB1 ON SB1.B1_COD = Z2_COD "
	cQuery += " Where Z2.D_E_L_E_T_ = '' "
	cQuery += " And Z2_FILIAL = '" + SZ2->(xFilial()) + "'" "
	cQuery += " And B1_COD BetWeen '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " And B1_GRUPO BetWeen '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += " And B1_TIPO BetWeen '"+mv_par05+"' AND '"+mv_par06+"' "
	cQuery += " ORDER BY Z2_COD"




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


		cCodproduto 	:= cAlias->Z2_COD

		IncProc("Imprimindo Produto"+alltrim(cAlias->Z2_COD)) 



		//imprimo a primeira seção				
		oSection1:Cell("Z2_COD"):SetValue(cAlias->Z2_COD)
		oSection1:Cell("B1_DESC"):SetValue(cAlias->B1_DESC)

		oSection1:Printline()


		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->Z2_COD == cCodproduto
			oReport:IncMeter()		                                

			IncProc("Imprimindo Componentes"+alltrim(cAlias->Z2_COMP))
			oSection2:Cell("Ordem"):SetValue(cAlias->Ordem)
			oSection2:Cell("Z2_COMP"):SetValue(cAlias->Z2_COMP)
			oSection2:Cell("Z2_DESCMP"):SetValue(cAlias->Z2_DESCMP)
			oSection2:Cell("Z2_UNICMP"):SetValue(cAlias->Z2_UNICMP)
			oSection2:Cell("Z2_QUANT"):SetValue(cAlias->Z2_QUANT)
			oSection2:Cell("Z2_CUSTO"):SetValue(cAlias->Z2_CUSTO)
			oSection2:Cell("Z2_TOTAL"):SetValue(cAlias->Z2_TOTAL)  
			oSection2:Cell("Z2_PERPAR"):SetValue(cAlias->Z2_PERPAR)  
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

	u_InPutSX1(cPerg,"01",PADR("Cod De  ?    	 ",20)+"","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Cod Até ?    	 ",20)+"","","","mv_ch2","C",15,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Grupo De  ?",20)+"","","","mv_ch3","C",4,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Grupo Até ?",20)+"","","","mv_ch4","C",4,0,0,"G","","","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("Centro de Custo De  ?    ",20)+"","","","mv_ch5","C",9,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Centro de Custo Até ?    ",20)+"","","","mv_ch6","C",9,0,0,"G","","","","","mv_par06")


Return