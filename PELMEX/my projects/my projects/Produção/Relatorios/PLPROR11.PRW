#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR11    ºAutor  ³Wylliam Silva     				º Data ³  25/07/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Relatório Plano de Bloco				  								 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR11()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR11"

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

	oReport := TReport():New(cPerg,"Relatório Plano de Bloco",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Relatório Plano de Bloco",{"SG1"},aOrdem)  
	TRCell():New(oSection,"DT_PRODUCAO" ,"PED","Dt.Producao","@!",15)
	TRCell():New(oSection,"COMP"	      ,"SG1","Codigo","@!",15)
	TRCell():New(oSection,"G1_COMP"	      ,"SG1","Codigo","@!",15)
	TRCell():New(oSection,"DESCRI"	      ,"SB1","Descricao","@!",30)
	TRCell():New(oSection,"UMCOMP"	      ,"SG1","UM","@!",3)
	TRCell():New(oSection,"QTD_PORBLOCO"  ,"SG1","Qtd Estrutura","@E 999,999,999.9999",)
	TRCell():New(oSection,"CONSUMO"	      ,"SG1","Consumo","@E 999,999,999.9999",)
	TRCell():New(oSection,"QTD_BOCO"	  ,"SG1","Qtd.Bloco","@E 999,999,999.9999",)
	TRCell():New(oSection,"M3"	          ,"SG1","M3","@E 999,999,999.9999",) 
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
		SELECT DT_PRODUCAO,COMP,G1_COMP,DESCRI,UMCOMP,CONSUMO,QTD_PORBLOCO,CONSUMO/QTD_PORBLOCO QTD_BOCO,(CONSUMO/QTD_PORBLOCO)*B1_QB M3
FROM(
SELECT DT_PRODUCAO,COMP,G1_COMP,DESCRI,UMCOMP,B1_QB,SUM(CONSUMO)CONSUMO,G1_QUANT QTD_PORBLOCO
FROM(
SELECT PED_DTPROPEL DT_PRODUCAO,QTD_PA,TB2.G1_COMP COMPONENTE,TB2.B1_DESC,TB2.B1_UM,QTD_ESTCOMP,SB13.B1_QB,
       SG12.G1_COMP COMP,SG13.G1_COMP,SB12.B1_DESC DESCRI,SB12.B1_UM UMCOMP,SG13.G1_QUANT,((QTD_ESTCOMP/SB13.B1_QB)*SG13.G1_QUANT)*QTD_PA CONSUMO
FROM(
		SELECT PED_DTPROPEL,G1_TRT,G1_COMP,B1_DESC,B1_UM,G1_QUANT,QTD_PA,G1_QUANT QTD_ESTCOMP,B1_QB
		FROM(
			SELECT PED_DTPROPEL,PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS INT)QTD_PA
			FROM(
				SELECT PED_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_DTPROPEL,PED_NOME,PED_SETOR
				FROM PED (NOLOCK)
				WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			    AND PED_STATUS != 'C'
			    GROUP BY PED_DTPROPEL,PED_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_DTPROPEL,PED_NOME,PED_SETOR
			)TB
		GROUP BY PED_DTPROPEL,PED_PRODUTO,PED_DESCRI
		)TB1
		INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
		INNER JOIN SB1200 SB1 (NOLOCK) ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''
		WHERE (B1_DESC LIKE 'ART%BLO%'
		OR B1_DESC LIKE 'ART%CED%')
		 
		GROUP BY PED_DTPROPEL,G1_TRT,G1_COMP,B1_DESC,B1_UM,G1_QUANT,B1_QB,QTD_PA
)TB2
INNER JOIN SG1200 SG1 (NOLOCK) ON TB2.G1_COMP = SG1.G1_COD AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.G1_COMP NOT LIKE 'MOD%' AND SG1.D_E_L_E_T_ = ''
INNER JOIN SG1200 SG12 (NOLOCK) ON SG1.G1_COMP = SG12.G1_COMP AND SG12.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG12.G1_COMP NOT LIKE 'MOD%' AND SG12.D_E_L_E_T_ = ''
INNER JOIN SG1200 SG13 (NOLOCK) ON SG12.G1_COMP = SG13.G1_COD AND SG13.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG13.G1_COMP NOT LIKE 'MOD%' AND SG13.D_E_L_E_T_ = ''
INNER JOIN SB1200 SB12 (NOLOCK) ON SG13.G1_COMP = SB12.B1_COD AND SB12.D_E_L_E_T_ = ''
INNER JOIN SB1200 SB13 (NOLOCK) ON SG12.G1_COMP = SB13.B1_COD AND SB13.D_E_L_E_T_ = ''
GROUP BY TB2.PED_DTPROPEL,QTD_PA,TB2.G1_COMP,TB2.B1_DESC,TB2.B1_UM,QTD_ESTCOMP,SB13.B1_QB,SG12.G1_COMP,SG13.G1_COMP,SB12.B1_DESC,SB12.B1_UM,SG13.G1_QUANT
)TB3
GROUP BY DT_PRODUCAO,COMP,G1_COMP,DESCRI,UMCOMP,B1_QB,G1_QUANT
)TB4
GROUP BY DT_PRODUCAO,COMP,G1_COMP,DESCRI,UMCOMP,CONSUMO,QTD_PORBLOCO,B1_QB
ORDER BY 2,4
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
