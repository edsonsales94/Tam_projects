#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR05    บAutor  ณWilson Guedes     				บ Data ณ  13/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  LISTAGEM PARA PRODUวรO		  						        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR05()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR05"

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

	oReport := TReport():New(cPerg,"LISTAGEM PARA PRODUวรO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"LISTAGEM PARA PRODUวรO",{"SC2"},aOrdem)     


	TRCell():New(oSection,"C2_NUM"		        	,"SC2","N๚mero OP",,)
	TRCell():New(oSection,"C2_PRODUTO"	    		,"SC2","Cod. Produto",,)
	TRCell():New(oSection,"B1_DESC"					,"SB1","Descri็ใo",/*Mascara*/,45) 
	TRCell():New(oSection,"C2_QUANT"	        	,"SC2","Quantidade",'@E 9,999,999.99',)
	TRCell():New(oSection,"C2_DATPRI"      			,"SC2","Dt. Inicio",/*Mascara*/,12)
	TRCell():New(oSection,"C2_OBS"      			,"SC2","Observa็ใo",/*Mascara*/,)
	TRCell():New(oSection,"C2_XNOME"       			,"SC2","Nome Cliente",/*Mascara*/,)


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
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%


		SELECT C2_NUM,C2_PRODUTO,SB1.B1_DESC,C2_QUANT,C2_OBS,C2_DATPRI,C2_XNOME
		FROM %Table:SC2% AS SC2 (NOLOCK)
		INNER JOIN %Table:SB1% AS SB1 (NOLOCK) ON SB1.B1_COD = SC2.C2_PRODUTO AND SB1.D_E_L_E_T_ = '' 
		WHERE SC2.D_E_L_E_T_ = ''
		AND SC2.C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SC2.C2_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SB1.B1_CC BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SC2.C2_QUANT != SC2.C2_QUJE
		AND SC2.C2_DATRF = ''
		ORDER BY C2_NUM,SC2.C2_DATRF,C2_OBS,B1_DESC



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissใo De    			",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissใo At้   			",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Op De   				",20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Op At้   				",20)+"?","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("Centro de Custo De  	",20)+"?","","","mv_ch5","C",4,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Centro de Custo At้   	",20)+"?","","","mv_ch6","C",4,0,0,"G","","","","","mv_par06")  

Return