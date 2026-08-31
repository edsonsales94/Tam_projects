#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR16    บAutor  ณStan Lee Lopes     				บ Data ณ  01/01/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Cobran็a da produ็ใo 				    								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR16()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR16"

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

	oReport := TReport():New(cPerg,"Monitoramento das Ordens de Produ็ใo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()                                                                                                                      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Monitoramento das Ordens de Produ็ใo",{"SC2"},aOrdem) 


	TRCell():New(oSection,"C2_PRODUTO"				,"SC2","Cod.Produto",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"B1_DESC"	 				,"SB1","Descri็ใo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C2_QUANT"				,"SC2","Qtd.Aberta","@E 9,999,999,999.99",20) 
	TRCell():New(oSection,"C2_EMISSAO"				,"SC2","Emissใo",,) 
	TRCell():New(oSection,"QUANT"					,"SC2","Qtd.Entregue",/*Mascara*/,)
	TRCell():New(oSection,"C2_DATA"					,"SC2","Data de Entrega",/*Mascara*/,) 
	TRCell():New(oSection,"JUSTIFICATIVA"			,"SC2","Justificativa",/*Mascara*/,50) 


	//Totalizador
	/*                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)



	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   



		SELECT C2_PRODUTO,B1_DESC,
		SUM(C2_QUANT-C2_QUJE) C2_QUANT,C2_EMISSAO,'_______' QUANT,'____/____/________' C2_DATA,  '____________________________________________________________________________' JUSTIFICATIVA 
		FROM %Table:SC2% SC2 (NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON B1_COD = C2_PRODUTO AND SB1.D_E_L_E_T_ = '' 
		WHERE 
		C2_DATRF = ''
		AND C2_LOCAL = '20'
		AND SC2.D_E_L_E_T_ =''
		AND C2_CC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY C2_PRODUTO,B1_DESC,C2_EMISSAO
		ORDER BY C2_PRODUTO,C2_EMISSAO





	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Centro de Custo De?     ",20)+"?","","","mv_ch1","C",14,0,0,"G","","CTT","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Centro de Custo Ate?    ",20)+"?","","","mv_ch2","C",14,0,0,"G","","CTT","","","mv_par02") 



Return