#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR18    บAutor  ณWilson Junior     				บ Data ณ  03/05/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATำRIO status do pedido de compra 									 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLCOMR07()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLCOMR07"

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

	oReport := TReport():New(cPerg,"Status Pedido de Compras",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira se็ใo
	oSection := TRSection():New(oReport,"Status Pedido de Compras",{"SC7"},aOrdem) 

	TRCell():New(oSection,"C7_NUM"	        			,"SC7","Numero",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"C7_FORNECE"	        		,"SC7","Cod.Fornece",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"A2_NOME"	        			,"SA2","Nome.Fornece ",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"D1_DOC"	       				,"SD1","Documento de entrada",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"D1_SERIE"	       			,"SD1","Serie",/*Mascara*/,/*Tamanho*/)	
	TRCell():New(oSection,"C7_PRODUTO"	        		,"SC7","Produto",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"B1_DESC"	        			,"SB1","Descri็ใo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C7_QUANT"	        		,"SC7","Qtd.Solicitada",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C7_QUJEFAT"		        	,"SC7","Qtd.Faturada",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"D1_QUANT"		       		,"SD1","Qtd.Entregue",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C7_EMISSAO"	        		,"SC7","Emissใo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C7_DATPRF"	        		,"SC7","Dt.Entrega",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C7_DTLANC"	        		,"SC7","Dt.Lan็amento",/*Mascara*/,/*Tamanho*/)

	//TRCell():New(oSection,"RA_DTFIMCT"	        		,"SRA","Fim do Contrato",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_DEFIFIS"	       			,"SRA","Deficiente",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_BRPDH"	        		,"SRA","Reabilitado?",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_TPDEFFI"        			,"SRA","Tipo de Deficiencia",/*Mascara*/,/*Tamanho*/)
	//Totalizador                                                                                  


	/*
	TRFunction():New(oSection:Cell("M"),"Masculino","SUM",,,,,.F.,.T.)  
	TRFunction():New(oSection:Cell("F"),"Feminino","SUM",,,,,.F.,.T.)  
	*/
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENวA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("DA1_TOTAL"),"TOTAL FABRICA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	/*
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                      MIMIM ท
	//endif      
	Local nTotReg :=0

	/*
	local par01 :=0
	local par02 :=0
	if %Exp:MV_PAR05% == 1 
	par01 := "M"
	else
	par01 := "F"
	endif 
	if %Exp:MV_PAR06% == 1 
	par02 := "M"
	else
	par02 := "F"
	endif
	*/

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		SELECT C7_NUM,C7_FORNECE,A2_NOME, ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,C7_PRODUTO,B1_DESC,sum(C7_QUANT) C7_QUANT,C7_QUJEFAT,sum(ISNULL(D1_QUANT,0))D1_QUANT,C7_EMISSAO,C7_DATPRF,C7_DTLANC
		FROM %Table:SC7% SC7
		LEFT JOIN %Table:SD1% SD1 ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND C7_PRODUTO = D1_COD AND C7_ITEM = D1_ITEMPC AND SD1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 ON C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA2% SA2 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
		WHERE C7_FILIAL = '01'
		AND C7_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C7_FORNECE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		GROUP BY C7_NUM,C7_FORNECE,A2_NOME,D1_DOC,D1_SERIE,C7_PRODUTO,B1_DESC,C7_QUJEFAT,C7_EMISSAO,C7_DATPRF,C7_DTLANC
		ORDER BY 1




		/*
		SELECT C7_NUM,C7_FORNECE,A2_NOME, ISNULL(D1_DOC,'')D1_DOC,ISNULL(D1_SERIE,'')D1_SERIE,C7_PRODUTO,B1_DESC,C7_QUANT,C7_QUJEFAT,ISNULL(D1_QUANT,0)D1_QUANT,C7_EMISSAO,C7_DATPRF,C7_DTLANC
		FROM %Table:SC7% SC7
		LEFT JOIN %Table:SD1% SD1 ON C7_FILIAL = D1_FILIAL AND C7_NUM = D1_PEDIDO AND C7_PRODUTO = D1_COD AND SD1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 ON C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA2% SA2 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ''
		WHERE C7_FILIAL = '01'
		AND C7_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C7_FORNECE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		GROUP BY C7_NUM,C7_FORNECE,A2_NOME,D1_DOC,D1_SERIE,C7_PRODUTO,B1_DESC,C7_QUANT,C7_QUJEFAT,D1_QUANT,C7_EMISSAO,C7_DATPRF,C7_DTLANC
		ORDER BY 1
		*/

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            
	u_InPutSX1(cPerg,"01",PADR("DT.Emissao De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("DT.Emissao At้   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Fornecedor De    ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA2","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Fornecedor At้   ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA2","","","mv_par04") 

Return