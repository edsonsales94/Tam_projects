#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR72    บAutor  ณWylliam Silva     				บ Data ณ  27/04/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio Produtos Nใo Produzidos      						  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR72()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR72"

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

	oReport := TReport():New(cPerg,"Relat๓rio Produtos Nใo Produzidos",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Relat๓rio Produtos Nใo Produzidos",{"PED"},aOrdem)  
	
	TRCell():New(oSection,"DT_EMISSAO"	    ,"PED","DT PROD. PELMEX","@!",10)
	TRCell():New(oSection,"OP"	        	,"SC2","ORDEM PROD.","@!",10)
	TRCell():New(oSection,"PEDIDO"	        ,"PED","PEDIDO","@!",10)   
	TRCell():New(oSection,"PRODUTO"	        ,"SC2","PRODUTO","@!",20)          
	TRCell():New(oSection,"DESCRICAO"       ,"SB1","DESCRICAO","@!",50) 
	TRCell():New(oSection,"QTD_OP"   	    ,"SC2","QTDE OP","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_COLCHAO"     ,"CLA","QTDE PROD.COLCHAO","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_CAMA"        ,"CLB","QTDE PROD.CAMA","@E 999,999,999,999",)
	TRCell():New(oSection,"QTD_TRAV"        ,"CLD","QTDE PROD.TRAVES.","@E 999,999,999,999",)
	TRCell():New(oSection,"NOME"	        ,"SC2","CLIENTE","@!",30)
	TRCell():New(oSection,"CIDADE"	    	,"PED","CIDADE","@!",30)
	
	
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

  SELECT 
     CONVERT(VARCHAR,CAST(C2_EMISSAO AS DATE),103)DT_EMISSAO,
     C2_NUM +'01001'OP,
     ISNULL(PEDIDO,'')PEDIDO,
     C2_PRODUTO PRODUTO,
     B1_DESC DESCRICAO,
     C2_QUANT QTD_OP,    
     CAST(ISNULL(QTD_COLCHAO,0) AS INT)QTD_COLCHAO,
     CAST(ISNULL(QTD_CAMA,0) AS INT)QTD_CAMA,
     CAST(ISNULL(QTD_TRAV,0) AS INT)QTD_TRAV,
     C2_OBS NOME,
     ISNULL(CIDADE,'')CIDADE
FROM SC2100 SC2 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT PED_NUM PEDIDO,PED_NOTA NOTA,PED_OP,PED_DTPROPEL DT_PRODUCAO,PED_SETOR,PED_PRODUTO,PED_QUANT QTD_PEDIDO,PED_NOME CLIENTE,PED_MUN CIDADE,PED_STATUS
           FROM PED
           WHERE PED_STATUS = '')PED ON C2_NUM = PED_OP
LEFT JOIN (SELECT SUBSTRING(CLA_CPRODUC,1,6)CLA_OP,CLA_COD,SUM(CLA_QUANT)QTD_COLCHAO
           FROM CLA (NOLOCK)
       GROUP BY SUBSTRING(CLA_CPRODUC,1,6),CLA_COD)CLA ON C2_NUM = CLA_OP
LEFT JOIN (SELECT SUBSTRING(CLB_CPRODUC,1,6)CLB_OP,CLB_COD,SUM(CLB_QUANT)QTD_CAMA
           FROM CLB (NOLOCK)
       GROUP BY SUBSTRING(CLB_CPRODUC,1,6),CLB_COD)CLB ON C2_NUM = CLB_OP

LEFT JOIN (SELECT SUBSTRING(CLD_CPRODUC,1,6)CLD_OP,CLD_COD,SUM(CLD_QUANT)QTD_TRAV
           FROM CLD (NOLOCK)
       GROUP BY SUBSTRING(CLD_CPRODUC,1,6),CLD_COD)CLD ON C2_NUM = CLD_OP

LEFT JOIN (SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,COUNT(Z1_OP+Z1_CHASSIS)QTD_ENTRADA
           FROM SZ1100 SZ1 (NOLOCK)
       GROUP BY SUBSTRING(Z1_OP,1,6))SZ1 ON C2_NUM = Z1_OP
LEFT JOIN (SELECT SUBSTRING(SAI_CPRODUC,1,6)SAI_OP,SAI_PRODUTO,SUM(SAI_QUANT)QTD_SAIDA
           FROM SAI (NOLOCK)
       GROUP BY SUBSTRING(SAI_CPRODUC,1,6),SAI_PRODUTO)SAI ON C2_NUM = SAI_OP
LEFT JOIN (SELECT CNF_FILIAL,CNF_DOC,CNF_SERIE,CNF_EXPEDICAO DT_TRANSPORTE
           FROM CNF
       )CNF ON C2_FILIAL = CNF_FILIAL AND NOTA = CNF_DOC

WHERE SC2.D_E_L_E_T_ = ''
AND CONVERT(VARCHAR,CAST(DT_PRODUCAO AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
AND B1_TIPO IN ('PA','PC')                               
AND ISNULL(QTD_ENTRADA,0) = 0
AND ISNULL(QTD_SAIDA,0) = 0
AND (ISNULL(QTD_CAMA,0) = 0
AND ISNULL(QTD_COLCHAO,0) = 0)
AND ISNULL(QTD_TRAV,0) = 0
ORDER BY 1,PED_SETOR,C2_NUM

	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Emissใo:",20)+"?","","","mv_ch1","D",10,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Emissใo:",20)+"?","","","mv_ch2","D",10,0,0,"G","","","","","mv_par02")
	//u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	//u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return