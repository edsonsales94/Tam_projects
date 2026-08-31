#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  PMPCPR45    ºAutor  ³Wylliam Silva     				º Data ³  20/12/21 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Monitor Geral de Produção              						  			 ±
±±º          ³                                                            			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        			   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PMPCPR47()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR47"

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

	oReport := TReport():New(cPerg,"Monitor Geral de Produção",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira seção
	oSection := TRSection():New(oReport,"Monitor Geral de Produção",{"PED"},aOrdem)  
	
	TRCell():New(oSection,"DT_PRODUCAO"	    ,"PED","DT PROD. PELMEX","@!",8)
	TRCell():New(oSection,"OP"	        	,"SC2","ORDEM PROD.","@!",10)
	TRCell():New(oSection,"PEDIDO"	        ,"PED","PEDIDO","@!",10)   
	TRCell():New(oSection,"NOTA"	   		,"SD2","NOTA","@!",9)
	TRCell():New(oSection,"C2_XCARGA"	   	,"SC2","CARGA","@!",10)
	TRCell():New(oSection,"PRODUTO"	        ,"SC2","PRODUTO","@!",20)          
	TRCell():New(oSection,"DESCRICAO"       ,"SB1","DESCRICAO","@!",50) 
	TRCell():New(oSection,"QTD_OP"   	    ,"SC2","QTDE OP","@E 999,999,999.99",)
	TRCell():New(oSection,"QTD_APONTADA"    ,"SC2","QTDE APONTADA","@E 999,999,999.99",)
	TRCell():New(oSection,"QTD_ENTRADA"     ,"SZ1","QTDE ENTRADA","@E 999,999,999.99",)
	TRCell():New(oSection,"QTD_SAIDA"       ,"SAI","QTDE SAIDA","@E 999,999,999.99",)
	TRCell():New(oSection,"QTD_COLCHAO"     ,"CLA","QTDE PROD.COLCHAO","@E 999,999,999,99",)
	TRCell():New(oSection,"QTD_CAMA"        ,"CLB","QTDE PROD.CAMA","@E 999,999,999.99",)
	TRCell():New(oSection,"QTD_TRAV"        ,"CLD","QTDE PROD.TRAVES.","@E 999,999,999,99",)
	TRCell():New(oSection,"NOME"	        ,"SC2","CLIENTE","@!",30)
	TRCell():New(oSection,"CIDADE"	        ,"SC2","CIDADE","@!",30)
	TRCell():New(oSection,"B1_XSETOR"	    ,"SB1","SETOR","@!",30)
  
	
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

	SELECT DT_PRODUCAO,SUBSTRING(OP,1,6)OP,PEDIDO,NOTA,C2_XCARGA,PRODUTO,DESCRICAO,SUM(QTD_OP)QTD_OP,SUM(QTD_APONTADA)QTD_APONTADA,SUM(QTD_ENTRADA)QTD_ENTRADA,SUM(QTD_SAIDA)QTD_SAIDA,SUM(QTD_COLCHAO)QTD_COLCHAO,SUM(QTD_CAMA)QTD_CAMA,NOME,CIDADE,B1_XSETOR
FROM(
    SELECT 
	     ISNULL(DT_PRODUCAO,'')DT_PRODUCAO,
         C2_NUM+C2_ITEM+C2_SEQUEN OP,
	     ISNULL(PEDIDO,'')PEDIDO,
         ISNULL (D2_DOC,'') NOTA,C2_XCARGA,
	     C2_PRODUTO PRODUTO,
	     B1_DESC DESCRICAO,
	     SUM(C2_QUANT) QTD_OP,
	     SUM(C2_QUJE) QTD_APONTADA,
	     ISNULL(QTD_ENTRADA,0)QTD_ENTRADA,
	     CASE WHEN ISNULL(QTD_SAIDA,0) > SUM(C2_QUANT) THEN SUM(C2_QUANT) ELSE ISNULL(QTD_SAIDA,0) END QTD_SAIDA,
	     CAST(ISNULL(QTD_COLCHAO,0) AS FLOAT)QTD_COLCHAO,
	     CAST(ISNULL(QTD_CAMA,0) AS FLOAT)QTD_CAMA,
	     //CAST(ISNULL(QTD_TRAV,0) AS FLOAT)QTD_TRAV,
	     C2_OBS NOME,
		 CIDADE,
	     B1_XSETOR
	FROM SC2100 SC2 (NOLOCK)
	INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''

	LEFT JOIN (SELECT PED_NUM PEDIDO,PED_NOTA NOTA,PED_OP,PED_DTPROPEL DT_PRODUCAO,PED_SETOR,PED_ITEM,PED_PRODUTO,
                        PED_QUANT QTD_PEDIDO,PED_NOME CLIENTE,PED_MUN CIDADE,PED_STATUS,PED_FILIAL
	           FROM PED
	           WHERE PED_STATUS != 'C')PED ON C2_NUM = PED_OP AND C2_PRODUTO = PED_PRODUTO

	LEFT JOIN ( SELECT SUBSTRING(CLA_CPRODUC,1,11)CLA_OP,CLA_COD,SUM(CLA_QUANT)QTD_COLCHAO
				FROM(
					 SELECT CLA_CPRODUC,CLA_COD,CLA_QUANT
					 FROM CLA (NOLOCK)
					 GROUP BY CLA_CPRODUC,CLA_COD,CLA_QUANT
				)TB
				GROUP BY SUBSTRING(CLA_CPRODUC,1,11),CLA_COD)CLA ON C2_NUM+C2_ITEM+C2_SEQUEN = CLA_OP

    LEFT JOIN ( SELECT SUBSTRING(CLB_CPRODUC,1,11)CLB_OP,CLB_COD,SUM(QTD_CAMA)QTD_CAMA
                FROM(
                     SELECT CLB_CPRODUC,CLB_COD,
                            CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END QTD_CAMA
                     FROM CLB (NOLOCK)
                     INNER JOIN SB1100 SB1 (NOLOCK) ON CLB_COD = B1_COD AND SB1.D_E_L_E_T_ = ''
                     GROUP BY CLB_CPRODUC,CLB_COD,B1_XJUNCAO
            	)TB
       			GROUP BY SUBSTRING(CLB_CPRODUC,1,11),CLB_COD)CLB ON C2_NUM+C2_ITEM+C2_SEQUEN  = CLB_OP AND PED_PRODUTO = CLB_COD
	
	/*LEFT JOIN (SELECT SUBSTRING(CLD_CPRODUC,1,11)CLD_OP,CLD_COD,SUM(CLD_QUANT)QTD_TRAV
	           FROM CLD (NOLOCK)
	           GROUP BY SUBSTRING(CLD_CPRODUC,1,11),CLD_COD)CLD ON C2_NUM+C2_ITEM+C2_SEQUEN = CLD_OP*/
	
	LEFT JOIN (SELECT Z1_OP,Z1_PRODUTO,CAST(SUM(Z1_QUANT) AS FLOAT)QTD_ENTRADA
	           FROM(
	               SELECT SUBSTRING(Z1_OP,1,11)Z1_OP,C2_PRODUTO Z1_PRODUTO,
						  CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
				   FROM SZ1100 SZ1 (NOLOCK)
				   INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
				   INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
				   WHERE SZ1.D_E_L_E_T_ = ''
			   )TB
			   GROUP BY Z1_OP,Z1_PRODUTO)SZ1 ON C2_NUM+C2_ITEM+C2_SEQUEN = Z1_OP AND C2_PRODUTO = Z1_PRODUTO

	LEFT JOIN (SELECT SUBSTRING(SAI_CPRODUC,1,11)SAI_OP,SAI_PRODUTO,SUM(SAI_QUANT)QTD_SAIDA
	           FROM SAI (NOLOCK)
	       GROUP BY SUBSTRING(SAI_CPRODUC,1,11),SAI_PRODUTO)SAI ON C2_NUM+C2_ITEM+C2_SEQUEN = SAI_OP

		LEFT JOIN (SELECT C6_NOTA,C6_SERIE,C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO
	           FROM SC6100 SC6 (NOLOCK)
			   WHERE SC6.D_E_L_E_T_ =''
	       )SC6 ON PED_FILIAL = C6_FILIAL AND PEDIDO = C6_NUM AND PED_ITEM = C6_ITEM AND PED_PRODUTO = C6_PRODUTO      

    LEFT JOIN (SELECT *
           FROM SD2100 SD2 (NOLOCK)
		   WHERE SD2.D_E_L_E_T_ = '')SD2 ON (CASE WHEN ISNULL(PED_FILIAL,'') = '' THEN C6_FILIAL ELSE PED_FILIAL END) = D2_FILIAL AND (CASE WHEN ISNULL (NOTA,'') = '' THEN (CASE WHEN ISNULL (PEDIDO,'') = '' THEN C6_NUM ELSE PEDIDO END) ELSE NOTA END) = (CASE WHEN ISNULL (NOTA,'') = '' THEN D2_PEDIDO ELSE D2_DOC END) 
            AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD  

  	WHERE SC2.D_E_L_E_T_ = ''
	AND CONVERT(VARCHAR,CAST(DT_PRODUCAO AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
    AND NOTA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
    AND C2_XCARGA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
    AND PEDIDO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND B1_TIPO IN ('PA','PC') 
	GROUP BY DT_PRODUCAO,C2_NUM+C2_ITEM+C2_SEQUEN,PEDIDO,C2_PRODUTO,B1_DESC,QTD_ENTRADA,QTD_SAIDA,QTD_COLCHAO,QTD_CAMA,
	         C2_OBS,B1_XSETOR,C6_NOTA,C2_EMISSAO,C2_XCARGA,SD2.D2_DOC,CIDADE
)TB
GROUP BY DT_PRODUCAO,SUBSTRING(OP,1,6),PEDIDO,PRODUTO,DESCRICAO,NOME,CIDADE,B1_XSETOR,NOTA,C2_XCARGA
ORDER BY CONVERT(VARCHAR,CAST(DT_PRODUCAO AS DATE),112),C2_XCARGA,OP,PRODUTO,B1_XSETOR

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Emissão:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissão:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Nota:"		,20)+"?","","","mv_ch3","C",9,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Nota:"		,20)+"?","","","mv_ch4","C",9,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Carga:"		,20)+"?","","","mv_ch5","C",9,0,0,"G","","","","","mv_par05") 
	u_InPutSX1(cPerg,"06",PADR("Ate Carga:"		,20)+"?","","","mv_ch6","C",9,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De Pedido:"		,20)+"?","","","mv_ch7","C",9,0,0,"G","","","","","mv_par07") 
	u_InPutSX1(cPerg,"08",PADR("Ate Pedido:"	,20)+"?","","","mv_ch8","C",9,0,0,"G","","","","","mv_par08")
Return
