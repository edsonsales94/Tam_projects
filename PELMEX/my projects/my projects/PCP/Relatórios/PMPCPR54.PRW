#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR55    บAutor  ณWylliam Silva     				บ Data ณ  14/01/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   	Rel. Cliente                                 			  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR54()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR54"

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

	oReport := TReport():New(cPerg,"Rel. Cliente",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Cliente",{"SC6"},aOrdem)  
	

	TRCell():New(oSection,"FILIAL"	        ,"SC6","FILIAL","@!",8)             
	TRCell():New(oSection,"PEDIDO"          ,"SC6","PEDIDO","@!",10)
	TRCell():New(oSection,"DT_EMISSAO"	    ,"SC5","DT EMISSAO","@!",8)
	TRCell():New(oSection,"DT_ENTREGA"	    ,"SC5","DT ENTREGA","@!",8)
	TRCell():New(oSection,"NOTA"	        ,"SC5","NOTA FISCAL","@!",10)
	TRCell():New(oSection,"SERIE"	        ,"SC6","SERIE","@!",4)
	TRCell():New(oSection,"ITEM"	        ,"SC6","ITEM","@!",4)
	TRCell():New(oSection,"PRODUTO"	        ,"SC6","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"	    ,"SC6","DESCRICAO","@!",30)
	TRCell():New(oSection,"QTD_PEDIDO"	    ,"SC6","QUANT PEDIDO","@E 999,999,999,999",5)
	TRCell():New(oSection,"CLIENTE"	        ,"SA1","CLIENTE","@!",20)
	
	
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

SELECT C6_FILIAL FILIAL,C6_NUM PEDIDO,CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_EMISSAO,CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),103)DT_ENTREGA,C6_NOTA NOTA,C6_SERIE SERIE,C6_ITEM ITEM,C6_PRODUTO PRODUTO,C6_DESCRI DESCRICAO,C6_QTDVEN QTD_PEDIDO,A1_NOME CLIENTE
FROM SC6100 SC6
INNER JOIN SC5100 SC5 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
WHERE SC6.D_E_L_E_T_ = ''
AND C6_CLI BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND A1_CGC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%



	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Cod. Cliente:",20)+"?","","","mv_ch1","C",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Cod. Cliente:",20)+"?","","","mv_ch2","C",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De CGC:",20)+"?","","","mv_ch3","C",30,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate CGC:",20)+"?","","","mv_ch4","C",30,0,0,"G","","","","","mv_par04")
	

Return