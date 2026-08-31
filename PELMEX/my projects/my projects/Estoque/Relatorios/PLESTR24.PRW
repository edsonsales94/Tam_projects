#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLESTR24    บAutor  ณJevan Silva    				บ Data ณ  04/02/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Frete x Nota de Origem 						  					 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLESTR24()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLESTR24"

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

	oReport := TReport():New(cPerg,"Frete x Nota de Origem",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Frete x Nota de Origem",{"SB2"},aOrdem)  


	TRCell():New(oSection,"FILIAL"				,"SF8","FILIAL",,3)           
	TRCell():New(oSection,"NF_CTE" 	   			,"SF8","CTE",,10) 
	TRCell():New(oSection,"TOTAL_CTE" 	   			,"SD1","VALCTE",,10)
	TRCell():New(oSection,"SERIE_CTE"  			,"SF8","SERIE",,3)
	TRCell():New(oSection,"NF_NOTA"    	   			,"SF8","NOTA","@!",10)
	TRCell():New(oSection,"SERIE_NOTA"    	    ,"SF8","SERNOTA","@!",10)   
	TRCell():New(oSection,"COD_TRANS"    	,"SF8","CONDICAO","@!",10)    
	TRCell():New(oSection,"TRANSPORTADOR"    	 ,"SA2","TRANSPORTADOR","@!",40)      
	TRCell():New(oSection,"LOJA_TRANSP"    	,"SF8","LTRANSPORT","@!",10)		
	TRCell():New(oSection,"FORNECEDOR"    	,"SF8","FORNECE","@!",7)
    TRCell():New(oSection,"LOJA"			,"SF8","LOJA","@!",3)  	    
	TRCell():New(oSection,"EMPRESA"    	,"SA2","EMPRESA","@!",30)	
	TRCell():New(oSection,"TIPO" ,"SB2","TIPO","@!",3)
	//TRCell():New(oSection,"DESCGRUPO"			,"SBM","Grupo","@!",20)  
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

	SELECT F8_FILIAL FILIAL,F8_NFDIFRE NF_CTE,F1_VALBRUT TOTAL_CTE,F8_SEDIFRE SERIE_CTE,F8_NFORIG NF_NOTA,F8_SERORIG SERIE_NOTA,F8_TRANSP COD_TRANS,SA21.A2_NOME TRANSPORTADOR,F8_LOJTRAN LOJA_TRANSP,F8_FORNECE FORNECEDOR,F8_LOJA LOJA,SA2.A2_NOME EMPRESA,F8_TIPO TIPO
FROM %Table:SF8% SF8 (NOLOCK)
INNER JOIN %Table:SA2% SA2 (NOLOCK) ON F8_FORNECE = SA2.A2_COD AND F8_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ = ''
INNER JOIN %Table:SF1% SF1 (NOLOCK) ON F8_FILIAL = F1_FILIAL AND F8_NFDIFRE = F1_DOC AND F8_SEDIFRE = F1_SERIE AND SF1.D_E_L_E_T_ = ''
LEFT JOIN %Table:SA2% SA21 (NOLOCK) ON F8_TRANSP = SA21.A2_COD AND F8_LOJTRAN = SA21.A2_LOJA AND SA21.D_E_L_E_T_ = ''
WHERE SF8.D_E_L_E_T_ = ''
AND F8_NFDIFRE BETWEEN '' AND 'ZZZZZZZZ'
AND F8_FORNECE BETWEEN '' AND 'ZZZZZZ'
AND F8_DTDIGIT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
ORDER BY F8_FILIAL,F8_NFDIFRE,F8_SEDIFRE


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:" ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
Return
