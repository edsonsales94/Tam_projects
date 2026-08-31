#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR57    ºAutor  ³KLEDSON OLIVEIRA    				º Data ³  05/12/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Onde é usado?(Customizado)		   						     			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PLPROR57()
	Local oReport := nil
	Local cPerg:= Padr("PLPROR57",10)

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

	oReport := TReport():New(cNOME,"Onde é usado?(Customizado)",cNOME,{|oReport| ReportPrint(oReport)},"custo")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8

	//Primeira seção
	


	oSection1:= TRSection():New(oReport, "Componente", {"cAlias"}, , .F., .T.)
	
	TRCell():New(oSection1,"G1_COMP"	,"cAlias","Componente","@!",15)
	TRCell():New(oSection1,"DESCPI"	    ,"cAlias","Descricao PI","@!",20)
	TRCell():New(oSection1,"TIPOPI"		   ,"cAlias","TP","@!",2)
	TRCell():New(oSection1,"GRUPOPI"		   ,"cAlias","Grupo","@!",4)
	TRCell():New(oSection1,"UMPI"		   ,"cAlias","UM","@!",4)


	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Produto", {"cAlias"}, NIL, .F., .T.)

	//TRCell():New(oSection2,"DENSIDADE"      ,"cAlias","Densidade",,20)
	TRCell():New(oSection2,"B1_COD"		,"cAlias","CodigoPA","@!",20)
	TRCell():New(oSection2,"DESCPA"	        ,"cAlias","DescricaoPA","@!",50)
	TRCell():New(oSection2,"GRUPOPA"	        ,"cAlias","GrupoPA","@!",4)
	TRCell():New(oSection2,"UMPA"	        ,"cAlias","UM PA","@!",2)
	TRCell():New(oSection2,"G1_NIV"	        ,"cAlias","Nivel","@!",2)
	TRCell():New(oSection2,"G1_QUANT"	        ,"cAlias","Qtd. PI","@E 9,999,999,999.99",)



	//TRCell():New(oSection2,"QTD_PRODUZIDA"	,"cAlias","Qtd.Produzida","@E 9,999,999,999.99",)
	//TRCell():New(oSection2,"STATUS"			,"cAlias","Status",,20)
	//Quebra por Seção
	//oBreak := TRBreak():New(oSection2,oSection1:Cell("G1_XDENSID"),"Densidade")
	//TRFunction():New(oSection2:Cell("PONTAS"),"Total Pontas","SUM",oBreak,,,,.F.,.F.)
	//TRFunction():New(oSection2:Cell("QTD_PRODUZIDA"),"Total","SUM",oBreak,,,,.F.,.F.)
	//Fim Quebra por Seção

	//Totalizador final
	//TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
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
	Local lPrim 	:= .T.
	
    cQuery := " SELECT G1_COMP,SB12.B1_DESC DESCPI,SB12.B1_TIPO TIPOPI,SB12.B1_GRUPO GRUPOPI,SB12.B1_UM UMPI, "
    cQuery += "SB1.B1_COD,SB1.B1_DESC DESCPA,SB1.B1_TIPO TIPOPA,SB1.B1_GRUPO GRUPOPA,SB1.B1_UM UMPA,G1_NIV,G1_QUANT "
    cQuery += "FROM SG1100 SG1 (NOLOCK) "
    cQuery += "INNER JOIN SB1100 SB1 (NOLOCK) ON SG1.G1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' AND SB1.B1_MSBLQL != '1' " 
    cQuery += "INNER JOIN SB1100 SB12 (NOLOCK) ON SG1.G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = '' "
    cQuery += "WHERE SG1.D_E_L_E_T_ = '' "
    cQuery += "AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) "
    cQuery += "AND G1_COMP BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += "ORDER BY G1_COMP ASC "


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



		cSetor 	:= cAlias->G1_COMP

		//IncProc("Imprimindo Estrutura "+alltrim(cAlias->CODIGO))

		//imprimo a primeira seção

		oSection1:Cell("G1_COMP"):SetValue(cAlias->G1_COMP)
		oSection1:Cell("DESCPI"):SetValue(cAlias->DESCPI)
		//oSection1:Cell("DTAMAZON"):SetValue(cAlias->DTAMAZON)
		oSection1:Printline()

		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2)

		//verifico se o Setor é mesmo, se sim, imprimo Estrutura
		While cAlias->G1_COMP == cSetor
			oReport:IncMeter()

			IncProc("Imprimindo Relatorio "+alltrim(cAlias->G1_COMP))
			//oSection2:Cell("LARGURA"):SetValue(cAlias->LARGURA)
			//oSection2:Cell("PONTAS"):SetValue(cAlias->PONTAS)
			//oSection2:Cell("QTD_PLANEJADA"):SetValue(cAlias->QTD_PLANEJADA)
			//oSection2:Cell("QTD_PRODUZIDA"):SetValue(cAlias->QTD_PRODUZIDA)
			//oSection2:Cell("STATUS"):SetValue(cAlias->STATUS)
			oSection2:Printline()

			cAlias->(dbSkip())
		EndDo*/
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
    u_InPutSX1(cPerg,"01",PADR("De Componente?    ",20)+"","","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Componente?    ",20)+"","","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02") 
Return
