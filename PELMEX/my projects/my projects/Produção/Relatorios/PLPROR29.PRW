#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR29   ºAutor  ³Juevan Silva     				º Data ³  10/11/23 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Pedidos X Insumos Detalhado                     			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR29()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR29"

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

	oReport := TReport():New(cPerg,"Pedidos X Insumos Detalhado",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Pedidos X Insumos Detalhado",{"SC2"},aOrdem) 


    TRCell():New(oSection,"C6_NUM"   	     ,"SC6","PEDIDO","@!",6)
	TRCell():New(oSection,"C6_ITEM"		      ,"SC6","ITEM","@!",3)
	TRCell():New(oSection,"C6_PRODUTO"		     ,"SC6","COD","@!",15)
    TRCell():New(oSection,"C6_DESCRI"		     ,"SC6","DESC_PA","@!",20)
    TRCell():New(oSection,"PI"		   ,"SB1","PI","@!",10) 
    TRCell():New(oSection,"B1_DESC"		     ,"SB1","DESC","@!",20)
    TRCell():New(oSection,"B1_UM"		     ,"SB1","UM","@!",3)
	TRCell():New(oSection,"C6_QTDVEN"		    ,"SC6","QTD PEDIDO","@@E 999,999,999.999",)
    TRCell():New(oSection,"G1_QUANT"	     ,"SG1","QTD ESTRUTURA","@@E 999,999,999.999",)  
	TRCell():New(oSection,"QTD_EMPENHADA"			    ,"SD3","QTD EMPENHO","@@E 999,999,999.999",) 
	TRCell():New(oSection,"QTD_01"        ,"SB2","ARMAZEM 01","@@E 999,999,999.999",) 
	TRCell():New(oSection,"QTD_10"        ,"SB2","ARMAZEM 10","@@E 999,999,999.999",) 
    TRCell():New(oSection,"SALDO_EMPENHO"        ,"SB2","SALDO EMPENHO","@@E 999,999,999.999",) 
	TRCell():New(oSection,"PED_NOME" 	,"PED","CLIENTE","@!",80) 
	TRCell():New(oSection,"PED_MUN" 	,"PED","CIDADE","@!",50) 
	//TRCell():New(oSection,"HORA"	,"CLC","HORA","@!",10) 
	//TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",12)
	//TRCell():New(oSection,"CLIENTE"     	,"SC2","CLIENTE","@!",30) 
	
    
	
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



SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,PI,B1_DESC,B1_UM,C6_QTDVEN,G1_QUANT,QTD_EMPENHADA,QTD_01,QTD_10,QTD_01+QTD_10-QTD_EMPENHADA SALDO_EMPENHO,PED_NOME,PED_MUN
FROM(
SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,SG1.G1_COMP PI,SB1.B1_DESC,SB1.B1_UM,C6_QTDVEN,SG1.G1_QUANT,C6_QTDVEN*(SG1.G1_QUANT+(SG1.G1_QUANT*SG1.G1_PERDA/100)) QTD_EMPENHADA,
       ISNULL(QTD_01,0)QTD_01,ISNULL(QTD_10,0)QTD_10,PED_NOME,PED_MUN 
FROM SC5100 SC5 (NOLOCK) 
INNER JOIN SC6100 SC6 (NOLOCK) ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = '' 
INNER JOIN SG1100 SG1 (NOLOCK) ON C6_PRODUTO = SG1.G1_COD AND SG1.G1_FIM >= CONVERT(VARCHAR,GETDATE(),112) AND SG1.D_E_L_E_T_ = '' AND SG1.G1_COMP NOT LIKE 'MOD%' 
INNER JOIN SB1100 SB1 (NOLOCK) ON SG1.G1_COMP = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' AND SB1.B1_MSBLQL != '1' 
LEFT JOIN PED (NOLOCK) ON C6_FILIAL = PED_FILIAL AND C6_NUM = PED_NUM AND C6_ITEM = PED_ITEM AND C6_PRODUTO = PED_PRODUTO AND ISNULL(PED_OP,'') = '' 
LEFT JOIN (SELECT B2_FILIAL,B2_COD,CASE WHEN B2_QATU-B2_QEMP < 0 THEN 0 ELSE B2_QATU-B2_QEMP END QTD_01,B2_LOCAL
           FROM SB2100 SB2 (NOLOCK)
		   WHERE SB2.D_E_L_E_T_ = ''
		   AND B2_FILIAL = '01'
		   AND B2_LOCAL = '01')SB201 ON G1_COMP = SB201.B2_COD
LEFT JOIN (SELECT B2_FILIAL,B2_COD,CASE WHEN B2_QATU-B2_QEMP < 0 THEN 0 ELSE B2_QATU-B2_QEMP END QTD_10,B2_LOCAL
           FROM SB2100 SB2 (NOLOCK)
		   WHERE SB2.D_E_L_E_T_ = ''
		   AND B2_FILIAL = '01'
		   AND B2_LOCAL = '10')SB210 ON G1_COMP = SB210.B2_COD 
WHERE SC5.D_E_L_E_T_ = '' 
AND C5_FILIAL = '01' 
AND C6_TES NOT IN ('709','915','917') 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NÃO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TESTE%'  
AND CONVERT(VARCHAR,CAST (PED_DTPREVIA AS DATE),112)  BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)TB 
//WHERE PI BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
ORDER BY C6_NUM,C6_ITEM


		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Emissao:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Codigo:" ,20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Codigo:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	
	
	
Return
