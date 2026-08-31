#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR45    บAutor  ณWylliam Silva     				บ Data ณ  17/12/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  RASTREIO DO CLIENTE						  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR45()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR45"

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

	oReport := TReport():New(cPerg,"Rastreio do Cliente",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Rastreio do Cliente",{"SD3"},aOrdem)  

	TRCell():New(oSection,"DT_EMISSAO"		,"PED","DT EMISSAO","@!",10)             
	TRCell():New(oSection,"DT_ENTREGA" 		,"PED","DT ENTREGA","@!",10) 
	TRCell():New(oSection,"PEDIDO"   	    ,"PED","PEDIDO","@!",10)
	TRCell():New(oSection,"OP"    	    	,"PED","OP","@!",10)
	TRCell():New(oSection,"DT_PRODUCAO"     ,"PK2","DT PRODUCAO","@!",10)
	TRCell():New(oSection,"ITEM"            ,"PED","ITEM","@!",5)
	TRCell():New(oSection,"PRODUTO"         ,"PED","PRODUTO","@!",25)
	TRCell():New(oSection,"DESCRICAO"       ,"PED","DESCRICAO","@!",50)
	TRCell():New(oSection,"QTD_PEDIDO"    	,"PED","QTD PEDIDO","@E 999,999,999,999",10)
	TRCell():New(oSection,"QTD_ENTRADA"    	,"PED","QTD ENTRADA","@E 999,999,999,999",10)
	TRCell():New(oSection,"QTD_INVENTARIO"  ,"PED","QTD INVENTARIO","@E 999,999,999,999",10)
	TRCell():New(oSection,"QTD_SAIDA"    	,"SAI","QTD SAIDA","@E 999,999,999,999",10)
	TRCell():New(oSection,"PED_CLIENTE"     ,"PED","COD CLIENTE","@!",40)
	TRCell():New(oSection,"CLIENTE"         ,"PED","CLIENTE PEDIDO","@!",40)
	TRCell():New(oSection,"CLIENTE_SAIDA"     ,"SAI","CLIENTE SAIDA","@!",40)
	
	
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

SELECT CONVERT(VARCHAR,CAST(PED_EMISSAO AS DATE),103)DT_EMISSAO,
       CONVERT(VARCHAR,CAST(PED_ENTREG AS DATE),103)DT_ENTREGA,
     PED_NUM PEDIDO,PED_OP OP,PK2_DTPROPEL DT_PRODUCAO,PED_ITEM ITEM,PED_PRODUTO PRODUTO,PED_DESCRI DESCRICAO,
     CAST(PED_QUANT AS INT)QTD_PEDIDO,ISNULL(QTD_ENTRADA,0)QTD_ENTRADA,ISNULL(QTD_INVENTARIO,0)QTD_INVENTARIO,ISNULL(QTD_SAIDA,0)QTD_SAIDA,
     PED_CLIENTE,PED_NOME CLIENTE,SAI_NOME CLIENTE_SAIDA
FROM PED
INNER JOIN PK2 ON PED_CODIGO = PK2_CODIGO AND PED_PRODUTO = PK2_PRODUTO
LEFT JOIN (SELECT SUBSTRING(Z1_OP,1,6)Z1_OP,COUNT(Z1_OP+Z1_CHASSIS)QTD_ENTRADA
           FROM SZ1100 SZ1
       WHERE SZ1.D_E_L_E_T_ = ''
       GROUP BY SUBSTRING(Z1_OP,1,6))SZ1 ON PED_OP = Z1_OP
LEFT JOIN (SELECT SUBSTRING(SAI_CPRODUC,1,6)SAI_OP,SUM(SAI_QUANT)QTD_SAIDA,SAI_NOME
           FROM SAI
       WHERE CONVERT(VARCHAR,CAST(SAI_DTEXP AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
       GROUP BY SUBSTRING(SAI_CPRODUC,1,6),SAI_NOME)SAI ON PED_OP = SAI_OP
LEFT JOIN (SELECT SUBSTRING(COL_CPRODUC,1,6)COL_OP,SUM(COL_QUANT)QTD_INVENTARIO,COL_DOC
           FROM COLINV
       LEFT JOIN SAI ON COL_CPRODUC = SAI_CPRODUC
       WHERE COL_EMPRESA = '10'
       AND COL_FILIAL = '01'
       AND COL_DOC BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
       AND SAI_CPRODUC IS NULL
       GROUP BY SUBSTRING(COL_CPRODUC,1,6),COL_DOC)COL ON PED_OP = COL_OP
WHERE CONVERT(VARCHAR,CAST(PED_DTPROPEL AS DATE),112) BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND PED_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND PED_CLIENTE BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
AND PED_OP BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
ORDER BY PED_NUM,PED_ITEM


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Emissao:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Emissao:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	u_InPutSX1(cPerg,"05",PADR("De Cliente:",20)+"?","","","mv_ch5","C",10,0,0,"G","","","","","mv_par05")
	u_InPutSX1(cPerg,"06",PADR("Ate Cliente:",20)+"?","","","mv_ch6","C",10,0,0,"G","","","","","mv_par06")
	u_InPutSX1(cPerg,"07",PADR("De Ordem Prod:",20)+"?","","","mv_ch7","C",10,0,0,"G","","","","","mv_par07")
	u_InPutSX1(cPerg,"08",PADR("Ate Ordem Prod:",20)+"?","","","mv_ch8","C",10,0,0,"G","","","","","mv_par08")
	u_InPutSX1(cPerg,"09",PADR("De Doc.Inv:",20)+"?","","","mv_ch9","C",10,0,0,"G","","","","","mv_par09")
	u_InPutSX1(cPerg,"10",PADR("Ate Doc.Inv:",20)+"?","","","mv_cha","C",10,0,0,"G","","","","","mv_par10")

Return