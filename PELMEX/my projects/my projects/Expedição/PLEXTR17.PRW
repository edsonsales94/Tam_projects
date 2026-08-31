#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXTR17    บAutor  ณJUEVAN SILVA     				บ Data ณ  11/02/25 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Saida da Expedicao           				  							 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEXTR17()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLEXTR17"

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

	oReport := TReport():New(cPerg,"Saida da Expedicao",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Saida da Expedicao",{"SD2"},aOrdem)  
	
	TRCell():New(oSection,"OP"    ,"SAI","OP","@!",13)
    TRCell():New(oSection,"SAI_DOC"    ,"SAI","SAI_DOC","@!",10)
    TRCell():New(oSection,"SAI_SERIE"    ,"SAI","SAI_SERIE","@!",03)
	TRCell():New(oSection,"DT_NOTA"    ,"SAI","DT_NOTA","@!",10)
    TRCell():New(oSection,"SAI_PRODUTO"    ,"SAI","SAI_PRODUTO","@!",13)
    TRCell():New(oSection,"SAI_DESCPROD"    ,"SAI","SAI_DESCPROD","@!",30)
    TRCell():New(oSection,"SAI_CLIENTE"    ,"SAI","SAI_CLIENTE","@!",06)
    TRCell():New(oSection,"SAI_NOME"    ,"SAI","SAI_NOME","@!",30)
	/* TRCell():New(oSection,"OP"    ,"SAI","OP","@!",13)
	TRCell():New(oSection,"QTD_PELMEX"	    ,"SC2","QTD.PTRCell():New(oSection,"OP"    ,"SAI","OP","@!",13)ELEX","@E 999,999,999,999",)          
	TRCell():New(oSection,"QTD_APTPEL"      ,"SC2","QTD.APT PEL","@E 999,999,999,999",) TRCell():New(oSection,"OP"    ,"SAI","OP","@!",13)
	TRCell():New(oSection,"QTD_AMAZON"   	,"SC2","QTD.AMAZON","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_APTAMA"      ,"SC2","QTD.APT AMA","@E 999,999,999,999",)
	TRCell():New(oSection,"DIF_PELXAMA"     ,"SC2","DIFERENCA","@E 999,999,999,999",)*/

	
	
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
		
SELECT SAI_CPRODUC OP,SAI_DOC,SAI_SERIE,CONVERT(VARCHAR,CAST(SAI_EMISSAO AS DATE),103)DT_NOTA,SAI_PRODUTO,SAI_DESCPROD,SAI_CLIENTE,SAI_NOME
FROM SAI
WHERE SAI_DOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND SAI_CLIENTE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	
	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)
    u_InPutSX1(cPerg,"01",PADR("De Nota:" ,20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Nota:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Cliente:",20)+"?","","","mv_ch1","C",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Cliente:",20)+"?","","","mv_ch2","C",10,0,0,"G","","","","","mv_par04")

	

Return
