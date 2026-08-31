#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFATR37    ºAutor  ³Wilson Guedes     				º Data ³  25/03/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de pedidos em aberto      								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFATR38()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR38"

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

	oReport := TReport():New(cPerg,"Saldo no CD",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	
	

	oSection := TRSection():New(oReport,"Saldo no CD",{"SL1"},aOrdem) 

	
	
	TRCell():New(oSection,"B2_FILIAL"	,"SB2","Filial",/*Mascara*/)
	TRCell():New(oSection,"B2_COD"		,"SB2","Codigo",/*Mascara*/,) 
	TRCell():New(oSection,"B1_DESC"  		,"SB1","Descrição",/*Mascara*/,) 
	TRCell():New(oSection,"B2_LOCAL"    		,"SB2","Local",/*Mascara*/,)
	TRCell():New(oSection,"QTD_MICROSIGA"    		,"SB1","Saldo Atual",/*Mascara*/,)               
	TRCell():New(oSection,"QTD_VEND" 		,"SB2","A faturar","@E 999,999,999.99",/*Tamanho*/) 
	TRCell():New(oSection,"SALDO" 		,"SB2","Saldo Restante","@E 999,999,999.99",/*Tamanho*/) 
	
	//Totalizador                                                                                  


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



SELECT B2_FILIAL,B2_COD,B1_DESC,B2_LOCAL,B2_QATU QTD_MICROSIGA,ISNULL(C6_QUANT,0)QTD_VEND,B2_QATU-ISNULL(C6_QUANT,0)SALDO
FROM %Table:SB2% SB2
INNER JOIN %Table:SB1% SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT C6_FILIAL,C6_PRODUTO,B1_DESC DESCRICAO,SUM(C6_QTDVEN)-SUM(C6_QTDENT)C6_QUANT FROM SC6100 SC6
           INNER JOIN SC5100 SC5 ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = '' 
		   INNER JOIN SB1100 SB1 ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		   INNER JOIN SA1100 SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI
           WHERE C6_FILIAL = '01' 
		   AND  SC6.D_E_L_E_T_ = ''
		   AND C6_QTDVEN > C6_QTDENT
		   AND C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		   AND A1_EST BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		   GROUP BY C6_FILIAL,C6_PRODUTO,B1_DESC)SC61 ON B2_FILIAL = C6_FILIAL AND B2_COD = C6_PRODUTO AND B2_LOCAL = '15'
WHERE SB2.D_E_L_E_T_ = ''
AND B2_FILIAL = '01'
AND B2_LOCAL = '15'
AND B2_QATU > 0

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("Emissao De     ",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Emissao Até    ",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Estado De     ",20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Estado Até    ",20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")  

Return
