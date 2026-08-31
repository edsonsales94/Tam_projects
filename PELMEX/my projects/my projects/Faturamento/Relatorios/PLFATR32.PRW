#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR19    บAutor  ณStan Lee Lopes     				บ Data ณ  02/04/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Comiss๕es Representantes simplificado      				 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR32()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR32"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE PEDIDOS",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"RELATำRIO DE PEDIDOS",{"SA1"},aOrdem) 

	TRCell():New(oSection,"C6_PRODUTO"    		,"SC6","Produto",/*Mascara*/,)
	TRCell():New(oSection,"B1_DESC"    			,"SA1","Descri็ใo",/*Mascara*/,)
	TRCell():New(oSection,"QTDVENDIDA"        	,"SC5","Qtd.Vendida",/*Mascara*/,/*Tamanho*/14) 
	TRCell():New(oSection,"QTDFATURADA"		    ,"SA3","Qtd.Faturada",/*Mascara*/,/*Tamanho*/14)
	TRCell():New(oSection,"VALORTOTAL"        	,"SC5","Vlr Total",/*Mascara*/,/*Tamanho*/14) 

	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("QTDVENDIDA"),"Qtd.Vendida","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("QTDFATURADA"),"Qtd.Faturada","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALORTOTAL"),"Vlr Total","SUM",,,"@E 999,999,999.99",,.F.,.T.)

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


		SELECT C6_PRODUTO,B1_DESC,SUM(C6_QTDVEN) QTDVENDIDA,SUM(C6_QTDENT) QTDFATURADA,SUM(C6_VALOR) VALORTOTAL 
		FROM  %Table:SC6% SC6
		INNER JOIN  %Table:SB1% SB1 ON B1_COD = C6_PRODUTO
		WHERE SC6.D_E_L_E_T_ = ''
		AND C6_ENTREG BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C6_TES NOT IN('705','723','702')
		AND C6_FILIAL = '01'
		GROUP BY C6_PRODUTO,B1_DESC
		ORDER BY 3 DESC




	EndSQL 
	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Entrega De     ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Entrega At้    ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 


Return
