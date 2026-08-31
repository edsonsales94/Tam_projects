#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR68    ºAutor  ³Wylliam Silva     				º Data ³  24/03/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Estrutura Unificada PelxAma                              			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR68()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR68"

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

	oReport := TReport():New(cPerg,"Estrutura Unificada PelxAma",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Estrutura Unificada PelxAma",{"SG1"},aOrdem)  

	TRCell():New(oSection,"DT_PRODPEL"		,"PED","DATA PELMEX","@!",8)
	TRCell():New(oSection,"DT_PRODAMA"		,"PED","DATA AMAZON","@!",3) 
	TRCell():New(oSection,"PAPEL"			,"SB1","PA PELMEX","@!",15)   
	TRCell():New(oSection,"DESCPAPEL"		,"SB1","DESC. PAPEL","@!",30)
	TRCell():New(oSection,"PAQTDPEL"  		,"PED","QTD PAPEL","@E 999,999,999.999",)
	TRCell():New(oSection,"PIPEL "			,"SG1","PI PELMEX","@!",15)         
	TRCell():New(oSection,"PIDESCPEL"  		,"SB1","DESC. PI PELMEX","@!",30)
	TRCell():New(oSection,"PIUMPEL"			,"SB1","UM PI PELMEX","@!",8)
	TRCell():New(oSection,"PIQTDPEL"  		,"SG1","QTD PI PELMEX","@E 999,999,999.999",)
	TRCell():New(oSection,"PITOTALPEL"  	,"SG1","QTD PI TTL PEL","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_ESTPEL01"  	,"SB2","QTD ESTPEL01","@E 999,999,999.999",)
	TRCell():New(oSection,"PIAMA"			,"SG1","PI AMAZON","@!",15) 
	TRCell():New(oSection,"PIDESCAMA"		,"SB1","DESC. PI AMAZ","@!",30)
	TRCell():New(oSection,"PIUMAM"			,"SB1","UM PI AMA","@!",8)
	TRCell():New(oSection,"PIQTDAMA"  		,"SG1","QTD PI AMA","@E 999,999,999.999",)
	TRCell():New(oSection,"PITOTALAMA"  	,"SG1","QTD PI TTL AMA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_ESTAMA01"  	,"SB2","QTD ESTAMA01","@E 999,999,999.999",)
	
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

		SELECT DT_PRODPEL,DT_PRODAMA,PAPEL,DESCPAPEL,PAQTDPEL,
		       PIPEL,PIDESCPEL,PIUMPEL,PIQTDPEL,PAQTDPEL*PIQTDPEL PITOTALPEL,ISNULL(SB2.B2_QATU,0) QTD_ESTPEL01,
		       PIAMA,PIDESCAMA,PIUMAMA,PIQTDAMA,(PAQTDPEL*PIQTDPEL)*PIQTDAMA PITOTALAMA,ISNULL(SB21.B2_QATU,0) QTD_ESTAMA01
		FROM(
				SELECT PED_DTPROPEL DT_PRODPEL,PED_DTPROAMA DT_PRODAMA,PED_PRODUTO PAPEL,PED_DESCRI DESCPAPEL,PED_QUANT PAQTDPEL,
				       PIPEL,PIDESCPEL,PIUMPEL,PIQTDPEL,
				       ISNULL(SG12.G1_COMP,'S/C')PIAMA,ISNULL(SB12.B1_DESC,'PRODUTO NA ESTRUTURA PELMEX')PIDESCAMA,ISNULL(SB12.B1_UM,'')PIUMAMA,ISNULL(SG12.G1_QUANT,'')PIQTDAMA
				FROM(
					SELECT PED_DTPROPEL,PED_DTPROAMA,PED_PRODUTO,PED_DESCRI,PED_QUANT,
					       SG1.G1_COMP PIPEL,SB1.B1_DESC PIDESCPEL,SB1.B1_UM PIUMPEL,SG1.G1_QUANT PIQTDPEL
					FROM(
							SELECT PED_DTPROPEL,PED_DTPROAMA,PED_PRODUTO,PED_DESCRI,SUM(PED_QUANT)PED_QUANT
							FROM(
							SELECT PED_DTPROPEL,PED_DTPROAMA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS INT)PED_QUANT
							FROM PED (NOLOCK)
							WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
							GROUP BY PED_DTPROPEL,PED_DTPROAMA,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT
							)TB1
						GROUP BY PED_DTPROPEL,PED_DTPROAMA,PED_PRODUTO,PED_DESCRI
						)TB2
			INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = SG1.G1_COD AND SG1.D_E_L_E_T_ = '' AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
			INNER JOIN SB1100 SB1 (NOLOCK) ON SG1.G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = ''
			GROUP BY PED_DTPROPEL,PED_DTPROAMA,PED_PRODUTO,PED_DESCRI,PED_QUANT,
			         SG1.G1_COMP,SB1.B1_DESC,SB1.B1_UM,SG1.G1_QUANT
			)TB3
			LEFT JOIN SG1200 SG12 (NOLOCK) ON TB3.PIPEL = SG12.G1_COD AND SG12.D_E_L_E_T_ = '' AND SG12.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
			LEFT JOIN SB1200 SB12 (NOLOCK) ON SG12.G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
			WHERE PED_PRODUTO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			AND ISNULL(PIPEL,'') BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
			AND ISNULL(SG12.G1_COMP,'') BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
			)TB4
		LEFT JOIN SB2100 SB2 (NOLOCK) ON PIPEL = SB2.B2_COD AND SB2.B2_FILIAL = '01' AND SB2.B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = ''
		LEFT JOIN SB2200 SB21 (NOLOCK) ON PIAMA = SB21.B2_COD AND SB21.B2_FILIAL = '01' AND SB21.B2_LOCAL = '01' AND SB21.D_E_L_E_T_ = ''
		ORDER BY PAPEL,PIPEL,PIAMA
		
		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De DT Prod PEL:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Até DT Prod PEL:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De PA :",20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Até PA:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De PI PEL :",20)+"?","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Até PI PEL:",20)+"?","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De PI AMA :",20)+"?","","","mv_ch7","C",15,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Até PI AMA:",20)+"?","","","mv_ch8","C",15,0,0,"G","","","","","mv_par08")
	
Return