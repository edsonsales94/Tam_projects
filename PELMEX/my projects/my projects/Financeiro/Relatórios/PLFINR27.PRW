#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFINR27    บAutor  ณWylliam Silva     				บ Data ณ 11/04/2022บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Devolu็ใo Produtos                  							 	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFINR27()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR27"

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

	oReport := TReport():New(cPerg,"Rel. Devolu็ใo Produtos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Devolu็ใo Produtos",{"SD2"},aOrdem)
	
		   
	TRCell():New(oSection,"EXP_NOTA"	    ,"SAI","EXP_NOTA","@!",9) 
	TRCell():New(oSection,"EXP_SERIE"	    ,"SAI","EXP_SERIE","@!",2)
	TRCell():New(oSection,"EXP_FILIAL"	    ,"SAI","EXP_FILIAL","@!",2)
	TRCell():New(oSection,"EXPEDIDO"	    ,"SAI","EXPEDIDO","@!",10)
	TRCell():New(oSection,"HORAEXPEDI"	    ,"SAI","HORAEXPEDI","@!",8)
	TRCell():New(oSection,"CHIP"			,"SAI","CHIP","@!",18)
	TRCell():New(oSection,"CLIENTE"	  		,"SAI","CLIENTE","@!",30)
	TRCell():New(oSection,"NFDEVOLU"	    ,"SD1","NF ENTRADA","@!",9) 
	TRCell():New(oSection,"SERIE_DEVOLU"	,"SD1","SERIE","@!",2)
	TRCell():New(oSection,"DTDEVOLU"		,"SD2","DTDEVOLU","@!",10)
	TRCell():New(oSection,"INVENT"			,"COL","INVENT","@!",9)
	TRCell():New(oSection,"FILIAL_INV"		,"COL","FILIAL_INV","@!",2)	            
	TRCell():New(oSection,"PRODUTO"			,"COL","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"		,"COL","DESCRICAO","@!",30)

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

	
	SELECT SAI_DOC EXP_NOTA,SAI_SERIE EXP_SERIE, SAI_FILIAL EXP_FILIAL, SAI_DTEXP EXPEDIDO,SAI_DTHORA HORAEXPEDI, SAI_CPRODUC CHIP,SAI_NOME CLIENTE,
        D1_DOC NFDEVOLU,D1_SERIE SERIE_DEVOLU,CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103) DTDEVOLU,COL_FILIAL FILIAL_INV,COL_DOC INVENT,COL_COD PRODUTO, COL_DESC DESCRICAO
	FROM SD2100 SD2
	LEFT JOIN SAI  ON D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND SD2.D_E_L_E_T_ =''
	LEFT JOIN SD1100 SD1 ON D1_NFORI = D2_DOC AND D1_SERIORI = D2_SERIE AND SD1.D_E_L_E_T_ =''
	LEFT JOIN COLINV COL ON COL_CPRODUC = SAI_CPRODUC
	LEFT JOIN PIK ON PIK_CPRODUC = SAI_CPRODUC
	WHERE SAI_DOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SAI_SERIE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND SAI_PRODUTO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	GROUP BY SAI_DOC ,SAI_SERIE , SAI_FILIAL , SAI_DTEXP ,SAI_DTHORA , SAI_CPRODUC ,SAI_NOME, COL_FILIAL,COL_DOC,COL_COD,COL_DESC,D1_DOC,D1_SERIE,D1_EMISSAO
	ORDER BY SAI_CPRODUC,COL_DOC
	
		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Nota Fiscal "   ,20)+"?","","","mv_ch1","C",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("At้ Nota Fiscal "  ,20)+"?","","","mv_ch2","C",10,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Serie "     ,20)+"?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("At้ Serie "    ,20)+"?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")
u_InPutSX1(cPerg,"05",PADR("De Produto "   ,20)+"?","","","mv_ch5","C",15,0,0,"G","","SB1","","","mv_par05") 
u_InPutSX1(cPerg,"06",PADR("At้ Produto "  ,20)+"?","","","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06")
   
Return