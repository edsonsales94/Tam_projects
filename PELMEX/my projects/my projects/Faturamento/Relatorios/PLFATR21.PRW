#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR05    ºAutor  ³Wilson Guedes     				º Data ³  13/03/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  PEDIDOS COM RESEVA 			  						        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFATR21()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR21"

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

	oReport := TReport():New(cPerg,"PEDIDOS COM RESERVA",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"PEDIDOS COM RESERVA",{"SC2"},aOrdem)     


	TRCell():New(oSection,"C5_FILIAL"		        ,"SC5","Filial",,)
	TRCell():New(oSection,"C5_NUM"	    			,"SC5","Numero",,)
	TRCell():New(oSection,"B2_COD"      			,"SB2","Codigo Prod.",/*Mascara*/,20)
	TRCell():New(oSection,"B1_DESC"      			,"SB1","Descrição",/*Mascara*/,)
	TRCell():New(oSection,"L1_ORCRES"				,"SL1","Orçamento",/*Mascara*/,8) 
	TRCell():New(oSection,"L1_FILRES"	        	,"SL1","Filial Origem",,)
	TRCell():New(oSection,"B2_RESERVA"       		,"SB2","QTD. Reserva","@E 99999999",)
	TRCell():New(oSection,"B2_QATU"	       			,"SB2","QTD. Estoque","@E 99999999",)
	TRCell():New(oSection,"C6_LOCAL "	       		,"SC6","Armazém",,)
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
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%



		SELECT * FROM (
		SELECT SC5.C5_FILIAL,SC5.C5_NUM,SL1.L1_ORCRES,SL1.L1_FILRES, SB2.B2_COD,SB1.B1_DESC, SB2.B2_RESERVA, SB2.B2_QATU,SC6.C6_LOCAL 
		FROM %Table:SC6% SC6  (NOLOCK)
		INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SC6.C6_NUM=SC5.C5_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB2% SB2 (NOLOCK) ON SB2.B2_FILIAL= SC6.C6_FILIAL AND SC6.C6_PRODUTO=SB2.B2_COD AND SB2.D_E_L_E_T_ = '' AND SB2.B2_LOCAL = SC6.C6_LOCAL
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD=SB2.B2_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SL1% SL1 (NOLOCK) ON SL1.L1_NUM=SC5.C5_ORCRES AND SC5.C5_FILIAL = SL1.L1_FILIAL AND SL1.D_E_L_E_T_ =''
		INNER JOIN %Table:SA1% SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI	
		WHERE 
		SC5.C5_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SC5.C5_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SB2.B2_COD BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SC6.C6_LOCAL = %Exp:MV_PAR07%
		AND SC6.C6_QTDVEN > SC6.C6_QTDENT
		
		AND SC5.D_E_L_E_T_ = ''
		AND A1_EST BETWEEN %Exp:MV_PAR08% AND %Exp:MV_PAR09%
		AND A1_MUN BETWEEN %Exp:MV_PAR10% AND %Exp:MV_PAR11%
		UNION 

		SELECT SC5.C5_FILIAL,SC5.C5_NUM,'' L1_ORCRES,'' L1_FILRES, SB2.B2_COD,SB1.B1_DESC, SB2.B2_RESERVA, SB2.B2_QATU,SC6.C6_LOCAL 
		FROM %Table:SC6% SC6  (NOLOCK)
		INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SC6.C6_NUM=SC5.C5_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.D_E_L_E_T_ = ''
		INNER JOIN %Table:SB2% SB2 (NOLOCK) ON SB2.B2_FILIAL= SC6.C6_FILIAL AND SC6.C6_PRODUTO=SB2.B2_COD AND SB2.D_E_L_E_T_ = '' AND SB2.B2_LOCAL = SC6.C6_LOCAL
		INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD=SB2.B2_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN %Table:SA1% SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI

		WHERE 
		SC5.C5_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND SC5.C5_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND SB2.B2_COD BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND SB2.B2_LOCAL = %Exp:MV_PAR07%
		AND SC6.C6_LOCAL = %Exp:MV_PAR07%
		AND SC6.C6_QTDVEN > SC6.C6_QTDENT
		AND A1_EST BETWEEN %Exp:MV_PAR08% AND %Exp:MV_PAR09%
		AND SC5.D_E_L_E_T_ = ''
		AND A1_MUN BETWEEN %Exp:MV_PAR10% AND %Exp:MV_PAR11%
		)TB

		WHERE C6_LOCAL = %Exp:MV_PAR07%



		ORDER BY C5_FILIAL,C5_NUM,L1_ORCRES,L1_FILRES,B2_COD


	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Filial De?   	",20)+"","","","mv_ch1","C",2,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Filial Até?		",20)+"","","","mv_ch2","C",2,0,0,"G","","","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Emissão De?		",20)+"","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Emissão Até?   	",20)+"","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("Produto De?		",20)+"","","","mv_ch5","C",16,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Produto Até?  	",20)+"","","","mv_ch6","C",16,0,0,"G","","","","","mv_par06") 
	u_InPutSX1(cPerg,"07",PADR("Armazém ?  		",20)+"","","","mv_ch7","C",2,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Estado De?		",20)+"","","","mv_ch8","C",2,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("Estado Até?  	",20)+"","","","mv_ch9","C",2,0,0,"G","","","","","mv_par09")
	u_InPutSX1(cPerg,"10",PADR("Municipio De?		",20)+"","","","mv_cha","C",20,0,0,"G","","","","","mv_par10")
	u_InPutSX1(cPerg,"11",PADR("Municipio Até?  	",20)+"","","","mv_chb","C",20,0,0,"G","","","","","mv_par11")  

Return