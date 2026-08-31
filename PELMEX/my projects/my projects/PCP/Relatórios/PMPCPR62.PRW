#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR62    ºAutor  ³Wylliam Silva     				º Data ³  23/02/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Pick List Marcenaria                                       			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR62()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR62"

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

	oReport := TReport():New(cPerg,"Pick List Marcenaria",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Pick List Marcenaria",{"PED"},aOrdem)  
	
	
	TRCell():New(oSection,"DT_PRODUCAO"		 	     ,"PED","DT_PROD","@!",10)             
	TRCell():New(oSection,"PI"         				 ,"SG2","COD_INTERM","@!",10)
	TRCell():New(oSection,"DESCPI"	    			 ,"SB1","DESCICAO_PI","@!",30)
	TRCell():New(oSection,"UM"	    				 ,"SB1","UM","@!",4)
	TRCell():New(oSection,"TOTAL"	    			 ,"PED","TOTAL","@E 9,999,999,999.99",)

	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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


		SELECT DT_PRODUCAO,PI,DESCPI,UM,SUM(TOTAL)TOTAL
		FROM(
		SELECT DT_PRODUCAO,PI,DESCPI,UM,SUM(QTD_PEDIDO)*QTD_ESTRUTURA TOTAL
		FROM (
			SELECT DT_PRODUCAO,PA,DESCRIPA,PI,DESCPI,UM,SUM(QTD_PEDIDO)QTD_PEDIDO,QTD_ESTRUTURA
			FROM(
				SELECT CONVERT(VARCHAR,DATEADD (DAY, -%Exp:MV_PAR03%, CAST(PED_DTPROPEL AS DATE)),103) DT_PRODUCAO,
						PED_NUM PEDIDO,PED_PRODUTO PA,PED_DESCRI DESCRIPA,PED_QUANT QTD_PEDIDO,
						G2_PRODUTO [PI],B1_DESC DESCPI,B1_UM UM,G1_QUANT QTD_ESTRUTURA
				FROM PED
				INNER JOIN SG1100 SG1 ON PED_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
				LEFT JOIN SG2100 SG2 ON G1_COMP = G2_PRODUTO AND SG2.D_E_L_E_T_ = ''
				INNER JOIN SB1100 SB1 ON G2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
				WHERE CONVERT(VARCHAR,CAST(PED_DTPREVIA AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
				AND B1_DESC LIKE 'KIT%'
				GROUP BY PED_DTPROPEL,PED_NUM,PED_PRODUTO,PED_DESCRI,G2_PRODUTO,B1_DESC,B1_UM,PED_QUANT,G1_QUANT
				)TB
				GROUP BY DT_PRODUCAO,PA,DESCRIPA,PI,DESCPI,UM,QTD_ESTRUTURA
			)TB1
			GROUP BY DT_PRODUCAO,PI,DESCPI,UM,QTD_ESTRUTURA
		)TB2
	GROUP BY DT_PRODUCAO,PI,DESCPI,UM
	ORDER BY TOTAL DESC


	EndSQL

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return



Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissão:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Até Emissão:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("Periodo:",20)+"?","","","mv_ch3","N",2,0,0,"G","","","","","mv_par03")
	
Return
