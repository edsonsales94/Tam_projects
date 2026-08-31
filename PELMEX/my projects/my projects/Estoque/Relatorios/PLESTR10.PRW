#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR10    บAutor  ณWILSON GUEDES	    				บ Data ณ  02/07/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de OPS EM ABERTO 							        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR10()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLESTR10"

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


	oReport := TReport():New(cPerg,"ORDENS DE PRODUวรO EM ABERTO AGRUPADO ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"ORDENS DE PRODUวรO EM ABERTO AGRUPADO",{"SC2"},aOrdem)
	TRCell():New(oSection,"C2_PRODUTO"		,"SC2","PRODUTO",/*Mascara*/)
	TRCell():New(oSection,"B1_DESC"		,"SC2","DESCRIวรO",/*Mascara*/)
	TRCell():New(oSection,"C2_QUANT"		,"SC2","QTD","@E 999,999,999.99",)  
	TRCell():New(oSection,"C2_OBS"		,"SC2","OBSERVAวรO",/*Mascara*/,) 



	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("C2_QUANT"),"TOTAL ","SUM",,,"@E 999,999,999.99",,.F.,.T.)

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

		SELECT C2_PRODUTO,RTRIM(LTRIM(B1_DESC))B1_DESC,SUM(SC2.C2_QUANT) C2_QUANT,C2_OBS
		FROM %Table:SC2% SC2
		INNER JOIN %Table:SB1% SB1 ON C2_PRODUTO = B1_COD  
		WHERE 
		SC2.C2_NUM BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%  
		AND  SC2.C2_PRODUTO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SC2.C2_EMISSAO  BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SC2.C2_DATRF = ''
		AND SC2.D_E_L_E_T_ = '' 
		AND SC2.C2_CC BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08% 
		GROUP BY C2_PRODUTO,B1_DESC,C2_OBS
		ORDER BY SB1.B1_DESC,2 DESC

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)


	u_InPutSX1(cPerg,"01",PADR("OP De      ",20)+"?","","","mv_ch1","C",6,0,0,"G","","SM0","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("OP At้     ",20)+"?","","","mv_ch2","C",6,0,0,"G","","SM0","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Emissao De     ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Emissao At้    ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("Produto De    ",20)+"?","","","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Produto At้   ",20)+"?","","","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Centro De    ",9)+"?","","","mv_ch5","C",15,0,0,"G","","CTT","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Centro At้   ",9)+"?","","","mv_ch6","C",15,0,0,"G","","CTT","","","mv_par08")


Return