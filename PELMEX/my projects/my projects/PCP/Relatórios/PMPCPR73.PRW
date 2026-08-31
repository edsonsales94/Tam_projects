#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR72    ºAutor  ³Wylliam Silva     				º Data ³  27/04/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório Diferença OP PELxAMA (Art,Sup)    				  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR73()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR73"

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

	oReport := TReport():New(cPerg,"Relatório Diferença OP PELxAMA (Art,Sup)",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Relatório Diferença OP PELxAMA (Art,Sup)",{"SC2"},aOrdem)  
	
	TRCell():New(oSection,"COMP"	        ,"SG1","COMP","@!",15)
	TRCell():New(oSection,"B1_DESC"	      	,"SB1","DESCRICAO","@!",30)
	TRCell():New(oSection,"B1_UM"	        ,"SB1","UM","@!",10)   
	TRCell():New(oSection,"QTD_PELMEX"	    ,"SC2","QTD.PELEX","@E 999,999,999,999",)          
	TRCell():New(oSection,"QTD_APTPEL"      ,"SC2","QTD.APT PEL","@E 999,999,999,999",) 
	TRCell():New(oSection,"QTD_AMAZON"   	,"SC2","QTD.AMAZON","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_APTAMA"      ,"SC2","QTD.APT AMA","@E 999,999,999,999",)
	TRCell():New(oSection,"DIF_PELXAMA"     ,"SC2","DIFERENCA","@E 999,999,999,999",)

	
	
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

		SELECT G1_COMP COMP,SB1.B1_DESC,SB1.B1_UM,SUM(C2_QUANT)QTD_PELMEX,SUM(C2_QUJE)QTD_APTPEL,ISNULL(QTD_AMAZON,0)QTD_AMAZON,ISNULL(QTD_APTAMA,0)QTD_APTAMA,SUM(C2_QUANT)-ISNULL(QTD_AMAZON,0) DIF_PELXAMA
		FROM SC2100 SC2
		INNER JOIN PED (NOLOCK) ON C2_NUM = PED_OP AND C2_PRODUTO = PED_PRODUTO AND PED_STATUS != 'C'
		INNER JOIN SG1100 SG1 (NOLOCK)  ON C2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
		INNER JOIN SB1100 SB1 (NOLOCK)  ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''	
		LEFT JOIN (SELECT C2_PRODUTO,SUM(C2_QUANT) QTD_AMAZON,SUM(C2_QUJE)QTD_APTAMA
						FROM SC2200 SC2 (NOLOCK) 
						INNER JOIN SB1200 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = '' 
						WHERE SC2.D_E_L_E_T_ = ''
						AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
						AND B1_DESC LIKE 'SUP%'
						GROUP BY C2_PRODUTO)SC22 ON G1_COMP = SC22.C2_PRODUTO
		WHERE SC2.D_E_L_E_T_ = ''
		AND CONVERT(VARCHAR,CAST(PED_DTPROAMA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND B1_DESC LIKE 'SUP%'
		GROUP BY G1_COMP,SB1.B1_DESC,SB1.B1_UM,QTD_AMAZON,QTD_APTAMA
		HAVING SUM(C2_QUANT)-ISNULL(QTD_AMAZON,0) != 0
		ORDER BY G1_COMP,B1_DESC

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Emissão:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissão:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return
