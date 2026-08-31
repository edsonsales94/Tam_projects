#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR01    ºAutor  ³Stan Lee Lopes     				º Data ³  27/11/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de Conferência PCP	        								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR01()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR01"

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

	oReport := TReport():New(cPerg,"RELATÓRIO DE CONFERÊNCIA PCP",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Conferência",{"SC6"},aOrdem) 

	TRCell():New(oSection,"C6_FILIAL"		,"SC6","Filial",/*Mascara*/,/*Tamanho*/)     
	TRCell():New(oSection,"C5_EMISSAO"      ,"SC5","Dt.Emissão",/*"@E 999,999.99"*/,)  
	TRCell():New(oSection,"C6_ENTREG"       ,"SC6","Dt.Entrega",/*"@E 999,999.99"*/,)  
	TRCell():New(oSection,"A1_MUN"		    ,"SA1","Município",/*Mascara*/,/*Tamanho*/)
	TRCell():New(oSection,"A1_COD"			,"SA1","Cod.Cli",/*"@E 999,999.99"*/,/*Tamanho*/)
	TRCell():New(oSection,"A1_NOME"		    ,"SA1","Cliente",/*"@E 999,999.99"*/,/*Tamanho*/) 
	TRCell():New(oSection,"C6_NUM"          ,"SC6","Pedido",/*"@E 999,999.99"*/,)   
	TRCell():New(oSection,"C6_ITEM"		    ,"SC6","Cod.Prod",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"C6_PRODUTO"      ,"SC6","Cod.Prod",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"C6_DESCRI"       ,"SC6","Produto",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"C6_QTDVEN"       ,"SC6","Qtd.Solicitada","@E 999,999.99",) 
	TRCell():New(oSection,"C6_QTDENT"       ,"SC6","Qtd.Entregue","@E 999,999.99",)              
	TRCell():New(oSection,"QTD_PEND"        ,"SC6","Qtd.Pendente","@E 999,999.99",)
	TRCell():New(oSection,"C6_PRCVEN"       ,"SC6","Valor Unitario","@E 999,999.99",)    
	TRCell():New(oSection,"C6_VALOR"        ,"SC6","Valor Pendente","@E 999,999.99",)            
	TRCell():New(oSection,"B1_DCR"          ,"SB1","DCRE",,)
	TRCell():New(oSection,"CUBAGEM"         ,"SB1","CUBAGEM","@E 999,999.999999",)
	//TRCell():New(oSection,"C5_MENNOTA"      ,"SC5","Mensagem NF",/*"@E 999,999.99"*/,) 
	TRCell():New(oSection,"OBS"        		,"SC5","OBS",/*"@E 999,999.99"*/,) 
	//TRCell():New(oSection,"C5_OBS2"         ,"SC5","OBS2",/*"@E 999,999.99"*/,) 
	//TRCell():New(oSection,"C5_OBS3"         ,"SC5","OBS3",/*"@E 999,999.99"*/,) 


	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("C6_VALOR"),"TOTAL FATURADO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("CUBAGEM"),"TOTAL CUBAGEM","SUM",,,"@E 999,999,999.999999",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)


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
		
			SELECT C6_FILIAL,C5_EMISSAO,C6_ENTREG,A1_MUN,A1_COD,A1_NOME,
			C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_QTDENT,C6_PRCVEN,((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) C6_VALOR,(C6_QTDVEN-C6_QTDENT)QTD_PEND,B1_DCR,((B1_XALTURA*B1_XLARGUR*B1_XCOMPRI)*(C6_QTDVEN-C6_QTDENT))CUBAGEM,C5_MENNOTA+' '+C5_OBS1+' '+C5_OBS2+' '+C5_OBS3 OBS
			FROM %Table:SC6% SC6 (NOLOCK)
			INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = ''
			INNER JOIN %Table:SL1% SL1 (NOLOCK) ON SC5.C5_XFILRES = SL1.L1_FILIAL AND SC5.C5_XORCRES = SL1.L1_NUM 
			INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
			INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
			INNER JOIN %Table:SBM% SBM (NOLOCK) ON SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.D_E_L_E_T_ = ''
			WHERE C5_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
			AND C6_ENTREG BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			AND C6_CLI BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%                          
			AND BM_GRUPO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
			AND C6_LOCAL BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
			AND C6_QTDVEN != C6_QTDENT       
			AND B1_TIPO IN ('PA','PC')    
			AND C6_ENTREG >='20210101'
			
			UNION
	
			SELECT C6_FILIAL,C5_EMISSAO,C6_ENTREG,A1_MUN,A1_COD,A1_NOME,
			C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_QTDENT,C6_PRCVEN,((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) C6_VALOR,(C6_QTDVEN-C6_QTDENT)QTD_PEND,B1_DCR,((B1_XALTURA*B1_XLARGUR*B1_XCOMPRI)*(C6_QTDVEN-C6_QTDENT))CUBAGEM,C5_MENNOTA+' '+C5_OBS1+' '+C5_OBS2+' '+C5_OBS3 OBS
			FROM %Table:SC6% SC6 (NOLOCK)
			INNER JOIN %Table:SC5% SC5 (NOLOCK) ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = ''
			INNER JOIN %Table:SA1% SA1 (NOLOCK) ON SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ''
			INNER JOIN %Table:SB1% SB1 (NOLOCK) ON SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
			INNER JOIN %Table:SBM% SBM (NOLOCK) ON SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.D_E_L_E_T_ = ''
			WHERE C5_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
			AND C6_ENTREG BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			AND C6_CLI BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%                          
			AND BM_GRUPO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
			AND C6_LOCAL BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
			AND C6_QTDVEN != C6_QTDENT     
			AND B1_TIPO IN ('PA','PC')    
			AND SC5.C5_ORCRES = ''
			AND C5_XORCRES = ''            
			AND C6_ENTREG >='20210101'
		)TB
		GROUP BY C6_FILIAL,C5_EMISSAO,C6_ENTREG,A1_MUN,A1_COD,A1_NOME,C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_QTDENT,C6_PRCVEN,C6_VALOR,QTD_PEND,B1_DCR,CUBAGEM,OBS
		
		ORDER BY 7,8



	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Filial De    ",20)+"?","","","mv_ch1","C",2,0,0,"G","","SM0","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Filial Até   ",20)+"?","","","mv_ch2","C",2,0,0,"G","","SM0","","","mv_par02") 
	u_InPutSX1(cPerg,"03",PADR("Entrega De    ",20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Entrega Até   ",20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04") 
	u_InPutSX1(cPerg,"05",PADR("Cliente De    ",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA1","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Cliente Até   ",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA1","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("Grupo De    ",20)+"?","","","mv_ch7","C",6,0,0,"G","","SBM","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Grupo Até   ",20)+"?","","","mv_ch8","C",6,0,0,"G","","SBM","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("Armazém De    ",20)+"?","","","mv_ch9","C",2,0,0,"G","","","","","mv_par09") 
	u_InPutSX1(cPerg,"10",PADR("Armazém Até   ",20)+"?","","","mv_chA","C",2,0,0,"G","","","","","mv_par10")
Return
