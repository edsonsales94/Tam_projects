#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR31   ºAutor  ³Juevan Silva     				º Data ³  28/11/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Artefatos X Tecidos Amazon                      			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR31()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR31"

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

	oReport := TReport():New(cPerg,"Artefatos X Tecidos Amazon",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Artefatos X Tecidos Amazon",{"SC2"},aOrdem) 


    TRCell():New(oSection,"CODIGO"   	     ,"SG1","CODIGO","@!",15)
	TRCell():New(oSection,"DESCPA"		      ,"SB1","DESCPA","@!",30)
	TRCell():New(oSection,"UMPA"		     ,"SB1","UMPA","@!",3)
    TRCell():New(oSection,"QTD_20"		   ,"SB2","QTD20","@@E 999,999,999.999",) 
    TRCell():New(oSection,"COMPONENTE"    ,"SG1","COMPONENTE","@!",12) 
	TRCell():New(oSection,"DESCPI"		      ,"SB1","DESCPI","@!",30)
    TRCell():New(oSection,"UMPI"		     ,"SB1","UMPI","@!",3)   
	TRCell():New(oSection,"QTD_01"		   ,"SB2","QTD01","@@E 999,999,999.999",)
	//TRCell():New(oSection,"DATA" 	,"CLE","DATA","@!",10) 
	//TRCell():New(oSection,"HORA"	,"CLE","HORA","@!",10) 
	
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


SELECT SG1.G1_COD CODIGO,SB1.B1_DESC DESCPA,SB1.B1_UM UMPA,SB2.B2_QATU QTD_20,SG1.G1_COMP COMPONENTE,SB12.B1_DESC DESCPI,SB12.B1_UM UMPI,SB22.B2_QATU QTD_01
FROM SG1200 SG1 (NOLOCK)
INNER JOIN SB1200 SB1 (NOLOCK) ON SG1.G1_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SB1200 SB12 (NOLOCK) ON SG1.G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
INNER JOIN SB2200 SB2 (NOLOCK) ON SG1.G1_COD = SB2.B2_COD AND SB2.B2_FILIAL = '01' AND SB2.B2_LOCAL = '20' AND SB2.D_E_L_E_T_ = ''
INNER JOIN SB2200 SB22 (NOLOCK) ON SG1.G1_COMP = SB22.B2_COD AND SB22.B2_FILIAL = '01' AND SB22.B2_LOCAL = '01' AND SB22.D_E_L_E_T_ = ''
WHERE SG1.D_E_L_E_T_ = ''
AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
AND SB12.B1_DESC LIKE 'TEC%'
AND SB12.B1_DESC NOT LIKE '%TNT%'
AND SG1.G1_COD LIKE '070%'
AND SB1.B1_DESC LIKE 'ART%'
ORDER BY SB1.B1_DESC

 
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	//u_InPutSX1(cPerg,"01",PADR("DT Bipagem:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	//u_InPutSX1(cPerg,"02",PADR("DT Fim Bipagem:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
