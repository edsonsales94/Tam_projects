#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLCOMR11    บAutor  ณWylliam Silva     				บ Data ณ  02/05/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Produtos sem Controle de Estoque 		  		                     	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLCOMR11()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLCOMR11"

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

	oReport := TReport():New(cPerg,"Produtos sem Controle de Estoque",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Produtos sem Controle de Estoque",{"SB1"},aOrdem)  
	
	
	TRCell():New(oSection,"EMPRESA"	  		,"SB1","EMPRESA","@!",6)
	TRCell():New(oSection,"B1_CODBAR"	   	,"SB1","CODIGO BARRA","@!",30)
	TRCell():New(oSection,"B1_COD"	   		,"SB1","CODIGO","@!",15)
	TRCell():New(oSection,"B1_DESC"	   		,"SB1","DESC PROD","@!",30)   
	TRCell():New(oSection,"B1_UM"		    ,"SB1","UM","@!",3)         
	TRCell():New(oSection,"D1_QUANT"  	    ,"SD1","SALDO ENTRADA","@E 999,999,999.999") 
	TRCell():New(oSection,"B9_QUANT"   		,"SB9","SALDO INICIAL","@E 999,999,999.999")
	TRCell():New(oSection,"D3_QUANT"  		,"SD3","SALDO PERIODO","@E 999,999,999.999")
	TRCell():New(oSection,"SALDO"  			,"SC7","SALDO TOTAL","@E 999,999,999.999")

	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"
	//endif      

//inicia o Sql
	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

	SELECT 'PELMEX' EMPRESA,B1_CODBAR,B1_COD,B1_DESC,B1_UM,ISNULL(D1_QUANT,0)D1_QUANT,ISNULL(B9_QUANT,0)B9_QUANT,ISNULL(D3_QUANT,0)D3_QUANT,
			       (ISNULL(D1_QUANT,0)+ISNULL(B9_QUANT,0))+ISNULL(D3_QUANT,0) SALDO
			FROM SB1100 SB1 (NOLOCK)
			LEFT JOIN (SELECT '10' EMPRESA,D1_FILIAL,D1_COD,SUM(D1_QUANT)D1_QUANT,D1_LOCAL
			      FROM SD1100 SD1 (NOLOCK)
			      WHERE SD1.D_E_L_E_T_ = ''
			      AND D1_FILIAL = '01'
			      AND D1_LOCAL = '01'
			      AND D1_TIPO = 'N'
			      AND D1_DTDIGIT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			      GROUP BY D1_FILIAL,D1_COD,D1_LOCAL)SD1 ON SD1.EMPRESA = '10' AND SD1.D1_COD = SB1.B1_COD
			LEFT JOIN (SELECT B9_EMPRESA,B9_FILIAL,B9_COD,B9_QUANT,B9_LOCAL,B9_DATA
			           FROM SB9 (NOLOCK)
			       WHERE B9_EMPRESA = '10'
			       AND B9_DATA BETWEEN SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)+'01' AND SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)+'31'
			       )SB9 ON B9_EMPRESA = '10' AND SB1.B1_COD = B9_COD
			LEFT JOIN (SELECT D3_EMPRESA,D3_FILIAL,D3_COD,SUM(D3_QUANT)D3_QUANT,D3_LOCAL
			           FROM SD3 (NOLOCK)
			       WHERE D3_EMPRESA = '10'
			       AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			       GROUP BY D3_EMPRESA,D3_FILIAL,D3_COD,D3_LOCAL)SD3 ON D3_EMPRESA = '10' AND SB1.B1_COD = D3_COD
			WHERE SB1.D_E_L_E_T_ = ''
			AND B1_MSBLQL != '1'
			AND B1_XFANTAS = 'S'
			AND B1_TIPO NOT IN ('PA')
			
			UNION
			
			SELECT 'AMAZON' EMPRESA,B1_CODBAR,B1_COD,B1_DESC,B1_UM,ISNULL(D1_QUANT,0)D1_QUANT,ISNULL(B9_QUANT,0)B9_QUANT,ISNULL(D3_QUANT,0)D3_QUANT,
			       (ISNULL(D1_QUANT,0)+ISNULL(B9_QUANT,0))+ISNULL(D3_QUANT,0) SALDO
			FROM SB1100 SB1 (NOLOCK)
			LEFT JOIN (SELECT '20' EMPRESA,D1_FILIAL,D1_COD,SUM(D1_QUANT)D1_QUANT,D1_LOCAL
			      FROM SD1100 SD1 (NOLOCK)
			      WHERE SD1.D_E_L_E_T_ = ''
			      AND D1_FILIAL = '01'
			      AND D1_LOCAL = '01'
			      AND D1_TIPO = 'N'
			      AND D1_DTDIGIT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			      GROUP BY D1_FILIAL,D1_COD,D1_LOCAL)SD1 ON SD1.EMPRESA = '20' AND SD1.D1_COD = SB1.B1_COD
			LEFT JOIN (SELECT B9_EMPRESA,B9_FILIAL,B9_COD,B9_QUANT,B9_LOCAL,B9_DATA
			           FROM SB9 (NOLOCK)
				       WHERE B9_EMPRESA = '20'
				       AND B9_DATA BETWEEN SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)+'01' AND SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)+'31'
				       )SB9 ON B9_EMPRESA = '20' AND SB1.B1_COD = B9_COD
			LEFT JOIN (SELECT D3_EMPRESA,D3_FILIAL,D3_COD,SUM(D3_QUANT)D3_QUANT,D3_LOCAL
			           FROM SD3 (NOLOCK)
				       WHERE D3_EMPRESA = '20'
				       AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				       GROUP BY D3_EMPRESA,D3_FILIAL,D3_COD,D3_LOCAL)SD3 ON D3_EMPRESA = '20' AND SB1.B1_COD = D3_COD
			WHERE SB1.D_E_L_E_T_ = ''
			AND B1_MSBLQL != '1'
			AND B1_XFANTAS = 'S'
			AND B1_TIPO NOT IN ('PA')//ORDER BY 1,B1_DESC
				
	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") // Inicio de Data
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02") // Fim de Data
	//u_InPutSX1(cPerg,"03",PADR("Periodo :"   ,20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03")   
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return