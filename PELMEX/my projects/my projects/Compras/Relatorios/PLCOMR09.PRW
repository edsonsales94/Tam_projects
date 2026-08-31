#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLCOM09   ºAutor  ³Wylliam Silva     		      		º Data ³  09/02/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Protocolo Etiqueta RFID                                 			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLCOM09()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLCOM09"

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

	oReport := TReport():New(cPerg,"Protocolo Etiqueta RFID",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Protocolo Etiqueta RFID",{"PED"},aOrdem)  
	
	TRCell():New(oSection,"PED_NUM"	        ,"PED","Pedido","@!",10)             
	TRCell():New(oSection,"PED_OP"          ,"PED","Ordem Produção","@!",10)
	TRCell():New(oSection,"PED_DTPROPEL"	,"PED","Dt.Produção","@!",15)
	TRCell():New(oSection,"PED_PRODUTO"	    ,"PED","Produto","@!",20)
	TRCell():New(oSection,"PED_DESCRI"	    ,"PED","Descrição","@!",100)
	TRCell():New(oSection,"PED_QUANT"	    ,"PED","Qtd.Pedido","@!",30)
	TRCell():New(oSection,"QTD_ETIQUETA"	,"PED","Qtd.Etiqueta","@!",30)
	TRCell():New(oSection,"DIFERENCA"	    ,"PED","Diferença","@!",30)
	TRCell():New(oSection,"RECEB_ETIQUETA"	,"PED","Usuário Recebimento","@!",30)
	TRCell():New(oSection,"PED_NOME"	    ,"PED","Cliente","@!",30)
	
	
	
	//Totalizador                                                                                  
	TRFunction():New(oSection:Cell("PED_QUANT"),"Total Etiqueta:","SUM",,,"@E 999,999,999,999",,.F.,.T.)

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

SELECT *
FROM(
SELECT 'AMAZON' EMPRESA,
       G1_COMP CODIGO,B1_DESC DESCRICAO,B1_UM UM,
       3 PERIODO_MES,
       SUM(NO_PERIODO)CONSUMO_PERIODO,
       SUM(MEDIA)MEDIA_MES,
       ISNULL(EM_ESTOQUE,0) ESTOQUE_ATUAL,
       CASE WHEN SUM(MEDIA) > 0 THEN EM_ESTOQUE/SUM(MEDIA)
       ELSE 0 END PREVISAO_ESTOQUE_MES,
       PRECO
	   FROM(
		SELECT G1_COD,G1_COMP,SB1.B1_DESC,SB1.B1_UM,
		       SUM(D2_QUANT)D2_QUANT,
		        G1_QUANT,
		       SUM(D2_QUANT)*G1_QUANT NO_PERIODO,
		       (SUM(D2_QUANT)*G1_QUANT)/3 MEDIA,
		       B2_QATU-B2_RESERVA EM_ESTOQUE,
		       SB1.B1_UPRC PRECO
FROM SG1200 SG1 (NOLOCK)
INNER JOIN SD2200 SD2 (NOLOCK) ON G1_COD = D2_COD AND SD2.D_E_L_E_T_ = '' 
LEFT JOIN SD1200 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
INNER JOIN SB2200 SB2 (NOLOCK) ON G1_COMP = SB2.B2_COD AND B2_FILIAL = '01' AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = '' 
INNER JOIN SB1200 SB1 (NOLOCK) ON G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' 
LEFT JOIN PROTHEUS_REPOSIT (NOLOCK) ON B1_BITMAP = BMPNAME AND PROTHEUS_REPOSIT.D_E_L_E_T_ = '' AND SEQ = '01' 
WHERE SG1.D_E_L_E_T_ = '' 
AND B1_MSBLQL != '1' 
AND D1_DOC IS NULL
AND G1_FIM > CONVERT(VARCHAR,GETDATE(),112) 
AND D2_EMISSAO BETWEEN CONVERT(VARCHAR,DATEADD (m, -3, GETDATE ()),112) AND CONVERT(VARCHAR,GETDATE(),112)
GROUP BY G1_COD,G1_COMP,SB1.B1_DESC,SB1.B1_UM,G1_QUANT,B2_QATU,B2_RESERVA,B1_UPRC
UNION
SELECT G1_COD,G1_COMP,B1_DESC,B1_UM,0 D2_QUANT,G1_QUANT,0 NO_PERIODO,0 MEDIA,B2_QATU-B2_RESERVA EM_ESTOQUE,B1_UPRC
FROM SB1200 SB1 (NOLOCK)
INNER JOIN SG1200 SG1 (NOLOCK) ON B1_COD = G1_COMP AND SG1.D_E_L_E_T_ = '' 
LEFT JOIN PROTHEUS_REPOSIT (NOLOCK) ON B1_BITMAP = BMPNAME AND PROTHEUS_REPOSIT.D_E_L_E_T_ = '' AND SEQ = '01' 
LEFT JOIN SB2200 SB2 (NOLOCK) ON B1_COD = B2_COD AND B2_FILIAL = '01' AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = '' 
WHERE SB1.D_E_L_E_T_ = '' 
AND B1_MSBLQL != '1'
AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
GROUP BY G1_COD,G1_COMP,B1_DESC,B1_UM,G1_QUANT,B2_QATU,B2_RESERVA,B1_UPRC
)TB
WHERE ISNULL(EM_ESTOQUE,0) > 0
GROUP BY G1_COMP,B1_DESC,B1_UM,EM_ESTOQUE,PRECO
UNION
SELECT 'PELMEX' EMPRESA,
       G1_COMP CODIGO,B1_DESC DESCRICAO,B1_UM UM,
     3 PERIODO_MES,
       SUM(NO_PERIODO)CONSUMO_PERIODO,
       SUM(MEDIA)MEDIA_MES,
       ISNULL(EM_ESTOQUE,0) ESTOQUE_ATUAL,
       CASE WHEN SUM(MEDIA) > 0 THEN EM_ESTOQUE/SUM(MEDIA)
       ELSE 0 END PREVISAO_ESTOQUE_MES,
       PRECO
FROM(
SELECT G1_COD,G1_COMP,SB1.B1_DESC,SB1.B1_UM,
       SUM(D2_QUANT)D2_QUANT,
        G1_QUANT,
       SUM(D2_QUANT)*G1_QUANT NO_PERIODO,
       (SUM(D2_QUANT)*G1_QUANT)/3 MEDIA,
       B2_QATU-B2_RESERVA EM_ESTOQUE,
       SB1.B1_UPRC PRECO
FROM SG1100 SG1 (NOLOCK)
INNER JOIN SD2100 SD2 (NOLOCK) ON G1_COD = D2_COD AND SD2.D_E_L_E_T_ = '' 
LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
INNER JOIN SB2100 SB2 (NOLOCK) ON G1_COMP = SB2.B2_COD AND B2_FILIAL = '01' AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = '' 
INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' 
LEFT JOIN PROTHEUS_REPOSIT (NOLOCK) ON B1_BITMAP = BMPNAME AND PROTHEUS_REPOSIT.D_E_L_E_T_ = '' AND SEQ = '01' 
WHERE SG1.D_E_L_E_T_ = '' 
AND B1_MSBLQL != '1' 
AND D1_DOC IS NULL
AND G1_COMP NOT LIKE '050%'
AND G1_COMP NOT LIKE 'SUP%'
AND G1_FIM > CONVERT(VARCHAR,GETDATE(),112) 
AND D2_EMISSAO BETWEEN CONVERT(VARCHAR,DATEADD (m, -3, GETDATE ()),112) AND CONVERT(VARCHAR,GETDATE(),112)
GROUP BY G1_COD,G1_COMP,SB1.B1_DESC,SB1.B1_UM,G1_QUANT,B2_QATU,B2_RESERVA,B1_UPRC
UNION
SELECT G1_COD,G1_COMP,B1_DESC,B1_UM,0 D2_QUANT,G1_QUANT,0 NO_PERIODO,0 MEDIA,B2_QATU-B2_RESERVA EM_ESTOQUE,B1_UPRC
FROM SB1100 SB1 (NOLOCK)
INNER JOIN SG1100 SG1 (NOLOCK) ON B1_COD = G1_COMP AND SG1.D_E_L_E_T_ = '' 
LEFT JOIN PROTHEUS_REPOSIT (NOLOCK) ON B1_BITMAP = BMPNAME AND PROTHEUS_REPOSIT.D_E_L_E_T_ = '' AND SEQ = '01'
LEFT JOIN SB2100 SB2 (NOLOCK) ON B1_COD = B2_COD AND B2_FILIAL = '01' AND B2_LOCAL = '01' AND SB2.D_E_L_E_T_ = '' 
WHERE SB1.D_E_L_E_T_ = '' 
AND B1_MSBLQL != '1'
AND G1_COMP NOT LIKE '050%'
AND G1_COMP NOT LIKE 'SUP%'
AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112)
GROUP BY G1_COD,G1_COMP,B1_DESC,B1_UM,G1_QUANT,B2_QATU,B2_RESERVA,B1_UPRC
)TB
GROUP BY G1_COMP,B1_DESC,B1_UM,EM_ESTOQUE,PRECO
)TB1
WHERE (TB1.CONSUMO_PERIODO > 0
OR TB1.ESTOQUE_ATUAL > 0)
ORDER BY 1,8 DESC



	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt.Produção:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt.Produtoção:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	
Return