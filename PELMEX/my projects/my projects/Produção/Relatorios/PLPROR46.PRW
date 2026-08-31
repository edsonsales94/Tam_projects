#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR46   ºAutor  ³Juevan Silva     				º Data ³ 15/05/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Pickilist X Almoxarifado                      			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR46()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR46"

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

	oReport := TReport():New(cPerg,"Pickilist X Almoxarifado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Pickilist X Almoxarifado",{"PED"},aOrdem) 

    TRCell():New(oSection,"DT_PRODUCAO"   	        ,"PED","DT_PRODUCAO","@!",10)
    TRCell():New(oSection,"CODIGO"	           ,"PED","CODIGO","@!",20)
    TRCell():New(oSection,"DESCRICAO"	        ,"PED","DESCRICAO","@!",30)
    TRCell():New(oSection,"UNIDADE"	        ,"SC6","UNIDADE","@!",03)
    TRCell():New(oSection,"QTD_NECESSARIA"	        ,"PED","QTD_NECESSARIA","@E 999,999,999.999",)
    TRCell():New(oSection,"QTD_EMPENHO"		    ,"PED","QTD_EMPENHO","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_10"		    ,"PED","QTD_10","@E 999,999,999.999",)
    TRCell():New(oSection,"QTD_01"		    ,"PED","QTD_01","@E 999,999,999.999",)
    TRCell():New(oSection,"QTD_MOV"		    ,"PED","QTD_MOV","@E 999,999,999.999",)
    TRCell():New(oSection,"QTD_PENDENTE"		    ,"PED","QTD_PENDENTE","@E 999,999,999.999",)

    //TRCell():New(oSection,"C6_NUM"		     ,"SC6","C6_NUM","@!",7)

	
    
	
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

SELECT DT_PRODUCAO,CODIGO,DESCRICAO,UNIDADE, QTD_NECESSARIA,QTD_EMPENHO,QTD_10,QTD_01,ISNULL(QTD_MOV,0)QTD_MOV,ISNULL(QTD_MOV,0)-QTD_EMPENHO QTD_PENDENTE
FROM(
SELECT TB.PK2_DTPROPEL DT_PRODUCAO,TB.G1_COMP CODIGO,TB.B1_DESC DESCRICAO,TB.B1_UM UNIDADE,SUM(QTD_NECESSARIA)QTD_NECESSARIA,
        SUM(ISNULL(QTD_EMPENHO,0))QTD_EMPENHO,
    ISNULL(QTD_10,0)QTD_10,
    ISNULL(QTD_01,0)QTD_01 
FROM( 
    SELECT PK2_DTPROPEL,PK2_PRODUTO,PK2_DESCRI,G1_COMP,SB1.B1_DESC,SB1.B1_UM,PK2_QUANT, 
           G1_QUANT,PK2_QUANT*(G1_QUANT+G1_QUANT*G1_PERDA/100) QTD_NECESSARIA ,QTD_EMPENHO
    FROM PK2 (NOLOCK)
    INNER JOIN SG1100 SG1 (NOLOCK) ON PK2_PRODUTO = G1_COD AND SG1.D_E_L_E_T_ = '' AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) 
    INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = B1_COD AND SB1.D_E_L_E_T_ = '' AND B1_XFANTAS != 'S'
    LEFT JOIN (  SELECT SUBSTRING(D4_OP,1,6)D4_OP,D4_TRT,D4_COD,SUM(D4_QTDEORI) QTD_EMPENHO
           FROM SD4100 SD4 (NOLOCK)
           WHERE SD4.D_E_L_E_T_ = ''
           AND D4_COD NOT LIKE 'MOD%'
           GROUP BY SUBSTRING(D4_OP,1,6),D4_TRT,D4_COD 
           )SD4 ON G1_TRT = D4_TRT AND G1_COMP = D4_COD AND PK2_OP = D4_OP  
    WHERE G1_COMP NOT LIKE 'MOD%' 
    AND CONVERT(VARCHAR,CAST(PK2_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB
LEFT JOIN (SELECT B2_FILIAL,B2_COD,B2_QATU QTD_10,B2_LOCAL
           FROM SB2100 SB2 (NOLOCK)
       WHERE SB2.D_E_L_E_T_ = ''
       AND B2_FILIAL = '01'
         AND B2_LOCAL = '10')SB210 ON G1_COMP = SB210.B2_COD
LEFT JOIN (SELECT B2_FILIAL,B2_COD,B2_QATU QTD_01,B2_LOCAL
           FROM SB2100 SB2 (NOLOCK)
           WHERE SB2.D_E_L_E_T_ = ''
         AND B2_FILIAL = '01'
        AND B2_LOCAL = '01')SB201 ON G1_COMP = SB201.B2_COD 
GROUP BY TB.PK2_DTPROPEL,TB.G1_COMP,TB.B1_DESC,TB.B1_UM,QTD_10,QTD_01
)TB2
LEFT JOIN ( SELECT D3_COD,B1_DESC,B1_UM,SUM(D3_QUANT)QTD_MOV
      FROM(
      SELECT 'PELMEX' EMPRESA,D3_DOC,D3_COD,B1_DESC,B1_UM,D3_QUANT,D3_LOCAL
      FROM SD3100 SD3 (NOLOCK)
      INNER JOIN SB1100 SB1 (NOLOCK) ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
      WHERE SD3.D_E_L_E_T_ = ''
      AND D3_COD BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
      AND D3_DOC IN (
              SELECT D3_DOC
              FROM SD3100 SD3
              WHERE SD3.D_E_L_E_T_ = ''
              AND CONVERT(VARCHAR,CAST(RTRIM(D3_OBSERVA) AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
      )
      )TB
      GROUP BY D3_COD,B1_DESC,B1_UM)SD3 ON CODIGO = D3_COD
WHERE CODIGO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
ORDER BY 1,DESCRICAO








		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Cod:" ,20)+"?","","","mv_ch3","C",20,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Cod:",20)+"?","","","mv_ch4","C",20,0,0,"G","","","","","mv_par04")
	