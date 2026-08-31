#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR28    ºAutor  ³WILSON GUEDES	    				º Data ³  10/02/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Produto X Componente  aprimorado								        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR28()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR28"

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

	oReport := TReport():New(cPerg,"Estrutura x empenho",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira seção
	oSection := TRSection():New(oReport,"Estrutura x empenho",{"SC2"},aOrdem) 



	TRCell():New(oSection,"C2_NUM"	        			,"SC2","Op",/*Mascara*/,6)  
	TRCell():New(oSection,"C2_PRODUTO"	        		,"SC2","Produto",/*Mascara*/,15)  
	TRCell():New(oSection,"B1_DESC"	        			,"SB1","Descrição",/*Mascara*/,60)
	TRCell():New(oSection,"G1_COMP"	       				,"SG1","Componente",/*Mascara*/,/*Tamanho*/)  
	TRCell():New(oSection,"DESCRI"	       				,"SB1","Descrição",/*Mascara*/,60)	
	TRCell():New(oSection,"B1_UM"	        			,"SB1","Und",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"B1_SEGUM"	        		,"SB1","2Und",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"G1_XDIMENS"	        		,"SG1","Dimensão",/*Mascara*/,10)
	TRCell():New(oSection,"G1_TRT"	        			,"SG1","Sequencia",/*Mascara*/,3)
	TRCell():New(oSection,"G1_QUANT"		        	,"SG1","Qtd",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"OPS"		       				,"SC2","Qtd em aberto",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"RESULT"	        			,"SG1","Consumo",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"D4_QTDORI"	        		,"SD4","Empenho",/*Mascara*/,/*Tamanho*/)

	//TRCell():New(oSection,"RA_DTFIMCT"	        		,"SRA","Fim do Contrato",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_DEFIFIS"	       			,"SRA","Deficiente",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_BRPDH"	        		,"SRA","Reabilitado?",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_TPDEFFI"        			,"SRA","Tipo de Deficiencia",/*Mascara*/,/*Tamanho*/)
	//Totalizador                                                                                  


	/*
	TRFunction():New(oSection:Cell("M"),"Masculino","SUM",,,,,.F.,.T.)  
	TRFunction():New(oSection:Cell("F"),"Feminino","SUM",,,,,.F.,.T.)  
	*/
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENÇA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
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
	//	cOrdem := "A1_COD"                      MIMIM ·
	//endif      
	Local nTotReg :=0


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		SELECT C2_NUM,C2_PRODUTO,B1_DESC,G1_COMP,DESCRI,B1_UM,B1_SEGUM,G1_XDIMENS,G1_TRT,G1_QUANT,OPS, CAST(G1_QUANT*OPS AS NUMERIC(15,8))RESULT,CAST(D4_QTDEORI AS NUMERIC(15,8))D4_QTDORI 
		FROM ( 
		SELECT C2_NUM+C2_ITEM+C2_SEQUEN C2_NUM,C2_PRODUTO,SB11.B1_DESC,G1_TRT,G1_COMP,SB12.B1_DESC DESCRI,SB12.B1_UM,SB12.B1_SEGUM,G1_XDIMENS,SUM(G1_QUANT) G1_QUANT,SUM(C2_QUANT) OPS 
		FROM %Table:SC2% SC2 (NOLOCK)  
		INNER JOIN %Table:SG1% SG1 (NOLOCK) ON C2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
		LEFT JOIN %Table:SB1% SB11 (NOLOCK) ON SB11.B1_COD = C2_PRODUTO AND SB11.D_E_L_E_T_  = '' 
		LEFT JOIN %Table:SB1% SB12 (NOLOCK) ON SB12.B1_COD = G1_COMP AND SB12.D_E_L_E_T_ ='' 
		WHERE  
		SC2.D_E_L_E_T_ = '' 
		AND G1_COMP NOT LIKE 'MOD%' 
		AND C2_LOCAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C2_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND C2_EMISSAO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND C2_PRODUTO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		AND G1_COMP BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
		AND C2_CC BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
		AND C2_DATRF = ''
		GROUP BY C2_NUM,C2_ITEM,C2_SEQUEN,C2_PRODUTO,SB11.B1_DESC,G1_TRT,G1_COMP,SB12.B1_DESC,G1_XDIMENS,SB12.B1_UM,SB12.B1_SEGUM 
		)TB 
		INNER JOIN %Table:SD4% SD4 (NOLOCK) ON TB.C2_NUM = D4_OP  AND C2_PRODUTO = D4_PRODUTO AND G1_COMP = D4_COD AND D4_TRT = G1_TRT AND D4_LOCAL = '10' AND  SD4.D_E_L_E_T_ ='' 
		GROUP BY C2_NUM,C2_PRODUTO,B1_DESC,G1_COMP,DESCRI,G1_QUANT,OPS,D4_QTDEORI,G1_XDIMENS,B1_UM,B1_SEGUM, G1_TRT 
		ORDER BY C2_NUM,C2_PRODUTO ,G1_COMP 



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            

	u_InPutSX1(cPerg,"01",PADR("Armazen De ? ",20)+"","","","mv_ch1","C",2,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Armazen Ate? ",30)+"","","","mv_ch2","C",2,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Op de? ",30)+"","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Op ate? ",30)+"","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Emissao De? ",30)+"","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Emissão Ate? ",30)+"","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Produto de? ",30)+"","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Produto Ate? ",20)+"","","","mv_ch8","C",15,0,0,"G","","","","","mv_par08") 
	u_InPutSX1(cPerg,"09",PADR("Componente De? ",20)+"","","","mv_ch9","C",15,0,0,"G","","","","","mv_par09")
	u_InPutSX1(cPerg,"10",PADR("Componente Até ? ",20)+"","","","mv_ch8","C",15,0,0,"G","","","","","mv_par10") 
	u_InPutSX1(cPerg,"11",PADR("Cento de Custo de   ? ",20)+"","","","mv_ch9","C",4,0,0,"G","","","","","mv_par11")
	u_InPutSX1(cPerg,"12",PADR("Centro de Custo ate? ",20)+"","","","mv_cha","C",4,0,0,"G","","","","","mv_par12")

Return
