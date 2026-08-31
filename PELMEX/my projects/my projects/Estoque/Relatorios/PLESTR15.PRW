#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Ultima Entrada Estrutura					        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR15()
	Local oReport := nil
	Local cPerg:= "PLESTR15"

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


	oReport := TReport():New(cNOME,"Relat๓rio Custo do PA",cNOME,{|oReport| ReportPrint(oReport)},"Custo de produto")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira se็ใo



	oSection1:= TRSection():New(oReport, "Produto", {"SG1"}, , .F., .T.)
	TRCell():New(oSection1,"G1_COD"		   ,"cAlias","Codigo do PA","@!",17)
	TRCell():New(oSection1,"PRODUTO"	   ,"cAlias","Descri็ใo do PA",,50)
	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Componentes", {"SG1"}, NIL, .F., .T.)
	TRCell():New(oSection2,"G1_COMP"	    		,"cAlias","Componente",,)
	TRCell():New(oSection2,"COMPONENTE"		    	,"cAlias","Descri็ใo do componente",,50)
    TRCell():New(oSection2,"G1_QUANT"				,"cAlias","Quantidade","@E 9,999,999,999.9999",)    
	TRCell():New(oSection2,"B2_CM1"					,"cAlias","Custo Medio",/*Mascara*/,)
	TRCell():New(oSection2,"ULT_ENTRADA"			,"cAlias","Proco Ult. Entrada","@E 9,999,999,999.99",)    
	TRCell():New(oSection2,"TOTAL_CM"				,"cAlias","Total Custo Medio","@E 9,999,999,999.99999999",50)  
	TRCell():New(oSection2,"TOTAL_ULT"				,"cAlias","Total Ult. Entrada","@E 9,999,999,999.99999999",50)  
	//Quebra por Se็ใo
	oBreak := TRBreak():New(oSection2,oSection1:Cell("G1_COD"),"Total por Produto") 
	TRFunction():New(oSection2:Cell("TOTAL_CM"),"Total Custo Medio","SUM",oBreak,,,,.F.,.F.) 
	TRFunction():New(oSection2:Cell("TOTAL_ULT"),"Total Ult.Entrada","SUM",oBreak,,,,.F.,.F.) 
	//Fim Quebra por Se็ใo

	//Totalizador final
	//TRFunction():New(oSection2:Cell("TOTAL"),"CUSTO TOTAL DO PEDIDO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)




	//Totalizador

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

	cQuery := " SELECT	G1_COD,SB1.B1_DESC PRODUTO,G1_COMP,SB12.B1_DESC COMPONENTE,G1_QUANT,SB12.B1_UPRC ULT_ENTRADA,B2_CM1, G1_QUANT*B2_CM1 TOTAL_CM,SB12.B1_UPRC * G1_QUANT TOTAL_ULT  "
	cQuery += " FROM "+RETSQLNAME("SG1")+" SG1 (NOLOCK) "
	cQuery += " INNER JOIN "+RETSQLNAME("SB2")+" SB2 (NOLOCK)  ON SB2.B2_FILIAL = SG1.G1_FILIAL AND G1_COMP = B2_COD AND SB2.D_E_L_E_T_='' "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB1 (NOLOCK) ON SB1.B1_COD = SG1.G1_COD AND SB1.D_E_L_E_T_ = ''  "
	cQuery += " INNER JOIN "+RETSQLNAME("SB1")+" SB12 (NOLOCK) ON SB12.B1_COD = SG1.G1_COMP AND SB12.D_E_L_E_T_ = ''  "
	cQuery += " WHERE "
	cQuery += " SG1.D_E_L_E_T_ = '' "
	cQuery += " AND SG1.G1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "    
	cQuery += " AND SB2.B2_FILIAL = '01' "
	cQuery += " AND SB2.B2_LOCAL = '10' "
	cQuery += " AND SB1.B1_TIPO IN ('MN','MI','MA','PI','MO','PA') "
	cQuery += " GROUP BY G1_COD,SB1.B1_DESC,G1_COMP,SB12.B1_DESC,G1_QUANT,B2_CM1,SB12.B1_UPRC "
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

		//inicializo a primeira se็ใo
		oSection1:Init()

		oReport:IncMeter()

		cCodproduto 	:= cAlias->G1_COD

		IncProc("Imprimindo Produto"+alltrim(cAlias->G1_COD))

		//imprimo a primeira se็ใo				
		oSection1:Cell("G1_COD"):SetValue(cAlias->G1_COD)
		oSection1:Cell("PRODUTO"):SetValue(cAlias->PRODUTO)       			
		oSection1:Printline()

		//inicializo a segunda se็ใo
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM ้ mesmo, se sim, imprimo o produto
		While cAlias->G1_COD == cCodproduto
			oReport:IncMeter()		                                


			IncProc("Imprimindo Componentes"+alltrim(cAlias->G1_COMP))
			oSection2:Cell("G1_COMP"):SetValue(cAlias->G1_COMP)
			oSection2:Cell("COMPONENTE"):SetValue(cAlias->COMPONENTE)
			oSection2:Cell("G1_QUANT"):SetValue(cAlias->G1_QUANT)
			oSection2:Cell("B2_CM1"):SetValue(cAlias->B2_CM1)			
			oSection2:Cell("TOTAL_CM"):SetValue(cAlias->TOTAL_CM)		
			oSection2:Cell("TOTAL_ULT"):SetValue(cAlias->TOTAL_ULT)		

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

	u_InPutSX1(cPerg,"01",PADR("Produto De  ?    ",20)+"","","","mv_ch1","C",16,0,0,"G","","SB1","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Produto At้ ?    ",20)+"","","","mv_ch2","C",16,0,0,"G","","SB1","","","mv_par02")

Return
