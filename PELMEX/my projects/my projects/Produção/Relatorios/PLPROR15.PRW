#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR101   บAutor  ณWylliam Silva     				บ Data ณ  18/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Produ็ใo X Apontamento                       		                     ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR15()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR15"

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

	oReport := TReport():New(cPerg,"Pedidos Lan็ados",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Pedidos Lan็ados",{"SC5"},aOrdem) 


    TRCell():New(oSection,"FILIAL"          ,"SC5","FILIAL","@!",3)
	TRCell():New(oSection,"DT_PEDIDO"		,"SC5","DT_PEDIDO","@!",10)
	TRCell():New(oSection,"DT_ENTREGA"	    ,"SC6","DT_ENTREGA","@!",10)
    TRCell():New(oSection,"PEDIDO"	        ,"SC6","PEDIDO","@!",8)
    TRCell():New(oSection,"ITEM"	        ,"SC6","ITEM","@!",3)
    TRCell():New(oSection,"PRODUTO"	        ,"SC6","PRODUTO","@!",15) 
    TRCell():New(oSection,"DESCRICAO"	    ,"SC6","DESCRICAO","@!",35) 
    TRCell():New(oSection,"QTD_PEDIDO"	    ,"SC6","COD.QTD_PEDIDO","@E 999,999,999.99",)
    TRCell():New(oSection,"C6_PRCVEN"	    ,"SC6","PRECO_VEND","@E 999,999,999.99",)
    TRCell():New(oSection,"TOTAL"	        ,"SC6","TOTAL","@E 999,999,999.99",)
    TRCell():New(oSection,"ITEM_PC"	        ,"SC6","ITEM_PC","@!",3)
    TRCell():New(oSection,"CLIENTE"         ,"SA1","CLIENTE","@!",25)
    TRCell():New(oSection,"CIDADE"          ,"SA1","CIDADE","@!",25)
    
	
	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("TOTAL"),"TOTAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)

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

    SELECT C5_FILIAL FILIAL,CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_PEDIDO,
       CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),103)DT_ENTREGA,
       C6_NUM PEDIDO,C6_ITEM ITEM,C6_PRODUTO PRODUTO,C6_DESCRI DESCRICAO,C6_QTDVEN QTD_PEDIDO,
       C6_PRCVEN,C6_VALOR TOTAL,C6_ITEMPC ITEM_PC,C6_NUMPCOM PEDIDO_COMPRA,A1_NOME CLIENTE,A1_MUN CIDADE
            FROM SC5100 SC5 (NOLOCK)
            INNER JOIN SC6100 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ''
            INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
            WHERE SC5.D_E_L_E_T_ = ''
            AND C5_CLIENTE BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND C5_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
            AND C5_EMISSAO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
            ORDER BY C6_NUM,C6_ITEM
		
    EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Cliente:",20)+"?","","","mv_ch1","C",8,0,0,"G","","SA1","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Cliente:",20)+"?","","","mv_ch2","C",8,0,0,"G","","SA1","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Pedido:" ,20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Emissao:" ,20)+"?","","","mv_ch5","D",10,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate Emissao:",20)+"?","","","mv_ch6","D",10,0,0,"G","","","","","mv_par06")


Return
