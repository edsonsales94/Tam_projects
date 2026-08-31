#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLEXTR11    ºAutor  ³Wylliam Silva     				º Data ³  04/05/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Notas Pendentes de Entrega				   	  							 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLEXTR12()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLEXTR12"

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

	oReport := TReport():New(cPerg,"Notas Pendentes de Entrega",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Notas Pendentes de Entrega",{"CNF"},aOrdem)  
	
	TRCell():New(oSection,"DT_PRODUCAO"    		,"PED","Dt.Producao","@!",9)
	TRCell():New(oSection,"DT_NOTA"  			,"SD2","Dt.Nota","@!",15)
	TRCell():New(oSection,"CARGA"  			    ,"SD2","Carga","@!",15)
	TRCell():New(oSection,"NOTA"   		        ,"SD2","Nota","@!",20)
	TRCell():New(oSection,"SERIE"   		    ,"SD2","Serie","@!",6)
	TRCell():New(oSection,"QTD_NOTA"            ,"SD2","Qtd.Nota","@E 999,999,999,999",)
	TRCell():New(oSection,"TOTAL"               ,"SD2","Total Nota","@E 999,999,999,999.99",)
	TRCell():New(oSection,"QTD_BIPE"            ,"SD2","Qtd.Bipe","@E 999,999,999,999",)
	TRCell():New(oSection,"DIFERENCA"           ,"SD2","Diferenca","@E 999,999,999,999",)
	TRCell():New(oSection,"DT_SAIDA"   		    ,"CNF","Dt.Saida","@!",15)
	TRCell():New(oSection,"DT_BIPE"   		    ,"SAI","Dt.Bipe","@!",15)
	TRCell():New(oSection,"NOME"   		        ,"SA1","Nome","@!",50)
	TRCell():New(oSection,"CIDADE"   		    ,"SA1","Cidade","@!",30)
		
	
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
SELECT DT_PRODUCAO,CARGA,DT_NOTA,NOTA,SERIE,SUM(QTD_NOTA)QTD_NOTA,SUM(TOTAL)TOTAL,SUM(QTD_BIPE)QTD_BIPE,SUM(DIFERENCA)DIFERENCA,DT_SAIDA,DT_BIPE,NOME,CIDADE
FROM(
SELECT ISNULL(PED_DTPROPEL,'')DT_PRODUCAO,
       ISNULL(C2_XCARGA,'')CARGA,
       CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103)DT_NOTA,
	   D2_DOC NOTA,D2_SERIE SERIE,
	   SUM(D2_QUANT)QTD_NOTA,SUM(D2_TOTAL)TOTAL,
	   QTD_BIPE,
	   SUM(D2_QUANT)-QTD_BIPE DIFERENCA,
	   ISNULL(CNF_EXPEDICAO,'') DT_SAIDA,
	   MAX(ISNULL(DT_BIPE,''))DT_BIPE,
	   A1_NOME NOME,A1_MUN CIDADE
FROM(
SELECT PED_DTPROPEL,C2_XCARGA,D2_EMISSAO,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,D2_TOTAL,CASE WHEN ISNULL(QTD_BIPE,0) > D2_QUANT THEN D2_QUANT ELSE ISNULL(QTD_BIPE,0) END QTD_BIPE,CNF_EXPEDICAO,DT_BIPE,A1_NOME,A1_MUN
FROM SD2100 SD2 (NOLOCK)
LEFT JOIN PED (NOLOCK) ON D2_FILIAL = PED_FILIAL AND CASE WHEN ISNULL(PED_NOTA,'') = '' THEN D2_PEDIDO ELSE D2_DOC END = CASE WHEN ISNULL(PED_NOTA,'') = '' THEN PED_NUM ELSE PED_NOTA END AND D2_ITEMPV = PED_ITEM AND D2_COD = PED_PRODUTO AND PED_STATUS != 'C'
LEFT JOIN SC2100 SC2 (NOLOCK) ON PED_OP = C2_NUM AND PED_PRODUTO = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_  = ''
INNER JOIN SC5100 SC5 (NOLOCK) ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
LEFT JOIN (SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SUM(SAI_QUANT)QTD_BIPE,MAX(DT_BIPE)DT_BIPE
			FROM(SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_PRODUTO,SAI_QUANT,SAI_CPRODUC,MAX(SAI_DTEXP)DT_BIPE
			FROM SAI
			GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_PRODUTO,SAI_QUANT,SAI_CPRODUC
			)TB
			GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE)SAI ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE
LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA
WHERE SD2.D_E_L_E_T_ = ''
AND CNF_DOC IS NULL
AND D1_DOC IS NULL
AND D2_LOCAL = '20'
AND D2_FILIAL = '01'
AND D2_TES NOT IN ('709','915','917')
AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
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
GROUP BY PED_DTPROPEL,C2_XCARGA,D2_EMISSAO,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,D2_TOTAL,QTD_BIPE,CNF_EXPEDICAO,DT_BIPE,A1_NOME,A1_MUN
)TB
GROUP BY PED_DTPROPEL,C2_XCARGA,D2_EMISSAO,D2_DOC,D2_SERIE,QTD_BIPE,CNF_EXPEDICAO,A1_NOME,A1_MUN
)TB1
GROUP BY DT_PRODUCAO,CARGA,DT_NOTA,NOTA,SERIE,DT_SAIDA,DT_BIPE,NOME,CIDADE
ORDER BY CONVERT(VARCHAR,CAST(DT_PRODUCAO AS DATE),112),NOTA,SERIE 	

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("Usuario:" ,20)+"?","","","mv_ch3","C",4,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return
