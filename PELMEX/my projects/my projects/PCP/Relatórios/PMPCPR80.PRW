#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR79    ºAutor  ³Wylliam Silva     				º Data ³  29/05/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Plano de Corte Laminas	 			                 		  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR80()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR80"

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

	oReport := TReport():New(cPerg,"SITUACAO DO PEDIDO",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"SITUACAO DO PEDIDO",{"PED"},aOrdem)  
	


	TRCell():New(oSection,"DT_EMISSAO"    		,"SC5","DTEMISSAO","@!",10)
	TRCell():New(oSection,"DT_ENTREGA"      	,"SC5","DTENTREGA","@!",10)
	TRCell():New(oSection,"FILIAL"	  			,"SC6","FILIAL","@!",3)
	TRCell():New(oSection,"PEDIDO"	  			,"SC6","PEDIDO","@!",8)
	TRCell():New(oSection,"OP"	  				,"PED","OP","@!",10)
	TRCell():New(oSection,"DT_PROGRAMACAO"		,"PED","DT_PROGRAMACAO","@!",10)
	TRCell():New(oSection,"DT_NOTA"				,"SD2","DT NOTA","@!",10)
	TRCell():New(oSection,"NOTA"				,"SD2","NOTA","@!",10)
	TRCell():New(oSection,"ITEM"				,"SC6","ITEM","@!",4)
	TRCell():New(oSection,"PRODUTO"				,"SC6","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"			,"SC6","DESCRICAO","@!",30)
	TRCell():New(oSection,"ARMZ"				,"SC6","ARMZ","@!",3)
	TRCell():New(oSection,"QTD_PEDIDO"			,"SC6","QTD_PEDIDO","@E 999,999,999",)
	TRCell():New(oSection,"QTD_PROGRAMADA"		,"PED","QTD_PROGRAMADA","@E 999,999,999",)
	TRCell():New(oSection,"QTD_PRODUZIDA"		,"PED","QTD_PRODUZIDA","@E 999,999,999",)
	TRCell():New(oSection,"QTD_ENTRADA"			,"SZ1","QTD_ENTRADA","@E 999,999,999",)
	TRCell():New(oSection,"QTD_NOTA"			,"SD2","QTD_NOTA","@E 999,999,999",)
	TRCell():New(oSection,"QTD_SAIDA"			,"SAI","QTD_SAIDA","@E 999,999,999",)
	TRCell():New(oSection,"DT_EXPDICAO"			,"SAI","DT_EXPDICAO","@!",10)
	TRCell():New(oSection,"VALOR_PEDIDO"		,"SC6","VALOR_PEDIDO","@E 999,999,999",)
	TRCell():New(oSection,"VALOR_PROGRAMADO"	,"SC6","VALOR_PROGRAMADO","@E 999,999,999",)
	TRCell():New(oSection,"TOTAL_EXPEDIDO"		,"SC6","TOTAL_EXPEDIDO","@E 999,999,999",)
	TRCell():New(oSection,"COD_CLI"				,"SA1","COD_CLI","@!",10)
	TRCell():New(oSection,"CLIENTE"				,"SA1","CLIENTE","@!",35)
	TRCell():New(oSection,"FANTASIA"			,"SA1","FANTASIA","@!",15)
	TRCell():New(oSection,"SETOR"				,"SB1","SETOR","@!",25)
	TRCell():New(oSection,"MUNICIPIO"			,"SB1","MUNICIPIO","@!",25)	
	TRCell():New(oSection,"OBSERVA"				,"SC5","OBSERVA","@!",50)

	
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
		
SELECT CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_EMISSAO,
       CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),103)DT_ENTREGA,
     C6_FILIAL FILIAL,C6_NUM PEDIDO,ISNULL(PED_OP,'') OP,ISNULL(PED_DTPROPEL,'') DT_PROGRAMACAO,
     ISNULL(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),'')DT_NOTA,ISNULL(D2_DOC,'') NOTA,
     C6_ITEM ITEM,C6_PRODUTO PRODUTO,C6_DESCRI DESCRICAO,C6_LOCAL ARMZ,C6_QTDVEN QTD_PEDIDO,ISNULL(QTD_PROGRAMADA,0)QTD_PROGRAMADA,
     CAST(ISNULL(CASE WHEN B1_XSETOR LIKE 'CAMA%' THEN QTD_CAMA ELSE QTD_COLCHAO END,0) AS FLOAT)QTD_PRODUZIDA,CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)QTD_ENTRADA, 
     ISNULL(D2_QUANT,0) QTD_NOTA,ISNULL(QTD_SAIDA,0)QTD_SAIDA,ISNULL(DT_EXPEDICAO,'')DT_EXPDICAO,
     (C6_QTDVEN)*C6_PRCVEN VALOR_PEDIDO,ISNULL(QTD_PROGRAMADA,0)*C6_PRCVEN VALOR_PROGRAMADO,ISNULL(QTD_SAIDA,0)*C6_PRCVEN TOTAL_EXPEDIDO,
     A1_COD COD_CLI,A1_NOME CLIENTE,A1_NREDUZ FANTASIA,B1_XSETOR SETOR,A1_MUN MUNICIPIO ,(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT)OBSERVA
	FROM SC6100 SC6 (NOLOCK)
	INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
	INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
	INNER JOIN SC5100 SC5 (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
	LEFT JOIN (SELECT PED_FILIAL,PED_NUM,PED_DTPROPEL,PED_OP,PED_ITEM,PED_PRODUTO,CAST(PED_QUANT AS FLOAT) QTD_PROGRAMADA
           FROM PED (NOLOCK)
       WHERE PED_OP != ''
       AND PED_STATUS != 'C'
       GROUP BY PED_FILIAL,PED_NUM,PED_DTPROPEL,PED_OP,PED_ITEM,PED_PRODUTO,PED_QUANT)PED ON C6_FILIAL = PED_FILIAL AND C6_NUM = PED_NUM AND C6_ITEM = PED_ITEM AND C6_PRODUTO = PED_PRODUTO
LEFT JOIN (SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_EMISSAO,D2_ITEM,D2_ITEMPV,D2_COD,D2_QUANT,D2_PEDIDO,D2_LOCAL,D2_CLIENTE
           FROM SD2100 SD2 (NOLOCK)
       LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD
       WHERE SD2.D_E_L_E_T_ = ''
       AND D1_DOC IS NULL
       AND D2_FILIAL = '01')SD2 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND D2_COD = C6_PRODUTO
LEFT JOIN (SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO,SUM(SAI_QUANT)QTD_SAIDA,MAX(SAI_DTEXP)DT_EXPEDICAO
           FROM SAI (NOLOCK)
       GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO)SAI ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND D2_ITEM = SAI_ITEM AND D2_COD = SAI_PRODUTO
LEFT JOIN (SELECT CLB_FILIAL,SUBSTRING(CLB_OP,1,6)CLB_OP,CLB_COD,SUM(QTD_CAMA)QTD_CAMA
           FROM(
           SELECT CLB_FILIAL,SUBSTRING(CLB_CPRODUC,1,8)CLB_OP,CLB_COD,
                  CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END QTD_CAMA
           FROM CLB (NOLOCK)
       INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
       GROUP BY CLB_FILIAL,SUBSTRING(CLB_CPRODUC,1,8),CLB_COD,B1_XJUNCAO
       )TB
       GROUP BY CLB_FILIAL,SUBSTRING(CLB_OP,1,6),CLB_COD)CLB ON PED_OP = CLB_OP AND PED_PRODUTO = CLB_COD
LEFT JOIN (SELECT CLA_FILIAL,SUBSTRING(CLA_CPRODUC,1,6)CLA_OP,CLA_COD,SUM(CLA_QUANT)QTD_COLCHAO
           FROM CLA (NOLOCK)
       GROUP BY CLA_FILIAL,SUBSTRING(CLA_CPRODUC,1,6),CLA_COD)CLA ON PED_FILIAL = CLA_FILIAL AND PED_OP = CLA_OP AND PED_PRODUTO = CLA_COD
LEFT JOIN (SELECT Z1_OP,C2_PRODUTO,SUM(QTD_ENTRADA)QTD_ENTRADA
           FROM(
           SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,C2_PRODUTO,
                  CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END QTD_ENTRADA
           FROM SZ1100 SZ1 (NOLOCK)
       INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
       INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
       WHERE SZ1.D_E_L_E_T_ = ''
       )TB
       GROUP BY Z1_OP,C2_PRODUTO)SZ1 ON PED_OP = Z1_OP AND PED_PRODUTO = C2_PRODUTO 
WHERE SC6.D_E_L_E_T_ = ''
AND C6_QTDVEN > C6_QTDENT
AND C6_TES NOT IN ('709','915','916','917')
AND C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C5_CLIENTE BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NÃO PRODUZIR%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%'
ORDER BY C5_EMISSAO,C6_ENTREG,C6_NUM,C6_ITEM

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De DT Emissao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate DT Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Cliente:",20)+"?","","","mv_ch3","C",8,0,0,"G","","SA1","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Cliente:",20)+"?","","","mv_ch4","C",8,0,0,"G","","SA1","","","mv_par04")
	
Return
