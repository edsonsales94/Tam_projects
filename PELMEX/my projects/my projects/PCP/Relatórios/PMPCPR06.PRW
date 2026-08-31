#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR06    ºAutor  ³Stan Lee Lopes     				º Data ³  29/04/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Posição das OP's Geradas	  						        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR06()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR06"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oBreak
	Local aOrdem      := {"FILIAL"}

	oReport := TReport():New(cPerg,"Posição das OP's Geradas",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Posição das OP's Geradas",{"SC2"},aOrdem)     


	TRCell():New(oSection,"C2_NUM"		        	,"SC2","Número OP",,)
	TRCell():New(oSection,"C2_PRODUTO"	    		,"SC2","Cod. Produto",,)
	TRCell():New(oSection,"B1_DESC"					,"SB1","Descrição",/*Mascara*/,) 
	TRCell():New(oSection,"C2_UM"					,"SC2","Unidade",/*Mascara*/,) 
	TRCell():New(oSection,"C2_LOCAL"				,"SC2","Armazém",/*Mascara*/,) 
	TRCell():New(oSection,"C2_QUANT"	        	,"SC2","Qtd.Solicitada",'@E 9,999,999.99',)
	TRCell():New(oSection,"C2_QUJE"		        	,"SC2","Qtd.Atendida",'@E 9,999,999.99',)
	TRCell():New(oSection,"C2_EMISSAO"     			,"SC2","Dt.Emissão",/*Mascara*/,12)
	TRCell():New(oSection,"C2_DATRF"	       		,"SC2","Dt.Apontamento",/*Mascara*/,12)     
	TRCell():New(oSection,"C2_OBS"      			,"SC2","Observação",/*Mascara*/,20)  
	TRCell():New(oSection,"C2_XNOME"      			,"SC2","Cliente",/*Mascara*/,20)
	//TRCell():New(oSection,"C2_XCARGA"      			,"SC2","Carga",/*Mascara*/,12)
	TRCell():New(oSection,"STATUS"      			,"SC2","Status",/*Mascara*/,35)
	//TRCell():New(oSection,('000169')	,"SC2","Usuário",/*Mascara*/,35)
	//TRCell():New(oSection,FWLeUserlg("C2_USERLGA",2)	,"SC2","Usuário",/*Mascara*/,35)

	//Totalizador
	/*                                                                                  

	TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

		SELECT C2_NUM,C2_PRODUTO,B1_DESC,C2_UM,C2_LOCAL,C2_QUANT,C2_QUJE,C2_EMISSAO,C2_DATRF,C2_OBS,
		CASE WHEN (C2_QUANT = C2_QUJE) THEN 'OP APONTADA'
		WHEN (C2_QUJE > 0 AND C2_QUJE < C2_QUANT) THEN 'OP APONTADA PARCIAL'
		WHEN (C2_QUJE > C2_QUANT) THEN 'OP COM PROBLEMA DE CONSUMO' 
		WHEN C2_QUJE = 0 THEN 'OP PENDENTE DE APONTAMENTO' 
	END [STATUS],
	C2_USERLGA,
	C2_XNOME
	FROM %Table:SC2% SC2(NOLOCK)
	INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC2.C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
	WHERE SC2.D_E_L_E_T_ = '' 
	AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND C2_LOCAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%    
	AND C2_PRODUTO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	ORDER BY 1,8

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Emissão De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Emissão Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	PutSX1(cPerg,"03",PADR("Armazém De    ",20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
	PutSX1(cPerg,"04",PADR("Armazém Até   ",20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04") 
	PutSX1(cPerg,"03",PADR("Produto De    ",20)+"?","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05") 
	PutSX1(cPerg,"04",PADR("Produto Até   ",20)+"?","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06") 

Return