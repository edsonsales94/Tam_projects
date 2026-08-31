#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR95   ºAutor  ³Juevan Silva     				º Data ³  21/03/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Monta Kit PA                        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR95()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR95"

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

	oReport := TReport():New(cPerg,"Monta Kit PA",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Monta Kit PA",{"SC2"},aOrdem) 

  CLIENTE
    TRCell():New(oSection,"PED_DTPROPEL"   	    ,"PED","PED_DTPROPEL","@!",10)
	TRCell():New(oSection,"PED_PRODUTO"		        ,"PED","PED_PRODUTO","@!",20)
	TRCell():New(oSection,"PED_DESCRI"		    ,"PED","PED_DESCRI","@!",60) 
    TRCell():New(oSection,"G1_TRT"		    ,"SG1","G1_COMP","@!",10) 
	TRCell():New(oSection,"G1_COMP"		    ,"SG1","G1_COMP","@!",20)   
    TRCell():New(oSection,"B1_DESC"	    ,"SB1","B1_DESC","@!",30)         
	TRCell():New(oSection,"QUANTIDADE"  	    ,"PED","QUANTIDADE","@@E 999,999,999.999",)
	TRCell():New(oSection,"G1_XDENSID"			    ,"SG1","G1_XDENSID","@!",4)
	TRCell():New(oSection,"G1_XDIMENS"        ,"SG1","G1_XDENSID","@!",30)
	//TRCell():New(oSection,"QTD_SOLICITADA" 	,"SG1","QTDE SOLICITAdA","@E 999,999,999.999",)
	//TRCell():New(oSection,"QTD_EMPENHADA"	,"SG1","QtDE EMPENHADA","@E 999,999,999.999",)
	//TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",12)
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

    
SELECT PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,PED_QUANT,G1_TRT,G1_COMP,B1_DESC,CAST(PED_QUANT AS FLOAT) QUANTIDADE,G1_XDENSID,G1_XDIMENS
FROM(
SELECT PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,SUM(PED_QUANT) PED_QUANT
FROM(
SELECT PED_DTPROPEL,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT
FROM PED
WHERE PED_STATUS != 'C'
AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
GROUP BY PED_DTPROPEL,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT
)TB
GROUP BY PED_DTPROPEL,PED_PRODUTO,PED_DESCRI
)TB1
INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = SG1.G1_COD AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE SB1.B1_DESC LIKE 'ART%'
AND SB1.B1_DESC NOT LIKE '%TNT%'
AND SB1.B1_DESC NOT LIKE '%BL%CIL%'
GROUP BY PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,PED_QUANT,G1_TRT,G1_COMP,B1_DESC,G1_XDENSID,G1_XDIMENS
ORDER BY CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112),PED_DESCRI,B1_DESC

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Prod:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate DtProd:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
