#Include "TopConn.CH"
#Include "Protheus.CH"
#Include "TOTVS.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  PLFATR47    บAutor  ณJuevan Silva     				บ Data ณ  11/10/22 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ  Confere NF Saida CFOP											 ฑ
ฑฑบ          ณ                                                            			   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        			   บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PLFATR47()
	Local oReport
	Local cQuery
	Local cAlias      := getNextAlias()
	Private cPerg     := "PLFATR47"

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

	oReport := TReport():New(cPerg,"Confere NF Saida CFOP",cPerg,{|oReport| PrintReport(oReport,cAlias)}, )
	oReport:SetPortrait()      
	oReport:SetEnvironment(2)      

	//Primeira se็ใo
	oSection := TRSection():New(oReport,"Confere NF Saida CFOP",{"SC6"},aOrdem) 

    TRCell():New(oSection,"CLIENTE"    	,"SC6","CLIENTE","@!",15)
    TRCell():New(oSection,"NOME"  	,"SA1","NOME","@!",40)
    TRCell():New(oSection,"UF"   	,"SA1","UF","@!",4)
    TRCell():New(oSection,"EMPRESA"   	,"SB1","EMPRESA","@!",30)
    TRCell():New(oSection,"NOTA"    	,"SC6","NOTA","@!",10)
    TRCell():New(oSection,"ITEM"    	,"SC6","ITEM","@!",10)
    TRCell():New(oSection,"PRODUTO"    	,"SC6","PRODUTO","@!",30)
    TRCell():New(oSection,"DESCRICAO"    	,"SC6","DESC","@!",40)
    TRCell():New(oSection,"ARMAZEM"    	,"SC6","LOCAL","@!",4)
    TRCell():New(oSection,"CFOP"    	,"SC6","CFOP","@!",6)
    TRCell():New(oSection,"QTD_PEDIDO"    	,"SC6","QTPEDIDO","@E 999,999,999,999",10)
    TRCell():New(oSection,"DT_NOTA"    	,"SD2","DTNOTA","@!",15)
    TRCell():New(oSection,"PEDIDO"    	,"SC6","PEDIDO","@!",15)
    TRCell():New(oSection,"OP"    	,"PED","OP","@!",15)
    TRCell():New(oSection,"DT_PRODUCAO"    	,"PED","DTPRODUC","@!",15)
    TRCell():New(oSection,"QTD_SAIDA"    		,"SAI","QTSAIDA","@E 999,999,999,999",10)
    TRCell():New(oSection,"DT_BIPE"    	,"SAI","DTBIPE","@!",15)
    TRCell():New(oSection,"DT_SAIDA"    	,"SAI","DTSAIDA","@!",15)

	//Totalizador
	/*                                                                                  
	TRFunction():New(oSection:Cell("L2_VLRITEM"),"TOTAL BASE","SUM",,,"@E 9,999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("L1_VLRTOT"),"TOTAL GERAL","SUM",,,"@E 999,999,999.99",,.F.,.T.)  
	TRFunction():New(oSection:Cell("IR"),"TOTAL IR","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	TRFunction():New(oSection:Cell("VALLIQ"),"TOTAL LIQUIDO","SUM",,,"@E 999,999,999.99",,.F.,.T.)
	*/

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
SELECT C6_CLI CLIENTE,A1_NOME NOME,A1_EST UF,
       CASE WHEN B1_XEMP = '1' THEN 'PROBEL'
          WHEN B1_XEMP = '2' THEN 'PELMEX'
      WHEN B1_XEMP = '3' THEN 'SONOFLEX'
      WHEN B1_XEMP = '4' THEN 'POLISHOP'
      WHEN B1_XEMP = '5' THEN 'KING STAR'
      WHEN B1_XEMP = '6' THEN 'INOVAR'
      WHEN B1_XEMP = '7' THEN 'NAMASPET'
      WHEN B1_XEMP = '8' THEN 'ORTOCONFORT'
    ELSE 'OUTRAS' END EMPRESA,
    ISNULL(D2_DOC,'') NOTA,C6_ITEM ITEM,C6_PRODUTO PRODUTO,C6_DESCRI DESCRICAO,C6_LOCAL ARMAZEM,C6_CF CFOP,C6_QTDVEN QTD_PEDIDO,C6_QTDENT QTD_ENTREGUE,
    ISNULL(CONVERT(VARCHAR,CAST(D2_EMISSAO AS DATE),103),'')DT_NOTA,C6_NUM PEDIDO,ISNULL(PED_OP,'') OP,ISNULL(PED_DTPROPEL,'') DT_PRODUCAO,ISNULL(QTD_SAIDA,0)QTD_SAIDA,ISNULL(DT_BIPE,'')DT_BIPE,ISNULL(CNF_EXPEDICAO,'')DT_SAIDA
FROM SC6100 SC6 (NOLOCK)
INNER JOIN SB1100 SB1 (NOLOCK) ON C6_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
INNER JOIN SC5100 SC5 (NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ''
INNER JOIN SA1100 SA1 (NOLOCK) ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ''
LEFT JOIN SD2100 SD2 (NOLOCK) ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV AND C6_PRODUTO = D2_COD AND SD2.D_E_L_E_T_ = ''
LEFT JOIN PED (NOLOCK) ON D2_FILIAL = PED_FILIAL AND D2_PEDIDO = PED_NUM AND D2_ITEMPV = PED_ITEM AND D2_COD = PED_PRODUTO
LEFT JOIN CNF (NOLOCK) ON D2_FILIAL = CNF_FILIAL AND D2_DOC = CNF_DOC AND D2_SERIE = CNF_SERIE
LEFT JOIN (SELECT Z1_OP,C2_PRODUTO,SUM(Z1_QUANT)QTD_PRODUZIDA
           FROM(
           SELECT C2_NUM Z1_OP,C2_PRODUTO,CASE WHEN B1_XJUNCAO = 'S' THEN 0.5 ELSE 1 END Z1_QUANT
           FROM SZ1100 SZ1 (NOLOCK)
       INNER JOIN SC2100 SC2 (NOLOCK) ON Z1_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2.D_E_L_E_T_ = ''
       INNER JOIN SB1100 SB1 (NOLOCK) ON C2_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ''
       WHERE SZ1.D_E_L_E_T_ = ''
       )TB
       GROUP BY Z1_OP,C2_PRODUTO)SZ1 ON PED_OP = Z1_OP AND PED_PRODUTO = C2_PRODUTO
LEFT JOIN (SELECT SAI_FILIAL,SAI_DOC,SAI_SERIE,SUBSTRING(SAI_CPRODUC,1,6)SAI_OP,SAI_ITEM,SAI_PRODUTO,SUM(SAI_QUANT)QTD_SAIDA,MAX(SAI_DTEXP)DT_BIPE
           FROM SAI (NOLOCK)
       GROUP BY SAI_FILIAL,SAI_DOC,SAI_SERIE,SUBSTRING(SAI_CPRODUC,1,6),SAI_ITEM,SAI_PRODUTO)SAI ON D2_FILIAL = SAI_FILIAL AND PED_OP = SAI_OP AND D2_DOC = SAI_DOC AND D2_SERIE = SAI_SERIE AND D2_ITEM = SAI_ITEM AND D2_COD = SAI_PRODUTO
WHERE SC6.D_E_L_E_T_ = ''
AND C5_EMISSAO BETWEEN  %Exp:MV_PAR01% AND %Exp:MV_PAR02%
AND C6_FILIAL = '01'
ORDER BY C6_NUM,C6_ITEM

EndSQL 

	oSection:EndQuery() 
	oSection:SetParentQuery()
	oSection:Print()	 
Return

Static Function AjustaSX1(cPerg)
	u_InPutSX1(cPerg,"01",PADR("De Emissao NF   ",20)+"?","","","mv_ch1","D",6,0,0,"G","","","","","mv_par01")  
	u_InPutSX1(cPerg,"02",PADR("Ate Emisao NF  ",20)+"?","","","mv_ch2","D",6,0,0,"G","","","","","mv_par02")

Return
