#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  RCOMR12    บAutor  ณjUEVAN SILVA    				บ Data ณ  21/12/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel. Uso E Consumo 									 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RCOMR12()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "RCOMR12"

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

	oReport := TReport():New(cPerg,"Rel. Uso E Consumo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      •//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Uso E Consumo",{"SC7"},aOrdem) 

	TRCell():New(oSection,"C7_FILIAL"    		,"SC7","FILIAL","@!",3)
	TRCell():New(oSection,"C7_NUM"  			,"SC7","PEDIDO","@!",15)
	TRCell():New(oSection,"C7_PRODUTO"  		,"SC7","CODIGO","@!",15)
	TRCell():New(oSection,"C7_DESCRI"   		,"SC7","DESCRI","@!",30)
	TRCell():New(oSection,"C7_UM"   		    ,"SC7","UM","@!",3)
	TRCell():New(oSection,"C7_QUANT"            ,"SC7","QNT","@E 999,999,999,999",)
    TRCell():New(oSection,"C7_PRECO"            ,"SC7","PRECO","@E 999,999,999,999",)
	TRCell():New(oSection,"C7_TOTAL"               ,"SC7","TOTAL","@E 999,999,999,999.99",)
    TRCell():New(oSection,"C7_CC"                 ,"SC7","CONTA","@!",5)
	TRCell():New(oSection,"CLIENTE"   		    ,"SC7","CLIENTE","@!",7)
	TRCell():New(oSection,"D1_DOC"   		    ,"SD1","NOTA","@!",10)
	TRCell():New(oSection,"D1_EMISSAO"   		  ,"SD1","EMISSAO","@!",10)
	TRCell():New(oSection,"D1_DTDIGIT"   		  ,"SD1","DT_DIGITACAO","@!",10)
    TRCell():New(oSection,"D1_GRUPO"   		  ,"SD1","GRUPO","@!",4)

	//TRCell():New(oSection,"RA_DTFIMCT"	        		,"SRA","Fim do Contrato",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_DEFIFIS"	       			,"SRA","Deficiente",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_BRPDH"	        		,"SRA","Reabilitado?",/*Mascara*/,/*Tamanho*/)
	//TRCell():New(oSection,"RA_TPDEFFI"        			,"SRA","Tipo de Deficiencia",/*Mascara*/,/*Tamanho*/)
	//Totalizador                                                                                  


	/*
	TRFunction():New(oSection:Cell("M"),"Masculino","SUM",,,,,.F.,.T.)  
	TRFunction():New(oSection:Cell("F"),"Feminino","SUM",,,,,.F.,.T.)  
	*/
	//TRFunction():New(oSection:Cell("DA1_DESC"),"TOTAL DIFERENวA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("DA1_TOTAL"),"TOTAL FABRICA","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)  
	/*
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                      MIMIM ท
	//endif      
	Local nTotReg :=0

	/*
	local par01 :=0
	local par02 :=0
	if %Exp:MV_PAR05% == 1 
	par01 := "M"
	else
	par01 := "F"
	endif 
	if %Exp:MV_PAR06% == 1 
	par02 := "M"
	else
	par02 := "F"
	endif
	*/

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%   

    SELECT C7_FILIAL,C7_NUM, C7_PRODUTO, C7_DESCRI,C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL,C7_CC, C7_FORNECE CLIENTE ,D1_DOC, C7_EMISSAO, D1_DTDIGIT,D1_GRUPO
    FROM SC7100 SC7
	INNER JOIN SD1100 SD1 ON D1_COD = C7_PRODUTO AND D1_FORNECE = C7_FORNECE AND SD1.D_E_L_E_T_ = ''
    WHERE C7_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND C7_FILIAL BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND C7_NUM  BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	AND D1_DOC BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND C7_CC BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
	AND D1_GRUPO BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%

	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)            
	u_InPutSX1(cPerg,"01",PADR("De Emissao",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Filial",20)+"?","","","mv_ch3","C",6,0,0,"G","","SA2","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Filial",20)+"?","","","mv_ch4","C",6,0,0,"G","","SA2","","","mv_par04")
    u_InPutSX1(cPerg,"05",PADR("De Pedido" ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
    u_InPutSX1(cPerg,"06",PADR("Ate Pedido",20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06") 
    u_InPutSX1(cPerg,"07",PADR("De Nota" ,20)+"?","","","mv_ch7","C",9,0,0,"G","","","","","mv_par07") 
    u_InPutSX1(cPerg,"08",PADR("Ate Nota",20)+"?","","","mv_ch8","C",9,0,0,"G","","","","","mv_par08")
    u_InPutSX1(cPerg,"09",PADR("De Conta" ,20)+"?","","","mv_ch9","C",10,5,0,"G","","","","","mv_par09") 
    u_InPutSX1(cPerg,"10",PADR("Ate Conta",20)+"?","","","mv_ch10","C",10,5,0,"G","","","","","mv_par10")
    u_InPutSX1(cPerg,"11",PADR("De Grupo",20)+"?","","","mv_ch11","C",10,5,0,"G","","","","","mv_par11") 
    u_InPutSX1(cPerg,"12",PADR("Ate Grupo",20)+"?","","","mv_ch12","C",10,5,0,"G","","","","","mv_par12")

Return
