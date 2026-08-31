#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR04    บAutor  ณWilson Junior 	  				บ Data ณ  12/05/20 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RELATORIO DE ESTOQUE 								        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR21()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLESTR21"

	//AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oBreak
	Local aOrdem      := {"FILIAL"}

	oReport := TReport():New(cPerg,"ESTOQUE ATUAL",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"ESTOQUE ATUAL",{"SB2"},aOrdem)     


	TRCell():New(oSection,"EMPRESA"					,"SB2","EMPRESA",'!@',8) 
	TRCell():New(oSection,"CODIGO"					,"SB2","CODIGO",'!@',15)
	TRCell():New(oSection,"DESCRICAO"				,"SB1","DESCRICAO",'!@',30)
	TRCell():New(oSection,"TIPO"					,"SB1","TIPO",'!@',4)
	TRCell():New(oSection,"UM"						,"SB1","UM",'!@',3)
	TRCell():New(oSection,"QTD10"				    ,"SB2","PRODUวรO_QTD","@E 9,999,999.999",)   
	TRCell():New(oSection,"QTD01"				    ,"SB2","ESTOQUE_QTD","@E 9,999,999.999",)       
	TRCell():New(oSection,"ULTPRECO"			    ,"SB1","ULT.PREวO COMPRA","@E 9,999,999.99",) 
	
	//TRFunction():New(oSection:Cell("B2_QATU"),"Produtos em Estoque","SUM",,,"@E 9,999,999,999",,.F.,.T.)

	//Totalizador
	/*                                                                                  



	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)                            MIC
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

	SELECT EMPRESA,CODIGO,DESCRICAO,TIPO,UM,QTD10,QTD01,ULTPRECO
		FROM(   SELECT 'PELMEX' EMPRESA,B1_COD CODIGO,B1_DESC DESCRICAO,B1_TIPO TIPO,B1_UM UM,ISNULL(SB21.QTD10,0)QTD10,ISNULL(SB22.QTD01,0)QTD01,B1_UPRC ULTPRECO
		        FROM SB1100 SB1 (NOLOCK)
		        LEFT JOIN (SELECT B2_FILIAL,B2_COD,SB21.B2_QATU QTD10,B2_LOCAL
		                    FROM SB2100 SB21 (NOLOCK)
		                    WHERE SB21.D_E_L_E_T_ = ''
		                    AND B2_FILIAL = '01'
		                    AND B2_LOCAL = '10'
		                    )SB21 ON SB21.B2_COD = SB1.B1_COD 
		        LEFT JOIN (SELECT B2_FILIAL,B2_COD,SB22.B2_QATU QTD01,B2_LOCAL
		                    FROM SB2100 SB22 (NOLOCK)
		                    WHERE SB22.D_E_L_E_T_ = ''
		                    AND B2_FILIAL = '01'
		                    AND B2_LOCAL = '01'
		                    )SB22 ON SB22.B2_COD = SB1.B1_COD 
		        WHERE SB1.D_E_L_E_T_ = ''
		        AND B1_MSBLQL != '1'
		        AND B1_TIPO IN ('PI','MN','MC','MI')
		
		        UNION
		
		        SELECT 'AMAZON' EMPRESA,B1_COD CODIGO,B1_DESC DESCRICAO,B1_TIPO TIPO,B1_UM UM,ISNULL(SB24.QTD10,0)QTD10,ISNULL(SB23.QTD01,0)QTD01,B1_UPRC ULTPRECO
		        FROM SB1200 SB1 (NOLOCK)
		        LEFT JOIN (SELECT B2_FILIAL,B2_COD,SB24.B2_QATU QTD10,B2_LOCAL
		                    FROM SB2200 SB24 (NOLOCK)
		                    WHERE SB24.D_E_L_E_T_ = ''
		                    AND B2_FILIAL = '01'
		                    AND B2_LOCAL = '10'
		                    )SB24 ON SB24.B2_COD = SB1.B1_COD 
		        LEFT JOIN (SELECT B2_FILIAL,B2_COD,SB23.B2_QATU QTD01,B2_LOCAL
		                    FROM SB2200 SB23 (NOLOCK)
		                    WHERE SB23.D_E_L_E_T_ = ''
		                    AND B2_FILIAL = '01'
		                    AND B2_LOCAL = '01'
		                    )SB23 ON SB23.B2_COD = SB1.B1_COD 
		        WHERE SB1.D_E_L_E_T_ = ''
		        AND B1_MSBLQL != '1'
		        AND B1_TIPO IN ('PI','MN','MC','MI')
		        )TB
		WHERE CODIGO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND TIPO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		ORDER BY 1,2

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)


u_InPutSX1(cPerg,"01",PADR("De Codigo ?   ",20)+"?","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("At้ Codigo?  ",20)+"?","","","mv_ch2","C",15,0,0,"G","","","","","mv_par02")  
u_InPutSX1(cPerg,"03",PADR("De Tipo?   ",20)+"?","","","mv_ch3","C",4,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("At้ Tipo?  ",20)+"?","","","mv_ch4","C",4,0,0,"G","","","","","mv_par04")
/*u_InPutSX1(cPerg,"05",PADR("Emissใo De ?   ",20)+"?","","","mv_ch5","D",8,0,0,"G","","","","","mv_par05") 
u_InPutSX1(cPerg,"06",PADR("Emissใo At้ ?  ",20)+"?","","","mv_ch6","D",8,0,0,"G","","","","","mv_par06") */


Return
*/