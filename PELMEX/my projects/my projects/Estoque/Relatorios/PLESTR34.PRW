#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR34    ºAutor  ³Kledson Oliveira Andrade   		º Data ³  17/12/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Resumo de Incentivos ICMS 						  					 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR34()
	Local oReport := nil
	Local cPerg:= Padr("PLESTR34",10)

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


	oReport := TReport():New(cNOME,"Resumo de Incentivos ICMS",cNOME,{|oReport| ReportPrint(oReport)},"Resumo de Incentivos ICMS")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção



	oSection1:= TRSection():New(oReport, "COD_INCENTIVO",{"cAlias"} , , .F., .T.)

	TRCell():New(oSection1,"COD_INCENTIVO"		,"cAlias","Cod.Incentivo",,12)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas


	oSection2:= TRSection():New(oReport, "ESPECIE", {"cAlias"}, NIL, .F., .T.)
	//TRCell():New(oSection2,"TIPO"	   ,"cAlias","Tipo",,8)	
	TRCell():New(oSection2,"ESPECIE"	   	   ,"cAlias","Especie",,10)
	TRCell():New(oSection2,"CFOP"				,"cAlias","CFOP",/*Mascara*/,5)
	TRCell():New(oSection2,"VLR_CONTABIL"	   	,"cAlias","Vlr Contabil","@E 9,999,999,999.99",)     
	TRCell():New(oSection2,"BASE"				,"cAlias","Base","@E 9,999,999,999.99",)   
	TRCell():New(oSection2,"ICMS"	   			,"cAlias","ICMS","@E 9,999,999,999.99",)       

	oBreak := TRBreak():New(oSection2,oSection1:Cell("COD_INCENTIVO"),"Total Base/Total ICMS") 
	TRFunction():New(oSection2:Cell("VLR_CONTABIL"),"Total Vlr CTB","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("BASE"),"Total Base","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection2:Cell("ICMS"),"Total ICMS","SUM",oBreak,,,,.F.,.F.)

	//Fim Quebra por Seção

	//Totalizador final
	//TRFunction():New(oSection1:Cell("E1_BASCOM1"),"Total Bruto  ","SUM",,,"@E 9,999,999,99",,.F.,.T.) 

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
	Local cMascara  := "@E 9,999,999,999,999,999,999"
	Local lPrim 	:= .T.


cQuery := " SELECT F1_ESPECIE ESPECIE,CDA_CODLAN COD_INCENTIVO,D1_CF CFOP,ROUND(SUM(CDA_BASE),2)BASE,ROUND(SUM(CDA_VALOR),2)ICMS, ROUND(SUM(ISNULL(CTB,0)),2)VLR_CONTABIL  "
cQuery += " FROM(  "
cQuery += " SELECT F1_ESPECIE,D1_FILIAL,D1_DOC,D1_SERIE,D1_ITEM,D1_COD,D1_QUANT,D1_CF,CDA_CLIFOR,CDA_LOJA,D1_PICM,D1_VALICM,D1_BASEICM,CDA_BASE,CDA_VALOR,D1_TOTAL,CDA_TPMOVI,CDA_CODLAN, FT_VALCONT CTB "
cQuery += " FROM CDA100 CDA (NOLOCK) "
cQuery += " INNER JOIN SD1100 SD1 (NOLOCK) ON CDA_FILIAL = D1_FILIAL AND CDA_NUMERO = D1_DOC AND CDA_SERIE = D1_SERIE AND CDA_NUMITE = D1_ITEM AND CDA_CLIFOR = D1_FORNECE AND CDA_LOJA = D1_LOJA AND SD1.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN SF1100 SF1 (NOLOCK) ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND SF1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN SFT100 SFT (NOLOCK) ON D1_FILIAL = FT_FILIAL AND D1_DOC = FT_NFISCAL AND D1_SERIE = FT_SERIE AND D1_FORNECE = FT_CLIEFOR AND D1_ITEM = FT_ITEM AND D1_LOJA = FT_LOJA AND D1_COD = FT_PRODUTO AND SFT.D_E_L_E_T_ = '' "
cQuery += " WHERE CDA.D_E_L_E_T_ = '' "
cQuery += " AND D1_FILIAL = '01' "
cQuery += " AND D1_BASEICM > 0 "
cQuery += " AND D1_CF NOT IN ('5914','5916') "
cQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " AND F1_ESPECIE IN ('SPED','CTE') "
cQuery += " GROUP BY F1_ESPECIE,D1_FILIAL,D1_DOC,D1_SERIE,D1_ITEM,D1_COD,D1_QUANT,D1_CF,CDA_CLIFOR,CDA_LOJA,D1_PICM,D1_VALICM,D1_BASEICM,CDA_BASE,CDA_VALOR,D1_TOTAL,CDA_TPMOVI,CDA_CODLAN, FT_VALCONT "
cQuery += " )TB "
cQuery += " GROUP BY F1_ESPECIE,CDA_CODLAN,D1_CF "
cQuery += " UNION "
cQuery += " SELECT F2_ESPECIE,CDA_CODLAN,D2_CF,ROUND(SUM(CDA_BASE),2)BASE,ROUND(SUM(CDA_VALOR),2)ICMS, ROUND(SUM(ISNULL(CTB,0)),2)VLR_CONTABIL "
cQuery += " FROM( "
cQuery += " SELECT F2_ESPECIE,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_CF,CDA_CLIFOR,CDA_LOJA,D2_PICM,D2_VALICM,D2_BASEICM,CDA_BASE,CDA_VALOR,D2_TOTAL,CDA_TPMOVI,CDA_CODLAN, FT_VALCONT CTB "
cQuery += " FROM CDA100 CDA (NOLOCK) "
cQuery += " INNER JOIN SD2100 SD2 (NOLOCK) ON CDA_FILIAL = D2_FILIAL AND CDA_NUMERO = D2_DOC AND CDA_SERIE = D2_SERIE AND CDA_NUMITE = D2_ITEM AND CDA_CLIFOR = D2_CLIENTE AND CDA_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN SF2100 SF2 (NOLOCK) ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND SF2.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN SFT100 SFT (NOLOCK) ON D2_FILIAL = FT_FILIAL AND D2_DOC = FT_NFISCAL AND D2_SERIE = FT_SERIE AND D2_ITEM = FT_ITEM AND D2_CLIENTE = FT_CLIEFOR AND D2_LOJA = FT_LOJA AND D2_COD = FT_PRODUTO AND SFT.D_E_L_E_T_ = '' "
cQuery += " WHERE CDA.D_E_L_E_T_ = '' "
cQuery += " AND D2_FILIAL = '01' "
cQuery += " AND D2_BASEICM > 0 "  
cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' " 
cQuery += " AND F2_ESPECIE IN ('SPED') " 
cQuery += " GROUP BY F2_ESPECIE,D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_CF,CDA_CLIFOR,CDA_LOJA,D2_PICM,D2_VALICM,D2_BASEICM,CDA_BASE,FT_VALCONT,CDA_VALOR,D2_TOTAL,CDA_TPMOVI,CDA_CODLAN" 
cQuery += " )TB "  
cQuery += " GROUP BY F2_ESPECIE,CDA_CODLAN,D2_CF " 
cQuery += " ORDER BY 2,1 "




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
			cCodIncentivo 	:= cAlias->COD_INCENTIVO
			IncProc("Imprimindo Resumo"+alltrim(cAlias->COD_INCENTIVO))
		//imprimo a primeira seção				
			oSection1:Cell("COD_INCENTIVO"):SetValue(cAlias->COD_INCENTIVO)   
		oSection1:Printline()

		//inicializo a segunda seção

		oSection2:init()
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While cAlias->COD_INCENTIVO == cCodIncentivo
			oReport:IncMeter()		                                
			IncProc("Imprimindo Valores"+alltrim(cAlias->ESPECIE))
			oSection2:Cell("ESPECIE"):SetValue(cAlias->ESPECIE)
			oSection2:Cell("CFOP"):SetValue(cAlias->CFOP)
			oSection2:Cell("VLR_CONTABIL"):SetValue(cAlias->VLR_CONTABIL)			
			oSection2:Cell("BASE"):SetValue(cAlias->BASE)
			oSection2:Cell("ICMS"):SetValue(cAlias->ICMS)
			
			//oSection2:Cell("F4_TEXTO"):SetValue(cAlias->F4_TEXTO)	
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

	u_InPutSX1(cPerg,"01",PADR("Dt. Emissao/Digitacao De    ? ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
	u_InPutSX1(cPerg,"02",PADR("Dt. Emissao/Digitacao Ate   ? ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return
