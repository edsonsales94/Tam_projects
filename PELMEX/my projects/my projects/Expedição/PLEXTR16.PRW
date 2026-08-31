#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXTR16    บAutor  ณJuevan Silva     				บ Data ณ  10/10/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Bipagem Por Pedido 				  						    	 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEXTR16()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLEXTR16"

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

	oReport := TReport():New(cPerg,"Bipagem Por Pedido",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Bipagem Por Pedido",{"PIK"},aOrdem)  
	
	TRCell():New(oSection,"PEDIDO"	    ,"SAI","PEDIDO","@!",6)
    TRCell():New(oSection,"SAI_DOC"	    ,"SAI","NOTA","@!",9)
    TRCell():New(oSection,"SAI_SERIE"	        ,"SAI","SERIE","@!",3)
	TRCell():New(oSection,"CLIENTE"	      	,"SAI","CLIENTE","@!",30)
    TRCell():New(oSection,"NOME"	      	,"SAI","NOME","@!",20)
	TRCell():New(oSection,"TOTAL"	 	,"SAI","TOTAL","@E 999,999,999.999",) 
    TRCell():New(oSection,"A1_MUN"	      	,"SA1","MUNICIPIO","@!",30)
	/* 
	TRCell():New(oSection,"QTD_PELMEX"	    ,"SC2","QTD.PELEX","@E 999,999,999,999",)          
	TRCell():New(oSection,"QTD_APTPEL"      ,"SC2","QTD.APT PEL","@E 999,999,999,999",) 
	TRCell():New(oSection,"QTD_AMAZON"   	,"SC2","QTD.AMAZON","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_APTAMA"      ,"SC2","QTD.APT AMA","@E 999,999,999,999",)
	TRCell():New(oSection,"DIF_PELXAMA"     ,"SC2","DIFERENCA","@E 999,999,999,999",)*/

	oReport:SetTotalInLine(.F.)
	
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
		
SELECT SAI_PEDIDO PEDIDO,SAI_DOC NOTA,SAI_SERIE SERIE,SAI_CLIENTE CLIENTE,SAI_NOME NOME,SUM(SAI_QUANT)TOTAL,A1_MUN
FROM SAI (NOLOCK)
INNER JOIN SA1100 SA1 (NOLOCK) ON SAI_CLIENTE = A1_COD AND SAI_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
WHERE SAI_DOC = ''
GROUP BY SAI_PEDIDO,SAI_DOC,SAI_SERIE,SAI_CLIENTE,SAI_NOME,A1_MUN
ORDER BY SAI_NOME,SAI_PEDIDO,SAI_DOC
		
		/*SELECT PIK_PRODUTO PRODUTO,PIK_DESC DESCRI,COUNT(PIK_CPRODUC) QTD
		FROM PIK
		INNER JOIN SRA100 S1 ON PIK_USERINC = RA_NOME
		WHERE CONVERT(VARCHAR,CAST(PIK_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND RA_MAT =  %Exp:MV_PAR03%
		GROUP BY PIK_PRODUTO,PIK_DESC*/
	
	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	//u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	//u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("Matricula Usuario:" ,20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return
