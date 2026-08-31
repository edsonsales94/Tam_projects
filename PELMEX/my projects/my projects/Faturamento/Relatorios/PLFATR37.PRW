#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR37    บAutor  ณWilson Guedes     				บ Data ณ  25/03/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de pedidos em aberto      								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR37()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR37"

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

	oReport := TReport():New(cPerg,"Pedidos de Representantes",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Pedidos de Representantes",{"SL1"},aOrdem) 

	
	
	TRCell():New(oSection,"C5_FILIAL"		,"SD2","Filial",/*Mascara*/)
	TRCell():New(oSection,"C5_EMISSAO"		,"SD2","Dt.Emissใo",/*Mascara*/,) 
	TRCell():New(oSection,"C5_NUM"  		,"SD2","Orc/Pedido",/*Mascara*/,) 
	TRCell():New(oSection,"A1_COD"    		,"SA1","Cod.Cliente",/*Mascara*/,)
	TRCell():New(oSection,"A1_NOME"    		,"SA1","Cliente",/*Mascara*/,)  
	TRCell():New(oSection,"B1_DESC"		    ,"SB1","Descri็ใo",/*Mascara*/,/*Tamanho*/)             
	TRCell():New(oSection,"C6_QTDVEN" 		,"SD2","Quantidade","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"C6_PRCVEN" 		,"SD2","Preco de venda","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"C6_VALOR"        ,"SC5","Total","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"L1_VLRTOT"   	,"SC5","%Comissใo","@E 999,999,999.99",/*Tamanho*/)
	TRCell():New(oSection,"C5_VEND1"        ,"SC5","Cod.Vendedor1",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"A3_NOME"		    ,"SA3","Vendedor",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"C5_VEND2"        ,"SC5","Cod.Vendedor2",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"VEND2"		    ,"SA3","Vendedor2",/*Mascara*/,/*Tamanho*/)


	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("C6_PRCVEN"),"TOTAL BASE","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)


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




		SELECT SC5.C5_FILIAL,SC5.C5_EMISSAO,SC5.C5_NUM,A1_COD,A1_NOME,
		B1_DESC,C6_QTDVEN,C6_PRCVEN,C6_VALOR,
		C5_VEND1,SA3.A3_NOME,C5_VEND2,SA32.A3_NOME VEND2,
		C6_PRCVEN * CASE WHEN C5_COMIS1 = 0 THEN 0.05 ELSE C5_COMIS1/100 END L1_VLRTOT
		FROM %Table:SC5% SC5 (NOLOCK)
		INNER JOIN %Table:SC6% SC6 (NOLOCK) ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC6.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SC5.C5_CLIENTE = A1_COD AND SC5.C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC6.C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SA3% SA3 (NOLOCK) ON SC5.C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
		LEFT JOIN %Table:SA3% SA32 (NOLOCK) ON SC5.C5_VEND2 = SA32.A3_COD AND SA3.D_E_L_E_T_ = ''
		WHERE 
		C5_FILIAL BETWEEN '' AND 'ZZ' 
		AND SC5.C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C5_VEND1 BETWEEN%Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND C5_VEND2 BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SA3.A3_TIPO = 'E' 
	//	AND C6_QTDENT != C6_QTDVEN
		AND SC5.C5_CLIENTE BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		AND SC5.C5_LOJACLI BETWEEN%Exp:MV_PAR09% AND %Exp:MV_PAR10%
		ORDER BY 1,3,4,5
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissao De     ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissao At้    ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Vendedor De    ",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA3","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Vendedor At้   ",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA3","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Vendedor 2 De    ",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA3","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Vendedor 2 At้   ",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA3","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Cliente De     ",20)+"?","","","mv_ch7","C",6,0,0,"G","","SA1","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Cliente At้    ",20)+"?","","","mv_ch8","C",6,0,0,"G","","SA1","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("Loja De        ",20)+"?","","","mv_ch9","C",6,0,0,"G","","","","","mv_par09") 
	u_InPutSX1(cPerg,"10",PADR("Loja At้       ",20)+"?","","","mv_cha","C",6,0,0,"G","","","","","mv_par10")

Return
