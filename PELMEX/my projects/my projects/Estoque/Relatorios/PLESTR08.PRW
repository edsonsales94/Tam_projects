#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR08    ºAutor  ³WILSON GUEDES	    				º Data ³  02/07/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório Custo de produto							        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR08()
	Local oReport := nil
	Local cPerg:= Padr("PLESTR08",10)

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


	oReport := TReport():New(cNOME,"Relatório Custo de produto",cNOME,{|oReport| ReportPrint(oReport)},"Custo de produto")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção



	oSection1:= TRSection():New(oReport, "Produto", {"SG1"}, , .F., .T.)
	TRCell():New(oSection1,"G1_COD"		   ,"cAlias","Codigo do produto","@!",17)
	TRCell():New(oSection1,"PRODUTO"	   ,"cAlias","Descrição do produto",,50)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Componentes", {"SG1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"G1_COD"					,"cAlias","Codigo do produto","@!",17)
	TRCell():New(oSection2,"G1_COMP"	    		,"cAlias","Componente",,)
	TRCell():New(oSection2,"COMPONENTE"		    	,"cAlias","Descrição do componente",,50)
	TRCell():New(oSection2,"G1_QUANT"				,"cAlias","Quantidade",/*Mascara*/,)
	TRCell():New(oSection2,"B1_UPRC"				,"cAlias","Custo da Ultima Entrada",/*Mascara*/,)
	TRCell():New(oSection2,"CAMZ01"					,"cAlias","Custo do Amz 01",/*Mascara*/,)
	TRCell():New(oSection2,"CAMZ10"					,"cAlias","Custo do Amz 10",/*Mascara*/,)
	TRCell():New(oSection2,"TOTAL_UPRC"				,"cAlias","Total da Ultima Entrada",/*Mascara*/,)
	TRCell():New(oSection2,"TOTAL_AMZ01"			,"cAlias","Total do Amz 01",/*Mascara*/,)
	TRCell():New(oSection2,"TOTAL_AMZ10"			,"cAlias","Total do Amz 10",/*Mascara*/,)
	//Quebra por Seção
	oBreak := TRBreak():New(oSection2,oSection1:Cell("G1_COD"),"Total por Produto") 
	TRFunction():New(oSection2:Cell("G1_QUANT"),"Total por Custos","SUM",oBreak,,,,.F.,.F.) 
	TRFunction():New(oSection2:Cell("B1_UPRC"),"Total por Custos","SUM",oBreak,,,,.F.,.F.) 
	TRFunction():New(oSection2:Cell("CAMZ01"),"Total por Custos","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("CAMZ10"),"Total por Custos","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Seção

	//Totalizador final
	TRFunction():New(oSection2:Cell("G1_QUANT"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.999999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("B1_UPRC"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.999999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("CAMZ01"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.999999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("CAMZ10"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.999999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("TOTAL_UPRC"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.999999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("TOTAL_AMZ01"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.999999",,.F.,.T.)
	TRFunction():New(oSection2:Cell("TOTAL_AMZ10"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.999999",,.F.,.T.)




	//Totalizador

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

	cQuery := " SELECT	G1_COD,SB1.B1_DESC PRODUTO,G1_COMP,SB12.B1_DESC COMPONENTE,G1_QUANT,SB12.B1_UPRC B1_UPRC,SB2.B2_CM1 CAMZ01,SB22.B2_CM1 CAMZ10,G1_QUANT*SB12.B1_UPRC TOTAL_UPRC,G1_QUANT*SB2.B2_CM1 TOTAL_AMZ01,G1_QUANT*SB22.B2_CM1 TOTAL_AMZ10"
	cQuery += " FROM "+RETSQLNAME("SG1")+" SG1 (NOLOCK) "
	cQuery += " LEFT JOIN "+RETSQLNAME("SB2")+" SB2 (NOLOCK)  ON SB2.B2_FILIAL = SG1.G1_FILIAL AND G1_COMP = SB2.B2_COD AND SB2.D_E_L_E_T_=''  AND SB2.B2_LOCAL = '01' "
	cQuery += " LEFT JOIN "+RETSQLNAME("SB2")+" SB22 (NOLOCK)  ON SB22.B2_FILIAL = SG1.G1_FILIAL AND G1_COMP = SB22.B2_COD AND SB22.D_E_L_E_T_='' AND SB22.B2_LOCAL = '10' "
	cQuery += " LEFT JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK) ON SB1.B1_COD = SG1.G1_COD AND SB1.D_E_L_E_T_ = ''  "
	cQuery += " LEFT JOIN "+RETSQLNAME("SB1")+" SB12 (NOLOCK) ON SB12.B1_COD = SG1.G1_COMP AND SB12.D_E_L_E_T_ = ''  "
	cQuery += " WHERE "
	cQuery += " SG1.D_E_L_E_T_ = '' "
	cQuery += " AND SG1.G1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "    
	cQuery += " AND SG1.G1_FIM >= '"+DToS(DDATABASE)+"' " 
	

	cQuery += " AND SB1.B1_TIPO IN ('MN','MI','MA','PI','MO','PA') "
	cQuery += " GROUP BY G1_COD,SB1.B1_DESC,G1_COMP,SB12.B1_DESC,G1_QUANT,SB2.B2_CM1,SB12.B1_UPRC,G1_TRT,SB22.B2_CM1 "
	cQuery += " ORDER BY SG1.G1_COD,SG1.G1_COMP "


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

		cCodproduto 	:= cAlias->G1_COD

		IncProc("Imprimindo Produto"+alltrim(cAlias->G1_COD))

		//imprimo a primeira seção				
		oSection1:Cell("G1_COD"):SetValue(cAlias->G1_COD)
		oSection1:Cell("PRODUTO"):SetValue(cAlias->PRODUTO)       			
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->G1_COD == cCodproduto
			oReport:IncMeter()		                                


			IncProc("Imprimindo Componentes"+alltrim(cAlias->G1_COD))
			oSection2:Cell("G1_COD"):SetValue(cAlias->G1_COD)
			oSection2:Cell("G1_COMP"):SetValue(cAlias->G1_COMP)
			oSection2:Cell("COMPONENTE"):SetValue(cAlias->COMPONENTE)
			oSection2:Cell("G1_QUANT"):SetValue(cAlias->G1_QUANT)
			oSection2:Cell("B1_UPRC"):SetValue(cAlias->B1_UPRC)
			oSection2:Cell("CAMZ01"):SetValue(cAlias->CAMZ01)	
			oSection2:Cell("CAMZ10"):SetValue(cAlias->CAMZ10)				
			

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

	u_InPutSX1(cPerg,"01",PADR("Produto De  ?    ",20)+"","","","mv_ch1","C",16,0,0,"G","","SB1","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Produto Até ?    ",20)+"","","","mv_ch2","C",16,0,0,"G","","SB1","","","mv_par02")

Return
