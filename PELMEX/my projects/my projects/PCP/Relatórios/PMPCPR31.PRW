#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR30   ºAutor  ³Stan Lee Lopes	    				º Data ³  14/04/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Analise do PCP									        	   			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR31()
	Local oReport := nil
	Local cPerg:= Padr("PMPCPR31",10)

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


	oReport := TReport():New(cNOME,"Analise do Pick list",cNOME,{|oReport| ReportPrint(oReport)},"Analise do Pick list")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

	//Primeira seção


	oSection1:= TRSection():New(oReport, "Modelo", {"PRO"}, , .F., .T.)
	TRCell():New(oSection1,"G1_COMP"		   ,"cAlias","Modelo",,50)
	TRCell():New(oSection1,"COMPONENTE"		   ,"cAlias","Modelo",,50)
	TRCell():New(oSection1,"ESTRUTURA"		   ,"cAlias","Modelo",,50)
	TRCell():New(oSection1,"ARMAZEM01"	   ,"cAlias","Modelo",,50)
	TRCell():New(oSection1,"APAGAR"		       ,"cAlias","Modelo",,50)
	//	TRCell():New(oSection1,"C2_XNOME"	   ,"cAlias","Nome do Cliente",,50)

	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas



	//Quebra por Seção

/*
	oBreak := TRBreak():New(oSection1,oSection2:Cell("PRO_QUANT"),"TOTAL") 

	TRFunction():New(oSection2:Cell("PRO_QUANT"),"Total","SUM",oBreak,,,,.F.,.F.)
*/
	//Fim Quebra por Seção                                                       


	//Totalizador final
//	TRFunction():New(oSection2:Cell("PRO_QUANT"),"A produzir ","SUM", ,,"@E 9,999,999,999",,.F.,.T.)


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
	mv_par02 = ALLTRIM(mv_par02)
	mv_par01 = ALLTRIM(mv_par01)
	
	
	cQuery += " SELECT G1_COMP,COMPONENTE,SUM(ESTRUTURA) ESTRUTURA,[ARMAZEM 01] 'ARMAZEM01',[ARMAZEM 10]-SUM(ESTRUTURA)  'APAGAR' "
	cQuery += " FROM ( " 
	cQuery += " 		SELECT  PRO_PRODUTO,PRO_DESCRI,PRO_MODELO,PRO_QUANT, PRO_DATINC,G1_COMP,SB1.B1_DESC COMPONENTE,G1_QUANT,(G1_QUANT*PRO_QUANT)'ESTRUTURA', "
	cQuery += " 				SB21.B2_QATU-SB21.B2_QEMP 'ARMAZEM 01',SB210.B2_QATU-SB210.B2_QEMP 'ARMAZEM 10' "
	cQuery += " 			FROM ( "
	cQuery += " 							SELECT PRO_PRODUTO,PRO_DESCRI,PRO_MODELO,PRO_QUANT,CONVERT (VARCHAR,CAST(PRO_DATINC AS DATE),112) PRO_DATINC "
	cQuery += " 								FROM PRO "
	cQuery += " 								WHERE  CONVERT (VARCHAR,CAST(PRO_DATINC AS DATE),112) BETWEEN '"+DToS(mv_par03)+"' AND '"+DToS(mv_par04)+"' "
	cQuery += " 								AND (PRO_DESCRI LIKE '%"+mv_par02+"%' OR PRO_PRODUTO LIKE '%"+mv_par02+"%') "
	cQuery += " 								AND PRO_MODELO LIKE '%"+mv_par01+"%' "
	cQuery += " 				)TB "
	cQuery += " 			INNER JOIN SG1100 SG1 (NOLOCK) ON G1_COD = PRO_PRODUTO AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) "
	cQuery += " 			INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = B1_COD "
	cQuery += " 			INNER JOIN SB2100 SB21 (NOLOCK) ON G1_COMP = SB21.B2_COD AND SB21.B2_FILIAL = 01 AND  SB21.B2_LOCAL = '01' AND SB21.D_E_L_E_T_ = '' "
	cQuery += " 			INNER JOIN SB2100 SB210 (NOLOCK) ON G1_COMP = SB210.B2_COD AND SB210.B2_FILIAL = 01 AND SB210.B2_LOCAL = '10' AND SB21.D_E_L_E_T_ = '' "
	cQuery += " 			WHERE " 
	cQuery += " 			SG1.D_E_L_E_T_ = '' "
	cQuery += " 			GROUP BY PRO_PRODUTO,PRO_DESCRI,PRO_MODELO,PRO_QUANT, PRO_DATINC,G1_COMP,SB1.B1_DESC,G1_QUANT,SB21.B2_QATU,SB210.B2_QATU,SB21.B2_QEMP,SB210.B2_QEMP "
	cQuery += " )TB2 "
	cQuery += " GROUP BY G1_COMP,COMPONENTE,[ARMAZEM 01], [ARMAZEM 10] "
	cQuery += " HAVING [ARMAZEM 10]-SUM(ESTRUTURA)<0 "
	cQuery += " ORDER BY G1_COMP "

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

		cCodproduto 	:= cAlias->G1_COMP

		IncProc("Imprimindo COMPONENTES"+alltrim(cAlias->G1_COMP)) 

		//imprimo a primeira seção				
		oSection1:Cell("G1_COMP"):SetValue(cAlias->G1_COMP)
		oSection1:Cell("COMPONENTE"):SetValue(cAlias->COMPONENTE)
		oSection1:Cell("ESTRUTURA"):SetValue(cAlias->ESTRUTURA)
		oSection1:Cell("ARMAZEM01"):SetValue(cAlias->ARMAZEM01)
		oSection1:Cell("APAGAR"):SetValue(cAlias->APAGAR)
		//	oSection1:Cell("C2_XNOME"):SetValue(cAlias->C2_XNOME)       			
		oSection1:Printline()


		//inicializo a segunda seção
		oSection2:init()
		//TRFunction():EndSection(2) 

		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
	/*
		While cAlias->PRO_MODELO == cCodproduto
			oReport:IncMeter()		                                

			IncProc("Imprimindo produtos"+alltrim(cAlias->PRO_PRODUTO))
			oSection2:Cell("PRO_PRODUTO"):SetValue(cAlias->PRO_PRODUTO)
			oSection2:Cell("PRO_TIPO"):SetValue(cAlias->PRO_TIPO)
			oSection2:Cell("PRO_QUANT"):SetValue(cAlias->PRO_QUANT)
			oSection2:Cell("PRO_DATINC"):SetValue(cAlias->PRO_DATINC)
			oSection2:Printline()


			cAlias->(dbSkip())
		EndDo		
		*/
		//Aqui, farei uma quebra  por seção

		//finalizo a segunda seção para que seja reiniciada para o proximo registro
		//oSection2:Finish()
		//imprimo uma linha para separar os Títulos de outro
		oReport:ThinLine()
		//finalizo a primeira seção
		oSection1:Finish()
	Enddo


Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Modelo De?    	 ",20)+"","","","mv_ch1","C",14,0,0,"G","","SB1","","","mv_par01")   
	u_InPutSX1(cPerg,"02",PADR("Produto ou descricao?",20)+"","","","mv_ch2","C",14,0,0,"G","","SB1","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Emissao de?    	",20)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Emissao Ate?    ",20)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")

Return