
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR50    บAutor  ณJuevan Silva     				บ Data ณ  10/11/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Analise de Venda Nota										 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR51()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR51"

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

	oReport := TReport():New(cPerg,"Analise de Pedidos para Produ็ใo",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Analise de Pedidos para Produ็ใo",{"SC6"},aOrdem) 



    TRCell():New(oSection,"C6_NUM"    		,"SC6","PEDIDO","@!",12)
    TRCell():New(oSection,"DT_PEDIDO"  		,"SC5","DT_PEDIDO","@!",10)
    TRCell():New(oSection,"DT_ENTREGA" 		,"SC6","DT_ENTREGA","@!",10)
    TRCell():New(oSection,"PED_OP"   		,"PED","ORDEM PROD","@!",10)
    TRCell():New(oSection,"PED_DTPROPEL"   	,"PED","DT_PRODUCAO","@!",10)
    TRCell():New(oSection,"D2_DOC"      	,"SD2","NOTA","@!",10)
    TRCell():New(oSection,"DT_NOTA"    		,"SD2","DT_NOTA","@!",10)
 	TRCell():New(oSection,"A1_EST"   		,"SA1","ESTADO","@!",10)
    TRCell():New(oSection,"A1_MUN"      	,"SA1","MUNICIPIO","@!",30)
    TRCell():New(oSection,"A1_NOME"    	    ,"SA1","CLIENTE","@!",35)
   
    

	//Totalizador
	/*                                                                                
	TRFunction():New(oSection:Cell("D2_QUANT"),"TOTAL BASE","SUM",,,"@E 9,999,999,999.99",,.F.,.F.)
	TRFunction():New(oSection:Cell("D2_PRCVEN"),"TOTAL PREวOVEND","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("D2_TOTAL"),"TOTAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)*/
	
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

    SELECT C6_NUM,
       CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_PEDIDO,
       CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),103)DT_ENTREGA,
       ISNULL(PED_OP,'')PED_OP,
       ISNULL(PED_DTPROPEL,'')PED_DTPROPEL,
       ISNULL(D2_DOC,'')D2_DOC,
       ISNULL(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),'')DT_NOTA,
       A1_EST,
       A1_MUN,
       A1_COD,
       A1_NOME
FROM SC6100 SC6 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SC5100 SC5 (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT *
           FROM PED
          )PED ON C6_FILIAL = PED_FILIAL AND C6_NUM = PED_NUM AND C6_ITEM = PED_ITEM AND C6_PRODUTO = PED_PRODUTO
LEFT JOIN (SELECT *
           FROM SD2100 SD2 (NOLOCK)
		   WHERE SD2.D_E_L_E_T_ = '')SD2 ON (CASE WHEN ISNULL(PED_FILIAL,'') = '' THEN C6_FILIAL ELSE PED_FILIAL END) = D2_FILIAL AND (CASE WHEN ISNULL (PED_NOTA,'') = '' THEN (CASE WHEN ISNULL (PED_NUM,'') = '' THEN C6_NUM ELSE PED_NUM END) ELSE PED_NOTA END) = (CASE WHEN ISNULL (PED_NOTA,'') = '' THEN D2_PEDIDO ELSE D2_DOC END) 
 
                                                                   AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD 
LEFT JOIN (SELECT *
          FROM SC2100 SC2
         ) SC2 ON C2_NUM = PED_OP AND C2_PRODUTO = PED_PRODUTO AND  SC2.D_E_L_E_T_ = ''
          
LEFT JOIN (SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO,SUM(SAI_QUANT)SAI_QUANT,MIN(SAI_DTEXP)SAI_DTEXP
           FROM SAI
           GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO)SAI ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND D2_ITEM = SAI_ITEM AND D2_COD = SAI_PRODUTO
LEFT JOIN (SELECT *
           FROM CNF
           WHERE CNF_DOC IS NULL)CNF ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE
LEFT JOIN (SELECT *
			FROM PTC
			WHERE PTC_STATUS != 'D' AND PTC_EMPRESA = '10') PTC ON D2_FILIAL = PTC_FILIAL AND D2_DOC = PTC_DOC AND D2_SERIE = PTC_SERIE
			AND PTC_SETOR = '4040      | EXPEDICAO                               '
LEFT JOIN (SELECT *
			FROM MAN
			WHERE MAN_EMPRESA = '10') MAN ON D2_FILIAL = MAN_FILIAL AND D2_DOC = MAN_DOC AND D2_SERIE = MAN_SERIE
LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = '' 
WHERE SC6.D_E_L_E_T_ = ''
AND C6_FILIAL = '01'
AND C6_TES NOT IN ('709','915','916','917')
AND C6_LOCAL ='20'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%INVENT%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%NAO PRODUZIR%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%NรO PRODUZIR%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%REFATURAMENTO%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%TRANSFERENCIA%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%TRANSF %'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%DEVOLUCAO%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'DEV %'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'REF.%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'REF %'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'ESTORNO%'

AND CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%

GROUP BY C6_NUM,C5_EMISSAO,C6_ENTREG,PED_OP,PED_DTPROPEL,C2_XCARGA,D2_DOC,D2_EMISSAO,PTC_DATINC,PTC_DATALT,D1_DOC,D1_EMISSAO,SAI_DTEXP,CNF_EXPEDICAO,MAN_CODMAN,
         MAN_DATEXP,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_LOCAL,D2_QUANT,C6_QTDVEN,C6_QTDENT,PED_QUANT,B1_DCR,B1_XALTURA,B1_XCOMPRI,B1_XLARGUR,A1_EST,A1_MUN,A1_COD,A1_NOME,
	   A1_MSBLQL,RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3),B1_XSETOR
ORDER BY A1_MUN,C6_NUM,C6_ITEM


EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)

u_InPutSX1(cPerg,"01",PADR("De Dt Entrega  ",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
u_InPutSX1(cPerg,"02",PADR("Ate Dt Entrega ",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02") 

Return
