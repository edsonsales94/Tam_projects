#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PMPCPR46    บAutor  ณWylliam Silva     				บ Data ณ  20/12/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  COMPLEMENTO DO PEDIDO                						  			 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PMPCPR46()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()      

	Private cPerg     := "PMPCPR46"

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

	oReport := TReport():New(cPerg,"Complemento do Pedido",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Complemento do Pedido",{"PED"},aOrdem)  
	


	TRCell():New(oSection,"NOTA"		    ,"SAI","NOTA","@!",15)             
	TRCell():New(oSection,"PEDIDO" 		    ,"PED","PEDIDO","@!",10) 
	TRCell():New(oSection,"DT_PEDIDO"   	,"PED","DT PEDIDO","@!",10)
	TRCell():New(oSection,"DT_NOTA"    	  	,"SD2","DT NOTA","@!",10)
	TRCell():New(oSection,"DT_EXPEDICAO"    ,"SAI","DT EXPEDICAO","@!",10)
	TRCell():New(oSection,"DT_ENTREGA"      ,"SAI","DT ENTREGA","@!",10)
	TRCell():New(oSection,"OP"              ,"PED","OP","@!",15)
	TRCell():New(oSection,"DT_PRODUCAO"     ,"PK2","DT PRODUCAO","@!",10)
	TRCell():New(oSection,"ITEM"            ,"PED","ITEM","@!",5)
	TRCell():New(oSection,"PRODUTO"         ,"PED","PRODUTO","@!",35)
	TRCell():New(oSection,"DESCRICAO"       ,"PED","DESCRICAO","@!",35)
	TRCell():New(oSection,"QTD_PEDIDO"    	,"PED","QTD PEDIDO","@E 999,999,999,999",6)
	TRCell():New(oSection,"CLIENET"         ,"PED","CLIENTE","@!",40)
	
	
	
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

SELECT ISNULL(D2_DOC,'')NOTA,PED_NUM PEDIDO,CONVERT(VARCHAR,CAST(PED_EMISSAO AS DATE),103)DT_PEDIDO,
       ISNULL(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),'')DT_NOTA,
     ISNULL(DT_EXPEDICAO,'')DT_EXPEDICAO,
     CONVERT(VARCHAR,CAST(PED_ENTREG AS DATE),103)DT_ENTREGA,PED_OP OP,PK2_DTPROPEL DT_PRODUCAO,PED_ITEM ITEM,PED_PRODUTO PRODUTO,PED_DESCRI DESCRICAO,PED_QUANT QTD_PEDIDO,PED_NOME CLIENET
FROM PED
INNER JOIN PK2 ON PED_CODIGO = PK2_CODIGO AND PED_PRODUTO = PK2_PRODUTO
LEFT JOIN SD2100 SD2 ON PED_FILIAL = D2_FILIAL AND PED_NUM = D2_PEDIDO AND PED_ITEM = D2_ITEMPV AND PED_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = ''
LEFT JOIN SD1100 SD1 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI AND D2_COD = D1_COD AND SD1.D_E_L_E_T_ = ''
LEFT JOIN (SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO,SUM(SAI_QUANT)QTD_SAIDA,MAX(SAI_DTEXP) DT_EXPEDICAO
           FROM SAI
       WHERE SAI_DTEXP BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
       GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE,SAI_ITEM,SAI_PRODUTO)SAI ON D2_FILIAL = SAI_FILIAL AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND D2_ITEM = SAI_ITEM AND D2_COD = SAI_PRODUTO
WHERE PED_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
AND D1_DOC IS NULL
ORDER BY PED_NUM,PED_ITEM


	EndSQL 


	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return


Static Function AjustaSX1(cPerg)

	u_InPutSX1(cPerg,"01",PADR("De Dt Expedi็ใo:",20)+"?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01") 
	u_InPutSX1(cPerg,"02",PADR("Ate Dt Expedi็ใo:",20)+"?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
	u_InPutSX1(cPerg,"03",PADR("De Pedido:",20)+"?","","","mv_ch3","C",10,0,0,"G","","","","","mv_par03") 
	u_InPutSX1(cPerg,"04",PADR("Ate Pedido:",20)+"?","","","mv_ch4","C",10,0,0,"G","","","","","mv_par04")
	

Return