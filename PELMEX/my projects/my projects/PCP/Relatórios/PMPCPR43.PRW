#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR43    บAutor  ณWYLLIAM SILVA     				บ Data ณ  14/12/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rel.Ordem Produ็ใo Geral    								             ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR43()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PMPCPR43"

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

	oReport := TReport():New(cPerg,"Rel.Ordem Produ็ใo Geral",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"REL.ORDEM PRODUวรO GERAL",{"SC5"},aOrdem) 
	
    TRCell():New(oSection,"FILIAL"	    	,"SC6","FILIAL",/*Mascara*/,20)     
	TRCell():New(oSection,"DT_PEIDO"        ,"SC5","PEDIDO DT",/*Mascara*/,15)  
	TRCell():New(oSection,"PEDIDO"	    	,"SC6","NUM PEDIDO",/*Mascara*/,15)  
	TRCell():New(oSection,"NOTA"	    	,"SC6","NOTA",/*Mascara*/,15)
	TRCell():New(oSection,"OP"	        	,"PED","OP",/*Mascara*/,15)
	TRCell():New(oSection,"DT_OP"	        ,"PED","OP DT",/*Mascara*/,15)
	TRCell():New(oSection,"DT_PRODUCAO"     ,"PED","PROD DT",/*Mascara*/,15)
	TRCell():New(oSection,"ITEM"	    	,"SC6","ITEM",/*Mascara*/,15)
	TRCell():New(oSection,"PRODUTO"         ,"SC6","PRODUTO",/*Mascara*/,20)
	TRCell():New(oSection,"DESCRICAO"       ,"SC6","DESCRICAO",/*Mascara*/,50)   
	TRCell():New(oSection,"ARMAZEM"         ,"SC6","ARMAZEM",/*Mascara*/,15)
	TRCell():New(oSection,"QTD_PEDIDO"      ,"SC6","QTD PEDIDO","@E 9,999,999,999.99",5) 
	TRCell():New(oSection,"QTD_ENTREGUE"    ,"SC6","QTD ENTREG","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_PEDIDO"      ,"SC6","QTD PEDIDO","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"VAL_UNITARIO"    ,"SC6","VALOR UNIT","@E 9,999,999,999.99",10)
	TRCell():New(oSection,"VALOR"           ,"SC6","QTD VALOR","@E 9,999,999,999.99",10)
	TRCell():New(oSection,"QTD_PLANO"       ,"PK2","QTDPLANO","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_OP"          ,"PK2","QTD OP","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_APONTADA"    ,"PED","QTD APONTADA","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_MICROSIGA"   ,"SB2","QTD MICROSIGA","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_OP"          ,"PED","QTD OP","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_COLCHAO"     ,"CLA","QTD COLCHAO","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_CAMA"        ,"CLB","QTD CAMA","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_ENTRADA"     ,"SZ1","QTD ENTRADA","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"QTD_SAIDA"       ,"SAI","QTD SAIDA","@E 9,999,999,999.99",5)
	TRCell():New(oSection,"CLIENTE"         ,"SA1","CLIENTE",/*Mascara*/,20)
	TRCell():New(oSection,"FONE"            ,"SA1","FONE",/*Mascara*/,20)
	TRCell():New(oSection,"CIDADE"          ,"SA1","CIDADE",/*Mascara*/,20)
			
    //TRCell():New(oSection,"QTD_SAIDA"       ,"PED","QUANT. SAIDA","@E 9,999,999,999.99",20) NUMERAL
	//TRCell():New(oSection,"DT_PEIDO"        ,"SC5","PEDIDO DT",/*Mascara*/,20) CARACTERE
	
	//Totalizador                                                                                  
	//TRFunction():New(oSection:Cell("C6_VALOR"),"TOTAL FATURADO","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("CUBAGEM"),"TOTAL CUBAGEM","SUM",,,"@E 999,999,999.999999",,.F.,.T.)  
	//TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)


Return oReport


/*Inicia Logica Print Report */

Static Function PrintReport(oReport,cAlias)
	Local oSection  := oReport:Section(1)

	oSection:BeginQuery()
	BeginSQL Alias cAlias
		%noparser%

	  SELECT C6_FILIAL FILIAL,
		     CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_PEIDO,
		     CONVERT(VARCHAR,CAST(C6_ENTREG AS DATE),103)DT_ENTREGA,
		     C6_NUM PEDIDO,C6_NOTA NOTA,ISNULL(OP,'')OP,
		     ISNULL(DT_OP,'')DT_OP,ISNULL(DT_PRODUCAO,'')DT_PRODUCAO,
		     C6_ITEM ITEM,C6_PRODUTO PRODUTO,C6_DESCRI DESCRICAO,C6_LOCAL ARMAZEM,
		     C6_QTDVEN QTD_PEDIDO,C6_QTDENT QTD_ENTREGUE,C6_PRCVEN VAL_UNITARIO,C6_VALOR VALOR,ISNULL(QTD_PLANO,0)QTD_PLANO,ISNULL(QTD_OP,0)QTD_OP,ISNULL(QTD_APONTADA,0)QTD_APONTADA,B2_QATU QTD_MICROSIGA,
		     CAST(ISNULL(QTD_COLCHAO,0) AS INT)QTD_COLCHAO,CAST(ISNULL(QTD_CAMA,0) AS INT)QTD_CAMA,ISNULL(QTD_ENTRADA,0)QTD_ENTRADA,ISNULL(QTD_SAIDA,0)QTD_SAIDA,
		     A1_NOME CLIENTE,A1_TEL FONE,A1_MUN CIDADE
FROM SC5100 SC5
INNER JOIN SC6100 SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ = ''
INNER JOIN SB1100 SB1 ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SB2100 SB2 ON C6_FILIAL = B2_FILIAL AND C6_LOCAL = B2_LOCAL AND C6_PRODUTO = B2_COD AND SB2.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN (
    SELECT ISNULL(PED_FILIAL,'') FILIAL,ISNULL(PED_EMISSAO,'')DT_PEDIDO,ISNULL(PED_ENTREG,'')DT_ENTREGA,CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_OP,ISNULL(PK2_DTPROPEL,'') DT_PRODUCAO,
	       ISNULL(PED_NUM,'') PEDIDO,C2_NUM OP,ISNULL(PED_ITEM,'')ITEM,C2_PRODUTO PRODUTO,B1_DESC DESCRICAO,ISNULL(QTD_PLANO,0)QTD_PLANO,C2_QUANT QTD_OP,C2_QUJE QTD_APONTADA,
	       ISNULL(QTD_COLCHAO,0)QTD_COLCHAO,ISNULL(QTD_CAMA,0)QTD_CAMA,ISNULL(QTD_ENTRADA,0)QTD_ENTRADA,ISNULL(QTD_SAIDA,0)QTD_SAIDA,C2_OBS CLIENTE,ISNULL(PED_MUN,'')MUNICIPIO
		    FROM SC2100 SC2
		    INNER JOIN SB1100 SB1 ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
		    LEFT JOIN (SELECT PED_FILIAL,PED_NUM,PED_OP,PED_ITEM,PED_PRODUTO,CAST(PED_QUANT AS INT) QTD_PLANO,PED_MUN,
		              CONVERT(VARCHAR,CAST(PED_EMISSAO AS DATE),103)PED_EMISSAO,
		              CONVERT(VARCHAR,CAST(PED_ENTREG AS DATE),103)PED_ENTREG,
		              PK2_DTPROPEL
		           FROM PED
		           INNER JOIN PK2 ON PED_CODIGO = PK2_CODIGO AND PED_OP = PK2_OP AND PED_PRODUTO = PK2_PRODUTO
		           INNER JOIN SC2100 SC2 ON PED_OP = C2_NUM AND PED_PRODUTO = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
		           )PED ON C2_NUM = PED_OP AND C2_PRODUTO = PED_PRODUTO
    LEFT JOIN ( SELECT SUBSTRING(CLA_CPRODUC,1,6)CLA_OP,CLA_COD,SUM(CLA_QUANT)QTD_COLCHAO
          FROM CLA
          WHERE CONVERT(VARCHAR,CAST(CLA_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
          GROUP BY SUBSTRING(CLA_CPRODUC,1,6),CLA_COD)CLA ON C2_NUM = CLA_OP AND C2_PRODUTO = CLA_COD
    LEFT JOIN ( SELECT SUBSTRING(CLB_CPRODUC,1,6)CLB_OP,CLB_COD,SUM(CLB_QUANT)QTD_CAMA
          FROM CLB
          WHERE CONVERT(VARCHAR,CAST(CLB_DATINC AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
          GROUP BY SUBSTRING(CLB_CPRODUC,1,6),CLB_COD)CLB ON C2_NUM = CLB_OP AND C2_PRODUTO = CLB_COD
    LEFT JOIN ( SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,C2_PRODUTO Z1_PRODUTO,COUNT(Z1_OP+Z1_CHASSIS)QTD_ENTRADA
          FROM SZ1100 SZ1
          INNER JOIN SC2100 SC2 ON SUBSTRING(Z1_OP,1,6) = C2_NUM AND SC2.D_E_L_E_T_ = ''
          WHERE SZ1.D_E_L_E_T_ = ''
          AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
          GROUP BY SUBSTRING(Z1_OP,1,6),C2_PRODUTO)SZ1 ON C2_NUM = Z1_OP AND C2_PRODUTO = Z1_PRODUTO
    LEFT JOIN ( SELECT SUBSTRING(SAI_CPRODUC,1,6)SAI_OP,C2_PRODUTO SAI_PRODUTO,SUM(SAI_QUANT)QTD_SAIDA
          FROM SAI
          INNER JOIN SC2100 SC2 ON SUBSTRING(SAI_CPRODUC,1,6) = C2_NUM AND SC2.D_E_L_E_T_ = ''
          WHERE C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
          GROUP BY SUBSTRING(SAI_CPRODUC,1,6),C2_PRODUTO)SAI ON C2_NUM = SAI_OP AND C2_PRODUTO = SAI_PRODUTO
    WHERE SC2.D_E_L_E_T_ = ''
    AND C2_PRODUTO NOT LIKE 'BLO%'
    AND C2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
)PED ON C6_FILIAL = FILIAL AND C6_NUM = PEDIDO AND C6_ITEM = ITEM AND C6_PRODUTO = PRODUTO
WHERE SC5.D_E_L_E_T_ = ''
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAM%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%N%PRODUZ%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%MANUTEN%'
AND C5_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C6_LOCAL IN ('20','30')
AND C6_FILIAL = '01'
ORDER BY C6_ENTREG,C6_NUM,C6_ITEM
		
	EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissใo"     ,8)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("At้ Emissใo"    ,8)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02") 
	//u_InPutSX1(cPerg,"03",PADR("De Emissใo"     ,20)+"?","","","mv_ch3","D",8,0,0,"G","","","","","mv_par03")
	//u_InPutSX1(cPerg,"04",PADR("At้ Emissใo"    ,20)+"?","","","mv_ch4","D",8,0,0,"G","","","","","mv_par04")  
	
Return