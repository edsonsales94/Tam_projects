#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR59  ºAutor  ³Kledson Oliveira    				º Data ³  28/12/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   REL. CONSUMO DE TECIDOS GERAL                    			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR59()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR59"

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

	oReport := TReport():New(cPerg,"REL. CONSUMO DE TECIDOS GERAL",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"REL. CONSUMO DE TECIDOS GERAL",{"SD4"},aOrdem) 

    //TRCell():New(oSection,"PA"   	    ,"PED","Codigo PA","@!",20)
	//TRCell():New(oSection,"DESCRIPA"		    ,"PED","Desc PA","@!",60)
	TRCell():New(oSection,"G1_COMP"		        ,"SG1","Componente","@!",20)
    TRCell():New(oSection,"B1_DESC"		,"SB1","Desc Comp","@!",60)
	TRCell():New(oSection,"B1_UM"		    ,"SB1","UM","@!",4)
	TRCell():New(oSection,"QTD_EMPENHADA"		    ,"SD4","Qtd. Empenhada","@!",20)
	TRCell():New(oSection,"PERIODO"		,"SD4","Periodo","@!",11)
	TRCell():New(oSection,"MEDIA"		,"SD4","Diferenca","@E 999,999,999.999",)
	//TRCell():New(oSection,"QTD_AMAZON01"		  ,"SB2","Qtd. Amazon","@E 999,999,999.999",)		
	//TRCell():New(oSection,"CLIENTE"     	,"PED","Cliente","@!",30) 
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

SELECT G1_COMP,B1_DESC,B1_UM,SUM(D4_QTDEORI)QTD_EMPENHADA,
       DATEDIFF(MONTH,'20241001','20241231')+1 PERIODO,
       SUM(D4_QTDEORI)/(DATEDIFF(MONTH,'20241001','20241231')+1) MEDIA 
FROM(
SELECT PED_NUM,C2_NUM,PED_ITEM,PED_PRODUTO,PED_DESCRI,CAST(PED_QUANT AS FLOAT)PED_QUANT,PED_TOTAL,PED_NOME,PED_MUN,
       G1_COMP,B1_DESC,B1_UM,G1_QUANT,G1_PERDA,D4_QTDEORI
FROM PED (NOLOCK)
INNER JOIN SC2100 SC2 (NOLOCK) ON PED_OP = C2_NUM AND PED_PRODUTO = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
INNER JOIN SG1100 SG1 (NOLOCK) ON PED_PRODUTO = G1_COD AND G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON G1_COMP = B1_COD AND B1_MSBLQL != '1' AND SB1.D_E_L_E_T_ = ''
INNER JOIN SD4100 SD4 (NOLOCK) ON C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP AND G1_COD = D4_PRODUTO AND G1_COMP = D4_COD AND G1_TRT = D4_TRT AND SD4.D_E_L_E_T_ = ''
WHERE PED_STATUS != 'C'
AND B1_DESC LIKE '%TEC%'
AND D4_DATA BETWEEN '20241001' AND '20241231'
AND D4_PRODUTO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
AND D4_COD BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
AND PED_CLIENTE BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
)TB
GROUP BY G1_COMP,B1_DESC,B1_UM
ORDER BY 4 DESC,B1_DESC


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
