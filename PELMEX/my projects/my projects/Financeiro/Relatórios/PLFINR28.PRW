#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR28    บAutor  ณWylliam Silva     				บ Data ณ 08/04/2022บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Nota Fiscal                      								 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR28()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR28"

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

	oReport := TReport():New(cPerg,"Rel. Nota Fiscal",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Nota Fiscal",{"SD2"},aOrdem)
	
		   
	TRCell():New(oSection,"NOTA"	 	    ,"SD2","NOTA FISCAL","@!",9) 
	TRCell():New(oSection,"SERIE"	        ,"SD2","SERIE","@!",2)
	TRCell():New(oSection,"FILIAL"		    ,"SD2","FILIAL","@!",2)
	TRCell():New(oSection,"ITEM"		    ,"SD2","ITEM","@!",2)
	TRCell():New(oSection,"CODIGO"	  		,"SD2","CODIGO","@!",15)
	TRCell():New(oSection,"DESCRICAO"	    ,"SB1","DESCRICAO","@!",30)
	TRCell():New(oSection,"QTD"				,"SD2","QTD","@E 9,999,999,999,999",)
	TRCell():New(oSection,"VLR_UNIT"	 	,"SD2","VLR.UNIT","@E 9,999,999,999.99",)
	TRCell():New(oSection,"TOTAL"	  		,"SD2","TOTAL","@E 9,999,999,999.99",)
	TRCell():New(oSection,"TES"				,"SD2","TES","@!",3)
	TRCell():New(oSection,"CFOP"			,"SD2","CFOP","@!",4)
	TRCell():New(oSection,"PEDIDO"			,"SD2","PEDIDO","@!",8)            
	TRCell():New(oSection,"COD_CLIENTE"		,"SD2","COD_CLIENTE","@!",8)
	TRCell():New(oSection,"UF"				,"SD2","UF","@!",2)
	TRCell():New(oSection,"DTEMISSAO"		,"SD2","DTEMISSAO","@!",8)

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

	
		SELECT D2_DOC NOTA,D2_SERIE SERIE,D2_FILIAL FILIAL,D2_ITEM ITEM,D2_COD CODIGO,B1_DESC DESCRICAO,D2_QUANT QTD,D2_PRCVEN VLR_UNIT,D2_TOTAL TOTAL,D2_TES TES,D2_CF CFOP,D2_PEDIDO PEDIDO,D2_CLIENTE COD_CLIENTE,
		        D2_TP UF,CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103) DTEMISSAO
		FROM SD2100
		INNER JOIN SB1100 SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ =''
		WHERE D2_DOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND D2_SERIE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		ORDER BY ITEM

		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Nota Fiscal "      ,20)+"?","","","mv_ch1","C",9,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("At้ Nota Fiscal "      ,20)+"?","","","mv_ch2","C",9,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Serie "      ,20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("At้ Serie "      ,20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")
   

Return