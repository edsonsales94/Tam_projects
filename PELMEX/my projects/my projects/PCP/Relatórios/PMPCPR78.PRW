#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR77    ºAutor  ³Wylliam Silva     				º Data ³  29/05/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Revisao Plano de Lamina	 			                 		  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR78()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR78"

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

	oReport := TReport():New(cPerg,"Revisao Plano de Lamina",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Revisao Plano de Lamina",{"PED"},aOrdem)  
	
	TRCell():New(oSection,"PED_PRODUTO"    	,"PED","PRODUTO","@!",10)
	TRCell():New(oSection,"PED_DESCRI"    	,"PED","DESCRI PROD","@!",30)
	TRCell():New(oSection,"G1_TRT"	 	 	,"SG1","SEQUENCIA","@!",8)
	TRCell():New(oSection,"G1_COMP"	 	 	,"SG1","COD.COMP","@!",15)
	TRCell():New(oSection,"B1_DESC"	 	 	,"SB1","DESC.COMP","@!",30)
	TRCell():New(oSection,"G1_XDIMENS"	  	,"SG1","DIMENSAO","@E 999,999.999",)
	TRCell():New(oSection,"TOTAL"		 	,"PED","QTD_APONT","@E 999,999.999",)

	
	/*TRCell():New(oSection,"C6_FILIAL"	  	,"SC2","FILIAL","@!",2)
	TRCell():New(oSection,"C6_QUANT"    	,"SC6","QUANTIDADE","@E 999,999,999,999",) 
	TRCell():New(oSection,"C6_PRCVEN"    	,"SC6","PREÇO VEND","@E 999,999,999.999",)
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("ETIQUETA"),"Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)*/

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
		
		SELECT PED_PRODUTO,PED_DESCRI,G1_TRT,G1_COMP,B1_DESC,REPLACE(REPLACE(G1_XDIMENS,CHAR(10),''),CHAR(13),'')G1_XDIMENS,SUM(TOTAL)TOTAL
				FROM(
						SELECT PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS INT)TOTAL
						FROM(
						SELECT PED_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_DTPROPEL,PED_NOME,PED_SETOR
						FROM PED (NOLOCK)
						WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
						AND PED_STATUS != 'C'
						GROUP BY PED_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_DTPROPEL,PED_NOME,PED_SETOR
						)TB
						GROUP BY PED_PRODUTO,PED_DESCRI
						)TB1
				INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
				INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''
				WHERE B1_DESC LIKE 'BL%'
				
				GROUP BY PED_PRODUTO,PED_DESCRI,G1_TRT,G1_COMP,B1_DESC,REPLACE(REPLACE(G1_XDIMENS,CHAR(10),''),CHAR(13),'')		

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return