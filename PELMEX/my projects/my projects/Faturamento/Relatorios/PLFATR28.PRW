#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATR28    ºAutor  ³Stan Lee Lopes     				º Data ³  17/03/20 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ops a Faturar						      								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFATR28()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR28"

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

	oReport := TReport():New(cPerg,"Produto X Pedido",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Ops a Faturar",{"SC2"},aOrdem)  


	TRCell():New(oSection,"C2_EMISSAO"  	,"SC2","Emissão",/*Mascara*/,15) 
	TRCell():New(oSection,"C2_NUM"		    ,"SC2","OP",/*Mascara*/,/*Tamanho*/)             
	TRCell():New(oSection,"C2_PRODUTO" 		,"SC2","Produto",,/*Tamanho*/) 
	TRCell():New(oSection,"B1_DESC"    		,"SB1","B1_DESC",/*Mascara*/,)
	TRCell():New(oSection,"C2_QUANT"    	,"SC2","Quantidade OP","@E 999,999,999",)
	TRCell():New(oSection,"APONTADA"    	,"SC2","Apontamento de OP","@E 999,999,999",)
	TRCell():New(oSection,"ENTRADA"    		,"SC2","No Estoque","@E 999,999,999",)
	TRCell():New(oSection,"SALDO"    		,"SC2","Saldo Sistema","@E 999,999,999",)


	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("APONTADA"),"Apontamento Total","SUM",,,"@E 999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("ENTRADA"),"Entrada Total","SUM",,,"@E 999,999,999",,.F.,.T.)
	TRFunction():New(oSection:Cell("SALDO"),"Salto Total","SUM",,,"@E 999,999,999",,.F.,.T.)
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


		SELECT TB.C2_EMISSAO,TB.C2_NUM,TB.C2_PRODUTO,TB.B1_DESC,TB.C2_QUANT,TB.APONTADA,COUNT(Z1_OP) ENTRADA,B2_QATU SALDO
		FROM(

		SELECT C2_FILIAL,C2_NUM,C2_PRODUTO,B1_DESC,C2_LOCAL,C2_QUANT,SUM(D3_QUANT) APONTADA,C2_EMISSAO
		FROM %Table:SC2% SC2 (NOLOCK)
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC2.C2_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SD3% SD3 (NOLOCK) ON SC2.C2_FILIAL = SD3.D3_FILIAL AND SC2.C2_PRODUTO = SD3.D3_COD AND SC2.C2_LOCAL = SD3.D3_LOCAL AND SC2.C2_NUM = SUBSTRING(SD3.D3_OP,1,6) AND SD3.D_E_L_E_T_ = ''
		//LEFT JOIN %Table:SC6% SC6 (NOLOCK ) ON C6_PRODUTO = C2_PRODUTO AND C6_FILIAL= C2_FILIAL
		WHERE SC2.D_E_L_E_T_ = '' 
		AND C2_NUM >= '820000'
		AND D3_LOCAL = '20'
		AND C2_XNOME BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND C2_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND C2_PRODUTO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		//AND C6_NUM BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		GROUP BY C2_FILIAL,C2_NUM,C2_PRODUTO,B1_DESC,C2_LOCAL,C2_QUANT,C2_EMISSAO

		)TB
		INNER JOIN %Table:SZ1% SZ1 (NOLOCK) ON SUBSTRING(Z1_OP,1,6) = TB.C2_NUM
		LEFT JOIN SAI (NOLOCK) ON Z1_OP+Z1_CHASSIS = SAI_CPRODUC AND SZ1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB2% SB2 (NOLOCK) ON TB.C2_FILIAL = SB2.B2_FILIAL AND TB.C2_PRODUTO = SB2.B2_COD AND TB.C2_LOCAL = SB2.B2_LOCAL AND SB2.D_E_L_E_T_ = ''
		WHERE SAI_CPRODUC IS NULL
		AND Z1_DTAPONT >= C2_EMISSAO   
		GROUP BY C2_EMISSAO,C2_NUM,C2_PRODUTO,B1_DESC,C2_QUANT,APONTADA,B2_QATU
		ORDER BY C2_PRODUTO

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Nome na Etiqueta De     ",20)+"?","","","mv_ch1","c",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Nome na Etiqueta Até    ",20)+"?","","","mv_ch2","c",8,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Ordem De",20)+"?","","","mv_ch3","C",6,0,0,"G","","SC2","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ordem Até",20)+"?","","","mv_ch4","C",6,0,0,"G","","SC2","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Produto De",20)+"?","","","mv_ch5","C",6,0,0,"G","","SB1","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Produto Até",20)+"?","","","mv_ch6","C",6,0,0,"G","","SB1","","","mv_par06")
	//u_InPutSX1(cPerg,"07",PADR("Pedido De",20)+"?","","","mv_ch7","C",6,0,0,"G","","SC5","","","mv_par07") 
	//u_InPutSX1(cPerg,"08",PADR("Pedido Até",20)+"?","","","mv_ch8","C",6,0,0,"G","","SC5","","","mv_par08") 

Return
