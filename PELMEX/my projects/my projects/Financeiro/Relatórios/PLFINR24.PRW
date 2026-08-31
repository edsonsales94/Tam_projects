#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR21    ºAutor  ³Stan Lee Lopes     				º Data ³ 06/04/2021º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de Fluxo de caixa	           								 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR24()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR24"

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

	oReport := TReport():New(cPerg,"Fluxo de caixa",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Fluxo de caixa",{"SE1"},aOrdem)
	
	TRCell():New(oSection,"E1_VENCREA"		,"SE1","Vencimento",/*Mascara*/,20) 
	TRCell():New(oSection,"VAL_RECEBER"		,"SE1","Vlr.Recebido","@E 9,999,999,999.99",20)
	TRCell():New(oSection,"VAL_PAGAR"     	,"SE1","Vlr.Pago","@E 9,999,999,999.99",20)
	TRCell():New(oSection,"DIFERENCA"     	,"SE1","Diferenca","@E 9,999,999,999.99",20)            

	//Segunda seção
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  

	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("VAL_RECEBER"),"TOTAL Recebido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//oReport:SetTotalInLine(.F.)

	//Quebra por Seção
	//oSection1:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

		
		
		SELECT E1_VENCREA,
		       SUM(VAL_RECEBER)VAL_RECEBER,SUM(VAL_PAGAR)VAL_PAGAR,SUM(VAL_RECEBER)-SUM(VAL_PAGAR) DIFERENCA
		FROM(
		SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_NOMCLI,
		       CONVERT(DATETIME,E1_VENCREA,121) E1_VENCREA,SUM(E1_VALOR)VAL_RECEBER,0 VAL_PAGAR,E1_SALDO
		FROM %Table:SE1% SE1
		WHERE SE1.D_E_L_E_T_ = ''
		//AND E1_TIPO IN ('CC','CD','DH','TB','BO','BOL')
		AND E1_TIPO NOT IN ('NCC')
		AND E1_SITUACA IN ('0','1')
		AND E1_SALDO > 0
		AND E1_VENCREA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_NOMCLI,E1_SALDO,
		         E1_VENCREA
		
		UNION 
		
		SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_NOMCLI,
		       CONVERT(DATETIME,E1_DATABOR,121) E1_VENCREA,
			   SUM(E1_VALOR)VAL_RECEBER,0 VAL_PAGAR,E1_SALDO
		FROM %Table:SE1% SE1
		WHERE SE1.D_E_L_E_T_ = ''
		AND E1_TIPO IN ('NF')
		AND E1_SALDO > 0
		AND E1_SITUACA IN ('2')
		AND E1_DATABOR BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		GROUP BY E1_NUM,E1_PREFIXO,E1_PARCELA,E1_TIPO,E1_NOMCLI,E1_SALDO,
		         E1_DATABOR
				 
		UNION 
		
		SELECT E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_NOMFOR,
		       E2_VENCREA,0 VAL_RECEBER,SUM(E2_VALOR)VAL_PAGAR,E2_SALDO
		FROM %Table:SE2% SE2
		WHERE SE2.D_E_L_E_T_ = ''
		AND E2_VENCREA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND E2_SALDO > 0
		GROUP BY E2_NUM,E2_PREFIXO,E2_PARCELA,E2_TIPO,E2_NOMFOR,E2_SALDO,
		         E2_VENCREA
		
		)TB 
		GROUP BY TB.E1_VENCREA
		ORDER BY TB.E1_VENCREA
			
				

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("Vencimento De    ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Vencimento Até   ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")   
	
Return
