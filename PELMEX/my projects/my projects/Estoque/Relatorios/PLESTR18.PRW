#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLESTR18    ºAutor  ³Stan Lee Lopes     				º Data ³  07/12/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Verifica Saldos nos Armazens 						  					 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLESTR18()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR18"

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

	oReport := TReport():New(cPerg,"Verifica Saldo nos Armazens",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Verifica Saldo nos Armazens",{"SB2"},aOrdem)  


	TRCell():New(oSection,"FILIAL"		,"SB2","Filial",,10)             
	TRCell():New(oSection,"PRODUTO" 	,"SB2","Produto",,25) 
	TRCell():New(oSection,"DESCRICAO"   ,"SB2","Descrição",,150)
	TRCell():New(oSection,"UM"    	    ,"SB2","UM",,10)
	//TRCell():New(oSection,"QTD_01"    	,"SB2","QTD_01","@E 999,999,999,999",)
	//TRCell():New(oSection,"QTD_10"    	,"SB2","QTD_10","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_20"    	,"SB2","QTD_20","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_30"    	,"SB2","QTD_30","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_50"    	,"SB2","QTD_50","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_60"    	,"SB2","QTD_60","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_80"    	,"SB2","QTD_80","@E 999,999,999,999",)
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

SELECT SB2.B2_FILIAL FILIAL,SB2.B2_COD PRODUTO,B1_DESC DESCRICAO,B1_UM UM,ISNULL(QTD_01,0)QTD_01,B2_QATU QTD_10,ISNULL(QTD_20,0)QTD_20,
       ISNULL(QTD_30,0)QTD_30,ISNULL(QTD_50,0)QTD_50,ISNULL(QTD_60,0)QTD_60,ISNULL(QTD_80,0)QTD_80
FROM SB2100 SB2
INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_01
            FROM SB2100 SB2
			INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
			WHERE SB2.D_E_L_E_T_ = ''
			AND B2_FILIAL = '01'
			AND B2_LOCAL = '01'
			AND B2_QATU > 0)SB210 ON SB2.B2_COD = SB210.B2_COD
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_20
            FROM SB2100 SB2
			INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
			WHERE SB2.D_E_L_E_T_ = ''
			AND B2_FILIAL = '01'
			AND B2_LOCAL = '20'
			AND B2_QATU > 0)SB220 ON SB2.B2_COD = SB220.B2_COD
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_30
            FROM SB2100 SB2
			INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
			WHERE SB2.D_E_L_E_T_ = ''
			AND B2_FILIAL = '01'
			AND B2_LOCAL = '30'
			AND B2_QATU > 0)SB230 ON SB2.B2_COD = SB230.B2_COD
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_60
            FROM SB2100 SB2
			INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
			WHERE SB2.D_E_L_E_T_ = ''
			AND B2_FILIAL = '01'
			AND B2_LOCAL = '60'
			AND B2_QATU > 0)SB260 ON SB2.B2_COD = SB260.B2_COD
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_80
            FROM SB2100 SB2
			INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
			WHERE SB2.D_E_L_E_T_ = ''
			AND B2_FILIAL = '01'
			AND B2_LOCAL = '80'
			AND B2_QATU > 0)SB280 ON SB2.B2_COD = SB280.B2_COD
LEFT JOIN ( SELECT B2_COD,B2_QATU QTD_50
            FROM SB2100 SB2
			INNER JOIN SB1100 SB1 ON B2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
			WHERE SB2.D_E_L_E_T_ = ''
			AND B2_FILIAL = '01'
			AND B2_LOCAL = '50'
			AND B2_QATU > 0)SB250 ON SB2.B2_COD = SB250.B2_COD
WHERE SB2.D_E_L_E_T_ = ''
AND SB2.B2_COD NOT LIKE 'MOD%'
AND B2_FILIAL = '01'
//AND B2_LOCAL IN ('10')
AND SB2.B2_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY B1_DESC



	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Produto:",20)+"?","","","mv_ch1","C",15,0,0,"G","","","SB1","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Produto:",20)+"?","","","mv_ch2","C",15,0,0,"G","","","SB1","","mv_par02")

Return
