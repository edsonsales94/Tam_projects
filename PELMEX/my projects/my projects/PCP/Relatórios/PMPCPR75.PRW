#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR75    บAutor  ณWylliam Silva     				บ Data ณ  02/05/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Diferen็a entre PlanjxOP  			                 	  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR75()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR75"

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

	oReport := TReport():New(cPerg,"Rel. Diferen็a entre PlanjxOP",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Diferen็a entre PlanjxOP",{"SC2"},aOrdem)  
	
	TRCell():New(oSection,"C2_NUM"	  		,"SC2","ORDEM PROD","@!",10)
	TRCell():New(oSection,"C2_PRODUTO"		,"SC2","PRODUTO","@!",15)   
	TRCell():New(oSection,"B1_DESC"	  		,"SB1","DESCRICAO","@!",30)         
	TRCell():New(oSection,"C2_QUANT"  	    ,"SC2","QTD OP","@E 999,999,999,999",) 
	TRCell():New(oSection,"PED_QUANT"   	,"PED","QTD PED","@E 999,999,999,999",)
	TRCell():New(oSection,"C2_OBS"    		,"SC2","CLIENTE","@!",10)
	TRCell():New(oSection,"B1_XJUNCAO"   	,"SB1","JUNวรO","@!",5)
		
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

		
		SELECT C2_NUM,C2_PRODUTO,B1_DESC,C2_QUANT,PED_QUANT,C2_OBS,B1_XJUNCAO
		FROM SC2100 SC2
		INNER JOIN SB1100 SB1 ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		LEFT JOIN (SELECT PED_NUM,PED_OP,PED_PRODUTO,PED_QUANT,PED_DTPROPEL,PED_LOCAL
		           FROM PED
		       WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) = %Exp:MV_PAR01% )PED ON C2_NUM = PED_OP AND C2_PRODUTO = PED_PRODUTO AND PED_LOCAL = C2_LOCAL
		WHERE SC2.D_E_L_E_T_ = ''
		AND C2_EMISSAO = %Exp:MV_PAR01% 
		AND C2_LOCAL != '10'
		AND PED_QUANT IS NULL
		ORDER BY C2_OBS,C2_PRODUTO

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Emissao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	//u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissใo:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return