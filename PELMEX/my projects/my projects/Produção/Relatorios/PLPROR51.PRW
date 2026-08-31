
#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PLPROR51  ºAutor  ³Juevan Silva     				º Data ³ 12/09/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Monitoramento de Saida de Cargas                  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PLPROR51()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR51"

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

	oReport := TReport():New(cPerg,"Monitoramento de Saida de Cargas",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Monitoramento de Saida de Cargas ",{"SD2"},aOrdem) 

    TRCell():New(oSection,"DT_PRODUCAO"   	        ,"PED","DT_PRODUCAO","@!",10)
    TRCell():New(oSection,"PEDIDO"	            ,"PED","PEDIDO","@!",6)
    TRCell():New(oSection,"NOTA"	    ,"SA1","NOTA","@!",10)
    TRCell():New(oSection,"CARGA"  			,"SC2","CARGA","@!",10)
    TRCell():New(oSection,"M3"		    ,"SC6","M3","@E 999,999,999,999.99",)
    TRCell():New(oSection,"QTD_PEDIDO"	            ,"PED","QTD_PEDIDO","@E 999,999,999,999",)
    TRCell():New(oSection,"QTD_PRODUZIDA"	            ,"PED","QTD_PRODUZIDA","@E 999,999,999,999.99",)
    TRCell():New(oSection,"QTD_ENTRADA"	            ,"PED","QTD_ENTRADA","@E 999,999,999,999.99",)
    TRCell():New(oSection,"STATUS_PRODUCAO"	            ,"PED","STATUS_PRODUCAO","@!",2)
    TRCell():New(oSection,"CIDADE"		    ,"SA1","CIDADE","@!",20)
    TRCell():New(oSection,"CLIENTE"		    ,"SA1","CLIENTE","@!",20)
    TRCell():New(oSection,"SAIDA"		    ,"SF4","SAIDA","@!",3)
    TRCell():New(oSection,"DT_SAIDA"   	        ,"SAI","DT_SAIDA","@!",10)
	//TRCell():New(oSection,"C6_ITEM"		  ,"SC6","C6_ITEM","@!",3)
    //TRCell():New(oSection,"C6_PRODUTO"	      ,"SC6","PRODUTO","@!",20) 
	//TRCell():New(oSection,"C6_CLI" 	         ,"SC6","C6_CLI","@!",7)
	
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

SELECT DT_PRODUCAO,PEDIDO,NOTA,CARGA,SUM(M3)M3,SUM(QTD_PEDIDO)QTD_PEDIDO,
       SUM(ISNULL(QTD_PRODUZIDA,0))QTD_PRODUZIDA,
       SUM(ISNULL(Z1_QUANT,0))QTD_ENTRADA,
       CASE WHEN SUM(QTD_PEDIDO) > (CASE WHEN SUM(ISNULL(QTD_PRODUZIDA,0)) > SUM(ISNULL(Z1_QUANT,0)) THEN SUM(ISNULL(QTD_PRODUZIDA,0)) ELSE SUM(ISNULL(Z1_QUANT,0)) END) THEN 'PENDENTE' ELSE 'OK' END STATUS_PRODUCAO,
       CIDADE,CLIENTE,SAIDA,DT_SAIDA
FROM(
SELECT PED_DTPROPEL DT_PRODUCAO,PED_NUM PEDIDO,ISNULL(D2_DOC,'')NOTA,C2_XCARGA CARGA,CAST(PED_QUANT AS FLOAT)QTD_PEDIDO,
       PED_QUANT*(B1_XLARGUR*B1_XALTURA*B1_XCOMPRI) M3,PED_MUN CIDADE,PED_NOME CLIENTE,
       CASE WHEN CNF_DOC IS NULL THEN 'NÃO' ELSE 'SIM' END SAIDA,Z1_QUANT,ISNULL(CNF_EXPEDICAO,'')DT_SAIDA,
     CASE WHEN B1_XSETOR LIKE 'CAM%' THEN QTD_CAMA
          WHEN B1_XSETOR LIKE 'COLCHAO%' THEN QTD_COLCHAO
     ELSE Z1_QUANT END QTD_PRODUZIDA
FROM PED
INNER JOIN SC2100 SC2 ON PED_OP = C2_NUM AND PED_PRODUTO = C2_PRODUTO AND SC2.D_E_L_E_T_ = ''
LEFT JOIN (SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,Z1_PRODUTO,CAST(SUM(Z1_QUANT) AS FLOAT)Z1_QUANT
           FROM(
       SELECT Z1_OP,C2_PRODUTO Z1_PRODUTO,
                  CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
           FROM SZ1100 SZ1 (NOLOCK)
       INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
       INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND B1_MSBLQL != '1' AND SB1.D_E_L_E_T_ = ''
       WHERE SZ1.D_E_L_E_T_ = ''
       )TB
       GROUP BY SUBSTRING(Z1_OP,1,6),Z1_PRODUTO)SZ1 ON PED_OP = Z1_OP AND PED_PRODUTO = Z1_PRODUTO 
LEFT JOIN (SELECT SUBSTRING(CLB_CPRODUC,1,6)CLB_OP,CLB_COD,CAST(SUM(CLB_QUANT) AS FLOAT)QTD_CAMA
           FROM(
       SELECT CLB_CPRODUC,CLB_COD,
                  CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END CLB_QUANT
           FROM CLB (NOLOCK)
       INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND B1_MSBLQL != '1' AND SB1.D_E_L_E_T_ = ''
       )TB
       GROUP BY SUBSTRING(CLB_CPRODUC,1,6),CLB_COD)CLB ON PED_OP = CLB_OP AND PED_PRODUTO = CLB_COD
LEFT JOIN (SELECT SUBSTRING(CLA_CPRODUC,1,6)CLA_OP,CLA_COD,SUM(CLA_QUANT) QTD_COLCHAO
           FROM CLA
       GROUP BY SUBSTRING(CLA_CPRODUC,1,6),CLA_COD)CLA ON PED_OP = CLA_OP AND PED_PRODUTO = CLA_COD 
INNER JOIN SB1100 SB1 ON PED_PRODUTO = B1_COD AND B1_MSBLQL != '1' AND SB1.D_E_L_E_T_ = ''
LEFT JOIN SD2100 SD2 ON PED_FILIAL = D2_FILIAL AND PED_NUM = D2_PEDIDO AND PED_ITEM = D2_ITEMPV AND PED_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = ''
LEFT JOIN CNF ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA
WHERE PED_STATUS != 'C'
AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
//AND C2_XCARGA = '000009143'
GROUP BY PED_DTPROPEL,PED_NUM,D2_DOC,C2_XCARGA,PED_QUANT,
         Z1_QUANT,QTD_CAMA,QTD_COLCHAO,B1_XSETOR,
     B1_XLARGUR,B1_XALTURA,B1_XCOMPRI,PED_MUN,PED_NOME,CNF_DOC,CNF_EXPEDICAO
)TB
GROUP BY DT_PRODUCAO,PEDIDO,NOTA,CARGA,CIDADE,CLIENTE,SAIDA,DT_SAIDA
ORDER BY CONVERT(VARCHAR,CAST(DT_PRODUCAO AS DATE),112),CIDADE,CARGA,CLIENTE








		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Data:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
