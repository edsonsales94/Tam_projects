#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR08    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de etiquetas antigas						        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMASSR04()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMASSR04"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return                                        

Static Function ReportDef(cAlias,cPerg)
	Local oReport := Nil
	Local oSection:= Nil
	Local oBreak
	Local aOrdem      := {"FILIAL"}



	oReport := TReport():New(cPerg,"Rank de Produtos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()    
	oReport:SetEnvironment(2)      


	//Primeira se็ใo


	oSection:= TRSection():New(oReport, "Rank de Produtos", {"SAI"},aOrdem)   


	//A segunda se็ใo, serแ apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado tamb้m a tabela de NCM, com isso, voc๊ poderia incluir os campos da tabela
	//SYD.Semelhante a se็ใo 1, defino o titulo e tamanho das colunas


	TRCell():New(oSection,"COD"	    				,"cAlias","Codigo",,)
	TRCell():New(oSection,"DESCRI"		    		,"cAlias","Descri็ใo do produto",,50)
	TRCell():New(oSection,"GRUPO"					,"cAlias","Grupo",/*Mascara*/,)    
	TRCell():New(oSection,"QUANT"				    ,"cAlias","Quantidade","@E 9,999,999,999",20)
	TRCell():New(oSection,"VALOR"		   			,"cAlias","Valor","@E 9,999,999,999.99",20)        

	TRFunction():New(oSection:Cell("COD"),"Total de Produtos:","COUNT",,,"@E 999,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("QUANT"),"Total de produtos vendidos:","SUM",,,"@E 999,999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALOR"),"Valor de venda:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

	//Quebra por Se็ใo                         N4


	//	TRFunction():New(oSection2:Cell("TOTALVEND"),"Total:   ","SUM",oBreak,,,,.F.,.F.)
	//	TRFunction():New(oSection2:Cell("D2_TOTAL"),"Total : ","SUM",oBreak,,,,.F.,.F.)  


	//Fim Quebra por Se็ใo

	//Totalizador final





	//Totalizador                                                                                                          MIC

	/* 

	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/
	//quebra  por se็ใo (.T.) uma se็ใo por pagina		
Return(oReport)



/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%    



		SELECT SB1.B1_COD COD,SB1.B1_DESC DESCRI,SB1.B1_GRUPO GRUPO,SUM(SD2.D2_QUANT) QUANT,SUM(SD2.D2_TOTAL+SD2.D2_VALIPI) VALOR 

		FROM %Table:SD2% SD2 
		INNER JOIN %Table:SF4% SF4 ON F4_CODIGO = D2_TES 
		INNER JOIN %Table:SB1% SB1 ON B1_COD = D2_COD AND B1_TIPO = 'PA'
		WHERE SD2.D2_FILIAL = '01'
		AND SD2.D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND SD2.D2_COD BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SB1.B1_GRUPO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SF4.F4_DUPLIC  =  'S' 
		AND SD2.D_E_L_E_T_ = '' 
		AND SF4.D_E_L_E_T_ = '' 
		AND SB1.D_E_L_E_T_ = '' 
		AND SD2.D2_COD = SB1.B1_COD 
		GROUP BY SD2.D2_COD, SB1.B1_COD,SB1.B1_DESC,SB1.B1_GRUPO 
		ORDER BY VALOR DESC
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo de?     ",20)+"","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo ate?    ",20)+"","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Codigo de?    	",20)+"","","","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Codigo At้?   	",20)+"","","","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Grupo de?		",20)+"","","","mv_ch5","C",4,2,0,"G","","SBM","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Grupo Ate?   	",20)+"","","","mv_ch6","C",4,2,0,"G","","SBM","","","mv_par06")

Return
