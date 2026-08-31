#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR58  ºAutor  ³Kledson Oliveira    				º Data ³  28/12/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   REL. TECIDOS INGRID                    			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR58()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR58"

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

	oReport := TReport():New(cPerg,"REL. TECIDOS INGRID",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"REL. TECIDOS INGRID",{"SD4"},aOrdem) 

    TRCell():New(oSection,"PA"   	    ,"PED","Codigo PA","@!",20)
	TRCell():New(oSection,"DESCRIPA"		    ,"PED","Desc PA","@!",60)
	TRCell():New(oSection,"COMPONENTE"		        ,"SG1","Componente","@!",20)
    TRCell():New(oSection,"DESCRICAO"		,"SB1","Desc Comp","@!",60)
	TRCell():New(oSection,"UM"		    ,"SB1","UM","@!",4)
	TRCell():New(oSection,"QTD_EMPENHADA"		    ,"SD4","Qtd. Empenhada","@E 999,999,999.999",20)
	TRCell():New(oSection,"PERIODO"		,"SD4","Periodo","@!",11)
	TRCell():New(oSection,"MEDIA"		,"SD4","Diferenca","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_AMAZON01"		  ,"SB2","Qtd. Amazon","@E 999,999,999.999",)		
	TRCell():New(oSection,"CLIENTE"     	,"PED","Cliente","@!",30) 
    //TRCell():New(oSection,"R8_TIPOAFA"	      ,"SR8","R8_TIPOAFA","@!",4) 
	//TRCell():New(oSection,"DESCRICAO"  	     ,"SRA","DESCRICAO","@!",40)
	//TRCell():New(oSection,"R8_CID"		 ,"SR8","R8_CID","@!",3)
	//TRCell():New(oSection,"DIAS"  			,"SRA","DIAS","@!",3)
    //TRCell():New(oSection,"R8_OBSAFAS"  	,"SR8","R8_OBSAFAS","@!",100)

	
    
	
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

SELECT PED_PRODUTO PA,PED_DESCRI DESCRIPA,TB.G1_COMP COMPONENTE, TB.B1_DESC DESCRICAO, TB.B1_UM UM,SUM(D4_QTDEORI)QTD_EMPENHADA,
       DATEDIFF(MONTH,'20241001','20241231')+1 PERIODO,
     SUM(D4_QTDEORI)/(DATEDIFF(MONTH,'20241001','20241231')+1) MEDIA,
     ISNULL(QTD_AMAZON01,0)QTD_AMAZON01,PED_NOME CLIENTE
FROM(
SELECT PED_NUM,C2_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,PED_TOTAL,PED_NOME,PED_MUN,
       G1_COMP, SB1.B1_DESC B1_DESC ,SB1.B1_UM B1_UM,G1_QUANT,G1_PERDA,D4_QTDEORI
FROM PED (NOLOCK)
INNER JOIN SC2100 SC2 (NOLOCK) ON PED_OP = C2_NUM AND PED_PRODUTO = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = '' AND SG1.G1_COMP NOT LIKE 'MOD%'
INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = SB1.B1_COD AND SB1.B1_MSBLQL != '1' AND SB1.D_E_L_E_T_ = ''
INNER JOIN SD4100 SD4 (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND G1_COD = D4_PRODUTO AND G1_COMP = D4_COD AND G1_TRT = D4_TRT AND SD4.D_E_L_E_T_ = ''
WHERE PED_STATUS != 'C'
AND SB1.B1_DESC LIKE '%TEC%'
AND D4_DATA BETWEEN '20241001' AND '20241231'
AND D4_PRODUTO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
AND D4_COD BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
AND PED_CLIENTE BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
)TB
LEFT JOIN SG1200 SG12 (NOLOCK) ON TB.G1_COMP = SG12.G1_COD AND SG12.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG12.D_E_L_E_T_ = '' AND SG12.G1_COMP NOT LIKE 'MOD%'
LEFT JOIN (SELECT B2_COD,B2_LOCAL,B2_QATU QTD_AMAZON01
           FROM SB2200 SB2 (NOLOCK) 
       WHERE SB2.D_E_L_E_T_ = ''
       AND B2_FILIAL = '01' 
       AND B2_LOCAL = '01'
       GROUP BY B2_COD,B2_LOCAL,B2_QATU)SB2 ON SG12.G1_COMP = B2_COD 
INNER JOIN (
    SELECT B1_COD, B1_DESC, B1_MSBLQL, B1_TIPO
    FROM SB1100 SB11 
    WHERE SB11.D_E_L_E_T_ = ''
    AND B1_MSBLQL = '2'
    AND B1_TIPO = 'PA'
    AND (B1_DESC LIKE 'COL%' OR B1_DESC LIKE 'CAM%')
 ) SB11 ON PED_PRODUTO = SB11.B1_COD AND PED_DESCRI = SB11.B1_DESC
WHERE QTD_AMAZON01 IS NOT NULL
GROUP BY PED_PRODUTO,PED_DESCRI,TB.G1_COMP, TB.B1_DESC, TB.B1_UM,PED_NOME,QTD_AMAZON01
ORDER BY TB.B1_DESC,PED_DESCRI,PED_NOME


		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

    u_InPutSX1(cPerg,"01",PADR("De PA:" ,20)+"?","","","mv_ch1","C",20,0,0,"G","","SB1","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate PA:",20)+"?","","","mv_ch2","C",20,0,0,"G","","SB1","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Componente:",20)+"?","","","mv_ch3","C",20,0,0,"G","","","","","mv_par03")
	u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",20,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Cliente:",20)+"?","","","mv_ch5","C",6,0,0,"G","","SA1","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Ate Cliente:",20)+"?","","","mv_ch6","C",6,0,0,"G","","SA1","","","mv_par06")
	

	//u_InPutSX1(cPerg,"03",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par04")
	
	
	
	
Return
