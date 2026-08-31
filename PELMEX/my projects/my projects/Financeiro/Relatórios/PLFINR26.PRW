#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR26    บAutor  ณWylliam Silva     				บ Data ณ 14/02/2022บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Vendas Namaspet                      								 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR26()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR26"

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

	oReport := TReport():New(cPerg,"Vendas Namaspet",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Vendas Namaspet",{"SD2"},aOrdem)
	
		   
	TRCell():New(oSection,"FILIAL"		    ,"SD2","FILIAL",/*Mascara*/,5) 
	TRCell():New(oSection,"NOTA"		    ,"SD2","NOTA FISCAL",/*Mascara*/,10)
	TRCell():New(oSection,"SERIE"		    ,"SD2","SERIE",/*Mascara*/,4)
	TRCell():New(oSection,"DT_EMISSAO"	    ,"SD2","DT EMISSAO",/*Mascara*/,10)
	TRCell():New(oSection,"PRODUTO"		    ,"SD2","PRODUTO",/*Mascara*/,15)
	TRCell():New(oSection,"DESCRICAO"		,"SB1","DESCRICAO",/*Mascara*/,30)
	TRCell():New(oSection,"QUANTIDADE"	    ,"SD2","QUANTIDADE","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"VALOR"		    ,"SD2","VALOR","@E 9,999,999,999.999",8)
	TRCell():New(oSection,"TOTAL"		    ,"SD2","TOTAL","@E 9,999,999,999.999",8)
	TRCell():New(oSection,"CLIENTE"	    	,"SD2","CLIENTE",/*Mascara*/,10)
	TRCell():New(oSection,"NOME"	    	,"SA1","NOME CLIENTE",/*Mascara*/,30)
	TRCell():New(oSection,"VENDEDOR"		,"SF2","VENDEDOR",/*Mascara*/,10)
	TRCell():New(oSection,"NOME_VEND"	    ,"SA3","NOME",/*Mascara*/,20)
	            

	//Segunda se็ใo
	//oSection2 := TRSection():New(oReport,"TOTAL GERAL RECEBER X NOTAS FISCAIS",{"SE1"},aOrdem)  

	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("VAL_RECEBER"),"TOTAL Recebido","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//oReport:SetTotalInLine(.F.)

	//Quebra por Se็ใo
	//oSection1:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ท
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   

SELECT D2_FILIAL FILIAL,D2_DOC NOTA,D2_SERIE SERIE,
       D2_EMISSAO DT_EMISSAO,
       D2_COD PRODUTO,B1_DESC DESCRICAO,D2_QUANT QUANTIDADE,D2_PRCVEN VALOR,D2_TOTAL TOTAL,D2_CLIENTE CLIENTE,A1_NOME NOME,F2_VEND1 VENDEDOR,A3_NOME NOME_VEND
		FROM SD2100 SD2
		INNER JOIN SF2100 SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND F2_SERIE = D2_SERIE AND SF2.D_E_L_E_T_ = ''
		INNER JOIN SB1100 SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
		INNER JOIN SA1100 SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
		LEFT JOIN SD1100 SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
		LEFT JOIN SA3100 SA3 ON F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
		WHERE SD2.D_E_L_E_T_ = ''
		AND D1_DOC IS NULL
		AND D2_FILIAL = '01'
		AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND (B1_XSETOR LIKE 'NAMASPET%'
		OR B1_DESC LIKE '%NAMASPET%'
		OR F2_VEND1 = '270')
		ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM	
	    
					

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Dt Emissao "      ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("At้ Dt Emissao"      ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
   

Return
