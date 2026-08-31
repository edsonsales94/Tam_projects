#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLEXTR08    บAutor  ณWylliam Silva     				บ Data ณ  04/05/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rel. Coleta Rfid Simplificado   				  							 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLEXTR08()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLEXTR08"

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

	oReport := TReport():New(cPerg,"Rel. Coleta Rfid Simplificado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Coleta Rfid Simplificado",{"PIK"},aOrdem)  
	
	TRCell():New(oSection,"PRODUTO"	        ,"PIK","PRODUTO","@!",15)
	TRCell():New(oSection,"B1_CODBAR"	      	,"SB1","Cod_Barras","@!",20)
	TRCell():New(oSection,"DESCRI"	      	,"PIK","DESCRICAO","@!",50)
	TRCell():New(oSection,"PIK_QUANT"	 	,"PIK","QTD TOTAL","@E 999,999,999.999",) 

	TRFunction():New(oSection:Cell("PIK_QUANT"),"TOTAL:","SUM",,,"@E 999,999,999,999.999",,.F.,.T.)
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
		
		SELECT PIK_PRODUTO PRODUTO, B1_CODBAR,PIK_DESC DESCRI,CAST(SUM(PIK_QUANT) AS FLOAT)PIK_QUANT
				FROM(
				SELECT PIK_PRODUTO,PIK_DESC,PIK_CPRODUC,
				       CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END PIK_QUANT,PIK_USERINC,PIK_DATINC, B1_CODBAR
				FROM PIK
				INNER JOIN SRA100 S1 ON PIK_USERINC = RA_NOME
				INNER JOIN SB1100 SB1 (NOLOCK) ON PIK_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
				WHERE CONVERT(VARCHAR,CAST(PIK_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND RA_MAT = %Exp:MV_PAR03%
				)TB
	GROUP BY PIK_PRODUTO,PIK_DESC,PIK_USERINC,PIK_DATINC, B1_CODBAR
	ORDER BY PIK_DESC	
		
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

	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Matricula Usuario:" ,20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return
