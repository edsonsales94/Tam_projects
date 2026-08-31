#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR86   ºAutor  ³Juevan Silva     				º Data ³  31/10/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Modelo de Estrutura Completa                        			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR88()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR88"

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

	oReport := TReport():New(cPerg,"DIF. APONTAMENTO X PRODUZIDO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"DIF. APONTAMENTO X PRODUZIDO",{"SC2"},aOrdem) 

 
    TRCell():New(oSection,"DT_OP"   	    ,"SC2","DT OP","@!",10)
	TRCell():New(oSection,"OP"		        ,"SC2","OP","@!",8)
	TRCell():New(oSection,"PRODUTO"		    ,"SC2","PRODUTO","@!",15) 
	TRCell():New(oSection,"DESCRICAO"	    ,"SB1","DESCRICAO","@!",30)   
	TRCell():New(oSection,"QTD_OP"	        ,"SC2","QTDE OP","@E 999,999,999,999.99",)
	TRCell():New(oSection,"QTD_APONTADA"    ,"SC2","QTDE APONTADA","@E 999,999,999,999.99",)
	TRCell():New(oSection,"PENDENTE"	    ,"SC2","PENDENTE","@E 999,999,999,999.99",)      
	TRCell():New(oSection,"QTD_PRODUZIDA"  	,"CLA","QTD_PRODUZIDA","@E 999,999,999,999.99",)
	TRCell():New(oSection,"QTD_ENTRADA"	    ,"SZ1","QTD_ENTRADA","@E 999,999,999.999.99",)
	TRCell():New(oSection,"QTD_SAIDA"       ,"SAI","QTD_SAIDA","@E 999,999,999.999.99",)
	TRCell():New(oSection,"CARGA" 	        ,"SC2","CARGA","@!",15) 
	TRCell():New(oSection,"CLIENTE"	        ,"SC2","CLIENTE","@!",30) 
	TRCell():New(oSection,"SETOR"  			,"SB1","SETOR","@!",12)
	 
	
    
	
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

SELECT CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_OP,C2_NUM+C2_ITEM+C2_SEQUEN OP,SC2.C2_PRODUTO PRODUTO,
        B1_DESC DESCRICAO,C2_QUANT QTD_OP,
        C2_QUJE QTD_APONTADA,C2_QUANT-C2_QUJE PENDENTE,
        ISNULL(CASE WHEN B1_XSETOR LIKE 'CAM%' THEN QTD_CAMA
                   WHEN B1_XSETOR LIKE 'COL%' THEN QTD_COLCHAO
                   ELSE QTD_ENTRADA END,0) QTD_PRODUZIDA,
        ISNULL(QTD_ENTRADA,0)QTD_ENTRADA,
        ISNULL(QTD_SAIDA,0)QTD_SAIDA,
        C2_XCARGA CARGA,C2_OBS CLIENTE,B1_XSETOR SETOR
FROM SC2100 SC2 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT Z1_OP,C2_PRODUTO,CAST(SUM(Z1_QUANT) AS FLOAT)QTD_ENTRADA
           FROM(
           SELECT Z1_OP,C2_PRODUTO,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
           FROM SZ1100 SZ1 (NOLOCK)
       INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
       INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
       WHERE SZ1.D_E_L_E_T_ = ''
       )TB
       GROUP BY Z1_OP,C2_PRODUTO)SZ1 ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SZ1.C2_PRODUTO = SC2.C2_PRODUTO 
LEFT JOIN (SELECT SUBSTRING(CLA_CPRODUC,1,11)CLA_OP,CLA_COD,CAST(SUM(CLA_QUANT) AS FLOAT)QTD_COLCHAO
           FROM(
           SELECT CLA_CPRODUC,CLA_COD,CLA_QUANT
           FROM CLA (NOLOCK)
            INNER JOIN SB1100 SB1 (NOLOCK) ON CLA_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
            WHERE B1_XSETOR LIKE 'COL%'
            )TB
       GROUP BY SUBSTRING(CLA_CPRODUC,1,11),CLA_COD)CLA ON C2_NUM+C2_ITEM+C2_SEQUEN = CLA_OP AND SC2.C2_PRODUTO = CLA_COD
LEFT JOIN (SELECT SUBSTRING(CLB_CPRODUC,1,11)CLB_OP,CLB_COD,CAST(SUM(CLB_QUANT) AS FLOAT)QTD_CAMA
           FROM(
           SELECT CLB_CPRODUC,CLB_COD,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END CLB_QUANT
           FROM CLB (NOLOCK)
       INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
       WHERE B1_XSETOR LIKE 'CAM%'
       )TB
       GROUP BY SUBSTRING(CLB_CPRODUC,1,11),CLB_COD)CLB ON C2_NUM+C2_ITEM+C2_SEQUEN = CLB_OP AND SC2.C2_PRODUTO = CLB_COD
LEFT JOIN (SELECT SUBSTRING(SAI_CPRODUC,1,11)SAI_OP,SAI_PRODUTO,CAST(SUM(SAI_QUANT) AS FLOAT)QTD_SAIDA
           FROM(
           SELECT SAI_CPRODUC,SAI_PRODUTO,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END SAI_QUANT
           FROM SAI (NOLOCK)
            INNER JOIN SB1100 SB1 (NOLOCK) ON SAI_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
            //WHERE B1_XSETOR LIKE 'CAM%'
            )TB
       GROUP BY SUBSTRING(SAI_CPRODUC,1,11),SAI_PRODUTO)SAI ON C2_NUM+C2_ITEM+C2_SEQUEN = SAI_OP AND SC2.C2_PRODUTO = SAI_PRODUTO
WHERE SC2.D_E_L_E_T_ = ''
AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
AND B1_TIPO IN ('PA','PC')
AND C2_QUANT > C2_QUJE
//GROUP BY C2_EMISSAO,B1_XSETOR
ORDER BY C2_EMISSAO,B1_XSETOR,C2_NUM

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De DTOP:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate DTOP:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
