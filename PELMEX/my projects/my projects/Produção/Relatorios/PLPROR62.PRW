#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLPROR62   บAutor  ณkLEDSON OLIVEIRA    				บ Data ณ  20/05/23 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ   Status Pedidos Pelmex                        			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLPROR62()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PLPROR62"

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

	oReport := TReport():New(cPerg,"Status Pedidos Pelmex",cPerg,{|oReport| PrintReport(oReport,cAlias)}, "Este relatorio mostra o Status dos Pedidos")
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Status Pedidos Pelmex",{"SZ4"},aOrdem) 

	TRCell():New(oSection,"DT_PRODUCAO"		    ,"SC6","DT_PRODUCAO","@!",11)
	TRCell():New(oSection,"DT_PREVIA"	    ,"SC6","DT_PREVIA","@!",11)
	TRCell():New(oSection,"DT_PEDIDO"	    ,"SC6","DT_PEDIDO","@!",11)
	TRCell():New(oSection,"DT_NOTA"		    ,"SC6","DT_NOTA","@!",11)
	TRCell():New(oSection,"NOTA"	    ,"SC6","NOTA","@!",9)
	TRCell():New(oSection,"DT_SAIDA"	    	,"SC6","DT_SAIDA","@!",11)
	TRCell():New(oSection,"DT_DEV"	    	,"SC6","DT_DEV","@!",11)
	TRCell():New(oSection,"PEDIDO"	    	,"SC6","PEDIDO","@!",6)
	TRCell():New(oSection,"CARGA"	    ,"SC6","CARGA","@!",9)
	TRCell():New(oSection,"OP"	    ,"SC6","OP","@!",6)
	TRCell():New(oSection,"ITEM"	    ,"SC6","ITEM","@!",3)
	TRCell():New(oSection,"PRODUTO"	    ,"SC6","PRODUTO","@!",15)
	TRCell():New(oSection,"DESCRICAO"	    ,"SC6","DESCRICAO","@!",30)
	TRCell():New(oSection,"ARMAZEM"	    ,"SC6","ARMAZEM","@!",3)
	TRCell():New(oSection,"TOTAL_M3"	    ,"SC6","TOTAL_M3","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_PEDIDO"	    ,"SC6","QTD_PEDIDO","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_APONTADA"	    ,"SC6","QTD_APONTADA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_ENTRADA"	    ,"SC6","QTD_ENTRADA","@E 999,999,999.999",)
	TRCell():New(oSection,"QTD_BIPADA"	    ,"SC6","QTD_BIPADA","@E 999,999,999.999",)
	TRCell():New(oSection,"DIFERENCA"	    ,"SC6","DIFERENCA","@E 999,999,999.999",)
	TRCell():New(oSection,"PENDENTE_BIPE"	,"SC6","PENDENTE_BIPE","@E 999,999,999.999",)
	TRCell():New(oSection,"CLIENTE"	    	,"SC6","CLIENTE","@!",30)
	TRCell():New(oSection,"CIDADE"	    	,"SC6","CIDADE","@!",15)
	TRCell():New(oSection,"OBSERVACAO"	    ,"SC6","OBSERVACAO","@!",30)


//SELECT DT_PRODUCAO,DT_PREVIA,DT_PEDIDO,DT_NOTA,NOTA,DT_SAIDA,DT_DEV,PEDIDO,CARGA,OP,ITEM, PRODUTO, DESCRICAO, ARMAZEM,
//QTD_PEDIDO*(B1_XCOMPRI*B1_XLARGUR*B1_XALTURA) TOTAL_M3,QTD_PEDIDO,QTD_APONTADA,
//QTD_ENTRADA,QTD_BIPADA,DIFERENCA,PENDENTE_BIPE,CLIENTE,CIDADE,OBSERVACAO




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

SELECT DT_PRODUCAO,DT_PREVIA,DT_PEDIDO,DT_NOTA,NOTA,DT_SAIDA,DT_DEV,PEDIDO,CARGA,OP,ITEM,PRODUTO,DESCRICAO,ARMAZEM,
       QTD_PEDIDO*(B1_XCOMPRI*B1_XLARGUR*B1_XALTURA) TOTAL_M3,QTD_PEDIDO,QTD_APONTADA,
       QTD_ENTRADA,QTD_BIPADA,DIFERENCA,PENDENTE_BIPE,CLIENTE,CIDADE,OBSERVACAO
FROM(
SELECT PED_DTPROPEL DT_PRODUCAO,PED_DTPREVIA DT_PREVIA,ISNULL(D1_DOC,'') NF_DEV,ISNULL(CONVERT(VARCHAR,CAST(D1_EMISSAO AS DATE),103),'') DT_DEV,
       CONVERT(VARCHAR,CAST(C5_EMISSAO AS DATE),103)DT_PEDIDO,
     ISNULL(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),'')DT_NOTA,ISNULL(D2_DOC,'') NOTA,
     ISNULL(CNF_EXPEDICAO,'') DT_SAIDA,PED_NUM PEDIDO,ISNULL(C2_XCARGA,'') CARGA,PED_OP OP,PED_ITEM ITEM,
     PED_PRODUTO PRODUTO,PED_DESCRI DESCRICAO,PED_LOCAL ARMAZEM,
       CAST(PED_QUANT AS FLOAT)QTD_PEDIDO,
     C2_QUJE QTD_APONTADA,
     CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)QTD_ENTRADA,
     CAST(ISNULL(QTD_SAIDA,0) AS FLOAT)QTD_BIPADA,
       CAST(PED_QUANT AS FLOAT)-CAST(ISNULL(QTD_ENTRADA,0) AS FLOAT)DIFERENCA,
     CAST(PED_QUANT AS FLOAT)-CAST(ISNULL(QTD_SAIDA,0) AS FLOAT)PENDENTE_BIPE,
     PED_NOME CLIENTE,PED_MUN CIDADE,
     RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT)OBSERVACAO
FROM PED (NOLOCK)
INNER JOIN SC5100 SC5 (NOLOCK) ON PED_FILIAL = C5_FILIAL AND PED_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
LEFT JOIN SD2100 SD2 (NOLOCK) ON PED_FILIAL = D2_FILIAL AND PED_NUM = D2_PEDIDO AND PED_ITEM = D2_ITEMPV AND PED_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 (NOLOCK) ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE AND D2_CLIENTE = CNF_CLIENTE AND D2_LOJA = CNF_LOJA 
LEFT JOIN SEN (NOLOCK) ON D2_FILIAL = SEN_FILIAL AND D2_DOC = SEN_DOC AND D2_SERIE = SEN_SERIE AND D2_CLIENTE = SEN_CLIENTE AND D2_LOJA = SEN_LOJA
LEFT JOIN (SELECT C2_XCARGA,C2_EMISSAO,C2_NUM,C2_PRODUTO,C2_DATRF,SUM(C2_QUANT)C2_QUANT,SUM(C2_QUJE)C2_QUJE
            FROM(
            SELECT *
            FROM SC2100 SC2 (NOLOCK) 
      WHERE SC2.D_E_L_E_T_ = ''
      )TB 
      GROUP BY C2_XCARGA,C2_EMISSAO,C2_DATRF,C2_NUM,C2_PRODUTO)SC2 ON PED_OP = SC2.C2_NUM AND PED_PRODUTO = SC2.C2_PRODUTO
LEFT JOIN (SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,Z1_PRODUTO,SUM(Z1_QUANT)QTD_ENTRADA
           FROM(
       SELECT Z1_OP+Z1_CHASSIS Z1_OP,C2_PRODUTO Z1_PRODUTO,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
           FROM SZ1100 SZ1 (NOLOCK)
       INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
       INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
       WHERE SZ1.D_E_L_E_T_ = ''
       )TB
       GROUP BY SUBSTRING(Z1_OP,1,6),Z1_PRODUTO)SZ1 ON PED_OP = Z1_OP AND PED_PRODUTO = Z1_PRODUTO
LEFT JOIN (SELECT SUBSTRING(SAI_CPRODUC,1,6)SAI_OP,SAI_PRODUTO,SUM(SAI_QUANT)QTD_SAIDA
           FROM(
            SELECT SAI_FILIAL,SAI_PEDIDO,SAI_DOC,SAI_SERIE,SAI_ITEM,
               SAI_PRODUTO,SAI_QUANT,SAI_CPRODUC
        FROM SAI
        GROUP BY SAI_FILIAL,SAI_PEDIDO,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO,SAI_QUANT,SAI_CPRODUC
      )TB
      GROUP BY SUBSTRING(SAI_CPRODUC,1,6),SAI_PRODUTO)SAI ON PED_OP = SAI_OP AND PED_PRODUTO = SAI_PRODUTO
WHERE PED_STATUS != 'C'
AND D1_DOC IS NULL
AND PED_LOCAL IN ('15','20','50','80')
AND CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NAO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%NรO PRODUZIR%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEVOLUCAO%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE 'DEV%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REF%DEV%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%INVENT%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSFERENCIA%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TRANSF%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%REFATURAMENTO%'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '% STAN%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%TESTE%' 
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%MARKET%PLACE'
AND RTRIM(C5_MENNOTA)+RTRIM(C5_OBS1)+RTRIM(C5_OBS2)+RTRIM(C5_OBS3)+RTRIM(C5_XMSGNOT) NOT LIKE '%MKT' 
)TB2
INNER JOIN SB1100 SB1 (NOLOCK) ON PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
GROUP BY DT_PRODUCAO,DT_PREVIA,DT_PEDIDO,DT_NOTA,NOTA,DT_SAIDA,PEDIDO,CARGA,OP,ITEM,PRODUTO,DESCRICAO,ARMAZEM,
         QTD_PEDIDO,B1_XCOMPRI,B1_XLARGUR,B1_XALTURA,QTD_PEDIDO,QTD_APONTADA,NF_DEV,DT_DEV,
         QTD_ENTRADA,QTD_BIPADA,DIFERENCA,PENDENTE_BIPE,CLIENTE,CIDADE,OBSERVACAO
ORDER BY CIDADE,CONVERT(VARCHAR,CAST(DT_PRODUCAO AS DATE),112),
         CLIENTE,
     PEDIDO,ITEM

		EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	
	u_InPutSX1(cPerg,"01",PADR("De Data Prod:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Data Prod:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02") 
	//u_InPutSX1(cPerg,"02",PADR("Dt Pelmex Ate:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Componente:" ,20)+"?","","","mv_ch3","C",15,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Componente:",20)+"?","","","mv_ch4","C",15,0,0,"G","","","","","mv_par04")
	
	
	
Return
