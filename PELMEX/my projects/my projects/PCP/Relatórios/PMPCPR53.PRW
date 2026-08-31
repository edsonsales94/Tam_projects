#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR53    ºAutor  ³Wylliam Silva     				º Data ³  05/01/22 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   	Relatório Rastreio do Pedido	           		    	  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR53()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR53"

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

	oReport := TReport():New(cPerg,"Relatório Rastreio do Pedido",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Relatório Rastreio do Pedido",{"SC6"},aOrdem)  
	
    TRCell():New(oSection,"C6_NUM"	         ,"SC6","NUM. PEDIDO","@!",8) 
    TRCell():New(oSection,"DT_PEDIDO"	     ,"SC5","DT PEDIDO","@!",8)             
	TRCell():New(oSection,"DT_ENTREGA"       ,"SC6","DT ENTREGA","@!",8)
	TRCell():New(oSection,"DT_PREVIA"       ,"SC6","DT PREVIA","@!",8)
	TRCell():New(oSection,"PED_OP"           ,"PED","ORDEM PROD","@!",10)
	TRCell():New(oSection,"PED_DTPROPEL"     ,"PED","DT PRODUCAO","@!",8)
	TRCell():New(oSection,"D2_DOC"           ,"SD2","NOTA FISCAL","@!",9)
	TRCell():New(oSection,"DT_NOTA"          ,"SD2","DT NF","@!",8)
	TRCell():New(oSection,"PTC_DATINC"       ,"PTC","DT INC.PROTOCOLO","@!",8)
	TRCell():New(oSection,"PTC_DATALT"       ,"PTC","DT RECB.PROTOCOLO","@!",8)
	TRCell():New(oSection,"D1_DOC"           ,"SD1","NOTA DEVOL","@!",9)
	TRCell():New(oSection,"DT_DEVOLUCAO"     ,"SD1","DT DEVOL","@!",8)
	TRCell():New(oSection,"SAI_DTEXP"        ,"SAI","DT EXPEDIDA","@!",8)
	TRCell():New(oSection,"CNF_EXPEDICAO"    ,"CNF","DT TRANSPORTE","@!",8)
	TRCell():New(oSection,"MAN_CODMAN"       ,"MAN","MANIFESTO","@!",9)
	TRCell():New(oSection,"MAN_DATEXP"       ,"MAN","DT MANIFESTO","@!",8)
	TRCell():New(oSection,"C6_ITEM"          ,"SC6","ITEM","@!",8)
	TRCell():New(oSection,"C6_PRODUTO"       ,"SC6","PRODUTO","@!",8)
	TRCell():New(oSection,"C6_DESCRI"        ,"SC6","DESCRICAO","@!",8)
	TRCell():New(oSection,"C6_LOCAL"	     ,"SC6","LOCAL","@!",8)
	TRCell():New(oSection,"C6_QTDVEN"	     ,"SC6","QUANT VENDA","@E 999,999,999.999",)
	TRCell():New(oSection,"C6_QTDENT"	     ,"SC6","QUANT ATENDIDA","@E 999,999,999.999",)
	//TRCell():New(oSection,"PED_QUANT"	     ,"PED","QUANT PEDIDO","@E 999,999,999,999",5)
	TRCell():New(oSection,"B1_DCR"           ,"SB1","DCR","@!",8)
	TRCell():New(oSection,"B1_XALTURA"	     ,"SB1","ALTURA PROD.","@E 999,999,999.999",)
	//TRCell():New(oSection,"B1_XALTURA"           ,"SB1","ALTURA PROD.","@!",5)
	TRCell():New(oSection,"B1_XCOMPRI"	     ,"SB1","COMPRI. PROD.","@E 999,999,999.999",)
	//TRCell():New(oSection,"B1_XCOMPRI"           ,"SB1","COMPRI. PROD.","@!",5)
	TRCell():New(oSection,"B1_XLARGUR"	     ,"SB1","COMPRI. LARGURA","@E 999,999,999.999",)
	//TRCell():New(oSection,"B1_XLARGUR"           ,"SB1","COMPRI. LARGURA","@!",5)
	TRCell():New(oSection,"CUBAGEM"	         ,"SB1","CUBAGEM","@E 999,999,999.99999",)
	//TRCell():New(oSection,"CUBAGEM"           ,"SB1","CUBAGEM","@!",5)
	TRCell():New(oSection,"A1_EST"	         ,"SA1","ESTADO","@!",4)
	TRCell():New(oSection,"A1_MUN"	         ,"SA1","MUNICIPIO","@!",30)
	TRCell():New(oSection,"A1_COD"	         ,"SA1","COD.CLIENTE","@!",10)
	TRCell():New(oSection,"A1_NOME"	         ,"SA1","CLIENTE","@!",30)
	TRCell():New(oSection,"A1_MSBLQL"	      ,"SA1","STATUS CLIENTE","@!",30)
	TRCell():New(oSection,"OBSERVACAO"	     ,"SC5","OBSERVAÇÃO","@!",80)
	TRCell():New(oSection,"B1_XSETOR"	      ,"SB1","SETOR","@!",15)
	TRCell():New(oSection,"C2_XCARGA"	      ,"SC2","CARGA","@!",15)
	TRCell():New(oSection,"C5_VEND1"	      ,"SC5","VENDEDOR","@!",35)
	TRCell():New(oSection,"A3_NOME"	      ,"SA3","NOME","@!",55)
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
		
SELECT C6_NUM,
       CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_PEDIDO,
       CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),103)DT_ENTREGA,
       ISNULL(PED_DTPREVIA,'')DT_PREVIA,
	   ISNULL(PED_OP,'')PED_OP,
       ISNULL(PED_DTPROPEL,'')PED_DTPROPEL,
       ISNULL(C2_XCARGA, '')C2_XCARGA,
       ISNULL(D2_DOC,'')D2_DOC,
       ISNULL(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),'')DT_NOTA,
       ISNULL (PTC_DATINC,'')PTC_DATINC,  
       ISNULL (PTC_DATALT,'')PTC_DATALT,  
       ISNULL (D1_DOC,'')D1_DOC,
       ISNULL(CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103),'')DT_DEVOLUCAO,
       ISNULL(SAI_DTEXP,'')SAI_DTEXP,
       ISNULL(CNF_EXPEDICAO,'')CNF_EXPEDICAO,
       ISNULL(MAN_CODMAN,'')MAN_CODMAN,
       ISNULL(MAN_DATEXP,'')MAN_DATEXP,
       C6_ITEM,
       C6_PRODUTO,
       C6_DESCRI,
       C6_LOCAL,
       C6_QTDVEN,
       CASE WHEN D2_QUANT IS NULL THEN C6_QTDENT ELSE D2_QUANT END C6_QTDENT,
       PED_QUANT,
       B1_DCR,
       B1_XALTURA,
       B1_XCOMPRI,
       B1_XLARGUR,
      CASE WHEN (C6_QTDVEN-C6_QTDENT)> 0 THEN ((B1_XALTURA*B1_XCOMPRI*B1_XLARGUR)* (C6_QTDVEN-C6_QTDENT)) ELSE ((B1_XALTURA*B1_XCOMPRI*B1_XLARGUR)* C6_QTDVEN) END CUBAGEM,
       A1_EST,
       A1_MUN,
       A1_COD,
       A1_NOME,
       CASE WHEN A1_MSBLQL = '1' THEN 'CLIENTE COM PENDENCIA' ELSE 'CLIENTE OK' END A1_MSBLQL,
       RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) OBSERVACAO,
       B1_XSETOR,C5_VEND1,A3_NOME
FROM SC6100 SC6 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SC5100 SC5 (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SA3100 SA3 (NOLOCK) ON C5_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ''
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
           FROM CNF)CNF ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE
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
//AND D1_DOC IS NULL
AND C6_TES NOT IN ('709','915','916','917')
AND C6_LOCAL IN ('15','20','30','50')
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%INVENT%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%NAO PRODUZIR%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%NÃO PRODUZIR%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%REFATURAMENTO%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%TRANSFERENCIA%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%TRANSF %'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE '%DEVOLUCAO%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'DEV %'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'REF.%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'REF %'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3) NOT LIKE 'ESTORNO%'
AND C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C6_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND A1_EST BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND A1_MUN BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
AND A1_COD BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
AND ISNULL(A3_COD,'') BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
GROUP BY C6_NUM,C5_EMISSAO,C6_ENTREG,PED_DTPREVIA,PED_OP,PED_DTPROPEL,C2_XCARGA,D2_DOC,D2_EMISSAO,PTC_DATINC,PTC_DATALT,D1_DOC,D1_EMISSAO,SAI_DTEXP,CNF_EXPEDICAO,MAN_CODMAN,C5_VEND1,A3_NOME,
         MAN_DATEXP,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_LOCAL,D2_QUANT,C6_QTDVEN,C6_QTDENT,PED_QUANT,B1_DCR,B1_XALTURA,B1_XCOMPRI,B1_XLARGUR,A1_EST,A1_MUN,A1_COD,A1_NOME,
		 A1_MSBLQL,RTRIM(C5_MENNOTA)+RTRIM(C5_XMSGNOT)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3),B1_XSETOR
ORDER BY A1_MUN,C6_NUM,C6_ITEM


EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao.:"     ,20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao.:"    ,20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Pedido:"       ,20)+"?","","","mv_ch3","C",6,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Pedido:"      ,20)+"?","","","mv_ch4","C",6,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De UF:"           ,20)+"?","","","mv_ch5","C",2,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate UF:"          ,20)+"?","","","mv_ch6","C",2,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De Municipio:"    ,20)+"?","","","mv_ch7","C",30,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Ate Municipio:"   ,20)+"?","","","mv_ch8","C",30,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("De Cod.Cliente:"  ,20)+"?","","","mv_ch9","C",8,0,0,"G","","SA1","","","mv_par09") 
	u_InPutSX1(cPerg,"10",PADR("Ate Cod.Cliente:" ,20)+"?","","","mv_cha","C",8,0,0,"G","","SA1","","","mv_par10")
	u_InPutSX1(cPerg,"11",PADR("De Vendedor:" ,20)+"?","","","mv_chb","C",8,0,0,"G","","SA3","","","mv_par11")
	u_InPutSX1(cPerg,"12",PADR("Ate Vendedor:" ,20)+"?","","","mv_chc","C",8,0,0,"G","","SA3","","","mv_par12")

Return
