#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR30    บAutor  ณWylliam Silva    	    			บ Data ณ  25/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rel. Movimentos Internos     						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR30()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR30"

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

	oReport := TReport():New(cPerg,"Rel. Movimentos internos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Movimentos Internos",{"SD3"},aOrdem)  

	TRCell():New(oSection,"D3_FILIAL"		,"SD3","FILIAL","@!",3)           
	TRCell():New(oSection,"D3_TM" 	   	    ,"SD3","TM","@!",5) 
	TRCell():New(oSection,"D3_COD"    	    ,"SD3","CODIGO","@!",15)
	TRCell():New(oSection,"B1_DESC"  		,"SB1","DESCRICAO","@!",35)
    TRCell():New(oSection,"D3_UM"    	    ,"SD3","UM","@!",4) 
    TRCell():New(oSection,"D3_QUANT"    	,"SD3","QTD","@E 999,999,999.99999",)
    TRCell():New(oSection,"D3_CF"    	    ,"SD3","CF","@!",5) 
	TRCell():New(oSection,"D3_CONTA"    	,"SD3","CONTA","@!",15) 	  
    TRCell():New(oSection,"D3_OP"    	    ,"SD3","OP","@!",12) 
    TRCell():New(oSection,"D3_LOCAL"    	,"SD3","LOCAL","@!",4) 
    TRCell():New(oSection,"D3_DOC"    	    ,"SD3","DOCUMENTO","@!",15)
    TRCell():New(oSection,"D3_EMISSAO"      ,"SD3","EMISSAO","@!",10)
    TRCell():New(oSection,"D3_GRUPO"    	,"SD3","GRUPO","@!",6)
    TRCell():New(oSection,"D3_CUSTO1"    	,"SD3","CUSTO","@E 999,999,999.99",)
    TRCell():New(oSection,"D3_CC"    	    ,"SD3","CC","@!",6)
    TRCell():New(oSection,"D3_TIPO"    	    ,"SD3","TIPO","@!",4)
    TRCell():New(oSection,"D3_USUARIO"    	,"SD3","USUARIO","@!",20)
    TRCell():New(oSection,"D3_ESTORNO"    	,"SD3","ESTORNO","@!",9)
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

    SELECT D3_FILIAL,D3_TM,D3_COD,B1_DESC,D3_UM,D3_QUANT,D3_CF,D3_CONTA,D3_OP,D3_LOCAL,D3_DOC,D3_EMISSAO,D3_GRUPO,D3_CUSTO1,D3_CC,D3_TIPO,D3_USUARIO,D3_ESTORNO
    FROM %Table:SD3% (NOLOCK) SD3
    INNER JOIN %Table:SB1% (NOLOCK) SB1 ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ =''
    WHERE SD3.D_E_L_E_T_ = ''
    AND D3_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:" ,20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//_InPutSX1(cPerg,"03",PADR("De Dt Digit:" ,20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Dt Digit:",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")

Return
