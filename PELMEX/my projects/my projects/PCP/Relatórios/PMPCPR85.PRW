#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR85    ºAutor  ³Juevan Silva     				º Data ³  27/10/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Montagem Kit Colagem	 			                 		  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR85()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR85"

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

	oReport := TReport():New(cPerg,"Montagem Kit Colagem",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Montagem Kit Colagem",{"PED"},aOrdem)  


	TRCell():New(oSection,"SETOR"    	,"PED","SETOR","@!",20)
	TRCell():New(oSection,"PRODUTO"    	,"PED","PRODUTO","@!",30)
	TRCell():New(oSection,"DESCRICAO"    		,"PED","DESC","@!",40)
	TRCell():New(oSection,"DENSIDADE"   			,"SB1","DENSIDADE","@!",20)
	TRCell():New(oSection,"DIMENSAO"			,"SG1","DIMENSAO","@!",20)
	TRCell():New(oSection,"TOTAL"    	,"PED","TOTAL","@E 999,999,999,999",) 
	//TRCell():New(oSection,"DESCRICAO"		,"SC6","Descrição","@!",100)
	//TRCell():New(oSection,"ARMAZEM"			,"SC6","Armazem","@!",10)
	//TRCell():New(oSection,"QTD_PEDIDO"		,"SC6","Qtd. Pedido","@E 999,999,999",)
	//TRCell():New(oSection,"QTD_ATENDIDA"	,"SC6","Qtd. Atendida","@E 999,999,999",)
	//TRCell():New(oSection,"TOTAL"			,"SC6","Total","@E 999,999,999",)
	//TRCell():New(oSection,"SETOR"			,"SB1","Setor","@!",50)
	//TRCell():New(oSection,"CLIENTE"			,"SA1","Cliente","@!",10)
	//TRCell():New(oSection,"NOME"			,"SA1","Nome","@!",70)
	//TRCell():New(oSection,"NFANT"			,"SA1","NFant","@!",70)
	//TRCell():New(oSection,"ESTADO"			,"SA1","Estado","@!",5)
	//TRCell():New(oSection,"MUNICIPIO"		,"SA1","Municipio","@!",50)	
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

SELECT PED_SETOR SETOR,PED_PRODUTO PRODUTO,PED_DESCRI DESCRICAO,B1_XSETOR DENSIDADE,REPLACE(REPLACE(G1_XDIMENS,CHAR(10),''),CHAR(13),'')DIMENSAO,SUM(TOTAL)TOTAL
FROM(
SELECT PED_PRODUTO,PED_DESCRI,CAST(SUM(PED_QUANT) AS INT)TOTAL,PED_SETOR
FROM(
        SELECT PED_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_DTPROPEL,PED_NOME,PED_SETOR
        FROM PED (NOLOCK)
        WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
        AND PED_STATUS != 'C'
        GROUP BY PED_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,PED_QUANT,PED_DTPROPEL,PED_NOME,PED_SETOR
        )TB
        GROUP BY PED_PRODUTO,PED_DESCRI,PED_SETOR
        )TB1
LEFT JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = ''
WHERE B1_DESC LIKE 'BL%'
GROUP BY PED_PRODUTO,PED_DESCRI,G1_TRT,G1_COMP,B1_XSETOR,REPLACE(REPLACE(G1_XDIMENS,CHAR(10),''),CHAR(13),''),PED_SETOR
ORDER BY PED_SETOR,PED_DESCRI,DIMENSAO
	
	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt.Emissão:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt.Emissão:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Dt.Entrega:",20)+"?","","","mv_ch3","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Dt.Entrega:",20)+"?","","","mv_ch4","D",10,0,0,"G","","","","","mv_par04")
	
Return
