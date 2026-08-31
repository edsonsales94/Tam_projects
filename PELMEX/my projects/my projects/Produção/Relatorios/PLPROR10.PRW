#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR09    บAutor  ณWylliam Silva     				บ Data ณ  22/06/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rel. Pontua็ใo Mensal   				  							 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR10()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR10"

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

	oReport := TReport():New(cPerg,"Rel. Pontua็ใo Mensal",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rel. Pontua็ใo Mensal",{"CLA"},aOrdem)  
	
	TRCell():New(oSection,"RA_NOME"	        ,"RA","NOME","@!",30)
	TRCell():New(oSection,"CLA_PONTOS"	    ,"CLA","DESCRICAO","@E 999,999,999,999",)
	   
	/* 
	TRCell():New(oSection,"QTD_PELMEX"	    ,"SC2","QTD.PELEX","@E 999,999,999,999",)          
	TRCell():New(oSection,"QTD_APTPEL"      ,"SC2","QTD.APT PEL","@E 999,999,999,999",) 
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
		
		SELECT RA_NOME,SUM(CLA_PONTOS)CLA_PONTOS
		FROM CLA (NOLOCK)
		INNER JOIN SRA100 SRA (NOLOCK) ON CLA_FILIAL = RA_FILIAL AND CLA_USERINC = RA_MAT AND SRA.D_E_L_E_T_ = ''
		WHERE CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		AND CLA_RETRAB != 'S'
		GROUP BY RA_NOME
		ORDER BY CLA_PONTOS DESC
	
	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("Usuario:" ,20)+"?","","","mv_ch3","C",4,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return