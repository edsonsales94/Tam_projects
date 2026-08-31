#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLOJR06    บAutor  ณStan Lee Lopes     				บ Data ณ  04/03/19 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de Comiss๕es Feirใo Matriz       								 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMLOJR06()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMLOJR06"

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

	oReport := TReport():New(cPerg,"RELATำRIO DE COMISSีES FEIRรO MATRIZ",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Comissใo Feirใo Matriz",{"SL1"},aOrdem) 

	TRCell():New(oSection,"L1_FILIAL"		,"SL1","Filial",/*Mascara*/)
	TRCell():New(oSection,"L1_EMISNF"		,"SL1","Dt.Emissใo",/*Mascara*/,) 
	TRCell():New(oSection,"L1_NUM"   		,"SL1","Orc/Pedido",/*Mascara*/,) 
	TRCell():New(oSection,"L1_DOC"		    ,"SL1","NFe/NFCe/Pedido",/*Mascara*/,13)
	TRCell():New(oSection,"L1_SERIE"		,"SL1","S้rie"		  ,/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"D2_DOC"		    ,"SD2","Nota Fiscal",/*Mascara*/,13)
	TRCell():New(oSection,"D2_SERIE"		,"SD2","S้rie"		  ,/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"D1_EMISSAO"		,"SD1","Dt.Devolu็ใo",/*Mascara*/,) 
	TRCell():New(oSection,"A1_COD"    		,"SA1","Cliente",/*Mascara*/,)
	TRCell():New(oSection,"A1_NOME"    		,"SA1","Cliente",/*Mascara*/,)
	TRCell():New(oSection,"L2_PRODUTO"		,"SL2","C๓digo",/*Mascara*/,25)  
	TRCell():New(oSection,"B1_DESC"		    ,"SL2","Descri็ใo",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"L2_VLRITEM"		,"SL2","Base Comissใo","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"L1_NSUTEF"	    ,"SL1","NSU TEF",/*Mascara*/,20) 
	TRCell():New(oSection,"B1_COMIS"		,"SB1","%Comissใo","@E 999,999.99",/*Tamanho*/)
	TRCell():New(oSection,"L1_VLRTOT"	    ,"SL1","Valor Comissใo","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"L2_VEND"		    ,"SL2","Cod.Vendedor",/*Mascara*/,/*Tamanho*/) 
	TRCell():New(oSection,"A3_NOME"		    ,"SA3","Vendedor",/*Mascara*/,/*Tamanho*/)


	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 999,999,999.99",,.F.,.T.)
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

		SELECT *
		FROM(
		SELECT F2_FILIAL L1_FILIAL,F2_EMISSAO L1_EMISNF,D2_PEDIDO L1_NUM,
		F2_DOC L1_DOC,F2_SERIE L1_SERIE, D2_DOC,D2_SERIE,'' D1_EMISSAO,
		A1_COD,A1_NOME,
		D2_COD L2_PRODUTO,B1_DESC,D2_TOTAL L2_VLRITEM,'' L1_NSUTEF,
		CASE WHEN F2_FILIAL IN ('14','15','16','17','18') THEN 5
		ELSE C6_COMIS1 END B1_COMIS,
		CASE WHEN F2_FILIAL IN ('14','15','16','17','18') THEN (((D2_TOTAL)*5)/100)
		ELSE (((D2_TOTAL)*C6_COMIS1)/100) END L1_VLRTOT,
		F2_VEND1 L2_VEND,A3_NOME
		FROM %Table:SF2% SF2 (NOLOCK)          
		INNER JOIN %Table:SD2% SD2 (NOLOCK) ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND SF2.D_E_L_E_T_ = '' AND SD2.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 (NOLOCK) ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA3% SA3 (NOLOCK) ON F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''     
		INNER JOIN %Table:SC6% SC6 (NOLOCK) ON SD2.D2_FILIAL = SC6.C6_FILIAL AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_COD = SC6.C6_PRODUTO AND SC6.D_E_L_E_T_ = ''
		INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC5.D_E_L_E_T_ = ''
		WHERE F2_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND F2_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND F2_VEND1 BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SF2.D_E_L_E_T_ = ''
		AND C5_XORCRES = ''
		AND F2_DUPL != ''
		AND A3_TIPO != 'E'
		)SD2
		GROUP BY L1_FILIAL,L1_EMISNF, L1_NUM,
		L1_DOC,L1_SERIE, D2_DOC,D2_SERIE,D1_EMISSAO,
		A1_COD,A1_NOME,
		L2_PRODUTO,B1_DESC,L2_VLRITEM,L1_NSUTEF,
		B1_COMIS,
		L1_VLRTOT,
		L2_VEND,A3_NOME
		ORDER BY L1_FILIAL,L1_NUM,L1_DOC,L1_SERIE

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	PutSX1(cPerg,"01",PADR("Filial De    ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	PutSX1(cPerg,"02",PADR("Filial At้   ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02") 
	PutSX1(cPerg,"03",PADR("Emissao De    ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	PutSX1(cPerg,"04",PADR("Emissao At้   ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04") 
	PutSX1(cPerg,"05",PADR("Vendedor De    ",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA3","","","mv_par05") 
	PutSX1(cPerg,"06",PADR("Vendedor At้   ",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA3","","","mv_par06")

Return
