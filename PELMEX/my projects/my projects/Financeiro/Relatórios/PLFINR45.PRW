#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLFINR45    ºAutor  ³juevan Silva     				º Data ³ 03/03/2023º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contas Receber X Saida NF         		     			 	 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLFINR45()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFINR45"

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)

	oReport := ReportDef(cAlias,cPerg)
	oReport:PrintDialog()
Return


Static Function ReportDef(cAlias,cPerg)
	Local oReport
	Local oSection
	Local oFunction1
    Local oBreak
	Local aOrdem      := {"FILIAL"}
   

	oReport := TReport():New(cPerg,"Contas Receber X Saida NF",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Contas Receber X Saida NF",{"SE1"},aOrdem)
	
	TRCell():New(oSection,"DT_NOTA"	        ,"SD2","DT_NOTA","@!",7)	   
	TRCell():New(oSection,"STATUS"	  		    ,"SE1","STATUS","@!",10) 
    TRCell():New(oSection,"BANCO"	  	    ,"SE1","BANCO","@!",4)
	TRCell():New(oSection,"AGENCIA"	  	    ,"SE1","AGENCIA","@!",3)
	TRCell():New(oSection,"CONTRATO"	   	   ,"SC6","CONTRATO","@!",10)
	TRCell():New(oSection,"NOTA"	  	 ,"SD2","NOTA","@!",10)     
    TRCell():New(oSection,"SERIE"	   	   ,"SD2","SRIE","@!",4)
    TRCell():New(oSection,"QTD_NOTA"	   	   ,"SD2","QTD_NOTA","@!",10)
    TRCell():New(oSection,"TOTAL_PARCELA"	  ,"SD2","TOTAL_PARCELA","@E 9,999,999,999.99",)  
    TRCell():New(oSection,"DT_SAIDA"	   	   ,"CNF","DT_SAIDA","@!",10)
    TRCell():New(oSection,"DT_BIPE"	   	   ,"SAI","DT_BIPE","@!",10)
    TRCell():New(oSection,"CODCLI"	   	   ,"SA1","CODCLI","@!",10)
    TRCell():New(oSection,"LOJA"	   	   ,"SA1","LOJA","@!",10)
    TRCell():New(oSection,"CLIENTE"	   	   ,"SA1","CLIENTE","@!",40)
    TRCell():New(oSection,"CIDADE"	   	   ,"SA1","CIDADE","@!",10)
    TRCell():New(oSection,"CODVEND"	   	   ,"SA3","CODVEND","@!",7)
    TRCell():New(oSection,"VENDEDOR"	   	,"SA3","VENDEDOR","@!",30)

    
    

	//Totalizador  
    //oReport:GetFunction("TOTAL_DESCONTADO"):uReport := Total_Liq

	/*TRFunction():New(oSection:Cell("TOTAL_DUPLICATA"),"Total Duplicata:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("JUROS"),"Total Juros:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_IOF_DIA"),"Total IOF Dia","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_IOF_ADICIONAL"),"Total IOF Adicional:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_IOF"),"Total IOF:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("VAL_OPERACAO"),"Total Taxa Inclusão:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_DESCONTADO"),"Total Líquido:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
    TRFunction():New(oSection:Cell("TOTAL_LIQUIDO"),"Total a Receber:","SUM",,,"@E 9,999,999,999.99",,.T.,.F.)
	
    /*oFunction1 := TRFunction():New(oSection:Cell("TOTAL_DUPLICATA") ,"Total Duplicata :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("TOTAL_IOF") ,"Total IOF :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("VAL_OPERACAO") ,"Total IOF :","SUM",oBreak,"","@E 999,999,999.99",,.F.,.F.,.F.)
    oFunction1 := TRFunction():New(oSection:Cell("GERAL") ,"A Receber:","ONPRINT",oBreak,"","@E 999,999,999.99",{||oSection:aFunction[1]:GetValue() - oSection:aFunction[2]:GetValue() - oSection:aFunction[3]:GetValue()},.F.,.F.,.F.)
    */
    //TRFunction():New(oSection:Cell("VAL_PAGAR"),"TOTAL Pagar","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("DIFERENCA"),"Diferenca","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	oReport:SetTotalInLine(.T.)

	//Quebra por Seção
	//oSection1:SetPageBreak(.T.)
	//oSection1:SetTotalText(" ")

Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)
	//Local oSection2  := oReport:Section(2)

	//if oReport:Section(1):GetOrder() == 1
	//	cOrdem := "A1_COD"                       ·
	//endif      


	oSection:BeginQuery()
	BeginSQL Alias cAlias
	%noparser%   

SELECT DT_NOTA,CASE WHEN E1_PORTADO IS NULL THEN 'NÃO GERA FINANCEIRO' ELSE 'GERA FINANCEIRO' END STATUS,
       ISNULL(E1_PORTADO,'')BANCO,ISNULL(E1_AGEDEP,'')AGENCIA,C6_CONTRAT CONTRATO,D2_DOC NOTA,D2_SERIE SERIE,SUM(QTD_NOTA)QTD_NOTA,
     ISNULL(E1_VALOR,0) TOTAL_PARCELA,DT_SAIDA,DT_BIPE,A1_COD CODCLI,A1_LOJA LOJA,A1_NOME CLIENTE,A1_MUN CIDADE,
     ISNULL(E1_VEND1,'')CODVEND,ISNULL(A3_NOME,'')VENDEDOR
FROM(
SELECT ISNULL(PED_DTPROPEL,'')DT_PRODUCAO,CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103)DT_NOTA,C6_CONTRAT,D2_DOC,D2_SERIE,SUM(D2_QUANT)QTD_NOTA,
       SUM(D2_TOTAL)TOTAL,
     QTD_BIPE,SUM(D2_QUANT)-QTD_BIPE DIFERENCA,ISNULL(CNF_EXPEDICAO,'')DT_SAIDA,ISNULL(MAX(DT_BIPE),'')DT_BIPE,A1_COD,A1_LOJA,A1_NOME,A1_MUN
FROM(
SELECT PED_DTPROPEL,D2_EMISSAO,C6_CONTRAT,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,D2_TOTAL,
       CASE WHEN ISNULL(QTD_BIPE,0) > D2_QUANT THEN D2_QUANT ELSE ISNULL(QTD_BIPE,0) END QTD_BIPE,
     CNF_EXPEDICAO,DT_BIPE,A1_COD,A1_LOJA,A1_NOME,A1_MUN
FROM SD2100 SD2 (NOLOCK)
LEFT JOIN PED (NOLOCK) ON D2_FILIAL = PED_FILIAL AND CASE WHEN ISNULL(PED_NOTA,'') = '' THEN D2_PEDIDO ELSE D2_DOC END = CASE WHEN ISNULL(PED_NOTA,'') = '' THEN PED_NUM ELSE PED_NOTA END AND CASE WHEN ISNULL(PED_NOTA,'') = '' THEN D2_ITEMPV ELSE D2_ITEM END = PED_ITEM AND D2_COD = PED_PRODUTO AND PED_STATUS != 'C'
INNER JOIN SA1100 SA1 (NOLOCK) ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 (NOLOCK) ON D2_COD = B1_COD AND SB1.D_E_L_E_T_  = ''
INNER JOIN SC5100 SC5 (NOLOCK) ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ''
INNER JOIN SC6100 SC6 (NOLOCK) ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND D2_COD = C6_PRODUTO AND SC6.D_E_L_E_T_ = ''
LEFT JOIN (SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SUM(SAI_QUANT)QTD_BIPE,MAX(DT_BIPE)DT_BIPE
      FROM(SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_PRODUTO,SAI_QUANT,SAI_CPRODUC,MAX(SAI_DTEXP)DT_BIPE
      FROM SAI
      GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_PRODUTO,SAI_QUANT,SAI_CPRODUC
      )TB
      GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE)SAI ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE
LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE
WHERE SD2.D_E_L_E_T_ = ''
AND CNF_DOC IS NULL
AND ISNULL(DT_BIPE,'') = ''
AND D1_DOC IS NULL
AND D2_SERIE = '2'
AND D2_LOCAL = '20'
AND D2_FILIAL = '01'
AND D2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND D2_CLIENTE BETWEEN '' AND 'ZZZZZZ'
AND D2_DOC BETWEEN '' AND 'ZZZZZZZZZ'
AND D2_SERIE BETWEEN '' AND 'ZZZ'
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
)TB
GROUP BY PED_DTPROPEL,D2_EMISSAO,C6_CONTRAT,D2_DOC,D2_SERIE,QTD_BIPE,CNF_EXPEDICAO,A1_COD,A1_LOJA,A1_NOME,A1_MUN
)TB1
LEFT JOIN (SELECT E1_NUM,E1_PREFIXO,SUM(E1_VALOR)E1_VALOR,SUM(E1_COMIS1)E1_COMIS1,E1_CLIENTE,E1_LOJA,E1_PORTADO,E1_AGEDEP,E1_VEND1
           FROM(
           SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VALOR,E1_COMIS1,E1_CLIENTE,E1_LOJA,E1_PORTADO,E1_AGEDEP,E1_VEND1
           FROM SE1100 SE1 (NOLOCK)
       WHERE SE1.D_E_L_E_T_ = ''
       )TB
       GROUP BY E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_PORTADO,E1_AGEDEP,E1_VEND1)SE1 ON D2_DOC = E1_NUM AND D2_SERIE = E1_PREFIXO AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA
LEFT JOIN SA3100 SA3 (NOLOCK) ON E1_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
WHERE E1_VEND1 BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
GROUP BY DT_NOTA,E1_PORTADO,E1_AGEDEP,C6_CONTRAT,D2_DOC,D2_SERIE,E1_VALOR,DT_SAIDA,DT_BIPE,A1_COD,A1_LOJA,A1_NOME,A1_MUN,E1_VEND1,A3_NOME,E1_COMIS1 
ORDER BY C6_CONTRAT,D2_DOC,D2_SERIE,BANCO
    		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()
		 
Return


Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Emissao"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate DtEmissao"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
u_InPutSX1(cPerg,"03",PADR("De Vendedor"     ,20)+"?","","","mv_ch3","C",7,0,0,"G","","","","","mv_par03") 
u_InPutSX1(cPerg,"04",PADR("Ate Vendedor"    ,20)+"?","","","mv_ch4","C",7,0,0,"G","","","","","mv_par04")
//u_InPutSX1(cPerg,"05",PADR("De Cliente"         ,20)+"?","","","mv_ch5","C",10,5,0,"G","","","","","mv_par05") 
//u_InPutSX1(cPerg,"06",PADR("Ate Cliente"        ,20)+"?","","","mv_ch6","C",10,5,0,"G","","","","","mv_par06")

Return
