#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR02    บAutor  ณStan Lee Lopes     				บ Data ณ  04/12/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Notas Emitidas X Entrega      								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR02()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR02"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE NOTAS EMITIDAS X ENTREGA ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Nota",{"SD2"},aOrdem) 

	TRCell():New(oSection,"D2_FILIAL"	,"SD2","Filial",/*Mascara*/)
	TRCell():New(oSection,"D2_PEDIDO"	,"SD2","Pedido",/*Mascara*/,) 
	TRCell():New(oSection,"D2_DOC"   	,"SD2","Nota Fiscal",/*Mascara*/,)
	TRCell():New(oSection,"D2_SERIE"   	,"SD2","S้rie",/*Mascara*/,)
	TRCell():New(oSection,"D2_EMISSAO"	,"SD2","Dt.Faturamento",/*Mascara*/,) 
	TRCell():New(oSection,"C6_ENTREG"	,"SC6","Dt.Entrega",/*Mascara*/,)
	TRCell():New(oSection,"SAIDA"	    ,"SD2","Dt.Saํda",/*Mascara*/,20)
	TRCell():New(oSection,"D2_CLIENTE"	,"SD2","Cod.Cliente",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"A1_NOME"    	,"SA1","Cliente",/*Mascara*/,)


	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)


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

		SELECT D2_FILIAL,D2_PEDIDO,D2_DOC,D2_SERIE,D2_EMISSAO,C6_ENTREG,CONVERT(VARCHAR,SE.data_embarque,103)SAIDA,D2_CLIENTE,A1_NOME
		FROM %Table:SD2% SD2 (NOLOCK)
		INNER JOIN %Table:SC6% SC6 (NOLOCK) ON SD2.D2_FILIAL = SC6.C6_FILIAL AND  SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_COD = SC6.C6_PRODUTO AND SC6.D_E_L_E_T_ = ''
		INNER JOIN dbPelmex.dbo.set_embarque SE (NOLOCK) ON SD2.D2_CLIENTE = SE.cod_cliente COLLATE Latin1_General_BIN AND SD2.D2_DOC = SE.nota_fiscal COLLATE Latin1_General_BIN AND SD2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SC6.C6_CLI = SA1.A1_COD AND SC6.C6_LOJA = SA1.A1_LOJA
		WHERE D2_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND D2_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
		GROUP BY D2_FILIAL,D2_PEDIDO,D2_DOC,D2_SERIE,D2_EMISSAO,C6_ENTREG,SE.data_embarque,D2_CLIENTE,A1_NOME
		ORDER BY 5,9 

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Filial De    ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Filial At้   ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02") 
	PutSX1(cPerg,"03",PADR("Dt.Faturamento De    ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	PutSX1(cPerg,"04",PADR("Dt.Faturamento At้   ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04") 

Return
