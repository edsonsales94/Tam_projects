
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMLFATR55  บAutor  ณJuevan Silva     				บ Data ณ  18/04/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Pedidos a Faturar Armazem 80                        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR55()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLFATR55"

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

	oReport := TReport():New(cPerg,"Pedidos a Faturar Armazem 80",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Pedidos a Faturar Armazem 80",{"SC2"},aOrdem) 

    TRCell():New(oSection,"C6_FILIAL"   	    ,"SC6","C6_FILIAL","@!",3)
    TRCell():New(oSection,"C6_NOTA"   	    ,"SC6","C6_NOTA","@!",10)
	TRCell():New(oSection,"C5_EMISSAO"		    ,"SC5","C5_EMISSAO","@!",10)
	TRCell():New(oSection,"C6_ENTREG"		    ,"SC6","C6_ENTREG","@!",10)
    TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)
	TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	TRCell():New(oSection,"C6_DESCRI"  	     ,"SC6","C6_DESCRI","@!",40)
	TRCell():New(oSection,"C6_QTDVEN"		 ,"SC6","C6_QTDVEN","@E 999,999,999,999",10)
	TRCell():New(oSection,"C6_LOCAL"         ,"SC6","C6_LOCAL","@!",3)
	TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	TRCell():New(oSection,"A1_NOME"	    ,"SA1","A1_NOME","@!",20)
	TRCell():New(oSection,"A1_MUN"  			,"SA1","A1_MUN","@!",15)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 

	
    
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999.999",,.F.,.T.)

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


SELECT C6_FILIAL,C6_NOTA,C5_EMISSAO,C6_ENTREG,C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_LOCAL,C6_CLI,A1_NOME,A1_MUN
FROM SC6100 SC6 (NOLOCK)
INNER JOIN SC5100 SC5 (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' AND A1_MSBLQL !='1'
WHERE SC6.D_E_L_E_T_ = ''
AND C6_LOCAL = '80'
ORDER BY C5_EMISSAO

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	//u_InPutSX1(cPerg,"01",PADR("DT Ini:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	//u_InPutSX1(cPerg,"02",PADR("DT Fim:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
